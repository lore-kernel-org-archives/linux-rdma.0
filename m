From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/12] net/mlx5: EQ, Create all EQs in one place
Date: Fri, 16 Nov 2018 13:58:55 -0800
Message-ID: <20181116215901.5874-7-saeedm@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Instead of creating the EQ table in three steps at driver load,
 - allocate irq vectors
 - allocate async EQs
 - allocate completion EQs
Gather all of the procedures into one function in eq.c and call it from
driver load.

This will help us reduce the EQ and EQ table private structures
visibility to eq.c in downstream refactoring.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  10 ++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 121 ++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/main.c    |  81 ++----------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   8 +-
 4 files changed, 116 insertions(+), 104 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 90fabd612b6c..b76766fb6c67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -349,6 +349,16 @@ static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 	return param;
 }
 
+static int mlx5_core_eq_query(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
+			      u32 *out, int outlen)
+{
+	u32 in[MLX5_ST_SZ_DW(query_eq_in)] = {};
+
+	MLX5_SET(query_eq_in, in, opcode, MLX5_CMD_OP_QUERY_EQ);
+	MLX5_SET(query_eq_in, in, eq_number, eq->eqn);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+}
+
 static u64 eq_read_field(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 			 int index)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 4d79a4ccb758..44ccd4206104 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -822,7 +822,7 @@ void mlx5_eq_cleanup(struct mlx5_core_dev *dev)
 
 /* Async EQs */
 
-int mlx5_start_eqs(struct mlx5_core_dev *dev)
+static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	u64 async_event_mask = MLX5_ASYNC_EVENT_MASK;
@@ -914,7 +914,7 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 	return err;
 }
 
-void mlx5_stop_eqs(struct mlx5_core_dev *dev)
+static void destroy_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	int err;
@@ -945,19 +945,9 @@ void mlx5_stop_eqs(struct mlx5_core_dev *dev)
 			      err);
 }
 
-int mlx5_core_eq_query(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
-		       u32 *out, int outlen)
-{
-	u32 in[MLX5_ST_SZ_DW(query_eq_in)] = {0};
-
-	MLX5_SET(query_eq_in, in, opcode, MLX5_CMD_OP_QUERY_EQ);
-	MLX5_SET(query_eq_in, in, eq_number, eq->eqn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
-}
-
 /* Completion EQs */
 
-static int mlx5_irq_set_affinity_hint(struct mlx5_core_dev *mdev, int i)
+static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 {
 	struct mlx5_priv *priv  = &mdev->priv;
 	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
@@ -978,7 +968,7 @@ static int mlx5_irq_set_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	return 0;
 }
 
-static void mlx5_irq_clear_affinity_hint(struct mlx5_core_dev *mdev, int i)
+static void clear_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
 {
 	int vecidx = MLX5_EQ_VEC_COMP_BASE + i;
 	struct mlx5_priv *priv  = &mdev->priv;
@@ -988,13 +978,13 @@ static void mlx5_irq_clear_affinity_hint(struct mlx5_core_dev *mdev, int i)
 	free_cpumask_var(priv->irq_info[vecidx].mask);
 }
 
-static int mlx5_irq_set_affinity_hints(struct mlx5_core_dev *mdev)
+static int set_comp_irq_affinity_hints(struct mlx5_core_dev *mdev)
 {
 	int err;
 	int i;
 
 	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++) {
-		err = mlx5_irq_set_affinity_hint(mdev, i);
+		err = set_comp_irq_affinity_hint(mdev, i);
 		if (err)
 			goto err_out;
 	}
@@ -1003,25 +993,25 @@ static int mlx5_irq_set_affinity_hints(struct mlx5_core_dev *mdev)
 
 err_out:
 	for (i--; i >= 0; i--)
-		mlx5_irq_clear_affinity_hint(mdev, i);
+		clear_comp_irq_affinity_hint(mdev, i);
 
 	return err;
 }
 
-static void mlx5_irq_clear_affinity_hints(struct mlx5_core_dev *mdev)
+static void clear_comp_irqs_affinity_hints(struct mlx5_core_dev *mdev)
 {
 	int i;
 
 	for (i = 0; i < mdev->priv.eq_table.num_comp_vectors; i++)
-		mlx5_irq_clear_affinity_hint(mdev, i);
+		clear_comp_irq_affinity_hint(mdev, i);
 }
 
-void mlx5_free_comp_eqs(struct mlx5_core_dev *dev)
+static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	struct mlx5_eq *eq, *n;
 
