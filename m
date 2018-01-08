From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 4/8] mlx5: Convert from init_context to alloc_context
Date: Mon,  8 Jan 2018 14:26:28 -0700
Message-ID: <20180108212632.5183-5-jgg@ziepe.ca>
References: <20180108212632.5183-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Now that alloc_context can create a verbs_context directly we do
not need two init APIs.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/buf.c   |  2 +-
 providers/mlx5/cq.c    |  2 +-
 providers/mlx5/dbrec.c |  4 ++--
 providers/mlx5/mlx5.c  | 45 +++++++++++++++++++++++++--------------------
 providers/mlx5/mlx5.h  |  4 ++--
 5 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/providers/mlx5/buf.c b/providers/mlx5/buf.c
index 72de5b0e55e462..89573caa73628b 100644
--- a/providers/mlx5/buf.c
+++ b/providers/mlx5/buf.c
@@ -538,7 +538,7 @@ int mlx5_alloc_buf_contig(struct mlx5_context *mctx,
 	int block_size_exp;
 	int max_block_log;
 	int min_block_log;
-	struct ibv_context *context = &mctx->ibv_ctx;
+	struct ibv_context *context = &mctx->ibv_ctx.context;
 	off_t offset;
 
 	mlx5_alloc_get_env_info(&max_block_log,
diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index e96418f6c66ad5..e62b2eb6ec1ea8 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1717,7 +1717,7 @@ int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 {
 	struct mlx5_cqe64 *cqe;
 	int i;
-	struct mlx5_device *dev = to_mdev(mctx->ibv_ctx.device);
+	struct mlx5_device *dev = to_mdev(mctx->ibv_ctx.context.device);
 	int ret;
 	enum mlx5_alloc_type type;
 	enum mlx5_alloc_type default_type = MLX5_ALLOC_TYPE_ANON;
diff --git a/providers/mlx5/dbrec.c b/providers/mlx5/dbrec.c
index 17aee0ba20eea6..d6a69a50b26901 100644
--- a/providers/mlx5/dbrec.c
+++ b/providers/mlx5/dbrec.c
@@ -49,7 +49,7 @@ struct mlx5_db_page {
 static struct mlx5_db_page *__add_page(struct mlx5_context *context)
 {
 	struct mlx5_db_page *page;
-	int ps = to_mdev(context->ibv_ctx.device)->page_size;
+	int ps = to_mdev(context->ibv_ctx.context.device)->page_size;
 	int pp;
 	int i;
 	int nlong;
@@ -121,7 +121,7 @@ out:
 void mlx5_free_db(struct mlx5_context *context, __be32 *db)
 {
 	struct mlx5_db_page *page;
-	uintptr_t ps = to_mdev(context->ibv_ctx.device)->page_size;
+	uintptr_t ps = to_mdev(context->ibv_ctx.context.device)->page_size;
 	int i;
 
 	pthread_mutex_lock(&context->db_list_mutex);
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index a829cd5eb26473..7e8dc9b1951192 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -549,7 +549,7 @@ static int mlx5_cmd_get_context(struct mlx5_context *context,
 				struct mlx5_alloc_ucontext_resp *resp,
 				size_t resp_len)
 {
-	struct verbs_context *verbs_ctx = verbs_get_ctx(&context->ibv_ctx);
+	struct verbs_context *verbs_ctx = &context->ibv_ctx;
 
 	if (!ibv_cmd_get_context(verbs_ctx, &req->ibv_req,
 				 req_len, &resp->ibv_resp, resp_len))
@@ -856,8 +856,8 @@ static void adjust_uar_info(struct mlx5_device *mdev,
 	context->num_uars_per_page = resp.num_uars_per_page;
 }
 
-static int mlx5_init_context(struct verbs_device *vdev,
-			     struct ibv_context *ctx, int cmd_fd)
+static struct verbs_context *mlx5_alloc_context(struct ibv_device *ibdev,
+						int cmd_fd)
 {
 	struct mlx5_context	       *context;
 	struct mlx5_alloc_ucontext	req;
@@ -868,7 +868,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	int				low_lat_uuars;
 	int				gross_uuars;
 	int				j;
-	struct mlx5_device	       *mdev;
+	struct mlx5_device	       *mdev = to_mdev(ibdev);
 	struct verbs_context	       *v_ctx;
 	struct ibv_port_attr		port_attr;
 	struct ibv_device_attr_ex	device_attr;
@@ -876,14 +876,14 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	int				bfi;
 	int				num_sys_page_map;
 
-	mdev = to_mdev(&vdev->device);
-	v_ctx = verbs_get_ctx(ctx);
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
+	if (!context)
+		return NULL;
+
+	v_ctx = &context->ibv_ctx;
 	page_size = mdev->page_size;
 	mlx5_single_threaded = single_threaded_app();
 
-	context = to_mctx(ctx);
-	context->ibv_ctx.cmd_fd = cmd_fd;
-
 	open_debug_file(context);
 	set_debug_mask();
 	set_freeze_on_error();
@@ -1001,15 +1001,15 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	    sizeof(resp.hca_core_clock_offset) &&
 	    resp.comp_mask & MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET) {
 		context->core_clock.offset = resp.hca_core_clock_offset;
-		mlx5_map_internal_clock(mdev, ctx);
+		mlx5_map_internal_clock(mdev, &v_ctx->context);
 	}
 
-	mlx5_read_env(&vdev->device, context);
+	mlx5_read_env(ibdev, context);
 
 	mlx5_spinlock_init(&context->hugetlb_lock);
 	list_head_init(&context->hugetlb_list);
 
-	context->ibv_ctx.ops = mlx5_ctx_ops;
+	v_ctx->context.ops = mlx5_ctx_ops;
 
 	v_ctx->create_qp_ex = mlx5_create_qp_ex;
 	v_ctx->open_xrcd = mlx5_open_xrcd;
@@ -1030,7 +1030,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	v_ctx->modify_cq = mlx5_modify_cq;
 
 	memset(&device_attr, 0, sizeof(device_attr));
-	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
+	if (!mlx5_query_device_ex(&v_ctx->context, NULL, &device_attr,
 				  sizeof(struct ibv_device_attr_ex))) {
 		context->cached_device_cap_flags =
 			device_attr.orig_attr.device_cap_flags;
@@ -1040,11 +1040,11 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	for (j = 0; j < min(MLX5_MAX_PORTS_NUM, context->num_ports); ++j) {
 		memset(&port_attr, 0, sizeof(port_attr));
-		if (!mlx5_query_port(ctx, j + 1, &port_attr))
+		if (!mlx5_query_port(&v_ctx->context, j + 1, &port_attr))
 			context->cached_link_layer[j] = port_attr.link_layer;
 	}
 
-	return 0;
+	return v_ctx;
 
 err_free_bf:
 	free(context->bfs);
@@ -1055,11 +1055,13 @@ err_free:
 			munmap(context->uar[i].reg, page_size);
 	}
 	close_debug_file(context);
-	return errno;
+
+	verbs_uninit_context(&context->ibv_ctx);
+	free(context);
+	return NULL;
 }
 
-static void mlx5_cleanup_context(struct verbs_device *device,
-				 struct ibv_context *ibctx)
+static void mlx5_free_context(struct ibv_context *ibctx)
 {
 	struct mlx5_context *context = to_mctx(ibctx);
 	int page_size = to_mdev(ibctx->device)->page_size;
@@ -1074,6 +1076,9 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 		munmap(context->hca_core_clock - context->core_clock.offset,
 		       page_size);
 	close_debug_file(context);
+
+	verbs_uninit_context(&context->ibv_ctx);
+	free(context);
 }
 
 static void mlx5_uninit_device(struct verbs_device *verbs_device)
@@ -1108,7 +1113,7 @@ static const struct verbs_device_ops mlx5_dev_ops = {
 	.match_table = hca_table,
 	.alloc_device = mlx5_device_alloc,
 	.uninit_device = mlx5_uninit_device,
-	.init_context = mlx5_init_context,
-	.uninit_context = mlx5_cleanup_context,
+	.alloc_context = mlx5_alloc_context,
+	.free_context = mlx5_free_context,
 };
 PROVIDER_DRIVER(mlx5_dev_ops);
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 5a1f7c0a2bbafc..45778460610beb 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -230,7 +230,7 @@ struct mlx5_uar_info {
 };
 
 struct mlx5_context {
-	struct ibv_context		ibv_ctx;
+	struct verbs_context		ibv_ctx;
 	int				max_num_qps;
 	int				bf_reg_size;
 	int				tot_uuars;
@@ -548,7 +548,7 @@ static inline struct mlx5_device *to_mdev(struct ibv_device *ibdev)
 
 static inline struct mlx5_context *to_mctx(struct ibv_context *ibctx)
 {
-	return to_mxxx(ctx, context);
+	return container_of(ibctx, struct mlx5_context, ibv_ctx.context);
 }
 
 static inline struct mlx5_pd *to_mpd(struct ibv_pd *ibpd)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
