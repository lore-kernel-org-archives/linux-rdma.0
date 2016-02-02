From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 v2 4/7] Add QP and XSRQ create/destroy flow with user index
Date: Tue,  2 Feb 2016 21:29:48 +0200
Message-ID: <1454441391-30494-5-git-send-email-majd@mellanox.com>
References: <1454441391-30494-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454441391-30494-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When working with CQE version 1, the library allocates a user-index
for each new QP/XSRQ, and this user-index is passed to the kernel.

Also in the destruction of a QP/XSRQ, the library needs to free the
user-index, so it can be reused.

As part of enforcing the user-space to use the new CQE version:
1. If both the device and the user-space support CQE version 1,
then the kernel expects a valid user-index when creating QPs and
XSRQs, otherwise the creation
fails.
2. If the user-space supports CQE version 1 (has the uidx field
in the commands), but the device doesn't, then the user-space
should pass 0xffffff to make sure that the user is aware of
working with CQE version 0.

In this stage, the library still doesn't work with CQE version 1,
and therefore it passes user-index that equals to 0xffffff.

Reviewed-by:: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c       |  47 ++++++++++++++++++--
 src/mlx5-abi.h |   5 +++
 src/mlx5.c     |  10 +++++
 src/mlx5.h     |   1 +
 src/verbs.c    | 137 +++++++++++++++++++++++++++++++++++++++++++--------------
 5 files changed, 163 insertions(+), 37 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index eadc2c7..79a200f 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -732,6 +732,47 @@ static int is_equal_rsn(struct mlx5_cqe64 *cqe64, uint32_t rsn)
 	return rsn == (ntohl(cqe64->sop_drop_qpn) & 0xffffff);
 }
 
+static inline int is_equal_uidx(struct mlx5_cqe64 *cqe64, uint32_t uidx)
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
@@ -739,6 +780,7 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 	struct mlx5_cqe64 *cqe64, *dest64;
 	void *cqe, *dest;
 	uint8_t owner_bit;
+	int cqe_version;
 
 	if (!cq)
 		return;
