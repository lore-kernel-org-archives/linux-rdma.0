From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 rdma-core 5/7] libhns: Add verbs of qp support
Date: Sun, 13 Nov 2016 18:35:58 +0800
Message-ID: <1479033360-56035-6-git-send-email-oulijun@huawei.com>
References: <1479033360-56035-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479033360-56035-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch mainly introduces the relatived qp verbs for userspace
library of hns, include:
    1. create_qp
    2. query_qp
    3. modify_qp
    4. destroy_qp

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
v5/v4/v3:
- No change over v2

v2:
- Delete the min() and use the ccan header

v1:
- The initial submit
---
 providers/hns/hns_roce_u.c       |   5 +
 providers/hns/hns_roce_u.h       |  45 +++++++
 providers/hns/hns_roce_u_abi.h   |   8 ++
 providers/hns/hns_roce_u_hw_v1.c | 155 +++++++++++++++++++++++
 providers/hns/hns_roce_u_verbs.c | 259 ++++++++++++++++++++++++++++++++++++++-
 5 files changed, 471 insertions(+), 1 deletion(-)

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 1877218..de2fd57 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -127,6 +127,11 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 	context->ibv_ctx.ops.cq_event	   = hns_roce_u_cq_event;
 	context->ibv_ctx.ops.destroy_cq    = hns_roce_u_destroy_cq;
 
+	context->ibv_ctx.ops.create_qp     = hns_roce_u_create_qp;
+	context->ibv_ctx.ops.query_qp	   = hns_roce_u_query_qp;
+	context->ibv_ctx.ops.modify_qp     = hr_dev->u_hw->modify_qp;
+	context->ibv_ctx.ops.destroy_qp    = hr_dev->u_hw->destroy_qp;
+
 	if (hns_roce_u_query_device(&context->ibv_ctx, &dev_attrs))
 		goto tptr_free;
 
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index c3e364d..02b9251 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -44,6 +44,7 @@
 
 #define HNS_ROCE_MAX_CQ_NUM		0x10000
 #define HNS_ROCE_MIN_CQE_NUM		0x40
+#define HNS_ROCE_MIN_WQE_NUM		0x20
 #define HNS_ROCE_CQ_DB_BUF_SIZE		((HNS_ROCE_MAX_CQ_NUM >> 11) << 12)
 #define HNS_ROCE_TPTR_OFFSET		0x1000
 #define HNS_ROCE_HW_VER1		('h' << 24 | 'i' << 16 | '0' << 8 | '6')
@@ -128,10 +129,29 @@ struct hns_roce_cq {
 	int				arm_sn;
 };
 
+struct hns_roce_srq {
+	struct ibv_srq			ibv_srq;
+	struct hns_roce_buf		buf;
+	pthread_spinlock_t		lock;
+	unsigned long			*wrid;
+	unsigned int			srqn;
+	int				max;
+	unsigned int			max_gs;
+	int				wqe_shift;
+	int				head;
+	int				tail;
+	unsigned int			*db;
+	unsigned short			counter;
+};
+
 struct hns_roce_wq {
 	unsigned long			*wrid;
+	pthread_spinlock_t		lock;
 	unsigned int			wqe_cnt;
+	int				max_post;
+	unsigned int			head;
 	unsigned int			tail;
+	unsigned int			max_gs;
 	int				wqe_shift;
 	int				offset;
 };
@@ -139,14 +159,21 @@ struct hns_roce_wq {
 struct hns_roce_qp {
 	struct ibv_qp			ibv_qp;
 	struct hns_roce_buf		buf;
+	int				max_inline_data;
+	int				buf_size;
 	unsigned int			sq_signal_bits;
 	struct hns_roce_wq		sq;
 	struct hns_roce_wq		rq;
+	int				port_num;
+	int				sl;
 };
 
 struct hns_roce_u_hw {
 	int (*poll_cq)(struct ibv_cq *ibvcq, int ne, struct ibv_wc *wc);
 	int (*arm_cq)(struct ibv_cq *ibvcq, int solicited);
+	int (*modify_qp)(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+			 int attr_mask);
+	int (*destroy_qp)(struct ibv_qp *ibqp);
 };
 
 static inline unsigned long align(unsigned long val, unsigned long align)
@@ -174,6 +201,16 @@ static inline struct hns_roce_cq *to_hr_cq(struct ibv_cq *ibv_cq)
 	return container_of(ibv_cq, struct hns_roce_cq, ibv_cq);
 }
 
