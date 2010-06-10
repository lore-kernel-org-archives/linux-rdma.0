From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 08/19 V4] mlx4_core: multi-function resource setup
Date: Thu, 10 Jun 2010 22:00:48 +0300
Message-ID: <4C113660.6010409@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Only master function needs to configure eq asynch events, and initialize resource
allocators.
Only the master function polls for fatal events.

Signed-off-by: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/cq.c       |    4 +++
 drivers/net/mlx4/eq.c       |   52 +++++++++++++++++++++++++-----------------
 drivers/net/mlx4/intf.c     |    6 +++-
 drivers/net/mlx4/main.c     |   40 ++++++++++++++++++---------------
 drivers/net/mlx4/mcg.c      |    6 +++++
 drivers/net/mlx4/mr.c       |    6 +++++
 drivers/net/mlx4/pd.c       |    7 ++++-
 drivers/net/mlx4/qp.c       |   28 +++++++++++++++++++++-
 drivers/net/mlx4/srq.c      |    4 +++
 include/linux/mlx4/device.h |    1 +
 10 files changed, 109 insertions(+), 45 deletions(-)

diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
index c896f71..89af831 100644
--- a/drivers/net/mlx4/cq.c
+++ b/drivers/net/mlx4/cq.c
@@ -352,6 +352,8 @@ int mlx4_init_cq_table(struct mlx4_dev *dev)
 
 	spin_lock_init(&cq_table->lock);
 	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
+	if (mlx4_is_slave(dev))
+		return 0;
 
 	err = mlx4_bitmap_init(&cq_table->bitmap, dev->caps.num_cqs,
 			       dev->caps.num_cqs - 1, dev->caps.reserved_cqs, 0);
@@ -363,6 +365,8 @@ int mlx4_init_cq_table(struct mlx4_dev *dev)
 
 void mlx4_cleanup_cq_table(struct mlx4_dev *dev)
 {
+	if (mlx4_is_slave(dev))
+		return;
 	/* Nothing to do to clean up radix_tree */
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->cq_table.bitmap);
 }
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index e0cba6f..1cb692d 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -699,6 +699,7 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int err;
 	int i;
+	u32 round_eqs = roundup_pow_of_two(dev->caps.num_eqs);
 
 	priv->eq_table.uar_map = kcalloc(sizeof *priv->eq_table.uar_map,
 					 mlx4_num_eq_uar(dev), GFP_KERNEL);
@@ -707,33 +708,38 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 		goto err_out_free;
 	}
 
-	err = mlx4_bitmap_init(&priv->eq_table.bitmap, dev->caps.num_eqs,
-			       dev->caps.num_eqs - 1, dev->caps.reserved_eqs, 0);
+	err = mlx4_bitmap_init(&priv->eq_table.bitmap, round_eqs, round_eqs - 1,
+			       dev->caps.reserved_eqs, round_eqs - dev->caps.num_eqs);
 	if (err)
 		goto err_out_free;
 
 	for (i = 0; i < mlx4_num_eq_uar(dev); ++i)
 		priv->eq_table.uar_map[i] = NULL;
 
