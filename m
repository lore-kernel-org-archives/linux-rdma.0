From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 4/5] Added QP and XSRQ create/destroy flow with user index
Date: Sun,  6 Sep 2015 12:30:11 +0300
Message-ID: <1441531812-27716-5-git-send-email-hagaya@mellanox.com>
References: <1441531812-27716-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441531812-27716-1-git-send-email-hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When wokring with CQE version 1, the library allocates a user-index for
each new QP/XSRQ, and this user-index is passed to the kernel.

Also in the destruction of a QP/XSRQ, the library needs to free the
user-index, so it can be reused.

In this stage, the library still doesn't work with CQE version 1,
therefore we prepared the user-index in the driver data,  but don't pass
it to the kernel.


Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c       |  47 +++++++++++++++++++--
 src/mlx5-abi.h |   5 +++
 src/mlx5.c     |  10 +++++
 src/mlx5.h     |   4 +-
 src/verbs.c    | 127 ++++++++++++++++++++++++++++++++++++++++++---------------
 5 files changed, 155 insertions(+), 38 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index a1fdac3..32f0dd4 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -721,6 +721,47 @@ static int is_equal_rsn(struct mlx5_cqe64 *cqe64, uint32_t rsn)
 	return rsn == (ntohl(cqe64->sop_drop_qpn) & 0xffffff);
 }
 
