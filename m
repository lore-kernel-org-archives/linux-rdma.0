From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv5 2/2][RESEND] opensm/osm_console.c: Add dump and clear
	redir perfmgr command support
Date: Thu, 17 Jun 2010 14:16:29 -0400
Message-ID: <20100617181629.GA17408@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Follows previous patch that adds better redirection support for PerfMgr

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v4:
Fixed rejection of Copyright hunk

Changes since v3:
Fixed some formatting problems (spaces instead of tabs)

Changes since v2:
Rebased

Changes since v1:
Changes based on changes to PerfMgr redir support in v3 patch

diff --git a/opensm/opensm/osm_console.c b/opensm/opensm/osm_console.c
index bc7bea3..27f1e1e 100644
--- a/opensm/opensm/osm_console.c
+++ b/opensm/opensm/osm_console.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2005-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2009 HNR Consulting. All rights reserved.
+ * Copyright (c) 2009,2010 HNR Consulting. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -231,7 +231,7 @@ static void help_update_desc(FILE *out, int detail)
 static void help_perfmgr(FILE * out, int detail)
 {
 	fprintf(out,
-		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|sweep_time[seconds]]\n");
+		"perfmgr [enable|disable|clear_counters|dump_counters|print_counters|dump_redir|clear_redir|sweep_time[seconds]]\n");
 	if (detail) {
 		fprintf(out,
 			"perfmgr -- print the performance manager state\n");
@@ -245,6 +245,10 @@ static void help_perfmgr(FILE * out, int detail)
 			"   [dump_counters [mach]] -- dump the counters (optionally in [mach]ine readable format)\n");
 		fprintf(out,
 			"   [print_counters <nodename|nodeguid>] -- print the counters for the specified node\n");
+		fprintf(out,
+			"   [dump_redir [<nodename|nodeguid>]] -- dump the redirection table\n");
+		fprintf(out,
+			"   [clear_redir [<nodename|nodeguid>]] -- clear the redirection table\n");
 	}
 }
 #endif				/* ENABLE_OSM_PERF_MGR */
@@ -1179,6 +1183,152 @@ static void update_desc_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 }
 
 #ifdef ENABLE_OSM_PERF_MGR
