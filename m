From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/4] srp_daemon: Use pipe2 instead of pip&fcntl
Date: Tue, 29 Aug 2017 09:58:43 -0600
Message-ID: <1504022325-31039-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504022325-31039-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504022325-31039-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just make a nonblocking pipe directly.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 94d52673dc0fb6..2465ccd9e74f07 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1998,25 +1998,12 @@ static int setup_wakeup_fd(void)
 {
 	struct sigaction sa = {};
 	int ret;
-	int i;
-	int flags;
 
-	ret = pipe(wakeup_pipe);
+	ret = pipe2(wakeup_pipe, O_NONBLOCK | O_CLOEXEC);
 	if (ret < 0) {
 		pr_err("could not create pipe\n");
 		return -1;
 	}
-	for (i = 0; i < 2; i++) {
-		flags = fcntl(wakeup_pipe[i], F_GETFL);
-		if (flags < 0) {
-			pr_err("fcntl F_GETFL failed for %d\n", wakeup_pipe[i]);
-			goto close_pipe;
-		}
-		if (fcntl(wakeup_pipe[i], F_SETFL, flags | O_NONBLOCK) < 0) {
-			pr_err("fcntl F_SETFL failed for %d\n", wakeup_pipe[i]);
-			goto close_pipe;
-		}
-	}
 
 	sigemptyset(&sa.sa_mask);
 	sa.sa_handler = signal_handler;
@@ -2024,10 +2011,6 @@ static int setup_wakeup_fd(void)
 	sigaction(SIGTERM, &sa, NULL);
 	sigaction(SRP_CATAS_ERR, &sa, NULL);
 	return 0;
-
-close_pipe:
-	cleanup_wakeup_fd();
-	return -1;
 }
 
 static int ibsrpdm(int argc, char *argv[])
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
