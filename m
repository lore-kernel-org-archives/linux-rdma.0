From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/6] net/mlx5: Rename modify/query_vport state related enums
Date: Wed,  8 Aug 2018 16:23:49 -0700
Message-ID: <20180808232353.15514-3-saeedm@mellanox.com>
References: <20180808232353.15514-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180808232353.15514-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Eran Ben Elisha <eranbe@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Modify and query vport state commands share the same admin_state and
op_mod values, rename the enums to fit them both.

In addition, remove the esw prefix from the admin state enum as this
also applied for vnic.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c    | 10 +++++-----
 include/linux/mlx5/device.h                          |  6 +++---
 include/linux/mlx5/mlx5_ifc.h                        |  4 ++--
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 56c1b6f5593e..4708b82e1695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -222,7 +222,7 @@ static void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	u8 port_state;
 
 	port_state = mlx5_query_vport_state(mdev,
-					    MLX5_QUERY_VPORT_STATE_IN_OP_MOD_VNIC_VPORT,
+					    MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT,
 					    0);
 
 	if (port_state == VPORT_STATE_UP) {
@@ -3873,9 +3873,9 @@ static int mlx5e_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate,
 static int mlx5_vport_link2ifla(u8 esw_link)
 {
 	switch (esw_link) {
-	case MLX5_ESW_VPORT_ADMIN_STATE_DOWN:
+	case MLX5_VPORT_ADMIN_STATE_DOWN:
 		return IFLA_VF_LINK_STATE_DISABLE;
-	case MLX5_ESW_VPORT_ADMIN_STATE_UP:
+	case MLX5_VPORT_ADMIN_STATE_UP:
 		return IFLA_VF_LINK_STATE_ENABLE;
 	}
 	return IFLA_VF_LINK_STATE_AUTO;
@@ -3885,11 +3885,11 @@ static int mlx5_ifla_link2vport(u8 ifla_link)
 {
 	switch (ifla_link) {
 	case IFLA_VF_LINK_STATE_DISABLE:
-		return MLX5_ESW_VPORT_ADMIN_STATE_DOWN;
+		return MLX5_VPORT_ADMIN_STATE_DOWN;
 	case IFLA_VF_LINK_STATE_ENABLE:
-		return MLX5_ESW_VPORT_ADMIN_STATE_UP;
+		return MLX5_VPORT_ADMIN_STATE_UP;
 	}
-	return MLX5_ESW_VPORT_ADMIN_STATE_AUTO;
+	return MLX5_VPORT_ADMIN_STATE_AUTO;
 }
 
 static int mlx5e_set_vf_link_state(struct net_device *dev, int vf,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 57987f6546e8..ea0fb36dbacf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -698,8 +698,8 @@ static int mlx5e_rep_open(struct net_device *dev)
 		goto unlock;
 
 	if (!mlx5_modify_vport_admin_state(priv->mdev,
-					   MLX5_QUERY_VPORT_STATE_IN_OP_MOD_ESW_VPORT,
-					   rep->vport, MLX5_ESW_VPORT_ADMIN_STATE_UP))
+					   MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+					   rep->vport, MLX5_VPORT_ADMIN_STATE_UP))
 		netif_carrier_on(dev);
 
 unlock:
@@ -716,8 +716,8 @@ static int mlx5e_rep_close(struct net_device *dev)
 
 	mutex_lock(&priv->state_lock);
 	mlx5_modify_vport_admin_state(priv->mdev,
-				      MLX5_QUERY_VPORT_STATE_IN_OP_MOD_ESW_VPORT,
-				      rep->vport, MLX5_ESW_VPORT_ADMIN_STATE_DOWN);
+				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+				      rep->vport, MLX5_VPORT_ADMIN_STATE_DOWN);
 	ret = mlx5e_close_locked(dev);
 	mutex_unlock(&priv->state_lock);
 	return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 4d316cc9b008..35ded91203f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -74,7 +74,7 @@ static int mlx5e_test_link_state(struct mlx5e_priv *priv)
 	if (!netif_carrier_ok(priv->netdev))
 		return 1;
 
-	port_state = mlx5_query_vport_state(priv->mdev, MLX5_QUERY_VPORT_STATE_IN_OP_MOD_VNIC_VPORT, 0);
+	port_state = mlx5_query_vport_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT, 0);
 	return port_state == VPORT_STATE_UP ? 0 : 1;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index f63dfbcd29fe..4e5305106695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1469,7 +1469,7 @@ static void esw_apply_vport_conf(struct mlx5_eswitch *esw,
 		return;
 
 	mlx5_modify_vport_admin_state(esw->dev,
-				      MLX5_QUERY_VPORT_STATE_IN_OP_MOD_ESW_VPORT,
+				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      vport_num,
 				      vport->info.link_state);
 	mlx5_modify_nic_vport_mac_address(esw->dev, vport_num, vport->info.mac);
@@ -1582,9 +1582,9 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, int vport_num)
 	esw_vport_disable_qos(esw, vport_num);
 	if (vport_num && esw->mode == SRIOV_LEGACY) {
 		mlx5_modify_vport_admin_state(esw->dev,
-					      MLX5_QUERY_VPORT_STATE_IN_OP_MOD_ESW_VPORT,
+					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 					      vport_num,
-					      MLX5_ESW_VPORT_ADMIN_STATE_DOWN);
+					      MLX5_VPORT_ADMIN_STATE_DOWN);
 		esw_vport_disable_egress_acl(esw, vport);
 		esw_vport_disable_ingress_acl(esw, vport);
 		esw_vport_destroy_drop_counters(vport);
@@ -1738,7 +1738,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		struct mlx5_vport *vport = &esw->vports[vport_num];
 
 		vport->vport = vport_num;
-		vport->info.link_state = MLX5_ESW_VPORT_ADMIN_STATE_AUTO;
+		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
 		vport->dev = dev;
 		INIT_WORK(&vport->vport_change_handler,
 			  esw_vport_change_handler);
@@ -1862,7 +1862,7 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 	evport = &esw->vports[vport];
 
 	err = mlx5_modify_vport_admin_state(esw->dev,
-					    MLX5_QUERY_VPORT_STATE_IN_OP_MOD_ESW_VPORT,
+					    MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 					    vport, link_state);
 	if (err) {
 		mlx5_core_warn(esw->dev,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0566c6a94805..4de9ac023e6e 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -939,9 +939,9 @@ enum {
 };
 
 enum {
-	MLX5_ESW_VPORT_ADMIN_STATE_DOWN  = 0x0,
-	MLX5_ESW_VPORT_ADMIN_STATE_UP    = 0x1,
-	MLX5_ESW_VPORT_ADMIN_STATE_AUTO  = 0x2,
+	MLX5_VPORT_ADMIN_STATE_DOWN  = 0x0,
+	MLX5_VPORT_ADMIN_STATE_UP    = 0x1,
+	MLX5_VPORT_ADMIN_STATE_AUTO  = 0x2,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2b0b6a8550bf..b2d9f0ecb897 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3763,8 +3763,8 @@ struct mlx5_ifc_query_vport_state_out_bits {
 };
 
 enum {
-	MLX5_QUERY_VPORT_STATE_IN_OP_MOD_VNIC_VPORT  = 0x0,
-	MLX5_QUERY_VPORT_STATE_IN_OP_MOD_ESW_VPORT   = 0x1,
+	MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT  = 0x0,
+	MLX5_VPORT_STATE_OP_MOD_ESW_VPORT   = 0x1,
 };
 
 struct mlx5_ifc_query_vport_state_in_bits {
-- 
2.17.0
