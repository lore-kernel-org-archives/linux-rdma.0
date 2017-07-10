From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libqedr: fix bugs introduced in "sparse fixes"
Date: Mon, 10 Jul 2017 12:48:32 +0300
Message-ID: <1499680112-7347-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix byte swapping function (pointer must advance).
Fix WQE size to be multiples of 16 bytes, not 8 bytes.
Pass a pointer to wqe_size to allow it to be updated.
Update the immediate value before the wqe is copied.

Fixes: 259ddded0e16 ("libqedr: fix sparse warnings")

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h       |  1 +
 providers/qedr/qelr_verbs.c | 59 ++++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index b093509..05b1640 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -285,6 +285,7 @@ static inline struct qelr_cq *get_qelr_cq(struct ibv_cq *ibcq)
 	(((value) >> (name ## _SHIFT)) & name ## _MASK)
 
 #define ROCE_WQE_ELEM_SIZE	sizeof(struct rdma_sq_sge)
+#define RDMA_WQE_BYTES		(16)
 
 #define QELR_RESP_IMM (RDMA_CQE_RESPONDER_IMM_FLG_MASK <<	\
 			RDMA_CQE_RESPONDER_IMM_FLG_SHIFT)
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index fc4afdb..fb52f9d 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -1035,7 +1035,7 @@ static void qelr_prepare_sq_sges(struct qelr_qp *qp,
 static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 					  struct qelr_dpm *dpm,
 					  int data_size,
-					  uint8_t wqe_size,
+					  uint8_t *p_wqe_size,
 					  struct rdma_sq_rdma_wqe_1st *rwqe,
 					  struct rdma_sq_rdma_wqe_2nd *rwqe2,
 					  struct ibv_send_wr *wr,
@@ -1044,7 +1044,10 @@ static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 	memset(rwqe2, 0, sizeof(*rwqe2));
 	rwqe2->r_key = htole32(wr->wr.rdma.rkey);
 	TYPEPTR_ADDR_SET(rwqe2, remote_va, wr->wr.rdma.remote_addr);
-	rwqe->wqe_size = wqe_size;
+	rwqe->length = htole32(data_size);
+
+	if (is_imm)
+		rwqe->imm_data = htole32(be32toh(wr->imm_data));
 
 	if (wr->send_flags & IBV_SEND_INLINE &&
 	    (wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM ||
@@ -1053,48 +1056,45 @@ static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 
 		SET_FIELD2(flags, RDMA_SQ_RDMA_WQE_1ST_INLINE_FLG, 1);
 		qelr_prepare_sq_inline_data(qp, dpm, data_size,
-					    &rwqe->wqe_size, wr,
+					    p_wqe_size, wr,
 					    &rwqe->flags, flags);
+		rwqe->wqe_size = *p_wqe_size;
 	} else {
-		qelr_prepare_sq_sges(qp, dpm, &rwqe->wqe_size, wr);
+		qelr_prepare_sq_sges(qp, dpm, p_wqe_size, wr);
+		rwqe->wqe_size = *p_wqe_size;
 	}
 
-	rwqe->length = htole32(data_size);
-
-	if (is_imm)
-		rwqe->imm_data = htole32(be32toh(wr->imm_data));
-
 	return data_size;
 }
 
 static uint32_t qelr_prepare_sq_send_data(struct qelr_qp *qp,
 					  struct qelr_dpm *dpm,
 					  int data_size,
-					  uint8_t wqe_size,
+					  uint8_t *p_wqe_size,
 					  struct rdma_sq_send_wqe_1st *swqe,
 					  struct rdma_sq_send_wqe_2st *swqe2,
 					  struct ibv_send_wr *wr,
 					  bool is_imm)
 {
 	memset(swqe2, 0, sizeof(*swqe2));
-	swqe->wqe_size = wqe_size;
+	swqe->length = htole32(data_size);
+
+	if (is_imm)
+		swqe->inv_key_or_imm_data = htole32(be32toh(wr->imm_data));
 
 	if (wr->send_flags & IBV_SEND_INLINE) {
 		uint8_t flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_SEND_WQE_INLINE_FLG, 1);
 		qelr_prepare_sq_inline_data(qp, dpm, data_size,
-					    &swqe->wqe_size, wr,
+					    p_wqe_size, wr,
 					    &swqe->flags, flags);
+		swqe->wqe_size = *p_wqe_size;
 	} else {
-		qelr_prepare_sq_sges(qp, dpm, &swqe->wqe_size, wr);
+		qelr_prepare_sq_sges(qp, dpm, p_wqe_size, wr);
+		swqe->wqe_size = *p_wqe_size;
 	}
 
-	swqe->length = htole32(data_size);
-
-	if (is_imm)
-		swqe->inv_key_or_imm_data = htole32(be32toh(wr->imm_data));
-
 	return data_size;
 }
 
@@ -1261,14 +1261,14 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		wqe->req_type = RDMA_SQ_REQ_TYPE_SEND_WITH_IMM;
 		swqe = (struct rdma_sq_send_wqe_1st *)wqe;
 
-		wqe_size = sizeof(struct rdma_sq_send_wqe) / sizeof(uint64_t);
+		wqe_size = sizeof(struct rdma_sq_send_wqe) / RDMA_WQE_BYTES;
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
 
 		if (dpm.is_edpm)
 			qelr_edpm_set_inv_imm(qp, &dpm, wr->imm_data);
 
 		wqe_length = qelr_prepare_sq_send_data(qp, &dpm, data_size,
-						       wqe_size, swqe, swqe2,
+						       &wqe_size, swqe, swqe2,
 						       wr, 1 /* Imm */);
 
 		if (dpm.is_edpm)
@@ -1285,10 +1285,10 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		wqe->req_type = RDMA_SQ_REQ_TYPE_SEND;
 		swqe = (struct rdma_sq_send_wqe_1st *)wqe;
 
-		wqe_size = sizeof(struct rdma_sq_send_wqe) / sizeof(uint64_t);
+		wqe_size = sizeof(struct rdma_sq_send_wqe) / RDMA_WQE_BYTES;
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
 		wqe_length = qelr_prepare_sq_send_data(qp, &dpm, data_size,
-						       wqe_size, swqe, swqe2,
+						       &wqe_size, swqe, swqe2,
 						       wr, 0);
 
 		if (dpm.is_edpm)
@@ -1305,7 +1305,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR_WITH_IMM;
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
-		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / sizeof(uint64_t);
+		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / RDMA_WQE_BYTES;
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
 		if (dpm.is_edpm) {
 			qelr_edpm_set_rdma_ext(qp, &dpm, wr->wr.rdma.remote_addr,
@@ -1313,7 +1313,8 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 			qelr_edpm_set_inv_imm(qp, &dpm, wr->imm_data);
 		}
 
-		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, wqe_size, rwqe, rwqe2, wr, 1 /* Imm */);
+		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, &wqe_size,
+						       rwqe, rwqe2, wr, 1 /* Imm */);
 		if (dpm.is_edpm)
 			qelr_edpm_set_msg_data(qp, &dpm,
 					       QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE,
@@ -1328,14 +1329,15 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR;
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
-		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / sizeof(uint64_t);
+		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / RDMA_WQE_BYTES;
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
 		if (dpm.is_edpm)
 			qelr_edpm_set_rdma_ext(qp, &dpm,
 					       wr->wr.rdma.remote_addr,
 					       wr->wr.rdma.rkey);
 
-		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, wqe_size, rwqe, rwqe2, wr, 0);
+		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, &wqe_size,
+						       rwqe, rwqe2, wr, 0);
 		if (dpm.is_edpm)
 			qelr_edpm_set_msg_data(qp, &dpm,
 					       QELR_IB_OPCODE_RDMA_WRITE_ONLY,
@@ -1351,9 +1353,10 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_RD;
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
-		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / sizeof(uint64_t);
+		wqe_size = sizeof(struct rdma_sq_rdma_wqe) / RDMA_WQE_BYTES;
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
-		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, wqe_size, rwqe, rwqe2, wr, 0);
+		wqe_length = qelr_prepare_sq_rdma_data(qp, &dpm, data_size, &wqe_size,
+						       rwqe, rwqe2, wr, 0);
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = wqe_size;
 		qp->prev_wqe_size = wqe_size;
 		qp->wqe_wr_id[qp->sq.prod].bytes_len = wqe_length;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
