From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 03/20] IB/hns: Add the check for pointer ctrl
Date: Fri, 9 Sep 2016 18:30:34 +0800
Message-ID: <1473417051-99560-4-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, xuwei5@hisilicon.com, mehta.salil.lnk@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

The pointer ctrl may be null, so we add check for it.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 5f76fc1..ea47ec4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -336,6 +336,12 @@ int hns_roce_v1_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		}
 
 		ctrl = get_recv_wqe(hr_qp, ind);
+		if (unlikely(!ctrl)) {
+			dev_err(dev, "Get recv wqe failed!\n");
+			ret = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
 
 		roce_set_field(ctrl->rwqe_byte_12,
 			       RQ_WQE_CTRL_RWQE_BYTE_12_RWQE_SGE_NUM_M,
-- 
1.7.9.5
