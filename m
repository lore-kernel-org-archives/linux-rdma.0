From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 29/54] staging/rdma/hfi1: Improve performance of TID cache
 look up
Date: Wed, 03 Feb 2016 14:34:41 -0800
Message-ID: <20160203223437.5923.33289.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When TID caching was enabled, the way the driver found
RB nodes when PSM was unprogramming TID entries was by
traversing the RB tree, looking for a match on the
RcvArray entry index.

The performance of this algorithm was not only poor but
also inconsistent depending on how many RB nodes would
have to be traversed before a match was found.

The lower performance was especially evident in cases where
there was a cache miss with the cache full, requiring the
unprogramming of several TID entries.

This commit changes how RB nodes are looked up when being
free'd by PSM to a index-based lookup into a flat array on
the index of the RcvArray entry. This turns the entire
look-up process into an O(1) algorithm.

Special care needs to be taken for situations when TID
caching is disabled. In those cases, there is no need to
insert the RB nodes into an actual RB tree. Since the entire
RcvArray management mechanism is managed by an index-based
algorithm, the RB nodes can be saved into the flat array,
making both "insertion" and "removal" faster.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/hfi.h          |    6 +
 drivers/staging/rdma/hfi1/user_exp_rcv.c |  149 ++++++++++++++++--------------
 2 files changed, 83 insertions(+), 72 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 112f790..f3c1e67 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1171,6 +1171,7 @@ struct hfi1_filedata {
 	int rec_cpu_num;
 	struct mmu_notifier mn;
 	struct rb_root tid_rb_root;
+	struct mmu_rb_node **entry_to_rb;
 	spinlock_t tid_lock; /* protect tid_[limit,used] counters */
 	u32 tid_limit;
 	u32 tid_used;
@@ -1178,7 +1179,10 @@ struct hfi1_filedata {
 	u32 *invalid_tids;
 	u32 invalid_tid_idx;
 	spinlock_t invalid_lock; /* protect the invalid_tids array */
-	int (*mmu_rb_insert)(struct rb_root *, struct mmu_rb_node *);
+	int (*mmu_rb_insert)(struct hfi1_filedata *, struct rb_root *,
+			     struct mmu_rb_node *);
+	void (*mmu_rb_remove)(struct hfi1_filedata *, struct rb_root *,
+			      struct mmu_rb_node *);
 };
 
 extern struct list_head hfi1_dev_list;
diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 79612a2..36b61b5 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -102,12 +102,15 @@ static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
-static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
-						 unsigned long);
-static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *,
-							 u32);
-static int mmu_rb_insert_by_addr(struct rb_root *, struct mmu_rb_node *);
-static int mmu_rb_insert_by_entry(struct rb_root *, struct mmu_rb_node *);
+static struct mmu_rb_node *mmu_rb_search(struct rb_root *, unsigned long);
+static int mmu_rb_insert_by_addr(struct hfi1_filedata *, struct rb_root *,
+				 struct mmu_rb_node *);
+static int mmu_rb_insert_by_entry(struct hfi1_filedata *, struct rb_root *,
+				  struct mmu_rb_node *);
+static void mmu_rb_remove_by_addr(struct hfi1_filedata *, struct rb_root *,
+				  struct mmu_rb_node *);
+static void mmu_rb_remove_by_entry(struct hfi1_filedata *, struct rb_root *,
+				   struct mmu_rb_node *);
 static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
 					unsigned long, unsigned long,
 					enum mmu_call_types);
@@ -219,6 +222,12 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		}
 	}
 
