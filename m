From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/3] mlx5: Report tunneling offloads capabilities
Date: Sun,  3 Dec 2017 18:03:37 +0200
Message-ID: <1512317017-6223-4-git-send-email-yishaih@mellanox.com>
References: <1512317017-6223-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1512317017-6223-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reports capability of which tunneling type supports
the tunneling offloads.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 15 ++++++++++++++-
 providers/mlx5/mlx5-abi.h                |  2 ++
 providers/mlx5/mlx5.c                    |  5 +++++
 providers/mlx5/mlx5.h                    |  1 +
 providers/mlx5/mlx5dv.h                  | 10 +++++++++-
 providers/mlx5/verbs.c                   |  1 +
 6 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index f7cfdc0..f4b8104 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -47,6 +47,7 @@ uint64_t        flags;
 uint64_t        comp_mask; /* Use enum mlx5dv_context_comp_mask */
 struct mlx5dv_cqe_comp_caps     cqe_comp_caps;
 struct mlx5dv_sw_parsing_caps sw_parsing_caps;
+uint32_t	tunnel_offloads_caps;
 .in -8
 };
 
@@ -71,7 +72,8 @@ enum mlx5dv_context_comp_mask {
 MLX5DV_CONTEXT_MASK_CQE_COMPRESION      = 1 << 0,
 MLX5DV_CONTEXT_MASK_SWP                 = 1 << 1,
 MLX5DV_CONTEXT_MASK_STRIDING_RQ         = 1 << 2,
-MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 3,
+MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS     = 1 << 3,
+MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 4,
 .in -8
 };
 
@@ -84,6 +86,17 @@ MLX5DV_SW_PARSING_CSUM    = 1 << 1,
 MLX5DV_SW_PARSING_LSO     = 1 << 2,
 .in -8
 };
+
+.PP
+.nf
+enum mlx5dv_tunnel_offloads {
+.in +8
+MLX5DV_RAW_PACKET_CAP_TUNNELED_OFFLOAD_VXLAN  = 1 << 0,
+MLX5DV_RAW_PACKET_CAP_TUNNELED_OFFLOAD_GRE    = 1 << 1,
+MLX5DV_RAW_PACKET_CAP_TUNNELED_OFFLOAD_GENEVE = 1 << 2,
+.in -8
+};
+
 .fi
 .SH "RETURN VALUE"
 0 on success or the value of errno on failure (which indicates the failure reason).
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index b0b6704..afc9e6f 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -312,6 +312,8 @@ struct mlx5_query_device_ex_resp {
 	__u32				flags; /* Use enum mlx5_query_dev_resp_flags */
 	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
 	struct mlx5_striding_rq_caps	striding_rq_caps;
+	__u32				tunnel_offloads_caps;
+	__u32				reserved;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 36b47d7..2a29983 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -646,6 +646,11 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_STRIDING_RQ;
 	}
 
+	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS) {
+		attrs_out->tunnel_offloads_caps = mctx->tunnel_offloads_caps;
+		comp_mask_out |= MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS;
+	}
+
 	attrs_out->comp_mask = comp_mask_out;
 
 	return 0;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 7c85ab6..b9f10f4 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -293,6 +293,7 @@ struct mlx5_context {
 	struct mlx5dv_ctx_allocators	extern_alloc;
 	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
 	struct mlx5dv_striding_rq_caps	striding_rq_caps;
+	uint32_t			tunnel_offloads_caps;
 };
 
 struct mlx5_bitmap {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 95a1697..0e78c41 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -61,7 +61,8 @@ enum mlx5dv_context_comp_mask {
 	MLX5DV_CONTEXT_MASK_CQE_COMPRESION	= 1 << 0,
 	MLX5DV_CONTEXT_MASK_SWP			= 1 << 1,
 	MLX5DV_CONTEXT_MASK_STRIDING_RQ		= 1 << 2,
-	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 3,
+	MLX5DV_CONTEXT_MASK_TUNNEL_OFFLOADS	= 1 << 3,
+	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 4,
 };
 
 struct mlx5dv_cqe_comp_caps {
@@ -82,6 +83,12 @@ struct mlx5dv_striding_rq_caps {
 	uint32_t supported_qpts;
 };
 
+enum mlx5dv_tunnel_offloads {
+	MLX5DV_RAW_PACKET_CAP_TUNNELED_OFFLOAD_VXLAN	= 1 << 0,
+	MLX5DV_RAW_PACKET_CAP_TUNNELED_OFFLOAD_GRE	= 1 << 1,
+	MLX5DV_RAW_PACKET_CAP_TUNNELED_OFFLOAD_GENEVE	= 1 << 2,
+};
+
 /*
  * Direct verbs device-specific attributes
  */
@@ -92,6 +99,7 @@ struct mlx5dv_context {
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 	struct mlx5dv_sw_parsing_caps sw_parsing_caps;
 	struct mlx5dv_striding_rq_caps striding_rq_caps;
+	uint32_t	tunnel_offloads_caps;
 };
 
 enum mlx5dv_context_flags {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 7d36434..a3323fd 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2214,6 +2214,7 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	mctx->cqe_comp_caps = resp.cqe_comp_caps;
 	mctx->sw_parsing_caps = resp.sw_parsing_caps;
 	mctx->striding_rq_caps = resp.striding_rq_caps.caps;
+	mctx->tunnel_offloads_caps = resp.tunnel_offloads_caps;
 
 	if (resp.flags & MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP)
 		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
