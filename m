From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libqedr: Sort out dpm/edpm naming
Date: Sun, 2 Jul 2017 12:09:25 +0300
Message-ID: <1498986565-2756-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

DPM stands for Direct Packet Mode while EDPM stands for Enhanced DPM.
Give more meaningful naming to the structures and functions to reduce
possible confusion.
Also avoid entering E/DPM functions if not in E/DPM to begin with.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h       |  11 +--
 providers/qedr/qelr_verbs.c | 198 ++++++++++++++++++++++----------------------
 2 files changed, 107 insertions(+), 102 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index 0dd6835..1a1032e 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -205,16 +205,17 @@ struct qelr_rdma_ext {
 /* rdma extension, invalidate / immediate data + padding, inline data... */
 #define QELR_MAX_DPM_PAYLOAD (sizeof(struct qelr_rdma_ext) + sizeof(uint64_t) +\
 			       ROCE_REQ_MAX_INLINE_DATA_SIZE)
-struct qelr_edpm {
+struct qelr_dpm {
+	uint8_t			is_edpm;
 	union {
 		struct db_roce_dpm_data	data;
 		uint64_t raw;
 	} msg;
 
-	uint8_t			dpm_payload[QELR_MAX_DPM_PAYLOAD];
-	uint32_t		dpm_payload_size;
-	uint32_t		dpm_payload_offset;
-	uint8_t			is_edpm;
+	uint8_t			payload[QELR_MAX_DPM_PAYLOAD];
+	uint32_t		payload_size;
+	uint32_t		payload_offset;
+
 	struct qelr_rdma_ext    *rdma_ext;
 };
 
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index d44e28b..451f633 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -862,19 +862,19 @@ static void swap_wqe_data64(uint64_t *p)
 		*p = htobe64(htole64(*p));
 }
 
-static inline void qelr_init_edpm_info(struct qelr_devctx *cxt,
-				       struct qelr_qp *qp,
-				       struct ibv_send_wr *wr,
-				       struct qelr_edpm *edpm,
-				       int data_size)
+static inline void qelr_init_dpm_info(struct qelr_devctx *cxt,
+				      struct qelr_qp *qp,
+				      struct ibv_send_wr *wr,
+				      struct qelr_dpm *dpm,
+				      int data_size)
 {
-	edpm->is_edpm = 0;
+	dpm->is_edpm = 0;
 
 	if (qelr_chain_is_full(&qp->sq.chain) &&
 	    wr->send_flags & IBV_SEND_INLINE && !qp->edpm_disabled) {
-		memset(edpm, 0, sizeof(*edpm));
-		edpm->rdma_ext = (struct qelr_rdma_ext *)&edpm->dpm_payload;
-		edpm->is_edpm = 1;
+		memset(dpm, 0, sizeof(*dpm));
+		dpm->rdma_ext = (struct qelr_rdma_ext *)&dpm->payload;
+		dpm->is_edpm = 1;
 	}
 }
 
@@ -887,80 +887,67 @@ static inline void qelr_init_edpm_info(struct qelr_devctx *cxt,
 	 (opcode == QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE))
 
 static inline void qelr_edpm_set_msg_data(struct qelr_qp *qp,
-					  struct qelr_edpm *edpm,
+					  struct qelr_dpm *dpm,
 					  uint8_t opcode,
 					  uint16_t length,
 					  uint8_t se,
 					  uint8_t comp)
 {
-	uint32_t wqe_size = length + (QELR_IS_IMM(opcode)? sizeof(uint32_t) : 0);
-	uint32_t dpm_size = wqe_size + sizeof(struct db_roce_dpm_data);
+	uint32_t wqe_size, dpm_size;
+	wqe_size = length + (QELR_IS_IMM(opcode)? sizeof(uint32_t) : 0);
+	dpm_size = wqe_size + sizeof(struct db_roce_dpm_data);
 
-	if (!edpm->is_edpm)
-		return;
-
-	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_SIZE,
+	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_SIZE,
 		  (dpm_size + sizeof(uint64_t) - 1) / sizeof(uint64_t));
 
