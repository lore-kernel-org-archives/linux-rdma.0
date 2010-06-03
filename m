From: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] cxgb4: use the DMA state API instead of the pci equivalents
Date: Thu, 3 Jun 2010 14:37:50 +0900
Message-ID: <20100603143721A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This replace the PCI DMA state API (include/linux/pci-dma.h) with the
DMA equivalents since the PCI DMA state API will be obsolete.

No functional change.

For further information about the background:

http://marc.info/?l=linux-netdev&m=127037540020276&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cq.c       |    6 +++---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    2 +-
 drivers/infiniband/hw/cxgb4/mem.c      |    4 ++--
 drivers/infiniband/hw/cxgb4/qp.c       |   12 ++++++------
 drivers/infiniband/hw/cxgb4/t4.h       |    6 +++---
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 2447f52..e1317f5 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -77,7 +77,7 @@ static int destroy_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	kfree(cq->sw_queue);
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  cq->memsize, cq->queue,
-			  pci_unmap_addr(cq, mapping));
+			  dma_unmap_addr(cq, mapping));
 	c4iw_put_cqid(rdev, cq->cqid, uctx);
 	return ret;
 }
@@ -112,7 +112,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 		ret = -ENOMEM;
 		goto err3;
 	}
-	pci_unmap_addr_set(cq, mapping, cq->dma_addr);
+	dma_unmap_addr_set(cq, mapping, cq->dma_addr);
 	memset(cq->queue, 0, cq->memsize);
 
 	/* build fw_ri_res_wr */
@@ -179,7 +179,7 @@ static int create_cq(struct c4iw_rdev *rdev, struct t4_cq *cq,
 	return 0;
 err4:
 	dma_free_coherent(&rdev->lldi.pdev->dev, cq->memsize, cq->queue,
-			  pci_unmap_addr(cq, mapping));
+			  dma_unmap_addr(cq, mapping));
 err3:
 	kfree(cq->sw_queue);
 err2:
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 277ab58..d33e1a6 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -261,7 +261,7 @@ static inline struct c4iw_mw *to_c4iw_mw(struct ib_mw *ibmw)
 
 struct c4iw_fr_page_list {
 	struct ib_fast_reg_page_list ibpl;
-	DECLARE_PCI_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	dma_addr_t dma_addr;
 	struct c4iw_dev *dev;
 	int size;
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7f94da1..82b5703 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -764,7 +764,7 @@ struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(struct ib_device *device,
 	if (!c4pl)
 		return ERR_PTR(-ENOMEM);
 
-	pci_unmap_addr_set(c4pl, mapping, dma_addr);
+	dma_unmap_addr_set(c4pl, mapping, dma_addr);
 	c4pl->dma_addr = dma_addr;
 	c4pl->dev = dev;
 	c4pl->size = size;
@@ -779,7 +779,7 @@ void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_list *ibpl)
 	struct c4iw_fr_page_list *c4pl = to_c4iw_fr_page_list(ibpl);
 
 	dma_free_coherent(&c4pl->dev->rdev.lldi.pdev->dev, c4pl->size,
-			  c4pl, pci_unmap_addr(c4pl, mapping));
+			  c4pl, dma_unmap_addr(c4pl, mapping));
 }
 
 int c4iw_dereg_mr(struct ib_mr *ib_mr)
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 0c28ed1..7065cb3 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -40,10 +40,10 @@ static int destroy_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	 */
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->rq.memsize, wq->rq.queue,
-			  pci_unmap_addr(&wq->rq, mapping));
+			  dma_unmap_addr(&wq->rq, mapping));
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->sq.memsize, wq->sq.queue,
-			  pci_unmap_addr(&wq->sq, mapping));
+			  dma_unmap_addr(&wq->sq, mapping));
 	c4iw_rqtpool_free(rdev, wq->rq.rqt_hwaddr, wq->rq.rqt_size);
 	kfree(wq->rq.sw_rq);
 	kfree(wq->sq.sw_sq);
@@ -99,7 +99,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	if (!wq->sq.queue)
 		goto err5;
 	memset(wq->sq.queue, 0, wq->sq.memsize);
-	pci_unmap_addr_set(&wq->sq, mapping, wq->sq.dma_addr);
+	dma_unmap_addr_set(&wq->sq, mapping, wq->sq.dma_addr);
 
 	wq->rq.queue = dma_alloc_coherent(&(rdev->lldi.pdev->dev),
 					  wq->rq.memsize, &(wq->rq.dma_addr),
@@ -112,7 +112,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 		wq->rq.queue,
 		(unsigned long long)virt_to_phys(wq->rq.queue));
 	memset(wq->rq.queue, 0, wq->rq.memsize);
-	pci_unmap_addr_set(&wq->rq, mapping, wq->rq.dma_addr);
+	dma_unmap_addr_set(&wq->rq, mapping, wq->rq.dma_addr);
 
 	wq->db = rdev->lldi.db_reg;
 	wq->gts = rdev->lldi.gts_reg;
@@ -217,11 +217,11 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 err7:
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->rq.memsize, wq->rq.queue,
-			  pci_unmap_addr(&wq->rq, mapping));
+			  dma_unmap_addr(&wq->rq, mapping));
 err6:
 	dma_free_coherent(&(rdev->lldi.pdev->dev),
 			  wq->sq.memsize, wq->sq.queue,
-			  pci_unmap_addr(&wq->sq, mapping));
+			  dma_unmap_addr(&wq->sq, mapping));
 err5:
 	c4iw_rqtpool_free(rdev, wq->rq.rqt_hwaddr, wq->rq.rqt_size);
 err4:
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 1057cb9..9cf8d85 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -279,7 +279,7 @@ struct t4_swsqe {
 struct t4_sq {
 	union t4_wr *queue;
 	dma_addr_t dma_addr;
-	DECLARE_PCI_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	struct t4_swsqe *sw_sq;
 	struct t4_swsqe *oldest_read;
 	u64 udb;
@@ -298,7 +298,7 @@ struct t4_swrqe {
 struct t4_rq {
 	union  t4_recv_wr *queue;
 	dma_addr_t dma_addr;
-	DECLARE_PCI_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	struct t4_swrqe *sw_rq;
 	u64 udb;
 	size_t memsize;
@@ -429,7 +429,7 @@ static inline int t4_wq_db_enabled(struct t4_wq *wq)
 struct t4_cq {
 	struct t4_cqe *queue;
 	dma_addr_t dma_addr;
-	DECLARE_PCI_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_ADDR(mapping);
 	struct t4_cqe *sw_queue;
 	void __iomem *gts;
 	struct c4iw_rdev *rdev;
-- 
1.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
