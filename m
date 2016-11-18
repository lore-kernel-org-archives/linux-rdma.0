From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/10] svcrdma: Remove DMA map accounting
Date: Fri, 18 Nov 2016 10:10:50 -0500
Message-ID: <20161118151050.13658.70902.stgit@klimt.1015granger.net>
References: <20161118145940.13658.59105.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161118145940.13658.59105.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: sc_dma_used is not required for correct operation. It is
simply a debugging tool to report when svcrdma has leaked DMA maps.

However, manipulating an atomic has a measurable CPU cost, and DMA
map accounting specific to svcrdma will be meaningless once svcrdma
is converted to use the new generic r/w API.

A similar kind of debug accounting can be done simply by enabling
the IOMMU or by using CONFIG_DMA_API_DEBUG, CONFIG_IOMMU_DEBUG, and
CONFIG_IOMMU_LEAK.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sunrpc/svc_rdma.h          |    2 --
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |    1 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   13 +++----------
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 601cb07..43d7c70 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -148,7 +148,6 @@ struct svcxprt_rdma {
 
 	struct ib_pd         *sc_pd;
 
-	atomic_t	     sc_dma_used;
 	spinlock_t	     sc_ctxt_lock;
 	struct list_head     sc_ctxts;
 	int		     sc_ctxt_used;
@@ -200,7 +199,6 @@ static inline void svc_rdma_count_mappings(struct svcxprt_rdma *rdma,
 					   struct svc_rdma_op_ctxt *ctxt)
 {
 	ctxt->mapped_sges++;
-	atomic_inc(&rdma->sc_dma_used);
 }
 
 /* svc_rdma_backchannel.c */
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 873c2a9..283246e 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -279,7 +279,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 		       frmr->sg);
 		return -ENOMEM;
 	}
-	atomic_inc(&xprt->sc_dma_used);
 
 	n = ib_map_mr_sg(frmr->mr, frmr->sg, frmr->sg_nents, NULL, PAGE_SIZE);
 	if (unlikely(n != frmr->sg_nents)) {
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index da990d7..a613ebd 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -224,25 +224,22 @@ void svc_rdma_unmap_dma(struct svc_rdma_op_ctxt *ctxt)
 	struct svcxprt_rdma *xprt = ctxt->xprt;
 	struct ib_device *device = xprt->sc_cm_id->device;
 	u32 lkey = xprt->sc_pd->local_dma_lkey;
-	unsigned int i, count;
+	unsigned int i;
 
-	for (count = 0, i = 0; i < ctxt->mapped_sges; i++) {
+	for (i = 0; i < ctxt->mapped_sges; i++) {
 		/*
 		 * Unmap the DMA addr in the SGE if the lkey matches
 		 * the local_dma_lkey, otherwise, ignore it since it is
 		 * an FRMR lkey and will be unmapped later when the
 		 * last WR that uses it completes.
 		 */
-		if (ctxt->sge[i].lkey == lkey) {
-			count++;
+		if (ctxt->sge[i].lkey == lkey)
 			ib_dma_unmap_page(device,
 					    ctxt->sge[i].addr,
 					    ctxt->sge[i].length,
 					    ctxt->direction);
-		}
 	}
 	ctxt->mapped_sges = 0;
-	atomic_sub(count, &xprt->sc_dma_used);
 }
 
 void svc_rdma_put_context(struct svc_rdma_op_ctxt *ctxt, int free_pages)
@@ -944,7 +941,6 @@ void svc_rdma_put_frmr(struct svcxprt_rdma *rdma,
 	if (frmr) {
 		ib_dma_unmap_sg(rdma->sc_cm_id->device,
 				frmr->sg, frmr->sg_nents, frmr->direction);
-		atomic_dec(&rdma->sc_dma_used);
 		spin_lock_bh(&rdma->sc_frmr_q_lock);
 		WARN_ON_ONCE(!list_empty(&frmr->frmr_list));
 		list_add(&frmr->frmr_list, &rdma->sc_frmr_q);
@@ -1256,9 +1252,6 @@ static void __svc_rdma_free(struct work_struct *work)
 	if (rdma->sc_ctxt_used != 0)
 		pr_err("svcrdma: ctxt still in use? (%d)\n",
 		       rdma->sc_ctxt_used);
-	if (atomic_read(&rdma->sc_dma_used) != 0)
-		pr_err("svcrdma: dma still in use? (%d)\n",
-		       atomic_read(&rdma->sc_dma_used));
 
 	/* Final put of backchannel client transport */
 	if (xprt->xpt_bc_xprt) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
