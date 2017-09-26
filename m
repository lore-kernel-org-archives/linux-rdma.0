From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/9] IB/hfi1: Refactor get_ctxt_info
Date: Tue, 26 Sep 2017 07:03:57 -0700
Message-ID: <20170926140355.16637.75620.stgit@scvm10.sc.intel.com>
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

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 174af25..a37139f 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -84,8 +84,7 @@ static void init_subctxts(struct hfi1_ctxtdata *uctxt,
 static int init_user_ctxt(struct hfi1_filedata *fd,
 			  struct hfi1_ctxtdata *uctxt);
 static void user_init(struct hfi1_ctxtdata *uctxt);
-static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
-			 __u32 len);
+static int get_ctxt_info(struct hfi1_filedata *fd, unsigned long arg, u32 len);
 static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 			 __u32 len);
 static int setup_base_ctxt(struct hfi1_filedata *fd,
@@ -240,9 +239,9 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		break;
 
 	case HFI1_IOCTL_CTXT_INFO:
-		ret = get_ctxt_info(fd, (void __user *)(unsigned long)arg,
-				    sizeof(struct hfi1_ctxt_info));
+		ret = get_ctxt_info(fd, arg, _IOC_SIZE(cmd));
 		break;
+
 	case HFI1_IOCTL_USER_INFO:
 		ret = get_base_info(fd, (void __user *)(unsigned long)arg,
 				    sizeof(struct hfi1_base_info));
@@ -1230,12 +1229,13 @@ static void user_init(struct hfi1_ctxtdata *uctxt)
 	hfi1_rcvctrl(uctxt->dd, rcvctrl_ops, uctxt);
 }
 
-static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
-			 __u32 len)
+static int get_ctxt_info(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 {
 	struct hfi1_ctxt_info cinfo;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
-	int ret = 0;
+
+	if (sizeof(cinfo) != len)
+		return -EINVAL;
 
 	memset(&cinfo, 0, sizeof(cinfo));
 	cinfo.runtime_flags = (((uctxt->flags >> HFI1_CAP_MISC_SHIFT) &
@@ -1265,10 +1265,10 @@ static int get_ctxt_info(struct hfi1_filedata *fd, void __user *ubase,
 	cinfo.rcvegr_size = uctxt->egrbufs.rcvtid_size;
 
 	trace_hfi1_ctxt_info(uctxt->dd, uctxt->ctxt, fd->subctxt, cinfo);
-	if (copy_to_user(ubase, &cinfo, sizeof(cinfo)))
-		ret = -EFAULT;
+	if (copy_to_user((void __user *)arg, &cinfo, len))
+		return -EFAULT;
 
-	return ret;
+	return 0;
 }
 
 static int init_user_ctxt(struct hfi1_filedata *fd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
