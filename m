From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] complib: Fix memory leak in cl_thread_pool_destroy
 function
Date: Mon, 24 Jun 2013 11:56:11 -0400
Message-ID: <51C86C1B.6030307@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 complib/cl_threadpool.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/complib/cl_threadpool.c b/complib/cl_threadpool.c
index 0f6498b..11abfbb 100644
--- a/complib/cl_threadpool.c
+++ b/complib/cl_threadpool.c
@@ -129,6 +129,9 @@ void cl_thread_pool_destroy(IN cl_thread_pool_t * const p_thread_pool)
 			pthread_join(p_thread_pool->tid[i], NULL);
 
 	p_thread_pool->running_count = 0;
+
+	free(p_thread_pool->tid);
+
 	pthread_cond_destroy(&p_thread_pool->cond);
 	pthread_mutex_destroy(&p_thread_pool->mutex);
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
