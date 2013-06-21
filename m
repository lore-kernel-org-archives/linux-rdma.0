From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 07/15 ibacm] More cosmetic changes for consistency between
 acme and config files
Date: Fri, 21 Jun 2013 07:01:50 -0400
Message-ID: <51C4329E.2070002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm_addr.cfg |    2 +-
 ibacm_opts.cfg |    2 +-
 src/acme.c     |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/ibacm_addr.cfg b/ibacm_addr.cfg
index c8f7f68..584419c 100644
--- a/ibacm_addr.cfg
+++ b/ibacm_addr.cfg
@@ -1,6 +1,6 @@
 # InfiniBand Communication Management Assistant for clusters address file
 #
-# Use ib_acme utility with -G option to automatically generate a sample
+# Use ib_acme utility with -A option to automatically generate a sample
 # ibacm_addr.cfg file for the current system.
 #
 # Entry format is:
diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
index 6f260da..87f31d9 100644
--- a/ibacm_opts.cfg
+++ b/ibacm_opts.cfg
@@ -1,4 +1,4 @@
-# InfiniBand Multicast Communication Manager for clusters configuration file
+# InfiniBand Communication Management Assistant for clusters configuration file
 #
 # Use ib_acme utility with -O option to automatically generate a sample
 # ibacm_opts.cfg file for the current system.
diff --git a/src/acme.c b/src/acme.c
index 81d9e3a..d7ad25f 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -97,7 +97,7 @@ static void show_usage(char *program)
 
 static void gen_opts_temp(FILE *f)
 {
-	fprintf(f, "# InfiniBand Multicast Communication Manager for clusters configuration file\n");
+	fprintf(f, "# InfiniBand Communication Management Assistant for clusters configuration file\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# Use ib_acme utility with -O option to automatically generate a sample\n");
 	fprintf(f, "# ibacm_opts.cfg file for the current system.\n");
@@ -275,7 +275,7 @@ static void gen_addr_temp(FILE *f)
 {
 	fprintf(f, "# InfiniBand Communication Management Assistant for clusters address file\n");
 	fprintf(f, "#\n");
-	fprintf(f, "# Use ib_acme utility with -G option to automatically generate a sample\n");
+	fprintf(f, "# Use ib_acme utility with -A option to automatically generate a sample\n");
 	fprintf(f, "# ibacm_addr.cfg file for the current system.\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# Entry format is:\n");
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
