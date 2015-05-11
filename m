From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 13/16] xprtrdma: Split rb_lock
Date: Mon, 11 May 2015 14:04:21 -0400
Message-ID: <20150511180421.31263.78591.stgit@manet.1015granger.net>
References: <20150511174401.31263.79596.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511174401.31263.79596.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

/proc/lock_stat showed contention between rpcrdma_buffer_get/put
and the MR allocation functions during I/O intensive workloads.

Now that MRs are no longer allocated in rpcrdma_buffer_get(),
there's no reason the rb_mws list has to be managed using the
same lock as the send/receive buffers. Split that lock. The
new lock does not need to disable interrupts because buffer
get/put is never called in an interrupt context.

struct rpcrdma_buffer is re-arranged to ensure rb_mwlock and rb_mws
are always in a different cacheline than rb_lock and the buffer
pointers.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c   |    1 +
 net/sunrpc/xprtrdma/frwr_ops.c  |    1 +
 net/sunrpc/xprtrdma/verbs.c     |   10 ++++------
 net/sunrpc/xprtrdma/xprt_rdma.h |   16 +++++++++-------
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 5dd77da..52f9ad5 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -65,6 +65,7 @@ fmr_op_init(struct rpcrdma_xprt *r_xprt)
 	struct rpcrdma_mw *r;
 	int i, rc;
 
+	spin_lock_init(&buf->rb_mwlock);
 	INIT_LIST_HEAD(&buf->rb_mws);
 	INIT_LIST_HEAD(&buf->rb_all);
 
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 8622792..18b7305 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -266,6 +266,7 @@ frwr_op_init(struct rpcrdma_xprt *r_xprt)
 	struct ib_pd *pd = r_xprt->rx_ia.ri_pd;
 	int i;
 
+	spin_lock_init(&buf->rb_mwlock);
 	INIT_LIST_HEAD(&buf->rb_mws);
 	INIT_LIST_HEAD(&buf->rb_all);
 
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index cc1a526..2340835 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1173,15 +1173,14 @@ rpcrdma_get_mw(struct rpcrdma_xprt *r_xprt)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
 	struct rpcrdma_mw *mw = NULL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&buf->rb_lock, flags);
+	spin_lock(&buf->rb_mwlock);
 	if (!list_empty(&buf->rb_mws)) {
 		mw = list_first_entry(&buf->rb_mws,
 				      struct rpcrdma_mw, mw_list);
 		list_del_init(&mw->mw_list);
 	}
-	spin_unlock_irqrestore(&buf->rb_lock, flags);
+	spin_unlock(&buf->rb_mwlock);
 
 	if (!mw)
 		pr_err("RPC:       %s: no MWs available\n", __func__);
@@ -1192,11 +1191,10 @@ void
 rpcrdma_put_mw(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mw *mw)
 {
 	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
-	unsigned long flags;
 
-	spin_lock_irqsave(&buf->rb_lock, flags);
+	spin_lock(&buf->rb_mwlock);
 	list_add_tail(&mw->mw_list, &buf->rb_mws);
-	spin_unlock_irqrestore(&buf->rb_lock, flags);
+	spin_unlock(&buf->rb_mwlock);
 }
 
 static void
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 3ecee38..df92884 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -282,15 +282,17 @@ rpcr_to_rdmar(struct rpc_rqst *rqst)
  * One of these is associated with a transport instance
  */
 struct rpcrdma_buffer {
-	spinlock_t	rb_lock;	/* protects indexes */
-	u32		rb_max_requests;/* client max requests */
-	struct list_head rb_mws;	/* optional memory windows/fmrs/frmrs */
-	struct list_head rb_all;
-	int		rb_send_index;
+	spinlock_t		rb_mwlock;	/* protect rb_mws list */
+	struct list_head	rb_mws;
+	struct list_head	rb_all;
+	char			*rb_pool;
+
+	spinlock_t		rb_lock;	/* protect buf arrays */
+	u32			rb_max_requests;
+	int			rb_send_index;
+	int			rb_recv_index;
 	struct rpcrdma_req	**rb_send_bufs;
-	int		rb_recv_index;
 	struct rpcrdma_rep	**rb_recv_bufs;
-	char		*rb_pool;
 };
 #define rdmab_to_ia(b) (&container_of((b), struct rpcrdma_xprt, rx_buf)->rx_ia)
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