@@ -758,12 +800,11 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
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
index 31bbc8f..4b21a17 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -108,6 +108,9 @@ struct mlx5_create_srq_ex {
 	__u64				buf_addr;
 	__u64				db_addr;
 	__u32				flags;
+	__u32				reserved;
+	__u32                           uidx;
+	__u32                           reserved1;
 };
 
 struct mlx5_create_qp {
@@ -118,6 +121,8 @@ struct mlx5_create_qp {
 	__u32				rq_wqe_count;
 	__u32				rq_wqe_shift;
 	__u32				flags;
+	__u32                           uidx;
+	__u32                           reserved;
 };
 
 struct mlx5_create_qp_resp {
diff --git a/src/mlx5.c b/src/mlx5.c
index 877df12..b942815 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -608,12 +608,22 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	context->max_recv_wr	= resp.max_recv_wr;
 	context->max_srq_recv_wr = resp.max_srq_recv_wr;
 
+	if (context->cqe_version) {
+		if (context->cqe_version == 1)
+			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
+		else
+			 goto err_free_bf;
+	}
+
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	pthread_mutex_init(&context->srq_table_mutex, NULL);
 	pthread_mutex_init(&context->uidx_table_mutex, NULL);
 	for (i = 0; i < MLX5_QP_TABLE_SIZE; ++i)
 		context->qp_table[i].refcnt = 0;
 
+	for (i = 0; i < MLX5_QP_TABLE_SIZE; ++i)
+		context->uidx_table[i].refcnt = 0;
+
 	context->db_list = NULL;
 
 	pthread_mutex_init(&context->db_list_mutex, NULL);
diff --git a/src/mlx5.h b/src/mlx5.h
index 8190062..cda7c71 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -306,6 +306,7 @@ struct mlx5_context {
 	char				hostname[40];
 	struct mlx5_spinlock            hugetlb_lock;
 	struct list_head                hugetlb_list;
+	int				cqe_version;
 };
 
 struct mlx5_bitmap {
diff --git a/src/verbs.c b/src/verbs.c
index 68b31f7..64f7694 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -53,6 +53,11 @@
 
 int mlx5_single_threaded = 0;
 
+static inline int is_xrc_tgt(int type)
+{
+	return type == IBV_QPT_XRC_RECV;
+}
+
 int mlx5_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 {
 	struct ibv_query_device cmd;
@@ -505,6 +510,8 @@ struct ibv_srq *mlx5_create_srq(struct ibv_pd *pd,
 	pthread_mutex_unlock(&ctx->srq_table_mutex);
 
 	srq->srqn = resp.srqn;
+	srq->rsc.rsn = resp.srqn;
+	srq->rsc.type = MLX5_RSC_TYPE_SRQ;
 
 	return ibsrq;
 
@@ -545,16 +552,22 @@ int mlx5_query_srq(struct ibv_srq *srq,
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
@@ -882,6 +895,7 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	int				ret;
 	struct mlx5_context	       *ctx = to_mctx(context);
 	struct ibv_qp		       *ibqp;
+	uint32_t			usr_idx = 0;
 #ifdef MLX5_DEBUG
 	FILE *fp = ctx->dbg_fp;
 #endif
@@ -938,24 +952,38 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	cmd.rq_wqe_count = qp->rq.wqe_cnt;
 	cmd.rq_wqe_shift = qp->rq.wqe_shift;
 
-	pthread_mutex_lock(&ctx->qp_table_mutex);
+	if (!ctx->cqe_version) {
+		cmd.uidx = 0xffffff;
+		pthread_mutex_lock(&ctx->qp_table_mutex);
+	} else if (!is_xrc_tgt(attr->qp_type)) {
+		usr_idx = mlx5_store_uidx(ctx, qp);
+		if (usr_idx < 0) {
+			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
+			goto err_rq_db;
+		}
+
+		cmd.uidx = usr_idx;
+	}
 
 	ret = ibv_cmd_create_qp_ex(context, &qp->verbs_qp, sizeof(qp->verbs_qp),
 				   attr, &cmd.ibv_cmd, sizeof(cmd),
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
+
+		pthread_mutex_unlock(&ctx->qp_table_mutex);
 	}
-	pthread_mutex_unlock(&ctx->qp_table_mutex);
 
 	map_uuar(context, qp, resp.uuar_index);
 
@@ -969,13 +997,22 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	attr->cap.max_recv_wr = qp->rq.max_post;
 	attr->cap.max_recv_sge = qp->rq.max_gs;
 
+	qp->rsc.type = MLX5_RSC_TYPE_QP;
+	qp->rsc.rsn = (ctx->cqe_version && !is_xrc_tgt(attr->qp_type)) ?
+		      usr_idx : ibqp->qp_num;
+
 	return ibqp;
 
 err_destroy:
 	ibv_cmd_destroy_qp(ibqp);
 
+err_free_uidx:
+	if (!ctx->cqe_version)
+		pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
+	else if (!is_xrc_tgt(attr->qp_type))
+		mlx5_clear_uidx(ctx, usr_idx);
+
 err_rq_db:
-	pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
 	mlx5_free_db(to_mctx(context), qp->db);
 
 err_free_qp_buf:
@@ -1046,29 +1083,38 @@ static void mlx5_unlock_cqs(struct ibv_qp *qp)
 int mlx5_destroy_qp(struct ibv_qp *ibqp)
 {
 	struct mlx5_qp *qp = to_mqp(ibqp);
+	struct mlx5_context *ctx = to_mctx(ibqp->context);
 	int ret;
 
-	pthread_mutex_lock(&to_mctx(ibqp->context)->qp_table_mutex);
+	if (!ctx->cqe_version)
+		pthread_mutex_lock(&ctx->qp_table_mutex);
+
 	ret = ibv_cmd_destroy_qp(ibqp);
 	if (ret) {
-		pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
+		if (!ctx->cqe_version)
+			pthread_mutex_unlock(&ctx->qp_table_mutex);
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
+			mlx5_clear_qp(ctx, ibqp->qp_num);
+	}
 
 	mlx5_unlock_cqs(ibqp);
-	pthread_mutex_unlock(&to_mctx(ibqp->context)->qp_table_mutex);
+	if (!ctx->cqe_version)
+		pthread_mutex_unlock(&ctx->qp_table_mutex);
+	else if (!is_xrc_tgt(ibqp->qp_type))
+		mlx5_clear_uidx(ctx, qp->rsc.rsn);
 
-	mlx5_free_db(to_mctx(ibqp->context), qp->db);
+	mlx5_free_db(ctx, qp->db);
 	mlx5_free_qp_buf(qp);
 	free(qp);
 
@@ -1108,11 +1154,12 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	    (attr_mask & IBV_QP_STATE) &&
 	    attr->qp_state == IBV_QPS_RESET) {
 		if (qp->recv_cq) {
-			mlx5_cq_clean(to_mcq(qp->recv_cq), qp->qp_num,
+			mlx5_cq_clean(to_mcq(qp->recv_cq), to_mqp(qp)->rsc.rsn,
 				      qp->srq ? to_msrq(qp->srq) : NULL);
 		}
 		if (qp->send_cq != qp->recv_cq && qp->send_cq)
-			mlx5_cq_clean(to_mcq(qp->send_cq), qp->qp_num, NULL);
+			mlx5_cq_clean(to_mcq(qp->send_cq),
+				      to_mqp(qp)->rsc.rsn, NULL);
 
 		mlx5_init_qp_indices(to_mqp(qp));
 		db = to_mqp(qp)->db;
@@ -1231,9 +1278,13 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	struct mlx5_create_srq_ex cmd;
 	struct mlx5_create_srq_resp resp;
 	struct mlx5_srq *msrq;
-	struct mlx5_context *ctx;
+	struct mlx5_context *ctx = to_mctx(context);
 	int max_sge;
 	struct ibv_srq *ibsrq;
+	int uidx;
+#ifdef MLX5_DEBUG
+	FILE *fp = ctx->dbg_fp;
+#endif
 
 	msrq = calloc(1, sizeof(*msrq));
 	if (!msrq)
@@ -1244,8 +1295,6 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 	memset(&cmd, 0, sizeof(cmd));
 	memset(&resp, 0, sizeof(resp));
 
-	ctx = to_mctx(context);
-
 	if (mlx5_spinlock_init(&msrq->lock)) {
 		fprintf(stderr, "%s-%d:\n", __func__, __LINE__);
 		goto err;
@@ -1297,28 +1346,48 @@ mlx5_create_xrc_srq(struct ibv_context *context,
 		cmd.flags = MLX5_SRQ_FLAG_SIGNATURE;
 
 	attr->attr.max_sge = msrq->max_gs;
-	pthread_mutex_lock(&ctx->srq_table_mutex);
+	if (ctx->cqe_version) {
+		uidx = mlx5_store_uidx(ctx, msrq);
+		if (uidx < 0) {
+			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
+			goto err_free_db;
+		}
+		cmd.uidx = uidx;
+	} else {
+		cmd.uidx = 0xffffff;
+		pthread_mutex_lock(&ctx->srq_table_mutex);
+	}
+
 	err = ibv_cmd_create_srq_ex(context, &msrq->vsrq, sizeof(msrq->vsrq),
 				    attr, &cmd.ibv_cmd, sizeof(cmd),
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
 
+err_free_uidx:
+	if (ctx->cqe_version)
+		mlx5_clear_uidx(ctx, cmd.uidx);
+	else
+		pthread_mutex_unlock(&ctx->srq_table_mutex);
+
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
