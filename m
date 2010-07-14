From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [1/4] add --diff support to iblinkinfo [REPOST]
Date: Wed, 14 Jul 2010 09:29:45 -0700
Message-ID: <1279124985.20914.213.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-n/RQ9hPY+XA4I1bTuBAp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-n/RQ9hPY+XA4I1bTuBAp
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

Similar to ibnetdiscover, this patch support a --diff option in
iblinkinfo.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-n/RQ9hPY+XA4I1bTuBAp
Content-Disposition: attachment; filename=0001-add-diff-support-to-iblinkinfo.patch
Content-Type: message/rfc822; name=0001-add-diff-support-to-iblinkinfo.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 19 Apr 2010 10:36:54 -0700
Subject: [PATCH] add --diff support to iblinkinfo
Message-Id: <1279124683.20914.205.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8 |    8 ++
 infiniband-diags/src/iblinkinfo.c |  221 +++++++++++++++++++++++++++++++++---
 2 files changed, 210 insertions(+), 19 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index f184edf..b91afbd 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -50,6 +50,14 @@ fabrics or a previous state of a fabric.  Cannot be used if user
 specifies a directo route path.  See
 .B ibnetdiscover
 for information on caching ibnetdiscover output.
+.TP
+\fB\-\-diff\fR <filename>
+Load cached ibnetdiscover data and do a diff comparison to the current
+network or another cache.  A special diff output for iblinkinfo
+output will be displayed showing differences between the old and current
+fabric links.  See
+.B ibnetdiscover
+for information on caching ibnetdiscover output.
 
 .SH AUTHOR
 .TP
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index d0c9b13..4b922af 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -53,9 +53,16 @@
 
 #include "ibdiag_common.h"
 
+#define DIFF_FLAG_PORT_CONNECTION  0x01
+#define DIFF_FLAG_PORT_STATE       0x02
+
+#define DIFF_FLAG_DEFAULT (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE)
+
 static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
 static char *load_cache_file = NULL;
+static char *diff_cache_file = NULL;
+static unsigned diffcheck_flags = DIFF_FLAG_DEFAULT;
 
 static uint64_t guid = 0;
 static char *guid_str = NULL;
@@ -107,7 +114,7 @@ void get_msg(char *width_msg, char *speed_msg, int msg_size, ibnd_port_t * port)
 				      buf, 64, &max_speed));
 }
 
-void print_port(ibnd_node_t * node, ibnd_port_t * port)
+void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 {
 	char width[64], speed[64], state[64], physstate[64];
 	char remote_guid_str[256];
@@ -204,21 +211,35 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port)
 	if (line_mode) {
 		char *remap = remap_node_name(node_name_map, node->guid,
 					      node->nodedesc);
-		printf("0x%016" PRIx64 " \"%30s\" ", node->guid, remap);
+		printf("%s0x%016" PRIx64 " \"%30s\" ",
+		       out_prefix ? out_prefix : "",
+		       node->guid, remap);
 		free(remap);
 	} else
-		printf("      ");
+		printf("%s      ", out_prefix ? out_prefix : "");
 
 	printf("%6d %4d[%2s] ==%s==>  %s",
 	       node->smalid, port->portnum, ext_port_str, link_str, remote_str);
 }
 
