From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/2] mlx5: Use non-cached mapping when Blueflame is not used
Date: Sun, 29 Oct 2017 15:01:09 +0200
Message-ID: <1509282070-1391-2-git-send-email-yishaih@mellanox.com>
References: <1509282070-1391-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509282070-1391-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The user can avoid using Blueflame by setting the MLX5_SHUT_UP_BF environment
variable. In this case, mapping the UAR to non-cached can save memory barrier
when writing the doorbell.

The knowledge whether a successful non-cached mapping was done can be achieved
by the DV API.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c     |  2 +-
 providers/mlx5/mlx5.c   | 72 +++++++++++++++++++++++++++++++++++++------------
 providers/mlx5/mlx5.h   | 13 +++++++--
 providers/mlx5/mlx5dv.h |  5 ++++
 4 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index de261dd..5459488 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1308,7 +1308,7 @@ int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	 */
 	mmio_wc_start();
 
-	mmio_write64_be(ctx->uar[0] + MLX5_CQ_DOORBELL, htobe64(doorbell));
+	mmio_write64_be(ctx->uar[0].reg + MLX5_CQ_DOORBELL, htobe64(doorbell));
 
 	mmio_flush_writes();
 
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 15f258d..d5ed4a0 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -684,7 +684,7 @@ static int mlx5dv_get_cq(struct ibv_cq *cq_in,
 	cq_out->cqe_size  = mcq->cqe_sz;
 	cq_out->buf       = mcq->active_buf->buf;
 	cq_out->dbrec     = mcq->dbrec;
-	cq_out->cq_uar	  = mctx->uar[0];
+	cq_out->cq_uar	  = mctx->uar[0].reg;
 
 	mcq->flags	 |= MLX5_CQ_FLAGS_DV_OWNED;
 
@@ -756,15 +756,52 @@ COMPAT_SYMVER_FUNC(mlx5dv_init_obj, 1_0, "MLX5_1.0",
 	return ret;
 }
 
-static off_t get_uar_mmap_offset(int idx, int page_size)
+static off_t get_uar_mmap_offset(int idx, int page_size, int command)
 {
 	off_t offset = 0;
 
-	set_command(MLX5_MMAP_GET_REGULAR_PAGES_CMD, &offset);
+	set_command(command, &offset);
 	set_index(idx, &offset);
+
 	return offset * page_size;
 }
 
+static off_t uar_type_to_cmd(int uar_type)
+{
+	return (uar_type == MLX5_UAR_TYPE_NC) ? MLX5_MMAP_GET_NC_PAGES_CMD :
+		MLX5_MMAP_GET_REGULAR_PAGES_CMD;
+}
+
+static void *mlx5_mmap(struct mlx5_uar_info *uar, int index,
+		       int cmd_fd, int page_size, int uar_type)
+{
+	off_t offset;
+
+	if (uar_type == MLX5_UAR_TYPE_NC) {
+		offset = get_uar_mmap_offset(index, page_size,
+					     MLX5_MMAP_GET_NC_PAGES_CMD);
+		uar->reg = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED,
+				       cmd_fd, offset);
+		if (uar->reg != MAP_FAILED) {
+			uar->type = MLX5_UAR_TYPE_NC;
+			goto out;
+		}
+	}
+
+	/* Backward compatibility for legacy kernels that don't support
+	 * MLX5_MMAP_GET_NC_PAGES_CMD mmap command.
+	 */
+	offset = get_uar_mmap_offset(index, page_size,
+				     MLX5_MMAP_GET_REGULAR_PAGES_CMD);
+	uar->reg = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED,
+			cmd_fd, offset);
+	if (uar->reg != MAP_FAILED)
+		uar->type = MLX5_UAR_TYPE_REGULAR;
+
+out:
+	return uar->reg;
+}
+
 int mlx5dv_set_context_attr(struct ibv_context *ibv_ctx,
 			enum mlx5dv_set_ctx_attr_type type, void *attr)
 {
@@ -808,7 +845,6 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	int				low_lat_uuars;
 	int				gross_uuars;
 	int				j;
-	off_t				offset;
 	struct mlx5_device	       *mdev;
 	struct verbs_context	       *v_ctx;
 	struct ibv_port_attr		port_attr;
@@ -905,13 +941,15 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
+	context->prefer_bf = get_always_bf();
+	context->shut_up_bf = get_shut_up_bf();
+
 	num_sys_page_map = context->tot_uuars / (context->num_uars_per_page * MLX5_NUM_NON_FP_BFREGS_PER_UAR);
 	for (i = 0; i < num_sys_page_map; ++i) {
-		offset = get_uar_mmap_offset(i, page_size);
-		context->uar[i] = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED,
-				       cmd_fd, offset);
-		if (context->uar[i] == MAP_FAILED) {
-			context->uar[i] = NULL;
+		if (mlx5_mmap(&context->uar[i], i, cmd_fd, page_size,
+			      context->shut_up_bf ? MLX5_UAR_TYPE_NC :
+			      MLX5_UAR_TYPE_REGULAR) == MAP_FAILED) {
+			context->uar[i].reg = NULL;
 			goto err_free_bf;
 		}
 	}
@@ -920,7 +958,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		for (j = 0; j < context->num_uars_per_page; j++) {
 			for (k = 0; k < NUM_BFREGS_PER_UAR; k++) {
 				bfi = (i * context->num_uars_per_page + j) * NUM_BFREGS_PER_UAR + k;
-				context->bfs[bfi].reg = context->uar[i] + MLX5_ADAPTER_PAGE_SIZE * j +
+				context->bfs[bfi].reg = context->uar[i].reg + MLX5_ADAPTER_PAGE_SIZE * j +
 							MLX5_BF_OFFSET + k * context->bf_reg_size;
 				context->bfs[bfi].need_lock = need_uuar_lock(context, bfi);
 				mlx5_spinlock_init(&context->bfs[bfi].lock);
@@ -928,7 +966,9 @@ static int mlx5_init_context(struct verbs_device *vdev,
 				if (bfi)
 					context->bfs[bfi].buf_size = context->bf_reg_size / 2;
 				context->bfs[bfi].uuarn = bfi;
-				context->bfs[bfi].uar_mmap_offset = get_uar_mmap_offset(i, page_size);
+				context->bfs[bfi].uar_mmap_offset = get_uar_mmap_offset(i,
+											page_size,
+											uar_type_to_cmd(context->uar[i].type));
 			}
 		}
 	}
@@ -941,8 +981,6 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		mlx5_map_internal_clock(mdev, ctx);
 	}
 
