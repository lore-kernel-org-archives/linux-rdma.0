From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH V2 for-4.1 2/9] RDMA/ocrdma: Report EQ full fatal error
Date: Tue, 19 May 2015 11:32:33 +0530
Message-ID: <1432015360-15447-3-git-send-email-selvin.xavier@avagotech.com>
References: <1432015360-15447-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432015360-15447-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Detect when Event Queue (EQ) becomes full and print a warning message.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c  | 6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 3a5ea5af..65759ac 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -933,12 +933,18 @@ static irqreturn_t ocrdma_irq_handler(int irq, void *handle)
 	struct ocrdma_eqe eqe;
 	struct ocrdma_eqe *ptr;
 	u16 cq_id;
+	u8 mcode;
 	int budget = eq->cq_cnt;
 
 	do {
 		ptr = ocrdma_get_eqe(eq);
 		eqe = *ptr;
 		ocrdma_le32_to_cpu(&eqe, sizeof(eqe));
+		mcode = (eqe.id_valid & OCRDMA_EQE_MAJOR_CODE_MASK)
+				>> OCRDMA_EQE_MAJOR_CODE_SHIFT;
+		if (mcode == OCRDMA_MAJOR_CODE_SENTINAL)
+			pr_err("EQ full on eqid = 0x%x, eqe = 0x%x\n",
+			       eq->q.id, eqe.id_valid);
 		if ((eqe.id_valid & OCRDMA_EQE_VALID_MASK) == 0)
 			break;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 243c87c..baf9b8a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1624,12 +1624,19 @@ struct ocrdma_delete_ah_tbl_rsp {
 enum {
 	OCRDMA_EQE_VALID_SHIFT		= 0,
 	OCRDMA_EQE_VALID_MASK		= BIT(0),
+	OCRDMA_EQE_MAJOR_CODE_MASK      = 0x0E,
+	OCRDMA_EQE_MAJOR_CODE_SHIFT     = 0x01,
 	OCRDMA_EQE_FOR_CQE_MASK		= 0xFFFE,
 	OCRDMA_EQE_RESOURCE_ID_SHIFT	= 16,
 	OCRDMA_EQE_RESOURCE_ID_MASK	= 0xFFFF <<
 				OCRDMA_EQE_RESOURCE_ID_SHIFT,
 };
 
+enum major_code {
+	OCRDMA_MAJOR_CODE_COMPLETION    = 0x00,
+	OCRDMA_MAJOR_CODE_SENTINAL      = 0x01
+};
+
 struct ocrdma_eqe {
 	u32 id_valid;
 };
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
