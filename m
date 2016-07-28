From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 14/16] IB/hfi1: Remove unneeded mm argument in remove function
Date: Thu, 28 Jul 2016 15:21:25 -0400
Message-ID: <1469733687-31738-15-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The reworked mmu_rb interface allows the unused mm argument to be removed.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c       |  7 +++----
 drivers/infiniband/hw/hfi1/mmu_rb.h       |  3 +--
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 10 ++++------
 drivers/infiniband/hw/hfi1/user_sdma.c    |  5 ++---
 4 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 76f7b0403207..a02344a9d746 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -253,8 +253,7 @@ void hfi1_mmu_rb_evict(struct mmu_rb_handler *handler, void *evict_arg)
 	while (!list_empty(&del_list)) {
 		rbnode = list_first_entry(&del_list, struct mmu_rb_node, list);
 		list_del(&rbnode->list);
-		handler->ops->remove(handler->ops_arg, rbnode,
-				     handler->mm);
+		handler->ops->remove(handler->ops_arg, rbnode);
 	}
 }
 
@@ -275,7 +274,7 @@ void hfi1_mmu_rb_remove(struct mmu_rb_handler *handler,
 	__mmu_int_rb_remove(node, &handler->root);
 	spin_unlock_irqrestore(&handler->lock, flags);
 
-	handler->ops->remove(handler->ops_arg, node, NULL);
+	handler->ops->remove(handler->ops_arg, node);
 }
 
 static inline void mmu_notifier_page(struct mmu_notifier *mn,
@@ -335,7 +334,7 @@ static void do_remove(struct mmu_rb_handler *handler,
 	while (!list_empty(del_list)) {
 		node = list_first_entry(del_list, struct mmu_rb_node, list);
 		list_del(&node->list);
-		handler->ops->remove(handler->ops_arg, node, handler->mm);
+		handler->ops->remove(handler->ops_arg, node);
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index e4f853fa91e6..754f6ebf13fb 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -65,8 +65,7 @@ struct mmu_rb_ops {
 	bool (*filter)(struct mmu_rb_node *node, unsigned long addr,
 		       unsigned long len);
 	int (*insert)(void *ops_arg, struct mmu_rb_node *mnode);
-	void (*remove)(void *ops_arg, struct mmu_rb_node *mnode,
-		       struct mm_struct *mm);
+	void (*remove)(void *ops_arg, struct mmu_rb_node *mnode);
 	int (*invalidate)(void *ops_arg, struct mmu_rb_node *node);
 	int (*evict)(void *ops_arg, struct mmu_rb_node *mnode,
 		     void *evict_arg, bool *stop);
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 3bcda22e7b87..8717e11fe3f5 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -87,8 +87,7 @@ static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
 static int tid_rb_insert(void *, struct mmu_rb_node *);
-static void tid_rb_remove(void *, struct mmu_rb_node *,
-			  struct mm_struct *);
+static void tid_rb_remove(void *, struct mmu_rb_node *);
 static int tid_rb_invalidate(void *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
@@ -901,7 +900,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 	if (!fd->handler)
-		tid_rb_remove(fd, &node->mmu, fd->mm);
+		tid_rb_remove(fd, &node->mmu);
 	else
 		hfi1_mmu_rb_remove(fd->handler, &node->mmu);
 
@@ -964,7 +963,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 				if (!node || node->rcventry != rcventry)
 					continue;
 				if (!fd->handler)
-					tid_rb_remove(fd, &node->mmu, fd->mm);
+					tid_rb_remove(fd, &node->mmu);
 				else
 					hfi1_mmu_rb_remove(fd->handler,
 							   &node->mmu);
@@ -1028,8 +1027,7 @@ static int tid_rb_insert(void *arg, struct mmu_rb_node *node)
 	return 0;
 }
 
-static void tid_rb_remove(void *arg, struct mmu_rb_node *node,
-			  struct mm_struct *mm)
+static void tid_rb_remove(void *arg, struct mmu_rb_node *node)
 {
 	struct hfi1_filedata *fdata = arg;
 	struct tid_rb_node *tnode =
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 751aa2260c1c..0ecf27903dc2 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -310,7 +310,7 @@ static bool sdma_rb_filter(struct mmu_rb_node *, unsigned long, unsigned long);
 static int sdma_rb_insert(void *, struct mmu_rb_node *);
 static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
 			 void *arg2, bool *stop);
-static void sdma_rb_remove(void *, struct mmu_rb_node *, struct mm_struct *);
+static void sdma_rb_remove(void *, struct mmu_rb_node *);
 static int sdma_rb_invalidate(void *, struct mmu_rb_node *);
 
 static struct mmu_rb_ops sdma_rb_ops = {
@@ -1643,8 +1643,7 @@ static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
 	return 1; /* remove this node */
 }
 
-static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode,
-			   struct mm_struct *mm)
+static void sdma_rb_remove(void *arg, struct mmu_rb_node *mnode)
 {
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
