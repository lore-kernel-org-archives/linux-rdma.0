From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/7] Implement ibv_poll_cq_ex extension verb
Date: Tue, 27 Oct 2015 18:52:31 +0200
Message-ID: <1445964755-13371-4-git-send-email-matanb@mellanox.com>
References: <1445964755-13371-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445964755-13371-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an implementation for verb_poll_cq extension verb.
This patch implements the new API via the standard
function mlx4_poll_one.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 src/mlx4.c  |   1 +
 src/mlx4.h  |   4 +
 src/verbs.c |   1 +
 4 files changed, 284 insertions(+), 29 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 32c9070..c86e824 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -52,6 +52,7 @@ enum {
 };
 
 enum {
+	CQ_CONTINUE				=  1,
 	CQ_OK					=  0,
 	CQ_EMPTY				= -1,
 	CQ_POLL_ERR				= -2
@@ -121,7 +122,9 @@ static void update_cons_index(struct mlx4_cq *cq)
 	*cq->set_ci_db = htonl(cq->cons_index & 0xffffff);
 }
 
-static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe, struct ibv_wc *wc)
+static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe,
+				  enum ibv_wc_status *status,
+				  enum ibv_wc_opcode *vendor_err)
 {
 	if (cqe->syndrome == MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR)
 		printf(PFX "local QP operation err "
@@ -133,64 +136,68 @@ static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe, struct ibv_wc *wc)
 
 	switch (cqe->syndrome) {
 	case MLX4_CQE_SYNDROME_LOCAL_LENGTH_ERR:
-		wc->status = IBV_WC_LOC_LEN_ERR;
+		*status = IBV_WC_LOC_LEN_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR:
-		wc->status = IBV_WC_LOC_QP_OP_ERR;
+		*status = IBV_WC_LOC_QP_OP_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_LOCAL_PROT_ERR:
-		wc->status = IBV_WC_LOC_PROT_ERR;
+		*status = IBV_WC_LOC_PROT_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_WR_FLUSH_ERR:
-		wc->status = IBV_WC_WR_FLUSH_ERR;
+		*status = IBV_WC_WR_FLUSH_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_MW_BIND_ERR:
-		wc->status = IBV_WC_MW_BIND_ERR;
+		*status = IBV_WC_MW_BIND_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_BAD_RESP_ERR:
-		wc->status = IBV_WC_BAD_RESP_ERR;
+		*status = IBV_WC_BAD_RESP_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_LOCAL_ACCESS_ERR:
-		wc->status = IBV_WC_LOC_ACCESS_ERR;
+		*status = IBV_WC_LOC_ACCESS_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
-		wc->status = IBV_WC_REM_INV_REQ_ERR;
+		*status = IBV_WC_REM_INV_REQ_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_REMOTE_ACCESS_ERR:
-		wc->status = IBV_WC_REM_ACCESS_ERR;
+		*status = IBV_WC_REM_ACCESS_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_REMOTE_OP_ERR:
-		wc->status = IBV_WC_REM_OP_ERR;
+		*status = IBV_WC_REM_OP_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RETRY_EXC_ERR;
+		*status = IBV_WC_RETRY_EXC_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_RNR_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RNR_RETRY_EXC_ERR;
+		*status = IBV_WC_RNR_RETRY_EXC_ERR;
 		break;
 	case MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR:
-		wc->status = IBV_WC_REM_ABORT_ERR;
+		*status = IBV_WC_REM_ABORT_ERR;
 		break;
 	default:
-		wc->status = IBV_WC_GENERAL_ERR;
+		*status = IBV_WC_GENERAL_ERR;
 		break;
 	}
 
-	wc->vendor_err = cqe->vendor_err;
+	*vendor_err = cqe->vendor_err;
 }
 
