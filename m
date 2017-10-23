From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 10/10] mlx5: Tag matching receive implementation
Date: Mon, 23 Oct 2017 16:18:01 +0300
Message-ID: <1508764681-4531-11-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement poll_cq tag matching extensions.
Handle receiving of TM CQEs:
* decrements expected cqe
* if no more cqe expected enqueues the tag to free tag list FIFO
* copy inline data from CQE if passed
* returns wr_id passed via add.tm.recv_wr_id
wc_flags and status returned according to definition

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c     | 138 ++++++++++++++++++++++++++++++++++++++++++++++--
 providers/mlx5/mlx5dv.h |   3 ++
 providers/mlx5/verbs.c  |   3 +-
 3 files changed, 138 insertions(+), 6 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 1b610fd..84c0d0b 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -63,11 +63,30 @@ enum {
 };
 
 enum {
+	MLX5_CQE_APP_OP_TM_CONSUMED = 0x1,
+	MLX5_CQE_APP_OP_TM_EXPECTED = 0x2,
+	MLX5_CQE_APP_OP_TM_UNEXPECTED = 0x3,
+	MLX5_CQE_APP_OP_TM_NO_TAG = 0x4,
 	MLX5_CQE_APP_OP_TM_APPEND = 0x5,
 	MLX5_CQE_APP_OP_TM_REMOVE = 0x6,
 	MLX5_CQE_APP_OP_TM_NOOP = 0x7,
+	MLX5_CQE_APP_OP_TM_CONSUMED_SW_RDNV = 0x9,
+	MLX5_CQE_APP_OP_TM_CONSUMED_MSG = 0xA,
+	MLX5_CQE_APP_OP_TM_CONSUMED_MSG_SW_RDNV = 0xB,
+	MLX5_CQE_APP_OP_TM_MSG_COMPLETION_CANCELED = 0xC,
 };
 
