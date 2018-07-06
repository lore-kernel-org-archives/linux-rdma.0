From: Jann Horn <jannh@google.com>
Subject: [PATCH] IB/mlx5: fix uaccess beyond "count" in debugfs read handlers
Date: Fri,  6 Jul 2018 17:24:49 +0200
Message-ID: <20180706152449.33415-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, jannh@google.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In general, accessing userspace memory beyond the length of the supplied
buffer in VFS read/write handlers can lead to both kernel memory corruption
(via kernel_read()/kernel_write(), which can e.g. be triggered via
sys_splice()) and privilege escalation inside userspace.

In this case, the affected files are in debugfs (and should therefore only
be accessible to root) and check that *pos is zero (which prevents the
sys_splice() trick). Therefore, this is not a security fix, but rather a
small cleanup.

Fix it by using simple_read_from_buffer() instead of custom logic.

Fixes: 4a2da0b8c078 ("IB/mlx5: Add debug control parameters for congestion control")
Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Jann Horn <jannh@google.com>
---
 drivers/infiniband/hw/mlx5/cong.c |  9 +--------
 drivers/infiniband/hw/mlx5/mr.c   | 20 ++------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index 985fa2637390..7e4e358a4fd8 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -359,9 +359,6 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
 	int ret;
 	char lbuf[11];
 
-	if (*pos)
-		return 0;
-
 	ret = mlx5_ib_get_cc_params(param->dev, param->port_num, offset, &var);
 	if (ret)
 		return ret;
@@ -370,11 +367,7 @@ static ssize_t get_param(struct file *filp, char __user *buf, size_t count,
 	if (ret < 0)
 		return ret;
 
-	if (copy_to_user(buf, lbuf, ret))
-		return -EFAULT;
-
-	*pos += ret;
-	return ret;
+	return simple_read_from_buffer(buf, count, pos, lbuf, ret);
 }
 
 static const struct file_operations dbg_cc_fops = {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 90a9c461cedc..37847add6f74 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -310,19 +310,11 @@ static ssize_t size_read(struct file *filp, char __user *buf, size_t count,
 	char lbuf[20];
 	int err;
 
-	if (*pos)
-		return 0;
-
 	err = snprintf(lbuf, sizeof(lbuf), "%d\n", ent->size);
 	if (err < 0)
 		return err;
 
-	if (copy_to_user(buf, lbuf, err))
-		return -EFAULT;
-
-	*pos += err;
-
-	return err;
+	return simple_read_from_buffer(buf, count, pos, lbuf, err);
 }
 
 static const struct file_operations size_fops = {
@@ -372,19 +364,11 @@ static ssize_t limit_read(struct file *filp, char __user *buf, size_t count,
 	char lbuf[20];
 	int err;
 
-	if (*pos)
-		return 0;
-
 	err = snprintf(lbuf, sizeof(lbuf), "%d\n", ent->limit);
 	if (err < 0)
 		return err;
 
-	if (copy_to_user(buf, lbuf, err))
-		return -EFAULT;
-
-	*pos += err;
-
-	return err;
+	return simple_read_from_buffer(buf, count, pos, lbuf, err);
 }
 
 static const struct file_operations limit_fops = {
-- 
2.18.0.399.gad0ab374a1-goog
