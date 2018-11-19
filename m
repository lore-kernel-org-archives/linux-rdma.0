From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 08/12] net/mlx5: EQ, Privatize eq_table and friends
Date: Mon, 19 Nov 2018 10:52:38 -0800
Message-ID: <20181119185242.21961-9-saeedm@mellanox.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Move unnecessary EQ table structures and declaration from the
public include/linux/mlx5/driver.h into the private area of mlx5_core
and into eq.c/eq.h.

Introduce new mlx5 EQ APIs:

mlx5_comp_vectors_count(dev);
mlx5_comp_irq_get_affinity_mask(dev, vector);

And use them from mlx5_ib or mlx5e netdevice instead of direct access to
mlx5_core internal structures.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 102 ++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  77 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  15 ---
 include/linux/mlx5/driver.h                   |  87 +--------------
 12 files changed, 179 insertions(+), 135 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e9c428071df3..6fbc0cba1bac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5337,7 +5337,7 @@ mlx5_ib_get_vector_affinity(struct ib_device *ibdev, int comp_vector)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 
-	return mlx5_get_vector_affinity_hint(dev->mdev, comp_vector);
+	return mlx5_comp_irq_get_affinity_mask(dev->mdev, comp_vector);
 }
 
 /* The mlx5_ib_multiport_mutex should be held when calling this function */
@@ -5701,8 +5701,7 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.node_type		= RDMA_NODE_IB_CA;
 	dev->ib_dev.local_dma_lkey	= 0 /* not supported for now */;
 	dev->ib_dev.phys_port_cnt	= dev->num_ports;
-	dev->ib_dev.num_comp_vectors    =
-		dev->mdev->priv.eq_table.num_comp_vectors;
+	dev->ib_dev.num_comp_vectors    = mlx5_comp_vectors_count(mdev);
 	dev->ib_dev.dev.parent		= &mdev->pdev->dev;
 
 	mutex_init(&dev->cap_mask_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 4b85abb5c9f7..6e55d2f37c6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -38,6 +38,7 @@
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/cq.h>
 #include "mlx5_core.h"
+#include "lib/eq.h"
 
 #define TASKLET_MAX_TIME 2
 #define TASKLET_MAX_TIME_JIFFIES msecs_to_jiffies(TASKLET_MAX_TIME)
@@ -124,7 +125,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 		goto err_cmd;
 
 	/* Add to async EQ CQ tree to recv async events */
-	err = mlx5_eq_add_cq(&dev->priv.eq_table.async_eq, cq);
+	err = mlx5_eq_add_cq(mlx5_get_async_eq(dev), cq);
 	if (err)
 		goto err_cq_add;
 
@@ -157,7 +158,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {0};
 	int err;
 
-	err = mlx5_eq_del_cq(&dev->priv.eq_table.async_eq, cq);
+	err = mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index b76766fb6c67..a11e22d0b0cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -36,6 +36,7 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/driver.h>
 #include "mlx5_core.h"
+#include "lib/eq.h"
 
 enum {
 	QP_PID,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d7fbd5b6ac95..aea74856c702 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -178,8 +178,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 {
 	return is_kdump_kernel() ?
 		MLX5E_MIN_NUM_CHANNELS :
-		min_t(int, mdev->priv.eq_table.num_comp_vectors,
-		      MLX5E_MAX_NUM_CHANNELS);
+		min_t(int, mlx5_comp_vectors_count(mdev), MLX5E_MAX_NUM_CHANNELS);
 }
 
 /* Use this function to get max num channels after netdev was created */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 32ea47c28324..c23caade31bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -49,6 +49,7 @@
 #include "lib/clock.h"
 #include "en/port.h"
 #include "en/xdp.h"
+#include "lib/eq.h"
 
 struct mlx5e_rq_param {
 	u32			rqc[MLX5_ST_SZ_DW(rqc)];
@@ -1758,11 +1759,6 @@ static void mlx5e_close_cq(struct mlx5e_cq *cq)
 	mlx5e_free_cq(cq);
 }
 
-static int mlx5e_get_cpu(struct mlx5e_priv *priv, int ix)
-{
-	return cpumask_first(priv->mdev->priv.eq_table.irq_info[ix + MLX5_EQ_VEC_COMP_BASE].mask);
-}
-
 static int mlx5e_open_tx_cqs(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
 			     struct mlx5e_channel_param *cparam)
@@ -1913,9 +1909,9 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_channel_param *cparam,
 			      struct mlx5e_channel **cp)
 {
+	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
 	struct net_dim_cq_moder icocq_moder = {0, 0};
 	struct net_device *netdev = priv->netdev;
-	int cpu = mlx5e_get_cpu(priv, ix);
 	struct mlx5e_channel *c;
 	unsigned int irq;
 	int err;
@@ -4960,7 +4956,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	netif_carrier_off(netdev);
 
 #ifdef CONFIG_MLX5_EN_ARFS
-	netdev->rx_cpu_rmap = mdev->priv.eq_table.rmap;
+	netdev->rx_cpu_rmap =  mlx5_eq_table_get_rmap(mdev);
 #endif
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 70f62f10065e..32ce20221c44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -38,6 +38,7 @@
 #include <linux/cpu_rmap.h>
 #endif
 #include "mlx5_core.h"
+#include "lib/eq.h"
 #include "fpga/core.h"
 #include "eswitch.h"
 #include "lib/clock.h"
@@ -65,6 +66,26 @@ enum {
 	MLX5_EQ_DOORBEL_OFFSET	= 0x40,
 };
 
+struct mlx5_irq_info {
+	cpumask_var_t mask;
+	char name[MLX5_MAX_IRQ_NAME];
+};
+
+struct mlx5_eq_table {
+	struct list_head	comp_eqs_list;
+	struct mlx5_eq		pages_eq;
+	struct mlx5_eq		async_eq;
+	struct mlx5_eq		cmd_eq;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	struct mlx5_eq		pfault_eq;
+#endif
+	int			num_comp_vectors;
+	struct mlx5_irq_info	*irq_info;
+#ifdef CONFIG_RFS_ACCEL
+	struct cpu_rmap         *rmap;
+#endif
+};
+
 #define MLX5_ASYNC_EVENT_MASK ((1ull << MLX5_EVENT_TYPE_PATH_MIG)	    | \
 			       (1ull << MLX5_EVENT_TYPE_COMM_EST)	    | \
 			       (1ull << MLX5_EVENT_TYPE_SQ_DRAINED)	    | \
@@ -633,10 +654,11 @@ static void init_eq_buf(struct mlx5_eq *eq)
 	}
 }
 
