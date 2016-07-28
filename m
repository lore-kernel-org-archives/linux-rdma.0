From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/13] IB/hfi1: Remove unneeded empty check in hfi1_mmu_rb_unregister()
Date: Thu, 28 Jul 2016 12:27:36 -0400
Message-ID: <1469723257-27317-13-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Checking if the rb tree is empty is redundant with the while loop which is
emptying the rb tree.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index b845adf9fc0e..1c7e25b90a2c 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -118,6 +118,8 @@ int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
 void hfi1_mmu_rb_unregister(struct rb_root *root)
 {
 	struct mmu_rb_handler *handler = find_mmu_handler(root);
+	struct mmu_rb_node *rbnode;
+	struct rb_node *node;
 	unsigned long flags;
 
 	if (!handler)
@@ -133,15 +135,10 @@ void hfi1_mmu_rb_unregister(struct rb_root *root)
 	synchronize_rcu();
 
 	spin_lock_irqsave(&handler->lock, flags);
-	if (!RB_EMPTY_ROOT(root)) {
-		struct rb_node *node;
-		struct mmu_rb_node *rbnode;
-
-		while ((node = rb_first(root))) {
-			rbnode = rb_entry(node, struct mmu_rb_node, node);
-			rb_erase(node, root);
-			handler->ops->remove(root, rbnode, NULL);
-		}
+	while ((node = rb_first(root))) {
+		rbnode = rb_entry(node, struct mmu_rb_node, node);
+		rb_erase(node, root);
+		handler->ops->remove(root, rbnode, NULL);
 	}
 	spin_unlock_irqrestore(&handler->lock, flags);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
