From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 5/7] Add support for creating an extended CQ
Date: Wed,  1 Jun 2016 16:48:00 +0300
Message-ID: <1464788882-1876-6-git-send-email-yishaih@mellanox.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464788882-1876-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds the support for creating an extended CQ.
This means we support:
- The new polling mechanism.
- A CQ which is single threaded and by thus doesn't waste CPU cycles on locking.
- Getting completion timestamp from the CQ.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mlx5.c  |   1 +
 src/mlx5.h  |   5 +++
 src/verbs.c |  91 +++++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 190 insertions(+), 16 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 4fa0cf1..de91f07 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -1226,6 +1226,115 @@ static inline uint64_t mlx5_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
 	return ntohll(cq->cqe64->timestamp);
 }
 
+void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_attr)
+{
+	struct mlx5_context *mctx = to_mctx(ibv_cq_ex_to_cq(&cq->ibv_cq)->context);
+
+	if (mctx->cqe_version) {
+		if (cq->flags & MLX5_CQ_FLAGS_SINGLE_THREADED) {
+			if (cq->stall_enable) {
+				if (cq->stall_adaptive_enable) {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_adaptive_stall_enable_v1;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_adaptive_stall_enable;
+				} else {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_nonadaptive_stall_enable_v1;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_nonadaptive_stall_enable;
+				}
+			} else {
+				cq->ibv_cq.start_poll = mlx5_start_poll_v1;
+				cq->ibv_cq.end_poll = mlx5_end_poll_nop;
+			}
+		} else {
+			if (cq->stall_enable) {
+				if (cq->stall_adaptive_enable) {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_adaptive_stall_enable_v1_lock;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_adaptive_stall_enable_unlock;
+				} else {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_nonadaptive_stall_enable_v1_lock;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_nonadaptive_stall_enable_unlock;
+				}
+			} else {
+				cq->ibv_cq.start_poll = mlx5_start_poll_v1_lock;
+				cq->ibv_cq.end_poll = mlx5_end_poll_unlock;
+			}
+		}
+
+		if (!cq->stall_adaptive_enable)
+			cq->ibv_cq.next_poll = mlx5_next_poll_v1;
+		else
+			cq->ibv_cq.next_poll = mlx5_next_poll_adaptive_stall_enable_v1;
+	} else {
+		if (cq->flags & MLX5_CQ_FLAGS_SINGLE_THREADED) {
+			if (cq->stall_enable) {
+				if (cq->stall_adaptive_enable) {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_adaptive_stall_enable_v0;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_adaptive_stall_enable;
+				} else {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_nonadaptive_stall_enable_v0;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_nonadaptive_stall_enable;
+				}
+			} else {
+				cq->ibv_cq.start_poll = mlx5_start_poll_v0;
+				cq->ibv_cq.end_poll = mlx5_end_poll_nop;
+			}
+		} else {
+			if (cq->stall_enable) {
+				if (cq->stall_adaptive_enable) {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_adaptive_stall_enable_v0_lock;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_adaptive_stall_enable_unlock;
+				} else {
+					cq->ibv_cq.start_poll =
+						mlx5_start_poll_nonadaptive_stall_enable_v0_lock;
+					cq->ibv_cq.end_poll =
+						mlx5_end_poll_nonadaptive_stall_enable_unlock;
+				}
+			} else {
+				cq->ibv_cq.start_poll = mlx5_start_poll_v0_lock;
+				cq->ibv_cq.end_poll = mlx5_end_poll_unlock;
+			}
+		}
+
+		if (!cq->stall_adaptive_enable)
+			cq->ibv_cq.next_poll = mlx5_next_poll_v0;
+		else
+			cq->ibv_cq.next_poll = mlx5_next_poll_adaptive_stall_enable_v0;
+	}
+
+	cq->ibv_cq.read_opcode = mlx5_cq_read_wc_opcode;
+	cq->ibv_cq.read_vendor_err = mlx5_cq_read_wc_vendor_err;
+	cq->ibv_cq.read_wc_flags = mlx5_cq_read_wc_flags;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+		cq->ibv_cq.read_byte_len = mlx5_cq_read_wc_byte_len;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_IMM)
+		cq->ibv_cq.read_imm_data = mlx5_cq_read_wc_imm_data;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_QP_NUM)
+		cq->ibv_cq.read_qp_num = mlx5_cq_read_wc_qp_num;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_SRC_QP)
+		cq->ibv_cq.read_src_qp = mlx5_cq_read_wc_src_qp;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_SLID)
+		cq->ibv_cq.read_slid = mlx5_cq_read_wc_slid;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_SL)
+		cq->ibv_cq.read_sl = mlx5_cq_read_wc_sl;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS)
+		cq->ibv_cq.read_dlid_path_bits = mlx5_cq_read_wc_dlid_path_bits;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)
+		cq->ibv_cq.read_completion_ts = mlx5_cq_read_wc_completion_ts;
+}
+
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx5_cq *cq = to_mcq(ibvcq);
diff --git a/src/mlx5.c b/src/mlx5.c
index 7bd01bd..d7a6a8f 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -702,6 +702,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
 	verbs_set_ctx_op(v_ctx, ibv_create_flow, ibv_cmd_create_flow);
 	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
