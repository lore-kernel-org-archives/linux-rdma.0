From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/16] IB/hfi1: Allow MMU function execution in IRQ context
Date: Tue, 08 Mar 2016 11:14:25 -0800
Message-ID: <20160308191425.30542.58898.stgit@scvm10.sc.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308191210.30542.91885.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Future users of the MMU/RB functions might be searching or
manipulating the MMU RB trees in interrupt context. Therefore,
the MMU/RB functions need to be able to run in interrupt
context. This requires that we use the IRQ-aware API for
spin locks.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |   36 ++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 779ebaf..648f7e0 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -81,6 +81,7 @@ static struct mmu_notifier_ops mn_opts = {
 int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 {
 	struct mmu_rb_handler *handlr;
+	unsigned long flags;
 
 	if (!ops->compare || !ops->invalidate)
 		return -EINVAL;
@@ -94,9 +95,9 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 	INIT_HLIST_NODE(&handlr->mn.hlist);
 	spin_lock_init(&handlr->lock);
 	handlr->mn.ops = &mn_opts;
-	spin_lock(&mmu_rb_lock);
+	spin_lock_irqsave(&mmu_rb_lock, flags);
 	list_add_tail(&handlr->list, &mmu_rb_handlers);
-	spin_unlock(&mmu_rb_lock);
+	spin_unlock_irqrestore(&mmu_rb_lock, flags);
 
 	return mmu_notifier_register(&handlr->mn, current->mm);
 }
@@ -104,10 +105,11 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 void hfi1_mmu_rb_unregister(struct rb_root *root)
 {
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
+	unsigned long flags;
 
-	spin_lock(&mmu_rb_lock);
+	spin_lock_irqsave(&mmu_rb_lock, flags);
 	list_del(&handler->list);
-	spin_unlock(&mmu_rb_lock);
+	spin_unlock_irqrestore(&mmu_rb_lock, flags);
 
 	if (!RB_EMPTY_ROOT(root)) {
 		struct rb_node *node;
@@ -132,13 +134,14 @@ int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 	struct rb_node **new, *parent = NULL;
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
 	struct mmu_rb_node *this;
+	unsigned long flags;
 	int res, ret = 0;
 
 	if (!handler)
 		return -EINVAL;
 
 	new = &handler->root->rb_node;
-	spin_lock(&handler->lock);
+	spin_lock_irqsave(&handler->lock, flags);
 	while (*new) {
 		this = container_of(*new, struct mmu_rb_node, node);
 		res = handler->ops->compare(this, mnode->addr, mnode->len);
@@ -163,7 +166,7 @@ int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 	rb_link_node(&mnode->node, parent, new);
 	rb_insert_color(&mnode->node, root);
 unlock:
-	spin_unlock(&handler->lock);
+	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
 }
 
@@ -204,13 +207,14 @@ struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
 {
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
 	struct mmu_rb_node *node;
+	unsigned long flags;
 
 	if (!handler)
 		return ERR_PTR(-EINVAL);
 
-	spin_lock(&handler->lock);
+	spin_lock_irqsave(&handler->lock, flags);
 	node = __mmu_rb_search(handler, addr, len);
-	spin_unlock(&handler->lock);
+	spin_unlock_irqrestore(&handler->lock, flags);
 
 	return node;
 }
@@ -218,27 +222,29 @@ struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
 void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 {
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
+	unsigned long flags;
 
 	if (!handler || !node)
 		return;
 
-	spin_lock(&handler->lock);
+	spin_lock_irqsave(&handler->lock, flags);
 	__mmu_rb_remove(handler, node);
-	spin_unlock(&handler->lock);
+	spin_unlock_irqrestore(&handler->lock, flags);
 }
 
 static struct mmu_rb_handler *find_mmu_handler(struct rb_root *root)
 {
 	struct mmu_rb_handler *handler;
+	unsigned long flags;
 
-	spin_lock(&mmu_rb_lock);
+	spin_lock_irqsave(&mmu_rb_lock, flags);
 	list_for_each_entry(handler, &mmu_rb_handlers, list) {
 		if (handler->root == root)
 			goto unlock;
 	}
 	handler = NULL;
 unlock:
-	spin_unlock(&mmu_rb_lock);
+	spin_unlock_irqrestore(&mmu_rb_lock, flags);
 	return handler;
 }
 
@@ -263,9 +269,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		container_of(mn, struct mmu_rb_handler, mn);
 	struct rb_root *root = handler->root;
 	struct mmu_rb_node *node;
-	unsigned long addr = start;
+	unsigned long addr = start, flags;
 
-	spin_lock(&handler->lock);
+	spin_lock_irqsave(&handler->lock, flags);
 	while (addr < end) {
 		/*
 		 * There is no good way to provide a reasonable length to the
@@ -300,5 +306,5 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		 */
 		addr = node->addr + node->len;
 	}
-	spin_unlock(&handler->lock);
+	spin_unlock_irqrestore(&handler->lock, flags);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
