From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 13/14] net/mlx5: Expose MPEIN (Management PCIE INfo) register layout
Date: Fri, 29 Mar 2019 15:38:03 -0700
Message-ID: <20190329223804.8954-14-saeedm@mellanox.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeed@mellanox.com, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Aya Levin <ayal@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Expose PRM layout for handling MPEIN (Management PCIE Info). It will be
used in the downstream patch for querying MPEIN via the driver.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 51 ++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a74326a0178f..6c43191c0186 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -133,6 +133,7 @@ enum {
 	MLX5_REG_MTRC_CONF	 = 0x9041,
 	MLX5_REG_MTRC_STDB	 = 0x9042,
 	MLX5_REG_MTRC_CTRL	 = 0x9043,
+	MLX5_REG_MPEIN		 = 0x9050,
 	MLX5_REG_MPCNT		 = 0x9051,
 	MLX5_REG_MTPPS		 = 0x9053,
 	MLX5_REG_MTPPSE		 = 0x9054,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3b83288749c6..11e498442134 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8026,6 +8026,52 @@ struct mlx5_ifc_ppcnt_reg_bits {
 	union mlx5_ifc_eth_cntrs_grp_data_layout_auto_bits counter_set;
 };
 
+struct mlx5_ifc_mpein_reg_bits {
+	u8         reserved_at_0[0x2];
+	u8         depth[0x6];
+	u8         pcie_index[0x8];
+	u8         node[0x8];
+	u8         reserved_at_18[0x8];
+
+	u8         capability_mask[0x20];
+
+	u8         reserved_at_40[0x8];
+	u8         link_width_enabled[0x8];
+	u8         link_speed_enabled[0x10];
+
+	u8         lane0_physical_position[0x8];
+	u8         link_width_active[0x8];
+	u8         link_speed_active[0x10];
+
+	u8         num_of_pfs[0x10];
+	u8         num_of_vfs[0x10];
+
+	u8         bdf0[0x10];
+	u8         reserved_at_b0[0x10];
+
+	u8         max_read_request_size[0x4];
+	u8         max_payload_size[0x4];
+	u8         reserved_at_c8[0x5];
+	u8         pwr_status[0x3];
+	u8         port_type[0x4];
+	u8         reserved_at_d4[0xb];
+	u8         lane_reversal[0x1];
+
+	u8         reserved_at_e0[0x14];
+	u8         pci_power[0xc];
+
+	u8         reserved_at_100[0x20];
+
+	u8         device_status[0x10];
+	u8         port_state[0x8];
+	u8         reserved_at_138[0x8];
+
+	u8         reserved_at_140[0x10];
+	u8         receiver_detect_result[0x10];
+
+	u8         reserved_at_160[0x20];
+};
+
 struct mlx5_ifc_mpcnt_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         pcie_index[0x8];
@@ -8345,7 +8391,9 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x74];
+	u8         reserved_at_0[0x6e];
+	u8         pci_status_and_power[0x1];
+	u8         reserved_at_6f[0x5];
 	u8         mark_tx_action_cnp[0x1];
 	u8         mark_tx_action_cqe[0x1];
 	u8         dynamic_tx_overflow[0x1];
@@ -8953,6 +9001,7 @@ union mlx5_ifc_ports_control_registers_document_bits {
 	struct mlx5_ifc_pmtu_reg_bits pmtu_reg;
 	struct mlx5_ifc_ppad_reg_bits ppad_reg;
 	struct mlx5_ifc_ppcnt_reg_bits ppcnt_reg;
+	struct mlx5_ifc_mpein_reg_bits mpein_reg;
 	struct mlx5_ifc_mpcnt_reg_bits mpcnt_reg;
 	struct mlx5_ifc_pplm_reg_bits pplm_reg;
 	struct mlx5_ifc_pplr_reg_bits pplr_reg;
-- 
2.20.1
