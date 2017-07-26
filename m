From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/8] srp_daemon: Move the setup of the wakeup_pipe after openlog
Date: Wed, 26 Jul 2017 13:59:05 -0600
Message-ID: <1501099152-6344-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pipe setup failure triggers logging calls which shouldn't happen until
logging has been setup. Instead move this setup to after each of the
two configuration steps.

Bart says that wakeup_pipe[] is not used by ibsrpdm, so this also
drops the pipe setup and signal change from that code path.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 98 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 60 insertions(+), 38 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index c0e8d23d58faf5..ec394b686d55ff 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1955,6 +1955,58 @@ static void ts_sub(const struct timespec *a, const struct timespec *b,
 	}
 }
 
+static void cleanup_wakeup_fd(void)
+{
+	struct sigaction sa = {};
+
+	sigemptyset(&sa.sa_mask);
+	sa.sa_handler = SIG_DFL;
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SRP_CATAS_ERR, &sa, NULL);
+
+	close(wakeup_pipe[1]);
+	close(wakeup_pipe[0]);
+	wakeup_pipe[0] = -1;
+	wakeup_pipe[1] = -1;
+}
+
+static int setup_wakeup_fd(void)
+{
+	struct sigaction sa = {};
+	int ret;
+	int i;
+	int flags;
+
+	ret = pipe(wakeup_pipe);
+	if (ret < 0) {
+		pr_err("could not create pipe\n");
+		return -1;
+	}
+	for (i = 0; i < 2; i++) {
+		flags = fcntl(wakeup_pipe[i], F_GETFL);
+		if (flags < 0) {
+			pr_err("fcntl F_GETFL failed for %d\n", wakeup_pipe[i]);
+			goto close_pipe;
+		}
+		if (fcntl(wakeup_pipe[i], F_SETFL, flags | O_NONBLOCK) < 0) {
+			pr_err("fcntl F_SETFL failed for %d\n", wakeup_pipe[i]);
+			goto close_pipe;
+		}
+	}
+
+	sigemptyset(&sa.sa_mask);
+	sa.sa_handler = signal_handler;
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SRP_CATAS_ERR, &sa, NULL);
+	return 0;
+
+close_pipe:
+	cleanup_wakeup_fd();
+	return -1;
+}
+
 static int ibsrpdm(int argc, char *argv[])
 {
 	char* umad_dev = NULL;
@@ -2032,13 +2084,12 @@ umad_done:
 
 int main(int argc, char *argv[])
 {
-	int			ret, i, flags;
+	int			ret;
 	struct resources       *res;
 	uint16_t 		lid;
 	uint16_t 		pkey;
 	union umad_gid 		gid;
 	struct target_details  *target;
-	struct sigaction	sa;
 	int			subscribed;
 	int			lockfd = -1;
 	int			received_signal = 0;
@@ -2059,35 +2110,10 @@ int main(int argc, char *argv[])
 	BUILD_ASSERT(sizeof(struct srp_dm_iou_info) == 132);
 	BUILD_ASSERT(sizeof(struct srp_dm_ioc_prof) == 128);
 
-	ret = pipe(wakeup_pipe);
-	if (ret < 0) {
-		pr_err("could not create pipe\n");
-		goto out;
-	}
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
-
-	}
-
-	memset(&sa, 0, sizeof(sa));
-	sigemptyset(&sa.sa_mask);
-	sa.sa_handler = signal_handler;
-	sigaction(SIGINT, &sa, NULL);
-	sigaction(SIGTERM, &sa, NULL);
-	sigaction(SRP_CATAS_ERR, &sa, NULL);
-
 	if (strcmp(argv[0] + max_t(int, 0, strlen(argv[0]) - strlen("ibsrpdm")),
 		   "ibsrpdm") == 0) {
 		ret = ibsrpdm(argc, argv);
-		goto restore_sig;
+		goto out;
 	}
 
 	openlog("srp_daemon", LOG_PID | LOG_PERROR, LOG_DAEMON);
@@ -2115,6 +2141,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	ret = setup_wakeup_fd();
+	if (ret)
+		goto cleanup_wakeup;
+
 catas_start:
 	subscribed = 0;
 
@@ -2279,20 +2309,12 @@ clean_umad:
 close_lockfd:
 	if (lockfd >= 0)
 		close(lockfd);
+cleanup_wakeup:
+	cleanup_wakeup_fd();
 free_config:
 	free_config(config);
 close_log:
 	closelog();
-restore_sig:
-	sa.sa_handler = SIG_DFL;
-	sigaction(SIGINT, &sa, NULL);
-	sigaction(SIGTERM, &sa, NULL);
-	sigaction(SRP_CATAS_ERR, &sa, NULL);
-close_pipe:
-	close(wakeup_pipe[1]);
-	close(wakeup_pipe[0]);
-	wakeup_pipe[0] = -1;
-	wakeup_pipe[1] = -1;
 out:
 	exit(ret ? 1 : 0);
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
