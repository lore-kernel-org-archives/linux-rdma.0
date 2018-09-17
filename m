From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 07/25] net/mlx5: Update mlx5_ifc with DEVX UID bits
Date: Mon, 17 Sep 2018 14:04:00 +0300
Message-ID: <20180917110418.18937-8-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Add DEVX information to WQ, SRQ, CQ, TRI, TIS, QP,
RQ, XRCD, PD, MKEY and MCG.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 67 +++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 24 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index efa4a60431d4..0f460fb22c31 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1291,7 +1291,9 @@ struct mlx5_ifc_wq_bits {
 	u8         reserved_at_118[0x3];
 	u8         log_wq_sz[0x5];
 
-	u8         reserved_at_120[0x3];
+	u8         dbr_umem_valid[0x1];
+	u8         wq_umem_valid[0x1];
+	u8         reserved_at_122[0x1];
 	u8         log_hairpin_num_packets[0x5];
 	u8         reserved_at_128[0x3];
 	u8         log_hairpin_data_sz[0x5];
@@ -2365,7 +2367,10 @@ struct mlx5_ifc_qpc_bits {
 
 	u8         dc_access_key[0x40];
 
-	u8         reserved_at_680[0xc0];
+	u8         reserved_at_680[0x3];
+	u8         dbr_umem_valid[0x1];
+
+	u8         reserved_at_684[0xbc];
 };
 
 struct mlx5_ifc_roce_addr_layout_bits {
@@ -2465,7 +2470,7 @@ struct mlx5_ifc_xrc_srqc_bits {
 
 	u8         wq_signature[0x1];
 	u8         cont_srq[0x1];
-	u8         reserved_at_22[0x1];
+	u8         dbr_umem_valid[0x1];
 	u8         rlky[0x1];
 	u8         basic_cyclic_rcv_wqe[0x1];
 	u8         log_rq_stride[0x3];
@@ -3129,7 +3134,9 @@ enum {
 
 struct mlx5_ifc_cqc_bits {
 	u8         status[0x4];
-	u8         reserved_at_4[0x4];
+	u8         reserved_at_4[0x2];
+	u8         dbr_umem_valid[0x1];
+	u8         reserved_at_7[0x1];
 	u8         cqe_sz[0x3];
 	u8         cc[0x1];
 	u8         reserved_at_c[0x1];
@@ -5315,7 +5322,7 @@ struct mlx5_ifc_modify_tis_bitmask_bits {
 
 struct mlx5_ifc_modify_tis_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5354,7 +5361,7 @@ struct mlx5_ifc_modify_tir_out_bits {
 
 struct mlx5_ifc_modify_tir_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5455,7 +5462,7 @@ struct mlx5_ifc_rqt_bitmask_bits {
 
 struct mlx5_ifc_modify_rqt_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -5642,7 +5649,10 @@ struct mlx5_ifc_modify_cq_in_bits {
 
 	struct mlx5_ifc_cqc_bits cq_context;
 
-	u8         reserved_at_280[0x600];
+	u8         reserved_at_280[0x40];
+
+	u8         cq_umem_valid[0x1];
+	u8         reserved_at_2c1[0x5bf];
 
 	u8         pas[0][0x40];
 };
@@ -5963,7 +5973,7 @@ struct mlx5_ifc_detach_from_mcg_out_bits {
 
 struct mlx5_ifc_detach_from_mcg_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6031,7 +6041,7 @@ struct mlx5_ifc_destroy_tis_out_bits {
 
 struct mlx5_ifc_destroy_tis_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6053,7 +6063,7 @@ struct mlx5_ifc_destroy_tir_out_bits {
 
 struct mlx5_ifc_destroy_tir_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6143,7 +6153,7 @@ struct mlx5_ifc_destroy_rqt_out_bits {
 
 struct mlx5_ifc_destroy_rqt_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6508,7 +6518,7 @@ struct mlx5_ifc_dealloc_xrcd_out_bits {
 
 struct mlx5_ifc_dealloc_xrcd_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6596,7 +6606,7 @@ struct mlx5_ifc_dealloc_pd_out_bits {
 
 struct mlx5_ifc_dealloc_pd_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6675,7 +6685,9 @@ struct mlx5_ifc_create_xrc_srq_in_bits {
 
 	struct mlx5_ifc_xrc_srqc_bits xrc_srq_context_entry;
 
-	u8         reserved_at_280[0x600];
+	u8         reserved_at_280[0x40];
+	u8         xrc_srq_umem_valid[0x1];
+	u8         reserved_at_2c1[0x5bf];
 
 	u8         pas[0][0x40];
 };
@@ -6694,7 +6706,7 @@ struct mlx5_ifc_create_tis_out_bits {
 
 struct mlx5_ifc_create_tis_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6718,7 +6730,7 @@ struct mlx5_ifc_create_tir_out_bits {
 
 struct mlx5_ifc_create_tir_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6824,7 +6836,7 @@ struct mlx5_ifc_create_rqt_out_bits {
 
 struct mlx5_ifc_create_rqt_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6909,7 +6921,10 @@ struct mlx5_ifc_create_qp_in_bits {
 
 	struct mlx5_ifc_qpc_bits qpc;
 
-	u8         reserved_at_800[0x80];
+	u8         reserved_at_800[0x60];
+
+	u8         wq_umem_valid[0x1];
+	u8         reserved_at_861[0x1f];
 
 	u8         pas[0][0x40];
 };
@@ -6971,7 +6986,8 @@ struct mlx5_ifc_create_mkey_in_bits {
 	u8         reserved_at_40[0x20];
 
 	u8         pg_access[0x1];
-	u8         reserved_at_61[0x1f];
+	u8         mkey_umem_valid[0x1];
+	u8         reserved_at_62[0x1e];
 
 	struct mlx5_ifc_mkc_bits memory_key_mkey_entry;
 
@@ -7174,7 +7190,10 @@ struct mlx5_ifc_create_cq_in_bits {
 
 	struct mlx5_ifc_cqc_bits cq_context;
 
-	u8         reserved_at_280[0x600];
+	u8         reserved_at_280[0x60];
+
+	u8         cq_umem_valid[0x1];
+	u8         reserved_at_2e1[0x59f];
 
 	u8         pas[0][0x40];
 };
@@ -7222,7 +7241,7 @@ struct mlx5_ifc_attach_to_mcg_out_bits {
 
 struct mlx5_ifc_attach_to_mcg_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7349,7 +7368,7 @@ struct mlx5_ifc_alloc_xrcd_out_bits {
 
 struct mlx5_ifc_alloc_xrcd_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7437,7 +7456,7 @@ struct mlx5_ifc_alloc_pd_out_bits {
 
 struct mlx5_ifc_alloc_pd_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.14.4
