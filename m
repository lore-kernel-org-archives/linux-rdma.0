From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH for-next 13/20] IB/hns: Add check for some NULL pointer scenes
Date: Fri, 9 Sep 2016 18:30:44 +0800
Message-ID: <1473417051-99560-14-git-send-email-salil.mehta@huawei.com>
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

Some pointers have not be checked when they are null,
so we add check for them.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index f0d6315..e3e154c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -92,6 +92,12 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		}
 
 		wqe = get_send_wqe(qp, ind & (qp->sq.wqe_cnt - 1));
+		if (unlikely(!wqe)) {
+			dev_err(dev, "get send wqe failed\n");
+			ret = -EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
 		qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
 								      wr->wr_id;
 
@@ -1558,6 +1564,11 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *hr_cq,
 		sq_wqe = get_send_wqe(*cur_qp, roce_get_field(cqe->cqe_byte_4,
 						CQE_BYTE_4_WQE_INDEX_M,
 						CQE_BYTE_4_WQE_INDEX_S));
+		if (unlikely(!sq_wqe)) {
+			dev_err(dev, "Get send wqe failed!\n");
+			return -EFAULT;
+		}
+
 		switch (sq_wqe->flag & HNS_ROCE_WQE_OPCODE_MASK) {
 		case HNS_ROCE_WQE_OPCODE_SEND:
 			wc->opcode = IB_WC_SEND;
-- 
1.7.9.5
