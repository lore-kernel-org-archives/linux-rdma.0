From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/9] IB/hfi1: Refactor hfi_user_exp_rcv_invalid()
 IOCTLs
Date: Tue, 26 Sep 2017 07:04:29 -0700
Message-ID: <20170926140427.16637.40359.stgit@scvm10.sc.intel.com>
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
Refactor _TID_INVAL_READ IOCTLs.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c     |   54 +++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |    3 --
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 5015898..6146899 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -90,6 +90,8 @@ static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
 			      u32 len);
 static int user_exp_rcv_clear(struct hfi1_filedata *fd, unsigned long arg,
 			      u32 len);
+static int user_exp_rcv_invalid(struct hfi1_filedata *fd, unsigned long arg,
+				u32 len);
 static int setup_base_ctxt(struct hfi1_filedata *fd,
 			   struct hfi1_ctxtdata *uctxt);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
@@ -223,9 +225,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 {
 	struct hfi1_filedata *fd = fp->private_data;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	struct hfi1_tid_info tinfo;
 	int ret = 0;
-	unsigned long addr;
 	int uval = 0;
 	unsigned long ul_uval = 0;
 	u16 uval16 = 0;
@@ -263,18 +263,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		break;
 
 	case HFI1_IOCTL_TID_INVAL_READ:
-		if (copy_from_user(&tinfo,
-				   (struct hfi11_tid_info __user *)arg,
-				   sizeof(tinfo)))
-			return -EFAULT;
-
-		ret = hfi1_user_exp_rcv_invalid(fd, &tinfo);
-		if (ret)
-			break;
-		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
-		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-				 sizeof(tinfo.tidcnt)))
-			ret = -EFAULT;
+		ret = user_exp_rcv_invalid(fd, arg, _IOC_SIZE(cmd));
 		break;
 
 	case HFI1_IOCTL_RECV_CTRL:
@@ -1469,6 +1458,43 @@ static int user_exp_rcv_clear(struct hfi1_filedata *fd, unsigned long arg,
 	return ret;
 }
 
+/**
+ * user_exp_rcv_invalid - Invalidate the given tid rcv list
+ * @fd: file data of the current driver instance
+ * @arg: ioctl argumnent for user space information
+ * @len: length of data structure associated with ioctl command
+ *
+ * Wrapper to validate ioctl information before doing _rcv_invalid.
+ *
+ */
+static int user_exp_rcv_invalid(struct hfi1_filedata *fd, unsigned long arg,
+				u32 len)
+{
+	int ret;
+	unsigned long addr;
+	struct hfi1_tid_info tinfo;
+
+	if (sizeof(tinfo) != len)
+		return -EINVAL;
+
+	if (!fd->invalid_tids)
+		return -EINVAL;
+
+	if (copy_from_user(&tinfo, (void __user *)arg, (sizeof(tinfo))))
+		return -EFAULT;
+
+	ret = hfi1_user_exp_rcv_invalid(fd, &tinfo);
+	if (ret)
+		return ret;
+
+	addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
+	if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+			 sizeof(tinfo.tidcnt)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static unsigned int poll_urgent(struct file *fp,
 				struct poll_table_struct *pt)
 {
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index ff9ad69..c1c596a 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -546,9 +546,6 @@ int hfi1_user_exp_rcv_invalid(struct hfi1_filedata *fd,
 	u32 *array;
 	int ret = 0;
 
-	if (!fd->invalid_tids)
-		return -EINVAL;
-
 	/*
 	 * copy_to_user() can sleep, which will leave the invalid_lock
 	 * locked and cause the MMU notifier to be blocked on the lock

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
