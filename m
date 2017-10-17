From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 4/5] libhns: Reimplement verbs of post_send and post_recv for hip08 RoCE
Date: Tue, 17 Oct 2017 21:12:25 +0800
Message-ID: <1508245946-145697-5-git-send-email-oulijun@huawei.com>
References: <1508245946-145697-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508245946-145697-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The verbs of post_send and post recv need to fill sqwqe and rqwqe and
issue the doorbell cmd. The sqwqe&rqwqe&doorbell structures are
different between hip06 and hip08 etc. Hence, It needs to rewrite
the verbs of post_send and post_recv.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u.h       |   8 +
 providers/hns/hns_roce_u_hw_v2.c | 384 ++++++++++++++++++++++++++++++++++++++-
 providers/hns/hns_roce_u_hw_v2.h |  50 +++++
 providers/hns/hns_roce_u_verbs.c |  76 ++++++--
 4 files changed, 501 insertions(+), 17 deletions(-)

diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 568bfc3..ea645be 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -159,6 +159,12 @@ struct hns_roce_wq {
 	int				offset;
 };
 
+struct hns_roce_sge_ex {
+	int				offset;
+	unsigned int			sge_cnt;
+	int				sge_shift;
+};
+
 struct hns_roce_qp {
 	struct ibv_qp			ibv_qp;
 	struct hns_roce_buf		buf;
@@ -167,6 +173,8 @@ struct hns_roce_qp {
 	unsigned int			sq_signal_bits;
 	struct hns_roce_wq		sq;
 	struct hns_roce_wq		rq;
+	struct hns_roce_sge_ex		sge;
+	unsigned int			next_sge;
 	int				port_num;
 	int				sl;
 };
diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index 33f7973..b124813 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -37,6 +37,22 @@
 #include "hns_roce_u_db.h"
 #include "hns_roce_u_hw_v2.h"
 
+static inline void set_raddr_seg_v2(struct hns_roce_v2_wqe_raddr_seg *rseg,
+				    uint64_t remote_addr, uint32_t rkey)
+{
+	rseg->raddr    = remote_addr;
+	rseg->rkey     = rkey;
+	rseg->len      = 0;
+}
+
+static void set_data_seg_v2(struct hns_roce_v2_wqe_data_seg *dseg,
+			 struct ibv_sge *sg)
+{
+	dseg->lkey = sg->lkey;
+	dseg->addr = sg->addr;
+	dseg->len = sg->length;
+}
+
 static void hns_roce_v2_handle_error_cqe(struct hns_roce_v2_cqe *cqe,
 					 struct ibv_wc *wc)
 {
@@ -102,11 +118,92 @@ static void *get_sw_cqe_v2(struct hns_roce_cq *cq, int n)
 		!!(n & (cq->ibv_cq.cqe + 1))) ? cqe : NULL;
 }
 
-static struct hns_roce_v2_cqe *next_cqe_sw(struct hns_roce_cq *cq)
+static struct hns_roce_v2_cqe *next_cqe_sw_v2(struct hns_roce_cq *cq)
 {
 	return get_sw_cqe_v2(cq, cq->cons_index);
 }
 
