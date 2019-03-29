From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/14] net/mlx5: Replace dev_err/warn/info by mlx5_core_err/warn/info
Date: Fri, 29 Mar 2019 15:38:00 -0700
Message-ID: <20190329223804.8954-11-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>, Vu Pham <vuhuong@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Replace pci dev_err/warn/info messages with mlx5_core_err/warn/info
messages to provide a better report/debug of different mlx5 device types.

This patch does not change any functionality.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  20 +--
 .../ethernet/mellanox/mlx5/core/fpga/core.h   |  21 +--
 .../net/ethernet/mellanox/mlx5/core/health.c  |  35 ++---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 133 +++++++++---------
 4 files changed, 106 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a15bceba58d3..0a2ffe794a54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1902,9 +1902,9 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	memset(cmd, 0, sizeof(*cmd));
 	cmd_if_rev = cmdif_rev(dev);
 	if (cmd_if_rev != CMD_IF_REV) {
-		dev_err(&dev->pdev->dev,
-			"Driver cmdif rev(%d) differs from firmware's(%d)\n",
-			CMD_IF_REV, cmd_if_rev);
+		mlx5_core_err(dev,
+			      "Driver cmdif rev(%d) differs from firmware's(%d)\n",
+			      CMD_IF_REV, cmd_if_rev);
 		return -EINVAL;
 	}
 
@@ -1921,14 +1921,14 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	cmd->log_sz = cmd_l >> 4 & 0xf;
 	cmd->log_stride = cmd_l & 0xf;
 	if (1 << cmd->log_sz > MLX5_MAX_COMMANDS) {
-		dev_err(&dev->pdev->dev, "firmware reports too many outstanding commands %d\n",
-			1 << cmd->log_sz);
+		mlx5_core_err(dev, "firmware reports too many outstanding commands %d\n",
+			      1 << cmd->log_sz);
 		err = -EINVAL;
 		goto err_free_page;
 	}
 
 	if (cmd->log_sz + cmd->log_stride > MLX5_ADAPTER_PAGE_SHIFT) {
-		dev_err(&dev->pdev->dev, "command queue size overflow\n");
+		mlx5_core_err(dev, "command queue size overflow\n");
 		err = -EINVAL;
 		goto err_free_page;
 	}
@@ -1939,8 +1939,8 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 
 	cmd->cmdif_rev = ioread32be(&dev->iseg->cmdif_rev_fw_sub) >> 16;
 	if (cmd->cmdif_rev > CMD_IF_REV) {
-		dev_err(&dev->pdev->dev, "driver does not support command interface version. driver %d, firmware %d\n",
-			CMD_IF_REV, cmd->cmdif_rev);
+		mlx5_core_err(dev, "driver does not support command interface version. driver %d, firmware %d\n",
+			      CMD_IF_REV, cmd->cmdif_rev);
 		err = -EOPNOTSUPP;
 		goto err_free_page;
 	}
@@ -1956,7 +1956,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	cmd_h = (u32)((u64)(cmd->dma) >> 32);
 	cmd_l = (u32)(cmd->dma);
 	if (cmd_l & 0xfff) {
-		dev_err(&dev->pdev->dev, "invalid command queue address\n");
+		mlx5_core_err(dev, "invalid command queue address\n");
 		err = -ENOMEM;
 		goto err_free_page;
 	}
