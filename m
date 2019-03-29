From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/14] net/mlx5: Move health and page alloc init to mdev_init
Date: Fri, 29 Mar 2019 15:37:55 -0700
Message-ID: <20190329223804.8954-6-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Vu Pham <vuhuong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Software structure initialization should be in mdev_init stage.

This provides a better logical separation of mlx5 core device
initialization flow and will help to seamlessly support creating different
mlx5 device types such as PF, VF and SF mlx5 sub-function virtual device.

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  |  7 ++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 37 ++++++++++---------
 include/linux/mlx5/driver.h                   |  1 +
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index cb9fa3430c53..b0e3f809e886 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -352,6 +352,13 @@ void mlx5_drain_health_recovery(struct mlx5_core_dev *dev)
 	cancel_delayed_work_sync(&dev->priv.health.recover_work);
 }
 
+void mlx5_health_flush(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	flush_workqueue(health->wq);
+}
+
 void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5c96f1136c0a..131a00688438 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1227,6 +1227,7 @@ static const struct devlink_ops mlx5_devlink_ops = {
 static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx, const char *name)
 {
 	struct mlx5_priv *priv = &dev->priv;
+	int err;
 
 	strncpy(priv->name, name, MLX5_MAX_NAME_LEN);
 	priv->name[MLX5_MAX_NAME_LEN - 1] = 0;
@@ -1254,11 +1255,28 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx, const char
 		return -ENOMEM;
 	}
 
+	err = mlx5_health_init(dev);
+	if (err)
+		goto err_health_init;
+
+	err = mlx5_pagealloc_init(dev);
+	if (err)
+		goto err_pagealloc_init;
+
 	return 0;
+
+err_pagealloc_init:
+	mlx5_health_cleanup(dev);
+err_health_init:
+	debugfs_remove(dev->priv.dbg_root);
+
+	return err;
 }
 
 static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
+	mlx5_pagealloc_cleanup(dev);
+	mlx5_health_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg_root);
 }
 
@@ -1287,16 +1305,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto pci_init_err;
 	}
 
-	err = mlx5_health_init(dev);
-	if (err) {
-		dev_err(&pdev->dev, "mlx5_health_init failed with error code %d\n", err);
-		goto close_pci;
-	}
-
-	err = mlx5_pagealloc_init(dev);
-	if (err)
-		goto err_pagealloc_init;
-
 	err = mlx5_load_one(dev, true);
 	if (err) {
 		dev_err(&pdev->dev, "mlx5_load_one failed with error code %d\n", err);
@@ -1314,11 +1322,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 clean_load:
 	mlx5_unload_one(dev, true);
+
 err_load_one:
-	mlx5_pagealloc_cleanup(dev);
-err_pagealloc_init:
-	mlx5_health_cleanup(dev);
-close_pci:
 	mlx5_pci_close(dev);
 pci_init_err:
 	mlx5_mdev_uninit(dev);
@@ -1338,12 +1343,10 @@ static void remove_one(struct pci_dev *pdev)
 
 	if (mlx5_unload_one(dev, true)) {
 		dev_err(&dev->pdev->dev, "mlx5_unload_one failed\n");
-		mlx5_health_cleanup(dev);
+		mlx5_health_flush(dev);
 		return;
 	}
 
-	mlx5_pagealloc_cleanup(dev);
-	mlx5_health_cleanup(dev);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
 	devlink_free(devlink);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 022541dc5dbf..302d65dfa17c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -885,6 +885,7 @@ void mlx5_cmd_mbox_status(void *out, u8 *status, u32 *syndrome);
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
 int mlx5_cmd_alloc_uar(struct mlx5_core_dev *dev, u32 *uarn);
 int mlx5_cmd_free_uar(struct mlx5_core_dev *dev, u32 uarn);
+void mlx5_health_flush(struct mlx5_core_dev *dev);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
-- 
2.20.1