+
+/* When larger messages or rendezvous transfers are involved, matching and
+ * data transfer completion are distinct events that generate 2 completion
+ * events for the same recv_wr_id.
+ */
+static inline bool mlx5_cqe_app_op_tm_is_complete(int op)
+{
+	return op != MLX5_CQE_APP_OP_TM_CONSUMED &&
+	       op != MLX5_CQE_APP_OP_TM_CONSUMED_SW_RDNV;
+}
+
 enum {
 	MLX5_CQ_LAZY_FLAGS =
 		MLX5_CQ_FLAGS_RX_CSUM_VALID |
@@ -80,6 +99,10 @@ int mlx5_stall_cq_poll_max = 100000;
 int mlx5_stall_cq_inc_step = 100;
 int mlx5_stall_cq_dec_step = 10;
 
+enum {
+	MLX5_TM_MAX_SYNC_DIFF = 0x3fff
+};
+
 static inline uint8_t get_cqe_l3_hdr_type(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->l4_hdr_type_etc >> 2) & 0x3;
@@ -532,10 +555,44 @@ static int handle_tag_matching(struct mlx5_cq *cq,
 			       struct mlx5_srq *srq)
 {
 	FILE *fp = to_mctx(srq->vsrq.srq.context)->dbg_fp;
+	struct mlx5_tag_entry *tag;
 	struct mlx5_srq_op *op;
+	uint16_t wqe_ctr;
 
 	cq->ibv_cq.status = IBV_WC_SUCCESS;
 	switch (cqe64->app_op) {
+	case MLX5_CQE_APP_OP_TM_CONSUMED_MSG_SW_RDNV:
+	case MLX5_CQE_APP_OP_TM_CONSUMED_SW_RDNV:
+	case MLX5_CQE_APP_OP_TM_MSG_COMPLETION_CANCELED:
+		cq->ibv_cq.status = IBV_WC_TM_RNDV_INCOMPLETE;
+		SWITCH_FALLTHROUGH;
+
+	case MLX5_CQE_APP_OP_TM_CONSUMED_MSG:
+	case MLX5_CQE_APP_OP_TM_CONSUMED:
+	case MLX5_CQE_APP_OP_TM_EXPECTED:
+		mlx5_spin_lock(&srq->lock);
+		tag = &srq->tm_list[be16toh(cqe64->app_info)];
+		if (!tag->expect_cqe) {
+			mlx5_dbg(fp, MLX5_DBG_CQ, "got idx %d which wasn't added\n",
+				 be16toh(cqe64->app_info));
+			cq->ibv_cq.status = IBV_WC_GENERAL_ERR;
+			mlx5_spin_unlock(&srq->lock);
+			return CQ_OK;
+		}
+		cq->ibv_cq.wr_id = tag->wr_id;
+		if (mlx5_cqe_app_op_tm_is_complete(cqe64->app_op))
+			mlx5_tm_release_tag(srq, tag);
+		/* inline scatter 32 not supported for TM */
+		if (cqe64->op_own & MLX5_INLINE_SCATTER_64) {
+			if (be32toh(cqe64->byte_cnt) > tag->size)
+				cq->ibv_cq.status = IBV_WC_LOC_LEN_ERR;
+			else
+				memcpy(tag->ptr, cqe64 - 1,
+				       be32toh(cqe64->byte_cnt));
+		}
+		mlx5_spin_unlock(&srq->lock);
+		break;
+
 	case MLX5_CQE_APP_OP_TM_REMOVE:
 		if (!(be32toh(cqe64->tm_cqe.success) & MLX5_TMC_SUCCESS))
 			cq->ibv_cq.status = IBV_WC_TM_ERR;
@@ -575,6 +632,24 @@ static int handle_tag_matching(struct mlx5_cq *cq,
 
 		mlx5_spin_unlock(&srq->lock);
 		break;
+
+	case MLX5_CQE_APP_OP_TM_UNEXPECTED:
+		srq->unexp_in++;
+		if (srq->unexp_in - srq->unexp_out > MLX5_TM_MAX_SYNC_DIFF)
+			cq->flags |= MLX5_CQ_FLAGS_TM_SYNC_REQ;
+		SWITCH_FALLTHROUGH;
+
+	case MLX5_CQE_APP_OP_TM_NO_TAG:
+		wqe_ctr = be16toh(cqe64->wqe_counter);
+		cq->ibv_cq.wr_id = srq->wrid[wqe_ctr];
+		mlx5_free_srq_wqe(srq, wqe_ctr);
+		if (cqe64->op_own & MLX5_INLINE_SCATTER_32)
+			return mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe64,
+						    be32toh(cqe64->byte_cnt));
+		else if (cqe64->op_own & MLX5_INLINE_SCATTER_64)
+			return mlx5_copy_to_recv_srq(srq, wqe_ctr, cqe64 - 1,
+						    be32toh(cqe64->byte_cnt));
+		break;
 #ifdef MLX5_DEBUG
 	default:
 		mlx5_dbg(fp, MLX5_DBG_CQ, "un-expected TM opcode in cqe\n");
@@ -688,13 +763,23 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 		if (unlikely(err))
 			return CQ_POLL_ERR;
 
-		if (lazy)
-			cq->ibv_cq.status = handle_responder_lazy(cq, cqe64,
-							      *cur_rsc,
-							      is_srq ? *cur_srq : NULL);
-		else
+		if (lazy) {
+			if (likely(cqe64->app != MLX5_CQE_APP_TAG_MATCHING)) {
+				cq->ibv_cq.status = handle_responder_lazy
+					(cq, cqe64, *cur_rsc,
+					 is_srq ? *cur_srq : NULL);
+			} else {
+				if (unlikely(!is_srq))
+					return CQ_POLL_ERR;
+
+				err = handle_tag_matching(cq, cqe64, *cur_srq);
+				if (unlikely(err))
+					return CQ_POLL_ERR;
+			}
+		} else {
 			wc->status = handle_responder(wc, cqe64, *cur_rsc,
 					      is_srq ? *cur_srq : NULL);
+		}
 		break;
 
 	case MLX5_CQE_NO_PACKET:
@@ -1151,6 +1236,18 @@ static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 	case MLX5_CQE_RESP_SEND:
 	case MLX5_CQE_RESP_SEND_IMM:
 	case MLX5_CQE_RESP_SEND_INV:
+		if (unlikely(cq->cqe64->app == MLX5_CQE_APP_TAG_MATCHING)) {
+			switch (cq->cqe64->app_op) {
+			case MLX5_CQE_APP_OP_TM_CONSUMED_MSG_SW_RDNV:
+			case MLX5_CQE_APP_OP_TM_CONSUMED_MSG:
+			case MLX5_CQE_APP_OP_TM_CONSUMED_SW_RDNV:
+			case MLX5_CQE_APP_OP_TM_EXPECTED:
+			case MLX5_CQE_APP_OP_TM_UNEXPECTED:
+				return IBV_WC_TM_RECV;
+			case MLX5_CQE_APP_OP_TM_NO_TAG:
+				return IBV_WC_TM_NO_TAG;
+			}
+		}
 		return IBV_WC_RECV;
 	case MLX5_CQE_NO_PACKET:
 		switch (cq->cqe64->app_op) {
@@ -1160,6 +1257,8 @@ static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 			return IBV_WC_TM_ADD;
 		case MLX5_CQE_APP_OP_TM_NOOP:
 			return IBV_WC_TM_SYNC;
+		case MLX5_CQE_APP_OP_TM_CONSUMED:
+			return IBV_WC_TM_RECV;
 		}
 		break;
 	case MLX5_CQE_REQ:
@@ -1222,6 +1321,24 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 	if (cq->flags & MLX5_CQ_FLAGS_TM_SYNC_REQ)
 		wc_flags |= IBV_WC_TM_SYNC_REQ;
 
+	if (unlikely(cq->cqe64->app == MLX5_CQE_APP_TAG_MATCHING)) {
+		switch (cq->cqe64->app_op) {
+		case MLX5_CQE_APP_OP_TM_CONSUMED_MSG_SW_RDNV:
+		case MLX5_CQE_APP_OP_TM_CONSUMED_MSG:
+		case MLX5_CQE_APP_OP_TM_MSG_COMPLETION_CANCELED:
+						   /* Full completion */
+			wc_flags |= (IBV_WC_TM_MATCH | IBV_WC_TM_DATA_VALID);
+			break;
+		case MLX5_CQE_APP_OP_TM_CONSUMED_SW_RDNV:
+		case MLX5_CQE_APP_OP_TM_CONSUMED:  /* First completion */
+			wc_flags |= IBV_WC_TM_MATCH;
+			break;
+		case MLX5_CQE_APP_OP_TM_EXPECTED:  /* Second completion */
+			wc_flags |= IBV_WC_TM_DATA_VALID;
+			break;
+		}
+	}
+
 	wc_flags |= ((be32toh(cq->cqe64->flags_rqpn) >> 28) & 3) ? IBV_WC_GRH : 0;
 	return wc_flags;
 }
@@ -1305,6 +1422,15 @@ static inline uint32_t mlx5_cq_read_flow_tag(struct ibv_cq_ex *ibcq)
 	return be32toh(cq->cqe64->sop_drop_qpn) & MLX5_FLOW_TAG_MASK;
 }
 
+static inline void mlx5_cq_read_wc_tm_info(struct ibv_cq_ex *ibcq,
+					   struct ibv_wc_tm_info *tm_info)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	tm_info->tag = be64toh(cq->cqe64->tmh.tag);
+	tm_info->priv = be32toh(cq->cqe64->tmh.app_ctx);
+}
+
 #define BIT(i) (1UL << (i))
 
 #define SINGLE_THREADED BIT(0)