-	err = mlx4_map_clr_int(dev);
-	if (err)
-		goto err_out_bitmap;
+	if (!mlx4_is_slave(dev)) {
+		err = mlx4_map_clr_int(dev);
+		if (err)
+			goto err_out_bitmap;
 
-	priv->eq_table.clr_mask =
-		swab32(1 << (priv->eq_table.inta_pin & 31));
-	priv->eq_table.clr_int  = priv->clr_base +
-		(priv->eq_table.inta_pin < 32 ? 4 : 0);
+		priv->eq_table.clr_mask =
+			swab32(1 << (priv->eq_table.inta_pin & 31));
+		priv->eq_table.clr_int  = priv->clr_base +
+			(priv->eq_table.inta_pin < 32 ? 4 : 0);
+	}
 
 	priv->eq_table.irq_names =
 		kmalloc(MLX4_IRQNAME_SIZE * (dev->caps.num_comp_vectors + 1),
 			GFP_KERNEL);
 	if (!priv->eq_table.irq_names) {
 		err = -ENOMEM;
-		goto err_out_bitmap;
+		i = 0;
+		goto err_out_unmap;
 	}
 
 	for (i = 0; i < dev->caps.num_comp_vectors; ++i) {
-		err = mlx4_create_eq(dev, dev->caps.num_cqs + MLX4_NUM_SPARE_EQE,
+		err = mlx4_create_eq(dev, dev->caps.num_cqs -
+					  dev->caps.reserved_cqs +
+					  MLX4_NUM_SPARE_EQE,
 				     (dev->flags & MLX4_FLAG_MSI_X) ? i : 0,
 				     &priv->eq_table.eq[i]);
 		if (err) {
@@ -791,11 +797,13 @@ int mlx4_init_eq_table(struct mlx4_dev *dev)
 		priv->eq_table.have_irq = 1;
 	}
 
-	err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
-			  priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
-	if (err)
-		mlx4_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
-			   priv->eq_table.eq[dev->caps.num_comp_vectors].eqn, err);
+	if (!mlx4_is_slave(dev)) { /* hw async events cannot be shared */
+		err = mlx4_MAP_EQ(dev, MLX4_ASYNC_EVENT_MASK, 0,
+				  priv->eq_table.eq[dev->caps.num_comp_vectors].eqn);
+		if (err)
+			mlx4_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
+				   priv->eq_table.eq[dev->caps.num_comp_vectors].eqn, err);
+	}
 
 	for (i = 0; i < dev->caps.num_comp_vectors + 1; ++i)
 		eq_set_ci(&priv->eq_table.eq[i], 1);
@@ -806,14 +814,15 @@ err_out_async:
 	mlx4_free_eq(dev, &priv->eq_table.eq[dev->caps.num_comp_vectors]);
 
 err_out_comp:
-	i = dev->caps.num_comp_vectors - 1;
+	i = dev->caps.num_comp_vectors;
 
 err_out_unmap:
-	while (i >= 0) {
-		mlx4_free_eq(dev, &priv->eq_table.eq[i]);
+	while (i > 0) {
 		--i;
+		mlx4_free_eq(dev, &priv->eq_table.eq[i]);
 	}
-	mlx4_unmap_clr_int(dev);
+	if (!mlx4_is_slave(dev))
+		mlx4_unmap_clr_int(dev);
 	mlx4_free_irqs(dev);
 
 err_out_bitmap:
@@ -840,7 +849,8 @@ void mlx4_cleanup_eq_table(struct mlx4_dev *dev)
 	for (i = 0; i < dev->caps.num_comp_vectors + !mlx4_is_slave(dev); ++i)
 		mlx4_free_eq(dev, &priv->eq_table.eq[i]);
 
-	mlx4_unmap_clr_int(dev);
+	if (!mlx4_is_slave(dev))
+		mlx4_unmap_clr_int(dev);
 
 	for (i = 0; i < mlx4_num_eq_uar(dev); ++i)
 		if (priv->eq_table.uar_map[i])
diff --git a/drivers/net/mlx4/intf.c b/drivers/net/mlx4/intf.c
index 5550678..5871957 100644
--- a/drivers/net/mlx4/intf.c
+++ b/drivers/net/mlx4/intf.c
@@ -141,7 +141,8 @@ int mlx4_register_device(struct mlx4_dev *dev)
 		mlx4_add_device(intf, priv);
 
 	mutex_unlock(&intf_mutex);
-	mlx4_start_catas_poll(dev);
+	if (!mlx4_is_slave(dev))
+		mlx4_start_catas_poll(dev);
 
 	return 0;
 }
@@ -151,7 +152,8 @@ void mlx4_unregister_device(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_interface *intf;
 
-	mlx4_stop_catas_poll(dev);
+	if (!mlx4_is_slave(dev))
+		mlx4_stop_catas_poll(dev);
 	mutex_lock(&intf_mutex);
 
 	list_for_each_entry(intf, &intf_list, list)
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 99e267c..f67f992 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -920,11 +920,13 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		goto err_mr_table_free;
 	}
 
-	err = mlx4_cmd_use_events(dev);
-	if (err) {
-		mlx4_err(dev, "Failed to switch to event-driven "
-			 "firmware commands, aborting.\n");
-		goto err_eq_table_free;
+	if (!mlx4_is_slave(dev)) {
+		err = mlx4_cmd_use_events(dev);
+		if (err) {
+			mlx4_err(dev, "Failed to switch to event-driven "
+				 "firmware commands, aborting.\n");
+			goto err_eq_table_free;
+		}
 	}
 
 	err = mlx4_NOP(dev);
@@ -974,19 +976,21 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		goto err_qp_table_free;
 	}
 
