From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core PATCH] srp_daemon: Don't create async_ev_thread if only run once
Date: Wed, 20 Dec 2017 03:09:58 +0800
Message-ID: <20171219190958.3189-1-honli@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
default signal handler will be used when the main pthread send signal
SIGINT to pthread async_ev_thread. ibsrpdm will exit with non-zero
exit code as default signal handler killed it. ibsrpdm should return
with exit code zero, if no error emerged.

We should not create async_ev_thread for ibsrpdm.

Fixes: fd3005f0cd34 ("srp_daemon: Move the setup of the wakeup_pipe after openlog")
Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2..4012a7db 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1945,12 +1945,12 @@ static struct resources *alloc_res(void)
 				     run_thread_get_trap_notices, &res->res);
 		if (ret)
 			goto err;
-	}
 
-	ret = pthread_create(&res->res.async_ev_thread, NULL,
-			     run_thread_listen_to_events, &res->res);
-	if (ret)
-		goto err;
+		ret = pthread_create(&res->res.async_ev_thread, NULL,
+				     run_thread_listen_to_events, &res->res);
+		if (ret)
+			goto err;
+	}
 
 	if (config->retry_timeout && !config->once) {
 		ret = pthread_create(&res->res.reconnect_thread, NULL,
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
