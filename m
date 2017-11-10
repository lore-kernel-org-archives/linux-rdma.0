From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 08/11] {topost} RDMA/hns: Add sq_invld_flg field in QP context
Date: Fri, 10 Nov 2017 16:55:50 +0800
Message-ID: <1510304153-91394-9-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In hip08 RoCE, it need to add the sq_invld_flg field
in QP context for RoCE hardware.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d74a522..c1f3325 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2042,6 +2042,8 @@ static void modify_qp_reset_to_init(struct ib_qp *ibqp,
 
 	roce_set_bit(qpc_mask->byte_168_irrl_idx,
 		     V2_QPC_BYTE_168_MSG_RTY_LP_FLG_S, 0);
+	roce_set_bit(qpc_mask->byte_168_irrl_idx,
+		     V2_QPC_BYTE_168_SQ_INVLD_FLG_S, 0);
 	roce_set_field(qpc_mask->byte_168_irrl_idx,
 		       V2_QPC_BYTE_168_IRRL_IDX_LSB_M,
 		       V2_QPC_BYTE_168_IRRL_IDX_LSB_S, 0);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 3d9114e..04b7a51 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -606,8 +606,10 @@ struct hns_roce_v2_qp_context {
 
 #define V2_QPC_BYTE_168_MSG_RTY_LP_FLG_S 20
 
-#define	V2_QPC_BYTE_168_LP_SGEN_INI_S 21
-#define V2_QPC_BYTE_168_LP_SGEN_INI_M GENMASK(23, 21)
+#define V2_QPC_BYTE_168_SQ_INVLD_FLG_S 21
+
+#define	V2_QPC_BYTE_168_LP_SGEN_INI_S 22
+#define V2_QPC_BYTE_168_LP_SGEN_INI_M GENMASK(23, 22)
 
 #define	V2_QPC_BYTE_168_SQ_SHIFT_BAK_S 24
 #define V2_QPC_BYTE_168_SQ_SHIFT_BAK_M GENMASK(27, 24)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
