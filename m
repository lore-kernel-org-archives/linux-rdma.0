From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/10] net/mlx5: Revise gre and nvgre key formats
Date: Sun,  9 Dec 2018 19:04:37 -0800
Message-ID: <20181210030442.7543-6-saeedm@mellanox.com>
References: <20181210030442.7543-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210030442.7543-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Oz Shlomo <ozsh@mellanox.com>

GRE RFC defines a 32 bit key field. NVGRE RFC splits the 32 bit
key field to 24 bit VSID (gre_key_h) and 8 bit flow entropy (gre_key_l).

Define the two key parsing alternatives in a union, thus enabling both
access methods.

Signed-off-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c                   |  4 ++--
 .../mellanox/mlx5/core/diag/fs_tracepoint.c         |  8 ++++----
 include/linux/mlx5/mlx5_ifc.h                       | 13 +++++++++++--
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 96515a8c9d2c..2560996fce79 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2680,11 +2680,11 @@ static int parse_flow_attr(struct mlx5_core_dev *mdev, u32 *match_c,
 			 ntohs(ib_spec->gre.val.protocol));
 
 		memcpy(MLX5_ADDR_OF(fte_match_set_misc, misc_params_c,
-				    gre_key_h),
+				    gre_key.nvgre.hi),
 		       &ib_spec->gre.mask.key,
 		       sizeof(ib_spec->gre.mask.key));
 		memcpy(MLX5_ADDR_OF(fte_match_set_misc, misc_params_v,
-				    gre_key_h),
+				    gre_key.nvgre.hi),
 		       &ib_spec->gre.val.key,
 		       sizeof(ib_spec->gre.val.key));
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index 0f11fff32a9b..424457ff9759 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -161,10 +161,10 @@ static void print_misc_parameters_hdrs(struct trace_seq *p,
 	PRINT_MASKED_VAL(name, p, format);		   \
 }
 	DECLARE_MASK_VAL(u64, gre_key) = {
-		.m = MLX5_GET(fte_match_set_misc, mask, gre_key_h) << 8 |
-		     MLX5_GET(fte_match_set_misc, mask, gre_key_l),
-		.v = MLX5_GET(fte_match_set_misc, value, gre_key_h) << 8 |
-		     MLX5_GET(fte_match_set_misc, value, gre_key_l)};
+		.m = MLX5_GET(fte_match_set_misc, mask, gre_key.nvgre.hi) << 8 |
+		     MLX5_GET(fte_match_set_misc, mask, gre_key.nvgre.lo),
+		.v = MLX5_GET(fte_match_set_misc, value, gre_key.nvgre.hi) << 8 |
+		     MLX5_GET(fte_match_set_misc, value, gre_key.nvgre.lo)};
 
 	PRINT_MASKED_VAL(gre_key, p, "%llu");
 	PRINT_MASKED_VAL_MISC(u32, source_sqn, source_sqn, p, "%u");
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9f7cc26bfb3b..688a549e74f1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -423,6 +423,16 @@ struct mlx5_ifc_fte_match_set_lyr_2_4_bits {
 	union mlx5_ifc_ipv6_layout_ipv4_layout_auto_bits dst_ipv4_dst_ipv6;
 };
 
+struct mlx5_ifc_nvgre_key_bits {
+	u8 hi[0x18];
+	u8 lo[0x8];
+};
+
+union mlx5_ifc_gre_key_bits {
+	struct mlx5_ifc_nvgre_key_bits nvgre;
+	u8 key[0x20];
+};
+
 struct mlx5_ifc_fte_match_set_misc_bits {
 	u8         reserved_at_0[0x8];
 	u8         source_sqn[0x18];
@@ -444,8 +454,7 @@ struct mlx5_ifc_fte_match_set_misc_bits {
 	u8         reserved_at_64[0xc];
 	u8         gre_protocol[0x10];
 
-	u8         gre_key_h[0x18];
-	u8         gre_key_l[0x8];
+	union mlx5_ifc_gre_key_bits gre_key;
 
 	u8         vxlan_vni[0x18];
 	u8         reserved_at_b8[0x8];
-- 
2.19.2
