From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/6] ibacm: Use daemon() instead of open coding
Date: Mon, 31 Jul 2017 14:25:42 -0600
Message-ID: <1501532745-28378-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501532745-28378-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501532745-28378-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The version in glibc does the same things.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/src/acm.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 648ee400f795fb..e5cfdcb8726a8f 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -28,6 +28,8 @@
  * SOFTWARE.
  */
 
+#define _GNU_SOURCE
+
 #include <config.h>
 
 #include <stdio.h>
@@ -2933,29 +2935,6 @@ static int acm_open_lock_file(void)
 	return 0;
 }
 
-static void daemonize(void)
-{
-	pid_t pid, sid;
-
-	pid = fork();
-	if (pid)
-		exit(pid < 0);
-
-	sid = setsid();
-	if (sid < 0)
-		exit(1);
-
-	if (chdir("/"))
-		exit(1);
-
-	if(!freopen("/dev/null", "r", stdin))
-		exit(1);
-	if(!freopen("/dev/null", "w", stdout))
-		exit(1);
-	if(!freopen("/dev/null", "w", stderr))
-		exit(1);
-}
-
 static void show_usage(char *program)
 {
 	printf("usage: %s\n", program);
@@ -2969,7 +2948,7 @@ static void show_usage(char *program)
 
 int main(int argc, char **argv)
 {
-	int i, op, daemon = 1;
+	int i, op, as_daemon = 1;
 
 	while ((op = getopt(argc, argv, "DPA:O:")) != -1) {
 		switch (op) {
@@ -2977,7 +2956,7 @@ int main(int argc, char **argv)
 			/* option no longer required */
 			break;
 		case 'P':
-			daemon = 0;
+			as_daemon = 0;
 			break;
 		case 'A':
 			addr_file = optarg;
@@ -2991,8 +2970,10 @@ int main(int argc, char **argv)
 		}
 	}
 
-	if (daemon)
-		daemonize();
+	if (as_daemon) {
+		if (daemon(0, 0))
+			return EXIT_FAILURE;
+	}
 
 	acm_set_options();
 	if (acm_open_lock_file())
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
