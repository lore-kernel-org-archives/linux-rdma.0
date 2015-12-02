From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 04/13] staging/rdma/hfi1: diag.c fix white space errors
Date: Wed,  2 Dec 2015 00:43:29 -0500
Message-ID: <1449035018-26396-5-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add or remove whitespace according to checkpatch --strict

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index ca833e9a4f15..ac0685ce373f 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -177,27 +177,27 @@ struct hfi1_link_info {
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
@@ -440,7 +438,7 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 	}
 
 	if (copy_from_user(tmpbuf,
-			   (const void __user *) (unsigned long) dp->data,
+			   (const void __user *)(unsigned long)dp->data,
 			   dp->len)) {
 		ret = -EFAULT;
 		goto bail;
@@ -611,7 +609,6 @@ static struct hfi1_devdata *hfi1_dd_from_sc_inode(struct inode *in)
 
 	dd = hfi1_lookup(unit);
 	return dd;
-
 }
 
 /* clear or restore send context integrity checks */
@@ -805,7 +802,6 @@ static unsigned int hfi1_snoop_poll(struct file *fp,
 
 	spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 	return ret;
-
 }
 
 static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
@@ -847,7 +843,7 @@ static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
 		if (copy_from_user(&byte_one, data, 1))
 			return -EINVAL;
 
-		if (copy_from_user(&byte_two, data+1, 1))
+		if (copy_from_user(&byte_two, data + 1, 1))
 			return -EINVAL;
 
 		sc4 = (byte_one >> 4) & 0xf;
@@ -1321,7 +1317,6 @@ static int hfi1_filter_mad_mgmt_class(void *ibhdr, void *packet_data,
 
 static int hfi1_filter_qp_number(void *ibhdr, void *packet_data, void *value)
 {
-
 	struct hfi1_ib_header *hdr;
 	struct hfi1_other_headers *ohdr = NULL;
 	int ret;
@@ -1404,7 +1399,6 @@ static int hfi1_filter_ib_service_level(void *ibhdr, void *packet_data,
 
 static int hfi1_filter_ib_pkey(void *ibhdr, void *packet_data, void *value)
 {
-
 	u32 lnh = 0;
 	struct hfi1_ib_header *hdr;
 	struct hfi1_other_headers *ohdr = NULL;
@@ -1476,7 +1470,6 @@ static struct snoop_packet *allocate_snoop_packet(u32 hdr_len,
 						  u32 data_len,
 						  u32 md_len)
 {
-
 	struct snoop_packet *packet;
 
 	packet = kzalloc(sizeof(struct snoop_packet) + hdr_len + data_len
@@ -1485,7 +1478,6 @@ static struct snoop_packet *allocate_snoop_packet(u32 hdr_len,
 	if (likely(packet))
 		INIT_LIST_HEAD(&packet->list);
 
-
 	return packet;
 }
 
@@ -1542,7 +1534,6 @@ int snoop_recv_handler(struct hfi1_packet *packet)
 		    unlikely(snoop_flags & SNOOP_USE_METADATA))
 			md_len = sizeof(struct capture_md);
 
-
 		s_packet = allocate_snoop_packet(header_size,
 						 tlen - header_size,
 						 md_len);
@@ -1869,5 +1860,4 @@ void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 
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
