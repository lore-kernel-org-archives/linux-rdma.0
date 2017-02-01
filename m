From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 08/10] mlx4: Add support for creating an extended CQ
Date: Wed,  1 Feb 2017 09:39:34 +0200
Message-ID: <1485934776-715-9-git-send-email-yishaih@mellanox.com>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds the support for creating an extended CQ.
This means we support:
- The new polling mechanism.
- A CQ which is single threaded and by thus doesn't waste CPU cycles on locking.
- Getting completion timestamp from the CQ.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c       |  33 ++++++++++
 providers/mlx4/mlx4-abi.h |  12 ++++
 providers/mlx4/mlx4.c     |   1 +
 providers/mlx4/mlx4.h     |   5 ++
 providers/mlx4/verbs.c    | 157 ++++++++++++++++++++++++++++++++++++++++------
 5 files changed, 190 insertions(+), 18 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 045a1c2..769c702 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -644,6 +644,39 @@ static uint64_t mlx4_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
 			       (cq->cqe->ts_7_0);
 }
 
+void mlx4_cq_fill_pfns(struct mlx4_cq *cq, const struct ibv_cq_init_attr_ex *cq_attr)
+{
+
+	if (cq->flags & MLX4_CQ_FLAGS_SINGLE_THREADED) {
+		cq->ibv_cq.start_poll = mlx4_start_poll;
+		cq->ibv_cq.end_poll = mlx4_end_poll;
+	} else {
+		cq->ibv_cq.start_poll = mlx4_start_poll_lock;
+		cq->ibv_cq.end_poll = mlx4_end_poll_lock;
+	}
+	cq->ibv_cq.next_poll = mlx4_next_poll;
+
+	cq->ibv_cq.read_opcode = mlx4_cq_read_wc_opcode;
+	cq->ibv_cq.read_vendor_err = mlx4_cq_read_wc_vendor_err;
+	cq->ibv_cq.read_wc_flags = mlx4_cq_read_wc_flags;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+		cq->ibv_cq.read_byte_len = mlx4_cq_read_wc_byte_len;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_IMM)
+		cq->ibv_cq.read_imm_data = mlx4_cq_read_wc_imm_data;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_QP_NUM)
+		cq->ibv_cq.read_qp_num = mlx4_cq_read_wc_qp_num;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_SRC_QP)
+		cq->ibv_cq.read_src_qp = mlx4_cq_read_wc_src_qp;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_SLID)
+		cq->ibv_cq.read_slid = mlx4_cq_read_wc_slid;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_SL)
+		cq->ibv_cq.read_sl = mlx4_cq_read_wc_sl;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS)
+		cq->ibv_cq.read_dlid_path_bits = mlx4_cq_read_wc_dlid_path_bits;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)
+		cq->ibv_cq.read_completion_ts = mlx4_cq_read_wc_completion_ts;
+}
+
 int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx4_cq *cq = to_mcq(ibvcq);
diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index ac21fa8..3b8bac5 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -78,6 +78,18 @@ struct mlx4_create_cq_resp {
 	__u32				reserved;
 };
 
+struct mlx4_create_cq_ex {
+	struct ibv_create_cq_ex		ibv_cmd;
+	__u64				buf_addr;
+	__u64				db_addr;
+};
+
+struct mlx4_create_cq_resp_ex {
+	struct ibv_create_cq_resp_ex	ibv_resp;
+	__u32				cqn;
+	__u32				reserved;
+};
+
 struct mlx4_resize_cq {
 	struct ibv_resize_cq		ibv_cmd;
 	__u64				buf_addr;
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index b59c202..3f29d1a 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -216,6 +216,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
 	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, ibv_cmd_create_flow);
 	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
