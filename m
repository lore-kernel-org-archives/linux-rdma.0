From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core v2] libqedr: Refactor post_send
Date: Wed, 1 Mar 2017 15:48:04 +0200
Message-ID: <1488376084-27072-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Refactor post send by creating a function that posts a single WR
that is invoked from a loop, early all WRs validity checks so that
WR posting won't even start if it is invalid, and move the edpm
structure outside of the QP structure as a preparation for dpm.

Version 2 differences:
 * updated to the latest rdma-core (post udma barriers)
 * re-directs a debug print to cxt->dbg_fp (rather stderr)

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 providers/qedr/qelr.h       |   2 -
 providers/qedr/qelr_verbs.c | 628 +++++++++++++++++++++++---------------------
 2 files changed, 323 insertions(+), 307 deletions(-)

diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index e887d9f..38882c4 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -236,13 +236,11 @@ struct qelr_qp {
 		uint8_t wqe_size;
 	} *rqe_wr_id;
 
-	struct qelr_edpm			edpm;
 	uint8_t					prev_wqe_size;
 	uint32_t				max_inline_data;
 	uint32_t				qp_id;
 	int					sq_sig_all;
 	int					atomic_supported;
-
 };
 
 static inline struct qelr_devctx *get_qelr_ctx(struct ibv_context *ibctx)
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 47c5dc6..7b52b0f 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -825,13 +825,20 @@ static void swap_wqe_data64(uint64_t *p)
 		*p = htobe64(htole64(*p));
 }
 
-static void qelr_init_edpm_info(struct qelr_qp *qp, struct qelr_devctx *cxt)
+static inline void qelr_init_edpm_info(struct qelr_devctx *cxt,
+				       struct qelr_qp *qp,
+				       struct ibv_send_wr *wr,
+				       struct qelr_edpm *edpm,
+				       int data_size)
 {
-	memset(&qp->edpm, 0, sizeof(qp->edpm));
+	edpm->is_edpm = 0;
 
-	qp->edpm.rdma_ext = (struct qelr_rdma_ext *)&qp->edpm.dpm_payload;
-	if (qelr_chain_is_full(&qp->sq.chain))
-		qp->edpm.is_edpm = 1;
+	if (qelr_chain_is_full(&qp->sq.chain) &&
+	    wr->send_flags & IBV_SEND_INLINE) {
+			memset(edpm, 0, sizeof(*edpm));
+			edpm->rdma_ext = (struct qelr_rdma_ext *)&edpm->dpm_payload;
+			edpm->is_edpm = 1;
+	}
 }
 
 #define QELR_IB_OPCODE_SEND_ONLY                         0x04
@@ -843,99 +850,92 @@ static void qelr_init_edpm_info(struct qelr_qp *qp, struct qelr_devctx *cxt)
 	 (opcode == QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE))
 
 static inline void qelr_edpm_set_msg_data(struct qelr_qp *qp,
+					  struct qelr_edpm *edpm,
 					  uint8_t opcode,
 					  uint16_t length,
 					  uint8_t se,
 					  uint8_t comp)
 {
-	uint32_t wqe_size = length +
-		(QELR_IS_IMM(opcode) ? sizeof(uint32_t) : 0);
+	uint32_t wqe_size = length + (QELR_IS_IMM(opcode)? sizeof(uint32_t) : 0);
 	uint32_t dpm_size = wqe_size + sizeof(struct db_roce_dpm_data);
 
-	if (!qp->edpm.is_edpm)
+	if (!edpm->is_edpm)
 		return;
 
-	SET_FIELD(qp->edpm.msg.data.params.params,
-		  DB_ROCE_DPM_PARAMS_SIZE,
+	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_SIZE,
 		  (dpm_size + sizeof(uint64_t) - 1) / sizeof(uint64_t));
 
-	SET_FIELD(qp->edpm.msg.data.params.params,
-		  DB_ROCE_DPM_PARAMS_DPM_TYPE, DPM_ROCE);
+	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_DPM_TYPE,
+		  DPM_ROCE);
 
-	SET_FIELD(qp->edpm.msg.data.params.params,
-		  DB_ROCE_DPM_PARAMS_OPCODE,
+	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_OPCODE,
 		  opcode);
 
-	SET_FIELD(qp->edpm.msg.data.params.params,
-		  DB_ROCE_DPM_PARAMS_WQE_SIZE,
+	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_WQE_SIZE,
 		  wqe_size);
 
