From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 8/9] IB/hns: Fix two bugs for rdma cm connecting
Date: Tue, 13 Sep 2016 20:49:29 +0100
Message-ID: <20160913194930.273964-9-salil.mehta@huawei.com>
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

This patch mainly modify the value of HNS_ROCE_SL_SHIFT
and delete the lines for assigning for the field of
local_enable_e2e_credit in QP1C.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 833742b..066bb3e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -62,7 +62,7 @@
 #define HNS_ROCE_AEQE_OF_VEC_NUM		1
 
 /* 4G/4K = 1M */
-#define HNS_ROCE_SL_SHIFT			29
+#define HNS_ROCE_SL_SHIFT			28
 #define HNS_ROCE_TCLASS_SHIFT			20
 #define HNS_ROCE_FLOW_LABLE_MASK		0xfffff
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 206957b..3feac8a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1734,9 +1734,6 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		roce_set_bit(context->qp1c_bytes_16,
 			     QP1C_BYTES_16_SIGNALING_TYPE_S,
 			     hr_qp->sq_signal_bits);
-		roce_set_bit(context->qp1c_bytes_16,
-			     QP1C_BYTES_16_LOCAL_ENABLE_E2E_CREDIT_S,
-			     hr_qp->sq_signal_bits);
 		roce_set_bit(context->qp1c_bytes_16, QP1C_BYTES_16_RQ_BA_FLG_S,
 			     1);
 		roce_set_bit(context->qp1c_bytes_16, QP1C_BYTES_16_SQ_BA_FLG_S,
-- 
1.9.1
