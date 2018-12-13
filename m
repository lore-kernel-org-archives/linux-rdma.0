From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 6/6] net/mlx5: Fold the modify lag code into function
Date: Wed, 12 Dec 2018 19:11:41 -0800
Message-ID: <20181213031141.12783-7-saeedm@mellanox.com>
References: <20181213031141.12783-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213031141.12783-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Shahar Klein <shahark@mellanox.com>, Roi Dayan <roid@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Shahar Klein <shahark@mellanox.com>

Handle the code of modifying the lag affinity within a separate function.

Signed-off-by: Shahar Klein <shahark@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Aviv Heller <avivh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 44 ++++++++++++-------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 448d9d5c689c..8c5c5e418d61 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -186,6 +186,32 @@ static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
 		*port2 = 1;
 }
 
+static void mlx5_modify_lag(struct mlx5_lag *ldev,
+			    struct lag_tracker *tracker)
+{
+	struct mlx5_core_dev *dev0 = ldev->pf[0].dev;
+	u8 v2p_port1, v2p_port2;
+	int err;
+
+	mlx5_infer_tx_affinity_mapping(tracker, &v2p_port1,
+				       &v2p_port2);
+
+	if (v2p_port1 != ldev->v2p_map[0] ||
+	    v2p_port2 != ldev->v2p_map[1]) {
+		ldev->v2p_map[0] = v2p_port1;
+		ldev->v2p_map[1] = v2p_port2;
+
+		mlx5_core_info(dev0, "modify lag map port 1:%d port 2:%d",
+			       ldev->v2p_map[0], ldev->v2p_map[1]);
+
+		err = mlx5_cmd_modify_lag(dev0, v2p_port1, v2p_port2);
+		if (err)
+			mlx5_core_err(dev0,
+				      "Failed to modify LAG (%d)\n",
+				      err);
+	}
+}
+
 static int mlx5_create_lag(struct mlx5_lag *ldev,
 			   struct lag_tracker *tracker)
 {
@@ -232,8 +258,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	struct mlx5_core_dev *dev0 = ldev->pf[0].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[1].dev;
 	struct lag_tracker tracker;
-	u8 v2p_port1, v2p_port2;
-	int i, err;
+	int i;
 	bool do_bond;
 
 	if (!dev0 || !dev1)
@@ -255,20 +280,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		mlx5_add_dev_by_protocol(dev0, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_nic_vport_enable_roce(dev1);
 	} else if (do_bond && mlx5_lag_is_bonded(ldev)) {
-		mlx5_infer_tx_affinity_mapping(&tracker, &v2p_port1,
-					       &v2p_port2);
-
-		if ((v2p_port1 != ldev->v2p_map[0]) ||
-		    (v2p_port2 != ldev->v2p_map[1])) {
-			ldev->v2p_map[0] = v2p_port1;
-			ldev->v2p_map[1] = v2p_port2;
-
-			err = mlx5_cmd_modify_lag(dev0, v2p_port1, v2p_port2);
-			if (err)
-				mlx5_core_err(dev0,
-					      "Failed to modify LAG (%d)\n",
-					      err);
-		}
+		mlx5_modify_lag(ldev, &tracker);
 	} else if (!do_bond && mlx5_lag_is_bonded(ldev)) {
 		mlx5_remove_dev_by_protocol(dev0, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_nic_vport_disable_roce(dev1);
-- 
2.19.2
