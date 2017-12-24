From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next V2 03/11] net/mlx5: E-Switch, Simplify representor load/unload callback API
Date: Sun, 24 Dec 2017 15:45:39 +0200
Message-ID: <20171224134547.600-4-saeedm@mellanox.com>
References: <20171224134547.600-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171224134547.600-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

In the load() callback for loading representors we don't really need
struct mlx5_eswitch but struct mlx5_core_dev, pass it directly.

In the unload() callback for unloading representors we don't need the
struct mlx5_eswitch argument, remove it.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c           | 14 +++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  6 +++---
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4661ef12c18c..6d2219f3acf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -967,7 +967,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 /* e-Switch vport representors */
 
 static int
-mlx5e_nic_rep_load(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
+mlx5e_nic_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5e_priv *priv = netdev_priv(rep->netdev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
@@ -992,7 +992,7 @@ mlx5e_nic_rep_load(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
 }
 
 static void
-mlx5e_nic_rep_unload(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
+mlx5e_nic_rep_unload(struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5e_priv *priv = netdev_priv(rep->netdev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
@@ -1008,7 +1008,7 @@ mlx5e_nic_rep_unload(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
 }
 
 static int
-mlx5e_vport_rep_load(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
+mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
 	struct mlx5e_rep_priv *rpriv;
 	struct net_device *netdev;
@@ -1019,7 +1019,7 @@ mlx5e_vport_rep_load(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
 	if (!rpriv)
 		return -ENOMEM;
 
-	netdev = mlx5e_create_netdev(esw->dev, &mlx5e_rep_profile, rpriv);
+	netdev = mlx5e_create_netdev(dev, &mlx5e_rep_profile, rpriv);
 	if (!netdev) {
 		pr_warn("Failed to create representor netdev for vport %d\n",
 			rep->vport);
@@ -1044,7 +1044,7 @@ mlx5e_vport_rep_load(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
 		goto err_detach_netdev;
 	}
 
-	upriv = netdev_priv(mlx5_eswitch_get_uplink_netdev(esw));
+	upriv = netdev_priv(mlx5_eswitch_get_uplink_netdev(dev->priv.eswitch));
 	err = tc_setup_cb_egdev_register(netdev, mlx5e_setup_tc_block_cb,
 					 upriv);
 	if (err)
@@ -1076,7 +1076,7 @@ mlx5e_vport_rep_load(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
 }
 
 static void
-mlx5e_vport_rep_unload(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
+mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 {
 	struct net_device *netdev = rep->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -1085,7 +1085,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch *esw, struct mlx5_eswitch_rep *rep)
 	struct mlx5e_priv *upriv;
 
 	unregister_netdev(rep->netdev);
-	upriv = netdev_priv(mlx5_eswitch_get_uplink_netdev(esw));
+	upriv = netdev_priv(mlx5_eswitch_get_uplink_netdev(priv->mdev->priv.eswitch));
 	tc_setup_cb_egdev_unregister(netdev, mlx5e_setup_tc_block_cb,
 				     upriv);
 	mlx5e_rep_neigh_cleanup(rpriv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9722c2a96090..23808a65889c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -139,10 +139,9 @@ struct mlx5_esw_sq {
 };
 
 struct mlx5_eswitch_rep {
-	int		       (*load)(struct mlx5_eswitch *esw,
+	int		       (*load)(struct mlx5_core_dev *dev,
 				       struct mlx5_eswitch_rep *rep);
-	void		       (*unload)(struct mlx5_eswitch *esw,
-					 struct mlx5_eswitch_rep *rep);
+	void		       (*unload)(struct mlx5_eswitch_rep *rep);
 	u16		       vport;
 	u8		       hw_id[ETH_ALEN];
 	struct net_device      *netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 26fbc50ddc6d..aa20f51c0a99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -777,7 +777,7 @@ static void esw_offloads_unload_reps(struct mlx5_eswitch *esw, int nvports)
 		if (!rep->valid)
 			continue;
 
-		rep->unload(esw, rep);
+		rep->unload(rep);
 	}
 }
 
@@ -792,7 +792,7 @@ static int esw_offloads_load_reps(struct mlx5_eswitch *esw, int nvports)
 		if (!rep->valid)
 			continue;
 
-		err = rep->load(esw, rep);
+		err = rep->load(esw->dev, rep);
 		if (err)
 			goto err_reps;
 	}
@@ -1193,7 +1193,7 @@ void mlx5_eswitch_unregister_vport_rep(struct mlx5_eswitch *esw,
 	rep = &offloads->vport_reps[vport_index];
 
 	if (esw->mode == SRIOV_OFFLOADS && esw->vports[vport_index].enabled)
-		rep->unload(esw, rep);
+		rep->unload(rep);
 
 	rep->valid = false;
 }
-- 
2.13.0
