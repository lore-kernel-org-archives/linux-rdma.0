From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 libmlx4 2/7] Add support for ibv_create_cq_ex
Date: Tue, 27 Oct 2015 19:08:52 +0200
Message-ID: <1445965737-14187-3-git-send-email-matanb@mellanox.com>
References: <1445965737-14187-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445965737-14187-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an extension verb mlx4_create_cq_ex that follows the
standard extension verb mechanism.
This function is similar to mlx4_create_cq but supports the
extension verbs functions and stores the creation flags
for later use (for example, timestamp flag is used in poll_cq).
The function fails if the user passes unsupported WC attributes.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4-abi.h |  12 ++++++
 src/mlx4.c     |   1 +
 src/mlx4.h     |   3 ++
 src/verbs.c    | 117 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 117 insertions(+), 16 deletions(-)

diff --git a/src/mlx4-abi.h b/src/mlx4-abi.h
index b348ce3..9b765e4 100644
--- a/src/mlx4-abi.h
+++ b/src/mlx4-abi.h
@@ -72,12 +72,24 @@ struct mlx4_create_cq {
 	__u64				db_addr;
 };
 
+struct mlx4_create_cq_ex {
+	struct ibv_create_cq_ex		ibv_cmd;
+	__u64				buf_addr;
+	__u64				db_addr;
+};
+
 struct mlx4_create_cq_resp {
 	struct ibv_create_cq_resp	ibv_resp;
 	__u32				cqn;
 	__u32				reserved;
 };
 
+struct mlx4_create_cq_resp_ex {
+	struct ibv_create_cq_resp_ex	ibv_resp;
+	__u32				cqn;
+	__u32				reserved;
+};
+
 struct mlx4_resize_cq {
 	struct ibv_resize_cq		ibv_cmd;
 	__u64				buf_addr;
diff --git a/src/mlx4.c b/src/mlx4.c
index d41dff0..9cfd013 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -208,6 +208,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, ibv_cmd_create_flow);
 	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
+	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
 
 	return 0;
 
diff --git a/src/mlx4.h b/src/mlx4.h
index 0f643bc..91eb79c 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -222,6 +222,7 @@ struct mlx4_cq {
 	uint32_t		       *arm_db;
 	int				arm_sn;
 	int				cqe_size;
+	int				creation_flags;
 };
 
 struct mlx4_srq {
@@ -402,6 +403,8 @@ int mlx4_dereg_mr(struct ibv_mr *mr);
 struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
+struct ibv_cq *mlx4_create_cq_ex(struct ibv_context *context,
+				 struct ibv_create_cq_attr_ex *cq_attr);
 int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent,
 		      int entry_size);
 int mlx4_resize_cq(struct ibv_cq *cq, int cqe);
diff --git a/src/verbs.c b/src/verbs.c
index e93114b..3290b86 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -272,19 +272,69 @@ int align_queue_size(int req)
 	return nent;
 }
 
-struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
-			       struct ibv_comp_channel *channel,
-			       int comp_vector)
+enum cmd_type {
+	MLX4_CMD_TYPE_BASIC,
+	MLX4_CMD_TYPE_EXTENDED
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
+enum {
+	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS
+};
+
+static struct ibv_cq *create_cq(struct ibv_context *context,
+				struct ibv_create_cq_attr_ex *cq_attr,
+				enum cmd_type cmd_type)
 {
-	struct mlx4_create_cq      cmd;
-	struct mlx4_create_cq_resp resp;
-	struct mlx4_cq		  *cq;
-	int			   ret;
-	struct mlx4_context       *mctx = to_mctx(context);
+	struct mlx4_create_cq		cmd;
+	struct mlx4_create_cq_ex	cmd_e;
+	struct mlx4_create_cq_resp	resp;
+	struct mlx4_create_cq_resp_ex	resp_e;
+	struct mlx4_cq			*cq;
+	int				ret;
+	struct mlx4_context		*mctx = to_mctx(context);
+	struct ibv_create_cq_attr_ex	cq_attr_e;
+	int cqe;
 
 	/* Sanity check CQ size before proceeding */
-	if (cqe > 0x3fffff)
+	if (cq_attr->cqe > 0x3fffff)
+		return NULL;
+
+	if (cq_attr->comp_mask & ~CREATE_CQ_SUPPORTED_COMP_MASK) {
+		errno = EINVAL;
 		return NULL;
+	}
+
+	if (cq_attr->comp_mask & IBV_CREATE_CQ_ATTR_FLAGS &&
+	    cq_attr->flags & ~CREATE_CQ_SUPPORTED_FLAGS) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (cq_attr->wc_flags & ~CREATE_CQ_SUPPORTED_WC_FLAGS) {
+		errno = ENOTSUP;
+		return NULL;
+	}
+
+	if (!(cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP) !=
+	    !(cq_attr->comp_mask & IBV_CREATE_CQ_ATTR_FLAGS &&
+	      cq_attr->flags & IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP)) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP &&
+	    cq_attr->wc_flags & (IBV_WC_EX_WITH_SL | IBV_WC_EX_WITH_SLID)) {
+		errno = EOPNOTSUPP;
+		return NULL;
+	}
 
 	cq = malloc(sizeof *cq);
 	if (!cq)
@@ -295,9 +345,11 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 	if (pthread_spin_init(&cq->lock, PTHREAD_PROCESS_PRIVATE))
 		goto err;
 
-	cqe = align_queue_size(cqe + 1);
+	cq_attr_e = *cq_attr;
+	cqe = align_queue_size(cq_attr->cqe + 1);
 
-	if (mlx4_alloc_cq_buf(to_mdev(context->device), &cq->buf, cqe, mctx->cqe_size))
+	if (mlx4_alloc_cq_buf(to_mdev(context->device), &cq->buf, cqe,
+			      mctx->cqe_size))
 		goto err;
 
 	cq->cqe_size = mctx->cqe_size;
@@ -310,15 +362,31 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 	cq->arm_sn     = 1;
 	*cq->set_ci_db = 0;
 
-	cmd.buf_addr = (uintptr_t) cq->buf.buf;
-	cmd.db_addr  = (uintptr_t) cq->set_ci_db;
+	if (cmd_type == MLX4_CMD_TYPE_BASIC) {
+		cmd.buf_addr = (uintptr_t)cq->buf.buf;
+		cmd.db_addr  = (uintptr_t)cq->set_ci_db;
+
+		ret = ibv_cmd_create_cq(context, cqe - 1,
+					cq_attr_e.channel, cq_attr_e.comp_vector,
+					&cq->ibv_cq, &cmd.ibv_cmd, sizeof(cmd),
+					&resp.ibv_resp, sizeof(resp));
+	} else {
+		cmd_e.buf_addr = (uintptr_t)cq->buf.buf;
+		cmd_e.db_addr  = (uintptr_t)cq->set_ci_db;
+
+		cq_attr_e.cqe = cqe - 1;
+		ret = ibv_cmd_create_cq_ex(context, &cq_attr_e, &cq->ibv_cq,
+					   &cmd_e.ibv_cmd,
+					   sizeof(cmd_e.ibv_cmd), sizeof(cmd_e),
+					   &resp_e.ibv_resp,
+					   sizeof(resp_e.ibv_resp),
+					   sizeof(resp_e));
+	}
 
-	ret = ibv_cmd_create_cq(context, cqe - 1, channel, comp_vector,
-				&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
-				&resp.ibv_resp, sizeof resp);
 	if (ret)
 		goto err_db;
 
+	cq->creation_flags = cmd_e.ibv_cmd.flags;
 	cq->cqn = resp.cqn;
 
 	return &cq->ibv_cq;
@@ -335,6 +403,23 @@ err:
 	return NULL;
 }
 
+struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
+			      struct ibv_comp_channel *channel,
+			      int comp_vector)
+{
+	struct ibv_create_cq_attr_ex attr = {.cqe = cqe, .channel = channel,
+					     .comp_vector = comp_vector,
+					     .wc_flags = IBV_WC_STANDARD_FLAGS};
+
+	return create_cq(context, &attr, MLX4_CMD_TYPE_BASIC);
+}
+
+struct ibv_cq *mlx4_create_cq_ex(struct ibv_context *context,
+				 struct ibv_create_cq_attr_ex *cq_attr)
+{
+	return create_cq(context, cq_attr, MLX4_CMD_TYPE_EXTENDED);
+}
+
 int mlx4_resize_cq(struct ibv_cq *ibcq, int cqe)
 {
 	struct mlx4_cq *cq = to_mcq(ibcq);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
