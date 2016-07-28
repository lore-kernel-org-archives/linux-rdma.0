From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/16] IB/hfi1: Fix TID caching actions
Date: Thu, 28 Jul 2016 15:21:21 -0400
Message-ID: <1469733687-31738-11-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Per file descriptor TID caching actions depend on a global that can
change midway through the lifetime of that file descriptor.

Make the use of caching consistent for the life of the file descriptor
by using the presence of the cache handler to decide when to use the cache
functions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |  4 ++++
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 16 +++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 302f0cdd8119..4f39bffad74a 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1132,6 +1132,10 @@ static int get_ctxt_info(struct file *fp, void __user *ubase, __u32 len)
 				HFI1_CAP_MISC_MASK) << HFI1_CAP_USER_SHIFT) |
 			HFI1_CAP_UGET_MASK(uctxt->flags, MASK) |
 			HFI1_CAP_KGET_MASK(uctxt->flags, K2U);
+	/* adjust flag if this fd is not able to cache */
+	if (!fd->handler)
+		cinfo.runtime_flags |= HFI1_CAP_TID_UNMAP; /* no caching */
+
 	cinfo.num_active = hfi1_count_active_units();
 	cinfo.unit = uctxt->dd->unit;
 	cinfo.ctxt = uctxt->ctxt;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 269a948189e0..9b740db34963 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -196,7 +196,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	if (!fd->entry_to_rb)
 		return -ENOMEM;
 
-	if (!HFI1_CAP_IS_USET(TID_UNMAP)) {
+	if (!HFI1_CAP_UGET_MASK(uctxt->flags, TID_UNMAP)) {
 		fd->invalid_tid_idx = 0;
 		fd->invalid_tids = kzalloc(uctxt->expected_count *
 					   sizeof(u32), GFP_KERNEL);
@@ -207,15 +207,13 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 
 		/*
 		 * Register MMU notifier callbacks. If the registration
-		 * fails, continue but turn off the TID caching for
-		 * all user contexts.
+		 * fails, continue without TID caching for this context.
 		 */
 		ret = hfi1_mmu_rb_register(fd, fd->mm, &tid_rb_ops, &fd->handler);
 		if (ret) {
 			dd_dev_info(dd,
 				    "Failed MMU notifier registration %d\n",
 				    ret);
-			HFI1_CAP_USET(TID_UNMAP);
 			ret = 0;
 		}
 	}
@@ -234,7 +232,7 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 	 * init.
 	 */
 	spin_lock(&fd->tid_lock);
-	if (uctxt->subctxt_cnt && !HFI1_CAP_IS_USET(TID_UNMAP)) {
+	if (uctxt->subctxt_cnt && fd->handler) {
 		u16 remainder;
 
 		fd->tid_limit = uctxt->expected_count / uctxt->subctxt_cnt;
@@ -260,7 +258,7 @@ int hfi1_user_exp_rcv_free(struct hfi1_filedata *fd)
 	 * The notifier would have been removed when the process'es mm
 	 * was freed.
 	 */
-	if (!HFI1_CAP_IS_USET(TID_UNMAP))
+	if (fd->handler)
 		hfi1_mmu_rb_unregister(fd->handler);
 
 	kfree(fd->invalid_tids);
@@ -857,7 +855,7 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	node->freed = false;
 	memcpy(node->pages, pages, sizeof(struct page *) * npages);
 
-	if (HFI1_CAP_IS_USET(TID_UNMAP))
+	if (!fd->handler)
 		ret = tid_rb_insert(fd, &node->mmu);
 	else
 		ret = hfi1_mmu_rb_insert(fd->handler, &node->mmu);
@@ -900,7 +898,7 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	node = fd->entry_to_rb[rcventry];
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
-	if (HFI1_CAP_IS_USET(TID_UNMAP))
+	if (!fd->handler)
 		tid_rb_remove(fd, &node->mmu, fd->mm);
 	else
 		hfi1_mmu_rb_remove(fd->handler, &node->mmu);
@@ -963,7 +961,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 							  uctxt->expected_base];
 				if (!node || node->rcventry != rcventry)
 					continue;
-				if (HFI1_CAP_IS_USET(TID_UNMAP))
+				if (!fd->handler)
 					tid_rb_remove(fd, &node->mmu, fd->mm);
 				else
 					hfi1_mmu_rb_remove(fd->handler,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
