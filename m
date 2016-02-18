From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/8] staging/rdma/hfi1: Guard i2c access against cp
Date: Thu, 18 Feb 2016 11:12:51 -0800
Message-ID: <20160218191248.20983.84486.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

An attempt to cp or cat /sys/kernel/debug/hfi1/hfi1_0/i2c1
produces this message:

hfi1 0000:81:00.0: hfi1_0: IB0:1 I2C failed even retrying

Fix the issue by explicitly rejecting a simple cat/cp with an
-EINVAL error return.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/debugfs.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index 4fd58e3..07c16b3 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -446,6 +446,16 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 	rcu_read_lock();
 	ppd = private2ppd(file);
 
+	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
+	i2c_addr = (*ppos >> 16) & 0xffff;
+	offset = *ppos & 0xffff;
+
+	/* explicitly reject invalid address 0 to catch cp and cat */
+	if (i2c_addr == 0) {
+		ret = -EINVAL;
+		goto _return;
+	}
+
 	buff = kmalloc(count, GFP_KERNEL);
 	if (!buff) {
 		ret = -ENOMEM;
@@ -458,10 +468,6 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 		goto _free;
 	}
 
-	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
-	i2c_addr = (*ppos >> 16) & 0xffff;
-	offset = *ppos & 0xffff;
-
 	total_written = i2c_write(ppd, target, i2c_addr, offset, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
@@ -507,16 +513,22 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 	rcu_read_lock();
 	ppd = private2ppd(file);
 
+	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
+	i2c_addr = (*ppos >> 16) & 0xffff;
+	offset = *ppos & 0xffff;
+
+	/* explicitly reject invalid address 0 to catch cp and cat */
+	if (i2c_addr == 0) {
+		ret = -EINVAL;
+		goto _return;
+	}
+
 	buff = kmalloc(count, GFP_KERNEL);
 	if (!buff) {
 		ret = -ENOMEM;
 		goto _return;
 	}
 
-	/* byte offset format: [offsetSize][i2cAddr][offsetHigh][offsetLow] */
-	i2c_addr = (*ppos >> 16) & 0xffff;
-	offset = *ppos & 0xffff;
-
 	total_read = i2c_read(ppd, target, i2c_addr, offset, buff, count);
 	if (total_read < 0) {
 		ret = total_read;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
