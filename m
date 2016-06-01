From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 2/7] Add lazy CQ polling
Date: Wed,  1 Jun 2016 16:47:57 +0300
Message-ID: <1464788882-1876-3-git-send-email-yishaih@mellanox.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464788882-1876-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently, when a user wants to poll a CQ for completion, he has no
choice but to get the whole work completion (WC). This has several
implications - for example:
* Extending the WC is limited, as adding new fields makes the WC
  larger and could take more cache lines.
* Every field is being copied to the WC - even fields that the user
  doesn't care about.

This patch adds some support for handling the CQE in a lazing manner.
The new lazy mode is going to be called in downstream patches.

We only parse fields that are mandatory in order to figure out the CQE
such as type, status, wr_id, etc.

To share code with the legacy mode without having a performance penalty
the legacy code was refactored and the 'always_inline' mechanism was
used so that branch conditions will be dropped at compile time.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 176 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 src/mlx5.h  |  11 +++-
 src/verbs.c |   6 +--
 3 files changed, 157 insertions(+), 36 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index d3f2ada..a056787 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -219,6 +219,54 @@ static void handle_good_req(struct ibv_wc *wc, struct mlx5_cqe64 *cqe)
 	}
 }
 
+static inline void handle_good_req_lazy(struct mlx5_cqe64 *cqe, uint32_t *pwc_byte_len)
+{
+	switch (ntohl(cqe->sop_drop_qpn) >> 24) {
+	case MLX5_OPCODE_RDMA_READ:
+		*pwc_byte_len  = ntohl(cqe->byte_cnt);
+		break;
+	case MLX5_OPCODE_ATOMIC_CS:
+	case MLX5_OPCODE_ATOMIC_FA:
+		*pwc_byte_len  = 8;
+		break;
+	}
+}
+
+static inline int handle_responder_lazy(struct mlx5_cq *cq, struct mlx5_cqe64 *cqe,
+					struct mlx5_qp *qp, struct mlx5_srq *srq)
+{
+	uint16_t	wqe_ctr;
+	struct mlx5_wq *wq;
+	int err = IBV_WC_SUCCESS;
+
+	if (srq) {
+		wqe_ctr = ntohs(cqe->wqe_counter);
+		cq->ibv_cq.wr_id = srq->wrid[wqe_ctr];
+		mlx5_free_srq_wqe(srq, wqe_ctr);
+		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe,
+						    ntohl(cqe->byte_cnt));
+		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+			err = mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe - 1,
+						    ntohl(cqe->byte_cnt));
+	} else {
+		wq	  = &qp->rq;
+		wqe_ctr = wq->tail & (wq->wqe_cnt - 1);
+		cq->ibv_cq.wr_id = wq->wrid[wqe_ctr];
+		++wq->tail;
+		if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
+			cq->flags |= MLX5_CQ_FLAGS_RX_CSUM_VALID;
+		if (cqe->op_own & MLX5_INLINE_SCATTER_32)
+			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe,
+						    ntohl(cqe->byte_cnt));
+		else if (cqe->op_own & MLX5_INLINE_SCATTER_64)
+			err = mlx5_copy_to_recv_wqe(qp, wqe_ctr, cqe - 1,
+						    ntohl(cqe->byte_cnt));
+	}
+
+	return err;
+}
+
 static int handle_responder(struct ibv_wc *wc, struct mlx5_cqe64 *cqe,
 			    struct mlx5_qp *qp, struct mlx5_srq *srq)
 {
@@ -547,41 +595,49 @@ static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
 	return CQ_OK;
 }
 