@@ -1976,7 +1976,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	set_wqname(dev);
 	cmd->wq = create_singlethread_workqueue(cmd->wq_name);
 	if (!cmd->wq) {
-		dev_err(&dev->pdev->dev, "failed to create command workqueue\n");
+		mlx5_core_err(dev, "failed to create command workqueue\n");
 		err = -ENOMEM;
 		goto err_cache;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
index 7e2e871dbf83..52c9dee91ea4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
@@ -37,6 +37,7 @@
 
 #include <linux/mlx5/eq.h>
 
+#include "mlx5_core.h"
 #include "lib/eq.h"
 #include "fpga/cmd.h"
 
@@ -62,26 +63,26 @@ struct mlx5_fpga_device {
 };
 
 #define mlx5_fpga_dbg(__adev, format, ...) \
-	dev_dbg(&(__adev)->mdev->pdev->dev, "FPGA: %s:%d:(pid %d): " format, \
-		 __func__, __LINE__, current->pid, ##__VA_ARGS__)
+	mlx5_core_dbg((__adev)->mdev, "FPGA: %s:%d:(pid %d): " format, \
+		       __func__, __LINE__, current->pid, ##__VA_ARGS__)
 
 #define mlx5_fpga_err(__adev, format, ...) \
-	dev_err(&(__adev)->mdev->pdev->dev, "FPGA: %s:%d:(pid %d): " format, \
-		__func__, __LINE__, current->pid, ##__VA_ARGS__)
+	mlx5_core_err((__adev)->mdev, "FPGA: %s:%d:(pid %d): " format, \
+		      __func__, __LINE__, current->pid, ##__VA_ARGS__)
 
 #define mlx5_fpga_warn(__adev, format, ...) \
-	dev_warn(&(__adev)->mdev->pdev->dev, "FPGA: %s:%d:(pid %d): " format, \
-		__func__, __LINE__, current->pid, ##__VA_ARGS__)
+	mlx5_core_warn((__adev)->mdev, "FPGA: %s:%d:(pid %d): " format, \
+		       __func__, __LINE__, current->pid, ##__VA_ARGS__)
 
 #define mlx5_fpga_warn_ratelimited(__adev, format, ...) \
-	dev_warn_ratelimited(&(__adev)->mdev->pdev->dev, "FPGA: %s:%d: " \
-		format, __func__, __LINE__, ##__VA_ARGS__)
+	mlx5_core_err_rl((__adev)->mdev, "FPGA: %s:%d: " \
+			 format, __func__, __LINE__, ##__VA_ARGS__)
 
 #define mlx5_fpga_notice(__adev, format, ...) \
-	dev_notice(&(__adev)->mdev->pdev->dev, "FPGA: " format, ##__VA_ARGS__)
+	mlx5_core_info((__adev)->mdev, "FPGA: " format, ##__VA_ARGS__)
 
 #define mlx5_fpga_info(__adev, format, ...) \
-	dev_info(&(__adev)->mdev->pdev->dev, "FPGA: " format, ##__VA_ARGS__)
+	mlx5_core_info((__adev)->mdev, "FPGA: " format, ##__VA_ARGS__)
 
 int mlx5_fpga_init(struct mlx5_core_dev *mdev);
 void mlx5_fpga_cleanup(struct mlx5_core_dev *mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index fa28975dfe7b..3b98fcdd7d0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -152,11 +152,11 @@ static void health_recover(struct work_struct *work)
 
 	nic_state = mlx5_get_nic_state(dev);
 	if (nic_state == MLX5_NIC_IFC_INVALID) {
-		dev_err(&dev->pdev->dev, "health recovery flow aborted since the nic state is invalid\n");
+		mlx5_core_err(dev, "health recovery flow aborted since the nic state is invalid\n");
 		return;
 	}
 
-	dev_err(&dev->pdev->dev, "starting health recovery flow\n");
+	mlx5_core_err(dev, "starting health recovery flow\n");
 	mlx5_recover_device(dev);
 }
 
@@ -180,8 +180,8 @@ static void health_care(struct work_struct *work)
 	if (!test_bit(MLX5_DROP_NEW_RECOVERY_WORK, &health->flags))
 		schedule_delayed_work(&health->recover_work, recover_delay);
 	else
-		dev_err(&dev->pdev->dev,
-			"new health works are not permitted at this stage\n");
+		mlx5_core_err(dev,
+			      "new health works are not permitted at this stage\n");
 	spin_unlock_irqrestore(&health->wq_lock, flags);
 }
 
@@ -228,18 +228,22 @@ static void print_health_info(struct mlx5_core_dev *dev)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(h->assert_var); i++)
-		dev_err(&dev->pdev->dev, "assert_var[%d] 0x%08x\n", i, ioread32be(h->assert_var + i));
+		mlx5_core_err(dev, "assert_var[%d] 0x%08x\n", i,
+			      ioread32be(h->assert_var + i));
 
-	dev_err(&dev->pdev->dev, "assert_exit_ptr 0x%08x\n", ioread32be(&h->assert_exit_ptr));
-	dev_err(&dev->pdev->dev, "assert_callra 0x%08x\n", ioread32be(&h->assert_callra));
+	mlx5_core_err(dev, "assert_exit_ptr 0x%08x\n",
+		      ioread32be(&h->assert_exit_ptr));
+	mlx5_core_err(dev, "assert_callra 0x%08x\n",
+		      ioread32be(&h->assert_callra));
 	sprintf(fw_str, "%d.%d.%d", fw_rev_maj(dev), fw_rev_min(dev), fw_rev_sub(dev));
-	dev_err(&dev->pdev->dev, "fw_ver %s\n", fw_str);
-	dev_err(&dev->pdev->dev, "hw_id 0x%08x\n", ioread32be(&h->hw_id));
-	dev_err(&dev->pdev->dev, "irisc_index %d\n", ioread8(&h->irisc_index));
-	dev_err(&dev->pdev->dev, "synd 0x%x: %s\n", ioread8(&h->synd), hsynd_str(ioread8(&h->synd)));
-	dev_err(&dev->pdev->dev, "ext_synd 0x%04x\n", ioread16be(&h->ext_synd));
+	mlx5_core_err(dev, "fw_ver %s\n", fw_str);
+	mlx5_core_err(dev, "hw_id 0x%08x\n", ioread32be(&h->hw_id));
+	mlx5_core_err(dev, "irisc_index %d\n", ioread8(&h->irisc_index));
+	mlx5_core_err(dev, "synd 0x%x: %s\n", ioread8(&h->synd),
+		      hsynd_str(ioread8(&h->synd)));
+	mlx5_core_err(dev, "ext_synd 0x%04x\n", ioread16be(&h->ext_synd));
 	fw = ioread32be(&h->fw_ver);
-	dev_err(&dev->pdev->dev, "raw fw_ver 0x%08x\n", fw);
+	mlx5_core_err(dev, "raw fw_ver 0x%08x\n", fw);
 }
 
 static unsigned long get_next_poll_jiffies(void)
@@ -262,8 +266,7 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
 	if (!test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags))
 		queue_work(health->wq, &health->work);
 	else
-		dev_err(&dev->pdev->dev,
-			"new health works are not permitted at this stage\n");
+		mlx5_core_err(dev, "new health works are not permitted at this stage\n");
 	spin_unlock_irqrestore(&health->wq_lock, flags);
 }
 
@@ -284,7 +287,7 @@ static void poll_health(struct timer_list *t)
 
 	health->prev = count;
 	if (health->miss_counter == MAX_MISSES) {
-		dev_err(&dev->pdev->dev, "device's health compromised - reached miss count\n");
+		mlx5_core_err(dev, "device's health compromised - reached miss count\n");
 		print_health_info(dev);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bdfc0429ee6e..cbb5e76d9351 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -587,24 +587,23 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 
 static int set_hca_cap(struct mlx5_core_dev *dev)
 {
-	struct pci_dev *pdev = dev->pdev;
 	int err;
 
 	err = handle_hca_cap(dev);
 	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap failed\n");
+		mlx5_core_err(dev, "handle_hca_cap failed\n");
 		goto out;
 	}
 
 	err = handle_hca_cap_atomic(dev);
 	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
+		mlx5_core_err(dev, "handle_hca_cap_atomic failed\n");
 		goto out;
 	}
 
 	err = handle_hca_cap_odp(dev);
 	if (err) {
-		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
+		mlx5_core_err(dev, "handle_hca_cap_odp failed\n");
 		goto out;
 	}
 
@@ -751,13 +750,13 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Cannot enable PCI device, aborting\n");
+		mlx5_core_err(dev, "Cannot enable PCI device, aborting\n");
 		return err;
 	}
 
 	err = request_bar(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "error requesting BARs, aborting\n");
+		mlx5_core_err(dev, "error requesting BARs, aborting\n");
 		goto err_disable;
 	}
 
@@ -765,7 +764,7 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 
 	err = set_dma_caps(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed setting DMA capabilities mask, aborting\n");
+		mlx5_core_err(dev, "Failed setting DMA capabilities mask, aborting\n");
 		goto err_clr_master;
 	}
 
@@ -778,7 +777,7 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 	dev->iseg = ioremap(dev->iseg_base, sizeof(*dev->iseg));
 	if (!dev->iseg) {
 		err = -ENOMEM;
-		dev_err(&pdev->dev, "Failed mapping initialization segment, aborting\n");
+		mlx5_core_err(dev, "Failed mapping initialization segment, aborting\n");
 		goto err_clr_master;
 	}
 
@@ -802,35 +801,34 @@ static void mlx5_pci_close(struct mlx5_core_dev *dev)
 
 static int mlx5_init_once(struct mlx5_core_dev *dev)
 {
-	struct pci_dev *pdev = dev->pdev;
 	int err;
 
 	dev->priv.devcom = mlx5_devcom_register_device(dev);
 	if (IS_ERR(dev->priv.devcom))
-		dev_err(&pdev->dev, "failed to register with devcom (0x%p)\n",
-			dev->priv.devcom);
+		mlx5_core_err(dev, "failed to register with devcom (0x%p)\n",
+			      dev->priv.devcom);
 
 	err = mlx5_query_board_id(dev);
 	if (err) {
-		dev_err(&pdev->dev, "query board id failed\n");
+		mlx5_core_err(dev, "query board id failed\n");
 		goto err_devcom;
 	}
 
 	err = mlx5_eq_table_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "failed to initialize eq\n");
+		mlx5_core_err(dev, "failed to initialize eq\n");
 		goto err_devcom;
 	}
 
 	err = mlx5_events_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "failed to initialize events\n");
+		mlx5_core_err(dev, "failed to initialize events\n");
 		goto err_eq_cleanup;
 	}
 
 	err = mlx5_cq_debugfs_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "failed to initialize cq debugfs\n");
+		mlx5_core_err(dev, "failed to initialize cq debugfs\n");
 		goto err_events_cleanup;
 	}
 
@@ -846,31 +844,31 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 	err = mlx5_init_rl_table(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init rate limiting\n");
+		mlx5_core_err(dev, "Failed to init rate limiting\n");
 		goto err_tables_cleanup;
 	}
 
 	err = mlx5_mpfs_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init l2 table %d\n", err);
+		mlx5_core_err(dev, "Failed to init l2 table %d\n", err);
 		goto err_rl_cleanup;
 	}
 
 	err = mlx5_eswitch_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init eswitch %d\n", err);
