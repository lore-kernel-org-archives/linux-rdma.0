From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 1/2] libqedr: fix sparse warnings
Date: Tue, 4 Jul 2017 13:35:53 +0300
Message-ID: <1499164554-28552-2-git-send-email-Ram.Amrani@cavium.com>
References: <1499164554-28552-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499164554-28552-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Properly use __be and __le types and their conversions.
Do not use values stored in firmware structures as they are __le
and not host by nature. This avoids conversion back to host.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h       |   6 +-
 providers/qedr/qelr_verbs.c | 174 +++++++++++++++++++++++++-------------------
 2 files changed, 102 insertions(+), 78 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index 1a1032e..b093509 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -197,9 +197,9 @@ struct qelr_qp_hwq_info {
 };
 
 struct qelr_rdma_ext {
-	uint64_t remote_va;
-	uint32_t remote_key;
-	uint32_t dma_length;
+	__be64	remote_va;
+	__be32	remote_key;
+	__be32	dma_length;
 };
 
 /* rdma extension, invalidate / immediate data + padding, inline data... */
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 451f633..fc4afdb 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -44,6 +44,7 @@
 #include <malloc.h>
 #include <sys/mman.h>
 #include <unistd.h>
+#include <stdbool.h>
 
 #include "qelr.h"
 #include "qelr_abi.h"
