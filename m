From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 11/17] xprtrdma: Simplify rpcrdma_deregister_external()
	synopsis
Date: Mon, 21 Apr 2014 18:02:22 -0400
Message-ID: <20140421220222.12569.19405.stgit@manet.1015granger.net>
References: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140421214442.12569.8950.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: All remaining callers of rpcrdma_deregister_external()
pass NULL as the last argument, so remove that argument.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/rpc_rdma.c  |    2 +-
 net/sunrpc/xprtrdma/transport.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c     |    8 +-------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 +-
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index a38efda..315417d 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -273,7 +273,7 @@ rpcrdma_create_chunks(struct rpc_rqst *rqst, struct xdr_buf *target,
 out:
 	for (pos = 0; nchunks--;)
 		pos += rpcrdma_deregister_external(
-				&req->rl_segments[pos], r_xprt, NULL);
+				&req->rl_segments[pos], r_xprt);
 	return 0;
 }
 
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 4607b62..6a47193 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -575,7 +575,7 @@ xprt_rdma_free(void *buffer)
 	for (i = 0; req->rl_nchunks;) {
 		--req->rl_nchunks;
 		i += rpcrdma_deregister_external(
-			&req->rl_segments[i], r_xprt, NULL);
+			&req->rl_segments[i], r_xprt);
 	}
 
 	if (req->rl_iov.length == 0) {	/* see allocate above */
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 9b71896..7a8a1bf 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1632,7 +1632,7 @@ rpcrdma_register_external(struct rpcrdma_mr_seg *seg,
 
 int
 rpcrdma_deregister_external(struct rpcrdma_mr_seg *seg,
-		struct rpcrdma_xprt *r_xprt, void *r)
+		struct rpcrdma_xprt *r_xprt)
 {
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 	int nsegs = seg->mr_nsegs, rc;
@@ -1658,12 +1658,6 @@ rpcrdma_deregister_external(struct rpcrdma_mr_seg *seg,
 	default:
 		break;
 	}
-	if (r) {
-		struct rpcrdma_rep *rep = r;
-		void (*func)(struct rpcrdma_rep *) = rep->rr_func;
-		rep->rr_func = NULL;
-		func(rep);	/* dereg done, callback now */
-	}
 	return nsegs;
 }
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index bf08ee0..3f44d6a 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -331,7 +331,7 @@ int rpcrdma_deregister_internal(struct rpcrdma_ia *,
 int rpcrdma_register_external(struct rpcrdma_mr_seg *,
 				int, int, struct rpcrdma_xprt *);
 int rpcrdma_deregister_external(struct rpcrdma_mr_seg *,
-				struct rpcrdma_xprt *, void *);
+				struct rpcrdma_xprt *);
 
 /*
  * RPC/RDMA connection management calls - xprtrdma/rpc_rdma.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
