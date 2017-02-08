From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 06/14] RDMA/cxgb4: Return an error code only as a constant in
 stag_open()
Date: Wed, 8 Feb 2017 22:16:46 +0100
Message-ID: <b636e00c-5a42-cdaa-9286-c4b7e48b497b@users.sourceforge.net>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Feb 2017 16:50:52 +0100

* Return an error code without storing it in an intermediate variable.

* Adjust jump targets according to the Linux coding style convention.

* Delete the local variable "ret" which became unnecessary with
  this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/cxgb4/device.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 51801a7d4fb3..90fa96abb5bc 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -433,14 +433,12 @@ static int stag_release(struct inode *inode, struct file *file)
 static int stag_open(struct inode *inode, struct file *file)
 {
 	struct c4iw_debugfs_data *stagd;
-	int ret = 0;
 	int count = 1;
 
 	stagd = kmalloc(sizeof *stagd, GFP_KERNEL);
-	if (!stagd) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!stagd)
+		goto failure_indication;
+
 	stagd->devp = inode->i_private;
 	stagd->pos = 0;
 
@@ -450,10 +448,8 @@ static int stag_open(struct inode *inode, struct file *file)
 
 	stagd->bufsize = count * 256;
 	stagd->buf = vmalloc(stagd->bufsize);
-	if (!stagd->buf) {
-		ret = -ENOMEM;
-		goto err1;
-	}
+	if (!stagd->buf)
+		goto free_stagd;
 
 	spin_lock_irq(&stagd->devp->lock);
 	idr_for_each(&stagd->devp->mmidr, dump_stag, stagd);
@@ -461,11 +457,11 @@ static int stag_open(struct inode *inode, struct file *file)
 
 	stagd->buf[stagd->pos++] = 0;
 	file->private_data = stagd;
-	goto out;
-err1:
+	return 0;
+free_stagd:
 	kfree(stagd);
-out:
-	return ret;
+failure_indication:
+	return -ENOMEM;
 }
 
 static const struct file_operations stag_debugfs_fops = {
-- 
2.11.1