-	for (port = 1; port <= dev->caps.num_ports; port++) {
-		ib_port_default_caps = 0;
-		err = mlx4_get_port_ib_caps(dev, port, &ib_port_default_caps);
-		if (err)
-			mlx4_warn(dev, "failed to get port %d default "
-				  "ib capabilities (%d). Continuing with "
-				  "caps = 0\n", port, err);
-		dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
-		err = mlx4_SET_PORT(dev, port);
-		if (err) {
-			mlx4_err(dev, "Failed to set port %d, aborting\n",
-				port);
-			goto err_mcg_table_free;
+	if (!mlx4_is_slave(dev)) {
+		for (port = 1; port <= dev->caps.num_ports; port++) {
+			ib_port_default_caps = 0;
+			err = mlx4_get_port_ib_caps(dev, port, &ib_port_default_caps);
+			if (err)
+				mlx4_warn(dev, "failed to get port %d default "
+					  "ib capabilities (%d). Continuing with "
+					  "caps = 0\n", port, err);
+			dev->caps.ib_port_def_cap[port] = ib_port_default_caps;
+			err = mlx4_SET_PORT(dev, port);
+			if (err) {
+				mlx4_err(dev, "Failed to set port %d, aborting\n",
+					port);
+				goto err_mcg_table_free;
+			}
 		}
 	}
 
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index c4f88b7..b8c7a72 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -347,6 +347,10 @@ int mlx4_init_mcg_table(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int err;
 
+	/* Nothing to do for slaves - mcg handling is para-virtualized */
+	if (mlx4_is_slave(dev))
+		return 0;
+
 	err = mlx4_bitmap_init(&priv->mcg_table.bitmap, dev->caps.num_amgms,
 			       dev->caps.num_amgms - 1, 0, 0);
 	if (err)
@@ -359,5 +363,7 @@ int mlx4_init_mcg_table(struct mlx4_dev *dev)
 
 void mlx4_cleanup_mcg_table(struct mlx4_dev *dev)
 {
+	if (mlx4_is_slave(dev))
+		return;
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->mcg_table.bitmap);
 }
diff --git a/drivers/net/mlx4/mr.c b/drivers/net/mlx4/mr.c
index a3f5a36..7ffe156 100644
--- a/drivers/net/mlx4/mr.c
+++ b/drivers/net/mlx4/mr.c
@@ -618,6 +618,10 @@ int mlx4_init_mr_table(struct mlx4_dev *dev)
 	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
 	int err;
 
+	/* Nothing to do for slaves - all MR handling is forwarded to the master */
+	if (mlx4_is_slave(dev))
+		return 0;
+
 	err = mlx4_bitmap_init(&mr_table->mpt_bitmap, dev->caps.num_mpts,
 			       ~0, dev->caps.reserved_mrws, 0);
 	if (err)
@@ -652,6 +656,8 @@ void mlx4_cleanup_mr_table(struct mlx4_dev *dev)
 {
 	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
 
+	if (mlx4_is_slave(dev))
+		return;
 	mlx4_buddy_cleanup(&mr_table->mtt_buddy);
 	mlx4_bitmap_cleanup(&mr_table->mpt_bitmap);
 }
diff --git a/drivers/net/mlx4/pd.c b/drivers/net/mlx4/pd.c
index c4988d6..4b4d9cb 100644
--- a/drivers/net/mlx4/pd.c
+++ b/drivers/net/mlx4/pd.c
@@ -90,6 +90,8 @@ EXPORT_SYMBOL_GPL(mlx4_uar_free);
 
 int mlx4_init_uar_table(struct mlx4_dev *dev)
 {
+	u32 round_uars = roundup_pow_of_two(dev->caps.num_uars);
+
 	if (dev->caps.num_uars <= 128) {
 		mlx4_err(dev, "Only %d UAR pages (need more than 128)\n",
 			 dev->caps.num_uars);
@@ -98,8 +100,9 @@ int mlx4_init_uar_table(struct mlx4_dev *dev)
 	}
 
 	return mlx4_bitmap_init(&mlx4_priv(dev)->uar_table.bitmap,
-				dev->caps.num_uars, dev->caps.num_uars - 1,
-				max(128, dev->caps.reserved_uars), 0);
+				round_uars, round_uars - 1,
+				dev->caps.reserved_uars,
+				round_uars - dev->caps.num_uars);
 }
 
 void mlx4_cleanup_uar_table(struct mlx4_dev *dev)
diff --git a/drivers/net/mlx4/qp.c b/drivers/net/mlx4/qp.c
index 5aa99b0..13b0008 100644
--- a/drivers/net/mlx4/qp.c
+++ b/drivers/net/mlx4/qp.c
@@ -340,6 +340,23 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 
 	spin_lock_init(&qp_table->lock);
 	INIT_RADIX_TREE(&dev->qp_table_tree, GFP_ATOMIC);
+	if (mlx4_is_slave(dev)) {
+		/* For each slave, just allocate a normal 8-byte alligned special-QP
+		 * range intead of mlx4_init_qp_table() reservation */
+		err = mlx4_qp_reserve_range(dev, 8, 8, &dev->caps.sqp_start);
+		if (err) {
+			mlx4_err(dev, "Failed to allocate special QP range\n");
+			return err;
+		}
+
+		err = mlx4_CONF_SPECIAL_QP(dev, dev->caps.sqp_start);
+		if (err) {
+			mlx4_err(dev, "Failed to configure special QP range\n");
+			mlx4_qp_release_range(dev, dev->caps.sqp_start, 8);
+			return err;
+		}
+		return 0;
+	}
 
 	/*
 	 * We reserve 2 extra QPs per port for the special QPs.  The
@@ -349,6 +366,9 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 	dev->caps.sqp_start =
 		ALIGN(dev->caps.reserved_qps_cnt[MLX4_QP_REGION_FW], 8);
 
+	/* If multi-function is enabled, we reserve an additional QP for qp0/1 tunneling. */
+	dev->caps.tunnel_qpn = mlx4_is_master(dev) ? dev->caps.sqp_start + 8 : 0;
+
 	{
 		int sort[MLX4_NUM_QP_REGION];
 		int i, j, tmp;
@@ -378,8 +398,8 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 	}
 
 	err = mlx4_bitmap_init(&qp_table->bitmap, dev->caps.num_qps,
-			       (1 << 23) - 1, dev->caps.sqp_start + 8,
-			       reserved_from_top);
+			       (1 << 23) - 1, dev->caps.sqp_start + 8 +
+			       2 * !!dev->caps.tunnel_qpn, reserved_from_top);
 	if (err)
 		return err;
 
