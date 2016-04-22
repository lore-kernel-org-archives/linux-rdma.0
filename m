From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc] IB/hfi1: Use kernel default llseek for ui device
Date: Fri, 22 Apr 2016 11:17:03 -0700
Message-ID: <20160422181702.15797.42892.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ui device llseek had a mistake with SEEK_END and did
not fully follow seek semantics.  Correct all this by
using a kernel supplied function for fixed size devices.

Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index ec6c226..5415295 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1559,29 +1559,8 @@ static loff_t ui_lseek(struct file *filp, loff_t offset, int whence)
 {
 	struct hfi1_devdata *dd = filp->private_data;
 
-	switch (whence) {
-	case SEEK_SET:
-		break;
-	case SEEK_CUR:
-		offset += filp->f_pos;
-		break;
-	case SEEK_END:
-		offset = ((dd->kregend - dd->kregbase) + DC8051_DATA_MEM_SIZE) -
-			offset;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (offset < 0)
-		return -EINVAL;
-
-	if (offset >= (dd->kregend - dd->kregbase) + DC8051_DATA_MEM_SIZE)
-		return -EINVAL;
-
-	filp->f_pos = offset;
-
-	return filp->f_pos;
+	return fixed_size_llseek(filp, offset, whence,
+		(dd->kregend - dd->kregbase) + DC8051_DATA_MEM_SIZE);
 }
 
 /* NOTE: assumes unsigned long is 8 bytes */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
