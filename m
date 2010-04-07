From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [1/3] support --diff in ibnetdiscover
Date: Wed, 07 Apr 2010 10:05:38 -0700
Message-ID: <1270659938.26381.39.camel@crazyclimber.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-zMruRO2XEPvhEwAhysEX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-zMruRO2XEPvhEwAhysEX
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This patch adds the default --diff support in ibnetdiscover.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-zMruRO2XEPvhEwAhysEX
Content-Disposition: attachment; filename=0001-support-diff-in-ibnetdiscover.patch
Content-Type: message/rfc822; name=0001-support-diff-in-ibnetdiscover.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 31 Mar 2010 11:10:34 -0700
Subject: [PATCH] support --diff in ibnetdiscover
Message-Id: <1270659341.26381.27.camel-RLKWKRZIcZkVVsCFsIUZTRy+HRzXvqW9@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibnetdiscover.8 |    7 +
 infiniband-diags/src/ibnetdiscover.c |  246 +++++++++++++++++++++++++++++----
 2 files changed, 223 insertions(+), 30 deletions(-)

diff --git a/infiniband-diags/man/ibnetdiscover.8 b/infiniband-diags/man/ibnetdiscover.8
index 082a8e4..975b999 100644
--- a/infiniband-diags/man/ibnetdiscover.8
+++ b/infiniband-diags/man/ibnetdiscover.8
@@ -57,6 +57,13 @@ Load and use the cached ibnetdiscover data stored in the specified
 filename.  May be useful for outputting and learning about other
 fabrics or a previous state of a fabric.
 .TP
+\fB\-\-diff\fR <filename>
+Load cached ibnetdiscover data and do a diff comparison to the current
+network or another cache.  A special diff output for ibnetdiscover
+output will be displayed showing differences between the old and current
+fabric.  By default, the following are compared for differences: switches,
+channel adapters, routers, and port connections.
+.TP
 \fB\-p\fR, \fB\-\-ports\fR
 Obtain a ports report which is a
 list of connected ports with relevant information (like LID, portnum,
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 651bafd..4da09ce 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -57,6 +57,16 @@
 #define LIST_SWITCH_NODE (1 << IB_NODE_SWITCH)
 #define LIST_ROUTER_NODE (1 << IB_NODE_ROUTER)
 
+#define DIFF_FLAG_SWITCH          0x00000001
+#define DIFF_FLAG_CA              0x00000002
+#define DIFF_FLAG_ROUTER          0x00000004
+#define DIFF_FLAG_PORT_CONNECTION 0x00000008
+
+#define DIFF_FLAG_DEFAULT      (DIFF_FLAG_SWITCH \
+				| DIFF_FLAG_CA \
+				| DIFF_FLAG_ROUTER \
+				| DIFF_FLAG_PORT_CONNECTION)
+
 struct ibmad_port *srcport;
 
 static FILE *f;
@@ -65,6 +75,7 @@ static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
 static char *cache_file = NULL;
 static char *load_cache_file = NULL;
+static char *diff_cache_file = NULL;
 
 static int report_max_hops = 0;
 
@@ -183,16 +194,20 @@ void list_nodes(ibnd_fabric_t * fabric, int list)
 		ibnd_iter_nodes_type(fabric, list_node, IB_NODE_ROUTER, NULL);
 }
 
