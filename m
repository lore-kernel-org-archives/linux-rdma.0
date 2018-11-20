From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/11] net/mlx5: CmdIF, Use async events chain
Date: Tue, 20 Nov 2018 14:12:24 -0800
Message-ID: <20181120221228.18365-8-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_cmd_comp_handler on MLX5_EVENT_TYPE_CMD
and let command interface to register its own handler when its ready.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 48 ++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  4 --
 .../net/ethernet/mellanox/mlx5/core/health.c  | 25 +---------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +-
 include/linux/mlx5/driver.h                   |  2 +
 5 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 7b18aff955f1..8ab636d59edb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -40,9 +40,11 @@
 #include <linux/random.h>
 #include <linux/io-mapping.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/eq.h>
 #include <linux/debugfs.h>
 
 #include "mlx5_core.h"
+#include "lib/eq.h"
 
 enum {
 	CMD_IF_REV = 5,
@@ -805,6 +807,8 @@ static u16 msg_to_opcode(struct mlx5_cmd_msg *in)
 	return MLX5_GET(mbox_in, in->first.data, opcode);
 }
 
+static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced);
+
 static void cb_timeout_handler(struct work_struct *work)
 {
 	struct delayed_work *dwork = container_of(work, struct delayed_work,
@@ -1412,14 +1416,32 @@ static void mlx5_cmd_change_mod(struct mlx5_core_dev *dev, int mode)
 		up(&cmd->sem);
 }
 
+static int cmd_comp_notifier(struct notifier_block *nb,
+			     unsigned long type, void *data)
+{
+	struct mlx5_core_dev *dev;
+	struct mlx5_cmd *cmd;
+	struct mlx5_eqe *eqe;
+
+	cmd = mlx5_nb_cof(nb, struct mlx5_cmd, nb);
+	dev = container_of(cmd, struct mlx5_core_dev, cmd);
+	eqe = data;
+
+	mlx5_cmd_comp_handler(dev, be32_to_cpu(eqe->data.cmd.vector), false);
+
+	return NOTIFY_OK;
+}
 void mlx5_cmd_use_events(struct mlx5_core_dev *dev)
 {
+	MLX5_NB_INIT(&dev->cmd.nb, cmd_comp_notifier, CMD);
+	mlx5_eq_notifier_register(dev, &dev->cmd.nb);
 	mlx5_cmd_change_mod(dev, CMD_MODE_EVENTS);
 }
 
 void mlx5_cmd_use_polling(struct mlx5_core_dev *dev)
 {
 	mlx5_cmd_change_mod(dev, CMD_MODE_POLLING);
+	mlx5_eq_notifier_unregister(dev, &dev->cmd.nb);
 }
 
 static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)
@@ -1435,7 +1457,7 @@ static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)
 	}
 }
 
-void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced)
+static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	struct mlx5_cmd_work_ent *ent;
@@ -1533,7 +1555,29 @@ void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced)
 		}
 	}
 }
-EXPORT_SYMBOL(mlx5_cmd_comp_handler);
+
+void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev)
+{
+	unsigned long flags;
+	u64 vector;
+
+	/* wait for pending handlers to complete */
+	mlx5_eq_synchronize_cmd_irq(dev);
+	spin_lock_irqsave(&dev->cmd.alloc_lock, flags);
+	vector = ~dev->cmd.bitmask & ((1ul << (1 << dev->cmd.log_sz)) - 1);
+	if (!vector)
+		goto no_trig;
+
+	vector |= MLX5_TRIGGERED_CMD_COMP;
+	spin_unlock_irqrestore(&dev->cmd.alloc_lock, flags);
+
+	mlx5_core_dbg(dev, "vector 0x%llx\n", vector);
+	mlx5_cmd_comp_handler(dev, vector, true);
+	return;
+
+no_trig:
+	spin_unlock_irqrestore(&dev->cmd.alloc_lock, flags);
+}
 
 static int status_to_err(u8 status)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 7f6a644700eb..b28869aa1a4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -368,10 +368,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			mlx5_srq_event(dev, rsn, eqe->type);
 			break;
 
-		case MLX5_EVENT_TYPE_CMD:
-			mlx5_cmd_comp_handler(dev, be32_to_cpu(eqe->data.cmd.vector), false);
-			break;
-
 		case MLX5_EVENT_TYPE_PORT_CHANGE:
 			port = (eqe->data.port.port >> 4) & 0xf;
 			switch (eqe->sub_type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 066883003aea..4e42bd290959 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -79,29 +79,6 @@ void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state)
 		    &dev->iseg->cmdq_addr_l_sz);
 }
 
-static void trigger_cmd_completions(struct mlx5_core_dev *dev)
-{
-	unsigned long flags;
-	u64 vector;
-
-	/* wait for pending handlers to complete */
-	mlx5_eq_synchronize_cmd_irq(dev);
-	spin_lock_irqsave(&dev->cmd.alloc_lock, flags);
-	vector = ~dev->cmd.bitmask & ((1ul << (1 << dev->cmd.log_sz)) - 1);
-	if (!vector)
-		goto no_trig;
-
-	vector |= MLX5_TRIGGERED_CMD_COMP;
-	spin_unlock_irqrestore(&dev->cmd.alloc_lock, flags);
-
-	mlx5_core_dbg(dev, "vector 0x%llx\n", vector);
-	mlx5_cmd_comp_handler(dev, vector, true);
-	return;
-
-no_trig:
-	spin_unlock_irqrestore(&dev->cmd.alloc_lock, flags);
-}
-
 static int in_fatal(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
@@ -125,7 +102,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 	mlx5_core_err(dev, "start\n");
 	if (pci_channel_offline(dev->pdev) || in_fatal(dev) || force) {
 		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
-		trigger_cmd_completions(dev);
+		mlx5_cmd_trigger_completions(dev);
 	}
 
 	mlx5_core_event(dev, MLX5_DEV_EVENT_SYS_ERROR, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index e06c6e16ffc9..5dd453e47a04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -127,7 +127,7 @@ int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev);
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev);
 
-void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced);
+void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev);
 int mlx5_cq_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 61088ad33500..a8d638134fc8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -278,6 +278,8 @@ struct mlx5_cmd_stats {
 };
 
 struct mlx5_cmd {
+	struct mlx5_nb    nb;
+
 	void	       *cmd_alloc_buf;
 	dma_addr_t	alloc_dma;
 	int		alloc_size;
-- 
2.19.1