+void print_switch_header(ibnd_node_t *node, int *out_header_flag, char *out_prefix)
+{
+	if (!(*out_header_flag) && !line_mode) {
+		char *remap =
+			remap_node_name(node_name_map, node->guid, node->nodedesc);
+		printf("%sSwitch 0x%016" PRIx64 " %s:\n",
+		       out_prefix ? out_prefix : "",
+		       node->guid, remap);
+		(*out_header_flag)++;
+		free(remap);
+	}
+}
+
 void print_switch(ibnd_node_t * node, void *user_data)
 {
 	int i = 0;
 	int head_print = 0;
-	char *remap =
-	    remap_node_name(node_name_map, node->guid, node->nodedesc);
+	char *out_prefix = (char *)user_data;
 
 	for (i = 1; i <= node->numports; i++) {
 		ibnd_port_t *port = node->ports[i];
@@ -227,15 +248,153 @@ void print_switch(ibnd_node_t * node, void *user_data)
 		if (!down_links_only ||
 		    mad_get_field(port->info, 0,
 				  IB_PORT_STATE_F) == IB_LINK_DOWN) {
-			if (!head_print && !line_mode) {
-				printf("Switch 0x%016" PRIx64 " %s:\n",
-				       node->guid, remap);
-				head_print = 1;
-			}
-			print_port(node, port);
+			print_switch_header(node, &head_print, out_prefix);
+			print_port(node, port, out_prefix);
+		}
+	}
+}
+
+struct iter_diff_data {
+        uint32_t diff_flags;
+        ibnd_fabric_t *fabric1;
+        ibnd_fabric_t *fabric2;
+        char *fabric1_prefix;
+        char *fabric2_prefix;
+};
+
+void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
+		       int *head_print, struct iter_diff_data *data)
+{
+	int i = 0;
+
+	for (i = 1; i <= fabric1_node->numports; i++) {
+		ibnd_port_t *fabric1_port, *fabric2_port;
+		int output_diff = 0;
+
+		fabric1_port = fabric1_node->ports[i];
+		fabric2_port = fabric2_node->ports[i];
+
+		if (!fabric1_port && !fabric2_port)
+			continue;
+
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION) {
+			if ((fabric1_port && !fabric2_port)
+			    || (!fabric1_port && fabric2_port)
+			    || (fabric1_port->remoteport
+				&& !fabric2_port->remoteport)
+			    || (!fabric1_port->remoteport
+				&& fabric2_port->remoteport)
+			    || (fabric1_port->remoteport
+				&& fabric2_port->remoteport
+				&& fabric1_port->remoteport->guid !=
+				fabric2_port->remoteport->guid))
+				output_diff++;
+		}
+
+		/* if either fabric1_port or fabric2_port NULL, should be
+		 * handled by port connection diff code
+		 */
+		if (data->diff_flags & DIFF_FLAG_PORT_STATE
+		    && fabric1_port
+		    && fabric2_port) {
+			int state1, state2;
+
+			state1 = mad_get_field(fabric1_port->info, 0,
+					       IB_PORT_STATE_F);
+			state2 = mad_get_field(fabric2_port->info, 0,
+					       IB_PORT_STATE_F);
+
+			if (state1 != state2)
+				output_diff++;
+		}
+
+		if (output_diff && fabric1_port) {
+			print_switch_header(fabric1_node,
+					    &head_print,
+					    NULL);
+			print_port(fabric1_node,
+				   fabric1_port,
+				   data->fabric1_prefix);
+		}
+
+		if (output_diff && fabric2_port) {
+			print_switch_header(fabric1_node,
+					    &head_print,
+					    NULL);
+			print_port(fabric2_node,
+				   fabric2_port,
+				   data->fabric2_prefix);
 		}
 	}
-	free(remap);
+}
+
+void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
+{
+	struct iter_diff_data *data = iter_user_data;
+	ibnd_node_t *fabric2_node;
+	int head_print = 0;
+
+	DEBUG("DEBUG: fabric1_node %p\n", fabric1_node);
+
+	fabric2_node = ibnd_find_node_guid(data->fabric2, fabric1_node->guid);
+	if (!fabric2_node)
+		print_switch(fabric1_node, data->fabric1_prefix);
+	else if (data->diff_flags &
+		 (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE)) {
+
+		if (fabric1_node->numports != fabric2_node->numports) {
+			print_switch_header(fabric1_node,
+					    &head_print,
+					    NULL);
+			printf("%snumports = %d\n", data->fabric1_prefix,
+			       fabric1_node->numports);
+			printf("%snumports = %d\n", data->fabric2_prefix,
+			       fabric2_node->numports);
+			return;
+		}
+
+		diff_switch_ports(fabric1_node, fabric2_node,
+				  &head_print, data);
+	}
+}
+
+int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
+		ibnd_fabric_t * new_fabric)
+{
+	struct iter_diff_data iter_diff_data;
+
+	iter_diff_data.diff_flags = diffcheck_flags;
+	iter_diff_data.fabric1 = orig_fabric;
+	iter_diff_data.fabric2 = new_fabric;
+	iter_diff_data.fabric1_prefix = "< ";
+	iter_diff_data.fabric2_prefix = "> ";
+	if (node)
+		diff_switch_iter(node, &iter_diff_data);
+	else
+		ibnd_iter_nodes_type(orig_fabric, diff_switch_iter,
+				     IB_NODE_SWITCH, &iter_diff_data);
+
+	/* Do opposite diff to find existence of node types
+	 * in new_fabric but not in orig_fabric.
+	 *
+	 * In this diff, we don't need to check port connections
+	 * or port state since it has already been done (i.e.
+	 * checks are only done when guid exists on both
+	 * orig and new).
+	 */
+	iter_diff_data.diff_flags = diffcheck_flags & ~DIFF_FLAG_PORT_CONNECTION;
+	iter_diff_data.diff_flags &= ~DIFF_FLAG_PORT_STATE;
+	iter_diff_data.fabric1 = new_fabric;
+	iter_diff_data.fabric2 = orig_fabric;
+	iter_diff_data.fabric1_prefix = "> ";
+	iter_diff_data.fabric2_prefix = "< ";
+	if (node)
+		diff_switch_iter(node, &iter_diff_data);
+	else
+		ibnd_iter_nodes_type(new_fabric, diff_switch_iter,
+				     IB_NODE_SWITCH, &iter_diff_data);
+
+	return 0;
 }
 
 static int process_opt(void *context, int ch, char *optarg)
