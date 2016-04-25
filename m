From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 13/18] xprtrdma: Refactor the FRWR recovery worker
Date: Mon, 25 Apr 2016 15:22:34 -0400
Message-ID: <20160425192234.3566.63698.stgit@manet.1015granger.net>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425185956.3566.64142.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Maintain the order of invalidation and DMA unmapping when doing
a background MR reset.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index ce245dc..4e0a5c1 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -124,6 +124,21 @@ __frwr_reset_mr(struct rpcrdma_ia *ia, struct rpcrdma_mw *r)
 	return 0;
 }
 
+static void
+__frwr_reset_and_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mw *mw)
+{
+	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
+	struct rpcrdma_frmr *f = &mw->frmr;
+	int rc;
+
+	rc = __frwr_reset_mr(ia, mw);
+	ib_dma_unmap_sg(ia->ri_device, f->fr_sg, f->fr_nents, f->fr_dir);
+	if (rc)
+		return;
+
+	rpcrdma_put_mw(r_xprt, mw);
+}
+
 /* Deferred reset of a single FRMR. Generate a fresh rkey by
  * replacing the MR.
  *
@@ -136,15 +151,8 @@ __frwr_recovery_worker(struct work_struct *work)
 {
 	struct rpcrdma_mw *r = container_of(work, struct rpcrdma_mw,
 					    frmr.fr_work);
-	struct rpcrdma_xprt *r_xprt = r->frmr.fr_xprt;
-	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
-	int rc;
-
-	rc = __frwr_reset_mr(ia, r);
-	if (rc)
-		return;
 
-	rpcrdma_put_mw(r_xprt, r);
+	__frwr_reset_and_unmap(r->frmr.fr_xprt, r);
 	return;
 }
 
@@ -483,7 +491,6 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 
 out_senderr:
 	dprintk("RPC:       %s: ib_post_send status %i\n", __func__, rc);
-	ib_dma_unmap_sg(device, frmr->fr_sg, dma_nents, direction);
 	__frwr_queue_recovery(mw);
 	return rc;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
