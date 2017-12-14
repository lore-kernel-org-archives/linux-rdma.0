From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Thu, 14 Dec 2017 19:02:41 +0800
Message-ID: <20171214110241.4701-1-honli@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

[root@localhost ~]# /usr/sbin/ibsrpdm -c -d /dev/infiniband/umad0
id_ext=0002c90300317810,ioc_guid=0002c90300317810,dgid=fe800000000000000002c90300317811,pkey=ffff,service_id=0002c90300317810

[root@localhost ~]# echo $?
130

fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
default signal handler will be used when it receives signal SIGINT.
ibsrpdm will exit with non-zero exit code as default signal handler
killed it. ibsrpdm should return with exit code zero, if no error
emerged.

main->ibsrpdm->free_res->pthread_kill(res->async_ev_thread, SIGINT)

Beside the wrong exit code, there is an extra blank line at the end of
output of ibsrpdm.

Fixes: fd3005f0cd34 ("srp_daemon: Move the setup of the wakeup_pipe after openlog")
Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2..0d00d712 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1996,7 +1996,6 @@ static void cleanup_wakeup_fd(void)
 
 static int setup_wakeup_fd(void)
 {
-	struct sigaction sa = {};
 	int ret;
 
 	ret = pipe2(wakeup_pipe, O_NONBLOCK | O_CLOEXEC);
@@ -2005,11 +2004,6 @@ static int setup_wakeup_fd(void)
 		return -1;
 	}
 
-	sigemptyset(&sa.sa_mask);
-	sa.sa_handler = signal_handler;
-	sigaction(SIGINT, &sa, NULL);
-	sigaction(SIGTERM, &sa, NULL);
-	sigaction(SRP_CATAS_ERR, &sa, NULL);
 	return 0;
 }
 
@@ -2100,6 +2094,7 @@ int main(int argc, char *argv[])
 	int			lockfd = -1;
 	int			received_signal = 0;
 	bool                    systemd;
+	struct sigaction        sa = {};
 
 #ifndef __CHECKER__
 	/*
@@ -2117,6 +2112,12 @@ int main(int argc, char *argv[])
 	BUILD_ASSERT(sizeof(struct srp_dm_iou_info) == 132);
 	BUILD_ASSERT(sizeof(struct srp_dm_ioc_prof) == 128);
 
+	sigemptyset(&sa.sa_mask);
+	sa.sa_handler = signal_handler;
+	sigaction(SIGINT, &sa, NULL);
+	sigaction(SIGTERM, &sa, NULL);
+	sigaction(SRP_CATAS_ERR, &sa, NULL);
+
 	if (strcmp(argv[0] + max_t(int, 0, strlen(argv[0]) - strlen("ibsrpdm")),
 		   "ibsrpdm") == 0) {
 		ret = ibsrpdm(argc, argv);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
