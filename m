From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v4 4/8] libbnxt_re: Add support for posting and polling
Date: Fri, 21 Apr 2017 13:30:14 -0400
Message-ID: <1492795818-29618-5-git-send-email-devesh.sharma@broadcom.com>
References: <1492795818-29618-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492795818-29618-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds code to support ibv_post_recv(),
ibv_post_send(), ibv_poll_cq() and ibv_arm_cq()
routines. With this patch applications are able
to enqueue RQE or WQE ring doorbells and poll for
completions from CQ. Currently, this code do not
support SRQ, UD service and and flush completions.
Following are the major changes:

 - Added most of the enums to handle device specific
   opcodes, masks, shifts and data structures.
 - Added a new file to define DB related routines.
 - Added routines to handle circular queue operations.
 - Added enums and few utility functions.
 - Added bnxt_re_post_recv().
 - Add code to build and post SQEs for RDMA-WRITE,
   RDMA-READ, SEND through bnxt_re_post_send() routine.
 - Fixed couple of bugs in create-qp and modify-qp.
 - bnxt_re_create_qp() now check the limits.
 - Add polling support for RC send completions.
 - Add polling support for RC Recv completions.
 - Add support to ARM completion queue.
 - Cleanup CQ while QP is being destroyed.
 - Add utility functions to convert chip specific
   completion codes to IB stack specific codes.

v3->v4
 -- change the write memory barrier and read memory barrier
    calls.
 -- removed one time byte-order conversion, convert while
    assigning instead.
 -- take care of sparse error and warnnings.

v1->v2
 -- Delete redefinition of "true" and "false"
 -- Removed unwanted wmb()
 -- Removed dead code and fixed return type mismatch.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/CMakeLists.txt |   1 +
 providers/bnxt_re/bnxt_re-abi.h  | 174 ++++++++++-
 providers/bnxt_re/db.c           |  93 ++++++
 providers/bnxt_re/main.c         |   1 +
 providers/bnxt_re/main.h         | 201 +++++++++++-
 providers/bnxt_re/memory.h       |  31 ++
 providers/bnxt_re/verbs.c        | 654 ++++++++++++++++++++++++++++++++++++---
 7 files changed, 1114 insertions(+), 41 deletions(-)
 create mode 100644 providers/bnxt_re/db.c

