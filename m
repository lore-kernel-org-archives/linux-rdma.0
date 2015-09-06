From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 3/5] Added new poll_cq according to the new CQE format
Date: Sun,  6 Sep 2015 12:30:10 +0300
Message-ID: <1441531812-27716-4-git-send-email-hagaya@mellanox.com>
References: <1441531812-27716-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441531812-27716-1-git-send-email-hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When working with CQE  version 1, the CQE format is different, therefore
we need a new poll_cq function that is compatible with the new CQE
format.

When  allocating the user-context, we decide on the CQE version, and
according to this, we choose which poll_cq  function to use; the old one
that supports the old CQE format or the new one.


Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c       | 217 +++++++++++++++++++++++++++++++++++++++++++++------------
 src/mlx5-abi.h |   3 +-
 src/mlx5.h     |  12 ++++
 3 files changed, 187 insertions(+), 45 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 63c3ab0..a1fdac3 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -116,7 +116,7 @@ struct mlx5_cqe64 {
 	uint16_t	slid;
 	uint32_t	flags_rqpn;
 	uint8_t		rsvd28[4];
-	uint32_t	srqn;
+	uint32_t	srqn_uidx;
 	uint32_t	imm_inval_pkey;
 	uint8_t		rsvd40[4];
 	uint32_t	byte_cnt;
@@ -362,21 +362,120 @@ static void mlx5_get_cycles(uint64_t *cycles)
 }
 #endif
 
