From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/6] mlx4: Add WQ data path support
Date: Tue, 12 Sep 2017 15:53:07 +0300
Message-ID: <1505220788-23849-6-git-send-email-yishaih@mellanox.com>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It includes:
1) Adding support for post receive to a WQ.
2) Adding support in the poll CQ flow to handle QP and WQ.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c    |  5 +++--
 providers/mlx4/mlx4.h  |  4 ++++
 providers/mlx4/qp.c    | 30 ++++++++++++++++++++++++++----
 providers/mlx4/verbs.c |  7 +++++++
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 5c7723b..8ced49e 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -229,7 +229,7 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
 		if (!srq)
 			return CQ_POLL_ERR;
 	} else {
-		if (!*cur_qp || (qpn != (*cur_qp)->verbs_qp.qp.qp_num)) {
+		if (!*cur_qp || (qpn != (*cur_qp)->qpn_cache)) {
 			/*
 			 * We do not have to take the QP table lock here,
 			 * because CQs will be locked while QPs are removed
@@ -239,7 +239,8 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
 			if (!*cur_qp)
 				return CQ_POLL_ERR;
 		}
-		srq = ((*cur_qp)->verbs_qp.qp.srq) ? to_msrq((*cur_qp)->verbs_qp.qp.srq) : NULL;
+		srq = ((*cur_qp)->type == MLX4_RSC_TYPE_SRQ) ?
+			to_msrq((*cur_qp)->verbs_qp.qp.srq) : NULL;
 	}
 
 	pwr_id = lazy ? &cq->ibv_cq.wr_id : &wc->wr_id;
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 83dd551..14f2720 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -201,6 +201,7 @@ struct mlx4_wq {
 enum mlx4_rsc_type {
 	MLX4_RSC_TYPE_QP	= 0,
 	MLX4_RSC_TYPE_RSS_QP	= 1,
+	MLX4_RSC_TYPE_SRQ	= 2,
 };
 
 struct mlx4_qp {
@@ -223,6 +224,7 @@ struct mlx4_qp {
 	uint8_t				link_layer;
 	uint8_t				type; /* enum mlx4_rsc_type */
 	uint32_t			qp_cap_cache;
+	uint32_t			qpn_cache;
 };
 
 struct mlx4_ah {
@@ -420,5 +422,7 @@ int mlx4_destroy_wq(struct ibv_wq *wq);
 struct ibv_rwq_ind_table *mlx4_create_rwq_ind_table(struct ibv_context *context,
 						    struct ibv_rwq_ind_table_init_attr *init_attr);
 int mlx4_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
+int mlx4_post_wq_recv(struct ibv_wq *ibwq, struct ibv_recv_wr *wr,
+		      struct ibv_recv_wr **bad_wr);
 
 #endif /* MLX4_H */
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 8f33f0e..61f69ee 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -509,10 +509,14 @@ out:
 	return ret;
 }
 
-int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
-		   struct ibv_recv_wr **bad_wr)
+static inline int _mlx4_post_recv(struct mlx4_qp *qp, struct mlx4_cq *cq,
+				  struct ibv_recv_wr *wr,
+				  struct ibv_recv_wr **bad_wr)
+				  ALWAYS_INLINE;
+static inline int _mlx4_post_recv(struct mlx4_qp *qp, struct mlx4_cq *cq,
+				  struct ibv_recv_wr *wr,
+				  struct ibv_recv_wr **bad_wr)
 {
-	struct mlx4_qp *qp = to_mqp(ibqp);
 	struct mlx4_wqe_data_seg *scat;
 	int ret = 0;
 	int nreq;
@@ -526,7 +530,7 @@ int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
-		if (wq_overflow(&qp->rq, nreq, to_mcq(ibqp->recv_cq))) {
+		if (wq_overflow(&qp->rq, nreq, cq)) {
 			ret = ENOMEM;
 			*bad_wr = wr;
 			goto out;
@@ -572,6 +576,24 @@ out:
 	return ret;
 }
 
+int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
+		   struct ibv_recv_wr **bad_wr)
+{
+	struct mlx4_qp *qp = to_mqp(ibqp);
+	struct mlx4_cq *cq = to_mcq(ibqp->recv_cq);
+
+	return _mlx4_post_recv(qp, cq, wr, bad_wr);
+}
+
+int mlx4_post_wq_recv(struct ibv_wq *ibwq, struct ibv_recv_wr *wr,
+		      struct ibv_recv_wr **bad_wr)
+{
+	struct mlx4_qp *qp = wq_to_mqp(ibwq);
+	struct mlx4_cq *cq = to_mcq(ibwq->cq);
+
+	return _mlx4_post_recv(qp, cq, wr, bad_wr);
+}
+
 static int num_inline_segs(int data, enum ibv_qp_type type)
 {
 	/*
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 5f2266a..b966ef2 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -976,6 +976,9 @@ static struct ibv_qp *create_qp_ex(struct ibv_context *context,
 	else
 		qp->sq_signal_bits = 0;
 
+	qp->qpn_cache = qp->verbs_qp.qp.qp_num;
+	qp->type = attr->srq ? MLX4_RSC_TYPE_SRQ : MLX4_RSC_TYPE_QP;
+
 	return &qp->verbs_qp.qp;
 
 err_destroy:
@@ -1473,6 +1476,10 @@ struct ibv_wq *mlx4_create_wq(struct ibv_context *context,
 
 	qp->wq.state = IBV_WQS_RESET;
 
+	qp->wq.post_recv = mlx4_post_wq_recv;
+
+	qp->qpn_cache = qp->wq.wq_num;
+
 	return &qp->wq;
 
 err_destroy:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