-	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_DPM_TYPE,
+	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_DPM_TYPE,
 		  DPM_ROCE);
 
-	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_OPCODE,
+	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_OPCODE,
 		  opcode);
 
-	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_WQE_SIZE,
+	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_WQE_SIZE,
 		  wqe_size);
 
-	SET_FIELD(edpm->msg.data.params.params,
+	SET_FIELD(dpm->msg.data.params.params,
 		  DB_ROCE_DPM_PARAMS_COMPLETION_FLG, comp ? 1 : 0);
 
-	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_S_FLG,
+	SET_FIELD(dpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_S_FLG,
 		  se ? 1 : 0);
 }
 
 static inline void qelr_edpm_set_inv_imm(struct qelr_qp *qp,
-					 struct qelr_edpm *edpm,
-					 uint32_t inv_key_or_imm_data)
+					 struct qelr_dpm *dpm,
+					 uint32_t data)
 {
-	if (!edpm->is_edpm)
-		return;
-
-	memcpy(&edpm->dpm_payload[edpm->dpm_payload_offset],
-	       &inv_key_or_imm_data, sizeof(inv_key_or_imm_data));
+	memcpy(&dpm->payload[dpm->payload_offset], &data, sizeof(data));
 
-	edpm->dpm_payload_offset += sizeof(inv_key_or_imm_data);
-	edpm->dpm_payload_size += sizeof(inv_key_or_imm_data);
+	dpm->payload_offset += sizeof(data);
+	dpm->payload_size += sizeof(data);
 }
 
 static inline void qelr_edpm_set_rdma_ext(struct qelr_qp *qp,
-					  struct qelr_edpm *edpm,
+					  struct qelr_dpm *dpm,
 					  uint64_t remote_addr,
 					  uint32_t rkey)
 {
-	if (!edpm->is_edpm)
-		return;
-
-	edpm->rdma_ext->remote_va = htobe64(remote_addr);
-	edpm->rdma_ext->remote_key = htobe32(rkey);
-	edpm->dpm_payload_offset += sizeof(*edpm->rdma_ext);
-	edpm->dpm_payload_size += sizeof(*edpm->rdma_ext);
+	dpm->rdma_ext->remote_va = htobe64(remote_addr);
+	dpm->rdma_ext->remote_key = htobe32(rkey);
+	dpm->payload_offset += sizeof(*dpm->rdma_ext);
+	dpm->payload_size += sizeof(*dpm->rdma_ext);
 }
 
 static inline void qelr_edpm_set_payload(struct qelr_qp *qp,
-					 struct qelr_edpm *edpm, char *buf,
+					 struct qelr_dpm *dpm, char *buf,
 					 uint32_t length)
 {
-	if (!edpm->is_edpm)
-		return;
-
-	memcpy(&edpm->dpm_payload[edpm->dpm_payload_offset], buf,
-	       length);
+	memcpy(&dpm->payload[dpm->payload_offset], buf, length);
 
-	edpm->dpm_payload_offset += length;
+	dpm->payload_offset += length;
 }
 
 static void qelr_prepare_sq_inline_data(struct qelr_qp *qp,
-					    struct qelr_edpm *edpm,
+					    struct qelr_dpm *dpm,
 					    int data_size,
 					    uint8_t *wqe_size,
 					    struct ibv_send_wr *wr,
@@ -985,7 +972,8 @@ static void qelr_prepare_sq_inline_data(struct qelr_qp *qp,
 		uint32_t len = wr->sg_list[i].length;
 		void *src = (void *)(uintptr_t)wr->sg_list[i].addr;
 
-		qelr_edpm_set_payload(qp, edpm, src, wr->sg_list[i].length);
+		if (dpm->is_edpm)
+			qelr_edpm_set_payload(qp, dpm, src, len);
 
 		while (len > 0) {
 			uint32_t cur;
@@ -1020,16 +1008,17 @@ static void qelr_prepare_sq_inline_data(struct qelr_qp *qp,
 	if (seg_siz)
 		swap_wqe_data64((uint64_t *)wqe);
 
-	if (edpm->is_edpm) {
-		edpm->dpm_payload_size += data_size;
+	if (dpm->is_edpm) {
+		dpm->payload_size += data_size;
 
 		if (wr->opcode == IBV_WR_RDMA_WRITE ||
 		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
-			edpm->rdma_ext->dma_length = htobe32(data_size);
+			dpm->rdma_ext->dma_length = htobe32(data_size);
 	}
 }
 
 static void qelr_prepare_sq_sges(struct qelr_qp *qp,
+				 struct qelr_dpm *dpm,
 				     uint8_t *wqe_size,
 				     struct ibv_send_wr *wr)
 {
@@ -1048,7 +1037,7 @@ static void qelr_prepare_sq_sges(struct qelr_qp *qp,
 }
 
 static void qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
-				      struct qelr_edpm *edpm,
+				      struct qelr_dpm *dpm,
 				      int data_size,
 				      struct rdma_sq_rdma_wqe_1st *rwqe,
 				      struct rdma_sq_rdma_wqe_2nd *rwqe2,
@@ -1064,17 +1053,17 @@ static void qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 		uint8_t flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_RDMA_WQE_1ST_INLINE_FLG, 1);
-		qelr_prepare_sq_inline_data(qp, edpm, data_size,
+		qelr_prepare_sq_inline_data(qp, dpm, data_size,
 					    &rwqe->wqe_size, wr,
 					    &rwqe->flags, flags);
 	} else {
-		qelr_prepare_sq_sges(qp, &rwqe->wqe_size, wr);
+		qelr_prepare_sq_sges(qp, dpm, &rwqe->wqe_size, wr);
 	}
 	rwqe->length = htole32(data_size);
 }
 
 static void qelr_prepare_sq_send_data(struct qelr_qp *qp,
-				      struct qelr_edpm *edpm,
+				      struct qelr_dpm *dpm,
 				      int data_size,
 				      struct rdma_sq_send_wqe_1st *swqe,
 				      struct rdma_sq_send_wqe_2st *swqe2,
@@ -1085,11 +1074,11 @@ static void qelr_prepare_sq_send_data(struct qelr_qp *qp,
 		uint8_t flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_SEND_WQE_INLINE_FLG, 1);
-		qelr_prepare_sq_inline_data(qp, edpm, data_size,
+		qelr_prepare_sq_inline_data(qp, dpm, data_size,
 					    &swqe->wqe_size, wr,
 					    &swqe->flags, flags);
 	} else {
-		qelr_prepare_sq_sges(qp, &swqe->wqe_size, wr);
+		qelr_prepare_sq_sges(qp, dpm, &swqe->wqe_size, wr);
 	}
 
 	swqe->length = htole32(data_size);
@@ -1122,12 +1111,12 @@ static inline void doorbell_qp(struct qelr_qp *qp)
 	mmio_flush_writes();
 }
 
-static inline void doorbell_edpm_qp(struct qelr_devctx *cxt, struct qelr_qp *qp,
-				    struct qelr_edpm *edpm)
+static inline void doorbell_dpm_qp(struct qelr_devctx *cxt, struct qelr_qp *qp,
+				   struct qelr_dpm *dpm)
 {
 	uint32_t offset = 0;
 	uint64_t data;
-	uint64_t *dpm_payload = (uint64_t *)edpm->dpm_payload;
+	uint64_t *payload = (uint64_t *)dpm->payload;
 	uint32_t num_dwords;
 	int bytes = 0;
 	void *db_addr;
@@ -1135,20 +1124,20 @@ static inline void doorbell_edpm_qp(struct qelr_devctx *cxt, struct qelr_qp *qp,
 	mmio_wc_start();
 
 	/* Write message header */
-	edpm->msg.data.icid = qp->sq.db_data.data.icid;
-	edpm->msg.data.prod_val = qp->sq.db_data.data.value;
+	dpm->msg.data.icid = qp->sq.db_data.data.icid;
+	dpm->msg.data.prod_val = qp->sq.db_data.data.value;
 	db_addr = qp->sq.edpm_db;
-	writeq(edpm->msg.raw, db_addr);
+	writeq(dpm->msg.raw, db_addr);
 
 
 	/* Write mesage body */
 	bytes += sizeof(uint64_t);
-	num_dwords = (edpm->dpm_payload_size + sizeof(uint64_t) - 1) /
+	num_dwords = (dpm->payload_size + sizeof(uint64_t) - 1) /
 		sizeof(uint64_t);
-	db_addr += sizeof(edpm->msg.data);
+	db_addr += sizeof(dpm->msg.data);
 
 	while (offset < num_dwords) {
-		data = dpm_payload[offset];
+		data = payload[offset];
 		writeq(data, db_addr);
 
 		bytes += sizeof(uint64_t);
@@ -1217,7 +1206,7 @@ static inline int qelr_can_post_send(struct qelr_devctx *cxt,
 
 static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 			    struct ibv_send_wr *wr, int data_size,
-			    int *doorbell_required)
+			    int *normal_db_required)
 {
 	uint8_t se, comp, fence;
 	struct rdma_sq_common_wqe *wqe;
@@ -1228,11 +1217,11 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 	struct rdma_sq_atomic_wqe_1st *awqe1;
 	struct rdma_sq_atomic_wqe_2nd *awqe2;
 	struct rdma_sq_atomic_wqe_3rd *awqe3;
-	struct qelr_edpm edpm;
+	struct qelr_dpm dpm;
 	uint16_t db_val;
 	int rc = 0;
 
-	qelr_init_edpm_info(cxt, qp, wr, &edpm, data_size);
+	qelr_init_dpm_info(cxt, qp, wr, &dpm, data_size);
 
 	wqe = qelr_chain_produce(&qp->sq.chain);
 
@@ -1259,11 +1248,14 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		swqe->wqe_size = 2;
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
 		swqe->inv_key_or_imm_data = htobe32(htole32(wr->imm_data));
-		qelr_edpm_set_inv_imm(qp, &edpm, wr->imm_data);
-		qelr_prepare_sq_send_data(qp, &edpm, data_size, swqe, swqe2, wr);
-		qelr_edpm_set_msg_data(qp, &edpm,
-				       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
-				       swqe->length, se, comp);
+		if (dpm.is_edpm)
+			qelr_edpm_set_inv_imm(qp, &dpm, wr->imm_data);
+
+		qelr_prepare_sq_send_data(qp, &dpm, data_size, swqe, swqe2, wr);
+		if (dpm.is_edpm)
+			qelr_edpm_set_msg_data(qp, &dpm,
+					       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
+					       swqe->length, se, comp);
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
 		qp->prev_wqe_size = swqe->wqe_size;
 		qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
@@ -1275,9 +1267,12 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 
 		swqe->wqe_size = 2;
 		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
-		qelr_prepare_sq_send_data(qp, &edpm, data_size, swqe, swqe2, wr);
-		qelr_edpm_set_msg_data(qp, &edpm, QELR_IB_OPCODE_SEND_ONLY,
-				       swqe->length, se, comp);
+		qelr_prepare_sq_send_data(qp, &dpm, data_size, swqe, swqe2, wr);
+
+		if (dpm.is_edpm)
+			qelr_edpm_set_msg_data(qp, &dpm,
+					       QELR_IB_OPCODE_SEND_ONLY,
+					       swqe->length, se, comp);
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
 		qp->prev_wqe_size = swqe->wqe_size;
 		qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
@@ -1289,15 +1284,19 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 
 		rwqe->wqe_size = 2;
 		rwqe->imm_data = htobe32(htole32(wr->imm_data));
-		qelr_edpm_set_rdma_ext(qp, &edpm, wr->wr.rdma.remote_addr,
-				       wr->wr.rdma.rkey);
-		qelr_edpm_set_inv_imm(qp, &edpm, wr->imm_data);
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
-		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
-		qelr_edpm_set_msg_data(qp, &edpm,
-				       QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE,
-				       rwqe->length + sizeof(*edpm.rdma_ext),
-				       se, comp);
+		if (dpm.is_edpm) {
+			qelr_edpm_set_rdma_ext(qp, &dpm, wr->wr.rdma.remote_addr,
+					       wr->wr.rdma.rkey);
+			qelr_edpm_set_inv_imm(qp, &dpm, wr->imm_data);
+		}
+
+		qelr_prepare_sq_rdma_data(qp, &dpm, data_size, rwqe, rwqe2, wr);
+		if (dpm.is_edpm)
+			qelr_edpm_set_msg_data(qp, &dpm,
+					       QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE,
+					       rwqe->length + sizeof(*dpm.rdma_ext),
+					       se, comp);
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 		qp->prev_wqe_size = rwqe->wqe_size;
 		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
@@ -1308,14 +1307,19 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
 
 		rwqe->wqe_size = 2;
-		qelr_edpm_set_rdma_ext(qp, &edpm, wr->wr.rdma.remote_addr,
-				       wr->wr.rdma.rkey);
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
-		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
-		qelr_edpm_set_msg_data(qp, &edpm,
-				       QELR_IB_OPCODE_RDMA_WRITE_ONLY,
-				       rwqe->length + sizeof(*edpm.rdma_ext),
-				       se, comp);
+		if (dpm.is_edpm)
+			qelr_edpm_set_rdma_ext(qp, &dpm,
+					       wr->wr.rdma.remote_addr,
+					       wr->wr.rdma.rkey);
+
+		qelr_prepare_sq_rdma_data(qp, &dpm, data_size, rwqe, rwqe2, wr);
+		if (dpm.is_edpm)
+			qelr_edpm_set_msg_data(qp, &dpm,
+					       QELR_IB_OPCODE_RDMA_WRITE_ONLY,
+					       rwqe->length +
+					       sizeof(*dpm.rdma_ext),
+					       se, comp);
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 		qp->prev_wqe_size = rwqe->wqe_size;
 		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
@@ -1327,7 +1331,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 
 		rwqe->wqe_size = 2;
 		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
-		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
+		qelr_prepare_sq_rdma_data(qp, &dpm, data_size, rwqe, rwqe2, wr);
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
 		qp->prev_wqe_size = rwqe->wqe_size;
 		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
@@ -1353,7 +1357,7 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 			TYPEPTR_ADDR_SET(awqe3, cmp_data, wr->wr.atomic.compare_add);
 		}
 
-		qelr_prepare_sq_sges(qp, NULL, wr);
+		qelr_prepare_sq_sges(qp, &dpm, NULL, wr);
 
 		qp->wqe_wr_id[qp->sq.prod].wqe_size = awqe1->wqe_size;
 		qp->prev_wqe_size = awqe1->wqe_size;
@@ -1384,11 +1388,11 @@ static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
 	db_val = le16toh(qp->sq.db_data.data.value) + 1;
 	qp->sq.db_data.data.value = htole16(db_val);
 
-	if (edpm.is_edpm) {
-		doorbell_edpm_qp(cxt, qp, &edpm);
-		*doorbell_required = 0;
+	if (dpm.is_edpm) {
+		doorbell_dpm_qp(cxt, qp, &dpm);
+		*normal_db_required = 0;
 	} else {
-		*doorbell_required = 1;
+		*normal_db_required = 1;
 	}
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
