From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v5 for-4.13 1/6] mlx5: convert to generic pci_alloc_irq_vectors
Date: Wed,  7 Jun 2017 19:02:37 +0300
Message-ID: <1496851362-1344-2-git-send-email-sagi@grimberg.me>
References: <1496851362-1344-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496851362-1344-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Now that we have a generic code to allocate an array
of irq vectors and even correctly spread their affinity,
correctly handle cpu hotplug events and more, were much
better off using it.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  9 ++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 39 +++++++++-------------
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  1 -
 include/linux/mlx5/driver.h                        |  1 -
 7 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 41cd22a223dc..2a3c59e55dcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -385,7 +385,7 @@ static void mlx5e_enable_async_events(struct mlx5e_priv *priv)
 static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
 {
 	clear_bit(MLX5E_STATE_ASYNC_EVENTS_ENABLED, &priv->state);
-	synchronize_irq(mlx5_get_msix_vec(priv->mdev, MLX5_EQ_VEC_ASYNC));
+	synchronize_irq(pci_irq_vector(priv->mdev->pdev, MLX5_EQ_VEC_ASYNC));
 }
 
 static inline int mlx5e_get_wqe_mtt_sz(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 33eae5ad2fb0..36bcfe6fe780 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -575,7 +575,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 		 name, pci_name(dev->pdev));
 
 	eq->eqn = MLX5_GET(create_eq_out, out, eq_number);
-	eq->irqn = priv->msix_arr[vecidx].vector;
+	eq->irqn = pci_irq_vector(dev->pdev, vecidx);
 	eq->dev = dev;
 	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBEL_OFFSET;
 	err = request_irq(eq->irqn, handler, 0,
@@ -610,7 +610,7 @@ int mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	return 0;
 
 err_irq:
-	free_irq(priv->msix_arr[vecidx].vector, eq);
+	free_irq(eq->irqn, eq);
 
 err_eq:
 	mlx5_cmd_destroy_eq(dev, eq->eqn);
@@ -651,11 +651,6 @@ int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 }
 EXPORT_SYMBOL_GPL(mlx5_destroy_unmap_eq);
 
-u32 mlx5_get_msix_vec(struct mlx5_core_dev *dev, int vecidx)
-{
-	return dev->priv.msix_arr[MLX5_EQ_VEC_ASYNC].vector;
-}
-
 int mlx5_eq_init(struct mlx5_core_dev *dev)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2e34d95ea776..e9256b7017b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1592,7 +1592,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, int vport_num)
 	/* Mark this vport as disabled to discard new events */
 	vport->enabled = false;
 
-	synchronize_irq(mlx5_get_msix_vec(esw->dev, MLX5_EQ_VEC_ASYNC));
+	synchronize_irq(pci_irq_vector(esw->dev->pdev, MLX5_EQ_VEC_ASYNC));
 	/* Wait for current already scheduled events to complete */
 	flush_workqueue(esw->work_queue);
 	/* Disable events from this vport */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 44f59b1d6f0f..6deb2b5b59dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -80,7 +80,7 @@ static void trigger_cmd_completions(struct mlx5_core_dev *dev)
 	u64 vector;
 
 	/* wait for pending handlers to complete */
-	synchronize_irq(dev->priv.msix_arr[MLX5_EQ_VEC_CMD].vector);
+	synchronize_irq(pci_irq_vector(dev->pdev, MLX5_EQ_VEC_CMD));
 	spin_lock_irqsave(&dev->cmd.alloc_lock, flags);
 	vector = ~dev->cmd.bitmask & ((1ul << (1 << dev->cmd.log_sz)) - 1);
 	if (!vector)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index af945edfee19..cf64bd2a6966 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -308,13 +308,12 @@ static void release_bar(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 }
 
-static int mlx5_enable_msix(struct mlx5_core_dev *dev)
+static int mlx5_alloc_irq_vectors(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	struct mlx5_eq_table *table = &priv->eq_table;
 	int num_eqs = 1 << MLX5_CAP_GEN(dev, log_max_eq);
 	int nvec;
-	int i;
 
 	nvec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() +
 	       MLX5_EQ_VEC_COMP_BASE;
@@ -322,17 +321,13 @@ static int mlx5_enable_msix(struct mlx5_core_dev *dev)
 	if (nvec <= MLX5_EQ_VEC_COMP_BASE)
 		return -ENOMEM;
 
-	priv->msix_arr = kcalloc(nvec, sizeof(*priv->msix_arr), GFP_KERNEL);
-
 	priv->irq_info = kcalloc(nvec, sizeof(*priv->irq_info), GFP_KERNEL);
-	if (!priv->msix_arr || !priv->irq_info)
+	if (!priv->irq_info)
 		goto err_free_msix;
 
-	for (i = 0; i < nvec; i++)
-		priv->msix_arr[i].entry = i;
-
-	nvec = pci_enable_msix_range(dev->pdev, priv->msix_arr,
-				     MLX5_EQ_VEC_COMP_BASE + 1, nvec);
+	nvec = pci_alloc_irq_vectors(dev->pdev,
+			MLX5_EQ_VEC_COMP_BASE + 1, nvec,
+			PCI_IRQ_MSIX);
 	if (nvec < 0)
 		return nvec;
 
@@ -342,17 +337,15 @@ static int mlx5_enable_msix(struct mlx5_core_dev *dev)
 
 err_free_msix:
 	kfree(priv->irq_info);
-	kfree(priv->msix_arr);
 	return -ENOMEM;
 }
 