@@ -389,6 +409,10 @@ int mlx4_init_qp_table(struct mlx4_dev *dev)
 void mlx4_cleanup_qp_table(struct mlx4_dev *dev)
 {
 	mlx4_CONF_SPECIAL_QP(dev, 0);
+	if (mlx4_is_slave(dev)) {
+		mlx4_qp_release_range(dev, dev->caps.sqp_start, 8);
+		return;
+	}
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->qp_table.bitmap);
 }
 
diff --git a/drivers/net/mlx4/srq.c b/drivers/net/mlx4/srq.c
index 8bfb54a..57722d4 100644
--- a/drivers/net/mlx4/srq.c
+++ b/drivers/net/mlx4/srq.c
@@ -288,6 +288,8 @@ int mlx4_init_srq_table(struct mlx4_dev *dev)
 
 	spin_lock_init(&srq_table->lock);
 	INIT_RADIX_TREE(&srq_table->tree, GFP_ATOMIC);
+	if (mlx4_is_slave(dev))
+		return 0;
 
 	err = mlx4_bitmap_init(&srq_table->bitmap, dev->caps.num_srqs,
 			       dev->caps.num_srqs - 1, dev->caps.reserved_srqs, 0);
@@ -299,5 +301,7 @@ int mlx4_init_srq_table(struct mlx4_dev *dev)
 
 void mlx4_cleanup_srq_table(struct mlx4_dev *dev)
 {
+	if (mlx4_is_slave(dev))
+		return;
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->srq_table.bitmap);
 }
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index efc8a90..78a5fc9 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -204,6 +204,7 @@ struct mlx4_caps {
 	int			max_qp_init_rdma;
 	int			max_qp_dest_rdma;
 	int			sqp_start;
+	int			tunnel_qpn;
 	int			num_srqs;
 	int			max_srq_wqes;
 	int			max_srq_sge;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
