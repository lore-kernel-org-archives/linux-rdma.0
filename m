From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 16/18] svcrdma: Add infrastructure to send backwards
 direction RPC/RDMA calls
Date: Thu, 17 Sep 2015 16:46:22 -0400
Message-ID: <20150917204622.19671.71471.stgit@manet.1015granger.net>
References: <20150917202829.19671.90044.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917202829.19671.90044.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

To support the NFSv4.1 backchannel on RDMA connections, add a
mechanism for sending a backwards-direction RPC/RDMA call on a
connection established by a client.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h       |    2 +
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   63 +++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 2500dd1..42262dd 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -216,6 +216,8 @@ extern int rdma_read_chunk_frmr(struct svcxprt_rdma *, struct svc_rqst *,
 extern int svc_rdma_sendto(struct svc_rqst *);
 extern struct rpcrdma_read_chunk *
 	svc_rdma_get_read_chunk(struct rpcrdma_msg *);
+extern int svc_rdma_bc_post_send(struct svcxprt_rdma *,
+				 struct svc_rdma_op_ctxt *, struct xdr_buf *);
 
 /* svc_rdma_transport.c */
 extern int svc_rdma_send(struct svcxprt_rdma *, struct ib_send_wr *);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 1dfae83..0bda3a5 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -641,3 +641,66 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	svc_rdma_put_context(ctxt, 0);
 	return ret;
 }
+
+#if defined(CONFIG_SUNRPC_BACKCHANNEL)
+/* Send a backwards direction RPC call.
+ *
+ * Caller holds the connection's mutex and has already marshaled the
+ * RPC/RDMA request. Before sending the request, this API also posts
+ * an extra receive buffer to catch the bc reply for this request.
+ */
+int svc_rdma_bc_post_send(struct svcxprt_rdma *rdma,
+			  struct svc_rdma_op_ctxt *ctxt, struct xdr_buf *sndbuf)
+{
+	struct svc_rdma_req_map *vec;
+	struct ib_send_wr send_wr;
+	int ret;
+
+	vec = svc_rdma_get_req_map();
+	ret = map_xdr(rdma, sndbuf, vec);
+	if (ret)
+		goto out;
+
+	/* Post a recv buffer to handle reply for this request */
+	ret = svc_rdma_post_recv(rdma);
+	if (ret) {
+		pr_err("svcrdma: Failed to post bc receive buffer, err=%d. "
+		       "Closing transport %p.\n", ret, rdma);
+		set_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags);
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	ctxt->wr_op = IB_WR_SEND;
+	ctxt->direction = DMA_TO_DEVICE;
+	ctxt->sge[0].lkey = rdma->sc_dma_lkey;
+	ctxt->sge[0].length = sndbuf->len;
+	ctxt->sge[0].addr =
+	    ib_dma_map_page(rdma->sc_cm_id->device, ctxt->pages[0], 0,
+			    sndbuf->len, DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(rdma->sc_cm_id->device, ctxt->sge[0].addr)) {
+		svc_rdma_unmap_dma(ctxt);
+		ret = -EIO;
+		goto out;
+	}
+	atomic_inc(&rdma->sc_dma_used);
+
+	memset(&send_wr, 0, sizeof send_wr);
+	send_wr.wr_id = (unsigned long)ctxt;
+	send_wr.sg_list = ctxt->sge;
+	send_wr.num_sge = 1;
+	send_wr.opcode = IB_WR_SEND;
+	send_wr.send_flags = IB_SEND_SIGNALED;
+
+	ret = svc_rdma_send(rdma, &send_wr);
+	if (ret) {
+		svc_rdma_unmap_dma(ctxt);
+		ret = -EIO;
+		goto out;
+	}
+out:
+	svc_rdma_put_req_map(vec);
+	pr_info("svcrdma: %s returns %d\n", __func__, ret);
+	return ret;
+}
+#endif	/* CONFIG_SUNRPC_BACKCHANNEL */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
