From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libqedr: remove fast-path debug prints
Date: Wed, 18 Jan 2017 14:26:38 +0200
Message-ID: <1484742398-6927-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the invocations of the macro FP_DP_VERBOSE().
They are not useful as enabling them causes a flood of prints.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index a7c4503..f24b1a2 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -54,10 +54,6 @@
 #include <stdlib.h>
 #include <execinfo.h>
 
-/* Fast path debug prints */
-#define FP_DP_VERBOSE(...)
-/* #define FP_DP_VERBOSE(...)	DP_VERBOSE(__VA_ARGS__) */
-
 #define QELR_SQE_ELEMENT_SIZE	(sizeof(struct rdma_sq_sge))
 #define QELR_RQE_ELEMENT_SIZE	(sizeof(struct rdma_rq_sge))
 #define QELR_CQE_SIZE		(sizeof(union rdma_cqe))
@@ -1208,9 +1204,6 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
 			qp->prev_wqe_size = swqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "SEND w/ IMM length = %d imm data=%x\n",
-				      swqe->length, wr->imm_data);
 			break;
 
 		case IBV_WR_SEND:
@@ -1230,9 +1223,6 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
 			qp->prev_wqe_size = swqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "SEND w/o IMM length = %d\n",
-				      swqe->length);
 			break;
 
 		case IBV_WR_RDMA_WRITE_WITH_IMM:
@@ -1257,9 +1247,6 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 			qp->prev_wqe_size = rwqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "RDMA WRITE w/ IMM length = %d imm data=%x\n",
-				      rwqe->length, rwqe->imm_data);
 			break;
 
 		case IBV_WR_RDMA_WRITE:
@@ -1281,9 +1268,6 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 			qp->prev_wqe_size = rwqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "RDMA WRITE w/o IMM length = %d\n",
-				      rwqe->length);
 			break;
 
 		case IBV_WR_RDMA_READ:
@@ -1301,13 +1285,10 @@ int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
 			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 			qp->prev_wqe_size = rwqe->wqe_size;
 			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "RDMA READ length = %d\n", rwqe->length);
 			break;
 
 		case IBV_WR_ATOMIC_CMP_AND_SWP:
 		case IBV_WR_ATOMIC_FETCH_AND_ADD:
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "ATOMIC\n");
 			if (!qp->atomic_supported) {
 				DP_ERR(cxt->dbg_fp,
 				       "Atomic not supported on this machine\n");
@@ -1422,9 +1403,6 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			*bad_wr = wr;
 			break;
 		}
-		FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-			      "RQ WR: SGEs: %d with wr_id[%d] = %lx\n",
-			      wr->num_sge, qp->rq.prod, wr->wr_id);
 		for (i = 0; i < wr->num_sge; i++) {
 			uint32_t flags = 0;
 			struct rdma_rq_sge *rqe;
@@ -1441,10 +1419,6 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			rqe = qelr_chain_produce(&qp->rq.chain);
 			RQ_SGE_SET(rqe, wr->sg_list[i].addr,
 				   wr->sg_list[i].length, flags);
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "[%d]: len %d key %x addr %x:%x\n", i,
-				      rqe->length, rqe->flags,
-				      rqe->first_addr.hi, rqe->first_addr.lo);
 		}
 		/* Special case of no sges. FW requires between 1-4 sges...
 		 * in this case we need to post 1 sge with length zero. this is
@@ -1482,8 +1456,6 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		wr = wr->next;
 	}
 
-	FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "POST: Elements in RespQ: %d\n",
-		      qelr_chain_get_elem_left_u32(&qp->rq.chain));
 	pthread_spin_unlock(&qp->q_lock);
 
 	return status;
@@ -1682,8 +1654,6 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 	wc->opcode = IBV_WC_RECV;
 	wc->wc_flags = 0;
 
-	FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ, "\n");
-
 	switch (resp->status) {
 	case RDMA_CQE_RESP_STS_LOCAL_ACCESS_ERR:
 		wc_status = IBV_WC_LOC_ACCESS_ERR;
@@ -1718,9 +1688,6 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 			wc->imm_data =
 				ntohl(le32toh(resp->imm_data_or_inv_r_Key));
 			wc->wc_flags |= IBV_WC_WITH_IMM;
-			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
-				      "POLL CQ RQ2: RESP_RDMA_IMM imm_data = %x resp_len=%d\n",
-				      wc->imm_data, wc->byte_len);
 			break;
 		case QELR_RESP_RDMA:
 			DP_ERR(cxt->dbg_fp, "Invalid flags detected\n");
@@ -1884,8 +1851,6 @@ int qelr_poll_cq(struct ibv_cq *ibcq, int num_entries, struct ibv_wc *wc)
 		 * but chain already point to the next INVALID one
 		 */
 		doorbell_cq(cq, db_cons, cq->arm_flags);
-		FP_DP_VERBOSE(stderr, QELR_MSG_CQ, "doorbell_cq cons=%x\n",
-			      db_cons);
 	}
 
 	return done;
@@ -1905,9 +1870,6 @@ int qelr_arm_cq(struct ibv_cq *ibcq, int solicited)
 	uint32_t db_cons;
 
 	db_cons = qelr_chain_get_cons_idx_u32(&cq->chain) - 1;
-	FP_DP_VERBOSE(get_qelr_ctx(ibcq->context)->dbg_fp, QELR_MSG_CQ,
-		      "Arm CQ cons=%x solicited=%d\n", db_cons, solicited);
-
 	cq->arm_flags = solicited ? DQ_UCM_ROCE_CQ_ARM_SE_CF_CMD :
 				    DQ_UCM_ROCE_CQ_ARM_CF_CMD;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