@@ -1381,6 +1507,8 @@ void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_
 		cq->ibv_cq.read_cvlan = mlx5_cq_read_wc_cvlan;
 	if (cq_attr->wc_flags & IBV_WC_EX_WITH_FLOW_TAG)
 		cq->ibv_cq.read_flow_tag = mlx5_cq_read_flow_tag;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_TM_INFO)
+		cq->ibv_cq.read_tm_info = mlx5_cq_read_wc_tm_info;
 }
 
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 00bb1e8..3537045 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -43,6 +43,7 @@
 #endif /* defined(__SSE3__) */
 
 #include <infiniband/verbs.h>
+#include <infiniband/tm_types.h>
 
 /* Always inline the functions */
 #ifdef __GNUC__
@@ -311,6 +312,8 @@ struct mlx5_cqe64 {
 			__be16		vlan_info;
 		};
 		struct mlx5_tm_cqe tm_cqe;
+		/* TMH is scattered to CQE upon match */
+		struct ibv_tmh tmh;
 	};
 	__be32		srqn_uidx;
 	__be32		imm_inval_pkey;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index f935fc8..b073d7b 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -330,7 +330,8 @@ enum {
 	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
 				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
 				       IBV_WC_EX_WITH_CVLAN |
-				       IBV_WC_EX_WITH_FLOW_TAG
+				       IBV_WC_EX_WITH_FLOW_TAG |
+				       IBV_WC_EX_WITH_TM_INFO
 };
 
 enum {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
