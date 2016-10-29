From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 rdma-core 6/7] libhns: Add verbs of post_send and post_recv support
Date: Sat, 29 Oct 2016 17:03:45 +0800
Message-ID: <1477731826-10787-7-git-send-email-oulijun@huawei.com>
References: <1477731826-10787-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477731826-10787-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch mainly introduces the verbs of posting send
and psoting recv.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u.c       |   2 +
 providers/hns/hns_roce_u.h       |   8 +
 providers/hns/hns_roce_u_hw_v1.c | 314 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_hw_v1.h |  79 ++++++++++
 4 files changed, 403 insertions(+)

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 30f8678..bceed84 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -131,6 +131,8 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 	context->ibv_ctx.ops.query_qp	   = hns_roce_u_query_qp;
 	context->ibv_ctx.ops.modify_qp     = hr_dev->u_hw->modify_qp;
 	context->ibv_ctx.ops.destroy_qp    = hr_dev->u_hw->destroy_qp;
+	context->ibv_ctx.ops.post_send     = hr_dev->u_hw->post_send;
+	context->ibv_ctx.ops.post_recv     = hr_dev->u_hw->post_recv;
 
 	if (hns_roce_u_query_device(&context->ibv_ctx, &dev_attrs))
 		goto tptr_free;
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 02b9251..4a6ed8e 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -51,6 +51,10 @@
 
 #define PFX				"hns: "
 
+#ifndef likely
+#define likely(x)     __builtin_expect(!!(x), 1)
+#endif
+
 #define roce_get_field(origin, mask, shift) \
 	(((origin) & (mask)) >> (shift))
 
