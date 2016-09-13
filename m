From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 7/9] IB/hns: Fix the bug of rdma cm connecting on user mode
Date: Tue, 13 Sep 2016 20:49:28 +0100
Message-ID: <20160913194930.273964-8-salil.mehta@huawei.com>
References: <20160913194930.273964-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913194930.273964-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

Fix bug of modify qp from init to init on user mode. Otherwise,
it will oops when rmda cm established.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 41 ++++++++++--------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 581e542..206957b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2395,35 +2395,22 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	if (cur_state == IB_QPS_INIT && new_state == IB_QPS_INIT) {
 		/* Memory barrier */
 		wmb();
-		if (hr_qp->ibqp.qp_type == IB_QPT_GSI) {
-			/* SW update GSI rq header */
-			reg_val = roce_read(hr_dev, ROCEE_QP1C_CFG3_0_REG +
-					    QP1C_CFGN_OFFSET * hr_qp->phy_port);
-			roce_set_field(reg_val,
-				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_M,
-				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_S,
-				       hr_qp->rq.head);
-			roce_write(hr_dev, ROCEE_QP1C_CFG3_0_REG +
-				   QP1C_CFGN_OFFSET * hr_qp->phy_port, reg_val);
-		} else {
-			rq_db.u32_4 = 0;
-			rq_db.u32_8 = 0;
 
-			roce_set_field(rq_db.u32_4, RQ_DOORBELL_U32_4_RQ_HEAD_M,
-				       RQ_DOORBELL_U32_4_RQ_HEAD_S,
-				       hr_qp->rq.head);
-			roce_set_field(rq_db.u32_8, RQ_DOORBELL_U32_8_QPN_M,
-				       RQ_DOORBELL_U32_8_QPN_S, hr_qp->qpn);
-			roce_set_field(rq_db.u32_8, RQ_DOORBELL_U32_8_CMD_M,
-				       RQ_DOORBELL_U32_8_CMD_S, 1);
-			roce_set_bit(rq_db.u32_8, RQ_DOORBELL_U32_8_HW_SYNC_S,
-				     1);
-
-			doorbell[0] = rq_db.u32_4;
-			doorbell[1] = rq_db.u32_8;
-
-			hns_roce_write64_k(doorbell, hr_qp->rq.db_reg_l);
+		roce_set_field(doorbell[0], RQ_DOORBELL_U32_4_RQ_HEAD_M,
+			       RQ_DOORBELL_U32_4_RQ_HEAD_S, hr_qp->rq.head);
+		roce_set_field(doorbell[1], RQ_DOORBELL_U32_8_QPN_M,
+			       RQ_DOORBELL_U32_8_QPN_S, hr_qp->qpn);
+		roce_set_field(doorbell[1], RQ_DOORBELL_U32_8_CMD_M,
+			       RQ_DOORBELL_U32_8_CMD_S, 1);
+		roce_set_bit(doorbell[1], RQ_DOORBELL_U32_8_HW_SYNC_S, 1);
+
+		if (ibqp->uobject) {
+			hr_qp->rq.db_reg_l = hr_dev->reg_base +
+				     ROCEE_DB_OTHERS_L_0_REG +
+				     DB_REG_OFFSET * hr_dev->priv_uar.index;
 		}
+
+		hns_roce_write64_k(doorbell, hr_qp->rq.db_reg_l);
 	}
 
 	hr_qp->state = new_state;
-- 
1.9.1
