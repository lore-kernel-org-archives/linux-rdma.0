From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 5/6] net/mlx5: Add lag affinity info to log
Date: Wed, 12 Dec 2018 19:11:40 -0800
Message-ID: <20181213031141.12783-6-saeedm@mellanox.com>
References: <20181213031141.12783-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213031141.12783-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Roi Dayan <roid@mellanox.com>, Shahar Klein <shahark@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Report the initial LAG port affinity upon LAG creation.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Shahar Klein <shahark@mellanox.com>
Reviewed-by: Aviv Heller <avivh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 75f7c8efaab5..448d9d5c689c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -195,6 +195,9 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[0],
 				       &ldev->v2p_map[1]);
 
+	mlx5_core_info(dev0, "lag map port 1:%d port 2:%d",
+		       ldev->v2p_map[0], ldev->v2p_map[1]);
+
 	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map[0], ldev->v2p_map[1]);
 	if (err)
 		mlx5_core_err(dev0,
-- 
2.19.2
