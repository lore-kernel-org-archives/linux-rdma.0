From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH libmlx4 v6 1/2] libmlx4: Infra-structure changes to support verbs extensions
Date: Tue, 26 Mar 2013 14:16:30 -0700
Message-ID: <1364332591-22866-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change from v5:
Reverted support to include provider ABI 2

 src/mlx4.c |   82 ++++++++++++++++++++++++++++++++---------------------------
 src/mlx4.h |    8 ++++-
 2 files changed, 50 insertions(+), 40 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 8cf249a..dcea026 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -120,22 +120,26 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
-static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_fd)
+static int mlx4_init_context(struct verbs_device *v_device,
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
@@ -150,15 +154,16 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
 
-	context->uar = mmap(NULL, to_mdev(ibdev)->page_size, PROT_WRITE,
-			    MAP_SHARED, cmd_fd, 0);
+	context->uar = mmap(NULL, to_mdev(&v_device->device)->page_size,
+			    PROT_WRITE, MAP_SHARED, cmd_fd, 0);
 	if (context->uar == MAP_FAILED)
-		goto err_free;
+		return errno;
 
 	if (resp.bf_reg_size) {
-		context->bf_page = mmap(NULL, to_mdev(ibdev)->page_size,
+		context->bf_page = mmap(NULL,
+					to_mdev(&v_device->device)->page_size,
 					PROT_WRITE, MAP_SHARED, cmd_fd,
-					to_mdev(ibdev)->page_size);
+					to_mdev(&v_device->device)->page_size);
 		if (context->bf_page == MAP_FAILED) {
 			fprintf(stderr, PFX "Warning: BlueFlame available, "
 				"but failed to mmap() BlueFlame page.\n");
@@ -176,35 +181,29 @@ static struct ibv_context *mlx4_alloc_context(struct ibv_device *ibdev, int cmd_
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 
-	context->ibv_ctx.ops = mlx4_ctx_ops;
-
-	return &context->ibv_ctx;
+	ibv_ctx->ops = mlx4_ctx_ops;
+	/* New verbs should be added as below
+	  * verbs_ctx->drv_new_func1 = mlx4_new_func1;
+	  */
+	return 0;
 
-err_free:
-	free(context);
-	return NULL;
 }
 
-static void mlx4_free_context(struct ibv_context *ibctx)
+static void mlx4_uninit_context(struct verbs_device *v_device,
+					struct ibv_context *ibv_ctx)
 {
-	struct mlx4_context *context = to_mctx(ibctx);
+	struct mlx4_context *context = to_mctx(ibv_ctx);
 
-	munmap(context->uar, to_mdev(ibctx->device)->page_size);
+	munmap(context->uar, to_mdev(&v_device->device)->page_size);
 	if (context->bf_page)
-		munmap(context->bf_page, to_mdev(ibctx->device)->page_size);
-	free(context);
+		munmap(context->bf_page, to_mdev(&v_device->device)->page_size);
 }
 
-static struct ibv_device_ops mlx4_dev_ops = {
-	.alloc_context = mlx4_alloc_context,
-	.free_context  = mlx4_free_context
-};
-
-static struct ibv_device *mlx4_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path,
+					     int abi_version)
 {
 	char			value[8];
-	struct mlx4_device    *dev;
+	struct mlx4_device	*dev;
 	unsigned		vendor, device;
 	int			i;
 
@@ -236,23 +235,30 @@ found:
 		return NULL;
 	}
 
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
 			uverbs_sys_path);
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = mlx4_dev_ops;
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
index 13c13d8..5028fea 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -131,7 +131,7 @@ enum {
 };
 
 struct mlx4_device {
-	struct ibv_device		ibv_dev;
+	struct verbs_device		verbs_dev;
 	int				page_size;
 };
 
@@ -258,7 +258,11 @@ static inline unsigned long align(unsigned long val, unsigned long align)
 
 static inline struct mlx4_device *to_mdev(struct ibv_device *ibdev)
 {
-	return to_mxxx(dev, device);
+	/* ibv_device is first field of verbs_device
+	 * see try_driver in libibverbs
+	 */
+	return ((struct mlx4_device *)
+		((void *) ibdev - offsetof(struct mlx4_device, verbs_dev)));
 }
 
 static inline struct mlx4_context *to_mctx(struct ibv_context *ibctx)
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
