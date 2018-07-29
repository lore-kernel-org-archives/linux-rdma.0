From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 01/27] net/mlx5: Cleanup flow namespace getter switch logic
Date: Sun, 29 Jul 2018 15:58:39 +0300
Message-ID: <20180729125905.31989-2-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Refactor the switch logic so it's simpler to follow and understand.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 0d8378243903..17bbad8ee882 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1976,7 +1976,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 						    enum mlx5_flow_namespace_type type)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
-	struct mlx5_flow_root_namespace *root_ns;
+	struct mlx5_flow_root_namespace *steering_ns = NULL;
 	int prio;
 	struct fs_prio *fs_prio;
 	struct mlx5_flow_namespace *ns;
@@ -1992,37 +1992,33 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 	case MLX5_FLOW_NAMESPACE_KERNEL:
 	case MLX5_FLOW_NAMESPACE_LEFTOVERS:
 	case MLX5_FLOW_NAMESPACE_ANCHOR:
+		steering_ns = steering->root_ns;
 		prio = type;
 		break;
 	case MLX5_FLOW_NAMESPACE_FDB:
 		if (steering->fdb_root_ns)
 			return &steering->fdb_root_ns->ns;
-		else
-			return NULL;
+		break;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_RX:
 		if (steering->sniffer_rx_root_ns)
 			return &steering->sniffer_rx_root_ns->ns;
-		else
-			return NULL;
+		break;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_TX:
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
-		else
-			return NULL;
+		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
 		if (steering->egress_root_ns)
 			return &steering->egress_root_ns->ns;
-		else
-			return NULL;
+		break;
 	default:
-		return NULL;
+		break;
 	}
 
-	root_ns = steering->root_ns;
-	if (!root_ns)
+	if (!steering_ns)
 		return NULL;
 
-	fs_prio = find_prio(&root_ns->ns, prio);
+	fs_prio = find_prio(&steering_ns->ns, prio);
 	if (!fs_prio)
 		return NULL;
 
-- 
2.14.4