-int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
-		       int nent, u64 mask, const char *name,
-		       enum mlx5_eq_type type)
+static int
+mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
+		   int nent, u64 mask, const char *name, enum mlx5_eq_type type)
 {
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
 	struct mlx5_cq_table *cq_table = &eq->cq_table;
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
 	struct mlx5_priv *priv = &dev->priv;
@@ -694,7 +716,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	if (err)
 		goto err_in;
 
-	snprintf(priv->eq_table.irq_info[vecidx].name, MLX5_MAX_IRQ_NAME, "%s@pci:%s",
+	snprintf(eq_table->irq_info[vecidx].name, MLX5_MAX_IRQ_NAME, "%s@pci:%s",
 		 name, pci_name(dev->pdev));
 
 	eq->eqn = MLX5_GET(create_eq_out, out, eq_number);
@@ -702,7 +724,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	eq->dev = dev;
 	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBEL_OFFSET;
 	err = request_irq(eq->irqn, handler, 0,
-			  priv->eq_table.irq_info[vecidx].name, eq);
+			  eq_table->irq_info[vecidx].name, eq);
 	if (err)
 		goto err_eq;
 
@@ -746,7 +768,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	return err;
 }
 
-int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
+static int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
 	int err;
 
@@ -806,25 +828,35 @@ int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 	return 0;
 }
 
-int mlx5_eq_init(struct mlx5_core_dev *dev)
+int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 {
+	struct mlx5_eq_table *eq_table;
 	int err;
 
+	eq_table = kvzalloc(sizeof(*eq_table), GFP_KERNEL);
+	if (!eq_table)
+		return -ENOMEM;
+
+	dev->priv.eq_table = eq_table;
+
 	err = mlx5_eq_debugfs_init(dev);
+	if (err)
+		kvfree(eq_table);
 
 	return err;
 }
 
-void mlx5_eq_cleanup(struct mlx5_core_dev *dev)
+void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev)
 {
 	mlx5_eq_debugfs_cleanup(dev);
+	kvfree(dev->priv.eq_table);
 }
 
 /* Async EQs */
 
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	u64 async_event_mask = MLX5_ASYNC_EVENT_MASK;
 	int err;
 
@@ -916,7 +948,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 static void destroy_async_eqs(struct mlx5_core_dev *dev)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	int err;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
@@ -945,6 +977,11 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 			      err);
 }
 
+struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev)
+{
+	return &dev->priv.eq_table->async_eq;
+}
+
 /* Completion EQs */
 
 static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
