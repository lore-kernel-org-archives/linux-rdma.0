From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 07/11] xprtrdma: Add ro_unmap_sync method for FMR
Date: Mon, 14 Dec 2015 16:18:59 -0500
Message-ID: <20151214211859.16295.76938.stgit@manet.1015granger.net>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214211317.16295.70115.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

FMR's ro_unmap method is already synchronous because ib_unmap_fmr()
is a synchronous verb. However, some improvements can be made here.

1. Gather all the MRs for the RPC request onto a list, and invoke
   ib_unmap_fmr() once with that list. This reduces the number of
   doorbells when there is more than one MR to invalidate

2. Perform the DMA unmap _after_ the MRs are unmapped, not before.
   This is critical after invalidating a Write chunk.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/fmr_ops.c |   64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/net/sunrpc/xprtrdma/fmr_ops.c b/net/sunrpc/xprtrdma/fmr_ops.c
index f1e8daf..c14f3a4 100644
--- a/net/sunrpc/xprtrdma/fmr_ops.c
+++ b/net/sunrpc/xprtrdma/fmr_ops.c
@@ -179,6 +179,69 @@ out_maperr:
 	return rc;
 }
 
+static void
+__fmr_dma_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
+{
+	struct ib_device *device = r_xprt->rx_ia.ri_device;
+	struct rpcrdma_mw *mw = seg->rl_mw;
+	int nsegs = seg->mr_nsegs;
+
+	seg->rl_mw = NULL;
+
+	while (nsegs--)
+		rpcrdma_unmap_one(device, seg++);
+
+	rpcrdma_put_mw(r_xprt, mw);
+}
+
+/* Invalidate all memory regions that were registered for "req".
+ *
+ * Sleeps until it is safe for the host CPU to access the
+ * previously mapped memory regions.
+ */
+static void
+fmr_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
+{
+	struct rpcrdma_mr_seg *seg;
+	unsigned int i, nchunks;
+	struct rpcrdma_mw *mw;
+	LIST_HEAD(unmap_list);
+	int rc;
+
+	dprintk("RPC:       %s: req %p\n", __func__, req);
+
+	/* ORDER: Invalidate all of the req's MRs first
+	 *
+	 * ib_unmap_fmr() is slow, so use a single call instead
+	 * of one call per mapped MR.
+	 */
+	for (i = 0, nchunks = req->rl_nchunks; nchunks; nchunks--) {
+		seg = &req->rl_segments[i];
+		mw = seg->rl_mw;
+
+		list_add(&mw->r.fmr.fmr->list, &unmap_list);
+
+		i += seg->mr_nsegs;
+	}
+	rc = ib_unmap_fmr(&unmap_list);
+	if (rc)
+		pr_warn("%s: ib_unmap_fmr failed (%i)\n", __func__, rc);
+
+	/* ORDER: Now DMA unmap all of the req's MRs, and return
+	 * them to the free MW list.
+	 */
+	for (i = 0, nchunks = req->rl_nchunks; nchunks; nchunks--) {
+		seg = &req->rl_segments[i];
+
+		__fmr_dma_unmap(r_xprt, seg);
+
+		i += seg->mr_nsegs;
+		seg->mr_nsegs = 0;
+	}
+
+	req->rl_nchunks = 0;
+}
+
 /* Use the ib_unmap_fmr() verb to prevent further remote
  * access via RDMA READ or RDMA WRITE.
  */
@@ -231,6 +294,7 @@ fmr_op_destroy(struct rpcrdma_buffer *buf)
 
 const struct rpcrdma_memreg_ops rpcrdma_fmr_memreg_ops = {
 	.ro_map				= fmr_op_map,
+	.ro_unmap_sync			= fmr_op_unmap_sync,
 	.ro_unmap			= fmr_op_unmap,
 	.ro_open			= fmr_op_open,
 	.ro_maxpages			= fmr_op_maxpages,

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
