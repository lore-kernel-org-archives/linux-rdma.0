From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 2/5] libhns: Introduce QP operations refered to hip08 RoCE device
Date: Tue, 17 Oct 2017 21:12:23 +0800
Message-ID: <1508245946-145697-3-git-send-email-oulijun@huawei.com>
References: <1508245946-145697-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508245946-145697-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

QP APIs need to operate doorbell and cqe. the definition of
doorbell and cqe in The different hardware is discrepant.
Hence, This patch introduces the QP operations of hip08
RoCE hardware.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/hns_roce_u_hw_v2.c | 190 +++++++++++++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_hw_v2.h | 136 ++++++++++++++++++++++++++++
 providers/hns/hns_roce_u_verbs.c |  31 ++++---
 3 files changed, 344 insertions(+), 13 deletions(-)
 create mode 100644 providers/hns/hns_roce_u_hw_v2.h

diff --git a/providers/hns/hns_roce_u_hw_v2.c b/providers/hns/hns_roce_u_hw_v2.c
index a580bad..bf1c3f3 100644
--- a/providers/hns/hns_roce_u_hw_v2.c
+++ b/providers/hns/hns_roce_u_hw_v2.c
@@ -35,7 +35,197 @@
 #include <malloc.h>
 #include "hns_roce_u.h"
 #include "hns_roce_u_db.h"
