From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH for-next 1/9] RDMA/hns: Modify the value with rd&dest_rd of qp_attr
Date: Thu, 28 Sep 2017 12:57:26 +0800
Message-ID: <1506574654-56699-2-git-send-email-xavier.huwei@huawei.com>
References: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506574654-56699-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, xavier.huwei@tom.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

The value of max_rd_atomic and max_dest_rd_atomic in query_qp
are incorrect. It should be assigned by left shifting of
the bit in hip06 SoC.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 426f55a..6e9acfd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3484,10 +3484,10 @@ static int hns_roce_v1_q_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 			      QP_CONTEXT_QPC_BYTES_12_P_KEY_INDEX_S);
 	qp_attr->port_num = hr_qp->port + 1;
 	qp_attr->sq_draining = 0;
-	qp_attr->max_rd_atomic = roce_get_field(context->qpc_bytes_156,
+	qp_attr->max_rd_atomic = 1 << roce_get_field(context->qpc_bytes_156,
 				 QP_CONTEXT_QPC_BYTES_156_INITIATOR_DEPTH_M,
 				 QP_CONTEXT_QPC_BYTES_156_INITIATOR_DEPTH_S);
-	qp_attr->max_dest_rd_atomic = roce_get_field(context->qpc_bytes_32,
+	qp_attr->max_dest_rd_atomic = 1 << roce_get_field(context->qpc_bytes_32,
 				 QP_CONTEXT_QPC_BYTES_32_RESPONDER_RESOURCES_M,
 				 QP_CONTEXT_QPC_BYTES_32_RESPONDER_RESOURCES_S);
 	qp_attr->min_rnr_timer = (u8)(roce_get_field(context->qpc_bytes_24,
-- 
1.9.1
