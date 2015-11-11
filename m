From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 6/8] staging/rdma/hfi1: Further clean up hfi1_ioctl parameter checks
Date: Wed, 11 Nov 2015 00:43:07 -0500
Message-ID: <1447220589-9067-7-git-send-email-ira.weiny@intel.com>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447220589-9067-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Final clean up of the if/then/else clause for the parameter checks of
hfi1_ioctl

Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index a489a79dd3b6..43f08080480c 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -974,24 +974,28 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	struct hfi1_pportdata *ppd = NULL;
 	unsigned int index;
 	struct hfi1_link_info link_info;
+	int read_cmd, write_cmd, read_ok, write_ok;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
 	if (dd == NULL)
 		return -ENODEV;
 
 	mode_flag = dd->hfi1_snoop.mode_flag;
+	read_cmd = _IOC_DIR(cmd) & _IOC_READ;
+	write_cmd = _IOC_DIR(cmd) & _IOC_WRITE;
+	write_ok = access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd));
+	read_ok = access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd));
 
-	if (((_IOC_DIR(cmd) & _IOC_READ)
-	    && !access_ok(VERIFY_WRITE, (void __user *)arg, _IOC_SIZE(cmd)))
-	    || ((_IOC_DIR(cmd) & _IOC_WRITE)
-	    && !access_ok(VERIFY_READ, (void __user *)arg, _IOC_SIZE(cmd)))) {
+	if ((read_cmd && !write_ok) || (write_cmd && !read_ok))
 		return -EFAULT;
-	} else if (!capable(CAP_SYS_ADMIN)) {
+
+	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	} else if ((mode_flag & HFI1_PORT_CAPTURE_MODE) &&
-		   (cmd != HFI1_SNOOP_IOCCLEARQUEUE) &&
-		   (cmd != HFI1_SNOOP_IOCCLEARFILTER) &&
-		   (cmd != HFI1_SNOOP_IOCSETFILTER)) {
+
+	if ((mode_flag & HFI1_PORT_CAPTURE_MODE) &&
+	    (cmd != HFI1_SNOOP_IOCCLEARQUEUE) &&
+	    (cmd != HFI1_SNOOP_IOCCLEARFILTER) &&
+	    (cmd != HFI1_SNOOP_IOCSETFILTER))
 		/* Capture devices are allowed only 3 operations
 		 * 1.Clear capture queue
 		 * 2.Clear capture filter
@@ -999,10 +1003,10 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		 * Other are invalid.
 		 */
 		return -EINVAL;
-	} else if (cmd == HFI1_SNOOP_IOCSETLINKSTATE) {
+
+	if (cmd == HFI1_SNOOP_IOCSETLINKSTATE)
 		/* We do not support the old setlink state */
 		return -EINVAL;
-	}
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
