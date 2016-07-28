From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 07/13] IB/hfi1: Consolidate __mmu_rb_remove and hfi1_mmu_rb_remove
Date: Thu, 28 Jul 2016 12:27:31 -0400
Message-ID: <1469723257-27317-8-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

__mmu_rb_remove was called in only 1 place which was a very simple
call site.  Combine this function into its caller.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 525d58afb354..b845adf9fc0e 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -200,22 +200,6 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 	return node;
 }
 
-/* Caller must *not* hold handler lock. */
-static void __mmu_rb_remove(struct mmu_rb_handler *handler,
-			    struct mmu_rb_node *node, struct mm_struct *mm)
-{
-	unsigned long flags;
-
-	/* Validity of handler and node pointers has been checked by caller. */
-	hfi1_cdbg(MMU, "Removing node addr 0x%llx, len %u", node->addr,
-		  node->len);
-	spin_lock_irqsave(&handler->lock, flags);
-	__mmu_int_rb_remove(node, handler->root);
-	spin_unlock_irqrestore(&handler->lock, flags);
-
-	handler->ops->remove(handler->root, node, mm);
-}
-
 struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *root,
 					unsigned long addr, unsigned long len)
 {
@@ -237,12 +221,20 @@ struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *root,
 
 void hfi1_mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node)
 {
+	unsigned long flags;
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
 
 	if (!handler || !node)
 		return;
 
-	__mmu_rb_remove(handler, node, NULL);
+	/* Validity of handler and node pointers has been checked by caller. */
+	hfi1_cdbg(MMU, "Removing node addr 0x%llx, len %u", node->addr,
+		  node->len);
+	spin_lock_irqsave(&handler->lock, flags);
+	__mmu_int_rb_remove(node, handler->root);
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	handler->ops->remove(handler->root, node, NULL);
 }
 
 static struct mmu_rb_handler *find_mmu_handler(struct rb_root *root)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