@@ -856,10 +857,11 @@ static int sge_data_len(struct ibv_sge *sg_list, int num_sge)
 
 static void swap_wqe_data64(uint64_t *p)
 {
+	__be64 *bep=(__be64 *)p;
 	int i;
 
 	for (i = 0; i < ROCE_WQE_ELEM_SIZE / sizeof(uint64_t); i++, p++)
-		*p = htobe64(htole64(*p));
+		*bep = htobe64(*p);
 }
 
 static inline void qelr_init_dpm_info(struct qelr_devctx *cxt,
@@ -893,32 +895,26 @@ static inline void qelr_edpm_set_msg_data(struct qelr_qp *qp,
 					  uint8_t se,
 					  uint8_t comp)
 {
-	uint32_t wqe_size, dpm_size;
+	uint32_t wqe_size, dpm_size, params;
+
+	params = 0;
 	wqe_size = length + (QELR_IS_IMM(opcode)? sizeof(uint32_t) : 0);
 	dpm_size = wqe_size + sizeof(struct db_roce_dpm_data);
 
-	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_SIZE,
+	SET_FIELD(params, DB_ROCE_DPM_PARAMS_DPM_TYPE, DPM_ROCE);
+	SET_FIELD(params, DB_ROCE_DPM_PARAMS_OPCODE, opcode);
+	SET_FIELD(params, DB_ROCE_DPM_PARAMS_WQE_SIZE, wqe_size);
+	SET_FIELD(params, DB_ROCE_DPM_PARAMS_COMPLETION_FLG, comp ? 1 : 0);
+	SET_FIELD(params, DB_ROCE_DPM_PARAMS_S_FLG, se ? 1 : 0);
+	SET_FIELD(params, DB_ROCE_DPM_PARAMS_SIZE,
 		  (dpm_size + sizeof(uint64_t) - 1) / sizeof(uint64_t));
 
-	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_DPM_TYPE,
-		  DPM_ROCE);
-
-	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_OPCODE,
-		  opcode);
-
-	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_WQE_SIZE,
-		  wqe_size);
-
-	SET_FIELD(dpm->msg.data.params.params,
-		  DB_ROCE_DPM_PARAMS_COMPLETION_FLG, comp ? 1 : 0);
-
-	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_S_FLG,
-		  se ? 1 : 0);
+	dpm->msg.data.params.params = htole32(params);
 }
 
 static inline void qelr_edpm_set_inv_imm(struct qelr_qp *qp,
 					 struct qelr_dpm *dpm,
-					 uint32_t data)
+					 __be32 data)
 {
 	memcpy(&dpm->payload[dpm->payload_offset], &data, sizeof(data));
 
@@ -1036,16 +1032,19 @@ static void qelr_prepare_sq_sges(struct qelr_qp *qp,
 		*wqe_size += wr->num_sge;
 }
 
-static void qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
-				      struct qelr_dpm *dpm,
-				      int data_size,
-				      struct rdma_sq_rdma_wqe_1st *rwqe,
-				      struct rdma_sq_rdma_wqe_2nd *rwqe2,
-				      struct ibv_send_wr *wr)
+static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
+					  struct qelr_dpm *dpm,
+					  int data_size,
+					  uint8_t wqe_size,
+					  struct rdma_sq_rdma_wqe_1st *rwqe,
+					  struct rdma_sq_rdma_wqe_2nd *rwqe2,
+					  struct ibv_send_wr *wr,
+					  bool is_imm)
 {
 	memset(rwqe2, 0, sizeof(*rwqe2));
 	rwqe2->r_key = htole32(wr->wr.rdma.rkey);
 	TYPEPTR_ADDR_SET(rwqe2, remote_va, wr->wr.rdma.remote_addr);
+	rwqe->wqe_size = wqe_size;
 
 	if (wr->send_flags & IBV_SEND_INLINE &&
 	    (wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM ||
@@ -1059,17 +1058,27 @@ static void qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 	} else {
 		qelr_prepare_sq_sges(qp, dpm, &rwqe->wqe_size, wr);
 	}
+
 	rwqe->length = htole32(data_size);
+
+	if (is_imm)
+		rwqe->imm_data = htole32(be32toh(wr->imm_data));
+
+	return data_size;
 }
 
-static void qelr_prepare_sq_send_data(struct qelr_qp *qp,
-				      struct qelr_dpm *dpm,
-				      int data_size,
-				      struct rdma_sq_send_wqe_1st *swqe,
-				      struct rdma_sq_send_wqe_2st *swqe2,
-				      struct ibv_send_wr *wr)
+static uint32_t qelr_prepare_sq_send_data(struct qelr_qp *qp,
+					  struct qelr_dpm *dpm,
+					  int data_size,
+					  uint8_t wqe_size,
+					  struct rdma_sq_send_wqe_1st *swqe,
+					  struct rdma_sq_send_wqe_2st *swqe2,
+					  struct ibv_send_wr *wr,
+					  bool is_imm)
 {
 	memset(swqe2, 0, sizeof(*swqe2));
+	swqe->wqe_size = wqe_size;
+
 	if (wr->send_flags & IBV_SEND_INLINE) {
 		uint8_t flags = 0;
 
@@ -1082,6 +1091,11 @@ static void qelr_prepare_sq_send_data(struct qelr_qp *qp,
 	}
 
 	swqe->length = htole32(data_size);
+
+	if (is_imm)
+		swqe->inv_key_or_imm_data = htole32(be32toh(wr->imm_data));
+
+	return data_size;
 }
 
 static enum ibv_wc_opcode qelr_ibv_to_wc_opcode(enum ibv_wr_opcode opcode)
@@ -1218,6 +1232,8 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 	struct rdma_sq_atomic_wqe_2nd *awqe2;
 	struct rdma_sq_atomic_wqe_3rd *awqe3;
 	struct qelr_dpm dpm;
+	uint32_t wqe_length;
+	uint8_t wqe_size;
 	uint16_t db_val;
 	int rc = 0;
 
@@ -1245,45 +1261,51 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		wqe->req_type = RDMA_SQ_REQ_TYPE_SEND_WITH_IMM;
 		swqe = (struct rdma_sq_send_wqe_1st *)wqe;
 
-		swqe->wqe_size = 2;
+		wqe_size = sizeof(struct rdma_sq_send_wqe) / sizeof(uint64_t);
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
-		swqe->inv_key_or_imm_data = htobe32(htole32(wr->imm_data));
+
 		if (dpm.is_edpm)
 			qelr_edpm_set_inv_imm(qp, &dpm, wr->imm_data);
 
-		qelr_prepare_sq_send_data(qp, &dpm, data_size, swqe, swqe2, wr);
+		wqe_length = qelr_prepare_sq_send_data(qp, &dpm, data_size,
+						       wqe_size, swqe, swqe2,
+						       wr, 1 /* Imm */);
+
 		if (dpm.is_edpm)
 			qelr_edpm_set_msg_data(qp, &dpm,
 					       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
-					       swqe->length, se, comp);
-		qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
-		qp->prev_wqe_size = swqe->wqe_size;
-		qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
+					       wqe_length, se, comp);
+
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = wqe_size;
+		qp->prev_wqe_size = wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = wqe_length;
 		break;
 
 	case IBV_WR_SEND:
 		wqe->req_type = RDMA_SQ_REQ_TYPE_SEND;
 		swqe = (struct rdma_sq_send_wqe_1st *)wqe;
 
-		swqe->wqe_size = 2;
+		wqe_size = sizeof(struct rdma_sq_send_wqe) / sizeof(uint64_t);
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
-		qelr_prepare_sq_send_data(qp, &dpm, data_size, swqe, swqe2, wr);
+		wqe_length = qelr_prepare_sq_send_data(qp, &dpm, data_size,
+						       wqe_size, swqe, swqe2,
+						       wr, 0);
 
 		if (dpm.is_edpm)
 			qelr_edpm_set_msg_data(qp, &dpm,
 					       QELR_IB_OPCODE_SEND_ONLY,
-					       swqe->length, se, comp);
-		qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
-		qp->prev_wqe_size = swqe->wqe_size;
-		qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
+					       wqe_length, se, comp);
+
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = wqe_size;
+		qp->prev_wqe_size = wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = wqe_length;
 		break;
 
 	case IBV_WR_RDMA_WRITE_WITH_IMM:
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR_WITH_IMM;
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
-		rwqe->wqe_size = 2;
-		rwqe->imm_data = htobe32(htole32(wr->imm_data));
+		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / sizeof(uint64_t);
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
 		if (dpm.is_edpm) {
 			qelr_edpm_set_rdma_ext(qp, &dpm, wr->wr.rdma.remote_addr,
@@ -1291,50 +1313,50 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 			qelr_edpm_set_inv_imm(qp, &dpm, wr->imm_data);
 		}
 
-		qelr_prepare_sq_rdma_data(qp, &dpm, data_size, rwqe, rwqe2, wr);
+		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, wqe_size, rwqe, rwqe2, wr, 1 /* Imm */);
 		if (dpm.is_edpm)
 			qelr_edpm_set_msg_data(qp, &dpm,
 					       QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE,
-					       rwqe->length + sizeof(*dpm.rdma_ext),
+					       wqe_length + sizeof(*dpm.rdma_ext),
 					       se, comp);
