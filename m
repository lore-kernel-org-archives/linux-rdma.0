From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 15/21] xprtrdma: Disable completions for LOCAL_INV Work
 Requests
Date: Tue, 15 Jul 2014 10:22:20 -0400
Message-ID: <20140715142220.8908.44603.stgit@manet.1015granger.net>
References: <20140715142020.8908.80969.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715142020.8908.80969.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of relying on a completion to change the state of an FRMR
to FRMR_IS_INVALID, set it in advance. If an error occurs, a completion
will fire anyway and mark the FRMR FRMR_IS_STALE.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index b36a5dd..fa5199d 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -154,12 +154,8 @@ rpcrdma_sendcq_process_wc(struct ib_wc *wc)
 
 	if (wc->wr_id == 0ULL)
 		return;
-	if (wc->status != IB_WC_SUCCESS) {
+	if (wc->status != IB_WC_SUCCESS)
 		frmr->r.frmr.fr_state = FRMR_IS_STALE;
-		return;
-	}
-
-	frmr->r.frmr.fr_state = FRMR_IS_INVALID;
 }
 
 static int
@@ -1369,12 +1365,11 @@ rpcrdma_retry_local_inv(struct rpcrdma_mw *r, struct rpcrdma_ia *ia)
 	dprintk("RPC:       %s: FRMR %p is stale\n", __func__, r);
 
 	/* When this FRMR is re-inserted into rb_mws, it is no longer stale */
-	r->r.frmr.fr_state = FRMR_IS_VALID;
+	r->r.frmr.fr_state = FRMR_IS_INVALID;
 
 	memset(&invalidate_wr, 0, sizeof(invalidate_wr));
 	invalidate_wr.wr_id = (unsigned long)(void *)r;
 	invalidate_wr.opcode = IB_WR_LOCAL_INV;
-	invalidate_wr.send_flags = IB_SEND_SIGNALED;
 	invalidate_wr.ex.invalidate_rkey = r->r.frmr.fr_mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
@@ -1773,10 +1768,11 @@ rpcrdma_deregister_frmr_external(struct rpcrdma_mr_seg *seg,
 	struct ib_send_wr invalidate_wr, *bad_wr;
 	int rc;
 
+	seg1->mr_chunk.rl_mw->r.frmr.fr_state = FRMR_IS_INVALID;
+
 	memset(&invalidate_wr, 0, sizeof invalidate_wr);
 	invalidate_wr.wr_id = (unsigned long)(void *)seg1->mr_chunk.rl_mw;
 	invalidate_wr.opcode = IB_WR_LOCAL_INV;
-	invalidate_wr.send_flags = IB_SEND_SIGNALED;
 	invalidate_wr.ex.invalidate_rkey = seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
 	DECR_CQCOUNT(&r_xprt->rx_ep);
 
@@ -1785,9 +1781,12 @@ rpcrdma_deregister_frmr_external(struct rpcrdma_mr_seg *seg,
 		rpcrdma_unmap_one(ia, seg++);
 	rc = ib_post_send(ia->ri_id->qp, &invalidate_wr, &bad_wr);
 	read_unlock(&ia->ri_qplock);
-	if (rc)
+	if (rc) {
+		/* Force rpcrdma_buffer_get() to retry */
+		seg1->mr_chunk.rl_mw->r.frmr.fr_state = FRMR_IS_STALE;
 		dprintk("RPC:       %s: failed ib_post_send for invalidate,"
 			" status %i\n", __func__, rc);
+	}
 	return rc;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