-void out_ids(ibnd_node_t * node, int group, char *chname)
+void out_ids(ibnd_node_t * node, int group, char *chname, char *out_prefix)
 {
 	uint64_t sysimgguid =
 	    mad_get_field64(node->info, 0, IB_NODE_SYSTEM_GUID_F);
 
-	fprintf(f, "\nvendid=0x%x\ndevid=0x%x\n",
-		mad_get_field(node->info, 0, IB_NODE_VENDORID_F),
+	fprintf(f, "\n%svendid=0x%x\n",
+		out_prefix ? out_prefix : "",
+		mad_get_field(node->info, 0, IB_NODE_VENDORID_F));
+	fprintf(f, "%sdevid=0x%x\n",
+		out_prefix ? out_prefix : "",
 		mad_get_field(node->info, 0, IB_NODE_DEVID_F));
 	if (sysimgguid)
-		fprintf(f, "sysimgguid=0x%" PRIx64, sysimgguid);
+		fprintf(f, "%ssysimgguid=0x%" PRIx64,
+			out_prefix ? out_prefix : "", sysimgguid);
 	if (group && node->chassis && node->chassis->chassisnum) {
 		fprintf(f, "\t\t# Chassis %d", node->chassis->chassisnum);
 		if (chname)
@@ -217,14 +232,15 @@ uint64_t out_chassis(ibnd_fabric_t * fabric, unsigned char chassisnum)
 	return guid;
 }
 
-void out_switch(ibnd_node_t * node, int group, char *chname)
+void out_switch(ibnd_node_t * node, int group, char *chname, char *out_prefix)
 {
 	char *str;
 	char str2[256];
 	char *nodename = NULL;
 
-	out_ids(node, group, chname);
-	fprintf(f, "switchguid=0x%" PRIx64, node->guid);
+	out_ids(node, group, chname, out_prefix);
+	fprintf(f, "%sswitchguid=0x%" PRIx64,
+		out_prefix ? out_prefix : "", node->guid);
 	fprintf(f, "(%" PRIx64 ")",
 		mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F));
 	if (group) {
@@ -239,7 +255,8 @@ void out_switch(ibnd_node_t * node, int group, char *chname)
 
 	nodename = remap_node_name(node_name_map, node->guid, node->nodedesc);
 
-	fprintf(f, "\nSwitch\t%d %s\t\t# \"%s\" %s port 0 lid %d lmc %d\n",
+	fprintf(f, "\n%sSwitch\t%d %s\t\t# \"%s\" %s port 0 lid %d lmc %d\n",
+		out_prefix ? out_prefix : "",
 		node->numports, node_name(node), nodename,
 		node->smaenhsp0 ? "enhanced" : "base",
 		node->smalid, node->smalmc);
@@ -247,12 +264,12 @@ void out_switch(ibnd_node_t * node, int group, char *chname)
 	free(nodename);
 }
 
-void out_ca(ibnd_node_t * node, int group, char *chname)
+void out_ca(ibnd_node_t * node, int group, char *chname, char *out_prefix)
 {
 	char *node_type;
 	char *node_type2;
 
-	out_ids(node, group, chname);
+	out_ids(node, group, chname, out_prefix);
 	switch (node->type) {
 	case IB_NODE_CA:
 		node_type = "ca";
@@ -268,8 +285,10 @@ void out_ca(ibnd_node_t * node, int group, char *chname)
 		break;
 	}
 
-	fprintf(f, "%sguid=0x%" PRIx64 "\n", node_type, node->guid);
-	fprintf(f, "%s\t%d %s\t\t# \"%s\"",
+	fprintf(f, "%s%sguid=0x%" PRIx64 "\n",
+		out_prefix ? out_prefix : "", node_type, node->guid);
+	fprintf(f, "%s%s\t%d %s\t\t# \"%s\"",
+		out_prefix ? out_prefix : "",
 		node_type2, node->numports, node_name(node),
 		clean_nodedesc(node->nodedesc));
 	if (group && ibnd_is_xsigo_hca(node->guid))
@@ -291,7 +310,7 @@ static char *out_ext_port(ibnd_port_t * port, int group)
 	return (NULL);
 }
 
-void out_switch_port(ibnd_port_t * port, int group)
+void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 {
 	char *ext_port_str = NULL;
 	char *rem_nodename = NULL;
@@ -302,7 +321,7 @@ void out_switch_port(ibnd_port_t * port, int group)
 
 	DEBUG("port %p:%d remoteport %p\n", port, port->portnum,
 	      port->remoteport);
-	fprintf(f, "[%d]", port->portnum);
+	fprintf(f, "%s[%d]", out_prefix ? out_prefix : "", port->portnum);
 
 	ext_port_str = out_ext_port(port, group);
 	if (ext_port_str)
@@ -334,7 +353,7 @@ void out_switch_port(ibnd_port_t * port, int group)
 	free(rem_nodename);
 }
 
-void out_ca_port(ibnd_port_t * port, int group)
+void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 {
 	char *str = NULL;
 	char *rem_nodename = NULL;
@@ -343,7 +362,7 @@ void out_ca_port(ibnd_port_t * port, int group)
 	uint32_t ispeed = mad_get_field(port->info, 0,
 					IB_PORT_LINK_SPEED_ACTIVE_F);
 
-	fprintf(f, "[%d]", port->portnum);
+	fprintf(f, "%s[%d]", out_prefix ? out_prefix : "", port->portnum);
 	if (port->node->type != IB_NODE_SWITCH)
 		fprintf(f, "(%" PRIx64 ") ", port->guid);
 	fprintf(f, "\t%s[%d]",
@@ -386,11 +405,11 @@ static void switch_iter_func(ibnd_node_t * node, void *iter_user_data)
 	    && node->chassis->chassisnum)
 		return;
 
-	out_switch(node, data->group, NULL);
+	out_switch(node, data->group, NULL, NULL);
 	for (p = 1; p <= node->numports; p++) {
 		port = node->ports[p];
 		if (port && port->remoteport)
-			out_switch_port(port, data->group);
+			out_switch_port(port, data->group, NULL);
 	}
 }
 
@@ -404,12 +423,12 @@ static void ca_iter_func(ibnd_node_t * node, void *iter_user_data)
 	/* Now, skip chassis based CAs */
 	if (data->group && node->chassis && node->chassis->chassisnum)
 		return;
-	out_ca(node, data->group, NULL);
+	out_ca(node, data->group, NULL, NULL);
 
 	for (p = 1; p <= node->numports; p++) {
 		port = node->ports[p];
 		if (port && port->remoteport)
-			out_ca_port(port, data->group);
+			out_ca_port(port, data->group, NULL);
 	}
 }
 
@@ -423,11 +442,11 @@ static void router_iter_func(ibnd_node_t * node, void *iter_user_data)
 	/* Now, skip chassis based RTs */
 	if (data->group && node->chassis && node->chassis->chassisnum)
 		return;
-	out_ca(node, data->group, NULL);
+	out_ca(node, data->group, NULL, NULL);
 	for (p = 1; p <= node->numports; p++) {
 		port = node->ports[p];
 		if (port && port->remoteport)
-			out_ca_port(port, data->group);
+			out_ca_port(port, data->group, NULL);
 	}
 }
 
@@ -482,7 +501,7 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (n = 1; n <= SPINES_MAX_NUM; n++) {
 				if (ch->spinenode[n]) {
 					out_switch(ch->spinenode[n], group,
-						   chname);
+						   chname, NULL);
 					for (p = 1;
 					     p <= ch->spinenode[n]->numports;
 					     p++) {
@@ -490,7 +509,8 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 						    ch->spinenode[n]->ports[p];
 						if (port && port->remoteport)
 							out_switch_port(port,
-									group);
+									group,
+									NULL);
 					}
 				}
 			}
