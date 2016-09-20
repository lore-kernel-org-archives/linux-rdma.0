From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 08/19] IB/hns: Optimize code of aeq and ceq interrupt handle and fix the bug of qpn
Date: Tue, 20 Sep 2016 17:07:01 +0100
Message-ID: <20160920160712.1190216-9-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>

This patch optimized the codes of aeq and ceq interrupt handle
and fixed the bug in the calculation of qpn. For the special
qp(GSI or SMI), calculated the qp number according to physical
port and the qpn reported in the event of async event queue.

Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
PATCH V2: Addressed Leon Romanovsky's comment
         Link: https://lkml.org/lkml/2016/9/12/303
PATCH V1: Initial patch
---
 drivers/infiniband/hw/hns/hns_roce_eq.c | 146 ++++++++++++++++----------------
 drivers/infiniband/hw/hns/hns_roce_eq.h |   4 +
 2 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_eq.c b/drivers/infiniband/hw/hns/hns_roce_eq.c
index 98af7fe..21e21b0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_eq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_eq.c
@@ -66,9 +66,6 @@ static void hns_roce_wq_catas_err_handle(struct hns_roce_dev *hr_dev,
 {
 	struct device *dev = &hr_dev->pdev->dev;
 
-	qpn = roce_get_field(aeqe->event.qp_event.qp,
-			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
-			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S);
 	dev_warn(dev, "Local Work Queue Catastrophic Error.\n");
 	switch (roce_get_field(aeqe->asyn, HNS_ROCE_AEQE_U32_4_EVENT_SUB_TYPE_M,
 			       HNS_ROCE_AEQE_U32_4_EVENT_SUB_TYPE_S)) {
@@ -96,13 +93,6 @@ static void hns_roce_wq_catas_err_handle(struct hns_roce_dev *hr_dev,
 	default:
 		break;
 	}
-
-	hns_roce_qp_event(hr_dev, roce_get_field(aeqe->event.qp_event.qp,
-					HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
-					HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S),
-			  roce_get_field(aeqe->asyn,
-					HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-					HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
 }
 
 static void hns_roce_local_wq_access_err_handle(struct hns_roce_dev *hr_dev,
@@ -111,9 +101,6 @@ static void hns_roce_local_wq_access_err_handle(struct hns_roce_dev *hr_dev,
 {
 	struct device *dev = &hr_dev->pdev->dev;
 
-	qpn = roce_get_field(aeqe->event.qp_event.qp,
-			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
-			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S);
 	dev_warn(dev, "Local Access Violation Work Queue Error.\n");
 	switch (roce_get_field(aeqe->asyn, HNS_ROCE_AEQE_U32_4_EVENT_SUB_TYPE_M,
 			       HNS_ROCE_AEQE_U32_4_EVENT_SUB_TYPE_S)) {
@@ -141,13 +128,69 @@ static void hns_roce_local_wq_access_err_handle(struct hns_roce_dev *hr_dev,
 	default:
 		break;
 	}
+}
+
+static void hns_roce_qp_err_handle(struct hns_roce_dev *hr_dev,
+				   struct hns_roce_aeqe *aeqe,
+				   int event_type)
+{
+	struct device *dev = &hr_dev->pdev->dev;
+	int phy_port;
+	int qpn;
+
+	qpn = roce_get_field(aeqe->event.qp_event.qp,
+			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
+			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S);
+	phy_port = roce_get_field(aeqe->event.qp_event.qp,
+			HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_M,
+			HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_S);
+	if (qpn <= 1)
+		qpn = HNS_ROCE_MAX_PORTS * qpn + phy_port;
+
+	switch (event_type) {
+	case HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR:
+		dev_warn(dev, "Invalid Req Local Work Queue Error.\n"
+			      "QP %d, phy_port %d.\n", qpn, phy_port);
+		break;
+	case HNS_ROCE_EVENT_TYPE_WQ_CATAS_ERROR:
+		hns_roce_wq_catas_err_handle(hr_dev, aeqe, qpn);
+		break;
+	case HNS_ROCE_EVENT_TYPE_LOCAL_WQ_ACCESS_ERROR:
+		hns_roce_local_wq_access_err_handle(hr_dev, aeqe, qpn);
+		break;
+	default:
+		break;
+	}
+
+	hns_roce_qp_event(hr_dev, qpn, event_type);
+}
+
+static void hns_roce_cq_err_handle(struct hns_roce_dev *hr_dev,
+				   struct hns_roce_aeqe *aeqe,
+				   int event_type)
+{
+	struct device *dev = &hr_dev->pdev->dev;
+	u32 cqn;
+
+	cqn = le32_to_cpu(roce_get_field(aeqe->event.cq_event.cq,
+		    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M,
+		    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S));
+
+	switch (event_type) {
+	case HNS_ROCE_EVENT_TYPE_CQ_ACCESS_ERROR:
+		dev_warn(dev, "CQ 0x%x access err.\n", cqn);
+		break;
+	case HNS_ROCE_EVENT_TYPE_CQ_OVERFLOW:
+		dev_warn(dev, "CQ 0x%x overflow\n", cqn);
+		break;
+	case HNS_ROCE_EVENT_TYPE_CQ_ID_INVALID:
+		dev_warn(dev, "CQ 0x%x ID invalid.\n", cqn);
+		break;
+	default:
+		break;
+	}
 
-	hns_roce_qp_event(hr_dev, roce_get_field(aeqe->event.qp_event.qp,
-					 HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
-					 HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S),
-			  roce_get_field(aeqe->asyn,
-					 HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-					 HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
+	hns_roce_cq_event(hr_dev, cqn, event_type);
 }
 
 static void hns_roce_db_overflow_handle(struct hns_roce_dev *hr_dev,
@@ -185,7 +228,7 @@ static int hns_roce_aeq_int(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
 	struct device *dev = &hr_dev->pdev->dev;
 	struct hns_roce_aeqe *aeqe;
 	int aeqes_found = 0;
-	int qpn = 0;
+	int event_type;
 
 	while ((aeqe = next_aeqe_sw(eq))) {
 		dev_dbg(dev, "aeqe = %p, aeqe->asyn.event_type = 0x%lx\n", aeqe,
@@ -195,9 +238,10 @@ static int hns_roce_aeq_int(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
 		/* Memory barrier */
 		rmb();
 
-		switch (roce_get_field(aeqe->asyn,
-			HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-			HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S)) {
+		event_type = roce_get_field(aeqe->asyn,
+				HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
+				HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S);
+		switch (event_type) {
 		case HNS_ROCE_EVENT_TYPE_PATH_MIG:
 			dev_warn(dev, "PATH MIG not supported\n");
 			break;
@@ -211,23 +255,9 @@ static int hns_roce_aeq_int(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
 			dev_warn(dev, "PATH MIG failed\n");
 			break;
 		case HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR:
-			dev_warn(dev, "qpn = 0x%lx\n",
-			roce_get_field(aeqe->event.qp_event.qp,
-				       HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
-				       HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S));
-			hns_roce_qp_event(hr_dev,
-				roce_get_field(aeqe->event.qp_event.qp,
-					HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
-					HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S),
-				roce_get_field(aeqe->asyn,
-					HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-					HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
-			break;
 		case HNS_ROCE_EVENT_TYPE_WQ_CATAS_ERROR:
-			hns_roce_wq_catas_err_handle(hr_dev, aeqe, qpn);
-			break;
 		case HNS_ROCE_EVENT_TYPE_LOCAL_WQ_ACCESS_ERROR:
-			hns_roce_local_wq_access_err_handle(hr_dev, aeqe, qpn);
+			hns_roce_qp_err_handle(hr_dev, aeqe, event_type);
 			break;
 		case HNS_ROCE_EVENT_TYPE_SRQ_LIMIT_REACH:
 		case HNS_ROCE_EVENT_TYPE_SRQ_CATAS_ERROR:
@@ -235,40 +265,9 @@ static int hns_roce_aeq_int(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
 			dev_warn(dev, "SRQ not support!\n");
 			break;
 		case HNS_ROCE_EVENT_TYPE_CQ_ACCESS_ERROR:
-			dev_warn(dev, "CQ 0x%lx access err.\n",
-			roce_get_field(aeqe->event.cq_event.cq,
-				       HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M,
-				       HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S));
-			hns_roce_cq_event(hr_dev,
-			le32_to_cpu(roce_get_field(aeqe->event.cq_event.cq,
-				    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M,
-				    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S)),
-			roce_get_field(aeqe->asyn,
-				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
-			break;
 		case HNS_ROCE_EVENT_TYPE_CQ_OVERFLOW:
-			dev_warn(dev, "CQ 0x%lx overflow\n",
-			roce_get_field(aeqe->event.cq_event.cq,
-				       HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M,
-				       HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S));
-			hns_roce_cq_event(hr_dev,
-			le32_to_cpu(roce_get_field(aeqe->event.cq_event.cq,
-				    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M,
-				    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S)),
-			roce_get_field(aeqe->asyn,
-				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
-			break;
 		case HNS_ROCE_EVENT_TYPE_CQ_ID_INVALID:
-			dev_warn(dev, "CQ ID invalid.\n");
-			hns_roce_cq_event(hr_dev,
-			le32_to_cpu(roce_get_field(aeqe->event.cq_event.cq,
-				    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M,
-				    HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S)),
-			roce_get_field(aeqe->asyn,
-				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-				       HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S));
+			hns_roce_cq_err_handle(hr_dev, aeqe, event_type);
 			break;
 		case HNS_ROCE_EVENT_TYPE_PORT_CHANGE:
 			dev_warn(dev, "port change.\n");
@@ -290,11 +289,8 @@ static int hns_roce_aeq_int(struct hns_roce_dev *hr_dev, struct hns_roce_eq *eq)
 				     HNS_ROCE_AEQE_EVENT_CE_EVENT_CEQE_CEQN_S));
 			break;
 		default:
-			dev_warn(dev, "Unhandled event 0x%lx on EQ %d at index %u\n",
-				 roce_get_field(aeqe->asyn,
-					      HNS_ROCE_AEQE_U32_4_EVENT_TYPE_M,
-					      HNS_ROCE_AEQE_U32_4_EVENT_TYPE_S),
-				 eq->eqn, eq->cons_index);
+			dev_warn(dev, "Unhandled event %d on EQ %d at index %u\n",
+				 event_type, eq->eqn, eq->cons_index);
 			break;
 		};
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_eq.h b/drivers/infiniband/hw/hns/hns_roce_eq.h
index fe43881..c6d212d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_eq.h
+++ b/drivers/infiniband/hw/hns/hns_roce_eq.h
@@ -107,6 +107,10 @@ struct hns_roce_aeqe {
 #define HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M   \
 	(((1UL << 24) - 1) << HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S)
 
+#define HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_S 25
+#define HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_M   \
+	(((1UL << 3) - 1) << HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_S)
+
 #define HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S 0
 #define HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_M   \
 	(((1UL << 16) - 1) << HNS_ROCE_AEQE_EVENT_CQ_EVENT_CQ_CQN_S)
-- 
1.9.1
