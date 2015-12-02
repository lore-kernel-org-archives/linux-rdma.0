From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 02/13] staging/rdma/hfi1: diag.c fix alignment
Date: Wed,  2 Dec 2015 00:43:27 -0500
Message-ID: <1449035018-26396-3-git-send-email-ira.weiny@intel.com>
References: <1449035018-26396-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449035018-26396-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix line alignment in various places as caught by checkpatch --strict.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 8faad4556ae1..1d9faad7662f 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -135,7 +135,7 @@ static struct cdev diagpkt_cdev;
 static struct device *diagpkt_device;
 
 static ssize_t diagpkt_write(struct file *fp, const char __user *data,
-				 size_t count, loff_t *off);
+			     size_t count, loff_t *off);
 
 static const struct file_operations diagpkt_file_ops = {
 	.owner = THIS_MODULE,
@@ -202,12 +202,12 @@ struct hfi1_link_info {
 
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
@@ -393,7 +393,7 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 
 	if (dp->version != _DIAG_PKT_VERS) {
 		dd_dev_err(dd, "Invalid version %u for diagpkt_write\n",
-			    dp->version);
+			   dp->version);
 		ret = -EINVAL;
 		goto bail;
 	}
@@ -545,7 +545,7 @@ bail:
 }
 
 static ssize_t diagpkt_write(struct file *fp, const char __user *data,
-				 size_t count, loff_t *off)
+			     size_t count, loff_t *off)
 {
 	struct hfi1_devdata *dd;
 	struct send_context *sc;
@@ -598,7 +598,7 @@ static int hfi1_snoop_add(struct hfi1_devdata *dd, const char *name)
 	if (ret) {
 		dd_dev_err(dd, "Couldn't create %s device: %d", name, ret);
 		hfi1_cdev_cleanup(&dd->hfi1_snoop.cdev,
-				 &dd->hfi1_snoop.class_dev);
+				  &dd->hfi1_snoop.class_dev);
 	}
 
 	return ret;
@@ -946,7 +946,7 @@ static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
 		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		if (pkt_len >= packet->total_len) {
 			if (copy_to_user(data, packet->data,
-				packet->total_len))
+					 packet->total_len))
 				ret = -EFAULT;
 			else
 				ret = packet->total_len;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