+		mlx5_core_err(dev, "Failed to init eswitch %d\n", err);
 		goto err_mpfs_cleanup;
 	}
 
 	err = mlx5_sriov_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init sriov %d\n", err);
+		mlx5_core_err(dev, "Failed to init sriov %d\n", err);
 		goto err_eswitch_cleanup;
 	}
 
 	err = mlx5_fpga_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init fpga device %d\n", err);
+		mlx5_core_err(dev, "Failed to init fpga device %d\n", err);
 		goto err_sriov_cleanup;
 	}
 
@@ -922,11 +920,10 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 
 static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 {
-	struct pci_dev *pdev = dev->pdev;
 	int err;
 
-	dev_info(&pdev->dev, "firmware version: %d.%d.%d\n", fw_rev_maj(dev),
-		 fw_rev_min(dev), fw_rev_sub(dev));
+	mlx5_core_info(dev, "firmware version: %d.%d.%d\n", fw_rev_maj(dev),
+		       fw_rev_min(dev), fw_rev_sub(dev));
 
 	/* Only PFs hold the relevant PCIe information for this query */
 	if (mlx5_core_is_pf(dev))
@@ -936,63 +933,63 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 	 */
 	err = wait_fw_init(dev, FW_PRE_INIT_TIMEOUT_MILI);
 	if (err) {
-		dev_err(&dev->pdev->dev, "Firmware over %d MS in pre-initializing state, aborting\n",
-			FW_PRE_INIT_TIMEOUT_MILI);
+		mlx5_core_err(dev, "Firmware over %d MS in pre-initializing state, aborting\n",
+			      FW_PRE_INIT_TIMEOUT_MILI);
 		return err;
 	}
 
 	err = mlx5_cmd_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed initializing command interface, aborting\n");
+		mlx5_core_err(dev, "Failed initializing command interface, aborting\n");
 		return err;
 	}
 
 	err = wait_fw_init(dev, FW_INIT_TIMEOUT_MILI);
 	if (err) {
-		dev_err(&dev->pdev->dev, "Firmware over %d MS in initializing state, aborting\n",
-			FW_INIT_TIMEOUT_MILI);
+		mlx5_core_err(dev, "Firmware over %d MS in initializing state, aborting\n",
+			      FW_INIT_TIMEOUT_MILI);
 		goto err_cmd_cleanup;
 	}
 
 	err = mlx5_core_enable_hca(dev, 0);
 	if (err) {
-		dev_err(&pdev->dev, "enable hca failed\n");
+		mlx5_core_err(dev, "enable hca failed\n");
 		goto err_cmd_cleanup;
 	}
 
 	err = mlx5_core_set_issi(dev);
 	if (err) {
-		dev_err(&pdev->dev, "failed to set issi\n");
+		mlx5_core_err(dev, "failed to set issi\n");
 		goto err_disable_hca;
 	}
 
 	err = mlx5_satisfy_startup_pages(dev, 1);
 	if (err) {
-		dev_err(&pdev->dev, "failed to allocate boot pages\n");
+		mlx5_core_err(dev, "failed to allocate boot pages\n");
 		goto err_disable_hca;
 	}
 
 	err = set_hca_ctrl(dev);
 	if (err) {
-		dev_err(&pdev->dev, "set_hca_ctrl failed\n");
+		mlx5_core_err(dev, "set_hca_ctrl failed\n");
 		goto reclaim_boot_pages;
 	}
 
 	err = set_hca_cap(dev);
 	if (err) {
-		dev_err(&pdev->dev, "set_hca_cap failed\n");
+		mlx5_core_err(dev, "set_hca_cap failed\n");
 		goto reclaim_boot_pages;
 	}
 
 	err = mlx5_satisfy_startup_pages(dev, 0);
 	if (err) {
-		dev_err(&pdev->dev, "failed to allocate init pages\n");
+		mlx5_core_err(dev, "failed to allocate init pages\n");
 		goto reclaim_boot_pages;
 	}
 
 	err = mlx5_cmd_init_hca(dev, sw_owner_id);
 	if (err) {
-		dev_err(&pdev->dev, "init hca failed\n");
+		mlx5_core_err(dev, "init hca failed\n");
 		goto reclaim_boot_pages;
 	}
 
