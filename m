From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 09/15] net/mlx5e: Explicitly set source e-switch in offloaded TC rules
Date: Thu, 17 May 2018 18:22:52 -0700
Message-ID: <20180518012258.26968-10-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Shahar Klein <shahark@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Shahar Klein <shahark@mellanox.com>

Set a specific source e-switch when setting a rule that matches on the
ingress port.

Signed-off-by: Shahar Klein <shahark@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h         | 1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 880adc810ccc..1d2ba687b902 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2462,6 +2462,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 
 	memset(attr, 0, sizeof(*attr));
 	attr->in_rep = rpriv->rep;
+	attr->in_mdev = priv->mdev;
 
 	tcf_exts_to_list(exts, &actions);
 	list_for_each_entry(a, &actions, list) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ac5db54823a1..98a306e02640 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -231,6 +231,7 @@ struct mlx5_esw_flow_attr {
 	struct mlx5_eswitch_rep *in_rep;
 	struct mlx5_eswitch_rep *out_rep;
 	struct mlx5_core_dev	*out_mdev;
+	struct mlx5_core_dev	*in_mdev;
 
 	int	action;
 	__be16	vlan_proto;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ea93867d1ab4..6c83eef5141a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -93,8 +93,16 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters);
 	MLX5_SET(fte_match_set_misc, misc, source_port, attr->in_rep->vport);
 
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		MLX5_SET(fte_match_set_misc, misc,
+			 source_eswitch_owner_vhca_id,
+			 MLX5_CAP_GEN(attr->in_mdev, vhca_id));
+
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc,
+				 source_eswitch_owner_vhca_id);
 
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS |
 				      MLX5_MATCH_MISC_PARAMETERS;
-- 
2.17.0
