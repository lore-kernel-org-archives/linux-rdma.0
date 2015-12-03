From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 V1 1/6] Add ibv_poll_cq_ex support
Date: Thu,  3 Dec 2015 18:02:46 +0200
Message-ID: <1449158571-26228-2-git-send-email-matanb@mellanox.com>
References: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449158571-26228-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Extended poll_cq supports writing only user's required work completion
fields. Adding support for this extended verb.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c   | 699 +++++++++++++++++++++++++++++++++++++++++++++++++------------
 src/mlx5.c |   5 +
 src/mlx5.h |  14 ++
 3 files changed, 584 insertions(+), 134 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 32f0dd4..0185696 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -200,6 +200,85 @@ static void handle_good_req(struct ibv_wc *wc, struct mlx5_cqe64 *cqe)
 	}
 }
 
+union wc_buffer {
+	uint8_t		*b8;
+	uint16_t	*b16;
+	uint32_t	*b32;
+	uint64_t	*b64;
+};
+
+static inline void handle_good_req_ex(struct ibv_wc_ex *wc_ex,
+				      union wc_buffer *pwc_buffer,
+				      struct mlx5_cqe64 *cqe,
+				      uint64_t wc_flags,
+				      uint32_t qpn)
+{
+	union wc_buffer wc_buffer = *pwc_buffer;
+
+	switch (ntohl(cqe->sop_drop_qpn) >> 24) {
+	case MLX5_OPCODE_RDMA_WRITE_IMM:
+		wc_ex->wc_flags |= IBV_WC_EX_IMM;
+	case MLX5_OPCODE_RDMA_WRITE:
+		wc_ex->opcode    = IBV_WC_RDMA_WRITE;
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	case MLX5_OPCODE_SEND_IMM:
+		wc_ex->wc_flags |= IBV_WC_EX_IMM;
+	case MLX5_OPCODE_SEND:
+	case MLX5_OPCODE_SEND_INVAL:
+		wc_ex->opcode    = IBV_WC_SEND;
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	case MLX5_OPCODE_RDMA_READ:
+		wc_ex->opcode    = IBV_WC_RDMA_READ;
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			*wc_buffer.b32++ = ntohl(cqe->byte_cnt);
+			wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	case MLX5_OPCODE_ATOMIC_CS:
+		wc_ex->opcode    = IBV_WC_COMP_SWAP;
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			*wc_buffer.b32++ = 8;
+			wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	case MLX5_OPCODE_ATOMIC_FA:
+		wc_ex->opcode    = IBV_WC_FETCH_ADD;
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			*wc_buffer.b32++ = 8;
+			wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	case MLX5_OPCODE_BIND_MW:
+		wc_ex->opcode    = IBV_WC_BIND_MW;
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	}
+
+	if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+		*wc_buffer.b32++ = qpn;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_QP_NUM;
+	}
+
+	*pwc_buffer = wc_buffer;
+}
+
 static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 			    struct mlx5_qp *qp, struct mlx5_srq *srq)
 {
@@ -262,6 +341,103 @@ static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 	return IBV_WC_SUCCESS;
 }
 
