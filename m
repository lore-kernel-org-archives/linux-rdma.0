From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/6] net/mlx4_core: Add support for steer-able IB UD QPs
Date: Thu,  7 Nov 2013 15:25:14 +0200
Message-ID: <1383830717-17312-4-git-send-email-ogerlitz@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds support for allocating IB UD QPs that we could steer
traffic from them. In order to do that, we introduce a new firmware
command FLOW_STEERING_IB_UC_QP_RANGE and a capability bit.

This command isn't supported for VFs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |    9 +++++++++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   10 ++++++++++
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   17 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    5 +++++
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   10 ++++++++++
 include/linux/mlx4/cmd.h                           |    1 +
 include/linux/mlx4/device.h                        |    6 +++++-
 7 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index ea20182..d7f9003 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1371,6 +1371,15 @@ static struct mlx4_cmd_info cmd_info[] = {
 		.verify = NULL,
 		.wrapper = mlx4_QP_FLOW_STEERING_DETACH_wrapper
 	},
+	{
+		.opcode = MLX4_FLOW_STEERING_IB_UC_QP_RANGE,
+		.has_inbox = false,
+		.has_outbox = false,
+		.out_is_imm = false,
+		.encode_slave_id = false,
+		.verify = NULL,
+		.wrapper = mlx4_FLOW_STEERING_IB_UC_QP_RANGE_wrapper
+	},
 };
 
 static int mlx4_master_process_vhcr(struct mlx4_dev *dev, int slave,
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 0d63daa..69558e7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -472,6 +472,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAX_XRC_OFFSET		0x67
 #define QUERY_DEV_CAP_MAX_COUNTERS_OFFSET	0x68
 #define QUERY_DEV_CAP_EXT_2_FLAGS_OFFSET	0x70
+#define QUERY_DEV_CAP_FLOW_STEERING_IPOIB_OFFSET	0x74
 #define QUERY_DEV_CAP_FLOW_STEERING_RANGE_EN_OFFSET	0x76
 #define QUERY_DEV_CAP_FLOW_STEERING_MAX_QP_OFFSET	0x77
 #define QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET	0x80
@@ -562,6 +563,9 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	if (field & 0x80)
 		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_FS_EN;
 	dev_cap->fs_log_max_ucast_qp_range_size = field & 0x1f;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_FLOW_STEERING_IPOIB_OFFSET);
+	if (field & 0x80)
+		dev_cap->flags2 |= MLX4_DEV_CAP_FLAG2_DMFS_IPOIB;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_FLOW_STEERING_MAX_QP_OFFSET);
 	dev_cap->fs_max_num_qp_per_entry = field;
 	MLX4_GET(stat_rate, outbox, QUERY_DEV_CAP_RATE_SUPPORT_OFFSET);
@@ -819,6 +823,12 @@ int mlx4_QUERY_DEV_CAP_wrapper(struct mlx4_dev *dev, int slave,
 		MLX4_PUT(outbox->buf, field,
 			 QUERY_DEV_CAP_FLOW_STEERING_RANGE_EN_OFFSET);
 	}
+
+	/* turn off ipoib managed steering for guests */
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_FLOW_STEERING_IPOIB_OFFSET);
+	field &= ~0x80;
+	MLX4_PUT(outbox->buf, field, QUERY_DEV_CAP_FLOW_STEERING_IPOIB_OFFSET);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 55f6245..98f55d9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -897,6 +897,23 @@ int mlx4_flow_detach(struct mlx4_dev *dev, u64 reg_id)
 }
 EXPORT_SYMBOL_GPL(mlx4_flow_detach);
 
