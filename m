From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 15/16] IB/hfi1: Fix memory leak during unexpected shutdown
Date: Thu, 28 Jul 2016 15:21:26 -0400
Message-ID: <1469733687-31738-16-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

During an unexpected shutdown, references to tid_rb_node were NULL'ed out
without properly being released.

Fix this by calling clear_tid_node in the mmu notifier remove callback
rather than after these callbacks are called.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 44 ++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 8717e11fe3f5..64d26525435a 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -87,13 +87,15 @@ static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
 static int tid_rb_insert(void *, struct mmu_rb_node *);
+static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
+				    struct tid_rb_node *tnode);
 static void tid_rb_remove(void *, struct mmu_rb_node *);
 static int tid_rb_invalidate(void *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
 			    u32 *, unsigned *, unsigned *);
 static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
-static void clear_tid_node(struct hfi1_filedata *, struct tid_rb_node *);
+static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node);
 
 static struct mmu_rb_ops tid_rb_ops = {
 	.insert = tid_rb_insert,
@@ -899,14 +901,15 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	node = fd->entry_to_rb[rcventry];
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
+
+	if (grp)
+		*grp = node->grp;
+
 	if (!fd->handler)
-		tid_rb_remove(fd, &node->mmu);
+		cacheless_tid_rb_remove(fd, node);
 	else
 		hfi1_mmu_rb_remove(fd->handler, &node->mmu);
 
-	if (grp)
-		*grp = node->grp;
-	clear_tid_node(fd, node);
 	return 0;
 }
 
@@ -943,6 +946,10 @@ static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
 	kfree(node);
 }
 
+/*
+ * As a simple helper for hfi1_user_exp_rcv_free, this function deals with
+ * clearing nodes in the non-cached case.
+ */
 static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 			    struct exp_tid_set *set,
 			    struct hfi1_filedata *fd)
@@ -962,17 +969,20 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 							  uctxt->expected_base];
 				if (!node || node->rcventry != rcventry)
 					continue;
-				if (!fd->handler)
-					tid_rb_remove(fd, &node->mmu);
-				else
-					hfi1_mmu_rb_remove(fd->handler,
-							   &node->mmu);
-				clear_tid_node(fd, node);
+
+				cacheless_tid_rb_remove(fd, node);
 			}
 		}
 	}
 }
 
+/*
+ * Always return 0 from this function.  A non-zero return indicates that the
+ * remove operation will be called and that memory should be unpinned.
+ * However, the driver cannot unpin out from under PSM.  Instead, retain the
+ * memory (by returning 0) and inform PSM that the memory is going away.  PSM
+ * will call back later when it has removed the memory from its list.
+ */
 static int tid_rb_invalidate(void *arg, struct mmu_rb_node *mnode)
 {
 	struct hfi1_filedata *fdata = arg;
@@ -1027,12 +1037,20 @@ static int tid_rb_insert(void *arg, struct mmu_rb_node *node)
 	return 0;
 }
 
+static void cacheless_tid_rb_remove(struct hfi1_filedata *fdata,
+				    struct tid_rb_node *tnode)
+{
+	u32 base = fdata->uctxt->expected_base;
+
+	fdata->entry_to_rb[tnode->rcventry - base] = NULL;
+	clear_tid_node(fdata, tnode);
+}
+
 static void tid_rb_remove(void *arg, struct mmu_rb_node *node)
 {
 	struct hfi1_filedata *fdata = arg;
 	struct tid_rb_node *tnode =
 		container_of(node, struct tid_rb_node, mmu);
-	u32 base = fdata->uctxt->expected_base;
 
-	fdata->entry_to_rb[tnode->rcventry - base] = NULL;
+	cacheless_tid_rb_remove(fdata, tnode);
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
