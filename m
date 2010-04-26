From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [2/4] support --diffcheck in iblinkinfo
Date: Mon, 26 Apr 2010 14:39:40 -0700
Message-ID: <1272317980.29737.48.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Gx1YXGLLVF/IZG8RrQxK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Gx1YXGLLVF/IZG8RrQxK
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

Similar to ibnetdiscover, this patch support a --diffcheck option in
iblinkinfo.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-Gx1YXGLLVF/IZG8RrQxK
Content-Disposition: attachment; filename=0002-support-diffcheck-in-iblinkinfo.patch
Content-Type: message/rfc822; name=0002-support-diffcheck-in-iblinkinfo.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 20 Apr 2010 09:53:53 -0700
Subject: [PATCH] support --diffcheck in iblinkinfo
Message-Id: <1272317488.29737.31.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8 |    5 +++++
 infiniband-diags/src/iblinkinfo.c |   20 ++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index b91afbd..431ab0e 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -58,6 +58,11 @@ output will be displayed showing differences between the old and current
 fabric links.  See
 .B ibnetdiscover
 for information on caching ibnetdiscover output.
+.TP
+\fB\-\-diffcheck\fR <key(s)>
+Specify what diff checks should be done in the \fB\-\-diff\fR option above.
+Comma separate multiple diff check key(s).  The available diff checks
+are:\fIport\fR = port connections, \fIstate\fR = port state.
 
 .SH AUTHOR
 .TP
diff --git a/infiniband-diags/src/iblinkinfo.c b/infiniband-diags/src/iblinkinfo.c
index c6092f9..a4a8e49 100644
--- a/infiniband-diags/src/iblinkinfo.c
+++ b/infiniband-diags/src/iblinkinfo.c
@@ -400,6 +400,8 @@ int diff_switch(ibnd_node_t * node, ibnd_fabric_t * orig_fabric,
 static int process_opt(void *context, int ch, char *optarg)
 {
 	struct ibnd_config *cfg = context;
+	char *p;
+
 	switch (ch) {
 	case 1:
 		node_name_map_file = strdup(optarg);
@@ -410,6 +412,22 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 3:
 		diff_cache_file = strdup(optarg);
 		break;
+	case 4:
+		diffcheck_flags = 0;
+		p = strtok(optarg, ",");
+		while (p) {
+			if (!strcasecmp(p, "port"))
+				diffcheck_flags |= DIFF_FLAG_PORT_CONNECTION;
+			else if (!strcasecmp(p, "state"))
+				diffcheck_flags |= DIFF_FLAG_PORT_STATE;
+			else {
+				fprintf(stderr, "invalid diff check key: %s\n",
+					p);
+				return -1;
+			}
+			p = strtok(NULL, ",");
+		}
+		break;
 	case 'S':
 		guid_str = optarg;
 		guid = (uint64_t) strtoull(guid_str, 0, 0);
@@ -480,6 +498,8 @@ int main(int argc, char **argv)
 		 "filename of ibnetdiscover cache to load"},
 		{"diff", 3, 1, "<file>",
 		 "filename of ibnetdiscover cache to diff"},
+		{"diffcheck", 4, 1, "<key(s)>",
+		 "specify checks to execute for --diff"},
 		{"outstanding_smps", 'o', 1, NULL,
 		 "specify the number of outstanding SMP's which should be "
 		 "issued during the scan"},
-- 
1.5.4.5


--=-Gx1YXGLLVF/IZG8RrQxK--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
