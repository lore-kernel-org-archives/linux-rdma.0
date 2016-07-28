From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 11/16] IB/hfi1: Add evict operation to the mmu rb handler
Date: Thu, 28 Jul 2016 15:21:22 -0400
Message-ID: <1469733687-31738-12-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Allow users to clear nodes from the rb tree based on their evict callback.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/mmu_rb.h |  4 ++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 9fbcfed4d34c..97f2d3680751 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -206,6 +206,40 @@ struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
 	return node;
 }
 
+void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
+{
+	struct mmu_rb_node *rbnode;
+	struct rb_node *node, *next;
+	struct list_head del_list;
+	unsigned long flags;
+	bool stop = false;
+
+	INIT_LIST_HEAD(&del_list);
+
+	spin_lock_irqsave(&handler->lock, flags);
+	for (node = rb_first(&handler->root); node; node = next) {
+		next = rb_next(node);
+		rbnode = rb_entry(node, struct mmu_rb_node, node);
+		if (handler->ops->evict(handler->ops_arg, rbnode, evict_arg,
+					&stop)) {
+			__mmu_int_rb_remove(rbnode, &handler->root);
+			list_add(&rbnode->list, &del_list);
+		}
+		if (stop)
+			break;
+	}
+	spin_unlock_irqrestore(&handler->lock, flags);
+
+	down_write(&handler->mm->mmap_sem);
+	while (!list_empty(&del_list)) {
+		rbnode = list_first_entry(&del_list, struct mmu_rb_node, list);
+		list_del(&rbnode->list);
+		handler->ops->remove(handler->ops_arg, rbnode,
+				     handler->mm);
+	}
+	up_write(&handler->mm->mmap_sem);
+}
+
 void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 			struct mmu_rb_node *node)
 {
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 2cedfbe2189e..09e5888c0818 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -54,6 +54,7 @@ struct mmu_rb_node {
 	unsigned long len;
 	unsigned long __last;
 	struct rb_node node;
+	struct list_head list;
 };
 
 struct mmu_rb_ops {
@@ -63,6 +64,8 @@ struct mmu_rb_ops {
 	void (*remove)(void *ops_arg, struct mmu_rb_node *mnode,
 		       struct mm_struct *mm);
 	int (*invalidate)(void *ops_arg, struct mmu_rb_node *node);
+	int (*evict)(void *ops_arg, struct mmu_rb_node *mnode,
+		     void *evict_arg, bool *stop);
 };
 
 int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
@@ -71,6 +74,7 @@ int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
 void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler);
 int hfi1_mmu_rb_insert(struct mmu_rb_handler *handler,
 		       struct mmu_rb_node *mnode);
+void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg);
 void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 			struct mmu_rb_node *mnode);
 struct mmu_rb_node *hfi1_mmu_rb_extract(struct mmu_rb_handler *handler,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
