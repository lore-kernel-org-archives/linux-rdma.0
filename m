From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 07/10] mlx5: Tag matching list operation completions
Date: Mon, 23 Oct 2017 16:17:58 +0300
Message-ID: <1508764681-4531-8-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

List opetation completion arrival:
* removes a tag from head of CQE waiting FIFO
* updates command QP SQ tail (wqe_head)
* decrements expected cqe
* if no more cqe expected enqueues the tag to free tag list FIFO
* returns wr_id
* returns SYNC_REQ flag if SW phase_cnt and HW phase_cnt not matching

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c     | 102 +++++++++++++++++++++++++++++++++++++++++++++++-
 providers/mlx5/mlx5.h   |   1 +
 providers/mlx5/mlx5dv.h |  36 ++++++++++++-----
 3 files changed, 129 insertions(+), 10 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index de261dd..1b610fd 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -58,6 +58,22 @@ enum {
 	MLX5_CQ_MODIFY_MAPPING = 2,
 };
 
+enum {
+	MLX5_CQE_APP_TAG_MATCHING = 1,
+};
+
+enum {
+	MLX5_CQE_APP_OP_TM_APPEND = 0x5,
+	MLX5_CQE_APP_OP_TM_REMOVE = 0x6,
+	MLX5_CQE_APP_OP_TM_NOOP = 0x7,
+};
+
+enum {
+	MLX5_CQ_LAZY_FLAGS =
+		MLX5_CQ_FLAGS_RX_CSUM_VALID |
+		MLX5_CQ_FLAGS_TM_SYNC_REQ
+};
+
 int mlx5_stall_num_loop = 60;
 int mlx5_stall_cq_poll_min = 60;
 int mlx5_stall_cq_poll_max = 100000;
@@ -511,6 +527,63 @@ static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
 	return CQ_OK;
 }
 
+static int handle_tag_matching(struct mlx5_cq *cq,
+			       struct mlx5_cqe64 *cqe64,
+			       struct mlx5_srq *srq)
+{
+	FILE *fp = to_mctx(srq->vsrq.srq.context)->dbg_fp;
+	struct mlx5_srq_op *op;
+
+	cq->ibv_cq.status = IBV_WC_SUCCESS;
+	switch (cqe64->app_op) {
+	case MLX5_CQE_APP_OP_TM_REMOVE:
+		if (!(be32toh(cqe64->tm_cqe.success) & MLX5_TMC_SUCCESS))
+			cq->ibv_cq.status = IBV_WC_TM_ERR;
+		SWITCH_FALLTHROUGH;
+
+	case MLX5_CQE_APP_OP_TM_APPEND:
+	case MLX5_CQE_APP_OP_TM_NOOP:
+		mlx5_spin_lock(&srq->lock);
+#ifdef MLX5_DEBUG
+		if (srq->op_tail == srq->op_head) {
+			mlx5_dbg(fp, MLX5_DBG_CQ, "got unexpected list op CQE\n");
+			cq->ibv_cq.status = IBV_WC_GENERAL_ERR;
+			mlx5_spin_unlock(&srq->lock);
+			return CQ_OK;
+		}
+#endif
+		op = srq->op + (srq->op_head++ &
+				(to_mqp(srq->cmd_qp)->sq.wqe_cnt - 1));
+		if (op->tag) { /* APPEND or REMOVE */
+			mlx5_tm_release_tag(srq, op->tag);
+			if (cqe64->app_op == MLX5_CQE_APP_OP_TM_REMOVE &&
+			    cq->ibv_cq.status == IBV_WC_SUCCESS)
+				/*
+				 * If tag entry was successfully removed we
+				 * don't expect consumption completion for it
+				 * anymore. Remove reports failure if tag was
+				 * consumed meanwhile.
+				 */
+				mlx5_tm_release_tag(srq, op->tag);
+			if (be16toh(cqe64->tm_cqe.hw_phase_cnt) !=
+			    op->tag->phase_cnt)
+				cq->flags |= MLX5_CQ_FLAGS_TM_SYNC_REQ;
+		}
+
+		to_mqp(srq->cmd_qp)->sq.tail = op->wqe_head + 1;
+		cq->ibv_cq.wr_id = op->wr_id;
+
+		mlx5_spin_unlock(&srq->lock);
+		break;
+#ifdef MLX5_DEBUG
+	default:
+		mlx5_dbg(fp, MLX5_DBG_CQ, "un-expected TM opcode in cqe\n");
+#endif
+	}
+
+	return CQ_OK;
+}
+
 static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 				 struct mlx5_cqe64 *cqe64,
 				 void *cqe,
