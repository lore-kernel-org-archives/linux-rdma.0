From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] IB/hfi1: Inline sdma_txclean() for verbs pio
Date: Mon, 10 Oct 2016 06:14:34 -0700
Message-ID: <20161010131433.17586.31365.stgit@scvm10.sc.intel.com>
References: <20161010131249.17586.23789.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161010131249.17586.23789.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Short circuit sdma_txclean() by adding an __sdma_txclean()
that is only called when the tx has sdma mappings.

Convert internal calls to __sdma_txclean().

This removes a call from the critical path.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/sdma.c |   18 +++++++++---------
 drivers/infiniband/hw/hfi1/sdma.h |   12 +++++++++---
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index fd39bca..7102a07 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -375,7 +375,7 @@ static inline void complete_tx(struct sdma_engine *sde,
 			   sde->head_sn, tx->sn);
 	sde->head_sn++;
 #endif
-	sdma_txclean(sde->dd, tx);
+	__sdma_txclean(sde->dd, tx);
 	if (complete)
 		(*complete)(tx, res);
 	if (wait && iowait_sdma_dec(wait))
@@ -1643,7 +1643,7 @@ static inline u8 ahg_mode(struct sdma_txreq *tx)
 }
 
 /**
- * sdma_txclean() - clean tx of mappings, descp *kmalloc's
+ * __sdma_txclean() - clean tx of mappings, descp *kmalloc's
  * @dd: hfi1_devdata for unmapping
  * @tx: tx request to clean
  *
@@ -1653,7 +1653,7 @@ static inline u8 ahg_mode(struct sdma_txreq *tx)
  * The code can be called multiple times without issue.
  *
  */
-void sdma_txclean(
+void __sdma_txclean(
 	struct hfi1_devdata *dd,
 	struct sdma_txreq *tx)
 {
@@ -3080,7 +3080,7 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 		tx->descp[i] = tx->descs[i];
 	return 0;
 enomem:
-	sdma_txclean(dd, tx);
+	__sdma_txclean(dd, tx);
 	return -ENOMEM;
 }
 
@@ -3109,14 +3109,14 @@ int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
 
 	rval = _extend_sdma_tx_descs(dd, tx);
 	if (rval) {
-		sdma_txclean(dd, tx);
+		__sdma_txclean(dd, tx);
 		return rval;
 	}
 
 	/* If coalesce buffer is allocated, copy data into it */
 	if (tx->coalesce_buf) {
 		if (type == SDMA_MAP_NONE) {
-			sdma_txclean(dd, tx);
+			__sdma_txclean(dd, tx);
 			return -EINVAL;
 		}
 
@@ -3124,7 +3124,7 @@ int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
 			kvaddr = kmap(page);
 			kvaddr += offset;
 		} else if (WARN_ON(!kvaddr)) {
-			sdma_txclean(dd, tx);
+			__sdma_txclean(dd, tx);
 			return -EINVAL;
 		}
 
@@ -3154,7 +3154,7 @@ int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
 				      DMA_TO_DEVICE);
 
 		if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
-			sdma_txclean(dd, tx);
+			__sdma_txclean(dd, tx);
 			return -ENOSPC;
 		}
 
@@ -3196,7 +3196,7 @@ int _pad_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 	if ((unlikely(tx->num_desc == tx->desc_limit))) {
 		rval = _extend_sdma_tx_descs(dd, tx);
 		if (rval) {
-			sdma_txclean(dd, tx);
+			__sdma_txclean(dd, tx);
 			return rval;
 		}
 	}
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index 56257ea..21f1e28 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -667,7 +667,13 @@ int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
 			   int type, void *kvaddr, struct page *page,
 			   unsigned long offset, u16 len);
 int _pad_sdma_tx_descs(struct hfi1_devdata *, struct sdma_txreq *);
-void sdma_txclean(struct hfi1_devdata *, struct sdma_txreq *);
+void __sdma_txclean(struct hfi1_devdata *, struct sdma_txreq *);
+
+static inline void sdma_txclean(struct hfi1_devdata *dd, struct sdma_txreq *tx)
+{
+	if (tx->num_desc)
+		__sdma_txclean(dd, tx);
+}
 
 /* helpers used by public routines */
 static inline void _sdma_close_tx(struct hfi1_devdata *dd,
@@ -753,7 +759,7 @@ static inline int sdma_txadd_page(
 		       DMA_TO_DEVICE);
 
 	if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
-		sdma_txclean(dd, tx);
+		__sdma_txclean(dd, tx);
 		return -ENOSPC;
 	}
 
@@ -834,7 +840,7 @@ static inline int sdma_txadd_kvaddr(
 		       DMA_TO_DEVICE);
 
 	if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
-		sdma_txclean(dd, tx);
+		__sdma_txclean(dd, tx);
 		return -ENOSPC;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
