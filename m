From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] libhns: Add rq inline data support for hip08 RoCE user mode
Date: Mon, 20 Nov 2017 21:06:04 +0800
Message-ID: <1511183164-197590-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch implements rq inline data feature in hip08
userspace.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u.h       | 17 ++++++++++
 providers/hns/hns_roce_u_hw_v2.c | 70 ++++++++++++++++++++++++++++++++++++++--
 providers/hns/hns_roce_u_verbs.c | 35 +++++++++++++++++++-
 3 files changed, 118 insertions(+), 4 deletions(-)

diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 9ed70d8..0e98f22 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -165,6 +165,21 @@ struct hns_roce_sge_ex {
 	int				sge_shift;
 };
 
+struct hns_roce_rinl_sge {
+	void				*addr;
+	unsigned int			len;
+};
+
+struct hns_roce_rinl_wqe {
+	struct hns_roce_rinl_sge	*sg_list;
+	unsigned int			sge_cnt;
+};
+
+struct hns_roce_rinl_buf {
+	struct hns_roce_rinl_wqe	*wqe_list;
+	unsigned int			wqe_cnt;
+};
+
 struct hns_roce_qp {
 	struct ibv_qp			ibv_qp;
 	struct hns_roce_buf		buf;
@@ -177,6 +192,8 @@ struct hns_roce_qp {
 	unsigned int			next_sge;
 	int				port_num;
 	int				sl;
+
+	struct hns_roce_rinl_buf	rq_rinl_buf;
 };
 
 struct hns_roce_u_hw {
diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index ac35f30..226f66d 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -246,6 +246,8 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
 	uint32_t local_qpn;
 	struct hns_roce_wq *wq = NULL;
 	struct hns_roce_v2_cqe *cqe = NULL;
+	struct hns_roce_rinl_sge *sge_list;
+	uint32_t opcode;
 
 	/* According to CI, find the relative cqe */
 	cqe = next_cqe_sw_v2(cq);
@@ -381,8 +383,9 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
 		/* Get opcode and flag in rq&srq */
 		wc->byte_len = le32toh(cqe->byte_cnt);
 
-		switch (roce_get_field(cqe->byte_4, CQE_BYTE_4_OPCODE_M,
-			CQE_BYTE_4_OPCODE_S) & HNS_ROCE_V2_CQE_OPCODE_MASK) {
+		opcode = roce_get_field(cqe->byte_4, CQE_BYTE_4_OPCODE_M,
+			CQE_BYTE_4_OPCODE_S) & HNS_ROCE_V2_CQE_OPCODE_MASK;
+		switch (opcode) {
 		case HNS_ROCE_RECV_OP_RDMA_WRITE_IMM:
 			wc->opcode = IBV_WC_RECV_RDMA_WITH_IMM;
 			wc->wc_flags = IBV_WC_WITH_IMM;
@@ -409,6 +412,45 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *cq,
 			wc->status = IBV_WC_GENERAL_ERR;
 			break;
 		}
+
+		if (((*cur_qp)->ibv_qp.qp_type == IBV_QPT_RC ||
+		    (*cur_qp)->ibv_qp.qp_type == IBV_QPT_UC) &&
+		    (opcode == HNS_ROCE_RECV_OP_SEND ||
+		     opcode == HNS_ROCE_RECV_OP_SEND_WITH_IMM ||
+		     opcode == HNS_ROCE_RECV_OP_SEND_WITH_INV) &&
+		     (roce_get_bit(cqe->byte_4, CQE_BYTE_4_RQ_INLINE_S))) {
+			uint32_t wr_num, wr_cnt, sge_num, data_len;
+			uint8_t *wqe_buf;
+			uint32_t sge_cnt, size;
+
+			wr_num = (uint16_t)roce_get_field(cqe->byte_4,
+						CQE_BYTE_4_WQE_IDX_M,
+						CQE_BYTE_4_WQE_IDX_S) & 0xffff;
+			wr_cnt = wr_num & ((*cur_qp)->rq.wqe_cnt - 1);
+
+			sge_list =
+				(*cur_qp)->rq_rinl_buf.wqe_list[wr_cnt].sg_list;
+			sge_num =
+				(*cur_qp)->rq_rinl_buf.wqe_list[wr_cnt].sge_cnt;
+			wqe_buf = (uint8_t *)get_recv_wqe_v2(*cur_qp, wr_cnt);
+			data_len = wc->byte_len;
+
+			for (sge_cnt = 0; (sge_cnt < sge_num) && (data_len);
+			     sge_cnt++) {
+				size = sge_list[sge_cnt].len < data_len ?
+				       sge_list[sge_cnt].len : data_len;
+
+				memcpy((void *)sge_list[sge_cnt].addr,
+					(void *)wqe_buf, size);
+				data_len -= size;
+				wqe_buf += size;
+			}
+
+			if (data_len) {
+				wc->status = IBV_WC_LOC_LEN_ERR;
+				return -1;
+			}
+		}
 	}
 
 	return V2_CQ_OK;
@@ -723,6 +765,7 @@ static int hns_roce_u_v2_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
 	struct hns_roce_qp *qp = to_hr_qp(ibvqp);
 	struct hns_roce_context *ctx = to_hr_ctx(ibvqp->context);
 	struct hns_roce_v2_wqe_data_seg *dseg;
+	struct hns_roce_rinl_sge *sge_list;
 	void *wqe;
 	int i;
 
@@ -766,6 +809,17 @@ static int hns_roce_u_v2_post_recv(struct ibv_qp *ibvqp, struct ibv_recv_wr *wr,
 			dseg[i].addr = 0;
 		}
 
+		/* QP support receive inline wqe */
+		sge_list = qp->rq_rinl_buf.wqe_list[ind].sg_list;
+		qp->rq_rinl_buf.wqe_list[ind].sge_cnt =
+						(unsigned int)wr->num_sge;
+
+		for (i = 0; i < wr->num_sge; i++) {
+			sge_list[i].addr =
+					(void *)(uintptr_t)wr->sg_list[i].addr;
+			sge_list[i].len = wr->sg_list[i].length;
+		}
+
 		qp->rq.wrid[ind] = wr->wr_id;
 
 		ind = (ind + 1) & (qp->rq.wqe_cnt - 1);
@@ -917,11 +971,21 @@ static int hns_roce_u_v2_destroy_qp(struct ibv_qp *ibqp)
 	hns_roce_unlock_cqs(ibqp);
 	pthread_mutex_unlock(&to_hr_ctx(ibqp->context)->qp_table_mutex);
 
+	hns_roce_free_buf(&qp->buf);
+	if (qp->rq_rinl_buf.wqe_list) {
+		if (qp->rq_rinl_buf.wqe_list[0].sg_list) {
+			free(qp->rq_rinl_buf.wqe_list[0].sg_list);
+			qp->rq_rinl_buf.wqe_list[0].sg_list = NULL;
+		}
+
+		free(qp->rq_rinl_buf.wqe_list);
+		qp->rq_rinl_buf.wqe_list = NULL;
+	}
+
 	free(qp->sq.wrid);
 	if (qp->rq.wqe_cnt)
 		free(qp->rq.wrid);
 
-	hns_roce_free_buf(&qp->buf);
 	free(qp);
 
 	return ret;
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 7dc643c..d0ab10a 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -359,6 +359,8 @@ static int hns_roce_verify_qp(struct ibv_qp_init_attr *attr,
 static int hns_roce_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 				 enum ibv_qp_type type, struct hns_roce_qp *qp)
 {
+	int i;
+
 	qp->sq.wrid =
 		(unsigned long *)malloc(qp->sq.wqe_cnt * sizeof(uint64_t));
 	if (!qp->sq.wrid)
@@ -399,6 +401,36 @@ static int hns_roce_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 		else
 			qp->sge.sge_shift = 0;
 
+		/* alloc recv inline buf*/
+		qp->rq_rinl_buf.wqe_list =
+			(struct hns_roce_rinl_wqe *)calloc(1, qp->rq.wqe_cnt *
+					      sizeof(struct hns_roce_rinl_wqe));
+		if (!qp->rq_rinl_buf.wqe_list) {
+			if (qp->rq.wqe_cnt)
+				free(qp->rq.wrid);
+			free(qp->sq.wrid);
+			return -1;
+		}
+
+		qp->rq_rinl_buf.wqe_cnt = qp->rq.wqe_cnt;
+
+		qp->rq_rinl_buf.wqe_list[0].sg_list =
+			(struct hns_roce_rinl_sge *)calloc(1, qp->rq.wqe_cnt *
+			  cap->max_recv_sge * sizeof(struct hns_roce_rinl_sge));
+		if (!qp->rq_rinl_buf.wqe_list[0].sg_list) {
+			if (qp->rq.wqe_cnt)
+				free(qp->rq.wrid);
+			free(qp->sq.wrid);
+			free(qp->rq_rinl_buf.wqe_list);
+			return -1;
+		}
+		for (i = 0; i < qp->rq_rinl_buf.wqe_cnt; i++) {
+			int wqe_size = i * cap->max_recv_sge;
+
+			qp->rq_rinl_buf.wqe_list[i].sg_list =
+			  &(qp->rq_rinl_buf.wqe_list[0].sg_list[wqe_size]);
+		}
+
 		qp->buf_size = align((qp->sq.wqe_cnt << qp->sq.wqe_shift),
 				     0x1000) +
 			       align((qp->sge.sge_cnt << qp->sge.sge_shift),
@@ -422,7 +454,8 @@ static int hns_roce_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
 
 	if (hns_roce_alloc_buf(&qp->buf, align(qp->buf_size, 0x1000),
 			       to_hr_dev(pd->context->device)->page_size)) {
-		free(qp->sq.wrid);
+		if (qp->rq.wqe_cnt)
+			free(qp->sq.wrid);
 		free(qp->rq.wrid);
 		return -1;
 	}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
