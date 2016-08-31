From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] IB/hfi1: Rework debugfs to use SRCU
Date: Wed, 31 Aug 2016 07:24:46 -0700
Message-ID: <20160831142445.27232.21375.stgit@scvm10.sc.intel.com>
References: <20160831141841.27232.61621.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831141841.27232.61621.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The debugfs RCU trips many debug kernel warnings because of potential
sleeps with an RCU read lock held. This includes both user copy calls
and slab allocations throughout the file.

This patch switches the RCU to use SRCU for file remove/access
race protection.

In one case, the SRCU is implicit in the use of the raw debugfs file
object and just works.

In the seq_file case, a wrapper around seq_read() and seq_lseek() is
used to enforce the SRCU using the debugfs supplied functions
debugfs_use_file_start() and debugfs_use_file_stop().

The sychronize_rcu() is deleted since the SRCU prevents the remove
access race.

The RCU locking is kept for qp_stats since the QP hash list is
protected using the non-sleepable RCU.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |  132 +++++++++++++---------------------
 1 files changed, 52 insertions(+), 80 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index a49cc88..5e9be16 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -59,6 +59,40 @@
 
 static struct dentry *hfi1_dbg_root;
 
+/* wrappers to enforce srcu in seq file */
+static ssize_t hfi1_seq_read(
+	struct file *file,
+	char __user *buf,
+	size_t size,
+	loff_t *ppos)
+{
+	struct dentry *d = file->f_path.dentry;
+	int srcu_idx;
+	ssize_t r;
+
+	r = debugfs_use_file_start(d, &srcu_idx);
+	if (likely(!r))
+		r = seq_read(file, buf, size, ppos);
+	debugfs_use_file_finish(srcu_idx);
+	return r;
+}
+
+static loff_t hfi1_seq_lseek(
+	struct file *file,
+	loff_t offset,
+	int whence)
+{
+	struct dentry *d = file->f_path.dentry;
+	int srcu_idx;
+	loff_t r;
+
+	r = debugfs_use_file_start(d, &srcu_idx);
+	if (likely(!r))
+		r = seq_lseek(file, offset, whence);
+	debugfs_use_file_finish(srcu_idx);
+	return r;
+}
+
 #define private2dd(file) (file_inode(file)->i_private)
 #define private2ppd(file) (file_inode(file)->i_private)
 
@@ -87,8 +121,8 @@ static int _##name##_open(struct inode *inode, struct file *s) \
 static const struct file_operations _##name##_file_ops = { \
 	.owner   = THIS_MODULE, \
 	.open    = _##name##_open, \
-	.read    = seq_read, \
-	.llseek  = seq_lseek, \
+	.read    = hfi1_seq_read, \
+	.llseek  = hfi1_seq_lseek, \
 	.release = seq_release \
 }
 
