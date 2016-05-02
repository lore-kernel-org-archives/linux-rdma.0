From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 13/20] xprtrdma: Save I/O direction in struct rpcrdma_frwr
Date: Mon, 02 May 2016 14:42:04 -0400
Message-ID: <20160502184204.10798.65595.stgit@manet.1015granger.net>
References: <20160502183144.10798.99847.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502183144.10798.99847.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Move the the I/O direction field from rpcrdma_mr_seg into the
rpcrdma_frmr.

This makes it possible to DMA-unmap the frwr long after an RPC has
exited and its rpcrdma_mr_seg array has been released and re-used.
This might occur if an RPC times out while waiting for a new
connection to be established.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c  |    6 +++---
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 7c22e9e..e1e6ac1 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -416,6 +416,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 			break;
 	}
 	frmr->fr_nents = i;
+	frmr->fr_dir = direction;
 
 	dma_nents = ib_dma_map_sg(device, frmr->fr_sg, frmr->fr_nents, direction);
 	if (!dma_nents) {
@@ -455,7 +456,6 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	if (rc)
 		goto out_senderr;
 
-	seg1->mr_dir = direction;
 	seg1->rl_mw = mw;
 	seg1->mr_rkey = mr->rkey;
 	seg1->mr_base = mr->iova;
@@ -500,7 +500,7 @@ __frwr_dma_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 
 	seg->rl_mw = NULL;
 
-	ib_dma_unmap_sg(device, f->fr_sg, f->fr_nents, seg->mr_dir);
+	ib_dma_unmap_sg(device, f->fr_sg, f->fr_nents, f->fr_dir);
 
 	if (!rc)
 		rpcrdma_put_mw(r_xprt, mw);
@@ -611,7 +611,7 @@ frwr_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
 	invalidate_wr->ex.invalidate_rkey = frmr->fr_mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
-	ib_dma_unmap_sg(ia->ri_device, frmr->fr_sg, frmr->fr_nents, seg1->mr_dir);
+	ib_dma_unmap_sg(ia->ri_device, frmr->fr_sg, frmr->fr_nents, frmr->fr_dir);
 	read_lock(&ia->ri_qplock);
 	rc = ib_post_send(ia->ri_id->qp, invalidate_wr, &bad_wr);
 	read_unlock(&ia->ri_qplock);
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 612e3de..b5793cb 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -224,6 +224,7 @@ enum rpcrdma_frmr_state {
 struct rpcrdma_frmr {
 	struct scatterlist		*fr_sg;
 	int				fr_nents;
+	enum dma_data_direction		fr_dir;
 	struct ib_mr			*fr_mr;
 	struct ib_cqe			fr_cqe;
 	enum rpcrdma_frmr_state		fr_state;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
