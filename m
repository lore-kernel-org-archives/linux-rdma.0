From: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 for-next 1/2] RDMA/hns: Add detailed comments for mb() call
Date: Fri, 29 Dec 2017 19:26:18 +0800
Message-ID: <1514546779-206832-2-git-send-email-liuyixian@huawei.com>
References: <1514546779-206832-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514546779-206832-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds more detailed comments when we call the
memory barrier function, such as rmb, wmb and mb. Three
mb() callers are deleted since they are unnecessary.

Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
v3 -> v4:
1. Delete two mb() call since they are unnecessary.
v3:
1. Subsitute rmb() with dma_rmb() according to Jason's comment,
   since using dma_rmb() is enough.
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 19 ++++++++++++-------
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 26 ++++++++++----------------
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 6100ace..73f187e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -3963,8 +3963,6 @@ static void set_eq_cons_index_v1(struct hns_roce_eq *eq, int req_not)
 {
 	roce_raw_write((eq->cons_index & HNS_ROCE_V1_CONS_IDX_M) |
 		      (req_not << eq->log_entries), eq->doorbell);
-	/* Memory barrier */
-	mb();
 }
 
 static void hns_roce_v1_wq_catas_err_handle(struct hns_roce_dev *hr_dev,
@@ -4156,13 +4154,16 @@ static int hns_roce_v1_aeq_int(struct hns_roce_dev *hr_dev,
 	int event_type;
 
 	while ((aeqe = next_aeqe_sw_v1(eq))) {
+
+		/* Make sure we read the AEQ entry after we have checked the
+		 * ownership bit
+		 */
+		dma_rmb();
+
 		dev_dbg(dev, "aeqe = %p, aeqe->asyn.event_type = 0x%lx\n", aeqe,
 			roce_get_field(aeqe->asyn,
 				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
 				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
-		/* Memory barrier */
-		rmb();
-
 		event_type = roce_get_field(aeqe->asyn,
 					    HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
 					    HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S);
@@ -4260,8 +4261,12 @@ static int hns_roce_v1_ceq_int(struct hns_roce_dev *hr_dev,
 	u32 cqn;
 
 	while ((ceqe = next_ceqe_sw_v1(eq))) {
-		/* Memory barrier */
-		rmb();
+
+		/* Make sure we read CEQ entry after we have checked the
+		 * ownership bit
+		 */
+		dma_rmb();
+
 		cqn = roce_get_field(ceqe->comp,
 				     HNS_ROCE_CEQE_CEQE_COMP_CQN_M,
 				     HNS_ROCE_CEQE_CEQE_COMP_CQN_S);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 04281d0..68dc718 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3199,10 +3199,6 @@ static void set_eq_cons_index_v2(struct hns_roce_eq *eq)
 		       (eq->cons_index & HNS_ROCE_V2_CONS_IDX_M));
 
 	hns_roce_write64_k(doorbell, eq->doorbell);
-
-	/* Memory barrier */
-	mb();
-
 }
 
 static void hns_roce_v2_wq_catas_err_handle(struct hns_roce_dev *hr_dev,
@@ -3384,8 +3380,11 @@ static int hns_roce_v2_aeq_int(struct hns_roce_dev *hr_dev,
 	int event_type;
 
 	while ((aeqe = next_aeqe_sw_v2(eq))) {
-		/* Memory barrier */
-		rmb();
+
+		/* Make sure we read AEQ entry after we have checked the
+		 * ownership bit
+		 */
+		dma_rmb();
 
 		event_type = roce_get_field(aeqe->asyn,
 					    HNS_ROCE_V2_AEQE_EVENT_TYPE_M,
@@ -3500,8 +3499,11 @@ static int hns_roce_v2_ceq_int(struct hns_roce_dev *hr_dev,
 
 	while ((ceqe = next_ceqe_sw_v2(eq))) {
 
-		/* Memory barrier */
-		rmb();
+		/* Make sure we read CEQ entry after we have checked the
+		 * ownership bit
+		 */
+		dma_rmb();
+
 		cqn = roce_get_field(ceqe->comp,
 				     HNS_ROCE_V2_CEQE_COMP_CQN_M,
 				     HNS_ROCE_V2_CEQE_COMP_CQN_S);
@@ -3556,9 +3558,6 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 		roce_set_bit(int_st, HNS_ROCE_V2_VF_INT_ST_AEQ_OVERFLOW_S, 1);
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG, int_st);
 
-		/* Memory barrier */
-		mb();
-
 		roce_set_bit(int_en, HNS_ROCE_V2_VF_ABN_INT_EN_S, 1);
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG, int_en);
 
@@ -3569,9 +3568,6 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 		roce_set_bit(int_st, HNS_ROCE_V2_VF_INT_ST_BUS_ERR_S, 1);
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG, int_st);
 
-		/* Memory barrier */
-		mb();
-
 		roce_set_bit(int_en, HNS_ROCE_V2_VF_ABN_INT_EN_S, 1);
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG, int_en);
 
@@ -3582,8 +3578,6 @@ static irqreturn_t hns_roce_v2_msix_interrupt_abn(int irq, void *dev_id)
 		roce_set_bit(int_st, HNS_ROCE_V2_VF_INT_ST_OTHER_ERR_S, 1);
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_ST_REG, int_st);
 
-		/* Memory barrier */
-		mb();
 		roce_set_bit(int_en, HNS_ROCE_V2_VF_ABN_INT_EN_S, 1);
 		roce_write(hr_dev, ROCEE_VF_ABN_INT_EN_REG, int_en);
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
