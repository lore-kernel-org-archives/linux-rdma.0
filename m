From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 12/15] net/mlx5e: Prepare for shared table to keep TC eswitch flows
Date: Thu, 17 May 2018 18:22:55 -0700
Message-ID: <20180518012258.26968-13-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

This is a refactoring step to be able and store the hash table which
keeps track of offloaded TC flows in a different location for NIC
vs e-switch rules.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 39 ++++++++++---------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 51a1d36a56c5..bc91a7335c93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -634,7 +634,6 @@ struct mlx5e_flow_table {
 struct mlx5e_tc_table {
 	struct mlx5_flow_table		*t;
 
-	struct rhashtable_params        ht_params;
 	struct rhashtable               ht;
 
 	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 26a1312ec9f8..1c90586d7f58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2634,12 +2634,24 @@ static void get_flags(int flags, u8 *flow_flags)
 	*flow_flags = __flow_flags;
 }
 
+static const struct rhashtable_params tc_ht_params = {
+	.head_offset = offsetof(struct mlx5e_tc_flow, node),
+	.key_offset = offsetof(struct mlx5e_tc_flow, cookie),
+	.key_len = sizeof(((struct mlx5e_tc_flow *)0)->cookie),
+	.automatic_shrinking = true,
+};
+
+static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv)
+{
+	return &priv->fs.tc.ht;
+}
+
 int mlx5e_configure_flower(struct mlx5e_priv *priv,
 			   struct tc_cls_flower_offload *f, int flags)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct rhashtable *tc_ht = get_tc_ht(priv);
 	struct mlx5e_tc_flow *flow;
 	int attr_size, err = 0;
 	u8 flow_flags = 0;
@@ -2693,8 +2705,7 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 	    !(flow->esw_attr->action & MLX5_FLOW_CONTEXT_ACTION_ENCAP))
 		kvfree(parse_attr);
 
-	err = rhashtable_insert_fast(&tc->ht, &flow->node,
-				     tc->ht_params);
+	err = rhashtable_insert_fast(tc_ht, &flow->node, tc_ht_params);
 	if (err) {
 		mlx5e_tc_del_flow(priv, flow);
 		kfree(flow);
@@ -2711,15 +2722,14 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 int mlx5e_delete_flower(struct mlx5e_priv *priv,
 			struct tc_cls_flower_offload *f, int flags)
 {
+	struct rhashtable *tc_ht = get_tc_ht(priv);
 	struct mlx5e_tc_flow *flow;
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
 
-	flow = rhashtable_lookup_fast(&tc->ht, &f->cookie,
-				      tc->ht_params);
+	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
 	if (!flow)
 		return -EINVAL;
 
-	rhashtable_remove_fast(&tc->ht, &flow->node, tc->ht_params);
+	rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
 
 	mlx5e_tc_del_flow(priv, flow);
 
@@ -2731,15 +2741,14 @@ int mlx5e_delete_flower(struct mlx5e_priv *priv,
 int mlx5e_stats_flower(struct mlx5e_priv *priv,
 		       struct tc_cls_flower_offload *f, int flags)
 {
-	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct rhashtable *tc_ht = get_tc_ht(priv);
 	struct mlx5e_tc_flow *flow;
 	struct mlx5_fc *counter;
 	u64 bytes;
 	u64 packets;
 	u64 lastuse;
 
-	flow = rhashtable_lookup_fast(&tc->ht, &f->cookie,
-				      tc->ht_params);
+	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
 	if (!flow)
 		return -EINVAL;
 
@@ -2757,13 +2766,6 @@ int mlx5e_stats_flower(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static const struct rhashtable_params mlx5e_tc_flow_ht_params = {
-	.head_offset = offsetof(struct mlx5e_tc_flow, node),
-	.key_offset = offsetof(struct mlx5e_tc_flow, cookie),
-	.key_len = sizeof(((struct mlx5e_tc_flow *)0)->cookie),
-	.automatic_shrinking = true,
-};
-
 int mlx5e_tc_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
@@ -2771,8 +2773,7 @@ int mlx5e_tc_init(struct mlx5e_priv *priv)
 	hash_init(tc->mod_hdr_tbl);
 	hash_init(tc->hairpin_tbl);
 
-	tc->ht_params = mlx5e_tc_flow_ht_params;
-	return rhashtable_init(&tc->ht, &tc->ht_params);
+	return rhashtable_init(&tc->ht, &tc_ht_params);
 }
 
 static void _mlx5e_tc_del_flow(void *ptr, void *arg)
-- 
2.17.0