diff --git a/providers/bnxt_re/CMakeLists.txt b/providers/bnxt_re/CMakeLists.txt
index 7ea5ed8..13ad287 100644
--- a/providers/bnxt_re/CMakeLists.txt
+++ b/providers/bnxt_re/CMakeLists.txt
@@ -1,4 +1,5 @@
 rdma_provider(bnxt_re
+	db.c
 	main.c
 	memory.c
 	verbs.c
diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index 60ef63e..7062f3b 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -43,6 +43,142 @@
 
 #define BNXT_RE_ABI_VERSION 1
 
+enum bnxt_re_wr_opcode {
+	BNXT_RE_WR_OPCD_SEND		= 0x00,
+	BNXT_RE_WR_OPCD_SEND_IMM	= 0x01,
+	BNXT_RE_WR_OPCD_SEND_INVAL	= 0x02,
+	BNXT_RE_WR_OPCD_RDMA_WRITE	= 0x04,
+	BNXT_RE_WR_OPCD_RDMA_WRITE_IMM	= 0x05,
+	BNXT_RE_WR_OPCD_RDMA_READ	= 0x06,
+	BNXT_RE_WR_OPCD_ATOMIC_CS	= 0x08,
+	BNXT_RE_WR_OPCD_ATOMIC_FA	= 0x0B,
+	BNXT_RE_WR_OPCD_LOC_INVAL	= 0x0C,
+	BNXT_RE_WR_OPCD_BIND		= 0x0E,
+	BNXT_RE_WR_OPCD_RECV		= 0x80
+};
+
+enum bnxt_re_wr_flags {
+	BNXT_RE_WR_FLAGS_INLINE		= 0x10,
+	BNXT_RE_WR_FLAGS_SE		= 0x08,
+	BNXT_RE_WR_FLAGS_UC_FENCE	= 0x04,
+	BNXT_RE_WR_FLAGS_RD_FENCE	= 0x02,
+	BNXT_RE_WR_FLAGS_SIGNALED	= 0x01
+};
+
+enum bnxt_re_wc_type {
+	BNXT_RE_WC_TYPE_SEND		= 0x00,
+	BNXT_RE_WC_TYPE_RECV_RC		= 0x01,
+	BNXT_RE_WC_TYPE_RECV_UD		= 0x02,
+	BNXT_RE_WC_TYPE_RECV_RAW	= 0x03,
+	BNXT_RE_WC_TYPE_TERM		= 0x0E,
+	BNXT_RE_WC_TYPE_COFF		= 0x0F
+};
+
+enum bnxt_re_req_wc_status {
+	BNXT_RE_REQ_ST_OK		= 0x00,
+	BNXT_RE_REQ_ST_BAD_RESP		= 0x01,
+	BNXT_RE_REQ_ST_LOC_LEN		= 0x02,
+	BNXT_RE_REQ_ST_LOC_QP_OP	= 0x03,
+	BNXT_RE_REQ_ST_PROT		= 0x04,
+	BNXT_RE_REQ_ST_MEM_OP		= 0x05,
+	BNXT_RE_REQ_ST_REM_INVAL	= 0x06,
+	BNXT_RE_REQ_ST_REM_ACC		= 0x07,
+	BNXT_RE_REQ_ST_REM_OP		= 0x08,
+	BNXT_RE_REQ_ST_RNR_NAK_XCED	= 0x09,
+	BNXT_RE_REQ_ST_TRNSP_XCED	= 0x0A,
+	BNXT_RE_REQ_ST_WR_FLUSH		= 0x0B
+};
+
+enum bnxt_re_rsp_wc_status {
+	BNXT_RE_RSP_ST_OK		= 0x00,
+	BNXT_RE_RSP_ST_LOC_ACC		= 0x01,
+	BNXT_RE_RSP_ST_LOC_LEN		= 0x02,
+	BNXT_RE_RSP_ST_LOC_PROT		= 0x03,
+	BNXT_RE_RSP_ST_LOC_QP_OP	= 0x04,
+	BNXT_RE_RSP_ST_MEM_OP		= 0x05,
+	BNXT_RE_RSP_ST_REM_INVAL	= 0x06,
+	BNXT_RE_RSP_ST_WR_FLUSH		= 0x07,
+	BNXT_RE_RSP_ST_HW_FLUSH		= 0x08
+};
+
+enum bnxt_re_hdr_offset {
+	BNXT_RE_HDR_WT_MASK		= 0xFF,
+	BNXT_RE_HDR_FLAGS_MASK		= 0xFF,
+	BNXT_RE_HDR_FLAGS_SHIFT		= 0x08,
+	BNXT_RE_HDR_WS_MASK		= 0xFF,
+	BNXT_RE_HDR_WS_SHIFT		= 0x10
+};
+
+enum bnxt_re_db_que_type {
+	BNXT_RE_QUE_TYPE_SQ		= 0x00,
+	BNXT_RE_QUE_TYPE_RQ		= 0x01,
+	BNXT_RE_QUE_TYPE_SRQ		= 0x02,
+	BNXT_RE_QUE_TYPE_SRQ_ARM	= 0x03,
+	BNXT_RE_QUE_TYPE_CQ		= 0x04,
+	BNXT_RE_QUE_TYPE_CQ_ARMSE	= 0x05,
+	BNXT_RE_QUE_TYPE_CQ_ARMALL	= 0x06,
+	BNXT_RE_QUE_TYPE_CQ_ARMENA	= 0x07,
+	BNXT_RE_QUE_TYPE_SRQ_ARMENA	= 0x08,
+	BNXT_RE_QUE_TYPE_CQ_CUT_ACK	= 0x09,
+	BNXT_RE_QUE_TYPE_NULL		= 0x0F
+};
+
+enum bnxt_re_db_mask {
+	BNXT_RE_DB_INDX_MASK		= 0xFFFFFUL,
+	BNXT_RE_DB_QID_MASK		= 0xFFFFFUL,
+	BNXT_RE_DB_TYP_MASK		= 0x0FUL,
+	BNXT_RE_DB_TYP_SHIFT		= 0x1C
+};
+
+enum bnxt_re_psns_mask {
+	BNXT_RE_PSNS_SPSN_MASK		= 0xFFFFFF,
+	BNXT_RE_PSNS_OPCD_MASK		= 0xFF,
+	BNXT_RE_PSNS_OPCD_SHIFT		= 0x18,
+	BNXT_RE_PSNS_NPSN_MASK		= 0xFFFFFF,
+	BNXT_RE_PSNS_FLAGS_MASK		= 0xFF,
+	BNXT_RE_PSNS_FLAGS_SHIFT	= 0x18
+};
+
+enum bnxt_re_bcqe_mask {
+	BNXT_RE_BCQE_PH_MASK		= 0x01,
+	BNXT_RE_BCQE_TYPE_MASK		= 0x0F,
+	BNXT_RE_BCQE_TYPE_SHIFT		= 0x01,
+	BNXT_RE_BCQE_STATUS_MASK	= 0xFF,
+	BNXT_RE_BCQE_STATUS_SHIFT	= 0x08,
+	BNXT_RE_BCQE_FLAGS_MASK		= 0xFFFFU,
+	BNXT_RE_BCQE_FLAGS_SHIFT	= 0x10,
+	BNXT_RE_BCQE_RWRID_MASK		= 0xFFFFFU,
+	BNXT_RE_BCQE_SRCQP_MASK		= 0xFF,
+	BNXT_RE_BCQE_SRCQP_SHIFT	= 0x18
+};
+
+enum bnxt_re_rc_flags_mask {
+	BNXT_RE_RC_FLAGS_SRQ_RQ_MASK	= 0x01,
+	BNXT_RE_RC_FLAGS_IMM_MASK	= 0x02,
+	BNXT_RE_RC_FLAGS_IMM_SHIFT	= 0x01,
+	BNXT_RE_RC_FLAGS_INV_MASK	= 0x04,
+	BNXT_RE_RC_FLAGS_INV_SHIFT	= 0x02,
+	BNXT_RE_RC_FLAGS_RDMA_MASK	= 0x08,
+	BNXT_RE_RC_FLAGS_RDMA_SHIFT	= 0x03
+};
+
+enum bnxt_re_ud_flags_mask {
+	BNXT_RE_UD_FLAGS_SRQ_RQ_MASK	= 0x01,
+	BNXT_RE_UD_FLAGS_IMM_MASK	= 0x02,
+	BNXT_RE_UD_FLAGS_HDR_TYP_MASK	= 0x0C,
+
+	BNXT_RE_UD_FLAGS_SRQ		= 0x01,
+	BNXT_RE_UD_FLAGS_RQ		= 0x00,
+	BNXT_RE_UD_FLAGS_ROCE		= 0x00,
+	BNXT_RE_UD_FLAGS_ROCE_IPV4	= 0x02,
+	BNXT_RE_UD_FLAGS_ROCE_IPV6	= 0x03
+};
+
+struct bnxt_re_db_hdr {
+	__le32 indx;
+	__le32 typ_qid; /* typ: 4, qid:20*/
+};
+
 struct bnxt_re_cntx_resp {
 	struct ibv_get_context_resp resp;
 	__u32 dev_id;
@@ -78,6 +214,39 @@ struct bnxt_re_cq_resp {
 	__u32 rsvd;
 };
 
+struct bnxt_re_bcqe {
+	__le32 flg_st_typ_ph;
+	__le32 qphi_rwrid;
+};
+
+struct bnxt_re_req_cqe {
+	__le64 qp_handle;
+	__le32 con_indx; /* 16 bits valid. */
+	__le32 rsvd1;
+	__le64 rsvd2;
+};
+
+struct bnxt_re_rc_cqe {
+	__le32 length;
+	__le32 imm_key;
+	__le64 qp_handle;
+	__le64 mr_handle;
+};
+
+struct bnxt_re_ud_cqe {
+	__le32 length; /* 14 bits */
+	__le32 immd;
+	__le64 qp_handle;
+	__le64 qplo_mac; /* 16:48*/
+};
+
+struct bnxt_re_term_cqe {
+	__le64 qp_handle;
+	__le32 rq_sq_cidx;
+	__le32 rsvd;
+	__le64 rsvd1;
+};
+
 struct bnxt_re_qp_req {
 	struct ibv_create_qp cmd;
 	__u64 qpsva;
@@ -157,7 +326,9 @@ struct bnxt_re_brqe {
 };
 
 struct bnxt_re_rqe {
-	__le64 rsvd[3];
+	__le32 wrid;
+	__le32 rsvd1;
+	__le64 rsvd[2];
 };
 
 struct bnxt_re_srqe {
@@ -165,5 +336,4 @@ struct bnxt_re_srqe {
 	__le32 rsvd1;
 	__le64 rsvd[2];
 };
-
 #endif
diff --git a/providers/bnxt_re/db.c b/providers/bnxt_re/db.c
new file mode 100644
index 0000000..c5ab4db
--- /dev/null
+++ b/providers/bnxt_re/db.c
@@ -0,0 +1,93 @@
+/*
+ * Broadcom NetXtreme-E User Space RoCE driver
+ *
+ * Copyright (c) 2015-2017, Broadcom. All rights reserved.  The term
+ * Broadcom refers to Broadcom Limited and/or its subsidiaries.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
+ * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
+ * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * Description: Doorbell handling functions.
+ */
+
+#include <util/udma_barrier.h>
+#include "main.h"
+
+static void bnxt_re_ring_db(struct bnxt_re_dpi *dpi,
+			    struct bnxt_re_db_hdr *hdr)
+{
+	__le64 *dbval;
+
+	pthread_spin_lock(&dpi->db_lock);
+	dbval = (__le64 *)&hdr->indx;
+	udma_to_device_barrier();
+	iowrite64(dpi->dbpage, dbval);
+	pthread_spin_unlock(&dpi->db_lock);
+}
+
+static void bnxt_re_init_db_hdr(struct bnxt_re_db_hdr *hdr, uint32_t indx,
+				uint32_t qid, uint32_t typ)
+{
+	hdr->indx = htole32(indx & BNXT_RE_DB_INDX_MASK);
+	hdr->typ_qid = htole32(qid & BNXT_RE_DB_QID_MASK);
+	hdr->typ_qid |= htole32(((typ & BNXT_RE_DB_TYP_MASK) <<
+				  BNXT_RE_DB_TYP_SHIFT));
+}
+
+void bnxt_re_ring_rq_db(struct bnxt_re_qp *qp)
+{
+	struct bnxt_re_db_hdr hdr;
+
+	bnxt_re_init_db_hdr(&hdr, qp->rqq->tail, qp->qpid, BNXT_RE_QUE_TYPE_RQ);
+	bnxt_re_ring_db(qp->udpi, &hdr);
+}
+
+void bnxt_re_ring_sq_db(struct bnxt_re_qp *qp)
+{
+	struct bnxt_re_db_hdr hdr;
+
+	bnxt_re_init_db_hdr(&hdr, qp->sqq->tail, qp->qpid, BNXT_RE_QUE_TYPE_SQ);
+	bnxt_re_ring_db(qp->udpi, &hdr);
+}
+
+void bnxt_re_ring_cq_db(struct bnxt_re_cq *cq)
+{
+	struct bnxt_re_db_hdr hdr;
+
+	bnxt_re_init_db_hdr(&hdr, cq->cqq.head, cq->cqid, BNXT_RE_QUE_TYPE_CQ);
+	bnxt_re_ring_db(cq->udpi, &hdr);
+}
+
+void bnxt_re_ring_cq_arm_db(struct bnxt_re_cq *cq, uint8_t aflag)
+{
+	struct bnxt_re_db_hdr hdr;
+
+	bnxt_re_init_db_hdr(&hdr, cq->cqq.head, cq->cqid, aflag);
+	bnxt_re_ring_db(cq->udpi, &hdr);
+}
diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index 5612a70..60ad653 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -105,6 +105,7 @@ static struct ibv_context_ops bnxt_re_cntx_ops = {
 	.destroy_ah    = bnxt_re_destroy_ah
 };
 
+/* Context Init functions */
 static int bnxt_re_init_context(struct verbs_device *vdev,
 				struct ibv_context *ibvctx, int cmd_fd)
 {
diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index 9677ff7..f754a85 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -40,6 +40,7 @@
 #define __MAIN_H__
 
 #include <inttypes.h>
+#include <stdbool.h>
 #include <stddef.h>
 #include <endian.h>
 #include <pthread.h>
@@ -76,23 +77,40 @@ struct bnxt_re_srq {
 	struct ibv_srq ibvsrq;
 };
 
+struct bnxt_re_wrid {
+	struct bnxt_re_psns *psns;
+	uint64_t wrid;
+	uint32_t bytes;
+	uint8_t sig;
+};
+
+struct bnxt_re_qpcap {
+	uint32_t max_swr;
+	uint32_t max_rwr;
+	uint32_t max_ssge;
+	uint32_t max_rsge;
+	uint32_t max_inline;
+	uint8_t	sqsig;
+};
+
 struct bnxt_re_qp {
 	struct ibv_qp ibvqp;
 	struct bnxt_re_queue *sqq;
-	struct bnxt_re_psns *psns; /* start ptr. */
+	struct bnxt_re_wrid *swrid;
 	struct bnxt_re_queue *rqq;
+	struct bnxt_re_wrid *rwrid;
 	struct bnxt_re_srq *srq;
 	struct bnxt_re_cq *scq;
 	struct bnxt_re_cq *rcq;
 	struct bnxt_re_dpi *udpi;
-	uint64_t *swrid;
-	uint64_t *rwrid;
+	struct bnxt_re_qpcap cap;
 	uint32_t qpid;
 	uint32_t tbl_indx;
+	uint32_t sq_psn;
+	uint32_t pending_db;
 	uint16_t mtu;
 	uint16_t qpst;
 	uint8_t qptyp;
-	/* wrid? */
 	/* irdord? */
 };
 
@@ -117,6 +135,14 @@ struct bnxt_re_context {
 	struct bnxt_re_dpi udpi;
 };
 
+/* DB ring functions used internally*/
+void bnxt_re_ring_rq_db(struct bnxt_re_qp *qp);
+void bnxt_re_ring_sq_db(struct bnxt_re_qp *qp);
+void bnxt_re_ring_srq_db(struct bnxt_re_srq *srq);
+void bnxt_re_ring_cq_db(struct bnxt_re_cq *cq);
+void bnxt_re_ring_cq_arm_db(struct bnxt_re_cq *cq, uint8_t aflag);
+
+/* pointer conversion functions*/
 static inline struct bnxt_re_dev *to_bnxt_re_dev(struct ibv_device *ibvdev)
 {
 	return container_of(ibvdev, struct bnxt_re_dev, vdev);
@@ -150,10 +176,177 @@ static inline uint32_t bnxt_re_get_sqe_sz(void)
 	       BNXT_RE_MAX_INLINE_SIZE;
 }
 
+static inline uint32_t bnxt_re_get_sqe_hdr_sz(void)
+{
+	return sizeof(struct bnxt_re_bsqe) + sizeof(struct bnxt_re_send);
+}
+
 static inline uint32_t bnxt_re_get_rqe_sz(void)
 {
 	return sizeof(struct bnxt_re_brqe) +
 	       sizeof(struct bnxt_re_rqe) +
 	       BNXT_RE_MAX_INLINE_SIZE;
 }
+
+static inline uint32_t bnxt_re_get_rqe_hdr_sz(void)
+{
+	return sizeof(struct bnxt_re_brqe) + sizeof(struct bnxt_re_rqe);
+}
+
+static inline uint32_t bnxt_re_get_cqe_sz(void)
+{
+	return sizeof(struct bnxt_re_req_cqe) + sizeof(struct bnxt_re_bcqe);
+}
+
+static inline uint8_t bnxt_re_ibv_to_bnxt_wr_opcd(uint8_t ibv_opcd)
+{
+	uint8_t bnxt_opcd;
+
+	switch (ibv_opcd) {
+	case IBV_WR_SEND:
+		bnxt_opcd = BNXT_RE_WR_OPCD_SEND;
+		break;
+	case IBV_WR_SEND_WITH_IMM:
+		bnxt_opcd = BNXT_RE_WR_OPCD_SEND_IMM;
+		break;
+	case IBV_WR_RDMA_WRITE:
+		bnxt_opcd = BNXT_RE_WR_OPCD_RDMA_WRITE;
+		break;
+	case IBV_WR_RDMA_WRITE_WITH_IMM:
+		bnxt_opcd = BNXT_RE_WR_OPCD_RDMA_WRITE_IMM;
+		break;
+	case IBV_WR_RDMA_READ:
+		bnxt_opcd = BNXT_RE_WR_OPCD_RDMA_READ;
+		break;
+		/* TODO: Add other opcodes */
+	default:
+		bnxt_opcd = 0xFF;
+		break;
+	};
+
+	return bnxt_opcd;
+}
+
+static inline uint8_t bnxt_re_ibv_wr_to_wc_opcd(uint8_t wr_opcd)
+{
+	uint8_t wc_opcd;
+
+	switch (wr_opcd) {
+	case IBV_WR_SEND_WITH_IMM:
+	case IBV_WR_SEND:
+		wc_opcd = IBV_WC_SEND;
+		break;
+	case IBV_WR_RDMA_WRITE_WITH_IMM:
+	case IBV_WR_RDMA_WRITE:
+		wc_opcd = IBV_WC_RDMA_WRITE;
+		break;
+	case IBV_WR_RDMA_READ:
+		wc_opcd = IBV_WC_RDMA_READ;
+		break;
+	case IBV_WR_ATOMIC_CMP_AND_SWP:
+		wc_opcd = IBV_WC_COMP_SWAP;
+		break;
+	case IBV_WR_ATOMIC_FETCH_AND_ADD:
+		wc_opcd = IBV_WC_FETCH_ADD;
+		break;
+	default:
+		wc_opcd = 0xFF;
+		break;
+	}
+
+	return wc_opcd;
+}
+
+static inline uint8_t bnxt_re_to_ibv_wc_status(uint8_t bnxt_wcst,
+					       uint8_t is_req)
+{
+	uint8_t ibv_wcst;
+
+	if (is_req) {
+		switch (bnxt_wcst) {
+		case BNXT_RE_REQ_ST_BAD_RESP:
+			ibv_wcst = IBV_WC_BAD_RESP_ERR;
+			break;
+		case BNXT_RE_REQ_ST_LOC_LEN:
+			ibv_wcst = IBV_WC_LOC_LEN_ERR;
+			break;
+		case BNXT_RE_REQ_ST_LOC_QP_OP:
+			ibv_wcst = IBV_WC_LOC_QP_OP_ERR;
+			break;
+		case BNXT_RE_REQ_ST_PROT:
+			ibv_wcst = IBV_WC_LOC_PROT_ERR;
+			break;
+		case BNXT_RE_REQ_ST_MEM_OP:
+			ibv_wcst = IBV_WC_MW_BIND_ERR;
+			break;
+		case BNXT_RE_REQ_ST_REM_INVAL:
+			ibv_wcst = IBV_WC_REM_INV_REQ_ERR;
+			break;
+		case BNXT_RE_REQ_ST_REM_ACC:
+			ibv_wcst = IBV_WC_REM_ACCESS_ERR;
+			break;
+		case BNXT_RE_REQ_ST_REM_OP:
+			ibv_wcst = IBV_WC_REM_OP_ERR;
+			break;
+		case BNXT_RE_REQ_ST_RNR_NAK_XCED:
+			ibv_wcst = IBV_WC_RNR_RETRY_EXC_ERR;
+			break;
+		case BNXT_RE_REQ_ST_TRNSP_XCED:
+			ibv_wcst = IBV_WC_RETRY_EXC_ERR;
+			break;
+		case BNXT_RE_REQ_ST_WR_FLUSH:
+			ibv_wcst = IBV_WC_WR_FLUSH_ERR;
+			break;
+		default:
+			ibv_wcst = IBV_WC_GENERAL_ERR;
+			break;
+		}
+	} else {
+		switch (bnxt_wcst) {
+		case BNXT_RE_RSP_ST_LOC_ACC:
+			ibv_wcst = IBV_WC_LOC_ACCESS_ERR;
+			break;
+		case BNXT_RE_RSP_ST_LOC_LEN:
+			ibv_wcst = IBV_WC_LOC_LEN_ERR;
+			break;
+		case BNXT_RE_RSP_ST_LOC_PROT:
+			ibv_wcst = IBV_WC_LOC_PROT_ERR;
+			break;
+		case BNXT_RE_RSP_ST_LOC_QP_OP:
+			ibv_wcst = IBV_WC_LOC_QP_OP_ERR;
+			break;
+		case BNXT_RE_RSP_ST_MEM_OP:
+			ibv_wcst = IBV_WC_MW_BIND_ERR;
+			break;
+		case BNXT_RE_RSP_ST_REM_INVAL:
+			ibv_wcst = IBV_WC_REM_INV_REQ_ERR;
+			break;
+		case BNXT_RE_RSP_ST_WR_FLUSH:
+			ibv_wcst = IBV_WC_WR_FLUSH_ERR;
+			break;
+		case BNXT_RE_RSP_ST_HW_FLUSH:
+			ibv_wcst = IBV_WC_FATAL_ERR;
+			break;
+		default:
+			ibv_wcst = IBV_WC_GENERAL_ERR;
+			break;
+		}
+	}
+
+	return ibv_wcst;
+}
+
+static inline uint8_t bnxt_re_is_cqe_valid(struct bnxt_re_cq *cq,
+					   struct bnxt_re_bcqe *hdr)
+{
+	udma_from_device_barrier();
+	return ((le32toh(hdr->flg_st_typ_ph) &
+		 BNXT_RE_BCQE_PH_MASK) == cq->phase);
+}
+
+static inline void bnxt_re_change_cq_phase(struct bnxt_re_cq *cq)
+{
+	if (!cq->cqq.head)
+		cq->phase = (~cq->phase & BNXT_RE_BCQE_PH_MASK);
+}
 #endif
diff --git a/providers/bnxt_re/memory.h b/providers/bnxt_re/memory.h
index ea29a24..4d6ab4d 100644
--- a/providers/bnxt_re/memory.h
+++ b/providers/bnxt_re/memory.h
@@ -73,4 +73,35 @@ static inline unsigned long roundup_pow_of_two(unsigned long val)
 int bnxt_re_alloc_aligned(struct bnxt_re_queue *que, uint32_t pg_size);
 void bnxt_re_free_aligned(struct bnxt_re_queue *que);
 
+static inline void iowrite64(__u64 *dst, __le64 *src)
+{
+	*(volatile __le64 *)dst = *src;
+}
+
+static inline void iowrite32(__u32 *dst, __le32 *src)
+{
+	*(volatile __le32 *)dst = *src;
+}
+
+/* Basic queue operation */
+static inline uint32_t bnxt_re_is_que_full(struct bnxt_re_queue *que)
+{
+	return (((que->tail + 1) & (que->depth - 1)) == que->head);
+}
+
+static inline uint32_t bnxt_re_incr(uint32_t val, uint32_t max)
+{
+	return (++val & (max - 1));
+}
+
+static inline void bnxt_re_incr_tail(struct bnxt_re_queue *que)
+{
+	que->tail = bnxt_re_incr(que->tail, que->depth);
+}
+
+static inline void bnxt_re_incr_head(struct bnxt_re_queue *que)
+{
+	que->head = bnxt_re_incr(que->head, que->depth);
+}
+
 #endif
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index d5b081d..13cdbe1 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -232,9 +232,264 @@ int bnxt_re_destroy_cq(struct ibv_cq *ibvcq)
 	return 0;
 }
 
+static uint8_t bnxt_re_poll_success_scqe(struct bnxt_re_qp *qp,
+					 struct ibv_wc *ibvwc,
+					 struct bnxt_re_bcqe *hdr,
+					 struct bnxt_re_req_cqe *scqe,
+					 int *cnt)
+{
+	struct bnxt_re_queue *sq = qp->sqq;
+	struct bnxt_re_wrid *swrid;
+	struct bnxt_re_psns *spsn;
+	uint8_t pcqe = false;
+	uint32_t head = sq->head;
+	uint32_t cindx;
+
+	swrid = &qp->swrid[head];
+	spsn = swrid->psns;
+	cindx = le32toh(scqe->con_indx);
+
+	if (!(swrid->sig & IBV_SEND_SIGNALED)) {
+		*cnt = 0;
+	} else {
+		ibvwc->status = IBV_WC_SUCCESS;
+		ibvwc->wc_flags = 0;
+		ibvwc->qp_num = qp->qpid;
+		ibvwc->wr_id = swrid->wrid;
+		ibvwc->opcode = (le32toh(spsn->opc_spsn) >>
+				BNXT_RE_PSNS_OPCD_SHIFT) &
+				BNXT_RE_PSNS_OPCD_MASK;
+		if (ibvwc->opcode == IBV_WC_RDMA_READ ||
+		    ibvwc->opcode == IBV_WC_COMP_SWAP ||
+		    ibvwc->opcode == IBV_WC_FETCH_ADD)
+			ibvwc->byte_len = swrid->bytes;
+
+		*cnt = 1;
+	}
+
+	bnxt_re_incr_head(sq);
+	if (sq->head != cindx)
+		pcqe = true;
+
+	return pcqe;
+}
+
+static uint8_t bnxt_re_poll_scqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
+				 void *cqe, int *cnt)
+{
+	struct bnxt_re_bcqe *hdr;
+	struct bnxt_re_req_cqe *scqe;
+	uint8_t status, pcqe = false;
+
+	scqe = cqe;
+	hdr = cqe + sizeof(struct bnxt_re_req_cqe);
+
+	status = (le32toh(hdr->flg_st_typ_ph) >> BNXT_RE_BCQE_STATUS_SHIFT) &
+		  BNXT_RE_BCQE_STATUS_MASK;
+	if (status == BNXT_RE_REQ_ST_OK) {
+		pcqe = bnxt_re_poll_success_scqe(qp, ibvwc, hdr, scqe, cnt);
+	} else {
+		/* TODO: Handle error completion properly. */
+		fprintf(stderr, "%s(): swc with error, vendor status = %d\n",
+			__func__, status);
+		*cnt = 1;
+		ibvwc->status = bnxt_re_to_ibv_wc_status(status, true);
+		ibvwc->wr_id = qp->swrid[qp->sqq->head].wrid;
+		bnxt_re_incr_head(qp->sqq);
+	}
+
+	return pcqe;
+}
+
+static void bnxt_re_poll_success_rcqe(struct bnxt_re_qp *qp,
+				      struct ibv_wc *ibvwc,
+				      struct bnxt_re_bcqe *hdr,
+				      struct bnxt_re_rc_cqe *rcqe)
+{
+	struct bnxt_re_queue *rq = qp->rqq;
+	struct bnxt_re_wrid *rwrid;
+	uint32_t head = rq->head;
+	uint8_t flags, is_imm, is_rdma;
+
+	rwrid = &qp->rwrid[head];
+
+	ibvwc->status = IBV_WC_SUCCESS;
+	ibvwc->wr_id = rwrid->wrid;
+	ibvwc->qp_num = qp->qpid;
+	ibvwc->byte_len = le32toh(rcqe->length);
+	ibvwc->opcode = IBV_WC_RECV;
+
+	flags = (le32toh(hdr->flg_st_typ_ph) >> BNXT_RE_BCQE_FLAGS_SHIFT) &
+		 BNXT_RE_BCQE_FLAGS_MASK;
+	is_imm = (flags & BNXT_RE_RC_FLAGS_IMM_MASK) >>
+		  BNXT_RE_RC_FLAGS_IMM_SHIFT;
+	is_rdma = (flags & BNXT_RE_RC_FLAGS_RDMA_MASK) >>
+		   BNXT_RE_RC_FLAGS_RDMA_SHIFT;
+	ibvwc->wc_flags = 0;
+	if (is_imm) {
+		ibvwc->wc_flags |= IBV_WC_WITH_IMM;
+		ibvwc->imm_data = htobe32(le32toh(rcqe->imm_key));
+		if (is_rdma)
+			ibvwc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
+	}
+
+	bnxt_re_incr_head(rq);
+}
+
+static uint8_t bnxt_re_poll_rcqe(struct bnxt_re_qp *qp, struct ibv_wc *ibvwc,
+				 void *cqe, int *cnt)
+{
+	struct bnxt_re_bcqe *hdr;
+	struct bnxt_re_rc_cqe *rcqe;
+	uint8_t status, pcqe = false;
+
+	rcqe = cqe;
+	hdr = cqe + sizeof(struct bnxt_re_rc_cqe);
+
+	status = (le32toh(hdr->flg_st_typ_ph) >> BNXT_RE_BCQE_STATUS_SHIFT) &
+		  BNXT_RE_BCQE_STATUS_MASK;
+	if (status == BNXT_RE_RSP_ST_OK) {
+		bnxt_re_poll_success_rcqe(qp, ibvwc, hdr, rcqe);
+		*cnt = 1;
+	} else {
+		/* TODO: Process error completions properly.*/
+		*cnt = 1;
+		ibvwc->status = bnxt_re_to_ibv_wc_status(status, false);
+		if (qp->rqq) {
+			ibvwc->wr_id = qp->rwrid[qp->rqq->head].wrid;
+			bnxt_re_incr_head(qp->rqq);
+		}
+	}
+
+	return pcqe;
+}
+
+static int bnxt_re_poll_one(struct bnxt_re_cq *cq, int nwc, struct ibv_wc *wc)
+{
+	struct bnxt_re_queue *cqq = &cq->cqq;
+	struct bnxt_re_qp *qp;
+	struct bnxt_re_bcqe *hdr;
+	struct bnxt_re_req_cqe *scqe;
+	struct bnxt_re_ud_cqe *rcqe;
+	void *cqe;
+	uint64_t *qp_handle = NULL;
+	int type, cnt = 0, dqed = 0, hw_polled = 0;
+	uint8_t pcqe = false;
+
+	while (nwc) {
+		cqe = cqq->va + cqq->head * bnxt_re_get_cqe_sz();
+		hdr = cqe + sizeof(struct bnxt_re_req_cqe);
+		if (!bnxt_re_is_cqe_valid(cq, hdr))
+			break;
+		type = (le32toh(hdr->flg_st_typ_ph) >>
+			BNXT_RE_BCQE_TYPE_SHIFT) & BNXT_RE_BCQE_TYPE_MASK;
+		switch (type) {
+		case BNXT_RE_WC_TYPE_SEND:
+			scqe = cqe;
+			qp_handle = (uint64_t *)&scqe->qp_handle;
+			qp = (struct bnxt_re_qp *)
+			     (uintptr_t)le64toh(scqe->qp_handle);
+			if (!qp)
+				break; /*stale cqe. should be rung.*/
+			if (qp->qptyp == IBV_QPT_UD)
+				goto bail; /* TODO: Add UD poll */
+
+			pcqe = bnxt_re_poll_scqe(qp, wc, cqe, &cnt);
+			break;
+		case BNXT_RE_WC_TYPE_RECV_RC:
+		case BNXT_RE_WC_TYPE_RECV_UD:
+			rcqe = cqe;
+			qp_handle = (uint64_t *)&rcqe->qp_handle;
+			qp = (struct bnxt_re_qp *)
+			     (uintptr_t)le64toh(rcqe->qp_handle);
+			if (!qp)
+				break; /*stale cqe. should be rung.*/
+			if (qp->srq)
+				goto bail; /*TODO: Add SRQ poll */
+
+			pcqe = bnxt_re_poll_rcqe(qp, wc, cqe, &cnt);
+			/* TODO: Process UD rcqe */
+			break;
+		case BNXT_RE_WC_TYPE_RECV_RAW:
+			break;
+		case BNXT_RE_WC_TYPE_TERM:
+			break;
+		case BNXT_RE_WC_TYPE_COFF:
+			break;
+		default:
+			break;
+		};
+
+		if (pcqe)
+			goto skipp_real;
+
+		hw_polled++;
+		if (qp_handle) {
+			*qp_handle = 0x0ULL; /* mark cqe as read */
+			qp_handle = NULL;
+		}
+		bnxt_re_incr_head(&cq->cqq);
+		bnxt_re_change_cq_phase(cq);
+skipp_real:
+		if (cnt) {
+			cnt = 0;
+			dqed++;
+			nwc--;
+			wc++;
+		}
+	}
+
+	if (hw_polled)
+		bnxt_re_ring_cq_db(cq);
+bail:
+	return dqed;
+}
+
 int bnxt_re_poll_cq(struct ibv_cq *ibvcq, int nwc, struct ibv_wc *wc)
 {
-	return -ENOSYS;
+	struct bnxt_re_cq *cq = to_bnxt_re_cq(ibvcq);
+	int dqed;
+
+	pthread_spin_lock(&cq->cqq.qlock);
+	dqed = bnxt_re_poll_one(cq, nwc, wc);
+	pthread_spin_unlock(&cq->cqq.qlock);
+
+	/* TODO: Flush Management*/
+
+	return dqed;
+}
+
+static void bnxt_re_cleanup_cq(struct bnxt_re_qp *qp, struct bnxt_re_cq *cq)
+{
+	struct bnxt_re_queue *que = &cq->cqq;
+	struct bnxt_re_bcqe *hdr;
+	struct bnxt_re_req_cqe *scqe;
+	struct bnxt_re_rc_cqe *rcqe;
+	void *cqe;
+	int indx, type;
+
+	pthread_spin_lock(&que->qlock);
+	for (indx = 0; indx < que->depth; indx++) {
+		cqe = que->va + indx * bnxt_re_get_cqe_sz();
+		hdr = cqe + sizeof(struct bnxt_re_req_cqe);
+		type = (le32toh(hdr->flg_st_typ_ph) >>
+			BNXT_RE_BCQE_TYPE_SHIFT) & BNXT_RE_BCQE_TYPE_MASK;
+
+		if (type == BNXT_RE_WC_TYPE_COFF)
+			continue;
+		if (type == BNXT_RE_WC_TYPE_SEND ||
+		    type == BNXT_RE_WC_TYPE_TERM) {
+			scqe = cqe;
+			if (le64toh(scqe->qp_handle) == (uintptr_t)qp)
+				scqe->qp_handle = 0ULL;
+		} else {
+			rcqe = cqe;
+			if (le64toh(rcqe->qp_handle) == (uintptr_t)qp)
+				rcqe->qp_handle = 0ULL;
+		}
+
+	}
+	pthread_spin_unlock(&que->qlock);
 }
 
 void bnxt_re_cq_event(struct ibv_cq *ibvcq)
@@ -244,11 +499,40 @@ void bnxt_re_cq_event(struct ibv_cq *ibvcq)
 
 int bnxt_re_arm_cq(struct ibv_cq *ibvcq, int flags)
 {
-	return -ENOSYS;
+	struct bnxt_re_cq *cq = to_bnxt_re_cq(ibvcq);
+
+	pthread_spin_lock(&cq->cqq.qlock);
+	flags = !flags ? BNXT_RE_QUE_TYPE_CQ_ARMALL :
+			 BNXT_RE_QUE_TYPE_CQ_ARMSE;
+	bnxt_re_ring_cq_arm_db(cq, flags);
+	pthread_spin_unlock(&cq->cqq.qlock);
+
+	return 0;
 }
 
-static int bnxt_re_check_qp_limits(struct ibv_qp_init_attr *attr)
+static int bnxt_re_check_qp_limits(struct bnxt_re_context *cntx,
+				   struct ibv_qp_init_attr *attr)
 {
+	struct ibv_device_attr devattr;
+	int ret;
+
+	if (attr->qp_type == IBV_QPT_UD)
+		return -ENOSYS;
+
+	ret = bnxt_re_query_device(&cntx->ibvctx, &devattr);
+	if (ret)
+		return ret;
+	if (attr->cap.max_send_sge > devattr.max_sge)
+		return EINVAL;
+	if (attr->cap.max_recv_sge > devattr.max_sge)
+		return EINVAL;
+	if (attr->cap.max_inline_data > BNXT_RE_MAX_INLINE_SIZE)
+		return EINVAL;
+	if (attr->cap.max_send_wr > devattr.max_qp_wr)
+		attr->cap.max_send_wr = devattr.max_qp_wr;
+	if (attr->cap.max_recv_wr > devattr.max_qp_wr)
+		attr->cap.max_recv_wr = devattr.max_qp_wr;
+
 	return 0;
 }
 
@@ -296,49 +580,56 @@ static int bnxt_re_alloc_queues(struct bnxt_re_qp *qp,
 				struct ibv_qp_init_attr *attr,
 				uint32_t pg_size) {
 	struct bnxt_re_queue *que;
+	struct bnxt_re_psns *psns;
 	uint32_t psn_depth;
-	int ret;
-
-	if (attr->cap.max_send_wr) {
-		que = qp->sqq;
-		que->stride = bnxt_re_get_sqe_sz();
-		que->depth = roundup_pow_of_two(attr->cap.max_send_wr);
-		/* psn_depth extra entries of size que->stride */
-		psn_depth = (que->depth * sizeof(struct bnxt_re_psns)) /
-			     que->stride;
-		que->depth += psn_depth;
-		ret = bnxt_re_alloc_aligned(qp->sqq, pg_size);
-		if (ret)
-			return ret;
-		/* exclude psns depth*/
-		que->depth -= psn_depth;
-		/* start of spsn space sizeof(struct bnxt_re_psns) each. */
-		qp->psns = (que->va + que->stride * que->depth);
-		pthread_spin_init(&que->qlock, PTHREAD_PROCESS_PRIVATE);
-		qp->swrid = calloc(que->depth, sizeof(uint64_t));
-		if (!qp->swrid) {
-			ret = -ENOMEM;
-			goto fail;
-		}
+	int ret, indx;
+
+	que = qp->sqq;
+	que->stride = bnxt_re_get_sqe_sz();
+	que->depth = roundup_pow_of_two(attr->cap.max_send_wr + 1);
+	/* psn_depth extra entries of size que->stride */
+	psn_depth = (que->depth * sizeof(struct bnxt_re_psns)) /
+		     que->stride;
+	if ((que->depth * sizeof(struct bnxt_re_psns)) % que->stride)
+		psn_depth++;
+
+	que->depth += psn_depth;
+	ret = bnxt_re_alloc_aligned(qp->sqq, pg_size);
+	if (ret)
+		return ret;
+	/* exclude psns depth*/
+	que->depth -= psn_depth;
+	/* start of spsn space sizeof(struct bnxt_re_psns) each. */
+	psns = (que->va + que->stride * que->depth);
+	pthread_spin_init(&que->qlock, PTHREAD_PROCESS_PRIVATE);
+	qp->swrid = calloc(que->depth, sizeof(struct bnxt_re_wrid));
+	if (!qp->swrid) {
+		ret = -ENOMEM;
+		goto fail;
 	}
 
-	if (attr->cap.max_recv_wr && qp->rqq) {
+	for (indx = 0 ; indx < que->depth; indx++, psns++)
+		qp->swrid[indx].psns = psns;
+	qp->cap.max_swr = que->depth;
+
+	if (qp->rqq) {
 		que = qp->rqq;
 		que->stride = bnxt_re_get_rqe_sz();
-		que->depth = roundup_pow_of_two(attr->cap.max_recv_wr);
+		que->depth = roundup_pow_of_two(attr->cap.max_recv_wr + 1);
 		ret = bnxt_re_alloc_aligned(qp->rqq, pg_size);
 		if (ret)
 			goto fail;
 		pthread_spin_init(&que->qlock, PTHREAD_PROCESS_PRIVATE);
-		qp->rwrid = calloc(que->depth, sizeof(uint64_t));
+		/* For RQ only bnxt_re_wri.wrid is used. */
+		qp->rwrid = calloc(que->depth, sizeof(struct bnxt_re_wrid));
 		if (!qp->rwrid) {
 			ret = -ENOMEM;
 			goto fail;
 		}
+		qp->cap.max_rwr = que->depth;
 	}
 
 	return 0;
-
 fail:
 	bnxt_re_free_queues(qp);
 	return ret;
@@ -350,11 +641,12 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
 	struct bnxt_re_qp *qp;
 	struct bnxt_re_qp_req req;
 	struct bnxt_re_qp_resp resp;
+	struct bnxt_re_qpcap *cap;
 
 	struct bnxt_re_context *cntx = to_bnxt_re_context(ibvpd->context);
 	struct bnxt_re_dev *dev = to_bnxt_re_dev(cntx->ibvctx.device);
 
-	if (bnxt_re_check_qp_limits(attr))
+	if (bnxt_re_check_qp_limits(cntx, attr))
 		return NULL;
 
 	qp = calloc(1, sizeof(*qp));
@@ -367,6 +659,7 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
 	if (bnxt_re_alloc_queues(qp, attr, dev->pg_size))
 		goto failq;
 	/* Fill ibv_cmd */
+	cap = &qp->cap;
 	req.qpsva = (uintptr_t)qp->sqq->va;
 	req.qprva = qp->rqq ? (uintptr_t)qp->rqq->va : 0;
 	req.qp_handle = (uintptr_t)qp;
@@ -382,6 +675,13 @@ struct ibv_qp *bnxt_re_create_qp(struct ibv_pd *ibvpd,
 	qp->scq = to_bnxt_re_cq(attr->send_cq);
 	qp->rcq = to_bnxt_re_cq(attr->recv_cq);
 	qp->udpi = &cntx->udpi;
+	/* Save/return the altered Caps. */
+	attr->cap.max_send_wr = cap->max_swr;
+	cap->max_ssge = attr->cap.max_send_sge;
+	attr->cap.max_recv_wr = cap->max_rwr;
+	cap->max_rsge = attr->cap.max_recv_sge;
+	cap->max_inline = attr->cap.max_inline_data;
+	cap->sqsig = attr->sq_sig_all;
 
 	return &qp->ibvqp;
 failcmd:
@@ -402,8 +702,15 @@ int bnxt_re_modify_qp(struct ibv_qp *ibvqp, struct ibv_qp_attr *attr,
 	int rc;
 
 	rc = ibv_cmd_modify_qp(ibvqp, attr, attr_mask, &cmd, sizeof(cmd));
-	if (!rc)
-		qp->qpst = ibvqp->state;
+	if (!rc) {
+		if (attr_mask & IBV_QP_STATE)
+			qp->qpst = attr->qp_state;
+
+		if (attr_mask & IBV_QP_SQ_PSN)
+			qp->sq_psn = attr->sq_psn;
+		if (attr_mask & IBV_QP_PATH_MTU)
+			qp->mtu = (0x80 << attr->path_mtu);
+	}
 
 	return rc;
 }
@@ -432,6 +739,8 @@ int bnxt_re_destroy_qp(struct ibv_qp *ibvqp)
 	if (status)
 		return status;
 
+	bnxt_re_cleanup_cq(qp, qp->rcq);
+	bnxt_re_cleanup_cq(qp, qp->scq);
 	bnxt_re_free_queues(qp);
 	bnxt_re_free_queue_ptr(qp);
 	free(qp);
@@ -439,16 +748,291 @@ int bnxt_re_destroy_qp(struct ibv_qp *ibvqp)
 	return 0;
 }
 
+static inline uint8_t bnxt_re_set_hdr_flags(struct bnxt_re_bsqe *hdr,
+					    uint32_t send_flags, uint8_t sqsig)
+{
+	uint8_t is_inline = false;
+	uint32_t hdrval = 0;
+
+	if (send_flags & IBV_SEND_SIGNALED || sqsig)
+		hdrval |= ((BNXT_RE_WR_FLAGS_SIGNALED & BNXT_RE_HDR_FLAGS_MASK)
+			    << BNXT_RE_HDR_FLAGS_SHIFT);
+	if (send_flags & IBV_SEND_FENCE)
+		/*TODO: See when RD fence can be used. */
+		hdrval |= ((BNXT_RE_WR_FLAGS_UC_FENCE & BNXT_RE_HDR_FLAGS_MASK)
+			    << BNXT_RE_HDR_FLAGS_SHIFT);
+	if (send_flags & IBV_SEND_SOLICITED)
+		hdrval |= ((BNXT_RE_WR_FLAGS_SE & BNXT_RE_HDR_FLAGS_MASK)
+			    << BNXT_RE_HDR_FLAGS_SHIFT);
+
+	if (send_flags & IBV_SEND_INLINE) {
+		hdrval |= ((BNXT_RE_WR_FLAGS_INLINE & BNXT_RE_HDR_FLAGS_MASK)
+			    << BNXT_RE_HDR_FLAGS_SHIFT);
+		is_inline = true;
+	}
+	hdr->rsv_ws_fl_wt = htole32(hdrval);
+
+	return is_inline;
+}
+
+static int bnxt_re_build_sge(struct bnxt_re_sge *sge, struct ibv_sge *sg_list,
+			     uint32_t num_sge, uint8_t is_inline) {
+	int indx, length = 0;
+	void *dst;
+
+	if (!num_sge) {
+		memset(sge, 0, sizeof(*sge));
+		return 0;
+	}
+
+	if (is_inline) {
+		dst = sge;
+		for (indx = 0; indx < num_sge; indx++) {
+			length += sg_list[indx].length;
+			if (length > BNXT_RE_MAX_INLINE_SIZE)
+				return -ENOMEM;
+			memcpy(dst, (void *)(uintptr_t)sg_list[indx].addr,
+			       sg_list[indx].length);
+			dst = dst + sg_list[indx].length;
+		}
+	} else {
+		for (indx = 0; indx < num_sge; indx++) {
+			sge[indx].pa = htole64(sg_list[indx].addr);
+			sge[indx].lkey = htole32(sg_list[indx].lkey);
+			sge[indx].length = htole32(sg_list[indx].length);
+			length += sg_list[indx].length;
+		}
+	}
+
+	return length;
+}
+
+static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
+			      uint8_t opcode, uint32_t len)
+{
+	uint32_t pkt_cnt = 0, nxt_psn;
+
+	memset(psns, 0, sizeof(*psns));
+	psns->opc_spsn = htole32(qp->sq_psn & BNXT_RE_PSNS_SPSN_MASK);
+	opcode = bnxt_re_ibv_wr_to_wc_opcd(opcode);
+	psns->opc_spsn |= htole32(((opcode & BNXT_RE_PSNS_OPCD_MASK) <<
+				    BNXT_RE_PSNS_OPCD_SHIFT));
+
+	pkt_cnt = (len / qp->mtu);
+	if (len % qp->mtu)
+		pkt_cnt++;
+	nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
+	psns->flg_npsn = htole32(nxt_psn);
+	qp->sq_psn = nxt_psn;
+}
+
+static void bnxt_re_fill_wrid(struct bnxt_re_wrid *wrid, struct ibv_send_wr *wr,
+			      uint32_t len, uint8_t sqsig)
+{
+	wrid->wrid = wr->wr_id;
+	wrid->bytes = len;
+	wrid->sig = 0;
+	if (wr->send_flags & IBV_SEND_SIGNALED || sqsig)
+		wrid->sig = IBV_SEND_SIGNALED;
+}
+
+static int bnxt_re_build_send_sqe(struct bnxt_re_qp *qp, void *wqe,
+				  struct ibv_send_wr *wr, uint8_t is_inline)
+{
+	struct bnxt_re_bsqe *hdr = wqe;
+	struct bnxt_re_send *sqe = ((void *)wqe + sizeof(struct bnxt_re_bsqe));
+	struct bnxt_re_sge *sge = ((void *)wqe + bnxt_re_get_sqe_hdr_sz());
+	uint32_t wrlen, hdrval = 0;
+	int len;
+	uint8_t opcode, qesize;
+
+	len = bnxt_re_build_sge(sge, wr->sg_list, wr->num_sge, is_inline);
+	if (len < 0)
+		return len;
+	sqe->length = htole32(len);
+
+	/* Fill Header */
+	opcode = bnxt_re_ibv_to_bnxt_wr_opcd(wr->opcode);
+	hdrval = (opcode & BNXT_RE_HDR_WT_MASK);
+
+	if (is_inline) {
+		wrlen = get_aligned(len, 16);
+		qesize = wrlen >> 4;
+	} else {
+		qesize = wr->num_sge;
+	}
+	qesize += (bnxt_re_get_sqe_hdr_sz() >> 4);
+	hdrval |= (qesize & BNXT_RE_HDR_WS_MASK) << BNXT_RE_HDR_WS_SHIFT;
+	hdr->rsv_ws_fl_wt |= htole32(hdrval);
+	return len;
+}
+
+static int bnxt_re_build_rdma_sqe(struct bnxt_re_qp *qp, void *wqe,
+				  struct ibv_send_wr *wr, uint8_t is_inline)
+{
+	struct bnxt_re_rdma *sqe = ((void *)wqe + sizeof(struct bnxt_re_bsqe));
+	int len;
+
+	len = bnxt_re_build_send_sqe(qp, wqe, wr, is_inline);
+	sqe->rva = htole64(wr->wr.rdma.remote_addr);
+	sqe->rkey = htole32(wr->wr.rdma.rkey);
+
+	return len;
+}
+
 int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 		      struct ibv_send_wr **bad)
 {
-	return -ENOSYS;
+	struct bnxt_re_qp *qp = to_bnxt_re_qp(ibvqp);
+	struct bnxt_re_queue *sq = qp->sqq;
+	struct bnxt_re_bsqe *hdr;
+	struct bnxt_re_wrid *wrid;
+	struct bnxt_re_psns *psns;
+	void *sqe;
+	int ret = 0, bytes = 0;
+	uint8_t is_inline = false;
+
+	pthread_spin_lock(&sq->qlock);
+	while (wr) {
+		if ((qp->qpst != IBV_QPS_RTS) && (qp->qpst != IBV_QPS_SQD)) {
+			*bad = wr;
+			pthread_spin_unlock(&sq->qlock);
+			return EINVAL;
+		}
+
+		if ((qp->qptyp == IBV_QPT_UD) &&
+		    (wr->opcode != IBV_WR_SEND &&
+		     wr->opcode != IBV_WR_SEND_WITH_IMM)) {
+			*bad = wr;
+			pthread_spin_unlock(&sq->qlock);
+			return EINVAL;
+		}
+
+		if (bnxt_re_is_que_full(sq) ||
+		    wr->num_sge > qp->cap.max_ssge) {
+			*bad = wr;
+			pthread_spin_unlock(&sq->qlock);
+			return ENOMEM;
+		}
+
+		sqe = (void *)(sq->va + (sq->tail * sq->stride));
+		wrid = &qp->swrid[sq->tail];
+		psns = wrid->psns;
+
+		memset(sqe, 0, bnxt_re_get_sqe_sz());
+		hdr = sqe;
+		is_inline = bnxt_re_set_hdr_flags(hdr, wr->send_flags,
+						  qp->cap.sqsig);
+		switch (wr->opcode) {
+		case IBV_WR_SEND_WITH_IMM:
+			hdr->key_immd = htole32(be32toh(wr->imm_data));
+		case IBV_WR_SEND:
+			bytes = bnxt_re_build_send_sqe(qp, sqe, wr, is_inline);
+			if (bytes < 0)
+				ret = ENOMEM;
+			break;
+		case IBV_WR_RDMA_WRITE_WITH_IMM:
+			hdr->key_immd = htole32(be32toh(wr->imm_data));
+		case IBV_WR_RDMA_WRITE:
+			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, is_inline);
+			if (bytes < 0)
+				ret = ENOMEM;
+			break;
+		case IBV_WR_RDMA_READ:
+			bytes = bnxt_re_build_rdma_sqe(qp, sqe, wr, false);
+			if (bytes < 0)
+				ret = ENOMEM;
+			break;
+		default:
+			ret = EINVAL;
+			break;
+		}
+
+		if (ret) {
+			*bad = wr;
+			break;
+		}
+
+		bnxt_re_fill_wrid(wrid, wr, bytes, qp->cap.sqsig);
+		bnxt_re_fill_psns(qp, psns, wr->opcode, bytes);
+		bnxt_re_incr_tail(sq);
+		wr = wr->next;
+		bnxt_re_ring_sq_db(qp);
+	}
+
+	pthread_spin_unlock(&sq->qlock);
+	return ret;
+}
+
+static int bnxt_re_build_rqe(struct bnxt_re_qp *qp, struct ibv_recv_wr *wr,
+			     void *rqe)
+{
+	struct bnxt_re_brqe *hdr = rqe;
+	struct bnxt_re_rqe *rwr;
+	struct bnxt_re_sge *sge;
+	struct bnxt_re_wrid *wrid;
+	int wqe_sz, len;
+	uint32_t hdrval;
+
+	rwr = (rqe + sizeof(struct bnxt_re_brqe));
+	sge = (rqe + bnxt_re_get_rqe_hdr_sz());
+	wrid = &qp->rwrid[qp->rqq->tail];
+
+	len = bnxt_re_build_sge(sge, wr->sg_list, wr->num_sge, false);
+	wqe_sz = wr->num_sge + (bnxt_re_get_rqe_hdr_sz() >> 4); /* 16B align */
+	hdrval = BNXT_RE_WR_OPCD_RECV;
+	hdrval |= ((wqe_sz & BNXT_RE_HDR_WS_MASK) << BNXT_RE_HDR_WS_SHIFT);
+	hdr->rsv_ws_fl_wt = htole32(hdrval);
+	rwr->wrid = htole32(qp->rqq->tail);
+
+	/* Fill wrid */
+	wrid->wrid = wr->wr_id;
+	wrid->bytes = len; /* N.A. for RQE */
+	wrid->sig = 0; /* N.A. for RQE */
+
+	return len;
 }
 
 int bnxt_re_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
 		      struct ibv_recv_wr **bad)
 {
-	return -ENOSYS;
+	struct bnxt_re_qp *qp = to_bnxt_re_qp(ibvqp);
+	struct bnxt_re_queue *rq = qp->rqq;
+	void *rqe;
+	int ret;
+
+	pthread_spin_lock(&rq->qlock);
+	while (wr) {
+		/* check QP state, abort if it is ERR or RST */
+		if (qp->qpst == IBV_QPS_RESET || qp->qpst == IBV_QPS_ERR) {
+			*bad = wr;
+			pthread_spin_unlock(&rq->qlock);
+			return EINVAL;
+		}
+
+		if (bnxt_re_is_que_full(rq) ||
+		    wr->num_sge > qp->cap.max_rsge) {
+			pthread_spin_unlock(&rq->qlock);
+			*bad = wr;
+			return ENOMEM;
+		}
+
+		rqe = (void *)(rq->va + (rq->tail * rq->stride));
+		memset(rqe, 0, bnxt_re_get_rqe_sz());
+		ret = bnxt_re_build_rqe(qp, wr, rqe);
+		if (ret < 0) {
+			pthread_spin_unlock(&rq->qlock);
+			*bad = wr;
+			return ENOMEM;
+		}
+
+		bnxt_re_incr_tail(rq);
+		wr = wr->next;
+		bnxt_re_ring_rq_db(qp);
+	}
+	pthread_spin_unlock(&rq->qlock);
+
+	return 0;
 }
 
 struct ibv_srq *bnxt_re_create_srq(struct ibv_pd *ibvpd,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
