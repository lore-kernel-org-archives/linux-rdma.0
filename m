From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/3] mlx5: Expose 128B padded CQE capability in direct verb
Date: Wed, 15 Nov 2017 16:23:41 +0200
Message-ID: <1510755822-15945-3-git-send-email-yishaih@mellanox.com>
References: <1510755822-15945-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510755822-15945-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Padded CQE lets in some benchmarks when the CQE size is the same
as the cache line size, to get better performance relative to CQE
which is not padded and causes to read-modify-write in case of a
partial cache line change.

This patch exposes the device capability of padding a 128B CQE size
by the direct verb mlx5dv_query_device.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
index 544a1af..eca6fc1 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -49,6 +49,7 @@ enum mlx5dv_context_flags {
  MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED  = (1 << 2), /* Multi packet WQE is allowed */
  MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3), /* Enhanced multi packet WQE is supported or not */
  MLX5DV_CONTEXT_FLAGS_CQE_128B_COMP = (1 << 4), /* Support CQE 128B compression */
+ MLX5DV_CONTEXT_FLAGS_CQE_128B_PAD = (1 << 5), /* Support CQE 128B padding */
 .in -8
 };
 
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 6e69d2c..574688a 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -281,6 +281,7 @@ enum mlx5_mpw_caps {
 
 enum mlx5_query_dev_resp_flags {
 	MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP	= 1 << 0,
+	MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD	= 1 << 1,
 };
 
 struct mlx5_query_device_ex_resp {
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 3874d79..70afbd4 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -625,6 +625,9 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP)
 		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_CQE_128B_COMP;
 
+	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_CQE_128B_PAD)
+		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_CQE_128B_PAD;
+
 	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_CQE_COMPRESION) {
 		attrs_out->cqe_comp_caps = mctx->cqe_comp_caps;
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_CQE_COMPRESION;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 1c287d2..b4782dd 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -194,6 +194,7 @@ enum mlx5_vendor_cap_flags {
 	MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED	= 1 << 1,
 	MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW	= 1 << 2,
 	MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP	= 1 << 3,
+	MLX5_VENDOR_CAP_FLAGS_CQE_128B_PAD	= 1 << 4,
 };
 
 enum {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 2b89f70..0073b9c 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -93,6 +93,7 @@ enum mlx5dv_context_flags {
 	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
 	MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3),
 	MLX5DV_CONTEXT_FLAGS_CQE_128B_COMP = (1 << 4), /* Support CQE 128B compression */
+	MLX5DV_CONTEXT_FLAGS_CQE_128B_PAD = (1 << 5), /* Support CQE 128B padding */
 };
 
 enum mlx5dv_cq_init_attr_mask {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index d861eb7..7350697 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2137,6 +2137,9 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	if (resp.flags & MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP)
 		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP;
 
+	if (resp.flags & MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD)
+		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_CQE_128B_PAD;
+
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
 	sub_minor = raw_fw_ver & 0xffff;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