-static int mlx4_poll_one(struct mlx4_cq *cq,
-			 struct mlx4_qp **cur_qp,
-			 struct ibv_wc *wc)
+static inline int mlx4_handle_cq(struct mlx4_cq *cq,
+				 struct mlx4_qp **cur_qp,
+				 uint64_t *wc_wr_id,
+				 enum ibv_wc_status *wc_status,
+				 uint32_t *wc_vendor_err,
+				 struct mlx4_cqe **pcqe,
+				 uint32_t *pqpn,
+				 int *pis_send)
 {
 	struct mlx4_wq *wq;
 	struct mlx4_cqe *cqe;
 	struct mlx4_srq *srq;
 	uint32_t qpn;
-	uint32_t g_mlpath_rqpn;
-	uint16_t wqe_index;
 	int is_error;
 	int is_send;
+	uint16_t wqe_index;
 
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
@@ -201,7 +208,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 
 	++cq->cons_index;
 
-	VALGRIND_MAKE_MEM_DEFINED(cqe, sizeof *cqe);
+	VALGRIND_MAKE_MEM_DEFINED(cqe, sizeof(*cqe));
 
 	/*
 	 * Make sure we read CQ entry contents after we've checked the
@@ -210,7 +217,6 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	rmb();
 
 	qpn = ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;
-	wc->qp_num = qpn;
 
 	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
 	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
@@ -243,26 +249,50 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	if (is_send) {
 		wq = &(*cur_qp)->sq;
 		wqe_index = ntohs(cqe->wqe_index);
-		wq->tail += (uint16_t) (wqe_index - (uint16_t) wq->tail);
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		wq->tail += (uint16_t)(wqe_index - (uint16_t)wq->tail);
+		*wc_wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	} else if (srq) {
 		wqe_index = htons(cqe->wqe_index);
-		wc->wr_id = srq->wrid[wqe_index];
+		*wc_wr_id = srq->wrid[wqe_index];
 		mlx4_free_srq_wqe(srq, wqe_index);
 	} else {
 		wq = &(*cur_qp)->rq;
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		*wc_wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	}
 
 	if (is_error) {
-		mlx4_handle_error_cqe((struct mlx4_err_cqe *) cqe, wc);
+		mlx4_handle_error_cqe((struct mlx4_err_cqe *)cqe,
+				      wc_status, wc_vendor_err);
 		return CQ_OK;
 	}
 
-	wc->status = IBV_WC_SUCCESS;
+	*wc_status = IBV_WC_SUCCESS;
 
+	*pcqe = cqe;
+	*pqpn = qpn;
+	*pis_send = is_send;
+
+	return CQ_CONTINUE;
+}
+
+static int mlx4_poll_one(struct mlx4_cq *cq,
+			 struct mlx4_qp **cur_qp,
+			 struct ibv_wc *wc)
+{
+	struct mlx4_cqe *cqe;
+	uint32_t qpn;
+	uint32_t g_mlpath_rqpn;
+	int is_send;
+	int err;
+
+	err = mlx4_handle_cq(cq, cur_qp, &wc->wr_id, &wc->status,
+			     &wc->vendor_err, &cqe, &qpn, &is_send);
+	if (err != CQ_CONTINUE)
+		return err;
+
+	wc->qp_num = qpn;
 	if (is_send) {
 		wc->wc_flags = 0;
 		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
@@ -340,6 +370,195 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	return CQ_OK;
 }
 
+union wc_buffer {
+	uint8_t		*b8;
+	uint16_t	*b16;
+	uint32_t	*b32;
+	uint64_t	*b64;
+};
+
+static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
+				    struct mlx4_qp **cur_qp,
+				    struct ibv_wc_ex **pwc_ex,
+				    uint64_t wc_flags)
+{
+	struct mlx4_cqe *cqe;
+	uint32_t qpn;
+	uint32_t g_mlpath_rqpn;
+	int is_send;
+	struct ibv_wc_ex *wc_ex = *pwc_ex;
+	union wc_buffer wc_buffer;
+	int err;
+	uint64_t wc_flags_out = 0;
+
+	wc_buffer.b64 = (uint64_t *)&wc_ex->buffer;
+	wc_ex->wc_flags = 0;
+	wc_ex->reserved = 0;
+	err = mlx4_handle_cq(cq, cur_qp, &wc_ex->wr_id, &wc_ex->status,
+			     &wc_ex->vendor_err, &cqe, &qpn, &is_send);
+	if (err != CQ_CONTINUE)
+		return err;
+
+	if (is_send) {
+		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_OPCODE_RDMA_WRITE_IMM:
+			wc_flags_out |= IBV_WC_EX_IMM;
+		case MLX4_OPCODE_RDMA_WRITE:
+			wc_ex->opcode    = IBV_WC_RDMA_WRITE;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+				wc_buffer.b32++;
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		case MLX4_OPCODE_SEND_IMM:
+			wc_flags_out |= IBV_WC_EX_IMM;
+		case MLX4_OPCODE_SEND:
+			wc_ex->opcode    = IBV_WC_SEND;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+				wc_buffer.b32++;
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		case MLX4_OPCODE_RDMA_READ:
+			wc_ex->opcode    = IBV_WC_RDMA_READ;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+				*wc_buffer.b32++  = ntohl(cqe->byte_cnt);
+				wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
+			}
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		case MLX4_OPCODE_ATOMIC_CS:
+			wc_ex->opcode    = IBV_WC_COMP_SWAP;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+				*wc_buffer.b32++  = 8;
+				wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
+			}
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		case MLX4_OPCODE_ATOMIC_FA:
+			wc_ex->opcode    = IBV_WC_FETCH_ADD;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+				*wc_buffer.b32++  = 8;
+				wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
+			}
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		case MLX4_OPCODE_BIND_MW:
+			wc_ex->opcode    = IBV_WC_BIND_MW;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+				wc_buffer.b32++;
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		default:
+			/* assume it's a send completion */
+			wc_ex->opcode    = IBV_WC_SEND;
+			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+				wc_buffer.b32++;
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		}
+
+		if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+			*wc_buffer.b32++  = qpn;
+			wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
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
+	} else {
+		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			*wc_buffer.b32++ = ntohl(cqe->byte_cnt);
+			wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
+		}
+
+		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
+			wc_ex->opcode   = IBV_WC_RECV_RDMA_WITH_IMM;
+			wc_flags_out |= IBV_WC_EX_IMM;
+			if (wc_flags & IBV_WC_EX_WITH_IMM) {
+				*wc_buffer.b32++ = cqe->immed_rss_invalid;
+				wc_flags_out |= IBV_WC_EX_WITH_IMM;
+			}
+			break;
+		case MLX4_RECV_OPCODE_SEND:
+			wc_ex->opcode   = IBV_WC_RECV;
+			if (wc_flags & IBV_WC_EX_WITH_IMM)
+				wc_buffer.b32++;
+			break;
+		case MLX4_RECV_OPCODE_SEND_IMM:
+			wc_ex->opcode   = IBV_WC_RECV;
+			wc_flags_out |= IBV_WC_EX_IMM;
+			if (wc_flags & IBV_WC_EX_WITH_IMM) {
+				*wc_buffer.b32++ = cqe->immed_rss_invalid;
+				wc_flags_out |= IBV_WC_EX_WITH_IMM;
+			}
+			break;
+		}
+
+		if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+			*wc_buffer.b32++  = qpn;
+			wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
+		}
+		g_mlpath_rqpn	   = ntohl(cqe->g_mlpath_rqpn);
+		if (wc_flags & IBV_WC_EX_WITH_SRC_QP) {
+			*wc_buffer.b32++  = g_mlpath_rqpn & 0xffffff;
+			wc_flags_out |= IBV_WC_EX_WITH_SRC_QP;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX) {
+			*wc_buffer.b16++  = ntohl(cqe->immed_rss_invalid) & 0x7f;
+			wc_flags_out |= IBV_WC_EX_WITH_PKEY_INDEX;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_SLID) {
+			*wc_buffer.b16++  = ntohs(cqe->rlid);
+			wc_flags_out |= IBV_WC_EX_WITH_SLID;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_SL) {
+			wc_flags_out |= IBV_WC_EX_WITH_SL;
+			if ((*cur_qp) && (*cur_qp)->link_layer == IBV_LINK_LAYER_ETHERNET)
+				*wc_buffer.b8++  = ntohs(cqe->sl_vid) >> 13;
+			else
+				*wc_buffer.b8++  = ntohs(cqe->sl_vid) >> 12;
+		}
+		if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS) {
+			*wc_buffer.b8++  = (g_mlpath_rqpn >> 24) & 0x7f;
+			wc_flags_out |= IBV_WC_EX_WITH_DLID_PATH_BITS;
+		}
+		wc_flags_out |= g_mlpath_rqpn & 0x80000000 ? IBV_WC_EX_GRH : 0;
+		/* When working with xrc srqs, don't have qp to check link layer.
+		  * Using IB SL, should consider Roce. (TBD)
+		*/
+	}
+
+	wc_ex->wc_flags = wc_flags_out;
+	/* Align the WC ex to the next 64bit. This is mandatory as ibv_wc_ex is
+	 * 64bit aligned. pwc_ex is used to write to the next wc and thus we
+	 * need to align it.
+	 */
+	*pwc_ex = (struct ibv_wc_ex *)((uintptr_t)(wc_buffer.b8 + sizeof(uint64_t) - 1) &
+				       ~(sizeof(uint64_t) - 1));
+
+	return CQ_OK;
+}
+
+int mlx4_poll_one_ex(struct mlx4_cq *cq,
+		     struct mlx4_qp **cur_qp,
+		     struct ibv_wc_ex **pwc_ex)
+{
+	return _mlx4_poll_one_ex(cq, cur_qp, pwc_ex, cq->wc_flags);
+}
+
 int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 {
 	struct mlx4_cq *cq = to_mcq(ibcq);
@@ -363,6 +582,36 @@ int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	return err == CQ_POLL_ERR ? err : npolled;
 }
 