+static inline int handle_responder_ex(struct ibv_wc_ex *wc_ex,
+				      union wc_buffer *pwc_buffer,
+				      struct mlx5_cqe64 *cqe,
+				      struct mlx5_qp *qp, struct mlx5_srq *srq,
+				      uint64_t wc_flags, uint32_t qpn)
+{
+	uint16_t wqe_ctr;
+	struct mlx5_wq *wq;
+	uint8_t g;
+	union wc_buffer wc_buffer = *pwc_buffer;
+	int err = 0;
+	uint32_t byte_len = ntohl(cqe->byte_cnt);
+
+	if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+		*wc_buffer.b32++ = byte_len;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+	}
+	if (srq) {
+		wqe_ctr = ntohs(cqe->wqe_counter);
+		wc_ex->wr_id = srq->wrid[wqe_ctr];
+		mlx5_free_srq_wqe(srq, wqe_ctr);
+		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe,
+						    byte_len);
+		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe - 1,
+						    byte_len);
+	} else {
+		wq	  = &qp->rq;
+		wqe_ctr = wq->tail & (wq->wqe_cnt - 1);
+		wc_ex->wr_id = wq->wrid[wqe_ctr];
+		++wq->tail;
+		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe,
+						    byte_len);
+		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
+						    byte_len);
+	}
+	if (err)
+		return err;
+
+	switch (cqe->op_own >> 4) {
+	case MLX5_CQE_RESP_WR_IMM:
+		wc_ex->opcode	= IBV_WC_RECV_RDMA_WITH_IMM;
+		wc_ex->wc_flags	= IBV_WC_EX_IMM;
+		if (wc_flags & IBV_WC_EX_WITH_IMM) {
+			*wc_buffer.b32++ = ntohl(cqe->byte_cnt);
+			wc_ex->wc_flags |= IBV_WC_EX_WITH_IMM;
+		}
+		break;
+	case MLX5_CQE_RESP_SEND:
+		wc_ex->opcode   = IBV_WC_RECV;
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		break;
+	case MLX5_CQE_RESP_SEND_IMM:
+		wc_ex->opcode	= IBV_WC_RECV;
+		wc_ex->wc_flags	= IBV_WC_EX_WITH_IMM;
+		if (wc_flags & IBV_WC_EX_WITH_IMM) {
+			*wc_buffer.b32++ = ntohl(cqe->imm_inval_pkey);
+			wc_ex->wc_flags |= IBV_WC_EX_WITH_IMM;
+		}
+		break;
+	}
+	if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+		*wc_buffer.b32++ = qpn;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_QP_NUM;
+	}
+	if (wc_flags & IBV_WC_EX_WITH_SRC_QP) {
+		*wc_buffer.b32++ = ntohl(cqe->flags_rqpn) & 0xffffff;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_SRC_QP;
+	}
+	if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX) {
+		*wc_buffer.b16++ = ntohl(cqe->imm_inval_pkey) & 0xffff;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_PKEY_INDEX;
+	}
+	if (wc_flags & IBV_WC_EX_WITH_SLID) {
+		*wc_buffer.b16++ = ntohs(cqe->slid);
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_SLID;
+	}
+	if (wc_flags & IBV_WC_EX_WITH_SL) {
+		*wc_buffer.b8++ = (ntohl(cqe->flags_rqpn) >> 24) & 0xf;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_SL;
+	}
+	if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS) {
+		*wc_buffer.b8++ = cqe->ml_path & 0x7f;
+		wc_ex->wc_flags |= IBV_WC_EX_WITH_DLID_PATH_BITS;
+	}
+
+	g = (ntohl(cqe->flags_rqpn) >> 28) & 3;
+	wc_ex->wc_flags |= g ? IBV_WC_EX_GRH : 0;
+
+	*pwc_buffer = wc_buffer;
+	return IBV_WC_SUCCESS;
+}
+
 static void dump_cqe(FILE *fp, void *buf)
 {
 	uint32_t *p = buf;
@@ -273,54 +449,55 @@ static void dump_cqe(FILE *fp, void *buf)
 }
 
 static void mlx5_handle_error_cqe(struct mlx5_err_cqe *cqe,
-				  struct ibv_wc *wc)
+				  uint32_t *pwc_status,
+				  uint32_t *pwc_vendor_err)
 {
 	switch (cqe->syndrome) {
 	case MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR:
-		wc->status = IBV_WC_LOC_LEN_ERR;
+		*pwc_status = IBV_WC_LOC_LEN_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR:
-		wc->status = IBV_WC_LOC_QP_OP_ERR;
+		*pwc_status = IBV_WC_LOC_QP_OP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_PROT_ERR:
-		wc->status = IBV_WC_LOC_PROT_ERR;
+		*pwc_status = IBV_WC_LOC_PROT_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_WR_FLUSH_ERR:
-		wc->status = IBV_WC_WR_FLUSH_ERR;
+		*pwc_status = IBV_WC_WR_FLUSH_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_MW_BIND_ERR:
-		wc->status = IBV_WC_MW_BIND_ERR;
+		*pwc_status = IBV_WC_MW_BIND_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_BAD_RESP_ERR:
-		wc->status = IBV_WC_BAD_RESP_ERR;
+		*pwc_status = IBV_WC_BAD_RESP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_ACCESS_ERR:
-		wc->status = IBV_WC_LOC_ACCESS_ERR;
+		*pwc_status = IBV_WC_LOC_ACCESS_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
-		wc->status = IBV_WC_REM_INV_REQ_ERR;
+		*pwc_status = IBV_WC_REM_INV_REQ_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR:
-		wc->status = IBV_WC_REM_ACCESS_ERR;
+		*pwc_status = IBV_WC_REM_ACCESS_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_OP_ERR:
-		wc->status = IBV_WC_REM_OP_ERR;
+		*pwc_status = IBV_WC_REM_OP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RETRY_EXC_ERR;
+		*pwc_status = IBV_WC_RETRY_EXC_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_RNR_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RNR_RETRY_EXC_ERR;
+		*pwc_status = IBV_WC_RNR_RETRY_EXC_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_ABORTED_ERR:
-		wc->status = IBV_WC_REM_ABORT_ERR;
+		*pwc_status = IBV_WC_REM_ABORT_ERR;
 		break;
 	default:
-		wc->status = IBV_WC_GENERAL_ERR;
+		*pwc_status = IBV_WC_GENERAL_ERR;
 		break;
 	}
 
-	wc->vendor_err = cqe->vendor_err_synd;
+	*pwc_vendor_err = cqe->vendor_err_synd;
 }
 
 #if defined(__x86_64__) || defined (__i386__)
