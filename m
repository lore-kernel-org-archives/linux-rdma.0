From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 3/8] mlx4: Convert from init_context to alloc_context
Date: Mon,  8 Jan 2018 14:26:27 -0700
Message-ID: <20180108212632.5183-4-jgg@ziepe.ca>
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
 providers/mlx4/dbrec.c |  4 ++--
 providers/mlx4/mlx4.c  | 53 ++++++++++++++++++++++++++++----------------------
 providers/mlx4/mlx4.h  |  4 ++--
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/providers/mlx4/dbrec.c b/providers/mlx4/dbrec.c
index e6d45fcff05a5b..57cd472dd2b381 100644
--- a/providers/mlx4/dbrec.c
+++ b/providers/mlx4/dbrec.c
@@ -55,7 +55,7 @@ static struct mlx4_db_page *__add_page(struct mlx4_context *context,
 				       enum mlx4_db_type type)
 {
 	struct mlx4_db_page *page;
-	int ps = to_mdev(context->ibv_ctx.device)->page_size;
+	int ps = to_mdev(context->ibv_ctx.context.device)->page_size;
 	int pp;
 	int i;
 
@@ -120,7 +120,7 @@ void mlx4_free_db(struct mlx4_context *context, enum mlx4_db_type type,
 		  __be32 *db)
 {
 	struct mlx4_db_page *page;
-	uintptr_t ps = to_mdev(context->ibv_ctx.device)->page_size;
+	uintptr_t ps = to_mdev(context->ibv_ctx.context.device)->page_size;
 	int i;
 
 	pthread_mutex_lock(&context->db_list_mutex);
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 56bf1298b48734..3d64b8c8ebae65 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -146,8 +146,8 @@ static int mlx4_map_internal_clock(struct mlx4_device *mdev,
 	return 0;
 }
 
-static int mlx4_init_context(struct verbs_device *v_device,
-				struct ibv_context *ibv_ctx, int cmd_fd)
+static struct verbs_context *mlx4_alloc_context(struct ibv_device *ibdev,
+						  int cmd_fd)
 {
 	struct mlx4_context	       *context;
 	struct ibv_get_context		cmd;
@@ -155,21 +155,21 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	int				i;
 	struct mlx4_alloc_ucontext_resp_v3 resp_v3;
 	__u16				bf_reg_size;
-	struct mlx4_device              *dev = to_mdev(&v_device->device);
-	struct verbs_context *verbs_ctx = verbs_get_ctx(ibv_ctx);
+	struct mlx4_device              *dev = to_mdev(ibdev);
+	struct verbs_context		*verbs_ctx;
 	struct ibv_device_attr_ex	dev_attrs;
 
-	/* memory footprint of mlx4_context and verbs_context share
-	* struct ibv_context.
-	*/
-	context = to_mctx(ibv_ctx);
-	ibv_ctx->cmd_fd = cmd_fd;
+	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
+	if (!context)
+		return NULL;
+
+	verbs_ctx = &context->ibv_ctx;
 
 	mlx4_read_env();
 	if (dev->abi_version <= MLX4_UVERBS_NO_DEV_CAPS_ABI_VERSION) {
 		if (ibv_cmd_get_context(verbs_ctx, &cmd, sizeof(cmd),
 					&resp_v3.ibv_resp, sizeof(resp_v3)))
-			return errno;
+			goto failed;
 
 		context->num_qps  = resp_v3.qp_tab_size;
 		bf_reg_size	  = resp_v3.bf_reg_size;
@@ -177,7 +177,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	} else  {
 		if (ibv_cmd_get_context(verbs_ctx, &cmd, sizeof(cmd),
 					&resp.ibv_resp, sizeof(resp)))
-			return errno;
+			goto failed;
 
 		context->num_qps  = resp.qp_tab_size;
 		bf_reg_size	  = resp.bf_reg_size;
@@ -205,7 +205,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	context->uar = mmap(NULL, dev->page_size, PROT_WRITE,
 			    MAP_SHARED, cmd_fd, 0);
 	if (context->uar == MAP_FAILED)
-		return errno;
+		goto failed;
 
 	if (bf_reg_size) {
 		context->bf_page = mmap(NULL, dev->page_size,
@@ -226,16 +226,16 @@ static int mlx4_init_context(struct verbs_device *v_device,
 		context->bf_buf_size = 0;
 	}
 
-	ibv_ctx->ops = mlx4_ctx_ops;
+	verbs_ctx->context.ops = mlx4_ctx_ops;
 
 	context->hca_core_clock = NULL;
 	memset(&dev_attrs, 0, sizeof(dev_attrs));
-	if (!mlx4_query_device_ex(ibv_ctx, NULL, &dev_attrs,
+	if (!mlx4_query_device_ex(&verbs_ctx->context, NULL, &dev_attrs,
 				  sizeof(struct ibv_device_attr_ex))) {
 		context->max_qp_wr = dev_attrs.orig_attr.max_qp_wr;
 		context->max_sge = dev_attrs.orig_attr.max_sge;
 		if (context->core_clock.offset_valid)
-			mlx4_map_internal_clock(dev, ibv_ctx);
+			mlx4_map_internal_clock(dev, &verbs_ctx->context);
 	}
 
 	verbs_ctx->close_xrcd = mlx4_close_xrcd;
@@ -256,21 +256,28 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_ctx->destroy_rwq_ind_table = mlx4_destroy_rwq_ind_table;
 	verbs_ctx->modify_cq = mlx4_modify_cq;
 
-	return 0;
+	return verbs_ctx;
 
+failed:
+	verbs_uninit_context(&context->ibv_ctx);
+	free(context);
+	return NULL;
 }
 
-static void mlx4_uninit_context(struct verbs_device *v_device,
-					struct ibv_context *ibv_ctx)
+static void mlx4_free_context(struct ibv_context *ibv_ctx)
 {
 	struct mlx4_context *context = to_mctx(ibv_ctx);
+	struct mlx4_device *mdev = to_mdev(ibv_ctx->device);
 
-	munmap(context->uar, to_mdev(&v_device->device)->page_size);
+	munmap(context->uar, mdev->page_size);
 	if (context->bf_page)
-		munmap(context->bf_page, to_mdev(&v_device->device)->page_size);
+		munmap(context->bf_page, mdev->page_size);
 	if (context->hca_core_clock)
 		munmap(context->hca_core_clock - context->core_clock.offset,
-		       to_mdev(&v_device->device)->page_size);
+		       mdev->page_size);
+
+	verbs_uninit_context(&context->ibv_ctx);
+	free(context);
 }
 
 static void mlx4_uninit_device(struct verbs_device *verbs_device)
@@ -305,8 +312,8 @@ static const struct verbs_device_ops mlx4_dev_ops = {
 	.match_table = hca_table,
 	.alloc_device = mlx4_device_alloc,
 	.uninit_device = mlx4_uninit_device,
-	.init_context = mlx4_init_context,
-	.uninit_context = mlx4_uninit_context,
+	.alloc_context = mlx4_alloc_context,
+	.free_context = mlx4_free_context,
 };
 PROVIDER_DRIVER(mlx4_dev_ops);
 
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index a71e42f5c6e25f..e78f6ab0d099e5 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -99,7 +99,7 @@ struct mlx4_device {
 struct mlx4_db_page;
 
 struct mlx4_context {
-	struct ibv_context		ibv_ctx;
+	struct verbs_context		ibv_ctx;
 
 	void			       *uar;
 
@@ -260,7 +260,7 @@ static inline struct mlx4_device *to_mdev(struct ibv_device *ibdev)
 
 static inline struct mlx4_context *to_mctx(struct ibv_context *ibctx)
 {
-	return to_mxxx(ctx, context);
+	return container_of(ibctx, struct mlx4_context, ibv_ctx.context);
 }
 
 static inline struct mlx4_pd *to_mpd(struct ibv_pd *ibpd)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
