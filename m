From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 14/14] svcrdma: Clean up svc_rdma_post_recv() error
 handling
Date: Thu, 16 Mar 2017 11:54:19 -0400
Message-ID: <20170316155419.4482.21602.stgit@klimt.1015granger.net>
References: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170316154132.4482.56769.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Distinguish and document failure modes.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   66 +++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 19 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 9176a35..95af982 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -486,6 +486,17 @@ static struct svcxprt_rdma *rdma_create_xprt(struct svc_serv *serv,
 	return cma_xprt;
 }
 
+/**
+ * svc_rdma_post_recv - Post one Receive buffer
+ * @xprt: controlling transport
+ * @flags: memory allocation flags
+ *
+ * Returns:
+ *	%0 if Receive was posted successfully,
+ *	%-EINVAL if arguments are not correct,
+ *	%-ENOMEM if a resource shortage occurred,
+ *	%-EIO if DMA mapping failed.
+ */
 int svc_rdma_post_recv(struct svcxprt_rdma *xprt, gfp_t flags)
 {
 	struct ib_recv_wr recv_wr, *bad_recv_wr;
@@ -501,14 +512,14 @@ int svc_rdma_post_recv(struct svcxprt_rdma *xprt, gfp_t flags)
 	ctxt->direction = DMA_FROM_DEVICE;
 	ctxt->cqe.done = svc_rdma_wc_receive;
 	for (sge_no = 0; buflen < xprt->sc_max_req_size; sge_no++) {
-		if (sge_no >= xprt->sc_max_sge) {
-			pr_err("svcrdma: Too many sges (%d)\n", sge_no);
-			goto err_put_ctxt;
-		}
+		if (sge_no >= xprt->sc_max_sge)
+			goto err_sges;
+		ret = -ENOMEM;
 		page = alloc_page(flags);
 		if (!page)
 			goto err_put_ctxt;
 		ctxt->pages[sge_no] = page;
+		ret = -EIO;
 		pa = ib_dma_map_page(xprt->sc_cm_id->device,
 				     page, 0, PAGE_SIZE,
 				     DMA_FROM_DEVICE);
@@ -528,32 +539,49 @@ int svc_rdma_post_recv(struct svcxprt_rdma *xprt, gfp_t flags)
 
 	svc_xprt_get(&xprt->sc_xprt);
 	ret = ib_post_recv(xprt->sc_qp, &recv_wr, &bad_recv_wr);
-	if (ret) {
-		svc_rdma_unmap_dma(ctxt);
-		svc_rdma_put_context(ctxt, 1);
-		svc_xprt_put(&xprt->sc_xprt);
-	}
-	return ret;
+	if (ret)
+		goto err_post;
+	return 0;
+
+ err_sges:
+	ret = -EINVAL;
+	pr_err("svcrdma: Too many sges (%d)\n", sge_no);
 
  err_put_ctxt:
 	svc_rdma_unmap_dma(ctxt);
 	svc_rdma_put_context(ctxt, 1);
-	return -ENOMEM;
+	return ret;
+
+ err_post:
+	svc_rdma_unmap_dma(ctxt);
+	svc_rdma_put_context(ctxt, 1);
+	svc_xprt_put(&xprt->sc_xprt);
+	return ret;
 }
 
+/**
+ * svc_rdma_repost_recv - Post one Receive buffer, disconnect on failure
+ * @xprt: controlling transport
+ * @flags: memory allocation flags
+ *
+ * Returns:
+ *	%0 if Receive was posted successfully,
+ *	%-ENOTCONN if posting failed (connection is lost).
+ */
 int svc_rdma_repost_recv(struct svcxprt_rdma *xprt, gfp_t flags)
 {
 	int ret = 0;
 
 	ret = svc_rdma_post_recv(xprt, flags);
-	if (ret) {
-		pr_err("svcrdma: could not post a receive buffer, err=%d.\n",
-		       ret);
-		pr_err("svcrdma: closing transport %p.\n", xprt);
-		set_bit(XPT_CLOSE, &xprt->sc_xprt.xpt_flags);
-		ret = -ENOTCONN;
-	}
-	return ret;
+	if (ret)
+		goto err_disconnect;
+	return 0;
+
+ err_disconnect:
+	pr_err("svcrdma: could not post a receive buffer, err=%d.\n", ret);
+	pr_err("svcrdma: closing transport %p.\n", xprt);
+	set_bit(XPT_CLOSE, &xprt->sc_xprt.xpt_flags);
+	return -ENOTCONN;
 }
 
 static void

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
