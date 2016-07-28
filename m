From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 06/13] IB/hfi1: Always expect ops functions
Date: Thu, 28 Jul 2016 12:27:30 -0400
Message-ID: <1469723257-27317-7-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove, insert, and invalidate are always provided.  No
need to test.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 9289bfaa4911..525d58afb354 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -99,9 +99,6 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 {
 	struct mmu_rb_handler *handlr;
 
-	if (!ops->invalidate)
-		return -EINVAL;
-
 	handlr = kmalloc(sizeof(*handlr), GFP_KERNEL);
 	if (!handlr)
 		return -ENOMEM;
@@ -143,8 +140,7 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 		while ((node = rb_first(root))) {
 			rbnode = rb_entry(node, struct mmu_rb_node, node);
 			rb_erase(node, root);
-			if (handler->ops->remove)
-				handler->ops->remove(root, rbnode, NULL);
+			handler->ops->remove(root, rbnode, NULL);
 		}
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
@@ -172,11 +168,9 @@ int hfi1_mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *mnode)
 	}
 	__mmu_int_rb_insert(mnode, root);
 
-	if (handler->ops->insert) {
-		ret = handler->ops->insert(root, mnode);
-		if (ret)
-			__mmu_int_rb_remove(mnode, root);
-	}
+	ret = handler->ops->insert(root, mnode);
+	if (ret)
+		__mmu_int_rb_remove(mnode, root);
 unlock:
 	spin_unlock_irqrestore(&handler->lock, flags);
 	return ret;
@@ -219,8 +213,7 @@ static void __mmu_rb_remove(struct mmu_rb_handler *handler,
 	__mmu_int_rb_remove(node, handler->root);
 	spin_unlock_irqrestore(&handler->lock, flags);
 
-	if (handler->ops->remove)
-		handler->ops->remove(handler->root, node, mm);
+	handler->ops->remove(handler->root, node, mm);
 }
 
 struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *root,
@@ -300,8 +293,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 			  node->addr, node->len);
 		if (handler->ops->invalidate(root, node)) {
 			__mmu_int_rb_remove(node, root);
-			if (handler->ops->remove)
-				handler->ops->remove(root, node, mm);
+			handler->ops->remove(root, node, mm);
 		}
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
