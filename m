From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: [PATCH V2 for-next 4/8] RDMA/hns: Set mask for destination qp field of qp context assignment
Date: Fri, 29 Sep 2017 23:10:10 +0800
Message-ID: <1506697814-98432-5-git-send-email-xavier.huwei@huawei.com>
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

When only set IB_QP_DEST_QPN flag for attr_mask, the operation of
assigning the dest_qp_num for dest_qp field of qp context is valid.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Shaobo Xu <xushaobo2@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 6f309f7..10d828c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2888,10 +2888,11 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 			       QP_CONTEXT_QPC_BYTES_32_RESPONDER_RESOURCES_S,
 			       ilog2((unsigned int)attr->max_dest_rd_atomic));
 
-		roce_set_field(context->qpc_bytes_36,
-			       QP_CONTEXT_QPC_BYTES_36_DEST_QP_M,
-			       QP_CONTEXT_QPC_BYTES_36_DEST_QP_S,
-			       attr->dest_qp_num);
+		if (attr_mask & IB_QP_DEST_QPN)
+			roce_set_field(context->qpc_bytes_36,
+				       QP_CONTEXT_QPC_BYTES_36_DEST_QP_M,
+				       QP_CONTEXT_QPC_BYTES_36_DEST_QP_S,
+				       attr->dest_qp_num);
 
 		/* Configure GID index */
 		port_num = rdma_ah_get_port_num(&attr->ah_attr);
-- 
1.9.1
