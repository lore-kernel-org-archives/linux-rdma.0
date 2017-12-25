From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 7/9] mlx5: Add support for using a dedicated BF register
Date: Mon, 25 Dec 2017 15:56:59 +0200
Message-ID: <1514210221-10466-8-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch enables attaching a dedicated BF register to a given TD.

It uses the new mmap command that was introduced in previous patch to
dynamically allocate a UAR, and then it manages its internal BF
registers to accomplish the above task.

In order to manage the UAR's BF registers the code takes into
consideration the number of uars per page as was reported from the
kernel driver upon context allocation.

In case there is an available BF register from previous UAR mapping it
will be reused instead of allocating a new UAR.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c  |  6 ++++
 providers/mlx5/mlx5.h  |  4 +++
 providers/mlx5/verbs.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index bdad9ba..10a59fe 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1087,6 +1087,12 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 	int page_size = to_mdev(ibctx->device)->page_size;
 	int i;
 
+	for (i = context->start_dyn_bfregs_index;
+	      i < context->start_dyn_bfregs_index + context->num_dyn_bfregs; i++) {
+		if (context->bfs[i].uar)
+			munmap(context->bfs[i].uar, page_size);
+	}
+
 	free(context->count_dyn_bfregs);
 	free(context->bfs);
 	for (i = 0; i < MLX5_MAX_UARS; ++i) {
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 7a9434b..d8b1858 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -469,6 +469,10 @@ struct mlx5_bf {
 	unsigned			buf_size;
 	unsigned			uuarn;
 	off_t				uar_mmap_offset;
+	/* The virtual address of the mmaped uar, applicable for the dynamic use case */
+	void				*uar;
+	/* Index in the dynamic bfregs portion */
+	uint32_t			bfreg_dyn_index;
 };
 
 struct mlx5_mr {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 13af0c2..b8cbbe9 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -154,13 +154,102 @@ struct ibv_pd *mlx5_alloc_pd(struct ibv_context *context)
 	return &pd->ibv_pd;
 }
 
+static void mlx5_put_bfreg_index(struct mlx5_context *ctx, uint32_t bfreg_dyn_index)
+{
+	pthread_mutex_lock(&ctx->dyn_bfregs_mutex);
+	ctx->count_dyn_bfregs[bfreg_dyn_index]--;
+	pthread_mutex_unlock(&ctx->dyn_bfregs_mutex);
+}
+
+static int mlx5_get_bfreg_index(struct mlx5_context *ctx)
+{
+	int i;
+
+	pthread_mutex_lock(&ctx->dyn_bfregs_mutex);
+	for (i = 0; i < ctx->num_dyn_bfregs; i++) {
+		if (!ctx->count_dyn_bfregs[i]) {
+			ctx->count_dyn_bfregs[i]++;
+			pthread_mutex_unlock(&ctx->dyn_bfregs_mutex);
+			return i;
+		}
+	}
+
+	pthread_mutex_unlock(&ctx->dyn_bfregs_mutex);
+
+	return -1;
+}
+
+/* Returns a dedicated BF to be used by a thread domain */
 static struct mlx5_bf *mlx5_attach_dedicated_bf(struct ibv_context *context)
 {
+	struct mlx5_uar_info uar;
+	struct mlx5_context *ctx = to_mctx(context);
+	struct mlx5_device *dev = to_mdev(ctx->ibv_ctx.device);
+	int bfreg_dyn_index;
+	uint32_t bfreg_total_index;
+	uint32_t uar_page_index;
+	int index_in_uar, index_uar_in_page;
+	int mmap_bf_index;
+	int num_bfregs_per_page;
+
+	bfreg_dyn_index = mlx5_get_bfreg_index(ctx);
+	if (bfreg_dyn_index < 0) {
+		errno = ENOENT;
+		return NULL;
+	}
+
+	bfreg_total_index = ctx->start_dyn_bfregs_index + bfreg_dyn_index;
+	/* Check whether this bfreg index was already mapped and ready to be used */
+	if (ctx->bfs[bfreg_total_index].reg)
+		return &(ctx->bfs[bfreg_total_index]);
+
+	num_bfregs_per_page = ctx->num_uars_per_page * MLX5_NUM_NON_FP_BFREGS_PER_UAR;
+	uar_page_index = bfreg_dyn_index / num_bfregs_per_page;
+
+	/* The first bf index of each page will hold the mapped area address of the UAR */
+	mmap_bf_index = ctx->start_dyn_bfregs_index + (uar_page_index * num_bfregs_per_page);
+
+	pthread_mutex_lock(&ctx->dyn_bfregs_mutex);
+	if (ctx->bfs[mmap_bf_index].uar) {
+		/* UAR was already mapped, set its matching bfreg */
+		goto set_reg;
+	}
+
+	ctx->bfs[mmap_bf_index].uar = mlx5_mmap(&uar, uar_page_index, ctx->ibv_ctx.cmd_fd, dev->page_size,
+				  MLX5_UAR_TYPE_REGULAR_DYN);
+	if (ctx->bfs[mmap_bf_index].uar == MAP_FAILED) {
+		ctx->bfs[mmap_bf_index].uar = NULL;
+		pthread_mutex_unlock(&ctx->dyn_bfregs_mutex);
+		goto out;
+	}
+
+set_reg:
+	pthread_mutex_unlock(&ctx->dyn_bfregs_mutex);
+	/* Find the uar index in the system page, may be different than 1 when 4K UAR is used in 64K system page */
+	index_uar_in_page = (bfreg_dyn_index % num_bfregs_per_page) /
+			    MLX5_NUM_NON_FP_BFREGS_PER_UAR;
+	index_in_uar = bfreg_dyn_index % MLX5_NUM_NON_FP_BFREGS_PER_UAR;
+	/* set the global index so that this entry will be detected as a valid BF entry as part of post_send */
+	ctx->bfs[bfreg_total_index].uuarn = bfreg_total_index;
+	ctx->bfs[bfreg_total_index].reg = ctx->bfs[mmap_bf_index].uar + (index_uar_in_page * MLX5_ADAPTER_PAGE_SIZE) +
+					MLX5_BF_OFFSET + (index_in_uar * ctx->bf_reg_size);
+	ctx->bfs[bfreg_total_index].buf_size = ctx->bf_reg_size / 2;
+	ctx->bfs[bfreg_total_index].bfreg_dyn_index = bfreg_dyn_index;
+	/* This mmap command can't be repeated by secondary processes, no option to re-allocate same UAR */
+	ctx->bfs[bfreg_total_index].uar_mmap_offset = 0;
+	ctx->bfs[bfreg_total_index].need_lock = 0;
+
+	return &ctx->bfs[bfreg_total_index];
+out:
+	mlx5_put_bfreg_index(ctx, bfreg_dyn_index);
 	return NULL;
 }
 
 static void mlx5_detach_dedicated_bf(struct ibv_context *context, struct mlx5_bf *bf)
 {
+	struct mlx5_context *ctx = to_mctx(context);
+
+	mlx5_put_bfreg_index(ctx, bf->bfreg_dyn_index);
 }
 
 struct ibv_td *mlx5_alloc_td(struct ibv_context *context, struct ibv_td_init_attr *init_attr)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