+int mlx4_FLOW_STEERING_IB_UC_QP_RANGE(struct mlx4_dev *dev, u32 min_range_qpn,
+				      u32 max_range_qpn)
+{
+	int err;
+	u64 in_param;
+
+	in_param = ((u64) min_range_qpn) << 32;
+	in_param |= ((u64) max_range_qpn) & 0xFFFFFFFF;
+
+	err = mlx4_cmd(dev, in_param, 0, 0,
+			MLX4_FLOW_STEERING_IB_UC_QP_RANGE,
+			MLX4_CMD_TIME_CLASS_A, MLX4_CMD_NATIVE);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx4_FLOW_STEERING_IB_UC_QP_RANGE);
+
 int mlx4_qp_attach_common(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 			  int block_mcast_loopback, enum mlx4_protocol prot,
 			  enum mlx4_steer_type steer)
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index 348bb8c..069ca2d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -1219,6 +1219,11 @@ int mlx4_QP_FLOW_STEERING_DETACH_wrapper(struct mlx4_dev *dev, int slave,
 					 struct mlx4_cmd_mailbox *inbox,
 					 struct mlx4_cmd_mailbox *outbox,
 					 struct mlx4_cmd_info *cmd);
+int mlx4_FLOW_STEERING_IB_UC_QP_RANGE_wrapper(struct mlx4_dev *dev, int slave,
+					      struct mlx4_vhcr *vhcr,
+					      struct mlx4_cmd_mailbox *inbox,
+					      struct mlx4_cmd_mailbox *outbox,
+					      struct mlx4_cmd_info *cmd);
 
 int mlx4_get_mgm_entry_size(struct mlx4_dev *dev);
 int mlx4_get_qp_per_mgm(struct mlx4_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index dd68763..3a26de6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -3387,6 +3387,16 @@ int mlx4_QUERY_IF_STAT_wrapper(struct mlx4_dev *dev, int slave,
 	return err;
 }
 
+int mlx4_FLOW_STEERING_IB_UC_QP_RANGE_wrapper(struct mlx4_dev *dev, int slave,
+					      struct mlx4_vhcr *vhcr,
+					      struct mlx4_cmd_mailbox *inbox,
+					      struct mlx4_cmd_mailbox *outbox,
+					      struct mlx4_cmd_info *cmd)
+{
+	return -EPERM;
+}
+
+
 static void detach_qp(struct mlx4_dev *dev, int slave, struct res_qp *rqp)
 {
 	struct res_gid *rgid;
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index cd1fdf7..09111b1 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -161,6 +161,7 @@ enum {
 	/* register/delete flow steering network rules */
 	MLX4_QP_FLOW_STEERING_ATTACH = 0x65,
 	MLX4_QP_FLOW_STEERING_DETACH = 0x66,
+	MLX4_FLOW_STEERING_IB_UC_QP_RANGE = 0x64,
 };
 
 enum {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 24ce6bd..4e4ae47 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -159,7 +159,8 @@ enum {
 	MLX4_DEV_CAP_FLAG2_TS			= 1LL <<  5,
 	MLX4_DEV_CAP_FLAG2_VLAN_CONTROL		= 1LL <<  6,
 	MLX4_DEV_CAP_FLAG2_FSM			= 1LL <<  7,
-	MLX4_DEV_CAP_FLAG2_UPDATE_QP		= 1LL <<  8
+	MLX4_DEV_CAP_FLAG2_UPDATE_QP		= 1LL <<  8,
+	MLX4_DEV_CAP_FLAG2_DMFS_IPOIB		= 1LL <<  9
 };
 
 enum {
@@ -1125,6 +1126,9 @@ int set_and_calc_slave_port_state(struct mlx4_dev *dev, int slave, u8 port, int
 void mlx4_put_slave_node_guid(struct mlx4_dev *dev, int slave, __be64 guid);
 __be64 mlx4_get_slave_node_guid(struct mlx4_dev *dev, int slave);
 
+int mlx4_FLOW_STEERING_IB_UC_QP_RANGE(struct mlx4_dev *dev, u32 min_range_qpn,
+				      u32 max_range_qpn);
+
 cycle_t mlx4_read_clock(struct mlx4_dev *dev);
 
 #endif /* MLX4_DEVICE_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
