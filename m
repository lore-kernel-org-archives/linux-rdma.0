From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 15/18] xprtrdma: Refactor __fmr_dma_unmap()
Date: Mon, 11 Apr 2016 16:12:14 -0400
Message-ID: <20160411201214.20531.91348.stgit@manet.1015granger.net>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160411200323.20531.8893.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Separate the DMA unmap operation from freeing the MW. In a
subsequent patch they will not always be done at the same time,
and they are not related operations (except by order; freeing
the MW must be the last step during invalidation).

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index 009694b..9d50f3a 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -186,15 +186,10 @@ static void
 __fmr_dma_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
 {
 	struct ib_device *device = r_xprt->rx_ia.ri_device;
-	struct rpcrdma_mw *mw = seg->rl_mw;
 	int nsegs = seg->mr_nsegs;
 
-	seg->rl_mw = NULL;
-
 	while (nsegs--)
 		rpcrdma_unmap_one(device, seg++);
-
-	rpcrdma_put_mw(r_xprt, mw);
 }
 
 /* Invalidate all memory regions that were registered for "req".
@@ -237,9 +232,11 @@ fmr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
 		seg = &req->rl_segments[i];
 
 		__fmr_dma_unmap(r_xprt, seg);
+		rpcrdma_put_mw(r_xprt, seg->rl_mw);
 
 		i += seg->mr_nsegs;
 		seg->mr_nsegs = 0;
+		seg->rl_mw = NULL;
 	}
 
 	req->rl_nchunks = 0;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
