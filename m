From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 rdma-core 3/5] libhns: Introduce CQ operations referred to hip08 device
Date: Tue, 24 Oct 2017 21:21:47 +0800
Message-ID: <1508851309-183263-4-git-send-email-oulijun@huawei.com>
References: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508851309-183263-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CQ APIs need to operate doorbell and cqe. the design of doorbell
and cqe in The different hardware is discrepant. Hence, This patch
introduces the CQ operations of hip08 hardware.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v2.c | 304 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_hw_v2.h |  75 ++++++++++
 providers/hns/hns_roce_u_verbs.c |  14 +-
 3 files changed, 388 insertions(+), 5 deletions(-)

diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index bf1c3f3..2aecc2b 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -37,6 +37,59 @@
 #include "hns_roce_u_db.h"
 #include "hns_roce_u_hw_v2.h"
 
+static void hns_roce_v2_handle_error_cqe(struct hns_roce_v2_cqe *cqe,
+					 struct ibv_wc *wc)
+{
+	unsigned int status = roce_get_field(cqe->byte_4, CQE_BYTE_4_STATUS_M,
+					     CQE_BYTE_4_STATUS_S);
+
+	fprintf(stderr, PFX "error cqe!\n");
+	switch (status & HNS_ROCE_V2_CQE_STATUS_MASK) {
+	case HNS_ROCE_V2_CQE_LOCAL_LENGTH_ERR:
+		wc->status = IBV_WC_LOC_LEN_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_LOCAL_QP_OP_ERR:
+		wc->status = IBV_WC_LOC_QP_OP_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_LOCAL_PROT_ERR:
+		wc->status = IBV_WC_LOC_PROT_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_WR_FLUSH_ERR:
+		wc->status = IBV_WC_WR_FLUSH_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_MEM_MANAGERENT_OP_ERR:
+		wc->status = IBV_WC_MW_BIND_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_BAD_RESP_ERR:
+		wc->status = IBV_WC_BAD_RESP_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_LOCAL_ACCESS_ERR:
+		wc->status = IBV_WC_LOC_ACCESS_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_REMOTE_INVAL_REQ_ERR:
+		wc->status = IBV_WC_REM_INV_REQ_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_REMOTE_ACCESS_ERR:
+		wc->status = IBV_WC_REM_ACCESS_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_REMOTE_OP_ERR:
+		wc->status = IBV_WC_REM_OP_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_TRANSPORT_RETRY_EXC_ERR:
+		wc->status = IBV_WC_RETRY_EXC_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_RNR_RETRY_EXC_ERR:
+		wc->status = IBV_WC_RNR_RETRY_EXC_ERR;
+		break;
+	case HNS_ROCE_V2_CQE_REMOTE_ABORTED_ERR:
+		wc->status = IBV_WC_REM_ABORT_ERR;
+		break;
+	default:
+		wc->status = IBV_WC_GENERAL_ERR;
+		break;
+	}
+}
+
 static struct hns_roce_v2_cqe *get_cqe_v2(struct hns_roce_cq *cq, int entry)
 {
 	return cq->buf.buf + entry * HNS_ROCE_CQE_ENTRY_SIZE;
@@ -50,6 +103,11 @@ static void *get_sw_cqe_v2(struct hns_roce_cq *cq, int n)
 		!!(n & (cq->ibv_cq.cqe + 1))) ? cqe : NULL;
 }
 
