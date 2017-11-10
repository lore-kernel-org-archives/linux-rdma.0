From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 01/11] {topost} RDMA/hns: Update calculation of irrl_ba field for hip08
Date: Fri, 10 Nov 2017 16:55:43 +0800
Message-ID: <1510304153-91394-2-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The irrl(initiator RDMA Read/Atomic list) base address of qp
context is assigned for addr[63:6]. This patch mainly fixed
it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 3b0cf55..a950f78 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2393,11 +2393,11 @@ static int modify_qp_init_to_rtr(struct ib_qp *ibqp,
 		       V2_QPC_BYTE_108_RX_REQ_EPSN_M,
 		       V2_QPC_BYTE_108_RX_REQ_EPSN_S, 0);
 
-	context->irrl_ba = (u32)dma_handle_2;
+	context->irrl_ba = (u32)(dma_handle_2 >> 6);
 	qpc_mask->irrl_ba = 0;
 	roce_set_field(context->byte_208_irrl, V2_QPC_BYTE_208_IRRL_BA_M,
 		       V2_QPC_BYTE_208_IRRL_BA_S,
-		      (dma_handle_2 >> 32) & V2_QPC_BYTE_208_IRRL_BA_M);
+		       dma_handle_2 >> (32 + 6));
 	roce_set_field(qpc_mask->byte_208_irrl, V2_QPC_BYTE_208_IRRL_BA_M,
 		       V2_QPC_BYTE_208_IRRL_BA_S, 0);
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
