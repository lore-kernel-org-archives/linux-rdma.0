From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [3/4] Add lid and node description diff options
	for --diffcheck in iblinkinfo [REPOST]
Date: Wed, 14 Jul 2010 09:29:58 -0700
Message-ID: <1279124998.20914.215.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-hd+NSjrBzb0peWhaqoPR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-hd+NSjrBzb0peWhaqoPR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This patch supports additional lid and node description diffing options
in iblinkinfo.  This is similar to the lid and nodescription --diffcheck
options in ibnetdiscover.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-hd+NSjrBzb0peWhaqoPR
Content-Disposition: attachment; filename=0003-Add-lid-and-node-description-diff-options-for-diff.patch
Content-Type: message/rfc822; name=0003-Add-lid-and-node-description-diff-options-for-diff.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 20 Apr 2010 10:13:05 -0700
Subject: [PATCH] Add lid and node description diff options for --diffcheck
	in iblinkinfo
Message-Id: <1279124743.20914.212.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8 |    7 +++-
 infiniband-diags/src/iblinkinfo.c |   53 ++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index 431ab0e..65ea919 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -55,14 +55,17 @@ for information on caching ibnetdiscover output.
 Load cached ibnetdiscover data and do a diff comparison to the current
 network or another cache.  A special diff output for iblinkinfo
 output will be displayed showing differences between the old and current
-fabric links.  See
+fabric links.  Be default, the following are compared for differences:
+port connections and port state.  See
 .B ibnetdiscover
 for information on caching ibnetdiscover output.
 .TP
 \fB\-\-diffcheck\fR <key(s)>
 Specify what diff checks should be done in the \fB\-\-diff\fR option above.
 Comma separate multiple diff check key(s).  The available diff checks
-are:\fIport\fR = port connections, \fIstate\fR = port state.
+are:\fIport\fR = port connections, \fIstate\fR = port state, \fIlid\fR = lids,
+\fInodedesc\fR = node descriptions.  If \fIport\fR is specified alongside \fIlid\fR
+or \fInodedesc\fR, remote port lids and node descriptions will also be compared.
 
 .SH AUTHOR
 .TP
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index b9c1c32..ae7bbf3 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -55,6 +55,8 @@
 
 #define DIFF_FLAG_PORT_CONNECTION  0x01
 #define DIFF_FLAG_PORT_STATE       0x02
+#define DIFF_FLAG_LID              0x04
+#define DIFF_FLAG_NODE_DESCRIPTION 0x08
 
 #define DIFF_FLAG_DEFAULT (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE)
 
@@ -224,7 +226,7 @@ void print_port(ibnd_node_t * node, ibnd_port_t * port, char *out_prefix)
 
 void print_switch_header(ibnd_node_t *node, int *out_header_flag, char *out_prefix)
 {
-	if (!(*out_header_flag) && !line_mode) {
+	if ((!out_header_flag || !(*out_header_flag)) && !line_mode) {
 		char *remap =
 			remap_node_name(node_name_map, node->guid, node->nodedesc);
 		printf("%sSwitch 0x%016" PRIx64 " %s:\n",
@@ -308,9 +310,25 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 				output_diff++;
 		}
 
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		    && data->diff_flags & DIFF_FLAG_LID
+		    && fabric1_port && fabric2_port
+		    && fabric1_port->remoteport && fabric2_port->remoteport
+		    && fabric1_port->remoteport->base_lid != fabric2_port->remoteport->base_lid)
+			output_diff++;
+
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		    && data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
+		    && fabric1_port && fabric2_port
+		    && fabric1_port->remoteport && fabric2_port->remoteport
+		    && memcmp(fabric1_port->remoteport->node->nodedesc,
+			      fabric2_port->remoteport->node->nodedesc,
+			      IB_SMP_DATA_SIZE))
+			output_diff++;
+
 		if (output_diff && fabric1_port) {
 			print_switch_header(fabric1_node,
-					    &head_print,
+					    head_print,
 					    NULL);
 			print_port(fabric1_node,
 				   fabric1_port,
@@ -319,7 +337,7 @@ void diff_switch_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
 
 		if (output_diff && fabric2_port) {
 			print_switch_header(fabric1_node,
-					    &head_print,
+					    head_print,
 					    NULL);
 			print_port(fabric2_node,
 				   fabric2_port,
@@ -340,7 +358,22 @@ void diff_switch_iter(ibnd_node_t * fabric1_node, void *iter_user_data)
 	if (!fabric2_node)
 		print_switch(fabric1_node, data->fabric1_prefix);
 	else if (data->diff_flags &
-		 (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE)) {
+		 (DIFF_FLAG_PORT_CONNECTION | DIFF_FLAG_PORT_STATE
+		  | DIFF_FLAG_LID | DIFF_FLAG_NODE_DESCRIPTION)) {
+
+		if ((data->diff_flags & DIFF_FLAG_LID
+		     && fabric1_node->smalid != fabric2_node->smalid) ||
+		    (data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
+		     && memcmp(fabric1_node->nodedesc, fabric2_node->nodedesc,
+			       IB_SMP_DATA_SIZE))) {
+			print_switch_header(fabric1_node,
+					    NULL,
+					    data->fabric1_prefix);
+			print_switch_header(fabric2_node,
+					    NULL,
+					    data->fabric2_prefix);
+			head_print++;
+		}
 
 		if (fabric1_node->numports != fabric2_node->numports) {
 			print_switch_header(fabric1_node,
@@ -377,13 +410,15 @@ int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	/* Do opposite diff to find existence of node types
 	 * in new_fabric but not in orig_fabric.
 	 *
-	 * In this diff, we don't need to check port connections
-	 * or port state since it has already been done (i.e.
-	 * checks are only done when guid exists on both
+	 * In this diff, we don't need to check port connections,
+	 * port state, lids, or node descriptions since it has already
+	 * been done (i.e. checks are only done when guid exists on both
 	 * orig and new).
 	 */
 	iter_diff_data.diff_flags = diffcheck_flags & ~DIFF_FLAG_PORT_CONNECTION;
 	iter_diff_data.diff_flags &= ~DIFF_FLAG_PORT_STATE;
+	iter_diff_data.diff_flags &= ~DIFF_FLAG_LID;
+	iter_diff_data.diff_flags &= ~DIFF_FLAG_NODE_DESCRIPTION;
 	iter_diff_data.fabric1 = new_fabric;
 	iter_diff_data.fabric2 = orig_fabric;
 	iter_diff_data.fabric1_prefix = "> ";
@@ -420,6 +455,10 @@ static int process_opt(void *context, int ch, char *optarg)
 				diffcheck_flags |= DIFF_FLAG_PORT_CONNECTION;
 			else if (!strcasecmp(p, "state"))
 				diffcheck_flags |= DIFF_FLAG_PORT_STATE;
+			else if (!strcasecmp(p, "lid"))
+				diffcheck_flags |= DIFF_FLAG_LID;
+			else if (!strcasecmp(p, "nodedesc"))
+				diffcheck_flags |= DIFF_FLAG_NODE_DESCRIPTION;
 			else {
 				fprintf(stderr, "invalid diff check key: %s\n",
 					p);
-- 
1.5.4.5


--=-hd+NSjrBzb0peWhaqoPR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