+static int is_equal_uidx(struct mlx5_cqe64 *cqe64, uint32_t uidx)
+{
+	return uidx == (ntohl(cqe64->srqn_uidx) & 0xffffff);
+}
+
+static inline int is_responder(uint8_t opcode)
+{
+	switch (opcode) {
+	case MLX5_CQE_RESP_WR_IMM:
+	case MLX5_CQE_RESP_SEND:
+	case MLX5_CQE_RESP_SEND_IMM:
+	case MLX5_CQE_RESP_SEND_INV:
+	case MLX5_CQE_RESP_ERR:
+		return 1;
+	}
+
+	return 0;
+}
+
+static inline int free_res_cqe(struct mlx5_cqe64 *cqe64, uint32_t rsn,
+			       struct mlx5_srq *srq, int cqe_version)
+{
+	if (cqe_version) {
+		if (is_equal_uidx(cqe64, rsn)) {
+			if (srq && is_responder(cqe64->op_own >> 4))
+				mlx5_free_srq_wqe(srq,
+						  ntohs(cqe64->wqe_counter));
+			return 1;
+		}
+	} else {
+		if (is_equal_rsn(cqe64, rsn)) {
+			if (srq && (ntohl(cqe64->srqn_uidx) & 0xffffff))
+				mlx5_free_srq_wqe(srq,
+						  ntohs(cqe64->wqe_counter));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 {
 	uint32_t prod_index;
@@ -728,6 +769,7 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 	struct mlx5_cqe64 *cqe64, *dest64;
 	void *cqe, *dest;
 	uint8_t owner_bit;
+	int cqe_version;
 
 	if (!cq)
 		return;
@@ -747,12 +789,11 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 	 * Now sweep backwards through the CQ, removing CQ entries
 	 * that match our QP by copying older entries on top of them.
 	 */
+	cqe_version = (to_mctx(cq->ibv_cq.context))->cqe_version;
 	while ((int) --prod_index - (int) cq->cons_index >= 0) {
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
 		cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
-		if (is_equal_rsn(cqe64, rsn)) {
-			if (srq && (ntohl(cqe64->srqn_uidx) & 0xffffff))
-				mlx5_free_srq_wqe(srq, ntohs(cqe64->wqe_counter));
+		if (free_res_cqe(cqe64, rsn, srq, cqe_version)) {
 			++nfreed;
 		} else if (nfreed) {
 			dest = get_cqe(cq, (prod_index + nfreed) & cq->ibv_cq.cqe);
diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 28490a5..001a4be 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -109,6 +109,9 @@ struct mlx5_create_srq_ex {
 	__u64				buf_addr;
 	__u64				db_addr;
 	__u32				flags;
+	__u32				reserved;
+	__u32                           uidx;
+	__u32                           reserved1;
 };
 
 struct mlx5_create_qp {
@@ -119,6 +122,8 @@ struct mlx5_create_qp {
 	__u32				rq_wqe_count;
 	__u32				rq_wqe_shift;
 	__u32				flags;
+	__u32                           uidx;
+	__u32                           reserved;
 };
 
 struct mlx5_create_qp_resp {
diff --git a/src/mlx5.c b/src/mlx5.c
index 6ce8bd8..e64ba8d 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -600,11 +600,21 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	context->max_recv_wr	= resp.max_recv_wr;
 	context->max_srq_recv_wr = resp.max_srq_recv_wr;
 
+	if (context->cqe_version) {
+		if (context->cqe_version == 1)
+			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
+		else
+			 context->cqe_version = 0;
+	}
+
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	pthread_mutex_init(&context->srq_table_mutex, NULL);
 	for (i = 0; i < MLX5_QP_TABLE_SIZE; ++i)
 		context->qp_table[i].refcnt = 0;
 
+	for (i = 0; i < MLX5_QP_TABLE_SIZE; ++i)
+		context->uidx_table[i].refcnt = 0;
+
 	context->db_list = NULL;
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
diff --git a/src/mlx5.h b/src/mlx5.h
index ce2e581..3f1a05a 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -242,8 +242,8 @@ enum mlx5_rsc_type {
 };
 
 struct mlx5_resource {
-	enum mlx5_rsc_type      type;
-	uint32_t                rsn;
+	enum mlx5_rsc_type  type;
+	uint32_t            rsn;
 };
 
 struct mlx5_device {
diff --git a/src/verbs.c b/src/verbs.c
index 8ddf4e6..c2f5493 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -505,6 +505,8 @@ struct ibv_srq *mlx5_create_srq(struct ibv_pd *pd,
 	pthread_mutex_unlock(&ctx->srq_table_mutex);
 
 	srq->srqn = resp.srqn;
+	srq->rsc.rsn = resp.srqn;
+	srq->rsc.type = MLX5_RSC_TYPE_SRQ;
 
 	return ibsrq;
 
@@ -545,16 +547,22 @@ int mlx5_query_srq(struct ibv_srq *srq,
 int mlx5_destroy_srq(struct ibv_srq *srq)
 {
 	int ret;
+	struct mlx5_srq *msrq = to_msrq(srq);
+	struct mlx5_context *ctx = to_mctx(srq->context);
 
 	ret = ibv_cmd_destroy_srq(srq);
 	if (ret)
 		return ret;
 
-	mlx5_clear_srq(to_mctx(srq->context), to_msrq(srq)->srqn);
-	mlx5_free_db(to_mctx(srq->context), to_msrq(srq)->db);
-	mlx5_free_buf(&to_msrq(srq)->buf);
-	free(to_msrq(srq)->wrid);
-	free(to_msrq(srq));
+	if (ctx->cqe_version && msrq->rsc.type == MLX5_RSC_TYPE_XSRQ)
+		mlx5_clear_uidx(ctx, msrq->rsc.rsn);
+	else
+		mlx5_clear_srq(ctx, msrq->srqn);
+
+	mlx5_free_db(ctx, msrq->db);
+	mlx5_free_buf(&msrq->buf);
+	free(msrq->wrid);
+	free(msrq);
 
 	return 0;
 }
@@ -873,6 +881,11 @@ static void mlx5_free_qp_buf(struct mlx5_qp *qp)
 		free(qp->sq.wrid);
 }
 
+static inline int is_xrc_tgt(int type)
+{
+	return type == IBV_QPT_XRC_RECV;
+}
+
 struct ibv_qp *create_qp(struct ibv_context *context,
 			 struct ibv_qp_init_attr_ex *attr)
 {
@@ -937,24 +950,35 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	cmd.rq_wqe_count = qp->rq.wqe_cnt;
 	cmd.rq_wqe_shift = qp->rq.wqe_shift;
 
-	pthread_mutex_lock(&ctx->qp_table_mutex);
+	if (!ctx->cqe_version) {
+		pthread_mutex_lock(&ctx->qp_table_mutex);
+	} else if (!is_xrc_tgt(attr->qp_type)) {
+		cmd.uidx = mlx5_store_uidx(ctx, qp);
+		if (cmd.uidx < 0) {
+			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
+			goto err_rq_db;
+		}
+	}
 
 	ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
-				   attr, &cmd.ibv_cmd, sizeof(cmd),
+				   attr, &cmd.ibv_cmd,
+				   offsetof(struct mlx5_create_qp, uidx),
 				   &resp.ibv_resp, sizeof(resp));
 	if (ret) {
 		mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
-		goto err_rq_db;
+		goto err_free_uidx;
 	}
 
-	if (qp->sq.wqe_cnt || qp->rq.wqe_cnt) {
-		ret = mlx5_store_qp(ctx, ibqp->qp_num, qp);
-		if (ret) {
-			mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
-			goto err_destroy;
+	if (!ctx->cqe_version) {
+		if (qp->sq.wqe_cnt || qp->rq.wqe_cnt) {
+			ret = mlx5_store_qp(ctx, ibqp->qp_num, qp);
+			if (ret) {
+				mlx5_dbg(fp, MLX5_DBG_QP, "ret %d\n", ret);
+				goto err_destroy;
+			}
 		}
+		pthread_mutex_unlock(&ctx->qp_table_mutex);
 	}
-	pthread_mutex_unlock(&ctx->qp_table_mutex);
 
 	map_uuar(context, qp, resp.uuar_index);
 
@@ -968,13 +992,21 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	attr->cap.max_recv_wr = qp->rq.max_post;
 	attr->cap.max_recv_sge = qp->rq.max_gs;
 
+	qp->rsc.type = MLX5_RSC_TYPE_QP;
+	qp->rsc.rsn = (ctx->cqe_version && !is_xrc_tgt(attr->qp_type)) ?
+		      cmd.uidx : ibqp->qp_num;
+
 	return ibqp;
 
 err_destroy:
 	ibv_cmd_destroy_qp(ibqp);
 
+err_free_uidx:
+	if (!ctx->cqe_version)
+		pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
+	else if (!is_xrc_tgt(attr->qp_type))
+		mlx5_clear_uidx(ctx, cmd.uidx);
 err_rq_db:
-	pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
 	mlx5_free_db(to_mctx(context), qp->db);
 
 err_free_qp_buf:
@@ -1045,27 +1077,37 @@ static void mlx5_unlock_cqs(struct ibv_qp *qp)
 int mlx5_destroy_qp(struct ibv_qp *ibqp)
 {
 	struct mlx5_qp *qp = to_mqp(ibqp);
+	struct mlx5_context *ctx = to_mctx(ibqp->context);
 	int ret;
 
-	pthread_mutex_lock(&to_mctx(ibqp->context)->qp_table_mutex);
+	if (!ctx->cqe_version)
+		pthread_mutex_lock(&to_mctx(ibqp->context)->qp_table_mutex);
+
 	ret = ibv_cmd_destroy_qp(ibqp);
 	if (ret) {
-		pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
+		if (!ctx->cqe_version)
+			pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
+
 		return ret;
 	}
 
 	mlx5_lock_cqs(ibqp);
 
-	__mlx5_cq_clean(to_mcq(ibqp->recv_cq), ibqp->qp_num,
+	__mlx5_cq_clean(to_mcq(ibqp->recv_cq), qp->rsc.rsn,
 			ibqp->srq ? to_msrq(ibqp->srq) : NULL);
 	if (ibqp->send_cq != ibqp->recv_cq)
-		__mlx5_cq_clean(to_mcq(ibqp->send_cq), ibqp->qp_num, NULL);
+		__mlx5_cq_clean(to_mcq(ibqp->send_cq), qp->rsc.rsn, NULL);
 
-	if (qp->sq.wqe_cnt || qp->rq.wqe_cnt)
-		mlx5_clear_qp(to_mctx(ibqp->context), ibqp->qp_num);
+	if (!ctx->cqe_version) {
+		if (qp->sq.wqe_cnt || qp->rq.wqe_cnt)
+			mlx5_clear_qp(to_mctx(ibqp->context), ibqp->qp_num);
+	}
 
 	mlx5_unlock_cqs(ibqp);
-	pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
+	if (!ctx->cqe_version)
+		pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
+	else if (!is_xrc_tgt(ibqp->qp_type))
+		mlx5_clear_uidx(ctx, qp->rsc.rsn);
 
 	mlx5_free_db(to_mctx(ibqp->context), qp->db);
 	mlx5_free_qp_buf(qp);
@@ -1107,11 +1149,11 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	    (attr_mask & IBV_QP_STATE) &&
 	    attr->qp_state == IBV_QPS_RESET) {
 		if (qp->recv_cq) {
-			mlx5_cq_clean(to_mcq(qp->recv_cq), qp->qp_num,
+			mlx5_cq_clean(to_mcq(qp->recv_cq), to_mqp(qp)->rsc.rsn,
 				      qp->srq ? to_msrq(qp->srq) : NULL);
 		}
 		if (qp->send_cq != qp->recv_cq && qp->send_cq)
-			mlx5_cq_clean(to_mcq(qp->send_cq), qp->qp_num, NULL);
+			mlx5_cq_clean(to_mcq(qp->send_cq), to_mqp(qp)->rsc.rsn, NULL);
 
 		mlx5_init_qp_indices(to_mqp(qp));
 		db = to_mqp(qp)->db;
@@ -1233,6 +1275,7 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	struct mlx5_context *ctx;
 	int max_sge;
 	struct ibv_srq *ibsrq;
+	int uidx;
 
 	msrq = calloc(1, sizeof(*msrq));
 	if (!msrq)
@@ -1296,28 +1339,46 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 		cmd.flags = MLX5_SRQ_FLAG_SIGNATURE;
 
 	attr->attr.max_sge = msrq->max_gs;
-	pthread_mutex_lock(&ctx->srq_table_mutex);
+
+	if (ctx->cqe_version) {
+		uidx = mlx5_store_uidx(ctx, msrq);
+		if (uidx < 0) {
+			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
+			goto err_free_db;
+		}
+		cmd.uidx = uidx;
+	} else {
+		pthread_mutex_lock(&ctx->srq_table_mutex);
+	}
+
 	err = ibv_cmd_create_srq_ex(context, &msrq->vsrq, sizeof(msrq->vsrq),
-				    attr, &cmd.ibv_cmd, sizeof(cmd),
+				    attr, &cmd.ibv_cmd, offsetof(struct mlx5_create_srq_ex, uidx),
 				    &resp.ibv_resp, sizeof(resp));
 	if (err)
-		goto err_free_db;
+		goto err_free_uidx;
 
-	err = mlx5_store_srq(to_mctx(context), resp.srqn, msrq);
-	if (err)
-		goto err_destroy;
+	if (!ctx->cqe_version) {
+		err = mlx5_store_srq(to_mctx(context), resp.srqn, msrq);
+		if (err)
+			goto err_destroy;
 
-	pthread_mutex_unlock(&ctx->srq_table_mutex);
+		pthread_mutex_unlock(&ctx->srq_table_mutex);
+	}
 
 	msrq->srqn = resp.srqn;
+	msrq->rsc.type = MLX5_RSC_TYPE_XSRQ;
+	msrq->rsc.rsn = ctx->cqe_version ? cmd.uidx : resp.srqn;
 
 	return ibsrq;
 
 err_destroy:
 	ibv_cmd_destroy_srq(ibsrq);
-
+err_free_uidx:
+	if (ctx->cqe_version)
+		mlx5_clear_uidx(ctx, cmd.uidx);
+	else
+		pthread_mutex_unlock(&ctx->srq_table_mutex);
 err_free_db:
-	pthread_mutex_unlock(&ctx->srq_table_mutex);
 	mlx5_free_db(ctx, msrq->db);
 
 err_free:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
