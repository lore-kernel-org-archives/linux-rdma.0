From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/2] mlx5: Report Multi-Packet RQ capabilities through mlx5 direct verbs
Date: Sun, 19 Nov 2017 21:21:07 +0200
Message-ID: <1511119268-5934-2-git-send-email-yishaih@mellanox.com>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511119268-5934-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A Multi-Packet RQ is a receive queue where multiple packets are
written to the same WQE. Each message starts in the beginning of a
stride. The total size of the scatter elements of each WQE is
determined upon RQ creation and all the posted WQEs should meet the
determined size.

A Multi-Packet RQ reduces the number of needed post-recv operations
thus increasing performance.

It reduces memory footprint by allowing each packet to consume a
different number of strides instead of the whole WR.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 14 +++++++++++++-
 providers/mlx5/mlx5-abi.h                |  6 ++++++
 providers/mlx5/mlx5.c                    |  5 +++++
 providers/mlx5/mlx5.h                    |  1 +
 providers/mlx5/mlx5dv.h                  | 12 +++++++++++-
 providers/mlx5/verbs.c                   |  1 +
 6 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index eca6fc1..f7cfdc0 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -29,6 +29,17 @@ uint32_t supported_qpts;
 };
 .PP
 .nf
+struct mlx5dv_striding_rq_caps {
+.in +8
+uint32_t min_single_stride_log_num_of_bytes; /* min log size of each stride */
+uint32_t max_single_stride_log_num_of_bytes; /* max log size of each stride */
+uint32_t min_single_wqe_log_num_of_strides; /* min log number of strides per WQE */
+uint32_t max_single_wqe_log_num_of_strides; /* max log number of strides per WQE */
+uint32_t supported_qpts;
+.in -8
+};
+.PP
+.nf
 struct mlx5dv_context {
 .in +8
 uint8_t         version;
@@ -59,7 +70,8 @@ enum mlx5dv_context_comp_mask {
 .in +8
 MLX5DV_CONTEXT_MASK_CQE_COMPRESION      = 1 << 0,
 MLX5DV_CONTEXT_MASK_SWP                 = 1 << 1,
-MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 2,
+MLX5DV_CONTEXT_MASK_STRIDING_RQ         = 1 << 2,
+MLX5DV_CONTEXT_MASK_RESERVED            = 1 << 3,
 .in -8
 };
 
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index e1f5114..b569bd4 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -288,6 +288,11 @@ enum mlx5_query_dev_resp_flags {
 	MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_PAD	= 1 << 1,
 };
 
+struct mlx5_striding_rq_caps {
+	struct mlx5dv_striding_rq_caps	caps;
+	__u32				reserved;
+};
+
 struct mlx5_query_device_ex_resp {
 	struct ibv_query_device_resp_ex ibv_resp;
 	__u32				comp_mask;
@@ -299,6 +304,7 @@ struct mlx5_query_device_ex_resp {
 	__u32				support_multi_pkt_send_wqe;
 	__u32				flags; /* Use enum mlx5_query_dev_resp_flags */
 	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
+	struct mlx5_striding_rq_caps	striding_rq_caps;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 70afbd4..36b47d7 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -641,6 +641,11 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 		comp_mask_out |= MLX5DV_CONTEXT_MASK_SWP;
 	}
 
+	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_STRIDING_RQ) {
+		attrs_out->striding_rq_caps = mctx->striding_rq_caps;
+		comp_mask_out |= MLX5DV_CONTEXT_MASK_STRIDING_RQ;
+	}
+
 	attrs_out->comp_mask = comp_mask_out;
 
 	return 0;
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index b4782dd..7c85ab6 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -292,6 +292,7 @@ struct mlx5_context {
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 	struct mlx5dv_ctx_allocators	extern_alloc;
 	struct mlx5dv_sw_parsing_caps	sw_parsing_caps;
+	struct mlx5dv_striding_rq_caps	striding_rq_caps;
 };
 
 struct mlx5_bitmap {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 935ff54..3566bcb 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -60,7 +60,8 @@ enum {
 enum mlx5dv_context_comp_mask {
 	MLX5DV_CONTEXT_MASK_CQE_COMPRESION	= 1 << 0,
 	MLX5DV_CONTEXT_MASK_SWP			= 1 << 1,
-	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 2,
+	MLX5DV_CONTEXT_MASK_STRIDING_RQ		= 1 << 2,
+	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 3,
 };
 
 struct mlx5dv_cqe_comp_caps {
@@ -73,6 +74,14 @@ struct mlx5dv_sw_parsing_caps {
 	uint32_t supported_qpts;
 };
 
+struct mlx5dv_striding_rq_caps {
+	uint32_t min_single_stride_log_num_of_bytes;
+	uint32_t max_single_stride_log_num_of_bytes;
+	uint32_t min_single_wqe_log_num_of_strides;
+	uint32_t max_single_wqe_log_num_of_strides;
+	uint32_t supported_qpts;
+};
+
 /*
  * Direct verbs device-specific attributes
  */
@@ -82,6 +91,7 @@ struct mlx5dv_context {
 	uint64_t	comp_mask;
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 	struct mlx5dv_sw_parsing_caps sw_parsing_caps;
+	struct mlx5dv_striding_rq_caps striding_rq_caps;
 };
 
 enum mlx5dv_context_flags {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 19fc947..478d9a1 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2156,6 +2156,7 @@ int mlx5_query_device_ex(struct ibv_context *context,
 
 	mctx->cqe_comp_caps = resp.cqe_comp_caps;
 	mctx->sw_parsing_caps = resp.sw_parsing_caps;
+	mctx->striding_rq_caps = resp.striding_rq_caps.caps;
 
 	if (resp.flags & MLX5_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP)
 		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_CQE_128B_COMP;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
