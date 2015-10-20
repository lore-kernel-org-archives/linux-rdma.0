From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 06/22] staging/rdma/hfi1: Add coalescing support for SDMA TX descriptors
Date: Mon, 19 Oct 2015 22:11:21 -0400
Message-ID: <1445307097-8244-7-git-send-email-ira.weiny@intel.com>
References: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445307097-8244-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This fixes transmit errors when the number of scatter gather elements in the
request is more that the number of per packet descriptors supported by the
hardware, allocate and coalesce the extra scatter gather elements into a single
buffer. The last descriptor is reserved and used for this coalesced buffer.

Verbs potentially need this support when transferring small data chunks
involving different memory regions.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c | 124 ++++++++++++++++++++++++++++++++++++---
 drivers/staging/rdma/hfi1/sdma.h |  74 +++++++++++++++--------
 2 files changed, 168 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index d57531796723..53b3e4d9518b 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -55,6 +55,7 @@
 #include <linux/bitops.h>
 #include <linux/timer.h>
 #include <linux/vmalloc.h>
+#include <linux/highmem.h>
 
 #include "hfi.h"
 #include "common.h"
@@ -2706,27 +2707,134 @@ static void __sdma_process_event(struct sdma_engine *sde,
  * of descriptors in the sdma_txreq is exhausted.
  *
  * The code will bump the allocation up to the max
- * of MAX_DESC (64) descriptors.  There doesn't seem
- * much point in an interim step.
+ * of MAX_DESC (64) descriptors. There doesn't seem
+ * much point in an interim step. The last descriptor
+ * is reserved for coalesce buffer in order to support
+ * cases where input packet has >MAX_DESC iovecs.
  *
  */
-int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
+static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int i;
 
+	/* Handle last descriptor */
+	if (unlikely((tx->num_desc == (MAX_DESC - 1)))) {
+		/* if tlen is 0, it is for padding, release last descriptor */
+		if (!tx->tlen) {
+			tx->desc_limit = MAX_DESC;
+		} else if (!tx->coalesce_buf) {
+			/* allocate coalesce buffer with space for padding */
+			tx->coalesce_buf = kmalloc(tx->tlen + sizeof(u32),
+						   GFP_ATOMIC);
+			if (!tx->coalesce_buf)
+				return -ENOMEM;
+
+			tx->coalesce_idx = 0;
+		}
+		return 0;
+	}
+
+	if (unlikely(tx->num_desc == MAX_DESC))
+		return -ENOMEM;
+
 	tx->descp = kmalloc_array(
 			MAX_DESC,
 			sizeof(struct sdma_desc),
 			GFP_ATOMIC);
 	if (!tx->descp)
 		return -ENOMEM;
-	tx->desc_limit = MAX_DESC;
+
+	/* reserve last descriptor for coalescing */
+	tx->desc_limit = MAX_DESC - 1;
 	/* copy ones already built */
 	for (i = 0; i < tx->num_desc; i++)
 		tx->descp[i] = tx->descs[i];
 	return 0;
 }
 
