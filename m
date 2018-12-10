From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/10] net/mlx5: Introduce extended destination fields
Date: Sun,  9 Dec 2018 19:04:38 -0800
Message-ID: <20181210030442.7543-7-saeedm@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Eli Britstein <elibr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

Extended destinations provide the ability to configure different
encapsulation properties per destination on a single FTE. This is
needed for use-cases such as remote mirroring over tunneled networks.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 688a549e74f1..60c1d49eb40c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -621,7 +621,9 @@ struct mlx5_ifc_e_switch_cap_bits {
 
 	u8         vxlan_encap_decap[0x1];
 	u8         nvgre_encap_decap[0x1];
-	u8         reserved_at_22[0x9];
+	u8         reserved_at_22[0x1];
+	u8         log_max_fdb_encap_uplink[0x5];
+	u8         reserved_at_21[0x3];
 	u8         log_max_packet_reformat_context[0x5];
 	u8         reserved_2b[0x6];
 	u8         max_encap_header_size[0xa];
@@ -1237,8 +1239,10 @@ enum mlx5_flow_destination_type {
 struct mlx5_ifc_dest_format_struct_bits {
 	u8         destination_type[0x8];
 	u8         destination_id[0x18];
+
 	u8         destination_eswitch_owner_vhca_id_valid[0x1];
-	u8         reserved_at_21[0xf];
+	u8         packet_reformat[0x1];
+	u8         reserved_at_22[0xe];
 	u8         destination_eswitch_owner_vhca_id[0x10];
 };
 
@@ -1248,6 +1252,14 @@ struct mlx5_ifc_flow_counter_list_bits {
 	u8         reserved_at_20[0x20];
 };
 
+struct mlx5_ifc_extended_dest_format_bits {
+	struct mlx5_ifc_dest_format_struct_bits destination_entry;
+
+	u8         packet_reformat_id[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
 union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits {
 	struct mlx5_ifc_dest_format_struct_bits dest_format_struct;
 	struct mlx5_ifc_flow_counter_list_bits flow_counter_list;
@@ -2469,7 +2481,8 @@ struct mlx5_ifc_flow_context_bits {
 	u8         reserved_at_60[0x10];
 	u8         action[0x10];
 
-	u8         reserved_at_80[0x8];
+	u8         extended_destination[0x1];
+	u8         reserved_at_80[0x7];
 	u8         destination_list_size[0x18];
 
 	u8         reserved_at_a0[0x8];
-- 
2.19.2