@@ -453,6 +630,171 @@ static inline int get_srq_ctx(struct mlx5_context *mctx,
 	return CQ_OK;
 }
 
+static inline void dump_cqe_debug(FILE *fp, struct mlx5_cqe64 *cqe64)
+	__attribute__((always_inline));
+static inline void dump_cqe_debug(FILE *fp, struct mlx5_cqe64 *cqe64)
+{
+#ifdef MLX5_DEBUG
+	if (mlx5_debug_mask & MLX5_DBG_CQ_CQE) {
+		mlx5_dbg(fp, MLX5_DBG_CQ_CQE, "dump cqe for cqn 0x%x:\n", cq->cqn);
+		dump_cqe(fp, cqe64);
+	}
+#endif
+}
+
+inline int mlx5_poll_one_cqe_req(struct mlx5_cq *cq,
+				 struct mlx5_resource **cur_rsc,
+				 void *cqe, uint32_t qpn, int cqe_ver,
+				 uint64_t *wr_id) __attribute__((always_inline));
+inline int mlx5_poll_one_cqe_req(struct mlx5_cq *cq,
+				 struct mlx5_resource **cur_rsc,
+				 void *cqe, uint32_t qpn, int cqe_ver,
+				 uint64_t *wr_id)
+{
+	struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
+	struct mlx5_qp *mqp = NULL;
+	struct mlx5_cqe64 *cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
+	uint32_t byte_len = ntohl(cqe64->byte_cnt);
+	struct mlx5_wq *wq;
+	uint16_t wqe_ctr;
+	int err;
+	int idx;
+
+	mqp = get_req_context(mctx, cur_rsc,
+			      (cqe_ver ? (ntohl(cqe64->srqn_uidx) & 0xffffff) : qpn),
+			      cqe_ver);
+	if (unlikely(!mqp))
+		return CQ_POLL_ERR;
+	wq = &mqp->sq;
+	wqe_ctr = ntohs(cqe64->wqe_counter);
+	idx = wqe_ctr & (wq->wqe_cnt - 1);
+	if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
+		err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
+					    byte_len);
+	else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
+		err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe - 1,
+					    byte_len);
+	else
+		err = 0;
+
+	wq->tail = wq->wqe_head[idx] + 1;
+	*wr_id = wq->wrid[idx];
+
+	return err;
+}
+
+inline int mlx5_poll_one_cqe_resp(struct mlx5_context *mctx,
+				  struct mlx5_resource **cur_rsc,
+				  struct mlx5_srq **cur_srq,
+				  struct mlx5_cqe64 *cqe64, int cqe_ver,
+				  uint32_t qpn, int *is_srq)
+	__attribute__((always_inline));
+inline int mlx5_poll_one_cqe_resp(struct mlx5_context *mctx,
+				  struct mlx5_resource **cur_rsc,
+				  struct mlx5_srq **cur_srq,
+				  struct mlx5_cqe64 *cqe64, int cqe_ver,
+				  uint32_t qpn, int *is_srq)
+{
+	uint32_t srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
+	int err;
+
+	if (cqe_ver) {
+		err = get_resp_cxt_v1(mctx, cur_rsc, cur_srq, srqn_uidx, is_srq);
+	} else {
+		if (srqn_uidx) {
+			err = get_srq_ctx(mctx, cur_srq, srqn_uidx);
+			*is_srq = 1;
+		} else {
+			err = get_resp_ctx(mctx, cur_rsc, qpn);
+		}
+	}
+
+	return err;
+}
+
+inline int mlx5_poll_one_cqe_err(struct mlx5_context *mctx,
+				 struct mlx5_resource **cur_rsc,
+				 struct mlx5_srq **cur_srq,
+				 struct mlx5_cqe64 *cqe64, int cqe_ver,
+				 uint32_t qpn, uint32_t *pwc_status,
+				 uint32_t *pwc_vendor_err,
+				 uint64_t *pwc_wr_id, uint8_t opcode)
+	__attribute__((always_inline));
+inline int mlx5_poll_one_cqe_err(struct mlx5_context *mctx,
+				 struct mlx5_resource **cur_rsc,
+				 struct mlx5_srq **cur_srq,
+				 struct mlx5_cqe64 *cqe64, int cqe_ver,
+				 uint32_t qpn, uint32_t *pwc_status,
+				 uint32_t *pwc_vendor_err,
+				 uint64_t *pwc_wr_id, uint8_t opcode)
+{
+	uint32_t srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
+	struct mlx5_err_cqe *ecqe = (struct mlx5_err_cqe *)cqe64;
+	int err = CQ_OK;
+
+	mlx5_handle_error_cqe(ecqe, pwc_status, pwc_vendor_err);
+	if (unlikely(ecqe->syndrome != MLX5_CQE_SYNDROME_WR_FLUSH_ERR &&
+		     ecqe->syndrome != MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR)) {
+		FILE *fp = mctx->dbg_fp;
+
+		fprintf(fp, PFX "%s: got completion with error:\n",
+			mctx->hostname);
+		dump_cqe(fp, ecqe);
+		if (mlx5_freeze_on_error_cqe) {
+			fprintf(fp, PFX "freezing at poll cq...");
+			while (1)
+				sleep(10);
+		}
+	}
+
+	if (opcode == MLX5_CQE_REQ_ERR) {
+		struct mlx5_qp *mqp = NULL;
+		struct mlx5_wq *wq;
+		uint16_t wqe_ctr;
+		int idx;
+
+		mqp = get_req_context(mctx, cur_rsc, (cqe_ver ? srqn_uidx : qpn), cqe_ver);
+		if (unlikely(!mqp))
+			return CQ_POLL_ERR;
+		wq = &mqp->sq;
+		wqe_ctr = ntohs(cqe64->wqe_counter);
+		idx = wqe_ctr & (wq->wqe_cnt - 1);
+		*pwc_wr_id = wq->wrid[idx];
+		wq->tail = wq->wqe_head[idx] + 1;
+	} else {
+		int is_srq = 0;
+
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
+			return CQ_POLL_ERR;
+
+		if (is_srq) {
+			uint16_t wqe_ctr = ntohs(cqe64->wqe_counter);
+
+			*pwc_wr_id = (*cur_srq)->wrid[wqe_ctr];
+			mlx5_free_srq_wqe(*cur_srq, wqe_ctr);
+		} else {
+			struct mlx5_qp *mqp = rsc_to_mqp(*cur_rsc);
+			struct mlx5_wq *wq;
+
+			wq = &mqp->rq;
+			*pwc_wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+			++wq->tail;
+		}
+	}
+
+	return err;
+}
+
 static inline int mlx5_poll_one(struct mlx5_cq *cq,
 			 struct mlx5_resource **cur_rsc,
 			 struct mlx5_srq **cur_srq,
@@ -464,17 +806,10 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 			 struct ibv_wc *wc, int cqe_ver)
 {
 	struct mlx5_cqe64 *cqe64;
-	struct mlx5_wq *wq;
-	uint16_t wqe_ctr;
 	void *cqe;
 	uint32_t qpn;
-	uint32_t srqn_uidx;
-	int idx;
 	uint8_t opcode;
-	struct mlx5_err_cqe *ecqe;
 	int err;
-	int is_srq = 0;
-	struct mlx5_qp *mqp = NULL;
 	struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
 
 	cqe = next_cqe_sw(cq);
@@ -494,137 +829,165 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 	 */
 	rmb();
 
-#ifdef MLX5_DEBUG
-	if (mlx5_debug_mask & MLX5_DBG_CQ_CQE) {
-		FILE *fp = mctx->dbg_fp;
-
-		mlx5_dbg(fp, MLX5_DBG_CQ_CQE, "dump cqe for cqn 0x%x:\n", cq->cqn);
-		dump_cqe(fp, cqe64);
-	}
-#endif
+	dump_cqe_debug(mctx->dbg_fp, cqe64);
 
 	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
 	wc->wc_flags = 0;
 
 	switch (opcode) {
 	case MLX5_CQE_REQ:
-		mqp = get_req_context(mctx, cur_rsc,
-				      (cqe_ver ? (ntohl(cqe64->srqn_uidx) & 0xffffff) : qpn),
-				      cqe_ver);
-		if (unlikely(!mqp))
-			return CQ_POLL_ERR;
-		wq = &mqp->sq;
-		wqe_ctr = ntohs(cqe64->wqe_counter);
-		idx = wqe_ctr & (wq->wqe_cnt - 1);
+		err = mlx5_poll_one_cqe_req(cq, cur_rsc, cqe, qpn, cqe_ver,
+					    &wc->wr_id);
 		handle_good_req(wc, cqe64);
-		if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
-			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
-						    wc->byte_len);
-		else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
-			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe - 1,
-						    wc->byte_len);
-		else
-			err = 0;
-
-		wc->wr_id = wq->wrid[idx];
-		wq->tail = wq->wqe_head[idx] + 1;
 		wc->status = err;
 		break;
