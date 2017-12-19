From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 rdma-core] srp_daemon: Remove duplicate sync_res shutdown
Date: Tue, 19 Dec 2017 14:51:02 -0700
Message-ID: <20171219215102.GA28841@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The very first thing free_res does is the same lock/signal/unlock
sequence, so there is no reason to open code it before calling
free_res.

res->sync_res always exists at this point so remove the assert too.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 6 ------
 1 file changed, 6 deletions(-)

v3:
- Delete stray edit

Bart, Yes, must have been a stray editor edit, I did not even look at v2 in
the mailer before sending it, since the one line change was so simple :(
This one compiles.

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2e0f12e..5995e6a6173046 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -2073,12 +2073,6 @@ static int ibsrpdm(int argc, char *argv[])
 	if (ret)
 		pr_err("Querying SRP targets failed\n");
 
-	assert(res->sync_res);
-	pthread_mutex_lock(&res->sync_res->retry_mutex);
-	res->sync_res->stop_threads = 1;
-	pthread_cond_signal(&res->sync_res->retry_cond);
-	pthread_mutex_unlock(&res->sync_res->retry_mutex);
-
 	free_res(res);
 umad_done:
 	umad_done();
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
