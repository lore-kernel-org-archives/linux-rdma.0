From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/5] IB/mlx5: Add delay drop configuration and statistics
Date: Tue, 30 May 2017 10:29:14 +0300
Message-ID: <20170530072914.9709-6-leon@kernel.org>
References: <20170530072914.9709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530072914.9709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add debugfs interface for monitor the number of delay drop timeout
events and the number of existing dropless RQs in the system.

In addition add debugfs interface for configuring the global timeout value
which is used in the SET_DELAY_DROP command.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 103 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  10 ++++
 drivers/infiniband/hw/mlx5/qp.c      |  13 ++++-
 3 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e76891a2a3b9..bf7ae5aa6c82 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */

+#include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -2709,6 +2710,8 @@ static void delay_drop_handler(struct work_struct *work)
 		container_of(work, struct mlx5_ib_delay_drop,
 			     delay_drop_work);

+	atomic_inc(&delay_drop->events_cnt);
+
 	mutex_lock(&delay_drop->lock);
 	err = mlx5_core_set_delay_drop(delay_drop->dev->mdev,
 				       delay_drop->timeout);
@@ -3577,12 +3580,107 @@ static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
 	return mlx5_rdma_netdev_free(netdev);
 }

+static void delay_drop_debugfs_cleanup(struct mlx5_ib_dev *dev)
+{
+	if (!dev->delay_drop.dbg)
+		return;
+	debugfs_remove_recursive(dev->delay_drop.dbg->dir_debugfs);
+	kfree(dev->delay_drop.dbg);
+	dev->delay_drop.dbg = NULL;
+}
+
 static void cancel_delay_drop(struct mlx5_ib_dev *dev)
 {
 	if (!(dev->ib_dev.attrs.raw_packet_caps & IB_RAW_PACKET_CAP_DELAY_DROP))
 		return;

 	cancel_work_sync(&dev->delay_drop.delay_drop_work);
+	delay_drop_debugfs_cleanup(dev);
+}
+
+static ssize_t delay_drop_timeout_read(struct file *filp, char __user *buf,
+				       size_t count, loff_t *pos)
+{
+	struct mlx5_ib_delay_drop *delay_drop = filp->private_data;
+	char lbuf[20];
+	int len;
+
+	len = snprintf(lbuf, sizeof(lbuf), "%u\n", delay_drop->timeout);
+	return simple_read_from_buffer(buf, count, pos, lbuf, len);
+}
+
+static ssize_t delay_drop_timeout_write(struct file *filp, const char __user *buf,
+					size_t count, loff_t *pos)
+{
+	struct mlx5_ib_delay_drop *delay_drop = filp->private_data;
+	u32 timeout;
+	u32 var;
+
+	if (kstrtouint_from_user(buf, count, 0, &var))
+		return -EFAULT;
+
+	timeout = min_t(u32, roundup(var, 100), MLX5_MAX_DELAY_DROP_TIMEOUT_MS *
+			1000);
+	if (timeout != var)
+		mlx5_ib_dbg(delay_drop->dev, "Round delay drop timeout to %u usec\n",
+			    timeout);
+
+	delay_drop->timeout = timeout;
+
+	return count;
+}
+
+static const struct file_operations fops_delay_drop_timeout = {
+	.owner	= THIS_MODULE,
+	.open	= simple_open,
+	.write	= delay_drop_timeout_write,
+	.read	= delay_drop_timeout_read,
+};
+
+static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_ib_dbg_delay_drop *dbg;
+
+	if (!mlx5_debugfs_root)
+		return 0;
+
+	dbg = kzalloc(sizeof(*dbg), GFP_KERNEL);
+	if (!dbg)
+		return -ENOMEM;
+
+	dbg->dir_debugfs =
+		debugfs_create_dir("delay_drop",
+				   dev->mdev->priv.dbg_root);
+	if (!dbg->dir_debugfs)
+		return -ENOMEM;
+
+	dbg->events_cnt_debugfs =
+		debugfs_create_atomic_t("num_timeout_events", 0400,
+					dbg->dir_debugfs,
+					&dev->delay_drop.events_cnt);
+	if (!dbg->events_cnt_debugfs)
+		goto out_debugfs;
+
+	dbg->rqs_cnt_debugfs =
+		debugfs_create_atomic_t("num_rqs", 0400,
+					dbg->dir_debugfs,
+					&dev->delay_drop.rqs_cnt);
+	if (!dbg->rqs_cnt_debugfs)
+		goto out_debugfs;
+
+	dbg->timeout_debugfs =
+		debugfs_create_file("timeout", 0600,
+				    dbg->dir_debugfs,
+				    &dev->delay_drop,
+				    &fops_delay_drop_timeout);
+	if (!dbg->timeout_debugfs)
+		goto out_debugfs;
+
+	return 0;
+
+out_debugfs:
+	delay_drop_debugfs_cleanup(dev);
+	return -ENOMEM;
 }

 static void init_delay_drop(struct mlx5_ib_dev *dev)