+
 	case MLX5_CQE_RESP_WR_IMM:
 	case MLX5_CQE_RESP_SEND:
 	case MLX5_CQE_RESP_SEND_IMM:
-	case MLX5_CQE_RESP_SEND_INV:
-		srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
-		if (cqe_ver) {
-			err = get_resp_cxt_v1(mctx, cur_rsc, cur_srq, srqn_uidx, &is_srq);
-		} else {
-			if (srqn_uidx) {
-				err = get_srq_ctx(mctx, cur_srq, srqn_uidx);
-				is_srq = 1;
-			} else {
-				err = get_resp_ctx(mctx, cur_rsc, qpn);
-			}
-		}
+	case MLX5_CQE_RESP_SEND_INV: {
+		int is_srq;
+
+		err = mlx5_poll_one_cqe_resp(mctx, cur_rsc, cur_srq, cqe64,
+					     cqe_ver, qpn, &is_srq);
 		if (unlikely(err))
 			return err;
 
 		wc->status = handle_responder(wc, cqe64, rsc_to_mqp(*cur_rsc),
 					      is_srq ? *cur_srq : NULL);
 		break;
+	}
 	case MLX5_CQE_RESIZE_CQ:
 		break;
 	case MLX5_CQE_REQ_ERR:
 	case MLX5_CQE_RESP_ERR:
