From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/12] net/mlx5: EQ, irq_info and rmap belong to eq_table
Date: Fri, 16 Nov 2018 13:58:56 -0800
Message-ID: <20181116215901.5874-8-saeedm@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

irq_info and rmap are EQ properties of the driver, and only needed for
EQ objects, move them to the eq_table EQs database structure.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 40 ++++++++++---------
 include/linux/mlx5/driver.h                   | 10 ++---
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2839c30dd3a0..32ea47c28324 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1760,7 +1760,7 @@ static void mlx5e_close_cq(struct mlx5e_cq *cq)
 
 static int mlx5e_get_cpu(struct mlx5e_priv *priv, int ix)
 {
-	return cpumask_first(priv->mdev->priv.irq_info[ix + MLX5_EQ_VEC_COMP_BASE].mask);
+	return cpumask_first(priv->mdev->priv.eq_table.irq_info[ix + MLX5_EQ_VEC_COMP_BASE].mask);
 }
 
 static int mlx5e_open_tx_cqs(struct mlx5e_channel *c,
@@ -4960,7 +4960,7 @@ int mlx5e_netdev_init(struct net_device *netdev,
 	netif_carrier_off(netdev);
 
 #ifdef CONFIG_MLX5_EN_ARFS
-	netdev->rx_cpu_rmap = mdev->rmap;
+	netdev->rx_cpu_rmap = mdev->priv.eq_table.rmap;
 #endif
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 44ccd4206104..70f62f10065e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -694,7 +694,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	if (err)
 		goto err_in;
 
-	snprintf(priv->irq_info[vecidx].name, MLX5_MAX_IRQ_NAME, "%s@pci:%s",
+	snprintf(priv->eq_table.irq_info[vecidx].name, MLX5_MAX_IRQ_NAME, "%s@pci:%s",
 		 name, pci_name(dev->pdev));
 
 	eq->eqn = MLX5_GET(create_eq_out, out, eq_number);
@@ -702,7 +702,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	eq->dev = dev;
 	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBEL_OFFSET;
 	err = request_irq(eq->irqn, handler, 0,
-			  priv->irq_info[vecidx].name, eq);
+			  priv->eq_table.irq_info[vecidx].name, eq);
 	if (err)
 		goto err_eq;
 
@@ -952,17 +952,18 @@ static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	struct mlx5_priv *priv  = &mdev->priv;
 	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
 	int irq = pci_irq_vector(mdev->pdev, vecidx);
+	struct mlx5_irq_info *irq_info = &priv->eq_table.irq_info[vecidx];
 
-	if (!zalloc_cpumask_var(&priv->irq_info[vecidx].mask, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&irq_info->mask, GFP_KERNEL)) {
 		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
 		return -ENOMEM;
 	}
 
 	cpumask_set_cpu(cpumask_local_spread(i, priv->numa_node),
-			priv->irq_info[vecidx].mask);
+			irq_info->mask);
 
 	if (IS_ENABLED(CONFIG_SMP) &&
-	    irq_set_affinity_hint(irq, priv->irq_info[vecidx].mask))
+	    irq_set_affinity_hint(irq, irq_info->mask))
 		mlx5_core_warn(mdev, "irq_set_affinity_hint failed, irq 0x%.4x", irq);
 
 	return 0;
@@ -973,9 +974,10 @@ static void clear_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
 	struct mlx5_priv *priv  = &mdev->priv;
 	int irq = pci_irq_vector(mdev->pdev, vecidx);
+	struct mlx5_irq_info *irq_info = &priv->eq_table.irq_info[vecidx];
 
 	irq_set_affinity_hint(irq, NULL);
-	free_cpumask_var(priv->irq_info[vecidx].mask);
+	free_cpumask_var(irq_info->mask);
 }
 
 static int set_comp_irq_affinity_hints(struct mlx5_core_dev *mdev)
@@ -1014,9 +1016,9 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 	clear_comp_irqs_affinity_hints(dev);
 
 #ifdef CONFIG_RFS_ACCEL
