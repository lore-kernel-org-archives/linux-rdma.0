From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/16] IB/hfi1: Allow remove MMU callbacks to free nodes
Date: Tue, 08 Mar 2016 11:14:36 -0800
Message-ID: <20160308191436.30542.12110.stgit@scvm10.sc.intel.com>
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

In order to allow the remove MMU callbacks to free the
RB nodes, it is necessary to prevent any references to
the nodes after the remove callback has been called.

Therefore, remove the node from the tree prior to calling
the callback. In other words, the MMU/RB API now guarantees
that all RB node operations it performs will be done prior
to calling the remove callback and that the RB node will
not be touched afterwards.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index f42a33b..a3515d7 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -120,10 +120,9 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 
 		while ((node = rb_first(root))) {
 			rbnode = rb_entry(node, struct mmu_rb_node, node);
+			rb_erase(node, root);
 			if (handler->ops->remove)
 				handler->ops->remove(root, rbnode);
-			rb_erase(node, root);
-			kfree(rbnode);
 		}
 	}
 
@@ -200,9 +199,9 @@ static void __mmu_rb_remove(struct mmu_rb_handler *handler,
 			    struct mmu_rb_node *node)
 {
 	/* Validity of handler and node pointers has been checked by caller. */
+	rb_erase(&node->node, handler->root);
 	if (handler->ops->remove)
 		handler->ops->remove(handler->root, node);
-	rb_erase(&node->node, handler->root);
 }
 
 struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
@@ -272,7 +271,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		container_of(mn, struct mmu_rb_handler, mn);
 	struct rb_root *root = handler->root;
 	struct mmu_rb_node *node;
-	unsigned long addr = start, flags;
+	unsigned long addr = start, naddr, nlen, flags;
 
 	spin_lock_irqsave(&handler->lock, flags);
 	while (addr < end) {
@@ -296,6 +295,9 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 			addr += PAGE_SIZE;
 			continue;
 		}
+
+		naddr = node->addr;
+		nlen = node->len;
 		if (handler->ops->invalidate(root, node))
 			__mmu_rb_remove(handler, node);
 
@@ -307,7 +309,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 		 * the address by the node's size would result is a
 		 * bad address.
 		 */
-		addr = node->addr + node->len;
+		addr = naddr + nlen;
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
