From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Add RoCE RX ICRC encapsulated counter
Date: Thu, 21 Jun 2018 15:37:55 +0300
Message-ID: <20180621123756.32645-2-leon@kernel.org>
References: <20180621123756.32645-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180621123756.32645-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Talat Batheesh <talatb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb@mellanox.com>

Add capability bit in PCAM register and RoCE ICRC error counter
to PPCNT register.

Signed-off-by: Talat Batheesh <talatb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b4302ccb63a6..9e8682489951 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1687,7 +1687,11 @@ struct mlx5_ifc_eth_extended_cntrs_grp_data_layout_bits {
 
 	u8         rx_buffer_full_low[0x20];
 
-	u8         reserved_at_1c0[0x600];
+	u8         rx_icrc_encapsulated_high[0x20];
+
+	u8         rx_icrc_encapsulated_low[0x20];
+
+	u8         reserved_at_3c0[0x5c0];
 };
 
 struct mlx5_ifc_eth_3635_cntrs_grp_data_layout_bits {
@@ -8050,8 +8054,9 @@ struct mlx5_ifc_peir_reg_bits {
 };
 
 struct mlx5_ifc_pcam_enhanced_features_bits {
-	u8         reserved_at_0[0x76];
-
+	u8         reserved_at_0[0x6d];
+	u8         rx_icrc_encapsulated_counter[0x1];
+	u8	   reserved_at_6e[0x8];
 	u8         pfcc_mask[0x1];
 	u8         reserved_at_77[0x4];
 	u8         rx_buffer_fullness_counters[0x1];
-- 
2.14.4
