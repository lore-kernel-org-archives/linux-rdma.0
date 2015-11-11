From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/8] staging/rdma/hfi1: diag.c Correct code style issues
Date: Wed, 11 Nov 2015 00:43:02 -0500
Message-ID: <1447220589-9067-2-git-send-email-ira.weiny@intel.com>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447220589-9067-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Using the latest checkpatch correct the checks on diag.c

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 81 ++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 0aaad7412842..c5cc2db1b559 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -78,8 +78,8 @@
 	hfi1_cdbg(SNOOP, fmt, ##__VA_ARGS__)
 
 /* Snoop option mask */
-#define SNOOP_DROP_SEND	(1 << 0)
-#define SNOOP_USE_METADATA	(1 << 1)
+#define SNOOP_DROP_SEND		BIT(0)
+#define SNOOP_USE_METADATA	BIT(1)
 
 static u8 snoop_flags;
 
@@ -135,7 +135,7 @@ static struct cdev diagpkt_cdev;
 static struct device *diagpkt_device;
 
 static ssize_t diagpkt_write(struct file *fp, const char __user *data,
-				 size_t count, loff_t *off);
+			     size_t count, loff_t *off);
 
 static const struct file_operations diagpkt_file_ops = {
 	.owner = THIS_MODULE,
@@ -177,37 +177,37 @@ struct hfi1_link_info {
 #define HFI1_SNOOP_IOCGETLINKSTATE \
 	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ)
 #define HFI1_SNOOP_IOCSETLINKSTATE \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+1)
+	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 1)
 #define HFI1_SNOOP_IOCCLEARQUEUE \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+2)
+	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 2)
 #define HFI1_SNOOP_IOCCLEARFILTER \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+3)
+	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 3)
 #define HFI1_SNOOP_IOCSETFILTER \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+4)
+	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 4)
 #define HFI1_SNOOP_IOCGETVERSION \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+5)
+	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 5)
 #define HFI1_SNOOP_IOCSET_OPTS \
-	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+6)
+	_IO(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 6)
 
 /*
  * These offsets +6/+7 could change, but these are already known and used
  * IOCTL numbers so don't change them without a good reason.
  */
 #define HFI1_SNOOP_IOCGETLINKSTATE_EXTRA \
-	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+6, \
+	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 6, \
 		struct hfi1_link_info)
 #define HFI1_SNOOP_IOCSETLINKSTATE_EXTRA \
-	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ+7, \
+	_IOWR(HFI1_SNOOP_IOC_MAGIC, HFI1_SNOOP_IOC_BASE_SEQ + 7, \
 		struct hfi1_link_info)
 
 static int hfi1_snoop_open(struct inode *in, struct file *fp);
 static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
-				size_t pkt_len, loff_t *off);
+			       size_t pkt_len, loff_t *off);
 static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
-				 size_t count, loff_t *off);
+				size_t count, loff_t *off);
 static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 static unsigned int hfi1_snoop_poll(struct file *fp,
-					struct poll_table_struct *wait);
+				    struct poll_table_struct *wait);
 static int hfi1_snoop_release(struct inode *in, struct file *fp);
 
 struct hfi1_packet_filter_command {
@@ -323,14 +323,12 @@ static void hfi1_snoop_remove(struct hfi1_devdata *dd)
 
 void hfi1_diag_remove(struct hfi1_devdata *dd)
 {
-
 	hfi1_snoop_remove(dd);
 	if (atomic_dec_and_test(&diagpkt_count))
 		hfi1_cdev_cleanup(&diagpkt_cdev, &diagpkt_device);
 	hfi1_cdev_cleanup(&dd->diag_cdev, &dd->diag_device);
 }
 
-
 /*
  * Allocated structure shared between the credit return mechanism and
  * diagpkt_send().
@@ -393,7 +391,7 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 
 	if (dp->version != _DIAG_PKT_VERS) {
 		dd_dev_err(dd, "Invalid version %u for diagpkt_write\n",
-			    dp->version);
+			   dp->version);
 		ret = -EINVAL;
 		goto bail;
 	}
@@ -440,7 +438,7 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 	}
 
 	if (copy_from_user(tmpbuf,
-			   (const void __user *) (unsigned long) dp->data,
+			   (const void __user *)(unsigned long)dp->data,
 			   dp->len)) {
 		ret = -EFAULT;
 		goto bail;
@@ -530,9 +528,9 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 		 * NOTE: PRC_FILL_ERR is at best informational and cannot
 		 * be depended on.
 		 */
-		if (!ret && (((wait->code & PRC_STATUS_ERR)
-				|| (wait->code & PRC_FILL_ERR)
-				|| (wait->code & PRC_SC_DISABLE))))
+		if (!ret && (((wait->code & PRC_STATUS_ERR) ||
+			      (wait->code & PRC_FILL_ERR) ||
+			      (wait->code & PRC_SC_DISABLE))))
 			ret = -EIO;
 
 		put_diagpkt_wait(wait);	/* finished with the structure */
@@ -545,7 +543,7 @@ bail:
 }
 
 static ssize_t diagpkt_write(struct file *fp, const char __user *data,
-				 size_t count, loff_t *off)
+			     size_t count, loff_t *off)
 {
 	struct hfi1_devdata *dd;
 	struct send_context *sc;
@@ -565,7 +563,7 @@ static ssize_t diagpkt_write(struct file *fp, const char __user *data,
 	*/
 	if (dp.pbc) {
 		dd = hfi1_lookup(dp.unit);
-		if (dd == NULL)
+		if (!dd)
 			return -ENODEV;
 		vl = (dp.pbc >> PBC_VL_SHIFT) & PBC_VL_MASK;
 		sc = dd->vld[vl].sc;
@@ -598,7 +596,7 @@ static int hfi1_snoop_add(struct hfi1_devdata *dd, const char *name)
 	if (ret) {
 		dd_dev_err(dd, "Couldn't create %s device: %d", name, ret);
 		hfi1_cdev_cleanup(&dd->hfi1_snoop.cdev,
-				 &dd->hfi1_snoop.class_dev);
+				  &dd->hfi1_snoop.class_dev);
 	}
 
 	return ret;
@@ -611,7 +609,6 @@ static struct hfi1_devdata *hfi1_dd_from_sc_inode(struct inode *in)
 
 	dd = hfi1_lookup(unit);
 	return dd;
-
 }
 
 /* clear or restore send context integrity checks */
@@ -652,7 +649,7 @@ static int hfi1_snoop_open(struct inode *in, struct file *fp)
 	mutex_lock(&hfi1_mutex);
 
 	dd = hfi1_dd_from_sc_inode(in);
-	if (dd == NULL) {
+	if (!dd) {
 		ret = -ENODEV;
 		goto bail;
 	}
@@ -739,7 +736,7 @@ static int hfi1_snoop_release(struct inode *in, struct file *fp)
 	int mode_flag;
 
 	dd = hfi1_dd_from_sc_inode(in);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -794,7 +791,7 @@ static unsigned int hfi1_snoop_poll(struct file *fp,
 	struct hfi1_devdata *dd;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -805,7 +802,6 @@ static unsigned int hfi1_snoop_poll(struct file *fp,
 
 	spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 	return ret;
-
 }
 
 static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
@@ -822,7 +818,7 @@ static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
 	struct hfi1_pportdata *ppd;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	ppd = dd->pport;
@@ -847,7 +843,7 @@ static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
 		if (copy_from_user(&byte_one, data, 1))
 			return -EINVAL;
 
-		if (copy_from_user(&byte_two, data+1, 1))
+		if (copy_from_user(&byte_two, data + 1, 1))
 			return -EINVAL;
 
 		sc4 = (byte_one >> 4) & 0xf;
@@ -920,7 +916,7 @@ static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
 	struct hfi1_devdata *dd;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -946,16 +942,18 @@ static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
 		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		if (pkt_len >= packet->total_len) {
 			if (copy_to_user(data, packet->data,
-				packet->total_len))
+					 packet->total_len))
 				ret = -EFAULT;
 			else
 				ret = packet->total_len;
-		} else
+		} else {
 			ret = -EINVAL;
+		}
 
 		kfree(packet);
