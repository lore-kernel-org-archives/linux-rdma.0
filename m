From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] mlx5_core: return -EFAULT if copy_to_user() fails
Date: Wed, 10 Jul 2013 13:57:14 +0300
Message-ID: <20130710105714.GC31232@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Eli Cohen <eli@mellanox.com>
Cc: linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This should return an error code instead of the number of bytes
remaining to be copied.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index a550a8e..4273c06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -148,7 +148,6 @@ static ssize_t average_read(struct file *filp, char __user *buf, size_t count,
 	struct mlx5_cmd_stats *stats;
 	u64 field = 0;
 	int ret;
-	int err;
 	char tbuf[22];
 
 	if (*pos)
@@ -161,9 +160,8 @@ static ssize_t average_read(struct file *filp, char __user *buf, size_t count,
 	spin_unlock(&stats->lock);
 	ret = snprintf(tbuf, sizeof(tbuf), "%llu\n", field);
 	if (ret > 0) {
-		err = copy_to_user(buf, tbuf, ret);
-		if (err)
-			return err;
+		if (copy_to_user(buf, tbuf, ret))
+			return -EFAULT;
 	}
 
 	*pos += ret;
@@ -418,7 +416,6 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 	char tbuf[18];
 	u64 field;
 	int ret;
-	int err;
 
 	if (*pos)
 		return 0;
@@ -445,9 +442,8 @@ static ssize_t dbg_read(struct file *filp, char __user *buf, size_t count,
 
 	ret = snprintf(tbuf, sizeof(tbuf), "0x%llx\n", field);
 	if (ret > 0) {
-		err = copy_to_user(buf, tbuf, ret);
-		if (err)
-			return err;
+		if (copy_to_user(buf, tbuf, ret))
+			return -EFAULT;
 	}
 
 	*pos += ret;
