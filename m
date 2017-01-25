From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 8/8] mlx4: Add ibv_query_rt_values
Date: Wed, 25 Jan 2017 16:49:51 +0200
Message-ID: <1485355791-27646-9-git-send-email-yishaih@mellanox.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485355791-27646-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to query the current HCA's core clock, libmlx4 should
support ibv_query_rt_values verb. Querying the hardware's cycles
register is done by mmaping this register to user-space.
Therefore, when libmlx4 initializes we mmap the cycles register.
This assumes the machine's architecture places the PCI and memory in
the same address space.
The page offset is retrieved by calling ibv_query_device_ex.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4.c  | 39 ++++++++++++++++++++++++++++++++++-----
 providers/mlx4/mlx4.h  |  8 +++++++-
 providers/mlx4/verbs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 755768e..8e1a0dd 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -118,6 +118,28 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
+static int mlx4_map_internal_clock(struct mlx4_device *mdev,
+				   struct ibv_context *ibv_ctx)
+{
+	struct mlx4_context *context = to_mctx(ibv_ctx);
+	void *hca_clock_page;
+
+	hca_clock_page = mmap(NULL, mdev->page_size,
+			      PROT_READ, MAP_SHARED, ibv_ctx->cmd_fd,
+			      mdev->page_size * 3);
+
+	if (hca_clock_page == MAP_FAILED) {
+		fprintf(stderr, PFX
+			"Warning: Timestamp available,\n"
+			"but failed to mmap() hca core clock page.\n");
+		return -1;
+	}
+
+	context->hca_core_clock = hca_clock_page +
+		(context->core_clock.offset & (mdev->page_size - 1));
+	return 0;
+}
+
 static int mlx4_init_context(struct verbs_device *v_device,
 				struct ibv_context *ibv_ctx, int cmd_fd)
 {
@@ -129,7 +151,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	__u16				bf_reg_size;
 	struct mlx4_device              *dev = to_mdev(&v_device->device);
 	struct verbs_context *verbs_ctx = verbs_get_ctx(ibv_ctx);
-	struct ibv_device_attr		dev_attrs;
+	struct ibv_device_attr_ex	dev_attrs;
 
 	/* memory footprint of mlx4_context and verbs_context share
 	* struct ibv_context.
@@ -200,10 +222,14 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 	ibv_ctx->ops = mlx4_ctx_ops;
 
+	context->hca_core_clock = NULL;
 	memset(&dev_attrs, 0, sizeof(dev_attrs));
-	if (!mlx4_query_device(ibv_ctx, &dev_attrs)) {
-		context->max_qp_wr = dev_attrs.max_qp_wr;
-		context->max_sge = dev_attrs.max_sge;
+	if (!mlx4_query_device_ex(ibv_ctx, NULL, &dev_attrs,
+				  sizeof(struct ibv_device_attr_ex))) {
+		context->max_qp_wr = dev_attrs.orig_attr.max_qp_wr;
+		context->max_sge = dev_attrs.orig_attr.max_sge;
+		if (context->core_clock.offset_valid)
+			mlx4_map_internal_clock(dev, ibv_ctx);
 	}
 
 	verbs_ctx->has_comp_mask = VERBS_CONTEXT_XRCD | VERBS_CONTEXT_SRQ |
@@ -218,6 +244,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
 	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
+	verbs_set_ctx_op(verbs_ctx, query_rt_values, mlx4_query_rt_values);
 
 	return 0;
 
@@ -231,7 +258,9 @@ static void mlx4_uninit_context(struct verbs_device *v_device,
 	munmap(context->uar, to_mdev(&v_device->device)->page_size);
 	if (context->bf_page)
 		munmap(context->bf_page, to_mdev(&v_device->device)->page_size);
-
+	if (context->hca_core_clock)
+		munmap(context->hca_core_clock - context->core_clock.offset,
+		       to_mdev(&v_device->device)->page_size);
 }
 
 static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 8c01ec1..2bcfc7f 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -175,6 +175,11 @@ struct mlx4_context {
 		uint8_t                 link_layer;
 		enum ibv_port_cap_flags caps;
 	} port_query_cache[MLX4_PORTS_NUM];
+	struct {
+		uint64_t                offset;
+		uint8_t                 offset_valid;
+	} core_clock;
+	void			       *hca_core_clock;
 };
 
 struct mlx4_buf {
@@ -381,7 +386,8 @@ int mlx4_query_device_ex(struct ibv_context *context,
 			 size_t attr_size);
 int mlx4_query_port(struct ibv_context *context, uint8_t port,
 		     struct ibv_port_attr *attr);
-
+int mlx4_query_rt_values(struct ibv_context *context,
+			 struct ibv_values_ex *values);
 struct ibv_pd *mlx4_alloc_pd(struct ibv_context *context);
 int mlx4_free_pd(struct ibv_pd *pd);
 struct ibv_xrcd *mlx4_open_xrcd(struct ibv_context *context,
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index c523c41..e2f798f 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -101,6 +101,52 @@ int mlx4_query_device_ex(struct ibv_context *context,
 	return 0;
 }
 
+#define READL(ptr) (*((uint32_t *)(ptr)))
+static int mlx4_read_clock(struct ibv_context *context, uint64_t *cycles)
+{
+	unsigned int clockhi, clocklo, clockhi1;
+	int i;
+	struct mlx4_context *ctx = to_mctx(context);
+
+	if (!ctx->hca_core_clock)
+		return -EOPNOTSUPP;
+
+	/* Handle wraparound */
+	for (i = 0; i < 2; i++) {
+		clockhi = ntohl(READL(ctx->hca_core_clock));
+		clocklo = ntohl(READL(ctx->hca_core_clock + 4));
+		clockhi1 = ntohl(READL(ctx->hca_core_clock));
+		if (clockhi == clockhi1)
+			break;
+	}
+
+	*cycles = (uint64_t)clockhi << 32 | (uint64_t)clocklo;
+
+	return 0;
+}
+
+int mlx4_query_rt_values(struct ibv_context *context,
+			 struct ibv_values_ex *values)
+{
+	uint32_t comp_mask = 0;
+	int err = 0;
+
+	if (values->comp_mask & IBV_VALUES_MASK_RAW_CLOCK) {
+		uint64_t cycles;
+
+		err = mlx4_read_clock(context, &cycles);
+		if (!err) {
+			values->raw_clock.tv_sec = 0;
+			values->raw_clock.tv_nsec = cycles;
+			comp_mask |= IBV_VALUES_MASK_RAW_CLOCK;
+		}
+	}
+
+	values->comp_mask = comp_mask;
+
+	return err;
+}
+
 int mlx4_query_port(struct ibv_context *context, uint8_t port,
 		     struct ibv_port_attr *attr)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
