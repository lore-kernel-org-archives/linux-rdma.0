From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v6.2] infiniband: dma-mapping: Use unsigned long for dma_attrs
Date: Wed, 13 Jul 2016 13:56:02 +0200
Message-ID: <1468410962-13820-1-git-send-email-k.kozlowski@samsung.com>
References: <1468399300-5399-17-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1468399300-5399-17-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

---

This is an update only to this patch from the set.

Changes since v6.1:
1. Rename attrs->dma_attrs everywhere.

Changes since v6:
1. Rename attrs->dma_attrs arguments in map/unmap functions (suggested
   by Bart Van Assche).
---
 drivers/infiniband/core/umem.c |  7 +++----
 include/rdma/ib_verbs.h        | 17 +++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index fe4d2e1a8b58..c68746ce6624 100644
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
+	unsigned long dma_attrs = 0;
 	struct scatterlist *sg, *sg_list_start;
 	int need_release = 0;
 
 	if (dmasync)
-		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
+		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
 
 	if (!size)
 		return ERR_PTR(-EINVAL);
@@ -215,7 +214,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 				  umem->sg_head.sgl,
 				  umem->npages,
 				  DMA_BIDIRECTIONAL,
-				  &attrs);
+				  dma_attrs);
 
 	if (umem->nmap <= 0) {
 		ret = -ENOMEM;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 156673a80704..94a0bc5b5bdd 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2910,19 +2910,19 @@ static inline void ib_dma_unmap_single(struct ib_device *dev,
 static inline u64 ib_dma_map_single_attrs(struct ib_device *dev,
 					  void *cpu_addr, size_t size,
 					  enum dma_data_direction direction,
-					  struct dma_attrs *attrs)
+					  unsigned long dma_attrs)
 {
 	return dma_map_single_attrs(dev->dma_device, cpu_addr, size,
-				    direction, attrs);
+				    direction, dma_attrs);
 }
 
 static inline void ib_dma_unmap_single_attrs(struct ib_device *dev,
 					     u64 addr, size_t size,
 					     enum dma_data_direction direction,
-					     struct dma_attrs *attrs)
+					     unsigned long dma_attrs)
 {
 	return dma_unmap_single_attrs(dev->dma_device, addr, size,
-				      direction, attrs);
+				      direction, dma_attrs);
 }
 
 /**
@@ -2997,17 +2997,18 @@ static inline void ib_dma_unmap_sg(struct ib_device *dev,
 static inline int ib_dma_map_sg_attrs(struct ib_device *dev,
 				      struct scatterlist *sg, int nents,
 				      enum dma_data_direction direction,
-				      struct dma_attrs *attrs)
+				      unsigned long dma_attrs)
 {
-	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+	return dma_map_sg_attrs(dev->dma_device, sg, nents, direction,
+				dma_attrs);
 }
 
 static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
 					 struct scatterlist *sg, int nents,
 					 enum dma_data_direction direction,
-					 struct dma_attrs *attrs)
+					 unsigned long dma_attrs)
 {
-	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, attrs);
+	dma_unmap_sg_attrs(dev->dma_device, sg, nents, direction, dma_attrs);
 }
 /**
  * ib_sg_dma_address - Return the DMA address from a scatter/gather entry
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
