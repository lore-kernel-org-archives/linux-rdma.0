From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 09/16] IB/hfi1: Make the cache handler own its rb tree root
Date: Thu, 28 Jul 2016 15:21:20 -0400
Message-ID: <1469733687-31738-10-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The objects which use cache handling should reference their own handler
object not the internal data structure it uses to track the nodes.

Have the "users" of the mmu notifier code pass opaque objects which can
then be properly used in the mmu callbacks depending on the owners needs.

This patch has the additional benefit that operations no longer require a
look up in a list to find the handlers.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h          |  3 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c       | 98 ++++++++++---------------------
 drivers/infiniband/hw/hfi1/mmu_rb.h       | 23 ++++----
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 54 +++++++----------
 drivers/infiniband/hw/hfi1/user_sdma.c    | 26 ++++----
 drivers/infiniband/hw/hfi1/user_sdma.h    |  2 +-
 6 files changed, 81 insertions(+), 125 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 67f37c9ea960..ba9083602cbd 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1186,6 +1186,7 @@ struct hfi1_devdata {
 
 struct tid_rb_node;
 struct mmu_rb_node;
+struct mmu_rb_handler;
 
 /* Private data for file operations */
 struct hfi1_filedata {
@@ -1196,7 +1197,7 @@ struct hfi1_filedata {
 	/* for cpu affinity; -1 if none */
 	int rec_cpu_num;
 	u32 tid_n_pinned;
-	struct rb_root tid_rb_root;
+	struct mmu_rb_handler *handler;
 	struct tid_rb_node **entry_to_rb;
 	spinlock_t tid_lock; /* protect tid_[limit,used] counters */
 	u32 tid_limit;
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index e5c5ef4cf06c..9fbcfed4d34c 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -53,20 +53,16 @@
 #include "trace.h"
 
 struct mmu_rb_handler {
-	struct list_head list;
 	struct mmu_notifier mn;
-	struct rb_root *root;
+	struct rb_root root;
+	void *ops_arg;
 	spinlock_t lock;        /* protect the RB tree */
 	struct mmu_rb_ops *ops;
 	struct mm_struct *mm;
 };
 
-static LIST_HEAD(mmu_rb_handlers);
-static DEFINE_SPINLOCK(mmu_rb_lock); /* protect mmu_rb_handlers list */
-
 static unsigned long mmu_node_start(struct mmu_rb_node *);
 static unsigned long mmu_node_last(struct mmu_rb_node *);
-static struct mmu_rb_handler *find_mmu_handler(struct rb_root *);
 static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
 				     unsigned long);
 static inline void mmu_notifier_range_start(struct mmu_notifier *,
@@ -96,8 +92,9 @@ static unsigned long mmu_node_last(struct mmu_rb_node *node)
 	return PAGE_ALIGN(node->addr + node->len) - 1;
 }
 
-int hfi1_mmu_rb_register(struct mm_struct *mm, struct rb_root *root,
-			 struct mmu_rb_ops *ops)
+int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
+			 struct mmu_rb_ops *ops,
+			 struct mmu_rb_handler **handler)
 {
 	struct mmu_rb_handler *handlr;
 	int ret;
@@ -106,8 +103,9 @@ int hfi1_mmu_rb_register(struct mm_struct *mm, struct rb_root *root,
 	if (!handlr)
 		return -ENOMEM;
 
-	handlr->root = root;
+	handlr->root = RB_ROOT;
 	handlr->ops = ops;
+	handlr->ops_arg = ops_arg;
 	INIT_HLIST_NODE(&handlr->mn.hlist);
 	spin_lock_init(&handlr->lock);
 	handlr->mn.ops = &mn_opts;
@@ -119,52 +117,38 @@ int hfi1_mmu_rb_register(struct mm_struct *mm, struct rb_root *root,
 		return ret;
 	}
 
-	spin_lock(&mmu_rb_lock);
-	list_add_tail_rcu(&handlr->list, &mmu_rb_handlers);
-	spin_unlock(&mmu_rb_lock);
-
-	return ret;
+	*handler = handlr;
+	return 0;
 }
 
-void hfi1_mmu_rb_unregister(struct rb_root *root)
+void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 {
-	struct mmu_rb_handler *handler = find_mmu_handler(root);
 	struct mmu_rb_node *rbnode;
 	struct rb_node *node;
 	unsigned long flags;
 
-	if (!handler)
-		return;
-
 	/* Unregister first so we don't get any more notifications. */
 	mmu_notifier_unregister(&handler->mn, handler->mm);
 
-	spin_lock(&mmu_rb_lock);
-	list_del_rcu(&handler->list);
-	spin_unlock(&mmu_rb_lock);
-	synchronize_rcu();
-
 	spin_lock_irqsave(&handler->lock, flags);
-	while ((node = rb_first(root))) {
+	while ((node = rb_first(&handler->root))) {
 		rbnode = rb_entry(node, struct mmu_rb_node, node);
-		rb_erase(node, root);
-		handler->ops->remove(root, rbnode, NULL);
+		rb_erase(node, &handler->root);
+		handler->ops->remove(handler->ops_arg, rbnode,
+				     NULL);
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 
 	kfree(handler);
 }
 
-int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
+int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
+		       struct mmu_rb_node *mnode)
 {
-	struct mmu_rb_handler *handler = find_mmu_handler(root);
 	struct mmu_rb_node *node;
 	unsigned long flags;
 	int ret = 0;
 
-	if (!handler)
-		return -EINVAL;
-
 	spin_lock_irqsave(&handler->lock, flags);
 	hfi1_cdbg(MMU, "Inserting node addr 0x%llx, len %u", mnode->addr,
 		  mnode->len);
@@ -173,11 +157,11 @@ int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 		ret = -EINVAL;
 		goto unlock;
 	}
-	__mmu_int_rb_insert(mnode, root);
+	__mmu_int_rb_insert(mnode, &handler->root);
 
-	ret = handler->ops->insert(root, mnode);
+	ret = handler->ops->insert(handler->ops_arg, mnode);
 	if (ret)
-		__mmu_int_rb_remove(mnode, root);
+		__mmu_int_rb_remove(mnode, &handler->root);
 unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
@@ -192,10 +176,10 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 
 	hfi1_cdbg(MMU, "Searching for addr 0x%llx, len %u", addr, len);
 	if (!handler->ops->filter) {
-		node = __mmu_int_rb_iter_first(handler->root, addr,
+		node = __mmu_int_rb_iter_first(&handler->root, addr,
 					       (addr + len) - 1);
 	} else {
-		for (node = __mmu_int_rb_iter_first(handler->root, addr,
+		for (node = __mmu_int_rb_iter_first(&handler->root, addr,
 						    (addr + len) - 1);
 		     node;
 		     node = __mmu_int_rb_iter_next(node, addr,
@@ -207,56 +191,34 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 	return node;
 }
 
-struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *root,
+struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
 					unsigned long addr, unsigned long len)
 {
-	struct mmu_rb_handler *handler = find_mmu_handler(root);
 	struct mmu_rb_node *node;
 	unsigned long flags;
 
-	if (!handler)
-		return ERR_PTR(-EINVAL);
-
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
 	if (node)
-		__mmu_int_rb_remove(node, handler->root);
+		__mmu_int_rb_remove(node, &handler->root);
 	spin_unlock_irqrestore(&handler->lock, flags);
 
 	return node;
 }
 
-void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
+void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
+			struct mmu_rb_node *node)
 {
 	unsigned long flags;
-	struct mmu_rb_handler *handler = find_mmu_handler(root);
-
-	if (!handler || !node)
-		return;
 
 	/* Validity of handler and node pointers has been checked by caller. */
 	hfi1_cdbg(MMU, "Removing node addr 0x%llx, len %u", node->addr,
 		  node->len);
 	spin_lock_irqsave(&handler->lock, flags);
-	__mmu_int_rb_remove(node, handler->root);
+	__mmu_int_rb_remove(node, &handler->root);
 	spin_unlock_irqrestore(&handler->lock, flags);
 
-	handler->ops->remove(handler->root, node, NULL);
-}
-
-static struct mmu_rb_handler *find_mmu_handler(struct rb_root *root)
-{
-	struct mmu_rb_handler *handler;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(handler, &mmu_rb_handlers, list) {
-		if (handler->root == root)
-			goto unlock;
-	}
-	handler = NULL;
-unlock:
-	rcu_read_unlock();
-	return handler;
+	handler->ops->remove(handler->ops_arg, node, NULL);
 }
 
 static inline void mmu_notifier_page(struct mmu_notifier *mn,
@@ -279,7 +241,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 {
 	struct mmu_rb_handler *handler =
 		container_of(mn, struct mmu_rb_handler, mn);
-	struct rb_root *root = handler->root;
+	struct rb_root *root = &handler->root;
 	struct mmu_rb_node *node, *ptr = NULL;
 	unsigned long flags;
 
@@ -290,9 +252,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		ptr = __mmu_int_rb_iter_next(node, start, end - 1);
 		hfi1_cdbg(MMU, "Invalidating node addr 0x%llx, len %u",
 			  node->addr, node->len);
-		if (handler->ops->invalidate(root, node)) {
+		if (handler->ops->invalidate(handler->ops_arg, node)) {
 			__mmu_int_rb_remove(node, root);
-			handler->ops->remove(root, node, mm);
+			handler->ops->remove(handler->ops_arg, node, mm);
 		}
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 489a691856e5..2cedfbe2189e 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -59,18 +59,21 @@ struct mmu_rb_node {
 struct mmu_rb_ops {
 	bool (*filter)(struct mmu_rb_node *node, unsigned long addr,
 		       unsigned long len);
-	int (*insert)(struct rb_root *root, struct mmu_rb_node *mnode);
-	void (*remove)(struct rb_root *root, struct mmu_rb_node *mnode,
+	int (*insert)(void *ops_arg, struct mmu_rb_node *mnode);
+	void (*remove)(void *ops_arg, struct mmu_rb_node *mnode,
 		       struct mm_struct *mm);
-	int (*invalidate)(struct rb_root *root, struct mmu_rb_node *node);
+	int (*invalidate)(void *ops_arg, struct mmu_rb_node *node);
 };
 
-int hfi1_mmu_rb_register(struct mm_struct *mm, struct rb_root *root,
-			 struct mmu_rb_ops *ops);
-void hfi1_mmu_rb_unregister(struct rb_root *);
-int hfi1_mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
-void hfi1_mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
-struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *, unsigned long,
-					unsigned long);
+int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
+			 struct mmu_rb_ops *ops,
+			 struct mmu_rb_handler **handler);
+void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler);
+int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
+		       struct mmu_rb_node *mnode);
+void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
+			struct mmu_rb_node *mnode);
+struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
+					unsigned long addr, unsigned long len);
 
 #endif /* _HFI1_MMU_RB_H */
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index a2f7e719dc4d..269a948189e0 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -82,14 +82,14 @@ struct tid_pageset {
 	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
 
 static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
-			    struct rb_root *);
+			    struct hfi1_filedata *);
 static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
-static int tid_rb_insert(struct rb_root *, struct mmu_rb_node *);
-static void tid_rb_remove(struct rb_root *, struct mmu_rb_node *,
+static int tid_rb_insert(void *, struct mmu_rb_node *);
+static void tid_rb_remove(void *, struct mmu_rb_node *,
 			  struct mm_struct *);
-static int tid_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
+static int tid_rb_invalidate(void *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
 			    u32 *, unsigned *, unsigned *);
@@ -162,7 +162,6 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 
 	spin_lock_init(&fd->tid_lock);
 	spin_lock_init(&fd->invalid_lock);
-	fd->tid_rb_root = RB_ROOT;
 
 	if (!uctxt->subctxt_cnt || !fd->subctxt) {
 		exp_tid_group_init(&uctxt->tid_group_list);
@@ -211,8 +210,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		 * fails, continue but turn off the TID caching for
 		 * all user contexts.
 		 */
-		ret = hfi1_mmu_rb_register(fd->mm, &fd->tid_rb_root,
-					   &tid_rb_ops);
+		ret = hfi1_mmu_rb_register(fd, fd->mm, &tid_rb_ops, &fd->handler);
 		if (ret) {
 			dd_dev_info(dd,
 				    "Failed MMU notifier registration %d\n",
@@ -263,17 +261,15 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 	 * was freed.
 	 */
 	if (!HFI1_CAP_IS_USET(TID_UNMAP))
-		hfi1_mmu_rb_unregister(&fd->tid_rb_root);
+		hfi1_mmu_rb_unregister(fd->handler);
 
 	kfree(fd->invalid_tids);
 
 	if (!uctxt->cnt) {
 		if (!EXP_TID_SET_EMPTY(uctxt->tid_full_list))
-			unlock_exp_tids(uctxt, &uctxt->tid_full_list,
-					&fd->tid_rb_root);
+			unlock_exp_tids(uctxt, &uctxt->tid_full_list, fd);
 		if (!EXP_TID_SET_EMPTY(uctxt->tid_used_list))
-			unlock_exp_tids(uctxt, &uctxt->tid_used_list,
-					&fd->tid_rb_root);
+			unlock_exp_tids(uctxt, &uctxt->tid_used_list, fd);
 		list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
 					 list) {
 			list_del_init(&grp->list);
@@ -830,7 +826,6 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct tid_rb_node *node;
 	struct hfi1_devdata *dd = uctxt->dd;
-	struct rb_root *root = &fd->tid_rb_root;
 	dma_addr_t phys;
 
 	/*
@@ -863,9 +858,9 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	memcpy(node->pages, pages, sizeof(struct page *) * npages);
 
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		ret = tid_rb_insert(root, &node->mmu);
+		ret = tid_rb_insert(fd, &node->mmu);
 	else
-		ret = hfi1_mmu_rb_insert(root, &node->mmu);
+		ret = hfi1_mmu_rb_insert(fd->handler, &node->mmu);
 
 	if (ret) {
 		hfi1_cdbg(TID, "Failed to insert RB node %u 0x%lx, 0x%lx %d",
@@ -906,9 +901,9 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		tid_rb_remove(&fd->tid_rb_root, &node->mmu, fd->mm);
+		tid_rb_remove(fd, &node->mmu, fd->mm);
 	else
-		hfi1_mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
+		hfi1_mmu_rb_remove(fd->handler, &node->mmu);
 
 	if (grp)
 		*grp = node->grp;
@@ -950,11 +945,10 @@ static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
 }
 
 static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
-			    struct exp_tid_set *set, struct rb_root *root)
+			    struct exp_tid_set *set,
+			    struct hfi1_filedata *fd)
 {
 	struct tid_group *grp, *ptr;
-	struct hfi1_filedata *fd = container_of(root, struct hfi1_filedata,
-						tid_rb_root);
 	int i;
 
 	list_for_each_entry_safe(grp, ptr, &set->list, list) {
@@ -970,10 +964,9 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 				if (!node || node->rcventry != rcventry)
 					continue;
 				if (HFI1_CAP_IS_USET(TID_UNMAP))
-					tid_rb_remove(&fd->tid_rb_root,
-						      &node->mmu, fd->mm);
+					tid_rb_remove(fd, &node->mmu, fd->mm);
 				else
-					hfi1_mmu_rb_remove(&fd->tid_rb_root,
+					hfi1_mmu_rb_remove(fd->handler,
 							   &node->mmu);
 				clear_tid_node(fd, node);
 			}
@@ -981,10 +974,9 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 	}
 }
 
-static int tid_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
+static int tid_rb_invalidate(void *arg, struct mmu_rb_node *mnode)
 {
-	struct hfi1_filedata *fdata =
-		container_of(root, struct hfi1_filedata, tid_rb_root);
+	struct hfi1_filedata *fdata = arg;
 	struct hfi1_ctxtdata *uctxt = fdata->uctxt;
 	struct tid_rb_node *node =
 		container_of(mnode, struct tid_rb_node, mmu);
@@ -1025,10 +1017,9 @@ static int tid_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
 	return 0;
 }
 
-static int tid_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
+static int tid_rb_insert(void *arg, struct mmu_rb_node *node)
 {
-	struct hfi1_filedata *fdata =
-		container_of(root, struct hfi1_filedata, tid_rb_root);
+	struct hfi1_filedata *fdata = arg;
 	struct tid_rb_node *tnode =
 		container_of(node, struct tid_rb_node, mmu);
 	u32 base = fdata->uctxt->expected_base;
@@ -1037,11 +1028,10 @@ static int tid_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 	return 0;
 }
 
-static void tid_rb_remove(struct rb_root *root, struct mmu_rb_node *node,
+static void tid_rb_remove(void *arg, struct mmu_rb_node *node,
 			  struct mm_struct *mm)
 {
-	struct hfi1_filedata *fdata =
-		container_of(root, struct hfi1_filedata, tid_rb_root);
+	struct hfi1_filedata *fdata = arg;
 	struct tid_rb_node *tnode =
 		container_of(node, struct tid_rb_node, mmu);
 	u32 base = fdata->uctxt->expected_base;
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 640c244b665b..8be095e1a538 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -305,10 +305,10 @@ static int defer_packet_queue(
 	unsigned seq);
 static void activate_packet_queue(struct iowait *, int);
 static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
-static int sdma_rb_insert(struct rb_root *, struct mmu_rb_node *);
-static void sdma_rb_remove(struct rb_root *, struct mmu_rb_node *,
+static int sdma_rb_insert(void *, struct mmu_rb_node *);
+static void sdma_rb_remove(void *, struct mmu_rb_node *,
 			   struct mm_struct *);
-static int sdma_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
+static int sdma_rb_invalidate(void *, struct mmu_rb_node *);
 
 static struct mmu_rb_ops sdma_rb_ops = {
 	.filter = sdma_rb_filter,
@@ -410,7 +410,6 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	pq->state = SDMA_PKT_Q_INACTIVE;
 	atomic_set(&pq->n_reqs, 0);
 	init_waitqueue_head(&pq->wait);
-	pq->sdma_rb_root = RB_ROOT;
 	INIT_LIST_HEAD(&pq->evict);
 	spin_lock_init(&pq->evict_lock);
 	pq->mm = fd->mm;
@@ -443,7 +442,7 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	cq->nentries = hfi1_sdma_comp_ring_size;
 	fd->cq = cq;
 
-	ret = hfi1_mmu_rb_register(pq->mm, &pq->sdma_rb_root, &sdma_rb_ops);
+	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, &pq->handler);
 	if (ret) {
 		dd_dev_err(dd, "Failed to register with MMU %d", ret);
 		goto done;
@@ -481,7 +480,8 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 		  uctxt->ctxt, fd->subctxt);
 	pq = fd->pq;
 	if (pq) {
-		hfi1_mmu_rb_unregister(&pq->sdma_rb_root);
+		if (pq->handler)
+			hfi1_mmu_rb_unregister(pq->handler);
 		spin_lock_irqsave(&uctxt->sdma_qlock, flags);
 		if (!list_empty(&pq->list))
 			list_del_init(&pq->list);
@@ -1145,7 +1145,7 @@ static u32 sdma_cache_evict(struct hfi1_user_sdma_pkt_q *pq, u32 npages)
 	spin_unlock(&pq->evict_lock);
 
 	list_for_each_entry_safe(node, ptr, &to_evict, list)
-		hfi1_mmu_rb_remove(&pq->sdma_rb_root, &node->rb);
+		hfi1_mmu_rb_remove(pq->handler, &node->rb);
 
 	return cleared;
 }
@@ -1159,7 +1159,7 @@ static int pin_vector_pages(struct user_sdma_request *req,
 	struct sdma_mmu_node *node = NULL;
 	struct mmu_rb_node *rb_node;
 
-	rb_node = hfi1_mmu_rb_extract(&pq->sdma_rb_root,
+	rb_node = hfi1_mmu_rb_extract(pq->handler,
 				      (unsigned long)iovec->iov.iov_base,
 				      iovec->iov.iov_len);
 	if (rb_node && !IS_ERR(rb_node))
@@ -1240,7 +1240,7 @@ retry:
 	iovec->npages = npages;
 	iovec->node = node;
 
-	ret = hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb);
+	ret = hfi1_mmu_rb_insert(req->pq->handler, &node->rb);
 	if (ret) {
 		spin_lock(&pq->evict_lock);
 		if (!list_empty(&node->list))
@@ -1612,7 +1612,7 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 				continue;
 
 			if (unpin)
-				hfi1_mmu_rb_remove(&req->pq->sdma_rb_root,
+				hfi1_mmu_rb_remove(req->pq->handler,
 						   &node->rb);
 			else
 				atomic_dec(&node->refcount);
@@ -1642,7 +1642,7 @@ static bool sdma_rb_filter(struct mmu_rb_node *node, unsigned long addr,
 	return (bool)(node->addr == addr);
 }
 
-static int sdma_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
+static int sdma_rb_insert(void *arg, struct mmu_rb_node *mnode)
 {
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
@@ -1651,7 +1651,7 @@ static int sdma_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 	return 0;
 }
 
-static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
+static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode,
 			   struct mm_struct *mm)
 {
 	struct sdma_mmu_node *node =
@@ -1692,7 +1692,7 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 	kfree(node);
 }
 
-static int sdma_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
+static int sdma_rb_invalidate(void *arg, struct mmu_rb_node *mnode)
 {
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index ff49f74f43f4..bcdc9e8ae1f0 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -68,7 +68,7 @@ struct hfi1_user_sdma_pkt_q {
 	unsigned state;
 	wait_queue_head_t wait;
 	unsigned long unpinned;
-	struct rb_root sdma_rb_root;
+	struct mmu_rb_handler *handler;
 	u32 n_locked;
 	struct list_head evict;
 	spinlock_t evict_lock; /* protect evict and n_locked */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
