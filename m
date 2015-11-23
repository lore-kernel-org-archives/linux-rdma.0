From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 6/9] xprtrdma: Add ro_unmap_sync method for all-physical
 registration
Date: Mon, 23 Nov 2015 17:14:38 -0500
Message-ID: <20151123221438.32702.73349.stgit@manet.1015granger.net>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151123220627.32702.62667.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

physical's ro_unmap is synchronous already. The new ro_unmap_sync
method just has to DMA unmap all MRs associated with the RPC
request.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/physical_ops.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/sunrpc/xprtrdma/physical_ops.c b/net/sunrpc/xprtrdma/physical_ops.c
index 617b76f..dbb302e 100644
--- a/net/sunrpc/xprtrdma/physical_ops.c
+++ b/net/sunrpc/xprtrdma/physical_ops.c
@@ -83,6 +83,18 @@ physical_op_unmap(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg)
 	return 1;
 }
 
+/* DMA unmap all memory regions that were mapped for "req".
+ */
+static void
+physical_op_unmap_sync(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req)
+{
+	struct ib_device *device = r_xprt->rx_ia.ri_device;
+	unsigned int i;
+
+	for (i = 0; req->rl_nchunks; --req->rl_nchunks)
+		rpcrdma_unmap_one(device, &req->rl_segments[i++]);
+}
+
 static void
 physical_op_destroy(struct rpcrdma_buffer *buf)
 {
@@ -90,6 +102,7 @@ physical_op_destroy(struct rpcrdma_buffer *buf)
 
 const struct rpcrdma_memreg_ops rpcrdma_physical_memreg_ops = {
 	.ro_map				= physical_op_map,
+	.ro_unmap_sync			= physical_op_unmap_sync,
 	.ro_unmap			= physical_op_unmap,
 	.ro_open			= physical_op_open,
 	.ro_maxpages			= physical_op_maxpages,

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