@@ -1002,7 +999,7 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 
 	err = mlx5_query_hca_caps(dev);
 	if (err) {
-		dev_err(&pdev->dev, "query hca failed\n");
+		mlx5_core_err(dev, "query hca failed\n");
 		goto stop_health;
 	}
 
@@ -1027,7 +1024,7 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	mlx5_stop_health_poll(dev, boot);
 	err = mlx5_cmd_teardown_hca(dev);
 	if (err) {
-		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
+		mlx5_core_err(dev, "tear_down_hca failed, skip cleanup\n");
 		return err;
 	}
 	mlx5_reclaim_startup_pages(dev);
@@ -1039,12 +1036,11 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 
 static int mlx5_load(struct mlx5_core_dev *dev)
 {
-	struct pci_dev *pdev = dev->pdev;
 	int err;
 
 	dev->priv.uar = mlx5_get_uars_page(dev);
 	if (IS_ERR(dev->priv.uar)) {
-		dev_err(&pdev->dev, "Failed allocating uar, aborting\n");
+		mlx5_core_err(dev, "Failed allocating uar, aborting\n");
 		err = PTR_ERR(dev->priv.uar);
 		return err;
 	}
@@ -1054,55 +1050,55 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 
 	err = mlx5_eq_table_create(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to create EQs\n");
+		mlx5_core_err(dev, "Failed to create EQs\n");
 		goto err_eq_table;
 	}
 
 	err = mlx5_fw_tracer_init(dev->tracer);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init FW tracer\n");
+		mlx5_core_err(dev, "Failed to init FW tracer\n");
 		goto err_fw_tracer;
 	}
 
 	err = mlx5_fpga_device_start(dev);
 	if (err) {
-		dev_err(&pdev->dev, "fpga device start failed %d\n", err);
+		mlx5_core_err(dev, "fpga device start failed %d\n", err);
 		goto err_fpga_start;
 	}
 
 	err = mlx5_accel_ipsec_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "IPSec device start failed %d\n", err);
