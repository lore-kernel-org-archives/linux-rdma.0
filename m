From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 03/13] svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
Date: Mon, 27 Mar 2017 09:48:19 -0400
Message-ID: <20170327134819.5585.90071.stgit@klimt.1015granger.net>
References: <20170327132329.5585.98465.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170327132329.5585.98465.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Send Queue depth is temporarily reduced to 1 SQE per credit. The
new rdma_rw API does an internal computation, during QP creation, to
increase the depth of the Send Queue to handle RDMA Read and Write
operations.

This change has to come before the NFSD code paths are updated to
use the rdma_rw API. Without this patch, rdma_rw_init_qp() increases
the size of the SQ too much, resulting in memory allocation failures
during QP creation.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    1 -
 net/sunrpc/xprtrdma/svc_rdma.c           |    2 --
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index ac05495..f066349 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -182,7 +182,6 @@ struct svcxprt_rdma {
 /* The default ORD value is based on two outstanding full-size writes with a
  * page size of 4k, or 32k * 2 ops / 4k = 16 outstanding RDMA_READ.  */
 #define RPCRDMA_ORD             (64/4)
-#define RPCRDMA_SQ_DEPTH_MULT   8
 #define RPCRDMA_MAX_REQUESTS    32
 #define RPCRDMA_MAX_REQ_SIZE    4096
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index c846ca9..9124441 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -247,8 +247,6 @@ int svc_rdma_init(void)
 	dprintk("SVCRDMA Module Init, register RPC RDMA transport\n");
 	dprintk("\tsvcrdma_ord      : %d\n", svcrdma_ord);
 	dprintk("\tmax_requests     : %u\n", svcrdma_max_requests);
-	dprintk("\tsq_depth         : %u\n",
-		svcrdma_max_requests * RPCRDMA_SQ_DEPTH_MULT);
 	dprintk("\tmax_bc_requests  : %u\n", svcrdma_max_bc_requests);
 	dprintk("\tmax_inline       : %d\n", svcrdma_max_req_size);
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index c13a5c3..b84cd53 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1013,7 +1013,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 					    svcrdma_max_bc_requests);
 	newxprt->sc_rq_depth = newxprt->sc_max_requests +
 			       newxprt->sc_max_bc_requests;
-	newxprt->sc_sq_depth = RPCRDMA_SQ_DEPTH_MULT * newxprt->sc_rq_depth;
+	newxprt->sc_sq_depth = newxprt->sc_rq_depth;
 	atomic_set(&newxprt->sc_sq_avail, newxprt->sc_sq_depth);
 
 	if (!svc_rdma_prealloc_ctxts(newxprt))

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
