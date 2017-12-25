From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 9/9] mlx5: Expose max dynamic blue flame registers capability
Date: Mon, 25 Dec 2017 15:57:01 +0200
Message-ID: <1514210221-10466-10-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Expose a capability which introduces the max dynamic blue flame
registers that can be allocated. This new capability can be read by the
mlx5dv_query_device() API.

Since blue flame registers are a device specific feature, this is
exposed through DV.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 4 +++-
 providers/mlx5/mlx5.c                    | 5 +++++
 providers/mlx5/mlx5dv.h                  | 4 +++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index f4b8104..0cffc2b 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -48,6 +48,7 @@ uint64_t        comp_mask; /* Use enum mlx5dv_context_comp_mask */
 struct mlx5dv_cqe_comp_caps     cqe_comp_caps;
 struct mlx5dv_sw_parsing_caps sw_parsing_caps;
 uint32_t	tunnel_offloads_caps;
+uint32_t        max_dynamic_bfregs /* max blue-flame registers that can be dynamiclly allocated */
 .in -8
 };
 
@@ -73,7 +74,8 @@ MLX5DV_CONTEXT_MASK_CQE_COMPRESION      = 1 << 0,
 MLX5DV_CONTEXT_MASK_SWP                 = 1 << 1,
 MLX5DV_CONTEXT_MASK_STRIDING_RQ         = 1 << 2,
 MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS     = 1 << 3,
-MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 4,
+MLX5DV_CONTEXT_MASK_DYN_BFREGS          = 1 << 4,
+MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 5,
 .in -8
 };
 
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 10a59fe..52eb4f9 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -651,6 +651,11 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS;
 	}
 
+	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_DYN_BFREGS) {
+		attrs_out->max_dynamic_bfregs = mctx->num_dyn_bfregs;
+		comp_mask_out |= MLX5DV_CONTEXT_MASK_DYN_BFREGS;
+	}
+
 	attrs_out->comp_mask = comp_mask_out;
 
 	return 0;
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 0e78c41..84c5099 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -62,7 +62,8 @@ enum mlx5dv_context_comp_mask {
 	MLX5DV_CONTEXT_MASK_SWP			= 1 << 1,
 	MLX5DV_CONTEXT_MASK_STRIDING_RQ		= 1 << 2,
 	MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS	= 1 << 3,
-	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 4,
+	MLX5DV_CONTEXT_MASK_DYN_BFREGS		= 1 << 4,
+	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 5,
 };
 
 struct mlx5dv_cqe_comp_caps {
@@ -100,6 +101,7 @@ struct mlx5dv_context {
 	struct mlx5dv_sw_parsing_caps sw_parsing_caps;
 	struct mlx5dv_striding_rq_caps striding_rq_caps;
 	uint32_t	tunnel_offloads_caps;
+	uint32_t	max_dynamic_bfregs;
 };
 
 enum mlx5dv_context_flags {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