-static int mlx5_poll_one(struct mlx5_cq *cq,
-			 struct mlx5_qp **cur_qp,
+static inline struct mlx5_qp *get_req_context(struct mlx5_context *mctx,
+					      struct mlx5_resource **cur_rsc,
+					      uint32_t rsn, int cqe_ver)
+					      __attribute__((always_inline));
+static inline struct mlx5_qp *get_req_context(struct mlx5_context *mctx,
+					      struct mlx5_resource **cur_rsc,
+					      uint32_t rsn, int cqe_ver)
+{
+	if (!*cur_rsc || (rsn != (*cur_rsc)->rsn))
+		*cur_rsc = cqe_ver ? mlx5_find_uidx(mctx, rsn) :
+				      (struct mlx5_resource *)mlx5_find_qp(mctx, rsn);
+
+	return rsc_to_mqp(*cur_rsc);
+}
+
+static inline int get_resp_cxt_v1(struct mlx5_context *mctx,
+				  struct mlx5_resource **cur_rsc,
+				  struct mlx5_srq **cur_srq,
+				  uint32_t uidx, int *is_srq)
+				  __attribute__((always_inline));
+static inline int get_resp_cxt_v1(struct mlx5_context *mctx,
+				  struct mlx5_resource **cur_rsc,
+				  struct mlx5_srq **cur_srq,
+				  uint32_t uidx, int *is_srq)
+{
+	struct mlx5_qp *mqp;
+
+	if (!*cur_rsc || (uidx != (*cur_rsc)->rsn)) {
+		*cur_rsc = mlx5_find_uidx(mctx, uidx);
+		if (unlikely(!*cur_rsc))
+			return CQ_POLL_ERR;
+	}
+
+	switch ((*cur_rsc)->type) {
+	case MLX5_RSC_TYPE_QP:
+		mqp = rsc_to_mqp(*cur_rsc);
+		if (mqp->verbs_qp.qp.srq) {
+			*cur_srq = to_msrq(mqp->verbs_qp.qp.srq);
+			*is_srq = 1;
+		}
+		break;
+	case MLX5_RSC_TYPE_XSRQ:
+		*cur_srq = rsc_to_msrq(*cur_rsc);
+		*is_srq = 1;
+		break;
+	default:
+		return CQ_POLL_ERR;
+	}
+
+	return CQ_OK;
+}
+
+static inline int get_resp_ctx(struct mlx5_context *mctx,
+			       struct mlx5_resource **cur_rsc,
+			       uint32_t qpn)
+			       __attribute__((always_inline));
+static inline int get_resp_ctx(struct mlx5_context *mctx,
+			       struct mlx5_resource **cur_rsc,
+			       uint32_t qpn)
+{
+	if (!*cur_rsc || (qpn != (*cur_rsc)->rsn)) {
+		/*
+		 * We do not have to take the QP table lock here,
+		 * because CQs will be locked while QPs are removed
+		 * from the table.
+		 */
+		*cur_rsc = (struct mlx5_resource *)mlx5_find_qp(mctx, qpn);
+		if (unlikely(!*cur_rsc))
+			return CQ_POLL_ERR;
+	}
+
+	return CQ_OK;
+}
+
+static inline int get_srq_ctx(struct mlx5_context *mctx,
+			      struct mlx5_srq **cur_srq,
+			      uint32_t srqn_uidx)
+			      __attribute__((always_inline));
+static inline int get_srq_ctx(struct mlx5_context *mctx,
+			      struct mlx5_srq **cur_srq,
+			      uint32_t srqn)
+{
+	if (!*cur_srq || (srqn != (*cur_srq)->srqn)) {
+		*cur_srq = mlx5_find_srq(mctx, srqn);
+		if (unlikely(!*cur_srq))
+			return CQ_POLL_ERR;
+	}
+
+	return CQ_OK;
+}
+
+static inline int mlx5_poll_one(struct mlx5_cq *cq,
+			 struct mlx5_resource **cur_rsc,
 			 struct mlx5_srq **cur_srq,
-			 struct ibv_wc *wc)
+			 struct ibv_wc *wc, int cqe_ver)
+			 __attribute__((always_inline));
+static inline int mlx5_poll_one(struct mlx5_cq *cq,
+			 struct mlx5_resource **cur_rsc,
+			 struct mlx5_srq **cur_srq,
+			 struct ibv_wc *wc, int cqe_ver)
 {
 	struct mlx5_cqe64 *cqe64;
 	struct mlx5_wq *wq;
 	uint16_t wqe_ctr;
 	void *cqe;
 	uint32_t qpn;
-	uint32_t srqn;
+	uint32_t srqn_uidx;
 	int idx;
 	uint8_t opcode;
 	struct mlx5_err_cqe *ecqe;
 	int err;
+	int is_srq = 0;
+	struct mlx5_qp *mqp = NULL;
+	struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
 
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
@@ -384,6 +483,7 @@ static int mlx5_poll_one(struct mlx5_cq *cq,
 
 	cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
 
+	opcode = cqe64->op_own >> 4;
 	++cq->cons_index;
 
 	VALGRIND_MAKE_MEM_DEFINED(cqe64, sizeof *cqe64);
@@ -396,51 +496,32 @@ static int mlx5_poll_one(struct mlx5_cq *cq,
 
 #ifdef MLX5_DEBUG
 	if (mlx5_debug_mask & MLX5_DBG_CQ_CQE) {
-		FILE *fp = to_mctx(cq->ibv_cq.context)->dbg_fp;
+		FILE *fp = mctx->dbg_fp;
 
 		mlx5_dbg(fp, MLX5_DBG_CQ_CQE, "dump cqe for cqn 0x%x:\n", cq->cqn);
 		dump_cqe(fp, cqe64);
 	}
 #endif
 
-	srqn = ntohl(cqe64->srqn) & 0xffffff;
 	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
-	if (srqn) {
-		if (!*cur_srq || (srqn != (*cur_srq)->srqn)) {
-			*cur_srq = mlx5_find_srq(to_mctx(cq->ibv_cq.context),
-						 srqn);
-			if (unlikely(!*cur_srq))
-				return CQ_POLL_ERR;
-		}
-	} else {
-		if (!*cur_qp || (qpn != (*cur_qp)->ibv_qp.qp_num)) {
-			/*
-			 * We do not have to take the QP table lock here,
-			 * because CQs will be locked while QPs are removed
-			 * from the table.
-			 */
-			*cur_qp = mlx5_find_qp(to_mctx(cq->ibv_cq.context),
-					       qpn);
-			if (unlikely(!*cur_qp))
-				return CQ_POLL_ERR;
-		}
-	}
-
 	wc->wc_flags = 0;
-	wc->qp_num = qpn;
 
-	opcode = cqe64->op_own >> 4;
 	switch (opcode) {
 	case MLX5_CQE_REQ:
-		wq = &(*cur_qp)->sq;
+		mqp = get_req_context(mctx, cur_rsc,
+				      (cqe_ver ? (ntohl(cqe64->srqn_uidx) & 0xffffff) : qpn),
+				      cqe_ver);
+		if (unlikely(!mqp))
+			return CQ_POLL_ERR;
+		wq = &mqp->sq;
 		wqe_ctr = ntohs(cqe64->wqe_counter);
 		idx = wqe_ctr & (wq->wqe_cnt - 1);
 		handle_good_req(wc, cqe64);
 		if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
-			err = mlx5_copy_to_send_wqe(*cur_qp, wqe_ctr, cqe,
+			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
 						    wc->byte_len);
 		else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
-			err = mlx5_copy_to_send_wqe(*cur_qp, wqe_ctr, cqe - 1,
+			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe - 1,
 						    wc->byte_len);
 		else
 			err = 0;
@@ -453,20 +534,35 @@ static int mlx5_poll_one(struct mlx5_cq *cq,
 	case MLX5_CQE_RESP_SEND:
 	case MLX5_CQE_RESP_SEND_IMM:
 	case MLX5_CQE_RESP_SEND_INV:
-		wc->status = handle_responder(wc, cqe64, *cur_qp,
-					      srqn ? *cur_srq : NULL);
+		srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
+		if (cqe_ver) {
+			err = get_resp_cxt_v1(mctx, cur_rsc, cur_srq, srqn_uidx, &is_srq);
+		} else {
+			if (srqn_uidx) {
+				err = get_srq_ctx(mctx, cur_srq, srqn_uidx);
+				is_srq = 1;
+			} else {
+				err = get_resp_ctx(mctx, cur_rsc, qpn);
+			}
+		}
+		if (unlikely(err))
+			return err;
+
+		wc->status = handle_responder(wc, cqe64, rsc_to_mqp(*cur_rsc),
+					      is_srq ? *cur_srq : NULL);
 		break;
 	case MLX5_CQE_RESIZE_CQ:
 		break;
 	case MLX5_CQE_REQ_ERR:
 	case MLX5_CQE_RESP_ERR:
+		srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
 		ecqe = (struct mlx5_err_cqe *)cqe64;
 		mlx5_handle_error_cqe(ecqe, wc);
 		if (unlikely(ecqe->syndrome != MLX5_CQE_SYNDROME_WR_FLUSH_ERR &&
 			     ecqe->syndrome != MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR)) {
-			FILE *fp = to_mctx(cq->ibv_cq.context)->dbg_fp;
+			FILE *fp = mctx->dbg_fp;
 			fprintf(fp, PFX "%s: got completion with error:\n",
-				to_mctx(cq->ibv_cq.context)->hostname);
+				mctx->hostname);
 			dump_cqe(fp, ecqe);
 			if (mlx5_freeze_on_error_cqe) {
 				fprintf(fp, PFX "freezing at poll cq...");
@@ -476,18 +572,35 @@ static int mlx5_poll_one(struct mlx5_cq *cq,
 		}
 
 		if (opcode == MLX5_CQE_REQ_ERR) {
-			wq = &(*cur_qp)->sq;
+			mqp = get_req_context(mctx, cur_rsc, (cqe_ver ? srqn_uidx : qpn), cqe_ver);
+			if (unlikely(!mqp))
+				return CQ_POLL_ERR;
+			wq = &mqp->sq;
 			wqe_ctr = ntohs(cqe64->wqe_counter);
 			idx = wqe_ctr & (wq->wqe_cnt - 1);
 			wc->wr_id = wq->wrid[idx];
 			wq->tail = wq->wqe_head[idx] + 1;
 		} else {
-			if (*cur_srq) {
+			if (cqe_ver) {
+				err = get_resp_cxt_v1(mctx, cur_rsc, cur_srq, srqn_uidx, &is_srq);
+			} else {
+				if (srqn_uidx) {
+					err = get_srq_ctx(mctx, cur_srq, srqn_uidx);
+					is_srq = 1;
+				} else {
+					err = get_resp_ctx(mctx, cur_rsc, qpn);
+				}
+			}
+			if (unlikely(err))
+				return CQ_POLL_ERR;
+
+			if (is_srq) {
 				wqe_ctr = ntohs(cqe64->wqe_counter);
 				wc->wr_id = (*cur_srq)->wrid[wqe_ctr];
 				mlx5_free_srq_wqe(*cur_srq, wqe_ctr);
 			} else {
-				wq = &(*cur_qp)->rq;
+				mqp = rsc_to_mqp(*cur_rsc);
+				wq = &mqp->rq;
 				wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 				++wq->tail;
 			}
@@ -495,13 +608,19 @@ static int mlx5_poll_one(struct mlx5_cq *cq,
 		break;
 	}
 
+	wc->qp_num = qpn;
+
 	return CQ_OK;
 }
 
-int mlx5_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
+static inline int poll_cq(struct ibv_cq *ibcq, int ne,
+		      struct ibv_wc *wc, int cqe_ver)
+		      __attribute__((always_inline));
+static inline int poll_cq(struct ibv_cq *ibcq, int ne,
+		      struct ibv_wc *wc, int cqe_ver)
 {
 	struct mlx5_cq *cq = to_mcq(ibcq);
-	struct mlx5_qp *qp = NULL;
+	struct mlx5_resource *rsc = NULL;
 	struct mlx5_srq *srq = NULL;
 	int npolled;
 	int err = CQ_OK;
@@ -519,7 +638,7 @@ int mlx5_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	mlx5_spin_lock(&cq->lock);
 
 	for (npolled = 0; npolled < ne; ++npolled) {
-		err = mlx5_poll_one(cq, &qp, &srq, wc + npolled);
+		err = mlx5_poll_one(cq, &rsc, &srq, wc + npolled, cqe_ver);
 		if (err != CQ_OK)
 			break;
 	}
@@ -551,6 +670,16 @@ int mlx5_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	return err == CQ_POLL_ERR ? err : npolled;
 }
 
+int mlx5_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
+{
+	return poll_cq(ibcq, ne, wc, 0);
+}
+
+int mlx5_poll_cq_v1(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
+{
+	return poll_cq(ibcq, ne, wc, 1);
+}
+
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx5_cq *cq = to_mcq(ibvcq);
@@ -622,7 +751,7 @@ void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t rsn, struct mlx5_srq *srq)
 		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
 		cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
 		if (is_equal_rsn(cqe64, rsn)) {
-			if (srq && (ntohl(cqe64->srqn) & 0xffffff))
+			if (srq && (ntohl(cqe64->srqn_uidx) & 0xffffff))
 				mlx5_free_srq_wqe(srq, ntohs(cqe64->wqe_counter));
 			++nfreed;
 		} else if (nfreed) {
diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 9c6ec7c..28490a5 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -70,7 +70,8 @@ struct mlx5_alloc_ucontext_resp {
 	__u32				max_recv_wr;
 	__u32				max_srq_recv_wr;
 	__u16				num_ports;
-	__u16				reserved;
+	__u8				cqe_version;
+	__u8				reserved[5];
 };
 
 struct mlx5_alloc_pd_resp {
diff --git a/src/mlx5.h b/src/mlx5.h
index 17ef51c..ce2e581 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -306,6 +306,7 @@ struct mlx5_context {
 	char				hostname[40];
 	struct mlx5_spinlock            hugetlb_lock;
 	struct list_head                hugetlb_list;
+	uint8_t				cqe_version;
 };
 
 struct mlx5_bitmap {
@@ -544,6 +545,16 @@ static inline int max_int(int a, int b)
 	return a > b ? a : b;
 }
 
+static inline struct mlx5_qp *rsc_to_mqp(struct mlx5_resource *rsc)
+{
+	return (struct mlx5_qp *)rsc;
+}
+
+static inline struct mlx5_srq *rsc_to_msrq(struct mlx5_resource *rsc)
+{
+	return (struct mlx5_srq *)rsc;
+}
+
 int mlx5_alloc_buf(struct mlx5_buf *buf, size_t size, int page_size);
 void mlx5_free_buf(struct mlx5_buf *buf);
 int mlx5_alloc_buf_contig(struct mlx5_context *mctx, struct mlx5_buf *buf,
@@ -586,6 +597,7 @@ int mlx5_free_cq_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
 int mlx5_resize_cq(struct ibv_cq *cq, int cqe);
 int mlx5_destroy_cq(struct ibv_cq *cq);
 int mlx5_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
+int mlx5_poll_cq_v1(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int mlx5_arm_cq(struct ibv_cq *cq, int solicited);
 void mlx5_cq_event(struct ibv_cq *cq);
 void __mlx5_cq_clean(struct mlx5_cq *cq, uint32_t qpn, struct mlx5_srq *srq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
