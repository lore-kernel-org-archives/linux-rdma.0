From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/6] IB/umem: Update on demand page (ODP) support
Date: Wed, 18 Jan 2017 16:58:07 +0200
Message-ID: <20170118145811.9136-3-leon@kernel.org>
References: <20170118145811.9136-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118145811.9136-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently ODP MR may explicitly register virtual address space area
of limited length.
This change allows MR to cover entire process virtual address space
dynamicaly adding/removing translation entries to device MTT.

Add following changes to support implicit MR:
* Allow umem to be zero size to back-up implicit MR.
* Add new function ib_alloc_odp_umem() to add virtual memory regions
  to implicit MR dynamically on demand.
* Add new function rbt_ib_umem_lookup() to find dynamically added
  virtual memory regions.
* Expose function rbt_ib_umem_for_each_in_range() to other modules and
  make it safe

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/umem.c        |  3 --
 drivers/infiniband/core/umem_odp.c    | 87 +++++++++++++++++++++++++++++++----
 drivers/infiniband/core/umem_rbtree.c | 21 +++++++--
 include/rdma/ib_umem_odp.h            | 21 +++++++--
 4 files changed, 113 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 1e62a5f..9f9630b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -99,9 +99,6 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (dmasync)
 		dma_attrs |= DMA_ATTR_WRITE_BARRIER;
 
