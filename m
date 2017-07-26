From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/8] iwpm: Use daemon() instead of open coding a version
Date: Wed, 26 Jul 2017 13:59:10 -0600
Message-ID: <1501099152-6344-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes a bug in the open coded version, stdin/err/out should never
be left as a closed file descriptor as libraries are hardwired to use
those FDs in emergencies.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/iwarp_pm_server.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index a0a877b91b0c60..ec5721020e224c 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -1358,39 +1358,14 @@ iwarp_port_mapper_exit:
  */ 
 static void daemonize_iwpm_server(void)
 {
-	pid_t pid, sid;
-
-	/* check if already a daemon */
-	if (getppid() == 1) return;
-
-    	pid = fork();
-    	if (pid < 0) {
-		syslog(LOG_WARNING, "daemonize_iwpm_server: Couldn't fork a new process\n");
-        	exit(EXIT_FAILURE);
-    	}
-
-    	/* exit the parent process */
-	if (pid > 0)
-        	exit(EXIT_SUCCESS);
-
+	if (daemon(0, 0) != 0) {
+		syslog(LOG_ERR, "Failed to daemonize\n");
+		exit(EXIT_FAILURE);
+	}
 	umask(0); /* change file mode mask */
-	sid = setsid();	/* create a new session, new group, no tty */
-	if (sid < 0) {
-    		syslog(LOG_WARNING, "daemonize_iwpm_server: Couldn't create new session\n");
-        	exit(EXIT_FAILURE);
-    	}
-
-    	if ((chdir("/")) < 0) {
-		syslog(LOG_WARNING, "daemonize_iwpm_server: Couldn't change the current directory\n");
-        	exit(EXIT_FAILURE);
-   	}
 
 	syslog(LOG_WARNING, "daemonize_iwpm_server: Starting iWarp Port Mapper V%d process\n",
 				iwpm_version);
-	/* close standard IO streams */
-	close(STDIN_FILENO);
-	close(STDOUT_FILENO);
-	close(STDERR_FILENO);
 }
 
 int main(int argc, char *argv[])
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