@@ -952,7 +989,7 @@ static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	struct mlx5_priv *priv  = &mdev->priv;
 	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
 	int irq = pci_irq_vector(mdev->pdev, vecidx);
-	struct mlx5_irq_info *irq_info = &priv->eq_table.irq_info[vecidx];
+	struct mlx5_irq_info *irq_info = &priv->eq_table->irq_info[vecidx];
 
 	if (!zalloc_cpumask_var(&irq_info->mask, GFP_KERNEL)) {
 		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
@@ -974,7 +1011,7 @@ static void clear_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
 	struct mlx5_priv *priv  = &mdev->priv;
 	int irq = pci_irq_vector(mdev->pdev, vecidx);
-	struct mlx5_irq_info *irq_info = &priv->eq_table.irq_info[vecidx];
+	struct mlx5_irq_info *irq_info = &priv->eq_table->irq_info[vecidx];
 
 	irq_set_affinity_hint(irq, NULL);
 	free_cpumask_var(irq_info->mask);
@@ -985,7 +1022,7 @@ static int set_comp_irq_affinity_hints(struct mlx5_core_dev *mdev)
 	int err;
 	int i;
 
-	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++) {
+	for (i = 0; i < mdev->priv.eq_table->num_comp_vectors; i++) {
 		err = set_comp_irq_affinity_hint(mdev, i);
 		if (err)
 			goto err_out;
@@ -1004,13 +1041,13 @@ static void clear_comp_irqs_affinity_hints(struct mlx5_core_dev *mdev)
 {
 	int i;
 
-	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++)
+	for (i = 0; i < mdev->priv.eq_table->num_comp_vectors; i++)
 		clear_comp_irq_affinity_hint(mdev, i);
 }
 
 static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	struct mlx5_eq *eq, *n;
 
 	clear_comp_irqs_affinity_hints(dev);
@@ -1032,7 +1069,7 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 
 static int create_comp_eqs(struct mlx5_core_dev *dev)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	char name[MLX5_MAX_IRQ_NAME];
 	struct mlx5_eq *eq;
 	int ncomp_vec;
@@ -1088,7 +1125,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 		    unsigned int *irqn)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	struct mlx5_eq *eq, *n;
 	int err = -ENOENT;
 	int i = 0;
@@ -1106,9 +1143,32 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 }
 EXPORT_SYMBOL(mlx5_vector2eqn);
 
