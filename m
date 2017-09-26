From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/9] IB/hfi1: Refactor assign_ctxt() IOCTL
Date: Tue, 26 Sep 2017 07:03:50 -0700
Message-ID: <20170926140348.16637.10329.stgit@scvm10.sc.intel.com>
References: <20170926140201.16637.45981.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926140201.16637.45981.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The IOCTL is a bit unwieldy.  Refactor to a common pattern.
Refactor the assign_ctxt() IOCTL.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   36 +++++++++++++++++----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index c200a5c..174af25 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -78,7 +78,7 @@
 static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma);
 
 static u64 kvirt_to_phys(void *addr);
-static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo);
+static int assign_ctxt(struct hfi1_filedata *fd, unsigned long arg, u32 len);
 static void init_subctxts(struct hfi1_ctxtdata *uctxt,
 			  const struct hfi1_user_info *uinfo);
 static int init_user_ctxt(struct hfi1_filedata *fd,
@@ -221,7 +221,6 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 {
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct hfi1_user_info uinfo;
 	struct hfi1_tid_info tinfo;
 	int ret = 0;
 	unsigned long addr;
@@ -237,16 +236,9 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 
 	switch (cmd) {
 	case HFI1_IOCTL_ASSIGN_CTXT:
-		if (uctxt)
-			return -EINVAL;
-
-		if (copy_from_user(&uinfo,
-				   (struct hfi1_user_info __user *)arg,
-				   sizeof(uinfo)))
-			return -EFAULT;
-
-		ret = assign_ctxt(fd, &uinfo);
+		ret = assign_ctxt(fd, arg, _IOC_SIZE(cmd));
 		break;
+
 	case HFI1_IOCTL_CTXT_INFO:
 		ret = get_ctxt_info(fd, (void __user *)(unsigned long)arg,
 				    sizeof(struct hfi1_ctxt_info));
@@ -889,20 +881,30 @@ static int complete_subctxt(struct hfi1_filedata *fd)
 	return ret;
 }
 
-static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
+static int assign_ctxt(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 {
 	int ret;
 	unsigned int swmajor, swminor;
 	struct hfi1_ctxtdata *uctxt = NULL;
+	struct hfi1_user_info uinfo;
+
+	if (fd->uctxt)
+		return -EINVAL;
+
+	if (sizeof(uinfo) != len)
+		return -EINVAL;
+
+	if (copy_from_user(&uinfo, (void __user *)arg, sizeof(uinfo)))
+		return -EFAULT;
 
-	swmajor = uinfo->userversion >> 16;
+	swmajor = uinfo.userversion >> 16;
 	if (swmajor != HFI1_USER_SWMAJOR)
 		return -ENODEV;
 
-	if (uinfo->subctxt_cnt > HFI1_MAX_SHARED_CTXTS)
+	if (uinfo.subctxt_cnt > HFI1_MAX_SHARED_CTXTS)
 		return -EINVAL;
 
-	swminor = uinfo->userversion & 0xffff;
+	swminor = uinfo.userversion & 0xffff;
 
 	/*
 	 * Acquire the mutex to protect against multiple creations of what
@@ -913,14 +915,14 @@ static int assign_ctxt(struct hfi1_filedata *fd, struct hfi1_user_info *uinfo)
 	 * Get a sub context if available  (fd->uctxt will be set).
 	 * ret < 0 error, 0 no context, 1 sub-context found
 	 */
-	ret = find_sub_ctxt(fd, uinfo);
+	ret = find_sub_ctxt(fd, &uinfo);
 
 	/*
 	 * Allocate a base context if context sharing is not required or a
 	 * sub context wasn't found.
 	 */
 	if (!ret)
-		ret = allocate_ctxt(fd, fd->dd, uinfo, &uctxt);
+		ret = allocate_ctxt(fd, fd->dd, &uinfo, &uctxt);
 
 	mutex_unlock(&hfi1_mutex);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
