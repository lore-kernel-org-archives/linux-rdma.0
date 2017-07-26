From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/8] Consistently open syslog in daemons
Date: Wed, 26 Jul 2017 13:59:08 -0600
Message-ID: <1501099152-6344-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These days we can use the POSIX 2008 format to automatically
set the program name. We always want fallback to console if syslog
is broken, and if we are calling openlog should take effect
immediately.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/iwarp_pm_server.c | 2 +-
 rdma-ndd/rdma-ndd.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index 53f61b2876b9b5..a0a877b91b0c60 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -1400,7 +1400,7 @@ int main(int argc, char *argv[])
 	FILE *fp;
 	int ret = EXIT_FAILURE;
 
-	openlog("iWarpPortMapper", LOG_CONS | LOG_PID, LOG_DAEMON);
+	openlog(NULL, LOG_NDELAY | LOG_CONS | LOG_PID, LOG_DAEMON);
 
 	daemonize_iwpm_server();
 
diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c
index e7be22b12ad6a1..3e99d2dc5332dc 100644
--- a/rdma-ndd/rdma-ndd.c
+++ b/rdma-ndd/rdma-ndd.c
@@ -286,7 +286,7 @@ int main(int argc, char *argv[])
 {
 	bool foreground = false;
 
-	openlog("rdma-ndd", LOG_PID, LOG_DAEMON);
+	openlog(NULL, LOG_NDELAY | LOG_CONS | LOG_PID, LOG_DAEMON);
 
 	while (1) {
 		int opt_idx = 0;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