@@ -498,7 +518,7 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (n = 1; n <= LINES_MAX_NUM; n++) {
 				if (ch->linenode[n]) {
 					out_switch(ch->linenode[n], group,
-						   chname);
+						   chname, NULL);
 					for (p = 1;
 					     p <= ch->linenode[n]->numports;
 					     p++) {
@@ -506,7 +526,8 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 						    ch->linenode[n]->ports[p];
 						if (port && port->remoteport)
 							out_switch_port(port,
-									group);
+									group,
+									NULL);
 					}
 				}
 			}
@@ -515,12 +536,13 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (node = ch->nodes; node;
 			     node = node->next_chassis_node) {
 				if (node->type == IB_NODE_SWITCH) {
-					out_switch(node, group, chname);
+					out_switch(node, group, chname, NULL);
 					for (p = 1; p <= node->numports; p++) {
 						port = node->ports[p];
 						if (port && port->remoteport)
 							out_switch_port(port,
-									group);
+									group,
+									NULL);
 					}
 				}
 
@@ -530,12 +552,13 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (node = ch->nodes; node;
 			     node = node->next_chassis_node) {
 				if (node->type == IB_NODE_CA) {
-					out_ca(node, group, chname);
+					out_ca(node, group, chname, NULL);
 					for (p = 1; p <= node->numports; p++) {
 						port = node->ports[p];
 						if (port && port->remoteport)
 							out_ca_port(port,
-								    group);
+								    group,
+								    NULL);
 					}
 				}
 			}
@@ -610,6 +633,155 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 	}
 }
 
