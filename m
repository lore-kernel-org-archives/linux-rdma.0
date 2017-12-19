From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 rdma-core] srp_daemon: Remove duplicate sync_res shutdown
Date: Tue, 19 Dec 2017 14:38:00 -0700
Message-ID: <20171219213800.GA28378@ziepe.ca>
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

res->sync_res always exists at this point so remove the assert too.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

v2:
Remove the assert too

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index cec36db2e0f12e..696c58bfd0b1ec 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -1899,7 +1899,7 @@ static void free_res(struct resources *res)
 		pthread_join(res->trap_thread, &status);
 	}
 	if (res->sync_res)
-		sync_resources_cleanup(res->sync_res);
+	f	sync_resources_cleanup(res->sync_res);
 	if (res->ud_res)
 		ud_resources_destroy(res->ud_res);
 	if (res->umad_res)
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
