From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/9] IB/hfi1: Refactor get_base_info
Date: Tue, 26 Sep 2017 07:04:10 -0700
Message-ID: <20170926140408.16637.21630.stgit@scvm10.sc.intel.com>
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
 drivers/infiniband/hw/hfi1/file_ops.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 1fc500f..b1c0cc1 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -85,8 +85,7 @@ static int init_user_ctxt(struct hfi1_filedata *fd,
 			  struct hfi1_ctxtdata *uctxt);
 static void user_init(struct hfi1_ctxtdata *uctxt);
 static int get_ctxt_info(struct hfi1_filedata *fd, unsigned long arg, u32 len);
-static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
-			 __u32 len);
+static int get_base_info(struct hfi1_filedata *fd, unsigned long arg, u32 len);
 static int setup_base_ctxt(struct hfi1_filedata *fd,
 			   struct hfi1_ctxtdata *uctxt);
 static int setup_subctxt(struct hfi1_ctxtdata *uctxt);
@@ -243,9 +242,9 @@ static long hfi1_file_ioctl(struct file *fp, unsigned int cmd,
 		break;
 
 	case HFI1_IOCTL_USER_INFO:
-		ret = get_base_info(fd, (void __user *)(unsigned long)arg,
-				    sizeof(struct hfi1_base_info));
+		ret = get_base_info(fd, arg, _IOC_SIZE(cmd));
 		break;
+
 	case HFI1_IOCTL_CREDIT_UPD:
 		if (uctxt)
 			sc_return_credits(uctxt->sc);
@@ -1344,18 +1343,18 @@ static int setup_base_ctxt(struct hfi1_filedata *fd,
 	return ret;
 }
 
-static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
-			 __u32 len)
+static int get_base_info(struct hfi1_filedata *fd, unsigned long arg, u32 len)
 {
 	struct hfi1_base_info binfo;
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
-	ssize_t sz;
 	unsigned offset;
-	int ret = 0;
 
 	trace_hfi1_uctxtdata(uctxt->dd, uctxt, fd->subctxt);
 
+	if (sizeof(binfo) != len)
+		return -EINVAL;
+
 	memset(&binfo, 0, sizeof(binfo));
 	binfo.hw_version = dd->revision;
 	binfo.sw_version = HFI1_KERN_SWVERSION;
@@ -1414,10 +1413,11 @@ static int get_base_info(struct hfi1_filedata *fd, void __user *ubase,
 							  uctxt->ctxt,
 							  fd->subctxt, 0);
 	}
-	sz = (len < sizeof(binfo)) ? len : sizeof(binfo);
-	if (copy_to_user(ubase, &binfo, sz))
-		ret = -EFAULT;
-	return ret;
+
+	if (copy_to_user((void __user *)arg, &binfo, len))
+		return -EFAULT;
+
+	return 0;
 }
 
 static unsigned int poll_urgent(struct file *fp,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