-	if (dev->rmap) {
-		free_irq_cpu_rmap(dev->rmap);
-		dev->rmap = NULL;
+	if (table->rmap) {
+		free_irq_cpu_rmap(table->rmap);
+		table->rmap = NULL;
 	}
 #endif
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
@@ -1042,8 +1044,8 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 	ncomp_vec = table->num_comp_vectors;
 	nent = MLX5_COMP_EQ_SIZE;
 #ifdef CONFIG_RFS_ACCEL
-	dev->rmap = alloc_irq_cpu_rmap(ncomp_vec);
-	if (!dev->rmap)
+	table->rmap = alloc_irq_cpu_rmap(ncomp_vec);
+	if (!table->rmap)
 		return -ENOMEM;
 #endif
 	for (i = 0; i < ncomp_vec; i++) {
@@ -1056,7 +1058,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		}
 
 #ifdef CONFIG_RFS_ACCEL
-		irq_cpu_rmap_add(dev->rmap, pci_irq_vector(dev->pdev, vecidx));
+		irq_cpu_rmap_add(table->rmap, pci_irq_vector(dev->pdev, vecidx));
 #endif
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", i);
 		err = mlx5_create_map_eq(dev, eq, vecidx, nent, 0,
@@ -1126,9 +1128,9 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 	clear_comp_irqs_affinity_hints(dev);
 
 #ifdef CONFIG_RFS_ACCEL
-	if (dev->rmap) {
-		free_irq_cpu_rmap(dev->rmap);
-		dev->rmap = NULL;
+	if (table->rmap) {
+		free_irq_cpu_rmap(table->rmap);
+		table->rmap = NULL;
 	}
 #endif
 	list_for_each_entry(eq, &table->comp_eqs_list, list)
@@ -1160,8 +1162,8 @@ static int alloc_irq_vectors(struct mlx5_core_dev *dev)
 	if (nvec <= MLX5_EQ_VEC_COMP_BASE)
 		return -ENOMEM;
 
-	priv->irq_info = kcalloc(nvec, sizeof(*priv->irq_info), GFP_KERNEL);
-	if (!priv->irq_info)
+	table->irq_info = kcalloc(nvec, sizeof(*table->irq_info), GFP_KERNEL);
+	if (!table->irq_info)
 		return -ENOMEM;
 
 	nvec = pci_alloc_irq_vectors(dev->pdev, MLX5_EQ_VEC_COMP_BASE + 1,
@@ -1176,7 +1178,7 @@ static int alloc_irq_vectors(struct mlx5_core_dev *dev)
 	return 0;
 
 err_free_irq_info:
-	kfree(priv->irq_info);
+	kfree(table->irq_info);
 	return err;
 }
 
@@ -1185,7 +1187,7 @@ static void free_irq_vectors(struct mlx5_core_dev *dev)
 	struct mlx5_priv *priv = &dev->priv;
 
 	pci_free_irq_vectors(dev->pdev);
-	kfree(priv->irq_info);
+	kfree(priv->eq_table.irq_info);
 }
 
 int mlx5_eq_table_create(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 852e397c7624..dcc3f7aa8572 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -484,6 +484,10 @@ struct mlx5_eq_table {
 	struct mlx5_eq		pfault_eq;
 #endif
 	int			num_comp_vectors;
+	struct mlx5_irq_info	*irq_info;
+#ifdef CONFIG_RFS_ACCEL
+	struct cpu_rmap         *rmap;
+#endif
 };
 
 struct mlx5_uars_page {
@@ -640,7 +644,6 @@ struct mlx5_port_module_event_stats {
 struct mlx5_priv {
 	char			name[MLX5_MAX_NAME_LEN];
 	struct mlx5_eq_table	eq_table;
-	struct mlx5_irq_info	*irq_info;
 
 	/* pages stuff */
 	struct workqueue_struct *pg_wq;
@@ -851,9 +854,6 @@ struct mlx5_core_dev {
 	} roce;
 #ifdef CONFIG_MLX5_FPGA
 	struct mlx5_fpga_device *fpga;
-#endif
-#ifdef CONFIG_RFS_ACCEL
-	struct cpu_rmap         *rmap;
 #endif
 	struct mlx5_clock        clock;
 	struct mlx5_ib_clock_info  *clock_info;
@@ -1302,7 +1302,7 @@ enum {
 static inline const struct cpumask *
 mlx5_get_vector_affinity_hint(struct mlx5_core_dev *dev, int vector)
 {
-	return dev->priv.irq_info[vector + MLX5_EQ_VEC_COMP_BASE].mask;
+	return dev->priv.eq_table.irq_info[vector + MLX5_EQ_VEC_COMP_BASE].mask;
 }
 
 #endif /* MLX5_DRIVER_H */
-- 
2.19.1
