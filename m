From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/2] mlx5: Report if kernel allows using MPW in SQ
Date: Mon, 11 Sep 2017 14:43:04 +0300
Message-ID: <1505130185-32658-2-git-send-email-yishaih@mellanox.com>
References: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505130185-32658-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use flag MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED to indicate hardware
supports multi packet WQE and it's enabled in SQ context.

Flag MLX5DV_CONTEXT_FLAGS_MPW is deprecated, shall not be used
in new applications.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 3 ++-
 providers/mlx5/mlx5-abi.h                | 5 +++++
 providers/mlx5/mlx5.c                    | 4 ++--
 providers/mlx5/mlx5.h                    | 3 ++-
 providers/mlx5/mlx5dv.h                  | 3 ++-
 providers/mlx5/verbs.c                   | 4 ++--
 6 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index b33a75b..c2f8bf4 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -35,7 +35,8 @@ enum mlx5dv_context_flags {
  * This flag indicates if CQE version 0 or 1 is needed.
  */
  MLX5DV_CONTEXT_FLAGS_CQE_V1 = (1 << 0),
- MLX5DV_CONTEXT_FLAGS_MPW    = (1 << 1), /* Multi packet WQE is supported or not */
+ MLX5DV_CONTEXT_FLAGS_MPW    = (1 << 1), /* Obsoleted */
+ MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED  = (1 << 2), /* Multi packet WQE is allowed */
 .in -8
 };
 .fi
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index d05cb40..c9d3ec2 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -273,6 +273,11 @@ struct mlx5_packet_pacing_caps {
 	__u32  reserved;
 };
 
+enum mlx5_mpw_caps {
+	MLX5_MPW_RESERVED	= 1 << 0, /* Obsoleted, don't use */
+	MLX5_ALLOW_MPW		= 1 << 1,
+};
+
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
 	__u32				comp_mask;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 0e4d65f..84a67e9 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -625,8 +625,8 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 	if (mctx->cqe_version == MLX5_CQE_VERSION_V1)
 		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_CQE_V1;
 
-	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_MPW)
-		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_MPW;
+	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED)
+		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED;
 
 	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_CQE_COMPRESION) {
 		attrs_out->cqe_comp_caps = mctx->cqe_comp_caps;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index ad36cbf..c8d9fe9 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -182,7 +182,8 @@ enum {
 };
 
 enum mlx5_vendor_cap_flags {
-	MLX5_VENDOR_CAP_FLAGS_MPW		= 1 << 0,
+	MLX5_VENDOR_CAP_FLAGS_MPW		= 1 << 0, /* Obsoleted */
+	MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED	= 1 << 1,
 };
 
 enum {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 34b4d27..cf49b63 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -81,7 +81,8 @@ enum mlx5dv_context_flags {
 	 * This flag indicates if CQE version 0 or 1 is needed.
 	 */
 	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
-	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
+	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1), /* Obsoleted */
+	MLX5DV_CONTEXT_FLAGS_MPW_ALLOWED = (1 << 2),
 };
 
 enum mlx5dv_cq_init_attr_mask {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index fc63ae9..0e8a9a3 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1965,8 +1965,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
 	attr->packet_pacing_caps = resp.packet_pacing_caps.caps;
 
-	if (resp.support_multi_pkt_send_wqe)
-		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW;
+	if (resp.support_multi_pkt_send_wqe & MLX5_ALLOW_MPW)
+		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW_ALLOWED;
 
 	mctx->cqe_comp_caps = resp.cqe_comp_caps;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