+	fd->entry_to_rb = kcalloc(uctxt->expected_count,
+				     sizeof(struct rb_node *),
+				     GFP_KERNEL);
+	if (!fd->entry_to_rb)
+		return -ENOMEM;
+
 	if (!HFI1_CAP_IS_USET(TID_UNMAP)) {
 		fd->invalid_tid_idx = 0;
 		fd->invalid_tids = kzalloc(uctxt->expected_count *
@@ -226,27 +235,30 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		if (!fd->invalid_tids) {
 			ret = -ENOMEM;
 			goto done;
-		} else {
-			/*
-			 * Register MMU notifier callbacks. If the registration
-			 * fails, continue but turn off the TID caching for
-			 * all user contexts.
-			 */
-			ret = mmu_notifier_register(&fd->mn, current->mm);
-			if (ret) {
-				dd_dev_info(dd,
-					    "Failed MMU notifier registration %d\n",
-					    ret);
-				HFI1_CAP_USET(TID_UNMAP);
-				ret = 0;
-			}
+		}
+
+		/*
+		 * Register MMU notifier callbacks. If the registration
+		 * fails, continue but turn off the TID caching for
+		 * all user contexts.
+		 */
+		ret = mmu_notifier_register(&fd->mn, current->mm);
+		if (ret) {
+			dd_dev_info(dd,
+				    "Failed MMU notifier registration %d\n",
+				    ret);
+			HFI1_CAP_USET(TID_UNMAP);
+			ret = 0;
 		}
 	}
 
-	if (HFI1_CAP_IS_USET(TID_UNMAP))
+	if (HFI1_CAP_IS_USET(TID_UNMAP)) {
 		fd->mmu_rb_insert = mmu_rb_insert_by_entry;
-	else
+		fd->mmu_rb_remove = mmu_rb_remove_by_entry;
+	} else {
 		fd->mmu_rb_insert = mmu_rb_insert_by_addr;
+		fd->mmu_rb_remove = mmu_rb_remove_by_addr;
+	}
 
 	/*
 	 * PSM does not have a good way to separate, count, and
@@ -318,6 +330,8 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 		spin_unlock(&fd->rb_lock);
 		hfi1_clear_tids(uctxt);
 	}
+
+	kfree(fd->entry_to_rb);
 	return 0;
 }
 
@@ -890,7 +904,7 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	memcpy(node->pages, pages, sizeof(struct page *) * npages);
 
 	spin_lock(&fd->rb_lock);
-	ret = fd->mmu_rb_insert(root, node);
+	ret = fd->mmu_rb_insert(fd, root, node);
 	spin_unlock(&fd->rb_lock);
 
 	if (ret) {
@@ -915,8 +929,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	struct hfi1_devdata *dd = uctxt->dd;
 	struct mmu_rb_node *node;
 	u8 tidctrl = EXP_TID_GET(tidinfo, CTRL);
-	u32 tidbase = uctxt->expected_base,
-		tididx = EXP_TID_GET(tidinfo, IDX) << 1, rcventry;
+	u32 tididx = EXP_TID_GET(tidinfo, IDX) << 1, rcventry;
 
 	if (tididx >= uctxt->expected_count) {
 		dd_dev_err(dd, "Invalid RcvArray entry (%u) index for ctxt %u\n",
@@ -927,15 +940,15 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	if (tidctrl == 0x3)
 		return -EINVAL;
 
-	rcventry = tidbase + tididx + (tidctrl - 1);
+	rcventry = tididx + (tidctrl - 1);
 
 	spin_lock(&fd->rb_lock);
-	node = mmu_rb_search_by_entry(&fd->tid_rb_root, rcventry);
-	if (!node) {
+	node = fd->entry_to_rb[rcventry];
+	if (!node || node->rcventry != (uctxt->expected_base + rcventry)) {
 		spin_unlock(&fd->rb_lock);
 		return -EBADF;
 	}
-	rb_erase(&node->rbnode, &fd->tid_rb_root);
+	fd->mmu_rb_remove(fd, &fd->tid_rb_root, node);
 	spin_unlock(&fd->rb_lock);
 	if (grp)
 		*grp = node->grp;
@@ -993,10 +1006,11 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 				u16 rcventry = grp->base + i;
 				struct mmu_rb_node *node;
 
-				node = mmu_rb_search_by_entry(root, rcventry);
-				if (!node)
+				node = fd->entry_to_rb[rcventry -
+							  uctxt->expected_base];
+				if (!node || node->rcventry != rcventry)
 					continue;
-				rb_erase(&node->rbnode, root);
+				fd->mmu_rb_remove(fd, root, node);
 				clear_tid_node(fd, -1, node);
 			}
 		}
@@ -1034,7 +1048,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 
 	spin_lock(&fd->rb_lock);
 	while (addr < end) {
-		node = mmu_rb_search_by_addr(root, addr);
+		node = mmu_rb_search(root, addr);
 
 		if (!node) {
 			/*
@@ -1116,8 +1130,8 @@ static inline int mmu_entry_cmp(struct mmu_rb_node *node, u32 entry)
 		return 0;
 }
 
-static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *root,
-						 unsigned long addr)
+static struct mmu_rb_node *mmu_rb_search(struct rb_root *root,
+					 unsigned long addr)
 {
 	struct rb_node *node = root->rb_node;
 
@@ -1142,48 +1156,21 @@ static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *root,
 	return NULL;
 }
 
-static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *root,
-							 u32 index)
-{
-	struct mmu_rb_node *rbnode;
-	struct rb_node *node;
-
-	if (root && !RB_EMPTY_ROOT(root))
-		for (node = rb_first(root); node; node = rb_next(node)) {
-			rbnode = rb_entry(node, struct mmu_rb_node, rbnode);
-			if (rbnode->rcventry == index)
-				return rbnode;
-		}
-	return NULL;
-}
-
-static int mmu_rb_insert_by_entry(struct rb_root *root,
+static int mmu_rb_insert_by_entry(struct hfi1_filedata *fdata,
+				  struct rb_root *root,
 				  struct mmu_rb_node *node)
 {
-	struct rb_node **new = &root->rb_node, *parent = NULL;
+	u32 base = fdata->uctxt->expected_base;
 
-	while (*new) {
-		struct mmu_rb_node *this =
-			container_of(*new, struct mmu_rb_node, rbnode);
-		int result = mmu_entry_cmp(this, node->rcventry);
-
-		parent = *new;
-		if (result < 0)
-			new = &((*new)->rb_left);
-		else if (result > 0)
-			new = &((*new)->rb_right);
-		else
-			return 1;
-	}
-
-	rb_link_node(&node->rbnode, parent, new);
-	rb_insert_color(&node->rbnode, root);
+	fdata->entry_to_rb[node->rcventry - base] = node;
 	return 0;
 }
 
-static int mmu_rb_insert_by_addr(struct rb_root *root, struct mmu_rb_node *node)
+static int mmu_rb_insert_by_addr(struct hfi1_filedata *fdata,
+				 struct rb_root *root, struct mmu_rb_node *node)
 {
 	struct rb_node **new = &root->rb_node, *parent = NULL;
+	u32 base = fdata->uctxt->expected_base;
 
 	/* Figure out where to put new node */
 	while (*new) {
@@ -1204,5 +1191,25 @@ static int mmu_rb_insert_by_addr(struct rb_root *root, struct mmu_rb_node *node)
 	rb_link_node(&node->rbnode, parent, new);
 	rb_insert_color(&node->rbnode, root);
 
+	fdata->entry_to_rb[node->rcventry - base] = node;
 	return 0;
 }
+
+static void mmu_rb_remove_by_entry(struct hfi1_filedata *fdata,
+				   struct rb_root *root,
+				   struct mmu_rb_node *node)
+{
+	u32 base = fdata->uctxt->expected_base;
+
+	fdata->entry_to_rb[node->rcventry - base] = NULL;
+}
+
+static void mmu_rb_remove_by_addr(struct hfi1_filedata *fdata,
+				  struct rb_root *root,
+				  struct mmu_rb_node *node)
+{
+	u32 base = fdata->uctxt->expected_base;
+
+	fdata->entry_to_rb[node->rcventry - base] = NULL;
+	rb_erase(&node->rbnode, root);
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
