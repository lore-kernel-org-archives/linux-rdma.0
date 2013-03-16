From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v4 1/2] libmlx4: Infra-structure changes to support verbs extensions
Date: Fri, 15 Mar 2013 17:39:55 -0700
Message-ID: <1363394396-951-1-git-send-email-sean.hefty@intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981D8@FMSMSX151.amr.corp.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A981D8-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c |  103 ++++++++++++++++++++++++++++++++++++++++++------------------
 src/mlx4.h |   16 +++++++++
 2 files changed, 88 insertions(+), 31 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 8cf249a..f6c12f9 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -120,22 +120,26 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
-static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_fd)
+static int mlx4_init_context(struct verbs_device *device,
+			struct ibv_context *ibv_ctx, int cmd_fd)
 {
-	struct mlx4_context	       *context;
+	struct mlx4_context		*context;
 	struct ibv_get_context		cmd;
 	struct mlx4_alloc_ucontext_resp resp;
 	int				i;
+	/* verbs_context should be used for new verbs
+	  *struct verbs_context *verbs_ctx = verbs_get_ctx(ibv_ctx);
+	 */
 
-	context = calloc(1, sizeof *context);
-	if (!context)
-		return NULL;
-
-	context->ibv_ctx.cmd_fd = cmd_fd;
+	/* memory footprint of mlx4_context and verbs_context share
+	  * struct ibv_context.
+	*/
+	context = to_mctx(ibv_ctx);
+	ibv_ctx->cmd_fd = cmd_fd;
 
-	if (ibv_cmd_get_context(&context->ibv_ctx, &cmd, sizeof cmd,
+	if (ibv_cmd_get_context(ibv_ctx, &cmd, sizeof(cmd),
 				&resp.ibv_resp, sizeof resp))
-		goto err_free;
+		return errno;
 
 	context->num_qps	= resp.qp_tab_size;
 	context->qp_table_shift = ffs(context->num_qps) - 1 - MLX4_QP_TABLE_BITS;
@@ -150,15 +154,15 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
-	context->uar = mmap(NULL, to_mdev(ibdev)->page_size, PROT_WRITE,
+	context->uar = mmap(NULL, to_mdev_ex(device)->page_size, PROT_WRITE,
 			    MAP_SHARED, cmd_fd, 0);
 	if (context->uar == MAP_FAILED)
-		goto err_free;
+		return errno;
 
 	if (resp.bf_reg_size) {
-		context->bf_page = mmap(NULL, to_mdev(ibdev)->page_size,
+		context->bf_page = mmap(NULL, to_mdev_ex(device)->page_size,
 					PROT_WRITE, MAP_SHARED, cmd_fd,
-					to_mdev(ibdev)->page_size);
+					to_mdev_ex(device)->page_size);
 		if (context->bf_page == MAP_FAILED) {
 			fprintf(stderr, PFX "Warning: BlueFlame available, "
 				"but failed to mmap() BlueFlame page.\n");
@@ -176,23 +180,52 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
-	context->ibv_ctx.ops = mlx4_ctx_ops;
+	ibv_ctx->ops = mlx4_ctx_ops;
+	/* New verbs should be added as below
+	  * verbs_ctx->drv_new_func1 = mlx4_new_func1;
+	  */
+	return 0;
 
-	return &context->ibv_ctx;
+}
 
-err_free:
-	free(context);
-	return NULL;
+static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_fd)
+{
+	struct verbs_device *vdev;
+	struct verbs_context *context_ex;
+	int ret;
+
+	vdev = container_of(ibdev, struct verbs_device, device);
+	context_ex = calloc(1, sizeof(*context_ex) + vdev->size_of_context);
+	if (!context_ex) {
+		errno = ENOMEM;
+		return NULL;
+	}
+
+	context_ex->sz = sizeof(*context_ex);
+	ret = mlx4_init_context(vdev, &context_ex->context, cmd_fd);
+	if (ret) {
+		free(context_ex);
+		return NULL;
+	}
+
+	return &context_ex->context;
 }
 
-static void mlx4_free_context(struct ibv_context *ibctx)
+static void mlx4_uninit_context(struct verbs_device *device,
+					struct ibv_context *ibv_ctx)
 {
-	struct mlx4_context *context = to_mctx(ibctx);
+	struct mlx4_context *context = to_mctx(ibv_ctx);
 
-	munmap(context->uar, to_mdev(ibctx->device)->page_size);
+	munmap(context->uar, to_mdev_ex(device)->page_size);
 	if (context->bf_page)
-		munmap(context->bf_page, to_mdev(ibctx->device)->page_size);
-	free(context);
+		munmap(context->bf_page, to_mdev_ex(device)->page_size);
+}
+
+static void mlx4_free_context(struct ibv_context *ibctx)
+{
+	mlx4_uninit_context(container_of(ibctx->device, struct verbs_device, device),
+			    ibctx);
+	free(container_of(ibctx, struct verbs_context, context));
 }
 
 static struct ibv_device_ops mlx4_dev_ops = {
@@ -200,11 +233,11 @@ static struct ibv_device_ops mlx4_dev_ops = {
 	.free_context  = mlx4_free_context
 };
 
-static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path,
+					     int abi_version)
 {
 	char			value[8];
-	struct mlx4_device    *dev;
+	struct mlx4_device_ex	*dev;
 	unsigned		vendor, device;
 	int			i;
 
@@ -226,7 +259,7 @@ static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
 	return NULL;
 
 found:
-	if (abi_version < MLX4_UVERBS_MIN_ABI_VERSION ||
+	if (abi_version <= MLX4_UVERBS_MIN_ABI_VERSION ||
 	    abi_version > MLX4_UVERBS_MAX_ABI_VERSION) {
 		fprintf(stderr, PFX "Fatal: ABI version %d of %s is not supported "
 			"(min supported %d, max supported %d)\n",
@@ -243,16 +276,24 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = mlx4_dev_ops;
+	dev->verbs_dev.device.ops = mlx4_dev_ops;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
-
-	return &dev->ibv_dev;
+	dev->verbs_dev.sz = sizeof(*dev);
+	dev->verbs_dev.size_of_context =
+		sizeof(struct mlx4_context) - sizeof(struct ibv_context);
+	 /* mlx4_init_context will initialize provider calls */
+	dev->verbs_dev.init_context = mlx4_init_context;
+	dev->verbs_dev.uninit_context = mlx4_uninit_context;
+
+	return &dev->verbs_dev;
 }
 
+
 #ifdef HAVE_IBV_REGISTER_DRIVER
 static __attribute__((constructor)) void mlx4_register_driver(void)
 {
-	ibv_register_driver("mlx4", mlx4_driver_init);
+	verbs_register_driver("mlx4", mlx4_driver_init);
+
 }
 #else
 /*
diff --git a/src/mlx4.h b/src/mlx4.h
index 13c13d8..c06dbd5 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -135,6 +135,11 @@ struct mlx4_device {
 	int				page_size;
 };
 
+struct mlx4_device_ex {
+	struct verbs_device	verbs_dev;
+	int			page_size;
+};
+
 struct mlx4_db_page;
 
 struct mlx4_context {
@@ -261,6 +266,17 @@ static inline struct mlx4_device *to_mdev(struct ibv_device *ibdev)
 	return to_mxxx(dev, device);
 }
 
+#define to_mxxx_ex(xxx, type)						\
+	((struct mlx4_##type##_ex *)					\
+	 ((void *) verbs##xxx - offsetof(struct mlx4_##type##_ex, verbs_##xxx)))
+
+
+static inline struct mlx4_device_ex *to_mdev_ex(const struct verbs_device
+						*verbsdev)
+{
+	return to_mxxx_ex(dev, device);
+}
+
 static inline struct mlx4_context *to_mctx(struct ibv_context *ibctx)
 {
 	return to_mxxx(ctx, context);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
