From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 05/12] net/mlx5: EQ, Move all EQ logic to eq.c
Date: Mon, 19 Nov 2018 10:52:35 -0800
Message-ID: <20181119185242.21961-6-saeedm@mellanox.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Move completion EQs flows from main.c to eq.c, reasons:
1) It is where this logic belongs.
2) It will help centralize the EQ logic in one file for downstream
refactoring, and future extensions/updates.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 176 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 179 +-----------------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 3 files changed, 181 insertions(+), 176 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index e75272503027..4d79a4ccb758 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -820,6 +820,8 @@ void mlx5_eq_cleanup(struct mlx5_core_dev *dev)
 	mlx5_eq_debugfs_cleanup(dev);
 }
 
+/* Async EQs */
+
 int mlx5_start_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
@@ -953,12 +955,186 @@ int mlx5_core_eq_query(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
 
+/* Completion EQs */
+
+static int mlx5_irq_set_affinity_hint(struct mlx5_core_dev *mdev, int i)
+{
+	struct mlx5_priv *priv  = &mdev->priv;
+	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
+	int irq = pci_irq_vector(mdev->pdev, vecidx);
+
+	if (!zalloc_cpumask_var(&priv->irq_info[vecidx].mask, GFP_KERNEL)) {
+		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
+		return -ENOMEM;
+	}
+
+	cpumask_set_cpu(cpumask_local_spread(i, priv->numa_node),
+			priv->irq_info[vecidx].mask);
+
+	if (IS_ENABLED(CONFIG_SMP) &&
+	    irq_set_affinity_hint(irq, priv->irq_info[vecidx].mask))
+		mlx5_core_warn(mdev, "irq_set_affinity_hint failed, irq 0x%.4x", irq);
+
+	return 0;
+}
+
+static void mlx5_irq_clear_affinity_hint(struct mlx5_core_dev *mdev, int i)
+{
+	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
+	struct mlx5_priv *priv  = &mdev->priv;
+	int irq = pci_irq_vector(mdev->pdev, vecidx);
+
+	irq_set_affinity_hint(irq, NULL);
+	free_cpumask_var(priv->irq_info[vecidx].mask);
+}
+
+static int mlx5_irq_set_affinity_hints(struct mlx5_core_dev *mdev)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++) {
+		err = mlx5_irq_set_affinity_hint(mdev, i);
+		if (err)
+			goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	for (i--; i >= 0; i--)
+		mlx5_irq_clear_affinity_hint(mdev, i);
+
+	return err;
+}
+
+static void mlx5_irq_clear_affinity_hints(struct mlx5_core_dev *mdev)
+{
+	int i;
+
+	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++)
+		mlx5_irq_clear_affinity_hint(mdev, i);
+}
+
+void mlx5_free_comp_eqs(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq *eq, *n;
+
+	mlx5_irq_clear_affinity_hints(dev);
+
+#ifdef CONFIG_RFS_ACCEL
+	if (dev->rmap) {
+		free_irq_cpu_rmap(dev->rmap);
+		dev->rmap = NULL;
+	}
+#endif
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+		list_del(&eq->list);
+		if (mlx5_destroy_unmap_eq(dev, eq))
+			mlx5_core_warn(dev, "failed to destroy EQ 0x%x\n",
+				       eq->eqn);
+		kfree(eq);
+	}
+}
+
+int mlx5_alloc_comp_eqs(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	char name[MLX5_MAX_IRQ_NAME];
+	struct mlx5_eq *eq;
+	int ncomp_vec;
+	int nent;
+	int err;
+	int i;
+
+	INIT_LIST_HEAD(&table->comp_eqs_list);
+	ncomp_vec = table->num_comp_vectors;
+	nent = MLX5_COMP_EQ_SIZE;
+#ifdef CONFIG_RFS_ACCEL
+	dev->rmap = alloc_irq_cpu_rmap(ncomp_vec);
+	if (!dev->rmap)
+		return -ENOMEM;
+#endif
+	for (i = 0; i < ncomp_vec; i++) {
+		int vecidx = i + MLX5_EQ_VEC_COMP_BASE;
+
+		eq = kzalloc(sizeof(*eq), GFP_KERNEL);
+		if (!eq) {
+			err = -ENOMEM;
+			goto clean;
+		}
+
+#ifdef CONFIG_RFS_ACCEL
+		irq_cpu_rmap_add(dev->rmap, pci_irq_vector(dev->pdev, vecidx));
+#endif
+		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", i);
+		err = mlx5_create_map_eq(dev, eq, vecidx, nent, 0,
+					 name, MLX5_EQ_TYPE_COMP);
+		if (err) {
+			kfree(eq);
+			goto clean;
+		}
+		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->eqn);
+		/* add tail, to keep the list ordered, for mlx5_vector2eqn to work */
+		list_add_tail(&eq->list, &table->comp_eqs_list);
+	}
+
+	err = mlx5_irq_set_affinity_hints(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to alloc affinity hint cpumask\n");
+		goto clean;
+	}
+
+	return 0;
+
+clean:
+	mlx5_free_comp_eqs(dev);
+	return err;
+}
+
+int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
+		    unsigned int *irqn)
+{
+	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq *eq, *n;
+	int err = -ENOENT;
+	int i = 0;
+
+	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+		if (i++ == vector) {
+			*eqn = eq->eqn;
+			*irqn = eq->irqn;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(mlx5_vector2eqn);
+
+struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
+{
+	struct mlx5_eq_table *table = &dev->priv.eq_table;
+	struct mlx5_eq *eq;
+
+	list_for_each_entry(eq, &table->comp_eqs_list, list) {
+		if (eq->eqn == eqn)
+			return eq;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	struct mlx5_eq *eq;
 
+	mlx5_irq_clear_affinity_hints(dev);
+
 #ifdef CONFIG_RFS_ACCEL
 	if (dev->rmap) {
 		free_irq_cpu_rmap(dev->rmap);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f692c2a42130..244fec4b2ef2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -637,168 +637,6 @@ u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev)
 	return (u64)timer_l | (u64)timer_h1 << 32;
 }
 
-static int mlx5_irq_set_affinity_hint(struct mlx5_core_dev *mdev, int i)
-{
-	struct mlx5_priv *priv  = &mdev->priv;
-	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
-	int irq = pci_irq_vector(mdev->pdev, vecidx);
-
-	if (!zalloc_cpumask_var(&priv->irq_info[vecidx].mask, GFP_KERNEL)) {
-		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
-		return -ENOMEM;
-	}
-
-	cpumask_set_cpu(cpumask_local_spread(i, priv->numa_node),
-			priv->irq_info[vecidx].mask);
-
-	if (IS_ENABLED(CONFIG_SMP) &&
-	    irq_set_affinity_hint(irq, priv->irq_info[vecidx].mask))
-		mlx5_core_warn(mdev, "irq_set_affinity_hint failed, irq 0x%.4x", irq);
-
-	return 0;
-}
-
-static void mlx5_irq_clear_affinity_hint(struct mlx5_core_dev *mdev, int i)
-{
-	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
-	struct mlx5_priv *priv  = &mdev->priv;
-	int irq = pci_irq_vector(mdev->pdev, vecidx);
-
-	irq_set_affinity_hint(irq, NULL);
-	free_cpumask_var(priv->irq_info[vecidx].mask);
-}
-
-static int mlx5_irq_set_affinity_hints(struct mlx5_core_dev *mdev)
-{
-	int err;
-	int i;
-
-	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++) {
-		err = mlx5_irq_set_affinity_hint(mdev, i);
-		if (err)
-			goto err_out;
-	}
-
-	return 0;
-
-err_out:
-	for (i--; i >= 0; i--)
-		mlx5_irq_clear_affinity_hint(mdev, i);
-
-	return err;
-}
-
-static void mlx5_irq_clear_affinity_hints(struct mlx5_core_dev *mdev)
-{
-	int i;
-
-	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++)
-		mlx5_irq_clear_affinity_hint(mdev, i);
-}
-
-int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
-		    unsigned int *irqn)
-{
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
-	struct mlx5_eq *eq, *n;
-	int err = -ENOENT;
-	int i = 0;
-
-	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
-		if (i++ == vector) {
-			*eqn = eq->eqn;
-			*irqn = eq->irqn;
-			err = 0;
-			break;
-		}
-	}
-
-	return err;
-}
-EXPORT_SYMBOL(mlx5_vector2eqn);
-
-struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
-{
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
-	struct mlx5_eq *eq;
-
-	list_for_each_entry(eq, &table->comp_eqs_list, list) {
-		if (eq->eqn == eqn)
-			return eq;
-	}
-
-
-	return ERR_PTR(-ENOENT);
-}
-
-static void free_comp_eqs(struct mlx5_core_dev *dev)
-{
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
-	struct mlx5_eq *eq, *n;
-
-#ifdef CONFIG_RFS_ACCEL
-	if (dev->rmap) {
-		free_irq_cpu_rmap(dev->rmap);
-		dev->rmap = NULL;
-	}
-#endif
-	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
-		list_del(&eq->list);
-		if (mlx5_destroy_unmap_eq(dev, eq))
-			mlx5_core_warn(dev, "failed to destroy EQ 0x%x\n",
-				       eq->eqn);
-		kfree(eq);
-	}
-}
-
-static int alloc_comp_eqs(struct mlx5_core_dev *dev)
-{
-	struct mlx5_eq_table *table = &dev->priv.eq_table;
-	char name[MLX5_MAX_IRQ_NAME];
-	struct mlx5_eq *eq;
-	int ncomp_vec;
-	int nent;
-	int err;
-	int i;
-
-	INIT_LIST_HEAD(&table->comp_eqs_list);
-	ncomp_vec = table->num_comp_vectors;
-	nent = MLX5_COMP_EQ_SIZE;
-#ifdef CONFIG_RFS_ACCEL
-	dev->rmap = alloc_irq_cpu_rmap(ncomp_vec);
-	if (!dev->rmap)
-		return -ENOMEM;
-#endif
-	for (i = 0; i < ncomp_vec; i++) {
-		eq = kzalloc(sizeof(*eq), GFP_KERNEL);
-		if (!eq) {
-			err = -ENOMEM;
-			goto clean;
-		}
-
-#ifdef CONFIG_RFS_ACCEL
-		irq_cpu_rmap_add(dev->rmap, pci_irq_vector(dev->pdev,
-				 MLX5_EQ_VEC_COMP_BASE + i));
-#endif
-		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", i);
-		err = mlx5_create_map_eq(dev, eq,
-					 i + MLX5_EQ_VEC_COMP_BASE, nent, 0,
-					 name, MLX5_EQ_TYPE_COMP);
-		if (err) {
-			kfree(eq);
-			goto clean;
-		}
-		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->eqn);
-		list_add_tail(&eq->list, &table->comp_eqs_list);
-	}
-
-	return 0;
-
-clean:
-	free_comp_eqs(dev);
-	return err;
-}
-
 static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 {
 	u32 query_in[MLX5_ST_SZ_DW(query_issi_in)]   = {0};
@@ -1177,18 +1015,12 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_fw_tracer;
 	}
 