+	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
 
 	return 0;
 
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 25b009b..8f5fd14 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -168,6 +168,8 @@ struct mlx4_pd {
 
 enum {
 	MLX4_CQ_FLAGS_RX_CSUM_VALID = 1 << 0,
+	MLX4_CQ_FLAGS_EXTENDED = 1 << 1,
+	MLX4_CQ_FLAGS_SINGLE_THREADED = 1 << 2,
 };
 
 struct mlx4_cq {
@@ -375,6 +377,9 @@ int mlx4_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
 struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
+struct ibv_cq_ex *mlx4_create_cq_ex(struct ibv_context *context,
+				    struct ibv_cq_init_attr_ex *cq_attr);
+void mlx4_cq_fill_pfns(struct mlx4_cq *cq, const struct ibv_cq_init_attr_ex *cq_attr);
 int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent,
 		      int entry_size);
 int mlx4_resize_cq(struct ibv_cq *cq, int cqe);
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 83c971d..4b00550 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -304,19 +304,103 @@ int align_queue_size(int req)
 	return nent;
 }
 
-struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
-			       struct ibv_comp_channel *channel,
-			       int comp_vector)
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
+
+static int mlx4_cmd_create_cq(struct ibv_context *context,
+			      struct ibv_cq_init_attr_ex *cq_attr,
+			      struct mlx4_cq *cq)
+{
+	struct mlx4_create_cq      cmd = {};
+	struct mlx4_create_cq_resp resp = {};
+	int ret;
+
+	cmd.buf_addr = (uintptr_t) cq->buf.buf;
+	cmd.db_addr  = (uintptr_t) cq->set_ci_db;
+
+	ret = ibv_cmd_create_cq(context, cq_attr->cqe, cq_attr->channel,
+				cq_attr->comp_vector,
+				ibv_cq_ex_to_cq(&cq->ibv_cq),
+				&cmd.ibv_cmd, sizeof(cmd),
+				&resp.ibv_resp, sizeof(resp));
+	if (!ret)
+		cq->cqn = resp.cqn;
+
+	return ret;
+
+}
+
+static int mlx4_cmd_create_cq_ex(struct ibv_context *context,
+				 struct ibv_cq_init_attr_ex *cq_attr,
+				 struct mlx4_cq *cq)
+{
+	struct mlx4_create_cq_ex      cmd = {};
+	struct mlx4_create_cq_resp_ex resp = {};
+	int ret;
+
+	cmd.buf_addr = (uintptr_t) cq->buf.buf;
+	cmd.db_addr  = (uintptr_t) cq->set_ci_db;
+
+	ret = ibv_cmd_create_cq_ex(context, cq_attr,
+				   &cq->ibv_cq, &cmd.ibv_cmd,
+				   sizeof(cmd.ibv_cmd),
+				   sizeof(cmd),
+				   &resp.ibv_resp,
+				   sizeof(resp.ibv_resp),
+				   sizeof(resp));
+	if (!ret)
+		cq->cqn = resp.cqn;
+
+	return ret;
+}
+
+static struct ibv_cq_ex *create_cq(struct ibv_context *context,
+				   struct ibv_cq_init_attr_ex *cq_attr,
+				   int cq_alloc_flags)
 {
-	struct mlx4_create_cq      cmd;
-	struct mlx4_create_cq_resp resp;
-	struct mlx4_cq		  *cq;
-	int			   ret;
-	struct mlx4_context       *mctx = to_mctx(context);
+	struct mlx4_cq      *cq;
+	int                  ret;
+	struct mlx4_context *mctx = to_mctx(context);
 
 	/* Sanity check CQ size before proceeding */
-	if (cqe > 0x3fffff)
+	if (cq_attr->cqe > 0x3fffff) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	if (cq_attr->comp_mask & ~CREATE_CQ_SUPPORTED_COMP_MASK) {
+		errno = ENOTSUP;
+		return NULL;
+	}
+
+	if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS &&
+	    cq_attr->flags & ~CREATE_CQ_SUPPORTED_FLAGS) {
+		errno = ENOTSUP;
+		return NULL;
+	}
+
+	if (cq_attr->wc_flags & ~CREATE_CQ_SUPPORTED_WC_FLAGS)
+		return NULL;
+
+	/* mlx4 devices don't support slid and sl in cqe when completion
+	 * timestamp is enabled in the CQ
+	*/
+	if ((cq_attr->wc_flags & (IBV_WC_EX_WITH_SLID | IBV_WC_EX_WITH_SL)) &&
+	    (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)) {
+		errno = ENOTSUP;
 		return NULL;
+	}
 
 	cq = malloc(sizeof *cq);
 	if (!cq)
