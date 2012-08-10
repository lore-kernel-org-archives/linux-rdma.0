From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fixed CONFIG_VLAN_8021Q.
Date: Fri, 10 Aug 2012 21:58:11 +0530
Message-ID: <9ac93bde-c809-45c2-86e2-a50ea6a1020f@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixed avoiding checking real vlan dev in scenario
when VLAN is disabled and ipv6 is enabled.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 5a04452..7146ffd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -161,7 +161,7 @@ static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
 	ocrdma_get_guid(dev, &sgid->raw[8]);
 }
 
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
+#if IS_ENABLED(CONFIG_VLAN_8021Q) || IS_ENABLED(CONFIG_VLAN_8021Q_MODULE)
 static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
 {
 	struct net_device *netdev, *tmp;
@@ -202,8 +202,16 @@ static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_IPV6) || IS_ENABLED(CONFIG_VLAN_8021Q)
+static struct net_device *ocrdma_get_real_netdev(struct net_device *netdev)
+{
+#if IS_ENABLED(CONFIG_VLAN_8021Q) || IS_ENABLED(CONFIG_VLAN_8021Q_MODULE)
+	return vlan_dev_real_dev(netdev);
+#else
+	return netdev;
+#endif
+}
 
+#if IS_ENABLED(CONFIG_IPV6)
 static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 				  unsigned long event, void *ptr)
 {
@@ -217,7 +225,7 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 	bool is_vlan = false;
 	u16 vid = 0;
 
-	netdev = vlan_dev_real_dev(event_netdev);
+	netdev = ocrdma_get_real_netdev(event_netdev);
 	if (netdev != event_netdev) {
 		is_vlan = true;
 		vid = vlan_dev_vlan_id(event_netdev);
@@ -262,7 +270,7 @@ static struct notifier_block ocrdma_inet6addr_notifier = {
 	.notifier_call = ocrdma_inet6addr_event
 };
 
-#endif /* IPV6 and VLAN */
+#endif /* IPV6 */
 
 static enum rdma_link_layer ocrdma_link_layer(struct ib_device *device,
 					      u8 port_num)
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