+static inline struct hns_roce_srq *to_hr_srq(struct ibv_srq *ibv_srq)
+{
+	return container_of(ibv_srq, struct hns_roce_srq, ibv_srq);
+}
+
+static inline struct  hns_roce_qp *to_hr_qp(struct ibv_qp *ibv_qp)
+{
+	return container_of(ibv_qp, struct hns_roce_qp, ibv_qp);
+}
+
 int hns_roce_u_query_device(struct ibv_context *context,
 			    struct ibv_device_attr *attr);
 int hns_roce_u_query_port(struct ibv_context *context, uint8_t port,
@@ -193,10 +230,18 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 int hns_roce_u_destroy_cq(struct ibv_cq *cq);
 void hns_roce_u_cq_event(struct ibv_cq *cq);
 
+struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
+				    struct ibv_qp_init_attr *attr);
+
+int hns_roce_u_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
+			int attr_mask, struct ibv_qp_init_attr *init_attr);
+
 int hns_roce_alloc_buf(struct hns_roce_buf *buf, unsigned int size,
 		       int page_size);
 void hns_roce_free_buf(struct hns_roce_buf *buf);
 
+void hns_roce_init_qp_indices(struct hns_roce_qp *qp);
+
 extern struct hns_roce_u_hw hns_roce_u_hw_v1;
 
 #endif /* _HNS_ROCE_U_H */
diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index 1e62a7e..e78f967 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -58,4 +58,12 @@ struct hns_roce_create_cq_resp {
 	__u32				reserved;
 };
 
+struct hns_roce_create_qp {
+	struct ibv_create_qp		ibv_cmd;
+	__u64				buf_addr;
+	__u8				log_sq_bb_count;
+	__u8				log_sq_stride;
+	__u8				reserved[5];
+};
+
 #endif /* _HNS_ROCE_U_ABI_H */
diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
index 39a67b1..e5c7f6a 100644
--- a/providers/hns/hns_roce_u_hw_v1.c
+++ b/providers/hns/hns_roce_u_hw_v1.c
@@ -149,6 +149,16 @@ static struct hns_roce_qp *hns_roce_find_qp(struct hns_roce_context *ctx,
 	}
 }
 
+static void hns_roce_clear_qp(struct hns_roce_context *ctx, uint32_t qpn)
+{
+	int tind = (qpn & (ctx->num_qps - 1)) >> ctx->qp_table_shift;
+
+	if (!--ctx->qp_table[tind].refcnt)
+		free(ctx->qp_table[tind].table);
+	else
+		ctx->qp_table[tind].table[qpn & ctx->qp_table_mask] = NULL;
+}
+
 static int hns_roce_v1_poll_one(struct hns_roce_cq *cq,
 				struct hns_roce_qp **cur_qp, struct ibv_wc *wc)
 {
@@ -362,7 +372,152 @@ static int hns_roce_u_v1_arm_cq(struct ibv_cq *ibvcq, int solicited)
 	return 0;
 }
 
