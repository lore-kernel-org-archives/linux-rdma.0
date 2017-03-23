From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 3/6] mlx5: Report CQE compression capabilities through mlx5 direct verbs
Date: Thu, 23 Mar 2017 15:55:26 +0200
Message-ID: <1490277329-8738-4-git-send-email-yishaih@mellanox.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490277329-8738-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report max number of compressed and aggregated CQEs in a single
merged CQE and the formats of mini CQE supported for responder.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h |  3 ++-
 providers/mlx5/mlx5.c     |  9 ++++++++-
 providers/mlx5/mlx5.h     |  1 +
 providers/mlx5/mlx5dv.h   | 17 +++++++++++++++++
 providers/mlx5/verbs.c    |  2 ++
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 3574594..487de3a 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -35,6 +35,7 @@
 
 #include <infiniband/kern-abi.h>
 #include <infiniband/verbs.h>
+#include "mlx5dv.h"
 
 #define MLX5_UVERBS_MIN_ABI_VERSION	1
 #define MLX5_UVERBS_MAX_ABI_VERSION	1
@@ -275,7 +276,7 @@ struct mlx5_query_device_ex_resp {
 	__u32				response_length;
 	struct ibv_tso_caps		tso_caps;
 	struct mlx5_rss_caps            rss_caps; /* vendor data channel */
-	__u64				reserved_cqe_comp;
+	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 	struct mlx5_packet_pacing_caps	packet_pacing_caps;
 	__u32				support_multi_pkt_send_wqe;
 	__u32				reserved;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 7af6a0a..edb6d35 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -613,8 +613,8 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 			 struct mlx5dv_context *attrs_out)
 {
 	struct mlx5_context *mctx = to_mctx(ctx_in);
+	uint64_t comp_mask_out = 0;
 
-	attrs_out->comp_mask = 0;
 	attrs_out->version   = 0;
 	attrs_out->flags     = 0;
 
@@ -624,6 +624,13 @@ int mlx5dv_query_device(struct ibv_context *ctx_in,
 	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_MPW)
 		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_MPW;
 
+	if (attrs_out->comp_mask & MLX5DV_CONTEXT_MASK_CQE_COMPRESION) {
+		attrs_out->cqe_comp_caps = mctx->cqe_comp_caps;
+		comp_mask_out |= MLX5DV_CONTEXT_MASK_CQE_COMPRESION;
+	}
+
+	attrs_out->comp_mask = comp_mask_out;
+
 	return 0;
 }
 
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 86f2438..bb383d4 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -263,6 +263,7 @@ struct mlx5_context {
 	int				cmds_supp_uhw;
 	uint32_t			uar_size;
 	uint64_t			vendor_cap_flags; /* Use enum mlx5_vendor_cap_flags */
+	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 };
 
 struct mlx5_bitmap {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index c09fad2..a2f7acf 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -54,6 +54,16 @@ enum {
 	MLX5_SND_DBR	= 1,
 };
 
+enum mlx5dv_context_comp_mask {
+	MLX5DV_CONTEXT_MASK_CQE_COMPRESION	= 1 << 0,
+	MLX5DV_CONTEXT_MASK_RESERVED		= 1 << 1,
+};
+
+struct mlx5dv_cqe_comp_caps {
+	uint32_t max_num;
+	uint32_t supported_format; /* enum mlx5dv_cqe_comp_res_format */
+};
+
 /*
  * Direct verbs device-specific attributes
  */
@@ -61,6 +71,7 @@ struct mlx5dv_context {
 	uint8_t		version;
 	uint64_t	flags;
 	uint64_t	comp_mask;
+	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
 };
 
 enum mlx5dv_context_flags {
@@ -277,6 +288,12 @@ struct mlx5_cqe64 {
 	uint8_t		op_own;
 };
 
+enum mlx5dv_cqe_comp_res_format {
+	MLX5DV_CQE_RES_FORMAT_HASH		= 1 << 0,
+	MLX5DV_CQE_RES_FORMAT_CSUM		= 1 << 1,
+	MLX5DV_CQE_RES_FORMAT_RESERVED		= 1 << 2,
+};
+
 static MLX5DV_ALWAYS_INLINE
 uint8_t mlx5dv_get_cqe_owner(struct mlx5_cqe64 *cqe)
 {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index cea9e46..a223291 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1927,6 +1927,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	if (resp.support_multi_pkt_send_wqe)
 		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW;
 
+	mctx->cqe_comp_caps = resp.cqe_comp_caps;
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
