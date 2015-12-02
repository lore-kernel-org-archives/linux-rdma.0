From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 05/13] staging/rdma/hfi1: diag.c change null comparisons
Date: Wed,  2 Dec 2015 00:43:30 -0500
Message-ID: <1449035018-26396-6-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use !foo rather than (foo == NULL) as recommended by checkpatch --strict

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index ac0685ce373f..0643f3716719 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -563,7 +563,7 @@ static ssize_t diagpkt_write(struct file *fp, const char __user *data,
 	*/
 	if (dp.pbc) {
 		dd = hfi1_lookup(dp.unit);
-		if (dd == NULL)
+		if (!dd)
 			return -ENODEV;
 		vl = (dp.pbc >> PBC_VL_SHIFT) & PBC_VL_MASK;
 		sc = dd->vld[vl].sc;
@@ -649,7 +649,7 @@ static int hfi1_snoop_open(struct inode *in, struct file *fp)
 	mutex_lock(&hfi1_mutex);
 
 	dd = hfi1_dd_from_sc_inode(in);
-	if (dd == NULL) {
+	if (!dd) {
 		ret = -ENODEV;
 		goto bail;
 	}
@@ -736,7 +736,7 @@ static int hfi1_snoop_release(struct inode *in, struct file *fp)
 	int mode_flag;
 
 	dd = hfi1_dd_from_sc_inode(in);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -791,7 +791,7 @@ static unsigned int hfi1_snoop_poll(struct file *fp,
 	struct hfi1_devdata *dd;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -818,7 +818,7 @@ static ssize_t hfi1_snoop_write(struct file *fp, const char __user *data,
 	struct hfi1_pportdata *ppd;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	ppd = dd->pport;
@@ -916,7 +916,7 @@ static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
 	struct hfi1_devdata *dd;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -974,7 +974,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	struct hfi1_link_info link_info;
 
 	dd = hfi1_dd_from_sc_inode(fp->f_inode);
-	if (dd == NULL)
+	if (!dd)
 		return -ENODEV;
 
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
@@ -1538,7 +1538,7 @@ int snoop_recv_handler(struct hfi1_packet *packet)
 						 tlen - header_size,
 						 md_len);
 
-		if (unlikely(s_packet == NULL)) {
+		if (unlikely(!s_packet)) {
 			dd_dev_warn_ratelimited(ppd->dd, "Unable to allocate snoop/capture packet\n");
 			break;
 		}
@@ -1659,7 +1659,7 @@ int snoop_send_pio_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
 	/* not using ss->total_len as arg 2 b/c that does not count CRC */
 	s_packet = allocate_snoop_packet(hdr_len, tlen - hdr_len, md_len);
 
-	if (unlikely(s_packet == NULL)) {
+	if (unlikely(!s_packet)) {
 		dd_dev_warn_ratelimited(ppd->dd, "Unable to allocate snoop/capture packet\n");
 		goto out;
 	}
@@ -1828,7 +1828,7 @@ void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 
 		s_packet = allocate_snoop_packet(packet_len, 0, md_len);
 
-		if (unlikely(s_packet == NULL)) {
+		if (unlikely(!s_packet)) {
 			dd_dev_warn_ratelimited(dd, "Unable to allocate snoop/capture packet\n");
 			goto inline_pio_out;
 		}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
