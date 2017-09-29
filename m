From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 for-next 5/8] RDMA/hns: Set rdma_ah_attr type for querying qp
Date: Fri, 29 Sep 2017 23:10:11 +0800
Message-ID: <1506697814-98432-6-git-send-email-xavier.huwei@huawei.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, xavier.huwei@huawei.com, lijun_nudt@163.com, oulijun@huawei.com, charles.chenxin@huawei.com, liuyixian@huawei.com, xushaobo2@huawei.com, zhangxiping3@huawei.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, shaobohsu@163.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

When querying qp, It needs to return RoCE device ah_attr type
that may be specific to RoCE devices.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 10d828c..d82b4de 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3359,6 +3359,7 @@ static int hns_roce_v1_q_sqp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	qp_attr->path_mtu	= IB_MTU_256;
 	qp_attr->path_mig_state	= IB_MIG_ARMED;
 	qp_attr->qkey		= QKEY_VAL;
+	qp_attr->ah_attr.type   = RDMA_AH_ATTR_TYPE_ROCE;
 	qp_attr->rq_psn		= 0;
 	qp_attr->sq_psn		= 0;
 	qp_attr->dest_qp_num	= 1;
@@ -3440,6 +3441,7 @@ static int hns_roce_v1_q_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 					       QP_CONTEXT_QPC_BYTES_48_MTU_M,
 					       QP_CONTEXT_QPC_BYTES_48_MTU_S);
 	qp_attr->path_mig_state = IB_MIG_ARMED;
+	qp_attr->ah_attr.type   = RDMA_AH_ATTR_TYPE_ROCE;
 	if (hr_qp->ibqp.qp_type == IB_QPT_UD)
 		qp_attr->qkey = QKEY_VAL;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index e5fe2cd..2def203 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2831,6 +2831,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 							V2_QPC_BYTE_24_MTU_M,
 							V2_QPC_BYTE_24_MTU_S);
 	qp_attr->path_mig_state = IB_MIG_ARMED;
+	qp_attr->ah_attr.type   = RDMA_AH_ATTR_TYPE_ROCE;
 	if (hr_qp->ibqp.qp_type == IB_QPT_UD)
 		qp_attr->qkey = V2_QKEY_VAL;
 
-- 
1.9.1
