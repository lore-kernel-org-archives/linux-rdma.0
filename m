From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add temperature warning event to log
Date: Tue, 29 May 2018 17:19:53 -0700
Message-ID: <20180530001954.12000-2-saeedm@mellanox.com>
References: <20180530001954.12000-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180530001954.12000-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Ilan Tayari <ilant@mellanox.com>, Adi Nissim <adin@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Ilan Tayari <ilant@mellanox.com>

Temperature warning event is sent by FW to indicate high temperature
as detected by one of the sensors on the board.
Add handling of this event by writing the numbers of the alert sensors
to the kernel log.

Signed-off-by: Ilan Tayari <ilant@mellanox.com>
Signed-off-by: Adi Nissim <adin@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 23 ++++++++++++++++++++
 include/linux/mlx5/device.h                  |  7 ++++++
 include/linux/mlx5/mlx5_ifc.h                |  2 +-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index c1c94974e16b..4bd4f011f0a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -141,6 +141,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_GPIO_EVENT";
 	case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
 		return "MLX5_EVENT_TYPE_PORT_MODULE_EVENT";
+	case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
+		return "MLX5_EVENT_TYPE_TEMP_WARN_EVENT";
 	case MLX5_EVENT_TYPE_REMOTE_CONFIG:
 		return "MLX5_EVENT_TYPE_REMOTE_CONFIG";
 	case MLX5_EVENT_TYPE_DB_BF_CONGESTION:
@@ -393,6 +395,20 @@ static void general_event_handler(struct mlx5_core_dev *dev,
 	}
 }
 
+static void mlx5_temp_warning_event(struct mlx5_core_dev *dev,
+				    struct mlx5_eqe *eqe)
+{
+	u64 value_lsb;
+	u64 value_msb;
+
+	value_lsb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_lsb);
+	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
+
+	mlx5_core_warn(dev,
+		       "High temperature on sensors with bit set %llx %llx",
+		       value_msb, value_lsb);
+}
+
 /* caller must eventually call mlx5_cq_put on the returned cq */
 static struct mlx5_core_cq *mlx5_eq_cq_get(struct mlx5_eq *eq, u32 cqn)
 {
@@ -547,6 +563,10 @@ static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 			mlx5_fpga_event(dev, eqe->type, &eqe->data.raw);
 			break;
 
+		case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
+			mlx5_temp_warning_event(dev, eqe);
+			break;
+
 		case MLX5_EVENT_TYPE_GENERAL_EVENT:
 			general_event_handler(dev, eqe);
 			break;
@@ -824,6 +844,9 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_DCT_DRAINED);
 
 
+	if (MLX5_CAP_GEN(dev, temp_warn_event))
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_TEMP_WARN_EVENT);
+
 	err = mlx5_create_map_eq(dev, &table->cmd_eq, MLX5_EQ_VEC_CMD,
 				 MLX5_NUM_CMD_EQE, 1ull << MLX5_EVENT_TYPE_CMD,
 				 "mlx5_cmd_eq", MLX5_EQ_TYPE_ASYNC);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 2bc27f8c5b87..eddacee5cf61 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -314,6 +314,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_PORT_CHANGE	   = 0x09,
 	MLX5_EVENT_TYPE_GPIO_EVENT	   = 0x15,
 	MLX5_EVENT_TYPE_PORT_MODULE_EVENT  = 0x16,
+	MLX5_EVENT_TYPE_TEMP_WARN_EVENT    = 0x17,
 	MLX5_EVENT_TYPE_REMOTE_CONFIG	   = 0x19,
 	MLX5_EVENT_TYPE_GENERAL_EVENT	   = 0x22,
 	MLX5_EVENT_TYPE_PPS_EVENT          = 0x25,
@@ -626,6 +627,11 @@ struct mlx5_eqe_dct {
 	__be32  dctn;
 };
 
+struct mlx5_eqe_temp_warning {
+	__be64 sensor_warning_msb;
+	__be64 sensor_warning_lsb;
+} __packed;
+
 union ev_data {
 	__be32				raw[7];
 	struct mlx5_eqe_cmd		cmd;
@@ -642,6 +648,7 @@ union ev_data {
 	struct mlx5_eqe_port_module	port_module;
 	struct mlx5_eqe_pps		pps;
 	struct mlx5_eqe_dct             dct;
+	struct mlx5_eqe_temp_warning	temp_warning;
 } __packed;
 
 struct mlx5_eqe {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 10c1613d9434..ba30c26aa6eb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -926,7 +926,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_msg[0x5];
 	u8         reserved_at_1c8[0x4];
 	u8         max_tc[0x4];
-	u8         reserved_at_1d0[0x1];
+	u8         temp_warn_event[0x1];
 	u8         dcbx[0x1];
 	u8         general_notification_event[0x1];
 	u8         reserved_at_1d3[0x2];
-- 
2.17.0
