From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/8] net/mlx5: Expose SW ICM related device memory capabilities
Date: Sun, 31 Mar 2019 19:44:43 +0300
Message-ID: <20190331164450.23618-2-leon@kernel.org>
References: <20190331164450.23618-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190331164450.23618-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Add SW ICM related fields to the device memory capabilities
structure and sw ownership capability in flow table properties.

The currently supported SW ICM types are steering and header modify
and the changes exposes the device memory capabilities for each
of these two types.

SW ICM memory can be allocated by SW and then be accessed by RDMA
operations for direct management of the HW packet handling tables.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 45 +++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 20c07cb87f6c..c2a558d58067 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -80,6 +80,14 @@ enum {
 	MLX5_SHARED_RESOURCE_UID = 0xffff,
 };
 
+enum {
+	MLX5_OBJ_TYPE_SW_ICM = 0x0008,
+};
+
+enum {
+	MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM = (1ULL << MLX5_OBJ_TYPE_SW_ICM),
+};
+
 enum {
 	MLX5_CMD_OP_QUERY_HCA_CAP                 = 0x100,
 	MLX5_CMD_OP_QUERY_ADAPTER                 = 0x101,
@@ -357,7 +365,8 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         pop_vlan_2[0x1];
 	u8         push_vlan_2[0x1];
 	u8	   reformat_and_vlan_action[0x1];
-	u8	   reserved_at_10[0x2];
+	u8	   reserved_at_10[0x1];
+	u8         sw_owner[0x1];
 	u8	   reformat_l3_tunnel_to_l2[0x1];
 	u8	   reformat_l2_to_l3_tunnel[0x1];
 	u8	   reformat_and_modify_action[0x1];
@@ -770,7 +779,19 @@ struct mlx5_ifc_device_mem_cap_bits {
 
 	u8         max_memic_size[0x20];
 
-	u8         reserved_at_c0[0x740];
+	u8         steering_sw_icm_start_address[0x40];
+
+	u8         reserved_at_100[0x8];
+	u8         log_header_modify_sw_icm_size[0x8];
+	u8         reserved_at_110[0x2];
+	u8         log_sw_icm_alloc_granularity[0x6];
+	u8         log_steering_sw_icm_size[0x8];
+
+	u8         reserved_at_120[0x20];
+
+	u8         header_modify_sw_icm_start_address[0x40];
+
+	u8         reserved_at_180[0x680];
 };
 
 enum {
@@ -919,6 +940,7 @@ enum {
 
 enum {
 	MLX5_UCTX_CAP_RAW_TX = 1UL << 0,
+	MLX5_UCTX_CAP_INTERNAL_DEV_RES = 1UL << 1,
 };
 
 struct mlx5_ifc_cmd_hca_cap_bits {
@@ -2922,6 +2944,7 @@ enum {
 	MLX5_MKC_ACCESS_MODE_MTT   = 0x1,
 	MLX5_MKC_ACCESS_MODE_KLMS  = 0x2,
 	MLX5_MKC_ACCESS_MODE_KSM   = 0x3,
+	MLX5_MKC_ACCESS_MODE_SW_ICM = 0x4,
 	MLX5_MKC_ACCESS_MODE_MEMIC = 0x5,
 };
 
@@ -9444,6 +9467,19 @@ struct mlx5_ifc_uctx_bits {
 	u8         reserved_at_20[0x160];
 };
 
+struct mlx5_ifc_sw_icm_bits {
+	u8         modify_field_select[0x40];
+
+	u8	   reserved_at_40[0x18];
+	u8         log_sw_icm_size[0x8];
+
+	u8         reserved_at_60[0x20];
+
+	u8         sw_icm_start_addr[0x40];
+
+	u8         reserved_at_c0[0x140];
+};
+
 struct mlx5_ifc_create_umem_in_bits {
 	u8         opcode[0x10];
 	u8         uid[0x10];
@@ -9481,6 +9517,11 @@ struct mlx5_ifc_destroy_uctx_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+struct mlx5_ifc_create_sw_icm_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits   hdr;
+	struct mlx5_ifc_sw_icm_bits		      sw_icm;
+};
+
 struct mlx5_ifc_mtrc_string_db_param_bits {
 	u8         string_db_base_address[0x20];
 
-- 
2.20.1
