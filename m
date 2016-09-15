From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 for-next 7/9] IB/hns: Fix the bug of rdma cm connecting on user mode
Date: Thu, 15 Sep 2016 23:48:12 +0100
Message-ID: <20160915224814.656184-8-salil.mehta@huawei.com>
References: <20160915224814.656184-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915224814.656184-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Fix bug of modify qp from init to init on user mode. Otherwise,
it will oops when rmda cm established.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
PATCH V3: Fixed compilation break reported by kbuild
          Link: https://lkml.org/lkml/2016/9/14/54
PATCH V1/V2: Initial Version
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  | 43 ++++++++++-------------------
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  1 -
 3 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 833742b..e8d2734 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -76,6 +76,7 @@
 #define PKEY_ID					0xffff
 #define GUID_LEN				8
 #define NODE_DESC_SIZE				64
+#define DB_REG_OFFSET				0x1000
 
 #define SERV_TYPE_RC				0
 #define SERV_TYPE_RD				1
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 581e542..110efd3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1834,12 +1834,10 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_qp_context *context;
-	struct hns_roce_rq_db rq_db;
 	dma_addr_t dma_handle_2 = 0;
 	dma_addr_t dma_handle = 0;
 	uint32_t doorbell[2] = {0};
 	int rq_pa_start = 0;
-	u32 reg_val = 0;
 	u64 *mtts_2 = NULL;
 	int ret = -EINVAL;
 	u64 *mtts = NULL;
@@ -2395,35 +2393,22 @@ static int hns_roce_v1_m_qp(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	if (cur_state == IB_QPS_INIT && new_state == IB_QPS_INIT) {
 		/* Memory barrier */
 		wmb();
-		if (hr_qp->ibqp.qp_type == IB_QPT_GSI) {
-			/* SW update GSI rq header */
-			reg_val = roce_read(hr_dev, ROCEE_QP1C_CFG3_0_REG +
-					    QP1C_CFGN_OFFSET * hr_qp->phy_port);
-			roce_set_field(reg_val,
-				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_M,
-				       ROCEE_QP1C_CFG3_0_ROCEE_QP1C_RQ_HEAD_S,
-				       hr_qp->rq.head);
-			roce_write(hr_dev, ROCEE_QP1C_CFG3_0_REG +
-				   QP1C_CFGN_OFFSET * hr_qp->phy_port, reg_val);
-		} else {
-			rq_db.u32_4 = 0;
-			rq_db.u32_8 = 0;
 
-			roce_set_field(rq_db.u32_4, RQ_DOORBELL_U32_4_RQ_HEAD_M,
-				       RQ_DOORBELL_U32_4_RQ_HEAD_S,
-				       hr_qp->rq.head);
-			roce_set_field(rq_db.u32_8, RQ_DOORBELL_U32_8_QPN_M,
-				       RQ_DOORBELL_U32_8_QPN_S, hr_qp->qpn);
-			roce_set_field(rq_db.u32_8, RQ_DOORBELL_U32_8_CMD_M,
-				       RQ_DOORBELL_U32_8_CMD_S, 1);
-			roce_set_bit(rq_db.u32_8, RQ_DOORBELL_U32_8_HW_SYNC_S,
-				     1);
-
-			doorbell[0] = rq_db.u32_4;
-			doorbell[1] = rq_db.u32_8;
-
-			hns_roce_write64_k(doorbell, hr_qp->rq.db_reg_l);
+		roce_set_field(doorbell[0], RQ_DOORBELL_U32_4_RQ_HEAD_M,
+			       RQ_DOORBELL_U32_4_RQ_HEAD_S, hr_qp->rq.head);
+		roce_set_field(doorbell[1], RQ_DOORBELL_U32_8_QPN_M,
+			       RQ_DOORBELL_U32_8_QPN_S, hr_qp->qpn);
+		roce_set_field(doorbell[1], RQ_DOORBELL_U32_8_CMD_M,
+			       RQ_DOORBELL_U32_8_CMD_S, 1);
+		roce_set_bit(doorbell[1], RQ_DOORBELL_U32_8_HW_SYNC_S, 1);
+
+		if (ibqp->uobject) {
+			hr_qp->rq.db_reg_l = hr_dev->reg_base +
+				     ROCEE_DB_OTHERS_L_0_REG +
+				     DB_REG_OFFSET * hr_dev->priv_uar.index;
 		}
+
+		hns_roce_write64_k(doorbell, hr_qp->rq.db_reg_l);
 	}
 
 	hr_qp->state = new_state;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 089da7f..dd94e41 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -38,7 +38,6 @@
 #include "hns_roce_hem.h"
 #include "hns_roce_user.h"
 
-#define DB_REG_OFFSET			0x1000
 #define SQP_NUM				12
 
 void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type)
-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
