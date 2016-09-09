From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 20/20] IB/hns: Delete the redundant lines in hns_roce_v1_m_qp()
Date: Fri, 9 Sep 2016 18:30:51 +0800
Message-ID: <1473417051-99560-21-git-send-email-salil.mehta@huawei.com>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473417051-99560-1-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

It doesn't need to assign for the filed of qp state in qpc separately
when qp happen to migrate state which supported in RoCE engine v1.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by:  Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 7a61d7e..3bc32fc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2405,11 +2405,6 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		roce_set_bit(context->qpc_bytes_140,
 			     QP_CONTEXT_QPC_BYTES_140_RNR_RETRY_FLG_S, 0);
 
-		roce_set_field(context->qpc_bytes_144,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
-			       attr->qp_state);
-
 		roce_set_field(context->qpc_bytes_148,
 			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_M,
 			       QP_CONTEXT_QPC_BYTES_148_CHECK_FLAG_S, 0);
@@ -2524,13 +2519,10 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 		   (cur_state == IB_QPS_RTS && new_state == IB_QPS_ERR) ||
 		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_RESET) ||
 		   (cur_state == IB_QPS_ERR && new_state == IB_QPS_ERR)) {
-		roce_set_field(context->qpc_bytes_144,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
-			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S,
-			       attr->qp_state);
-
+		/* It will not do additional options in engine v1 */
+		;
 	} else {
-		dev_err(dev, "not support this modify\n");
+		dev_err(dev, "not support this status migration\n");
 		goto out;
 	}
 
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