+struct iter_diff_data {
+	uint32_t diff_flags;
+	ibnd_fabric_t * fabric1;
+	ibnd_fabric_t * fabric2;
+	char *fabric1_prefix;
+	char *fabric2_prefix;
+	void (*out_header)(ibnd_node_t *, int, char *, char *);
+	void (*out_port)(ibnd_port_t *, int, char *);
+};
+
+static void diff_iter_out_header(ibnd_node_t * node,
+				 struct iter_diff_data *data,
+				 int *out_header_flag)
+{
+	if (!(*out_header_flag)) {
+		(*data->out_header)(node, 0, NULL, NULL);
+		(*out_header_flag)++;
+	}
+}
+
+static void diff_iter_func(ibnd_node_t * fabric1_node, void *iter_user_data)
+{
+	struct iter_diff_data *data = (struct iter_diff_data *)iter_user_data;
+	ibnd_node_t *fabric2_node;
+	ibnd_port_t *fabric1_port;
+	int p;
+
+	DEBUG("DEBUG: fabric1_node %p\n", fabric1_node);
+
+	fabric2_node = ibnd_find_node_guid (data->fabric2, fabric1_node->guid);
+
+	if (!fabric2_node) {
+		(*data->out_header)(fabric1_node, 0, NULL, data->fabric1_prefix);
+		for (p = 1; p <= fabric1_node->numports; p++) {
+			fabric1_port = fabric1_node->ports[p];
+			if (fabric1_port && fabric1_port->remoteport)
+				(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
+		}
+	}
+	else if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION) {
+		ibnd_port_t *fabric2_port;
+		int out_header_flag = 0;
+
+		if (fabric1_node->numports != fabric2_node->numports) {
+			diff_iter_out_header(fabric1_node, data, &out_header_flag);
+			fprintf(f, "%snumports = %d\n",
+				data->fabric1_prefix, fabric1_node->numports);
+			fprintf(f, "%snumports = %d\n",
+				data->fabric2_prefix, fabric2_node->numports);
+			return;
+		}
+
+		for (p = 1; p <= fabric1_node->numports; p++) {
+			fabric1_port = fabric1_node->ports[p];
+			fabric2_port = fabric2_node->ports[p];
+			if ((fabric1_port && !fabric2_port)
+			    || ((fabric1_port && fabric2_port)
+				&& (fabric1_port->remoteport && !fabric2_port->remoteport))) {
+				diff_iter_out_header(fabric1_node, data, &out_header_flag);
+				(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
+			}
+			else if ((!fabric1_port && fabric2_port)
+				 || ((fabric1_port && fabric2_port)
+				     && (!fabric1_port->remoteport && fabric2_port->remoteport))) {
+				diff_iter_out_header(fabric1_node, data, &out_header_flag);
+				(*data->out_port)(fabric2_port, 0, data->fabric2_prefix);
+			}
+			else if ((fabric1_port && fabric2_port)
+				 && ((fabric1_port->guid != fabric2_port->guid)
+				     || ((fabric1_port->remoteport && fabric2_port->remoteport)
+					 && (fabric1_port->remoteport->guid != fabric2_port->remoteport->guid)))) {
+				diff_iter_out_header(fabric1_node, data, &out_header_flag);
+				(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
+				(*data->out_port)(fabric2_port, 0, data->fabric2_prefix);
+			}
+		}
+	}
+}
+
+static int diff_common(ibnd_fabric_t * orig_fabric,
+		       ibnd_fabric_t * new_fabric,
+		       int node_type,
+		       uint32_t diff_flags,
+		       void (*out_header)(ibnd_node_t *, int, char *, char *),
+		       void (*out_port)(ibnd_port_t *, int, char *))
+{
+	struct iter_diff_data iter_diff_data;
+
+	iter_diff_data.diff_flags = diff_flags;
+	iter_diff_data.fabric1 = orig_fabric;
+	iter_diff_data.fabric2 = new_fabric;
+	iter_diff_data.fabric1_prefix = "< ";
+	iter_diff_data.fabric2_prefix = "> ";
+	iter_diff_data.out_header = out_header;
+	iter_diff_data.out_port = out_port;
+	ibnd_iter_nodes_type(orig_fabric, diff_iter_func,
+			     node_type, &iter_diff_data);
+
+	/* Do opposite diff to find existence of node types
+	 * in new_fabric but not in orig_fabric.
+	 *
+	 * In this diff, we don't need to check port connections,
+	 * since it has already been done before.
+	 */
+	iter_diff_data.diff_flags = diff_flags & ~DIFF_FLAG_PORT_CONNECTION;
+	iter_diff_data.fabric1 = new_fabric;
+	iter_diff_data.fabric2 = orig_fabric;
+	iter_diff_data.fabric1_prefix = "> ";
+	iter_diff_data.fabric2_prefix = "< ";
+	iter_diff_data.out_header = out_header;
+	iter_diff_data.out_port = out_port;
+	ibnd_iter_nodes_type(new_fabric, diff_iter_func,
+			     node_type, &iter_diff_data);
+
+	return 0;
+}
+
+int diff(ibnd_fabric_t * orig_fabric, ibnd_fabric_t * new_fabric)
+{
+	uint32_t diff_flags = DIFF_FLAG_DEFAULT;
+
+	if (diff_flags & DIFF_FLAG_SWITCH)
+		diff_common(orig_fabric,
+			    new_fabric,
+			    IB_NODE_SWITCH,
+			    diff_flags,
+			    out_switch,
+			    out_switch_port);
+
+	if (diff_flags & DIFF_FLAG_CA)
+		diff_common(orig_fabric,
+			    new_fabric,
+			    IB_NODE_CA,
+			    diff_flags,
+			    out_ca,
+			    out_ca_port);
+
+	if (diff_flags & DIFF_FLAG_ROUTER)
+		diff_common(orig_fabric,
+			    new_fabric,
+			    IB_NODE_ROUTER,
+			    diff_flags,
+			    out_ca,
+			    out_ca_port);
+
+
+	return 0;
+}
+
 static int list, group, ports_report;
 
 static int process_opt(void *context, int ch, char *optarg)
@@ -624,6 +796,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 3:
 		load_cache_file = strdup(optarg);
 		break;
+	case 4:
+		diff_cache_file = strdup(optarg);
+		break;
 	case 's':
 		ibnd_show_progress(1);
 		break;
@@ -658,6 +833,7 @@ static int process_opt(void *context, int ch, char *optarg)
 int main(int argc, char **argv)
 {
 	ibnd_fabric_t *fabric = NULL;
+	ibnd_fabric_t *diff_fabric = NULL;
 
 	struct ibmad_port *ibmad_port;
 	int mgmt_classes[2] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS };
@@ -674,6 +850,8 @@ int main(int argc, char **argv)
 		 "filename to cache ibnetdiscover data to"},
 		{"load-cache", 3, 1, "<file>",
 		 "filename of ibnetdiscover cache to load"},
+		{"diff", 4, 1, "<file>",
+		 "filename of ibnetdiscover cache to diff"},
 		{"ports", 'p', 0, NULL, "obtain a ports report"},
 		{"max_hops", 'm', 0, NULL,
 		 "report max hops discovered by the library"},
@@ -704,6 +882,11 @@ int main(int argc, char **argv)
 
 	node_name_map = open_node_name_map(node_name_map_file);
 
+	if (diff_cache_file) {
+		if ((diff_fabric = ibnd_load_fabric(diff_cache_file, 0)) == NULL)
+			IBERROR("loading cached fabric for diff failed\n");
+	}
+
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL)
 			IBERROR("loading cached fabric failed\n");
@@ -717,6 +900,8 @@ int main(int argc, char **argv)
 		ibnd_iter_nodes(fabric, dump_ports_report, NULL);
 	else if (list)
 		list_nodes(fabric, list);
+	else if (diff_fabric)
+		diff(diff_fabric, fabric);
 	else
 		dump_topology(group, fabric);
 
@@ -725,6 +910,7 @@ int main(int argc, char **argv)
 			IBERROR("caching ibnetdiscover data failed\n");
 
 	ibnd_destroy_fabric(fabric);
+	ibnd_destroy_fabric(diff_fabric);
 	close_node_name_map(node_name_map);
 	mad_rpc_close_port(ibmad_port);
 	exit(0);
-- 
1.5.4.5


--=-zMruRO2XEPvhEwAhysEX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
