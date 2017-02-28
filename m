From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx5: Add support for efficient UAR allocation
Date: Tue, 28 Feb 2017 12:45:32 +0200
Message-ID: <1488278732-27829-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The hardware allows now to use UARs with a fixed size of 4KB. To enable
this feature we need both firmware and driver to support this feature in
order to make benefit of this. Benefit is obtained when the system page
size is larger than 4KB, like power pc.

In order to support compatbility between any version of
library/driver/firmware we add a flags field to struct
mlx5_alloc_ucontext to notify the kernel driver whether this is a new
library that supports 4KB UARs. In response, the kernel driver will
return log_uar_size and number of UARs in a page.

We also make order in the terms used. So a "page" now refers to a system
page, "uar" refers to the 4KB UAR area and "uuar" or micro uar refers to
the section in the device registers that is used for posting doorbells.

In case of larger page sizes, we will try to assign more lockless uuars
and preserve the number of medium latency uuars.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/85

 providers/mlx5/mlx5-abi.h |  17 +++++--
 providers/mlx5/mlx5.c     | 127 ++++++++++++++++++++++++++++++++--------------
 providers/mlx5/mlx5.h     |   8 ++-
 3 files changed, 108 insertions(+), 44 deletions(-)

diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 272d14e..5d10486 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -48,10 +48,16 @@ enum {
 };
 
 enum {
-	MLX5_NUM_UUARS_PER_PAGE = 2,
-	MLX5_MAX_UAR_PAGES	= 1 << 8,
-	MLX5_MAX_UUARS		= MLX5_MAX_UAR_PAGES * MLX5_NUM_UUARS_PER_PAGE,
-	MLX5_DEF_TOT_UUARS	= 8 * MLX5_NUM_UUARS_PER_PAGE,
+	MLX5_NUM_NON_FP_BFREGS_PER_UAR	= 2,
+	NUM_BFREGS_PER_UAR		= 4,
+	MLX5_MAX_UARS			= 1 << 8,
+	MLX5_MAX_BFREGS			= MLX5_MAX_UARS * MLX5_NUM_NON_FP_BFREGS_PER_UAR,
+	MLX5_DEF_TOT_UUARS		= 8 * MLX5_NUM_NON_FP_BFREGS_PER_UAR,
+	MLX5_MED_BFREGS_TSHOLD		= 12,
+};
+
+enum mlx5_lib_caps {
+	MLX5_LIB_CAP_4K_UAR		= 1 << 0,
 };
 
 struct mlx5_alloc_ucontext {
@@ -64,6 +70,7 @@ struct mlx5_alloc_ucontext {
 	__u8				reserved0;
 	__u16				reserved1;
 	__u32				reserved2;
+	__u64				lib_caps;
 };
 
 enum mlx5_ib_alloc_ucontext_resp_mask {
@@ -89,6 +96,8 @@ struct mlx5_alloc_ucontext_resp {
 	__u8				cmds_supp_uhw;
 	__u16				reserved2;
 	__u64				hca_core_clock_offset;
+	__u32				log_uar_size;
+	__u32				num_uars_per_page;
 };
 
 struct mlx5_create_ah_resp {
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 980e4df..35ecc43 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -411,10 +411,11 @@ static void mlx5_read_env(struct ibv_device *ibdev, struct mlx5_context *ctx)
 
 }
 
-static int get_total_uuars(void)
+static int get_total_uuars(int page_size)
 {
-	char *env;
 	int size = MLX5_DEF_TOT_UUARS;
+	int uuars_in_page;
+	char *env;
 
 	env = getenv("MLX5_TOTAL_UUARS");
 	if (env)
@@ -423,8 +424,10 @@ static int get_total_uuars(void)
 	if (size < 1)
 		return -EINVAL;
 
-	size = align(size, MLX5_NUM_UUARS_PER_PAGE);
-	if (size > MLX5_MAX_UUARS)
+	uuars_in_page = page_size / MLX5_ADAPTER_PAGE_SIZE * MLX5_NUM_NON_FP_BFREGS_PER_UAR;
+	size = max(uuars_in_page, size);
+	size = align(size, MLX5_NUM_NON_FP_BFREGS_PER_UAR);
+	if (size > MLX5_MAX_BFREGS)
 		return -ENOMEM;
 
 	return size;
@@ -494,7 +497,7 @@ static int get_shut_up_bf(void)
 	return strcmp(env, "0") ? 1 : 0;
 }
 
-static int get_num_low_lat_uuars(void)
+static int get_num_low_lat_uuars(int tot_uuars)
 {
 	char *env;
 	int num = 4;
@@ -506,9 +509,16 @@ static int get_num_low_lat_uuars(void)
 	if (num < 0)
 		return -EINVAL;
 
+	num = max(num, tot_uuars - MLX5_MED_BFREGS_TSHOLD);
 	return num;
 }
 
+/* The library allocates an array of uuar contexts. The one in index zero does
+ * not to execersize odd/even policy so it can avoid a lock but it may not use
+ * blue flame. The upper ones, low_lat_uuars can use blue flame with no lock
+ * since they are assigned to one QP only. The rest can use blue flame but since
+ * they are shared they need a lock
+ */
 static int need_uuar_lock(struct mlx5_context *ctx, int uuarn)
 {
 	if (uuarn == 0)
@@ -547,7 +557,25 @@ static int mlx5_cmd_get_context(struct mlx5_context *context,
 	 * To avoid breaking compatibility of new libmlx5 and older
 	 * kernels, when ibv_cmd_get_context fails with the full
 	 * request length, we try once again with the legacy length.
+	 * We repeat this process while reducing requested size based
+	 * on the feature input size. To avoid this in the future, we
+	 * will remove the check in kernel that requires fields unknown
+	 * to the kernel to be cleared. This will require that any new
+	 * feature that involves extending struct mlx5_alloc_ucontext
+	 * will be accompanied by an indication in the form of one or
+	 * more fields in struct mlx5_alloc_ucontext_resp. If the
+	 * response value can be interpreted as feature not supported
+	 * when the returned value is zero, this will suffice to
+	 * indicate to the library that the request was ignored by the
+	 * kernel, either because it is unaware or because it decided
+	 * to do so. If zero is a valid response, we will add a new
+	 * field that indicates whether the request was handled.
 	 */
+	if (!ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
+				 offsetof(struct mlx5_alloc_ucontext, lib_caps),
+				 &resp->ibv_resp, resp_len))
+		return 0;
+
 	return ibv_cmd_get_context(&context->ibv_ctx, &req->ibv_req,
 				   offsetof(struct mlx5_alloc_ucontext,
 					    cqe_version),
@@ -687,6 +715,21 @@ int mlx5dv_init_obj(struct mlx5dv_obj *obj, uint64_t obj_type)
 	return ret;
 }
 
+static void adjust_uar_info(struct mlx5_device *mdev,
+			    struct mlx5_context *context,
+			    struct mlx5_alloc_ucontext_resp resp)
+{
+	if (!resp.log_uar_size && !resp.num_uars_per_page) {
+		/* old kernel */
+		context->uar_size = mdev->page_size;
+		context->num_uars_per_page = 1;
+		return;
+	}
+
+	context->uar_size = 1 << resp.log_uar_size;
+	context->num_uars_per_page = resp.num_uars_per_page;
+}
+
 static int mlx5_init_context(struct verbs_device *vdev,
 			     struct ibv_context *ctx, int cmd_fd)
 {
@@ -704,6 +747,9 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	struct verbs_context	       *v_ctx;
 	struct ibv_port_attr		port_attr;
 	struct ibv_device_attr_ex	device_attr;
+	int				k;
+	int				bfi;
+	int				num_sys_page_map;
 
 	mdev = to_mdev(&vdev->device);
 	v_ctx = verbs_get_ctx(ctx);
@@ -719,31 +765,21 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	if (gethostname(context->hostname, sizeof(context->hostname)))
 		strcpy(context->hostname, "host_unknown");
 
-	tot_uuars = get_total_uuars();
-	if (tot_uuars <= 0) {
-		if (tot_uuars == 0)
-			errno = EINVAL;
-		else
-			errno = -tot_uuars;
-		goto err_free;
-	}
-
-	gross_uuars = tot_uuars / MLX5_NUM_UUARS_PER_PAGE * 4;
-	context->bfs = calloc(gross_uuars, sizeof(*context->bfs));
-	if (!context->bfs) {
-		errno = ENOMEM;
+	tot_uuars = get_total_uuars(page_size);
+	if (tot_uuars < 0) {
+		errno = -tot_uuars;
 		goto err_free;
 	}
 
-	low_lat_uuars = get_num_low_lat_uuars();
+	low_lat_uuars = get_num_low_lat_uuars(tot_uuars);
 	if (low_lat_uuars < 0) {
-		errno = ENOMEM;
-		goto err_free_bf;
+		errno = -low_lat_uuars;
+		goto err_free;
 	}
 
 	if (low_lat_uuars > tot_uuars - 1) {
 		errno = ENOMEM;
-		goto err_free_bf;
+		goto err_free;
 	}
 
 	memset(&req, 0, sizeof(req));
@@ -752,10 +788,11 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	req.total_num_uuars = tot_uuars;
 	req.num_low_latency_uuars = low_lat_uuars;
 	req.cqe_version = MLX5_CQE_VERSION_V1;
+	req.lib_caps |= MLX5_LIB_CAP_4K_UAR;
 
 	if (mlx5_cmd_get_context(context, &req, sizeof(req), &resp,
 				 sizeof(resp)))
-		goto err_free_bf;
+		goto err_free;
 
 	context->max_num_qps		= resp.qp_tab_size;
 	context->bf_reg_size		= resp.bf_reg_size;
@@ -774,7 +811,16 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		if (context->cqe_version == MLX5_CQE_VERSION_V1)
 			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
 		else
-			 goto err_free_bf;
+			goto err_free;
+	}
+
+	adjust_uar_info(mdev, context, resp);
+
+	gross_uuars = context->tot_uuars / MLX5_NUM_NON_FP_BFREGS_PER_UAR * NUM_BFREGS_PER_UAR;
+	context->bfs = calloc(gross_uuars, sizeof(*context->bfs));
+	if (!context->bfs) {
+		errno = ENOMEM;
+		goto err_free;
 	}
 
 	context->cmds_supp_uhw = resp.cmds_supp_uhw;
@@ -792,8 +838,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
-
-	for (i = 0; i < resp.tot_uuars / MLX5_NUM_UUARS_PER_PAGE; ++i) {
+	num_sys_page_map = context->tot_uuars / (context->num_uars_per_page * MLX5_NUM_NON_FP_BFREGS_PER_UAR);
+	for (i = 0; i < num_sys_page_map; ++i) {
 		offset = 0;
 		set_command(MLX5_MMAP_GET_REGULAR_PAGES_CMD, &offset);
 		set_index(i, &offset);
@@ -805,18 +851,21 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		}
 	}
 
-	for (j = 0; j < gross_uuars; ++j) {
-		context->bfs[j].reg = context->uar[j / 4] +
-			MLX5_BF_OFFSET + (j % 4) * context->bf_reg_size;
-		context->bfs[j].need_lock = need_uuar_lock(context, j);
-		mlx5_spinlock_init(&context->bfs[j].lock);
-		context->bfs[j].offset = 0;
-		if (j)
-			context->bfs[j].buf_size = context->bf_reg_size / 2;
-
-		context->bfs[j].uuarn = j;
+	for (i = 0; i < num_sys_page_map; i++) {
+		for (j = 0; j < context->num_uars_per_page; j++) {
+			for (k = 0; k < NUM_BFREGS_PER_UAR; k++) {
+				bfi = (i * context->num_uars_per_page + j) * NUM_BFREGS_PER_UAR + k;
+				context->bfs[bfi].reg = context->uar[i] + MLX5_ADAPTER_PAGE_SIZE * j +
+							MLX5_BF_OFFSET + k * context->bf_reg_size;
+				context->bfs[bfi].need_lock = need_uuar_lock(context, bfi);
+				mlx5_spinlock_init(&context->bfs[bfi].lock);
+				context->bfs[bfi].offset = 0;
+				if (bfi)
+					context->bfs[bfi].buf_size = context->bf_reg_size / 2;
+				context->bfs[bfi].uuarn = bfi;
+			}
+		}
 	}
-
 	context->hca_core_clock = NULL;
 	if (resp.response_length + sizeof(resp.ibv_resp) >=
 	    offsetof(struct mlx5_alloc_ucontext_resp, hca_core_clock_offset) +
@@ -874,7 +923,7 @@ err_free_bf:
 	free(context->bfs);
 
 err_free:
-	for (i = 0; i < MLX5_MAX_UAR_PAGES; ++i) {
+	for (i = 0; i < MLX5_MAX_UARS; ++i) {
 		if (context->uar[i])
 			munmap(context->uar[i], page_size);
 	}
@@ -890,7 +939,7 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 	int i;
 
 	free(context->bfs);
-	for (i = 0; i < MLX5_MAX_UAR_PAGES; ++i) {
+	for (i = 0; i < MLX5_MAX_UARS; ++i) {
 		if (context->uar[i])
 			munmap(context->uar[i], page_size);
 	}
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index be52a0a..1f007f6 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -66,6 +66,10 @@ enum {
 	MLX5_CQE_VERSION_V1	= 1,
 };
 
+enum {
+	MLX5_ADAPTER_PAGE_SIZE		= 4096,
+};
+
 #define MLX5_CQ_PREFIX "MLX_CQ"
 #define MLX5_QP_PREFIX "MLX_QP"
 #define MLX5_MR_PREFIX "MLX_MR"
@@ -199,6 +203,7 @@ struct mlx5_context {
 	int				bf_reg_size;
 	int				tot_uuars;
 	int				low_lat_uuars;
+	int				num_uars_per_page;
 	int				bf_regs_per_page;
 	int				num_bf_regs;
 	int				prefer_bf;
@@ -221,7 +226,7 @@ struct mlx5_context {
 	}				uidx_table[MLX5_UIDX_TABLE_SIZE];
 	pthread_mutex_t                 uidx_table_mutex;
 
-	void			       *uar[MLX5_MAX_UAR_PAGES];
+	void			       *uar[MLX5_MAX_UARS];
 	struct mlx5_spinlock		lock32;
 	struct mlx5_db_page	       *db_list;
 	pthread_mutex_t			db_list_mutex;
@@ -251,6 +256,7 @@ struct mlx5_context {
 	void			       *hca_core_clock;
 	struct ibv_tso_caps		cached_tso_caps;
 	int				cmds_supp_uhw;
+	uint32_t			uar_size;
 };
 
 struct mlx5_bitmap {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
