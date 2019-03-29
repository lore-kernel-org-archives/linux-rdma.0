From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/14] net/mlx5: Remove redundant init functions parameter
Date: Fri, 29 Mar 2019 15:37:53 -0700
Message-ID: <20190329223804.8954-4-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Vu Pham <vuhuong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 49 +++++++++----------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 70cc906a102b..de406138b188 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -736,8 +736,9 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 	return -EOPNOTSUPP;
 }
 
-static int mlx5_pci_init(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
+static int mlx5_pci_init(struct mlx5_core_dev *dev)
 {
+	struct mlx5_priv *priv = &dev->priv;
 	struct pci_dev *pdev = dev->pdev;
 	int err = 0;
 
@@ -803,24 +804,24 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 	return err;
 }
 
-static void mlx5_pci_close(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
+static void mlx5_pci_close(struct mlx5_core_dev *dev)
 {
 	iounmap(dev->iseg);
 	pci_clear_master(dev->pdev);
 	release_bar(dev->pdev);
 	mlx5_pci_disable_device(dev);
-	debugfs_remove_recursive(priv->dbg_root);
+	debugfs_remove_recursive(dev->priv.dbg_root);
 }
 
-static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
+static int mlx5_init_once(struct mlx5_core_dev *dev)
 {
 	struct pci_dev *pdev = dev->pdev;
 	int err;
 
-	priv->devcom = mlx5_devcom_register_device(dev);
-	if (IS_ERR(priv->devcom))
+	dev->priv.devcom = mlx5_devcom_register_device(dev);
+	if (IS_ERR(dev->priv.devcom))
 		dev_err(&pdev->dev, "failed to register with devcom (0x%p)\n",
-			priv->devcom);
+			dev->priv.devcom);
 
 	err = mlx5_query_board_id(dev);
 	if (err) {
@@ -932,8 +933,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_devcom_unregister_device(dev->priv.devcom);
 }
 
-static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
-			 bool boot)
+static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 {
 	struct pci_dev *pdev = dev->pdev;
 	int err;
@@ -1033,7 +1033,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	}
 
 	if (boot) {
-		err = mlx5_init_once(dev, priv);
+		err = mlx5_init_once(dev);
 		if (err) {
 			dev_err(&pdev->dev, "sw objs init failed\n");
 			goto err_stop_poll;
@@ -1147,7 +1147,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 err_eq_table:
 	mlx5_pagealloc_stop(dev);
 	mlx5_events_stop(dev);
-	mlx5_put_uars_page(dev, priv->uar);
+	mlx5_put_uars_page(dev, dev->priv.uar);
 
 err_get_uars:
 	if (boot)
@@ -1176,8 +1176,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	return err;
 }
 
-static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
-			   bool cleanup)
+static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
 	int err = 0;
 
@@ -1208,7 +1207,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_eq_table_destroy(dev);
 	mlx5_pagealloc_stop(dev);
 	mlx5_events_stop(dev);
-	mlx5_put_uars_page(dev, priv->uar);
+	mlx5_put_uars_page(dev, dev->priv.uar);
 	if (cleanup)
 		mlx5_cleanup_once(dev);
 	mlx5_stop_health_poll(dev, cleanup);
@@ -1272,7 +1271,7 @@ static int init_one(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&priv->bfregs.reg_head.list);
 	INIT_LIST_HEAD(&priv->bfregs.wc_head.list);
 
-	err = mlx5_pci_init(dev, priv);
+	err = mlx5_pci_init(dev);
 	if (err) {
 		dev_err(&pdev->dev, "mlx5_pci_init failed with error code %d\n", err);
 		goto clean_dev;
@@ -1288,7 +1287,7 @@ static int init_one(struct pci_dev *pdev,
 	if (err)
 		goto err_pagealloc_init;
 
-	err = mlx5_load_one(dev, priv, true);
+	err = mlx5_load_one(dev, true);
 	if (err) {
 		dev_err(&pdev->dev, "mlx5_load_one failed with error code %d\n", err);
 		goto err_load_one;
@@ -1304,13 +1303,13 @@ static int init_one(struct pci_dev *pdev,
 	return 0;
 
 clean_load:
-	mlx5_unload_one(dev, priv, true);
+	mlx5_unload_one(dev, true);
 err_load_one:
 	mlx5_pagealloc_cleanup(dev);
 err_pagealloc_init:
 	mlx5_health_cleanup(dev);
 close_pci:
-	mlx5_pci_close(dev, priv);
+	mlx5_pci_close(dev);
 clean_dev:
 	devlink_free(devlink);
 
@@ -1321,12 +1320,11 @@ static void remove_one(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
-	struct mlx5_priv *priv = &dev->priv;
 
 	devlink_unregister(devlink);
 	mlx5_unregister_device(dev);
 
-	if (mlx5_unload_one(dev, priv, true)) {
+	if (mlx5_unload_one(dev, true)) {
 		dev_err(&dev->pdev->dev, "mlx5_unload_one failed\n");
 		mlx5_health_cleanup(dev);
 		return;
@@ -1334,7 +1332,7 @@ static void remove_one(struct pci_dev *pdev)
 
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
-	mlx5_pci_close(dev, priv);
+	mlx5_pci_close(dev);
 	devlink_free(devlink);
 }
 
@@ -1342,12 +1340,11 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 					      pci_channel_state_t state)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
-	struct mlx5_priv *priv = &dev->priv;
 
 	dev_info(&pdev->dev, "%s was called\n", __func__);
 
 	mlx5_enter_error_state(dev, false);
-	mlx5_unload_one(dev, priv, false);
+	mlx5_unload_one(dev, false);
 	/* In case of kernel call drain the health wq */
 	if (state) {
 		mlx5_drain_health_wq(dev);
@@ -1414,12 +1411,11 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 static void mlx5_pci_resume(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
-	struct mlx5_priv *priv = &dev->priv;
 	int err;
 
 	dev_info(&pdev->dev, "%s was called\n", __func__);
 
-	err = mlx5_load_one(dev, priv, false);
+	err = mlx5_load_one(dev, false);
 	if (err)
 		dev_err(&pdev->dev, "%s: mlx5_load_one failed with error code: %d\n"
 			, __func__, err);
@@ -1486,13 +1482,12 @@ static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 static void shutdown(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
-	struct mlx5_priv *priv = &dev->priv;
 	int err;
 
 	dev_info(&pdev->dev, "Shutdown was called\n");
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-		mlx5_unload_one(dev, priv, false);
+		mlx5_unload_one(dev, false);
 	mlx5_pci_disable_device(dev);
 }
 
-- 
2.20.1
