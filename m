From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3] infiniband-diags: convert ib[linkinfo|queryerrors] to
 use PortGUIDs
Date: Wed, 20 Jul 2011 16:16:56 -0700
Message-ID: <20110720161656.35f21e07.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


NodeGUID's are no longer output nor accepted as input.

Furthermore expand search to cover all node types:

iblinkinfo CA and router nodes are output in a slightly different manner due to
each port containing a unique PortGUID.  "-l" output is unaffected.

ibqueryerrors correctly reports PortGUID for each port printed.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/iblinkinfo.8       |   22 ++++----
 man/ibqueryerrors.8.in |   11 ++--
 src/iblinkinfo.c       |  146 +++++++++++++++++++++++++++---------------------
 src/ibqueryerrors.c    |   58 ++++++++++---------
 4 files changed, 131 insertions(+), 106 deletions(-)

diff --git a/man/iblinkinfo.8 b/man/iblinkinfo.8
index a66db6d..50d6254 100644
--- a/man/iblinkinfo.8
+++ b/man/iblinkinfo.8
@@ -5,34 +5,34 @@ iblinkinfo \- report link info for all links in the fabric
 
 .SH SYNOPSIS
 .B iblinkinfo
-   [-hcdl -C <ca_name> -P <ca_port> -v <lt,hoq,vlstall> -S <guid>
--D <direct_route> \-\-load\-cache <filename>]
+   [-hcdl -C <ca_name> -P <ca_port> -p -S <port_guid> -G <port_guid> -D <direct_route> \-\-load\-cache <filename>]
 
 .SH DESCRIPTION
 .PP
-iblinkinfo reports the link info for each port of each switch active in the
-IB fabric.
+iblinkinfo reports link info for each port in an IB fabric, node by node.
+Optionally, iblinkinfo can do partial scans and limit its output to parts of a
+fabric.
 
 .SH OPTIONS
 
 .PP
 .TP
-\fB\-S <guid>\fR
-Output only the switch specified by <guid> (hex format)
+\fB\-S <port_guid>\fR \fB\-G <port_guid>\fR \fB\-\-port\-guid\fR
+start partial scan at the port specified by <port_guid> (hex format)
 .TP
 \fB\-D <direct_route>\fR
-Output only the switch specified by the direct route path.
+start partial scan at the port specified by the direct route path.
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
diff --git a/man/ibqueryerrors.8.in b/man/ibqueryerrors.8.in
index 4e9c7a1..d190715 100644
--- a/man/ibqueryerrors.8.in
+++ b/man/ibqueryerrors.8.in
@@ -27,14 +27,15 @@ Suppress the errors listed in the comma separated list provided.
 Suppress some of the common "side effect" counters.  These counters usually do
 not indicate an error condition and can be usually be safely ignored.
 .TP
-\fB\-G <node_guid>\fR
-Report results only for the node guid specified.
+\fB\-G <port_guid>\fR \fB\-S <port_guid>\fR \fB\-\-port\-guid\fR
+Report results for the port specified.  For switches results are printed for
+all ports not just switch port 0.
 .TP
-\fB\-S <node_guid>\fR
-\-S is provided only for backward compatibility and works the same as "-G"
+\-S same as "-G". (provided only for backward compatibility)
 .TP
 \fB\-D <direct_route>\fR
-Report results only for the switch specified by the direct route path.
+Report results for the port specified.  For switches results are printed for
+all ports not just switch port 0.
 .TP
 \fB\-r\fR
 Report the port information.  This includes LID, port, external port (if
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index 8cf755d..c07d33e 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -77,7 +77,6 @@ static int all = 0;
 static int down_links_only = 0;
 static int line_mode = 0;
 static int add_sw_settings = 0;
-static int print_port_guids = 0;
 
 static unsigned int get_max(unsigned int num)
 {
@@ -217,14 +216,9 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 		get_msg(width_msg, speed_msg, 256, port);
 
 		if (line_mode) {
-			if (print_port_guids)
-				snprintf(remote_guid_str, 256,
-					 "0x%016" PRIx64 " ",
-					 port->remoteport->guid);
-			else
-				snprintf(remote_guid_str, 256,
-					 "0x%016" PRIx64 " ",
-					 port->remoteport->node->guid);
+			snprintf(remote_guid_str, 256,
+				 "0x%016" PRIx64 " ",
+				 port->remoteport->guid);
 		}
 
 		snprintf(remote_str, 256, "%s%6d %4d[%2s] \"%s\" (%s %s)\n",
@@ -247,29 +241,58 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 					      node->nodedesc);
 		printf("%s0x%016" PRIx64 " \"%30s\" ",
 		       out_prefix ? out_prefix : "",
-		       node->guid, remap);
+		       port->guid, remap);
 		free(remap);
 	} else
 		printf("%s      ", out_prefix ? out_prefix : "");
 