+/*
+ * ext_coal_sdma_tx_descs() - extend or coalesce sdma tx descriptors
+ *
+ * This is called once the initial nominal allocation of descriptors
+ * in the sdma_txreq is exhausted.
+ *
+ * This function calls _extend_sdma_tx_descs to extend or allocate
+ * coalesce buffer. If there is a allocated coalesce buffer, it will
+ * copy the input packet data into the coalesce buffer. It also adds
+ * coalesce buffer descriptor once whe whole packet is received.
+ *
+ * Return:
+ * <0 - error
+ * 0 - coalescing, don't populate descriptor
+ * 1 - continue with populating descriptor
+ */
+int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
+			   int type, void *kvaddr, struct page *page,
+			   unsigned long offset, u16 len)
+{
+	int pad_len, rval;
+	dma_addr_t addr;
+
+	rval = _extend_sdma_tx_descs(dd, tx);
+	if (rval) {
+		sdma_txclean(dd, tx);
+		return rval;
+	}
+
+	/* If coalesce buffer is allocated, copy data into it */
+	if (tx->coalesce_buf) {
+		if (type == SDMA_MAP_NONE) {
+			sdma_txclean(dd, tx);
+			return -EINVAL;
+		}
+
+		if (type == SDMA_MAP_PAGE) {
+			kvaddr = kmap(page);
+			kvaddr += offset;
+		} else if (WARN_ON(!kvaddr)) {
+			sdma_txclean(dd, tx);
+			return -EINVAL;
+		}
+
+		memcpy(tx->coalesce_buf + tx->coalesce_idx, kvaddr, len);
+		tx->coalesce_idx += len;
+		if (type == SDMA_MAP_PAGE)
+			kunmap(page);
+
+		/* If there is more data, return */
+		if (tx->tlen - tx->coalesce_idx)
+			return 0;
+
+		/* Whole packet is received; add any padding */
+		pad_len = tx->packet_len & (sizeof(u32) - 1);
+		if (pad_len) {
+			pad_len = sizeof(u32) - pad_len;
+			memset(tx->coalesce_buf + tx->coalesce_idx, 0, pad_len);
+			/* padding is taken care of for coalescing case */
+			tx->packet_len += pad_len;
+			tx->tlen += pad_len;
+		}
+
+		/* dma map the coalesce buffer */
+		addr = dma_map_single(&dd->pcidev->dev,
+				      tx->coalesce_buf,
+				      tx->tlen,
+				      DMA_TO_DEVICE);
+
+		if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
+			sdma_txclean(dd, tx);
+			return -ENOSPC;
+		}
+
+		/* Add descriptor for coalesce buffer */
+		tx->desc_limit = MAX_DESC;
+		return _sdma_txadd_daddr(dd, SDMA_MAP_SINGLE, tx,
+					 addr, tx->tlen);
+	}
+
+	return 1;
+}
+
 /* Update sdes when the lmc changes */
 void sdma_update_lmc(struct hfi1_devdata *dd, u64 mask, u32 lid)
 {
@@ -2752,13 +2860,15 @@ int _pad_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int rval = 0;
 
+	tx->num_desc++;
 	if ((unlikely(tx->num_desc == tx->desc_limit))) {
 		rval = _extend_sdma_tx_descs(dd, tx);
-		if (rval)
+		if (rval) {
+			sdma_txclean(dd, tx);
 			return rval;
+		}
 	}
-	/* finish the one just added  */
-	tx->num_desc++;
+	/* finish the one just added */
 	make_tx_sdma_desc(
 		tx,
 		SDMA_MAP_NONE,
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 496086903891..52a7d04067e0 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -352,6 +352,8 @@ struct sdma_txreq {
 	/* private: */
 	void *coalesce_buf;
 	/* private: */
+	u16 coalesce_idx;
+	/* private: */
 	struct iowait *wait;
 	/* private: */
 	callback_t                  complete;
@@ -735,7 +737,9 @@ static inline void make_tx_sdma_desc(
 }
 
 /* helper to extend txreq */
-int _extend_sdma_tx_descs(struct hfi1_devdata *, struct sdma_txreq *);
+int ext_coal_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx,
+			   int type, void *kvaddr, struct page *page,
+			   unsigned long offset, u16 len);
 int _pad_sdma_tx_descs(struct hfi1_devdata *, struct sdma_txreq *);
 void sdma_txclean(struct hfi1_devdata *, struct sdma_txreq *);
 
@@ -762,11 +766,6 @@ static inline int _sdma_txadd_daddr(
 {
 	int rval = 0;
 
-	if ((unlikely(tx->num_desc == tx->desc_limit))) {
-		rval = _extend_sdma_tx_descs(dd, tx);
-		if (rval)
-			return rval;
-	}
 	make_tx_sdma_desc(
 		tx,
 		type,
@@ -798,9 +797,7 @@ static inline int _sdma_txadd_daddr(
  *
  * Return:
  * 0 - success, -ENOSPC - mapping fail, -ENOMEM - couldn't
- * extend descriptor array or couldn't allocate coalesce
- * buffer.
- *
+ * extend/coalesce descriptor array
  */
 static inline int sdma_txadd_page(
 	struct hfi1_devdata *dd,
@@ -809,17 +806,28 @@ static inline int sdma_txadd_page(
 	unsigned long offset,
 	u16 len)
 {
-	dma_addr_t addr =
-		dma_map_page(
-			&dd->pcidev->dev,
-			page,
-			offset,
-			len,
-			DMA_TO_DEVICE);
+	dma_addr_t addr;
+	int rval;
+
+	if ((unlikely(tx->num_desc == tx->desc_limit))) {
+		rval = ext_coal_sdma_tx_descs(dd, tx, SDMA_MAP_PAGE,
+					      NULL, page, offset, len);
+		if (rval <= 0)
+			return rval;
+	}
+
+	addr = dma_map_page(
+		       &dd->pcidev->dev,
+		       page,
+		       offset,
+		       len,
+		       DMA_TO_DEVICE);
+
 	if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
 		sdma_txclean(dd, tx);
 		return -ENOSPC;
 	}
+
 	return _sdma_txadd_daddr(
 			dd, SDMA_MAP_PAGE, tx, addr, len);
 }
@@ -846,6 +854,15 @@ static inline int sdma_txadd_daddr(
 	dma_addr_t addr,
 	u16 len)
 {
+	int rval;
+
+	if ((unlikely(tx->num_desc == tx->desc_limit))) {
+		rval = ext_coal_sdma_tx_descs(dd, tx, SDMA_MAP_NONE,
+					      NULL, NULL, 0, 0);
+		if (rval <= 0)
+			return rval;
+	}
+
 	return _sdma_txadd_daddr(dd, SDMA_MAP_NONE, tx, addr, len);
 }
 
@@ -862,7 +879,7 @@ static inline int sdma_txadd_daddr(
  * The mapping/unmapping of the kvaddr and len is automatically handled.
  *
  * Return:
- * 0 - success, -ENOSPC - mapping fail, -ENOMEM - couldn't extend
+ * 0 - success, -ENOSPC - mapping fail, -ENOMEM - couldn't extend/coalesce
  * descriptor array
  */
 static inline int sdma_txadd_kvaddr(
@@ -871,16 +888,27 @@ static inline int sdma_txadd_kvaddr(
 	void *kvaddr,
 	u16 len)
 {
-	dma_addr_t addr =
-		dma_map_single(
-			&dd->pcidev->dev,
-			kvaddr,
-			len,
-			DMA_TO_DEVICE);
+	dma_addr_t addr;
+	int rval;
+
+	if ((unlikely(tx->num_desc == tx->desc_limit))) {
+		rval = ext_coal_sdma_tx_descs(dd, tx, SDMA_MAP_SINGLE,
+					      kvaddr, 0, 0, len);
+		if (rval <= 0)
+			return rval;
+	}
+
+	addr = dma_map_single(
+		       &dd->pcidev->dev,
+		       kvaddr,
+		       len,
+		       DMA_TO_DEVICE);
+
 	if (unlikely(dma_mapping_error(&dd->pcidev->dev, addr))) {
 		sdma_txclean(dd, tx);
 		return -ENOSPC;
 	}
+
 	return _sdma_txadd_daddr(
 			dd, SDMA_MAP_SINGLE, tx, addr, len);
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
