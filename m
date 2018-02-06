From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/3] RDMA/hns: Fix QP state judgement before receiving work requests
Date: Tue, 6 Feb 2018 20:34:18 +0800
Message-ID: <1517920459-93900-3-git-send-email-oulijun@huawei.com>
References: <1517920459-93900-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517920459-93900-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The QP can accept receive work requests only when the QP is
in the states that allow them to be submitted.

This patch updates the QP state judgement based on the
specification.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index db2ff35..0aa7483 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -509,7 +509,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	spin_lock_irqsave(&hr_qp->rq.lock, flags);
 	ind = hr_qp->rq.head & (hr_qp->rq.wqe_cnt - 1);
 
-	if (hr_qp->state == IB_QPS_RESET || hr_qp->state == IB_QPS_ERR) {
+	if (hr_qp->state == IB_QPS_RESET) {
 		spin_unlock_irqrestore(&hr_qp->rq.lock, flags);
 		*bad_wr = wr;
 		return -EINVAL;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
