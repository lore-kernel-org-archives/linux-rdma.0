From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 13/14] staging/rdma/hfi1: Add TID entry program function body
Date: Thu, 17 Dec 2015 23:50:03 -0500
Message-ID: <1450414204-13699-14-git-send-email-ira.weiny@intel.com>
References: <1450414204-13699-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450414204-13699-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The previous patch in the series added the free/invalidate
function bodies. Now, it's time for the programming side.

This large function takes the user's buffer, breaks it up
into manageable chunks, allocates enough RcvArray groups
and programs the chunks into the RcvArray entries in the
hardware.

With this function, the TID caching functionality is implemented.
However, it is still unused. The switch will come in a later
patch in the series, which will remove the old functionality and
switch the driver over to TID caching.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 263 ++++++++++++++++++++++++++++++-
 1 file changed, 259 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 776ce003248e..d33f579675b7 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -97,8 +97,7 @@ struct tid_pageset {
 
 static void unlock_exp_tids(struct hfi1_ctxtdata *, struct exp_tid_set *,
 			    struct rb_root *);
-static u32 find_phys_blocks(struct page **, unsigned,
-			    struct tid_pageset *) __maybe_unused;
+static u32 find_phys_blocks(struct page **, unsigned, struct tid_pageset *);
 static int set_rcvarray_entry(struct file *, unsigned long, u32,
 			      struct tid_group *, struct page **, unsigned);
 static inline int mmu_addr_cmp(struct mmu_rb_node *, unsigned long,
@@ -119,7 +118,7 @@ static inline void mmu_notifier_range_start(struct mmu_notifier *,
 					    unsigned long, unsigned long);
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
-			    u32 *, unsigned *, unsigned *) __maybe_unused;
+			    u32 *, unsigned *, unsigned *);
 static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
 static void clear_tid_node(struct hfi1_filedata *, u16, struct mmu_rb_node *);
 
@@ -339,9 +338,265 @@ static inline void rcv_array_wc_fill(struct hfi1_devdata *dd, u32 index)
 		writeq(0, dd->rcvarray_wc + (index * 8));
 }
 
