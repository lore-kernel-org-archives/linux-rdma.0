From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/5] mlx5: Support for user space clock info
Date: Wed, 17 Jan 2018 15:51:29 +0200
Message-ID: <1516197093-20699-2-git-send-email-yishaih@mellanox.com>
References: <1516197093-20699-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197093-20699-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch maps the kernel driver's clock info page to userspace.
With this, users will be able to read the clock info directly from
the shared page without any system calls.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5-abi.h | 20 +++++++++++++++++++-
 providers/mlx5/mlx5.c     | 27 +++++++++++++++++++++++++++
 providers/mlx5/mlx5.h     |  2 ++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 7b96429..c5d323e 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -81,6 +81,23 @@ enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 };
 
+/* Bit indexes for the mlx5_alloc_ucontext_resp.clock_info_versions bitmap */
+enum {
+	MLX5_IB_CLOCK_INFO_V1	= 0,
+};
+
+struct mlx5_ib_clock_info {
+	__u32 sig;
+	__u32 resv;
+	__u64 nsec;
+	__u64 last_cycles;
+	__u64 frac;
+	__u32 mult;
+	__u32 shift;
+	__u64 mask;
+	__u64 overflow_period;
+};
+
 struct mlx5_alloc_ucontext_resp {
 	struct ibv_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
@@ -98,7 +115,8 @@ struct mlx5_alloc_ucontext_resp {
 	__u32				response_length;
 	__u8				cqe_version;
 	__u8				cmds_supp_uhw;
-	__u16				reserved2;
+	__u8				reserved2;
+	__u8				clock_info_versions;
 	__u64				hca_core_clock_offset;
 	__u32				log_uar_size;
 	__u32				num_uars_per_page;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 52eb4f9..28bb320 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -607,6 +607,23 @@ static int mlx5_map_internal_clock(struct mlx5_device *mdev,
 	return 0;
 }
 
+static void mlx5_map_clock_info(struct mlx5_device *mdev,
+				struct ibv_context *ibv_ctx)
+{
+	struct mlx5_context *context = to_mctx(ibv_ctx);
+	void *clock_info_page;
+	off_t offset = 0;
+
+	set_command(MLX5_MMAP_GET_CLOCK_INFO_CMD, &offset);
+	set_index(MLX5_IB_CLOCK_INFO_V1, &offset);
+	clock_info_page = mmap(NULL, mdev->page_size,
+			       PROT_READ, MAP_SHARED, ibv_ctx->cmd_fd,
+			       offset * mdev->page_size);
+
+	if (clock_info_page != MAP_FAILED)
+		context->clock_info_page = clock_info_page;
+}
+
 int mlx5dv_query_device(struct ibv_context *ctx_in,
 			 struct mlx5dv_context *attrs_out)
 {
@@ -1027,6 +1044,14 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		mlx5_map_internal_clock(mdev, ctx);
 	}
 
+	context->clock_info_page = NULL;
+	if (resp.response_length + sizeof(resp.ibv_resp) >=
+	    offsetof(struct mlx5_alloc_ucontext_resp, clock_info_versions) +
+	    sizeof(resp.clock_info_versions) &&
+	    (resp.clock_info_versions & (1 << MLX5_IB_CLOCK_INFO_V1))) {
+		mlx5_map_clock_info(mdev, ctx);
+	}
+
 	mlx5_read_env(&vdev->device, context);
 
 	mlx5_spinlock_init(&context->hugetlb_lock);
@@ -1107,6 +1132,8 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 	if (context->hca_core_clock)
 		munmap(context->hca_core_clock - context->core_clock.offset,
 		       page_size);
+	if (context->clock_info_page)
+		munmap((void *)context->clock_info_page, page_size);
 	close_debug_file(context);
 }
 
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index d8b1858..c0f342d 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -60,6 +60,7 @@ enum {
 	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1,
 	MLX5_MMAP_GET_CORE_CLOCK_CMD    = 5,
 	MLX5_MMAP_ALLOC_WC		= 6,
+	MLX5_MMAP_GET_CLOCK_INFO_CMD    = 7,
 };
 
 enum {
@@ -287,6 +288,7 @@ struct mlx5_context {
 		uint64_t                mask;
 	} core_clock;
 	void			       *hca_core_clock;
+	const struct mlx5_ib_clock_info *clock_info_page;
 	struct ibv_tso_caps		cached_tso_caps;
 	int				cmds_supp_uhw;
 	uint32_t			uar_size;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
