From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] IB/hfi1: Remove UI char device
Date: Thu, 12 May 2016 10:28:02 -0700
Message-ID: <20160512172801.11667.38334.stgit@scvm10.sc.intel.com>
References: <20160512172500.11667.11333.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172500.11667.11333.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove UI char device which exposes direct access to registers for user
space. This was put in to aid in debugging the hardware. We are looking
into alternatives means of providing the same functionality. This
removes another char device from HFI1's footprint.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/file_ops.c |  168 ----------------------------------
 1 files changed, 1 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index 930d829..60f8885 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -1471,163 +1471,10 @@ done:
 	return ret;
 }
 
-static int ui_open(struct inode *inode, struct file *filp)
-{
-	struct hfi1_devdata *dd;
-
-	dd = container_of(inode->i_cdev, struct hfi1_devdata, ui_cdev);
-	filp->private_data = dd; /* for other methods */
-	return 0;
-}
-
-static int ui_release(struct inode *inode, struct file *filp)
-{
-	/* nothing to do */
-	return 0;
-}
-
-static loff_t ui_lseek(struct file *filp, loff_t offset, int whence)
-{
-	struct hfi1_devdata *dd = filp->private_data;
-
-	return fixed_size_llseek(filp, offset, whence,
-		(dd->kregend - dd->kregbase) + DC8051_DATA_MEM_SIZE);
-}
-
-/* NOTE: assumes unsigned long is 8 bytes */
-static ssize_t ui_read(struct file *filp, char __user *buf, size_t count,
-		       loff_t *f_pos)
-{
-	struct hfi1_devdata *dd = filp->private_data;
-	void __iomem *base = dd->kregbase;
-	unsigned long total, csr_off,
-		barlen = (dd->kregend - dd->kregbase);
-	u64 data;
-
-	/* only read 8 byte quantities */
-	if ((count % 8) != 0)
-		return -EINVAL;
-	/* offset must be 8-byte aligned */
-	if ((*f_pos % 8) != 0)
-		return -EINVAL;
-	/* destination buffer must be 8-byte aligned */
-	if ((unsigned long)buf % 8 != 0)
-		return -EINVAL;
-	/* must be in range */
-	if (*f_pos + count > (barlen + DC8051_DATA_MEM_SIZE))
-		return -EINVAL;
-	/* only set the base if we are not starting past the BAR */
-	if (*f_pos < barlen)
-		base += *f_pos;
-	csr_off = *f_pos;
-	for (total = 0; total < count; total += 8, csr_off += 8) {
-		/* accessing LCB CSRs requires more checks */
-		if (is_lcb_offset(csr_off)) {
-			if (read_lcb_csr(dd, csr_off, (u64 *)&data))
-				break; /* failed */
-		}
-		/*
-		 * Cannot read ASIC GPIO/QSFP* clear and force CSRs without a
-		 * false parity error.  Avoid the whole issue by not reading
-		 * them.  These registers are defined as having a read value
-		 * of 0.
-		 */
-		else if (csr_off == ASIC_GPIO_CLEAR ||
-			 csr_off == ASIC_GPIO_FORCE ||
-			 csr_off == ASIC_QSFP1_CLEAR ||
-			 csr_off == ASIC_QSFP1_FORCE ||
-			 csr_off == ASIC_QSFP2_CLEAR ||
-			 csr_off == ASIC_QSFP2_FORCE)
-			data = 0;
-		else if (csr_off >= barlen) {
-			/*
-			 * read_8051_data can read more than just 8 bytes at
-			 * a time. However, folding this into the loop and
-			 * handling the reads in 8 byte increments allows us
-			 * to smoothly transition from chip memory to 8051
-			 * memory.
-			 */
-			if (read_8051_data(dd,
-					   (u32)(csr_off - barlen),
-					   sizeof(data), &data))
-				break; /* failed */
-		} else
-			data = readq(base + total);
-		if (put_user(data, (unsigned long __user *)(buf + total)))
-			break;
-	}
-	*f_pos += total;
-	return total;
-}
-
-/* NOTE: assumes unsigned long is 8 bytes */
-static ssize_t ui_write(struct file *filp, const char __user *buf,
-			size_t count, loff_t *f_pos)
-{
-	struct hfi1_devdata *dd = filp->private_data;
-	void __iomem *base;
-	unsigned long total, data, csr_off;
-	int in_lcb;
-
-	/* only write 8 byte quantities */
-	if ((count % 8) != 0)
-		return -EINVAL;
-	/* offset must be 8-byte aligned */
-	if ((*f_pos % 8) != 0)
-		return -EINVAL;
-	/* source buffer must be 8-byte aligned */
-	if ((unsigned long)buf % 8 != 0)
-		return -EINVAL;
-	/* must be in range */
-	if (*f_pos + count > dd->kregend - dd->kregbase)
-		return -EINVAL;
-
-	base = (void __iomem *)dd->kregbase + *f_pos;
-	csr_off = *f_pos;
-	in_lcb = 0;
-	for (total = 0; total < count; total += 8, csr_off += 8) {
-		if (get_user(data, (unsigned long __user *)(buf + total)))
-			break;
-		/* accessing LCB CSRs requires a special procedure */
-		if (is_lcb_offset(csr_off)) {
-			if (!in_lcb) {
-				int ret = acquire_lcb_access(dd, 1);
-
-				if (ret)
-					break;
-				in_lcb = 1;
-			}
-		} else {
-			if (in_lcb) {
-				release_lcb_access(dd, 1);
-				in_lcb = 0;
-			}
-		}
-		writeq(data, base + total);
-	}
-	if (in_lcb)
-		release_lcb_access(dd, 1);
-	*f_pos += total;
-	return total;
-}
-
-static const struct file_operations ui_file_ops = {
-	.owner = THIS_MODULE,
-	.llseek = ui_lseek,
-	.read = ui_read,
-	.write = ui_write,
-	.open = ui_open,
-	.release = ui_release,
-};
-
-#define UI_OFFSET 192	/* device minor offset for UI devices */
-static int create_ui = 1;
-
 static void user_remove(struct hfi1_devdata *dd)
 {
 
 	hfi1_cdev_cleanup(&dd->user_cdev, &dd->user_device);
-	hfi1_cdev_cleanup(&dd->ui_cdev, &dd->ui_device);
 }
 
 static int user_add(struct hfi1_devdata *dd)
@@ -1640,21 +1487,8 @@ static int user_add(struct hfi1_devdata *dd)
 			     &dd->user_cdev, &dd->user_device,
 			     true);
 	if (ret)
-		goto done;
+		user_remove(dd);
 
-	if (create_ui) {
-		snprintf(name, sizeof(name),
-			 "%s_ui%d", class_name(), dd->unit);
-		ret = hfi1_cdev_init(dd->unit + UI_OFFSET, name, &ui_file_ops,
-				     &dd->ui_cdev, &dd->ui_device,
-				     false);
-		if (ret)
-			goto done;
-	}
-
-	return 0;
-done:
-	user_remove(dd);
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
