From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/9] net/mlx4: Match DMFS promiscuous field names to firmware spec
Date: Wed, 24 Apr 2013 16:58:45 +0300
Message-ID: <1366811932-28199-3-git-send-email-ogerlitz@mellanox.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Align the names used by enum mlx4_net_trans_promisc_mode with the actual
firmware specification. The patch doesn't introduce any functional change
or API change towards the firmware.

Remove MLX4_FS_PROMISC_FUNCTION_PORT which isn't of use. Add new enums
MLX4_FS_{UC/MC}_SNIFFER as a preparation step for sniffer support.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |   16 ++++++++--------
 drivers/net/ethernet/mellanox/mlx4/mcg.c        |   21 ++++++++++-----------
 include/linux/mlx4/device.h                     |   11 ++++++-----
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 00f25b5..2047684 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -889,7 +889,7 @@ static int mlx4_en_flow_replace(struct net_device *dev,
 		.queue_mode = MLX4_NET_TRANS_Q_FIFO,
 		.exclusive = 0,
 		.allow_loopback = 1,
-		.promisc_mode = MLX4_FS_PROMISC_NONE,
+		.promisc_mode = MLX4_FS_REGULAR,
 	};
 
 	rule.port = priv->port;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 30d78f8..0860130 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -127,7 +127,7 @@ static void mlx4_en_filter_work(struct work_struct *work)
 		.queue_mode = MLX4_NET_TRANS_Q_LIFO,
 		.exclusive = 1,
 		.allow_loopback = 1,
-		.promisc_mode = MLX4_FS_PROMISC_NONE,
+		.promisc_mode = MLX4_FS_REGULAR,
 		.port = priv->port,
 		.priority = MLX4_DOMAIN_RFS,
 	};
@@ -446,7 +446,7 @@ static int mlx4_en_uc_steer_add(struct mlx4_en_priv *priv,
 			.queue_mode = MLX4_NET_TRANS_Q_FIFO,
 			.exclusive = 0,
 			.allow_loopback = 1,
-			.promisc_mode = MLX4_FS_PROMISC_NONE,
+			.promisc_mode = MLX4_FS_REGULAR,
 			.priority = MLX4_DOMAIN_NIC,
 		};
 
@@ -793,7 +793,7 @@ static void mlx4_en_set_promisc_mode(struct mlx4_en_priv *priv,
 			err = mlx4_flow_steer_promisc_add(mdev->dev,
 							  priv->port,
 							  priv->base_qpn,
-							  MLX4_FS_PROMISC_UPLINK);
+							  MLX4_FS_ALL_DEFAULT);
 			if (err)
 				en_err(priv, "Failed enabling promiscuous mode\n");
 			priv->flags |= MLX4_EN_FLAG_MC_PROMISC;
@@ -856,7 +856,7 @@ static void mlx4_en_clear_promisc_mode(struct mlx4_en_priv *priv,
 	case MLX4_STEERING_MODE_DEVICE_MANAGED:
 		err = mlx4_flow_steer_promisc_remove(mdev->dev,
 						     priv->port,
-						     MLX4_FS_PROMISC_UPLINK);
+						     MLX4_FS_ALL_DEFAULT);
 		if (err)
 			en_err(priv, "Failed disabling promiscuous mode\n");
 		priv->flags &= ~MLX4_EN_FLAG_MC_PROMISC;
@@ -917,7 +917,7 @@ static void mlx4_en_do_multicast(struct mlx4_en_priv *priv,
 				err = mlx4_flow_steer_promisc_add(mdev->dev,
 								  priv->port,
 								  priv->base_qpn,
-								  MLX4_FS_PROMISC_ALL_MULTI);
+								  MLX4_FS_MC_DEFAULT);
 				break;
 
 			case MLX4_STEERING_MODE_B0:
@@ -940,7 +940,7 @@ static void mlx4_en_do_multicast(struct mlx4_en_priv *priv,
 			case MLX4_STEERING_MODE_DEVICE_MANAGED:
 				err = mlx4_flow_steer_promisc_remove(mdev->dev,
 								     priv->port,
-								     MLX4_FS_PROMISC_ALL_MULTI);
+								     MLX4_FS_MC_DEFAULT);
 				break;
 
 			case MLX4_STEERING_MODE_B0:
