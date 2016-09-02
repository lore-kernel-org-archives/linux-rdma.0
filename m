From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/9] ib_umem: Add a new, more generic ib_umem_get_attrs
Date: Fri,  2 Sep 2016 02:09:22 +0200
Message-ID: <1472774969-18997-3-git-send-email-knut.omang@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472774969-18997-1-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This call allows a full range of DMA attributes and also
DMA direction to be supplied and is just a refactor of the old ib_umem_get.
Reimplement ib_umem_get using the new generic call,
now a trivial implementation.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 23 +++++++++++++++--------
 include/rdma/ib_umem.h         | 15 ++++++++++++++-
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index c68746c..699a0f7 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -52,7 +52,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 	if (umem->nmap > 0)
 		ib_dma_unmap_sg(dev, umem->sg_head.sgl,
 				umem->nmap,
-				DMA_BIDIRECTIONAL);
+				umem->dir);
 
 	for_each_sg(umem->sg_head.sgl, sg, umem->npages, i) {
 
@@ -82,6 +82,17 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			    size_t size, int access, int dmasync)
 {
+	unsigned long dma_attrs = 0;
+	if (dmasync)
+		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
+	return ib_umem_get_attrs(context, addr, size, access, DMA_BIDIRECTIONAL, dma_attrs);
+}
+EXPORT_SYMBOL(ib_umem_get);
+
+struct ib_umem *ib_umem_get_attrs(struct ib_ucontext *context, unsigned long addr,
+				  size_t size, int access, enum dma_data_direction dir,
+				  unsigned long dma_attrs)
+{
 	struct ib_umem *umem;
 	struct page **page_list;
 	struct vm_area_struct **vma_list;
@@ -91,16 +102,11 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	unsigned long npages;
 	int ret;
 	int i;
-	unsigned long dma_attrs = 0;
 	struct scatterlist *sg, *sg_list_start;
 	int need_release = 0;
 
-	if (dmasync)
-		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
-
 	if (!size)
 		return ERR_PTR(-EINVAL);
-
 	/*
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
@@ -121,6 +127,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	umem->address   = addr;
 	umem->page_size = PAGE_SIZE;
 	umem->pid       = get_task_pid(current, PIDTYPE_PID);
+	umem->dir	= dir;
 	/*
 	 * We ask for writable memory if any of the following
 	 * access flags are set.  "Local write" and "remote write"
@@ -213,7 +220,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	umem->nmap = ib_dma_map_sg_attrs(context->device,
 				  umem->sg_head.sgl,
 				  umem->npages,
-				  DMA_BIDIRECTIONAL,
+				  dir,
 				  dma_attrs);
 
 	if (umem->nmap <= 0) {
@@ -239,7 +246,7 @@ out:
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
 }
-EXPORT_SYMBOL(ib_umem_get);
+EXPORT_SYMBOL(ib_umem_get_attrs);
 
 static void ib_umem_account(struct work_struct *work)
 {
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2d83cfd..2876679 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -36,6 +36,7 @@
 #include <linux/list.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
+#include <linux/dma-direction.h>
 
 struct ib_ucontext;
 struct ib_umem_odp;
@@ -47,6 +48,7 @@ struct ib_umem {
 	int			page_size;
 	int                     writable;
 	int                     hugetlb;
+	enum dma_data_direction dir;
 	struct work_struct	work;
 	struct pid             *pid;
 	struct mm_struct       *mm;
@@ -81,9 +83,12 @@ static inline size_t ib_umem_num_pages(struct ib_umem *umem)
 }
 
 #ifdef CONFIG_INFINIBAND_USER_MEM
-
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			    size_t size, int access, int dmasync);
+struct ib_umem *ib_umem_get_attrs(struct ib_ucontext *context, unsigned long addr,
+				  size_t size, int access,
+				  enum dma_data_direction dir,
+				  unsigned long dma_attrs);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
@@ -98,6 +103,14 @@ static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 					  int access, int dmasync) {
 	return ERR_PTR(-EINVAL);
 }
+static inline struct ib_umem *ib_umem_get_attrs(struct ib_ucontext *context,
+						unsigned long addr,
+						size_t size, int access,
+						enum dma_data_direction dir,
+						unsigned long dma_attrs)
+{
+	return ERR_PTR(-EINVAL);
+}
 static inline void ib_umem_release(struct ib_umem *umem) { }
 static inline int ib_umem_page_count(struct ib_umem *umem) { return 0; }
 static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