@@ -543,7 +616,7 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 	qpn = be32toh(cqe64->sop_drop_qpn) & 0xffffff;
 	if (lazy) {
 		cq->cqe64 = cqe64;
-		cq->flags &= (~MLX5_CQ_FLAGS_RX_CSUM_VALID);
+		cq->flags &= (~MLX5_CQ_LAZY_FLAGS);
 	} else {
 		wc->wc_flags = 0;
 		wc->qp_num = qpn;
@@ -623,6 +696,20 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 			wc->status = handle_responder(wc, cqe64, *cur_rsc,
 					      is_srq ? *cur_srq : NULL);
 		break;
+
+	case MLX5_CQE_NO_PACKET:
+		if (unlikely(cqe64->app != MLX5_CQE_APP_TAG_MATCHING))
+			return CQ_POLL_ERR;
+		srqn_uidx = be32toh(cqe64->srqn_uidx) & 0xffffff;
+		err = get_cur_rsc(mctx, cqe_ver, qpn, srqn_uidx, cur_rsc,
+				  cur_srq, &is_srq);
+		if (unlikely(err || !is_srq))
+			return CQ_POLL_ERR;
+		err = handle_tag_matching(cq, cqe64, *cur_srq);
+		if (unlikely(err))
+			return CQ_POLL_ERR;
+		break;
+
 	case MLX5_CQE_RESIZE_CQ:
 		break;
 	case MLX5_CQE_REQ_ERR:
@@ -1065,6 +1152,16 @@ static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 	case MLX5_CQE_RESP_SEND_IMM:
 	case MLX5_CQE_RESP_SEND_INV:
 		return IBV_WC_RECV;
+	case MLX5_CQE_NO_PACKET:
+		switch (cq->cqe64->app_op) {
+		case MLX5_CQE_APP_OP_TM_REMOVE:
+			return IBV_WC_TM_DEL;
+		case MLX5_CQE_APP_OP_TM_APPEND:
+			return IBV_WC_TM_ADD;
+		case MLX5_CQE_APP_OP_TM_NOOP:
+			return IBV_WC_TM_SYNC;
+		}
+		break;
 	case MLX5_CQE_REQ:
 		switch (be32toh(cq->cqe64->sop_drop_qpn) >> 24) {
 		case MLX5_OPCODE_RDMA_WRITE_IMM:
@@ -1122,6 +1219,9 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 		break;
 	}
 
+	if (cq->flags & MLX5_CQ_FLAGS_TM_SYNC_REQ)
+		wc_flags |= IBV_WC_TM_SYNC_REQ;
+
 	wc_flags |= ((be32toh(cq->cqe64->flags_rqpn) >> 28) & 3) ? IBV_WC_GRH : 0;
 	return wc_flags;
 }
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index d7eb477..5b7d5c0 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -323,6 +323,7 @@ enum {
 	MLX5_CQ_FLAGS_EXTENDED = 1 << 3,
 	MLX5_CQ_FLAGS_SINGLE_THREADED = 1 << 4,
 	MLX5_CQ_FLAGS_DV_OWNED = 1 << 5,
+	MLX5_CQ_FLAGS_TM_SYNC_REQ = 1 << 6,
 };
 
 struct mlx5_cq {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index e6cb610..00bb1e8 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -265,6 +265,7 @@ enum {
 	MLX5_CQE_RESP_SEND_IMM	= 3,
 	MLX5_CQE_RESP_SEND_INV	= 4,
 	MLX5_CQE_RESIZE_CQ	= 5,
+	MLX5_CQE_NO_PACKET	= 6,
 	MLX5_CQE_REQ_ERR	= 13,
 	MLX5_CQE_RESP_ERR	= 14,
 	MLX5_CQE_INVALID	= 15,
@@ -291,18 +292,31 @@ struct mlx5_err_cqe {
 	uint8_t		op_own;
 };
 
+struct mlx5_tm_cqe {
+	__be32		success;
+	__be16		hw_phase_cnt;
+	uint8_t		rsvd0[12];
+};
+
 struct mlx5_cqe64 {
-	uint8_t		rsvd0[17];
-	uint8_t		ml_path;
-	uint8_t		rsvd20[4];
-	__be16		slid;
-	__be32		flags_rqpn;
-	uint8_t		hds_ip_ext;
-	uint8_t		l4_hdr_type_etc;
-	__be16		vlan_info;
+	union {
+		struct {
+			uint8_t		rsvd0[17];
+			uint8_t		ml_path;
+			uint8_t		rsvd20[4];
+			__be16		slid;
+			__be32		flags_rqpn;
+			uint8_t		hds_ip_ext;
+			uint8_t		l4_hdr_type_etc;
+			__be16		vlan_info;
+		};
+		struct mlx5_tm_cqe tm_cqe;
+	};
 	__be32		srqn_uidx;
 	__be32		imm_inval_pkey;
-	uint8_t		rsvd40[4];
+	uint8_t		app;
+	uint8_t		app_op;
+	__be16		app_info;
 	__be32		byte_cnt;
 	__be64		timestamp;
 	__be32		sop_drop_qpn;
@@ -311,6 +325,10 @@ struct mlx5_cqe64 {
 	uint8_t		op_own;
 };
 
+enum {
+	MLX5_TMC_SUCCESS	= 0x80000000U,
+};
+
 enum mlx5dv_cqe_comp_res_format {
 	MLX5DV_CQE_RES_FORMAT_HASH		= 1 << 0,
 	MLX5DV_CQE_RES_FORMAT_CSUM		= 1 << 1,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
