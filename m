From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 07/11] RDMA/cxgb4: debugfs files for dumping active
	stags.
Date: Fri, 10 Sep 2010 11:15:20 -0500
Message-ID: <20100910161519.6829.90437.stgit@build.ogc.int>
References: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100910161442.6829.91594.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add "stags" debugfs file.  This is useful for examining the TPTE
and PBL entries in adapter memory.  It allows scripts to dump just the
active entries.

Also clean up the "qps" file handlers and shared common code.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |  152 +++++++++++++++++++++++++---------
 1 files changed, 113 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 9bbf491..2851bf8 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -49,29 +49,57 @@ static DEFINE_MUTEX(dev_mutex);
 
 static struct dentry *c4iw_debugfs_root;
 
-struct debugfs_qp_data {
+struct c4iw_debugfs_data {
 	struct c4iw_dev *devp;
 	char *buf;
 	int bufsize;
 	int pos;
 };
 
-static int count_qps(int id, void *p, void *data)
+static int count_idrs(int id, void *p, void *data)
 {
-	struct c4iw_qp *qp = p;
 	int *countp = data;
 
-	if (id != qp->wq.sq.qid)
-		return 0;
-
 	*countp = *countp + 1;
 	return 0;
 }
 
-static int dump_qps(int id, void *p, void *data)
+static ssize_t debugfs_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct c4iw_debugfs_data *d = file->private_data;
+	loff_t pos = *ppos;
+	loff_t avail = d->pos;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= avail)
+		return 0;
+	if (count > avail - pos)
+		count = avail - pos;
+
+	while (count) {
+		size_t len = 0;
+
+		len = min((int)count, (int)d->pos - (int)pos);
+		if (copy_to_user(buf, d->buf + pos, len))
+			return -EFAULT;
+		if (len == 0)
+			return -EINVAL;
+
+		buf += len;
+		pos += len;
+		count -= len;
+	}
+	count = pos - *ppos;
+	*ppos = pos;
+	return count;
+}
+
+static int dump_qp(int id, void *p, void *data)
 {
 	struct c4iw_qp *qp = p;
-	struct debugfs_qp_data *qpd = data;
+	struct c4iw_debugfs_data *qpd = data;
 	int space;
 	int cc;
 
@@ -101,7 +129,7 @@ static int dump_qps(int id, void *p, void *data)
 
 static int qp_release(struct inode *inode, struct file *file)
 {
-	struct debugfs_qp_data *qpd = file->private_data;
+	struct c4iw_debugfs_data *qpd = file->private_data;
 	if (!qpd) {
 		printk(KERN_INFO "%s null qpd?\n", __func__);
 		return 0;
@@ -113,7 +141,7 @@ static int qp_release(struct inode *inode, struct file *file)
 
 static int qp_open(struct inode *inode, struct file *file)
 {
-	struct debugfs_qp_data *qpd;
+	struct c4iw_debugfs_data *qpd;
 	int ret = 0;
 	int count = 1;
 
@@ -126,7 +154,7 @@ static int qp_open(struct inode *inode, struct file *file)
 	qpd->pos = 0;
 
 	spin_lock_irq(&qpd->devp->lock);
-	idr_for_each(&qpd->devp->qpidr, count_qps, &count);
+	idr_for_each(&qpd->devp->qpidr, count_idrs, &count);
 	spin_unlock_irq(&qpd->devp->lock);
 
 	qpd->bufsize = count * 128;
@@ -137,7 +165,7 @@ static int qp_open(struct inode *inode, struct file *file)
 	}
 
 	spin_lock_irq(&qpd->devp->lock);
-	idr_for_each(&qpd->devp->qpidr, dump_qps, qpd);
+	idr_for_each(&qpd->devp->qpidr, dump_qp, qpd);
 	spin_unlock_irq(&qpd->devp->lock);
 
 	qpd->buf[qpd->pos++] = 0;
@@ -149,43 +177,84 @@ out:
 	return ret;
 }
 
-static ssize_t qp_read(struct file *file, char __user *buf, size_t count,
-			loff_t *ppos)
+static const struct file_operations qp_debugfs_fops = {
+	.owner   = THIS_MODULE,
+	.open    = qp_open,
+	.release = qp_release,
+	.read    = debugfs_read,
+};
+
+static int dump_stag(int id, void *p, void *data)
 {
-	struct debugfs_qp_data *qpd = file->private_data;
-	loff_t pos = *ppos;
-	loff_t avail = qpd->pos;
+	struct c4iw_debugfs_data *stagd = data;
+	int space;
+	int cc;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= avail)
+	space = stagd->bufsize - stagd->pos - 1;
+	if (space == 0)
+		return 1;
+
+	cc = snprintf(stagd->buf + stagd->pos, space, "0x%x\n", id<<8);
+	if (cc < space)
+		stagd->pos += cc;
+	return 0;
+}
+
+static int stag_release(struct inode *inode, struct file *file)
+{
+	struct c4iw_debugfs_data *stagd = file->private_data;
+	if (!stagd) {
+		printk(KERN_INFO "%s null stagd?\n", __func__);
 		return 0;
-	if (count > avail - pos)
-		count = avail - pos;
+	}
+	kfree(stagd->buf);
+	kfree(stagd);
+	return 0;
+}
 
-	while (count) {
-		size_t len = 0;
+static int stag_open(struct inode *inode, struct file *file)
+{
+	struct c4iw_debugfs_data *stagd;
+	int ret = 0;
+	int count = 1;
 
-		len = min((int)count, (int)qpd->pos - (int)pos);
-		if (copy_to_user(buf, qpd->buf + pos, len))
-			return -EFAULT;
-		if (len == 0)
-			return -EINVAL;
+	stagd = kmalloc(sizeof *stagd, GFP_KERNEL);
+	if (!stagd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	stagd->devp = inode->i_private;
+	stagd->pos = 0;
 
-		buf += len;
-		pos += len;
-		count -= len;
+	spin_lock_irq(&stagd->devp->lock);
+	idr_for_each(&stagd->devp->mmidr, count_idrs, &count);
+	spin_unlock_irq(&stagd->devp->lock);
+
+	stagd->bufsize = count * sizeof("0x12345678\n");
+	stagd->buf = kmalloc(stagd->bufsize, GFP_KERNEL);
+	if (!stagd->buf) {
+		ret = -ENOMEM;
+		goto err1;
 	}
-	count = pos - *ppos;
-	*ppos = pos;
-	return count;
+
+	spin_lock_irq(&stagd->devp->lock);
+	idr_for_each(&stagd->devp->mmidr, dump_stag, stagd);
+	spin_unlock_irq(&stagd->devp->lock);
+
+	stagd->buf[stagd->pos++] = 0;
+	file->private_data = stagd;
+	goto out;
+err1:
+	kfree(stagd);
+out:
+	return ret;
 }
 
-static const struct file_operations qp_debugfs_fops = {
+static const struct file_operations stag_debugfs_fops = {
 	.owner   = THIS_MODULE,
-	.open    = qp_open,
-	.release = qp_release,
-	.read    = qp_read,
+	.open    = stag_open,
+	.release = stag_release,
+	.read    = debugfs_read,
 };
 
 static int setup_debugfs(struct c4iw_dev *devp)
@@ -199,6 +268,11 @@ static int setup_debugfs(struct c4iw_dev *devp)
 				 (void *)devp, &qp_debugfs_fops);
 	if (de && de->d_inode)
 		de->d_inode->i_size = 4096;
+
+	de = debugfs_create_file("stags", S_IWUSR, devp->debugfs_root,
+				 (void *)devp, &stag_debugfs_fops);
+	if (de && de->d_inode)
+		de->d_inode->i_size = 4096;
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
