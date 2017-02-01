From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 05/10] mlx4: Add lazy CQ polling
Date: Wed,  1 Feb 2017 09:39:31 +0200
Message-ID: <1485934776-715-6-git-send-email-yishaih@mellanox.com>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

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

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c    | 165 +++++++++++++++++++++++++++++++------------------
 providers/mlx4/mlx4.h  |   9 ++-
 providers/mlx4/verbs.c |   6 +-
 3 files changed, 116 insertions(+), 64 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 8f67c90..6c4b3c4 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -156,6 +156,46 @@ static enum ibv_wc_status mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe)
 	}
 }
 
+static inline void handle_good_req(struct ibv_wc *wc, struct mlx4_cqe *cqe)
+{
+	wc->wc_flags = 0;
+	switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+	case MLX4_OPCODE_RDMA_WRITE_IMM:
+		wc->wc_flags |= IBV_WC_WITH_IMM;
+	case MLX4_OPCODE_RDMA_WRITE:
+		wc->opcode    = IBV_WC_RDMA_WRITE;
+		break;
+	case MLX4_OPCODE_SEND_IMM:
+		wc->wc_flags |= IBV_WC_WITH_IMM;
+	case MLX4_OPCODE_SEND:
+	case MLX4_OPCODE_SEND_INVAL:
+		wc->opcode    = IBV_WC_SEND;
+		break;
+	case MLX4_OPCODE_RDMA_READ:
+		wc->opcode    = IBV_WC_RDMA_READ;
+		wc->byte_len  = ntohl(cqe->byte_cnt);
+		break;
+	case MLX4_OPCODE_ATOMIC_CS:
+		wc->opcode    = IBV_WC_COMP_SWAP;
+		wc->byte_len  = 8;
+		break;
+	case MLX4_OPCODE_ATOMIC_FA:
+		wc->opcode    = IBV_WC_FETCH_ADD;
+		wc->byte_len  = 8;
+		break;
+	case MLX4_OPCODE_LOCAL_INVAL:
+		wc->opcode    = IBV_WC_LOCAL_INV;
+		break;
+	case MLX4_OPCODE_BIND_MW:
+		wc->opcode    = IBV_WC_BIND_MW;
+		break;
+	default:
+		/* assume it's a send completion */
+		wc->opcode    = IBV_WC_SEND;
+		break;
+	}
+}
+
 static inline int mlx4_get_next_cqe(struct mlx4_cq *cq,
 				    struct mlx4_cqe **pcqe)
 				    ALWAYS_INLINE;
@@ -186,25 +226,35 @@ static inline int mlx4_get_next_cqe(struct mlx4_cq *cq,
 	return CQ_OK;
 }
 
-static int mlx4_poll_one(struct mlx4_cq *cq,
-			 struct mlx4_qp **cur_qp,
-			 struct ibv_wc *wc)
+static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
+					struct mlx4_cqe *cqe,
+					struct mlx4_qp **cur_qp,
+					struct ibv_wc *wc, int lazy)
+					ALWAYS_INLINE;
+static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
+					struct mlx4_cqe *cqe,
+					struct mlx4_qp **cur_qp,
+					struct ibv_wc *wc, int lazy)
 {
 	struct mlx4_wq *wq;
-	struct mlx4_cqe *cqe;
 	struct mlx4_srq *srq;
 	uint32_t qpn;
 	uint32_t g_mlpath_rqpn;
+	uint64_t *pwr_id;
 	uint16_t wqe_index;
 	struct mlx4_err_cqe *ecqe;
+	struct mlx4_context *mctx;
 	int is_error;
 	int is_send;
+	enum ibv_wc_status *pstatus;
 
-	if  (mlx4_get_next_cqe(cq, &cqe) == CQ_EMPTY)
-		return CQ_EMPTY;
-
+	mctx = to_mctx(cq->ibv_cq.context);
 	qpn = ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;
-	wc->qp_num = qpn;
+	if (lazy) {
+		cq->cqe = cqe;
+		cq->flags &= (~MLX4_CQ_FLAGS_RX_CSUM_VALID);
+	} else
+		wc->qp_num = qpn;
 
 	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
 	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
@@ -216,7 +266,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		 * because CQs will be locked while SRQs are removed
 		 * from the table.
 		 */
-		srq = mlx4_find_xsrq(&to_mctx(cq->ibv_cq.context)->xsrq_table,
+		srq = mlx4_find_xsrq(&mctx->xsrq_table,
 				     ntohl(cqe->g_mlpath_rqpn) & MLX4_CQE_QPN_MASK);
 		if (!srq)
 			return CQ_POLL_ERR;
@@ -227,78 +277,46 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 			 * because CQs will be locked while QPs are removed
 			 * from the table.
 			 */
-			*cur_qp = mlx4_find_qp(to_mctx(cq->ibv_cq.context), qpn);
+			*cur_qp = mlx4_find_qp(mctx, qpn);
 			if (!*cur_qp)
 				return CQ_POLL_ERR;
 		}
 		srq = ((*cur_qp)->verbs_qp.qp.srq) ? to_msrq((*cur_qp)->verbs_qp.qp.srq) : NULL;
 	}
 
