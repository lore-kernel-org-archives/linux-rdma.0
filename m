From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] ibacm: daemonize ib_acm service
Date: Thu, 29 Jul 2010 11:02:49 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9272612@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow ib_acm to run as a daemon.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 7cd60a4..8b09453 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -32,6 +32,7 @@
 #include <string.h>
 #include <osd.h>
 #include <arpa/inet.h>
+#include <sys/stat.h>
 #include <infiniband/acm.h>
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
@@ -2611,11 +2612,53 @@ static FILE *acm_open_log(void)
 	return f;
 }
 
+static void daemonize(void)
+{
+	pid_t pid, sid;
+
+	pid = fork();
+	if (pid)
+		exit(pid < 0);
+
+	umask(0);
+
+	sid = setsid();
+	if (sid < 0)
+		exit(1);
+
+	if (chdir("/"))
+		exit(1);
+
+	freopen("/dev/null", "r", stdin);
+	freopen("/dev/null", "w", stdout);
+	freopen("/dev/null", "w", stderr);
+}
+
+static void show_usage(char *program)
+{
+	printf("usage: %s\n", program);
+	printf("   [-D] - run as a daemon\n");
+}
+
 int CDECL_FUNC main(int argc, char **argv)
 {
 	struct ibv_device **ibdev;
 	int dev_cnt;
-	int i;
+	int op, i, daemon = 0;
+
+	while ((op = getopt(argc, argv, "D")) != -1) {
+		switch (op) {
+		case 'D':
+			daemon = 1;
+			break;
+		default:
+			show_usage(argv[0]);
+			exit(1);
+		}
+	}
+
+	if (daemon)
+		daemonize();
 
 	if (osd_init())
 		return -1;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
