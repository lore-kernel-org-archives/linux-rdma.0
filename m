From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 13/13] IB/hfi1: Rename TID mmu_rb_* functions
Date: Thu, 28 Jul 2016 12:27:37 -0400
Message-ID: <1469723257-27317-14-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clarify the names of the TID mmu functions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index f16eb25bfcd2..8283a6a2bb15 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -86,10 +86,10 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
 static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
-static int mmu_rb_insert(struct rb_root *, struct mmu_rb_node *);
-static void mmu_rb_remove(struct rb_root *, struct mmu_rb_node *,
+static int tid_rb_insert(struct rb_root *, struct mmu_rb_node *);
+static void tid_rb_remove(struct rb_root *, struct mmu_rb_node *,
 			  struct mm_struct *);
-static int mmu_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
+static int tid_rb_invalidate(struct rb_root *, struct mmu_rb_node *);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
 			    u32 *, unsigned *, unsigned *);
@@ -97,9 +97,9 @@ static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
 static void clear_tid_node(struct hfi1_filedata *, struct tid_rb_node *);
 
 static struct mmu_rb_ops tid_rb_ops = {
-	.insert = mmu_rb_insert,
-	.remove = mmu_rb_remove,
-	.invalidate = mmu_rb_invalidate
+	.insert = tid_rb_insert,
+	.remove = tid_rb_remove,
+	.invalidate = tid_rb_invalidate
 };
 
 static inline u32 rcventry2tidinfo(u32 rcventry)
@@ -862,7 +862,7 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	memcpy(node->pages, pages, sizeof(struct page *) * npages);
 
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		ret = mmu_rb_insert(root, &node->mmu);
+		ret = tid_rb_insert(root, &node->mmu);
 	else
 		ret = hfi1_mmu_rb_insert(root, &node->mmu);
 
@@ -905,7 +905,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
 	if (HFI1_CAP_IS_USET(TID_UNMAP))
-		mmu_rb_remove(&fd->tid_rb_root, &node->mmu, NULL);
+		tid_rb_remove(&fd->tid_rb_root, &node->mmu, NULL);
 	else
 		hfi1_mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
 
@@ -969,7 +969,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 				if (!node || node->rcventry != rcventry)
 					continue;
 				if (HFI1_CAP_IS_USET(TID_UNMAP))
-					mmu_rb_remove(&fd->tid_rb_root,
+					tid_rb_remove(&fd->tid_rb_root,
 						      &node->mmu, NULL);
 				else
 					hfi1_mmu_rb_remove(&fd->tid_rb_root,
@@ -980,7 +980,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 	}
 }
 
-static int mmu_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
+static int tid_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
 {
 	struct hfi1_filedata *fdata =
 		container_of(root, struct hfi1_filedata, tid_rb_root);
@@ -1024,7 +1024,7 @@ static int mmu_rb_invalidate(struct rb_root *root, struct mmu_rb_node *mnode)
 	return 0;
 }
 
-static int mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
+static int tid_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 {
 	struct hfi1_filedata *fdata =
 		container_of(root, struct hfi1_filedata, tid_rb_root);
@@ -1036,7 +1036,7 @@ static int mmu_rb_insert(struct rb_root *root, struct mmu_rb_node *node)
 	return 0;
 }
 
-static void mmu_rb_remove(struct rb_root *root, struct mmu_rb_node *node,
+static void tid_rb_remove(struct rb_root *root, struct mmu_rb_node *node,
 			  struct mm_struct *mm)
 {
 	struct hfi1_filedata *fdata =
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