-	} else
+	} else {
 		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
+	}
 
 	return ret;
 }
@@ -1321,7 +1319,6 @@ static int hfi1_filter_mad_mgmt_class(void *ibhdr, void *packet_data,
 
 static int hfi1_filter_qp_number(void *ibhdr, void *packet_data, void *value)
 {
-
 	struct hfi1_ib_header *hdr;
 	struct hfi1_other_headers *ohdr = NULL;
 	int ret;
@@ -1404,7 +1401,6 @@ static int hfi1_filter_ib_service_level(void *ibhdr, void *packet_data,
 
 static int hfi1_filter_ib_pkey(void *ibhdr, void *packet_data, void *value)
 {
-
 	u32 lnh = 0;
 	struct hfi1_ib_header *hdr;
 	struct hfi1_other_headers *ohdr = NULL;
@@ -1479,13 +1475,12 @@ static struct snoop_packet *allocate_snoop_packet(u32 hdr_len,
 
 	struct snoop_packet *packet;
 
-	packet = kzalloc(sizeof(struct snoop_packet) + hdr_len + data_len
+	packet = kzalloc(sizeof(*packet) + hdr_len + data_len
 			 + md_len,
 			 GFP_ATOMIC | __GFP_NOWARN);
 	if (likely(packet))
 		INIT_LIST_HEAD(&packet->list);
 
-
 	return packet;
 }
 
@@ -1542,12 +1537,11 @@ int snoop_recv_handler(struct hfi1_packet *packet)
 		    unlikely(snoop_flags & SNOOP_USE_METADATA))
 			md_len = sizeof(struct capture_md);
 
-
 		s_packet = allocate_snoop_packet(header_size,
 						 tlen - header_size,
 						 md_len);
 
-		if (unlikely(s_packet == NULL)) {
+		if (unlikely(!s_packet)) {
 			dd_dev_warn_ratelimited(ppd->dd, "Unable to allocate snoop/capture packet\n");
 			break;
 		}
@@ -1668,7 +1662,7 @@ int snoop_send_pio_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 	/* not using ss->total_len as arg 2 b/c that does not count CRC */
 	s_packet = allocate_snoop_packet(hdr_len, tlen - hdr_len, md_len);
 
-	if (unlikely(s_packet == NULL)) {
+	if (unlikely(!s_packet)) {
 		dd_dev_warn_ratelimited(ppd->dd, "Unable to allocate snoop/capture packet\n");
 		goto out;
 	}
@@ -1837,7 +1831,7 @@ void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 
 		s_packet = allocate_snoop_packet(packet_len, 0, md_len);
 
-		if (unlikely(s_packet == NULL)) {
+		if (unlikely(!s_packet)) {
 			dd_dev_warn_ratelimited(dd, "Unable to allocate snoop/capture packet\n");
 			goto inline_pio_out;
 		}
@@ -1869,5 +1863,4 @@ void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 
 inline_pio_out:
 	pio_copy(dd, pbuf, pbc, from, count);
-
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
