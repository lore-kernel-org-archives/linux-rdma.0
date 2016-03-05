From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/17] IB/hfi1: Hold i2c resource across debugfs open/close
Date: Sat, 05 Mar 2016 08:50:27 -0800
Message-ID: <20160305165027.32025.34116.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

External i2c firmware updates are done in multiple steps and
cannot have other things done in between.  For debugfs files,
acquire the resource on open and release it on close.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |  145 +++++++++++++++++++++++++++++-----
 1 files changed, 124 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 665666c..6a1bc28 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -49,6 +49,7 @@
 #include <linux/seq_file.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/module.h>
 
 #include "hfi.h"
 #include "debugfs.h"
@@ -465,22 +466,16 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 		goto _free;
 	}
 
-	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
-	if (ret)
-		goto _free;
-
 	total_written = i2c_write(ppd, target, i2c_addr, offset, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
-		goto _release;
+		goto _free;
 	}
 
 	*ppos += total_written;
 
 	ret = total_written;
 
- _release:
-	release_chip_resource(ppd->dd, i2c_target(target));
  _free:
 	kfree(buff);
  _return:
@@ -532,14 +527,10 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 		goto _return;
 	}
 
-	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
-	if (ret)
-		goto _free;
-
 	total_read = i2c_read(ppd, target, i2c_addr, offset, buff, count);
 	if (total_read < 0) {
 		ret = total_read;
-		goto _release;
+		goto _free;
 	}
 
 	*ppos += total_read;
@@ -547,13 +538,11 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 	ret = copy_to_user(buf, buff, total_read);
 	if (ret > 0) {
 		ret = -EFAULT;
-		goto _release;
+		goto _free;
 	}
 
 	ret = total_read;
 
- _release:
-	release_chip_resource(ppd->dd, i2c_target(target));
  _free:
 	kfree(buff);
  _return:
@@ -604,7 +593,7 @@ static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
 		goto _free;
 	}
 
-	total_written = one_qsfp_write(ppd, target, *ppos, buff, count);
+	total_written = qsfp_write(ppd, target, *ppos, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
 		goto _free;
@@ -658,7 +647,7 @@ static ssize_t __qsfp_debugfs_read(struct file *file, char __user *buf,
 		goto _return;
 	}
 
-	total_read = one_qsfp_read(ppd, target, *ppos, buff, count);
+	total_read = qsfp_read(ppd, target, *ppos, buff, count);
 	if (total_read < 0) {
 		ret = total_read;
 		goto _free;
@@ -695,6 +684,104 @@ static ssize_t qsfp2_debugfs_read(struct file *file, char __user *buf,
 	return __qsfp_debugfs_read(file, buf, count, ppos, 1);
 }
 
+static int __i2c_debugfs_open(struct inode *in, struct file *fp, u32 target)
+{
+	struct hfi1_pportdata *ppd;
+	int ret;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	ppd = private2ppd(fp);
+
+	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
+	if (ret) /* failed - release the module */
+		module_put(THIS_MODULE);
+
+	return ret;
+}
+
+static int i2c1_debugfs_open(struct inode *in, struct file *fp)
+{
+	return __i2c_debugfs_open(in, fp, 0);
+}
+
+static int i2c2_debugfs_open(struct inode *in, struct file *fp)
+{
+	return __i2c_debugfs_open(in, fp, 1);
+}
+
+static int __i2c_debugfs_release(struct inode *in, struct file *fp, u32 target)
+{
+	struct hfi1_pportdata *ppd;
+
+	ppd = private2ppd(fp);
+
+	release_chip_resource(ppd->dd, i2c_target(target));
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+static int i2c1_debugfs_release(struct inode *in, struct file *fp)
+{
+	return __i2c_debugfs_release(in, fp, 0);
+}
+
+static int i2c2_debugfs_release(struct inode *in, struct file *fp)
+{
+	return __i2c_debugfs_release(in, fp, 1);
+}
+
+static int __qsfp_debugfs_open(struct inode *in, struct file *fp, u32 target)
+{
+	struct hfi1_pportdata *ppd;
+	int ret;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	ppd = private2ppd(fp);
+
+	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
+	if (ret) /* failed - release the module */
+		module_put(THIS_MODULE);
+
+	return ret;
+}
+
+static int qsfp1_debugfs_open(struct inode *in, struct file *fp)
+{
+	return __qsfp_debugfs_open(in, fp, 0);
+}
+
+static int qsfp2_debugfs_open(struct inode *in, struct file *fp)
+{
+	return __qsfp_debugfs_open(in, fp, 1);
+}
+
+static int __qsfp_debugfs_release(struct inode *in, struct file *fp, u32 target)
+{
+	struct hfi1_pportdata *ppd;
+
+	ppd = private2ppd(fp);
+
+	release_chip_resource(ppd->dd, i2c_target(target));
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+static int qsfp1_debugfs_release(struct inode *in, struct file *fp)
+{
+	return __qsfp_debugfs_release(in, fp, 0);
+}
+
+static int qsfp2_debugfs_release(struct inode *in, struct file *fp)
+{
+	return __qsfp_debugfs_release(in, fp, 1);
+}
+
 #define DEBUGFS_OPS(nm, readroutine, writeroutine)	\
 { \
 	.name = nm, \
@@ -705,6 +792,18 @@ static ssize_t qsfp2_debugfs_read(struct file *file, char __user *buf,
 	}, \
 }
 
+#define DEBUGFS_XOPS(nm, readf, writef, openf, releasef) \
+{ \
+	.name = nm, \
+	.ops = { \
+		.read = readf, \
+		.write = writef, \
+		.llseek = generic_file_llseek, \
+		.open = openf, \
+		.release = releasef \
+	}, \
+}
+
 static const struct counter_info cntr_ops[] = {
 	DEBUGFS_OPS("counter_names", dev_names_read, NULL),
 	DEBUGFS_OPS("counters", dev_counters_read, NULL),
@@ -713,11 +812,15 @@ static const struct counter_info cntr_ops[] = {
 
 static const struct counter_info port_cntr_ops[] = {
 	DEBUGFS_OPS("port%dcounters", portcntrs_debugfs_read, NULL),
-	DEBUGFS_OPS("i2c1", i2c1_debugfs_read, i2c1_debugfs_write),
-	DEBUGFS_OPS("i2c2", i2c2_debugfs_read, i2c2_debugfs_write),
+	DEBUGFS_XOPS("i2c1", i2c1_debugfs_read, i2c1_debugfs_write,
+		     i2c1_debugfs_open, i2c1_debugfs_release),
+	DEBUGFS_XOPS("i2c2", i2c2_debugfs_read, i2c2_debugfs_write,
+		     i2c2_debugfs_open, i2c2_debugfs_release),
 	DEBUGFS_OPS("qsfp_dump%d", qsfp_debugfs_dump, NULL),
-	DEBUGFS_OPS("qsfp1", qsfp1_debugfs_read, qsfp1_debugfs_write),
-	DEBUGFS_OPS("qsfp2", qsfp2_debugfs_read, qsfp2_debugfs_write),
+	DEBUGFS_XOPS("qsfp1", qsfp1_debugfs_read, qsfp1_debugfs_write,
+		     qsfp1_debugfs_open, qsfp1_debugfs_release),
+	DEBUGFS_XOPS("qsfp2", qsfp2_debugfs_read, qsfp2_debugfs_write,
+		     qsfp2_debugfs_open, qsfp2_debugfs_release),
 };
 
 void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