+unsigned int mlx5_comp_vectors_count(struct mlx5_core_dev *dev)
+{
+	return dev->priv.eq_table->num_comp_vectors;
+}
+EXPORT_SYMBOL(mlx5_comp_vectors_count);
+
+struct cpumask *
+mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
+{
+	/* TODO: consider irq_get_affinity_mask(irq) */
+	return dev->priv.eq_table->irq_info[vector + MLX5_EQ_VEC_COMP_BASE].mask;
+}
+EXPORT_SYMBOL(mlx5_comp_irq_get_affinity_mask);
+
+struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev)
+{
+#ifdef CONFIG_RFS_ACCEL
+	return dev->priv.eq_table->rmap;
+#else
+	return NULL;
+#endif
+}
+
 struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	struct mlx5_eq *eq;
 
 	list_for_each_entry(eq, &table->comp_eqs_list, list) {
@@ -1122,7 +1182,7 @@ struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 {
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq_table *table = dev->priv.eq_table;
 	struct mlx5_eq *eq;
 
 	clear_comp_irqs_affinity_hints(dev);
@@ -1149,7 +1209,7 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 static int alloc_irq_vectors(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
-	struct mlx5_eq_table *table = &priv->eq_table;
+	struct mlx5_eq_table *table = priv->eq_table;
 	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
@@ -1187,7 +1247,7 @@ static void free_irq_vectors(struct mlx5_core_dev *dev)
 	struct mlx5_priv *priv = &dev->priv;
 
 	pci_free_irq_vectors(dev->pdev);
-	kfree(priv->eq_table.irq_info);
+	kfree(priv->eq_table->irq_info);
 }
 
 int mlx5_eq_table_create(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d004957328f9..324606227b1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -38,6 +38,7 @@
 #include "mlx5_core.h"
 #include "eswitch.h"
 #include "fs_core.h"
+#include "lib/eq.h"
 
 #define UPLINK_VPORT 0xFFFF
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 43118de8ee99..b5be6f0b9ed5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -38,6 +38,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
+#include "lib/eq.h"
 
 enum {
 	MLX5_HEALTH_POLL_INTERVAL	= 2 * HZ,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
new file mode 100644
index 000000000000..48ee37797b3f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2018 Mellanox Technologies */
+
+#ifndef __LIB_MLX5_EQ_H__
+#define __LIB_MLX5_EQ_H__
+#include <linux/mlx5/driver.h>
+
+#define MLX5_MAX_IRQ_NAME       (32)
+
+enum {
+	MLX5_EQ_VEC_PAGES	 = 0,
+	MLX5_EQ_VEC_CMD		 = 1,
+	MLX5_EQ_VEC_ASYNC	 = 2,
+	MLX5_EQ_VEC_PFAULT	 = 3,
+	MLX5_EQ_VEC_COMP_BASE,
+};
+
+struct mlx5_eq_tasklet {
+	struct list_head      list;
+	struct list_head      process_list;
+	struct tasklet_struct task;
+	spinlock_t            lock; /* lock completion tasklet list */
+};
+
+struct mlx5_eq_pagefault {
+	struct work_struct       work;
+	spinlock_t               lock; /* Pagefaults spinlock */
+	struct workqueue_struct  *wq;
+	mempool_t                *pool;
+};
+
+struct mlx5_cq_table {
+	spinlock_t              lock;	/* protect radix tree */
+	struct radix_tree_root  tree;
+};
+
+struct mlx5_eq {
+	struct mlx5_core_dev    *dev;
+	struct mlx5_cq_table    cq_table;
+	__be32 __iomem	        *doorbell;
+	u32                     cons_index;
+	struct mlx5_frag_buf    buf;
+	int                     size;
+	unsigned int            irqn;
+	u8                      eqn;
+	int                     nent;
+	struct list_head        list;
+	struct mlx5_rsc_debug   *dbg;
+	enum mlx5_eq_type       type;
+	union {
+		struct mlx5_eq_tasklet   tasklet_ctx;
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+		struct mlx5_eq_pagefault pf_ctx;
+#endif
+	};
+};
+
+int mlx5_eq_table_init(struct mlx5_core_dev *dev);
+void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev);
+int mlx5_eq_table_create(struct mlx5_core_dev *dev);
+void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
+int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
+int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
+struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn);
+struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev);
+u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq *eq);
+void mlx5_cq_tasklet_cb(unsigned long data);
+struct cpumask *mlx5_eq_comp_cpumask(struct mlx5_core_dev *dev, int ix);
+
+/* This function should only be called after mlx5_cmd_force_teardown_hca */
+void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
+
+#ifdef CONFIG_RFS_ACCEL
+struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev);
+#endif
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 21cc9bbc2563..5d11ef92c8b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -54,6 +54,7 @@
 #include <net/devlink.h>
 #include "mlx5_core.h"
 #include "fs_core.h"
+#include "lib/eq.h"
 #include "lib/mpfs.h"
 #include "eswitch.h"
 #include "lib/mlx5.h"
@@ -728,7 +729,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 		goto out;
 	}
 
-	err = mlx5_eq_init(dev);
+	err = mlx5_eq_table_init(dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to initialize eq\n");
 		goto out;
@@ -802,7 +803,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 	mlx5_cq_debugfs_cleanup(dev);
 
 err_eq_cleanup:
-	mlx5_eq_cleanup(dev);
+	mlx5_eq_table_cleanup(dev);
 
 out:
 	return err;
@@ -823,7 +824,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_srq_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
-	mlx5_eq_cleanup(dev);
+	mlx5_eq_table_cleanup(dev);
 }
 
 static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 3fa6d26875fe..4d39adcfb0eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -124,21 +124,6 @@ int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev);
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev);
 
