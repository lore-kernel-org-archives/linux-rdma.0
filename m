From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/11] net/mlx5: E-Switch, Use async events chain
Date: Tue, 20 Nov 2018 14:12:22 -0800
Message-ID: <20181120221228.18365-6-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_eswitch_vport_event on
MLX5_EVENT_TYPE_NIC_VPORT_CHANGE and let the eswitch register its own
handler when its ready.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  4 --
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 44 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  3 +-
 3 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index e5fcce9ca107..7c8b2d89645b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -409,10 +409,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			}
 			break;
 
-		case MLX5_EVENT_TYPE_NIC_VPORT_CHANGE:
-			mlx5_eswitch_vport_event(dev->priv.eswitch, eqe);
-			break;
-
 		case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
 			mlx5_port_module_event(dev, eqe);
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2346b6ba3d54..e6a9b19d8626 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -36,6 +36,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include "mlx5_core.h"
+#include "lib/eq.h"
 #include "eswitch.h"
 #include "fs_core.h"
 #include "lib/eq.h"
@@ -1568,7 +1569,6 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, int vport_num)
 	/* Mark this vport as disabled to discard new events */
 	vport->enabled = false;
 
-	mlx5_eq_synchronize_async_irq(esw->dev);
 	/* Wait for current already scheduled events to complete */
 	flush_workqueue(esw->work_queue);
 	/* Disable events from this vport */
@@ -1594,10 +1594,25 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, int vport_num)
 	mutex_unlock(&esw->state_lock);
 }
 
+static int eswitch_vport_event(struct notifier_block *nb,
+			       unsigned long type, void *data)
+{
+	struct mlx5_eswitch *esw = mlx5_nb_cof(nb, struct mlx5_eswitch, nb);
+	struct mlx5_eqe *eqe = data;
+	struct mlx5_vport *vport;
+	u16 vport_num;
+
+	vport_num = be16_to_cpu(eqe->data.vport_change.vport_num);
+	vport = &esw->vports[vport_num];
+	if (vport->enabled)
+		queue_work(esw->work_queue, &vport->vport_change_handler);
+
+	return NOTIFY_OK;
+}
+
 /* Public E-Switch API */
 #define ESW_ALLOWED(esw) ((esw) && MLX5_ESWITCH_MANAGER((esw)->dev))
 
-
 int mlx5_eswitch_enable_sriov(struct mlx5_eswitch *esw, int nvfs, int mode)
 {
 	int err;
@@ -1641,6 +1656,11 @@ int mlx5_eswitch_enable_sriov(struct mlx5_eswitch *esw, int nvfs, int mode)
 	for (i = 0; i <= nvfs; i++)
 		esw_enable_vport(esw, i, enabled_events);
 
+	if (mode == SRIOV_LEGACY) {
+		MLX5_NB_INIT(&esw->nb, eswitch_vport_event, NIC_VPORT_CHANGE);
+		mlx5_eq_notifier_register(esw->dev, &esw->nb);
+	}
+
 	esw_info(esw->dev, "SRIOV enabled: active vports(%d)\n",
 		 esw->enabled_vports);
 	return 0;
@@ -1670,6 +1690,9 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw)
 	mc_promisc = &esw->mc_promisc;
 	nvports = esw->enabled_vports;
 
+	if (esw->mode == SRIOV_LEGACY)
+		mlx5_eq_notifier_unregister(esw->dev, &esw->nb);
+
 	for (i = 0; i < esw->total_vports; i++)
 		esw_disable_vport(esw, i);
 
@@ -1778,23 +1801,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	kfree(esw);
 }
 
-void mlx5_eswitch_vport_event(struct mlx5_eswitch *esw, struct mlx5_eqe *eqe)
-{
-	struct mlx5_eqe_vport_change *vc_eqe = &eqe->data.vport_change;
-	u16 vport_num = be16_to_cpu(vc_eqe->vport_num);
-	struct mlx5_vport *vport;
-
-	if (!esw) {
-		pr_warn("MLX5 E-Switch: vport %d got an event while eswitch is not initialized\n",
-			vport_num);
-		return;
-	}
-
-	vport = &esw->vports[vport_num];
-	if (vport->enabled)
-		queue_work(esw->work_queue, &vport->vport_change_handler);
-}
-
 /* Vport Administration */
 #define LEGAL_VPORT(esw, vport) (vport >= 0 && vport < esw->total_vports)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index aaafc9f17115..480ffa294867 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -181,6 +181,7 @@ struct esw_mc_addr { /* SRIOV only */
 
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
+	struct mlx5_nb          nb;
 	struct mlx5_eswitch_fdb fdb_table;
 	struct hlist_head       mc_table[MLX5_L2_ADDR_HASH_SIZE];
 	struct workqueue_struct *work_queue;
@@ -211,7 +212,6 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw);
 /* E-Switch API */
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
 void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw);
-void mlx5_eswitch_vport_event(struct mlx5_eswitch *esw, struct mlx5_eqe *eqe);
 int mlx5_eswitch_enable_sriov(struct mlx5_eswitch *esw, int nvfs, int mode);
 void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw);
 int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
@@ -352,7 +352,6 @@ static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
-static inline void mlx5_eswitch_vport_event(struct mlx5_eswitch *esw, struct mlx5_eqe *eqe) {}
 static inline int  mlx5_eswitch_enable_sriov(struct mlx5_eswitch *esw, int nvfs, int mode) { return 0; }
 static inline void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw) {}
 
-- 
2.19.1
