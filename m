From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 14/15] net/mlx5e: Ignore attempts to offload multiple times a TC flow
Date: Thu, 17 May 2018 18:22:57 -0700
Message-ID: <20180518012258.26968-15-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

For VF->VF and uplink->VF rules, the TC core (cls_api) attempts
to offload the same flow multiple times into the driver, b/c we
registered to the egdev callback.

Use the flow cookie to ignore attempts to add such flows, we can't
reject them (return error), b/c this will fail the offload attempt,
so we ignore that. We indentify wrong stat/del calls using the flow
ingress/egress flags, here we do return error to the core.

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 05c90b4f8a31..674f1d7d2737 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2666,6 +2666,12 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 
 	get_flags(flags, &flow_flags);
 
+	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
+	if (flow) {
+		netdev_warn_once(priv->netdev, "flow cookie %lx already exists, ignoring\n", f->cookie);
+		return 0;
+	}
+
 	if (esw && esw->mode == SRIOV_OFFLOADS) {
 		flow_flags |= MLX5E_TC_FLOW_ESWITCH;
 		attr_size  = sizeof(struct mlx5_esw_flow_attr);
@@ -2728,6 +2734,17 @@ int mlx5e_configure_flower(struct mlx5e_priv *priv,
 	return err;
 }
 
+#define DIRECTION_MASK (MLX5E_TC_INGRESS | MLX5E_TC_EGRESS)
+#define FLOW_DIRECTION_MASK (MLX5E_TC_FLOW_INGRESS | MLX5E_TC_FLOW_EGRESS)
+
+static bool same_flow_direction(struct mlx5e_tc_flow *flow, int flags)
+{
+	if ((flow->flags & FLOW_DIRECTION_MASK) == (flags & DIRECTION_MASK))
+		return true;
+
+	return false;
+}
+
 int mlx5e_delete_flower(struct mlx5e_priv *priv,
 			struct tc_cls_flower_offload *f, int flags)
 {
@@ -2735,7 +2752,7 @@ int mlx5e_delete_flower(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 
 	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
-	if (!flow)
+	if (!flow || !same_flow_direction(flow, flags))
 		return -EINVAL;
 
 	rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
@@ -2758,7 +2775,7 @@ int mlx5e_stats_flower(struct mlx5e_priv *priv,
 	u64 lastuse;
 
 	flow = rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
-	if (!flow)
+	if (!flow || !same_flow_direction(flow, flags))
 		return -EINVAL;
 
 	if (!(flow->flags & MLX5E_TC_FLOW_OFFLOADED))
-- 
2.17.0
