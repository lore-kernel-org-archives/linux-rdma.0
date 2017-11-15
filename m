From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/3] mlx5: Expose 128B CQE compression capability
Date: Wed, 15 Nov 2017 16:23:40 +0200
Message-ID: <1510755822-15945-2-git-send-email-yishaih@mellanox.com>
References: <1510755822-15945-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510755822-15945-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose the capability for CQE compression feature on a CQE size of
128B by mlx5dv_query_device.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 1 +
 providers/mlx5/mlx5-abi.h                | 6 +++++-
 providers/mlx5/mlx5.c                    | 3 +++
 providers/mlx5/mlx5.h                    | 1 +
 providers/mlx5/mlx5dv.h                  | 1 +
 providers/mlx5/verbs.c                   | 3 +++
 6 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index 7a36717..544a1af 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -48,6 +48,7 @@ enum mlx5dv_context_flags {
  MLX5DV_CONTEXT_FLAGS_OBSOLETE    =  (1 << 1), /* Obsoleted, don't use */
  MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED  = (1 << 2), /* Multi packet WQE is allowed */
  MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3), /* Enhanced multi packet WQE is supported or not */
+ MLX5DV_CONTEXT_FLAGS_CQE_128B_COMP = (1 << 4), /* Support CQE 128B compression */
 .in -8
 };
 
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index d1e8b9d..6e69d2c 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -279,6 +279,10 @@ enum mlx5_mpw_caps {
 	MLX5_SUPPORT_EMPW	= 1 << 2,
 };
 
+enum mlx5_query_dev_resp_flags {
+	MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP	= 1 << 0,
+};
+
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
 	__u32				comp_mask;
@@ -288,7 +292,7 @@ struct mlx5_query_device_ex_resp {
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 	struct mlx5_packet_pacing_caps	packet_pacing_caps;
 	__u32				support_multi_pkt_send_wqe;
-	__u32				reserved;
+	__u32				flags; /* Use enum mlx5_query_dev_resp_flags */
 	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
 };
 
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 9aad52c..3874d79 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -622,6 +622,9 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED)
 		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED;
 
+	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP)
+		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_CQE_128B_COMP;
+
 	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_CQE_COMPRESION) {
 		attrs_out->cqe_comp_caps = mctx->cqe_comp_caps;
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_CQE_COMPRESION;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 3ace7e0..1c287d2 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -193,6 +193,7 @@ enum mlx5_vendor_cap_flags {
 	MLX5_VENDOR_CAP_FLAGS_MPW		= 1 << 0, /* Obsoleted */
 	MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED	= 1 << 1,
 	MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW	= 1 << 2,
+	MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP	= 1 << 3,
 };
 
 enum {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 600f6e1..2b89f70 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -92,6 +92,7 @@ enum mlx5dv_context_flags {
 	MLX5DV_CONTEXT_FLAGS_OBSOLETE	= (1 << 1), /* Obsoleted, don't use */
 	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
 	MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW = (1 << 3),
+	MLX5DV_CONTEXT_FLAGS_CQE_128B_COMP = (1 << 4), /* Support CQE 128B compression */
 };
 
 enum mlx5dv_cq_init_attr_mask {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index c2e8c64..d861eb7 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2134,6 +2134,9 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	mctx->cqe_comp_caps = resp.cqe_comp_caps;
 	mctx->sw_parsing_caps = resp.sw_parsing_caps;
 
+	if (resp.flags & MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP)
+		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP;
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
