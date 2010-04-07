From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [2/3] support --diffcheck in ibnetdiscover
Date: Wed, 07 Apr 2010 10:06:32 -0700
Message-ID: <1270659992.26381.40.camel@crazyclimber.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-v6BifIsGrF+9NJI4qOVK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-v6BifIsGrF+9NJI4qOVK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This patch adds basic --diffcheck support in ibnetdiscover, allowing
configuration of the diff checks done in the default --diff option.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-v6BifIsGrF+9NJI4qOVK
Content-Disposition: attachment; filename=0002-support-diffcheck-in-ibnetdiscover.patch
Content-Type: message/rfc822; name=0002-support-diffcheck-in-ibnetdiscover.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 31 Mar 2010 11:13:37 -0700
Subject: [PATCH] support --diffcheck in ibnetdiscover
Message-Id: <1270659341.26381.29.camel-RLKWKRZIcZkVVsCFsIUZTRy+HRzXvqW9@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibnetdiscover.8 |    8 +++++
 infiniband-diags/src/ibnetdiscover.c |   50 +++++++++++++++++++++++++---------
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/infiniband-diags/man/ibnetdiscover.8 b/infiniband-diags/man/ibnetdiscover.8
index 975b999..e122736 100644
--- a/infiniband-diags/man/ibnetdiscover.8
+++ b/infiniband-diags/man/ibnetdiscover.8
@@ -64,6 +64,14 @@ output will be displayed showing differences between the old and current
 fabric.  By default, the following are compared for differences: switches,
 channel adapters, routers, and port connections.
 .TP
+\fB\-\-diffcheck\fR <key(s)>
+Specify what diff checks should be done in the \fB\-\-diff\fR option above.
+Comma separate multiple diff check key(s).  The available diff checks
+are: \fIsw\fR = switches, \fIca\fR = channel adapters, \fIrouter\fR = routers,
+\fIport\fR = port connections descriptions.  Note that \fIport\fR is
+checked only for the node types that are specified (e.g. \fIsw\fR,
+\fIca\fR, \fIrouter\fR).
+.TP
 \fB\-p\fR, \fB\-\-ports\fR
 Obtain a ports report which is a
 list of connected ports with relevant information (like LID, portnum,
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 4da09ce..4435ade 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -57,10 +57,10 @@
 #define LIST_SWITCH_NODE (1 << IB_NODE_SWITCH)
 #define LIST_ROUTER_NODE (1 << IB_NODE_ROUTER)
 
-#define DIFF_FLAG_SWITCH          0x00000001
-#define DIFF_FLAG_CA              0x00000002
-#define DIFF_FLAG_ROUTER          0x00000004
-#define DIFF_FLAG_PORT_CONNECTION 0x00000008
+#define DIFF_FLAG_SWITCH           0x00000001
+#define DIFF_FLAG_CA               0x00000002
+#define DIFF_FLAG_ROUTER           0x00000004
+#define DIFF_FLAG_PORT_CONNECTION  0x00000008
 
 #define DIFF_FLAG_DEFAULT      (DIFF_FLAG_SWITCH \
 				| DIFF_FLAG_CA \
@@ -76,6 +76,7 @@ static nn_map_t *node_name_map = NULL;
 static char *cache_file = NULL;
 static char *load_cache_file = NULL;
 static char *diff_cache_file = NULL;
+static uint32_t diffcheck_flags = DIFF_FLAG_DEFAULT;
 
 static int report_max_hops = 0;
 
@@ -735,7 +736,9 @@ static int diff_common(ibnd_fabric_t * orig_fabric,
 	 * in new_fabric but not in orig_fabric.
 	 *
 	 * In this diff, we don't need to check port connections,
-	 * since it has already been done before.
+	 * lids, or node descriptions since it has already been
+         * done (i.e. checks are only done when guid exists on both
+	 * orig and new).
 	 */
 	iter_diff_data.diff_flags = diff_flags & ~DIFF_FLAG_PORT_CONNECTION;
 	iter_diff_data.fabric1 = new_fabric;
@@ -752,29 +755,27 @@ static int diff_common(ibnd_fabric_t * orig_fabric,
 
 int diff(ibnd_fabric_t * orig_fabric, ibnd_fabric_t * new_fabric)
 {
-	uint32_t diff_flags = DIFF_FLAG_DEFAULT;
-
-	if (diff_flags & DIFF_FLAG_SWITCH)
+	if (diffcheck_flags & DIFF_FLAG_SWITCH)
 		diff_common(orig_fabric,
 			    new_fabric,
 			    IB_NODE_SWITCH,
-			    diff_flags,
+			    diffcheck_flags,
 			    out_switch,
 			    out_switch_port);
 
-	if (diff_flags & DIFF_FLAG_CA)
+	if (diffcheck_flags & DIFF_FLAG_CA)
 		diff_common(orig_fabric,
 			    new_fabric,
 			    IB_NODE_CA,
-			    diff_flags,
+			    diffcheck_flags,
 			    out_ca,
 			    out_ca_port);
 
-	if (diff_flags & DIFF_FLAG_ROUTER)
+	if (diffcheck_flags & DIFF_FLAG_ROUTER)
 		diff_common(orig_fabric,
 			    new_fabric,
 			    IB_NODE_ROUTER,
-			    diff_flags,
+			    diffcheck_flags,
 			    out_ca,
 			    out_ca_port);
 
@@ -786,6 +787,8 @@ static int list, group, ports_report;
 
 static int process_opt(void *context, int ch, char *optarg)
 {
+	char *p;
+
 	switch (ch) {
 	case 1:
 		node_name_map_file = strdup(optarg);
@@ -799,6 +802,25 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 4:
 		diff_cache_file = strdup(optarg);
 		break;
+	case 5:
+		diffcheck_flags = 0;
+		p = strtok(optarg, ",");
+		while (p) {
+			if (!strcasecmp(p, "sw"))
+				diffcheck_flags |= DIFF_FLAG_SWITCH;
+			else if (!strcasecmp(p, "ca"))
+				diffcheck_flags |= DIFF_FLAG_CA;
+			else if (!strcasecmp(p, "router"))
+				diffcheck_flags |= DIFF_FLAG_ROUTER;
+			else if (!strcasecmp(p, "port"))
+				diffcheck_flags |= DIFF_FLAG_PORT_CONNECTION;
+			else {
+				fprintf(stderr, "invalid diff check key: %s\n", p);
+				return -1;
+			}
+			p = strtok(NULL, ",");
+		}
+		break;
 	case 's':
 		ibnd_show_progress(1);
 		break;
@@ -852,6 +874,8 @@ int main(int argc, char **argv)
 		 "filename of ibnetdiscover cache to load"},
 		{"diff", 4, 1, "<file>",
 		 "filename of ibnetdiscover cache to diff"},
+		{"diffcheck", 5, 1, "<key(s)>",
+		 "specify checks to execute for --diff"},
 		{"ports", 'p', 0, NULL, "obtain a ports report"},
 		{"max_hops", 'm', 0, NULL,
 		 "report max hops discovered by the library"},
-- 
1.5.4.5


--=-v6BifIsGrF+9NJI4qOVK--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
