From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v1 1/8] net/mlx5: Add forward compatible support for the FTE match data
Date: Wed, 11 Jul 2018 14:10:38 +0300
Message-ID: <20180711111045.6282-2-leon@kernel.org>
References: <20180711111045.6282-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180711111045.6282-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Use the PRM size including the reserved when working with the FTE
match data.

This comes to support forward compatibility for cases that current
reserved data will be exposed by the firmware and could be used by an
application by DEVX without changing the kernel.

Also drop some driver checks around the match criteria leaving the work
for firmware to enable forward compatibility for future bits there.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 77 +----------------------
 1 file changed, 1 insertion(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 49a75d31185e..eba113cf1117 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -309,89 +309,17 @@ static struct fs_prio *find_prio(struct mlx5_flow_namespace *ns,
 	return NULL;
 }
 
-static bool check_last_reserved(const u32 *match_criteria)
-{
-	char *match_criteria_reserved =
-		MLX5_ADDR_OF(fte_match_param, match_criteria, MLX5_FTE_MATCH_PARAM_RESERVED);
-
-	return	!match_criteria_reserved[0] &&
-		!memcmp(match_criteria_reserved, match_criteria_reserved + 1,
-			MLX5_FLD_SZ_BYTES(fte_match_param,
-					  MLX5_FTE_MATCH_PARAM_RESERVED) - 1);
-}
-
-static bool check_valid_mask(u8 match_criteria_enable, const u32 *match_criteria)
-{
-	if (match_criteria_enable & ~(
-		(1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_OUTER_HEADERS)   |
-		(1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS) |
-		(1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_INNER_HEADERS) |
-		(1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_2)))
-		return false;
-
-	if (!(match_criteria_enable &
-	      1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_OUTER_HEADERS)) {
-		char *fg_type_mask = MLX5_ADDR_OF(fte_match_param,
-						  match_criteria, outer_headers);
-
-		if (fg_type_mask[0] ||
-		    memcmp(fg_type_mask, fg_type_mask + 1,
-			   MLX5_ST_SZ_BYTES(fte_match_set_lyr_2_4) - 1))
-			return false;
-	}
-
-	if (!(match_criteria_enable &
-	      1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS)) {
-		char *fg_type_mask = MLX5_ADDR_OF(fte_match_param,
-						  match_criteria, misc_parameters);
-
-		if (fg_type_mask[0] ||
-		    memcmp(fg_type_mask, fg_type_mask + 1,
-			   MLX5_ST_SZ_BYTES(fte_match_set_misc) - 1))
-			return false;
-	}
-
-	if (!(match_criteria_enable &
-	      1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_INNER_HEADERS)) {
-		char *fg_type_mask = MLX5_ADDR_OF(fte_match_param,
-						  match_criteria, inner_headers);
-
-		if (fg_type_mask[0] ||
-		    memcmp(fg_type_mask, fg_type_mask + 1,
-			   MLX5_ST_SZ_BYTES(fte_match_set_lyr_2_4) - 1))
-			return false;
-	}
-
-	if (!(match_criteria_enable &
-	      1 << MLX5_CREATE_FLOW_GROUP_IN_MATCH_CRITERIA_ENABLE_MISC_PARAMETERS_2)) {
-		char *fg_type_mask = MLX5_ADDR_OF(fte_match_param,
-						  match_criteria, misc_parameters_2);
-
-		if (fg_type_mask[0] ||
-		    memcmp(fg_type_mask, fg_type_mask + 1,
-			   MLX5_ST_SZ_BYTES(fte_match_set_misc2) - 1))
-			return false;
-	}
-
-	return check_last_reserved(match_criteria);
-}
-
 static bool check_valid_spec(const struct mlx5_flow_spec *spec)
 {
 	int i;
 
-	if (!check_valid_mask(spec->match_criteria_enable, spec->match_criteria)) {
-		pr_warn("mlx5_core: Match criteria given mismatches match_criteria_enable\n");
-		return false;
-	}
-
 	for (i = 0; i < MLX5_ST_SZ_DW_MATCH_PARAM; i++)
 		if (spec->match_value[i] & ~spec->match_criteria[i]) {
 			pr_warn("mlx5_core: match_value differs from match_criteria\n");
 			return false;
 		}
 
-	return check_last_reserved(spec->match_value);
+	return true;
 }
 
 static struct mlx5_flow_root_namespace *find_root(struct fs_node *node)
@@ -1158,9 +1086,6 @@ struct mlx5_flow_group *mlx5_create_flow_group(struct mlx5_flow_table *ft,
 	struct mlx5_flow_group *fg;
 	int err;
 
-	if (!check_valid_mask(match_criteria_enable, match_criteria))
-		return ERR_PTR(-EINVAL);
-
 	if (ft->autogroup.active)
 		return ERR_PTR(-EPERM);
 
-- 
2.14.4
