From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 for-next 2/6] RDMA/hns: Update the usage of sr_max and rr_max field
Date: Fri, 29 Dec 2017 17:38:57 +0800
Message-ID: <1514540341-115107-3-git-send-email-oulijun@huawei.com>
References: <1514540341-115107-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514540341-115107-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch fixes the usage with sr_max filed and rr_max of qp
context when modify qp. Its modifications include:
1. Adjust location of filling sr_max filed of qpc
2. Only assign the number of responder resource if
   IB_QP_MAX_DEST_RD_ATOMIC bit is set
3. Only assign the number of outstanding resource if
   IB_QP_MAX_QP_RD_ATOMIC
4. Fix the assgin algorithms for the field of sr_max
   and rr_max of qp context

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 5be4356..3ade767 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2536,11 +2536,14 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		roce_set_bit(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_LBI_S, 0);
 	}
 
-	roce_set_field(context->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
-		       V2_QPC_BYTE_140_RR_MAX_S,
-		       ilog2((unsigned int)attr->max_dest_rd_atomic));
-	roce_set_field(qpc_mask->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
-		       V2_QPC_BYTE_140_RR_MAX_S, 0);
+	if ((attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) &&
+	     attr->max_dest_rd_atomic) {
+		roce_set_field(context->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
+			       V2_QPC_BYTE_140_RR_MAX_S,
+			       fls(attr->max_dest_rd_atomic - 1));
+		roce_set_field(qpc_mask->byte_140_raq, V2_QPC_BYTE_140_RR_MAX_M,
+			       V2_QPC_BYTE_140_RR_MAX_S, 0);
+	}
 
 	roce_set_field(context->byte_56_dqpn_err, V2_QPC_BYTE_56_DQPN_M,
 		       V2_QPC_BYTE_56_DQPN_S, attr->dest_qp_num);
@@ -2630,12 +2633,6 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		       V2_QPC_BYTE_168_LP_SGEN_INI_M,
 		       V2_QPC_BYTE_168_LP_SGEN_INI_S, 0);
 
-	roce_set_field(context->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
-		       V2_QPC_BYTE_208_SR_MAX_S,
-		       ilog2((unsigned int)attr->max_rd_atomic));
-	roce_set_field(qpc_mask->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
-		       V2_QPC_BYTE_208_SR_MAX_S, 0);
-
 	roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
 		       V2_QPC_BYTE_28_SL_S, rdma_ah_get_sl(&attr->ah_attr));
 	roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
@@ -2839,6 +2836,14 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
 	roce_set_field(qpc_mask->byte_196_sq_psn, V2_QPC_BYTE_196_SQ_MAX_PSN_M,
 		       V2_QPC_BYTE_196_SQ_MAX_PSN_S, 0);
 
+	if ((attr_mask & IB_QP_MAX_QP_RD_ATOMIC) && attr->max_rd_atomic) {
+		roce_set_field(context->byte_208_irrl, V2_QPC_BYTE_208_SR_MAX_M,
+			       V2_QPC_BYTE_208_SR_MAX_S,
+			       fls(attr->max_rd_atomic - 1));
+		roce_set_field(qpc_mask->byte_208_irrl,
+			       V2_QPC_BYTE_208_SR_MAX_M,
+			       V2_QPC_BYTE_208_SR_MAX_S, 0);
+	}
 	return 0;
 }
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