-		srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
-		ecqe = (struct mlx5_err_cqe *)cqe64;
-		mlx5_handle_error_cqe(ecqe, wc);
-		if (unlikely(ecqe->syndrome != MLX5_CQE_SYNDROME_WR_FLUSH_ERR &&
-			     ecqe->syndrome != MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR)) {
-			FILE *fp = mctx->dbg_fp;
-			fprintf(fp, PFX "%s: got completion with error:\n",
-				mctx->hostname);
-			dump_cqe(fp, ecqe);
-			if (mlx5_freeze_on_error_cqe) {
-				fprintf(fp, PFX "freezing at poll cq...");
-				while (1)
-					sleep(10);
-			}
-		}
+		err = mlx5_poll_one_cqe_err(mctx, cur_rsc, cur_srq, cqe64,
+					    cqe_ver, qpn, &wc->status,
+					    &wc->vendor_err, &wc->wr_id,
+					    opcode);
+		if (err != CQ_OK)
+			return err;
+		break;
+	}
 
-		if (opcode == MLX5_CQE_REQ_ERR) {
-			mqp = get_req_context(mctx, cur_rsc, (cqe_ver ? srqn_uidx : qpn), cqe_ver);
-			if (unlikely(!mqp))
-				return CQ_POLL_ERR;
-			wq = &mqp->sq;
-			wqe_ctr = ntohs(cqe64->wqe_counter);
-			idx = wqe_ctr & (wq->wqe_cnt - 1);
-			wc->wr_id = wq->wrid[idx];
-			wq->tail = wq->wqe_head[idx] + 1;
-		} else {
-			if (cqe_ver) {
-				err = get_resp_cxt_v1(mctx, cur_rsc, cur_srq, srqn_uidx, &is_srq);
-			} else {
-				if (srqn_uidx) {
-					err = get_srq_ctx(mctx, cur_srq, srqn_uidx);
-					is_srq = 1;
-				} else {
-					err = get_resp_ctx(mctx, cur_rsc, qpn);
-				}
-			}
-			if (unlikely(err))
-				return CQ_POLL_ERR;
+	wc->qp_num = qpn;
+	return CQ_OK;
+}
 
