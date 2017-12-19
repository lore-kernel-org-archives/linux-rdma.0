From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] srp_daemon: Remove duplicate sync_res shutdown
Date: Tue, 19 Dec 2017 14:16:01 -0700
Message-ID: <20171219211601.GA27412@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The very first thing free_res does is the same lock/signal/unlock
sequence, so there is no reason to open code it before calling
free_res.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 4 ----
 1 file changed, 4 deletions(-)

Noticed while looking at honli's patch.. Didn't make a PR.

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2e0f12e..a1798558373490 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -2074,10 +2074,6 @@ static int ibsrpdm(int argc, char *argv[])
 		pr_err("Querying SRP targets failed\n");
 
 	assert(res->sync_res);
-	pthread_mutex_lock(&res->sync_res->retry_mutex);
-	res->sync_res->stop_threads = 1;
-	pthread_cond_signal(&res->sync_res->retry_cond);
-	pthread_mutex_unlock(&res->sync_res->retry_mutex);
 
 	free_res(res);
 umad_done:
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
