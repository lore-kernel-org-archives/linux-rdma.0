From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/2] net/mlx5: Add FPGA QP error event
Date: Tue, 29 May 2018 17:19:54 -0700
Message-ID: <20180530001954.12000-3-saeedm@mellanox.com>
References: <20180530001954.12000-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180530001954.12000-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Ilan Tayari <ilant@mellanox.com>, Adi Nissim <adin@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Ilan Tayari <ilant@mellanox.com>

The FPGA QP event fires whenever a QP on the FPGA trasitions
to the error state.

At this stage, this event is unrecoverable, it may become recoverable
in the future.

Signed-off-by: Ilan Tayari <ilant@mellanox.com>
Signed-off-by: Adi Nissim <adin@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c |  7 +++++--
 include/linux/mlx5/device.h                  |  1 +
 include/linux/mlx5/mlx5_ifc.h                |  1 +
 include/linux/mlx5/mlx5_ifc_fpga.h           | 16 ++++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 4bd4f011f0a9..77c685645c66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -161,6 +161,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_NIC_VPORT_CHANGE";
 	case MLX5_EVENT_TYPE_FPGA_ERROR:
 		return "MLX5_EVENT_TYPE_FPGA_ERROR";
+	case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
+		return "MLX5_EVENT_TYPE_FPGA_QP_ERROR";
 	case MLX5_EVENT_TYPE_GENERAL_EVENT:
 		return "MLX5_EVENT_TYPE_GENERAL_EVENT";
 	default:
@@ -560,6 +562,7 @@ static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 			break;
 
 		case MLX5_EVENT_TYPE_FPGA_ERROR:
+		case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
 			mlx5_fpga_event(dev, eqe->type, &eqe->data.raw);
 			break;
 
@@ -839,11 +842,11 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_PPS_EVENT);
 
 	if (MLX5_CAP_GEN(dev, fpga))
-		async_event_mask |= (1ull << MLX5_EVENT_TYPE_FPGA_ERROR);
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_FPGA_ERROR) |
+				    (1ull << MLX5_EVENT_TYPE_FPGA_QP_ERROR);
 	if (MLX5_CAP_GEN_MAX(dev, dct))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_DCT_DRAINED);
 
-
 	if (MLX5_CAP_GEN(dev, temp_warn_event))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_TEMP_WARN_EVENT);
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index eddacee5cf61..71e1dc2523a6 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -331,6 +331,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_DCT_DRAINED        = 0x1c,
 
 	MLX5_EVENT_TYPE_FPGA_ERROR         = 0x20,
+	MLX5_EVENT_TYPE_FPGA_QP_ERROR      = 0x21,
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ba30c26aa6eb..3e8845dc85fe 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -60,6 +60,7 @@ enum {
 	MLX5_EVENT_TYPE_CODING_COMMAND_INTERFACE_COMPLETION        = 0xa,
 	MLX5_EVENT_TYPE_CODING_PAGE_REQUEST                        = 0xb,
 	MLX5_EVENT_TYPE_CODING_FPGA_ERROR                          = 0x20,
+	MLX5_EVENT_TYPE_CODING_FPGA_QP_ERROR                       = 0x21
 };
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc_fpga.h b/include/linux/mlx5/mlx5_ifc_fpga.h
index ec052491ba3d..7ddca31fa05d 100644
--- a/include/linux/mlx5/mlx5_ifc_fpga.h
+++ b/include/linux/mlx5/mlx5_ifc_fpga.h
@@ -432,6 +432,22 @@ struct mlx5_ifc_ipsec_counters_bits {
 	u8         dropped_cmd[0x40];
 };
 
+enum {
+	MLX5_FPGA_QP_ERROR_EVENT_SYNDROME_RETRY_COUNTER_EXPIRED  = 0x1,
+	MLX5_FPGA_QP_ERROR_EVENT_SYNDROME_RNR_EXPIRED            = 0x2,
+};
+
+struct mlx5_ifc_fpga_qp_error_event_bits {
+	u8         reserved_at_0[0x40];
+
+	u8         reserved_at_40[0x18];
+	u8         syndrome[0x8];
+
+	u8         reserved_at_60[0x60];
+
+	u8         reserved_at_c0[0x8];
+	u8         fpga_qpn[0x18];
+};
 enum mlx5_ifc_fpga_ipsec_response_syndrome {
 	MLX5_FPGA_IPSEC_RESPONSE_SUCCESS = 0,
 	MLX5_FPGA_IPSEC_RESPONSE_ILLEGAL_REQUEST = 1,
-- 
2.17.0
