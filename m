From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 15/20] IB/hns: Some items of qpc need to take user param
Date: Fri, 9 Sep 2016 18:30:46 +0800
Message-ID: <1473417051-99560-16-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, "Dongdong Huang(Donald)" <hdd.huang@huawei.com>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

Some items of qpc need to take user param when modified qp
state.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 836a2af..bdd9453 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2414,10 +2414,12 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_S, 0);
 		roce_set_field(context->qpc_bytes_148,
 			       QP_CONTEXT_QPC_BYTES_148_RETRY_COUNT_M,
-			       QP_CONTEXT_QPC_BYTES_148_RETRY_COUNT_S, 0);
+			       QP_CONTEXT_QPC_BYTES_148_RETRY_COUNT_S,
+			       attr->retry_cnt);
 		roce_set_field(context->qpc_bytes_148,
 			       QP_CONTEXT_QPC_BYTES_148_RNR_RETRY_COUNT_M,
-			       QP_CONTEXT_QPC_BYTES_148_RNR_RETRY_COUNT_S, 0);
+			       QP_CONTEXT_QPC_BYTES_148_RNR_RETRY_COUNT_S,
+			       attr->rnr_retry);
 		roce_set_field(context->qpc_bytes_148,
 			       QP_CONTEXT_QPC_BYTES_148_LSN_M,
 			       QP_CONTEXT_QPC_BYTES_148_LSN_S, 0x100);
-- 
1.7.9.5
