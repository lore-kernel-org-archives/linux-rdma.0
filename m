From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] net/mlx5: Introduce general notification event
Date: Tue, 30 May 2017 10:29:12 +0300
Message-ID: <20170530072914.9709-4-leon@kernel.org>
References: <20170530072914.9709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530072914.9709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When delay drop timeout is expired, the firmware raises
general notification event of DELAY_DROP_TIMEOUT subtype.
In addition the feature is disable so the driver have to
reactivate the timeout.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 23 +++++++++++++++++++++++
 include/linux/mlx5/device.h                  |  5 +++++
 include/linux/mlx5/driver.h                  |  1 +
 include/linux/mlx5/mlx5_ifc.h                |  3 ++-
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 01d2cd7e4746..afbd9171acb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -159,6 +159,8 @@ static const char *eqe_type_str(u8 type)
 		return "MLX5_EVENT_TYPE_PPS_EVENT";
 	case MLX5_EVENT_TYPE_FPGA_ERROR:
 		return "MLX5_EVENT_TYPE_FPGA_ERROR";
+	case MLX5_EVENT_TYPE_GENERAL_EVENT:
+		return "MLX5_EVENT_TYPE_GENERAL_EVENT";
 	default:
 		return "Unrecognized event";
 	}
@@ -376,6 +378,20 @@ int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 token,
 EXPORT_SYMBOL_GPL(mlx5_core_page_fault_resume);
 #endif

+static void general_event_handler(struct mlx5_core_dev *dev,
+				  struct mlx5_eqe *eqe)
+{
+	switch (eqe->sub_type) {
+	case MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT:
+		if (dev->event)
+			dev->event(dev, MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT, 0);
+		break;
+	default:
+		mlx5_core_dbg(dev, "General event with unrecognized subtype: sub_type %d\n",
+			      eqe->sub_type);
+	}
+}
+
 static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 {
 	struct mlx5_eq *eq = eq_ptr;
@@ -484,6 +500,9 @@ static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 			mlx5_fpga_event(dev, eqe->type, &eqe->data.raw);
 			break;

+		case MLX5_EVENT_TYPE_GENERAL_EVENT:
+			general_event_handler(dev, eqe);
+			break;
 		default:
 			mlx5_core_warn(dev, "Unhandled event 0x%x on EQ 0x%x\n",
 				       eqe->type, eq->eqn);
@@ -693,6 +712,10 @@ int mlx5_start_eqs(struct mlx5_core_dev *dev)
 	    mlx5_core_is_pf(dev))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_NIC_VPORT_CHANGE);

+	if (MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_ETH &&
+	    MLX5_CAP_GEN(dev, general_notification_event))
+		async_event_mask |= (1ull << MLX5_EVENT_TYPE_GENERAL_EVENT);
+
 	if (MLX5_CAP_GEN(dev, port_module_event))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_PORT_MODULE_EVENT);
 	else
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 786a43843da9..586f9f8a1481 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -290,6 +290,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_GPIO_EVENT	   = 0x15,
 	MLX5_EVENT_TYPE_PORT_MODULE_EVENT  = 0x16,
 	MLX5_EVENT_TYPE_REMOTE_CONFIG	   = 0x19,
+	MLX5_EVENT_TYPE_GENERAL_EVENT	   = 0x22,
 	MLX5_EVENT_TYPE_PPS_EVENT          = 0x25,

 	MLX5_EVENT_TYPE_DB_BF_CONGESTION   = 0x1a,
@@ -305,6 +306,10 @@ enum mlx5_event {
 };

 enum {
+	MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT = 0x1,
+};
+
+enum {
 	MLX5_PORT_CHANGE_SUBTYPE_DOWN		= 1,
 	MLX5_PORT_CHANGE_SUBTYPE_ACTIVE		= 4,
 	MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED	= 5,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 55bb712643cb..e88b710d3cb0 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -180,6 +180,7 @@ enum mlx5_dev_event {
 	MLX5_DEV_EVENT_GUID_CHANGE,
 	MLX5_DEV_EVENT_CLIENT_REREG,
 	MLX5_DEV_EVENT_PPS,
+	MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT,
 };

 enum mlx5_port_status {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5b9f836e66ca..1e107d474802 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -858,7 +858,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_tc[0x4];
 	u8         reserved_at_1d0[0x1];
 	u8         dcbx[0x1];
-	u8         reserved_at_1d2[0x3];
+	u8         general_notification_event[0x1];
+	u8         reserved_at_1d3[0x2];
 	u8         fpga[0x1];
 	u8         rol_s[0x1];
 	u8         rol_g[0x1];
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