@@ -105,11 +139,9 @@ do { \
 	DEBUGFS_FILE_CREATE(#name, parent, data, &_##name##_file_ops, S_IRUGO)
 
 static void *_opcode_stats_seq_start(struct seq_file *s, loff_t *pos)
-__acquires(RCU)
 {
 	struct hfi1_opcode_stats_perctx *opstats;
 
-	rcu_read_lock();
 	if (*pos >= ARRAY_SIZE(opstats->stats))
 		return NULL;
 	return pos;
@@ -126,9 +158,7 @@ static void *_opcode_stats_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void _opcode_stats_seq_stop(struct seq_file *s, void *v)
-__releases(RCU)
 {
-	rcu_read_unlock();
 }
 
 static int _opcode_stats_seq_show(struct seq_file *s, void *v)
@@ -285,12 +315,10 @@ DEBUGFS_SEQ_FILE_OPEN(qp_stats)
 DEBUGFS_FILE_OPS(qp_stats);
 
 static void *_sdes_seq_start(struct seq_file *s, loff_t *pos)
-__acquires(RCU)
 {
 	struct hfi1_ibdev *ibd;
 	struct hfi1_devdata *dd;
 
-	rcu_read_lock();
 	ibd = (struct hfi1_ibdev *)s->private;
 	dd = dd_from_dev(ibd);
 	if (!dd->per_sdma || *pos >= dd->num_sdma)
@@ -310,9 +338,7 @@ static void *_sdes_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void _sdes_seq_stop(struct seq_file *s, void *v)
-__releases(RCU)
 {
-	rcu_read_unlock();
 }
 
 static int _sdes_seq_show(struct seq_file *s, void *v)
@@ -339,11 +365,9 @@ static ssize_t dev_counters_read(struct file *file, char __user *buf,
 	struct hfi1_devdata *dd;
 	ssize_t rval;
 
-	rcu_read_lock();
 	dd = private2dd(file);
 	avail = hfi1_read_cntrs(dd, NULL, &counters);
 	rval =  simple_read_from_buffer(buf, count, ppos, counters, avail);
-	rcu_read_unlock();
 	return rval;
 }
 
@@ -356,11 +380,9 @@ static ssize_t dev_names_read(struct file *file, char __user *buf,
 	struct hfi1_devdata *dd;
 	ssize_t rval;
 
-	rcu_read_lock();
 	dd = private2dd(file);
 	avail = hfi1_read_cntrs(dd, &names, NULL);
 	rval =  simple_read_from_buffer(buf, count, ppos, names, avail);
-	rcu_read_unlock();
 	return rval;
 }
 
@@ -383,11 +405,9 @@ static ssize_t portnames_read(struct file *file, char __user *buf,
 	struct hfi1_devdata *dd;
 	ssize_t rval;
 
-	rcu_read_lock();
 	dd = private2dd(file);
 	avail = hfi1_read_portcntrs(dd->pport, &names, NULL);
 	rval = simple_read_from_buffer(buf, count, ppos, names, avail);
-	rcu_read_unlock();
 	return rval;
 }
 
@@ -400,11 +420,9 @@ static ssize_t portcntrs_debugfs_read(struct file *file, char __user *buf,
 	struct hfi1_pportdata *ppd;
 	ssize_t rval;
 
-	rcu_read_lock();
 	ppd = private2ppd(file);
 	avail = hfi1_read_portcntrs(ppd, NULL, &counters);
 	rval = simple_read_from_buffer(buf, count, ppos, counters, avail);
-	rcu_read_unlock();
 	return rval;
 }
 
@@ -434,16 +452,13 @@ static ssize_t asic_flags_read(struct file *file, char __user *buf,
 	int used;
 	int i;
 
-	rcu_read_lock();
 	ppd = private2ppd(file);
 	dd = ppd->dd;
 	size = PAGE_SIZE;
 	used = 0;
 	tmp = kmalloc(size, GFP_KERNEL);
-	if (!tmp) {
-		rcu_read_unlock();
+	if (!tmp)
 		return -ENOMEM;
-	}
 
 	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
 	used += scnprintf(tmp + used, size - used,
@@ -470,7 +485,6 @@ static ssize_t asic_flags_read(struct file *file, char __user *buf,
 	used += scnprintf(tmp + used, size - used, "Write bits to clear\n");
 
 	ret = simple_read_from_buffer(buf, count, ppos, tmp, used);
-	rcu_read_unlock();
 	kfree(tmp);
 	return ret;
 }
@@ -486,15 +500,12 @@ static ssize_t asic_flags_write(struct file *file, const char __user *buf,
 	u64 scratch0;
 	u64 clear;
 
-	rcu_read_lock();
 	ppd = private2ppd(file);
 	dd = ppd->dd;
 
 	buff = kmalloc(count + 1, GFP_KERNEL);
-	if (!buff) {
-		ret = -ENOMEM;
-		goto do_return;
-	}
+	if (!buff)
+		return -ENOMEM;
 
 	ret = copy_from_user(buff, buf, count);
 	if (ret > 0) {
@@ -527,8 +538,6 @@ static ssize_t asic_flags_write(struct file *file, const char __user *buf,
 
  do_free:
 	kfree(buff);
- do_return:
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -542,18 +551,14 @@ static ssize_t qsfp_debugfs_dump(struct file *file, char __user *buf,
 	char *tmp;
 	int ret;
 
-	rcu_read_lock();
 	ppd = private2ppd(file);
 	tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!tmp) {
-		rcu_read_unlock();
+	if (!tmp)
 		return -ENOMEM;
-	}
 
 	ret = qsfp_dump(ppd, tmp, PAGE_SIZE);
 	if (ret > 0)
 		ret = simple_read_from_buffer(buf, count, ppos, tmp, ret);
-	rcu_read_unlock();
 	kfree(tmp);
 	return ret;
 }
@@ -569,7 +574,6 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 	int offset;
 	int total_written;
 
-	rcu_read_lock();
 	ppd = private2ppd(file);
 
 	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
@@ -577,16 +581,12 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 	offset = *ppos & 0xffff;
 
 	/* explicitly reject invalid address 0 to catch cp and cat */
-	if (i2c_addr == 0) {
-		ret = -EINVAL;
-		goto _return;
-	}
+	if (i2c_addr == 0)
+		return -EINVAL;
 
 	buff = kmalloc(count, GFP_KERNEL);
-	if (!buff) {
-		ret = -ENOMEM;
-		goto _return;
-	}
+	if (!buff)
+		return -ENOMEM;
 
 	ret = copy_from_user(buff, buf, count);
 	if (ret > 0) {
@@ -606,8 +606,6 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 
  _free:
 	kfree(buff);
- _return:
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -636,7 +634,6 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 	int offset;
 	int total_read;
 
-	rcu_read_lock();
 	ppd = private2ppd(file);
 
 	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
@@ -644,16 +641,12 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 	offset = *ppos & 0xffff;
 
 	/* explicitly reject invalid address 0 to catch cp and cat */
-	if (i2c_addr == 0) {
-		ret = -EINVAL;
-		goto _return;
-	}
+	if (i2c_addr == 0)
+		return -EINVAL;
 
 	buff = kmalloc(count, GFP_KERNEL);
-	if (!buff) {
-		ret = -ENOMEM;
-		goto _return;
-	}
+	if (!buff)
+		return -ENOMEM;
 
 	total_read = i2c_read(ppd, target, i2c_addr, offset, buff, count);
 	if (total_read < 0) {
@@ -673,8 +666,6 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 
  _free:
 	kfree(buff);
- _return:
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -701,26 +692,20 @@ static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
 	int ret;
 	int total_written;
 
-	rcu_read_lock();
-	if (*ppos + count > QSFP_PAGESIZE * 4) { /* base page + page00-page03 */
-		ret = -EINVAL;
-		goto _return;
-	}
+	if (*ppos + count > QSFP_PAGESIZE * 4) /* base page + page00-page03 */
+		return -EINVAL;
 
 	ppd = private2ppd(file);
 
 	buff = kmalloc(count, GFP_KERNEL);
-	if (!buff) {
-		ret = -ENOMEM;
-		goto _return;
-	}
+	if (!buff)
+		return -ENOMEM;
 
 	ret = copy_from_user(buff, buf, count);
 	if (ret > 0) {
 		ret = -EFAULT;
 		goto _free;
 	}
-
 	total_written = qsfp_write(ppd, target, *ppos, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
@@ -733,8 +718,6 @@ static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
 
  _free:
 	kfree(buff);
- _return:
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -761,7 +744,6 @@ static ssize_t __qsfp_debugfs_read(struct file *file, char __user *buf,
 	int ret;
 	int total_read;
 
-	rcu_read_lock();
 	if (*ppos + count > QSFP_PAGESIZE * 4) { /* base page + page00-page03 */
 		ret = -EINVAL;
 		goto _return;
@@ -794,7 +776,6 @@ static ssize_t __qsfp_debugfs_read(struct file *file, char __user *buf,
  _free:
 	kfree(buff);
  _return:
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -1010,7 +991,6 @@ void hfi1_dbg_ibdev_exit(struct hfi1_ibdev *ibd)
 	debugfs_remove_recursive(ibd->hfi1_ibdev_dbg);
 out:
 	ibd->hfi1_ibdev_dbg = NULL;
-	synchronize_rcu();
 }
 
 /*
@@ -1035,9 +1015,7 @@ static const char * const hfi1_statnames[] = {
 };
 
 static void *_driver_stats_names_seq_start(struct seq_file *s, loff_t *pos)
-__acquires(RCU)
 {
-	rcu_read_lock();
 	if (*pos >= ARRAY_SIZE(hfi1_statnames))
 		return NULL;
 	return pos;
@@ -1055,9 +1033,7 @@ static void *_driver_stats_names_seq_next(
 }
 
 static void _driver_stats_names_seq_stop(struct seq_file *s, void *v)
-__releases(RCU)
 {
-	rcu_read_unlock();
 }
 
 static int _driver_stats_names_seq_show(struct seq_file *s, void *v)
@@ -1073,9 +1049,7 @@ DEBUGFS_SEQ_FILE_OPEN(driver_stats_names)
 DEBUGFS_FILE_OPS(driver_stats_names);
 
 static void *_driver_stats_seq_start(struct seq_file *s, loff_t *pos)
-__acquires(RCU)
 {
-	rcu_read_lock();
 	if (*pos >= ARRAY_SIZE(hfi1_statnames))
 		return NULL;
 	return pos;
@@ -1090,9 +1064,7 @@ static void *_driver_stats_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void _driver_stats_seq_stop(struct seq_file *s, void *v)
-__releases(RCU)
 {
-	rcu_read_unlock();
 }
 
 static u64 hfi1_sps_ints(void)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
