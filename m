From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 20/20] xprtrdma: Clean up after adding regbuf management
Date: Wed, 21 Jan 2015 11:04:41 -0500
Message-ID: <20150121160441.17297.77744.stgit@manet.1015granger.net>
References: <20150121155303.17297.47423.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150121155303.17297.47423.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rpcrdma_{de}register_internal() are used only in verbs.c now.

MAX_RPCRDMAHDR is no longer used and can be removed.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c     |    4 ++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    9 ---------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 8a05f45..124676c 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1729,7 +1729,7 @@ rpcrdma_recv_buffer_put(struct rpcrdma_rep *rep)
  * Wrappers for internal-use kmalloc memory registration, used by buffer code.
  */
 
-int
+static int
 rpcrdma_register_internal(struct rpcrdma_ia *ia, void *va, int len,
 				struct ib_mr **mrp, struct ib_sge *iov)
 {
@@ -1780,7 +1780,7 @@ rpcrdma_register_internal(struct rpcrdma_ia *ia, void *va, int len,
 	return rc;
 }
 
-int
+static int
 rpcrdma_deregister_internal(struct rpcrdma_ia *ia,
 				struct ib_mr *mr, struct ib_sge *iov)
 {
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 5630353..c9d2a02 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -171,10 +171,6 @@ enum rpcrdma_chunktype {
 /* temporary static scatter/gather max */
 #define RPCRDMA_MAX_DATA_SEGS	(64)	/* max scatter/gather */
 #define RPCRDMA_MAX_SEGS 	(RPCRDMA_MAX_DATA_SEGS + 2) /* head+tail = 2 */
-#define MAX_RPCRDMAHDR	(\
-	/* max supported RPC/RDMA header */ \
-	sizeof(struct rpcrdma_msg) + (2 * sizeof(u32)) + \
-	(sizeof(struct rpcrdma_read_chunk) * RPCRDMA_MAX_SEGS) + sizeof(u32))
 
 struct rpcrdma_buffer;
 
@@ -401,11 +397,6 @@ void rpcrdma_buffer_put(struct rpcrdma_req *);
 void rpcrdma_recv_buffer_get(struct rpcrdma_req *);
 void rpcrdma_recv_buffer_put(struct rpcrdma_rep *);
 
-int rpcrdma_register_internal(struct rpcrdma_ia *, void *, int,
-				struct ib_mr **, struct ib_sge *);
-int rpcrdma_deregister_internal(struct rpcrdma_ia *,
-				struct ib_mr *, struct ib_sge *);
-
 int rpcrdma_register_external(struct rpcrdma_mr_seg *,
 				int, int, struct rpcrdma_xprt *);
 int rpcrdma_deregister_external(struct rpcrdma_mr_seg *,

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
