From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/15] IB/hfi1: Improve performance of interval RB trees
Date: Thu, 12 May 2016 10:23:09 -0700
Message-ID: <20160512172308.9741.14001.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The interval RB tree management functions use handlers to
store user-specific callback for the various tree operations.
These handlers are put on a doubly-linked list. When a RB
tree function is called, the list is searched for the handler
of the particular tree.

The list which holds the handlers is modified very rarely - when
a handler is created and when a handler is removed. On the other
hand, it is searched very often. This a perfect usage scenario
for RCU.

The result is a much lower overhead of traversing the list as most
of the time no locking will be required.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mmu_rb.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mmu_rb.c b/drivers/staging/rdma/hfi1/mmu_rb.c
index 2b0e91d..b7a80aa 100644
--- a/drivers/staging/rdma/hfi1/mmu_rb.c
+++ b/drivers/staging/rdma/hfi1/mmu_rb.c
@@ -45,6 +45,7 @@
  *
  */
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/mmu_notifier.h>
 #include <linux/interval_tree_generic.h>
 
@@ -97,7 +98,6 @@ static unsigned long mmu_node_last(struct mmu_rb_node *node)
 int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 {
 	struct mmu_rb_handler *handlr;
-	unsigned long flags;
 
 	if (!ops->invalidate)
 		return -EINVAL;
@@ -111,9 +111,9 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 	INIT_HLIST_NODE(&handlr->mn.hlist);
 	spin_lock_init(&handlr->lock);
 	handlr->mn.ops = &mn_opts;
-	spin_lock_irqsave(&mmu_rb_lock, flags);
-	list_add_tail(&handlr->list, &mmu_rb_handlers);
-	spin_unlock_irqrestore(&mmu_rb_lock, flags);
+	spin_lock(&mmu_rb_lock);
+	list_add_tail_rcu(&handlr->list, &mmu_rb_handlers);
+	spin_unlock(&mmu_rb_lock);
 
 	return mmu_notifier_register(&handlr->mn, current->mm);
 }
@@ -130,9 +130,10 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 	if (current->mm)
 		mmu_notifier_unregister(&handler->mn, current->mm);
 
-	spin_lock_irqsave(&mmu_rb_lock, flags);
-	list_del(&handler->list);
-	spin_unlock_irqrestore(&mmu_rb_lock, flags);
+	spin_lock(&mmu_rb_lock);
+	list_del_rcu(&handler->list);
+	spin_unlock(&mmu_rb_lock);
+	synchronize_rcu();
 
 	spin_lock_irqsave(&handler->lock, flags);
 	if (!RB_EMPTY_ROOT(root)) {
@@ -271,16 +272,15 @@ void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 static struct mmu_rb_handler *find_mmu_handler(struct rb_root *root)
 {
 	struct mmu_rb_handler *handler;
-	unsigned long flags;
 
-	spin_lock_irqsave(&mmu_rb_lock, flags);
-	list_for_each_entry(handler, &mmu_rb_handlers, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(handler, &mmu_rb_handlers, list) {
 		if (handler->root == root)
 			goto unlock;
 	}
 	handler = NULL;
 unlock:
-	spin_unlock_irqrestore(&mmu_rb_lock, flags);
+	rcu_read_unlock();
 	return handler;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
