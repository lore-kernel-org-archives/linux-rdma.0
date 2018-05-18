From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 11/15] net/mlx5e: Add ingress/egress indication for offloaded TC flows
Date: Thu, 17 May 2018 18:22:54 -0700
Message-ID: <20180518012258.26968-12-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

When an e-switch TC rule is offloaded through the egdev (egress
device) mechanism, we treat this as egress, all other cases (NIC
and e-switch) are considred ingress.

This is preparation step that will allow us to  identify "wrong"
stat/del offload calls made by the TC core on egdev based flows and
ignore them.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 --
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 15 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 32 ++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 38 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   | 13 +++++--
 5 files changed, 70 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7c930088e96e..51a1d36a56c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1118,9 +1118,6 @@ int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
 int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
 			       struct ethtool_flash *flash);
 
-int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
-			    void *cb_priv);
-
 /* mlx5e generic netdev management API */
 struct net_device*
 mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *profile,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 417bf2e8ab85..27e8375a476b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3136,22 +3136,23 @@ static int mlx5e_setup_tc_mqprio(struct net_device *netdev,
 
 #ifdef CONFIG_MLX5_ESWITCH
 static int mlx5e_setup_tc_cls_flower(struct mlx5e_priv *priv,
-				     struct tc_cls_flower_offload *cls_flower)
+				     struct tc_cls_flower_offload *cls_flower,
+				     int flags)
 {
 	switch (cls_flower->command) {
 	case TC_CLSFLOWER_REPLACE:
-		return mlx5e_configure_flower(priv, cls_flower);
+		return mlx5e_configure_flower(priv, cls_flower, flags);
 	case TC_CLSFLOWER_DESTROY:
-		return mlx5e_delete_flower(priv, cls_flower);
+		return mlx5e_delete_flower(priv, cls_flower, flags);
 	case TC_CLSFLOWER_STATS:
-		return mlx5e_stats_flower(priv, cls_flower);
+		return mlx5e_stats_flower(priv, cls_flower, flags);
 	default:
 		return -EOPNOTSUPP;
 	}
 }
 