+	pwr_id = lazy ? &cq->ibv_cq.wr_id : &wc->wr_id;
 	if (is_send) {
 		wq = &(*cur_qp)->sq;
 		wqe_index = ntohs(cqe->wqe_index);
 		wq->tail += (uint16_t) (wqe_index - (uint16_t) wq->tail);
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		*pwr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	} else if (srq) {
 		wqe_index = htons(cqe->wqe_index);
-		wc->wr_id = srq->wrid[wqe_index];
+		*pwr_id = srq->wrid[wqe_index];
 		mlx4_free_srq_wqe(srq, wqe_index);
 	} else {
 		wq = &(*cur_qp)->rq;
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		*pwr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
 		++wq->tail;
 	}
 
+	pstatus = lazy ? &cq->ibv_cq.status : &wc->status;
 	if (is_error) {
 		ecqe = (struct mlx4_err_cqe *)cqe;
-		wc->status = mlx4_handle_error_cqe(ecqe);
-		wc->vendor_err = ecqe->vendor_err;
-
+		*pstatus = mlx4_handle_error_cqe(ecqe);
+		if (!lazy)
+			wc->vendor_err = ecqe->vendor_err;
 		return CQ_OK;
 	}
 
-	wc->status = IBV_WC_SUCCESS;
-
-	if (is_send) {
-		wc->wc_flags = 0;
-		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
-		case MLX4_OPCODE_RDMA_WRITE_IMM:
-			wc->wc_flags |= IBV_WC_WITH_IMM;
-		case MLX4_OPCODE_RDMA_WRITE:
-			wc->opcode    = IBV_WC_RDMA_WRITE;
-			break;
-		case MLX4_OPCODE_SEND_IMM:
-			wc->wc_flags |= IBV_WC_WITH_IMM;
-		case MLX4_OPCODE_SEND:
-			wc->opcode    = IBV_WC_SEND;
-			break;
-		case MLX4_OPCODE_RDMA_READ:
-			wc->opcode    = IBV_WC_RDMA_READ;
-			wc->byte_len  = ntohl(cqe->byte_cnt);
-			break;
-		case MLX4_OPCODE_ATOMIC_CS:
-			wc->opcode    = IBV_WC_COMP_SWAP;
-			wc->byte_len  = 8;
-			break;
-		case MLX4_OPCODE_ATOMIC_FA:
-			wc->opcode    = IBV_WC_FETCH_ADD;
-			wc->byte_len  = 8;
-			break;
-		case MLX4_OPCODE_LOCAL_INVAL:
-			wc->opcode    = IBV_WC_LOCAL_INV;
-			break;
-		case MLX4_OPCODE_BIND_MW:
-			wc->opcode    = IBV_WC_BIND_MW;
-			break;
-		case MLX4_OPCODE_SEND_INVAL:
-			wc->opcode    = IBV_WC_SEND;
-			break;
-		default:
-			/* assume it's a send completion */
-			wc->opcode    = IBV_WC_SEND;
-			break;
-		}
+	*pstatus = IBV_WC_SUCCESS;
+	if (lazy) {
+		if (!is_send)
+			if ((*cur_qp) && ((*cur_qp)->qp_cap_cache & MLX4_RX_CSUM_VALID))
+				cq->flags |= MLX4_CQ_FLAGS_RX_CSUM_VALID;
+	} else if (is_send) {
+		handle_good_req(wc, cqe);
 	} else {
 		wc->byte_len = ntohl(cqe->byte_cnt);
 
@@ -331,7 +349,7 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 		wc->wc_flags	  |= g_mlpath_rqpn & 0x80000000 ? IBV_WC_GRH : 0;
 		wc->pkey_index     = ntohl(cqe->immed_rss_invalid) & 0x7f;
 		/* When working with xrc srqs, don't have qp to check link layer.
-		  * Using IB SL, should consider Roce. (TBD)
+		* Using IB SL, should consider Roce. (TBD)
 		*/
 		if ((*cur_qp) && (*cur_qp)->link_layer == IBV_LINK_LAYER_ETHERNET)
 			wc->sl	   = ntohs(cqe->sl_vid) >> 13;
@@ -340,14 +358,41 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 
 		if ((*cur_qp) && ((*cur_qp)->qp_cap_cache & MLX4_RX_CSUM_VALID)) {
 			wc->wc_flags |= ((cqe->status & htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) ==
-					 htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) <<
-					IBV_WC_IP_CSUM_OK_SHIFT;
+				 htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) <<
+				IBV_WC_IP_CSUM_OK_SHIFT;
 		}
 	}
 
 	return CQ_OK;
 }
 
