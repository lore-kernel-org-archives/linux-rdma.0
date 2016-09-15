From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V3 for-next 4/9] IB/hns: Fix two possible bugs for rdma cm
Date: Thu, 15 Sep 2016 23:48:09 +0100
Message-ID: <20160915224814.656184-5-salil.mehta@huawei.com>
References: <20160915224814.656184-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160915224814.656184-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

Fix the length of wqe that maybe lead to an error and
write the end bytes of QP1C into the register.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 399f5de..aaea95c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -205,8 +205,7 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				      (wr->send_flags & IB_SEND_FENCE ?
 				      (cpu_to_le32(HNS_ROCE_WQE_FENCE)) : 0);
 
-			wqe = (struct hns_roce_wqe_ctrl_seg *)wqe +
-			       sizeof(struct hns_roce_wqe_ctrl_seg);
+			wqe += sizeof(struct hns_roce_wqe_ctrl_seg);
 
 			switch (wr->opcode) {
 			case IB_WR_RDMA_READ:
@@ -235,8 +234,7 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				break;
 			}
 			ctrl->flag |= cpu_to_le32(ps_opcode);
-			wqe = (struct hns_roce_wqe_raddr_seg *)wqe +
-			       sizeof(struct hns_roce_wqe_raddr_seg);
+			wqe += sizeof(struct hns_roce_wqe_raddr_seg);
 
 			dseg = wqe;
 			if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
@@ -253,8 +251,7 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					memcpy(wqe, ((void *) (uintptr_t)
 					       wr->sg_list[i].addr),
 					       wr->sg_list[i].length);
-					wqe = (struct hns_roce_wqe_raddr_seg *)
-					       wqe + wr->sg_list[i].length;
+					wqe += wr->sg_list[i].length;
 				}
 				ctrl->flag |= HNS_ROCE_WQE_INLINE;
 			} else {
@@ -1795,6 +1792,7 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		writel(context->qp1c_bytes_28, addr + 6);
 		writel(context->qp1c_bytes_32, addr + 7);
 		writel(context->cur_sq_wqe_ba_l, addr + 8);
+		writel(context->qp1c_bytes_40, addr + 9);
 	}
 
 	/* Modify QP1C status */
-- 
1.9.1
