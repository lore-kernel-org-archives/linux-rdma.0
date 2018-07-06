From: Jann Horn <jannh@google.com>
Subject: [PATCH net v2] net/mlx5: fix uaccess beyond "count" in debugfs
 read/write handlers
Date: Fri,  6 Jul 2018 22:18:09 +0200
Message-ID: <20180706201809.105152-1-jannh@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, jannh@google.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

In general, accessing userspace memory beyond the length of the supplied
buffer in VFS read/write handlers can lead to both kernel memory corruption
(via kernel_read()/kernel_write(), which can e.g. be triggered via
sys_splice()) and privilege escalation inside userspace.

In this case, the affected files are in debugfs (and should therefore only
be accessible to root) and check that *pos is zero (which prevents the
sys_splice() trick). Therefore, this is not a security fix, but rather a
small cleanup.

For the read handlers, fix it by using simple_read_from_buffer() instead of
custom logic.
For the write handler, add a check.

changed in v2:
 - also fix dbg_write()

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Jann Horn <jannh@google.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 28 +++++--------------
 .../net/ethernet/mellanox/mlx5/core/debugfs.c | 22 ++-------------
 2 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 384c1fa49081..92578074145d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1022,7 +1022,10 @@ static ssize_t dbg_write(struct file *filp, const char __user *buf,
 	if (!dbg->in_msg || !dbg->out_msg)
 		return -ENOMEM;
 
-	if (copy_from_user(lbuf, buf, sizeof(lbuf)))
+	if (count < sizeof(lbuf) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(lbuf, buf, sizeof(lbuf) - 1))
 		return -EFAULT;
 
 	lbuf[sizeof(lbuf) - 1] = 0;
@@ -1226,21 +1229,12 @@ static ssize_t data_read(struct file *filp, char __user *buf, size_t count,
 {
 	struct mlx5_core_dev *dev = filp->private_data;
 	struct mlx5_cmd_debug *dbg = &dev->cmd.dbg;
-	int copy;
-
-	if (*pos)
-		return 0;
 
 	if (!dbg->out_msg)
 		return -ENOMEM;
 
-	copy = min_t(int, count, dbg->outlen);
-	if (copy_to_user(buf, dbg->out_msg, copy))
-		return -EFAULT;
-
-	*pos += copy;
-
-	return copy;
+	return simple_read_from_buffer(buf, count, pos, dbg->out_msg,
+				       dbg->outlen);
 }
 
 static const struct file_operations dfops = {
@@ -1258,19 +1252,11 @@ static ssize_t outlen_read(struct file *filp, char __user *buf, size_t count,
 	char outlen[8];
 	int err;
 
-	if (*pos)
-		return 0;
-
 	err = snprintf(outlen, sizeof(outlen), "%d", dbg->outlen);
 	if (err < 0)
 		return err;
 
-	if (copy_to_user(buf, &outlen, err))
-		return -EFAULT;
-
-	*pos += err;
-
-	return err;
+	return simple_read_from_buffer(buf, count, pos, outlen, err);
 }
 
 static ssize_t outlen_write(struct file *filp, const char __user *buf,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 413080a312a7..90fabd612b6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -150,22 +150,13 @@ static ssize_t average_read(struct file *filp, char __user *buf, size_t count,
 	int ret;
 	char tbuf[22];
 
-	if (*pos)
-		return 0;
-
 	stats = filp->private_data;
 	spin_lock_irq(&stats->lock);
 	if (stats->n)
 		field = div64_u64(stats->sum, stats->n);
 	spin_unlock_irq(&stats->lock);
 	ret = snprintf(tbuf, sizeof(tbuf), "%llu\n", field);
-	if (ret > 0) {
-		if (copy_to_user(buf, tbuf, ret))
-			return -EFAULT;
-	}
-
-	*pos += ret;
-	return ret;
+	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
 }
 
 static ssize_t average_write(struct file *filp, const char __user *buf,
@@ -442,9 +433,6 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 	u64 field;
 	int ret;
 
-	if (*pos)
-		return 0;
-
 	desc = filp->private_data;
 	d = (void *)(desc - desc->i) - sizeof(*d);
 	switch (d->type) {
@@ -470,13 +458,7 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 	else
 		ret = snprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
 
-	if (ret > 0) {
-		if (copy_to_user(buf, tbuf, ret))
-			return -EFAULT;
-	}
-
-	*pos += ret;
-	return ret;
+	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
 }
 
 static const struct file_operations fops = {
-- 
2.18.0.203.gfac676dfb9-goog
