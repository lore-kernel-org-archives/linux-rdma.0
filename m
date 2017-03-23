From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 2/6] mlx5: Report multi packet send WQE capability for mlx5 based hardware
Date: Thu, 23 Mar 2017 15:55:25 +0200
Message-ID: <1490277329-8738-3-git-send-email-yishaih@mellanox.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490277329-8738-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Report whether multi packet send WQE is supported or not through mlx5
direct verbs.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/mlx5dv_query_device.3 | 1 +
 providers/mlx5/mlx5-abi.h                | 2 ++
 providers/mlx5/mlx5.c                    | 8 +++++++-
 providers/mlx5/mlx5.h                    | 5 +++++
 providers/mlx5/mlx5dv.h                  | 3 ++-
 providers/mlx5/verbs.c                   | 3 +++
 6 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/man/mlx5dv_query_device.3 b/providers/mlx5/man/mlx5dv_query_device.3
index 1954714..b33a75b 100644
--- a/providers/mlx5/man/mlx5dv_query_device.3
+++ b/providers/mlx5/man/mlx5dv_query_device.3
@@ -35,6 +35,7 @@ enum mlx5dv_context_flags {
  * This flag indicates if CQE version 0 or 1 is needed.
  */
  MLX5DV_CONTEXT_FLAGS_CQE_V1 = (1 << 0),
+ MLX5DV_CONTEXT_FLAGS_MPW    = (1 << 1), /* Multi packet WQE is supported or not */
 .in -8
 };
 .fi
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index dde46b9..3574594 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -277,6 +277,8 @@ struct mlx5_query_device_ex_resp {
 	struct mlx5_rss_caps            rss_caps; /* vendor data channel */
 	__u64				reserved_cqe_comp;
 	struct mlx5_packet_pacing_caps	packet_pacing_caps;
+	__u32				support_multi_pkt_send_wqe;
+	__u32				reserved;
 };
 
 #endif /* MLX5_ABI_H */
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index eeaf5ac..7af6a0a 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -612,13 +612,18 @@ static int mlx5_map_internal_clock(struct mlx5_device *mdev,
 int mlx5dv_query_device(struct ibv_context *ctx_in,
 			 struct mlx5dv_context *attrs_out)
 {
+	struct mlx5_context *mctx = to_mctx(ctx_in);
+
 	attrs_out->comp_mask = 0;
 	attrs_out->version   = 0;
 	attrs_out->flags     = 0;
 
-	if (to_mctx(ctx_in)->cqe_version == MLX5_CQE_VERSION_V1)
+	if (mctx->cqe_version == MLX5_CQE_VERSION_V1)
 		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_CQE_V1;
 
+	if (mctx->vendor_cap_flags & MLX5_VENDOR_CAP_FLAGS_MPW)
+		attrs_out->flags |= MLX5DV_CONTEXT_FLAGS_MPW;
+
 	return 0;
 }
 
@@ -827,6 +832,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	}
 
 	context->cmds_supp_uhw = resp.cmds_supp_uhw;
+	context->vendor_cap_flags = 0;
 
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	pthread_mutex_init(&context->srq_table_mutex, NULL);
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 57ed1a1..86f2438 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -180,6 +180,10 @@ enum {
 	MLX5_USER_CMDS_SUPP_UHW_CREATE_AH    = 1 << 1,
 };
 
+enum mlx5_vendor_cap_flags {
+	MLX5_VENDOR_CAP_FLAGS_MPW		= 1 << 0,
+};
+
 struct mlx5_resource {
 	enum mlx5_rsc_type	type;
 	uint32_t		rsn;
@@ -258,6 +262,7 @@ struct mlx5_context {
 	struct ibv_tso_caps		cached_tso_caps;
 	int				cmds_supp_uhw;
 	uint32_t			uar_size;
+	uint64_t			vendor_cap_flags; /* Use enum mlx5_vendor_cap_flags */
 };
 
 struct mlx5_bitmap {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 2e4995f..c09fad2 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -67,7 +67,8 @@ enum mlx5dv_context_flags {
 	/*
 	 * This flag indicates if CQE version 0 or 1 is needed.
 	 */
-	MLX5DV_CONTEXT_FLAGS_CQE_V1 = (1 << 0),
+	MLX5DV_CONTEXT_FLAGS_CQE_V1	= (1 << 0),
+	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
 };
 
 /*
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index aba1631..cea9e46 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1924,6 +1924,9 @@ int mlx5_query_device_ex(struct ibv_context *context,
 	attr->rss_caps.rx_hash_function = resp.rss_caps.rx_hash_function;
 	attr->packet_pacing_caps = resp.packet_pacing_caps.caps;
 
+	if (resp.support_multi_pkt_send_wqe)
+		mctx->vendor_cap_flags |= MLX5_VENDOR_CAP_FLAGS_MPW;
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
