From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [for-next 01/11] net/mlx5: E-Switch, Refactor vport representors initialization
Date: Tue, 19 Dec 2017 12:33:30 -0800
Message-ID: <20171219203340.2600-2-saeedm@mellanox.com>
References: <20171219203340.2600-1-saeedm@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219203340.2600-1-saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Refactor the init stage of vport representors registration.
vport number and hw id can be assigned by the E-Switch driver and not by
the netdevice driver. While here, make the error path of mlx5_eswitch_init()
a reverse order of the good path, also use kcalloc to allocate an array
instead of kzalloc.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  7 ----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 12 +++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 40 +++++++++++++++++++---
 4 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 2c43606c26b5..4661ef12c18c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1100,17 +1100,12 @@ static void mlx5e_rep_register_vf_vports(struct mlx5e_priv *priv)
 	struct mlx5_eswitch *esw   = mdev->priv.eswitch;
 	int total_vfs = MLX5_TOTAL_VPORTS(mdev);
 	int vport;
-	u8 mac[ETH_ALEN];
-
-	mlx5_query_nic_vport_mac_address(mdev, 0, mac);
 
 	for (vport = 1; vport < total_vfs; vport++) {
 		struct mlx5_eswitch_rep rep;
 
 		rep.load = mlx5e_vport_rep_load;
 		rep.unload = mlx5e_vport_rep_unload;
-		rep.vport = vport;
-		ether_addr_copy(rep.hw_id, mac);
 		mlx5_eswitch_register_vport_rep(esw, vport, &rep);
 	}
 }
@@ -1132,10 +1127,8 @@ void mlx5e_register_vport_reps(struct mlx5e_priv *priv)
 	struct mlx5_eswitch *esw   = mdev->priv.eswitch;
 	struct mlx5_eswitch_rep rep;
 
-	mlx5_query_nic_vport_mac_address(mdev, 0, rep.hw_id);
 	rep.load = mlx5e_nic_rep_load;
 	rep.unload = mlx5e_nic_rep_unload;
-	rep.vport = FDB_UPLINK_VPORT;
 	rep.netdev = priv->netdev;
 	mlx5_eswitch_register_vport_rep(esw, 0, &rep); /* UPLINK PF vport*/
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index bbb140f517c4..6d4cbdb69823 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1644,13 +1644,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
 	}
 
-	esw->offloads.vport_reps =
-		kzalloc(total_vports * sizeof(struct mlx5_eswitch_rep),
-			GFP_KERNEL);
-	if (!esw->offloads.vport_reps) {
-		err = -ENOMEM;
+	err = esw_offloads_init_reps(esw);
+	if (err)
 		goto abort;
-	}
 
 	hash_init(esw->offloads.encap_tbl);
 	hash_init(esw->offloads.mod_hdr_tbl);
@@ -1681,8 +1677,8 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 abort:
 	if (esw->work_queue)
 		destroy_workqueue(esw->work_queue);
+	esw_offloads_cleanup_reps(esw);
 	kfree(esw->vports);
-	kfree(esw->offloads.vport_reps);
 	kfree(esw);
 	return err;
 }
@@ -1696,7 +1692,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
-	kfree(esw->offloads.vport_reps);
+	esw_offloads_cleanup_reps(esw);
 	kfree(esw->vports);
 	kfree(esw);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 565c8b7a399a..9722c2a96090 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -197,6 +197,8 @@ struct mlx5_eswitch {
 
 void esw_offloads_cleanup(struct mlx5_eswitch *esw, int nvports);
 int esw_offloads_init(struct mlx5_eswitch *esw, int nvports);
+void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
+int esw_offloads_init_reps(struct mlx5_eswitch *esw);
 
 /* E-Switch API */
 int mlx5_eswitch_init(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1143d80119bd..230b05842cb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -732,6 +732,42 @@ static int esw_offloads_start(struct mlx5_eswitch *esw)
 	return err;
 }
 
+void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
+{
+	kfree(esw->offloads.vport_reps);
+}
+
+int esw_offloads_init_reps(struct mlx5_eswitch *esw)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_esw_offload *offloads;
+	struct mlx5_eswitch_rep *rep;
+	int total_vfs = MLX5_TOTAL_VPORTS(dev);
+	u8 hw_id[ETH_ALEN];
+	int vport;
+
+	esw->offloads.vport_reps =
+		kcalloc(total_vfs, sizeof(struct mlx5_eswitch_rep),
+			GFP_KERNEL);
+
+	if (!esw->offloads.vport_reps)
+		return -ENOMEM;
+
+	offloads = &esw->offloads;
+	mlx5_query_nic_vport_mac_address(dev, 0, hw_id);
+
+	for (vport = 0; vport < total_vfs; vport++) {
+		rep = &offloads->vport_reps[vport];
+
+		rep->vport = vport;
+		ether_addr_copy(rep->hw_id, hw_id);
+	}
+
+	offloads->vport_reps[0].vport = FDB_UPLINK_VPORT;
+
+	return 0;
+}
+
 int esw_offloads_init(struct mlx5_eswitch *esw, int nvports)
 {
 	struct mlx5_eswitch_rep *rep;
@@ -1127,13 +1163,9 @@ void mlx5_eswitch_register_vport_rep(struct mlx5_eswitch *esw,
 
 	rep = &offloads->vport_reps[vport_index];
 
-	memset(rep, 0, sizeof(*rep));
-
 	rep->load   = __rep->load;
 	rep->unload = __rep->unload;
-	rep->vport  = __rep->vport;
 	rep->netdev = __rep->netdev;
-	ether_addr_copy(rep->hw_id, __rep->hw_id);
 
 	INIT_LIST_HEAD(&rep->vport_sqs_list);
 	rep->valid = true;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
