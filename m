From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 14/20] IB/hns: The Ack timeout need a lower limit value
Date: Fri, 9 Sep 2016 18:30:45 +0800
Message-ID: <1473417051-99560-15-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Dongdong Huang(Donald)" <hdd.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The Ack timeout of qpc need a lower limit value,otherwise
the read performance will be very lower.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index e3e154c..836a2af 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2428,10 +2428,19 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 			       QP_CONTEXT_QPC_BYTES_156_RETRY_COUNT_INIT_M,
 			       QP_CONTEXT_QPC_BYTES_156_RETRY_COUNT_INIT_S,
 			       attr->retry_cnt);
-		roce_set_field(context->qpc_bytes_156,
-			       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_M,
-			       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_S,
-			       attr->timeout);
+		if (attr->timeout < 0x12) {
+			dev_info(dev, "ack timeout value(0x%x) must bigger than 0x12.\n",
+				 attr->timeout);
+			roce_set_field(context->qpc_bytes_156,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_M,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_S,
+				       0x12);
+		} else {
+			roce_set_field(context->qpc_bytes_156,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_M,
+				       QP_CONTEXT_QPC_BYTES_156_ACK_TIMEOUT_S,
+				       attr->timeout);
+		}
 		roce_set_field(context->qpc_bytes_156,
 			       QP_CONTEXT_QPC_BYTES_156_RNR_RETRY_COUNT_INIT_M,
 			       QP_CONTEXT_QPC_BYTES_156_RNR_RETRY_COUNT_INIT_S,
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
