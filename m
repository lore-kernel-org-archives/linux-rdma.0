From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 V1 3/6] Add ibv_create_cq_ex support
Date: Thu,  3 Dec 2015 18:02:48 +0200
Message-ID: <1449158571-26228-4-git-send-email-matanb@mellanox.com>
References: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449158571-26228-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to create a CQ which supports timestamp, the user needs
to specify the timestamp flag for ibv_create_cq_ex.
Adding support for ibv_create_cq_ex in the mlx5's vendor library.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c  |  1 +
 src/mlx5.h  |  2 ++
 src/verbs.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index eac332b..229d99d 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -664,6 +664,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
+	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
 	if (context->cqe_version && context->cqe_version == 1)
 		verbs_set_ctx_op(v_ctx, poll_cq_ex, mlx5_poll_cq_v1_ex);
 	else
diff --git a/src/mlx5.h b/src/mlx5.h
index 91aafbe..0c0b027 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -600,6 +600,8 @@ int mlx5_dereg_mr(struct ibv_mr *mr);
 struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
+struct ibv_cq *mlx5_create_cq_ex(struct ibv_context *context,
+				 struct ibv_create_cq_attr_ex *cq_attr);
 int mlx5_poll_cq_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
 		    struct ibv_poll_cq_ex_attr *attr);
 int mlx5_poll_cq_v1_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
diff --git a/src/verbs.c b/src/verbs.c
index 92f273d..1dbee60 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -240,9 +240,21 @@ static int qp_sig_enabled(void)
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
+	CREATE_CQ_SUPPORTED_COMP_MASK = IBV_CREATE_CQ_ATTR_FLAGS
+};
+
+enum {
+	CREATE_CQ_SUPPORTED_FLAGS = IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP
+};
+
+static struct ibv_cq *create_cq(struct ibv_context *context,
+				const struct ibv_create_cq_attr_ex *cq_attr)
 {
 	struct mlx5_create_cq		cmd;
 	struct mlx5_create_cq_resp	resp;
@@ -254,12 +266,33 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
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
+	if (cq_attr->comp_mask & IBV_CREATE_CQ_ATTR_FLAGS &&
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
@@ -273,14 +306,14 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 		goto err;
 
 	/* The additional entry is required for resize CQ */
-	if (cqe <= 0) {
+	if (cq_attr->cqe <= 0) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "\n");
 		errno = EINVAL;
 		goto err_spl;
 	}
 
-	ncqe = align_queue_size(cqe + 1);
-	if ((ncqe > (1 << 24)) || (ncqe < (cqe + 1))) {
+	ncqe = align_queue_size(cq_attr->cqe + 1);
+	if ((ncqe > (1 << 24)) || (ncqe < (cq_attr->cqe + 1))) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "ncqe %d\n", ncqe);
 		errno = EINVAL;
 		goto err_spl;
@@ -313,7 +346,8 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cmd.db_addr  = (uintptr_t) cq->dbrec;
 	cmd.cqe_size = cqe_sz;
 
-	ret = ibv_cmd_create_cq(context, ncqe - 1, channel, comp_vector,
+	ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
+				cq_attr->comp_vector,
 				&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
 				&resp.ibv_resp, sizeof resp);
 	if (ret) {
@@ -328,6 +362,9 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cq->stall_adaptive_enable = to_mctx(context)->stall_adaptive_enable;
 	cq->stall_cycles = to_mctx(context)->stall_cycles;
 
+	cq->wc_flags = cq_attr->wc_flags;
+	cq->poll_one = mlx5_poll_one_ex;
+
 	return &cq->ibv_cq;
 
 err_db:
@@ -345,6 +382,23 @@ err:
 	return NULL;
 }
 
+struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
+			      struct ibv_comp_channel *channel,
+			      int comp_vector)
+{
+	struct ibv_create_cq_attr_ex cq_attr = {.cqe = cqe, .channel = channel,
+						.comp_vector = comp_vector,
+						.wc_flags = IBV_WC_STANDARD_FLAGS};
+
+	return create_cq(context, &cq_attr);
+}
+
+struct ibv_cq *mlx5_create_cq_ex(struct ibv_context *context,
+				 struct ibv_create_cq_attr_ex *cq_attr)
+{
+	return create_cq(context, cq_attr);
+}
+
 int mlx5_resize_cq(struct ibv_cq *ibcq, int cqe)
 {
 	struct mlx5_cq *cq = to_mcq(ibcq);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
