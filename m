From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 4/7] xprtrdma: "Unoptimize" rpcrdma_prepare_hdr_sges()
Date: Mon, 11 Sep 2017 11:18:31 -0400
Message-ID: <150514310605.1307.7229343297387413741.stgit@lebasque.1015granger.net>
References: <150514269466.1307.1991885208569456320.stgit@lebasque.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150514269466.1307.1991885208569456320.stgit-NCCkF8GxsaM6WJ89mGctdJimSvn7F7xT@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The assumption made in rpcrdma_prepare_hdr_sges was that the zeroeth
element of the SGE array needed to be initialized just once, since
the array and rl_rdmabuf lived in the same data structure.

With sendctx, the Send SGE array is now separate from the
rpcrdma_req, so the zeroeth element of the SGE array needs to be
initialized every time.

XXX: What might make better sense would be to manage the header
buffer in struct rpcrdma_sendctx. It's size is not dependent on the
exact RPC message being sent.

 - Move its allocation from xprt_rdma_allocate to
   rpcrdma_sendctx_create
 - Move its release to rpcrdma_sendctxs_destroy

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 62ec1f7..545f5d0 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -511,7 +511,7 @@ rpcrdma_encode_reply_chunk(struct rpcrdma_xprt *r_xprt, struct rpcrdma_req *req,
 	return 0;
 }
 
-/* Prepare the RPC-over-RDMA header SGE.
+/* Prepare an SGE for the RPC-over-RDMA transport header.
  */
 static bool
 rpcrdma_prepare_hdr_sge(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
@@ -520,13 +520,11 @@ rpcrdma_prepare_hdr_sge(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
 	struct rpcrdma_regbuf *rb = req->rl_rdmabuf;
 	struct ib_sge *sge = &req->rl_send_sge[0];
 
-	if (unlikely(!rpcrdma_regbuf_is_mapped(rb))) {
-		if (!__rpcrdma_dma_map_regbuf(ia, rb))
-			goto out_regbuf;
-		sge->addr = rdmab_addr(rb);
-		sge->lkey = rdmab_lkey(rb);
-	}
+	if (!rpcrdma_dma_map_regbuf(ia, rb))
+		goto out_regbuf;
+	sge->addr = rdmab_addr(rb);
 	sge->length = len;
+	sge->lkey = rdmab_lkey(rb);
 
 	ib_dma_sync_single_for_device(rdmab_device(rb), sge->addr,
 				      sge->length, DMA_TO_DEVICE);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
