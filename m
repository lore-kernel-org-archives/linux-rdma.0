From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 08/15] xprtrdma: Account for RPC/RDMA header size when
 deciding to inline
Date: Mon, 20 Jul 2015 15:03:39 -0400
Message-ID: <20150720190339.10997.67723.stgit@manet.1015granger.net>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150720185624.10997.51574.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the size of the RPC message is near the inline threshold (1KB),
the client would allow messages to be sent that were a few bytes too
large.

When marshaling RPC/RDMA requests, ensure the combined size of
RPC/RDMA header and RPC header do not exceed the inline threshold.
Endpoints typically reject RPC/RDMA messages that exceed the size
of their receive buffers.

The two server implementations I test with (Linux and Solaris) use
receive buffers that are larger than the client=E2=80=99s inline thresh=
old.
Thus so far this has been benign, observed only by code inspection.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_r=
dma.c
index 8e9c564..950b654 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -71,6 +71,31 @@ static const char transfertypes[][12] =3D {
 };
 #endif
=20
+/* The client can send a request inline as long as the RPCRDMA header
+ * plus the RPC call fit under the transport's inline limit. If the
+ * combined call message size exceeds that limit, the client must use
+ * the read chunk list for this operation.
+ */
+static bool rpcrdma_args_inline(struct rpc_rqst *rqst)
+{
+	unsigned int callsize =3D RPCRDMA_HDRLEN_MIN + rqst->rq_snd_buf.len;
+
+	return callsize <=3D RPCRDMA_INLINE_WRITE_THRESHOLD(rqst);
+}
+
+/* The client can't know how large the actual reply will be. Thus it
+ * plans for the largest possible reply for that particular ULP
+ * operation. If the maximum combined reply message size exceeds that
+ * limit, the client must provide a write list or a reply chunk for
+ * this request.
+ */
+static bool rpcrdma_results_inline(struct rpc_rqst *rqst)
+{
+	unsigned int repsize =3D RPCRDMA_HDRLEN_MIN + rqst->rq_rcv_buf.buflen=
;
+
+	return repsize <=3D RPCRDMA_INLINE_READ_THRESHOLD(rqst);
+}
+
 /*
  * Chunk assembly from upper layer xdr_buf.
  *
@@ -409,7 +434,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 	 * a READ, then use write chunks to separate the file data
 	 * into pages; otherwise use reply chunks.
 	 */
-	if (rqst->rq_rcv_buf.buflen <=3D RPCRDMA_INLINE_READ_THRESHOLD(rqst))
+	if (rpcrdma_results_inline(rqst))
 		wtype =3D rpcrdma_noch;
 	else if (rqst->rq_rcv_buf.page_len =3D=3D 0)
 		wtype =3D rpcrdma_replych;
@@ -432,7 +457,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 	 * implies the op is a write.
 	 * TBD check NFSv4 setacl
 	 */
-	if (rqst->rq_snd_buf.len <=3D RPCRDMA_INLINE_WRITE_THRESHOLD(rqst))
+	if (rpcrdma_args_inline(rqst))
 		rtype =3D rpcrdma_noch;
 	else if (rqst->rq_snd_buf.page_len =3D=3D 0)
 		rtype =3D rpcrdma_areadch;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
