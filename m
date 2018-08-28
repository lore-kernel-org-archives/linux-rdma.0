From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 01/15] net/mlx5: Cleanup flow namespace getter switch logic
Date: Tue, 28 Aug 2018 14:18:40 +0300
Message-ID: <20180828111854.14367-2-leon@kernel.org>
References: <20180828111854.14367-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828111854.14367-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

Refactor the switch logic so it's simpler to follow and understand.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 24 ++++++-----------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index f418541af7cf..5624030d2ed4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1986,40 +1986,28 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		return NULL;
 
 	switch (type) {
-	case MLX5_FLOW_NAMESPACE_BYPASS:
-	case MLX5_FLOW_NAMESPACE_LAG:
-	case MLX5_FLOW_NAMESPACE_OFFLOADS:
-	case MLX5_FLOW_NAMESPACE_ETHTOOL:
-	case MLX5_FLOW_NAMESPACE_KERNEL:
-	case MLX5_FLOW_NAMESPACE_LEFTOVERS:
-	case MLX5_FLOW_NAMESPACE_ANCHOR:
-		prio = type;
-		break;
 	case MLX5_FLOW_NAMESPACE_FDB:
 		if (steering->fdb_root_ns)
 			return &steering->fdb_root_ns->ns;
-		else
-			return NULL;
+		return NULL;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_RX:
 		if (steering->sniffer_rx_root_ns)
 			return &steering->sniffer_rx_root_ns->ns;
-		else
-			return NULL;
+		return NULL;
 	case MLX5_FLOW_NAMESPACE_SNIFFER_TX:
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
-		else
-			return NULL;
+		return NULL;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
 		if (steering->egress_root_ns)
 			return &steering->egress_root_ns->ns;
-		else
-			return NULL;
-	default:
 		return NULL;
+	default:
+		break;
 	}
 
 	root_ns = steering->root_ns;
+	prio = type;
 	if (!root_ns)
 		return NULL;
 
-- 
2.14.4