+		mlx5_core_err(dev, "IPSec device start failed %d\n", err);
 		goto err_ipsec_start;
 	}
 
 	err = mlx5_accel_tls_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "TLS device start failed %d\n", err);
+		mlx5_core_err(dev, "TLS device start failed %d\n", err);
 		goto err_tls_start;
 	}
 
 	err = mlx5_init_fs(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init flow steering\n");
+		mlx5_core_err(dev, "Failed to init flow steering\n");
 		goto err_fs;
 	}
 
 	err = mlx5_core_set_hca_defaults(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to set hca defaults\n");
+		mlx5_core_err(dev, "Failed to set hca defaults\n");
 		goto err_fs;
 	}
 
 	err = mlx5_sriov_attach(dev);
 	if (err) {
-		dev_err(&pdev->dev, "sriov init failed %d\n", err);
+		mlx5_core_err(dev, "sriov init failed %d\n", err);
 		goto err_sriov;
 	}
 
 	err = mlx5_ec_init(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to init embedded CPU\n");
+		mlx5_core_err(dev, "Failed to init embedded CPU\n");
 		goto err_ec;
 	}
 
@@ -1146,7 +1142,6 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 
 static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 {
-	struct pci_dev *pdev = dev->pdev;
 	int err = 0;
 
 	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
@@ -1165,7 +1160,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	if (boot) {
 		err = mlx5_init_once(dev);
 		if (err) {
-			dev_err(&pdev->dev, "sw objs init failed\n");
+			mlx5_core_err(dev, "sw objs init failed\n");
 			goto function_teardown;
 		}
 	}
@@ -1179,7 +1174,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	} else {
 		err = mlx5_register_device(dev);
 		if (err) {
-			dev_err(&pdev->dev, "register device failed %d\n", err);
+			mlx5_core_err(dev, "register device failed %d\n", err);
 			goto err_reg_dev;
 		}
 	}
