From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 13/15] net/mlx5: Add new fields to Port Type and Speed register
Date: Tue, 12 Feb 2019 22:55:44 -0800
Message-ID: <20190213065546.3013-14-saeedm@mellanox.com>
References: <20190213065546.3013-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213065546.3013-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Aya Levin <ayal@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Register Port Type and Speed (PTYS) introduces three new fields
extending the speed/protocols the can be reported and configured.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 565046830559..5decffe565fb 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -7826,21 +7826,23 @@ struct mlx5_ifc_ptys_reg_bits {
 	u8         proto_mask[0x3];
 
 	u8         an_status[0x4];
-	u8         reserved_at_24[0x3c];
+	u8         reserved_at_24[0x1c];
+
+	u8         ext_eth_proto_capability[0x20];
 
 	u8         eth_proto_capability[0x20];
 
 	u8         ib_link_width_capability[0x10];
 	u8         ib_proto_capability[0x10];
 
-	u8         reserved_at_a0[0x20];
+	u8         ext_eth_proto_admin[0x20];
 
 	u8         eth_proto_admin[0x20];
 
 	u8         ib_link_width_admin[0x10];
 	u8         ib_proto_admin[0x10];
 
-	u8         reserved_at_100[0x20];
+	u8         ext_eth_proto_oper[0x20];
 
 	u8         eth_proto_oper[0x20];
 
@@ -8289,7 +8291,9 @@ struct mlx5_ifc_mpegc_reg_bits {
 struct mlx5_ifc_pcam_enhanced_features_bits {
 	u8         reserved_at_0[0x6d];
 	u8         rx_icrc_encapsulated_counter[0x1];
-	u8	   reserved_at_6e[0x8];
+	u8	   reserved_at_6e[0x4];
+	u8         ptys_extended_ethernet[0x1];
+	u8	   reserved_at_73[0x3];
 	u8         pfcc_mask[0x1];
 	u8         reserved_at_77[0x3];
 	u8         per_lane_error_counters[0x1];
-- 
2.20.1