+/*
+ * RcvArray entry allocation for Expected Receives is done by the
+ * following algorithm:
+ *
+ * The context keeps 3 lists of groups of RcvArray entries:
+ *   1. List of empty groups - tid_group_list
+ *      This list is created during user context creation and
+ *      contains elements which describe sets (of 8) of empty
+ *      RcvArray entries.
+ *   2. List of partially used groups - tid_used_list
+ *      This list contains sets of RcvArray entries which are
+ *      not completely used up. Another mapping request could
+ *      use some of all of the remaining entries.
+ *   3. List of full groups - tid_full_list
+ *      This is the list where sets that are completely used
+ *      up go.
+ *
+ * An attempt to optimize the usage of RcvArray entries is
+ * made by finding all sets of physically contiguous pages in a
+ * user's buffer.
+ * These physically contiguous sets are further split into
+ * sizes supported by the receive engine of the HFI. The
+ * resulting sets of pages are stored in struct tid_pageset,
+ * which describes the sets as:
+ *    * .count - number of pages in this set
+ *    * .idx - starting index into struct page ** array
+ *                    of this set
+ *
+ * From this point on, the algorithm deals with the page sets
+ * described above. The number of pagesets is divided by the
+ * RcvArray group size to produce the number of full groups
+ * needed.
+ *
+ * Groups from the 3 lists are manipulated using the following
+ * rules:
+ *   1. For each set of 8 pagesets, a complete group from
+ *      tid_group_list is taken, programmed, and moved to
+ *      the tid_full_list list.
+ *   2. For all remaining pagesets:
+ *      2.1 If the tid_used_list is empty and the tid_group_list
+ *          is empty, stop processing pageset and return only
+ *          what has been programmed up to this point.
+ *      2.2 If the tid_used_list is empty and the tid_group_list
+ *          is not empty, move a group from tid_group_list to
+ *          tid_used_list.
+ *      2.3 For each group is tid_used_group, program as much as
+ *          can fit into the group. If the group becomes fully
+ *          used, move it to tid_full_list.
+ */
 int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 {
-	return -EINVAL;
+	int ret = 0, need_group = 0, pinned;
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	struct hfi1_devdata *dd = uctxt->dd;
+	unsigned npages, ngroups, pageidx = 0, pageset_count, npagesets,
+		tididx = 0, mapped, mapped_pages = 0;
+	unsigned long vaddr = tinfo->vaddr;
+	struct page **pages = NULL;
+	u32 *tidlist = NULL;
+	struct tid_pageset *pagesets = NULL;
+
+	/* Get the number of pages the user buffer spans */
+	npages = num_user_pages(vaddr, tinfo->length);
+	if (!npages)
+		return -EINVAL;
+
+	if (npages > uctxt->expected_count) {
+		dd_dev_err(dd, "Expected buffer too big\n");
+		return -EINVAL;
+	}
+
+	/* Verify that access is OK for the user buffer */
+	if (!access_ok(VERIFY_WRITE, (void __user *)vaddr,
+		       npages * PAGE_SIZE)) {
+		dd_dev_err(dd, "Fail vaddr %p, %u pages, !access_ok\n",
+			   (void *)vaddr, npages);
+		return -EFAULT;
+	}
+
+	pagesets = kcalloc(uctxt->expected_count, sizeof(*pagesets),
+			   GFP_KERNEL);
+	if (!pagesets)
+		return -ENOMEM;
+
+	/* Allocate the array of struct page pointers needed for pinning */
+	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto bail;
+	}
+
+	/*
+	 * Pin all the pages of the user buffer. If we can't pin all the
+	 * pages, accept the amount pinned so far and program only that.
+	 * User space knows how to deal with partially programmed buffers.
+	 */
+	pinned = hfi1_acquire_user_pages(vaddr, npages, true, pages);
+	if (pinned <= 0) {
+		ret = pinned;
+		goto bail;
+	}
+
+	/* Find sets of physically contiguous pages */
+	npagesets = find_phys_blocks(pages, pinned, pagesets);
+
+	/*
+	 * We don't need to access this under a lock since tid_used is per
+	 * process and the same process cannot be in hfi1_user_exp_rcv_clear()
+	 * and hfi1_user_exp_rcv_setup() at the same time.
+	 */
+	spin_lock(&fd->tid_lock);
+	if (fd->tid_used + npagesets > fd->tid_limit)
+		pageset_count = fd->tid_limit - fd->tid_used;
+	else
+		pageset_count = npagesets;
+	spin_unlock(&fd->tid_lock);
+
+	if (!pageset_count)
+		goto bail;
+
+	ngroups = pageset_count / dd->rcv_entries.group_size;
+	tidlist = kcalloc(pageset_count, sizeof(*tidlist), GFP_KERNEL);
+	if (!tidlist) {
+		ret = -ENOMEM;
+		goto nomem;
+	}
+
+	tididx = 0;
+
+	/*
+	 * From this point on, we are going to be using shared (between master
+	 * and subcontexts) context resources. We need to take the lock.
+	 */
+	mutex_lock(&uctxt->exp_lock);
+	/*
+	 * The first step is to program the RcvArray entries which are complete
+	 * groups.
+	 */
+	while (ngroups && uctxt->tid_group_list.count) {
+		struct tid_group *grp =
+			tid_group_pop(&uctxt->tid_group_list);
+
+		ret = program_rcvarray(fp, vaddr, grp, pagesets,
+				       pageidx, dd->rcv_entries.group_size,
+				       pages, tidlist, &tididx, &mapped);
+		/*
+		 * If there was a failure to program the RcvArray
+		 * entries for the entire group, reset the grp fields
+		 * and add the grp back to the free group list.
+		 */
+		if (ret <= 0) {
+			tid_group_add_tail(grp, &uctxt->tid_group_list);
+			hfi1_cdbg(TID,
+				  "Failed to program RcvArray group %d", ret);
+			goto unlock;
+		}
+
+		tid_group_add_tail(grp, &uctxt->tid_full_list);
+		ngroups--;
+		pageidx += ret;
+		mapped_pages += mapped;
+	}
+
+	while (pageidx < pageset_count) {
+		struct tid_group *grp, *ptr;
+		/*
+		 * If we don't have any partially used tid groups, check
+		 * if we have empty groups. If so, take one from there and
+		 * put in the partially used list.
+		 */
+		if (!uctxt->tid_used_list.count || need_group) {
+			if (!uctxt->tid_group_list.count)
+				goto unlock;
+
+			grp = tid_group_pop(&uctxt->tid_group_list);
+			tid_group_add_tail(grp, &uctxt->tid_used_list);
+			need_group = 0;
+		}
+		/*
+		 * There is an optimization opportunity here - instead of
+		 * fitting as many page sets as we can, check for a group
+		 * later on in the list that could fit all of them.
+		 */
+		list_for_each_entry_safe(grp, ptr, &uctxt->tid_used_list.list,
+					 list) {
+			unsigned use = min_t(unsigned, pageset_count - pageidx,
+					     grp->size - grp->used);
+
+			ret = program_rcvarray(fp, vaddr, grp, pagesets,
+					       pageidx, use, pages, tidlist,
+					       &tididx, &mapped);
+			if (ret < 0) {
+				hfi1_cdbg(TID,
+					  "Failed to program RcvArray entries %d",
+					  ret);
+				ret = -EFAULT;
+				goto unlock;
+			} else if (ret > 0) {
+				if (grp->used == grp->size)
+					tid_group_move(grp,
+						       &uctxt->tid_used_list,
+						       &uctxt->tid_full_list);
+				pageidx += ret;
+				mapped_pages += mapped;
+				need_group = 0;
+				/* Check if we are done so we break out early */
+				if (pageidx >= pageset_count)
+					break;
+			} else if (WARN_ON(ret == 0)) {
+				/*
+				 * If ret is 0, we did not program any entries
+				 * into this group, which can only happen if
+				 * we've screwed up the accounting somewhere.
+				 * Warn and try to continue.
+				 */
+				need_group = 1;
+			}
+		}
+	}
+unlock:
+	mutex_unlock(&uctxt->exp_lock);
+nomem:
+	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
+		  mapped_pages, ret);
+	if (tididx) {
+		spin_lock(&fd->tid_lock);
+		fd->tid_used += tididx;
+		spin_unlock(&fd->tid_lock);
+		tinfo->tidcnt = tididx;
+		tinfo->length = mapped_pages * PAGE_SIZE;
+
+		if (copy_to_user((void __user *)(unsigned long)tinfo->tidlist,
+				 tidlist, sizeof(tidlist[0]) * tididx)) {
+			/*
+			 * On failure to copy to the user level, we need to undo
+			 * everything done so far so we don't leak resources.
+			 */
+			tinfo->tidlist = (unsigned long)&tidlist;
+			hfi1_user_exp_rcv_clear(fp, tinfo);
+			tinfo->tidlist = 0;
+			ret = -EFAULT;
+			goto bail;
+		}
+	}
+
+	/*
+	 * If not everything was mapped (due to insufficient RcvArray entries,
+	 * for example), unpin all unmapped pages so we can pin them nex time.
+	 */
+	if (mapped_pages != pinned)
+		hfi1_release_user_pages(&pages[mapped_pages],
+					pinned - mapped_pages,
+					false);
+bail:
+	kfree(pagesets);
+	kfree(pages);
+	kfree(tidlist);
+	return ret > 0 ? 0 : ret;
 }
 
 int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
