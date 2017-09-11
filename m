From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 7/7] xprtrdma: Remove atomic send completion counting
Date: Mon, 11 Sep 2017 11:19:27 -0400
Message-ID: <150514316269.1307.2611322584949337129.stgit@lebasque.1015granger.net>
References: <150514269466.1307.1991885208569456320.stgit@lebasque.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150514269466.1307.1991885208569456320.stgit-NCCkF8GxsaM6WJ89mGctdJimSvn7F7xT@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The sendctx circular queue now guarantees that xprtrdma cannot
overflow the Send Queue, so remove the Send counting mechanism.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c  |    8 --------
 net/sunrpc/xprtrdma/verbs.c     |    4 ----
 net/sunrpc/xprtrdma/xprt_rdma.h |   21 ---------------------
 3 files changed, 33 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 5a936a6..f366a05 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -419,7 +419,6 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 			 IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
 			 IB_ACCESS_REMOTE_READ;
 
-	rpcrdma_set_signaled(&r_xprt->rx_ep, &reg_wr->wr);
 	rc = ib_post_send(ia->ri_id->qp, &reg_wr->wr, &bad_wr);
 	if (rc)
 		goto out_senderr;
@@ -507,12 +506,6 @@ frwr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct list_head *mws)
 	f->fr_cqe.done = frwr_wc_localinv_wake;
 	reinit_completion(&f->fr_linv_done);
 
-	/* Initialize CQ count, since there is always a signaled
-	 * WR being posted here.  The new cqcount depends on how
-	 * many SQEs are about to be consumed.
-	 */
-	rpcrdma_init_cqcount(&r_xprt->rx_ep, count);
-
 	/* Transport disconnect drains the receive CQ before it
 	 * replaces the QP. The RPC reply handler won't call us
 	 * unless ri_id->qp is a valid pointer.
@@ -545,7 +538,6 @@ frwr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct list_head *mws)
 	/* Find and reset the MRs in the LOCAL_INV WRs that did not
 	 * get posted.
 	 */
-	rpcrdma_init_cqcount(&r_xprt->rx_ep, -count);
 	while (bad_wr) {
 		f = container_of(bad_wr, struct rpcrdma_frmr,
 				 fr_invwr);
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index de26ecf..d64bfdd 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -575,10 +575,6 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	ep->rep_send_batch = min_t(unsigned int, RPCRDMA_MAX_SEND_BATCH,
 				   cdata->max_requests >> 2);
 	ep->rep_send_count = ep->rep_send_batch;
-	ep->rep_cqinit = ep->rep_attr.cap.max_send_wr/2 - 1;
-	if (ep->rep_cqinit <= 2)
-		ep->rep_cqinit = 0;	/* always signal? */
-	rpcrdma_init_cqcount(ep, 0);
 	init_waitqueue_head(&ep->rep_connect_wait);
 	INIT_DELAYED_WORK(&ep->rep_connect_worker, rpcrdma_connect_worker);
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 6bb7054..66598de 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -95,8 +95,6 @@ enum {
 struct rpcrdma_ep {
 	unsigned int		rep_send_count;
 	unsigned int		rep_send_batch;
-	atomic_t		rep_cqcount;
-	int			rep_cqinit;
 	int			rep_connected;
 	struct ib_qp_init_attr	rep_attr;
 	wait_queue_head_t 	rep_connect_wait;
@@ -106,25 +104,6 @@ struct rpcrdma_ep {
 	struct delayed_work	rep_connect_worker;
 };
 
-static inline void
-rpcrdma_init_cqcount(struct rpcrdma_ep *ep, int count)
-{
-	atomic_set(&ep->rep_cqcount, ep->rep_cqinit - count);
-}
-
-/* To update send queue accounting, provider must take a
- * send completion every now and then.
- */
-static inline void
-rpcrdma_set_signaled(struct rpcrdma_ep *ep, struct ib_send_wr *send_wr)
-{
-	send_wr->send_flags = 0;
-	if (unlikely(atomic_sub_return(1, &ep->rep_cqcount) <= 0)) {
-		rpcrdma_init_cqcount(ep, 0);
-		send_wr->send_flags = IB_SEND_SIGNALED;
-	}
-}
-
 /* Pre-allocate extra Work Requests for handling backward receives
  * and sends. This is a fixed value because the Work Queues are
  * allocated when the forward channel is set up.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
