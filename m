From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 13/16] IB/hfi1: Consistently call ops->remove outside spinlock
Date: Thu, 28 Jul 2016 15:21:24 -0400
Message-ID: <1469733687-31738-14-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ops->remove() callback was called by hfi1_mmu_unregister() with a
NULL mm argument while holding a spinlock.  In the case of sdma_rb_remove()
this caused it to pass current->mm to hfi1_release_user_pages()

This had 2 problems.  First this would attempt to acquire the mmap_sem
under a spin lock.  Second the use of current->mm is not always guaranteed
to be the proper mm when the fd is being closed.

Rather than depend on this implicit behavior we move all calls to
ops->remove outside of the spinlock.  This also allows the correct
mm to be used in the remove callback without fear of deadlock.

Because the MMU notifier is not guaranteed to hold mm->mmap_sem, but
usually does, we must delay all remove callbacks until out of the notifier,
when the callbacks can take the mmap_sem if they need to.

Code comments were added to clarify what the expectations are for the
users of the mmu rb tree.

Suggested-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c       | 76 +++++++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/mmu_rb.h       |  5 ++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |  4 +-
 drivers/infiniband/hw/hfi1/user_sdma.c    | 22 ++-------
 4 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 97f2d3680751..76f7b0403207 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -59,6 +59,9 @@ struct mmu_rb_handler {
 	spinlock_t lock;        /* protect the RB tree */
 	struct mmu_rb_ops *ops;
 	struct mm_struct *mm;
+	struct work_struct del_work;
+	struct list_head del_list;
+	struct workqueue_struct *wq;
 };
 
 static unsigned long mmu_node_start(struct mmu_rb_node *);
@@ -73,6 +76,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
 					unsigned long, unsigned long);
 static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *,
 					   unsigned long, unsigned long);
+static void do_remove(struct mmu_rb_handler *handler,
+		      struct list_head *del_list);
+static void handle_remove(struct work_struct *work);
 
 static struct mmu_notifier_ops mn_opts = {
 	.invalidate_page = mmu_notifier_page,
@@ -94,6 +100,7 @@ static unsigned long mmu_node_last(struct mmu_rb_node *node)
 
 int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
 			 struct mmu_rb_ops *ops,
+			 struct workqueue_struct *wq,
 			 struct mmu_rb_handler **handler)
 {
 	struct mmu_rb_handler *handlr;
@@ -110,6 +117,9 @@ int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
 	spin_lock_init(&handlr->lock);
 	handlr->mn.ops = &mn_opts;
 	handlr->mm = mm;
+	INIT_WORK(&handlr->del_work, handle_remove);
+	INIT_LIST_HEAD(&handlr->del_list);
+	handlr->wq = wq;
 
 	ret = mmu_notifier_register(&handlr->mn, handlr->mm);
 	if (ret) {
@@ -126,19 +136,29 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 	struct mmu_rb_node *rbnode;
 	struct rb_node *node;
 	unsigned long flags;
+	struct list_head del_list;
 
 	/* Unregister first so we don't get any more notifications. */
 	mmu_notifier_unregister(&handler->mn, handler->mm);
 
+	/*
+	 * Make sure the wq delete handler is finished running.  It will not
+	 * be triggered once the mmu notifiers are unregistered above.
+	 */
+	flush_work(&handler->del_work);
+
+	INIT_LIST_HEAD(&del_list);
+
 	spin_lock_irqsave(&handler->lock, flags);
 	while ((node = rb_first(&handler->root))) {
 		rbnode = rb_entry(node, struct mmu_rb_node, node);
 		rb_erase(node, &handler->root);
-		handler->ops->remove(handler->ops_arg, rbnode,
-				     NULL);
+		list_add(&rbnode->list, &del_list);
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 
+	do_remove(handler, &del_list);
+
 	kfree(handler);
 }
 
@@ -230,16 +250,19 @@ void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 
-	down_write(&handler->mm->mmap_sem);
 	while (!list_empty(&del_list)) {
 		rbnode = list_first_entry(&del_list, struct mmu_rb_node, list);
 		list_del(&rbnode->list);
 		handler->ops->remove(handler->ops_arg, rbnode,
 				     handler->mm);
 	}
-	up_write(&handler->mm->mmap_sem);
 }
 
+/*
+ * It is up to the caller to ensure that this function does not race with the
+ * mmu invalidate notifier which may be calling the users remove callback on
+ * 'node'.
+ */
 void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 			struct mmu_rb_node *node)
 {
@@ -278,6 +301,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 	struct rb_root *root = &handler->root;
 	struct mmu_rb_node *node, *ptr = NULL;
 	unsigned long flags;
+	bool added = false;
 
 	spin_lock_irqsave(&handler->lock, flags);
 	for (node = __mmu_int_rb_iter_first(root, start, end - 1);
@@ -288,8 +312,50 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 			  node->addr, node->len);
 		if (handler->ops->invalidate(handler->ops_arg, node)) {
 			__mmu_int_rb_remove(node, root);
-			handler->ops->remove(handler->ops_arg, node, mm);
+			list_add(&node->list, &handler->del_list);
+			added = true;
 		}
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
+
+	if (added)
+		queue_work(handler->wq, &handler->del_work);
+}
+
+/*
+ * Call the remove function for the given handler and the list.  This
+ * is expected to be called with a delete list extracted from handler.
+ * The caller should not be holding the handler lock.
+ */
+static void do_remove(struct mmu_rb_handler *handler,
+		      struct list_head *del_list)
+{
+	struct mmu_rb_node *node;
+
+	while (!list_empty(del_list)) {
+		node = list_first_entry(del_list, struct mmu_rb_node, list);
+		list_del(&node->list);
+		handler->ops->remove(handler->ops_arg, node, handler->mm);
+	}
+}
+
+/*
+ * Work queue function to remove all nodes that have been queued up to
+ * be removed.  The key feature is that mm->mmap_sem is not being held
+ * and the remove callback can sleep while taking it, if needed.
+ */
+static void handle_remove(struct work_struct *work)
+{
+	struct mmu_rb_handler *handler = container_of(work,
+						struct mmu_rb_handler,
+						del_work);
+	struct list_head del_list;
+	unsigned long flags;
+
+	/* remove anything that is queued to get removed */
+	spin_lock_irqsave(&handler->lock, flags);
+	list_replace_init(&handler->del_list, &del_list);
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	do_remove(handler, &del_list);
 }
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 09e5888c0818..e4f853fa91e6 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -57,6 +57,10 @@ struct mmu_rb_node {
 	struct list_head list;
 };
 
