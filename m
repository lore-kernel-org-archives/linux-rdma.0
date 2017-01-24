From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 2/7] svcrdma: Clean up RPC-over-RDMA Reply header encoder
Date: Tue, 24 Jan 2017 15:34:46 -0500
Message-ID: <20170124203446.11807.20700.stgit@klimt.1015granger.net>
References: <20170124193242.11807.91861.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170124193242.11807.91861.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Replace C structure-based XDR decoding with pointer arithmetic.
Pointer arithmetic is considered more portable, and is used
throughout the kernel's existing XDR encoders. The gcc optimizer
generates similar assembler code either way.

Byte-swapping before a memory store on x86 typically results in an
instruction pipeline stall. Avoid byte-swapping when encoding a new
header.

svcrdma currently doesn't alter a connection's credit grant value
after the connection has been accepted, so it is effectively a
constant. Cache the byte-swapped value in a separate field.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |   11 +++++---
 net/sunrpc/xprtrdma/svc_rdma_marshal.c   |   39 +++++++++++++++++++-----------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   10 ++------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    1 +
 4 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 551c518..5549bdb 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -141,7 +141,8 @@ struct svcxprt_rdma {
 	atomic_t             sc_sq_avail;	/* SQEs ready to be consumed */
 	unsigned int	     sc_sq_depth;	/* Depth of SQ */
 	unsigned int	     sc_rq_depth;	/* Depth of RQ */
-	u32		     sc_max_requests;	/* Forward credits */
+	__be32		     sc_fc_credits;	/* Forward credits */
+	u32		     sc_max_requests;	/* Max requests */
 	u32		     sc_max_bc_requests;/* Backward credits */
 	int                  sc_max_req_size;	/* Size of each RQ WR buf */
 
@@ -214,10 +215,10 @@ extern int svc_rdma_xdr_encode_error(struct svcxprt_rdma *,
 extern void svc_rdma_xdr_encode_reply_array(struct rpcrdma_write_array *, int);
 extern void svc_rdma_xdr_encode_array_chunk(struct rpcrdma_write_array *, int,
 					    __be32, __be64, u32);
-extern void svc_rdma_xdr_encode_reply_header(struct svcxprt_rdma *,
-					     struct rpcrdma_msg *,
-					     struct rpcrdma_msg *,
-					     enum rpcrdma_proc);
+extern void svc_rdma_xdr_encode_reply_header(struct svcxprt_rdma *rdma,
+					     __be32 *rdma_argp,
+					     __be32 *rdma_resp,
+					     __be32 rdma_type);
 extern unsigned int svc_rdma_xdr_get_reply_hdr_len(__be32 *rdma_resp);
 
 /* svc_rdma_recvfrom.c */
diff --git a/net/sunrpc/xprtrdma/svc_rdma_marshal.c b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
index 4e72034..5efa019 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_marshal.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_marshal.c
@@ -249,7 +249,7 @@ int svc_rdma_xdr_encode_error(struct svcxprt_rdma *xprt,
 
 	*va++ = rmsgp->rm_xid;
 	*va++ = rmsgp->rm_vers;
-	*va++ = cpu_to_be32(xprt->sc_max_requests);
+	*va++ = xprt->sc_fc_credits;
 	*va++ = rdma_error;
 	*va++ = cpu_to_be32(err);
 	if (err == ERR_VERS) {
@@ -330,18 +330,29 @@ void svc_rdma_xdr_encode_array_chunk(struct rpcrdma_write_array *ary,
 	seg->rs_length = cpu_to_be32(write_len);
 }
 
-void svc_rdma_xdr_encode_reply_header(struct svcxprt_rdma *xprt,
-				  struct rpcrdma_msg *rdma_argp,
-				  struct rpcrdma_msg *rdma_resp,
-				  enum rpcrdma_proc rdma_type)
+/**
+ * svc_rdma_xdr_encode_reply_header - Encode Reply's fixed header fields
+ * @rdma: controlling transport
+ * @rdma_argp: Call's transport header
+ * @rdma_resp: Reply's transport header
+ * @rdma_type: procedure number
+ *
+ */
+void svc_rdma_xdr_encode_reply_header(struct svcxprt_rdma *rdma,
+				      __be32 *rdma_argp, __be32 *rdma_resp,
+				      __be32 rdma_type)
 {
-	rdma_resp->rm_xid = rdma_argp->rm_xid;
-	rdma_resp->rm_vers = rdma_argp->rm_vers;
-	rdma_resp->rm_credit = cpu_to_be32(xprt->sc_max_requests);
-	rdma_resp->rm_type = cpu_to_be32(rdma_type);
-
-	/* Encode <nul> chunks lists */
-	rdma_resp->rm_body.rm_chunks[0] = xdr_zero;
-	rdma_resp->rm_body.rm_chunks[1] = xdr_zero;
-	rdma_resp->rm_body.rm_chunks[2] = xdr_zero;
+	__be32 *p;
+
+	p = rdma_resp;
+
+	*p++ = *rdma_argp;		/* XID */
+	*p++ = *(rdma_argp + 1);	/* vers */
+	*p++ = rdma->sc_fc_credits;
+	*p++ = rdma_type;
+
+	/* Start with empty chunks */
+	*p++ = xdr_zero;
+	*p++ = xdr_zero;
+	*p = xdr_zero;
 }
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index ba76f1617..5953274 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -560,7 +560,6 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	struct rpcrdma_msg *rdma_argp;
 	struct rpcrdma_msg *rdma_resp;
 	struct rpcrdma_write_array *wr_ary, *rp_ary;
-	enum rpcrdma_proc reply_type;
 	int ret;
 	int inline_bytes;
 	struct page *res_page;
@@ -597,12 +596,9 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	if (!res_page)
 		goto err0;
 	rdma_resp = page_address(res_page);
-	if (rp_ary)
-		reply_type = RDMA_NOMSG;
-	else
-		reply_type = RDMA_MSG;
-	svc_rdma_xdr_encode_reply_header(rdma, rdma_argp,
-					 rdma_resp, reply_type);
+	svc_rdma_xdr_encode_reply_header(rdma, &rdma_argp->rm_xid,
+					 &rdma_resp->rm_xid,
+					 rp_ary ? rdma_nomsg : rdma_msg);
 
 	/* Send any write-chunk data and build resp write-list */
 	if (wr_ary) {
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index ca2799a..174928f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1002,6 +1002,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_req_size = svcrdma_max_req_size;
 	newxprt->sc_max_requests = min_t(u32, dev->attrs.max_qp_wr,
 					 svcrdma_max_requests);
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 	newxprt->sc_max_bc_requests = min_t(u32, dev->attrs.max_qp_wr,
 					    svcrdma_max_bc_requests);
 	newxprt->sc_rq_depth = newxprt->sc_max_requests +

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