-	mlx5_irq_clear_affinity_hints(dev);
+	clear_comp_irqs_affinity_hints(dev);
 
 #ifdef CONFIG_RFS_ACCEL
 	if (dev->rmap) {
@@ -1038,7 +1028,7 @@ void mlx5_free_comp_eqs(struct mlx5_core_dev *dev)
 	}
 }
 
-int mlx5_alloc_comp_eqs(struct mlx5_core_dev *dev)
+static int create_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	char name[MLX5_MAX_IRQ_NAME];
@@ -1080,7 +1070,7 @@ int mlx5_alloc_comp_eqs(struct mlx5_core_dev *dev)
 		list_add_tail(&eq->list, &table->comp_eqs_list);
 	}
 
-	err = mlx5_irq_set_affinity_hints(dev);
+	err = set_comp_irq_affinity_hints(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to alloc affinity hint cpumask\n");
 		goto clean;
@@ -1089,7 +1079,7 @@ int mlx5_alloc_comp_eqs(struct mlx5_core_dev *dev)
 	return 0;
 
 clean:
-	mlx5_free_comp_eqs(dev);
+	destroy_comp_eqs(dev);
 	return err;
 }
 
@@ -1133,7 +1123,7 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 	struct mlx5_eq_table *table = &dev->priv.eq_table;
 	struct mlx5_eq *eq;
 
-	mlx5_irq_clear_affinity_hints(dev);
+	clear_comp_irqs_affinity_hints(dev);
 
 #ifdef CONFIG_RFS_ACCEL
 	if (dev->rmap) {
@@ -1153,3 +1143,84 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 #endif
 	pci_free_irq_vectors(dev->pdev);
 }
+
+static int alloc_irq_vectors(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+	struct mlx5_eq_table *table = &priv->eq_table;
+	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
+		      MLX5_CAP_GEN(dev, max_num_eqs) :
+		      1 << MLX5_CAP_GEN(dev, log_max_eq);
+	int nvec;
+	int err;
+
+	nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
+	       MLX5_EQ_VEC_COMP_BASE;
+	nvec = min_t(int, nvec, num_eqs);
+	if (nvec <= MLX5_EQ_VEC_COMP_BASE)
+		return -ENOMEM;
+
+	priv->irq_info = kcalloc(nvec, sizeof(*priv->irq_info), GFP_KERNEL);
+	if (!priv->irq_info)
+		return -ENOMEM;
+
+	nvec = pci_alloc_irq_vectors(dev->pdev, MLX5_EQ_VEC_COMP_BASE + 1,
+				     nvec, PCI_IRQ_MSIX);
+	if (nvec < 0) {
+		err = nvec;
+		goto err_free_irq_info;
+	}
+
+	table->num_comp_vectors = nvec - MLX5_EQ_VEC_COMP_BASE;
+
+	return 0;
+
+err_free_irq_info:
+	kfree(priv->irq_info);
+	return err;
+}
+
+static void free_irq_vectors(struct mlx5_core_dev *dev)
+{
+	struct mlx5_priv *priv = &dev->priv;
+
+	pci_free_irq_vectors(dev->pdev);
+	kfree(priv->irq_info);
+}
+
+int mlx5_eq_table_create(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = alloc_irq_vectors(dev);
+	if (err) {
+		mlx5_core_err(dev, "alloc irq vectors failed\n");
+		return err;
+	}
+
+	err = create_async_eqs(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to create async EQs\n");
+		goto err_async_eqs;
+	}
+
+	err = create_comp_eqs(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed to create completion EQs\n");
+		goto err_comp_eqs;
+	}
+
+	return 0;
+err_comp_eqs:
+	destroy_async_eqs(dev);
+err_async_eqs:
+	free_irq_vectors(dev);
+	return err;
+}
+
+void mlx5_eq_table_destroy(struct mlx5_core_dev *dev)
+{
+	destroy_comp_eqs(dev);
+	destroy_async_eqs(dev);
+	free_irq_vectors(dev);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 244fec4b2ef2..21cc9bbc2563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -319,51 +319,6 @@ static void release_bar(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 }
 
-static int mlx5_alloc_irq_vectors(struct mlx5_core_dev *dev)
-{
-	struct mlx5_priv *priv = &dev->priv;
-	struct mlx5_eq_table *table = &priv->eq_table;
-	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
-		      MLX5_CAP_GEN(dev, max_num_eqs) :
-		      1 << MLX5_CAP_GEN(dev, log_max_eq);
-	int nvec;
-	int err;
-
-	nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
-	       MLX5_EQ_VEC_COMP_BASE;
-	nvec = min_t(int, nvec, num_eqs);
-	if (nvec <= MLX5_EQ_VEC_COMP_BASE)
-		return -ENOMEM;
-
-	priv->irq_info = kcalloc(nvec, sizeof(*priv->irq_info), GFP_KERNEL);
-	if (!priv->irq_info)
-		return -ENOMEM;
-
-	nvec = pci_alloc_irq_vectors(dev->pdev,
-			MLX5_EQ_VEC_COMP_BASE + 1, nvec,
-			PCI_IRQ_MSIX);
-	if (nvec < 0) {
-		err = nvec;
-		goto err_free_irq_info;
-	}
-
-	table->num_comp_vectors = nvec - MLX5_EQ_VEC_COMP_BASE;
-
-	return 0;
-
-err_free_irq_info:
-	kfree(priv->irq_info);
-	return err;
-}
-
-static void mlx5_free_irq_vectors(struct mlx5_core_dev *dev)
-{
-	struct mlx5_priv *priv = &dev->priv;
-
-	pci_free_irq_vectors(dev->pdev);
-	kfree(priv->irq_info);
-}
-
 struct mlx5_reg_host_endianness {
 	u8	he;
 	u8      rsvd[15];
@@ -990,23 +945,17 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		}
 	}
 
