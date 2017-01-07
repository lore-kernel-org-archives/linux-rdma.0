From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 21/22] svcrdma: Clean-up svc_rdma_unmap_dma
Date: Sat, 07 Jan 2017 12:18:07 -0500
Message-ID: <20170107171807.14126.25561.stgit@klimt.1015granger.net>
References: <20170107170258.14126.8503.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170107170258.14126.8503.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

svcrdma no longer manages FRMRs, so there's no need to compare each
SGE's lkey with the PD's local_dma_lkey.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 9b60740..4500000 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -223,23 +223,13 @@ struct svc_rdma_op_ctxt *svc_rdma_get_context(struct svcxprt_rdma *xprt)
 void svc_rdma_unmap_dma(struct svc_rdma_op_ctxt *ctxt)
 {
 	struct svcxprt_rdma *xprt = ctxt->xprt;
-	struct ib_device *device = xprt->sc_cm_id->device;
-	u32 lkey = xprt->sc_pd->local_dma_lkey;
 	unsigned int i;
 
-	for (i = 0; i < ctxt->mapped_sges; i++) {
-		/*
-		 * Unmap the DMA addr in the SGE if the lkey matches
-		 * the local_dma_lkey, otherwise, ignore it since it is
-		 * an FRMR lkey and will be unmapped later when the
-		 * last WR that uses it completes.
-		 */
-		if (ctxt->sge[i].lkey == lkey)
-			ib_dma_unmap_page(device,
-					    ctxt->sge[i].addr,
-					    ctxt->sge[i].length,
-					    ctxt->direction);
-	}
+	for (i = 0; i < ctxt->mapped_sges; i++)
+		ib_dma_unmap_page(xprt->sc_device,
+				  ctxt->sge[i].addr,
+				  ctxt->sge[i].length,
+				  ctxt->direction);
 	ctxt->mapped_sges = 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
