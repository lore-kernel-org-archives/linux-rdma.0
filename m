From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 07/11] {topost} RDMA/hns: Update the usage of ack timeout in hip08
Date: Fri, 10 Nov 2017 16:55:49 +0800
Message-ID: <1510304153-91394-8-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ack timeout's value in qp context shall be a 5-bit value
and be assgined by users. When at of qpc is set zero, the
timer is disabled.

When attr_mask set for IB_QP_TIMEOUT, The ack timeout field
is effective.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ee2d832..d74a522 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2725,15 +2725,12 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
 	roce_set_field(qpc_mask->byte_212_lsn, V2_QPC_BYTE_212_LSN_M,
 		       V2_QPC_BYTE_212_LSN_S, 0);
 
-	if (attr->timeout < 0xf)
-		roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_AT_M,
-			       V2_QPC_BYTE_28_AT_S, 0xf);
-	else
+	if (attr_mask & IB_QP_TIMEOUT) {
 		roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_AT_M,
 			       V2_QPC_BYTE_28_AT_S, attr->timeout);
-
-	roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_AT_M,
-		       V2_QPC_BYTE_28_AT_S, 0);
+		roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_AT_M,
+			      V2_QPC_BYTE_28_AT_S, 0);
+	}
 
 	roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
 		       V2_QPC_BYTE_28_SL_S,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
