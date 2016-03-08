From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/16] IB/hfi1: Adjust last address values for intervals
Date: Tue, 08 Mar 2016 11:15:16 -0800
Message-ID: <20160308191516.30542.57983.stgit@scvm10.sc.intel.com>
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

Last address values for intervals in the interval RB tree
nodes should be non-inclusive in order to avoid confusing
ranges.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 6edd5f0..c7ad016 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -90,7 +90,7 @@ static unsigned long mmu_node_start(struct mmu_rb_node *node)
 
 static unsigned long mmu_node_last(struct mmu_rb_node *node)
 {
-	return ((node->addr & PAGE_MASK) + node->len);
+	return PAGE_ALIGN((node->addr & PAGE_MASK) + node->len) - 1;
 }
 
 int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops)
@@ -281,8 +281,8 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 	unsigned long flags;
 
 	spin_lock_irqsave(&handler->lock, flags);
-	for (node = __mmu_int_rb_iter_first(root, start, end); node;
-	     node = __mmu_int_rb_iter_next(node, start, end)) {
+	for (node = __mmu_int_rb_iter_first(root, start, end - 1); node;
+	     node = __mmu_int_rb_iter_next(node, start, end - 1)) {
 		hfi1_cdbg(MMU, "Invalidating node addr 0x%llx, len %u",
 			  node->addr, node->len);
 		if (handler->ops->invalidate(root, node))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
