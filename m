From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 5/5] Add RSS data path support
Date: Tue, 30 Aug 2016 18:38:43 +0300
Message-ID: <1472571523-12067-6-git-send-email-yishaih@mellanox.com>
References: <1472571523-12067-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472571523-12067-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add RSS data path support, it includes:
- WQ post receive implementation.
- Poll CQ handling in both lazy/non-lazy modes.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c   | 55 +++++++++++++++++++++++++++-------------
 src/mlx5.h |  5 ++++
 src/qp.c   | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 128 insertions(+), 18 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8809703..06bda63 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -240,10 +240,11 @@ static inline void handle_good_req_lazy(struct mlx5_cqe64 *cqe, uint32_t *pwc_by
 }
 
 static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *cqe,
-					struct mlx5_qp *qp, struct mlx5_srq *srq)
+					struct mlx5_resource *cur_rsc, struct mlx5_srq *srq)
 {
 	uint16_t	wqe_ctr;
 	struct mlx5_wq *wq;
+	struct mlx5_qp *qp = rsc_to_mqp(cur_rsc);
 	int err = IBV_WC_SUCCESS;
 
 	if (srq) {
@@ -257,12 +258,17 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe - 1,
 						    ntohl(cqe->byte_cnt));
 	} else {
-		wq	  = &qp->rq;
+		if (likely(cur_rsc->type == MLX5_RSC_TYPE_QP)) {
+			wq = &qp->rq;
+			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
+				cq->flags |= MLX5_CQ_FLAGS_RX_CSUM_VALID;
+		} else {
+			wq = &(rsc_to_mrwq(cur_rsc)->rq);
+		}
+
 		wqe_ctr = wq->tail & (wq->wqe_cnt - 1);
 		cq->ibv_cq.wr_id = wq->wrid[wqe_ctr];
 		++wq->tail;
-		if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
-			cq->flags |= MLX5_CQ_FLAGS_RX_CSUM_VALID;
 		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe,
 						    ntohl(cqe->byte_cnt));
@@ -274,11 +280,12 @@ static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *c
 	return err;
 }
 
