From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/9] xprtrdma: Fix error handling in
 rpcrdma_prepare_msg_sges()
Date: Fri, 20 Oct 2017 10:47:47 -0400
Message-ID: <20171020144747.14869.77935.stgit@manet.1015granger.net>
References: <20171020143635.14869.15714.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020143635.14869.15714.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When this function fails, it needs to undo the DMA mappings it's
done so far. Otherwise these are leaked.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 3c92558..4f6c539 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -511,6 +511,28 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	return 0;
 }
 
+/**
+ * rpcrdma_unmap_sges - DMA-unmap Send buffers
+ * @ia: interface adapter (device)
+ * @req: req with possibly some SGEs to be DMA unmapped
+ *
+ */
+void
+rpcrdma_unmap_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req)
+{
+	struct ib_sge *sge;
+	unsigned int count;
+
+	/* The first two SGEs contain the transport header and
+	 * the inline buffer. These are always left mapped so
+	 * they can be cheaply re-used.
+	 */
+	sge = &req->rl_send_sge[2];
+	for (count = req->rl_mapped_sges; count--; sge++)
+		ib_dma_unmap_page(ia->ri_device,
+				  sge->addr, sge->length, DMA_TO_DEVICE);
+}
+
 /* Prepare the RPC-over-RDMA header SGE.
  */
 static bool
@@ -641,10 +663,12 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	return true;
 
 out_mapping_overflow:
+	rpcrdma_unmap_sges(ia, req);
 	pr_err("rpcrdma: too many Send SGEs (%u)\n", sge_no);
 	return false;
 
 out_mapping_err:
+	rpcrdma_unmap_sges(ia, req);
 	pr_err("rpcrdma: Send mapping error\n");
 	return false;
 }
@@ -671,20 +695,6 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	return false;
 }
 
-void
-rpcrdma_unmap_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req)
-{
-	struct ib_device *device = ia->ri_device;
-	struct ib_sge *sge;
-	int count;
-
-	sge = &req->rl_send_sge[2];
-	for (count = req->rl_mapped_sges; count--; sge++)
-		ib_dma_unmap_page(device, sge->addr, sge->length,
-				  DMA_TO_DEVICE);
-	req->rl_mapped_sges = 0;
-}
-
 /**
  * rpcrdma_marshal_req - Marshal and send one RPC request
  * @r_xprt: controlling transport

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