+static inline int mlx4_parse_lazy_cqe(struct mlx4_cq *cq,
+				      struct mlx4_cqe *cqe)
+				      ALWAYS_INLINE;
+static inline int mlx4_parse_lazy_cqe(struct mlx4_cq *cq,
+				      struct mlx4_cqe *cqe)
+{
+	return mlx4_parse_cqe(cq, cqe, &cq->cur_qp, NULL, 1);
+}
+
+static inline int mlx4_poll_one(struct mlx4_cq *cq,
+			 struct mlx4_qp **cur_qp,
+			 struct ibv_wc *wc)
+			 ALWAYS_INLINE;
+static inline int mlx4_poll_one(struct mlx4_cq *cq,
+			 struct mlx4_qp **cur_qp,
+			 struct ibv_wc *wc)
+{
+	struct mlx4_cqe *cqe;
+	int err;
+
+	err = mlx4_get_next_cqe(cq, &cqe);
+	if (err == CQ_EMPTY)
+		return err;
+
+	return mlx4_parse_cqe(cq, cqe, cur_qp, wc, 0);
+}
+
 int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 {
 	struct mlx4_cq *cq = to_mcq(ibcq);
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 28ed197..e9b0230 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -166,8 +166,12 @@ struct mlx4_pd {
 	uint32_t			pdn;
 };
 
+enum {
+	MLX4_CQ_FLAGS_RX_CSUM_VALID = 1 << 0,
+};
+
 struct mlx4_cq {
-	struct ibv_cq			ibv_cq;
+	struct ibv_cq_ex		ibv_cq;
 	struct mlx4_buf			buf;
 	struct mlx4_buf			resize_buf;
 	pthread_spinlock_t		lock;
@@ -177,6 +181,9 @@ struct mlx4_cq {
 	uint32_t		       *arm_db;
 	int				arm_sn;
 	int				cqe_size;
+	struct mlx4_qp			*cur_qp;
+	struct mlx4_cqe			*cqe;
+	uint32_t			flags;
 };
 
 struct mlx4_srq {
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 21ec1d1..83c971d 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -346,14 +346,14 @@ struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 	cmd.db_addr  = (uintptr_t) cq->set_ci_db;
 
 	ret = ibv_cmd_create_cq(context, cqe - 1, channel, comp_vector,
-				&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
-				&resp.ibv_resp, sizeof resp);
+				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd, sizeof(cmd),
+				&resp.ibv_resp, sizeof(resp));
 	if (ret)
 		goto err_db;
 
 	cq->cqn = resp.cqn;
 
-	return &cq->ibv_cq;
+	return ibv_cq_ex_to_cq(&cq->ibv_cq);
 
 err_db:
 	mlx4_free_db(to_mctx(context), MLX4_DB_TYPE_CQ, cq->set_ci_db);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