-static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
-			    struct mlx5_qp *qp, struct mlx5_srq *srq)
+static inline int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
+				   struct mlx5_resource *cur_rsc, struct mlx5_srq *srq)
 {
 	uint16_t	wqe_ctr;
 	struct mlx5_wq *wq;
+	struct mlx5_qp *qp = rsc_to_mqp(cur_rsc);
 	uint8_t g;
 	int err = 0;
 
@@ -294,7 +301,18 @@ static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe - 1,
 						    wc->byte_len);
 	} else {
-		wq	  = &qp->rq;
+		if (likely(cur_rsc->type == MLX5_RSC_TYPE_QP)) {
+			wq = &qp->rq;
+			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
+				wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
+						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
+						(get_cqe_l3_hdr_type(cqe) ==
+						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
+						IBV_WC_IP_CSUM_OK_SHIFT;
+		} else {
+			wq = &(rsc_to_mrwq(cur_rsc)->rq);
+		}
+
 		wqe_ctr = wq->tail & (wq->wqe_cnt - 1);
 		wc->wr_id = wq->wrid[wqe_ctr];
 		++wq->tail;
@@ -304,12 +322,6 @@ static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
 						    wc->byte_len);
-		if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
-			wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
-					 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
-					(get_cqe_l3_hdr_type(cqe) ==
-					MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
-					IBV_WC_IP_CSUM_OK_SHIFT;
 	}
 	if (err)
 		return err;
@@ -475,6 +487,8 @@ static inline int get_resp_ctx_v1(struct mlx5_context *mctx,
 		*cur_srq = rsc_to_msrq(*cur_rsc);
 		*is_srq = 1;
 		break;
+	case MLX5_RSC_TYPE_RWQ:
+		break;
 	default:
 		return CQ_POLL_ERR;
 	}
@@ -678,10 +692,10 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 
 		if (lazy)
 			cq->ibv_cq.status = handle_responder_lazy(cq, cqe64,
-							      rsc_to_mqp(*cur_rsc),
+							      *cur_rsc,
 							      is_srq ? *cur_srq : NULL);
 		else
-			wc->status = handle_responder(wc, cqe64, rsc_to_mqp(*cur_rsc),
+			wc->status = handle_responder(wc, cqe64, *cur_rsc,
 					      is_srq ? *cur_srq : NULL);
 		break;
 	case MLX5_CQE_RESIZE_CQ:
@@ -739,8 +753,15 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 					wc->wr_id = (*cur_srq)->wrid[wqe_ctr];
 				mlx5_free_srq_wqe(*cur_srq, wqe_ctr);
 			} else {
-				mqp = rsc_to_mqp(*cur_rsc);
-				wq = &mqp->rq;
+				switch ((*cur_rsc)->type) {
+				case MLX5_RSC_TYPE_RWQ:
+					wq = &(rsc_to_mrwq(*cur_rsc)->rq);
+					break;
+				default:
+					wq = &(rsc_to_mqp(*cur_rsc)->rq);
+					break;
+				}
+
 				if (lazy)
 					cq->ibv_cq.wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 				else
diff --git a/src/mlx5.h b/src/mlx5.h
index 40817d8..f513bc9 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -638,6 +638,11 @@ static inline struct mlx5_srq *rsc_to_msrq(struct mlx5_resource *rsc)
 	return (struct mlx5_srq *)rsc;
 }
 
+static inline struct mlx5_rwq *rsc_to_mrwq(struct mlx5_resource *rsc)
+{
+	return (struct mlx5_rwq *)rsc;
+}
+
 int mlx5_alloc_buf(struct mlx5_buf *buf, size_t size, int page_size);
 void mlx5_free_buf(struct mlx5_buf *buf);
 int mlx5_alloc_buf_contig(struct mlx5_context *mctx, struct mlx5_buf *buf,
diff --git a/src/qp.c b/src/qp.c
index d784c7e..2ae8833 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -67,6 +67,11 @@ static void *get_recv_wqe(struct mlx5_qp *qp, int n)
 	return qp->buf.buf + qp->rq.offset + (n << qp->rq.wqe_shift);
 }
 
+static void *get_wq_recv_wqe(struct mlx5_rwq *rwq, int n)
+{
+	return rwq->pbuff  + (n << rwq->rq.wqe_shift);
+}
+
 static int copy_to_scat(struct mlx5_wqe_data_seg *scat, void *buf, int *size,
 			 int max)
 {
@@ -1047,10 +1052,89 @@ static void set_sig_seg(struct mlx5_qp *qp, struct mlx5_rwqe_sig *sig,
 	sig->signature = sign;
 }
 
+static void set_wq_sig_seg(struct mlx5_rwq *rwq, struct mlx5_rwqe_sig *sig,
+			   int size, uint16_t idx)
+{
+	uint8_t  sign;
+	uint32_t qpn = rwq->wq.wq_num;
+
+	sign = calc_sig(sig, size);
+	sign ^= calc_sig(&qpn, 4);
+	sign ^= calc_sig(&idx, 2);
+	sig->signature = sign;
+}
+
 int mlx5_post_wq_recv(struct ibv_wq *ibwq, struct ibv_recv_wr *wr,
 		      struct ibv_recv_wr **bad_wr)
 {
-	return ENOSYS;
+	struct mlx5_rwq *rwq = to_mrwq(ibwq);
+	struct mlx5_wqe_data_seg *scat;
+	int err = 0;
+	int nreq;
+	int ind;
+	int i, j;
+	struct mlx5_rwqe_sig *sig;
+
+	mlx5_spin_lock(&rwq->rq.lock);
+
+	ind = rwq->rq.head & (rwq->rq.wqe_cnt - 1);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (unlikely(mlx5_wq_overflow(&rwq->rq, nreq,
+					      to_mcq(rwq->wq.cq)))) {
+			err = ENOMEM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (unlikely(wr->num_sge > rwq->rq.max_gs)) {
+			err = EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		scat = get_wq_recv_wqe(rwq, ind);
+		sig = (struct mlx5_rwqe_sig *)scat;
+		if (unlikely(rwq->wq_sig)) {
+			memset(sig, 0, 1 << rwq->rq.wqe_shift);
+			++scat;
+		}
+
+		for (i = 0, j = 0; i < wr->num_sge; ++i) {
+			if (unlikely(!wr->sg_list[i].length))
+				continue;
+			set_data_ptr_seg(scat + j++, wr->sg_list + i, 0);
+		}
+
+		if (j < rwq->rq.max_gs) {
+			scat[j].byte_count = 0;
+			scat[j].lkey       = htonl(MLX5_INVALID_LKEY);
+			scat[j].addr       = 0;
+		}
+
+		if (unlikely(rwq->wq_sig))
+			set_wq_sig_seg(rwq, sig, (wr->num_sge + 1) << 4,
+				       rwq->rq.head & 0xffff);
+
+		rwq->rq.wrid[ind] = wr->wr_id;
+
+		ind = (ind + 1) & (rwq->rq.wqe_cnt - 1);
+	}
+
+out:
+	if (likely(nreq)) {
+		rwq->rq.head += nreq;
+		/*
+		 * Make sure that descriptors are written before
+		 * doorbell record.
+		 */
+		wmb();
+		*(rwq->recv_db) = htonl(rwq->rq.head & 0xffff);
+	}
+
+	mlx5_spin_unlock(&rwq->rq.lock);
+
+	return err;
 }
 
 int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
