From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 1/5] Add support for RSS WQ verbs
Date: Tue, 30 Aug 2016 18:38:39 +0300
Message-ID: <1472571523-12067-2-git-send-email-yishaih@mellanox.com>
References: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472571523-12067-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for RSS WQ verbs, it includes:
create/destroy/modify WQ.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h |  32 +++++++++
 src/mlx5.c     |   3 +
 src/mlx5.h     |  26 +++++++
 src/qp.c       |  12 ++++
 src/verbs.c    | 214 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 287 insertions(+)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 3d71eb0..c750cc8 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -44,6 +44,10 @@ enum {
 };
 
 enum {
+	MLX5_RWQ_FLAG_SIGNATURE		= 1 << 0,
+};
+
+enum {
 	MLX5_NUM_UUARS_PER_PAGE = 2,
 	MLX5_MAX_UAR_PAGES	= 1 << 8,
 	MLX5_MAX_UUARS		= MLX5_MAX_UAR_PAGES * MLX5_NUM_UUARS_PER_PAGE,
@@ -170,6 +174,34 @@ struct mlx5_create_qp_resp {
 	__u32				uuar_index;
 };
 
+struct mlx5_drv_create_wq {
+	__u64		buf_addr;
+	__u64		db_addr;
+	__u32		rq_wqe_count;
+	__u32		rq_wqe_shift;
+	__u32		user_index;
+	__u32		flags;
+	__u32		comp_mask;
+	__u32		reserved;
+};
+
+struct mlx5_create_wq {
+	struct ibv_create_wq	ibv_cmd;
+	struct mlx5_drv_create_wq	drv;
+};
+
+struct mlx5_create_wq_resp {
+	struct ibv_create_wq_resp	ibv_resp;
+	__u32			response_length;
+	__u32			reserved;
+};
+
+struct mlx5_modify_wq {
+	struct ibv_modify_wq	ibv_cmd;
+	__u32			comp_mask;
+	__u32			reserved;
+};
+
 struct mlx5_resize_cq {
 	struct ibv_resize_cq		ibv_cmd;
 	__u64				buf_addr;
diff --git a/src/mlx5.c b/src/mlx5.c
index 5885f0b..5b69f36 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -745,6 +745,9 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, ibv_create_flow, ibv_cmd_create_flow);
 	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
+	verbs_set_ctx_op(v_ctx, create_wq, mlx5_create_wq);
+	verbs_set_ctx_op(v_ctx, modify_wq, mlx5_modify_wq);
+	verbs_set_ctx_op(v_ctx, destroy_wq, mlx5_destroy_wq);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/src/mlx5.h b/src/mlx5.h
index 5833339..fd3ca96 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -135,6 +135,7 @@ enum {
 #define MLX5_CQ_PREFIX "MLX_CQ"
 #define MLX5_QP_PREFIX "MLX_QP"
 #define MLX5_MR_PREFIX "MLX_MR"
+#define MLX5_RWQ_PREFIX "MLX_RWQ"
 #define MLX5_MAX_LOG2_CONTIG_BLOCK_SIZE 23
 #define MLX5_MIN_LOG2_CONTIG_BLOCK_SIZE 12
 
@@ -263,6 +264,7 @@ enum mlx5_rsc_type {
 	MLX5_RSC_TYPE_QP,
 	MLX5_RSC_TYPE_XSRQ,
 	MLX5_RSC_TYPE_SRQ,
+	MLX5_RSC_TYPE_RWQ,
 	MLX5_RSC_TYPE_INVAL,
 };
 
@@ -521,6 +523,18 @@ struct mlx5_ah {
 	struct mlx5_av			av;
 };
 
+struct mlx5_rwq {
+	struct mlx5_resource rsc;
+	struct ibv_wq wq;
+	struct mlx5_buf buf;
+	int buf_size;
+	struct mlx5_wq rq;
+	uint32_t *db;
+	void	*pbuff;
+	uint32_t	*recv_db;
+	int wq_sig;
+};
+
 static inline int mlx5_ilog2(int n)
 {
 	int t;
@@ -593,6 +607,11 @@ static inline struct mlx5_qp *to_mqp(struct ibv_qp *ibqp)
 	return container_of(vqp, struct mlx5_qp, verbs_qp);
 }
 
+static inline struct mlx5_rwq *to_mrwq(struct ibv_wq *ibwq)
+{
+	return container_of(ibwq, struct mlx5_rwq, wq);
+}
+
 static inline struct mlx5_mr *to_mmr(struct ibv_mr *ibmr)
 {
 	return to_mxxx(mr, mr);
@@ -703,10 +722,13 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask);
 int mlx5_destroy_qp(struct ibv_qp *qp);
 void mlx5_init_qp_indices(struct mlx5_qp *qp);
+void mlx5_init_rwq_indices(struct mlx5_rwq *rwq);
 int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			  struct ibv_send_wr **bad_wr);
 int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
+int mlx5_post_wq_recv(struct ibv_wq *ibwq, struct ibv_recv_wr *wr,
+		      struct ibv_recv_wr **bad_wr);
 void mlx5_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 			   struct mlx5_qp *qp);
 void mlx5_set_sq_sizes(struct mlx5_qp *qp, struct ibv_qp_cap *cap,
@@ -737,6 +759,10 @@ struct ibv_xrcd *mlx5_open_xrcd(struct ibv_context *context,
 				struct ibv_xrcd_init_attr *xrcd_init_attr);
 int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num);
 int mlx5_close_xrcd(struct ibv_xrcd *ib_xrcd);
+struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
+			      struct ibv_wq_init_attr *attr);
+int mlx5_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr);
+int mlx5_destroy_wq(struct ibv_wq *wq);
 struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 				   struct ibv_srq_init_attr_ex *attr);
 
diff --git a/src/qp.c b/src/qp.c
index c805fca..d784c7e 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -154,6 +154,12 @@ void *mlx5_get_send_wqe(struct mlx5_qp *qp, int n)
 	return qp->sq_start + (n << MLX5_SEND_WQE_SHIFT);
 }
 
+void mlx5_init_rwq_indices(struct mlx5_rwq *rwq)
+{
+	rwq->rq.head	 = 0;
+	rwq->rq.tail	 = 0;
+}
+
 void mlx5_init_qp_indices(struct mlx5_qp *qp)
 {
 	qp->sq.head	 = 0;
@@ -1041,6 +1047,12 @@ static void set_sig_seg(struct mlx5_qp *qp, struct mlx5_rwqe_sig *sig,
 	sig->signature = sign;
 }
 
+int mlx5_post_wq_recv(struct ibv_wq *ibwq, struct ibv_recv_wr *wr,
+		      struct ibv_recv_wr **bad_wr)
+{
+	return ENOSYS;
+}
+
 int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		   struct ibv_recv_wr **bad_wr)
 {
diff --git a/src/verbs.c b/src/verbs.c
index 07e2545..787dedf 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -885,6 +885,40 @@ static int mlx5_calc_sq_size(struct mlx5_context *ctx,
 	return wq_size;
 }
 
+static int mlx5_calc_rwq_size(struct mlx5_context *ctx,
+			      struct mlx5_rwq *rwq,
+			      struct ibv_wq_init_attr *attr)
+{
+	int wqe_size;
+	int wq_size;
+	int num_scatter;
+	int scat_spc;
+
+	if (!attr->max_wr)
+		return -EINVAL;
+
+	/* TBD: check caps for RQ */
+	num_scatter = max(attr->max_sge, 1);
+	wqe_size = sizeof(struct mlx5_wqe_data_seg) * num_scatter;
+
+	if (rwq->wq_sig)
+		wqe_size += sizeof(struct mlx5_rwqe_sig);
+
+	if (wqe_size <= 0 || wqe_size > ctx->max_rq_desc_sz)
+		return -EINVAL;
+
+	wqe_size = mlx5_round_up_power_of_two(wqe_size);
+	wq_size = mlx5_round_up_power_of_two(attr->max_wr) * wqe_size;
+	wq_size = max(wq_size, MLX5_SEND_WQE_BB);
+	rwq->rq.wqe_cnt = wq_size / wqe_size;
+	rwq->rq.wqe_shift = mlx5_ilog2(wqe_size);
+	rwq->rq.max_post = 1 << mlx5_ilog2(wq_size / wqe_size);
+	scat_spc = wqe_size -
+		((rwq->wq_sig) ? sizeof(struct mlx5_rwqe_sig) : 0);
+	rwq->rq.max_gs = scat_spc / sizeof(struct mlx5_wqe_data_seg);
+	return wq_size;
+}
+
 static int mlx5_calc_rq_size(struct mlx5_context *ctx,
 			     struct ibv_qp_init_attr_ex *attr,
 			     struct mlx5_qp *qp)
@@ -1779,3 +1813,183 @@ int mlx5_query_device_ex(struct ibv_context *context,
 
 	return 0;
 }
+
+static int rwq_sig_enabled(struct ibv_context *context)
+{
+	char *env;
+
+	env = getenv("MLX5_RWQ_SIGNATURE");
+	if (env)
+		return 1;
+
+	return 0;
+}
+
+static void mlx5_free_rwq_buf(struct mlx5_rwq *rwq, struct ibv_context *context)
+{
+	struct mlx5_context *ctx = to_mctx(context);
+
+	mlx5_free_actual_buf(ctx, &rwq->buf);
+	free(rwq->rq.wrid);
+}
+
+static int mlx5_alloc_rwq_buf(struct ibv_context *context,
+			      struct mlx5_rwq *rwq,
+			      int size)
+{
+	int err;
+	enum mlx5_alloc_type default_alloc_type = MLX5_ALLOC_TYPE_PREFER_CONTIG;
+
+	rwq->rq.wrid = malloc(rwq->rq.wqe_cnt * sizeof(uint64_t));
+	if (!rwq->rq.wrid) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	err = mlx5_alloc_prefered_buf(to_mctx(context), &rwq->buf,
+				      align(rwq->buf_size, to_mdev
+				      (context->device)->page_size),
+				      to_mdev(context->device)->page_size,
+				      default_alloc_type,
+				      MLX5_RWQ_PREFIX);
+
+	if (err) {
+		free(rwq->rq.wrid);
+		errno = ENOMEM;
+		return -1;
+	}
+
+	return 0;
+}
+
+struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
+			      struct ibv_wq_init_attr *attr)
+{
+	struct mlx5_create_wq		cmd;
+	struct mlx5_create_wq_resp		resp;
+	int				err;
+	struct mlx5_rwq			*rwq;
+	struct mlx5_context	*ctx = to_mctx(context);
+	int ret;
+	int32_t				usr_idx = 0;
+#ifdef MLX5_DEBUG
+	FILE *fp = ctx->dbg_fp;
+#endif
+
+	if (attr->wq_type != IBV_WQT_RQ)
+		return NULL;
+
+	memset(&cmd, 0, sizeof(cmd));
+	memset(&resp, 0, sizeof(resp));
+
+	rwq = calloc(1, sizeof(*rwq));
+	if (!rwq)
+		return NULL;
+
+	rwq->wq_sig = rwq_sig_enabled(context);
+	if (rwq->wq_sig)
+		cmd.drv.flags = MLX5_RWQ_FLAG_SIGNATURE;
+
+	ret = mlx5_calc_rwq_size(ctx, rwq, attr);
+	if (ret < 0) {
+		errno = -ret;
+		goto err;
+	}
+
+	rwq->buf_size = ret;
+	if (mlx5_alloc_rwq_buf(context, rwq, ret))
+		goto err;
+
+	mlx5_init_rwq_indices(rwq);
+
+	if (mlx5_spinlock_init(&rwq->rq.lock))
+		goto err_free_rwq_buf;
+
+	rwq->db = mlx5_alloc_dbrec(ctx);
+	if (!rwq->db)
+		goto err_free_rwq_buf;
+
+	rwq->db[MLX5_RCV_DBR] = 0;
+	rwq->db[MLX5_SND_DBR] = 0;
+	rwq->pbuff = rwq->buf.buf + rwq->rq.offset;
+	rwq->recv_db =  &rwq->db[MLX5_RCV_DBR];
+	cmd.drv.buf_addr = (uintptr_t)rwq->buf.buf;
+	cmd.drv.db_addr  = (uintptr_t)rwq->db;
+	cmd.drv.rq_wqe_count = rwq->rq.wqe_cnt;
+	cmd.drv.rq_wqe_shift = rwq->rq.wqe_shift;
+	usr_idx = mlx5_store_uidx(ctx, rwq);
+	if (usr_idx < 0) {
+		mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
+		goto err_free_db_rec;
+	}
+
+	cmd.drv.user_index = usr_idx;
+	err = ibv_cmd_create_wq(context, attr, &rwq->wq, &cmd.ibv_cmd,
+				sizeof(cmd.ibv_cmd),
+				sizeof(cmd),
+				&resp.ibv_resp, sizeof(resp.ibv_resp),
+				sizeof(resp));
+	if (err)
+		goto err_create;
+
+	rwq->rsc.type = MLX5_RSC_TYPE_RWQ;
+	rwq->rsc.rsn =  cmd.drv.user_index;
+
+	rwq->wq.post_recv = mlx5_post_wq_recv;
+	return &rwq->wq;
+
+err_create:
+	mlx5_clear_uidx(ctx, cmd.drv.user_index);
+err_free_db_rec:
+	mlx5_free_db(to_mctx(context), rwq->db);
+err_free_rwq_buf:
+	mlx5_free_rwq_buf(rwq, context);
+err:
+	free(rwq);
+	return NULL;
+}
+
+int mlx5_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr)
+{
+	struct mlx5_modify_wq	cmd = {};
+	struct mlx5_rwq *rwq = to_mrwq(wq);
+
+	if ((attr->attr_mask & IBV_WQ_ATTR_STATE) &&
+	    attr->wq_state == IBV_WQS_RDY) {
+		if ((attr->attr_mask & IBV_WQ_ATTR_CURR_STATE) &&
+		    attr->curr_wq_state != wq->state)
+			return -EINVAL;
+
+		if (wq->state == IBV_WQS_RESET) {
+			mlx5_spin_lock(&to_mcq(wq->cq)->lock);
+			__mlx5_cq_clean(to_mcq(wq->cq),
+					rwq->rsc.rsn, NULL);
+			mlx5_spin_unlock(&to_mcq(wq->cq)->lock);
+			mlx5_init_rwq_indices(rwq);
+			rwq->db[MLX5_RCV_DBR] = 0;
+			rwq->db[MLX5_SND_DBR] = 0;
+		}
+	}
+
+	return ibv_cmd_modify_wq(wq, attr, &cmd.ibv_cmd,  sizeof(cmd.ibv_cmd), sizeof(cmd));
+}
+
+int mlx5_destroy_wq(struct ibv_wq *wq)
+{
+	struct mlx5_rwq *rwq = to_mrwq(wq);
+	int ret;
+
+	ret = ibv_cmd_destroy_wq(wq);
+	if (ret)
+		return ret;
+
+	mlx5_spin_lock(&to_mcq(wq->cq)->lock);
+	__mlx5_cq_clean(to_mcq(wq->cq), rwq->rsc.rsn, NULL);
+	mlx5_spin_unlock(&to_mcq(wq->cq)->lock);
+	mlx5_clear_uidx(to_mctx(wq->context), rwq->rsc.rsn);
+	mlx5_free_db(to_mctx(wq->context), rwq->db);
+	mlx5_free_rwq_buf(rwq, wq->context);
+	free(rwq);
+
+	return 0;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
