From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 V1 4/6] Add ibv_query_values support
Date: Thu,  3 Dec 2015 18:02:49 +0200
Message-ID: <1449158571-26228-5-git-send-email-matanb@mellanox.com>
References: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449158571-26228-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to query the current HCA's core clock, libmlx5 should
support ibv_query_values verb. Querying the hardware's cycles
register is done by mmaping this register to user-space.
Therefore, when libmlx5 initializes we mmap the cycles register.
This assumes the machine's architecture places the PCI and memory in
the same address space.
The page offset is passed through init_context vendor's data.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h | 10 +++++++++-
 src/mlx5.c     | 37 +++++++++++++++++++++++++++++++++++++
 src/mlx5.h     | 10 +++++++++-
 src/verbs.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 769ea81..43d4906 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -55,7 +55,11 @@ struct mlx5_alloc_ucontext {
 	__u32				total_num_uuars;
 	__u32				num_low_latency_uuars;
 	__u32				flags;
-	__u32				reserved;
+	__u32				comp_mask;
+};
+
+enum mlx5_ib_alloc_ucontext_resp_mask {
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 };
 
 struct mlx5_alloc_ucontext_resp {
@@ -72,6 +76,10 @@ struct mlx5_alloc_ucontext_resp {
 	__u16				num_ports;
 	__u8				cqe_version;
 	__u8				reserved;
+	__u32				comp_mask;
+	__u32				response_length;
+	__u32				reserved2;
+	__u64				hca_core_clock_offset;
 };
 
 struct mlx5_alloc_pd_resp {
diff --git a/src/mlx5.c b/src/mlx5.c
index 229d99d..c455c08 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -524,6 +524,30 @@ static int single_threaded_app(void)
 	return 0;
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
@@ -647,6 +671,15 @@ static int mlx5_init_context(struct verbs_device *vdev,
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
@@ -664,6 +697,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
+	verbs_set_ctx_op(v_ctx, query_values, mlx5_query_values);
 	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
 	if (context->cqe_version && context->cqe_version == 1)
 		verbs_set_ctx_op(v_ctx, poll_cq_ex, mlx5_poll_cq_v1_ex);
@@ -697,6 +731,9 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 		if (context->uar[i])
 			munmap(context->uar[i], page_size);
 	}
+	if (context->hca_core_clock)
+		munmap(context->hca_core_clock - context->core_clock.offset,
+		       page_size);
 	close_debug_file(context);
 }
 
diff --git a/src/mlx5.h b/src/mlx5.h
index 0c0b027..b5bcfaa 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -117,7 +117,8 @@ enum {
 
 enum {
 	MLX5_MMAP_GET_REGULAR_PAGES_CMD    = 0,
-	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1
+	MLX5_MMAP_GET_CONTIGUOUS_PAGES_CMD = 1,
+	MLX5_MMAP_GET_CORE_CLOCK_CMD    = 5
 };
 
 #define MLX5_CQ_PREFIX "MLX_CQ"
@@ -307,6 +308,11 @@ struct mlx5_context {
 	struct mlx5_spinlock            hugetlb_lock;
 	struct list_head                hugetlb_list;
 	uint8_t				cqe_version;
+	struct {
+		uint64_t                offset;
+		uint64_t                mask;
+	} core_clock;
+	void			       *hca_core_clock;
 };
 
 struct mlx5_bitmap {
@@ -585,6 +591,8 @@ int mlx5_query_device_ex(struct ibv_context *context,
 			 const struct ibv_query_device_ex_input *input,
 			 struct ibv_device_attr_ex *attr,
 			 size_t attr_size);
+int mlx5_query_values(struct ibv_context *context,
+		      struct ibv_values_ex *values);
 struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 				 struct ibv_qp_init_attr_ex *attr);
 int mlx5_query_port(struct ibv_context *context, uint8_t port,
diff --git a/src/verbs.c b/src/verbs.c
index 1dbee60..5d732a2 100644
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
+int mlx5_query_values(struct ibv_context *context,
+		      struct ibv_values_ex *values)
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
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
