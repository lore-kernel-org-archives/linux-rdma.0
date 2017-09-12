From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/6] mlx4: Add support for WQ control path related verbs
Date: Tue, 12 Sep 2017 15:53:03 +0300
Message-ID: <1505220788-23849-2-git-send-email-yishaih@mellanox.com>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The base IB object to enable RSS functionality is a WQ (i.e. ibv_wq).
This patch implements the related WQ verbs as of create, modify and
destroy.
In downstream patches the WQ will be used as part of an indirection
table to enable RSS QP creation.

Since ConnectX-3 hardware requires consecutive WQNs list as receive
descriptor queues for the RSS QP, a range size for a consecutive
WQNs set is delivered in the driver data of the create WQ related
verb. This range size value will be set by a direct verb which will
be introduced in the downstream patches.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/mlx4-abi.h |  19 ++++++
 providers/mlx4/mlx4.c     |   3 +
 providers/mlx4/mlx4.h     |  17 ++++-
 providers/mlx4/qp.c       |   4 +-
 providers/mlx4/verbs.c    | 171 +++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 209 insertions(+), 5 deletions(-)

diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index ded1a4c..1cf6d5b 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -159,4 +159,23 @@ struct mlx4_create_qp_resp_ex {
 	struct ibv_create_qp_resp_ex	ibv_resp;
 };
 
+struct mlx4_drv_create_wq {
+	__u64		buf_addr;
+	__u64		db_addr;
+	__u8		log_range_size;
+	__u8		reserved[3];
+	__u32		comp_mask;
+};
+
+struct mlx4_create_wq {
+	struct ibv_create_wq		ibv_cmd;
+	struct mlx4_drv_create_wq	drv;
+};
+
+struct mlx4_modify_wq {
+	struct ibv_modify_wq	ibv_cmd;
+	__u32			comp_mask;
+	__u32			reserved;
+};
+
 #endif /* MLX4_ABI_H */
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index bd4cd5e..600daea 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -256,6 +256,9 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
 	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
 	verbs_set_ctx_op(verbs_ctx, query_rt_values, mlx4_query_rt_values);
+	verbs_set_ctx_op(verbs_ctx, create_wq, mlx4_create_wq);
+	verbs_set_ctx_op(verbs_ctx, modify_wq, mlx4_modify_wq);
+	verbs_set_ctx_op(verbs_ctx, destroy_wq, mlx4_destroy_wq);
 
 	return 0;
 
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 7d463f3..204542b 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -134,6 +134,7 @@ struct mlx4_context {
 	} core_clock;
 	void			       *hca_core_clock;
 	uint32_t			max_inl_recv_sz;
+	uint8_t				log_wqs_range_sz;
 };
 
 struct mlx4_buf {
@@ -198,7 +199,10 @@ struct mlx4_wq {
 };
 
 struct mlx4_qp {
-	struct verbs_qp			verbs_qp;
+	union {
+		struct verbs_qp		verbs_qp;
+		struct ibv_wq		wq;
+	};
 	struct mlx4_buf			buf;
 	int				max_inline_data;
 	int				buf_size;
@@ -274,6 +278,11 @@ static inline struct mlx4_qp *to_mqp(struct ibv_qp *ibqp)
 			    struct mlx4_qp, verbs_qp);
 }
 
+static inline struct mlx4_qp *wq_to_mqp(struct ibv_wq *ibwq)
+{
+	return container_of(ibwq, struct mlx4_qp, wq);
+}
+
 static inline struct mlx4_ah *to_mah(struct ibv_ah *ibah)
 {
 	return to_mxxx(ah, ah);
@@ -385,7 +394,7 @@ int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
 void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 			   struct mlx4_qp *qp);
-int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
+int mlx4_alloc_qp_buf(struct ibv_context *context, uint32_t max_recv_sge,
 		       enum ibv_qp_type type, struct mlx4_qp *qp,
 		       struct mlx4dv_qp_init_attr *mlx4qp_attr);
 void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
