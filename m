From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 10/14] staging/rdma/hfi1: Add Expected receive init and free functions
Date: Thu, 17 Dec 2015 23:50:00 -0500
Message-ID: <1450414204-13699-11-git-send-email-ira.weiny@intel.com>
References: <1450414204-13699-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450414204-13699-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The upcoming TID caching feature requires different data
structures and, by extension, different initialization for each
of the MPI processes.

The two new functions (currently unused) perform the required
initialization and freeing of required resources and structures.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 154 +++++++++++++++++++++++++++++--
 1 file changed, 144 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 5a7e455b9f58..843023e2e2c7 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -90,23 +90,25 @@ struct tid_pageset {
 
 #define EXP_TID_SET_EMPTY(set) (set.count == 0 && list_empty(&set.list))
 
+#define num_user_pages(vaddr, len)				       \
+	(1 + (((((unsigned long)(vaddr) +			       \
+		 (unsigned long)(len) - 1) & PAGE_MASK) -	       \
+	       ((unsigned long)vaddr & PAGE_MASK)) >> PAGE_SHIFT))
+
 static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
-			    struct rb_root *) __maybe_unused;
+			    struct rb_root *);
 static u32 find_phys_blocks(struct page **, unsigned,
 			    struct tid_pageset *) __maybe_unused;
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
-			      struct tid_group *, struct page **,
-			      unsigned) __maybe_unused;
+			      struct tid_group *, struct page **, unsigned);
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
 			       unsigned long);
 static struct mmu_rb_node *mmu_rb_search_by_addr(struct rb_root *,
 						 unsigned long) __maybe_unused;
 static inline struct mmu_rb_node *mmu_rb_search_by_entry(struct rb_root *,
 							 u32);
-static int mmu_rb_insert_by_addr(struct rb_root *,
-				 struct mmu_rb_node *) __maybe_unused;
-static int mmu_rb_insert_by_entry(struct rb_root *,
-				  struct mmu_rb_node *) __maybe_unused;
+static int mmu_rb_insert_by_addr(struct rb_root *, struct mmu_rb_node *);
+static int mmu_rb_insert_by_entry(struct rb_root *, struct mmu_rb_node *);
 static void mmu_notifier_mem_invalidate(struct mmu_notifier *,
 					unsigned long, unsigned long,
 					enum mmu_call_types);
@@ -168,7 +170,7 @@ static inline void tid_group_move(struct tid_group *group,
 	tid_group_add_tail(group, s2);
 }
 