-			if (is_srq) {
-				wqe_ctr = ntohs(cqe64->wqe_counter);
-				wc->wr_id = (*cur_srq)->wrid[wqe_ctr];
-				mlx5_free_srq_wqe(*cur_srq, wqe_ctr);
-			} else {
-				mqp = rsc_to_mqp(*cur_rsc);
-				wq = &mqp->rq;
-				wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
-				++wq->tail;
-			}
-		}
+inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
+			    struct mlx5_resource **cur_rsc,
+			    struct mlx5_srq **cur_srq,
+			    struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+			    int cqe_ver)
+{
+	struct mlx5_cqe64 *cqe64;
+	void *cqe;
+	uint32_t qpn;
+	uint8_t opcode;
+	int err;
+	struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
+	struct ibv_wc_ex *wc_ex = *pwc_ex;
+	union wc_buffer wc_buffer;
+
+	cqe = next_cqe_sw(cq);
+	if (!cqe)
+		return CQ_EMPTY;
+
+	cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
+
+	opcode = cqe64->op_own >> 4;
+	++cq->cons_index;
+
+	VALGRIND_MAKE_MEM_DEFINED(cqe64, sizeof *cqe64);
+
+	/*
+	 * Make sure we read CQ entry contents after we've checked the
+	 * ownership bit.
+	 */
+	rmb();
+
+	dump_cqe_debug(mctx->dbg_fp, cqe64);
+
+	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
+	wc_buffer.b64 = (uint64_t *)&wc_ex->buffer;
+	wc_ex->wc_flags = 0;
+	wc_ex->reserved = 0;
+
+	switch (opcode) {
+	case MLX5_CQE_REQ:
+		err = mlx5_poll_one_cqe_req(cq, cur_rsc, cqe, qpn, cqe_ver,
+					    &wc_ex->wr_id);
+		handle_good_req_ex(wc_ex, &wc_buffer, cqe64, wc_flags, qpn);
+		wc_ex->status = err;
+		if (wc_flags & IBV_WC_EX_WITH_SRC_QP)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX)
+			wc_buffer.b16++;
+		if (wc_flags & IBV_WC_EX_WITH_SLID)
+			wc_buffer.b16++;
+		if (wc_flags & IBV_WC_EX_WITH_SL)
+			wc_buffer.b8++;
+		if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS)
+			wc_buffer.b8++;
+		break;
+
+	case MLX5_CQE_RESP_WR_IMM:
+	case MLX5_CQE_RESP_SEND:
+	case MLX5_CQE_RESP_SEND_IMM:
+	case MLX5_CQE_RESP_SEND_INV: {
+		int is_srq;
+
+		err = mlx5_poll_one_cqe_resp(mctx, cur_rsc, cur_srq, cqe64,
+					     cqe_ver, qpn, &is_srq);
+		if (unlikely(err))
+			return err;
+
+		wc_ex->status = handle_responder_ex(wc_ex, &wc_buffer, cqe64,
+						    rsc_to_mqp(*cur_rsc),
+						    is_srq ? *cur_srq : NULL,
+						    wc_flags, qpn);
 		break;
 	}
