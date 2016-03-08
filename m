From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/16] IB/hfi1: Use interval RB trees
Date: Tue, 08 Mar 2016 11:14:53 -0800
Message-ID: <20160308191453.30542.3991.stgit@scvm10.sc.intel.com>
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

The interval RB trees can handle RB nodes which
hold ranged information. This is exactly the usage
for the buffer cache implemented in the expected
receive code path.

Convert the MMU/RB functions to use the interval RB
tree API. This will help with future users of the
caching API, as well.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |  106 +++++++++++------------------------
 drivers/infiniband/hw/hfi1/mmu_rb.h |    3 +
 2 files changed, 34 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 29d6d3e..540e267 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -46,7 +46,7 @@
  */
 #include <linux/list.h>
 #include <linux/mmu_notifier.h>
-#include <linux/rbtree.h>
+#include <linux/interval_tree_generic.h>
 
 #include "mmu_rb.h"
 #include "trace.h"
@@ -62,6 +62,8 @@ struct mmu_rb_handler {
 static LIST_HEAD(mmu_rb_handlers);
 static DEFINE_SPINLOCK(mmu_rb_lock); /* protect mmu_rb_handlers list */
 
+static unsigned long mmu_node_start(struct mmu_rb_node *);
+static unsigned long mmu_node_last(struct mmu_rb_node *);
 static struct mmu_rb_handler *find_mmu_handler(struct rb_root *);
 static inline void mmu_notifier_page(struct mmu_notifier *, struct mm_struct *,
 				     unsigned long);
@@ -78,6 +80,19 @@ static struct mmu_notifier_ops mn_opts = {
 	.invalidate_range_start = mmu_notifier_range_start,
 };
 
+INTERVAL_TREE_DEFINE(struct mmu_rb_node, node, unsigned long, __last,
+		     mmu_node_start, mmu_node_last, static, __mmu_int_rb);
+
+static unsigned long mmu_node_start(struct mmu_rb_node *node)
+{
+	return node->addr & PAGE_MASK;
+}
+
+static unsigned long mmu_node_last(struct mmu_rb_node *node)
+{
+	return ((node->addr & PAGE_MASK) + node->len);
+}
+
 int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 {
 	struct mmu_rb_handler *handlr;
@@ -133,40 +148,27 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 
 int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 {
-	struct rb_node **new, *parent = NULL;
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
-	struct mmu_rb_node *this;
+	struct mmu_rb_node *node;
 	unsigned long flags;
-	int res, ret = 0;
+	int ret = 0;
 
 	if (!handler)
 		return -EINVAL;
 
-	new = &handler->root->rb_node;
 	spin_lock_irqsave(&handler->lock, flags);
-	while (*new) {
-		this = container_of(*new, struct mmu_rb_node, node);
-		res = handler->ops->compare(this, mnode->addr, mnode->len);
-		parent = *new;
-
-		if (res < 0) {
-			new = &((*new)->rb_left);
-		} else if (res > 0) {
-			new = &((*new)->rb_right);
-		} else {
-			ret = 1;
-			goto unlock;
-		}
+	node = __mmu_rb_search(handler, mnode->addr, mnode->len);
+	if (node) {
+		ret = -EINVAL;
+		goto unlock;
 	}
+	__mmu_int_rb_insert(mnode, root);
 
 	if (handler->ops->insert) {
 		ret = handler->ops->insert(root, mnode);
 		if (ret)
-			goto unlock;
+			__mmu_int_rb_remove(mnode, root);
 	}
-
-	rb_link_node(&mnode->node, parent, new);
-	rb_insert_color(&mnode->node, root);
 unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
@@ -177,29 +179,17 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 					   unsigned long addr,
 					   unsigned long len)
 {
-	struct rb_node *node = handler->root->rb_node;
-	struct mmu_rb_node *mnode;
-	int res;
-
-	while (node) {
-		mnode = container_of(node, struct mmu_rb_node, node);
-		res = handler->ops->compare(mnode, addr, len);
-
-		if (res < 0)
-			node = node->rb_left;
-		else if (res > 0)
-			node = node->rb_right;
-		else
-			return mnode;
-	}
-	return NULL;
+	struct mmu_rb_node *node;
+
+	node = __mmu_int_rb_iter_first(handler->root, addr, len);
+	return node;
 }
 
 static void __mmu_rb_remove(struct mmu_rb_handler *handler,
 			    struct mmu_rb_node *node, bool arg)
 {
 	/* Validity of handler and node pointers has been checked by caller. */
-	rb_erase(&node->node, handler->root);
+	__mmu_int_rb_remove(node, handler->root);
 	if (handler->ops->remove)
 		handler->ops->remove(handler->root, node, arg);
 }
@@ -271,45 +261,13 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		container_of(mn, struct mmu_rb_handler, mn);
 	struct rb_root *root = handler->root;
 	struct mmu_rb_node *node;
-	unsigned long addr = start, naddr, nlen, flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&handler->lock, flags);
-	while (addr < end) {
-		/*
-		 * There is no good way to provide a reasonable length to the
-		 * search function at this point. Using the remaining length in
-		 * the invalidation range is not the right thing to do.
-		 * We have to rely on the fact that the insertion algorithm
-		 * takes care of any overlap or length restrictions by using the
-		 * actual size of each node. Therefore, we can use a page as an
-		 * arbitrary, non-zero value.
-		 */
-		node = __mmu_rb_search(handler, addr, PAGE_SIZE);
-
-		if (!node) {
-			/*
-			 * Didn't find a node at this address. However, the
-			 * range could be bigger than what we have registered
-			 * so we have to keep looking.
-			 */
-			addr += PAGE_SIZE;
-			continue;
-		}
-
-		naddr = node->addr;
-		nlen = node->len;
+	for (node = __mmu_int_rb_iter_first(root, start, end); node;
+	     node = __mmu_int_rb_iter_next(node, start, end)) {
 		if (handler->ops->invalidate(root, node))
 			__mmu_rb_remove(handler, node, true);
-
-		/*
-		 * The next address to be looked up is computed based
-		 * on the node's starting address. This is due to the
-		 * fact that the range where we start might be in the
-		 * middle of the node's buffer so simply incrementing
-		 * the address by the node's size would result is a
-		 * bad address.
-		 */
-		addr = naddr + nlen;
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 }
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index fdd9787..abed3a6 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -50,9 +50,10 @@
 #include "hfi.h"
 
 struct mmu_rb_node {
-	struct rb_node node;
 	unsigned long addr;
 	unsigned long len;
+	unsigned long __last;
+	struct rb_node node;
 };
 
 struct mmu_rb_ops {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