+int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
+		    struct ibv_wc_ex *wc,
+		    struct ibv_poll_cq_ex_attr *attr)
+{
+	struct mlx4_cq *cq = to_mcq(ibcq);
+	struct mlx4_qp *qp = NULL;
+	int npolled;
+	int err = CQ_OK;
+	unsigned int ne = attr->max_entries;
+	uint64_t wc_flags = cq->wc_flags;
+
+	if (attr->comp_mask)
+		return -EINVAL;
+
+	pthread_spin_lock(&cq->lock);
+
+	for (npolled = 0; npolled < ne; ++npolled) {
+		err = _mlx4_poll_one_ex(cq, &qp, &wc, wc_flags);
+		if (err != CQ_OK)
+			break;
+	}
+
+	if (npolled || err == CQ_POLL_ERR)
+		update_cons_index(cq);
+
+	pthread_spin_unlock(&cq->lock);
+
+	return err == CQ_POLL_ERR ? err : npolled;
+}
+
 int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx4_cq *cq = to_mcq(ibvcq);
diff --git a/src/mlx4.c b/src/mlx4.c
index 9cfd013..cc1211f 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -209,6 +209,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
 	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
+	verbs_set_ctx_op(verbs_ctx, poll_cq_ex, mlx4_poll_cq_ex);
 
 	return 0;
 
diff --git a/src/mlx4.h b/src/mlx4.h
index 91eb79c..e22f879 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -213,6 +213,7 @@ struct mlx4_pd {
 
 struct mlx4_cq {
 	struct ibv_cq			ibv_cq;
+	uint64_t			wc_flags;
 	struct mlx4_buf			buf;
 	struct mlx4_buf			resize_buf;
 	pthread_spinlock_t		lock;
@@ -410,6 +411,9 @@ int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent,
 int mlx4_resize_cq(struct ibv_cq *cq, int cqe);
 int mlx4_destroy_cq(struct ibv_cq *cq);
 int mlx4_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
+int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
+		    struct ibv_wc_ex *wc,
+		    struct ibv_poll_cq_ex_attr *attr);
 int mlx4_arm_cq(struct ibv_cq *cq, int solicited);
 void mlx4_cq_event(struct ibv_cq *cq);
 void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq);
diff --git a/src/verbs.c b/src/verbs.c
index 3290b86..0dcdc87 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -387,6 +387,7 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 		goto err_db;
 
 	cq->creation_flags = cmd_e.ibv_cmd.flags;
+	cq->wc_flags = cq_attr->wc_flags;
 	cq->cqn = resp.cqn;
 
 	return &cq->ibv_cq;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
