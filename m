From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 12/14] staging/rdma/hfi1: Add TID free/clear function bodies
Date: Thu, 17 Dec 2015 23:50:02 -0500
Message-ID: <1450414204-13699-13-git-send-email-ira.weiny@intel.com>
References: <1450414204-13699-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450414204-13699-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Up to now, the functions which cleared the programmed
TID entries and gave PSM the list of invalidated TID entries
were just stubs. With this commit, the bodies of these
functions are added.

This commit is a bit asymmetric as it only contains the
free code path. This is done on purpose to help with patch
reviews as the programming code path is much longer.

Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 91 +++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_exp_rcv.c b/drivers/staging/rdma/hfi1/user_exp_rcv.c
index 1787c55d21d6..776ce003248e 100644
--- a/drivers/staging/rdma/hfi1/user_exp_rcv.c
+++ b/drivers/staging/rdma/hfi1/user_exp_rcv.c
@@ -120,10 +120,8 @@ static inline void mmu_notifier_range_start(struct mmu_notifier *,
 static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
 			    u32 *, unsigned *, unsigned *) __maybe_unused;
-static int unprogram_rcvarray(struct file *, u32,
-			      struct tid_group **) __maybe_unused;
-static void clear_tid_node(struct hfi1_filedata *, u16,
-			   struct mmu_rb_node *) __maybe_unused;
+static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
+static void clear_tid_node(struct hfi1_filedata *, u16, struct mmu_rb_node *);
 
 static inline u32 rcventry2tidinfo(u32 rcventry)
 {
@@ -264,6 +262,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	 * Make sure that we set the tid counts only after successful
 	 * init.
 	 */
+	spin_lock(&fd->tid_lock);
 	if (uctxt->subctxt_cnt && !HFI1_CAP_IS_USET(TID_UNMAP)) {
 		u16 remainder;
 
@@ -274,6 +273,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	} else {
 		fd->tid_limit = uctxt->expected_count;
 	}
+	spin_unlock(&fd->tid_lock);
 done:
 	return ret;
 }
@@ -346,12 +346,91 @@ int hfi1_user_exp_rcv_setup(struct file *fp, struct hfi1_tid_info *tinfo)
 
 int hfi1_user_exp_rcv_clear(struct file *fp, struct hfi1_tid_info *tinfo)
 {
-	return -EINVAL;
+	int ret = 0;
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	u32 *tidinfo;
+	unsigned tididx;
+
+	tidinfo = kcalloc(tinfo->tidcnt, sizeof(*tidinfo), GFP_KERNEL);
+	if (!tidinfo)
+		return -ENOMEM;
+
+	if (copy_from_user(tidinfo, (void __user *)(unsigned long)
+			   tinfo->tidlist, sizeof(tidinfo[0]) *
+			   tinfo->tidcnt)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	mutex_lock(&uctxt->exp_lock);
+	for (tididx = 0; tididx < tinfo->tidcnt; tididx++) {
+		ret = unprogram_rcvarray(fp, tidinfo[tididx], NULL);
+		if (ret) {
+			hfi1_cdbg(TID, "Failed to unprogram rcv array %d",
+				  ret);
+			break;
+		}
+	}
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= tididx;
+	spin_unlock(&fd->tid_lock);
+	tinfo->tidcnt = tididx;
+	mutex_unlock(&uctxt->exp_lock);
+done:
+	kfree(tidinfo);
+	return ret;
 }
 
 int hfi1_user_exp_rcv_invalid(struct file *fp, struct hfi1_tid_info *tinfo)
 {
-	return -EINVAL;
+	struct hfi1_filedata *fd = fp->private_data;
+	struct hfi1_ctxtdata *uctxt = fd->uctxt;
+	unsigned long *ev = uctxt->dd->events +
+		(((uctxt->ctxt - uctxt->dd->first_user_ctxt) *
+		  HFI1_MAX_SHARED_CTXTS) + fd->subctxt);
+	u32 *array;
+	int ret = 0;
+
+	if (!fd->invalid_tids)
+		return -EINVAL;
+
+	/*
+	 * copy_to_user() can sleep, which will leave the invalid_lock
+	 * locked and cause the MMU notifier to be blocked on the lock
+	 * for a long time.
+	 * Copy the data to a local buffer so we can release the lock.
+	 */
+	array = kcalloc(uctxt->expected_count, sizeof(*array), GFP_KERNEL);
+	if (!array)
+		return -EFAULT;
+
+	spin_lock(&fd->invalid_lock);
+	if (fd->invalid_tid_idx) {
+		memcpy(array, fd->invalid_tids, sizeof(*array) *
+		       fd->invalid_tid_idx);
+		memset(fd->invalid_tids, 0, sizeof(*fd->invalid_tids) *
+		       fd->invalid_tid_idx);
+		tinfo->tidcnt = fd->invalid_tid_idx;
+		fd->invalid_tid_idx = 0;
+		/*
+		 * Reset the user flag while still holding the lock.
+		 * Otherwise, PSM can miss events.
+		 */
+		clear_bit(_HFI1_EVENT_TID_MMU_NOTIFY_BIT, ev);
+	} else {
+		tinfo->tidcnt = 0;
+	}
+	spin_unlock(&fd->invalid_lock);
+
+	if (tinfo->tidcnt) {
+		if (copy_to_user((void __user *)tinfo->tidlist,
+				 array, sizeof(*array) * tinfo->tidcnt))
+			ret = -EFAULT;
+	}
+	kfree(array);
+
+	return ret;
 }
 
 static u32 find_phys_blocks(struct page **pages, unsigned npages,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
