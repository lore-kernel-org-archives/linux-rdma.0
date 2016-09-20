From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 19/19] IB/hns: Fix for removal of redundant code
Date: Tue, 20 Sep 2016 17:07:12 +0100
Message-ID: <20160920160712.1190216-20-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

This patch removes the redundant code lines present in the
functions get_send_wqe() and get_recv_wqe(). This also fixes
the error in calculating the SQ WQE.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
PATCH V1: This has been create to address the Leon
          Romanovsky's comment provided in below patches:
	  Link: https://lkml.org/lkml/2016/9/15/117
	  Link: https://lkml.org/lkml/2016/9/13/54
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |  3 ++-
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 18 ------------------
 2 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index d52eeda..71232e5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1552,7 +1552,8 @@ static int hns_roce_v1_poll_one(struct hns_roce_cq *hr_cq,
 		/* SQ conrespond to CQE */
 		sq_wqe = get_send_wqe(*cur_qp, roce_get_field(cqe->cqe_byte_4,
 						CQE_BYTE_4_WQE_INDEX_M,
-						CQE_BYTE_4_WQE_INDEX_S));
+						CQE_BYTE_4_WQE_INDEX_S)&
+						((*cur_qp)->sq.wqe_cnt-1));
 		switch (sq_wqe->flag & HNS_ROCE_WQE_OPCODE_MASK) {
 		case HNS_ROCE_WQE_OPCODE_SEND:
 			wc->opcode = IB_WC_SEND;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 6a38909..e86dd8d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -784,29 +784,11 @@ static void *get_wqe(struct hns_roce_qp *hr_qp, int offset)
 
 void *get_recv_wqe(struct hns_roce_qp *hr_qp, int n)
 {
-	struct ib_qp *ibqp = &hr_qp->ibqp;
-	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
-
-	if ((n < 0) || (n > hr_qp->rq.wqe_cnt)) {
-		dev_err(&hr_dev->pdev->dev, "rq wqe index:%d,rq wqe cnt:%d\r\n",
-			n, hr_qp->rq.wqe_cnt);
-		return NULL;
-	}
-
 	return get_wqe(hr_qp, hr_qp->rq.offset + (n << hr_qp->rq.wqe_shift));
 }
 
 void *get_send_wqe(struct hns_roce_qp *hr_qp, int n)
 {
-	struct ib_qp *ibqp = &hr_qp->ibqp;
-	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
-
-	if ((n < 0) || (n > hr_qp->sq.wqe_cnt)) {
-		dev_err(&hr_dev->pdev->dev, "sq wqe index:%d,sq wqe cnt:%d\r\n",
-			n, hr_qp->sq.wqe_cnt);
-		return NULL;
-	}
-
 	return get_wqe(hr_qp, hr_qp->sq.offset + (n << hr_qp->sq.wqe_shift));
 }
 
-- 
1.9.1
