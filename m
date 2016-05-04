From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 9/9] svcrdma: Simplify the check for backward direction
 replies
Date: Wed, 04 May 2016 10:53:55 -0400
Message-ID: <20160504145355.6602.64946.stgit@klimt.1015granger.net>
References: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504144730.6602.89073.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: rq_arg.head[0] already points to the RPC header. No need
to walk down the RPC-over-RDMA header again.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index c984b0a..f30a43b 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -549,35 +549,24 @@ static void rdma_read_complete(struct svc_rqst *rqstp,
 	rqstp->rq_arg.buflen = head->arg.buflen;
 }
 
-/* By convention, backchannel calls arrive via rdma_msg type
- * messages, and never populate the chunk lists. This makes
- * the RPC/RDMA header small and fixed in size, so it is
- * straightforward to check the RPC header's direction field.
+/* Currently, this implementation does not support chunks in the
+ * backward direction. Thus only RDMA_MSG bc replies are accepted.
  */
 static bool
-svc_rdma_is_backchannel_reply(struct svc_xprt *xprt, struct rpcrdma_msg *rmsgp)
+svc_rdma_is_backchannel_reply(struct svc_xprt *xprt, struct rpcrdma_msg *rmsgp,
+			      struct xdr_buf *msgp)
 {
-	__be32 *p = (__be32 *)rmsgp;
+	__be32 *p = (__be32 *)msgp->head[0].iov_base;
 
+	/* Is there a backchannel transport associated with xprt? */
 	if (!xprt->xpt_bc_xprt)
 		return false;
-
+	/* Is there an RPC message in the inline buffer? */
 	if (rmsgp->rm_type != rdma_msg)
 		return false;
-	if (rmsgp->rm_body.rm_chunks[0] != xdr_zero)
-		return false;
-	if (rmsgp->rm_body.rm_chunks[1] != xdr_zero)
+	/* Is that message a Call or a Reply? */
+	if (p[1] != cpu_to_be32(RPC_REPLY))
 		return false;
-	if (rmsgp->rm_body.rm_chunks[2] != xdr_zero)
-		return false;
-
-	/* sanity */
-	if (p[7] != rmsgp->rm_xid)
-		return false;
-	/* call direction */
-	if (p[8] == cpu_to_be32(RPC_CALL))
-		return false;
-
 	return true;
 }
 
@@ -643,7 +632,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 		goto out_drop;
 	rqstp->rq_xprt_hlen = ret;
 
-	if (svc_rdma_is_backchannel_reply(xprt, rmsgp)) {
+	if (svc_rdma_is_backchannel_reply(xprt, rmsgp, &rqstp->rq_arg)) {
 		ret = svc_rdma_handle_bc_reply(xprt->xpt_bc_xprt, rmsgp,
 					       &rqstp->rq_arg);
 		svc_rdma_put_context(ctxt, 0);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
