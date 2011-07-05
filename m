From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 4/4] infiniband-diags: libibnetdisc/iblinkinfo Allow for a
 partial fabric query centered around a CA
Date: Tue, 5 Jul 2011 12:08:16 -0700
Message-ID: <20110705120816.4db6657c.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The old algorithm would attempt to extend the DR path through the CA and fail.
The new algoritm retracts the path to get to the node connected to the CA.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibnetdisc/libibnetdisc.ver |    2 +-
 libibnetdisc/src/ibnetdisc.c  |   83 ++++++++++++++++++++++++++++---------
 libibnetdisc/src/internal.h   |    1 +
 man/iblinkinfo.8              |   20 ++++-----
 src/iblinkinfo.c              |   91 +++++++++++++++++++++++++----------------
 5 files changed, 129 insertions(+), 68 deletions(-)

diff --git a/libibnetdisc/libibnetdisc.ver b/libibnetdisc/libibnetdisc.ver
index 27f922f..d0ea703 100644
--- a/libibnetdisc/libibnetdisc.ver
+++ b/libibnetdisc/libibnetdisc.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=5:1:0
+LIBVERSION=5:2:0
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 4a4f33b..52481eb 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -56,8 +56,13 @@
 #include "chassis.h"
 
 /* forward declare */
+struct ni_cbdata
+{
+	ibnd_node_t *node;
+	int port_num;
+};
 static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
-			   ibnd_node_t * node);
+			   struct ni_cbdata * cbdata);
 
 static int recv_switch_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			    uint8_t * mad, void *cb_data)
@@ -87,6 +92,26 @@ static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 	return path->cnt;
 }
 
+static int retract_dpath(smp_engine_t * engine, ib_portid_t * portid)
+{
+	ibnd_scan_t *scan = engine->user_data;
+	ibnd_fabric_t *fabric = scan->fabric;
+
+	if (scan->cfg->max_hops &&
+	    fabric->maxhops_discovered > scan->cfg->max_hops)
+		return 0;
+
+	/* this may seem wrong but the only time we would retract the path is
+	 * if the user specified a CA for the DR path and we are retracting
+	 * from that to find the node it is connected to.  This counts as a
+	 * positive hop discovered
+	 */
+	fabric->maxhops_discovered++;
+	portid->drpath.p[portid->drpath.cnt] = 0;
+	portid->drpath.cnt--;
+	return 1;
+}
+
 static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 			int nextport)
 {
@@ -115,8 +140,9 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 		return -1;
 	}
 
-	if ((unsigned) portid->drpath.cnt > fabric->maxhops_discovered)
-		fabric->maxhops_discovered = portid->drpath.cnt;
+	if (((unsigned) portid->drpath.cnt - scan->initial_hops) >
+	    fabric->maxhops_discovered)
+		fabric->maxhops_discovered++;
 
 	return 1;
 }
@@ -202,9 +228,26 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
 		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+
+		int rc = 0;
 		ib_portid_t path = smp->path;
-		if (extend_dpath(engine, &path, port_num) > 0)
-			query_node_info(engine, &path, node);
+
+		if (node->type != IB_NODE_SWITCH &&
+		    node == fabric->from_node &&
+		    path.drpath.cnt > 1)
+			rc = retract_dpath(engine, &path);
+		else {
+			/* we can't proceed through an HCA with DR */
+			if (path.lid == 0 || node->type == IB_NODE_SWITCH)
+				rc = extend_dpath(engine, &path, port_num);
+		}
+
+		if (rc > 0) {
+			struct ni_cbdata * cbdata = malloc(sizeof(*cbdata));
+			cbdata->node = node;
+			cbdata->port_num = port_num;
+			query_node_info(engine, &path, cbdata);
+		}
 	}
 
 	return 0;
@@ -255,11 +298,6 @@ static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 	return rc;
 }
 
