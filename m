From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 13/21] xprtrdma: Don't post a LOCAL_INV in
 rpcrdma_register_frmr_external()
Date: Tue, 29 Jul 2014 17:25:03 -0400
Message-ID: <20140729212503.2812.14645.stgit@manet.1015granger.net>
References: <20140729211534.2812.3128.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729211534.2812.3128.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Any FRMR arriving in rpcrdma_register_frmr_external() is now
guaranteed to be either invalid, or to be targeted by a queued
LOCAL_INV that will invalidate it before the adapter processes
the FAST_REG_MR being built here.

The problem with current arrangement of chaining a LOCAL_INV to the
FAST_REG_MR is that if the transport is not connected, the LOCAL_INV
is flushed and the FAST_REG_MR is flushed. This leaves the FRMR
valid with the old rkey. But rpcrdma_register_frmr_external() has
already bumped the in-memory rkey.

Next time through rpcrdma_register_frmr_external(), a LOCAL_INV and
FAST_REG_MR is attempted again because the FRMR is still valid. But
the rkey no longer matches the hardware's rkey, and a memory
management operation error occurs.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 2e91745..8da9a35 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1692,8 +1692,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	struct rpcrdma_mw *mw = seg1->mr_chunk.rl_mw;
 	struct rpcrdma_frmr *frmr = &mw->r.frmr;
 	struct ib_mr *mr = frmr->fr_mr;
-	struct ib_send_wr invalidate_wr, frmr_wr, *bad_wr, *post_wr;
-
+	struct ib_send_wr frmr_wr, *bad_wr;
 	u8 key;
 	int len, pageoff;
 	int i, rc;
@@ -1725,22 +1724,6 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	dprintk("RPC:       %s: Using frmr %p to map %d segments\n",
 		__func__, mw, i);
 
-	if (unlikely(frmr->fr_state != FRMR_IS_INVALID)) {
-		dprintk("RPC:       %s: frmr %x left valid, posting invalidate.\n",
-			__func__, mr->rkey);
-		/* Invalidate before using. */
-		memset(&invalidate_wr, 0, sizeof invalidate_wr);
-		invalidate_wr.wr_id = (unsigned long)(void *)mw;
-		invalidate_wr.next = &frmr_wr;
-		invalidate_wr.opcode = IB_WR_LOCAL_INV;
-		invalidate_wr.send_flags = IB_SEND_SIGNALED;
-		invalidate_wr.ex.invalidate_rkey = mr->rkey;
-		DECR_CQCOUNT(&r_xprt->rx_ep);
-		post_wr = &invalidate_wr;
-	} else
-		post_wr = &frmr_wr;
-
-	/* Prepare FRMR WR */
 	memset(&frmr_wr, 0, sizeof frmr_wr);
 	frmr_wr.wr_id = (unsigned long)(void *)mw;
 	frmr_wr.opcode = IB_WR_FAST_REG_MR;
@@ -1765,8 +1748,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	frmr_wr.wr.fast_reg.rkey = mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
-	rc = ib_post_send(ia->ri_id->qp, post_wr, &bad_wr);
-
+	rc = ib_post_send(ia->ri_id->qp, &frmr_wr, &bad_wr);
 	if (rc) {
 		dprintk("RPC:       %s: failed ib_post_send for register,"
 			" status %i\n", __func__, rc);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
