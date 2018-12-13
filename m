From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 4/6] net/mlx5: Split the activate lag function into two routines
Date: Wed, 12 Dec 2018 19:11:39 -0800
Message-ID: <20181213031141.12783-5-saeedm@mellanox.com>
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

Split the activate lag function in order to be symmetric with
the deactivate lag function.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Shahar Klein <shahark@mellanox.com>
Reviewed-by: Aviv Heller <avivh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 582b2f18010a..75f7c8efaab5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -186,14 +186,12 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 		*port2 = 1;
 }
 
-static void mlx5_activate_lag(struct mlx5_lag *ldev,
-			      struct lag_tracker *tracker)
+static int mlx5_create_lag(struct mlx5_lag *ldev,
+			   struct lag_tracker *tracker)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[0].dev;
 	int err;
 
-	ldev->flags |= MLX5_LAG_FLAG_BONDED;
-
 	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[0],
 				       &ldev->v2p_map[1]);
 
@@ -202,6 +200,14 @@ static void mlx5_activate_lag(struct mlx5_lag *ldev,
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
 			      err);
+	return err;
+}
+
+static void mlx5_activate_lag(struct mlx5_lag *ldev,
+			      struct lag_tracker *tracker)
+{
+	ldev->flags |= MLX5_LAG_FLAG_BONDED;
+	mlx5_create_lag(ldev, tracker);
 }
 
 static void mlx5_deactivate_lag(struct mlx5_lag *ldev)
-- 
2.19.2
