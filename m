From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 07/15] net/mlx5e: Explicitly set destination e-switch in FDB rules
Date: Thu, 17 May 2018 18:22:50 -0700
Message-ID: <20180518012258.26968-8-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Rabie Loulou <rabiel@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Rabie Loulou <rabiel@mellanox.com>

Set a specific destination e-switch when setting a destination vport.

Signed-off-by: Rabie Loulou <rabiel@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Shahar Klein <shahark@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4197001f9801..880adc810ccc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -836,6 +836,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		out_priv = netdev_priv(encap_dev);
 		rpriv = out_priv->ppriv;
 		attr->out_rep = rpriv->rep;
+		attr->out_mdev = out_priv->mdev;
 	}
 
 	err = mlx5_eswitch_add_vlan_action(esw, attr);
@@ -2501,6 +2502,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 				out_priv = netdev_priv(out_dev);
 				rpriv = out_priv->ppriv;
 				attr->out_rep = rpriv->rep;
+				attr->out_mdev = out_priv->mdev;
 			} else if (encap) {
 				parse_attr->mirred_ifindex = out_dev->ifindex;
 				parse_attr->tun_info = *info;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 4cd773fa55e3..ac5db54823a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -230,6 +230,7 @@ enum {
 struct mlx5_esw_flow_attr {
 	struct mlx5_eswitch_rep *in_rep;
 	struct mlx5_eswitch_rep *out_rep;
+	struct mlx5_core_dev	*out_mdev;
 
 	int	action;
 	__be16	vlan_proto;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 90c8cb31e633..ea93867d1ab4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -72,6 +72,11 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 		dest[i].vport.num = attr->out_rep->vport;
+		if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+			dest[i].vport.vhca_id =
+				MLX5_CAP_GEN(attr->out_mdev, vhca_id);
+			dest[i].vport.vhca_id_valid = 1;
+		}
 		i++;
 	}
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-- 
2.17.0
