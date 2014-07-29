From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 01/21] xprtrdma: Fix panic in
 rpcrdma_register_frmr_external()
Date: Tue, 29 Jul 2014 17:23:17 -0400
Message-ID: <20140729212317.2812.84498.stgit@manet.1015granger.net>
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

seg1->mr_nsegs is not yet initialized when it is used to unmap
segments during an error exit. Use the same unmapping logic for
all error exits.

"if (frmr_wr.wr.fast_reg.length < len) {" used to be a BUG_ON check.
The broken code will never be executed under normal operation.

Fixes: c977dea (xprtrdma: Remove BUG_ON() call sites)
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 13dbd1c..78bd7c6 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1545,9 +1545,8 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	frmr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
 	frmr_wr.wr.fast_reg.length = page_no << PAGE_SHIFT;
 	if (frmr_wr.wr.fast_reg.length < len) {
-		while (seg1->mr_nsegs--)
-			rpcrdma_unmap_one(ia, seg++);
-		return -EIO;
+		rc = -EIO;
+		goto out_err;
 	}
 
 	/* Bump the key */
@@ -1565,8 +1564,7 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 	if (rc) {
 		dprintk("RPC:       %s: failed ib_post_send for register,"
 			" status %i\n", __func__, rc);
-		while (i--)
-			rpcrdma_unmap_one(ia, --seg);
+		goto out_err;
 	} else {
 		seg1->mr_rkey = seg1->mr_chunk.rl_mw->r.frmr.fr_mr->rkey;
 		seg1->mr_base = seg1->mr_dma + pageoff;
@@ -1574,6 +1572,10 @@ rpcrdma_register_frmr_external(struct rpcrdma_mr_seg *seg,
 		seg1->mr_len = len;
 	}
 	*nsegs = i;
+	return 0;
+out_err:
+	while (i--)
+		rpcrdma_unmap_one(ia, --seg);
 	return rc;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
