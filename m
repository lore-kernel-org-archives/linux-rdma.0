From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/14] net/mlx5: Break load_one into three stages
Date: Fri, 29 Mar 2019 15:37:57 -0700
Message-ID: <20190329223804.8954-8-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Vu Pham <vuhuong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Using foundation from previous patches to factor mlx5_load_one flow
into three stages:
1. mlx5_function_setup() from previous patch to setup function
2. mlx5_init_once() from previous patch to init software objects
according to hw caps
3. New mlx5_load() to load mlx5 components

This provides a better logical separation of mlx5 core device
initialization flow and will help to seamlessly support creating different
mlx5 device types such as PF, VF and SF mlx5 sub-function virtual device.

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 148 +++++++++---------
 1 file changed, 77 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d5a8ec8f587d..bdfc0429ee6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -925,6 +925,13 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 	struct pci_dev *pdev = dev->pdev;
 	int err;
 
+	dev_info(&pdev->dev, "firmware version: %d.%d.%d\n", fw_rev_maj(dev),
+		 fw_rev_min(dev), fw_rev_sub(dev));
+
+	/* Only PFs hold the relevant PCIe information for this query */
+	if (mlx5_core_is_pf(dev))
+		pcie_print_link_status(dev->pdev);
+
 	/* wait for firmware to accept initialization segments configurations
 	 */
 	err = wait_fw_init(dev, FW_PRE_INIT_TIMEOUT_MILI);
@@ -1030,48 +1037,16 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	return 0;
 }
 
-static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_load(struct mlx5_core_dev *dev)
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
-	err = mlx5_function_setup(dev, boot);
-	if (err)
-		goto out;
-
-	if (boot) {
-		err = mlx5_init_once(dev);
-		if (err) {
-			dev_err(&pdev->dev, "sw objs init failed\n");
-			goto function_teardown;
-		}
-	}
-
 	dev->priv.uar = mlx5_get_uars_page(dev);
 	if (IS_ERR(dev->priv.uar)) {
 		dev_err(&pdev->dev, "Failed allocating uar, aborting\n");
 		err = PTR_ERR(dev->priv.uar);
-		goto err_get_uars;
+		return err;
 	}
 
 	mlx5_events_start(dev);
@@ -1131,55 +1106,95 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 		goto err_ec;
 	}
 
-	if (mlx5_device_registered(dev)) {
-		mlx5_attach_device(dev);
-	} else {
-		err = mlx5_register_device(dev);
-		if (err) {
-			dev_err(&pdev->dev, "mlx5_register_device failed %d\n", err);
-			goto err_reg_dev;
-		}
-	}
-
-	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
-out:
-	mutex_unlock(&dev->intf_state_mutex);
-
 	return 0;
 
-err_reg_dev:
-	mlx5_ec_cleanup(dev);
-
 err_ec:
 	mlx5_sriov_detach(dev);
-
 err_sriov:
 	mlx5_cleanup_fs(dev);
-
 err_fs:
 	mlx5_accel_tls_cleanup(dev);
-
 err_tls_start:
 	mlx5_accel_ipsec_cleanup(dev);
-
 err_ipsec_start:
 	mlx5_fpga_device_stop(dev);
-
 err_fpga_start:
 	mlx5_fw_tracer_cleanup(dev->tracer);
-
 err_fw_tracer:
 	mlx5_eq_table_destroy(dev);
-
 err_eq_table:
 	mlx5_pagealloc_stop(dev);
 	mlx5_events_stop(dev);
 	mlx5_put_uars_page(dev, dev->priv.uar);
+	return err;
+}
+
+static void mlx5_unload(struct mlx5_core_dev *dev)
+{
+	mlx5_ec_cleanup(dev);
+	mlx5_sriov_detach(dev);
+	mlx5_cleanup_fs(dev);
+	mlx5_accel_ipsec_cleanup(dev);
+	mlx5_accel_tls_cleanup(dev);
+	mlx5_fpga_device_stop(dev);
+	mlx5_fw_tracer_cleanup(dev->tracer);
+	mlx5_eq_table_destroy(dev);
+	mlx5_pagealloc_stop(dev);
+	mlx5_events_stop(dev);
+	mlx5_put_uars_page(dev, dev->priv.uar);
+}
+
+static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+{
+	struct pci_dev *pdev = dev->pdev;
+	int err = 0;
+
+	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
+	mutex_lock(&dev->intf_state_mutex);
+	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
+		mlx5_core_warn(dev, "interface is up, NOP\n");
+		goto out;
+	}
+	/* remove any previous indication of internal error */
+	dev->state = MLX5_DEVICE_STATE_UP;
+
+	err = mlx5_function_setup(dev, boot);
+	if (err)
+		goto out;
+
+	if (boot) {
+		err = mlx5_init_once(dev);
+		if (err) {
+			dev_err(&pdev->dev, "sw objs init failed\n");
+			goto function_teardown;
+		}
+	}
+
+	err = mlx5_load(dev);
+	if (err)
+		goto err_load;
+
+	if (mlx5_device_registered(dev)) {
+		mlx5_attach_device(dev);
+	} else {
+		err = mlx5_register_device(dev);
+		if (err) {
+			dev_err(&pdev->dev, "register device failed %d\n", err);
+			goto err_reg_dev;
+		}
+	}
+
+	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
+out:
+	mutex_unlock(&dev->intf_state_mutex);
 
-err_get_uars:
+	return err;
+
+err_reg_dev:
+	mlx5_unload(dev);
+err_load:
 	if (boot)
 		mlx5_cleanup_once(dev);
-
 function_teardown:
 	mlx5_function_teardown(dev, boot);
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
@@ -1209,17 +1224,8 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 	if (mlx5_device_registered(dev))
 		mlx5_detach_device(dev);
 
-	mlx5_ec_cleanup(dev);
-	mlx5_sriov_detach(dev);
-	mlx5_cleanup_fs(dev);
-	mlx5_accel_ipsec_cleanup(dev);
-	mlx5_accel_tls_cleanup(dev);
-	mlx5_fpga_device_stop(dev);
-	mlx5_fw_tracer_cleanup(dev->tracer);
-	mlx5_eq_table_destroy(dev);
-	mlx5_pagealloc_stop(dev);
-	mlx5_events_stop(dev);
-	mlx5_put_uars_page(dev, dev->priv.uar);
+	mlx5_unload(dev);
+
 	if (cleanup)
 		mlx5_cleanup_once(dev);
 
-- 
2.20.1
