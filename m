From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/3] net/mlx5_core: Add helper function to read IB error counters
Date: Thu, 18 Feb 2016 18:15:00 +0200
Message-ID: <1455812101-1258-3-git-send-email-matanb@mellanox.com>
References: <1455812101-1258-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455812101-1258-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added helper function to read IB standard error counters
via the PPCNT register.

The PPCNT register read command provides the 32-bit error counters
of both IB/RoCE link layer and transport layer.

Signed-off-by: Meny Yossefi <menyy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 23 ++++++++++++++++++
 include/linux/mlx5/device.h                    |  3 ++-
 include/linux/mlx5/driver.h                    |  2 ++
 include/linux/mlx5/mlx5_ifc.h                  | 32 ++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 19571de..9088df6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -325,6 +325,29 @@ int mlx5_query_port_vl_hw_cap(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mlx5_query_port_vl_hw_cap);
 
+int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
+			     u8 port_num, void *out, size_t sz)
+{
+	u32 *in;
+	int err;
+
+	in  = mlx5_vzalloc(sz);
+	if (!in) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	MLX5_SET(ppcnt_reg, in, local_port, port_num);
+
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_INFINIBAND_PORT_COUNTERS_GROUP);
+	err = mlx5_core_access_reg(dev, in, sz, out,
+				   sz, MLX5_REG_PPCNT, 0, 0);
+
+	kvfree(in);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_core_query_ib_ppcnt);
+
 int mlx5_set_port_pause(struct mlx5_core_dev *dev, u32 rx_pause, u32 tx_pause)
 {
 	u32 in[MLX5_ST_SZ_DW(pfcc_reg)];
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index fb527e7..1af4090 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1311,7 +1311,8 @@ enum {
 	MLX5_RFC_3635_COUNTERS_GROUP	      = 0x3,
 	MLX5_ETHERNET_EXTENDED_COUNTERS_GROUP = 0x5,
 	MLX5_PER_PRIORITY_COUNTERS_GROUP      = 0x10,
-	MLX5_PER_TRAFFIC_CLASS_COUNTERS_GROUP = 0x11
+	MLX5_PER_TRAFFIC_CLASS_COUNTERS_GROUP = 0x11,
+	MLX5_INFINIBAND_PORT_COUNTERS_GROUP   = 0x20,
 };
 
 static inline u16 mlx5_to_sw_pkey_sz(int pkey_sz)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d299737..ce3a85a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -830,6 +830,8 @@ int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
 int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
+int mlx5_core_query_ib_ppcnt(struct mlx5_core_dev *dev,
+			     u8 port_num, void *out, size_t sz);
 
 static inline int fw_initializing(struct mlx5_core_dev *dev)
 {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7dd48b32..2511129 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1250,6 +1250,36 @@ struct mlx5_ifc_phys_layer_cntrs_bits {
 	u8         reserved_at_640[0x180];
 };
 
+struct mlx5_ifc_ib_port_cntrs_grp_data_layout_bits {
+	u8	   symbol_error_counter[0x10];
+
+	u8         link_error_recovery_counter[0x8];
+
+	u8         link_downed_counter[0x8];
+
+	u8         port_rcv_errors[0x10];
+
+	u8         port_rcv_remote_physical_errors[0x10];
+
+	u8         port_rcv_switch_relay_errors[0x10];
+
+	u8         port_xmit_discards[0x10];
+
+	u8         port_xmit_constraint_errors[0x8];
+
+	u8         port_rcv_constraint_errors[0x8];
+
+	u8         reserved_at_70[0x8];
+
+	u8         link_overrun_errors[0x8];
+
+	u8	   reserved_at_80[0x10];
+
+	u8         vl_15_dropped[0x10];
+
+	u8	   reserved_at_a0[0xa0];
+};
+
 struct mlx5_ifc_eth_per_traffic_grp_data_layout_bits {
 	u8         transmit_queue_high[0x20];
 
@@ -2661,6 +2691,7 @@ union mlx5_ifc_eth_cntrs_grp_data_layout_auto_bits {
 	struct mlx5_ifc_eth_extended_cntrs_grp_data_layout_bits eth_extended_cntrs_grp_data_layout;
 	struct mlx5_ifc_eth_per_prio_grp_data_layout_bits eth_per_prio_grp_data_layout;
 	struct mlx5_ifc_eth_per_traffic_grp_data_layout_bits eth_per_traffic_grp_data_layout;
+	struct mlx5_ifc_ib_port_cntrs_grp_data_layout_bits ib_port_cntrs_grp_data_layout;
 	struct mlx5_ifc_phys_layer_cntrs_bits phys_layer_cntrs;
 	u8         reserved_at_0[0x7c0];
 };
@@ -7046,6 +7077,7 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_peir_reg_bits peir_reg;
 	struct mlx5_ifc_pelc_reg_bits pelc_reg;
 	struct mlx5_ifc_pfcc_reg_bits pfcc_reg;
+	struct mlx5_ifc_ib_port_cntrs_grp_data_layout_bits ib_port_cntrs_grp_data_layout;
 	struct mlx5_ifc_phys_layer_cntrs_bits phys_layer_cntrs;
 	struct mlx5_ifc_pifr_reg_bits pifr_reg;
 	struct mlx5_ifc_pipg_reg_bits pipg_reg;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