+static void __hns_roce_v1_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
+				   struct hns_roce_srq *srq)
+{
+	int nfreed = 0;
+	uint32_t prod_index;
+	uint8_t owner_bit = 0;
+	struct hns_roce_cqe *cqe, *dest;
+	struct hns_roce_context *ctx = to_hr_ctx(cq->ibv_cq.context);
+
+	for (prod_index = cq->cons_index; get_sw_cqe(cq, prod_index);
+	     ++prod_index)
+		if (prod_index == cq->cons_index + cq->ibv_cq.cqe)
+			break;
+
+	while ((int) --prod_index - (int) cq->cons_index >= 0) {
+		cqe = get_cqe(cq, prod_index & cq->ibv_cq.cqe);
+		if ((roce_get_field(cqe->cqe_byte_16, CQE_BYTE_16_LOCAL_QPN_M,
+			      CQE_BYTE_16_LOCAL_QPN_S) & 0xffffff) == qpn) {
+			++nfreed;
+		} else if (nfreed) {
+			dest = get_cqe(cq,
+				       (prod_index + nfreed) & cq->ibv_cq.cqe);
+			owner_bit = roce_get_bit(dest->cqe_byte_4,
+						 CQE_BYTE_4_OWNER_S);
+			memcpy(dest, cqe, sizeof(*cqe));
+			roce_set_bit(dest->cqe_byte_4, CQE_BYTE_4_OWNER_S,
+				     owner_bit);
+		}
+	}
+
+	if (nfreed) {
+		cq->cons_index += nfreed;
+		wmb();
+		hns_roce_update_cq_cons_index(ctx, cq);
+	}
+}
+
+static void hns_roce_v1_cq_clean(struct hns_roce_cq *cq, unsigned int qpn,
+				 struct hns_roce_srq *srq)
+{
+	pthread_spin_lock(&cq->lock);
+	__hns_roce_v1_cq_clean(cq, qpn, srq);
+	pthread_spin_unlock(&cq->lock);
+}
+
+static int hns_roce_u_v1_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
+				   int attr_mask)
+{
+	int ret;
+	struct ibv_modify_qp cmd;
+	struct hns_roce_qp *hr_qp = to_hr_qp(qp);
+
+	ret = ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof(cmd));
+
+	if (!ret && (attr_mask & IBV_QP_STATE) &&
+	    attr->qp_state == IBV_QPS_RESET) {
+		hns_roce_v1_cq_clean(to_hr_cq(qp->recv_cq), qp->qp_num,
+				     qp->srq ? to_hr_srq(qp->srq) : NULL);
+		if (qp->send_cq != qp->recv_cq)
+			hns_roce_v1_cq_clean(to_hr_cq(qp->send_cq), qp->qp_num,
+					     NULL);
+
+		hns_roce_init_qp_indices(to_hr_qp(qp));
+	}
+
+	if (!ret && (attr_mask & IBV_QP_PORT)) {
+		hr_qp->port_num = attr->port_num;
+		printf("hr_qp->port_num= 0x%x\n", hr_qp->port_num);
+	}
+
+	hr_qp->sl = attr->ah_attr.sl;
+
+	return ret;
+}
+
+static void hns_roce_lock_cqs(struct ibv_qp *qp)
+{
+	struct hns_roce_cq *send_cq = to_hr_cq(qp->send_cq);
+	struct hns_roce_cq *recv_cq = to_hr_cq(qp->recv_cq);
+
+	if (send_cq == recv_cq) {
+		pthread_spin_lock(&send_cq->lock);
+	} else if (send_cq->cqn < recv_cq->cqn) {
+		pthread_spin_lock(&send_cq->lock);
+		pthread_spin_lock(&recv_cq->lock);
+	} else {
+		pthread_spin_lock(&recv_cq->lock);
+		pthread_spin_lock(&send_cq->lock);
+	}
+}
+
+static void hns_roce_unlock_cqs(struct ibv_qp *qp)
+{
+	struct hns_roce_cq *send_cq = to_hr_cq(qp->send_cq);
+	struct hns_roce_cq *recv_cq = to_hr_cq(qp->recv_cq);
+
+	if (send_cq == recv_cq) {
+		pthread_spin_unlock(&send_cq->lock);
+	} else if (send_cq->cqn < recv_cq->cqn) {
+		pthread_spin_unlock(&recv_cq->lock);
+		pthread_spin_unlock(&send_cq->lock);
+	} else {
+		pthread_spin_unlock(&send_cq->lock);
+		pthread_spin_unlock(&recv_cq->lock);
+	}
+}
+
+static int hns_roce_u_v1_destroy_qp(struct ibv_qp *ibqp)
+{
+	int ret;
+	struct hns_roce_qp *qp = to_hr_qp(ibqp);
+
+	pthread_mutex_lock(&to_hr_ctx(ibqp->context)->qp_table_mutex);
+	ret = ibv_cmd_destroy_qp(ibqp);
+	if (ret) {
+		pthread_mutex_unlock(&to_hr_ctx(ibqp->context)->qp_table_mutex);
+		return ret;
+	}
+
+	hns_roce_lock_cqs(ibqp);
+
+	__hns_roce_v1_cq_clean(to_hr_cq(ibqp->recv_cq), ibqp->qp_num,
+			       ibqp->srq ? to_hr_srq(ibqp->srq) : NULL);
+
+	if (ibqp->send_cq != ibqp->recv_cq)
+		__hns_roce_v1_cq_clean(to_hr_cq(ibqp->send_cq), ibqp->qp_num,
+				       NULL);
+
+	hns_roce_clear_qp(to_hr_ctx(ibqp->context), ibqp->qp_num);
+
+	hns_roce_unlock_cqs(ibqp);
+	pthread_mutex_unlock(&to_hr_ctx(ibqp->context)->qp_table_mutex);
+
+	free(qp->sq.wrid);
+	if (qp->rq.wqe_cnt)
+		free(qp->rq.wrid);
+
+	hns_roce_free_buf(&qp->buf);
+	free(qp);
+
+	return ret;
+}
+
 struct hns_roce_u_hw hns_roce_u_hw_v1 = {
 	.poll_cq = hns_roce_u_v1_poll_cq,
 	.arm_cq = hns_roce_u_v1_arm_cq,
+	.modify_qp = hns_roce_u_v1_modify_qp,
+	.destroy_qp = hns_roce_u_v1_destroy_qp,
 };
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index c9324dd..0b8f444 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -38,11 +38,19 @@
 #include <sys/mman.h>
 #include <fcntl.h>
 #include <unistd.h>