@@ -1598,10 +1598,10 @@ void mlx4_en_stop_port(struct net_device *dev, int detach)
 				 MLX4_EN_FLAG_MC_PROMISC);
 		mlx4_flow_steer_promisc_remove(mdev->dev,
 					       priv->port,
-					       MLX4_FS_PROMISC_UPLINK);
+					       MLX4_FS_ALL_DEFAULT);
 		mlx4_flow_steer_promisc_remove(mdev->dev,
 					       priv->port,
-					       MLX4_FS_PROMISC_ALL_MULTI);
+					       MLX4_FS_MC_DEFAULT);
 	} else if (priv->flags & MLX4_EN_FLAG_PROMISC) {
 		priv->flags &= ~MLX4_EN_FLAG_PROMISC;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 5268552..d1f01dc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -649,10 +649,11 @@ static void trans_rule_ctrl_to_hw(struct mlx4_net_trans_rule *ctrl,
 				  struct mlx4_net_trans_rule_hw_ctrl *hw)
 {
 	static const u8 __promisc_mode[] = {
-		[MLX4_FS_PROMISC_NONE]   = 0x0,
-		[MLX4_FS_PROMISC_UPLINK] = 0x1,
-		[MLX4_FS_PROMISC_FUNCTION_PORT] = 0x2,
-		[MLX4_FS_PROMISC_ALL_MULTI] = 0x3,
+		[MLX4_FS_REGULAR]	= 0x0,
+		[MLX4_FS_ALL_DEFAULT]	= 0x1,
+		[MLX4_FS_MC_DEFAULT]	= 0x3,
+		[MLX4_FS_UC_SNIFFER]	= 0x4,
+		[MLX4_FS_MC_SNIFFER]	= 0x5,
 	};
 
 	u32 dw = 0;
@@ -1153,7 +1154,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 		struct mlx4_net_trans_rule rule = {
 			.queue_mode = MLX4_NET_TRANS_Q_FIFO,
 			.exclusive = 0,
-			.promisc_mode = MLX4_FS_PROMISC_NONE,
+			.promisc_mode = MLX4_FS_REGULAR,
 			.priority = MLX4_DOMAIN_NIC,
 		};
 
@@ -1222,11 +1223,10 @@ int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev, u8 port,
 	u64 *regid_p;
 
 	switch (mode) {
-	case MLX4_FS_PROMISC_UPLINK:
-	case MLX4_FS_PROMISC_FUNCTION_PORT:
+	case MLX4_FS_ALL_DEFAULT:
 		regid_p = &dev->regid_promisc_array[port];
 		break;
-	case MLX4_FS_PROMISC_ALL_MULTI:
+	case MLX4_FS_MC_DEFAULT:
 		regid_p = &dev->regid_allmulti_array[port];
 		break;
 	default:
@@ -1253,11 +1253,10 @@ int mlx4_flow_steer_promisc_remove(struct mlx4_dev *dev, u8 port,
 	u64 *regid_p;
 
 	switch (mode) {
-	case MLX4_FS_PROMISC_UPLINK:
-	case MLX4_FS_PROMISC_FUNCTION_PORT:
+	case MLX4_FS_ALL_DEFAULT:
 		regid_p = &dev->regid_promisc_array[port];
 		break;
-	case MLX4_FS_PROMISC_ALL_MULTI:
+	case MLX4_FS_MC_DEFAULT:
 		regid_p = &dev->regid_allmulti_array[port];
 		break;
 	default:
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 9fbf416..b2fe59d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -896,11 +896,12 @@ static inline int map_hw_to_sw_id(u16 header_id)
 }
 
 enum mlx4_net_trans_promisc_mode {
-	MLX4_FS_PROMISC_NONE = 0,
-	MLX4_FS_PROMISC_UPLINK,
-	/* For future use. Not implemented yet */
-	MLX4_FS_PROMISC_FUNCTION_PORT,
-	MLX4_FS_PROMISC_ALL_MULTI,
+	MLX4_FS_REGULAR = 1,
+	MLX4_FS_ALL_DEFAULT,
+	MLX4_FS_MC_DEFAULT,
+	MLX4_FS_UC_SNIFFER,
+	MLX4_FS_MC_SNIFFER,
+
 };
 
 struct mlx4_spec_eth {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