-		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
-		qp->prev_wqe_size = rwqe->wqe_size;
-		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = wqe_size;
+		qp->prev_wqe_size = wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = wqe_length;
 		break;
 
 	case IBV_WR_RDMA_WRITE:
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR;
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
-		rwqe->wqe_size = 2;
+		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / sizeof(uint64_t);
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
 		if (dpm.is_edpm)
 			qelr_edpm_set_rdma_ext(qp, &dpm,
 					       wr->wr.rdma.remote_addr,
 					       wr->wr.rdma.rkey);
 
-		qelr_prepare_sq_rdma_data(qp, &dpm, data_size, rwqe, rwqe2, wr);
+		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, wqe_size, rwqe, rwqe2, wr, 0);
 		if (dpm.is_edpm)
 			qelr_edpm_set_msg_data(qp, &dpm,
 					       QELR_IB_OPCODE_RDMA_WRITE_ONLY,
-					       rwqe->length +
+					       wqe_length +
 					       sizeof(*dpm.rdma_ext),
 					       se, comp);
-		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
-		qp->prev_wqe_size = rwqe->wqe_size;
-		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = wqe_size;
+		qp->prev_wqe_size = wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = wqe_length;
 		break;
 
 	case IBV_WR_RDMA_READ:
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_RD;
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
-		rwqe->wqe_size = 2;
+		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / sizeof(uint64_t);
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
-		qelr_prepare_sq_rdma_data(qp, &dpm, data_size, rwqe, rwqe2, wr);
-		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
-		qp->prev_wqe_size = rwqe->wqe_size;
-		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
+		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, wqe_size, rwqe, rwqe2, wr, 0);
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = wqe_size;
+		qp->prev_wqe_size = wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = wqe_length;
 		break;
 
 	case IBV_WR_ATOMIC_CMP_AND_SWP:
@@ -1548,7 +1570,7 @@ static struct qelr_qp *cqe_get_qp(union rdma_cqe *cqe)
 {
 	struct regpair *qph = &cqe->req.qp_handle;
 
-	return (struct qelr_qp *)HILO_U64(qph->hi, qph->lo);
+	return (struct qelr_qp *)HILO_U64(le32toh(qph->hi), le32toh(qph->lo));
 }
 
 static int process_req(struct qelr_qp *qp, struct qelr_cq *cq, int num_entries,
@@ -1612,24 +1634,25 @@ static int qelr_poll_cq_req(struct qelr_qp *qp, struct qelr_cq *cq,
 			    struct rdma_cqe_requester *req)
 {
 	struct qelr_devctx *cxt = get_qelr_ctx(qp->ibv_qp.context);
+	uint16_t sq_cons = le16toh(req->sq_cons);
 	int cnt = 0;
 
 	switch (req->status) {
 	case RDMA_CQE_REQ_STS_OK:
-		cnt = process_req(qp, cq, num_entries, wc, req->sq_cons,
+		cnt = process_req(qp, cq, num_entries, wc, sq_cons,
 				  IBV_WC_SUCCESS, 0);
 		break;
 	case RDMA_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR:
 		DP_ERR(cxt->dbg_fp,
 		       "Error: POLL CQ with ROCE_CQE_REQ_STS_WORK_REQUEST_FLUSHED_ERR. QP icid=0x%x\n",
 		       qp->sq.icid);
-		cnt = process_req(qp, cq, num_entries, wc, req->sq_cons,
+		cnt = process_req(qp, cq, num_entries, wc, sq_cons,
 				  IBV_WC_WR_FLUSH_ERR, 0);
 		break;
 	default: /* other errors case */
 		/* process all WQE before the consumer */
 		qp->state = QELR_QPS_ERR;
-		cnt = process_req(qp, cq, num_entries, wc, req->sq_cons - 1,
+		cnt = process_req(qp, cq, num_entries, wc, sq_cons - 1,
 				  IBV_WC_SUCCESS, 0);
 		wc += cnt;
 		/* if we have extra WC fill it with actual error info */
@@ -1704,8 +1727,8 @@ static int qelr_poll_cq_req(struct qelr_qp *qp, struct qelr_cq *cq,
 				wc_status = IBV_WC_GENERAL_ERR;
 			}
 
-			cnt += process_req(qp, cq, 1, wc, req->sq_cons,
-					   wc_status, 1 /* force use of WC */);
+			cnt += process_req(qp, cq, 1, wc, sq_cons, wc_status,
+					   1 /* force use of WC */);
 		}
 	}
 
@@ -1754,8 +1777,7 @@ static void __process_resp_one(struct qelr_qp *qp, struct qelr_cq *cq,
 			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
 			SWITCH_FALLTHROUGH;
 		case QELR_RESP_IMM:
-			wc->imm_data =
-				be32toh(le32toh(resp->imm_data_or_inv_r_Key));
+			wc->imm_data = htobe32(le32toh(resp->imm_data_or_inv_r_Key));
 			wc->wc_flags |= IBV_WC_WITH_IMM;
 			break;
 		case QELR_RESP_RDMA:
@@ -1825,7 +1847,9 @@ static union rdma_cqe *get_cqe(struct qelr_cq *cq)
 static void try_consume_req_cqe(struct qelr_cq *cq, struct qelr_qp *qp,
 				struct rdma_cqe_requester *req, int *update)
 {
-	if (le16toh(req->sq_cons) == qp->sq.wqe_cons) {
+	uint16_t sq_cons = le16toh(req->sq_cons);
+
+	if (sq_cons == qp->sq.wqe_cons) {
 		consume_cqe(cq);
 		*update |= 1;
 	}
@@ -1833,9 +1857,9 @@ static void try_consume_req_cqe(struct qelr_cq *cq, struct qelr_qp *qp,
 
 /* used with flush only, when resp->rq_cons is valid */
 static void try_consume_resp_cqe(struct qelr_cq *cq, struct qelr_qp *qp,
-				 struct rdma_cqe_responder *resp, int *update)
+				 uint16_t rq_cons, int *update)
 {
-	if (le16toh(resp->rq_cons) == qp->rq.wqe_cons) {
+	if (rq_cons == qp->rq.wqe_cons) {
 		consume_cqe(cq);
 		*update |= 1;
 	}
@@ -1845,12 +1869,12 @@ static int qelr_poll_cq_resp(struct qelr_qp *qp, struct qelr_cq *cq,
 			     int num_entries, struct ibv_wc *wc,
 			     struct rdma_cqe_responder *resp, int *update)
 {
+	uint16_t rq_cons = le16toh(resp->rq_cons);
 	int cnt;
 
 	if (resp->status == RDMA_CQE_RESP_STS_WORK_REQUEST_FLUSHED_ERR) {
-		cnt = process_resp_flush(qp, cq, num_entries, wc,
-					 resp->rq_cons);
-		try_consume_resp_cqe(cq, qp, resp, update);
+		cnt = process_resp_flush(qp, cq, num_entries, wc, rq_cons);
+		try_consume_resp_cqe(cq, qp, rq_cons, update);
 	} else {
 		cnt = process_resp_one(qp, cq, wc, resp);
 		consume_cqe(cq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