+	case MLX5_CQE_REQ_ERR:
+	case MLX5_CQE_RESP_ERR:
+		err = mlx5_poll_one_cqe_err(mctx, cur_rsc, cur_srq, cqe64,
+					    cqe_ver, qpn, &wc_ex->status,
+					    &wc_ex->vendor_err, &wc_ex->wr_id,
+					    opcode);
+		if (err != CQ_OK)
+			return err;
 
-	wc->qp_num = qpn;
+	case MLX5_CQE_RESIZE_CQ:
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_IMM)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+			*wc_buffer.b32++ = qpn;
+			wc_ex->wc_flags |= IBV_WC_EX_WITH_QP_NUM;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_SRC_QP)
+			wc_buffer.b32++;
+		if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX)
+			wc_buffer.b16++;
+		if (wc_flags & IBV_WC_EX_WITH_SLID)
+			wc_buffer.b16++;
+		if (wc_flags & IBV_WC_EX_WITH_SL)
+			wc_buffer.b8++;
+		if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS)
+			wc_buffer.b8++;
+		break;
+	}
 
+	*pwc_ex = (struct ibv_wc_ex *)((uintptr_t)(wc_buffer.b8 + sizeof(uint64_t) - 1) &
+				       ~(sizeof(uint64_t) - 1));
 	return CQ_OK;
 }
 
-static inline int poll_cq(struct ibv_cq *ibcq, int ne,
-		      struct ibv_wc *wc, int cqe_ver)
-		      __attribute__((always_inline));
-static inline int poll_cq(struct ibv_cq *ibcq, int ne,
-		      struct ibv_wc *wc, int cqe_ver)
+static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
+__attribute__((always_inline));
+static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
 {
-	struct mlx5_cq *cq = to_mcq(ibcq);
-	struct mlx5_resource *rsc = NULL;
-	struct mlx5_srq *srq = NULL;
-	int npolled;
-	int err = CQ_OK;
-
 	if (cq->stall_enable) {
 		if (cq->stall_adaptive_enable) {
 			if (cq->stall_last_count)
@@ -634,19 +997,13 @@ static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 			mlx5_stall_poll_cq();
 		}
 	}
+}
 
