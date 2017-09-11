From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] mlx5: Report enhanced multi packet send WQE capability
Date: Mon, 11 Sep 2017 14:43:05 +0300
Message-ID: <1505130185-32658-3-git-send-email-yishaih@mellanox.com>
References: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505130185-32658-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report if enhanced multi packet send WQE is supported through mlx5
direct verbs.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 1 +
 providers/mlx5/mlx5-abi.h                | 1 +
 providers/mlx5/mlx5.c                    | 3 +++
 providers/mlx5/mlx5.h                    | 1 +
 providers/mlx5/mlx5dv.h                  | 1 +
 providers/mlx5/verbs.c                   | 3 +++
 6 files changed, 10 insertions(+)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index c2f8bf4..9238b4f 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -37,6 +37,7 @@ enum mlx5dv_context_flags {
  MLX5DV_CONTEXT_FLAGS_CQE_V1 = (1 << 0),
  MLX5DV_CONTEXT_FLAGS_MPW    = (1 << 1), /* Obsoleted */
  MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED  = (1 << 2), /* Multi packet WQE is allowed */
+ MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3), /* Enhanced multi packet WQE is supported or not */
 .in -8
 };
 .fi
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index c9d3ec2..a741801 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -276,6 +276,7 @@ struct mlx5_packet_pacing_caps {
 enum mlx5_mpw_caps {
 	MLX5_MPW_RESERVED	= 1 << 0, /* Obsoleted, don't use */
 	MLX5_ALLOW_MPW		= 1 << 1,
+	MLX5_SUPPORT_EMPW	= 1 << 2,
 };
 
 struct mlx5_query_device_ex_resp {
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 84a67e9..e7adf14 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -633,6 +633,9 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_CQE_COMPRESION;
 	}
 
+	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW)
+		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW;
+
 	attrs_out->comp_mask = comp_mask_out;
 
 	return 0;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index c8d9fe9..42ccb57 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -184,6 +184,7 @@ enum {
 enum mlx5_vendor_cap_flags {
 	MLX5_VENDOR_CAP_FLAGS_MPW		= 1 << 0, /* Obsoleted */
 	MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED	= 1 << 1,
+	MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW	= 1 << 2,
 };
 
 enum {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index cf49b63..c0d47c7 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -83,6 +83,7 @@ enum mlx5dv_context_flags {
 	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
 	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1), /* Obsoleted */
 	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
+	MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3),
 };
 
 enum mlx5dv_cq_init_attr_mask {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 0e8a9a3..6c5e29f 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1968,6 +1968,9 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	if (resp.support_multi_pkt_send_wqe & MLX5_ALLOW_MPW)
 		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED;
 
+	if (resp.support_multi_pkt_send_wqe & MLX5_SUPPORT_EMPW)
+		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW;
+
 	mctx->cqe_comp_caps = resp.cqe_comp_caps;
 
 	major     = (raw_fw_ver >> 32) & 0xffff;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
