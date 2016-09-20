From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 11/19] IB/hns: Return bad wr while post send failed
Date: Tue, 20 Sep 2016 17:07:04 +0100
Message-ID: <20160920160712.1190216-12-salil.mehta@huawei.com>
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

While post failed, hns roce should return the wr failed to user.
We omitted this while qp type is wrong and fixed it.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
PATCH V2: Addressed commnets by Leon Romanovsky
          Link: https://lkml.org/lkml/2016/9/15/98
PATCH V1: Initial submit
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 65c3192..1205d1a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -73,8 +73,14 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	u32 ind = 0;
 	int ret = 0;
 
-	spin_lock_irqsave(&qp->sq.lock, flags);
+	if (unlikely(ibqp->qp_type != IB_QPT_GSI &&
+		ibqp->qp_type != IB_QPT_RC)) {
+		dev_err(dev, "un-supported QP type\n");
+		*bad_wr = NULL;
+		return -EOPNOTSUPP;
+	}
 
+	spin_lock_irqsave(&qp->sq.lock, flags);
 	ind = qp->sq_next_wqe;
 	for (nreq = 0; wr; ++nreq, wr = wr->next) {
 		if (hns_roce_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq)) {
@@ -263,9 +269,6 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					      HNS_ROCE_WQE_SGE_NUM_BIT);
 			}
 			ind++;
-		} else {
-			dev_dbg(dev, "unSupported QP type\n");
-			break;
 		}
 	}
 
-- 
1.9.1
