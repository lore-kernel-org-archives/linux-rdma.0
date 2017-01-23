From: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] qedr: dispatch port active event from qedr_add
Date: Mon, 23 Jan 2017 17:28:39 +0200
Message-ID: <1485185319-18771-6-git-send-email-Ram.Amrani@qlogic.com>
References: <1485185319-18771-1-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485185319-18771-1-git-send-email-Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Relying on qede to trigger qedr on startup is problematic. When probing
both if qedr loads slowly then qede can assume qedr is missing and not
trigger it. This patch adds a triggering from qedr and protects against
a race via an atomic bit.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c | 20 ++++++++++++++------
 drivers/infiniband/hw/qedr/qedr.h |  5 +++++
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index eac0bfc..3ac8aa5 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -791,6 +791,9 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 		if (device_create_file(&dev->ibdev.dev, qedr_attributes[i]))
 			goto sysfs_err;
 
+	if (!test_and_set_bit(QEDR_ENET_STATE_BIT, &dev->enet_state))
+		qedr_ib_dispatch_event(dev, QEDR_PORT, IB_EVENT_PORT_ACTIVE);
+
 	DP_DEBUG(dev, QEDR_MSG_INIT, "qedr driver loaded successfully\n");
 	return dev;
 
@@ -823,11 +826,10 @@ static void qedr_remove(struct qedr_dev *dev)
 	ib_dealloc_device(&dev->ibdev);
 }
 
-static int qedr_close(struct qedr_dev *dev)
+static void qedr_close(struct qedr_dev *dev)
 {
-	qedr_ib_dispatch_event(dev, 1, IB_EVENT_PORT_ERR);
-
-	return 0;
+	if (test_and_clear_bit(QEDR_ENET_STATE_BIT, &dev->enet_state))
+		qedr_ib_dispatch_event(dev, QEDR_PORT, IB_EVENT_PORT_ERR);
 }
 
 static void qedr_shutdown(struct qedr_dev *dev)
@@ -836,6 +838,12 @@ static void qedr_shutdown(struct qedr_dev *dev)
 	qedr_remove(dev);
 }
 
+static void qedr_open(struct qedr_dev *dev)
+{
+	if (!test_and_set_bit(QEDR_ENET_STATE_BIT, &dev->enet_state))
+		qedr_ib_dispatch_event(dev, QEDR_PORT, IB_EVENT_PORT_ACTIVE);
+}
+
 static void qedr_mac_address_change(struct qedr_dev *dev)
 {
 	union ib_gid *sgid = &dev->sgid_tbl[0];
@@ -862,7 +870,7 @@ static void qedr_mac_address_change(struct qedr_dev *dev)
 
 	ether_addr_copy(dev->gsi_ll2_mac_address, dev->ndev->dev_addr);
 
-	qedr_ib_dispatch_event(dev, 1, IB_EVENT_GID_CHANGE);
+	qedr_ib_dispatch_event(dev, QEDR_PORT, IB_EVENT_GID_CHANGE);
 
 	if (rc)
 		DP_ERR(dev, "Error updating mac filter\n");
@@ -876,7 +884,7 @@ static void qedr_notify(struct qedr_dev *dev, enum qede_roce_event event)
 {
 	switch (event) {
 	case QEDE_UP:
-		qedr_ib_dispatch_event(dev, 1, IB_EVENT_PORT_ACTIVE);
+		qedr_open(dev);
 		break;
 	case QEDE_DOWN:
 		qedr_close(dev);
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 620badd..f669d0b 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -113,6 +113,8 @@ struct qedr_device_attr {
 	struct qed_rdma_events events;
 };
 
+#define QEDR_ENET_STATE_BIT	(0)
+
 struct qedr_dev {
 	struct ib_device	ibdev;
 	struct qed_dev		*cdev;
@@ -153,6 +155,8 @@ struct qedr_dev {
 	struct qedr_cq		*gsi_sqcq;
 	struct qedr_cq		*gsi_rqcq;
 	struct qedr_qp		*gsi_qp;
+
+	unsigned long enet_state;
 };
 
 #define QEDR_MAX_SQ_PBL			(0x8000)
@@ -188,6 +192,7 @@ struct qedr_dev {
 #define QEDR_ROCE_MAX_CNQ_SIZE		(0x4000)
 
 #define QEDR_MAX_PORT			(1)
+#define QEDR_PORT			(1)
 
 #define QEDR_UVERBS(CMD_NAME) (1ull << IB_USER_VERBS_CMD_##CMD_NAME)
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
