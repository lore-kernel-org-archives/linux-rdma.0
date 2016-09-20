From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 12/19] IB/hns: The Ack timeout need a lower limit value
Date: Tue, 20 Sep 2016 17:07:05 +0100
Message-ID: <20160920160712.1190216-13-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, Dongdong Huang <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

The Ack timeout of qpc need a lower limit value,otherwise
the read performance will be very lower.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 1205d1a..5110a18 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2410,10 +2410,19 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 			       QP_CONTEXT_QPC_BYTES_156_RETRY_COUNT_INIT_M,
 			       QP_CONTEXT_QPC_BYTES_156_RETRY_COUNT_INIT_S,
 			       attr->retry_cnt);
-		roce_set_field(context->qpc_bytes_156,
-			       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_M,
-			       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_S,
-			       attr->timeout);
+		if (attr->timeout < 0x12) {
+			dev_info(dev, "ack timeout value(0x%x) must bigger than 0x12.\n",
+				 attr->timeout);
+			roce_set_field(context->qpc_bytes_156,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_M,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_S,
+				       0x12);
+		} else {
+			roce_set_field(context->qpc_bytes_156,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_M,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_S,
+				       attr->timeout);
+		}
 		roce_set_field(context->qpc_bytes_156,
 			       QP_CONTEXT_QPC_BYTES_156_RNR_RETRY_COUNT_INIT_M,
 			       QP_CONTEXT_QPC_BYTES_156_RNR_RETRY_COUNT_INIT_S,
-- 
1.9.1
