From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 3/7] IB/core: Umem tunneling peer memory APIs
Date: Thu, 11 Feb 2016 18:12:53 +0200
Message-ID: <1455207177-11949-4-git-send-email-artemyko@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Builds umem over peer memory client functionality.
It tries to get a peer client for a given address range.
In case it was found further memory calls are tunneled to that peer client.
ib_umem_get_flags was added as successor of ib_umem_get to have additional
flags, for instance indication whether this umem
can be part of a peer client.
Deprecated ib_umem_get left for backward compatibility.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/umem.c | 100 ++++++++++++++++++++++++++++++++++++++---
 include/rdma/ib_umem.h         |  34 +++++++++++---
 2 files changed, 123 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 38acb3c..2eab34e 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -43,6 +43,63 @@
 
 #include "uverbs.h"
 
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+static struct ib_umem *peer_umem_get(struct ib_peer_memory_client *ib_peer_mem,
+				     struct ib_umem *umem, unsigned long addr,
+				     int dmasync)
+{
+	int ret;
+	const struct peer_memory_client *peer_mem = ib_peer_mem->peer_mem;
+
+	umem->ib_peer_mem = ib_peer_mem;
+	/*
+	 * We always request write permissions to the pages, to force breaking
+	 * of any CoW during the registration of the MR. For read-only MRs we
+	 * use the "force" flag to indicate that CoW breaking is required but
+	 * the registration should not fail if referencing read-only areas.
+	 */
+	ret = peer_mem->get_pages(addr, umem->length,
+				  1, !umem->writable,
+				  &umem->sg_head,
+				  umem->peer_mem_client_context,
+				  0);
+	if (ret)
+		goto out;
+
+	umem->page_size = peer_mem->get_page_size
+					(umem->peer_mem_client_context);
+	ret = peer_mem->dma_map(&umem->sg_head,
+				umem->peer_mem_client_context,
+				umem->context->device->dma_device,
+				dmasync,
+				&umem->nmap);
+	if (ret)
+		goto put_pages;
+
+	return umem;
+
+put_pages:
+	peer_mem->put_pages(&umem->sg_head,
+			    umem->peer_mem_client_context);
+out:
+	ib_put_peer_client(ib_peer_mem, umem->peer_mem_client_context);
+	return ERR_PTR(ret);
+}
+
+static void peer_umem_release(struct ib_umem *umem)
+{
+	const struct peer_memory_client *peer_mem =
+				umem->ib_peer_mem->peer_mem;
+
+	peer_mem->dma_unmap(&umem->sg_head,
+			    umem->peer_mem_client_context,
+			    umem->context->device->dma_device);
+	peer_mem->put_pages(&umem->sg_head,
+			    umem->peer_mem_client_context);
+	ib_put_peer_client(umem->ib_peer_mem, umem->peer_mem_client_context);
+	kfree(umem);
+}
+#endif
 
 static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int dirty)
 {
@@ -69,7 +126,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 }
 
 /**
- * ib_umem_get - Pin and DMA map userspace memory.
+ * ib_umem_get_flags - Pin and DMA map userspace memory.
  *
  * If access flags indicate ODP memory, avoid pinning. Instead, stores
  * the mm for future page fault handling in conjunction with MMU notifiers.
@@ -78,10 +135,12 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
  * @access: IB_ACCESS_xxx flags for memory being pinned
- * @dmasync: flush in-flight DMA when the memory region is written
+ * @flags: IB_UMEM_xxx flags for memory being used
  */
-struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync)
+struct ib_umem *ib_umem_get_flags(struct ib_ucontext *context,
+				  unsigned long addr,
+				  size_t size, int access,
+				  unsigned long flags)
 {
 	struct ib_umem *umem;
 	struct page **page_list;
@@ -96,7 +155,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	struct scatterlist *sg, *sg_list_start;
 	int need_release = 0;
 
-	if (dmasync)
+	if (flags & IB_UMEM_DMA_SYNC)
 		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
 
 	if (!size)
@@ -144,6 +203,28 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	umem->odp_data = NULL;
 
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	if (flags & IB_UMEM_PEER_ALLOW) {
+		struct ib_peer_memory_client *peer_mem_client;
+		struct ib_umem *peer_umem;
+
+		peer_mem_client =
+			ib_get_peer_client(context, addr, size,
+					   &umem->peer_mem_client_context);
+		if (IS_ERR(peer_mem_client)) {
+			kfree(umem);
+			return ERR_CAST(peer_mem_client);
+
+		} else if (peer_mem_client) {
+			peer_umem = peer_umem_get(peer_mem_client, umem, addr,
+						  flags & IB_UMEM_DMA_SYNC);
+			if (IS_ERR(peer_umem))
+				kfree(umem);
+			return peer_umem;
+		}
+	}
+#endif
+
 	/* We assume the memory is from hugetlb until proved otherwise */
 	umem->hugetlb   = 1;
 
@@ -240,7 +321,7 @@ out:
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
 }
-EXPORT_SYMBOL(ib_umem_get);
+EXPORT_SYMBOL(ib_umem_get_flags);
 
 static void ib_umem_account(struct work_struct *work)
 {
@@ -264,6 +345,13 @@ void ib_umem_release(struct ib_umem *umem)
 	struct task_struct *task;
 	unsigned long diff;
 
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	if (umem->ib_peer_mem) {
+		peer_umem_release(umem);
+		return;
+	}
+#endif
+
 	if (umem->odp_data) {
 		ib_umem_odp_release(umem);
 		return;
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 2d83cfd..bb760f9 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -36,6 +36,9 @@
 #include <linux/list.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+#include <rdma/ib_peer_mem.h>
+#endif
 
 struct ib_ucontext;
 struct ib_umem_odp;
@@ -55,6 +58,12 @@ struct ib_umem {
 	struct sg_table sg_head;
 	int             nmap;
 	int             npages;
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	/* peer memory that manages this umem */
+	struct ib_peer_memory_client *ib_peer_mem;
+	/* peer memory private context */
+	void *peer_mem_client_context;
+#endif
 };
 
 /* Returns the offset of the umem start relative to the first page. */
@@ -80,10 +89,16 @@ static inline size_t ib_umem_num_pages(struct ib_umem *umem)
 	return (ib_umem_end(umem) - ib_umem_start(umem)) >> PAGE_SHIFT;
 }
 
+enum ib_peer_mem_flags {
+	IB_UMEM_DMA_SYNC	= (1 << 0),
+	IB_UMEM_PEER_ALLOW	= (1 << 1),
+};
+
 #ifdef CONFIG_INFINIBAND_USER_MEM
+struct ib_umem *ib_umem_get_flags(struct ib_ucontext *context,
+				  unsigned long addr, size_t size,
+				  int access, unsigned long flags);
 
-struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
-			    size_t size, int access, int dmasync);
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
@@ -93,11 +108,13 @@ int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
 
 #include <linux/err.h>
 
-static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
-					  unsigned long addr, size_t size,
-					  int access, int dmasync) {
+static inline struct ib_umem *ib_umem_get_flags(struct ib_ucontext *context,
+						unsigned long addr, size_t size,
+						int access,
+						unsigned long flags) {
 	return ERR_PTR(-EINVAL);
 }
+
 static inline void ib_umem_release(struct ib_umem *umem) { }
 static inline int ib_umem_page_count(struct ib_umem *umem) { return 0; }
 static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offset,
@@ -106,4 +123,11 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
 }
 #endif /* CONFIG_INFINIBAND_USER_MEM */
 
+static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
+					  unsigned long addr, size_t size,
+					  int access, int dmasync) {
+	return ib_umem_get_flags(context, addr, size, access,
+				 dmasync ? IB_UMEM_DMA_SYNC : 0);
+}
+
 #endif /* IB_UMEM_H */
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
