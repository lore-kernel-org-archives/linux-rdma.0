From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 04/11] {topost} RDMA/hns: Set se attribute of sqwqe in hip08
Date: Fri, 10 Nov 2017 16:55:46 +0800
Message-ID: <1510304153-91394-5-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When send flags is IB_SEND_SOLICITED, the se(solicated event)
field of sqwqe will be set.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 049a0df..f261544 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -114,6 +114,9 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_FENCE_S,
 			    (wr->send_flags & IB_SEND_FENCE) ? 1 : 0);
 
+		roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_SE_S,
+			    (wr->send_flags & IB_SEND_SOLICITED) ? 1 : 0);
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
