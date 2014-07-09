From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 16/21] xprtrdma: Rename frmr_wr
Date: Wed, 09 Jul 2014 12:58:46 -0400
Message-ID: <20140709165846.3496.13596.stgit@manet.1015granger.net>
References: <20140709163326.3496.37893.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140709163326.3496.37893.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: Name frmr_wr after the opcode of the Work Request,
consistent with the send and local invalidation paths.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 8eef343..d0a893d 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1701,7 +1701,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	struct rpcrdma_mr_seg *seg1 = seg;
 	struct rpcrdma_mw *mw = seg1->mr_chunk.rl_mw;
 	struct rpcrdma_frmr *frmr = &mw->r.frmr;
-	struct ib_send_wr frmr_wr, *bad_wr;
+	struct ib_send_wr fastreg_wr, *bad_wr;
 	int len, pageoff;
 	int i, rc;
 	int seg_len;
@@ -1734,26 +1734,26 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 
 	frmr->fr_state = FRMR_IS_VALID;
 
-	memset(&frmr_wr, 0, sizeof frmr_wr);
-	frmr_wr.wr_id = (unsigned long)(void *)mw;
-	frmr_wr.opcode = IB_WR_FAST_REG_MR;
-	frmr_wr.wr.fast_reg.iova_start = seg1->mr_dma;
-	frmr_wr.wr.fast_reg.page_list = frmr->fr_pgl;
-	frmr_wr.wr.fast_reg.page_list_len = page_no;
-	frmr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
-	frmr_wr.wr.fast_reg.length = page_no << PAGE_SHIFT;
-	if (frmr_wr.wr.fast_reg.length < len) {
+	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
+	fastreg_wr.wr_id = (unsigned long)(void *)mw;
+	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
+	fastreg_wr.wr.fast_reg.iova_start = seg1->mr_dma;
+	fastreg_wr.wr.fast_reg.page_list = frmr->fr_pgl;
+	fastreg_wr.wr.fast_reg.page_list_len = page_no;
+	fastreg_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
+	fastreg_wr.wr.fast_reg.length = page_no << PAGE_SHIFT;
+	if (fastreg_wr.wr.fast_reg.length < len) {
 		rc = -EIO;
 		goto out_err;
 	}
-	frmr_wr.wr.fast_reg.access_flags = (writing ?
+	fastreg_wr.wr.fast_reg.access_flags = (writing ?
 				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
 				IB_ACCESS_REMOTE_READ);
 	rpcrdma_increment_frmr_rkey(mw);
-	frmr_wr.wr.fast_reg.rkey = frmr->fr_mr->rkey;
+	fastreg_wr.wr.fast_reg.rkey = frmr->fr_mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
-	rc = ib_post_send(ia->ri_id->qp, &frmr_wr, &bad_wr);
+	rc = ib_post_send(ia->ri_id->qp, &fastreg_wr, &bad_wr);
 	if (rc) {
 		dprintk("RPC:       %s: failed ib_post_send for register,"
 			" status %i\n", __func__, rc);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
