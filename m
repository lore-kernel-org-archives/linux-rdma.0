From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 11/16] xprtrdma: Handle non-SEND completions via a callout
Date: Fri, 13 Mar 2015 17:28:16 -0400
Message-ID: <20150313212816.22783.49677.stgit@manet.1015granger.net>
References: <20150313212517.22783.18364.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313212517.22783.18364.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow each memory registration mode to plug in a callout that handles
the completion of a memory registration operation.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c  |   17 +++++++++++++++++
 net/sunrpc/xprtrdma/verbs.c     |   14 +++++---------
 net/sunrpc/xprtrdma/xprt_rdma.h |    5 +++++
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 9bb4b2d..6e6d8ba 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -164,6 +164,22 @@ frwr_op_maxpages(struct rpcrdma_xprt *r_xprt)
 		     rpcrdma_max_segments(r_xprt) * ia->ri_max_frmr_depth);
 }
 
+/* If FAST_REG or LOCAL_INV failed, indicate the frmr needs to be reset. */
+static void
+frwr_sendcompletion(struct ib_wc *wc)
+{
+	struct rpcrdma_mw *r;
+
+	if (likely(wc->status == IB_WC_SUCCESS))
+		return;
+
+	/* WARNING: Only wr_id and status are reliable at this point */
+	r = (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
+	dprintk("RPC:       %s: frmr %p (stale), status %d\n",
+		__func__, r, wc->status);
+	r->r.frmr.fr_state = FRMR_IS_STALE;
+}
+
 static int
 frwr_op_init(struct rpcrdma_xprt *r_xprt)
 {
@@ -195,6 +211,7 @@ frwr_op_init(struct rpcrdma_xprt *r_xprt)
 
 		list_add(&r->mw_list, &buf->rb_mws);
 		list_add(&r->mw_all, &buf->rb_all);
+		r->mw_sendcompletion = frwr_sendcompletion;
 	}
 
 	return 0;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 17b2a29..f108a57 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -204,21 +204,17 @@ static const char * const wc_status[] = {
 static void
 rpcrdma_sendcq_process_wc(struct ib_wc *wc)
 {
-	if (likely(wc->status == IB_WC_SUCCESS))
-		return;
-
 	/* WARNING: Only wr_id and status are reliable at this point */
-	if (wc->wr_id == 0ULL) {
-		if (wc->status != IB_WC_WR_FLUSH_ERR)
+	if (wc->wr_id == RPCRDMA_IGNORE_COMPLETION) {
+		if (wc->status != IB_WC_SUCCESS &&
+		    wc->status != IB_WC_WR_FLUSH_ERR)
 			pr_err("RPC:       %s: SEND: %s\n",
 			       __func__, COMPLETION_MSG(wc->status));
 	} else {
 		struct rpcrdma_mw *r;
 
 		r = (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
-		r->r.frmr.fr_state = FRMR_IS_STALE;
-		pr_err("RPC:       %s: frmr %p (stale): %s\n",
-		       __func__, r, COMPLETION_MSG(wc->status));
+		r->mw_sendcompletion(wc);
 	}
 }
 
@@ -1616,7 +1612,7 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
 	}
 
 	send_wr.next = NULL;
-	send_wr.wr_id = 0ULL;	/* no send cookie */
+	send_wr.wr_id = RPCRDMA_IGNORE_COMPLETION;
 	send_wr.sg_list = req->rl_send_iov;
 	send_wr.num_sge = req->rl_niovs;
 	send_wr.opcode = IB_WR_SEND;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index a53a564..40a0ee8 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -106,6 +106,10 @@ struct rpcrdma_ep {
 #define INIT_CQCOUNT(ep) atomic_set(&(ep)->rep_cqcount, (ep)->rep_cqinit)
 #define DECR_CQCOUNT(ep) atomic_sub_return(1, &(ep)->rep_cqcount)
 
+/* Force completion handler to ignore the signal
+ */
+#define RPCRDMA_IGNORE_COMPLETION	(0ULL)
+
 /* Registered buffer -- registered kmalloc'd memory for RDMA SEND/RECV
  *
  * The below structure appears at the front of a large region of kmalloc'd
@@ -206,6 +210,7 @@ struct rpcrdma_mw {
 		struct ib_fmr		*fmr;
 		struct rpcrdma_frmr	frmr;
 	} r;
+	void			(*mw_sendcompletion)(struct ib_wc *);
 	struct list_head	mw_list;
 	struct list_head	mw_all;
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