-	err = alloc_comp_eqs(dev);
+	err = mlx5_alloc_comp_eqs(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to alloc completion EQs\n");
 		goto err_comp_eqs;
 	}
 
-	err = mlx5_irq_set_affinity_hints(dev);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to alloc affinity hint cpumask\n");
-		goto err_affinity_hints;
-	}
-
 	err = mlx5_fpga_device_start(dev);
 	if (err) {
 		dev_err(&pdev->dev, "fpga device start failed %d\n", err);
@@ -1257,10 +1089,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_fpga_device_stop(dev);
 
 err_fpga_start:
-	mlx5_irq_clear_affinity_hints(dev);
-
-err_affinity_hints:
-	free_comp_eqs(dev);
+	mlx5_free_comp_eqs(dev);
 
 err_comp_eqs:
 	mlx5_fw_tracer_cleanup(dev->tracer);
@@ -1331,8 +1160,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
-	mlx5_irq_clear_affinity_hints(dev);
-	free_comp_eqs(dev);
+	mlx5_free_comp_eqs(dev);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_stop_eqs(dev);
 	mlx5_put_uars_page(dev, priv->uar);
@@ -1628,7 +1456,6 @@ static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 	 * kexec. There is no need to cleanup the mlx5_core software
 	 * contexts.
 	 */
-	mlx5_irq_clear_affinity_hints(dev);
 	mlx5_core_eq_free_irqs(dev);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 0594d0961cb3..22cff00faa5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -136,6 +136,8 @@ int mlx5_core_eq_query(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 		       u32 *out, int outlen);
 int mlx5_start_eqs(struct mlx5_core_dev *dev);
 void mlx5_stop_eqs(struct mlx5_core_dev *dev);
+int mlx5_alloc_comp_eqs(struct mlx5_core_dev *dev);
+void mlx5_free_comp_eqs(struct mlx5_core_dev *dev);
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn);
-- 
2.19.1
