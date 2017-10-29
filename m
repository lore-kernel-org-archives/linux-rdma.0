From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/2] mlx5: Report SW parsing capabilities through mlx5 direct verbs
Date: Sun, 29 Oct 2017 13:07:37 +0200
Message-ID: <1509275258-9808-2-git-send-email-yishaih@mellanox.com>
References: <1509275258-9808-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509275258-9808-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Software parsing (SWP) is a feature that can be used to instruct the
device to stop using its internal parser and to parse packets on the
transmit path according to offsets set for each packet.

Through this feature, the device allows the handling of checksum and LSO
by the hardware according to the location of IP and TCP/UDP headers.

Report various SW parsing capabilities and supported QP types through
mlx5 direct verbs interface.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  1 +
 providers/mlx5/mlx5.c     |  5 +++++
 providers/mlx5/mlx5.h     |  1 +
 providers/mlx5/mlx5dv.h   | 15 ++++++++++++++-
 providers/mlx5/verbs.c    |  1 +
 5 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index bce9e55..d1e8b9d 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -289,6 +289,7 @@ struct mlx5_query_device_ex_resp {
 	struct mlx5_packet_pacing_caps	packet_pacing_caps;
 	__u32				support_multi_pkt_send_wqe;
 	__u32				reserved;
+	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 15f258d..4001e85 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -630,6 +630,11 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW)
 		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_ENHANCED_MPW;
 
+	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_SWP) {
+		attrs_out->sw_parsing_caps = mctx->sw_parsing_caps;
+		comp_mask_out |= MLX5DV_CONTEXT_MASK_SWP;
+	}
+
 	attrs_out->comp_mask = comp_mask_out;
 
 	return 0;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 46fce28..270d525 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -272,6 +272,7 @@ struct mlx5_context {
 	uint64_t			vendor_cap_flags; /* Use enum mlx5_vendor_cap_flags */
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 	struct mlx5dv_ctx_allocators	extern_alloc;
+	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
 };
 
 struct mlx5_bitmap {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index ffe2c55..67965cd 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -58,7 +58,8 @@ enum {
 
 enum mlx5dv_context_comp_mask {
 	MLX5DV_CONTEXT_MASK_CQE_COMPRESION	= 1 << 0,
-	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 1,
+	MLX5DV_CONTEXT_MASK_SWP			= 1 << 1,
+	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 2,
 };
 
 struct mlx5dv_cqe_comp_caps {
@@ -66,6 +67,11 @@ struct mlx5dv_cqe_comp_caps {
 	uint32_t supported_format; /* enum mlx5dv_cqe_comp_res_format */
 };
 
+struct mlx5dv_sw_parsing_caps {
+	uint32_t sw_parsing_offloads; /* Use enum mlx5dv_sw_parsing_offloads */
+	uint32_t supported_qpts;
+};
+
 /*
  * Direct verbs device-specific attributes
  */
@@ -74,6 +80,7 @@ struct mlx5dv_context {
 	uint64_t	flags;
 	uint64_t	comp_mask;
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
+	struct mlx5dv_sw_parsing_caps sw_parsing_caps;
 };
 
 enum mlx5dv_context_flags {
@@ -316,6 +323,12 @@ enum mlx5dv_cqe_comp_res_format {
 	MLX5DV_CQE_RES_FORMAT_RESERVED		= 1 << 2,
 };
 
+enum mlx5dv_sw_parsing_offloads {
+	MLX5DV_SW_PARSING		= 1 << 0,
+	MLX5DV_SW_PARSING_CSUM		= 1 << 1,
+	MLX5DV_SW_PARSING_LSO		= 1 << 2,
+};
+
 static MLX5DV_ALWAYS_INLINE
 uint8_t mlx5dv_get_cqe_owner(struct mlx5_cqe64 *cqe)
 {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 2315a0d..52152f7 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2002,6 +2002,7 @@ int mlx5_query_device_ex(struct ibv_context *context,
 		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_ENHANCED_MPW;
 
 	mctx->cqe_comp_caps = resp.cqe_comp_caps;
+	mctx->sw_parsing_caps = resp.sw_parsing_caps;
 
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