+static void *get_recv_wqe_v2(struct hns_roce_qp *qp, int n)
+{
+	if ((n < 0) || (n > qp->rq.wqe_cnt)) {
+		printf("rq wqe index:%d,rq wqe cnt:%d\r\n", n, qp->rq.wqe_cnt);
+		return NULL;
+	}
+
+	return qp->buf.buf + qp->rq.offset + (n << qp->rq.wqe_shift);
+}
+
+static void *get_send_wqe(struct hns_roce_qp *qp, int n)
+{
+	return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
+				  (n << qp->sq.wqe_shift));
+}
+
+static void *get_send_sge_ex(struct hns_roce_qp *qp, int n)
+{
+	return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
+				  (n << qp->sge.sge_shift));
+}
+
+static int hns_roce_v2_wq_overflow(struct hns_roce_wq *wq, int nreq,
+				   struct hns_roce_cq *cq)
+{
+	unsigned int cur;
+
+	cur = wq->head - wq->tail;
+	if (cur + nreq < wq->max_post)
+		return 0;
+
+	/* While the num of wqe exceeds cap of the device, cq will be locked */
+	pthread_spin_lock(&cq->lock);
+	cur = wq->head - wq->tail;
+	pthread_spin_unlock(&cq->lock);
+
+	return cur + nreq >= wq->max_post;
+}
+
+static void hns_roce_update_rq_db(struct hns_roce_context *ctx,
+				  unsigned int qpn, unsigned int rq_head)
+{
+	struct hns_roce_db rq_db;
+
+	rq_db.byte_4 = 0;
+	rq_db.parameter = 0;
+
+	roce_set_field(rq_db.byte_4, DB_BYTE_4_TAG_M, DB_BYTE_4_TAG_S, qpn);
+	roce_set_field(rq_db.byte_4, DB_BYTE_4_CMD_M, DB_BYTE_4_CMD_S, 0x1);
+	roce_set_field(rq_db.parameter, DB_PARAM_RQ_PRODUCER_IDX_M,
+		       DB_PARAM_RQ_PRODUCER_IDX_S, rq_head);
+
+	udma_to_device_barrier();
+
+	hns_roce_write64((uint32_t *)&rq_db, ctx, ROCEE_VF_DB_CFG0_OFFSET);
+}
+
+static void hns_roce_update_sq_db(struct hns_roce_context *ctx,
+				  unsigned int qpn, unsigned int sl,
+				  unsigned int sq_head)
+{
+	struct hns_roce_db sq_db;
+
+	sq_db.byte_4 = 0;
+
+	/* In fact, the sq_head bits should be 15bit */
+	sq_db.parameter = 0;
+
+	/* cmd: 0 sq db; 1 rq db; 2; 2 srq db; 3 cq db ptr; 4 cq db ntr */
+	roce_set_field(sq_db.byte_4, DB_BYTE_4_CMD_M, DB_BYTE_4_CMD_S, 0);
+	roce_set_field(sq_db.byte_4, DB_BYTE_4_TAG_M, DB_BYTE_4_TAG_S, qpn);
+
+	roce_set_field(sq_db.parameter, DB_PARAM_SQ_PRODUCER_IDX_M,
+		       DB_PARAM_SQ_PRODUCER_IDX_S, sq_head);
+	roce_set_field(sq_db.parameter, DB_PARAM_SL_M, DB_PARAM_SL_S, sl);
+
+	udma_to_device_barrier();
+
+	hns_roce_write64((uint32_t *)&sq_db, ctx, ROCEE_VF_DB_CFG0_OFFSET);
+}
+
 static void hns_roce_v2_update_cq_cons_index(struct hns_roce_context *ctx,
 					     struct hns_roce_cq *cq)
 {
@@ -162,7 +259,7 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
 	struct hns_roce_v2_cqe *cqe = NULL;
 
 	/* According to CI, find the relative cqe */
-	cqe = next_cqe_sw(cq);
+	cqe = next_cqe_sw_v2(cq);
 	if (!cqe)
 		return V2_CQ_EMPTY;
 
@@ -384,6 +481,287 @@ static int hns_roce_u_v2_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	return 0;
 }
 