-	printf("%6d %4d[%2s] ==%s==>  %s",
-	       node->smalid, port->portnum, ext_port_str, link_str, remote_str);
+	if (port->node->type != IB_NODE_SWITCH) {
+		if (!line_mode)
+			printf("0x%016" PRIx64 " ", port->guid);
+
+		printf("%6d %4d[%2s] ==%s==>  %s",
+			port->base_lid,
+			port->portnum, ext_port_str, link_str, remote_str);
+	} else
+		printf("%6d %4d[%2s] ==%s==>  %s",
+			node->smalid, port->portnum, ext_port_str,
+			link_str, remote_str);
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
+void print_node_header(ibnd_node_t *node, int *out_header_flag,
+			char *out_prefix)
 {
 	if ((!out_header_flag || !(*out_header_flag)) && !line_mode) {
 		char *remap =
 			remap_node_name(node_name_map, node->guid, node->nodedesc);
-		printf("%sSwitch 0x%016" PRIx64 " %s:\n",
-		       out_prefix ? out_prefix : "",
-		       node->guid, remap);
+		if (node->type == IB_NODE_SWITCH)
+			printf("%s%s: 0x%016" PRIx64 " %s:\n",
+				out_prefix ? out_prefix : "",
+				nodetype_str(node),
+				node->ports[0]->guid, remap);
+		else
+			printf("%s%s: %s:\n",
+				out_prefix ? out_prefix : "",
+				nodetype_str(node), remap);
 		(*out_header_flag)++;
 		free(remap);
 	}
 }
 
-void print_switch(ibnd_node_t * node, void *user_data)
+void print_node(ibnd_node_t * node, void *user_data)
 {
 	int i = 0;
 	int head_print = 0;
@@ -282,7 +305,7 @@ void print_switch(ibnd_node_t * node, void *user_data)
 		if (!down_links_only ||
 		    mad_get_field(port->info, 0,
 				  IB_PORT_STATE_F) == IB_LINK_DOWN) {
-			print_switch_header(node, &head_print, out_prefix);
+			print_node_header(node, &head_print, out_prefix);
 			print_port(node, port, out_prefix);
 		}
 	}
@@ -296,7 +319,7 @@ struct iter_diff_data {
         char *fabric2_prefix;
 };
 
