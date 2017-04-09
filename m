From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 02/14] svcrdma: Add svc_rdma_map_reply_hdr()
Date: Sun, 09 Apr 2017 13:05:44 -0400
Message-ID: <20170409170544.15073.80801.stgit@klimt.1015granger.net>
References: <20170409163820.15073.43257.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409163820.15073.43257.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce a helper to DMA-map a reply's transport header before
sending it. This will in part replace the map vector cache.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h            |    3 +
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   36 +++++------------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   61 ++++++++++++++++++++++------
 3 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 287db5c..002a46d 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -228,6 +228,9 @@ extern int rdma_read_chunk_frmr(struct svcxprt_rdma *, struct svc_rqst *,
 /* svc_rdma_sendto.c */
 extern int svc_rdma_map_xdr(struct svcxprt_rdma *, struct xdr_buf *,
 			    struct svc_rdma_req_map *, bool);
+extern int svc_rdma_map_reply_hdr(struct svcxprt_rdma *rdma,
+				  struct svc_rdma_op_ctxt *ctxt,
+				  __be32 *rdma_resp, unsigned int len);
 extern int svc_rdma_post_send_wr(struct svcxprt_rdma *rdma,
 				 struct svc_rdma_op_ctxt *ctxt,
 				 int num_sge, u32 inv_rkey);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index f12f39c..0305b33 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -101,50 +101,36 @@ int svc_rdma_handle_bc_reply(struct rpc_xprt *xprt, struct rpcrdma_msg *rmsgp,
 static int svc_rdma_bc_sendto(struct svcxprt_rdma *rdma,
 			      struct rpc_rqst *rqst)
 {
-	struct xdr_buf *sndbuf = &rqst->rq_snd_buf;
 	struct svc_rdma_op_ctxt *ctxt;
-	struct svc_rdma_req_map *vec;
 	int ret;
 
-	vec = svc_rdma_get_req_map(rdma);
-	ret = svc_rdma_map_xdr(rdma, sndbuf, vec, false);
-	if (ret)
+	ctxt = svc_rdma_get_context(rdma);
+
+	/* rpcrdma_bc_send_request builds the transport header and
+	 * the backchannel RPC message in the same buffer. Thus only
+	 * one SGE is needed to send both.
+	 */
+	ret = svc_rdma_map_reply_hdr(rdma, ctxt, rqst->rq_buffer,
+				     rqst->rq_snd_buf.len);
+	if (ret < 0)
 		goto out_err;
 
 	ret = svc_rdma_repost_recv(rdma, GFP_NOIO);
 	if (ret)
 		goto out_err;
 
-	ctxt = svc_rdma_get_context(rdma);
-	ctxt->pages[0] = virt_to_page(rqst->rq_buffer);
-	ctxt->count = 1;
-
-	ctxt->direction = DMA_TO_DEVICE;
-	ctxt->sge[0].lkey = rdma->sc_pd->local_dma_lkey;
-	ctxt->sge[0].length = sndbuf->len;
-	ctxt->sge[0].addr =
-	    ib_dma_map_page(rdma->sc_cm_id->device, ctxt->pages[0], 0,
-			    sndbuf->len, DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(rdma->sc_cm_id->device, ctxt->sge[0].addr)) {
-		ret = -EIO;
-		goto out_unmap;
-	}
-	svc_rdma_count_mappings(rdma, ctxt);
-
 	ret = svc_rdma_post_send_wr(rdma, ctxt, 1, 0);
-	if (ret) {
-		ret = -EIO;
+	if (ret)
 		goto out_unmap;
-	}
 
 out_err:
-	svc_rdma_put_req_map(rdma, vec);
 	dprintk("svcrdma: %s returns %d\n", __func__, ret);
 	return ret;
 
 out_unmap:
 	svc_rdma_unmap_dma(ctxt);
 	svc_rdma_put_context(ctxt, 1);
+	ret = -EIO;
 	goto out_err;
 }
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index f90b40d..a7dc71d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -217,6 +217,49 @@ static u32 svc_rdma_get_inv_rkey(struct rpcrdma_msg *rdma_argp,
 	return 0;
 }
 
+static int svc_rdma_dma_map_page(struct svcxprt_rdma *rdma,
+				 struct svc_rdma_op_ctxt *ctxt,
+				 unsigned int sge_no,
+				 struct page *page,
+				 unsigned int offset,
+				 unsigned int len)
+{
+	struct ib_device *dev = rdma->sc_cm_id->device;
+	dma_addr_t dma_addr;
+
+	dma_addr = ib_dma_map_page(dev, page, offset, len, DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(dev, dma_addr))
+		return -EIO;
+
+	ctxt->sge[sge_no].addr = dma_addr;
+	ctxt->sge[sge_no].length = len;
+	ctxt->sge[sge_no].lkey = rdma->sc_pd->local_dma_lkey;
+	svc_rdma_count_mappings(rdma, ctxt);
+	return 0;
+}
+
+/**
+ * svc_rdma_map_reply_hdr - DMA map the transport header buffer
+ * @rdma: controlling transport
+ * @ctxt: op_ctxt for the Send WR
+ * @rdma_resp: buffer containing transport header
+ * @len: length of transport header
+ *
+ * Returns:
+ *	%0 if the header is DMA mapped,
+ *	%-EIO if DMA mapping failed.
+ */
+int svc_rdma_map_reply_hdr(struct svcxprt_rdma *rdma,
+			   struct svc_rdma_op_ctxt *ctxt,
+			   __be32 *rdma_resp,
+			   unsigned int len)
+{
+	ctxt->direction = DMA_TO_DEVICE;
+	ctxt->pages[0] = virt_to_page(rdma_resp);
+	ctxt->count = 1;
+	return svc_rdma_dma_map_page(rdma, ctxt, 0, ctxt->pages[0], 0, len);
+}
+
 /* Assumptions:
  * - The specified write_len can be represented in sc_max_sge * PAGE_SIZE
  */
@@ -699,22 +742,14 @@ void svc_rdma_send_error(struct svcxprt_rdma *xprt, struct rpcrdma_msg *rmsgp,
 		err = ERR_VERS;
 	length = svc_rdma_xdr_encode_error(xprt, rmsgp, err, va);
 
+	/* Map transport header; no RPC message payload */
 	ctxt = svc_rdma_get_context(xprt);
-	ctxt->direction = DMA_TO_DEVICE;
-	ctxt->count = 1;
-	ctxt->pages[0] = p;
-
-	/* Prepare SGE for local address */
-	ctxt->sge[0].lkey = xprt->sc_pd->local_dma_lkey;
-	ctxt->sge[0].length = length;
-	ctxt->sge[0].addr = ib_dma_map_page(xprt->sc_cm_id->device,
-					    p, 0, length, DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(xprt->sc_cm_id->device, ctxt->sge[0].addr)) {
-		dprintk("svcrdma: Error mapping buffer for protocol error\n");
-		svc_rdma_put_context(ctxt, 1);
+	ret = svc_rdma_map_reply_hdr(xprt, ctxt, &rmsgp->rm_xid, length);
+	if (ret) {
+		dprintk("svcrdma: Error %d mapping send for protocol error\n",
+			ret);
 		return;
 	}
-	svc_rdma_count_mappings(xprt, ctxt);
 
 	ret = svc_rdma_post_send_wr(xprt, ctxt, 1, 0);
 	if (ret) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
