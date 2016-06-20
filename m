From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 15/25] xprtrdma: Release orphaned MRs immediately
Date: Mon, 20 Jun 2016 12:10:38 -0400
Message-ID: <20160620161038.10809.47684.stgit@manet.1015granger.net>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620155751.10809.22262.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of leaving orphaned MRs to be released when the transport
is destroyed, release them immediately. The MR free list can now be
replenished if it becomes exhausted.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c  |   19 +++++++++++++------
 net/sunrpc/xprtrdma/frwr_ops.c |   19 +++++++++++++------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 6802b8f..828ba46 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -135,15 +135,22 @@ fmr_op_recover_mr(struct rpcrdma_mw *mw)
 	/* ORDER: then DMA unmap */
 	ib_dma_unmap_sg(r_xprt->rx_ia.ri_device,
 			mw->mw_sg, mw->mw_nents, mw->mw_dir);
-	if (rc) {
-		pr_err("rpcrdma: FMR reset status %d, %p orphaned\n",
-		       rc, mw);
-		r_xprt->rx_stats.mrs_orphaned++;
-		return;
-	}
+	if (rc)
+		goto out_release;
 
 	rpcrdma_put_mw(r_xprt, mw);
 	r_xprt->rx_stats.mrs_recovered++;
+	return;
+
+out_release:
+	pr_err("rpcrdma: FMR reset failed (%d), %p released\n", rc, mw);
+	r_xprt->rx_stats.mrs_orphaned++;
+
+	spin_lock(&r_xprt->rx_buf.rb_mwlock);
+	list_del(&mw->mw_all);
+	spin_unlock(&r_xprt->rx_buf.rb_mwlock);
+
+	fmr_op_release_mr(mw);
 }
 
 static int
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index e77776b..f4c06c8 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -177,15 +177,22 @@ frwr_op_recover_mr(struct rpcrdma_mw *mw)
 
 	rc = __frwr_reset_mr(ia, mw);
 	ib_dma_unmap_sg(ia->ri_device, mw->mw_sg, mw->mw_nents, mw->mw_dir);
-	if (rc) {
-		pr_err("rpcrdma: FRMR reset status %d, %p orphaned\n",
-		       rc, mw);
-		r_xprt->rx_stats.mrs_orphaned++;
-		return;
-	}
+	if (rc)
+		goto out_release;
 
 	rpcrdma_put_mw(r_xprt, mw);
 	r_xprt->rx_stats.mrs_recovered++;
+	return;
+
+out_release:
+	pr_err("rpcrdma: FRMR reset failed %d, %p release\n", rc, mw);
+	r_xprt->rx_stats.mrs_orphaned++;
+
+	spin_lock(&r_xprt->rx_buf.rb_mwlock);
+	list_del(&mw->mw_all);
+	spin_unlock(&r_xprt->rx_buf.rb_mwlock);
+
+	frwr_op_release_mr(mw);
 }
 
 static int

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
