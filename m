From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Fix use of uninitialized struct ibv_qp at struct mlx5_qp
Date: Wed,  9 Dec 2015 16:24:07 +0200
Message-ID: <1449671047-17834-2-git-send-email-eranbe@mellanox.com>
References: <1449671047-17834-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449671047-17834-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current state was use of mlx5_qp->ibv_qp which was uninitiallized.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 2 +-
 src/mlx5.h  | 2 +-
 src/qp.c    | 8 ++++----
 src/verbs.c | 5 +++--
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 63c3ab0..231b278 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -413,7 +413,7 @@ static int mlx5_poll_one(struct mlx5_cq *cq,
 				return CQ_POLL_ERR;
 		}
 	} else {
-		if (!*cur_qp || (qpn != (*cur_qp)->ibv_qp.qp_num)) {
+		if (!*cur_qp || (qpn != (*cur_qp)->ibv_qp->qp_num)) {
 			/*
 			 * We do not have to take the QP table lock here,
 			 * because CQs will be locked while QPs are removed
diff --git a/src/mlx5.h b/src/mlx5.h
index 92ef33d..9181ec5 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -393,7 +393,7 @@ struct mlx5_mr {
 
 struct mlx5_qp {
 	struct verbs_qp			verbs_qp;
-	struct ibv_qp			ibv_qp;
+	struct ibv_qp		       *ibv_qp;
 	struct mlx5_buf                 buf;
 	int                             max_inline_data;
 	int                             buf_size;
diff --git a/src/qp.c b/src/qp.c
index eeb0c92..67ded0d 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -104,7 +104,7 @@ int mlx5_copy_to_send_wqe(struct mlx5_qp *qp, int idx, void *buf, int size)
 
 	idx &= (qp->sq.wqe_cnt - 1);
 	ctrl = mlx5_get_send_wqe(qp, idx);
-	if (qp->ibv_qp.qp_type != IBV_QPT_RC) {
+	if (qp->ibv_qp->qp_type != IBV_QPT_RC) {
 		fprintf(stderr, "scatter to CQE is supported only for RC QPs\n");
 		return IBV_WC_GENERAL_ERR;
 	}
@@ -353,7 +353,7 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		}
 
 		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq,
-					      to_mcq(qp->ibv_qp.send_cq)))) {
+					      to_mcq(qp->ibv_qp->send_cq)))) {
 			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "work queue overflow\n");
 			errno = ENOMEM;
 			err = -1;
@@ -537,7 +537,7 @@ static void set_sig_seg(struct mlx5_qp *qp, struct mlx5_rwqe_sig *sig,
 			int size, uint16_t idx)
 {
 	uint8_t  sign;
-	uint32_t qpn = qp->ibv_qp.qp_num;
+	uint32_t qpn = qp->ibv_qp->qp_num;
 
 	sign = calc_sig(sig, size);
 	sign ^= calc_sig(&qpn, 4);
@@ -562,7 +562,7 @@ int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (unlikely(mlx5_wq_overflow(&qp->rq, nreq,
-					      to_mcq(qp->ibv_qp.recv_cq)))) {
+					      to_mcq(qp->ibv_qp->recv_cq)))) {
 			errno = ENOMEM;
 			*bad_wr = wr;
 			err = -1;
diff --git a/src/verbs.c b/src/verbs.c
index b99c8df..8cbdd68 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -822,7 +822,7 @@ static int mlx5_alloc_qp_buf(struct ibv_context *context,
 	}
 
 	/* compatability support */
-	qp_huge_key  = qptype2key(qp->ibv_qp.qp_type);
+	qp_huge_key  = qptype2key(qp->ibv_qp->qp_type);
 	if (mlx5_use_huge(qp_huge_key))
 		default_alloc_type = MLX5_ALLOC_TYPE_HUGE;
 
@@ -860,7 +860,7 @@ ex_wrid:
 
 static void mlx5_free_qp_buf(struct mlx5_qp *qp)
 {
-	struct mlx5_context *ctx = to_mctx(qp->ibv_qp.context);
+	struct mlx5_context *ctx = to_mctx(qp->ibv_qp->context);
 
 	mlx5_free_actual_buf(ctx, &qp->buf);
 	if (qp->rq.wrid)
@@ -968,6 +968,7 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		return NULL;
 	}
 	ibqp = (struct ibv_qp *)&qp->verbs_qp;
+	qp->ibv_qp = ibqp;
 
 	qp->wq_sig = qp_sig_enabled();
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