@@ -327,9 +411,9 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 	if (pthread_spin_init(&cq->lock, PTHREAD_PROCESS_PRIVATE))
 		goto err;
 
-	cqe = align_queue_size(cqe + 1);
+	cq_attr->cqe = align_queue_size(cq_attr->cqe + 1);
 
-	if (mlx4_alloc_cq_buf(to_mdev(context->device), &cq->buf, cqe, mctx->cqe_size))
+	if (mlx4_alloc_cq_buf(to_mdev(context->device), &cq->buf, cq_attr->cqe, mctx->cqe_size))
 		goto err;
 
 	cq->cqe_size = mctx->cqe_size;
@@ -341,19 +425,26 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 	*cq->arm_db    = 0;
 	cq->arm_sn     = 1;
 	*cq->set_ci_db = 0;
+	cq->flags = cq_alloc_flags;
 
-	cmd.buf_addr = (uintptr_t) cq->buf.buf;
-	cmd.db_addr  = (uintptr_t) cq->set_ci_db;
+	if (cq_attr->comp_mask & IBV_CQ_INIT_ATTR_MASK_FLAGS &&
+	    cq_attr->flags & IBV_CREATE_CQ_ATTR_SINGLE_THREADED)
+		cq->flags |= MLX4_CQ_FLAGS_SINGLE_THREADED;
+
+	--cq_attr->cqe;
+	if (cq_alloc_flags & MLX4_CQ_FLAGS_EXTENDED)
+		ret = mlx4_cmd_create_cq_ex(context, cq_attr, cq);
+	else
+		ret = mlx4_cmd_create_cq(context, cq_attr, cq);
 
-	ret = ibv_cmd_create_cq(context, cqe - 1, channel, comp_vector,
-				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd, sizeof(cmd),
-				&resp.ibv_resp, sizeof(resp));
 	if (ret)
 		goto err_db;
 
-	cq->cqn = resp.cqn;
 
-	return ibv_cq_ex_to_cq(&cq->ibv_cq);
+	if (cq_alloc_flags & MLX4_CQ_FLAGS_EXTENDED)
+		mlx4_cq_fill_pfns(cq, cq_attr);
+
+	return &cq->ibv_cq;
 
 err_db:
 	mlx4_free_db(to_mctx(context), MLX4_DB_TYPE_CQ, cq->set_ci_db);
@@ -367,6 +458,36 @@ err:
 	return NULL;
 }
 
+struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
+			      struct ibv_comp_channel *channel,
+			      int comp_vector)
+{
+	struct ibv_cq_ex *cq;
+	struct ibv_cq_init_attr_ex cq_attr = {.cqe = cqe, .channel = channel,
+					      .comp_vector = comp_vector,
+					      .wc_flags = IBV_WC_STANDARD_FLAGS};
+
+	cq = create_cq(context, &cq_attr, 0);
+	return cq ? ibv_cq_ex_to_cq(cq) : NULL;
+}
+
+struct ibv_cq_ex *mlx4_create_cq_ex(struct ibv_context *context,
+				    struct ibv_cq_init_attr_ex *cq_attr)
+{
+	/*
+	 * Make local copy since some attributes might be adjusted
+	 * for internal use.
+	 */
+	struct ibv_cq_init_attr_ex cq_attr_c = {.cqe = cq_attr->cqe,
+						.channel = cq_attr->channel,
+						.comp_vector = cq_attr->comp_vector,
+						.wc_flags = cq_attr->wc_flags,
+						.comp_mask = cq_attr->comp_mask,
+						.flags = cq_attr->flags};
+
+	return create_cq(context, &cq_attr_c, MLX4_CQ_FLAGS_EXTENDED);
+}
+
 int mlx4_resize_cq(struct ibv_cq *ibcq, int cqe)
 {
 	struct mlx4_cq *cq = to_mcq(ibcq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