+static int hns_roce_u_v2_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
+				   struct ibv_send_wr **bad_wr)
+{
+	unsigned int ind_sge;
+	unsigned int ind;
+	int nreq;
+	int i;
+	void *wqe;
+	int ret = 0;
+	struct hns_roce_qp *qp = to_hr_qp(ibvqp);
+	struct hns_roce_context *ctx = to_hr_ctx(ibvqp->context);
+	struct hns_roce_rc_sq_wqe *rc_sq_wqe;
+	struct hns_roce_v2_wqe_data_seg *dseg;
+
+	pthread_spin_lock(&qp->sq.lock);
+
+	/* check that state is OK to post send */
+	ind = qp->sq.head;
+	ind_sge = qp->next_sge;
+
+	if (ibvqp->state != IBV_QPS_RTS && ibvqp->state != IBV_QPS_SQD) {
+		pthread_spin_unlock(&qp->sq.lock);
+		*bad_wr = wr;
+		return EINVAL;
+	}
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (hns_roce_v2_wq_overflow(&qp->sq, nreq,
+					    to_hr_cq(qp->ibv_qp.send_cq))) {
+			ret = -1;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (wr->num_sge > qp->sq.max_gs) {
+			ret = -1;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
+		rc_sq_wqe = wqe;
+
+		memset(rc_sq_wqe, 0, sizeof(struct hns_roce_rc_sq_wqe));
+
+		qp->sq.wrid[ind & (qp->sq.wqe_cnt - 1)] = wr->wr_id;
+		for (i = 0; i < wr->num_sge; i++)
+			rc_sq_wqe->msg_len += wr->sg_list[i].length;
+
+		if (wr->opcode == IBV_WR_SEND_WITH_IMM ||
+		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
+			rc_sq_wqe->inv_key_immtdata = wr->imm_data;
+
+		roce_set_field(rc_sq_wqe->byte_16, RC_SQ_WQE_BYTE_16_SGE_NUM_M,
+			       RC_SQ_WQE_BYTE_16_SGE_NUM_S, wr->num_sge);
+
+		roce_set_field(rc_sq_wqe->byte_20,
+			       RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_S,
+			       RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_S,
+			       0);
+
+		roce_set_bit(rc_sq_wqe->byte_4, RC_SQ_WQE_BYTE_4_CQE_S,
+			     (wr->send_flags & IBV_SEND_SIGNALED) ? 1 : 0);
+
+		/* Set fence attr */
+		roce_set_bit(rc_sq_wqe->byte_4, RC_SQ_WQE_BYTE_4_FENCE_S,
+			     (wr->send_flags & IBV_SEND_FENCE) ? 1 : 0);
+
+		/* Set solicited attr */
+		roce_set_bit(rc_sq_wqe->byte_4, RC_SQ_WQE_BYTE_4_SE_S,
+			     (wr->send_flags & IBV_SEND_SOLICITED) ? 1 : 0);
+
+		wqe += sizeof(struct hns_roce_rc_sq_wqe);
+		/* set remote addr segment */
+		switch (ibvqp->qp_type) {
+		case IBV_QPT_RC:
+			switch (wr->opcode) {
+			case IBV_WR_RDMA_READ:
+				roce_set_field(rc_sq_wqe->byte_4,
+					       RC_SQ_WQE_BYTE_4_OPCODE_M,
+					       RC_SQ_WQE_BYTE_4_OPCODE_S,
+					       HNS_ROCE_WQE_OP_RDMA_READ);
+				rc_sq_wqe->va = wr->wr.rdma.remote_addr;
+				rc_sq_wqe->rkey = wr->wr.rdma.rkey;
+				break;
+
+			case IBV_WR_RDMA_WRITE:
+				roce_set_field(rc_sq_wqe->byte_4,
+					       RC_SQ_WQE_BYTE_4_OPCODE_M,
+					       RC_SQ_WQE_BYTE_4_OPCODE_S,
+					       HNS_ROCE_WQE_OP_RDMA_WRITE);
+				rc_sq_wqe->va = wr->wr.rdma.remote_addr;
+				rc_sq_wqe->rkey = wr->wr.rdma.rkey;
+				break;
+
+			case IBV_WR_RDMA_WRITE_WITH_IMM:
+				roce_set_field(rc_sq_wqe->byte_4,
+				       RC_SQ_WQE_BYTE_4_OPCODE_M,
+				       RC_SQ_WQE_BYTE_4_OPCODE_S,
+				       HNS_ROCE_WQE_OP_RDMA_WRITE_WITH_IMM);
+				rc_sq_wqe->va = wr->wr.rdma.remote_addr;
+				rc_sq_wqe->rkey = wr->wr.rdma.rkey;
+				break;
+
+			case IBV_WR_SEND:
+				roce_set_field(rc_sq_wqe->byte_4,
+					       RC_SQ_WQE_BYTE_4_OPCODE_M,
+					       RC_SQ_WQE_BYTE_4_OPCODE_S,
+					       HNS_ROCE_WQE_OP_SEND);
+				break;
+			case IBV_WR_SEND_WITH_INV:
+				roce_set_field(rc_sq_wqe->byte_4,
+					     RC_SQ_WQE_BYTE_4_OPCODE_M,
+					     RC_SQ_WQE_BYTE_4_OPCODE_S,
+					     HNS_ROCE_WQE_OP_SEND_WITH_INV);
+				rc_sq_wqe->inv_key_immtdata = wr->imm_data;
+				break;
+			case IBV_WR_SEND_WITH_IMM:
+				roce_set_field(rc_sq_wqe->byte_4,
+					RC_SQ_WQE_BYTE_4_OPCODE_M,
+					RC_SQ_WQE_BYTE_4_OPCODE_S,
+					HNS_ROCE_WQE_OP_SEND_WITH_IMM);
+				break;
+
+			case IBV_WR_ATOMIC_CMP_AND_SWP:
+				roce_set_field(rc_sq_wqe->byte_4,
+					RC_SQ_WQE_BYTE_4_OPCODE_M,
+					RC_SQ_WQE_BYTE_4_OPCODE_S,
+					HNS_ROCE_WQE_OP_ATOMIC_COM_AND_SWAP);
+				break;
+
+			case IBV_WR_ATOMIC_FETCH_AND_ADD:
+				roce_set_field(rc_sq_wqe->byte_4,
+					RC_SQ_WQE_BYTE_4_OPCODE_M,
+					RC_SQ_WQE_BYTE_4_OPCODE_S,
+					HNS_ROCE_WQE_OP_ATOMIC_FETCH_AND_ADD);
+				break;
+			default:
+				roce_set_field(rc_sq_wqe->byte_4,
+					       RC_SQ_WQE_BYTE_4_OPCODE_M,
+					       RC_SQ_WQE_BYTE_4_OPCODE_S,
+					       HNS_ROCE_WQE_OP_MASK);
+				printf("Not supported transport opcode %d\n",
+				       wr->opcode);
+				break;
+			}
+
+			break;
+		case IBV_QPT_UC:
+		case IBV_QPT_UD:
+		default:
+			break;
+		}
+
+		dseg = wqe;
+
+		/* Inline */
+		if (wr->send_flags & IBV_SEND_INLINE && wr->num_sge) {
+			if (rc_sq_wqe->msg_len > qp->max_inline_data) {
+				ret = -1;
+				*bad_wr = wr;
+				printf("inline data len(1-32)=%d, send_flags = 0x%x, check failed!\r\n",
+					wr->send_flags, rc_sq_wqe->msg_len);
+				return ret;
+			}
+
+			for (i = 0; i < wr->num_sge; i++) {
+				memcpy(wqe,
+				     ((void *) (uintptr_t) wr->sg_list[i].addr),
+				     wr->sg_list[i].length);
+				wqe = wqe + wr->sg_list[i].length;
+			}
+
+			roce_set_bit(rc_sq_wqe->byte_4,
+				     RC_SQ_WQE_BYTE_4_INLINE_S, 1);
+		} else {
+			/* set sge */
+			if (wr->num_sge <= 2) {
+				for (i = 0; i < wr->num_sge; i++)
+					set_data_seg_v2(dseg + i,
+							wr->sg_list + i);
+			} else {
+				roce_set_field(rc_sq_wqe->byte_20,
+					RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_M,
+					RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_S,
+					ind_sge & (qp->sge.sge_cnt - 1));
+
+				for (i = 0; i < 2; i++)
+					set_data_seg_v2(dseg + i,
+							wr->sg_list + i);
+
+				dseg = get_send_sge_ex(qp, ind_sge &
+						    (qp->sge.sge_cnt - 1));
+
+				for (i = 0; i < wr->num_sge - 2; i++) {
+					set_data_seg_v2(dseg + i,
+							wr->sg_list + 2 + i);
+					ind_sge++;
+				}
+			}
+		}
+
+		ind++;
+	}
+
+out:
+	if (likely(nreq)) {
+		qp->sq.head += nreq;
+
+		hns_roce_update_sq_db(ctx, qp->ibv_qp.qp_num, qp->sl,
+				     qp->sq.head & ((qp->sq.wqe_cnt << 1) - 1));
+
+		qp->next_sge = ind_sge;
+	}
+
+	pthread_spin_unlock(&qp->sq.lock);
+
+	return ret;
+}
+
+static int hns_roce_u_v2_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
+				   struct ibv_recv_wr **bad_wr)
+{
+	int ret = 0;
+	int nreq;
+	int ind;
+	struct hns_roce_qp *qp = to_hr_qp(ibvqp);
+	struct hns_roce_context *ctx = to_hr_ctx(ibvqp->context);
+	struct hns_roce_v2_wqe_data_seg *dseg;
+	void *wqe;
+	int i;
+
+	pthread_spin_lock(&qp->rq.lock);
+
+	/* check that state is OK to post receive */
+	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
+
+	if (ibvqp->state == IBV_QPS_RESET || ibvqp->state == IBV_QPS_ERR) {
+		pthread_spin_unlock(&qp->rq.lock);
+		*bad_wr = wr;
+		return -1;
+	}
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (hns_roce_v2_wq_overflow(&qp->rq, nreq,
+					    to_hr_cq(qp->ibv_qp.recv_cq))) {
+			ret = -1;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (wr->num_sge > qp->rq.max_gs) {
+			ret = -1;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		wqe = get_recv_wqe_v2(qp, ind);
+		dseg = (struct hns_roce_v2_wqe_data_seg *)wqe;
+
+		for (i = 0; i < wr->num_sge; i++)
+			set_data_seg_v2(dseg + i, wr->sg_list + i);
+
+		qp->rq.wrid[ind] = wr->wr_id;
+
+		ind = (ind + 1) & (qp->rq.wqe_cnt - 1);
+	}
+
+out:
+	if (nreq) {
+		qp->rq.head += nreq;
+
+		hns_roce_update_rq_db(ctx, qp->ibv_qp.qp_num,
+				     qp->rq.head & ((qp->rq.wqe_cnt << 1) - 1));
+	}
+
+	pthread_spin_unlock(&qp->rq.lock);
+
+	return ret;
+}
+
 static void __hns_roce_v2_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
 				   struct hns_roce_srq *srq)
 {
@@ -531,6 +909,8 @@ struct hns_roce_u_hw hns_roce_u_hw_v2 = {
 	.hw_version = HNS_ROCE_HW_VER2,
 	.poll_cq = hns_roce_u_v2_poll_cq,
 	.arm_cq = hns_roce_u_v2_arm_cq,
+	.post_send = hns_roce_u_v2_post_send,
+	.post_recv = hns_roce_u_v2_post_recv,
 	.modify_qp = hns_roce_u_v2_modify_qp,
 	.destroy_qp = hns_roce_u_v2_destroy_qp,
 };
diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
index 238bebf..28aab60 100644
--- a/providers/hns/hns_roce_u_hw_v2.h
+++ b/providers/hns/hns_roce_u_hw_v2.h
@@ -208,4 +208,54 @@ struct hns_roce_v2_cqe {
 
 #define CQE_BYTE_32_LPK_S 31
 
+struct hns_roce_rc_sq_wqe {
+	unsigned int	byte_4;
+	unsigned int	msg_len;
+	unsigned int	inv_key_immtdata;
+	unsigned int	byte_16;
+	unsigned int	byte_20;
+	unsigned int	rkey;
+	uint64_t	va;
+};
+
+#define RC_SQ_WQE_BYTE_4_OPCODE_S 0
+#define RC_SQ_WQE_BYTE_4_OPCODE_M \
+	(((1UL << 5) - 1) << RC_SQ_WQE_BYTE_4_OPCODE_S)
+
+#define RC_SQ_WQE_BYTE_4_OWNER_S 7
+
+#define RC_SQ_WQE_BYTE_4_CQE_S 8
+
+#define RC_SQ_WQE_BYTE_4_FENCE_S 9
+
+#define RC_SQ_WQE_BYTE_4_SO_S 10
+
+#define RC_SQ_WQE_BYTE_4_SE_S 11
+
+#define RC_SQ_WQE_BYTE_4_INLINE_S 12
+
+#define RC_SQ_WQE_BYTE_16_XRC_SRQN_S 0
+#define RC_SQ_WQE_BYTE_16_XRC_SRQN_M \
+	(((1UL << 24) - 1) << RC_SQ_WQE_BYTE_16_XRC_SRQN_S)
+
+#define RC_SQ_WQE_BYTE_16_SGE_NUM_S 24
+#define RC_SQ_WQE_BYTE_16_SGE_NUM_M \
+	(((1UL << 8) - 1) << RC_SQ_WQE_BYTE_16_SGE_NUM_S)
+
+#define RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_S 0
+#define RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_M \
+	(((1UL << 24) - 1) << RC_SQ_WQE_BYTE_20_MSG_START_SGE_IDX_S)
+
+struct hns_roce_v2_wqe_data_seg {
+	__be32    len;
+	__be32    lkey;
+	__be64    addr;
+};
+
+struct hns_roce_v2_wqe_raddr_seg {
+	__be32		rkey;
+	__be32		len;
+	__be64		raddr;
+};
+
 #endif /* _HNS_ROCE_U_HW_V2_H */
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 64a4ac3..7dc643c 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -50,6 +50,7 @@ void hns_roce_init_qp_indices(struct hns_roce_qp *qp)
 	qp->sq.tail = 0;
 	qp->rq.head = 0;
 	qp->rq.tail = 0;
+	qp->next_sge = 0;
 }
 
 int hns_roce_u_query_device(struct ibv_context *context,
@@ -187,7 +188,6 @@ static void hns_roce_set_sq_sizes(struct hns_roce_qp *qp,
 {
 	struct hns_roce_context *ctx = to_hr_ctx(qp->ibv_qp.context);
 
-	qp->sq.max_gs = 2;
 	cap->max_send_sge = min(ctx->max_sge, qp->sq.max_gs);
 	qp->sq.max_post = min(ctx->max_qp_wr, qp->sq.wqe_cnt);
 	cap->max_send_wr = qp->sq.max_post;
@@ -372,21 +372,52 @@ static int hns_roce_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 		}
 	}
 
-	for (qp->rq.wqe_shift = 4;
-	     1 << qp->rq.wqe_shift < sizeof(struct hns_roce_rc_send_wqe);
-	     qp->rq.wqe_shift++)
-		;
-
-	qp->buf_size = align((qp->sq.wqe_cnt << qp->sq.wqe_shift), 0x1000) +
-		      (qp->rq.wqe_cnt << qp->rq.wqe_shift);
-
-	if (qp->rq.wqe_shift > qp->sq.wqe_shift) {
-		qp->rq.offset = 0;
-		qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+	if (to_hr_dev(pd->context->device)->hw_version == HNS_ROCE_HW_VER1) {
+		for (qp->rq.wqe_shift = 4; 1 << qp->rq.wqe_shift <
+			sizeof(struct hns_roce_rc_send_wqe); qp->rq.wqe_shift++)
+			;
+
+		qp->buf_size = align((qp->sq.wqe_cnt << qp->sq.wqe_shift),
+				     0x1000) +
+			       (qp->rq.wqe_cnt << qp->rq.wqe_shift);
+
+		if (qp->rq.wqe_shift > qp->sq.wqe_shift) {
+			qp->rq.offset = 0;
+			qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+		} else {
+			qp->rq.offset = align((qp->sq.wqe_cnt <<
+					      qp->sq.wqe_shift), 0x1000);
+			qp->sq.offset = 0;
+		}
 	} else {
-		qp->rq.offset = align((qp->sq.wqe_cnt << qp->sq.wqe_shift),
-				       0x1000);
-		qp->sq.offset = 0;
+		for (qp->rq.wqe_shift = 4; 1 << qp->rq.wqe_shift < 16 *
+				cap->max_recv_sge; qp->rq.wqe_shift++)
+			;
+
+		if (qp->sq.max_gs > 2)
+			qp->sge.sge_shift = 4;
+		else
+			qp->sge.sge_shift = 0;
+
+		qp->buf_size = align((qp->sq.wqe_cnt << qp->sq.wqe_shift),
+				     0x1000) +
+			       align((qp->sge.sge_cnt << qp->sge.sge_shift),
+				     0x1000) +
+			       (qp->rq.wqe_cnt << qp->rq.wqe_shift);
+
+		if (qp->sge.sge_cnt) {
+			qp->sq.offset = 0;
+			qp->sge.offset = align((qp->sq.wqe_cnt <<
+						qp->sq.wqe_shift), 0x1000);
+			qp->rq.offset = qp->sge.offset +
+					align((qp->sge.sge_cnt <<
+					qp->sge.sge_shift), 0x1000);
+		} else {
+			qp->sq.offset = 0;
+			qp->sge.offset = 0;
+			qp->rq.offset = align((qp->sq.wqe_cnt <<
+						qp->sq.wqe_shift), 0x1000);
+		}
 	}
 
 	if (hns_roce_alloc_buf(&qp->buf, align(qp->buf_size, 0x1000),
@@ -427,6 +458,7 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 	struct hns_roce_create_qp cmd;
 	struct ibv_create_qp_resp resp;
 	struct hns_roce_context *context = to_hr_ctx(pd->context);
+	unsigned int sge_ex_count;
 
 	if (hns_roce_verify_qp(attr, context)) {
 		fprintf(stderr, "hns_roce_verify_sizes failed!\n");
@@ -443,6 +475,20 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 	qp->sq.wqe_cnt = align_qp_size(attr->cap.max_send_wr);
 	qp->rq.wqe_cnt = align_qp_size(attr->cap.max_recv_wr);
 
+	if (to_hr_dev(pd->context->device)->hw_version == HNS_ROCE_HW_VER1) {
+		qp->sq.max_gs = 2;
+	} else {
+		qp->sq.max_gs = attr->cap.max_send_sge;
+		if (qp->sq.max_gs > 2) {
+			sge_ex_count = qp->sq.wqe_cnt * (qp->sq.max_gs - 2);
+			for (qp->sge.sge_cnt = 1; qp->sge.sge_cnt <
+				sge_ex_count; qp->sge.sge_cnt <<= 1)
+				;
+		} else {
+			qp->sge.sge_cnt = 0;
+		}
+	}
+
 	if (hns_roce_alloc_qp_buf(pd, &attr->cap, attr->qp_type, qp)) {
 		fprintf(stderr, "hns_roce_alloc_qp_buf failed!\n");
 		goto err;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
