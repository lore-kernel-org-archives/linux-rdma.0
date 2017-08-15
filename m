From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 01/11] net/mlx5: Update HW layout definitions
Date: Tue, 15 Aug 2017 11:59:02 +0300
Message-ID: <20170815085912.10181-2-leon@kernel.org>
References: <20170815085912.10181-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085912.10181-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

* add offload_type field to mlx5_ifc_qpc_bits
* update mlx5_ifc_xrqc_bits layout

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/mlx5/mlx5_ifc.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 671004923f57..8d62c108dd80 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2016,6 +2016,10 @@ enum {
 	MLX5_QPC_PM_STATE_MIGRATED  = 0x3,
 };
 
+enum {
+	MLX5_QPC_OFFLOAD_TYPE_RNDV  = 0x1,
+};
+
 enum {
 	MLX5_QPC_END_PADDING_MODE_SCATTER_AS_IS                = 0x0,
 	MLX5_QPC_END_PADDING_MODE_PAD_TO_CACHE_LINE_ALIGNMENT  = 0x1,
@@ -2059,7 +2063,8 @@ struct mlx5_ifc_qpc_bits {
 	u8         st[0x8];
 	u8         reserved_at_10[0x3];
 	u8         pm_state[0x2];
-	u8         reserved_at_15[0x7];
+	u8         reserved_at_15[0x3];
+	u8         offload_type[0x4];
 	u8         end_padding_mode[0x2];
 	u8         reserved_at_1e[0x2];
 
@@ -3004,7 +3009,7 @@ struct mlx5_ifc_xrqc_bits {
 
 	struct mlx5_ifc_tag_matching_topology_context_bits tag_matching_topology_context;
 
-	u8         reserved_at_180[0x880];
+	u8         reserved_at_180[0x280];
 
 	struct mlx5_ifc_wq_bits wq;
 };
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