@@ -171,6 +175,10 @@ struct hns_roce_qp {
 struct hns_roce_u_hw {
 	int (*poll_cq)(struct ibv_cq *ibvcq, int ne, struct ibv_wc *wc);
 	int (*arm_cq)(struct ibv_cq *ibvcq, int solicited);
+	int (*post_send)(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
+			 struct ibv_send_wr **bad_wr);
+	int (*post_recv)(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
+			 struct ibv_recv_wr **bad_wr);
 	int (*modify_qp)(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 			 int attr_mask);
 	int (*destroy_qp)(struct ibv_qp *ibqp);
diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
index fb81634..a3aad1c 100644
--- a/providers/hns/hns_roce_u_hw_v1.c
+++ b/providers/hns/hns_roce_u_hw_v1.c
@@ -37,6 +37,59 @@
 #include "hns_roce_u_hw_v1.h"
 #include "hns_roce_u.h"
 
+static inline void set_raddr_seg(struct hns_roce_wqe_raddr_seg *rseg,
+				 uint64_t remote_addr, uint32_t rkey)
+{
+	rseg->raddr    = remote_addr;
+	rseg->rkey     = rkey;
+	rseg->len      = 0;
+}
+
+static void set_data_seg(struct hns_roce_wqe_data_seg *dseg, struct ibv_sge *sg)
+{
+
+	dseg->lkey = sg->lkey;
+	dseg->addr = sg->addr;
+	dseg->len = sg->length;
+}
+
+static void hns_roce_update_rq_head(struct hns_roce_context *ctx,
+				    unsigned int qpn, unsigned int rq_head)
+{
+	struct hns_roce_rq_db rq_db;
+
+	rq_db.u32_4 = 0;
+	rq_db.u32_8 = 0;
+
+	roce_set_field(rq_db.u32_4, RQ_DB_U32_4_RQ_HEAD_M,
+		       RQ_DB_U32_4_RQ_HEAD_S, rq_head);
+	roce_set_field(rq_db.u32_8, RQ_DB_U32_8_QPN_M, RQ_DB_U32_8_QPN_S, qpn);
+	roce_set_field(rq_db.u32_8, RQ_DB_U32_8_CMD_M, RQ_DB_U32_8_CMD_S, 1);
+	roce_set_bit(rq_db.u32_8, RQ_DB_U32_8_HW_SYNC_S, 1);
+
+	hns_roce_write64((uint32_t *)&rq_db, ctx, ROCEE_DB_OTHERS_L_0_REG);
+}
+
+static void hns_roce_update_sq_head(struct hns_roce_context *ctx,
+				    unsigned int qpn, unsigned int port,
+				    unsigned int sl, unsigned int sq_head)
+{
+	struct hns_roce_sq_db sq_db;
+
+	sq_db.u32_4 = 0;
+	sq_db.u32_8 = 0;
+
+	roce_set_field(sq_db.u32_4, SQ_DB_U32_4_SQ_HEAD_M,
+		       SQ_DB_U32_4_SQ_HEAD_S, sq_head);
+	roce_set_field(sq_db.u32_4, SQ_DB_U32_4_PORT_M, SQ_DB_U32_4_PORT_S,
+		       port);
+	roce_set_field(sq_db.u32_4, SQ_DB_U32_4_SL_M, SQ_DB_U32_4_SL_S, sl);
+	roce_set_field(sq_db.u32_8, SQ_DB_U32_8_QPN_M, SQ_DB_U32_8_QPN_S, qpn);
+	roce_set_bit(sq_db.u32_8, SQ_DB_U32_8_HW_SYNC, 1);
+
+	hns_roce_write64((uint32_t *)&sq_db, ctx, ROCEE_DB_SQ_L_0_REG);
+}
+
 static void hns_roce_update_cq_cons_index(struct hns_roce_context *ctx,
 					  struct hns_roce_cq *cq)
 {
@@ -126,6 +179,16 @@ static struct hns_roce_cqe *next_cqe_sw(struct hns_roce_cq *cq)
 	return get_sw_cqe(cq, cq->cons_index);
 }
 
+static void *get_recv_wqe(struct hns_roce_qp *qp, int n)
+{
+	if ((n < 0) || (n > qp->rq.wqe_cnt)) {
+		printf("rq wqe index:%d,rq wqe cnt:%d\r\n", n, qp->rq.wqe_cnt);
+		return NULL;
+	}
+
+	return qp->buf.buf + qp->rq.offset + (n << qp->rq.wqe_shift);
+}
+
 static void *get_send_wqe(struct hns_roce_qp *qp, int n)
 {
 	if ((n < 0) || (n > qp->sq.wqe_cnt)) {
@@ -137,6 +200,26 @@ static void *get_send_wqe(struct hns_roce_qp *qp, int n)
 				  (n << qp->sq.wqe_shift));
 }
 
+static int hns_roce_wq_overflow(struct hns_roce_wq *wq, int nreq,
+				struct hns_roce_cq *cq)
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
+	printf("wq:(head = %d, tail = %d, max_post = %d), nreq = 0x%x\n",
+		wq->head, wq->tail, wq->max_post, nreq);
+
+	return cur + nreq >= wq->max_post;
+}
+
 static struct hns_roce_qp *hns_roce_find_qp(struct hns_roce_context *ctx,
 					    uint32_t qpn)
 {
@@ -374,6 +457,144 @@ static int hns_roce_u_v1_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	return 0;
 }
 
+static int hns_roce_u_v1_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
+				   struct ibv_send_wr **bad_wr)
+{
+	unsigned int ind;
+	void *wqe;
+	int nreq;
+	int ps_opcode, i;
+	int ret = 0;
+	struct hns_roce_wqe_ctrl_seg *ctrl = NULL;
+	struct hns_roce_wqe_data_seg *dseg = NULL;
+	struct hns_roce_qp *qp = to_hr_qp(ibvqp);
+	struct hns_roce_context *ctx = to_hr_ctx(ibvqp->context);
+
+	pthread_spin_lock(&qp->sq.lock);
+
+	/* check that state is OK to post send */
+	ind = qp->sq.head;
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (hns_roce_wq_overflow(&qp->sq, nreq,
+					 to_hr_cq(qp->ibv_qp.send_cq))) {
+			ret = -1;
+			*bad_wr = wr;
+			goto out;
+		}
+		if (wr->num_sge > qp->sq.max_gs) {
+			ret = -1;
+			*bad_wr = wr;
+			printf("wr->num_sge(<=%d) = %d, check failed!\r\n",
+				qp->sq.max_gs, wr->num_sge);
+			goto out;
+		}
+
+		ctrl = wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
+		memset(ctrl, 0, sizeof(struct hns_roce_wqe_ctrl_seg));
+
+		qp->sq.wrid[ind & (qp->sq.wqe_cnt - 1)] = wr->wr_id;
+		for (i = 0; i < wr->num_sge; i++)
+			ctrl->msg_length += wr->sg_list[i].length;
+
+
+		ctrl->flag |= ((wr->send_flags & IBV_SEND_SIGNALED) ?
+				HNS_ROCE_WQE_CQ_NOTIFY : 0) |
+			      (wr->send_flags & IBV_SEND_SOLICITED ?
+				HNS_ROCE_WQE_SE : 0) |
+			      ((wr->opcode == IBV_WR_SEND_WITH_IMM ||
+			       wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM) ?
+				HNS_ROCE_WQE_IMM : 0) |
+			      (wr->send_flags & IBV_SEND_FENCE ?
+				HNS_ROCE_WQE_FENCE : 0);
+
+		if (wr->opcode == IBV_WR_SEND_WITH_IMM ||
+		    wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM)
+			ctrl->imm_data = wr->imm_data;
+
+		wqe += sizeof(struct hns_roce_wqe_ctrl_seg);
+
+		/* set remote addr segment */
+		switch (ibvqp->qp_type) {
+		case IBV_QPT_RC:
+			switch (wr->opcode) {
+			case IBV_WR_RDMA_READ:
+				ps_opcode = HNS_ROCE_WQE_OPCODE_RDMA_READ;
+				set_raddr_seg(wqe, wr->wr.rdma.remote_addr,
+					      wr->wr.rdma.rkey);
+				break;
+			case IBV_WR_RDMA_WRITE:
+			case IBV_WR_RDMA_WRITE_WITH_IMM:
+				ps_opcode = HNS_ROCE_WQE_OPCODE_RDMA_WRITE;
+				set_raddr_seg(wqe, wr->wr.rdma.remote_addr,
+					      wr->wr.rdma.rkey);
+				break;
+			case IBV_WR_SEND:
+			case IBV_WR_SEND_WITH_IMM:
+				ps_opcode = HNS_ROCE_WQE_OPCODE_SEND;
+				break;
+			case IBV_WR_ATOMIC_CMP_AND_SWP:
+			case IBV_WR_ATOMIC_FETCH_AND_ADD:
+			default:
+				ps_opcode = HNS_ROCE_WQE_OPCODE_MASK;
+				break;
+			}
+			ctrl->flag |= (ps_opcode);
+			wqe  += sizeof(struct hns_roce_wqe_raddr_seg);
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
+			if (ctrl->msg_length > qp->max_inline_data) {
+				ret = -1;
+				*bad_wr = wr;
+				printf("inline data len(1-32)=%d, send_flags = 0x%x, check failed!\r\n",
+					wr->send_flags, ctrl->msg_length);
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
+			ctrl->flag |= HNS_ROCE_WQE_INLINE;
+		} else {
+			/* set sge */
+			for (i = 0; i < wr->num_sge; i++)
+				set_data_seg(dseg+i, wr->sg_list + i);
+
+			ctrl->flag |= wr->num_sge << HNS_ROCE_WQE_SGE_NUM_BIT;
+		}
+
+		ind++;
+	}
+
+out:
+	/* Set DB return */
+	if (likely(nreq)) {
+		qp->sq.head += nreq;
+		wmb();
+
+		hns_roce_update_sq_head(ctx, qp->ibv_qp.qp_num,
+				qp->port_num - 1, qp->sl,
+				qp->sq.head & ((qp->sq.wqe_cnt << 1) - 1));
+	}
+
+	pthread_spin_unlock(&qp->sq.lock);
+
+	return ret;
+}
+
 static void __hns_roce_v1_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
 				   struct hns_roce_srq *srq)
 {
@@ -517,9 +738,102 @@ static int hns_roce_u_v1_destroy_qp(struct ibv_qp *ibqp)
 	return ret;
 }
 
