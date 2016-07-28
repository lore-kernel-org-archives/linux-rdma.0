From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 03/13] IB/hfi1: Remove unused function hfi1_mmu_rb_search
Date: Thu, 28 Jul 2016 12:27:27 -0400
Message-ID: <1469723257-27317-4-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 17 -----------------
 drivers/infiniband/hw/hfi1/mmu_rb.h |  2 --
 2 files changed, 19 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index b7a80aa1ae30..9289bfaa4911 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -223,23 +223,6 @@ static void __mmu_rb_remove(struct mmu_rb_handler *handler,
 		handler->ops->remove(handler->root, node, mm);
 }
 
-struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *root, unsigned long addr,
-				       unsigned long len)
-{
-	struct mmu_rb_handler *handler = find_mmu_handler(root);
-	struct mmu_rb_node *node;
-	unsigned long flags;
-
-	if (!handler)
-		return ERR_PTR(-EINVAL);
-
-	spin_lock_irqsave(&handler->lock, flags);
-	node = __mmu_rb_search(handler, addr, len);
-	spin_unlock_irqrestore(&handler->lock, flags);
-
-	return node;
-}
-
 struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *root,
 					unsigned long addr, unsigned long len)
 {
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 7a57b9c49d27..215c728e52cd 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -68,8 +68,6 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops);
 void hfi1_mmu_rb_unregister(struct rb_root *);
 int hfi1_mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
 void hfi1_mmu_rb_remove(struct rb_root *, struct mmu_rb_node *);
-struct mmu_rb_node *hfi1_mmu_rb_search(struct rb_root *, unsigned long,
-				       unsigned long);
 struct mmu_rb_node *hfi1_mmu_rb_extract(struct rb_root *, unsigned long,
 					unsigned long);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
