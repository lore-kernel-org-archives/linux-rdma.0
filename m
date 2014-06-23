From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 07/13] xprtrdma: Encode Work Request opcode in wc->wr_id
Date: Mon, 23 Jun 2014 18:39:58 -0400
Message-ID: <20140623223958.1634.60529.stgit@manet.1015granger.net>
References: <20140623223201.1634.83888.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623223201.1634.83888.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The wc->opcode field is unreliable when a completion fails.
Up until now, the completion handler has ignored unsuccessful
completions, so that didn't matter to xprtrdma.

In a subsequent patch, however, the send CQ handler will need
to know which Work Request opcode is completing, even if for
error completions.

xprtrdma posts three Work Request opcodes via the send queue:
SEND, FAST_REG_MR, and LOCAL_INV:

For SEND, wc->wr_id is zero. Those completions are ignored.

The other two plant a pointer to an rpcrdma_mw in wc->wr_id. Make
the low-order bit indicate which of FAST_REG_MR or LOCAL_INV is
being done.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c     |   19 +++++++++++--------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 ++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index e8ed81c..cef67fd 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -145,20 +145,22 @@ rpcrdma_cq_async_error_upcall(struct ib_event *event, void *context)
 static void
 rpcrdma_sendcq_process_wc(struct ib_wc *wc)
 {
-	struct rpcrdma_mw *frmr = (struct rpcrdma_mw *)(unsigned long)wc->wr_id;
+	unsigned long wrid = wc->wr_id;
+	struct rpcrdma_mw *mw;
+	int fastreg;
 
-	dprintk("RPC:       %s: frmr %p status %X opcode %d\n",
-		__func__, frmr, wc->status, wc->opcode);
+	dprintk("RPC:       %s: wr_id %lx status %X opcode %d\n",
+		__func__, wrid, wc->status, wc->opcode);
 
-	if (wc->wr_id == 0ULL)
+	if (wrid == 0)
 		return;
 	if (wc->status != IB_WC_SUCCESS)
 		return;
 
-	if (wc->opcode == IB_WC_FAST_REG_MR)
-		frmr->r.frmr.fr_state = FRMR_IS_VALID;
-	else if (wc->opcode == IB_WC_LOCAL_INV)
-		frmr->r.frmr.fr_state = FRMR_IS_INVALID;
+	fastreg = test_and_clear_bit(RPCRDMA_BIT_FASTREG, &wrid);
+	mw = (struct rpcrdma_mw *)wrid;
+
+	mw->r.frmr.fr_state = fastreg ? FRMR_IS_VALID : FRMR_IS_INVALID;
 }
 
 static int
@@ -1538,6 +1540,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	/* Prepare FRMR WR */
 	memset(&frmr_wr, 0, sizeof frmr_wr);
 	frmr_wr.wr_id = (unsigned long)(void *)seg1->mr_chunk.rl_mw;
+	frmr_wr.wr_id |= (u64)1 << RPCRDMA_BIT_FASTREG;
 	frmr_wr.opcode = IB_WR_FAST_REG_MR;
 	frmr_wr.send_flags = IB_SEND_SIGNALED;
 	frmr_wr.wr.fast_reg.iova_start = seg1->mr_dma;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 28c8570..6b5d243 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -177,6 +177,8 @@ struct rpcrdma_mw {
 	struct list_head	mw_list;
 };
 
+#define RPCRDMA_BIT_FASTREG		(0)
+
 /*
  * struct rpcrdma_req -- structure central to the request/reply sequence.
  *

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