-int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
-			    void *cb_priv)
+static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
+				   void *cb_priv)
 {
 	struct mlx5e_priv *priv = cb_priv;
 
@@ -3160,7 +3161,7 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		return mlx5e_setup_tc_cls_flower(priv, type_data);
+		return mlx5e_setup_tc_cls_flower(priv, type_data, MLX5E_TC_INGRESS);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a689f4c90fe3..182b636552a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -723,15 +723,31 @@ static int mlx5e_rep_get_phys_port_name(struct net_device *dev,
 
 static int
 mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *priv,
-			      struct tc_cls_flower_offload *cls_flower)
+			      struct tc_cls_flower_offload *cls_flower, int flags)
 {
 	switch (cls_flower->command) {
 	case TC_CLSFLOWER_REPLACE:
-		return mlx5e_configure_flower(priv, cls_flower);
+		return mlx5e_configure_flower(priv, cls_flower, flags);
 	case TC_CLSFLOWER_DESTROY:
-		return mlx5e_delete_flower(priv, cls_flower);
+		return mlx5e_delete_flower(priv, cls_flower, flags);
 	case TC_CLSFLOWER_STATS:
-		return mlx5e_stats_flower(priv, cls_flower);
+		return mlx5e_stats_flower(priv, cls_flower, flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlx5e_rep_setup_tc_cb_egdev(enum tc_setup_type type, void *type_data,
+				       void *cb_priv)
+{
+	struct mlx5e_priv *priv = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(priv->netdev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, MLX5E_TC_EGRESS);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -747,7 +763,7 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
-		return mlx5e_rep_setup_tc_cls_flower(priv, type_data);
+		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, MLX5E_TC_INGRESS);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1107,7 +1123,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	uplink_rpriv = mlx5_eswitch_get_uplink_priv(dev->priv.eswitch, REP_ETH);
 	upriv = netdev_priv(uplink_rpriv->netdev);
-	err = tc_setup_cb_egdev_register(netdev, mlx5e_setup_tc_block_cb,
+	err = tc_setup_cb_egdev_register(netdev, mlx5e_rep_setup_tc_cb_egdev,
 					 upriv);
 	if (err)
 		goto err_neigh_cleanup;
@@ -1122,7 +1138,7 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return 0;
 
 err_egdev_cleanup:
-	tc_setup_cb_egdev_unregister(netdev, mlx5e_setup_tc_block_cb,
+	tc_setup_cb_egdev_unregister(netdev, mlx5e_rep_setup_tc_cb_egdev,
 				     upriv);
 
 err_neigh_cleanup:
@@ -1151,7 +1167,7 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	uplink_rpriv = mlx5_eswitch_get_uplink_priv(priv->mdev->priv.eswitch,
 						    REP_ETH);
 	upriv = netdev_priv(uplink_rpriv->netdev);
-	tc_setup_cb_egdev_unregister(netdev, mlx5e_setup_tc_block_cb,
+	tc_setup_cb_egdev_unregister(netdev, mlx5e_rep_setup_tc_cb_egdev,
 				     upriv);
 	mlx5e_rep_neigh_cleanup(rpriv);
 	mlx5e_detach_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 77c3f8b8ae96..26a1312ec9f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -62,12 +62,16 @@ struct mlx5_nic_flow_attr {
 	struct mlx5_flow_table	*hairpin_ft;
 };
 
+#define MLX5E_TC_FLOW_BASE (MLX5E_TC_LAST_EXPORTED_BIT + 1)
+
 enum {
-	MLX5E_TC_FLOW_ESWITCH	= BIT(0),
-	MLX5E_TC_FLOW_NIC	= BIT(1),
-	MLX5E_TC_FLOW_OFFLOADED	= BIT(2),
-	MLX5E_TC_FLOW_HAIRPIN	= BIT(3),
-	MLX5E_TC_FLOW_HAIRPIN_RSS = BIT(4),
+	MLX5E_TC_FLOW_INGRESS	= MLX5E_TC_INGRESS,
+	MLX5E_TC_FLOW_EGRESS	= MLX5E_TC_EGRESS,
+	MLX5E_TC_FLOW_ESWITCH	= BIT(MLX5E_TC_FLOW_BASE),
+	MLX5E_TC_FLOW_NIC	= BIT(MLX5E_TC_FLOW_BASE + 1),
+	MLX5E_TC_FLOW_OFFLOADED	= BIT(MLX5E_TC_FLOW_BASE + 2),
+	MLX5E_TC_FLOW_HAIRPIN	= BIT(MLX5E_TC_FLOW_BASE + 3),
+	MLX5E_TC_FLOW_HAIRPIN_RSS = BIT(MLX5E_TC_FLOW_BASE + 4),
 };
 
 struct mlx5e_tc_flow {
@@ -2618,8 +2622,20 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 	return 0;
 }
 
+static void get_flags(int flags, u8 *flow_flags)
+{
+	u8 __flow_flags = 0;
+
+	if (flags & MLX5E_TC_INGRESS)
+		__flow_flags |= MLX5E_TC_FLOW_INGRESS;
+	if (flags & MLX5E_TC_EGRESS)
+		__flow_flags |= MLX5E_TC_FLOW_EGRESS;
+
+	*flow_flags = __flow_flags;
+}
+
 int mlx5e_configure_flower(struct mlx5e_priv *priv,
-			   struct tc_cls_flower_offload *f)
+			   struct tc_cls_flower_offload *f, int flags)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
@@ -2628,11 +2644,13 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 	int attr_size, err = 0;
 	u8 flow_flags = 0;
 
+	get_flags(flags, &flow_flags);
+
 	if (esw && esw->mode == SRIOV_OFFLOADS) {
-		flow_flags = MLX5E_TC_FLOW_ESWITCH;
+		flow_flags |= MLX5E_TC_FLOW_ESWITCH;
 		attr_size  = sizeof(struct mlx5_esw_flow_attr);
 	} else {
-		flow_flags = MLX5E_TC_FLOW_NIC;
+		flow_flags |= MLX5E_TC_FLOW_NIC;
 		attr_size  = sizeof(struct mlx5_nic_flow_attr);
 	}
 
@@ -2691,7 +2709,7 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 }
 
 int mlx5e_delete_flower(struct mlx5e_priv *priv,
-			struct tc_cls_flower_offload *f)
+			struct tc_cls_flower_offload *f, int flags)
 {
 	struct mlx5e_tc_flow *flow;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
@@ -2711,7 +2729,7 @@ int mlx5e_delete_flower(struct mlx5e_priv *priv,
 }
 
 int mlx5e_stats_flower(struct mlx5e_priv *priv,
-		       struct tc_cls_flower_offload *f)
+		       struct tc_cls_flower_offload *f, int flags)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct mlx5e_tc_flow *flow;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index c14c263a739b..2255345c2e18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -38,16 +38,23 @@
 #define MLX5E_TC_FLOW_ID_MASK 0x0000ffff
 
 #ifdef CONFIG_MLX5_ESWITCH
+
+enum {
+	MLX5E_TC_INGRESS = BIT(0),
+	MLX5E_TC_EGRESS  = BIT(1),
+	MLX5E_TC_LAST_EXPORTED_BIT = 1,
+};
+
 int mlx5e_tc_init(struct mlx5e_priv *priv);
 void mlx5e_tc_cleanup(struct mlx5e_priv *priv);
 
 int mlx5e_configure_flower(struct mlx5e_priv *priv,
-			   struct tc_cls_flower_offload *f);
+			   struct tc_cls_flower_offload *f, int flags);
 int mlx5e_delete_flower(struct mlx5e_priv *priv,
-			struct tc_cls_flower_offload *f);
+			struct tc_cls_flower_offload *f, int flags);
 
 int mlx5e_stats_flower(struct mlx5e_priv *priv,
-		       struct tc_cls_flower_offload *f);
+		       struct tc_cls_flower_offload *f, int flags);
 
 struct mlx5e_encap_entry;
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
-- 
2.17.0