+/*
+ * NOTE: filter, insert, invalidate, and evict must not sleep.  Only remove is
+ * allowed to sleep.
+ */
 struct mmu_rb_ops {
 	bool (*filter)(struct mmu_rb_node *node, unsigned long addr,
 		       unsigned long len);
@@ -70,6 +74,7 @@ struct mmu_rb_ops {
 
 int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
 			 struct mmu_rb_ops *ops,
+			 struct workqueue_struct *wq,
 			 struct mmu_rb_handler **handler);
 void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler);
 int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 9b740db34963..3bcda22e7b87 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -209,7 +209,9 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		 * Register MMU notifier callbacks. If the registration
 		 * fails, continue without TID caching for this context.
 		 */
-		ret = hfi1_mmu_rb_register(fd, fd->mm, &tid_rb_ops, &fd->handler);
+		ret = hfi1_mmu_rb_register(fd, fd->mm, &tid_rb_ops,
+					   dd->pport->hfi1_wq,
+					   &fd->handler);
 		if (ret) {
 			dd_dev_info(dd,
 				    "Failed MMU notifier registration %d\n",
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 3d76222d1aac..751aa2260c1c 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -310,8 +310,7 @@ static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
 static int sdma_rb_insert(void *, struct mmu_rb_node *);
 static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
 			 void *arg2, bool *stop);
-static void sdma_rb_remove(void *, struct mmu_rb_node *,
-			   struct mm_struct *);
+static void sdma_rb_remove(void *, struct mmu_rb_node *, struct mm_struct *);
 static int sdma_rb_invalidate(void *, struct mmu_rb_node *);
 
 static struct mmu_rb_ops sdma_rb_ops = {
@@ -446,7 +445,8 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	cq->nentries = hfi1_sdma_comp_ring_size;
 	fd->cq = cq;
 
-	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, &pq->handler);
+	ret = hfi1_mmu_rb_register(pq, pq->mm, &sdma_rb_ops, dd->pport->hfi1_wq,
+				   &pq->handler);
 	if (ret) {
 		dd_dev_err(dd, "Failed to register with MMU %d", ret);
 		goto done;
@@ -1651,20 +1651,8 @@ static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode,
 
 	atomic_sub(node->npages, &node->pq->n_locked);
 
-	/*
-	 * If mm is set, we are being called by the MMU notifier and we
-	 * should not pass a mm_struct to unpin_vector_page(). This is to
-	 * prevent a deadlock when hfi1_release_user_pages() attempts to
-	 * take the mmap_sem, which the MMU notifier has already taken.
-	 */
-	unpin_vector_pages(mm ? NULL : current->mm, node->pages, 0,
-			   node->npages);
-	/*
-	 * If called by the MMU notifier, we have to adjust the pinned
-	 * page count ourselves.
-	 */
-	if (mm)
-		mm->pinned_vm -= node->npages;
+	unpin_vector_pages(node->pq->mm, node->pages, 0, node->npages);
+
 	kfree(node);
 }
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
