From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 10/15] net/mlx5e: Offload TC eswitch rules for VFs belonging to different PFs
Date: Thu, 17 May 2018 18:22:53 -0700
Message-ID: <20180518012258.26968-11-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Rabie Loulou <rabiel@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Rabie Loulou <rabiel@mellanox.com>

When the merged eswitch capability is supported, allow offloading rules
between VFs which belong to different PFs (and hence have different
eswitch affinity).

Signed-off-by: Rabie Loulou <rabiel@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Shahar Klein <shahark@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 630dd6dcabb9..77c3f8b8ae96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2077,6 +2077,20 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static bool is_merged_eswitch_dev(struct mlx5e_priv *priv,
+				  struct net_device *peer_netdev)
+{
+	struct mlx5e_priv *peer_priv;
+
+	peer_priv = netdev_priv(peer_netdev);
+
+	return (MLX5_CAP_ESW(priv->mdev, merged_eswitch) &&
+		(priv->netdev->netdev_ops == peer_netdev->netdev_ops) &&
+		same_hw_devs(priv, peer_priv) &&
+		MLX5_VPORT_MANAGER(peer_priv->mdev) &&
+		(peer_priv->mdev->priv.eswitch->mode == SRIOV_OFFLOADS));
+}
+
 static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
 				   struct net_device *mirred_dev,
 				   struct net_device **out_dev,
@@ -2535,7 +2549,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv, struct tcf_exts *exts,
 			out_dev = tcf_mirred_dev(a);
 
 			if (switchdev_port_same_parent_id(priv->netdev,
-							  out_dev)) {
+							  out_dev) ||
+			    is_merged_eswitch_dev(priv, out_dev)) {
 				action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 					  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 				out_priv = netdev_priv(out_dev);
-- 
2.17.0