-	context->prefer_bf = get_always_bf();
-	context->shut_up_bf = get_shut_up_bf();
 	mlx5_read_env(&vdev->device, context);
 
 	mlx5_spinlock_init(&context->hugetlb_lock);
@@ -988,8 +1026,8 @@ err_free_bf:
 
 err_free:
 	for (i = 0; i < MLX5_MAX_UARS; ++i) {
-		if (context->uar[i])
-			munmap(context->uar[i], page_size);
+		if (context->uar[i].reg)
+			munmap(context->uar[i].reg, page_size);
 	}
 	close_debug_file(context);
 	return errno;
@@ -1004,8 +1042,8 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 
 	free(context->bfs);
 	for (i = 0; i < MLX5_MAX_UARS; ++i) {
-		if (context->uar[i])
-			munmap(context->uar[i], page_size);
+		if (context->uar[i].reg)
+			munmap(context->uar[i].reg, page_size);
 	}
 	if (context->hca_core_clock)
 		munmap(context->hca_core_clock - context->core_clock.offset,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 46fce28..66aae3a 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -57,7 +57,6 @@ enum {
 };
 
 enum {
-	MLX5_MMAP_GET_REGULAR_PAGES_CMD    = 0,
 	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1,
 	MLX5_MMAP_GET_CORE_CLOCK_CMD    = 5
 };
@@ -210,6 +209,16 @@ struct mlx5_spinlock {
 	int				in_use;
 };
 
+enum mlx5_uar_type {
+	MLX5_UAR_TYPE_REGULAR,
+	MLX5_UAR_TYPE_NC,
+};
+
+struct mlx5_uar_info {
+	void				*reg;
+	enum mlx5_uar_type		type;
+};
+
 struct mlx5_context {
 	struct ibv_context		ibv_ctx;
 	int				max_num_qps;
@@ -239,7 +248,7 @@ struct mlx5_context {
 	}				uidx_table[MLX5_UIDX_TABLE_SIZE];
 	pthread_mutex_t                 uidx_table_mutex;
 
-	void			       *uar[MLX5_MAX_UARS];
+	struct mlx5_uar_info		uar[MLX5_MAX_UARS];
 	struct mlx5_db_page	       *db_list;
 	pthread_mutex_t			db_list_mutex;
 	int				cache_line_size;
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index ffe2c55..9e20a25 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -632,6 +632,11 @@ enum mlx5dv_set_ctx_attr_type {
 	MLX5DV_CTX_ATTR_BUF_ALLOCATORS = 1,
 };
 
+enum {
+	MLX5_MMAP_GET_REGULAR_PAGES_CMD	= 0,
+	MLX5_MMAP_GET_NC_PAGES_CMD	= 3,
+};
+
 struct mlx5dv_ctx_allocators {
 	void *(*alloc)(size_t size, void *priv_data);
 	void (*free)(void *ptr, void *priv_data);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
