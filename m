From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 09/11] {topost} RDMA/hns: Set the owner field of SQWQE in hip08 RoCE
Date: Fri, 10 Nov 2017 16:55:51 +0800
Message-ID: <1510304153-91394-10-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

the owner need to be set when posting sqwqe in hip08 RoCE.
The owner be used according to the below algorithm:
The value of owner should be 1 in the first lap, it
should be 0 in the second lap and in turn.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c1f3325..7008fa3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -62,6 +62,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	struct hns_roce_v2_db sq_db;
 	unsigned int sge_ind = 0;
 	unsigned int wqe_sz = 0;
+	unsigned int owner_bit;
 	unsigned long flags;
 	unsigned int ind;
 	void *wqe = NULL;
@@ -104,6 +105,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		qp->sq.wrid[(qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1)] =
 								      wr->wr_id;
 
+		owner_bit = ~(qp->sq.head >> ilog2(qp->sq.wqe_cnt)) & 0x1;
 		rc_sq_wqe = wqe;
 		memset(rc_sq_wqe, 0, sizeof(*rc_sq_wqe));
 		for (i = 0; i < wr->num_sge; i++)
@@ -120,6 +122,9 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_CQE_S,
 			    (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
 
+		roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_OWNER_S,
+			     owner_bit);
+
 		switch (wr->opcode) {
 		case IB_WR_RDMA_READ:
 			roce_set_field(rc_sq_wqe->byte_4,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
