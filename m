From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 3/3] xprtrdma: Remove ro_unmap_safe
Date: Mon, 09 Oct 2017 12:03:42 -0400
Message-ID: <20171009160342.18726.6012.stgit@manet.1015granger.net>
References: <20171009155524.18726.32086.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171009155524.18726.32086.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: There are no remaining callers of this method.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c   |   19 -------------------
 net/sunrpc/xprtrdma/frwr_ops.c  |   19 -------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 --
 3 files changed, 40 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 6c71513..30bf713 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -305,28 +305,9 @@ enum {
 	}
 }
 
-/* Use a slow, safe mechanism to invalidate all memory regions
- * that were registered for "req".
- */
-static void
-fmr_op_unmap_safe(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req,
-		  bool sync)
-{
-	struct rpcrdma_mw *mw;
-
-	while (!list_empty(&req->rl_registered)) {
-		mw = rpcrdma_pop_mw(&req->rl_registered);
-		if (sync)
-			fmr_op_recover_mr(mw);
-		else
-			rpcrdma_defer_mr_recovery(mw);
-	}
-}
-
 const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops = {
 	.ro_map				= fmr_op_map,
 	.ro_unmap_sync			= fmr_op_unmap_sync,
-	.ro_unmap_safe			= fmr_op_unmap_safe,
 	.ro_recover_mr			= fmr_op_recover_mr,
 	.ro_open			= fmr_op_open,
 	.ro_maxpages			= fmr_op_maxpages,
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index df062e0..3053fb0 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -558,28 +558,9 @@
 	goto unmap;
 }
 
-/* Use a slow, safe mechanism to invalidate all memory regions
- * that were registered for "req".
- */
-static void
-frwr_op_unmap_safe(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req,
-		   bool sync)
-{
-	struct rpcrdma_mw *mw;
-
-	while (!list_empty(&req->rl_registered)) {
-		mw = rpcrdma_pop_mw(&req->rl_registered);
-		if (sync)
-			frwr_op_recover_mr(mw);
-		else
-			rpcrdma_defer_mr_recovery(mw);
-	}
-}
-
 const struct rpcrdma_memreg_ops rpcrdma_frwr_memreg_ops = {
 	.ro_map				= frwr_op_map,
 	.ro_unmap_sync			= frwr_op_unmap_sync,
-	.ro_unmap_safe			= frwr_op_unmap_safe,
 	.ro_recover_mr			= frwr_op_recover_mr,
 	.ro_open			= frwr_op_open,
 	.ro_maxpages			= frwr_op_maxpages,
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index e26a97d..74e0174 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -473,8 +473,6 @@ struct rpcrdma_memreg_ops {
 				  struct rpcrdma_mw **);
 	void		(*ro_unmap_sync)(struct rpcrdma_xprt *,
 					 struct list_head *);
-	void		(*ro_unmap_safe)(struct rpcrdma_xprt *,
-					 struct rpcrdma_req *, bool);
 	void		(*ro_recover_mr)(struct rpcrdma_mw *);
 	int		(*ro_open)(struct rpcrdma_ia *,
 				   struct rpcrdma_ep *,

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