-static inline int mlx5_poll_one(struct mlx5_cq *cq,
-				struct mlx5_resource **cur_rsc,
-				struct mlx5_srq **cur_srq,
-				struct ibv_wc *wc, int cqe_ver)
-				__attribute__((always_inline));
-static inline int mlx5_poll_one(struct mlx5_cq *cq,
-				struct mlx5_resource **cur_rsc,
-				struct mlx5_srq **cur_srq,
-				struct ibv_wc *wc, int cqe_ver)
+static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
+				 struct mlx5_cqe64 *cqe64,
+				 void *cqe,
+				 struct mlx5_resource **cur_rsc,
+				 struct mlx5_srq **cur_srq,
+				 struct ibv_wc *wc,
+				 int cqe_ver, int lazy)
+				 __attribute__((always_inline));
+static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
+				 struct mlx5_cqe64 *cqe64,
+				 void *cqe,
+				 struct mlx5_resource **cur_rsc,
+				 struct mlx5_srq **cur_srq,
+				 struct ibv_wc *wc,
+				 int cqe_ver, int lazy)
 {
-	struct mlx5_cqe64 *cqe64;
 	struct mlx5_wq *wq;
 	uint16_t wqe_ctr;
-	void *cqe;
 	uint32_t qpn;
 	uint32_t srqn_uidx;
 	int idx;
 	uint8_t opcode;
 	struct mlx5_err_cqe *ecqe;
-	int err;
+	int err = 0;
 	struct mlx5_qp *mqp;
 	struct mlx5_context *mctx;
 	uint8_t is_srq = 0;
 
-	err = mlx5_get_next_cqe(cq, &cqe64, &cqe);
-	if (err == CQ_EMPTY)
-		return err;
-
-	mctx = to_mctx(cq->ibv_cq.context);
+	mctx = to_mctx(ibv_cq_ex_to_cq(&cq->ibv_cq)->context);
 	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
-	wc->wc_flags = 0;
-	wc->qp_num = qpn;
+	if (lazy) {
+		cq->cqe64 = cqe64;
+		cq->flags &= (~MLX5_CQ_FLAGS_RX_CSUM_VALID);
+	} else {
+		wc->wc_flags = 0;
+		wc->qp_num = qpn;
+	}
+
 	opcode = cqe64->op_own >> 4;
 	switch (opcode) {
 	case MLX5_CQE_REQ:
+	{
+		uint32_t uninitialized_var(wc_byte_len);
 		mqp = get_req_context(mctx, cur_rsc,
 				      (cqe_ver ? (ntohl(cqe64->srqn_uidx) & 0xffffff) : qpn),
 				      cqe_ver);
@@ -590,20 +646,29 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 		wq = &mqp->sq;
 		wqe_ctr = ntohs(cqe64->wqe_counter);
 		idx = wqe_ctr & (wq->wqe_cnt - 1);
-		handle_good_req(wc, cqe64);
+		if (lazy)
+			handle_good_req_lazy(cqe64, &wc_byte_len);
+		else
+			handle_good_req(wc, cqe64);
+
 		if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
 			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
-						    wc->byte_len);
+						    lazy ? wc_byte_len : wc->byte_len);
 		else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
 			err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe - 1,
-						    wc->byte_len);
-		else
-			err = 0;
+						     lazy ? wc_byte_len : wc->byte_len);
+
+		if (lazy) {
+			cq->ibv_cq.wr_id = wq->wrid[idx];
+			cq->ibv_cq.status = err;
+		} else {
+			wc->wr_id = wq->wrid[idx];
+			wc->status = err;
+		}
 
-		wc->wr_id = wq->wrid[idx];
 		wq->tail = wq->wqe_head[idx] + 1;
-		wc->status = err;
 		break;
+	}
 	case MLX5_CQE_RESP_WR_IMM:
 	case MLX5_CQE_RESP_SEND:
 	case MLX5_CQE_RESP_SEND_IMM:
@@ -614,7 +679,12 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 		if (unlikely(err))
 			return CQ_POLL_ERR;
 