-	err = mlx5_alloc_irq_vectors(dev);
-	if (err) {
-		dev_err(&pdev->dev, "alloc irq vectors failed\n");
-		goto err_cleanup_once;
-	}
-
 	dev->priv.uar = mlx5_get_uars_page(dev);
 	if (IS_ERR(dev->priv.uar)) {
 		dev_err(&pdev->dev, "Failed allocating uar, aborting\n");
 		err = PTR_ERR(dev->priv.uar);
-		goto err_disable_msix;
+		goto err_get_uars;
 	}
 
-	err = mlx5_start_eqs(dev);
+	err = mlx5_eq_table_create(dev);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to start pages and async EQs\n");
-		goto err_put_uars;
+		dev_err(&pdev->dev, "Failed to create EQs\n");
+		goto err_eq_table;
 	}
 
 	err = mlx5_fw_tracer_init(dev->tracer);
@@ -1015,12 +964,6 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_fw_tracer;
 	}
 
-	err = mlx5_alloc_comp_eqs(dev);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to alloc completion EQs\n");
-		goto err_comp_eqs;
-	}
-
 	err = mlx5_fpga_device_start(dev);
 	if (err) {
 		dev_err(&pdev->dev, "fpga device start failed %d\n", err);
@@ -1089,21 +1032,15 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_fpga_device_stop(dev);
 
 err_fpga_start:
-	mlx5_free_comp_eqs(dev);
-
-err_comp_eqs:
 	mlx5_fw_tracer_cleanup(dev->tracer);
 
 err_fw_tracer:
-	mlx5_stop_eqs(dev);
+	mlx5_eq_table_destroy(dev);
 
-err_put_uars:
+err_eq_table:
 	mlx5_put_uars_page(dev, priv->uar);
 
-err_disable_msix:
-	mlx5_free_irq_vectors(dev);
-
-err_cleanup_once:
+err_get_uars:
 	if (boot)
 		mlx5_cleanup_once(dev);
 
@@ -1160,11 +1097,9 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
 	mlx5_fpga_device_stop(dev);
-	mlx5_free_comp_eqs(dev);
 	mlx5_fw_tracer_cleanup(dev->tracer);
-	mlx5_stop_eqs(dev);
+	mlx5_eq_table_destroy(dev);
 	mlx5_put_uars_page(dev, priv->uar);
-	mlx5_free_irq_vectors(dev);
 	if (cleanup)
 		mlx5_cleanup_once(dev);
 	mlx5_stop_health_poll(dev, cleanup);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 22cff00faa5a..3fa6d26875fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -132,12 +132,8 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
 int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
-int mlx5_core_eq_query(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
-		       u32 *out, int outlen);
-int mlx5_start_eqs(struct mlx5_core_dev *dev);
-void mlx5_stop_eqs(struct mlx5_core_dev *dev);
-int mlx5_alloc_comp_eqs(struct mlx5_core_dev *dev);
-void mlx5_free_comp_eqs(struct mlx5_core_dev *dev);
+int mlx5_eq_table_create(struct mlx5_core_dev *dev);
+void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn);
-- 
2.19.1
