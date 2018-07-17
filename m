From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 2/8] net/mlx5: Expose MPEGC (Management PCIe General Configuration) structures
Date: Mon, 16 Jul 2018 18:35:31 -0700
Message-ID: <20180717013537.26411-3-saeedm@mellanox.com>
References: <20180717013537.26411-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180717013537.26411-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

This patch exposes PRM layout for handling MPEGC (Management PCIe
General Configuration).

This will be used in the downstream patch for configuring MPEGC via the
driver.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4a4125b4279d..957199c20a0f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -145,6 +145,7 @@ enum {
 	MLX5_REG_MPCNT		 = 0x9051,
 	MLX5_REG_MTPPS		 = 0x9053,
 	MLX5_REG_MTPPSE		 = 0x9054,
+	MLX5_REG_MPEGC		 = 0x9056,
 	MLX5_REG_MCQI		 = 0x9061,
 	MLX5_REG_MCC		 = 0x9062,
 	MLX5_REG_MCDA		 = 0x9063,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index bd7b71f54d59..2de5feaeb74a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8049,6 +8049,19 @@ struct mlx5_ifc_peir_reg_bits {
 	u8         error_type[0x8];
 };
 
+struct mlx5_ifc_mpegc_reg_bits {
+	u8         reserved_at_0[0x30];
+	u8         field_select[0x10];
+
+	u8         tx_overflow_sense[0x1];
+	u8         mark_cqe[0x1];
+	u8         mark_cnp[0x1];
+	u8         reserved_at_43[0x1b];
+	u8         tx_lossy_overflow_oper[0x2];
+
+	u8         reserved_at_60[0x100];
+};
+
 struct mlx5_ifc_pcam_enhanced_features_bits {
 	u8         reserved_at_0[0x6d];
 	u8         rx_icrc_encapsulated_counter[0x1];
@@ -8097,7 +8110,11 @@ struct mlx5_ifc_pcam_reg_bits {
 };
 
 struct mlx5_ifc_mcam_enhanced_features_bits {
-	u8         reserved_at_0[0x7b];
+	u8         reserved_at_0[0x74];
+	u8         mark_tx_action_cnp[0x1];
+	u8         mark_tx_action_cqe[0x1];
+	u8         dynamic_tx_overflow[0x1];
+	u8         reserved_at_77[0x4];
 	u8         pcie_outbound_stalled[0x1];
 	u8         tx_overflow_buffer_pkt[0x1];
 	u8         mtpps_enh_out_per_adj[0x1];
@@ -8112,7 +8129,9 @@ struct mlx5_ifc_mcam_access_reg_bits {
 	u8         mcqi[0x1];
 	u8         reserved_at_1f[0x1];
 
-	u8         regs_95_to_68[0x1c];
+	u8         regs_95_to_87[0x9];
+	u8         mpegc[0x1];
+	u8         regs_85_to_68[0x12];
 	u8         tracer_registers[0x4];
 
 	u8         regs_63_to_32[0x20];
-- 
2.17.0