+	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device(ctx, &device_attr)) {
diff --git a/src/mlx5.h b/src/mlx5.h
index 15510cf..506ec0a 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -368,6 +368,8 @@ enum {
 	MLX5_CQ_FLAGS_RX_CSUM_VALID = 1 << 0,
 	MLX5_CQ_FLAGS_EMPTY_DURING_POLL = 1 << 1,
 	MLX5_CQ_FLAGS_FOUND_CQES = 1 << 2,
+	MLX5_CQ_FLAGS_EXTENDED = 1 << 3,
+	MLX5_CQ_FLAGS_SINGLE_THREADED = 1 << 4,
 };
 
 struct mlx5_cq {
@@ -635,6 +637,9 @@ int mlx5_dereg_mr(struct ibv_mr *mr);
 struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
+struct ibv_cq_ex *mlx5_create_cq_ex(struct ibv_context *context,
+				    struct ibv_cq_init_attr_ex *cq_attr);
+void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_attr);
 int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 		      struct mlx5_buf *buf, int nent, int cqe_sz);
 int mlx5_free_cq_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
diff --git a/src/verbs.c b/src/verbs.c
index e78d2a5..6f2ef00 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -254,9 +254,22 @@ static int qp_sig_enabled(void)
 	return 0;
 }
 
-struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
-			      struct ibv_comp_channel *channel,
-			      int comp_vector)
+enum {
+	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
+				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+};
+
+enum {
+	CREATE_CQ_SUPPORTED_COMP_MASK = IBV_CQ_INIT_ATTR_MASK_FLAGS
+};
+
+enum {
+	CREATE_CQ_SUPPORTED_FLAGS = IBV_CREATE_CQ_ATTR_SINGLE_THREADED
+};
+
+static struct ibv_cq_ex *create_cq(struct ibv_context *context,
+				   const struct ibv_cq_init_attr_ex *cq_attr,
+				   int cq_alloc_flags)
 {
 	struct mlx5_create_cq		cmd;
 	struct mlx5_create_cq_resp	resp;
@@ -268,12 +281,33 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	FILE *fp = to_mctx(context)->dbg_fp;
 #endif
 
-	if (!cqe) {
-		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
+	if (!cq_attr->cqe) {
+		mlx5_dbg(fp, MLX5_DBG_CQ, "CQE invalid\n");
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (cq_attr->comp_mask & ~CREATE_CQ_SUPPORTED_COMP_MASK) {
+		mlx5_dbg(fp, MLX5_DBG_CQ,
+			 "Unsupported comp_mask for create_cq\n");
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS &&
+	    cq_attr->flags & ~CREATE_CQ_SUPPORTED_FLAGS) {
+		mlx5_dbg(fp, MLX5_DBG_CQ,
+			 "Unsupported creation flags requested for create_cq\n");
 		errno = EINVAL;
 		return NULL;
 	}
 
+	if (cq_attr->wc_flags & ~CREATE_CQ_SUPPORTED_WC_FLAGS) {
+		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
+		errno = ENOTSUP;
+		return NULL;
+	}
+
 	cq =  calloc(1, sizeof *cq);
 	if (!cq) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
@@ -286,15 +320,8 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	if (mlx5_spinlock_init(&cq->lock))
 		goto err;
 
-	/* The additional entry is required for resize CQ */
-	if (cqe <= 0) {
-		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
-		errno = EINVAL;
-		goto err_spl;
-	}
-
-	ncqe = align_queue_size(cqe + 1);
-	if ((ncqe > (1 << 24)) || (ncqe < (cqe + 1))) {
+	ncqe = align_queue_size(cq_attr->cqe + 1);
+	if ((ncqe > (1 << 24)) || (ncqe < (cq_attr->cqe + 1))) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "ncqe %d\n", ncqe);
 		errno = EINVAL;
 		goto err_spl;
@@ -322,12 +349,17 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cq->dbrec[MLX5_CQ_ARM_DB]	= 0;
 	cq->arm_sn			= 0;
 	cq->cqe_sz			= cqe_sz;
+	cq->flags			= cq_alloc_flags;
 
+	if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS &&
+	    cq_attr->flags & IBV_CREATE_CQ_ATTR_SINGLE_THREADED)
+		cq->flags |= MLX5_CQ_FLAGS_SINGLE_THREADED;
 	cmd.buf_addr = (uintptr_t) cq->buf_a.buf;
 	cmd.db_addr  = (uintptr_t) cq->dbrec;
 	cmd.cqe_size = cqe_sz;
 
-	ret = ibv_cmd_create_cq(context, ncqe - 1, channel, comp_vector,
+	ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
+				cq_attr->comp_vector,
 				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd,
 				sizeof(cmd), &resp.ibv_resp, sizeof(resp));
 	if (ret) {
@@ -342,7 +374,10 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cq->stall_adaptive_enable = to_mctx(context)->stall_adaptive_enable;
 	cq->stall_cycles = to_mctx(context)->stall_cycles;
 
-	return ibv_cq_ex_to_cq(&cq->ibv_cq);
+	if (cq_alloc_flags & MLX5_CQ_FLAGS_EXTENDED)
+		mlx5_cq_fill_pfns(cq, cq_attr);
+
+	return &cq->ibv_cq;
 
 err_db:
 	mlx5_free_db(to_mctx(context), cq->dbrec);
@@ -359,6 +394,30 @@ err:
 	return NULL;
 }
 
+struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
+			      struct ibv_comp_channel *channel,
+			      int comp_vector)
+{
+	struct ibv_cq_ex *cq;
+	struct ibv_cq_init_attr_ex cq_attr = {.cqe = cqe, .channel = channel,
+						.comp_vector = comp_vector,
+						.wc_flags = IBV_WC_STANDARD_FLAGS};
+
+	if (cqe <= 0) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	cq = create_cq(context, &cq_attr, 0);
+	return cq ? ibv_cq_ex_to_cq(cq) : NULL;
+}
+
+struct ibv_cq_ex *mlx5_create_cq_ex(struct ibv_context *context,
+				    struct ibv_cq_init_attr_ex *cq_attr)
+{
+	return create_cq(context, cq_attr, MLX5_CQ_FLAGS_EXTENDED);
+}
+
 int mlx5_resize_cq(struct ibv_cq *ibcq, int cqe)
 {
 	struct mlx5_cq *cq = to_mcq(ibcq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
