From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH qedr 08/10] qedr: Add LL2 RoCE interface
Date: Wed, 5 Oct 2016 18:48:01 +0300
Message-ID: <1475682483-9878-9-git-send-email-Ram.Amrani@cavium.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475682483-9878-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add light L2 interface for RoCE.

Signed-off-by: Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/qedr/qedr.h |  2 +-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 86c23d2..d423f72 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -722,6 +722,38 @@ static void qedr_shutdown(struct qedr_dev *dev)
 	qedr_remove(dev);
 }
 
+static void qedr_mac_address_change(struct qedr_dev *dev)
+{
+	union ib_gid *sgid = &dev->sgid_tbl[0];
+	u8 guid[8], mac_addr[6];
+	int rc;
+
+	/* Update SGID */
+	ether_addr_copy(&mac_addr[0], dev->ndev->dev_addr);
+	guid[0] = mac_addr[0] ^ 2;
+	guid[1] = mac_addr[1];
+	guid[2] = mac_addr[2];
+	guid[3] = 0xff;
+	guid[4] = 0xfe;
+	guid[5] = mac_addr[3];
+	guid[6] = mac_addr[4];
+	guid[7] = mac_addr[5];
+	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	memcpy(&sgid->raw[8], guid, sizeof(guid));
+
+	/* Update LL2 */
+	rc = dev->ops->roce_ll2_set_mac_filter(dev->cdev,
+					       dev->gsi_ll2_mac_address,
+					       dev->ndev->dev_addr);
+
+	ether_addr_copy(dev->gsi_ll2_mac_address, dev->ndev->dev_addr);
+
+	qedr_ib_dispatch_event(dev, 1, IB_EVENT_GID_CHANGE);
+
+	if (rc)
+		DP_ERR(dev, "Error updating mac filter\n");
+}
+
 /* event handling via NIC driver ensures that all the NIC specific
  * initialization done before RoCE driver notifies
  * event to stack.
@@ -739,7 +771,7 @@ static void qedr_notify(struct qedr_dev *dev, enum qede_roce_event event)
 		qedr_shutdown(dev);
 		break;
 	case QEDE_CHANGE_ADDR:
-		qedr_ib_dispatch_event(dev, 1, IB_EVENT_GID_CHANGE);
+		qedr_mac_address_change(dev);
 		break;
 	default:
 		pr_err("Event not supported\n");
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index a623663..9e282fe 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -147,7 +147,7 @@ struct qedr_dev {
 	u8			dp_level;
 	u8			num_hwfns;
 	uint			wq_multiplier;
-
+	u8			gsi_ll2_mac_address[ETH_ALEN];
 };
 
 #define QEDR_MAX_SQ_PBL			(0x8000)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