-static struct mmu_notifier_ops __maybe_unused mn_opts = {
+static struct mmu_notifier_ops mn_opts = {
 	.invalidate_page = mmu_notifier_page,
 	.invalidate_range_start = mmu_notifier_range_start,
 };
@@ -180,12 +182,144 @@ static struct mmu_notifier_ops __maybe_unused mn_opts = {
  */
 int hfi1_user_exp_rcv_init(struct file *fp)
 {
-	return -EINVAL;
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = uctxt->dd;
+	unsigned tidbase;
+	int i, ret = 0;
+
+	INIT_HLIST_NODE(&fd->mn.hlist);
+	spin_lock_init(&fd->rb_lock);
+	spin_lock_init(&fd->tid_lock);
+	spin_lock_init(&fd->invalid_lock);
+	fd->mn.ops = &mn_opts;
+	fd->tid_rb_root = RB_ROOT;
+
+	if (!uctxt->subctxt_cnt || !fd->subctxt) {
+		exp_tid_group_init(&uctxt->tid_group_list);
+		exp_tid_group_init(&uctxt->tid_used_list);
+		exp_tid_group_init(&uctxt->tid_full_list);
+
+		tidbase = uctxt->expected_base;
+		for (i = 0; i < uctxt->expected_count /
+			     dd->rcv_entries.group_size; i++) {
+			struct tid_group *grp;
+
+			grp = kzalloc(sizeof(*grp), GFP_KERNEL);
+			if (!grp) {
+				/*
+				 * If we fail here, the groups already
+				 * allocated will be freed by the close
+				 * call.
+				 */
+				ret = -ENOMEM;
+				goto done;
+			}
+			grp->size = dd->rcv_entries.group_size;
+			grp->base = tidbase;
+			tid_group_add_tail(grp, &uctxt->tid_group_list);
+			tidbase += dd->rcv_entries.group_size;
+		}
+	}
+
+	if (!HFI1_CAP_IS_USET(TID_UNMAP)) {
+		fd->invalid_tid_idx = 0;
+		fd->invalid_tids = kzalloc(uctxt->expected_count *
+					   sizeof(u32), GFP_KERNEL);
+		if (!fd->invalid_tids) {
+			ret = -ENOMEM;
+			goto done;
+		} else {
+			/*
+			 * Register MMU notifier callbacks. If the registration
+			 * fails, continue but turn off the TID caching for
+			 * all user contexts.
+			 */
+			ret = mmu_notifier_register(&fd->mn, current->mm);
+			if (ret) {
+				dd_dev_info(dd,
+					    "Failed MMU notifier registration %d\n",
+					    ret);
+				HFI1_CAP_USET(TID_UNMAP);
+				ret = 0;
+			}
+		}
+	}
+
+	if (HFI1_CAP_IS_USET(TID_UNMAP))
+		fd->mmu_rb_insert = mmu_rb_insert_by_entry;
+	else
+		fd->mmu_rb_insert = mmu_rb_insert_by_addr;
+
+	/*
+	 * PSM does not have a good way to separate, count, and
+	 * effectively enforce a limit on RcvArray entries used by
+	 * subctxts (when context sharing is used) when TID caching
+	 * is enabled. To help with that, we calculate a per-process
+	 * RcvArray entry share and enforce that.
+	 * If TID caching is not in use, PSM deals with usage on its
+	 * own. In that case, we allow any subctxt to take all of the
+	 * entries.
+	 *
+	 * Make sure that we set the tid counts only after successful
+	 * init.
+	 */
+	if (uctxt->subctxt_cnt && !HFI1_CAP_IS_USET(TID_UNMAP)) {
+		u16 remainder;
+
+		fd->tid_limit = uctxt->expected_count / uctxt->subctxt_cnt;
+		remainder = uctxt->expected_count % uctxt->subctxt_cnt;
+		if (remainder && fd->subctxt < remainder)
+			fd->tid_limit++;
+	} else {
+		fd->tid_limit = uctxt->expected_count;
+	}
+done:
+	return ret;
 }
 
 int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 {
-	return -EINVAL;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct tid_group *grp, *gptr;
+
+	/*
+	 * The notifier would have been removed when the process'es mm
+	 * was freed.
+	 */
+	if (current->mm && !HFI1_CAP_IS_USET(TID_UNMAP))
+		mmu_notifier_unregister(&fd->mn, current->mm);
+
+	kfree(fd->invalid_tids);
+
+	if (!uctxt->cnt) {
+		if (!EXP_TID_SET_EMPTY(uctxt->tid_full_list))
+			unlock_exp_tids(uctxt, &uctxt->tid_full_list,
+					&fd->tid_rb_root);
+		if (!EXP_TID_SET_EMPTY(uctxt->tid_used_list))
+			unlock_exp_tids(uctxt, &uctxt->tid_used_list,
+					&fd->tid_rb_root);
+		list_for_each_entry_safe(grp, gptr, &uctxt->tid_group_list.list,
+					 list) {
+			list_del_init(&grp->list);
+			kfree(grp);
+		}
+		spin_lock(&fd->rb_lock);
+		if (!RB_EMPTY_ROOT(&fd->tid_rb_root)) {
+			struct rb_node *node;
+			struct mmu_rb_node *rbnode;
+
+			while ((node = rb_first(&fd->tid_rb_root))) {
+				rbnode = rb_entry(node, struct mmu_rb_node,
+						  rbnode);
+				rb_erase(&rbnode->rbnode, &fd->tid_rb_root);
+				kfree(rbnode);
+			}
+		}
+		spin_unlock(&fd->rb_lock);
+		hfi1_clear_tids(uctxt);
+	}
+	return 0;
 }
 
 /*
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
