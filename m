From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 08/10] SUNRPC: serialize iostats updates
Date: Sat, 08 Nov 2014 20:15:09 -0500
Message-ID: <20141109011509.8806.40278.stgit@manet.1015granger.net>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109010328.8806.5861.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Occasionally mountstats reports a negative retransmission rate.
Ensure that two RPCs completing concurrently don't confuse the sums
in the transport's op_metrics array.

Since pNFS filelayout can invoke rpc_count_iostats() on another
transport from xprt_release(), we can't rely on simply holding the
transport_lock in xprt_release(). There's nothing for it but hard
serialization. One spin lock per RPC operation should make this as
painless as it can be.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/metrics.h |    3 +++
 net/sunrpc/stats.c             |   21 ++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/sunrpc/metrics.h b/include/linux/sunrpc/metrics.h
index 1565bbe..eecb5a7 100644
--- a/include/linux/sunrpc/metrics.h
+++ b/include/linux/sunrpc/metrics.h
@@ -27,10 +27,13 @@
 
 #include <linux/seq_file.h>
 #include <linux/ktime.h>
+#include <linux/spinlock.h>
 
 #define RPC_IOSTATS_VERS	"1.0"
 
 struct rpc_iostats {
+	spinlock_t		om_lock;
+
 	/*
 	 * These counters give an idea about how many request
 	 * transmissions are required, on average, to complete that
diff --git a/net/sunrpc/stats.c b/net/sunrpc/stats.c
index 5453049..9711a15 100644
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -116,7 +116,15 @@ EXPORT_SYMBOL_GPL(svc_seq_show);
  */
 struct rpc_iostats *rpc_alloc_iostats(struct rpc_clnt *clnt)
 {
-	return kcalloc(clnt->cl_maxproc, sizeof(struct rpc_iostats), GFP_KERNEL);
+	struct rpc_iostats *stats;
+	int i;
+
+	stats = kcalloc(clnt->cl_maxproc, sizeof(*stats), GFP_KERNEL);
+	if (stats) {
+		for (i = 0; i < clnt->cl_maxproc; i++)
+			spin_lock_init(&stats[i].om_lock);
+	}
+	return stats;
 }
 EXPORT_SYMBOL_GPL(rpc_alloc_iostats);
 
@@ -135,20 +143,21 @@ EXPORT_SYMBOL_GPL(rpc_free_iostats);
  * rpc_count_iostats - tally up per-task stats
  * @task: completed rpc_task
  * @stats: array of stat structures
- *
- * Relies on the caller for serialization.
  */
 void rpc_count_iostats(const struct rpc_task *task, struct rpc_iostats *stats)
 {
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_iostats *op_metrics;
-	ktime_t delta;
+	ktime_t delta, now;
 
 	if (!stats || !req)
 		return;
 
+	now = ktime_get();
 	op_metrics = &stats[task->tk_msg.rpc_proc->p_statidx];
 
+	spin_lock(&op_metrics->om_lock);
+
 	op_metrics->om_ops++;
 	op_metrics->om_ntrans += req->rq_ntrans;
 	op_metrics->om_timeouts += task->tk_timeouts;
@@ -161,8 +170,10 @@ void rpc_count_iostats(const struct rpc_task *task, struct rpc_iostats *stats)
 
 	op_metrics->om_rtt = ktime_add(op_metrics->om_rtt, req->rq_rtt);
 
-	delta = ktime_sub(ktime_get(), task->tk_start);
+	delta = ktime_sub(now, task->tk_start);
 	op_metrics->om_execute = ktime_add(op_metrics->om_execute, delta);
+
+	spin_unlock(&op_metrics->om_lock);
 }
 EXPORT_SYMBOL_GPL(rpc_count_iostats);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
