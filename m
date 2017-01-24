From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 4/7] svcrdma: Clean up backchannel send header encoding
Date: Tue, 24 Jan 2017 15:35:03 -0500
Message-ID: <20170124203503.11807.89180.stgit@klimt.1015granger.net>
References: <20170124193242.11807.91861.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170124193242.11807.91861.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Replace C structure-based XDR decoding with pointer arithmetic.
Pointer arithmetic is considered more portable.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 288e35c..abfce04 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -200,19 +200,20 @@ static int svc_rdma_bc_sendto(struct svcxprt_rdma *rdma,
 {
 	struct rpc_xprt *xprt = rqst->rq_xprt;
 	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(xprt);
-	struct rpcrdma_msg *headerp = (struct rpcrdma_msg *)rqst->rq_buffer;
+	__be32 *p;
 	int rc;
 
 	/* Space in the send buffer for an RPC/RDMA header is reserved
 	 * via xprt->tsh_size.
 	 */
-	headerp->rm_xid = rqst->rq_xid;
-	headerp->rm_vers = rpcrdma_version;
-	headerp->rm_credit = cpu_to_be32(r_xprt->rx_buf.rb_bc_max_requests);
-	headerp->rm_type = rdma_msg;
-	headerp->rm_body.rm_chunks[0] = xdr_zero;
-	headerp->rm_body.rm_chunks[1] = xdr_zero;
-	headerp->rm_body.rm_chunks[2] = xdr_zero;
+	p = (__be32 *)rqst->rq_buffer;
+	*p++ = rqst->rq_xid;
+	*p++ = rpcrdma_version;
+	*p++ = cpu_to_be32(r_xprt->rx_buf.rb_bc_max_requests);
+	*p++ = rdma_msg;
+	*p++ = xdr_zero;
+	*p++ = xdr_zero;
+	*p = xdr_zero;
 
 #ifdef SVCRDMA_BACKCHANNEL_DEBUG
 	pr_info("%s: %*ph\n", __func__, 64, rqst->rq_buffer);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