-static int get_last_port(ib_portid_t * path)
-{
-	return path->drpath.p[path->drpath.cnt];
-}
-
 static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 		       ibnd_node_t * remotenode, ibnd_port_t * remoteport)
 {
@@ -294,7 +332,9 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	ibnd_fabric_t *fabric = scan->fabric;
 	int i = 0;
 	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
-	ibnd_node_t *rem_node = cb_data;
+	struct ni_cbdata *ni_cbdata = (struct ni_cbdata *)cb_data;
+	ibnd_node_t *rem_node = NULL;
+	int rem_port_num = 0;
 	ibnd_node_t *node;
 	int node_is_new = 0;
 	uint64_t node_guid = mad_get_field64(node_info, 0, IB_NODE_GUID_F);
@@ -302,6 +342,12 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	int port_num = mad_get_field(node_info, 0, IB_NODE_LOCAL_PORT_F);
 	ibnd_port_t *port = NULL;
 
+	if (ni_cbdata) {
+		rem_node = ni_cbdata->node;
+		rem_port_num = ni_cbdata->port_num;
+		free(ni_cbdata);
+	}
+
 	node = ibnd_find_node_guid(fabric, node_guid);
 	if (!node) {
 		node = create_node(engine, &smp->path, node_info);
@@ -333,8 +379,6 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		fabric->from_portnum = port_num;
 	} else {
 		/* link ports... */
-		int rem_port_num = get_last_port(&smp->path);
-
 		if (!rem_node->ports[rem_port_num]) {
 			IBND_ERROR("Internal Error; "
 				   "Node(%p) 0x%" PRIx64
@@ -363,11 +407,11 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 }
 
 static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
-			   ibnd_node_t * node)
+			   struct ni_cbdata * cbdata)
 {
 	IBND_DEBUG("Query Node Info; %s\n", portid2str(portid));
 	return issue_smp(engine, portid, IB_ATTR_NODE_INFO, 0,
-			 recv_node_info, node);
+			 recv_node_info, (void *)cbdata);
 }
 
 ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
