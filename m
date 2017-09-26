From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 5/9] IB/hfi1: Refactor hfi_user_exp_rcv_setup()
 IOCTL
Date: Tue, 26 Sep 2017 07:04:16 -0700
Message-ID: <20170926140415.16637.8118.stgit@scvm10.sc.intel.com>
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
Refactor the _TID_UPDATE IOCTL.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   66 +++++++++++++++++++++++----------
 1 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index b1c0cc1..6e85ee6 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -86,6 +86,8 @@ static int init_user_ctxt(struct hfi1_filedata *fd,
 static void user_init(struct hfi1_ctxtdata *uctxt);
 static int get_ctxt_info(struct hfi1_filedata *fd, unsigned long arg, u32 len);
 static int get_base_info(struct hfi1_filedata *fd, unsigned long arg, u32 len);
+static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
+			      u32 len);
 static int setup_base_ctxt(struct hfi1_filedata *fd,
 			   struct hfi1_ctxtdata *uctxt);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
@@ -251,27 +253,7 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		break;
 
 	case HFI1_IOCTL_TID_UPDATE:
-		if (copy_from_user(&tinfo,
-				   (struct hfi11_tid_info __user *)arg,
-				   sizeof(tinfo)))
-			return -EFAULT;
-
-		ret = hfi1_user_exp_rcv_setup(fd, &tinfo);
-		if (!ret) {
-			/*
-			 * Copy the number of tidlist entries we used
-			 * and the length of the buffer we registered.
-			 */
-			addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
-			if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
-					 sizeof(tinfo.tidcnt)))
-				return -EFAULT;
-
-			addr = arg + offsetof(struct hfi1_tid_info, length);
-			if (copy_to_user((void __user *)addr, &tinfo.length,
-					 sizeof(tinfo.length)))
-				ret = -EFAULT;
-		}
+		ret = user_exp_rcv_setup(fd, arg, _IOC_SIZE(cmd));
 		break;
 
 	case HFI1_IOCTL_TID_FREE:
@@ -1420,6 +1402,48 @@ static int get_base_info(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 	return 0;
 }
 
+/**
+ * user_exp_rcv_setup - Set up the given tid rcv list
+ * @fd: file data of the current driver instance
+ * @arg: ioctl argumnent for user space information
+ * @len: length of data structure associated with ioctl command
+ *
+ * Wrapper to validate ioctl information before doing _rcv_setup.
+ *
+ */
+static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
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
+	ret = hfi1_user_exp_rcv_setup(fd, &tinfo);
+	if (!ret) {
+		/*
+		 * Copy the number of tidlist entries we used
+		 * and the length of the buffer we registered.
+		 */
+		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
+		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
+				 sizeof(tinfo.tidcnt)))
+			return -EFAULT;
+
+		addr = arg + offsetof(struct hfi1_tid_info, length);
+		if (copy_to_user((void __user *)addr, &tinfo.length,
+				 sizeof(tinfo.length)))
+			ret = -EFAULT;
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