+#include "hns_roce_u_hw_v2.h"
+
+static struct hns_roce_v2_cqe *get_cqe_v2(struct hns_roce_cq *cq, int entry)
+{
+	return cq->buf.buf + entry * HNS_ROCE_CQE_ENTRY_SIZE;
+}
+
+static void *get_sw_cqe_v2(struct hns_roce_cq *cq, int n)
+{
+	struct hns_roce_v2_cqe *cqe = get_cqe_v2(cq, n & cq->ibv_cq.cqe);
+
+	return (!!(roce_get_bit(cqe->byte_4, CQE_BYTE_4_OWNER_S)) ^
+		!!(n & (cq->ibv_cq.cqe + 1))) ? cqe : NULL;
+}
+
+static void hns_roce_v2_update_cq_cons_index(struct hns_roce_context *ctx,
+					     struct hns_roce_cq *cq)
+{
+	struct hns_roce_v2_cq_db cq_db;
+
+	cq_db.byte_4 = 0;
+	cq_db.parameter = 0;
+
+	roce_set_field(cq_db.byte_4, DB_BYTE_4_TAG_M, DB_BYTE_4_TAG_S, cq->cqn);
+	roce_set_field(cq_db.byte_4, DB_BYTE_4_CMD_M, DB_BYTE_4_CMD_S, 0x3);
+
+	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CQ_CONSUMER_IDX_M,
+		       CQ_DB_PARAMETER_CQ_CONSUMER_IDX_S,
+		       cq->cons_index & ((cq->cq_depth << 1) - 1));
+	roce_set_field(cq_db.parameter, CQ_DB_PARAMETER_CMD_SN_M,
+		       CQ_DB_PARAMETER_CMD_SN_S, 1);
+	roce_set_bit(cq_db.parameter, CQ_DB_PARAMETER_NOTIFY_S, 0);
+
+	hns_roce_write64((uint32_t *)&cq_db, ctx, ROCEE_VF_DB_CFG0_OFFSET);
+}
+
+static void hns_roce_v2_clear_qp(struct hns_roce_context *ctx, uint32_t qpn)
+{
+	int tind = (qpn & (ctx->num_qps - 1)) >> ctx->qp_table_shift;
+
+	if (!--ctx->qp_table[tind].refcnt)
+		free(ctx->qp_table[tind].table);
+	else
+		ctx->qp_table[tind].table[qpn & ctx->qp_table_mask] = NULL;
+}
+
+static void __hns_roce_v2_cq_clean(struct hns_roce_cq *cq, uint32_t qpn,
+				   struct hns_roce_srq *srq)
+{
+	int nfreed = 0;
+	uint32_t prod_index;
+	uint8_t owner_bit = 0;
+	struct hns_roce_v2_cqe *cqe, *dest;
+	struct hns_roce_context *ctx = to_hr_ctx(cq->ibv_cq.context);
+
+	for (prod_index = cq->cons_index; get_sw_cqe_v2(cq, prod_index);
+	     ++prod_index)
+		if (prod_index == cq->cons_index + cq->ibv_cq.cqe)
+			break;
+
+	while ((int) --prod_index - (int) cq->cons_index >= 0) {
+		cqe = get_cqe_v2(cq, prod_index & cq->ibv_cq.cqe);
+		if ((roce_get_field(cqe->byte_16, CQE_BYTE_16_LCL_QPN_M,
+			      CQE_BYTE_16_LCL_QPN_S) & 0xffffff) == qpn) {
+			++nfreed;
+		} else if (nfreed) {
+			dest = get_cqe_v2(cq,
+				       (prod_index + nfreed) & cq->ibv_cq.cqe);
+			owner_bit = roce_get_bit(dest->byte_4,
+						 CQE_BYTE_4_OWNER_S);
+			memcpy(dest, cqe, sizeof(*cqe));
+			roce_set_bit(dest->byte_4, CQE_BYTE_4_OWNER_S,
+				     owner_bit);
+		}
+	}
+
+	if (nfreed) {
+		cq->cons_index += nfreed;
+		udma_to_device_barrier();
+		hns_roce_v2_update_cq_cons_index(ctx, cq);
+	}
+}
+
+static void hns_roce_v2_cq_clean(struct hns_roce_cq *cq, unsigned int qpn,
+				 struct hns_roce_srq *srq)
+{
+	pthread_spin_lock(&cq->lock);
+	__hns_roce_v2_cq_clean(cq, qpn, srq);
+	pthread_spin_unlock(&cq->lock);
+}
+
+static int hns_roce_u_v2_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
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
+		hns_roce_v2_cq_clean(to_hr_cq(qp->recv_cq), qp->qp_num,
+				     qp->srq ? to_hr_srq(qp->srq) : NULL);
+		if (qp->send_cq != qp->recv_cq)
+			hns_roce_v2_cq_clean(to_hr_cq(qp->send_cq), qp->qp_num,
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
+static int hns_roce_u_v2_destroy_qp(struct ibv_qp *ibqp)
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
+	__hns_roce_v2_cq_clean(to_hr_cq(ibqp->recv_cq), ibqp->qp_num,
+			       ibqp->srq ? to_hr_srq(ibqp->srq) : NULL);
+
+	if (ibqp->send_cq != ibqp->recv_cq)
+		__hns_roce_v2_cq_clean(to_hr_cq(ibqp->send_cq), ibqp->qp_num,
+				       NULL);
+
+	hns_roce_v2_clear_qp(to_hr_ctx(ibqp->context), ibqp->qp_num);
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
 
 struct hns_roce_u_hw hns_roce_u_hw_v2 = {
 	.hw_version = HNS_ROCE_HW_VER2,
+	.modify_qp = hns_roce_u_v2_modify_qp,
+	.destroy_qp = hns_roce_u_v2_destroy_qp,
 };
diff --git a/providers/hns/hns_roce_u_hw_v2.h b/providers/hns/hns_roce_u_hw_v2.h
new file mode 100644
index 0000000..d7fcf94
--- /dev/null
+++ b/providers/hns/hns_roce_u_hw_v2.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2016-2017 Hisilicon Limited.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef _HNS_ROCE_U_HW_V2_H
+#define _HNS_ROCE_U_HW_V2_H
+
+/* V2 REG DEFINITION */
+#define ROCEE_VF_DB_CFG0_OFFSET			0x0230
+
+struct hns_roce_db {
+	unsigned int	byte_4;
+	unsigned int	parameter;
+};
+#define DB_BYTE_4_TAG_S 0
+#define DB_BYTE_4_TAG_M   (((1UL << 23) - 1) << DB_BYTE_4_TAG_S)
+
+#define DB_BYTE_4_CMD_S 24
+#define DB_BYTE_4_CMD_M   (((1UL << 4) - 1) << DB_BYTE_4_CMD_S)
+
+#define DB_PARAM_SQ_PRODUCER_IDX_S 0
+#define DB_PARAM_SQ_PRODUCER_IDX_M \
+	(((1UL << 16) - 1) << DB_PARAM_SQ_PRODUCER_IDX_S)
+
+#define DB_PARAM_RQ_PRODUCER_IDX_S 0
+#define DB_PARAM_RQ_PRODUCER_IDX_M \
+	(((1UL << 16) - 1) << DB_PARAM_RQ_PRODUCER_IDX_S)
+
+#define DB_PARAM_SRQ_PRODUCER_COUNTER_S 0
+#define DB_PARAM_SRQ_PRODUCER_COUNTER_M \
+	(((1UL << 16) - 1) << DB_PARAM_SRQ_PRODUCER_COUNTER_S)
+
+#define DB_PARAM_SL_S 16
+#define DB_PARAM_SL_M \
+	(((1UL << 3) - 1) << DB_PARAM_SL_S)
+
+struct hns_roce_v2_cq_db {
+	unsigned int	byte_4;
+	unsigned int	parameter;
+};
+
+#define CQ_DB_BYTE_4_TAG_S 0
+#define CQ_DB_BYTE_4_TAG_M   (((1UL << 23) - 1) << CQ_DB_BYTE_4_TAG_S)
+
+#define CQ_DB_BYTE_4_CMD_S 24
+#define CQ_DB_BYTE_4_CMD_M   (((1UL << 4) - 1) << CQ_DB_BYTE_4_CMD_S)
+
+#define CQ_DB_PARAMETER_CQ_CONSUMER_IDX_S 0
+#define CQ_DB_PARAMETER_CQ_CONSUMER_IDX_M \
+	(((1UL << 24) - 1) << CQ_DB_PARAMETER_CQ_CONSUMER_IDX_S)
+
+#define CQ_DB_PARAMETER_NOTIFY_S 24
+
+#define CQ_DB_PARAMETER_CMD_SN_S 25
+#define CQ_DB_PARAMETER_CMD_SN_M \
+	(((1UL << 2) - 1) << CQ_DB_PARAMETER_CMD_SN_S)
+
+struct hns_roce_v2_cqe {
+	unsigned int	byte_4;
+	unsigned int	rkey_immtdata;
+	unsigned int	byte_12;
+	unsigned int	byte_16;
+	unsigned int	byte_cnt;
+	unsigned int	smac;
+	unsigned int	byte_28;
+	unsigned int	byte_32;
+};
+
+#define CQE_BYTE_4_OPCODE_S 0
+#define CQE_BYTE_4_OPCODE_M   (((1UL << 5) - 1) << CQE_BYTE_4_OPCODE_S)
+
+#define CQE_BYTE_4_RQ_INLINE_S 5
+
+#define CQE_BYTE_4_S_R_S 6
+#define CQE_BYTE_4_OWNER_S 7
+
+#define CQE_BYTE_4_STATUS_S 8
+#define CQE_BYTE_4_STATUS_M   (((1UL << 8) - 1) << CQE_BYTE_4_STATUS_S)
+
+#define CQE_BYTE_4_WQE_IDX_S 16
+#define CQE_BYTE_4_WQE_IDX_M   (((1UL << 16) - 1) << CQE_BYTE_4_WQE_IDX_S)
+
+#define CQE_BYTE_12_XRC_SRQN_S 0
+#define CQE_BYTE_12_XRC_SRQN_M   (((1UL << 24) - 1) << CQE_BYTE_12_XRC_SRQN_S)
+
+#define CQE_BYTE_16_LCL_QPN_S 0
+#define CQE_BYTE_16_LCL_QPN_M   (((1UL << 24) - 1) << CQE_BYTE_16_LCL_QPN_S)
+
+#define CQE_BYTE_28_SMAC_S 0
+#define CQE_BYTE_28_SMAC_M   (((1UL << 16) - 1) << CQE_BYTE_28_SMAC_S)
+
+#define CQE_BYTE_28_PORT_TYPE_S 16
+#define CQE_BYTE_28_PORT_TYPE_M   (((1UL << 2) - 1) << CQE_BYTE_28_PORT_TYPE_S)
+
+#define CQE_BYTE_32_RMT_QPN_S 0
+#define CQE_BYTE_32_RMT_QPN_M   (((1UL << 24) - 1) << CQE_BYTE_32_RMT_QPN_S)
+
+#define CQE_BYTE_32_SL_S 24
+#define CQE_BYTE_32_SL_M   (((1UL << 3) - 1) << CQE_BYTE_32_SL_S)
+
+#define CQE_BYTE_32_PORTN_S 27
+#define CQE_BYTE_32_PORTN_M   (((1UL << 3) - 1) << CQE_BYTE_32_PORTN_S)
+
+#define CQE_BYTE_32_GLH_S 30
+
+#define CQE_BYTE_32_LPK_S 31
+
+#endif /* _HNS_ROCE_U_HW_V2_H */
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 0b8f444..8f6c666 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2016 Hisilicon Limited.
+ * Copyright (c) 2016-2017 Hisilicon Limited.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -42,6 +42,7 @@
 #include "hns_roce_u.h"
 #include "hns_roce_u_abi.h"
 #include "hns_roce_u_hw_v1.h"
+#include "hns_roce_u_hw_v2.h"
 
 void hns_roce_init_qp_indices(struct hns_roce_qp *qp)
 {
@@ -272,7 +273,7 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
 		cq->set_ci_db = to_hr_ctx(context)->cq_tptr_base + cq->cqn * 2;
 	else
 		cq->set_ci_db = to_hr_ctx(context)->uar +
-				ROCEE_DB_OTHERS_L_0_REG;
+				ROCEE_VF_DB_CFG0_OFFSET;
 
 	cq->arm_db    = cq->set_ci_db;
 	cq->arm_sn    = 1;
@@ -312,18 +313,22 @@ int hns_roce_u_destroy_cq(struct ibv_cq *cq)
 static int hns_roce_verify_qp(struct ibv_qp_init_attr *attr,
 			      struct hns_roce_context *context)
 {
-	if (attr->cap.max_send_wr < HNS_ROCE_MIN_WQE_NUM) {
-		fprintf(stderr,
-			"max_send_wr = %d, less than minimum WQE number.\n",
-			attr->cap.max_send_wr);
-		attr->cap.max_send_wr = HNS_ROCE_MIN_WQE_NUM;
-	}
+	struct hns_roce_device *hr_dev = to_hr_dev(context->ibv_ctx.device);
+
+	if (hr_dev->hw_version == HNS_ROCE_HW_VER1) {
+		if (attr->cap.max_send_wr < HNS_ROCE_MIN_WQE_NUM) {
+			fprintf(stderr,
+				"max_send_wr = %d, less than minimum WQE number.\n",
+				attr->cap.max_send_wr);
+				attr->cap.max_send_wr = HNS_ROCE_MIN_WQE_NUM;
+		}
 
-	if (attr->cap.max_recv_wr < HNS_ROCE_MIN_WQE_NUM) {
-		fprintf(stderr,
-			"max_recv_wr = %d, less than minimum WQE number.\n",
-			attr->cap.max_recv_wr);
-		attr->cap.max_recv_wr = HNS_ROCE_MIN_WQE_NUM;
+		if (attr->cap.max_recv_wr < HNS_ROCE_MIN_WQE_NUM) {
+			fprintf(stderr,
+				"max_recv_wr = %d, less than minimum WQE number.\n",
+				attr->cap.max_recv_wr);
+				attr->cap.max_recv_wr = HNS_ROCE_MIN_WQE_NUM;
+		}
 	}
 
 	if (attr->cap.max_recv_sge < 1)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