-		wc->status = handle_responder(wc, cqe64, rsc_to_mqp(*cur_rsc),
+		if (lazy)
+			cq->ibv_cq.status = handle_responder_lazy(cq, cqe64,
+							      rsc_to_mqp(*cur_rsc),
+							      is_srq ? *cur_srq : NULL);
+		else
+			wc->status = handle_responder(wc, cqe64, rsc_to_mqp(*cur_rsc),
 					      is_srq ? *cur_srq : NULL);
 		break;
 	case MLX5_CQE_RESIZE_CQ:
@@ -623,8 +693,9 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 	case MLX5_CQE_RESP_ERR:
 		srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
 		ecqe = (struct mlx5_err_cqe *)cqe64;
-		mlx5_handle_error_cqe(ecqe, &wc->status);
-		wc->vendor_err = ecqe->vendor_err_synd;
+		mlx5_handle_error_cqe(ecqe, lazy ? &cq->ibv_cq.status : &wc->status);
+		if (!lazy)
+			wc->vendor_err = ecqe->vendor_err_synd;
 		if (unlikely(ecqe->syndrome != MLX5_CQE_SYNDROME_WR_FLUSH_ERR &&
 			     ecqe->syndrome != MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR)) {
 			FILE *fp = mctx->dbg_fp;
@@ -646,7 +717,10 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 			wq = &mqp->sq;
 			wqe_ctr = ntohs(cqe64->wqe_counter);
 			idx = wqe_ctr & (wq->wqe_cnt - 1);
-			wc->wr_id = wq->wrid[idx];
+			if (lazy)
+				cq->ibv_cq.wr_id = wq->wrid[idx];
+			else
+				wc->wr_id = wq->wrid[idx];
 			wq->tail = wq->wqe_head[idx] + 1;
 		} else {
 			err = get_cur_rsc(mctx, cqe_ver, qpn, srqn_uidx,
@@ -656,12 +730,18 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 
 			if (is_srq) {
 				wqe_ctr = ntohs(cqe64->wqe_counter);
-				wc->wr_id = (*cur_srq)->wrid[wqe_ctr];
+				if (lazy)
+					cq->ibv_cq.wr_id = (*cur_srq)->wrid[wqe_ctr];
+				else
+					wc->wr_id = (*cur_srq)->wrid[wqe_ctr];
 				mlx5_free_srq_wqe(*cur_srq, wqe_ctr);
 			} else {
 				mqp = rsc_to_mqp(*cur_rsc);
 				wq = &mqp->rq;
-				wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+				if (lazy)
+					cq->ibv_cq.wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+				else
+					wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 				++wq->tail;
 			}
 		}
@@ -671,6 +751,38 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 	return CQ_OK;
 }
 
+static inline int mlx5_parse_lazy_cqe(struct mlx5_cq *cq,
+				      struct mlx5_cqe64 *cqe64,
+				      void *cqe, int cqe_ver)
+				      __attribute__((always_inline));
+static inline int mlx5_parse_lazy_cqe(struct mlx5_cq *cq,
+				      struct mlx5_cqe64 *cqe64,
+				      void *cqe, int cqe_ver)
+{
+	return mlx5_parse_cqe(cq, cqe64, cqe, &cq->cur_rsc, &cq->cur_srq, NULL, cqe_ver, 1);
+}
+
+static inline int mlx5_poll_one(struct mlx5_cq *cq,
+				struct mlx5_resource **cur_rsc,
+				struct mlx5_srq **cur_srq,
+				struct ibv_wc *wc, int cqe_ver)
+				__attribute__((always_inline));
+static inline int mlx5_poll_one(struct mlx5_cq *cq,
+				struct mlx5_resource **cur_rsc,
+				struct mlx5_srq **cur_srq,
+				struct ibv_wc *wc, int cqe_ver)
+{
+	struct mlx5_cqe64 *cqe64;
+	void *cqe;
+	int err;
+
+	err = mlx5_get_next_cqe(cq, &cqe64, &cqe);
+	if (err == CQ_EMPTY)
+		return err;
+
+	return mlx5_parse_cqe(cq, cqe64, cqe, cur_rsc, cur_srq, wc, cqe_ver, 0);
+}
+
 static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 		      struct ibv_wc *wc, int cqe_ver)
 		      __attribute__((always_inline));
diff --git a/src/mlx5.h b/src/mlx5.h
index e91e519..99bee10 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -364,8 +364,13 @@ enum {
 	MLX5_CQ_ARM_DB	= 1,
 };
 
+enum {
+	MLX5_CQ_FLAGS_RX_CSUM_VALID = 1 << 0,
+};
+
 struct mlx5_cq {
-	struct ibv_cq			ibv_cq;
+	/* ibv_cq should always be subset of ibv_cq_ex */
+	struct ibv_cq_ex		ibv_cq;
 	struct mlx5_buf			buf_a;
 	struct mlx5_buf			buf_b;
 	struct mlx5_buf		       *active_buf;
@@ -384,6 +389,10 @@ struct mlx5_cq {
 	uint64_t			stall_last_count;
 	int				stall_adaptive_enable;
 	int				stall_cycles;
+	struct mlx5_resource		*cur_rsc;
+	struct mlx5_srq			*cur_srq;
+	struct mlx5_cqe64		*cqe64;
+	uint32_t			flags;
 };
 
 struct mlx5_srq {
diff --git a/src/verbs.c b/src/verbs.c
index e7aad5f..e78d2a5 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -328,8 +328,8 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cmd.cqe_size = cqe_sz;
 
 	ret = ibv_cmd_create_cq(context, ncqe - 1, channel, comp_vector,
-				&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
-				&resp.ibv_resp, sizeof resp);
+				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd,
+				sizeof(cmd), &resp.ibv_resp, sizeof(resp));
 	if (ret) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "ret %d\n", ret);
 		goto err_db;
@@ -342,7 +342,7 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 	cq->stall_adaptive_enable = to_mctx(context)->stall_adaptive_enable;
 	cq->stall_cycles = to_mctx(context)->stall_cycles;
 
-	return &cq->ibv_cq;
+	return ibv_cq_ex_to_cq(&cq->ibv_cq);
 
 err_db:
 	mlx5_free_db(to_mctx(context), cq->dbrec);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