-static void mlx5_disable_msix(struct mlx5_core_dev *dev)
+static void mlx5_free_irq_vectors(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 
-	pci_disable_msix(dev->pdev);
+	pci_free_irq_vectors(dev->pdev);
 	kfree(priv->irq_info);
-	kfree(priv->msix_arr);
 }
 
 struct mlx5_reg_host_endianess {
@@ -610,8 +603,7 @@ u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev)
 static int mlx5_irq_set_affinity_hint(struct mlx5_core_dev *mdev, int i)
 {
 	struct mlx5_priv *priv  = &mdev->priv;
-	struct msix_entry *msix = priv->msix_arr;
-	int irq                 = msix[i + MLX5_EQ_VEC_COMP_BASE].vector;
+	int irq = pci_irq_vector(mdev->pdev, MLX5_EQ_VEC_COMP_BASE + i);
 
 	if (!zalloc_cpumask_var(&priv->irq_info[i].mask, GFP_KERNEL)) {
 		mlx5_core_warn(mdev, "zalloc_cpumask_var failed");
@@ -631,8 +623,7 @@ static int mlx5_irq_set_affinity_hint(struct mlx5_core_dev *mdev, int i)
 static void mlx5_irq_clear_affinity_hint(struct mlx5_core_dev *mdev, int i)
 {
 	struct mlx5_priv *priv  = &mdev->priv;
-	struct msix_entry *msix = priv->msix_arr;
-	int irq                 = msix[i + MLX5_EQ_VEC_COMP_BASE].vector;
+	int irq = pci_irq_vector(mdev->pdev, MLX5_EQ_VEC_COMP_BASE + i);
 
 	irq_set_affinity_hint(irq, NULL);
 	free_cpumask_var(priv->irq_info[i].mask);
@@ -755,8 +746,8 @@ static int alloc_comp_eqs(struct mlx5_core_dev *dev)
 		}
 
 #ifdef CONFIG_RFS_ACCEL
-		irq_cpu_rmap_add(dev->rmap,
-				 dev->priv.msix_arr[i + MLX5_EQ_VEC_COMP_BASE].vector);
+		irq_cpu_rmap_add(dev->rmap, pci_irq_vector(dev->pdev,
+				 MLX5_EQ_VEC_COMP_BASE + i));
 #endif
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", i);
 		err = mlx5_create_map_eq(dev, eq,
@@ -1093,9 +1084,9 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_stop_poll;
 	}
 
-	err = mlx5_enable_msix(dev);
+	err = mlx5_alloc_irq_vectors(dev);
 	if (err) {
-		dev_err(&pdev->dev, "enable msix failed\n");
+		dev_err(&pdev->dev, "alloc irq vectors failed\n");
 		goto err_cleanup_once;
 	}
 
@@ -1178,7 +1169,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_put_uars_page(dev, priv->uar);
 
 err_disable_msix:
-	mlx5_disable_msix(dev);
+	mlx5_free_irq_vectors(dev);
 
 err_cleanup_once:
 	if (boot)
@@ -1239,7 +1230,7 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	free_comp_eqs(dev);
 	mlx5_stop_eqs(dev);
 	mlx5_put_uars_page(dev, priv->uar);
-	mlx5_disable_msix(dev);
+	mlx5_free_irq_vectors(dev);
 	if (cleanup)
 		mlx5_cleanup_once(dev);
 	mlx5_stop_health_poll(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index fbc6e9e9e305..521768c56073 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -109,7 +109,6 @@ int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 					u32 element_id);
 int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev);
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev);
-u32 mlx5_get_msix_vec(struct mlx5_core_dev *dev, int vecidx);
 struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn);
 void mlx5_cq_tasklet_cb(unsigned long data);
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 93273d9ea4d1..d48b9164a316 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -590,7 +590,6 @@ struct mlx5_port_module_event_stats {
 struct mlx5_priv {
 	char			name[MLX5_MAX_NAME_LEN];
 	struct mlx5_eq_table	eq_table;
-	struct msix_entry	*msix_arr;
 	struct mlx5_irq_info	*irq_info;
 
 	/* pages stuff */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
