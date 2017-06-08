From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 06/13] xprtrdma: Fix FRWR invalidation error recovery
Date: Thu, 08 Jun 2017 11:52:28 -0400
Message-ID: <20170608155228.18945.92955.stgit@manet.1015granger.net>
References: <20170608154339.18945.5500.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608154339.18945.5500.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When ib_post_send() fails, all LOCAL_INV WRs past @bad_wr have to be
examined, and the MRs reset by hand.

I'm not sure how the existing code can work by comparing R_keys.
Restructure the logic so that instead it walks the chain of WRs,
starting from the first bad one.

Make sure to wait for completion if at least one WR was actually
posted. Otherwise, if the ib_post_send fails, we can end up
DMA-unmapping the MR while LOCAL_INV operations are in flight.

Commit 7a89f9c626e3 ("xprtrdma: Honor ->send_request API contract")
added the rdma_disconnect() call site. The disconnect actually
causes more problems than it solves, and SQ overruns happen only as
a result of software bugs. So remove it.

Fixes: d7a21c1bed54 ("xprtrdma: Reset MRs in frwr_op_unmap_sync()")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 97f9f85..24631e0 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -521,12 +521,13 @@
 	 * unless ri_id->qp is a valid pointer.
 	 */
 	r_xprt->rx_stats.local_inv_needed++;
+	bad_wr = NULL;
 	rc = ib_post_send(ia->ri_id->qp, first, &bad_wr);
+	if (bad_wr != first)
+		wait_for_completion(&f->fr_linv_done);
 	if (rc)
 		goto reset_mrs;
 
-	wait_for_completion(&f->fr_linv_done);
-
 	/* ORDER: Now DMA unmap all of the MRs, and return
 	 * them to the free MW list.
 	 */
@@ -543,17 +544,19 @@
 
 reset_mrs:
 	pr_err("rpcrdma: FRMR invalidate ib_post_send returned %i\n", rc);
-	rdma_disconnect(ia->ri_id);
 
 	/* Find and reset the MRs in the LOCAL_INV WRs that did not
-	 * get posted. This is synchronous, and slow.
+	 * get posted.
 	 */
-	list_for_each_entry(mw, mws, mw_list) {
-		f = &mw->frmr;
-		if (mw->mw_handle == bad_wr->ex.invalidate_rkey) {
-			__frwr_reset_mr(ia, mw);
-			bad_wr = bad_wr->next;
-		}
+	rpcrdma_init_cqcount(&r_xprt->rx_ep, -count);
+	while (bad_wr) {
+		f = container_of(bad_wr, struct rpcrdma_frmr,
+				 fr_invwr);
+		mw = container_of(f, struct rpcrdma_mw, frmr);
+
+		__frwr_reset_mr(ia, mw);
+
+		bad_wr = bad_wr->next;
 	}
 	goto unmap;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
