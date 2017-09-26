From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/hfi1: Refactor hfi_user_exp_rcv_clear()
 IOCTLs
Date: Tue, 26 Sep 2017 07:04:22 -0700
Message-ID: <20170926140421.16637.59333.stgit@scvm10.sc.intel.com>
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
Refactor the _TID_FREE IOCTL.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   49 +++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 6e85ee6..5015898 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -88,6 +88,8 @@ static int init_user_ctxt(struct hfi1_filedata *fd,
 static int get_base_info(struct hfi1_filedata *fd, unsigned long arg, u32 len);
 static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
 			      u32 len);
+static int user_exp_rcv_clear(struct hfi1_filedata *fd, unsigned long arg,
+			      u32 len);
 static int setup_base_ctxt(struct hfi1_filedata *fd,
 			   struct hfi1_ctxtdata *uctxt);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
@@ -257,18 +259,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		break;
 
 	case HFI1_IOCTL_TID_FREE:
-		if (copy_from_user(&tinfo,
-				   (struct hfi11_tid_info __user *)arg,
-				   sizeof(tinfo)))
-			return -EFAULT;
-
-		ret = hfi1_user_exp_rcv_clear(fd, &tinfo);
-		if (ret)
-			break;
-		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
-		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-				 sizeof(tinfo.tidcnt)))
-			ret = -EFAULT;
+		ret = user_exp_rcv_clear(fd, arg, _IOC_SIZE(cmd));
 		break;
 
 	case HFI1_IOCTL_TID_INVAL_READ:
@@ -1444,6 +1435,40 @@ static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
 	return ret;
 }
 
+/**
+ * user_exp_rcv_clear - Clear the given tid rcv list
+ * @fd: file data of the current driver instance
+ * @arg: ioctl argumnent for user space information
+ * @len: length of data structure associated with ioctl command
+ *
+ * The hfi1_user_exp_rcv_clear() can be called from the error path.  Because
+ * of this, we need to use this wrapper to copy the user space information
+ * before doing the clear.
+ */
+static int user_exp_rcv_clear(struct hfi1_filedata *fd, unsigned long arg,
+			      u32 len)
+{
+	int ret;
+	unsigned long addr;
+	struct hfi1_tid_info tinfo;
+
+	if (sizeof(tinfo) != len)
+		return -EINVAL;
+
+	if (copy_from_user(&tinfo, (void __user *)arg, (sizeof(tinfo))))
+		return -EFAULT;
+
+	ret = hfi1_user_exp_rcv_clear(fd, &tinfo);
+	if (!ret) {
+		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			return -EFAULT;
+	}
+
+	return ret;
+}
+
 static unsigned int poll_urgent(struct file *fp,
 				struct poll_table_struct *pt)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
