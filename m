From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 10/12] xprtrdma: FMR does not need list_del_init()
Date: Tue, 23 May 2017 10:54:59 -0400
Message-ID: <20170523145459.961.69893.stgit@manet.1015granger.net>
References: <20170523142629.961.81233.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523142629.961.81233.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

Commit 38f1932e60ba ("xprtrdma: Remove FMRs from the unmap list
after unmapping") utilized list_del_init() to try to prevent some
list corruption. The corruption was actually caused by the reply
handler racing with a signal. Now that MR invalidation is properly
serialized, list_del_init() can safely be replaced.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 2f4eacd..d3f84bb 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -91,7 +91,7 @@ enum {
 
 	list_add(&mw->fmr.fm_mr->list, &l);
 	rc = ib_unmap_fmr(&l);
-	list_del_init(&mw->fmr.fm_mr->list);
+	list_del(&mw->fmr.fm_mr->list);
 	return rc;
 }
 
@@ -261,7 +261,7 @@ enum {
 static void
 fmr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct list_head *mws)
 {
-	struct rpcrdma_mw *mw, *tmp;
+	struct rpcrdma_mw *mw;
 	LIST_HEAD(unmap_list);
 	int rc;
 
@@ -283,9 +283,11 @@ enum {
 	/* ORDER: Now DMA unmap all of the req's MRs, and return
 	 * them to the free MW list.
 	 */
-	list_for_each_entry_safe(mw, tmp, mws, mw_list) {
-		list_del_init(&mw->mw_list);
-		list_del_init(&mw->fmr.fm_mr->list);
+	while (!list_empty(mws)) {
+		mw = rpcrdma_pop_mw(mws);
+		dprintk("RPC:       %s: DMA unmapping fmr %p\n",
+			__func__, &mw->fmr);
+		list_del(&mw->fmr.fm_mr->list);
 		ib_dma_unmap_sg(r_xprt->rx_ia.ri_device,
 				mw->mw_sg, mw->mw_nents, mw->mw_dir);
 		rpcrdma_put_mw(r_xprt, mw);
@@ -296,9 +298,9 @@ enum {
 out_reset:
 	pr_err("rpcrdma: ib_unmap_fmr failed (%i)\n", rc);
 
-	list_for_each_entry_safe(mw, tmp, mws, mw_list) {
-		list_del_init(&mw->mw_list);
-		list_del_init(&mw->fmr.fm_mr->list);
+	while (!list_empty(mws)) {
+		mw = rpcrdma_pop_mw(mws);
+		list_del(&mw->fmr.fm_mr->list);
 		fmr_op_recover_mr(mw);
 	}
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
