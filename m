From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 16/16] IB/hfi1: Add cache evict LRU list
Date: Thu, 28 Jul 2016 15:21:27 -0400
Message-ID: <1469733687-31738-17-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The original code used a LRU list to evict nodes which were least
recently used.  For correctness the evict code was moved under the
handler->lock, now add back the LRU list.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index a02344a9d746..7ad30898fc19 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -59,6 +59,7 @@ struct mmu_rb_handler {
 	spinlock_t lock;        /* protect the RB tree */
 	struct mmu_rb_ops *ops;
 	struct mm_struct *mm;
+	struct list_head lru_list;
 	struct work_struct del_work;
 	struct list_head del_list;
 	struct workqueue_struct *wq;
@@ -119,6 +120,7 @@ int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
 	handlr->mm = mm;
 	INIT_WORK(&handlr->del_work, handle_remove);
 	INIT_LIST_HEAD(&handlr->del_list);
+	INIT_LIST_HEAD(&handlr->lru_list);
 	handlr->wq = wq;
 
 	ret = mmu_notifier_register(&handlr->mn, handlr->mm);
@@ -153,7 +155,8 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 	while ((node = rb_first(&handler->root))) {
 		rbnode = rb_entry(node, struct mmu_rb_node, node);
 		rb_erase(node, &handler->root);
-		list_add(&rbnode->list, &del_list);
+		/* move from LRU list to delete list */
+		list_move(&rbnode->list, &del_list);
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 
@@ -178,10 +181,13 @@ int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
 		goto unlock;
 	}
 	__mmu_int_rb_insert(mnode, &handler->root);
+	list_add(&mnode->list, &handler->lru_list);
 
 	ret = handler->ops->insert(handler->ops_arg, mnode);
-	if (ret)
+	if (ret) {
 		__mmu_int_rb_remove(mnode, &handler->root);
+		list_del(&mnode->list); /* remove from LRU list */
+	}
 unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
@@ -219,8 +225,10 @@ struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
 
 	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
-	if (node)
+	if (node) {
 		__mmu_int_rb_remove(node, &handler->root);
+		list_del(&node->list); /* remove from LRU list */
+	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 
 	return node;
@@ -228,8 +236,7 @@ struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
 
 void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
 {
-	struct mmu_rb_node *rbnode;
-	struct rb_node *node, *next;
+	struct mmu_rb_node *rbnode, *ptr;
 	struct list_head del_list;
 	unsigned long flags;
 	bool stop = false;
@@ -237,13 +244,13 @@ void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
 	INIT_LIST_HEAD(&del_list);
 
 	spin_lock_irqsave(&handler->lock, flags);
-	for (node = rb_first(&handler->root); node; node = next) {
-		next = rb_next(node);
-		rbnode = rb_entry(node, struct mmu_rb_node, node);
+	list_for_each_entry_safe_reverse(rbnode, ptr, &handler->lru_list,
+					 list) {
 		if (handler->ops->evict(handler->ops_arg, rbnode, evict_arg,
 					&stop)) {
 			__mmu_int_rb_remove(rbnode, &handler->root);
-			list_add(&rbnode->list, &del_list);
+			/* move from LRU list to delete list */
+			list_move(&rbnode->list, &del_list);
 		}
 		if (stop)
 			break;
@@ -272,6 +279,7 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 		  node->len);
 	spin_lock_irqsave(&handler->lock, flags);
 	__mmu_int_rb_remove(node, &handler->root);
+	list_del(&node->list); /* remove from LRU list */
 	spin_unlock_irqrestore(&handler->lock, flags);
 
 	handler->ops->remove(handler->ops_arg, node);
@@ -311,7 +319,8 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 			  node->addr, node->len);
 		if (handler->ops->invalidate(handler->ops_arg, node)) {
 			__mmu_int_rb_remove(node, root);
-			list_add(&node->list, &handler->del_list);
+			/* move from LRU list to delete list */
+			list_move(&node->list, &handler->del_list);
 			added = true;
 		}
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
