From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libmlx5 6/7] Add ibv_query_rt_values support
Date: Tue,  7 Jun 2016 15:11:38 +0300
Message-ID: <1465301499-21234-7-git-send-email-yishaih@mellanox.com>
References: <1465301499-21234-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465301499-21234-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to query the current HCA's core clock, libmlx5 should
support ibv_query_rt_values verb. Querying the hardware's cycles
register is done by mmaping this register to user-space.
Therefore, when libmlx5 initializes we mmap the cycles register.
This assumes the machine's architecture places the PCI and memory in
the same address space.
The page offset is passed through init_context vendor's data.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h |  5 +++++
 src/mlx5.c     | 37 +++++++++++++++++++++++++++++++++++++
 src/mlx5.h     | 10 +++++++++-
 src/verbs.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index e2815c0..b57fd55 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -62,6 +62,10 @@ struct mlx5_alloc_ucontext {
 	__u32				reserved2;
 };
 
+enum mlx5_ib_alloc_ucontext_resp_mask {
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
+};
+
 struct mlx5_alloc_ucontext_resp {
 	struct ibv_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
@@ -80,6 +84,7 @@ struct mlx5_alloc_ucontext_resp {
 	__u8				cqe_version;
 	__u8				reserved2;
 	__u16				reserved3;
+	__u64				hca_core_clock_offset;
 };
 
 struct mlx5_alloc_pd_resp {
diff --git a/src/mlx5.c b/src/mlx5.c
index d7a6a8f..2d3f9d9 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -555,6 +555,30 @@ static int mlx5_cmd_get_context(struct mlx5_context *context,
 				   &resp->ibv_resp, resp_len);
 }
 
+static int mlx5_map_internal_clock(struct mlx5_device *mdev,
+				   struct ibv_context *ibv_ctx)
+{
+	struct mlx5_context *context = to_mctx(ibv_ctx);
+	void *hca_clock_page;
+	off_t offset = 0;
+
+	set_command(MLX5_MMAP_GET_CORE_CLOCK_CMD, &offset);
+	hca_clock_page = mmap(NULL, mdev->page_size,
+			      PROT_READ, MAP_SHARED, ibv_ctx->cmd_fd,
+			      mdev->page_size * offset);
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
 static int mlx5_init_context(struct verbs_device *vdev,
 			     struct ibv_context *ctx, int cmd_fd)
 {
@@ -683,6 +707,15 @@ static int mlx5_init_context(struct verbs_device *vdev,
 		context->bfs[j].uuarn = j;
 	}
 
+	context->hca_core_clock = NULL;
+	if (resp.response_length + sizeof(resp.ibv_resp) >=
+	    offsetof(struct mlx5_alloc_ucontext_resp, hca_core_clock_offset) +
+	    sizeof(resp.hca_core_clock_offset) &&
+	    resp.comp_mask & MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET) {
+		context->core_clock.offset = resp.hca_core_clock_offset;
+		mlx5_map_internal_clock(mdev, ctx);
+	}
+
 	mlx5_spinlock_init(&context->lock32);
 
 	context->prefer_bf = get_always_bf();
@@ -700,6 +733,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
+	verbs_set_ctx_op(v_ctx, query_rt_values, mlx5_query_rt_values);
 	verbs_set_ctx_op(v_ctx, ibv_create_flow, ibv_cmd_create_flow);
 	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
@@ -742,6 +776,9 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 		if (context->uar[i])
 			munmap(context->uar[i], page_size);
 	}
+	if (context->hca_core_clock)
+		munmap(context->hca_core_clock - context->core_clock.offset,
+		       page_size);
 	close_debug_file(context);
 }
 
diff --git a/src/mlx5.h b/src/mlx5.h
index 506ec0a..78357d3 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -117,7 +117,8 @@ enum {
 
 enum {
 	MLX5_MMAP_GET_REGULAR_PAGES_CMD    = 0,
-	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1
+	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1,
+	MLX5_MMAP_GET_CORE_CLOCK_CMD    = 5
 };
 
 enum {
@@ -328,6 +329,11 @@ struct mlx5_context {
 	uint8_t				cached_link_layer[MLX5_MAX_PORTS_NUM];
 	int				cached_device_cap_flags;
 	enum ibv_atomic_cap		atomic_cap;
+	struct {
+		uint64_t                offset;
+		uint64_t                mask;
+	} core_clock;
+	void			       *hca_core_clock;
 };
 
 struct mlx5_bitmap {
@@ -620,6 +626,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
 			 const struct ibv_query_device_ex_input *input,
 			 struct ibv_device_attr_ex *attr,
 			 size_t attr_size);
+int mlx5_query_rt_values(struct ibv_context *context,
+			 struct ibv_values_ex *values);
 struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr);
 int mlx5_query_port(struct ibv_context *context, uint8_t port,
diff --git a/src/verbs.c b/src/verbs.c
index 6f2ef00..e8873da 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -79,6 +79,52 @@ int mlx5_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 	return 0;
 }
 
+#define READL(ptr) (*((uint32_t *)(ptr)))
+static int mlx5_read_clock(struct ibv_context *context, uint64_t *cycles)
+{
+	unsigned int clockhi, clocklo, clockhi1;
+	int i;
+	struct mlx5_context *ctx = to_mctx(context);
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
+int mlx5_query_rt_values(struct ibv_context *context,
+			 struct ibv_values_ex *values)
+{
+	uint32_t comp_mask = 0;
+	int err = 0;
+
+	if (values->comp_mask & IBV_VALUES_MASK_RAW_CLOCK) {
+		uint64_t cycles;
+
+		err = mlx5_read_clock(context, &cycles);
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
 int mlx5_query_port(struct ibv_context *context, uint8_t port,
 		     struct ibv_port_attr *attr)
 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