+static int hns_roce_u_v1_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
+				   struct ibv_recv_wr **bad_wr)
+{
+	int ret = 0;
+	int nreq;
+	int ind;
+	struct ibv_sge *sg;
+	struct hns_roce_rc_rq_wqe *rq_wqe;
+	struct hns_roce_qp *qp = to_hr_qp(ibvqp);
+	struct hns_roce_context *ctx = to_hr_ctx(ibvqp->context);
+
+	pthread_spin_lock(&qp->rq.lock);
+
+	/* check that state is OK to post receive */
+	ind = qp->rq.head & (qp->rq.wqe_cnt - 1);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (hns_roce_wq_overflow(&qp->rq, nreq,
+					 to_hr_cq(qp->ibv_qp.recv_cq))) {
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
+		rq_wqe = get_recv_wqe(qp, ind);
+		if (wr->num_sge > HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM) {
+			ret = -1;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		if (wr->num_sge == HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM) {
+			roce_set_field(rq_wqe->u32_2,
+				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_M,
+				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_S,
+				       HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM);
+			sg = wr->sg_list;
+
+			rq_wqe->va0 = (sg->addr);
+			rq_wqe->l_key0 = (sg->lkey);
+			rq_wqe->length0 = (sg->length);
+
+			sg = wr->sg_list + 1;
+
+			rq_wqe->va1 = (sg->addr);
+			rq_wqe->l_key1 = (sg->lkey);
+			rq_wqe->length1 = (sg->length);
+		} else if (wr->num_sge == HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 1) {
+			roce_set_field(rq_wqe->u32_2,
+				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_M,
+				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_S,
+				       HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 1);
+			sg = wr->sg_list;
+
+			rq_wqe->va0 = (sg->addr);
+			rq_wqe->l_key0 = (sg->lkey);
+			rq_wqe->length0 = (sg->length);
+
+		} else if (wr->num_sge == HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 2) {
+			roce_set_field(rq_wqe->u32_2,
+				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_M,
+				       RC_RQ_WQE_NUMBER_OF_DATA_SEG_S,
+				       HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM - 2);
+		}
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
+		wmb();
+
+		hns_roce_update_rq_head(ctx, qp->ibv_qp.qp_num,
+				    qp->rq.head & ((qp->rq.wqe_cnt << 1) - 1));
+	}
+
+	pthread_spin_unlock(&qp->rq.lock);
+
+	return ret;
+}
+
 struct hns_roce_u_hw hns_roce_u_hw_v1 = {
 	.poll_cq = hns_roce_u_v1_poll_cq,
 	.arm_cq = hns_roce_u_v1_arm_cq,
+	.post_send = hns_roce_u_v1_post_send,
+	.post_recv = hns_roce_u_v1_post_recv,
 	.modify_qp = hns_roce_u_v1_modify_qp,
 	.destroy_qp = hns_roce_u_v1_destroy_qp,
 };
diff --git a/providers/hns/hns_roce_u_hw_v1.h b/providers/hns/hns_roce_u_hw_v1.h
index b249f54..128c66f 100644
--- a/providers/hns/hns_roce_u_hw_v1.h
+++ b/providers/hns/hns_roce_u_hw_v1.h
@@ -39,9 +39,15 @@
 #define HNS_ROCE_CQE_IS_SQ			0
 
 #define HNS_ROCE_RC_WQE_INLINE_DATA_MAX_LEN	32
+#define HNS_ROCE_RC_RQ_WQE_MAX_SGE_NUM		2
 
 enum {
+	HNS_ROCE_WQE_INLINE		= 1 << 31,
+	HNS_ROCE_WQE_SE			= 1 << 30,
+	HNS_ROCE_WQE_SGE_NUM_BIT	= 24,
 	HNS_ROCE_WQE_IMM		= 1 << 23,
+	HNS_ROCE_WQE_FENCE		= 1 << 21,
+	HNS_ROCE_WQE_CQ_NOTIFY		 = 1 << 20,
 	HNS_ROCE_WQE_OPCODE_SEND        = 0 << 16,
 	HNS_ROCE_WQE_OPCODE_RDMA_READ   = 1 << 16,
 	HNS_ROCE_WQE_OPCODE_RDMA_WRITE  = 2 << 16,
@@ -52,6 +58,20 @@ enum {
 struct hns_roce_wqe_ctrl_seg {
 	__be32		sgl_pa_h;
 	__be32		flag;
+	__be32		imm_data;
+	__be32		msg_length;
+};
+
+struct hns_roce_wqe_data_seg {
+	__be64		addr;
+	__be32		lkey;
+	__be32		len;
+};
+
+struct hns_roce_wqe_raddr_seg {
+	__be32		rkey;
+	__be32		len;
+	__be64		raddr;
 };
 
 enum {
@@ -102,6 +122,43 @@ struct hns_roce_cq_db {
 
 #define CQ_DB_U32_8_HW_SYNC_S 31
 
+struct hns_roce_rq_db {
+	unsigned int u32_4;
+	unsigned int u32_8;
+};
+
+#define RQ_DB_U32_4_RQ_HEAD_S 0
+#define RQ_DB_U32_4_RQ_HEAD_M   (((1UL << 15) - 1) << RQ_DB_U32_4_RQ_HEAD_S)
+
+#define RQ_DB_U32_8_QPN_S 0
+#define RQ_DB_U32_8_QPN_M   (((1UL << 24) - 1) << RQ_DB_U32_8_QPN_S)
+
+#define RQ_DB_U32_8_CMD_S 28
+#define RQ_DB_U32_8_CMD_M   (((1UL << 3) - 1) << RQ_DB_U32_8_CMD_S)
+
+#define RQ_DB_U32_8_HW_SYNC_S 31
+
+struct hns_roce_sq_db {
+	unsigned int u32_4;
+	unsigned int u32_8;
+};
+
+#define SQ_DB_U32_4_SQ_HEAD_S 0
+#define SQ_DB_U32_4_SQ_HEAD_M (((1UL << 15) - 1) << SQ_DB_U32_4_SQ_HEAD_S)
+
+#define SQ_DB_U32_4_SL_S 16
+#define SQ_DB_U32_4_SL_M (((1UL << 2) - 1) << SQ_DB_U32_4_SL_S)
+
+#define SQ_DB_U32_4_PORT_S 18
+#define SQ_DB_U32_4_PORT_M (((1UL << 3) - 1) << SQ_DB_U32_4_PORT_S)
+
+#define SQ_DB_U32_4_DIRECT_WQE_S 31
+
+#define SQ_DB_U32_8_QPN_S 0
+#define SQ_DB_U32_8_QPN_M (((1UL << 24) - 1) << SQ_DB_U32_8_QPN_S)
+
+#define SQ_DB_U32_8_HW_SYNC 31
+
 struct hns_roce_cqe {
 	unsigned int cqe_byte_4;
 	union {
@@ -160,4 +217,26 @@ struct hns_roce_rc_send_wqe {
 	unsigned int length1;
 };
 
+struct hns_roce_rc_rq_wqe {
+	unsigned int u32_0;
+	unsigned int sgl_ba_31_0;
+	unsigned int u32_2;
+	unsigned int rvd_5;
+	unsigned int rvd_6;
+	unsigned int rvd_7;
+	unsigned int rvd_8;
+	unsigned int rvd_9;
+
+	uint64_t     va0;
+	unsigned int l_key0;
+	unsigned int length0;
+
+	uint64_t     va1;
+	unsigned int l_key1;
+	unsigned int length1;
+};
+#define RC_RQ_WQE_NUMBER_OF_DATA_SEG_S 16
+#define RC_RQ_WQE_NUMBER_OF_DATA_SEG_M \
+	(((1UL << 6) - 1) << RC_RQ_WQE_NUMBER_OF_DATA_SEG_S)
+
 #endif /* _HNS_ROCE_U_HW_V1_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