-
+#include <ccan/minmax.h>
 #include "hns_roce_u.h"
 #include "hns_roce_u_abi.h"
 #include "hns_roce_u_hw_v1.h"
 
+void hns_roce_init_qp_indices(struct hns_roce_qp *qp)
+{
+	qp->sq.head = 0;
+	qp->sq.tail = 0;
+	qp->rq.head = 0;
+	qp->rq.tail = 0;
+}
+
 int hns_roce_u_query_device(struct ibv_context *context,
 			    struct ibv_device_attr *attr)
 {
@@ -163,6 +171,29 @@ static int align_cq_size(int req)
 	return nent;
 }
 
+static int align_qp_size(int req)
+{
+	int nent;
+
+	for (nent = HNS_ROCE_MIN_WQE_NUM; nent < req; nent <<= 1)
+		;
+
+	return nent;
+}
+
+static void hns_roce_set_sq_sizes(struct hns_roce_qp *qp,
+				  struct ibv_qp_cap *cap, enum ibv_qp_type type)
+{
+	struct hns_roce_context *ctx = to_hr_ctx(qp->ibv_qp.context);
+
+	qp->sq.max_gs = 2;
+	cap->max_send_sge = min(ctx->max_sge, qp->sq.max_gs);
+	qp->sq.max_post = min(ctx->max_qp_wr, qp->sq.wqe_cnt);
+	cap->max_send_wr = qp->sq.max_post;
+	qp->max_inline_data  = 32;
+	cap->max_inline_data = qp->max_inline_data;
+}
+
 static int hns_roce_verify_cq(int *cqe, struct hns_roce_context *context)
 {
 	if (*cqe < HNS_ROCE_MIN_CQE_NUM) {
@@ -189,6 +220,17 @@ static int hns_roce_alloc_cq_buf(struct hns_roce_device *dev,
 	return 0;
 }
 
+static void hns_roce_calc_sq_wqe_size(struct ibv_qp_cap *cap,
+				      enum ibv_qp_type type,
+				      struct hns_roce_qp *qp)
+{
+	int size = sizeof(struct hns_roce_rc_send_wqe);
+
+	for (qp->sq.wqe_shift = 6; 1 << qp->sq.wqe_shift < size;
+	     qp->sq.wqe_shift++)
+		;
+}
+
 struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 				    struct ibv_comp_channel *channel,
 				    int comp_vector)
@@ -266,3 +308,218 @@ int hns_roce_u_destroy_cq(struct ibv_cq *cq)
 
 	return ret;
 }
