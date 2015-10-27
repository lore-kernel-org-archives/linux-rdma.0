From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 5/7] Add support for ibv_query_values_ex
Date: Tue, 27 Oct 2015 18:52:33 +0200
Message-ID: <1445964755-13371-6-git-send-email-matanb@mellanox.com>
References: <1445964755-13371-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964755-13371-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding mlx4_query_values as implementation for
ibv_query_values_ex. mlx4_query_values follows the
standard extension verb mechanism.
This function supports reading the hwclock via mmaping
the required space from kernel.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c  | 36 ++++++++++++++++++++++++++++++++++++
 src/mlx4.h  |  3 +++
 src/verbs.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff --git a/src/mlx4.c b/src/mlx4.c
index cc1211f..6d66cf0 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -116,6 +116,28 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
+static int mlx4_map_internal_clock(struct mlx4_device *dev,
+				   struct ibv_context *ibv_ctx)
+{
+	struct mlx4_context *context = to_mctx(ibv_ctx);
+	void *hca_clock_page;
+
+	hca_clock_page = mmap(NULL, dev->page_size, PROT_READ, MAP_SHARED,
+			      ibv_ctx->cmd_fd, dev->page_size * 3);
+
+	if (hca_clock_page == MAP_FAILED) {
+		fprintf(stderr, PFX
+			"Warning: Timestamp available,\n"
+			"but failed to mmap() hca core clock page, errno=%d.\n",
+			errno);
+		return -1;
+	}
+
+	context->hca_core_clock = hca_clock_page +
+		context->core_clock_offset % dev->page_size;
+	return 0;
+}
+
 static int mlx4_init_context(struct verbs_device *v_device,
 				struct ibv_context *ibv_ctx, int cmd_fd)
 {
@@ -127,6 +149,10 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	__u16				bf_reg_size;
 	struct mlx4_device              *dev = to_mdev(&v_device->device);
 	struct verbs_context *verbs_ctx = verbs_get_ctx(ibv_ctx);
+	struct ibv_query_device_ex_input input_query_device = {.comp_mask = 0};
+	struct ibv_device_attr_ex	dev_attrs;
+	uint32_t			dev_attrs_comp_mask;
+	int				err;
 
 	/* memory footprint of mlx4_context and verbs_context share
 	* struct ibv_context.
@@ -194,6 +220,12 @@ static int mlx4_init_context(struct verbs_device *v_device,
 		context->bf_buf_size = 0;
 	}
 
+	context->hca_core_clock = NULL;
+	err = _mlx4_query_device_ex(ibv_ctx, &input_query_device, &dev_attrs,
+				    sizeof(dev_attrs), &dev_attrs_comp_mask);
+	if (!err && dev_attrs_comp_mask & QUERY_DEVICE_RESP_MASK_TIMESTAMP)
+		mlx4_map_internal_clock(dev, ibv_ctx);
+
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
 	ibv_ctx->ops = mlx4_ctx_ops;
 
@@ -210,6 +242,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
 	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
 	verbs_set_ctx_op(verbs_ctx, poll_cq_ex, mlx4_poll_cq_ex);
+	verbs_set_ctx_op(verbs_ctx, query_values, mlx4_query_values);
 
 	return 0;
 
@@ -223,6 +256,9 @@ static void mlx4_uninit_context(struct verbs_device *v_device,
 	munmap(context->uar, to_mdev(&v_device->device)->page_size);
 	if (context->bf_page)
 		munmap(context->bf_page, to_mdev(&v_device->device)->page_size);
+	if (context->hca_core_clock)
+		munmap(context->hca_core_clock - context->core_clock_offset,
+		       to_mdev(&v_device->device)->page_size);
 
 }
 
diff --git a/src/mlx4.h b/src/mlx4.h
index 2465298..8e1935d 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -199,6 +199,7 @@ struct mlx4_context {
 		enum ibv_port_cap_flags caps;
 	} port_query_cache[MLX4_PORTS_NUM];
 	uint64_t			core_clock_offset;
+	void			       *hca_core_clock;
 };
 
 struct mlx4_buf {
@@ -403,6 +404,8 @@ int _mlx4_query_device_ex(struct ibv_context *context,
 int mlx4_query_device_ex(struct ibv_context *context,
 			 const struct ibv_query_device_ex_input *input,
 			 struct ibv_device_attr_ex *attr, size_t attr_size);
+int mlx4_query_values(struct ibv_context *context,
+		      struct ibv_values_ex *values);
 int mlx4_query_port(struct ibv_context *context, uint8_t port,
 		     struct ibv_port_attr *attr);
 
diff --git a/src/verbs.c b/src/verbs.c
index a8d6bd7..843ca1e 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -114,6 +114,51 @@ int mlx4_query_device_ex(struct ibv_context *context,
 	return _mlx4_query_device_ex(context, input, attr, attr_size, NULL);
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
+	for (i = 0; i < 10; i++) {
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
+int mlx4_query_values(struct ibv_context *context,
+		      struct ibv_values_ex *values)
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
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
