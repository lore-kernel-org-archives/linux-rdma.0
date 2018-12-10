From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 4/9] net/mlx5: Add monitor commands layout and event data
Date: Mon, 10 Dec 2018 13:15:12 -0800
Message-ID: <20181210211517.3686-5-saeedm@mellanox.com>
References: <20181210211517.3686-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210211517.3686-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Eyal Davidovich <eyald@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eyal Davidovich <eyald@mellanox.com>

Will be used in downstream patch to monitor counter changes
by the HCA and report it to the driver by an event.
The driver will update its counters cached data accordingly.

Signed-off-by: Eyal Davidovich <eyald@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  4 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  3 +
 .../net/ethernet/mellanox/mlx5/core/events.c  |  2 +
 include/linux/mlx5/device.h                   |  1 +
 include/linux/mlx5/mlx5_ifc.h                 | 87 ++++++++++++++++++-
 5 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8ab636d59edb..d3125cdf69db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -373,6 +373,8 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_QUERY_VPORT_COUNTER:
 	case MLX5_CMD_OP_ALLOC_Q_COUNTER:
 	case MLX5_CMD_OP_QUERY_Q_COUNTER:
+	case MLX5_CMD_OP_SET_MONITOR_COUNTER:
+	case MLX5_CMD_OP_ARM_MONITOR_COUNTER:
 	case MLX5_CMD_OP_SET_PP_RATE_LIMIT:
 	case MLX5_CMD_OP_QUERY_RATE_LIMIT:
 	case MLX5_CMD_OP_CREATE_SCHEDULING_ELEMENT:
@@ -522,6 +524,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(ALLOC_Q_COUNTER);
 	MLX5_COMMAND_STR_CASE(DEALLOC_Q_COUNTER);
 	MLX5_COMMAND_STR_CASE(QUERY_Q_COUNTER);
+	MLX5_COMMAND_STR_CASE(SET_MONITOR_COUNTER);
+	MLX5_COMMAND_STR_CASE(ARM_MONITOR_COUNTER);
 	MLX5_COMMAND_STR_CASE(SET_PP_RATE_LIMIT);
 	MLX5_COMMAND_STR_CASE(QUERY_RATE_LIMIT);
 	MLX5_COMMAND_STR_CASE(CREATE_SCHEDULING_ELEMENT);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 4aa39a1fe23f..ee04aab65a9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -527,6 +527,9 @@ static u64 gather_async_events_mask(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_MCAM_REG(dev, tracer_registers))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_DEVICE_TRACER);
 
+	if (MLX5_CAP_GEN(dev, max_num_of_monitor_counters))
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_MONITOR_COUNTER);
+
 	return async_event_mask;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 900fdd235ba0..fbc42b7252a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -117,6 +117,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_FPGA_QP_ERROR";
 	case MLX5_EVENT_TYPE_GENERAL_EVENT:
 		return "MLX5_EVENT_TYPE_GENERAL_EVENT";
+	case MLX5_EVENT_TYPE_MONITOR_COUNTER:
+		return "MLX5_EVENT_TYPE_MONITOR_COUNTER";
 	case MLX5_EVENT_TYPE_DEVICE_TRACER:
 		return "MLX5_EVENT_TYPE_DEVICE_TRACER";
 	default:
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index c66867c8fc2f..4674b9e99f45 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -330,6 +330,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_TEMP_WARN_EVENT    = 0x17,
 	MLX5_EVENT_TYPE_REMOTE_CONFIG	   = 0x19,
 	MLX5_EVENT_TYPE_GENERAL_EVENT	   = 0x22,