+
+static int hns_roce_verify_qp(struct ibv_qp_init_attr *attr,
+			      struct hns_roce_context *context)
+{
+	if (attr->cap.max_send_wr < HNS_ROCE_MIN_WQE_NUM) {
+		fprintf(stderr,
+			"max_send_wr = %d, less than minimum WQE number.\n",
+			attr->cap.max_send_wr);
+		attr->cap.max_send_wr = HNS_ROCE_MIN_WQE_NUM;
+	}
+
+	if (attr->cap.max_recv_wr < HNS_ROCE_MIN_WQE_NUM) {
+		fprintf(stderr,
+			"max_recv_wr = %d, less than minimum WQE number.\n",
+			attr->cap.max_recv_wr);
+		attr->cap.max_recv_wr = HNS_ROCE_MIN_WQE_NUM;
+	}
+
+	if (attr->cap.max_recv_sge < 1)
+		attr->cap.max_recv_sge = 1;
+	if (attr->cap.max_send_wr > context->max_qp_wr ||
+	    attr->cap.max_recv_wr > context->max_qp_wr ||
+	    attr->cap.max_send_sge > context->max_sge  ||
+	    attr->cap.max_recv_sge > context->max_sge)
+		return -1;
+
+	if ((attr->qp_type != IBV_QPT_RC) && (attr->qp_type != IBV_QPT_UD))
+		return -1;
+
+	if ((attr->qp_type == IBV_QPT_RC) &&
+	    (attr->cap.max_inline_data > HNS_ROCE_RC_WQE_INLINE_DATA_MAX_LEN))
+		return -1;
+
+	if (attr->qp_type == IBV_QPT_UC)
+		return -1;
+
+	return 0;
+}
+
+static int hns_roce_alloc_qp_buf(struct ibv_pd *pd, struct ibv_qp_cap *cap,
+				 enum ibv_qp_type type, struct hns_roce_qp *qp)
+{
+	qp->sq.wrid =
+		(unsigned long *)malloc(qp->sq.wqe_cnt * sizeof(uint64_t));
+	if (!qp->sq.wrid)
+		return -1;
+
+	if (qp->rq.wqe_cnt) {
+		qp->rq.wrid = malloc(qp->rq.wqe_cnt * sizeof(uint64_t));
+		if (!qp->rq.wrid) {
+			free(qp->sq.wrid);
+			return -1;
+		}
+	}
+
+	for (qp->rq.wqe_shift = 4;
+	     1 << qp->rq.wqe_shift < sizeof(struct hns_roce_rc_send_wqe);
+	     qp->rq.wqe_shift++)
+		;
+
+	qp->buf_size = align((qp->sq.wqe_cnt << qp->sq.wqe_shift), 0x1000) +
+		      (qp->rq.wqe_cnt << qp->rq.wqe_shift);
+
+	if (qp->rq.wqe_shift > qp->sq.wqe_shift) {
+		qp->rq.offset = 0;
+		qp->sq.offset = qp->rq.wqe_cnt << qp->rq.wqe_shift;
+	} else {
+		qp->rq.offset = align((qp->sq.wqe_cnt << qp->sq.wqe_shift),
+				       0x1000);
+		qp->sq.offset = 0;
+	}
+
+	if (hns_roce_alloc_buf(&qp->buf, align(qp->buf_size, 0x1000),
+			       to_hr_dev(pd->context->device)->page_size)) {
+		free(qp->sq.wrid);
+		free(qp->rq.wrid);
+		return -1;
+	}
+
+	memset(qp->buf.buf, 0, qp->buf_size);
+
+	return 0;
+}
+
+static int hns_roce_store_qp(struct hns_roce_context *ctx, uint32_t qpn,
+			     struct hns_roce_qp *qp)
+{
+	int tind = (qpn & (ctx->num_qps - 1)) >> ctx->qp_table_shift;
+
+	if (!ctx->qp_table[tind].refcnt) {
+		ctx->qp_table[tind].table = calloc(ctx->qp_table_mask + 1,
+						  sizeof(struct hns_roce_qp *));
+		if (!ctx->qp_table[tind].table)
+			return -1;
+	}
+
+	++ctx->qp_table[tind].refcnt;
+	ctx->qp_table[tind].table[qpn & ctx->qp_table_mask] = qp;
+
+	return 0;
+}
+
+struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
+				    struct ibv_qp_init_attr *attr)
+{
+	int ret;
+	struct hns_roce_qp *qp = NULL;
+	struct hns_roce_create_qp cmd;
+	struct ibv_create_qp_resp resp;
+	struct hns_roce_context *context = to_hr_ctx(pd->context);
+
+	if (hns_roce_verify_qp(attr, context)) {
+		fprintf(stderr, "hns_roce_verify_sizes failed!\n");
+		return NULL;
+	}
+
+	qp = malloc(sizeof(*qp));
+	if (!qp) {
+		fprintf(stderr, "malloc failed!\n");
+		return NULL;
+	}
+
+	hns_roce_calc_sq_wqe_size(&attr->cap, attr->qp_type, qp);
+	qp->sq.wqe_cnt = align_qp_size(attr->cap.max_send_wr);
+	qp->rq.wqe_cnt = align_qp_size(attr->cap.max_recv_wr);
+
+	if (hns_roce_alloc_qp_buf(pd, &attr->cap, attr->qp_type, qp)) {
+		fprintf(stderr, "hns_roce_alloc_qp_buf failed!\n");
+		goto err;
+	}
+
+	hns_roce_init_qp_indices(qp);
+
+	if (pthread_spin_init(&qp->sq.lock, PTHREAD_PROCESS_PRIVATE) ||
+	    pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE)) {
+		fprintf(stderr, "pthread_spin_init failed!\n");
+		goto err_free;
+	}
+
+	cmd.buf_addr = (uintptr_t) qp->buf.buf;
+	cmd.log_sq_stride = qp->sq.wqe_shift;
+	for (cmd.log_sq_bb_count = 0; qp->sq.wqe_cnt > 1 << cmd.log_sq_bb_count;
+	     ++cmd.log_sq_bb_count)
+		;
+
+	memset(cmd.reserved, 0, sizeof(cmd.reserved));
+
+	pthread_mutex_lock(&to_hr_ctx(pd->context)->qp_table_mutex);
+
+	ret = ibv_cmd_create_qp(pd, &qp->ibv_qp, attr, &cmd.ibv_cmd,
+				sizeof(cmd), &resp, sizeof(resp));
+	if (ret) {
+		fprintf(stderr, "ibv_cmd_create_qp failed!\n");
+		goto err_rq_db;
+	}
+
+	ret = hns_roce_store_qp(to_hr_ctx(pd->context), qp->ibv_qp.qp_num, qp);
+	if (ret) {
+		fprintf(stderr, "hns_roce_store_qp failed!\n");
+		goto err_destroy;
+	}
+	pthread_mutex_unlock(&to_hr_ctx(pd->context)->qp_table_mutex);
+
+	qp->rq.wqe_cnt = attr->cap.max_recv_wr;
+	qp->rq.max_gs	= attr->cap.max_recv_sge;
+
+	/* adjust rq maxima to not exceed reported device maxima */
+	attr->cap.max_recv_wr = min(context->max_qp_wr, attr->cap.max_recv_wr);
+	attr->cap.max_recv_sge = min(context->max_sge, attr->cap.max_recv_sge);
+
+	qp->rq.max_post = attr->cap.max_recv_wr;
+	hns_roce_set_sq_sizes(qp, &attr->cap, attr->qp_type);
+
+	qp->sq_signal_bits = attr->sq_sig_all ? 0 : 1;
+
+	return &qp->ibv_qp;
+
+err_destroy:
+	ibv_cmd_destroy_qp(&qp->ibv_qp);
+
+err_rq_db:
+	pthread_mutex_unlock(&to_hr_ctx(pd->context)->qp_table_mutex);
+
+err_free:
+	free(qp->sq.wrid);
+	if (qp->rq.wqe_cnt)
+		free(qp->rq.wrid);
+	hns_roce_free_buf(&qp->buf);
+
+err:
+	free(qp);
+
+	return NULL;
+}
+
+int hns_roce_u_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
+			int attr_mask, struct ibv_qp_init_attr *init_attr)
+{
+	int ret;
+	struct ibv_query_qp cmd;
+	struct hns_roce_qp *qp = to_hr_qp(ibqp);
+
+	ret = ibv_cmd_query_qp(ibqp, attr, attr_mask, init_attr, &cmd,
+			       sizeof(cmd));
+	if (ret)
+		return ret;
+
+	init_attr->cap.max_send_wr = qp->sq.max_post;
+	init_attr->cap.max_send_sge = qp->sq.max_gs;
+	init_attr->cap.max_inline_data = qp->max_inline_data;
+
+	attr->cap = init_attr->cap;
+
+	return ret;
+}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