@@ -248,6 +407,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 2:
 		load_cache_file = strdup(optarg);
 		break;
+	case 3:
+		diff_cache_file = strdup(optarg);
+		break;
 	case 'S':
 		guid_str = optarg;
 		guid = (uint64_t) strtoull(guid_str, 0, 0);
@@ -291,6 +453,7 @@ int main(int argc, char **argv)
 	int rc = 0;
 	int resolved = -1;
 	ibnd_fabric_t *fabric = NULL;
+	ibnd_fabric_t *diff_fabric = NULL;
 	struct ibmad_port *ibmad_port;
 	ib_portid_t port_id = { 0 };
 	int mgmt_classes[3] =
@@ -315,6 +478,8 @@ int main(int argc, char **argv)
 		 "print port guids instead of node guids"},
 		{"load-cache", 2, 1, "<file>",
 		 "filename of ibnetdiscover cache to load"},
+		{"diff", 3, 1, "<file>",
+		 "filename of ibnetdiscover cache to diff"},
 		{"outstanding_smps", 'o', 1, NULL,
 		 "specify the number of outstanding SMP's which should be "
 		 "issued during the scan"},
@@ -365,6 +530,10 @@ int main(int argc, char **argv)
 			       guid_str);
 	}
 
+	if (diff_cache_file &&
+	    !(diff_fabric = ibnd_load_fabric(diff_cache_file, 0)))
+		IBERROR("loading cached fabric for diff failed\n");
+
 	if (load_cache_file) {
 		if ((fabric = ibnd_load_fabric(load_cache_file, 0)) == NULL) {
 			fprintf(stderr, "loading cached fabric failed\n");
@@ -387,8 +556,12 @@ int main(int argc, char **argv)
 
 	if (!all && guid_str) {
 		ibnd_node_t *sw = ibnd_find_node_guid(fabric, guid);
-		if (sw)
-			print_switch(sw, NULL);
+		if (sw) {
+			if (diff_fabric)
+				diff_switch(sw, diff_fabric, fabric);
+			else
+				print_switch(sw, NULL);
+		}
 		else
 			fprintf(stderr, "Failed to find switch: %s\n",
 				guid_str);
@@ -402,15 +575,25 @@ int main(int argc, char **argv)
 		mad_decode_field(ni, IB_NODE_GUID_F, &(guid));
 
 		sw = ibnd_find_node_guid(fabric, guid);
-		if (sw)
-			print_switch(sw, NULL);
+		if (sw) {
+			if (diff_fabric)
+				diff_switch(sw, diff_fabric, fabric);
+			else
+				print_switch(sw, NULL);
+		}
 		else
 			fprintf(stderr, "Failed to find switch: %s\n", dr_path);
-	} else
-		ibnd_iter_nodes_type(fabric, print_switch, IB_NODE_SWITCH,
-				     NULL);
+	} else {
+		if (diff_fabric)
+			diff_switch(NULL, diff_fabric, fabric);
+		else
+			ibnd_iter_nodes_type(fabric, print_switch,
+					     IB_NODE_SWITCH, NULL);
+	}
 
 	ibnd_destroy_fabric(fabric);
+	if (diff_fabric)
+		ibnd_destroy_fabric(diff_fabric);
 
 close_port:
 	close_node_name_map(node_name_map);
-- 
1.5.4.5


--=-n/RQ9hPY+XA4I1bTuBAp--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