@@ -398,5 +407,9 @@ int mlx4_destroy_ah(struct ibv_ah *ah);
 int mlx4_alloc_av(struct mlx4_pd *pd, struct ibv_ah_attr *attr,
 		   struct mlx4_ah *ah);
 void mlx4_free_av(struct mlx4_ah *ah);
+struct ibv_wq *mlx4_create_wq(struct ibv_context *context,
+			      struct ibv_wq_init_attr *attr);
+int mlx4_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr);
+int mlx4_destroy_wq(struct ibv_wq *wq);
 
 #endif /* MLX4_H */
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 63f66d7..8f33f0e 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -650,13 +650,13 @@ void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 		; /* nothing */
 }
 
-int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
+int mlx4_alloc_qp_buf(struct ibv_context *context, uint32_t max_recv_sge,
 		      enum ibv_qp_type type, struct mlx4_qp *qp,
 		      struct mlx4dv_qp_init_attr *mlx4qp_attr)
 {
 	int wqe_size;
 
-	qp->rq.max_gs	 = cap->max_recv_sge;
+	qp->rq.max_gs	 = max_recv_sge;
 	wqe_size = qp->rq.max_gs * sizeof(struct mlx4_wqe_data_seg);
 	if (mlx4qp_attr &&
 	    mlx4qp_attr->comp_mask & MLX4DV_QP_INIT_ATTR_MASK_INL_RECV &&
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index abb447d..5ded2c5 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -839,7 +839,7 @@ static struct ibv_qp *create_qp_ex(struct ibv_context *context,
 			attr->cap.max_recv_wr = 1;
 	}
 
-	if (mlx4_alloc_qp_buf(context, &attr->cap, attr->qp_type, qp,
+	if (mlx4_alloc_qp_buf(context, attr->cap.max_recv_sge, attr->qp_type, qp,
 			      mlx4qp_attr))
 		goto err;
 
@@ -1272,3 +1272,172 @@ int mlx4_destroy_ah(struct ibv_ah *ah)
 
 	return 0;
 }
+
+struct ibv_wq *mlx4_create_wq(struct ibv_context *context,
+			      struct ibv_wq_init_attr *attr)
+{
+	struct mlx4_context		*ctx = to_mctx(context);
+	struct mlx4_create_wq		cmd = {};
+	struct ibv_create_wq_resp	resp = {};
+	struct mlx4_qp			*qp;
+	int				ret;
+
+	if (attr->wq_type != IBV_WQT_RQ) {
+		errno = ENOTSUP;
+		return NULL;
+	}
+
+	/* Sanity check QP size before proceeding */
+	if (ctx->max_qp_wr) { /* mlx4_query_device succeeded */
+		if (attr->max_wr  > ctx->max_qp_wr ||
+		    attr->max_sge > ctx->max_sge) {
+			errno = EINVAL;
+			return NULL;
+		}
+	} else {
+		if (attr->max_wr  > 65536 ||
+		    attr->max_sge > 64) {
+			errno = EINVAL;
+			return NULL;
+		}
+	}
+
+	if (attr->comp_mask) {
+		errno = ENOTSUP;
+		return NULL;
+	}
+
+	qp = calloc(1, sizeof(*qp));
+	if (!qp)
+		return NULL;
+
+	if (attr->max_sge < 1)
+		attr->max_sge = 1;
+
+	if (attr->max_wr < 1)
+		attr->max_wr = 1;
+
+	/* Kernel driver requires a dummy SQ with minimum properties */
+	qp->sq.wqe_shift = 6;
+	qp->sq.wqe_cnt = 1;
+
+	qp->rq.wqe_cnt = align_queue_size(attr->max_wr);
+
+	if (mlx4_alloc_qp_buf(context, attr->max_sge, IBV_QPT_RAW_PACKET, qp, NULL))
+		goto err;
+
+	mlx4_init_qp_indices(qp);
+	mlx4_qp_init_sq_ownership(qp); /* For dummy SQ */
+
+	if (pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE))
+		goto err_free;
+
+	qp->db = mlx4_alloc_db(to_mctx(context), MLX4_DB_TYPE_RQ);
+	if (!qp->db)
+		goto err_free;
+
+	*qp->db = 0;
+	cmd.drv.db_addr = (uintptr_t)qp->db;
+
+	cmd.drv.buf_addr = (uintptr_t)qp->buf.buf;
+
+	cmd.drv.log_range_size = ctx->log_wqs_range_sz;
+
+	pthread_mutex_lock(&to_mctx(context)->qp_table_mutex);
+
+	ret = ibv_cmd_create_wq(context, attr, &qp->wq, &cmd.ibv_cmd,
+				sizeof(cmd.ibv_cmd),
+				sizeof(cmd),
+				&resp, sizeof(resp),
+				sizeof(resp));
+	if (ret)
+		goto err_rq_db;
+
+	ret = mlx4_store_qp(to_mctx(context), qp->wq.wq_num, qp);
+	if (ret)
+		goto err_destroy;
+
+	pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
+
+	ctx->log_wqs_range_sz = 0;
+
+	qp->rq.max_post = attr->max_wr;
+	qp->rq.wqe_cnt = attr->max_wr;
+	qp->rq.max_gs  = attr->max_sge;
+
+	qp->wq.state = IBV_WQS_RESET;
+
+	return &qp->wq;
+
+err_destroy:
+	ibv_cmd_destroy_wq(&qp->wq);
+
+err_rq_db:
+	pthread_mutex_unlock(&to_mctx(context)->qp_table_mutex);
+	mlx4_free_db(to_mctx(context), MLX4_DB_TYPE_RQ, qp->db);
+
+err_free:
+	free(qp->rq.wrid);
+	mlx4_free_buf(&qp->buf);
+
+err:
+	free(qp);
+
+	return NULL;
+}
+
+int mlx4_modify_wq(struct ibv_wq *ibwq, struct ibv_wq_attr *attr)
+{
+	struct mlx4_qp *qp = wq_to_mqp(ibwq);
+	struct mlx4_modify_wq cmd = {};
+	int ret;
+
+	ret = ibv_cmd_modify_wq(ibwq, attr, &cmd.ibv_cmd,  sizeof(cmd.ibv_cmd),
+				sizeof(cmd));
+
+	if (!ret && (attr->attr_mask & IBV_WQ_ATTR_STATE) &&
+	    (ibwq->state == IBV_WQS_RESET)) {
+		mlx4_cq_clean(to_mcq(ibwq->cq), ibwq->wq_num, NULL);
+
+		mlx4_init_qp_indices(qp);
+		*qp->db = 0;
+	}
+
+	return ret;
+}
+
+int mlx4_destroy_wq(struct ibv_wq *ibwq)
+{
+	struct mlx4_context *mcontext = to_mctx(ibwq->context);
+	struct mlx4_qp *qp = wq_to_mqp(ibwq);
+	struct mlx4_cq *cq = NULL;
+	int ret;
+
+	pthread_mutex_lock(&mcontext->qp_table_mutex);
+
+	ret = ibv_cmd_destroy_wq(ibwq);
+	if (ret && !cleanup_on_fatal(ret)) {
+		pthread_mutex_unlock(&mcontext->qp_table_mutex);
+		return ret;
+	}
+
+	cq = to_mcq(ibwq->cq);
+	pthread_spin_lock(&cq->lock);
+	__mlx4_cq_clean(cq, ibwq->wq_num, NULL);
+
+	mlx4_clear_qp(mcontext, ibwq->wq_num);
+
+	pthread_spin_unlock(&cq->lock);
+
+	pthread_mutex_unlock(&mcontext->qp_table_mutex);
+
+	mlx4_free_db(mcontext, MLX4_DB_TYPE_RQ, qp->db);
+	free(qp->rq.wrid);
+	free(qp->sq.wrid);
+
+	mlx4_free_buf(&qp->buf);
+
+	free(qp);
+
+	return 0;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