+static monitored_node_t *find_node_by_name(osm_opensm_t * p_osm,
+					   char *nodename)
+{
+	cl_map_item_t *item;
+	monitored_node_t *node;
+
+	item = cl_qmap_head(&p_osm->perfmgr.monitored_map);
+	while (item != cl_qmap_end(&p_osm->perfmgr.monitored_map)) {
+		node = (monitored_node_t *)item;
+		if (strcmp(node->name, nodename) == 0)
+			return node;
+		item = cl_qmap_next(item);
+	}
+
+	return NULL;
+}
+
+static monitored_node_t *find_node_by_guid(osm_opensm_t * p_osm,
+					   uint64_t guid)
+{
+	cl_map_item_t *node;
+
+	node = cl_qmap_get(&p_osm->perfmgr.monitored_map, guid);
+	if (node != cl_qmap_end(&p_osm->perfmgr.monitored_map))
+		return (monitored_node_t *)node;
+
+	return NULL;
+}
+
+static void dump_redir_entry(monitored_node_t *p_mon_node, FILE * out)
+{
+	int port, redir;
+
+	/* only display monitored nodes with redirection info */
+	redir = 0;
+	for (port = (p_mon_node->esp0) ? 0 : 1;
+	     port < p_mon_node->num_ports; port++) {
+		if (p_mon_node->port[port].redirection) {
+			if (!redir) {
+				fprintf(out, "   Node GUID       ESP0   Name\n");
+				fprintf(out, "   ---------       ----   ----\n");
+				fprintf(out, "   0x%" PRIx64 " %d      %s\n",
+					p_mon_node->guid, p_mon_node->esp0,
+					p_mon_node->name);
+				fprintf(out, "\n   Port Valid  LIDs     PKey  QP    PKey Index\n");
+				fprintf(out, "   ---- -----  ----     ----  --    ----------\n");
+				redir = 1;
+			}
+			fprintf(out, "   %d    %d      %u->%u  0x%x 0x%x   %d\n",
+				port, p_mon_node->port[port].valid,
+				cl_ntoh16(p_mon_node->port[port].orig_lid),
+				cl_ntoh16(p_mon_node->port[port].lid),
+				cl_ntoh16(p_mon_node->port[port].pkey),
+				cl_ntoh32(p_mon_node->port[port].qp),
+				p_mon_node->port[port].pkey_ix);
+		}
+	}
+	if (redir)
+		fprintf(out, "\n");
+}
+
+static void dump_redir(osm_opensm_t * p_osm, char *nodename, FILE * out)
+{
+	monitored_node_t *p_mon_node;
+	uint64_t guid;
+
+	if (!p_osm->subn.opt.perfmgr_redir)
+		fprintf(out, "Perfmgr redirection not enabled\n");
+
+	fprintf(out, "\nRedirection Table\n");
+	fprintf(out, "-----------------\n");
+	cl_plock_acquire(&p_osm->lock);
+	if (nodename) {
+		guid = strtoull(nodename, NULL, 0);
+		if (guid == 0 && errno)
+			p_mon_node = find_node_by_name(p_osm, nodename);
+		else
+			p_mon_node = find_node_by_guid(p_osm, guid);
+		if (p_mon_node)
+			dump_redir_entry(p_mon_node, out);
+		else {
+			if (guid == 0 && errno)
+				fprintf(out, "Node %s not found...\n", nodename);
+			else
+				fprintf(out, "Node 0x%" PRIx64 " not found...\n", guid);
+		}
+	} else {
+		p_mon_node = (monitored_node_t *) cl_qmap_head(&p_osm->perfmgr.monitored_map);
+		while (p_mon_node != (monitored_node_t *) cl_qmap_end(&p_osm->perfmgr.monitored_map)) {
+			dump_redir_entry(p_mon_node, out);
+			p_mon_node = (monitored_node_t *) cl_qmap_next((const cl_map_item_t *)p_mon_node);
+		}
+	}
+	cl_plock_release(&p_osm->lock);
+}
+
+static void clear_redir_entry(monitored_node_t *p_mon_node)
+{
+	int port;
+	ib_net16_t orig_lid;
+
+	for (port = (p_mon_node->esp0) ? 0 : 1;
+	     port < p_mon_node->num_ports; port++) {
+		if (p_mon_node->port[port].redirection) {
+			orig_lid = p_mon_node->port[port].orig_lid;
+			memset(&p_mon_node->port[port], 0,
+			       sizeof(monitored_port_t));
+			p_mon_node->port[port].valid = TRUE;
+			p_mon_node->port[port].orig_lid = orig_lid;
+		}
+	}
+}
+
+static void clear_redir(osm_opensm_t * p_osm, char *nodename, FILE * out)
+{
+	monitored_node_t *p_mon_node;
+	uint64_t guid;
+
+	if (!p_osm->subn.opt.perfmgr_redir)
+		fprintf(out, "Perfmgr redirection not enabled\n");
+
+	cl_plock_acquire(&p_osm->lock);
+	if (nodename) {
+		guid = strtoull(nodename, NULL, 0);
+		if (guid == 0 && errno)
+			p_mon_node = find_node_by_name(p_osm, nodename);
+		else
+			p_mon_node = find_node_by_guid(p_osm, guid);
+		if (p_mon_node)
+			clear_redir_entry(p_mon_node);
+		else {
+			if (guid == 0 && errno)
+				fprintf(out, "Node %s not found...\n", nodename);
+			else
+				fprintf(out, "Node 0x%" PRIx64 " not found...\n", guid);
+		}
+	} else {
+		p_mon_node = (monitored_node_t *) cl_qmap_head(&p_osm->perfmgr.monitored_map);
+		while (p_mon_node != (monitored_node_t *) cl_qmap_end(&p_osm->perfmgr.monitored_map)) {
+			clear_redir_entry(p_mon_node);
+			p_mon_node = (monitored_node_t *) cl_qmap_next((const cl_map_item_t *)p_mon_node);
+		}
+	}
+	cl_plock_release(&p_osm->lock);
+}
+
 static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 {
 	char *p_cmd;
@@ -1211,6 +1361,12 @@ static void perfmgr_parse(char **p_last, osm_opensm_t * p_osm, FILE * out)
 				fprintf(out,
 					"print_counters requires a node name or node GUID to be specified\n");
 			}
+		} else if (strcmp(p_cmd, "dump_redir") == 0) {
+			p_cmd = name_token(p_last);
+			dump_redir(p_osm, p_cmd, out);
+		} else if (strcmp(p_cmd, "clear_redir") == 0) {
+			p_cmd = name_token(p_last);
+			clear_redir(p_osm, p_cmd, out);
 		} else if (strcmp(p_cmd, "sweep_time") == 0) {
 			p_cmd = next_token(p_last);
 			if (p_cmd) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
