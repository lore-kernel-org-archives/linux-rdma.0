From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/9] net/mlx4_core: Expose few helpers to fill DMFS HW strucutures
Date: Wed, 24 Apr 2013 16:58:48 +0300
Message-ID: <1366811932-28199-6-git-send-email-ogerlitz@mellanox.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Re-arrange some of code which fills DMFS HW structures so we can use it from
within the core driver and from the IB driver too, e.g when verbs DMFS
structures are transformed into mlx4 Hardware structs.

Also, add struct mlx4_flow_handle struct which will be of use by the DMFS
verbs flow in the IB driver.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/mcg.c |   85 +++++++++++++++++++++---------
 include/linux/mlx4/device.h              |   12 ++++-
 2 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 07712f9..00b4e7b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -645,17 +645,28 @@ static int find_entry(struct mlx4_dev *dev, u8 port,
 	return err;
 }
 
+static const u8 __promisc_mode[] = {
+	[MLX4_FS_REGULAR]   = 0x0,
+	[MLX4_FS_ALL_DEFAULT] = 0x1,
+	[MLX4_FS_MC_DEFAULT] = 0x3,
+	[MLX4_FS_UC_SNIFFER] = 0x4,
+	[MLX4_FS_MC_SNIFFER] = 0x5,
+};
+
+int mlx4_map_sw_to_hw_steering_mode(struct mlx4_dev *dev,
+				    enum mlx4_net_trans_promisc_mode flow_type)
+{
+	if (flow_type >= MLX4_FS_MODE_NUM || flow_type < 0) {
+		mlx4_err(dev, "Invalid flow type. type = %d\n", flow_type);
+		return -EINVAL;
+	}
+	return __promisc_mode[flow_type];
+}
+EXPORT_SYMBOL_GPL(mlx4_map_sw_to_hw_steering_mode);
+
 static void trans_rule_ctrl_to_hw(struct mlx4_net_trans_rule *ctrl,
 				  struct mlx4_net_trans_rule_hw_ctrl *hw)
 {
-	static const u8 __promisc_mode[] = {
-		[MLX4_FS_REGULAR]	= 0x0,
-		[MLX4_FS_ALL_DEFAULT]	= 0x1,
-		[MLX4_FS_MC_DEFAULT]	= 0x3,
-		[MLX4_FS_UC_SNIFFER]	= 0x4,
-		[MLX4_FS_MC_SNIFFER]	= 0x5,
-	};
-
 	u8 flags = 0;
 
 	flags = ctrl->queue_mode == MLX4_NET_TRANS_Q_LIFO ? 1 : 0;
@@ -678,29 +689,51 @@ const u16 __sw_id_hw[] = {
 	[MLX4_NET_TRANS_RULE_ID_UDP]     = 0xE006
 };
 
+int mlx4_map_sw_to_hw_steering_id(struct mlx4_dev *dev,
+				  enum mlx4_net_trans_rule_id id)
+{
+	if (id >= MLX4_NET_TRANS_RULE_NUM || id < 0) {
+		mlx4_err(dev, "Invalid network rule id. id = %d\n", id);
+		return -EINVAL;
+	}
+	return __sw_id_hw[id];
+}
+EXPORT_SYMBOL_GPL(mlx4_map_sw_to_hw_steering_id);
+
+static const int __rule_hw_sz[] = {
+	[MLX4_NET_TRANS_RULE_ID_ETH] =
+		sizeof(struct mlx4_net_trans_rule_hw_eth),
+	[MLX4_NET_TRANS_RULE_ID_IB] =
+		sizeof(struct mlx4_net_trans_rule_hw_ib),
+	[MLX4_NET_TRANS_RULE_ID_IPV6] = 0,
+	[MLX4_NET_TRANS_RULE_ID_IPV4] =
+		sizeof(struct mlx4_net_trans_rule_hw_ipv4),
+	[MLX4_NET_TRANS_RULE_ID_TCP] =
+		sizeof(struct mlx4_net_trans_rule_hw_tcp_udp),
+	[MLX4_NET_TRANS_RULE_ID_UDP] =
+		sizeof(struct mlx4_net_trans_rule_hw_tcp_udp)
+};
+
+int mlx4_hw_rule_sz(struct mlx4_dev *dev,
+	       enum mlx4_net_trans_rule_id id)
+{
+	if (id >= MLX4_NET_TRANS_RULE_NUM || id < 0) {
+		mlx4_err(dev, "Invalid network rule id. id = %d\n", id);
+		return -EINVAL;
+	}
+
+	return __rule_hw_sz[id];
+}
+EXPORT_SYMBOL_GPL(mlx4_hw_rule_sz);
+
 static int parse_trans_rule(struct mlx4_dev *dev, struct mlx4_spec_list *spec,
 			    struct _rule_hw *rule_hw)
 {
-	static const size_t __rule_hw_sz[] = {
-		[MLX4_NET_TRANS_RULE_ID_ETH] =
-			sizeof(struct mlx4_net_trans_rule_hw_eth),
-		[MLX4_NET_TRANS_RULE_ID_IB] =
-			sizeof(struct mlx4_net_trans_rule_hw_ib),
-		[MLX4_NET_TRANS_RULE_ID_IPV6] = 0,
-		[MLX4_NET_TRANS_RULE_ID_IPV4] =
-			sizeof(struct mlx4_net_trans_rule_hw_ipv4),
-		[MLX4_NET_TRANS_RULE_ID_TCP] =
-			sizeof(struct mlx4_net_trans_rule_hw_tcp_udp),
-		[MLX4_NET_TRANS_RULE_ID_UDP] =
-			sizeof(struct mlx4_net_trans_rule_hw_tcp_udp)
-	};
-	if (spec->id >= MLX4_NET_TRANS_RULE_NUM) {
-		mlx4_err(dev, "Invalid network rule id. id = %d\n", spec->id);
+	if (mlx4_hw_rule_sz(dev, spec->id) < 0)
 		return -EINVAL;
-	}
-	memset(rule_hw, 0, __rule_hw_sz[spec->id]);
+	memset(rule_hw, 0, mlx4_hw_rule_sz(dev, spec->id));
 	rule_hw->id = cpu_to_be16(__sw_id_hw[spec->id]);
-	rule_hw->size = __rule_hw_sz[spec->id] >> 2;
+	rule_hw->size = mlx4_hw_rule_sz(dev, spec->id) >> 2;
 
 	switch (spec->id) {
 	case MLX4_NET_TRANS_RULE_ID_ETH:
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 08e5bc1..ad4a53f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -901,7 +901,7 @@ enum mlx4_net_trans_promisc_mode {
 	MLX4_FS_MC_DEFAULT,
 	MLX4_FS_UC_SNIFFER,
 	MLX4_FS_MC_SNIFFER,
-
+	MLX4_FS_MODE_NUM, /* should be last */
 };
 
 struct mlx4_spec_eth {
@@ -1044,6 +1044,11 @@ struct _rule_hw {
 	};
 };
 
+/* translating DMFS verbs sniffer rule to the FW API would need two reg IDs */
+struct mlx4_flow_handle {
+	u64 reg_id[2];
+};
+
 int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev, u8 port, u32 qpn,
 				enum mlx4_net_trans_promisc_mode mode);
 int mlx4_flow_steer_promisc_remove(struct mlx4_dev *dev, u8 port,
@@ -1093,6 +1098,11 @@ void mlx4_counter_free(struct mlx4_dev *dev, u32 idx);
 int mlx4_flow_attach(struct mlx4_dev *dev,
 		     struct mlx4_net_trans_rule *rule, u64 *reg_id);
 int mlx4_flow_detach(struct mlx4_dev *dev, u64 reg_id);
+int mlx4_map_sw_to_hw_steering_mode(struct mlx4_dev *dev,
+				    enum mlx4_net_trans_promisc_mode flow_type);
+int mlx4_map_sw_to_hw_steering_id(struct mlx4_dev *dev,
+				  enum mlx4_net_trans_rule_id id);
+int mlx4_hw_rule_sz(struct mlx4_dev *dev, enum mlx4_net_trans_rule_id id);
 
 void mlx4_sync_pkey_table(struct mlx4_dev *dev, int slave, int port,
 			  int i, int val);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
