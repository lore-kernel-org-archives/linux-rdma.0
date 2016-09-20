From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 18/19] IB/hns: Delete the redundant lines in hns_roce_v1_m_qp()
Date: Tue, 20 Sep 2016 17:07:11 +0100
Message-ID: <20160920160712.1190216-19-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

It doesn't need to assign for the filed of qp state in qpc separately
when qp happen to migrate state which supported in RoCE engine v1.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
PATCH V2: Addressed comments provided by Leon Romanovsky
          Link: https://lkml.org/lkml/2016/9/15/123
PATCH V1: Initial Submit
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 2070e9e..d52eeda 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2387,11 +2387,6 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		roce_set_bit(context->qpc_bytes_140,
 			     QP_CONTEXT_QPC_BYTES_140_RNR_RETRY_FLG_S, 0);
 
-		roce_set_field(context->qpc_bytes_144,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
-			       attr->qp_state);
-
 		roce_set_field(context->qpc_bytes_148,
 			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_M,
 			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_S, 0);
@@ -2498,21 +2493,15 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 			       QP_CONTEXT_QPC_BYTES_188_TX_RETRY_CUR_INDEX_M,
 			       QP_CONTEXT_QPC_BYTES_188_TX_RETRY_CUR_INDEX_S,
 			       0);
-	} else if ((cur_state == IB_QPS_INIT && new_state == IB_QPS_RESET) ||
+	} else if (!((cur_state == IB_QPS_INIT && new_state == IB_QPS_RESET) ||
 		   (cur_state == IB_QPS_INIT && new_state == IB_QPS_ERR) ||
 		   (cur_state == IB_QPS_RTR && new_state == IB_QPS_RESET) ||
 		   (cur_state == IB_QPS_RTR && new_state == IB_QPS_ERR) ||
 		   (cur_state == IB_QPS_RTS && new_state == IB_QPS_RESET) ||
 		   (cur_state == IB_QPS_RTS && new_state == IB_QPS_ERR) ||
 		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_RESET) ||
-		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_ERR)) {
-		roce_set_field(context->qpc_bytes_144,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
-			       attr->qp_state);
-
-	} else {
-		dev_err(dev, "not support this modify\n");
+		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_ERR))) {
+		dev_err(dev, "not support this status migration\n");
 		goto out;
 	}
 
-- 
1.9.1