-	SET_FIELD(qp->edpm.msg.data.params.params,
+	SET_FIELD(edpm->msg.data.params.params,
 		  DB_ROCE_DPM_PARAMS_COMPLETION_FLG, comp ? 1 : 0);
 
-	SET_FIELD(qp->edpm.msg.data.params.params,
-		  DB_ROCE_DPM_PARAMS_S_FLG,
+	SET_FIELD(edpm->msg.data.params.params, DB_ROCE_DPM_PARAMS_S_FLG,
 		  se ? 1 : 0);
 }
 
 static inline void qelr_edpm_set_inv_imm(struct qelr_qp *qp,
+					 struct qelr_edpm *edpm,
 					 uint32_t inv_key_or_imm_data)
 {
-	if (!qp->edpm.is_edpm)
+	if (!edpm->is_edpm)
 		return;
 
-	memcpy(&qp->edpm.dpm_payload[qp->edpm.dpm_payload_offset],
+	memcpy(&edpm->dpm_payload[edpm->dpm_payload_offset],
 	       &inv_key_or_imm_data, sizeof(inv_key_or_imm_data));
 
-	qp->edpm.dpm_payload_offset += sizeof(inv_key_or_imm_data);
-	qp->edpm.dpm_payload_size += sizeof(inv_key_or_imm_data);
+	edpm->dpm_payload_offset += sizeof(inv_key_or_imm_data);
+	edpm->dpm_payload_size += sizeof(inv_key_or_imm_data);
 }
 
 static inline void qelr_edpm_set_rdma_ext(struct qelr_qp *qp,
+					  struct qelr_edpm *edpm,
 					  uint64_t remote_addr,
 					  uint32_t rkey)
 {
-	if (!qp->edpm.is_edpm)
+	if (!edpm->is_edpm)
 		return;
 
-	qp->edpm.rdma_ext->remote_va = htobe64(remote_addr);
-	qp->edpm.rdma_ext->remote_key = htonl(rkey);
-	qp->edpm.dpm_payload_offset += sizeof(*qp->edpm.rdma_ext);
-	qp->edpm.dpm_payload_size += sizeof(*qp->edpm.rdma_ext);
+	edpm->rdma_ext->remote_va = htobe64(remote_addr);
+	edpm->rdma_ext->remote_key = htonl(rkey);
+	edpm->dpm_payload_offset += sizeof(*edpm->rdma_ext);
+	edpm->dpm_payload_size += sizeof(*edpm->rdma_ext);
 }
 
-static inline void qelr_edpm_set_payload(struct qelr_qp *qp, char *buf,
+static inline void qelr_edpm_set_payload(struct qelr_qp *qp,
+					 struct qelr_edpm *edpm, char *buf,
 					 uint32_t length)
 {
-	if (!qp->edpm.is_edpm)
+	if (!edpm->is_edpm)
 		return;
 
-	memcpy(&qp->edpm.dpm_payload[qp->edpm.dpm_payload_offset],
+	memcpy(&edpm->dpm_payload[edpm->dpm_payload_offset],
 	       buf,
 	       length);
 
-	qp->edpm.dpm_payload_offset += length;
+	edpm->dpm_payload_offset += length;
 }
 
-static uint32_t qelr_prepare_sq_inline_data(struct qelr_qp *qp,
+static void qelr_prepare_sq_inline_data(struct qelr_qp *qp,
+					    struct qelr_edpm *edpm,
+					    int data_size,
 					    uint8_t *wqe_size,
 					    struct ibv_send_wr *wr,
-					    struct ibv_send_wr **bad_wr,
 					    uint8_t *bits, uint8_t bit)
 {
 	int i;
 	uint32_t seg_siz;
 	char *seg_prt, *wqe;
-	uint32_t data_size = sge_data_len(wr->sg_list, wr->num_sge);
-
-	if (data_size > ROCE_REQ_MAX_INLINE_DATA_SIZE) {
-		DP_ERR(stderr, "Too much inline data in WR: %d\n", data_size);
-		*bad_wr = wr;
-		return 0;
-	}
 
 	if (!data_size)
-		return data_size;
+		return;
 
 	/* set the bit */
 	*bits |= bit;
@@ -949,7 +949,7 @@ static uint32_t qelr_prepare_sq_inline_data(struct qelr_qp *qp,
 		uint32_t len = wr->sg_list[i].length;
 		void *src = (void *)(uintptr_t)wr->sg_list[i].addr;
 
-		qelr_edpm_set_payload(qp, src, wr->sg_list[i].length);
+		qelr_edpm_set_payload(qp, edpm, src, wr->sg_list[i].length);
 
 		while (len > 0) {
 			uint32_t cur;
@@ -984,22 +984,19 @@ static uint32_t qelr_prepare_sq_inline_data(struct qelr_qp *qp,
 	if (seg_siz)
 		swap_wqe_data64((uint64_t *)wqe);
 
-	if (qp->edpm.is_edpm) {
-		qp->edpm.dpm_payload_size += data_size;
+	if (edpm->is_edpm) {
+		edpm->dpm_payload_size += data_size;
 
 		if (wr->opcode == IBV_WR_RDMA_WRITE ||
 		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
-			qp->edpm.rdma_ext->dma_length = htonl(data_size);
+			edpm->rdma_ext->dma_length = htonl(data_size);
 	}
-
-	return data_size;
 }
 
-static uint32_t qelr_prepare_sq_sges(struct qelr_qp *qp,
+static void qelr_prepare_sq_sges(struct qelr_qp *qp,
 				     uint8_t *wqe_size,
 				     struct ibv_send_wr *wr)
 {
-	uint32_t data_size = 0;
 	int i;
 
 	for (i = 0; i < wr->num_sge; i++) {
@@ -1008,20 +1005,18 @@ static uint32_t qelr_prepare_sq_sges(struct qelr_qp *qp,
 		TYPEPTR_ADDR_SET(sge, addr, wr->sg_list[i].addr);
 		sge->l_key = htole32(wr->sg_list[i].lkey);
 		sge->length = htole32(wr->sg_list[i].length);
-		data_size += wr->sg_list[i].length;
 	}
 
 	if (wqe_size)
 		*wqe_size += wr->num_sge;
-
-	return data_size;
 }
 
-static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
-					  struct rdma_sq_rdma_wqe_1st *rwqe,
-					  struct rdma_sq_rdma_wqe_2nd *rwqe2,
-					  struct ibv_send_wr *wr,
-					  struct ibv_send_wr **bad_wr)
+static void qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
+				      struct qelr_edpm *edpm,
+				      int data_size,
+				      struct rdma_sq_rdma_wqe_1st *rwqe,
+				      struct rdma_sq_rdma_wqe_2nd *rwqe2,
+				      struct ibv_send_wr *wr)
 {
 	memset(rwqe2, 0, sizeof(*rwqe2));
 	rwqe2->r_key = htole32(wr->wr.rdma.rkey);
@@ -1033,35 +1028,35 @@ static uint32_t qelr_prepare_sq_rdma_data(struct qelr_qp *qp,
 		uint8_t flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_RDMA_WQE_1ST_INLINE_FLG, 1);
-		return qelr_prepare_sq_inline_data(qp, &rwqe->wqe_size, wr,
-						   bad_wr, &rwqe->flags, flags);
+		qelr_prepare_sq_inline_data(qp, edpm, data_size,
+					    &rwqe->wqe_size, wr,
+					    &rwqe->flags, flags);
+	} else {
+		qelr_prepare_sq_sges(qp, &rwqe->wqe_size, wr);
 	}
-	/* else */
-	qp->edpm.is_edpm = 0;
-
-	return qelr_prepare_sq_sges(qp, &rwqe->wqe_size, wr);
+	rwqe->length = htole32(data_size);
 }
 
-static uint32_t qelr_prepare_sq_send_data(struct qelr_qp *qp,
-					  struct rdma_sq_send_wqe_1st *swqe,
-					  struct rdma_sq_send_wqe_2st *swqe2,
-					  struct ibv_send_wr *wr,
-					  struct ibv_send_wr **bad_wr)
+static void qelr_prepare_sq_send_data(struct qelr_qp *qp,
+				      struct qelr_edpm *edpm,
+				      int data_size,
+				      struct rdma_sq_send_wqe_1st *swqe,
+				      struct rdma_sq_send_wqe_2st *swqe2,
+				      struct ibv_send_wr *wr)
 {
 	memset(swqe2, 0, sizeof(*swqe2));
 	if (wr->send_flags & IBV_SEND_INLINE) {
 		uint8_t flags = 0;
 
 		SET_FIELD2(flags, RDMA_SQ_SEND_WQE_INLINE_FLG, 1);
-		return qelr_prepare_sq_inline_data(qp, &swqe->wqe_size, wr,
-						   bad_wr, &swqe->flags, flags);
+		qelr_prepare_sq_inline_data(qp, edpm, data_size,
+					    &swqe->wqe_size, wr,
+					    &swqe->flags, flags);
+	} else {
+		qelr_prepare_sq_sges(qp, &swqe->wqe_size, wr);
 	}
 
-	qp->edpm.is_edpm = 0;
-
-	/* else */
-
-	return qelr_prepare_sq_sges(qp, &swqe->wqe_size, wr);
+	swqe->length = htole32(data_size);
 }
 
 static enum ibv_wc_opcode qelr_ibv_to_wc_opcode(enum ibv_wr_opcode opcode)
@@ -1084,37 +1079,45 @@ static enum ibv_wc_opcode qelr_ibv_to_wc_opcode(enum ibv_wr_opcode opcode)
 	}
 }
 
-static void doorbell_edpm_qp(struct qelr_qp *qp)
+static inline void doorbell_qp(struct qelr_qp *qp)
+{
+	mmio_wc_start();
+	writel(qp->sq.db_data.raw, qp->sq.db);
+	mmio_flush_writes();
+}
+
+static inline void doorbell_edpm_qp(struct qelr_devctx *cxt, struct qelr_qp *qp,
+				    struct qelr_edpm *edpm)
 {
 	uint32_t offset = 0;
 	uint64_t data;
-	uint64_t *dpm_payload = (uint64_t *)qp->edpm.dpm_payload;
+	uint64_t *dpm_payload = (uint64_t *)edpm->dpm_payload;
 	uint32_t num_dwords;
 	int bytes = 0;
-
-	if (!qp->edpm.is_edpm)
-		return;
+	void *db_addr;
 
 	mmio_wc_start();
 
-	qp->edpm.msg.data.icid = qp->sq.db_data.data.icid;
-	qp->edpm.msg.data.prod_val = qp->sq.db_data.data.value;
+	/* Write message header */
+	edpm->msg.data.icid = qp->sq.db_data.data.icid;
+	edpm->msg.data.prod_val = qp->sq.db_data.data.value;
+	db_addr = qp->sq.edpm_db;
+	writeq(edpm->msg.raw, db_addr);
 
-	writeq(qp->edpm.msg.raw, qp->sq.edpm_db);
 
+	/* Write mesage body */
 	bytes += sizeof(uint64_t);
-
-	num_dwords = (qp->edpm.dpm_payload_size + sizeof(uint64_t) - 1) /
+	num_dwords = (edpm->dpm_payload_size + sizeof(uint64_t) - 1) /
 		sizeof(uint64_t);
+	db_addr += sizeof(edpm->msg.data);
 
 	while (offset < num_dwords) {
 		data = dpm_payload[offset];
-
-		writeq(data,
-		       qp->sq.edpm_db + sizeof(qp->edpm.msg.data) + offset *
-		       sizeof(uint64_t));
+		writeq(data, db_addr);
 
 		bytes += sizeof(uint64_t);
+		db_addr += sizeof(uint64_t);
+
 		/* Since we rewrite the buffer every 64 bytes we need to flush
 		 * it here, otherwise the CPU could optimize away the
 		 * duplicate stores.
@@ -1125,253 +1128,268 @@ static void doorbell_edpm_qp(struct qelr_qp *qp)
 		}
 		offset++;
 	}
+
 	mmio_flush_writes();
 }
 
-int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
-		   struct ibv_send_wr **bad_wr)
+static inline int qelr_can_post_send(struct qelr_devctx *cxt,
+				      struct qelr_qp *qp,
+				      struct ibv_send_wr *wr,
+				      int data_size)
 {
-	int status = 0;
-	struct qelr_qp *qp = get_qelr_qp(ib_qp);
-	struct qelr_devctx *cxt = get_qelr_ctx(ib_qp->context);
-	uint8_t se, comp, fence;
-	uint16_t db_val;
-	*bad_wr = NULL;
+	/* Invalid WR */
+	if (wr->num_sge > qp->sq.max_sges) {
+		DP_ERR(cxt->dbg_fp,
+		       "error: WR is bad. Post send on QP %p failed\n",
+		       qp);
+		return -EINVAL;
+	}
 
-	pthread_spin_lock(&qp->q_lock);
+	/* WQE overflow */
+	if (qelr_chain_get_elem_left_u32(&qp->sq.chain) <
+			QELR_MAX_SQ_WQE_SIZE) {
+		DP_ERR(cxt->dbg_fp,
+		       "error: WQ PBL is full. Post send on QP %p failed (this error appears only once)\n",
+		       qp);
+		return -ENOMEM;
+	}
 
-	if (qp->state != QELR_QPS_RTS && qp->state != QELR_QPS_SQD &&
-	    qp->state != QELR_QPS_ERR) {
-		pthread_spin_unlock(&qp->q_lock);
-		*bad_wr = wr;
+	if ((wr->opcode == IBV_WR_ATOMIC_CMP_AND_SWP ||
+	     wr->opcode == IBV_WR_ATOMIC_FETCH_AND_ADD) &&
+	    !qp->atomic_supported) {
+		DP_ERR(cxt->dbg_fp, "Atomic not supported on this machine\n");
 		return -EINVAL;
 	}
 
-	while (wr) {
-		struct rdma_sq_common_wqe *wqe;
-		struct rdma_sq_send_wqe_1st *swqe;
-		struct rdma_sq_send_wqe_2st *swqe2;
-		struct rdma_sq_rdma_wqe_1st *rwqe;
-		struct rdma_sq_rdma_wqe_2nd *rwqe2;
-		struct rdma_sq_atomic_wqe_1st *awqe1;
-		struct rdma_sq_atomic_wqe_2nd *awqe2;
-		struct rdma_sq_atomic_wqe_3rd *awqe3;
-
-		if ((qelr_chain_get_elem_left_u32(&qp->sq.chain) <
-					QELR_MAX_SQ_WQE_SIZE) ||
-		     (wr->num_sge > qp->sq.max_sges)) {
-			status = -ENOMEM;
-			*bad_wr = wr;
-			break;
-		}
+	if ((wr->send_flags & IBV_SEND_INLINE) &&
+	    (data_size > ROCE_REQ_MAX_INLINE_DATA_SIZE)) {
+		DP_ERR(cxt->dbg_fp, "Too much inline data in WR: %d\n", data_size);
+		return -EINVAL;
+	}
 
-		qelr_init_edpm_info(qp, cxt);
-
-		wqe = qelr_chain_produce(&qp->sq.chain);
-
-		comp = (!!(wr->send_flags & IBV_SEND_SIGNALED)) ||
-				(!!qp->sq_sig_all);
-		qp->wqe_wr_id[qp->sq.prod].signaled = comp;
-
-		/* common fields */
-		wqe->flags = 0;
-		se = !!(wr->send_flags & IBV_SEND_SOLICITED);
-		fence = !!(wr->send_flags & IBV_SEND_FENCE);
-		SET_FIELD2(wqe->flags, RDMA_SQ_COMMON_WQE_SE_FLG, se);
-		SET_FIELD2(wqe->flags, RDMA_SQ_COMMON_WQE_COMP_FLG, comp);
-		SET_FIELD2(wqe->flags, RDMA_SQ_COMMON_WQE_RD_FENCE_FLG, fence);
-		wqe->prev_wqe_size = qp->prev_wqe_size;
-
-		qp->wqe_wr_id[qp->sq.prod].opcode =
-		qelr_ibv_to_wc_opcode(wr->opcode);
-
-		switch (wr->opcode) {
-		case IBV_WR_SEND_WITH_IMM:
-			wqe->req_type = RDMA_SQ_REQ_TYPE_SEND_WITH_IMM;
-			swqe = (struct rdma_sq_send_wqe_1st *)wqe;
-
-			swqe->wqe_size = 2;
-			swqe2 = (struct rdma_sq_send_wqe_2st *)
-					qelr_chain_produce(&qp->sq.chain);
-			swqe->inv_key_or_imm_data =
-					htonl(htole32(wr->imm_data));
-			qelr_edpm_set_inv_imm(qp, swqe->inv_key_or_imm_data);
-			swqe->length = htole32(
-					qelr_prepare_sq_send_data(qp, swqe,
-								  swqe2, wr,
-								  bad_wr));
-			qelr_edpm_set_msg_data(qp,
-					       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
-					       swqe->length,
-					       se, comp);
-			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
-			qp->prev_wqe_size = swqe->wqe_size;
-			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
-			break;
 
-		case IBV_WR_SEND:
-			wqe->req_type = RDMA_SQ_REQ_TYPE_SEND;
-			swqe = (struct rdma_sq_send_wqe_1st *)wqe;
-
-			swqe->wqe_size = 2;
-			swqe2 = (struct rdma_sq_send_wqe_2st *)
-					qelr_chain_produce(&qp->sq.chain);
-			swqe->length = htole32(
-					qelr_prepare_sq_send_data(qp, swqe,
-								  swqe2, wr,
-								  bad_wr));
-			qelr_edpm_set_msg_data(qp, QELR_IB_OPCODE_SEND_ONLY,
-					       swqe->length,
-					       se, comp);
-			qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
-			qp->prev_wqe_size = swqe->wqe_size;
-			qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
-			break;
+	return 0;
+}
 
-		case IBV_WR_RDMA_WRITE_WITH_IMM:
-			wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR_WITH_IMM;
-			rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
-
-			rwqe->wqe_size = 2;
-			rwqe->imm_data = htonl(htole32(wr->imm_data));
-			qelr_edpm_set_rdma_ext(qp, wr->wr.rdma.remote_addr,
-					       wr->wr.rdma.rkey);
-			qelr_edpm_set_inv_imm(qp, rwqe->imm_data);
-			rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)
-					qelr_chain_produce(&qp->sq.chain);
-			rwqe->length = htole32(
-					qelr_prepare_sq_rdma_data(qp, rwqe,
-								  rwqe2, wr,
-								  bad_wr));
-			qelr_edpm_set_msg_data(qp,
-					       QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE,
-					       rwqe->length + sizeof(*qp->edpm.rdma_ext),
-					       se, comp);
-			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
-			qp->prev_wqe_size = rwqe->wqe_size;
-			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			break;
+static int __qelr_post_send(struct qelr_devctx *cxt, struct qelr_qp *qp,
+			    struct ibv_send_wr *wr, int data_size,
+			    int *doorbell_required)
+{
+	uint8_t se, comp, fence;
+	struct rdma_sq_common_wqe *wqe;
+	struct rdma_sq_send_wqe_1st *swqe;
+	struct rdma_sq_send_wqe_2st *swqe2;
+	struct rdma_sq_rdma_wqe_1st *rwqe;
+	struct rdma_sq_rdma_wqe_2nd *rwqe2;
+	struct rdma_sq_atomic_wqe_1st *awqe1;
+	struct rdma_sq_atomic_wqe_2nd *awqe2;
+	struct rdma_sq_atomic_wqe_3rd *awqe3;
+	struct qelr_edpm edpm;
+	uint16_t db_val;
+	int rc = 0;
 
-		case IBV_WR_RDMA_WRITE:
-			wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR;
-			rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
-
-			rwqe->wqe_size = 2;
-			qelr_edpm_set_rdma_ext(qp, wr->wr.rdma.remote_addr,
-					       wr->wr.rdma.rkey);
-			rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)
-					qelr_chain_produce(&qp->sq.chain);
-			rwqe->length = htole32(
-				qelr_prepare_sq_rdma_data(qp, rwqe, rwqe2, wr,
-							  bad_wr));
-			qelr_edpm_set_msg_data(qp,
-					       QELR_IB_OPCODE_RDMA_WRITE_ONLY,
-					       rwqe->length + sizeof(*qp->edpm.rdma_ext),
-					       se, comp);
-			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
-			qp->prev_wqe_size = rwqe->wqe_size;
-			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			break;
+	qelr_init_edpm_info(cxt, qp, wr, &edpm, data_size);
 
-		case IBV_WR_RDMA_READ:
-			wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_RD;
-			rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
-
-			rwqe->wqe_size = 2;
-			rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)
-					qelr_chain_produce(&qp->sq.chain);
-			rwqe->length = htole32(
-					qelr_prepare_sq_rdma_data(qp, rwqe,
-								  rwqe2, wr,
-								  bad_wr));
-
-			qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
-			qp->prev_wqe_size = rwqe->wqe_size;
-			qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
-			break;
+	wqe = qelr_chain_produce(&qp->sq.chain);
 
-		case IBV_WR_ATOMIC_CMP_AND_SWP:
-		case IBV_WR_ATOMIC_FETCH_AND_ADD:
-			if (!qp->atomic_supported) {
-				DP_ERR(cxt->dbg_fp,
-				       "Atomic not supported on this machine\n");
-				status = -EINVAL;
-				*bad_wr = wr;
-				break;
-			}
-			awqe1 = (struct rdma_sq_atomic_wqe_1st *)wqe;
-			awqe1->wqe_size = 4;
-
-			awqe2 = (struct rdma_sq_atomic_wqe_2nd *)
-					qelr_chain_produce(&qp->sq.chain);
-			TYPEPTR_ADDR_SET(awqe2, remote_va,
-					 wr->wr.atomic.remote_addr);
-			awqe2->r_key = htole32(wr->wr.atomic.rkey);
-
-			awqe3 = (struct rdma_sq_atomic_wqe_3rd *)
-				qelr_chain_produce(&qp->sq.chain);
-
-			if (wr->opcode == IBV_WR_ATOMIC_FETCH_AND_ADD) {
-				wqe->req_type = RDMA_SQ_REQ_TYPE_ATOMIC_ADD;
-				TYPEPTR_ADDR_SET(awqe3, swap_data,
-						 wr->wr.atomic.compare_add);
-			} else {
-				wqe->req_type =
-					RDMA_SQ_REQ_TYPE_ATOMIC_CMP_AND_SWAP;
-				TYPEPTR_ADDR_SET(awqe3, swap_data,
-						 wr->wr.atomic.swap);
-				TYPEPTR_ADDR_SET(awqe3, cmp_data,
-						 wr->wr.atomic.compare_add);
-			}
+	comp = (!!(wr->send_flags & IBV_SEND_SIGNALED)) ||
+			(!!qp->sq_sig_all);
+	qp->wqe_wr_id[qp->sq.prod].signaled = comp;
 
-			qelr_prepare_sq_sges(qp, NULL, wr);
+	/* common fields */
+	wqe->flags = 0;
+	se = !!(wr->send_flags & IBV_SEND_SOLICITED);
+	fence = !!(wr->send_flags & IBV_SEND_FENCE);
+	SET_FIELD2(wqe->flags, RDMA_SQ_COMMON_WQE_SE_FLG, se);
+	SET_FIELD2(wqe->flags, RDMA_SQ_COMMON_WQE_COMP_FLG, comp);
+	SET_FIELD2(wqe->flags, RDMA_SQ_COMMON_WQE_RD_FENCE_FLG, fence);
+	wqe->prev_wqe_size = qp->prev_wqe_size;
 
-			qp->wqe_wr_id[qp->sq.prod].wqe_size = awqe1->wqe_size;
-			qp->prev_wqe_size = awqe1->wqe_size;
+	qp->wqe_wr_id[qp->sq.prod].opcode = qelr_ibv_to_wc_opcode(wr->opcode);
 
-			break;
+	switch (wr->opcode) {
+	case IBV_WR_SEND_WITH_IMM:
+		wqe->req_type = RDMA_SQ_REQ_TYPE_SEND_WITH_IMM;
+		swqe = (struct rdma_sq_send_wqe_1st *)wqe;
+
+		swqe->wqe_size = 2;
+		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
+		swqe->inv_key_or_imm_data = htonl(htole32(wr->imm_data));
+		qelr_edpm_set_inv_imm(qp, &edpm, swqe->inv_key_or_imm_data);
+		qelr_prepare_sq_send_data(qp, &edpm, data_size, swqe, swqe2, wr);
+		qelr_edpm_set_msg_data(qp, &edpm,
+				       QELR_IB_OPCODE_SEND_ONLY_WITH_IMMEDIATE,
+				       swqe->length, se, comp);
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
+		qp->prev_wqe_size = swqe->wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
+		break;
 
-		default:
-			*bad_wr = wr;
-			break;
-		}
+	case IBV_WR_SEND:
+		wqe->req_type = RDMA_SQ_REQ_TYPE_SEND;
+		swqe = (struct rdma_sq_send_wqe_1st *)wqe;
+
+		swqe->wqe_size = 2;
+		swqe2 = (struct rdma_sq_send_wqe_2st *)qelr_chain_produce(&qp->sq.chain);
+		qelr_prepare_sq_send_data(qp, &edpm, data_size, swqe, swqe2, wr);
+		qelr_edpm_set_msg_data(qp, &edpm, QELR_IB_OPCODE_SEND_ONLY,
+				       swqe->length, se, comp);
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = swqe->wqe_size;
+		qp->prev_wqe_size = swqe->wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = swqe->length;
+		break;
 
-		if (*bad_wr) {
-			/* restore prod to its position before this WR was
-			 * processed
-			 */
-			qelr_chain_set_prod(&qp->sq.chain,
-					    le16toh(qp->sq.db_data.data.value),
-					    wqe);
-			/* restore prev_wqe_size */
-			qp->prev_wqe_size = wqe->prev_wqe_size;
-			status = -EINVAL;
-			DP_ERR(cxt->dbg_fp, "POST SEND FAILED\n");
-			break; /* out of the loop */
+	case IBV_WR_RDMA_WRITE_WITH_IMM:
+		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR_WITH_IMM;
+		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
+
+		rwqe->wqe_size = 2;
+		rwqe->imm_data = htonl(htole32(wr->imm_data));
+		qelr_edpm_set_rdma_ext(qp, &edpm, wr->wr.rdma.remote_addr,
+				       wr->wr.rdma.rkey);
+		qelr_edpm_set_inv_imm(qp, &edpm, rwqe->imm_data);
+		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
+		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
+		qelr_edpm_set_msg_data(qp, &edpm,
+				       QELR_IB_OPCODE_RDMA_WRITE_ONLY_WITH_IMMEDIATE,
+				       rwqe->length + sizeof(*edpm.rdma_ext),
+				       se, comp);
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
+		qp->prev_wqe_size = rwqe->wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
+		break;
+
+	case IBV_WR_RDMA_WRITE:
+		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_WR;
+		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
+
+		rwqe->wqe_size = 2;
+		qelr_edpm_set_rdma_ext(qp, &edpm, wr->wr.rdma.remote_addr,
+				       wr->wr.rdma.rkey);
+		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
+		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
+		qelr_edpm_set_msg_data(qp, &edpm,
+				       QELR_IB_OPCODE_RDMA_WRITE_ONLY,
+				       rwqe->length + sizeof(*edpm.rdma_ext),
+				       se, comp);
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
+		qp->prev_wqe_size = rwqe->wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
+		break;
+
+	case IBV_WR_RDMA_READ:
+		wqe->req_type = RDMA_SQ_REQ_TYPE_RDMA_RD;
+		rwqe = (struct rdma_sq_rdma_wqe_1st *)wqe;
+
+		rwqe->wqe_size = 2;
+		rwqe2 = (struct rdma_sq_rdma_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
+		qelr_prepare_sq_rdma_data(qp, &edpm, data_size, rwqe, rwqe2, wr);
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = rwqe->wqe_size;
+		qp->prev_wqe_size = rwqe->wqe_size;
+		qp->wqe_wr_id[qp->sq.prod].bytes_len = rwqe->length;
+		break;
+
+	case IBV_WR_ATOMIC_CMP_AND_SWP:
+	case IBV_WR_ATOMIC_FETCH_AND_ADD:
+		awqe1 = (struct rdma_sq_atomic_wqe_1st *)wqe;
+		awqe1->wqe_size = 4;
+
+		awqe2 = (struct rdma_sq_atomic_wqe_2nd *)qelr_chain_produce(&qp->sq.chain);
+		TYPEPTR_ADDR_SET(awqe2, remote_va, wr->wr.atomic.remote_addr);
+		awqe2->r_key = htole32(wr->wr.atomic.rkey);
+
+		awqe3 = (struct rdma_sq_atomic_wqe_3rd *)qelr_chain_produce(&qp->sq.chain);
+
+		if (wr->opcode == IBV_WR_ATOMIC_FETCH_AND_ADD) {
+			wqe->req_type = RDMA_SQ_REQ_TYPE_ATOMIC_ADD;
+			TYPEPTR_ADDR_SET(awqe3, swap_data, wr->wr.atomic.compare_add);
+		} else {
+			wqe->req_type = RDMA_SQ_REQ_TYPE_ATOMIC_CMP_AND_SWAP;
+			TYPEPTR_ADDR_SET(awqe3, swap_data, wr->wr.atomic.swap);
+			TYPEPTR_ADDR_SET(awqe3, cmp_data, wr->wr.atomic.compare_add);
 		}
 
-		qp->wqe_wr_id[qp->sq.prod].wr_id = wr->wr_id;
+		qelr_prepare_sq_sges(qp, NULL, wr);
+
+		qp->wqe_wr_id[qp->sq.prod].wqe_size = awqe1->wqe_size;
+		qp->prev_wqe_size = awqe1->wqe_size;
 
-		qelr_inc_sw_prod_u16(&qp->sq);
+		break;
 
-		db_val = le16toh(qp->sq.db_data.data.value) + 1;
-		qp->sq.db_data.data.value = htole16(db_val);
+	default:
+		/* restore prod to its position before this WR was processed */
+		qelr_chain_set_prod(&qp->sq.chain,
+				    le16toh(qp->sq.db_data.data.value),
+				    wqe);
 
-		wr = wr->next;
+		/* restore prev_wqe_size */
+		qp->prev_wqe_size = wqe->prev_wqe_size;
 
-		/* Doorbell */
-		doorbell_edpm_qp(qp);
+		rc = -EINVAL;
+		DP_ERR(cxt->dbg_fp, "invalid opcode in work request\n");
+		break;
 	}
 
-	if (!qp->edpm.is_edpm) {
-		mmio_wc_start();
-		writel(qp->sq.db_data.raw, qp->sq.db);
-		mmio_flush_writes();
+	if (rc)
+		return rc;
+
+	qp->wqe_wr_id[qp->sq.prod].wr_id = wr->wr_id;
+	qelr_inc_sw_prod_u16(&qp->sq);
+	db_val = le16toh(qp->sq.db_data.data.value) + 1;
+	qp->sq.db_data.data.value = htole16(db_val);
+
+	if (edpm.is_edpm) {
+		doorbell_edpm_qp(cxt, qp, &edpm);
+		*doorbell_required = 0;
+	} else {
+		*doorbell_required = 1;
+	}
+
+	return 0;
+}
+
+int qelr_post_send(struct ibv_qp *ib_qp, struct ibv_send_wr *wr,
+		   struct ibv_send_wr **bad_wr)
+{
+	struct qelr_devctx *cxt = get_qelr_ctx(ib_qp->context);
+	struct qelr_qp *qp = get_qelr_qp(ib_qp);
+	int doorbell_required = 0;
+	*bad_wr = NULL;
+	int rc = 0;
+
+	pthread_spin_lock(&qp->q_lock);
+
+	if ((qp->state != QELR_QPS_RTS && qp->state != QELR_QPS_ERR &&
+	     qp->state != QELR_QPS_SQD)) {
+		pthread_spin_unlock(&qp->q_lock);
+		*bad_wr = wr;
+		return -EINVAL;
 	}
 
+	while (wr) {
+		int data_size = sge_data_len(wr->sg_list, wr->num_sge);
+
+		rc = qelr_can_post_send(cxt, qp, wr, data_size);
+		if (rc) {
+			*bad_wr = wr;
+			break;
+		}
+
+		rc = __qelr_post_send(cxt, qp, wr, data_size, &doorbell_required);
+		if (rc) {
+			*bad_wr = wr;
+			break;
+		}
+
+		wr = wr->next;
+	}
+
+	if (doorbell_required)
+		doorbell_qp(qp);
+
 	pthread_spin_unlock(&qp->q_lock);
 
-	return status;
+	return rc;
 }
 
 int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
