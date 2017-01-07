From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 15/22] svcrdma: Clean up RPC-over-RDMA backchannel reply
 processing
Date: Sat, 07 Jan 2017 12:17:19 -0500
Message-ID: <20170107171719.14126.10512.stgit@klimt.1015granger.net>
References: <20170107170258.14126.8503.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170107170258.14126.8503.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Replace C structure-based XDR decoding with pointer arithmetic.
Pointer arithmetic is considered more portable.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h            |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   17 +++++++++++++----
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   27 +++++++++++++++------------
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 531980b..9866e94 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -184,7 +184,7 @@ static inline void svc_rdma_count_mappings(struct svcxprt_rdma *rdma,
 
 /* svc_rdma_backchannel.c */
 extern int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt,
-				    struct rpcrdma_msg *rmsgp,
+				    __be32 *rdma_resp,
 				    struct xdr_buf *rcvbuf);
 
 /* svc_rdma_marshal.c */
diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 7d49545..6b3bbb6 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -11,7 +11,16 @@
 
 #undef SVCRDMA_BACKCHANNEL_DEBUG
 
-int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, struct rpcrdma_msg *rmsgp,
+/**
+ * svc_rdma_handle_bc_reply - Process incoming backchannel reply
+ * @xprt: controlling backchannel transport
+ * @rdma_resp: pointer to incoming transport header
+ * @rcvbuf: XDR buffer into which to decode the reply
+ *
+ * Returns zero and fills @rcvbuf if successful. Otherwise a
+ * negative errno is returned.
+ */
+int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, __be32 *rdma_resp,
 			     struct xdr_buf *rcvbuf)
 {
 	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(xprt);
@@ -26,13 +35,13 @@ int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, struct rpcrdma_msg *rmsgp,
 
 	p = (__be32 *)src->iov_base;
 	len = src->iov_len;
-	xid = rmsgp->rm_xid;
+	xid = *rdma_resp;
 
 #ifdef SVCRDMA_BACKCHANNEL_DEBUG
 	pr_info("%s: xid=%08x, length=%zu\n",
 		__func__, be32_to_cpu(xid), len);
 	pr_info("%s: RPC/RDMA: %*ph\n",
-		__func__, (int)RPCRDMA_HDRLEN_MIN, rmsgp);
+		__func__, (int)RPCRDMA_HDRLEN_MIN, rdma_resp);
 	pr_info("%s:      RPC: %*ph\n",
 		__func__, (int)len, p);
 #endif
@@ -52,7 +61,7 @@ int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, struct rpcrdma_msg *rmsgp,
 		goto out_unlock;
 	memcpy(dst->iov_base, p, len);
 
-	credits = be32_to_cpu(rmsgp->rm_credit);
+	credits = be32_to_cpup(rdma_resp + 2);
 	if (credits == 0)
 		credits = 1;	/* don't deadlock */
 	else if (credits > r_xprt->rx_buf.rb_bc_max_requests)
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index f1b5bbf..c9ea2e9 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -565,28 +565,30 @@ static void rdma_read_complete(struct svc_rqst *rqstp,
  * the RPC/RDMA header small and fixed in size, so it is
  * straightforward to check the RPC header's direction field.
  */
-static bool
-svc_rdma_is_backchannel_reply(struct svc_xprt *xprt, struct rpcrdma_msg *rmsgp)
+static bool svc_rdma_is_backchannel_reply(struct svc_xprt *xprt,
+					  __be32 *rdma_resp)
 {
-	__be32 *p = (__be32 *)rmsgp;
+	__be32 *p;
 
 	if (!xprt->xpt_bc_xprt)
 		return false;
 
-	if (rmsgp->rm_type != rdma_msg)
+	p = rdma_resp + 3;
+	if (*p++ != rdma_msg)
 		return false;
-	if (rmsgp->rm_body.rm_chunks[0] != xdr_zero)
+
+	if (*p++ != xdr_zero)
 		return false;
-	if (rmsgp->rm_body.rm_chunks[1] != xdr_zero)
+	if (*p++ != xdr_zero)
 		return false;
-	if (rmsgp->rm_body.rm_chunks[2] != xdr_zero)
+	if (*p++ != xdr_zero)
 		return false;
 
-	/* sanity */
-	if (p[7] != rmsgp->rm_xid)
+	/* XID sanity */
+	if (*p++ != *rdma_resp)
 		return false;
 	/* call direction */
-	if (p[8] == cpu_to_be32(RPC_CALL))
+	if (*p == cpu_to_be32(RPC_CALL))
 		return false;
 
 	return true;
@@ -652,8 +654,9 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		goto out_drop;
 	rqstp->rq_xprt_hlen = ret;
 
-	if (svc_rdma_is_backchannel_reply(xprt, rmsgp)) {
-		ret = svc_rdma_handle_bc_reply(xprt->xpt_bc_xprt, rmsgp,
+	if (svc_rdma_is_backchannel_reply(xprt, (__be32 *)rmsgp)) {
+		ret = svc_rdma_handle_bc_reply(xprt->xpt_bc_xprt,
+					       (__be32 *)rmsgp,
 					       &rqstp->rq_arg);
 		svc_rdma_put_context(ctxt, 0);
 		if (ret)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