@@ -1212,8 +1207,8 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 
 	mutex_lock(&dev->intf_state_mutex);
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
-		dev_warn(&dev->pdev->dev, "%s: interface is down, NOP\n",
-			 __func__);
+		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
+			       __func__);
 		if (cleanup)
 			mlx5_cleanup_once(dev);
 		goto out;
@@ -1323,13 +1318,15 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = mlx5_pci_init(dev, pdev, id);
 	if (err) {
-		dev_err(&pdev->dev, "mlx5_pci_init failed with error code %d\n", err);
+		mlx5_core_err(dev, "mlx5_pci_init failed with error code %d\n",
+			      err);
 		goto pci_init_err;
 	}
 
 	err = mlx5_load_one(dev, true);
 	if (err) {
-		dev_err(&pdev->dev, "mlx5_load_one failed with error code %d\n", err);
+		mlx5_core_err(dev, "mlx5_load_one failed with error code %d\n",
+			      err);
 		goto err_load_one;
 	}
 
@@ -1364,7 +1361,7 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_unregister_device(dev);
 
 	if (mlx5_unload_one(dev, true)) {
-		dev_err(&dev->pdev->dev, "mlx5_unload_one failed\n");
+		mlx5_core_err(dev, "mlx5_unload_one failed\n");
 		mlx5_health_flush(dev);
 		return;
 	}
@@ -1379,7 +1376,7 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	dev_info(&pdev->dev, "%s was called\n", __func__);
+	mlx5_core_info(dev, "%s was called\n", __func__);
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_unload_one(dev, false);
@@ -1409,7 +1406,9 @@ static int wait_vital(struct pci_dev *pdev)
 		count = ioread32be(health->health_counter);
 		if (count && count != 0xffffffff) {
 			if (last_count && last_count != count) {
-				dev_info(&pdev->dev, "Counter value 0x%x after %d iterations\n", count, i);
+				mlx5_core_info(dev,
+					       "wait vital counter value 0x%x after %d iterations\n",
+					       count, i);
 				return 0;
 			}
 			last_count = count;
@@ -1425,12 +1424,12 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	dev_info(&pdev->dev, "%s was called\n", __func__);
+	mlx5_core_info(dev, "%s was called\n", __func__);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
-		dev_err(&pdev->dev, "%s: mlx5_pci_enable_device failed with error code: %d\n"
-			, __func__, err);
+		mlx5_core_err(dev, "%s: mlx5_pci_enable_device failed with error code: %d\n",
+			      __func__, err);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -1439,7 +1438,7 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 	pci_save_state(pdev);
 
 	if (wait_vital(pdev)) {
-		dev_err(&pdev->dev, "%s: wait_vital timed out\n", __func__);
+		mlx5_core_err(dev, "%s: wait_vital timed out\n", __func__);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -1451,14 +1450,14 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	dev_info(&pdev->dev, "%s was called\n", __func__);
+	mlx5_core_info(dev, "%s was called\n", __func__);
 
 	err = mlx5_load_one(dev, false);
 	if (err)
-		dev_err(&pdev->dev, "%s: mlx5_load_one failed with error code: %d\n"
-			, __func__, err);
+		mlx5_core_err(dev, "%s: mlx5_load_one failed with error code: %d\n",
+			      __func__, err);
 	else
-		dev_info(&pdev->dev, "%s: device recovered\n", __func__);
+		mlx5_core_info(dev, "%s: device recovered\n", __func__);
 }
 
 static const struct pci_error_handlers mlx5_err_handler = {
@@ -1522,7 +1521,7 @@ static void shutdown(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int err;
 
-	dev_info(&pdev->dev, "Shutdown was called\n");
+	mlx5_core_info(dev, "Shutdown was called\n");
 	err = mlx5_try_fast_unload(dev);
 	if (err)
 		mlx5_unload_one(dev, false);
-- 
2.20.1
