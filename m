From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/14] net/mlx5: Function setup/teardown procedures
Date: Fri, 29 Mar 2019 15:37:56 -0700
Message-ID: <20190329223804.8954-7-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Vu Pham <vuhuong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Function setup and teardown procedures are the basic procedure that
each mlx5 pci function should perform to boot up a mlx5 device function
and initialize basic communication with FW, before allocating any higher
level software/firmware resources.

This provides a better logical separation of mlx5 core device
initialization flow and will help to seamlessly support creating different
mlx5 device types such as PF, VF and SF mlx5 sub-function virtual device.

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 120 ++++++++++--------
 1 file changed, 68 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 131a00688438..d5a8ec8f587d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -920,44 +920,24 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_devcom_unregister_device(dev->priv.devcom);
 }
 
-static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 {
 	struct pci_dev *pdev = dev->pdev;
 	int err;
 
-	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
-	mutex_lock(&dev->intf_state_mutex);
-	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-		dev_warn(&dev->pdev->dev, "%s: interface is up, NOP\n",
-			 __func__);
-		goto out;
-	}
-
-	dev_info(&pdev->dev, "firmware version: %d.%d.%d\n", fw_rev_maj(dev),
-		 fw_rev_min(dev), fw_rev_sub(dev));
-
-	/* Only PFs hold the relevant PCIe information for this query */
-	if (mlx5_core_is_pf(dev))
-		pcie_print_link_status(dev->pdev);
-
-	/* on load removing any previous indication of internal error, device is
-	 * up
-	 */
-	dev->state = MLX5_DEVICE_STATE_UP;
-
 	/* wait for firmware to accept initialization segments configurations
 	 */
 	err = wait_fw_init(dev, FW_PRE_INIT_TIMEOUT_MILI);
 	if (err) {
 		dev_err(&dev->pdev->dev, "Firmware over %d MS in pre-initializing state, aborting\n",
 			FW_PRE_INIT_TIMEOUT_MILI);
-		goto out_err;
+		return err;
 	}
 
 	err = mlx5_cmd_init(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed initializing command interface, aborting\n");
-		goto out_err;
+		return err;
 	}
 
 	err = wait_fw_init(dev, FW_INIT_TIMEOUT_MILI);
@@ -1016,14 +996,74 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	err = mlx5_query_hca_caps(dev);
 	if (err) {
 		dev_err(&pdev->dev, "query hca failed\n");
-		goto err_stop_poll;
+		goto stop_health;
+	}
+
+	return 0;
+
+stop_health:
+	mlx5_stop_health_poll(dev, boot);
+reclaim_boot_pages:
+	mlx5_reclaim_startup_pages(dev);
+err_disable_hca:
+	mlx5_core_disable_hca(dev, 0);
+err_cmd_cleanup:
+	mlx5_cmd_cleanup(dev);
+
+	return err;
+}
+
+static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
+{
+	int err;
+
+	mlx5_stop_health_poll(dev, boot);
+	err = mlx5_cmd_teardown_hca(dev);
+	if (err) {
+		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
+		return err;
+	}
+	mlx5_reclaim_startup_pages(dev);
+	mlx5_core_disable_hca(dev, 0);
+	mlx5_cmd_cleanup(dev);
+
+	return 0;
+}
+
+static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+{
+	struct pci_dev *pdev = dev->pdev;
+	int err;
+
+	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
+	mutex_lock(&dev->intf_state_mutex);
+	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
+		dev_warn(&dev->pdev->dev, "%s: interface is up, NOP\n",
+			 __func__);
+		goto out;
 	}
 
+	dev_info(&pdev->dev, "firmware version: %d.%d.%d\n", fw_rev_maj(dev),
+		 fw_rev_min(dev), fw_rev_sub(dev));
+
+	/* Only PFs hold the relevant PCIe information for this query */
+	if (mlx5_core_is_pf(dev))
+		pcie_print_link_status(dev->pdev);
+
+	/* on load removing any previous indication of internal error, device is
+	 * up
+	 */
+	dev->state = MLX5_DEVICE_STATE_UP;
+
+	err = mlx5_function_setup(dev, boot);
+	if (err)
+		goto out;
+
 	if (boot) {
 		err = mlx5_init_once(dev);
 		if (err) {
 			dev_err(&pdev->dev, "sw objs init failed\n");
-			goto err_stop_poll;
+			goto function_teardown;
 		}
 	}
 
@@ -1140,23 +1180,8 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	if (boot)
 		mlx5_cleanup_once(dev);
 
-err_stop_poll:
-	mlx5_stop_health_poll(dev, boot);
-	if (mlx5_cmd_teardown_hca(dev)) {
-		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
-		goto out_err;
-	}
-
-reclaim_boot_pages:
-	mlx5_reclaim_startup_pages(dev);
-
-err_disable_hca:
-	mlx5_core_disable_hca(dev, 0);
-
-err_cmd_cleanup:
-	mlx5_cmd_cleanup(dev);
-
-out_err:
+function_teardown:
+	mlx5_function_teardown(dev, boot);
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
 
@@ -1197,17 +1222,8 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 	if (cleanup)
 		mlx5_cleanup_once(dev);
-	mlx5_stop_health_poll(dev, cleanup);
-
-	err = mlx5_cmd_teardown_hca(dev);
-	if (err) {
-		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
-		goto out;
-	}
-	mlx5_reclaim_startup_pages(dev);
-	mlx5_core_disable_hca(dev, 0);
-	mlx5_cmd_cleanup(dev);
 
+	mlx5_function_teardown(dev, cleanup);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
 	return err;
-- 
2.20.1