-	mlx5_spin_lock(&cq->lock);
-
-	for (npolled = 0; npolled < ne; ++npolled) {
-		err = mlx5_poll_one(cq, &rsc, &srq, wc + npolled, cqe_ver);
-		if (err != CQ_OK)
-			break;
-	}
-
-	update_cons_index(cq);
-
-	mlx5_spin_unlock(&cq->lock);
-
+static inline void mlx5_poll_cq_stall_end(struct mlx5_cq *cq, int ne,
+					  int npolled, int err) __attribute__((always_inline));
+static inline void mlx5_poll_cq_stall_end(struct mlx5_cq *cq, int ne,
+					  int npolled, int err)
+{
 	if (cq->stall_enable) {
 		if (cq->stall_adaptive_enable) {
 			if (npolled == 0) {
@@ -666,6 +1023,34 @@ static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 			cq->stall_next_poll = 1;
 		}
 	}
+}
+
+static inline int poll_cq(struct ibv_cq *ibcq, int ne,
+			  struct ibv_wc *wc, int cqe_ver)
+	__attribute__((always_inline));
+static inline int poll_cq(struct ibv_cq *ibcq, int ne,
+			  struct ibv_wc *wc, int cqe_ver)
+{
+	struct mlx5_cq *cq = to_mcq(ibcq);
+	struct mlx5_resource *rsc = NULL;
+	struct mlx5_srq *srq = NULL;
+	int npolled;
+	int err = CQ_OK;
+
+	mlx5_poll_cq_stall_start(cq);
+	mlx5_spin_lock(&cq->lock);
+
+	for (npolled = 0; npolled < ne; ++npolled) {
+		err = mlx5_poll_one(cq, &rsc, &srq, wc + npolled, cqe_ver);
+		if (err != CQ_OK)
+			break;
+	}
+
+	update_cons_index(cq);
+
+	mlx5_spin_unlock(&cq->lock);
+
+	mlx5_poll_cq_stall_end(cq, ne, npolled, err);
 
 	return err == CQ_POLL_ERR ? err : npolled;
 }
@@ -680,6 +1065,52 @@ int mlx5_poll_cq_v1(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	return poll_cq(ibcq, ne, wc, 1);
 }
 
+static inline int poll_cq_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
+			     struct ibv_poll_cq_ex_attr *attr, int cqe_ver)
+{
+	struct mlx5_cq *cq = to_mcq(ibcq);
+	struct mlx5_resource *rsc = NULL;
+	struct mlx5_srq *srq = NULL;
+	int npolled;
+	int err = CQ_OK;
+	int (*poll_fn)(struct mlx5_cq *cq, struct mlx5_resource **rsc,
+		       struct mlx5_srq **cur_srq,
+		       struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+		       int cqe_ver) =
+		cq->poll_one;
+	uint64_t wc_flags = cq->wc_flags;
+	unsigned int ne = attr->max_entries;
+
+	mlx5_poll_cq_stall_start(cq);
+	mlx5_spin_lock(&cq->lock);
+
+	for (npolled = 0; npolled < ne; ++npolled) {
+		err = poll_fn(cq, &rsc, &srq, &wc, wc_flags, cqe_ver);
+		if (err != CQ_OK)
+			break;
+	}
+
+	update_cons_index(cq);
+
+	mlx5_spin_unlock(&cq->lock);
+
+	mlx5_poll_cq_stall_end(cq, ne, npolled, err);
+
+	return err == CQ_POLL_ERR ? err : npolled;
+}
+
+int mlx5_poll_cq_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
+		    struct ibv_poll_cq_ex_attr *attr)
+{
+	return poll_cq_ex(ibcq, wc, attr, 0);
+}
+
+int mlx5_poll_cq_v1_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
+		       struct ibv_poll_cq_ex_attr *attr)
+{
+	return poll_cq_ex(ibcq, wc, attr, 1);
+}
+
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx5_cq *cq = to_mcq(ibvcq);
diff --git a/src/mlx5.c b/src/mlx5.c
index 5e9b61c..eac332b 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -664,6 +664,11 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
+	if (context->cqe_version && context->cqe_version == 1)
+		verbs_set_ctx_op(v_ctx, poll_cq_ex, mlx5_poll_cq_v1_ex);
+	else
+		verbs_set_ctx_op(v_ctx, poll_cq_ex, mlx5_poll_cq_ex);
+
 
 	return 0;
 
diff --git a/src/mlx5.h b/src/mlx5.h
index b57c7c7..91aafbe 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -345,6 +345,11 @@ enum {
 
 struct mlx5_cq {
 	struct ibv_cq			ibv_cq;
+	uint64_t			wc_flags;
+	int (*poll_one)(struct mlx5_cq *cq, struct mlx5_resource **cur_rsc,
+			struct mlx5_srq **cur_srq,
+			struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+			int cqe_ver);
 	struct mlx5_buf			buf_a;
 	struct mlx5_buf			buf_b;
 	struct mlx5_buf		       *active_buf;
@@ -595,6 +600,15 @@ int mlx5_dereg_mr(struct ibv_mr *mr);
 struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
+int mlx5_poll_cq_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
+		    struct ibv_poll_cq_ex_attr *attr);
+int mlx5_poll_cq_v1_ex(struct ibv_cq *ibcq, struct ibv_wc_ex *wc,
+		       struct ibv_poll_cq_ex_attr *attr);
+int mlx5_poll_one_ex(struct mlx5_cq *cq,
+		     struct mlx5_resource **cur_rsc,
+		     struct mlx5_srq **cur_srq,
+		     struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+		     int cqe_ver);
 int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 		      struct mlx5_buf *buf, int nent, int cqe_sz);
 int mlx5_free_cq_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
