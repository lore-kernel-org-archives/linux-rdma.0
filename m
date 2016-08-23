From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 20/22] xprtrmda: Report address of frmr, not mw
Date: Tue, 23 Aug 2016 13:54:46 -0400
Message-ID: <20160823175446.13038.58792.stgit@manet.1015granger.net>
References: <20160823174402.13038.84561.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160823174402.13038.84561.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tie frwr debugging messages together by always reporting the address
of the frwr.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index e82d5cf..2e51ef5 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -163,7 +163,7 @@ __frwr_reset_mr(struct rpcrdma_ia *ia, struct rpcrdma_mw *r)
 		return PTR_ERR(f->fr_mr);
 	}
 
-	dprintk("RPC:       %s: recovered FRMR %p\n", __func__, r);
+	dprintk("RPC:       %s: recovered FRMR %p\n", __func__, f);
 	f->fr_state = FRMR_IS_INVALID;
 	return 0;
 }
@@ -397,7 +397,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 		goto out_mapmr_err;
 
 	dprintk("RPC:       %s: Using frmr %p to map %u segments (%u bytes)\n",
-		__func__, mw, mw->mw_nents, mr->length);
+		__func__, frmr, mw->mw_nents, mr->length);
 
 	key = (u8)(mr->rkey & 0x000000FF);
 	ib_update_fast_reg_key(mr, ++key);
@@ -450,6 +450,9 @@ __frwr_prepare_linv_wr(struct rpcrdma_mw *mw)
 	struct rpcrdma_frmr *f = &mw->frmr;
 	struct ib_send_wr *invalidate_wr;
 
+	dprintk("RPC:       %s: invalidating frmr %p\n",
+		__func__, f);
+
 	f->fr_state = FRMR_IS_INVALID;
 	invalidate_wr = &f->fr_invwr;
 
@@ -532,6 +535,8 @@ frwr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 	 */
 unmap:
 	list_for_each_entry_safe(mw, tmp, &req->rl_registered, mw_list) {
+		dprintk("RPC:       %s: unmapping frmr %p\n",
+			__func__, &mw->frmr);
 		list_del_init(&mw->mw_list);
 		ib_dma_unmap_sg(ia->ri_device,
 				mw->mw_sg, mw->mw_nents, mw->mw_dir);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