+static struct hns_roce_v2_cqe *next_cqe_sw(struct hns_roce_cq *cq)
+{
+	return get_sw_cqe_v2(cq, cq->cons_index);
+}
+
 static void hns_roce_v2_update_cq_cons_index(struct hns_roce_context *ctx,
 					     struct hns_roce_cq *cq)
 {
@@ -71,6 +129,17 @@ static void hns_roce_v2_update_cq_cons_index(struct hns_roce_context *ctx,
 	hns_roce_write64((uint32_t *)&cq_db, ctx, ROCEE_VF_DB_CFG0_OFFSET);
 }
 
+static struct hns_roce_qp *hns_roce_v2_find_qp(struct hns_roce_context *ctx,
+					       uint32_t qpn)
+{
+	int tind = (qpn & (ctx->num_qps - 1)) >> ctx->qp_table_shift;
+
+	if (ctx->qp_table[tind].refcnt)
+		return ctx->qp_table[tind].table[qpn & ctx->qp_table_mask];
+	else
+		return NULL;
+}
+
 static void hns_roce_v2_clear_qp(struct hns_roce_context *ctx, uint32_t qpn)
 {
 	int tind = (qpn & (ctx->num_qps - 1)) >> ctx->qp_table_shift;
@@ -81,6 +150,239 @@ static void hns_roce_v2_clear_qp(struct hns_roce_context *ctx, uint32_t qpn)
 		ctx->qp_table[tind].table[qpn & ctx->qp_table_mask] = NULL;
 }
 
+static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
+				struct hns_roce_qp **cur_qp, struct ibv_wc *wc)
+{
+	uint32_t qpn;
+	int is_send;
+	uint16_t wqe_ctr;
+	uint32_t local_qpn;
+	struct hns_roce_wq *wq = NULL;
+	struct hns_roce_v2_cqe *cqe = NULL;
+
+	/* According to CI, find the relative cqe */
+	cqe = next_cqe_sw(cq);
+	if (!cqe)
+		return V2_CQ_EMPTY;
+
+	/* Get the next cqe, CI will be added gradually */
+	++cq->cons_index;
+
+	udma_from_device_barrier();
+
+	qpn = roce_get_field(cqe->byte_16, CQE_BYTE_16_LCL_QPN_M,
+			     CQE_BYTE_16_LCL_QPN_S);
+
+	is_send = (roce_get_bit(cqe->byte_4, CQE_BYTE_4_S_R_S) ==
+		   HNS_ROCE_V2_CQE_IS_SQ);
+
+	local_qpn = roce_get_field(cqe->byte_16, CQE_BYTE_16_LCL_QPN_M,
+				   CQE_BYTE_16_LCL_QPN_S);
+
+	/* if qp is zero, it will not get the correct qpn */
+	if (!*cur_qp ||
+	   (local_qpn & HNS_ROCE_V2_CQE_QPN_MASK) != (*cur_qp)->ibv_qp.qp_num) {
+
+		*cur_qp = hns_roce_v2_find_qp(to_hr_ctx(cq->ibv_cq.context),
+					      qpn & 0xffffff);
+		if (!*cur_qp) {
+			fprintf(stderr, PFX "can't find qp!\n");
+			return V2_CQ_POLL_ERR;
+		}
+	}
+	wc->qp_num = qpn & 0xffffff;
+
+	if (is_send) {
+		wq = &(*cur_qp)->sq;
+		/*
+		 * if sq_signal_bits is 1, the tail pointer first update to
+		 * the wqe corresponding the current cqe
+		 */
+		if ((*cur_qp)->sq_signal_bits) {
+			wqe_ctr = (uint16_t)(roce_get_field(cqe->byte_4,
+						CQE_BYTE_4_WQE_IDX_M,
+						CQE_BYTE_4_WQE_IDX_S));
+			/*
+			 * wq->tail will plus a positive number every time,
+			 * when wq->tail exceeds 32b, it is 0 and acc
+			 */
+			wq->tail += (wqe_ctr - (uint16_t) wq->tail) &
+				    (wq->wqe_cnt - 1);
+		}
+		/* write the wr_id of wq into the wc */
+		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		++wq->tail;
+	} else {
+		wq = &(*cur_qp)->rq;
+		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		++wq->tail;
+	}
+
+	/*
+	 * HW maintains wc status, set the err type and directly return, after
+	 * generated the incorrect CQE
+	 */
+	if (roce_get_field(cqe->byte_4, CQE_BYTE_4_STATUS_M,
+			   CQE_BYTE_4_STATUS_S) != HNS_ROCE_V2_CQE_SUCCESS) {
+		hns_roce_v2_handle_error_cqe(cqe, wc);
+		return V2_CQ_OK;
+	}
+
+	wc->status = IBV_WC_SUCCESS;
+
+	/*
+	 * According to the opcode type of cqe, mark the opcode and other
+	 * information of wc
+	 */
+	if (is_send) {
+		/* Get opcode and flag before update the tail point for send */
+		switch (roce_get_field(cqe->byte_4, CQE_BYTE_4_OPCODE_M,
+			CQE_BYTE_4_OPCODE_S) & HNS_ROCE_V2_CQE_OPCODE_MASK) {
+		case HNS_ROCE_SQ_OP_SEND:
+			wc->opcode = IBV_WC_SEND;
+			wc->wc_flags = 0;
+			break;
+
+		case HNS_ROCE_SQ_OP_SEND_WITH_IMM:
+			wc->opcode = IBV_WC_SEND;
+			wc->wc_flags = IBV_WC_WITH_IMM;
+			break;
+
+		case HNS_ROCE_SQ_OP_SEND_WITH_INV:
+			wc->opcode = IBV_WC_SEND;
+			break;
+
+		case HNS_ROCE_SQ_OP_RDMA_READ:
+			wc->opcode = IBV_WC_RDMA_READ;
+			wc->byte_len = cqe->byte_cnt;
+			wc->wc_flags = 0;
+			break;
+
+		case HNS_ROCE_SQ_OP_RDMA_WRITE:
+			wc->opcode = IBV_WC_RDMA_WRITE;
+			wc->wc_flags = 0;
+			break;
+
+		case HNS_ROCE_SQ_OP_RDMA_WRITE_WITH_IMM:
+			wc->opcode = IBV_WC_RDMA_WRITE;
+			wc->wc_flags = IBV_WC_WITH_IMM;
+			break;
+		case HNS_ROCE_SQ_OP_LOCAL_INV:
+			wc->opcode = IBV_WC_LOCAL_INV;
+			wc->wc_flags = IBV_WC_WITH_INV;
+			break;
+		case HNS_ROCE_SQ_OP_ATOMIC_COMP_AND_SWAP:
+			wc->opcode = IBV_WC_COMP_SWAP;
+			wc->byte_len  = 8;
+			wc->wc_flags = 0;
+			break;
+		case HNS_ROCE_SQ_OP_ATOMIC_FETCH_AND_ADD:
+			wc->opcode = IBV_WC_FETCH_ADD;
+			wc->byte_len  = 8;
+			wc->wc_flags = 0;
+			break;
+		case HNS_ROCE_SQ_OP_BIND_MW:
+			wc->opcode = IBV_WC_BIND_MW;
+			wc->wc_flags = 0;
+			break;
+		default:
+			wc->status = IBV_WC_GENERAL_ERR;
+			wc->wc_flags = 0;
+			break;
+		}
+	} else {
+		/* Get opcode and flag in rq&srq */
+		wc->byte_len = cqe->byte_cnt;
+		switch (roce_get_field(cqe->byte_4, CQE_BYTE_4_OPCODE_M,
+			CQE_BYTE_4_OPCODE_S) & HNS_ROCE_V2_CQE_OPCODE_MASK) {
+		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
+			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
+			wc->wc_flags = IBV_WC_WITH_IMM;
+			wc->imm_data = cqe->rkey_immtdata;
+			break;
+
+		case HNS_ROCE_RECV_OP_SEND:
+			wc->opcode = IBV_WC_RECV;
+			wc->wc_flags = 0;
+			break;
+
+		case HNS_ROCE_RECV_OP_SEND_WITH_IMM:
+			wc->opcode = IBV_WC_RECV;
+			wc->wc_flags = IBV_WC_WITH_IMM;
+			wc->imm_data = cqe->rkey_immtdata;
+			break;
+
+		case HNS_ROCE_RECV_OP_SEND_WITH_INV:
+			wc->opcode = IBV_WC_RECV;
+			wc->wc_flags = IBV_WC_WITH_INV;
+			wc->imm_data = cqe->rkey_immtdata;
+			break;
+		default:
+			wc->status = IBV_WC_GENERAL_ERR;
+			break;
+		}
+	}
+
+	return V2_CQ_OK;
+}
+
+static int hns_roce_u_v2_poll_cq(struct ibv_cq *ibvcq, int ne,
+				 struct ibv_wc *wc)
+{
+	int npolled;
+	int err = V2_CQ_OK;
+	struct hns_roce_qp *qp = NULL;
+	struct hns_roce_cq *cq = to_hr_cq(ibvcq);
+	struct hns_roce_context *ctx = to_hr_ctx(ibvcq->context);
+
+	pthread_spin_lock(&cq->lock);
+
+	for (npolled = 0; npolled < ne; ++npolled) {
+		err = hns_roce_v2_poll_one(cq, &qp, wc + npolled);
+		if (err != V2_CQ_OK)
+			break;
+	}
+
+	if (npolled) {
+		mmio_ordered_writes_hack();
+
+		hns_roce_v2_update_cq_cons_index(ctx, cq);
+	}
+
+	pthread_spin_unlock(&cq->lock);
+
+	return err == V2_CQ_POLL_ERR ? err : npolled;
+}
+
+static int hns_roce_u_v2_arm_cq(struct ibv_cq *ibvcq, int solicited)
+{
+	uint32_t ci;
+	uint32_t solicited_flag;
+	struct hns_roce_v2_cq_db cq_db;
+	struct hns_roce_cq *cq = to_hr_cq(ibvcq);
+
+	ci  = cq->cons_index & ((cq->cq_depth << 1) - 1);
+	solicited_flag = solicited ? HNS_ROCE_V2_CQ_DB_REQ_SOL :
+				     HNS_ROCE_V2_CQ_DB_REQ_NEXT;
+
+	cq_db.byte_4 = 0;
+	cq_db.parameter = 0;
+
+	roce_set_field(cq_db.byte_4, DB_BYTE_4_TAG_M, DB_BYTE_4_TAG_S, cq->cqn);
+	roce_set_field(cq_db.byte_4, DB_BYTE_4_CMD_M, DB_BYTE_4_CMD_S, 0x4);
+
+	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CQ_CONSUMER_IDX_M,
+		       CQ_DB_PARAMETER_CQ_CONSUMER_IDX_S, ci);
+
+	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CMD_SN_M,
+		       CQ_DB_PARAMETER_CMD_SN_S, 1);
+	roce_set_bit(cq_db.parameter, CQ_DB_PARAMETER_NOTIFY_S, solicited_flag);
+
+	hns_roce_write64((uint32_t *)&cq_db, to_hr_ctx(ibvcq->context),
+			  ROCEE_VF_DB_CFG0_OFFSET);
+	return 0;
+}
+
 static void __hns_roce_v2_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
 				   struct hns_roce_srq *srq)
 {
@@ -226,6 +528,8 @@ static int hns_roce_u_v2_destroy_qp(struct ibv_qp *ibqp)
 
 struct hns_roce_u_hw hns_roce_u_hw_v2 = {
 	.hw_version = HNS_ROCE_HW_VER2,
+	.poll_cq = hns_roce_u_v2_poll_cq,
+	.arm_cq = hns_roce_u_v2_arm_cq,
 	.modify_qp = hns_roce_u_v2_modify_qp,
 	.destroy_qp = hns_roce_u_v2_destroy_qp,
 };
diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
index d7fcf94..238bebf 100644
--- a/providers/hns/hns_roce_u_hw_v2.h
+++ b/providers/hns/hns_roce_u_hw_v2.h
@@ -33,9 +33,84 @@
 #ifndef _HNS_ROCE_U_HW_V2_H
 #define _HNS_ROCE_U_HW_V2_H
 
+#define HNS_ROCE_V2_CQE_IS_SQ			0
+
+#define HNS_ROCE_V2_CQ_DB_REQ_SOL		1
+#define HNS_ROCE_V2_CQ_DB_REQ_NEXT		0
+
 /* V2 REG DEFINITION */
 #define ROCEE_VF_DB_CFG0_OFFSET			0x0230
 
+enum {
+	HNS_ROCE_WQE_OP_SEND = 0x0,
+	HNS_ROCE_WQE_OP_SEND_WITH_INV = 0x1,
+	HNS_ROCE_WQE_OP_SEND_WITH_IMM = 0x2,
+	HNS_ROCE_WQE_OP_RDMA_WRITE = 0x3,
+	HNS_ROCE_WQE_OP_RDMA_WRITE_WITH_IMM = 0x4,
+	HNS_ROCE_WQE_OP_RDMA_READ = 0x5,
+	HNS_ROCE_WQE_OP_ATOMIC_COM_AND_SWAP = 0x6,
+	HNS_ROCE_WQE_OP_ATOMIC_FETCH_AND_ADD = 0x7,
+	HNS_ROCE_WQE_OP_ATOMIC_MASK_COMP_AND_SWAP = 0x8,
+	HNS_ROCE_WQE_OP_ATOMIC_MASK_FETCH_AND_ADD = 0x9,
+	HNS_ROCE_WQE_OP_FAST_REG_PMR = 0xa,
+	HNS_ROCE_WQE_OP_LOCAL_INV = 0xb,
+	HNS_ROCE_WQE_OP_BIND_MW_TYPE = 0xc,
+	HNS_ROCE_WQE_OP_MASK = 0x1f
+};
+
+enum {
+	/* rq operations */
+	HNS_ROCE_RECV_OP_RDMA_WRITE_IMM = 0x0,
+	HNS_ROCE_RECV_OP_SEND = 0x1,
+	HNS_ROCE_RECV_OP_SEND_WITH_IMM = 0x2,
+	HNS_ROCE_RECV_OP_SEND_WITH_INV = 0x3,
+};
+
+enum {
+	HNS_ROCE_SQ_OP_SEND = 0x0,
+	HNS_ROCE_SQ_OP_SEND_WITH_INV = 0x1,
+	HNS_ROCE_SQ_OP_SEND_WITH_IMM = 0x2,
+	HNS_ROCE_SQ_OP_RDMA_WRITE = 0x3,
+	HNS_ROCE_SQ_OP_RDMA_WRITE_WITH_IMM = 0x4,
+	HNS_ROCE_SQ_OP_RDMA_READ = 0x5,
+	HNS_ROCE_SQ_OP_ATOMIC_COMP_AND_SWAP = 0x6,
+	HNS_ROCE_SQ_OP_ATOMIC_FETCH_AND_ADD = 0x7,
+	HNS_ROCE_SQ_OP_ATOMIC_MASK_COMP_AND_SWAP = 0x8,
+	HNS_ROCE_SQ_OP_ATOMIC_MASK_FETCH_AND_ADD = 0x9,
+	HNS_ROCE_SQ_OP_FAST_REG_PMR = 0xa,
+	HNS_ROCE_SQ_OP_LOCAL_INV = 0xb,
+	HNS_ROCE_SQ_OP_BIND_MW = 0xc,
+};
+
+enum {
+	V2_CQ_OK			=  0,
+	V2_CQ_EMPTY			= -1,
+	V2_CQ_POLL_ERR			= -2,
+};
+
+enum {
+	HNS_ROCE_V2_CQE_QPN_MASK	= 0x3ffff,
+	HNS_ROCE_V2_CQE_STATUS_MASK	= 0xff,
+	HNS_ROCE_V2_CQE_OPCODE_MASK	= 0x1f,
+};
+
+enum {
+	HNS_ROCE_V2_CQE_SUCCESS				= 0x00,
+	HNS_ROCE_V2_CQE_LOCAL_LENGTH_ERR		= 0x01,
+	HNS_ROCE_V2_CQE_LOCAL_QP_OP_ERR			= 0x02,
+	HNS_ROCE_V2_CQE_LOCAL_PROT_ERR			= 0x04,
+	HNS_ROCE_V2_CQE_WR_FLUSH_ERR			= 0x05,
+	HNS_ROCE_V2_CQE_MEM_MANAGERENT_OP_ERR		= 0x06,
+	HNS_ROCE_V2_CQE_BAD_RESP_ERR			= 0x10,
+	HNS_ROCE_V2_CQE_LOCAL_ACCESS_ERR		= 0x11,
+	HNS_ROCE_V2_CQE_REMOTE_INVAL_REQ_ERR		= 0x12,
+	HNS_ROCE_V2_CQE_REMOTE_ACCESS_ERR		= 0x13,
+	HNS_ROCE_V2_CQE_REMOTE_OP_ERR			= 0x14,
+	HNS_ROCE_V2_CQE_TRANSPORT_RETRY_EXC_ERR		= 0x15,
+	HNS_ROCE_V2_CQE_RNR_RETRY_EXC_ERR		= 0x16,
+	HNS_ROCE_V2_CQE_REMOTE_ABORTED_ERR		= 0x22,
+};
+
 struct hns_roce_db {
 	unsigned int	byte_4;
 	unsigned int	parameter;
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 8f6c666..64a4ac3 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -197,11 +197,15 @@ static void hns_roce_set_sq_sizes(struct hns_roce_qp *qp,
 
 static int hns_roce_verify_cq(int *cqe, struct hns_roce_context *context)
 {
-	if (*cqe < HNS_ROCE_MIN_CQE_NUM) {
-		fprintf(stderr, "cqe = %d, less than minimum CQE number.\n",
-			*cqe);
-		*cqe = HNS_ROCE_MIN_CQE_NUM;
-	}
+	struct hns_roce_device *hr_dev = to_hr_dev(context->ibv_ctx.device);
+
+	if (hr_dev->hw_version == HNS_ROCE_HW_VER1)
+		if (*cqe < HNS_ROCE_MIN_CQE_NUM) {
+			fprintf(stderr,
+				"cqe = %d, less than minimum CQE number.\n",
+				*cqe);
+			*cqe = HNS_ROCE_MIN_CQE_NUM;
+		}
 
 	if (*cqe > context->max_cqe)
 		return -1;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
