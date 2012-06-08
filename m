From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: fixed gid table for vlan and events.
Date: Fri, 8 Jun 2012 21:25:25 +0530
Message-ID: <d17a7636-a3a0-4fc4-8ce0-f6af27cedf0d@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mahesh.Vardhamanaiah-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Fixed reporting GID table addition event also.
2. Enable vlan based GID entries only when VLAN is enabled at compile time using
CONFIG_VLAN_8021Q CONFIG_VLAN_8021Q_MODULE.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   63 +++++++++++++++-------------
 1 files changed, 34 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 04fef3d..b050e62 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -97,13 +97,11 @@ static void ocrdma_build_sgid_mac(union ib_gid *sgid, unsigned char *mac_addr,
 	sgid->raw[15] = mac_addr[5];
 }
 
-static void ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
+static bool ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
 			    bool is_vlan, u16 vlan_id)
 {
 	int i;
-	bool found = false;
 	union ib_gid new_sgid;
-	int free_idx = OCRDMA_MAX_SGID;
 	unsigned long flags;
 
 	memset(&ocrdma_zero_sgid, 0, sizeof(union ib_gid));
@@ -115,23 +113,19 @@ static void ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
 		if (!memcmp(&dev->sgid_tbl[i], &ocrdma_zero_sgid,
 			    sizeof(union ib_gid))) {
 			/* found free entry */
-			if (!found) {
-				free_idx = i;
-				found = true;
-				break;
-			}
+			memcpy(&dev->sgid_tbl[i], &new_sgid,
+			       sizeof(union ib_gid));
+			spin_unlock_irqrestore(&dev->sgid_lock, flags);
+			return true;
 		} else if (!memcmp(&dev->sgid_tbl[i], &new_sgid,
 				   sizeof(union ib_gid))) {
 			/* entry already present, no addition is required. */
 			spin_unlock_irqrestore(&dev->sgid_lock, flags);
-			return;
+			return false;
 		}
 	}
-	/* if entry doesn't exist and if table has some space, add entry */
-	if (found)
-		memcpy(&dev->sgid_tbl[free_idx], &new_sgid,
-		       sizeof(union ib_gid));
 	spin_unlock_irqrestore(&dev->sgid_lock, flags);
+	return false;
 }
 
 static bool ocrdma_del_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
@@ -167,7 +161,8 @@ static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
 	ocrdma_get_guid(dev, &sgid->raw[8]);
 }
 
-static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
 {
 	struct net_device *netdev, *tmp;
 	u16 vlan_id;
@@ -175,8 +170,6 @@ static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
 
 	netdev = dev->nic_info.netdev;
 
-	ocrdma_add_default_sgid(dev);
-
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, tmp) {
 		if (netdev == tmp || vlan_dev_real_dev(tmp) == netdev) {
@@ -194,10 +187,23 @@ static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
 		}
 	}
 	rcu_read_unlock();
+}
+#else
+static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
+{
+
+}
+#endif /* VLAN */
+
+static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
+{
+	ocrdma_add_default_sgid(dev);
+	ocrdma_add_vlan_sgids(dev);
 	return 0;
 }
 
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE) || \
+defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 
 static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 				  unsigned long event, void *ptr)
@@ -208,6 +214,7 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 	struct ib_event gid_event;
 	struct ocrdma_dev *dev;
 	bool found = false;
+	bool updated = false;
 	bool is_vlan = false;
 	u16 vid = 0;
 
@@ -233,23 +240,21 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 	mutex_lock(&dev->dev_lock);
 	switch (event) {
 	case NETDEV_UP:
-		ocrdma_add_sgid(dev, netdev->dev_addr, is_vlan, vid);
+		updated = ocrdma_add_sgid(dev, netdev->dev_addr, is_vlan, vid);
 		break;
 	case NETDEV_DOWN:
-		found = ocrdma_del_sgid(dev, netdev->dev_addr, is_vlan, vid);
-		if (found) {
-			/* found the matching entry, notify
-			 * the consumers about it
-			 */
-			gid_event.device = &dev->ibdev;
-			gid_event.element.port_num = 1;
-			gid_event.event = IB_EVENT_GID_CHANGE;
-			ib_dispatch_event(&gid_event);
-		}
+		updated = ocrdma_del_sgid(dev, netdev->dev_addr, is_vlan, vid);
 		break;
 	default:
 		break;
 	}
+	if (updated) {
+		/* GID table updated, notify the consumers about it */
+		gid_event.device = &dev->ibdev;
+		gid_event.element.port_num = 1;
+		gid_event.event = IB_EVENT_GID_CHANGE;
+		ib_dispatch_event(&gid_event);
+	}
 	mutex_unlock(&dev->dev_lock);
 	return NOTIFY_OK;
 }
@@ -258,7 +263,7 @@ static struct notifier_block ocrdma_inet6addr_notifier = {
 	.notifier_call = ocrdma_inet6addr_event
 };
 
-#endif /* IPV6 */
+#endif /* IPV6 and VLAN */
 
 static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 					      u8 port_num)
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
