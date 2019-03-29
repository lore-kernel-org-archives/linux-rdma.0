From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 04/14] net/mlx5: Split mdev init and pci init
Date: Fri, 29 Mar 2019 15:37:54 -0700
Message-ID: <20190329223804.8954-5-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Vu Pham <vuhuong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Separate resources initialization from pci initialization.

This provides a better logical separation of mlx5 core device
initialization flow and will help to seamlessly support creating different
mlx5 device types such as PF, VF and SF mlx5 sub-function virtual device.

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 95 +++++++++++--------
 1 file changed, 54 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index de406138b188..5c96f1136c0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -736,32 +736,23 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 	return -EOPNOTSUPP;
 }
 
-static int mlx5_pci_init(struct mlx5_core_dev *dev)
+static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
+			 const struct pci_device_id *id)
 {
 	struct mlx5_priv *priv = &dev->priv;
-	struct pci_dev *pdev = dev->pdev;
 	int err = 0;
 
-	pci_set_drvdata(dev->pdev, dev);
-	strncpy(priv->name, dev_name(&pdev->dev), MLX5_MAX_NAME_LEN);
-	priv->name[MLX5_MAX_NAME_LEN - 1] = 0;
-
-	mutex_init(&priv->pgdir_mutex);
-	INIT_LIST_HEAD(&priv->pgdir_list);
-	spin_lock_init(&priv->mkey_lock);
+	dev->pdev = pdev;
+	priv->pci_dev_data = id->driver_data;
 
-	mutex_init(&priv->alloc_mutex);
+	pci_set_drvdata(dev->pdev, dev);
 
 	priv->numa_node = dev_to_node(&dev->pdev->dev);
 
-	if (mlx5_debugfs_root)
-		priv->dbg_root =
-			debugfs_create_dir(pci_name(pdev), mlx5_debugfs_root);
-
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot enable PCI device, aborting\n");
-		goto err_dbg;
+		return err;
 	}
 
 	err = request_bar(pdev);
@@ -798,9 +789,6 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev)
 	release_bar(dev->pdev);
 err_disable:
 	mlx5_pci_disable_device(dev);
-
-err_dbg:
-	debugfs_remove(priv->dbg_root);
 	return err;
 }
 
@@ -810,7 +798,6 @@ static void mlx5_pci_close(struct mlx5_core_dev *dev)
 	pci_clear_master(dev->pdev);
 	release_bar(dev->pdev);
 	mlx5_pci_disable_device(dev);
-	debugfs_remove_recursive(dev->priv.dbg_root);
 }
 
 static int mlx5_init_once(struct mlx5_core_dev *dev)
@@ -1237,13 +1224,49 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #endif
 };
 
+static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx, const char *name)
+{
+	struct mlx5_priv *priv = &dev->priv;
+
+	strncpy(priv->name, name, MLX5_MAX_NAME_LEN);
+	priv->name[MLX5_MAX_NAME_LEN - 1] = 0;
+
+	dev->profile = &profile[profile_idx];
+
+	INIT_LIST_HEAD(&priv->ctx_list);
+	spin_lock_init(&priv->ctx_lock);
+	mutex_init(&dev->pci_status_mutex);
+	mutex_init(&dev->intf_state_mutex);
+
+	mutex_init(&priv->bfregs.reg_head.lock);
+	mutex_init(&priv->bfregs.wc_head.lock);
+	INIT_LIST_HEAD(&priv->bfregs.reg_head.list);
+	INIT_LIST_HEAD(&priv->bfregs.wc_head.list);
+
+	mutex_init(&priv->alloc_mutex);
+	mutex_init(&priv->pgdir_mutex);
+	INIT_LIST_HEAD(&priv->pgdir_list);
+	spin_lock_init(&priv->mkey_lock);
+
+	priv->dbg_root = debugfs_create_dir(name, mlx5_debugfs_root);
+	if (!priv->dbg_root) {
+		pr_err("mlx5_core: %s error, Cannot create debugfs dir, aborting\n", name);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
+{
+	debugfs_remove_recursive(dev->priv.dbg_root);
+}
+
 #define MLX5_IB_MOD "mlx5_ib"
-static int init_one(struct pci_dev *pdev,
-		    const struct pci_device_id *id)
+static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct mlx5_core_dev *dev;
 	struct devlink *devlink;
-	struct mlx5_priv *priv;
 	int err;
 
 	devlink = devlink_alloc(&mlx5_devlink_ops, sizeof(*dev));
@@ -1253,28 +1276,15 @@ static int init_one(struct pci_dev *pdev,
 	}
 
 	dev = devlink_priv(devlink);
-	priv = &dev->priv;
-	priv->pci_dev_data = id->driver_data;
-
-	pci_set_drvdata(pdev, dev);
-
-	dev->pdev = pdev;
-	dev->profile = &profile[prof_sel];
 
-	INIT_LIST_HEAD(&priv->ctx_list);
-	spin_lock_init(&priv->ctx_lock);
-	mutex_init(&dev->pci_status_mutex);
-	mutex_init(&dev->intf_state_mutex);
-
-	mutex_init(&priv->bfregs.reg_head.lock);
-	mutex_init(&priv->bfregs.wc_head.lock);
-	INIT_LIST_HEAD(&priv->bfregs.reg_head.list);
-	INIT_LIST_HEAD(&priv->bfregs.wc_head.list);
+	err = mlx5_mdev_init(dev, prof_sel, dev_name(&pdev->dev));
+	if (err)
+		goto mdev_init_err;
 
-	err = mlx5_pci_init(dev);
+	err = mlx5_pci_init(dev, pdev, id);
 	if (err) {
 		dev_err(&pdev->dev, "mlx5_pci_init failed with error code %d\n", err);
-		goto clean_dev;
+		goto pci_init_err;
 	}
 
 	err = mlx5_health_init(dev);
@@ -1310,7 +1320,9 @@ static int init_one(struct pci_dev *pdev,
 	mlx5_health_cleanup(dev);
 close_pci:
 	mlx5_pci_close(dev);
-clean_dev:
+pci_init_err:
+	mlx5_mdev_uninit(dev);
+mdev_init_err:
 	devlink_free(devlink);
 
 	return err;
@@ -1333,6 +1345,7 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
 	mlx5_pci_close(dev);
+	mlx5_mdev_uninit(dev);
 	devlink_free(devlink);
 }
 
-- 
2.20.1