-	if (!size)
-		return ERR_PTR(-EINVAL);
-
 	/*
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 6b079a3..1104d36 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -239,6 +239,71 @@ static const struct mmu_notifier_ops ib_umem_notifiers = {
 	.invalidate_range_end       = ib_umem_notifier_invalidate_range_end,
 };
 
+struct ib_umem *ib_alloc_odp_umem(struct ib_ucontext *context,
+				  unsigned long addr,
+				  size_t size)
+{
+	struct ib_umem *umem;
+	struct ib_umem_odp *odp_data;
+	int pages = size >> PAGE_SHIFT;
+	int ret;
+
+	umem = kzalloc(sizeof(*umem), GFP_KERNEL);
+	if (!umem)
+		return ERR_PTR(-ENOMEM);
+
+	umem->context   = context;
+	umem->length    = size;
+	umem->address   = addr;
+	umem->page_size = PAGE_SIZE;
+	umem->writable  = 1;
+
+	odp_data = kzalloc(sizeof(*odp_data), GFP_KERNEL);
+	if (!odp_data) {
+		ret = -ENOMEM;
+		goto out_umem;
+	}
+	odp_data->umem = umem;
+
+	mutex_init(&odp_data->umem_mutex);
+	init_completion(&odp_data->notifier_completion);
+
+	odp_data->page_list = vzalloc(pages * sizeof(*odp_data->page_list));
+	if (!odp_data->page_list) {
+		ret = -ENOMEM;
+		goto out_odp_data;
+	}
+
+	odp_data->dma_list = vzalloc(pages * sizeof(*odp_data->dma_list));
+	if (!odp_data->dma_list) {
+		ret = -ENOMEM;
+		goto out_page_list;
+	}
+
+	down_write(&context->umem_rwsem);
+	context->odp_mrs_count++;
+	rbt_ib_umem_insert(&odp_data->interval_tree, &context->umem_tree);
+	if (likely(!atomic_read(&context->notifier_count)))
+		odp_data->mn_counters_active = true;
+	else
+		list_add(&odp_data->no_private_counters,
+			 &context->no_private_counters);
+	up_write(&context->umem_rwsem);
+
+	umem->odp_data = odp_data;
+
+	return umem;
+
+out_page_list:
+	vfree(odp_data->page_list);
+out_odp_data:
+	kfree(odp_data);
+out_umem:
+	kfree(umem);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(ib_alloc_odp_umem);
+
 int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 {
 	int ret_val;
@@ -270,18 +335,20 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 
 	init_completion(&umem->odp_data->notifier_completion);
 
-	umem->odp_data->page_list = vzalloc(ib_umem_num_pages(umem) *
+	if (ib_umem_num_pages(umem)) {
+		umem->odp_data->page_list = vzalloc(ib_umem_num_pages(umem) *
 					    sizeof(*umem->odp_data->page_list));
-	if (!umem->odp_data->page_list) {
-		ret_val = -ENOMEM;
-		goto out_odp_data;
-	}
+		if (!umem->odp_data->page_list) {
+			ret_val = -ENOMEM;
+			goto out_odp_data;
+		}
 
-	umem->odp_data->dma_list = vzalloc(ib_umem_num_pages(umem) *
+		umem->odp_data->dma_list = vzalloc(ib_umem_num_pages(umem) *
 					  sizeof(*umem->odp_data->dma_list));
-	if (!umem->odp_data->dma_list) {
-		ret_val = -ENOMEM;
-		goto out_page_list;
+		if (!umem->odp_data->dma_list) {
+			ret_val = -ENOMEM;
+			goto out_page_list;
+		}
 	}
 
 	/*
@@ -466,6 +533,7 @@ static int ib_umem_odp_map_dma_single_page(
 		}
 		umem->odp_data->dma_list[page_index] = dma_addr | access_mask;
 		umem->odp_data->page_list[page_index] = page;
+		umem->npages++;
 		stored_page = 1;
 	} else if (umem->odp_data->page_list[page_index] == page) {
 		umem->odp_data->dma_list[page_index] |= access_mask;
@@ -665,6 +733,7 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
 				put_page(page);
 			umem->odp_data->page_list[idx] = NULL;
 			umem->odp_data->dma_list[idx] = 0;
+			umem->npages--;
 		}
 	}
 	mutex_unlock(&umem->odp_data->umem_mutex);
diff --git a/drivers/infiniband/core/umem_rbtree.c b/drivers/infiniband/core/umem_rbtree.c
index 727d788..d176597 100644
--- a/drivers/infiniband/core/umem_rbtree.c
+++ b/drivers/infiniband/core/umem_rbtree.c
@@ -78,17 +78,32 @@ int rbt_ib_umem_for_each_in_range(struct rb_root *root,
 				  void *cookie)
 {
 	int ret_val = 0;
-	struct umem_odp_node *node;
+	struct umem_odp_node *node, *next;
 	struct ib_umem_odp *umem;
 
 	if (unlikely(start == last))
 		return ret_val;
 
-	for (node = rbt_ib_umem_iter_first(root, start, last - 1); node;
-			node = rbt_ib_umem_iter_next(node, start, last - 1)) {
+	for (node = rbt_ib_umem_iter_first(root, start, last - 1);
+			node; node = next) {
+		next = rbt_ib_umem_iter_next(node, start, last - 1);
 		umem = container_of(node, struct ib_umem_odp, interval_tree);
 		ret_val = cb(umem->umem, start, last, cookie) || ret_val;
 	}
 
 	return ret_val;
 }
+EXPORT_SYMBOL(rbt_ib_umem_for_each_in_range);
+
+struct ib_umem_odp *rbt_ib_umem_lookup(struct rb_root *root,
+				       u64 addr, u64 length)
+{
+	struct umem_odp_node *node;
+
+	node = rbt_ib_umem_iter_first(root, addr, addr + length - 1);
+	if (node)
+		return container_of(node, struct ib_umem_odp, interval_tree);
+	return NULL;
+
+}
+EXPORT_SYMBOL(rbt_ib_umem_lookup);
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 3da0b16..542cd8b 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -79,11 +79,15 @@ struct ib_umem_odp {
 
 	struct completion	notifier_completion;
 	int			dying;
+	struct work_struct	work;
 };
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 
 int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem);
+struct ib_umem *ib_alloc_odp_umem(struct ib_ucontext *context,
+				  unsigned long addr,
+				  size_t size);
 
 void ib_umem_odp_release(struct ib_umem *umem);
 
@@ -117,10 +121,12 @@ typedef int (*umem_call_back)(struct ib_umem *item, u64 start, u64 end,
 int rbt_ib_umem_for_each_in_range(struct rb_root *root, u64 start, u64 end,
 				  umem_call_back cb, void *cookie);
 
-struct umem_odp_node *rbt_ib_umem_iter_first(struct rb_root *root,
-					     u64 start, u64 last);
-struct umem_odp_node *rbt_ib_umem_iter_next(struct umem_odp_node *node,
-					    u64 start, u64 last);
+/*
+ * Find first region intersecting with address range.
+ * Return NULL if not found
+ */
+struct ib_umem_odp *rbt_ib_umem_lookup(struct rb_root *root,
+				       u64 addr, u64 length);
 
 static inline int ib_umem_mmu_notifier_retry(struct ib_umem *item,
 					     unsigned long mmu_seq)
@@ -153,6 +159,13 @@ static inline int ib_umem_odp_get(struct ib_ucontext *context,
 	return -EINVAL;
 }
 
+static inline struct ib_umem *ib_alloc_odp_umem(struct ib_ucontext *context,
+						unsigned long addr,
+						size_t size)
+{
+	return ERR_PTR(-EINVAL);
+}
+
 static inline void ib_umem_odp_release(struct ib_umem *umem) {}
 
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