@@ -454,8 +498,7 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static int set_config(struct ibnd_config *config, struct ibnd_config *cfg,
-		      int initial_hops)
+static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
 {
 	if (!config)
 		return (-EINVAL);
@@ -469,8 +512,6 @@ static int set_config(struct ibnd_config *config, struct ibnd_config *cfg,
 		config->timeout_ms = DEFAULT_TIMEOUT;
 	if (!config->retries)
 		config->retries = DEFAULT_RETRIES;
-	if (config->max_hops)
-		config->max_hops += initial_hops;
 
 	return (0);
 }
@@ -491,7 +532,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	if (!from)
 		from = &my_portid;
 
-	if (set_config(&config, cfg, from->drpath.cnt)) {
+	if (set_config(&config, cfg)) {
 		IBND_ERROR("Invalid ibnd_config\n");
 		return NULL;
 	}
@@ -507,6 +548,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
 	scan.cfg = &config;
+	scan.initial_hops = from->drpath.cnt;
 
 	if (smp_engine_init(&engine, ca_name, ca_port, &scan, &config)) {
 		free(fabric);
@@ -529,6 +571,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 			goto error;
 
 	fabric->total_mads_used = engine.total_smps;
+	fabric->maxhops_discovered += scan.initial_hops;
 
 	if (group_nodes(fabric))
 		goto error;
diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
index 3c599ec..80918c4 100644
--- a/libibnetdisc/src/internal.h
+++ b/libibnetdisc/src/internal.h
@@ -62,6 +62,7 @@ typedef struct ibnd_scan {
 	ibnd_fabric_t *fabric;
 	struct ibnd_config *cfg;
 	struct ibmad_port *ibmad_port;
+	unsigned initial_hops;
 } ibnd_scan_t;
 
 typedef struct ibnd_smp ibnd_smp_t;
diff --git a/man/iblinkinfo.8 b/man/iblinkinfo.8
index a66db6d..dc3f328 100644
--- a/man/iblinkinfo.8
+++ b/man/iblinkinfo.8
@@ -5,34 +5,32 @@ iblinkinfo \- report link info for all links in the fabric
 
 .SH SYNOPSIS
 .B iblinkinfo
-   [-hcdl -C <ca_name> -P <ca_port> -v <lt,hoq,vlstall> -S <guid>
--D <direct_route> \-\-load\-cache <filename>]
+   [-hcdl -C <ca_name> -P <ca_port> -p -S <node_guid> -G <node_guid> -D <direct_route> \-\-load\-cache <filename>]
 
 .SH DESCRIPTION
 .PP
-iblinkinfo reports the link info for each port of each switch active in the
-IB fabric.
+iblinkinfo reports port info for each port in an IB fabric, node by node.
 
 .SH OPTIONS
 
 .PP
 .TP
-\fB\-S <guid>\fR
-Output only the switch specified by <guid> (hex format)
+\fB\-S <node_guid>\fR \fB\-G <node_guid>\fR
+Output only the node specified by <node_guid> (hex format)
 .TP
 \fB\-D <direct_route>\fR
-Output only the switch specified by the direct route path.
+Output only the node specified by the direct route path.
 .TP
 \fB\-l\fR
 Print all information for each link on one line. Default is to print a header
-with the switch information and then a list for each port (useful for
+with the node information and then a list for each port (useful for
 grep\'ing output).
 .TP
 \fB\-d\fR
-Print only switches which have a port in the "Down" state.
+Print only nodes which have a port in the "Down" state.
 .TP
-\fB\-v <lt,hoq,vlstall>\fR
-Verify additional switch settings (<LifeTime>,<HoqLife>,<VLStallCount>)
+\fB\-p\fR
+Print additional port settings (<LifeTime>,<HoqLife>,<VLStallCount>)
 .TP
 \fB\-C <ca_name>\fR    use the specified ca_name for the search.
 .TP
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 2f69acf..9ad0700 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -245,9 +245,13 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	if (line_mode) {
 		char *remap = remap_node_name(node_name_map, node->guid,
 					      node->nodedesc);
+		uint64_t guid = node->guid;
+		if (print_port_guids)
+		       guid = port->guid;
+
 		printf("%s0x%016" PRIx64 " \"%30s\" ",
 		       out_prefix ? out_prefix : "",
-		       node->guid, remap);
+		       guid, remap);
 		free(remap);
 	} else
 		printf("%s      ", out_prefix ? out_prefix : "");
@@ -256,20 +260,34 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 	       node->smalid, port->portnum, ext_port_str, link_str, remote_str);
 }
 
-void print_switch_header(ibnd_node_t *node, int *out_header_flag, char *out_prefix)
+static inline const char *nodetype_str(ibnd_node_t * node)
+{
+	switch (node->type) {
+	case IB_NODE_SWITCH:
+		return "Switch";
+	case IB_NODE_CA:
+		return "CA";
+	case IB_NODE_ROUTER:
+		return "Router";
+	}
+	return "??";
+}
+
+void print_node_header(ibnd_node_t *node, int *out_header_flag, char *out_prefix)
 {
 	if ((!out_header_flag || !(*out_header_flag)) && !line_mode) {
 		char *remap =
 			remap_node_name(node_name_map, node->guid, node->nodedesc);
-		printf("%sSwitch 0x%016" PRIx64 " %s:\n",
+		printf("%s%s 0x%016" PRIx64 " %s:\n",
 		       out_prefix ? out_prefix : "",
+		       nodetype_str(node),
 		       node->guid, remap);
 		(*out_header_flag)++;
 		free(remap);
 	}
 }
 
-void print_switch(ibnd_node_t * node, void *user_data)
+void print_node(ibnd_node_t * node, void *user_data)
 {
 	int i = 0;
 	int head_print = 0;
@@ -282,7 +300,7 @@ void print_switch(ibnd_node_t * node, void *user_data)
 		if (!down_links_only ||
 		    mad_get_field(port->info, 0,
 				  IB_PORT_STATE_F) == IB_LINK_DOWN) {
-			print_switch_header(node, &head_print, out_prefix);
+			print_node_header(node, &head_print, out_prefix);
 			print_port(node, port, out_prefix);
 		}
 	}
@@ -359,7 +377,7 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 			output_diff++;
 
 		if (output_diff && fabric1_port) {
-			print_switch_header(fabric1_node,
+			print_node_header(fabric1_node,
 					    head_print,
 					    NULL);
 			print_port(fabric1_node,
@@ -368,7 +386,7 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 		}
 
 		if (output_diff && fabric2_port) {
-			print_switch_header(fabric1_node,
+			print_node_header(fabric1_node,
 					    head_print,
 					    NULL);
 			print_port(fabric2_node,
@@ -388,7 +406,7 @@ void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 
 	fabric2_node = ibnd_find_node_guid(data->fabric2, fabric1_node->guid);
 	if (!fabric2_node)
-		print_switch(fabric1_node, data->fabric1_prefix);
+		print_node(fabric1_node, data->fabric1_prefix);
 	else if (data->diff_flags &
 		 (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE
 		  | DIFF_FLAG_LID | DIFF_FLAG_NODE_DESCRIPTION)) {
@@ -398,17 +416,17 @@ void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 		    (data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
 		     && memcmp(fabric1_node->nodedesc, fabric2_node->nodedesc,
 			       IB_SMP_DATA_SIZE))) {
-			print_switch_header(fabric1_node,
+			print_node_header(fabric1_node,
 					    NULL,
 					    data->fabric1_prefix);
-			print_switch_header(fabric2_node,
+			print_node_header(fabric2_node,
 					    NULL,
 					    data->fabric2_prefix);
 			head_print++;
 		}
 
 		if (fabric1_node->numports != fabric2_node->numports) {
-			print_switch_header(fabric1_node,
+			print_node_header(fabric1_node,
 					    &head_print,
 					    NULL);
 			printf("%snumports = %d\n", data->fabric1_prefix,
@@ -423,8 +441,8 @@ void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 	}
 }
 
-int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
-		ibnd_fabric_t * new_fabric)
+int diff_node(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
+	      ibnd_fabric_t * new_fabric)
 {
 	struct iter_diff_data iter_diff_data;
 
@@ -436,8 +454,8 @@ int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	if (node)
 		diff_switch_iter(node, &iter_diff_data);
 	else
-		ibnd_iter_nodes_type(orig_fabric, diff_switch_iter,
-				     IB_NODE_SWITCH, &iter_diff_data);
+		ibnd_iter_nodes(orig_fabric, diff_switch_iter,
+				&iter_diff_data);
 
 	/* Do opposite diff to find existence of node types
 	 * in new_fabric but not in orig_fabric.
@@ -458,8 +476,8 @@ int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	if (node)
 		diff_switch_iter(node, &iter_diff_data);
 	else
-		ibnd_iter_nodes_type(new_fabric, diff_switch_iter,
-				     IB_NODE_SWITCH, &iter_diff_data);
+		ibnd_iter_nodes(new_fabric, diff_switch_iter,
+				&iter_diff_data);
 
 	return 0;
 }
@@ -503,6 +521,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		filterdownports_cache_file = strdup(optarg);
 		break;
 	case 'S':
+	case 'G':
 		guid_str = optarg;
 		guid = (uint64_t) strtoull(guid_str, 0, 0);
 		break;
@@ -553,12 +572,14 @@ int main(int argc, char **argv)
 
 	const struct ibdiag_opt opts[] = {
 		{"node-name-map", 1, 1, "<file>", "node name map file"},
-		{"switch", 'S', 1, "<switch_guid>",
-		 "query only <switch_guid> (hex format)"},
+		{"switch", 'S', 1, "<node_guid>",
+		 "query only <node_guid> (same as -G)"},
+		{"node-guid", 'G', 1, "<node_guid>",
+		 "query only <node_guid> (same as -S)"},
 		{"Direct", 'D', 1, "<dr_path>",
 		 "query only node specified by <dr_path>"},
 		{"all", 'a', 0, NULL,
-		 "print all switches found in a partial fabric scan"},
+		 "print all nodes found in a partial fabric scan"},
 		{"hops", 'n', 1, "<hops>",
 		 "Number of hops to include away from specified node"},
 		{"down", 'd', 0, NULL, "print only down links"},
@@ -645,7 +666,7 @@ int main(int argc, char **argv)
 			if (!(fabric =
 			    ibnd_discover_fabric(ibd_ca, ibd_ca_port, &port_id, &config)))
 				IBWARN("Single node discover failed;"
-				       " attempting full scan\n");
+				       " attempting full scan");
 		}
 
 		if (!fabric &&
@@ -657,18 +678,17 @@ int main(int argc, char **argv)
 	}
 
 	if (!all && guid_str) {
-		ibnd_node_t *sw = ibnd_find_node_guid(fabric, guid);
-		if (sw && sw->type == IB_NODE_TYPE_SWITCH) {
+		ibnd_node_t *node = ibnd_find_node_guid(fabric, guid);
+		if (node) {
 			if (diff_fabric)
-				diff_switch(sw, diff_fabric, fabric);
+				diff_node(node, diff_fabric, fabric);
 			else
-				print_switch(sw, NULL);
+				print_node(node, NULL);
 		}
 		else
-			fprintf(stderr, "Failed to find switch: %s\n",
-				guid_str);
+			fprintf(stderr, "Failed to find node: %s\n", guid_str);
 	} else if (!all && dr_path) {
-		ibnd_node_t *sw = NULL;
+		ibnd_node_t *node = NULL;
 		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 
 		if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
@@ -676,21 +696,20 @@ int main(int argc, char **argv)
 			return -1;
 		mad_decode_field(ni, IB_NODE_GUID_F, &(guid));
 
-		sw = ibnd_find_node_guid(fabric, guid);
-		if (sw && sw->type == IB_NODE_TYPE_SWITCH) {
+		node = ibnd_find_node_guid(fabric, guid);
+		if (node) {
 			if (diff_fabric)
-				diff_switch(sw, diff_fabric, fabric);
+				diff_node(node, diff_fabric, fabric);
 			else
-				print_switch(sw, NULL);
+				print_node(node, NULL);
 		}
 		else
-			fprintf(stderr, "Failed to find switch: %s\n", dr_path);
+			fprintf(stderr, "Failed to find node: %s\n", dr_path);
 	} else {
 		if (diff_fabric)
-			diff_switch(NULL, diff_fabric, fabric);
+			diff_node(NULL, diff_fabric, fabric);
 		else
-			ibnd_iter_nodes_type(fabric, print_switch,
-					     IB_NODE_SWITCH, NULL);
+			ibnd_iter_nodes(fabric, print_node, NULL);
 	}
 
 	ibnd_destroy_fabric(fabric);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
