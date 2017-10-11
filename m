From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 18/45] IB/hns: Annotate iomem pointers correctly
Date: Wed, 11 Oct 2017 10:49:00 -0700
Message-ID: <20171011174927.25113-19-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that sparse complains that there is an address
space mismatch.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_eq.c    | 6 +++---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 9 +++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_eq.c b/drivers/infiniband/hw/hns/hns_roce_eq.c
index b0f43735de1a..d184431e2bf5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_eq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_eq.c
@@ -558,7 +558,7 @@ static int hns_roce_create_eq(struct hns_roce_dev *hr_dev,
 	writel(eqshift_val, eqc);
 
 	/* Configure eq extended address 12~44bit */
-	writel((u32)(eq->buf_list[0].map >> 12), (u8 *)eqc + 4);
+	writel((u32)(eq->buf_list[0].map >> 12), eqc + 4);
 
 	/*
 	 * Configure eq extended address 45~49 bit.
@@ -572,13 +572,13 @@ static int hns_roce_create_eq(struct hns_roce_dev *hr_dev,
 	roce_set_field(eqcuridx_val,
 		       ROCEE_CAEP_AEQE_CUR_IDX_CAEP_AEQE_CUR_IDX_M,
 		       ROCEE_CAEP_AEQE_CUR_IDX_CAEP_AEQE_CUR_IDX_S, 0);
-	writel(eqcuridx_val, (u8 *)eqc + 8);
+	writel(eqcuridx_val, eqc + 8);
 
 	/* Configure eq consumer index */
 	roce_set_field(eqconsindx_val,
 		       ROCEE_CAEP_AEQE_CONS_IDX_CAEP_AEQE_CONS_IDX_M,
 		       ROCEE_CAEP_AEQE_CONS_IDX_CAEP_AEQE_CONS_IDX_S, 0);
-	writel(eqconsindx_val, (u8 *)eqc + 0xc);
+	writel(eqconsindx_val, eqc + 0xc);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 852db18ec128..187241484fa1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1639,7 +1639,7 @@ static int hns_roce_v1_post_mbox(struct hns_roce_dev *hr_dev, u64 in_param,
 				 u64 out_param, u32 in_modifier, u8 op_modifier,
 				 u16 op, u16 token, int event)
 {
-	u32 *hcr = (u32 *)(hr_dev->reg_base + ROCEE_MB1_REG);
+	u32 __iomem *hcr = (u32 __iomem *)(hr_dev->reg_base + ROCEE_MB1_REG);
 	unsigned long end;
 	u32 val = 0;
 
@@ -2534,7 +2534,7 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	int rq_pa_start;
 	u32 reg_val;
 	u64 *mtts;
-	u32 *addr;
+	u32 __iomem *addr;
 
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
@@ -2616,8 +2616,9 @@ static int hns_roce_v1_m_sqp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 			       QP1C_BYTES_40_SQ_CUR_IDX_S, 0);
 
 		/* Copy context to QP1C register */
-		addr = (u32 *)(hr_dev->reg_base + ROCEE_QP1C_CFG0_0_REG +
-			hr_qp->phy_port * sizeof(*context));
+		addr = (u32 __iomem *)(hr_dev->reg_base +
+				       ROCEE_QP1C_CFG0_0_REG +
+				       hr_qp->phy_port * sizeof(*context));
 
 		writel(context->qp1c_bytes_4, addr);
 		writel(context->sq_rq_bt_l, addr + 1);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b99d70aa1120..ff61f30a82c2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -976,7 +976,8 @@ static int hns_roce_v2_post_mbox(struct hns_roce_dev *hr_dev, u64 in_param,
 				 u16 op, u16 token, int event)
 {
 	struct device *dev = hr_dev->dev;
-	u32 *hcr = (u32 *)(hr_dev->reg_base + ROCEE_VF_MB_CFG0_REG);
+	u32 __iomem *hcr = (u32 __iomem *)(hr_dev->reg_base +
+					   ROCEE_VF_MB_CFG0_REG);
 	unsigned long end;
 	u32 val0 = 0;
 	u32 val1 = 0;
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