@@ -3595,6 +3693,11 @@ static void init_delay_drop(struct mlx5_ib_dev *dev)
 	dev->delay_drop.activate = false;
 	dev->delay_drop.timeout = MLX5_MAX_DELAY_DROP_TIMEOUT_MS * 1000;
 	INIT_WORK(&dev->delay_drop.delay_drop_work, delay_drop_handler);
+	atomic_set(&dev->delay_drop.rqs_cnt, 0);
+	atomic_set(&dev->delay_drop.events_cnt, 0);
+
+	if (delay_drop_debugfs_init(dev))
+		mlx5_ib_warn(dev, "Failed to init delay drop debugfs\n");
 }

 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dd44624de56a..14e4398e7a6a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -627,6 +627,13 @@ enum {
 	MLX5_MAX_DELAY_DROP_TIMEOUT_MS = 100,
 };

+struct mlx5_ib_dbg_delay_drop {
+	struct dentry		*dir_debugfs;
+	struct dentry		*rqs_cnt_debugfs;
+	struct dentry		*events_cnt_debugfs;
+	struct dentry		*timeout_debugfs;
+};
+
 struct mlx5_ib_delay_drop {
 	struct mlx5_ib_dev     *dev;
 	struct work_struct	delay_drop_work;
@@ -634,6 +641,9 @@ struct mlx5_ib_delay_drop {
 	struct mutex		lock;
 	u32			timeout;
 	bool			activate;
+	atomic_t		events_cnt;
+	atomic_t		rqs_cnt;
+	struct mlx5_ib_dbg_delay_drop *dbg;
 };

 struct mlx5_ib_dev {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index fe519487461e..75b87d72df7b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -675,10 +675,14 @@ static int mlx5_ib_umem_get(struct mlx5_ib_dev *dev,
 	return err;
 }

-static void destroy_user_rq(struct ib_pd *pd, struct mlx5_ib_rwq *rwq)
+static void destroy_user_rq(struct mlx5_ib_dev *dev, struct ib_pd *pd,
+			    struct mlx5_ib_rwq *rwq)
 {
 	struct mlx5_ib_ucontext *context;

+	if (rwq->create_flags & MLX5_IB_WQ_FLAGS_DELAY_DROP)
+		atomic_dec(&dev->delay_drop.rqs_cnt);
+
 	context = to_mucontext(pd->uobject->context);
 	mlx5_ib_db_unmap_user(context, &rwq->db);
 	if (rwq->umem)
@@ -4625,6 +4629,9 @@ static int set_delay_drop(struct mlx5_ib_dev *dev)
 	dev->delay_drop.activate = true;
 out:
 	mutex_unlock(&dev->delay_drop.lock);
+
+	if (!err)
+		atomic_inc(&dev->delay_drop.rqs_cnt);
 	return err;
 }

@@ -4837,7 +4844,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 err_copy:
 	mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
 err_user_rq:
-	destroy_user_rq(pd, rwq);
+	destroy_user_rq(dev, pd, rwq);
 err:
 	kfree(rwq);
 	return ERR_PTR(err);
@@ -4849,7 +4856,7 @@ int mlx5_ib_destroy_wq(struct ib_wq *wq)
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);

 	mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
-	destroy_user_rq(wq->pd, rwq);
+	destroy_user_rq(dev, wq->pd, rwq);
 	kfree(rwq);

 	return 0;
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
