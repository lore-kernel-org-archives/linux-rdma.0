From: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] RDMA/cxgb3: use the dma state API instead of the pci
 equivalents
Date: Fri, 2 Apr 2010 13:29:38 +0900
Message-ID: <20100402132306I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The DMA API is preferred.

No functional change.

Signed-off-by: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/cxio_hal.c |   12 ++++++------
 drivers/infiniband/hw/cxgb3/cxio_hal.h |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index a28e862..619bae2 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -173,7 +173,7 @@ int cxio_create_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq, int kernel)
 		kfree(cq->sw_queue);
 		return -ENOMEM;
 	}
-	pci_unmap_addr_set(cq, mapping, cq->dma_addr);
+	dma_unmap_addr_set(cq, mapping, cq->dma_addr);
 	memset(cq->queue, 0, size);
 	setup.id = cq->cqid;
 	setup.base_addr = (u64) (cq->dma_addr);
@@ -296,7 +296,7 @@ int cxio_create_qp(struct cxio_rdev *rdev_p, u32 kernel_domain,
 		goto err4;
 
 	memset(wq->queue, 0, depth * sizeof(union t3_wr));
-	pci_unmap_addr_set(wq, mapping, wq->dma_addr);
+	dma_unmap_addr_set(wq, mapping, wq->dma_addr);
 	wq->doorbell = (void __iomem *)rdev_p->rnic_info.kdb_addr;
 	if (!kernel_domain)
 		wq->udb = (u64)rdev_p->rnic_info.udbell_physbase +
@@ -324,7 +324,7 @@ int cxio_destroy_cq(struct cxio_rdev *rdev_p, struct t3_cq *cq)
 	dma_free_coherent(&(rdev_p->rnic_info.pdev->dev),
 			  (1UL << (cq->size_log2))
 			  * sizeof(struct t3_cqe), cq->queue,
-			  pci_unmap_addr(cq, mapping));
+			  dma_unmap_addr(cq, mapping));
 	cxio_hal_put_cqid(rdev_p->rscp, cq->cqid);
 	return err;
 }
@@ -335,7 +335,7 @@ int cxio_destroy_qp(struct cxio_rdev *rdev_p, struct t3_wq *wq,
 	dma_free_coherent(&(rdev_p->rnic_info.pdev->dev),
 			  (1UL << (wq->size_log2))
 			  * sizeof(union t3_wr), wq->queue,
-			  pci_unmap_addr(wq, mapping));
+			  dma_unmap_addr(wq, mapping));
 	kfree(wq->sq);
 	cxio_hal_rqtpool_free(rdev_p, wq->rq_addr, (1UL << wq->rq_size_log2));
 	kfree(wq->rq);
@@ -536,7 +536,7 @@ static int cxio_hal_init_ctrl_qp(struct cxio_rdev *rdev_p)
 		err = -ENOMEM;
 		goto err;
 	}
-	pci_unmap_addr_set(&rdev_p->ctrl_qp, mapping,
+	dma_unmap_addr_set(&rdev_p->ctrl_qp, mapping,
 			   rdev_p->ctrl_qp.dma_addr);
 	rdev_p->ctrl_qp.doorbell = (void __iomem *)rdev_p->rnic_info.kdb_addr;
 	memset(rdev_p->ctrl_qp.workq, 0,
@@ -582,7 +582,7 @@ static int cxio_hal_destroy_ctrl_qp(struct cxio_rdev *rdev_p)
 	dma_free_coherent(&(rdev_p->rnic_info.pdev->dev),
 			  (1UL << T3_CTRL_QP_SIZE_LOG2)
 			  * sizeof(union t3_wr), rdev_p->ctrl_qp.workq,
-			  pci_unmap_addr(&rdev_p->ctrl_qp, mapping));
+			  dma_unmap_addr(&rdev_p->ctrl_qp, mapping));
 	return cxio_hal_clear_qp_ctx(rdev_p, T3_CTRL_QP_ID);
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.h b/drivers/infiniband/hw/cxgb3/cxio_hal.h
index 073373c..8f0caf7 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -71,7 +71,7 @@ struct cxio_hal_ctrl_qp {
 	wait_queue_head_t waitq;/* wait for RspQ/CQE msg */
 	union t3_wr *workq;	/* the work request queue */
 	dma_addr_t dma_addr;	/* pci bus address of the workq */
-	DECLARE_PCI_UNMAP_ADDR(mapping)
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	void __iomem *doorbell;
 };
 
diff --git a/drivers/infiniband/hw/cxgb3/cxio_wr.h b/drivers/infiniband/hw/cxgb3/cxio_wr.h
index 15073b2..e5ddb63 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_wr.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_wr.h
@@ -691,7 +691,7 @@ struct t3_swrq {
 struct t3_wq {
 	union t3_wr *queue;		/* DMA accessable memory */
 	dma_addr_t dma_addr;		/* DMA address for HW */
-	DECLARE_PCI_UNMAP_ADDR(mapping)	/* unmap kruft */
+	DEFINE_DMA_UNMAP_ADDR(mapping); /* unmap kruft */
 	u32 error;			/* 1 once we go to ERROR */
 	u32 qpid;
 	u32 wptr;			/* idx to next available WR slot */
@@ -718,7 +718,7 @@ struct t3_cq {
 	u32 wptr;
 	u32 size_log2;
 	dma_addr_t dma_addr;
-	DECLARE_PCI_UNMAP_ADDR(mapping)
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	struct t3_cqe *queue;
 	struct t3_cqe *sw_queue;
 	u32 sw_rptr;
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
