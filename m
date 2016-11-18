From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 07/10] svcrdma: Remove unused variables in
 xprt_rdma_bc_allocate()
Date: Fri, 18 Nov 2016 10:11:06 -0500
Message-ID: <20161118151106.13658.40860.stgit@klimt.1015granger.net>
References: <20161118145940.13658.59105.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161118145940.13658.59105.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

/linux-2.6/net/sunrpc/xprtrdma/svc_rdma_backchannel.c: In function
 ‘xprt_rdma_bc_allocate’:
linux-2.6/net/sunrpc/xprtrdma/svc_rdma_backchannel.c:169:23: warning:
 variable ‘rdma’ set but not used [-Wunused-but-set-variable]
  struct svcxprt_rdma *rdma;
                       ^

Fixes: 5d252f90a800 ("svcrdma: Add class for RDMA backwards ...")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 6035c5a..288e35c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -164,13 +164,9 @@ static int svc_rdma_bc_sendto(struct svcxprt_rdma *rdma,
 xprt_rdma_bc_allocate(struct rpc_task *task)
 {
 	struct rpc_rqst *rqst = task->tk_rqstp;
-	struct svc_xprt *sxprt = rqst->rq_xprt->bc_xprt;
 	size_t size = rqst->rq_callsize;
-	struct svcxprt_rdma *rdma;
 	struct page *page;
 
-	rdma = container_of(sxprt, struct svcxprt_rdma, sc_xprt);
-
 	if (size > PAGE_SIZE) {
 		WARN_ONCE(1, "svcrdma: large bc buffer request (size %zu)\n",
 			  size);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