-void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
+void diff_node_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 		       int *head_print, struct iter_diff_data *data)
 {
 	int i = 0;
@@ -359,7 +382,7 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 			output_diff++;
 
 		if (output_diff && fabric1_port) {
-			print_switch_header(fabric1_node,
+			print_node_header(fabric1_node,
 					    head_print,
 					    NULL);
 			print_port(fabric1_node,
@@ -368,7 +391,7 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 		}
 
 		if (output_diff && fabric2_port) {
-			print_switch_header(fabric1_node,
+			print_node_header(fabric1_node,
 					    head_print,
 					    NULL);
 			print_port(fabric2_node,
@@ -378,7 +401,7 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 	}
 }
 
-void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
+void diff_node_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 {
 	struct iter_diff_data *data = iter_user_data;
 	ibnd_node_t *fabric2_node;
@@ -388,27 +411,28 @@ void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 
 	fabric2_node = ibnd_find_node_guid(data->fabric2, fabric1_node->guid);
 	if (!fabric2_node)
-		print_switch(fabric1_node, data->fabric1_prefix);
+		print_node(fabric1_node, data->fabric1_prefix);
 	else if (data->diff_flags &
 		 (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE
 		  | DIFF_FLAG_LID | DIFF_FLAG_NODE_DESCRIPTION)) {
 
-		if ((data->diff_flags & DIFF_FLAG_LID
+		if ((fabric1_node->type == IB_NODE_SWITCH
+		     && data->diff_flags & DIFF_FLAG_LID
 		     && fabric1_node->smalid != fabric2_node->smalid) ||
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
@@ -418,12 +442,12 @@ void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 			return;
 		}
 
-		diff_switch_ports(fabric1_node, fabric2_node,
+		diff_node_ports(fabric1_node, fabric2_node,
 				  &head_print, data);
 	}
 }
 
-int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
+int diff_node(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 		ibnd_fabric_t * new_fabric)
 {
 	struct iter_diff_data iter_diff_data;
@@ -434,10 +458,9 @@ int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	iter_diff_data.fabric1_prefix = "< ";
 	iter_diff_data.fabric2_prefix = "> ";
 	if (node)
-		diff_switch_iter(node, &iter_diff_data);
+		diff_node_iter(node, &iter_diff_data);
 	else
-		ibnd_iter_nodes_type(orig_fabric, diff_switch_iter,
-				     IB_NODE_SWITCH, &iter_diff_data);
+		ibnd_iter_nodes(orig_fabric, diff_node_iter, &iter_diff_data);
 
 	/* Do opposite diff to find existence of node types
 	 * in new_fabric but not in orig_fabric.
@@ -456,10 +479,9 @@ int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	iter_diff_data.fabric1_prefix = "> ";
 	iter_diff_data.fabric2_prefix = "< ";
 	if (node)
-		diff_switch_iter(node, &iter_diff_data);
+		diff_node_iter(node, &iter_diff_data);
 	else
-		ibnd_iter_nodes_type(new_fabric, diff_switch_iter,
-				     IB_NODE_SWITCH, &iter_diff_data);
+		ibnd_iter_nodes(new_fabric, diff_node_iter, &iter_diff_data);
 
 	return 0;
 }
@@ -503,6 +525,7 @@ static int process_opt(void *context, int ch, char *optarg)
 		filterdownports_cache_file = strdup(optarg);
 		break;
 	case 'S':
+	case 'G':
 		guid_str = optarg;
 		guid = (uint64_t) strtoull(guid_str, 0, 0);
 		break;
@@ -524,9 +547,6 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'p':
 		add_sw_settings = 1;
 		break;
-	case 'g':
-		print_port_guids = 1;
-		break;
 	case 'R':		/* nop */
 		break;
 	case 'o':
@@ -553,21 +573,21 @@ int main(int argc, char **argv)
 
 	const struct ibdiag_opt opts[] = {
 		{"node-name-map", 1, 1, "<file>", "node name map file"},
-		{"switch", 'S', 1, "<switch_guid>",
-		 "query only <switch_guid> (hex format)"},
+		{"switch", 'S', 1, "<port_guid>",
+		 "start partial scan at the port specified by <port_guid> (hex format)"},
+		{"port-guid", 'G', 1, "<port_guid>",
+		 "(same as -S)"},
 		{"Direct", 'D', 1, "<dr_path>",
-		 "query only node specified by <dr_path>"},
+		 "start partial scan at the port specified by <dr_path>"},
 		{"all", 'a', 0, NULL,
-		 "print all switches found in a partial fabric scan"},
+		 "print all nodes found in a partial fabric scan"},
 		{"hops", 'n', 1, "<hops>",
 		 "Number of hops to include away from specified node"},
 		{"down", 'd', 0, NULL, "print only down links"},
 		{"line", 'l', 0, NULL,
 		 "(line mode) print all information for each link on a single line"},
 		{"additional", 'p', 0, NULL,
-		 "print additional switch settings (PktLifeTime, HoqLife, VLStallCount)"},
-		{"portguids", 'g', 0, NULL,
-		 "print port guids instead of node guids"},
+		 "print additional port settings (PktLifeTime, HoqLife, VLStallCount)"},
 		{"load-cache", 2, 1, "<file>",
 		 "filename of ibnetdiscover cache to load"},
 		{"diff", 3, 1, "<file>",
@@ -616,7 +636,7 @@ int main(int argc, char **argv)
 		     ib_resolve_portid_str_via(&port_id, dr_path,
 					       IB_DEST_DRPATH, NULL,
 					       ibmad_port)) < 0)
-			IBWARN("Failed to resolve %s; attempting full scan\n",
+			IBWARN("Failed to resolve %s; attempting full scan",
 			       dr_path);
 	} else if (guid_str) {
 		if ((resolved =
@@ -645,7 +665,7 @@ int main(int argc, char **argv)
 				config.max_hops = 1;
 			if (!(fabric =
 			    ibnd_discover_fabric(ibd_ca, ibd_ca_port, &port_id, &config)))
-				IBWARN("Single node discover failed;"
+				IBWARN("Partial fabric scan failed;"
 				       " attempting full scan\n");
 		}
 
@@ -658,40 +678,40 @@ int main(int argc, char **argv)
 	}
 
 	if (!all && guid_str) {
-		ibnd_node_t *sw = ibnd_find_node_guid(fabric, guid);
-		if (sw && sw->type == IB_NODE_TYPE_SWITCH) {
+		ibnd_port_t *p = ibnd_find_port_guid(fabric, guid);
+		if (p) {
+			ibnd_node_t *n = p->node;
 			if (diff_fabric)
-				diff_switch(sw, diff_fabric, fabric);
+				diff_node(n, diff_fabric, fabric);
 			else
-				print_switch(sw, NULL);
+				print_node(n, NULL);
 		}
 		else
-			fprintf(stderr, "Failed to find switch: %s\n",
-				guid_str);
+			fprintf(stderr, "Failed to find port: %s\n", guid_str);
 	} else if (!all && dr_path) {
-		ibnd_node_t *sw = NULL;
+		ibnd_port_t *p = NULL;
 		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 
 		if (!smp_query_via(ni, &port_id, IB_ATTR_NODE_INFO, 0,
 				   ibd_timeout, ibmad_port))
 			return -1;
-		mad_decode_field(ni, IB_NODE_GUID_F, &(guid));
+		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(guid));
 
-		sw = ibnd_find_node_guid(fabric, guid);
-		if (sw && sw->type == IB_NODE_TYPE_SWITCH) {
+		p = ibnd_find_port_guid(fabric, guid);
+		if (p) {
+			ibnd_node_t *n = p->node;
 			if (diff_fabric)
-				diff_switch(sw, diff_fabric, fabric);
+				diff_node(n, diff_fabric, fabric);
 			else
-				print_switch(sw, NULL);
+				print_node(n, NULL);
 		}
 		else
-			fprintf(stderr, "Failed to find switch: %s\n", dr_path);
+			fprintf(stderr, "Failed to find port: %s\n", dr_path);
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
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 1bba0e0..39af3a0 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -64,8 +64,8 @@ static char *load_cache_file = NULL;
 int data_counters = 0;
 int data_counters_only = 0;
 int port_config = 0;
-uint64_t node_guid = 0;
-char *node_guid_str = NULL;
+uint64_t port_guid = 0;
+char *port_guid_str = NULL;
 #define SUP_MAX 64
 int sup_total = 0;
 enum MAD_FIELDS suppressed_fields[SUP_MAX];
@@ -259,7 +259,7 @@ static void print_port_config(char *node_name, ibnd_node_t * node, int portnum)
 
 		snprintf(remote_str, 256,
 			 "0x%016" PRIx64 " %6d %4d[%2s] \"%s\" (%s %s)\n",
-			 port->remoteport->node->guid,
+			 port->remoteport->guid,
 			 port->remoteport->base_lid ? port->remoteport->
 			 base_lid : port->remoteport->node->smalid,
 			 port->remoteport->portnum, ext_port_str, rem_node_name,
@@ -415,18 +415,21 @@ static int print_results(ib_portid_t * portid, char *node_name,
 		}
 
 		if (!*header_printed) {
-			printf("Errors for 0x%" PRIx64 " \"%s\"\n", node->guid,
-			       node_name);
+			if (node->type == IB_NODE_SWITCH)
+				printf("Errors for 0x%" PRIx64 " \"%s\"\n",
+					node->ports[0]->guid, node_name);
+			else
+				printf("Errors for \"%s\"\n", node_name);
 			*header_printed = 1;
 			summary.bad_nodes++;
 		}
 
 		if (portnum == 0xFF)
 			printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
-			       node->guid, str);
+			       node->ports[0]->guid, str);
 		else
 			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
-			       node->guid, portnum, str);
+			       node->ports[portnum]->guid, portnum, str);
 		if (portnum != 0xFF && port_config)
 			print_port_config(node_name, node, portnum);
 
@@ -805,8 +808,8 @@ static int process_opt(void *context, int ch, char *optarg)
 		break;
 	case 'G':
 	case 'S':
-		node_guid_str = optarg;
-		node_guid = strtoull(optarg, 0, 0);
+		port_guid_str = optarg;
+		port_guid = strtoull(optarg, 0, 0);
 		break;
 	case 'D':
 		dr_path = strdup(optarg);
@@ -850,13 +853,14 @@ int main(int argc, char **argv)
 		{"suppress-common", 'c', 0, NULL,
 		 "suppress some of the common counters"},
 		{"node-name-map", 1, 1, "<file>", "node name map file"},
-		{"node-guid", 'G', 1, "<node_guid>", "query only <node_guid>"},
-		{"", 'S', 1, "<node_guid>",
+		{"port-guid", 'G', 1, "<port_guid>",
+		 "report the node containing the port specified by <port_guid>"},
+		{"", 'S', 1, "<port_guid>",
 		 "Same as \"-G\" for backward compatibility"},
 		{"Direct", 'D', 1, "<dr_path>",
-		 "query only switch specified by <dr_path>"},
+		 "report the node containing the port specified by <dr_path>"},
 		{"report-port", 'r', 0, NULL,
-		 "report port configuration information"},
+		 "report port link information"},
 		{"threshold-file", 8, 1, NULL,
 		 "specify an alternate threshold file, default: " DEF_THRES_FILE},
 		{"GNDN", 'R', 0, NULL,
@@ -913,13 +917,13 @@ int main(int argc, char **argv)
 					       NULL, ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan",
 			       dr_path);
-	} else if (node_guid_str) {
+	} else if (port_guid_str) {
 		if ((resolved =
-		     ib_resolve_portid_str_via(&portid, node_guid_str,
+		     ib_resolve_portid_str_via(&portid, port_guid_str,
 					       IB_DEST_GUID, ibd_sm_id,
 					       ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan",
-			       node_guid_str);
+			       port_guid_str);
 	}
 
 	if (load_cache_file) {
@@ -949,15 +953,15 @@ int main(int argc, char **argv)
 
 	set_thresholds(threshold_file);
 
-	if (node_guid_str) {
-		ibnd_node_t *node = ibnd_find_node_guid(fabric, node_guid);
-		if (node)
-			print_node(node, NULL);
+	if (port_guid_str) {
+		ibnd_port_t *port = ibnd_find_port_guid(fabric, port_guid);
+		if (port)
+			print_node(port->node, NULL);
 		else
 			fprintf(stderr, "Failed to find node: %s\n",
-				node_guid_str);
+				port_guid_str);
 	} else if (dr_path) {
-		ibnd_node_t *node = ibnd_find_node_dr(fabric, dr_path);
+		ibnd_port_t *port = ibnd_find_port_dr(fabric, dr_path);
 		uint8_t ni[IB_SMP_DATA_SIZE] = { 0 };
 
 		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
@@ -965,12 +969,12 @@ int main(int argc, char **argv)
 			rc = -1;
 			goto destroy_fabric;
 		}
-		mad_decode_field(ni, IB_NODE_GUID_F, &(node_guid));
+		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(port_guid));
 
-		node = ibnd_find_node_guid(fabric, node_guid);
-		if (node)
-			print_node(node, NULL);
-		else
+		port = ibnd_find_port_guid(fabric, port_guid);
+		if (port) {
+			print_node(port->node, NULL);
+		} else
 			fprintf(stderr, "Failed to find node: %s\n", dr_path);
 	} else
 		ibnd_iter_nodes(fabric, print_node, NULL);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