-int mlx5_eq_init(struct mlx5_core_dev *dev);
-void mlx5_eq_cleanup(struct mlx5_core_dev *dev);
-int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
-		       int nent, u64 mask, const char *name,
-		       enum mlx5_eq_type type);
-int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
-int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
-int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
-int mlx5_eq_table_create(struct mlx5_core_dev *dev);
-void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
-/* This function should only be called after mlx5_cmd_force_teardown_hca */
-void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
-struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn);
-u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq *eq);
-void mlx5_cq_tasklet_cb(unsigned long data);
 void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced);
 int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
 void mlx5_debug_eq_remove(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index dcc3f7aa8572..4d6246cb6c19 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -84,18 +84,6 @@ enum {
 	MLX5_MAX_PORTS	= 2,
 };
 
-enum {
-	MLX5_EQ_VEC_PAGES	 = 0,
-	MLX5_EQ_VEC_CMD		 = 1,
-	MLX5_EQ_VEC_ASYNC	 = 2,
-	MLX5_EQ_VEC_PFAULT	 = 3,
-	MLX5_EQ_VEC_COMP_BASE,
-};
-
-enum {
-	MLX5_MAX_IRQ_NAME	= 32
-};
-
 enum {
 	MLX5_ATOMIC_MODE_OFFSET = 16,
 	MLX5_ATOMIC_MODE_IB_COMP = 1,
@@ -366,49 +354,6 @@ struct mlx5_frag_buf_ctrl {
 	u8			log_frag_strides;
 };
 
-struct mlx5_eq_tasklet {
-	struct list_head list;
-	struct list_head process_list;
-	struct tasklet_struct task;
-	/* lock on completion tasklet list */
-	spinlock_t lock;
-};
-
-struct mlx5_eq_pagefault {
-	struct work_struct       work;
-	/* Pagefaults lock */
-	spinlock_t		 lock;
-	struct workqueue_struct *wq;
-	mempool_t		*pool;
-};
-
-struct mlx5_cq_table {
-	/* protect radix tree */
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
-};
-
-struct mlx5_eq {
-	struct mlx5_core_dev   *dev;
-	struct mlx5_cq_table	cq_table;
-	__be32 __iomem	       *doorbell;
-	u32			cons_index;
-	struct mlx5_frag_buf	buf;
-	int			size;
-	unsigned int		irqn;
-	u8			eqn;
-	int			nent;
-	struct list_head	list;
-	struct mlx5_rsc_debug	*dbg;
-	enum mlx5_eq_type	type;
-	union {
-		struct mlx5_eq_tasklet   tasklet_ctx;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-		struct mlx5_eq_pagefault pf_ctx;
-#endif
-	};
-};
-
 struct mlx5_core_psv {
 	u32	psv_idx;
 	struct psv_layout {
@@ -475,21 +420,6 @@ struct mlx5_core_srq {
 	u16		uid;
 };
 
-struct mlx5_eq_table {
-	struct list_head	comp_eqs_list;
-	struct mlx5_eq		pages_eq;
-	struct mlx5_eq		async_eq;
-	struct mlx5_eq		cmd_eq;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	struct mlx5_eq		pfault_eq;
-#endif
-	int			num_comp_vectors;
-	struct mlx5_irq_info	*irq_info;
-#ifdef CONFIG_RFS_ACCEL
-	struct cpu_rmap         *rmap;
-#endif
-};
-
 struct mlx5_uars_page {
 	void __iomem	       *map;
 	bool			wc;
@@ -572,11 +502,6 @@ struct mlx5_core_sriov {
 	int			enabled_vfs;
 };
 
-struct mlx5_irq_info {
-	cpumask_var_t mask;
-	char name[MLX5_MAX_IRQ_NAME];
-};
-
 struct mlx5_fc_stats {
 	spinlock_t counters_idr_lock; /* protects counters_idr */
 	struct idr counters_idr;
@@ -594,6 +519,7 @@ struct mlx5_mpfs;
 struct mlx5_eswitch;
 struct mlx5_lag;
 struct mlx5_pagefault;
+struct mlx5_eq_table;
 
 struct mlx5_rate_limit {
 	u32			rate;
@@ -643,7 +569,7 @@ struct mlx5_port_module_event_stats {
 
 struct mlx5_priv {
 	char			name[MLX5_MAX_NAME_LEN];
-	struct mlx5_eq_table	eq_table;
+	struct mlx5_eq_table	*eq_table;
 
 	/* pages stuff */
 	struct workqueue_struct *pg_wq;
@@ -1148,6 +1074,9 @@ int mlx5_alloc_bfreg(struct mlx5_core_dev *mdev, struct mlx5_sq_bfreg *bfreg,
 		     bool map_wc, bool fast_path);
 void mlx5_free_bfreg(struct mlx5_core_dev *mdev, struct mlx5_sq_bfreg *bfreg);
 
+unsigned int mlx5_comp_vectors_count(struct mlx5_core_dev *dev);
+struct cpumask *
+mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector);
 unsigned int mlx5_core_reserved_gids_count(struct mlx5_core_dev *dev);
 int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 			   u8 roce_version, u8 roce_l3_type, const u8 *gid,
@@ -1299,10 +1228,4 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
 
-static inline const struct cpumask *
-mlx5_get_vector_affinity_hint(struct mlx5_core_dev *dev, int vector)
-{
-	return dev->priv.eq_table.irq_info[vector + MLX5_EQ_VEC_COMP_BASE].mask;
-}
-
 #endif /* MLX5_DRIVER_H */
-- 
2.19.1
