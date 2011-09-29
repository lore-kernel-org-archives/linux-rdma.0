From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [patch] support --switches-only and --cas-only
	options in iblinkinfo
Date: Thu, 29 Sep 2011 13:16:00 -0700
Message-ID: <1317327360.29218.62.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-sH+bd8sUGg0MAIm8lKAU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-sH+bd8sUGg0MAIm8lKAU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

A relatively simple patch to make the output better for different users
under different circumstances.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory


--=-sH+bd8sUGg0MAIm8lKAU
Content-Disposition: attachment; filename*0=0001-support-switches-only-and-cas-only-options-in-iblink.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-support-switches-only-and-cas-only-options-in-iblink.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 29 Sep 2011 11:02:21 -0700
Subject: [PATCH 4/4] support --switches-only and --cas-only options in
	iblinkinfo
Message-Id: <1317327332.29218.61.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 man/iblinkinfo.8 |    6 ++++++
 src/iblinkinfo.c |   47 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/man/iblinkinfo.8 b/man/iblinkinfo.8
index 50d6254..d02a363 100644
--- a/man/iblinkinfo.8
+++ b/man/iblinkinfo.8
@@ -72,6 +72,12 @@ where switches are not fully populated, thus much of the default iblinkinfo
 info is considered unuseful.  See
 .B ibnetdiscover
 for information on caching ibnetdiscover output.
+.TP
+\fB\-\-switches\-only\fR
+Show only switches in output.
+.TP
+\fB\-\-cas\-only\fR
+Show only CAs in output.
 
 .SH AUTHOR
 .TP
diff --git a/src/iblinkinfo.c b/src/iblinkinfo.c
index bbdb51d..8b9bdf6 100644
--- a/src/iblinkinfo.c
+++ b/src/iblinkinfo.c
@@ -77,6 +77,8 @@ static int all = 0;
 static int down_links_only = 0;
 static int line_mode = 0;
 static int add_sw_settings = 0;
+static int only_flag = 0;
+static int only_type = 0;
 
 
 int filterdownport_check(ibnd_node_t * node, ibnd_port_t * port)
@@ -436,8 +438,14 @@ int diff_node(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	iter_diff_data.fabric2_prefix = "> ";
 	if (node)
 		diff_node_iter(node, &iter_diff_data);
-	else
-		ibnd_iter_nodes(orig_fabric, diff_node_iter, &iter_diff_data);
+	else {
+		if (only_flag)
+			ibnd_iter_nodes_type(orig_fabric, diff_node_iter,
+					     only_type, &iter_diff_data);
+		else
+			ibnd_iter_nodes(orig_fabric, diff_node_iter,
+					&iter_diff_data);
+	}
 
 	/* Do opposite diff to find existence of node types
 	 * in new_fabric but not in orig_fabric.
@@ -457,8 +465,14 @@ int diff_node(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 	iter_diff_data.fabric2_prefix = "< ";
 	if (node)
 		diff_node_iter(node, &iter_diff_data);
-	else
-		ibnd_iter_nodes(new_fabric, diff_node_iter, &iter_diff_data);
+	else {
+		if (only_flag)
+			ibnd_iter_nodes_type(new_fabric, diff_node_iter,
+					     only_type, &iter_diff_data);
+		else
+			ibnd_iter_nodes(new_fabric, diff_node_iter,
+					&iter_diff_data);
+	}
 
 	return 0;
 }
@@ -501,6 +515,14 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 5:
 		filterdownports_cache_file = strdup(optarg);
 		break;
+	case 6:
+		only_flag = 1;
+		only_type = IB_NODE_SWITCH;
+		break;
+	case 7:
+		only_flag = 1;
+		only_type = IB_NODE_CA;
+		break;
 	case 'S':
 	case 'G':
 		guid_str = optarg;
@@ -576,6 +598,10 @@ int main(int argc, char **argv)
 		{"outstanding_smps", 'o', 1, NULL,
 		 "specify the number of outstanding SMP's which should be "
 		 "issued during the scan"},
+		{"switches-only", 6, 0, NULL,
+		 "Output only switches"},
+		{"cas-only", 7, 0, NULL,
+		 "Output only CAs"},
 		{"GNDN", 'R', 0, NULL,
 		 "(This option is obsolete and does nothing)"},
 		{0}
@@ -656,7 +682,7 @@ int main(int argc, char **argv)
 
 	if (!all && guid_str) {
 		ibnd_port_t *p = ibnd_find_port_guid(fabric, guid);
-		if (p) {
+		if (p && (!only_flag || p->node->type == only_type)) {
 			ibnd_node_t *n = p->node;
 			if (diff_fabric)
 				diff_node(n, diff_fabric, fabric);
@@ -675,7 +701,7 @@ int main(int argc, char **argv)
 		mad_decode_field(ni, IB_NODE_PORT_GUID_F, &(guid));
 
 		p = ibnd_find_port_guid(fabric, guid);
-		if (p) {
+		if (p && (!only_flag || p->node->type == only_type)) {
 			ibnd_node_t *n = p->node;
 			if (diff_fabric)
 				diff_node(n, diff_fabric, fabric);
@@ -687,8 +713,13 @@ int main(int argc, char **argv)
 	} else {
 		if (diff_fabric)
 			diff_node(NULL, diff_fabric, fabric);
-		else
-			ibnd_iter_nodes(fabric, print_node, NULL);
+		else {
+			if (only_flag)
+				ibnd_iter_nodes_type(fabric, print_node,
+						     only_type, NULL);
+			else
+				ibnd_iter_nodes(fabric, print_node, NULL);
+		}
 	}
 
 	ibnd_destroy_fabric(fabric);
-- 
1.7.1


--=-sH+bd8sUGg0MAIm8lKAU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