+	MLX5_EVENT_TYPE_MONITOR_COUNTER    = 0x24,
 	MLX5_EVENT_TYPE_PPS_EVENT          = 0x25,
 
 	MLX5_EVENT_TYPE_DB_BF_CONGESTION   = 0x1a,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 91d6e85e3cef..9f7cc26bfb3b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -161,6 +161,8 @@ enum {
 	MLX5_CMD_OP_ALLOC_Q_COUNTER               = 0x771,
 	MLX5_CMD_OP_DEALLOC_Q_COUNTER             = 0x772,
 	MLX5_CMD_OP_QUERY_Q_COUNTER               = 0x773,
+	MLX5_CMD_OP_SET_MONITOR_COUNTER           = 0x774,
+	MLX5_CMD_OP_ARM_MONITOR_COUNTER           = 0x775,
 	MLX5_CMD_OP_SET_PP_RATE_LIMIT             = 0x780,
 	MLX5_CMD_OP_QUERY_RATE_LIMIT              = 0x781,
 	MLX5_CMD_OP_CREATE_SCHEDULING_ELEMENT      = 0x782,
@@ -1200,7 +1202,13 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8	   sw_owner_id[0x1];
 	u8         reserved_at_61f[0x1];
 
-	u8         reserved_at_620[0x80];
+	u8         max_num_of_monitor_counters[0x10];
+	u8         num_ppcnt_monitor_counters[0x10];
+
+	u8         reserved_at_640[0x10];
+	u8         num_q_monitor_counters[0x10];
+
+	u8         reserved_at_660[0x40];
 
 	u8         uctx_cap[0x20];
 
@@ -3808,6 +3816,83 @@ enum {
 	MLX5_VPORT_STATE_OP_MOD_ESW_VPORT   = 0x1,
 };
 
+struct mlx5_ifc_arm_monitor_counter_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_arm_monitor_counter_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+enum {
+	MLX5_QUERY_MONITOR_CNT_TYPE_PPCNT     = 0x0,
+	MLX5_QUERY_MONITOR_CNT_TYPE_Q_COUNTER = 0x1,
+};
+
+enum mlx5_monitor_counter_ppcnt {
+	MLX5_QUERY_MONITOR_PPCNT_IN_RANGE_LENGTH_ERRORS      = 0X0,
+	MLX5_QUERY_MONITOR_PPCNT_OUT_OF_RANGE_LENGTH_FIELD   = 0X1,
+	MLX5_QUERY_MONITOR_PPCNT_FRAME_TOO_LONG_ERRORS       = 0X2,
+	MLX5_QUERY_MONITOR_PPCNT_FRAME_CHECK_SEQUENCE_ERRORS = 0X3,
+	MLX5_QUERY_MONITOR_PPCNT_ALIGNMENT_ERRORS            = 0X4,
+	MLX5_QUERY_MONITOR_PPCNT_IF_OUT_DISCARDS             = 0X5,
+};
+
+enum {
+	MLX5_QUERY_MONITOR_Q_COUNTER_RX_OUT_OF_BUFFER     = 0X4,
+};
+
+struct mlx5_ifc_monitor_counter_output_bits {
+	u8         reserved_at_0[0x4];
+	u8         type[0x4];
+	u8         reserved_at_8[0x8];
+	u8         counter[0x10];
+
+	u8         counter_group_id[0x20];
+};
+
+#define MLX5_CMD_SET_MONITOR_NUM_PPCNT_COUNTER_SET1 (6)
+#define MLX5_CMD_SET_MONITOR_NUM_Q_COUNTERS_SET1    (1)
+#define MLX5_CMD_SET_MONITOR_NUM_COUNTER (MLX5_CMD_SET_MONITOR_NUM_PPCNT_COUNTER_SET1 +\
+					  MLX5_CMD_SET_MONITOR_NUM_Q_COUNTERS_SET1)
+
+struct mlx5_ifc_set_monitor_counter_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         num_of_counters[0x10];
+
+	u8         reserved_at_60[0x20];
+
+	struct mlx5_ifc_monitor_counter_output_bits monitor_counter[MLX5_CMD_SET_MONITOR_NUM_COUNTER];
+};
+
+struct mlx5_ifc_set_monitor_counter_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_query_vport_state_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];
-- 
2.19.2
