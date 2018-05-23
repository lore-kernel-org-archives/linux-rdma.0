From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 rdma-next 4/4] RDMA/hns: Fix the illegal memory operation when cross page
Date: Wed, 23 May 2018 18:16:30 +0800
Message-ID: <1527070590-94399-5-git-send-email-xavier.huwei@huawei.com>
References: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch fixed the potential illegal operation when using the
extend sge buffer cross page in post send operation. The bug
will cause the calltrace.

Reported-by: Jie Chen <chenjie103@huawei.com>
Reported-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
Fixes: b1c158350968("RDMA/hns: Get rid of virt_to_page and vmap calls after dma_alloc_coherent")
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>

---
v1->v2: Modify the Fixes statement according to Leon's comment.
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 70 +++++++++++++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  1 +
 2 files changed, 51 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a70d07b..62c1eb5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -52,6 +52,52 @@ static void set_data_seg_v2(struct hns_roce_v2_wqe_data_seg *dseg,
 	dseg->len  = cpu_to_le32(sg->length);
 }
 
+static void set_extend_sge(struct hns_roce_qp *qp, struct ib_send_wr *wr,
+			   unsigned int *sge_ind)
+{
+	struct hns_roce_v2_wqe_data_seg *dseg;
+	struct ib_sge *sg;
+	int num_in_wqe = 0;
+	int extend_sge_num;
+	int fi_sge_num;
+	int se_sge_num;
+	int shift;
+	int i;
+
+	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC)
+		num_in_wqe = HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE;
+	extend_sge_num = wr->num_sge - num_in_wqe;
+	sg = wr->sg_list + num_in_wqe;
+	shift = qp->hr_buf.page_shift;
+
+	/*
+	 * Check whether wr->num_sge sges are in the same page. If not, we
+	 * should calculate how many sges in the first page and the second
+	 * page.
+	 */
+	dseg = get_send_extend_sge(qp, (*sge_ind) & (qp->sge.sge_cnt - 1));
+	fi_sge_num = (((((u64)dseg >> shift) + 1) << shift) - (u64)dseg) /
+		      sizeof(struct hns_roce_v2_wqe_data_seg);
+	if (extend_sge_num > fi_sge_num) {
+		se_sge_num = extend_sge_num - fi_sge_num;
+		for (i = 0; i < fi_sge_num; i++) {
+			set_data_seg_v2(dseg++, sg + i);
+			(*sge_ind)++;
+		}
+		dseg = get_send_extend_sge(qp,
+					   (*sge_ind) & (qp->sge.sge_cnt - 1));
+		for (i = 0; i < se_sge_num; i++) {
+			set_data_seg_v2(dseg++, sg + fi_sge_num + i);
+			(*sge_ind)++;
+		}
+	} else {
+		for (i = 0; i < extend_sge_num; i++) {
+			set_data_seg_v2(dseg++, sg + i);
+			(*sge_ind)++;
+		}
+	}
+}
+
 static int set_rwqe_data_seg(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			     struct hns_roce_v2_rc_send_wqe *rc_sq_wqe,
 			     void *wqe, unsigned int *sge_ind,
@@ -85,7 +131,7 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_INLINE_S,
 			     1);
 	} else {
-		if (wr->num_sge <= 2) {
+		if (wr->num_sge <= HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE) {
 			for (i = 0; i < wr->num_sge; i++) {
 				if (likely(wr->sg_list[i].length)) {
 					set_data_seg_v2(dseg, wr->sg_list + i);
@@ -98,24 +144,14 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				     V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
 				     (*sge_ind) & (qp->sge.sge_cnt - 1));
 
-			for (i = 0; i < 2; i++) {
+			for (i = 0; i < HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE; i++) {
 				if (likely(wr->sg_list[i].length)) {
 					set_data_seg_v2(dseg, wr->sg_list + i);
 					dseg++;
 				}
 			}
 
-			dseg = get_send_extend_sge(qp,
-					    (*sge_ind) & (qp->sge.sge_cnt - 1));
-
-			for (i = 0; i < wr->num_sge - 2; i++) {
-				if (likely(wr->sg_list[i + 2].length)) {
-					set_data_seg_v2(dseg,
-							wr->sg_list + 2 + i);
-					dseg++;
-					(*sge_ind)++;
-				}
-			}
+			set_extend_sge(qp, wr, sge_ind);
 		}
 
 		roce_set_field(rc_sq_wqe->byte_16,
@@ -318,13 +354,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			memcpy(&ud_sq_wqe->dgid[0], &ah->av.dgid[0],
 			       GID_LEN_V2);
 
-			dseg = get_send_extend_sge(qp,
-					    sge_ind & (qp->sge.sge_cnt - 1));
-			for (i = 0; i < wr->num_sge; i++) {
-				set_data_seg_v2(dseg + i, wr->sg_list + i);
-				sge_ind++;
-			}
-
+			set_extend_sge(qp, wr, &sge_ind);
 			ind++;
 		} else if (ibqp->qp_type == IB_QPT_RC) {
 			rc_sq_wqe = wqe;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index f16df1b..97f9bef 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -77,6 +77,7 @@
 #define HNS_ROCE_V2_MAX_INNER_MTPT_NUM		2
 #define HNS_ROCE_INVALID_LKEY			0x100
 #define HNS_ROCE_CMQ_TX_TIMEOUT			30000
+#define HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE	2
 
 #define HNS_ROCE_CONTEXT_HOP_NUM		1
 #define HNS_ROCE_MTT_HOP_NUM			1
-- 
1.9.1
