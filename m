From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 16/44] infiniband: dma-mapping: Use unsigned long for
 dma_attrs
Date: Fri, 10 Jun 2016 12:11:33 +0200
Message-ID: <1465553521-27303-17-git-send-email-k.kozlowski@samsung.com>
References: <1465553521-27303-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1465553521-27303-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/infiniband/core/umem.c | 7 +++----
 include/rdma/ib_verbs.h        | 8 ++++----
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index fe4d2e1a8b58..75d8a8b178a5 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -37,7 +37,6 @@
 #include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/hugetlb.h>
-#include <linux/dma-attrs.h>
 #include <linux/slab.h>
 #include <rdma/ib_umem_odp.h>
 
@@ -92,12 +91,12 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	unsigned long npages;
 	int ret;
 	int i;
-	DEFINE_DMA_ATTRS(attrs);
+	unsigned long attrs = 0;
 	struct scatterlist *sg, *sg_list_start;
 	int need_release = 0;
 
 	if (dmasync)
-		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
+		attrs |= DMA_ATTR_WRITE_BARRIER;
 
 	if (!size)
 		return ERR_PTR(-EINVAL);
@@ -215,7 +214,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 				  umem->sg_head.sgl,
 				  umem->npages,
 				  DMA_BIDIRECTIONAL,
-				  &attrs);
+				  attrs);
 
 	if (umem->nmap <= 0) {
 		ret = -ENOMEM;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7d7cf4541263..0493a0cd0520 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2893,7 +2893,7 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
 					  void *cpu_addr, size_t size,
 					  enum dma_data_direction direction,
-					  struct dma_attrs *attrs)
+					  unsigned long attrs)
 {
 	return dma_map_single_attrs(dev->dma_device, cpu_addr, size,
 				    direction, attrs);
@@ -2902,7 +2902,7 @@ static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
 static inline void ib_dma_unmap_single_attrs(struct ib_device *dev,
 					     u64 addr, size_t size,
 					     enum dma_data_direction direction,
-					     struct dma_attrs *attrs)
+					     unsigned long attrs)
 {
 	return dma_unmap_single_attrs(dev->dma_device, addr, size,
 				      direction, attrs);
@@ -2980,7 +2980,7 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      struct scatterlist *sg, int nents,
 				      enum dma_data_direction direction,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
 }
@@ -2988,7 +2988,7 @@ static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 					 struct scatterlist *sg, int nents,
 					 enum dma_data_direction direction,
-					 struct dma_attrs *attrs)
+					 unsigned long attrs)
 {
 	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
 }
-- 
1.9.1
