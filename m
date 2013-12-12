From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V6 for-next 6/7] IB/ocrdma: Populate GID table with IP based gids
Date: Thu, 12 Dec 2013 18:03:16 +0200
Message-ID: <1386864197-10591-7-git-send-email-ogerlitz@mellanox.com>
References: <1386864197-10591-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386864197-10591-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch is similar in spirit to the "IB/mlx4: Use IBoE (RoCE) IP based GIDs
in the port GID table" patch.

Changes to inet4 and inet6 addresses for the host are monitored and if the
address is associated with an ocrdma device then a gid is added or deleted
from the device's gid table. The gid format will be a IPv4 to IPv6 mapped or
the IPv6 address.

Cc: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  138 ++++++++-------------------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 2 files changed, 41 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 91443bc..47187bf 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -67,46 +67,24 @@ void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 	guid[7] = mac_addr[5];
 }
 
-static void ocrdma_build_sgid_mac(union ib_gid *sgid, unsigned char *mac_addr,
-				  bool is_vlan, u16 vlan_id)
-{
-	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
-	sgid->raw[8] = mac_addr[0] ^ 2;
-	sgid->raw[9] = mac_addr[1];
-	sgid->raw[10] = mac_addr[2];
-	if (is_vlan) {
-		sgid->raw[11] = vlan_id >> 8;
-		sgid->raw[12] = vlan_id & 0xff;
-	} else {
-		sgid->raw[11] = 0xff;
-		sgid->raw[12] = 0xfe;
-	}
-	sgid->raw[13] = mac_addr[3];
-	sgid->raw[14] = mac_addr[4];
-	sgid->raw[15] = mac_addr[5];
-}
-
-static bool ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
-			    bool is_vlan, u16 vlan_id)
+static bool ocrdma_add_sgid(struct ocrdma_dev *dev, union ib_gid *new_sgid)
 {
 	int i;
-	union ib_gid new_sgid;
 	unsigned long flags;
 
 	memset(&ocrdma_zero_sgid, 0, sizeof(union ib_gid));
 
-	ocrdma_build_sgid_mac(&new_sgid, mac_addr, is_vlan, vlan_id);
 
 	spin_lock_irqsave(&dev->sgid_lock, flags);
 	for (i = 0; i < OCRDMA_MAX_SGID; i++) {
 		if (!memcmp(&dev->sgid_tbl[i], &ocrdma_zero_sgid,
 			    sizeof(union ib_gid))) {
 			/* found free entry */
-			memcpy(&dev->sgid_tbl[i], &new_sgid,
+			memcpy(&dev->sgid_tbl[i], new_sgid,
 			       sizeof(union ib_gid));
 			spin_unlock_irqrestore(&dev->sgid_lock, flags);
 			return true;
-		} else if (!memcmp(&dev->sgid_tbl[i], &new_sgid,
+		} else if (!memcmp(&dev->sgid_tbl[i], new_sgid,
 				   sizeof(union ib_gid))) {
 			/* entry already present, no addition is required. */
 			spin_unlock_irqrestore(&dev->sgid_lock, flags);
@@ -117,20 +95,17 @@ static bool ocrdma_add_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
 	return false;
 }
 
-static bool ocrdma_del_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
-			    bool is_vlan, u16 vlan_id)
+static bool ocrdma_del_sgid(struct ocrdma_dev *dev, union ib_gid *sgid)
 {
 	int found = false;
 	int i;
-	union ib_gid sgid;
 	unsigned long flags;
 
-	ocrdma_build_sgid_mac(&sgid, mac_addr, is_vlan, vlan_id);
 
 	spin_lock_irqsave(&dev->sgid_lock, flags);
 	/* first is default sgid, which cannot be deleted. */
 	for (i = 1; i < OCRDMA_MAX_SGID; i++) {
-		if (!memcmp(&dev->sgid_tbl[i], &sgid, sizeof(union ib_gid))) {
+		if (!memcmp(&dev->sgid_tbl[i], sgid, sizeof(union ib_gid))) {
 			/* found matching entry */
 			memset(&dev->sgid_tbl[i], 0, sizeof(union ib_gid));
 			found = true;
@@ -141,75 +116,18 @@ static bool ocrdma_del_sgid(struct ocrdma_dev *dev, unsigned char *mac_addr,
 	return found;
 }
 
-static void ocrdma_add_default_sgid(struct ocrdma_dev *dev)
-{
-	/* GID Index 0 - Invariant manufacturer-assigned EUI-64 */
-	union ib_gid *sgid = &dev->sgid_tbl[0];
-
-	sgid->global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
-	ocrdma_get_guid(dev, &sgid->raw[8]);
-}
-
-#if IS_ENABLED(CONFIG_VLAN_8021Q)
-static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
-{
-	struct net_device *netdev, *tmp;
-	u16 vlan_id;
-	bool is_vlan;
-
-	netdev = dev->nic_info.netdev;
-
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, tmp) {
-		if (netdev == tmp || vlan_dev_real_dev(tmp) == netdev) {
-			if (!netif_running(tmp) || !netif_oper_up(tmp))
-				continue;
-			if (netdev != tmp) {
-				vlan_id = vlan_dev_vlan_id(tmp);
-				is_vlan = true;
-			} else {
-				is_vlan = false;
-				vlan_id = 0;
-				tmp = netdev;
-			}
-			ocrdma_add_sgid(dev, tmp->dev_addr, is_vlan, vlan_id);
-		}
-	}
-	rcu_read_unlock();
-}
-#else
-static void ocrdma_add_vlan_sgids(struct ocrdma_dev *dev)
-{
-
-}
-#endif /* VLAN */
-
-static int ocrdma_build_sgid_tbl(struct ocrdma_dev *dev)
+static int ocrdma_addr_event(unsigned long event, struct net_device *netdev,
+			     union ib_gid *gid)
 {
-	ocrdma_add_default_sgid(dev);
-	ocrdma_add_vlan_sgids(dev);
-	return 0;
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-
-static int ocrdma_inet6addr_event(struct notifier_block *notifier,
-				  unsigned long event, void *ptr)
-{
-	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
-	struct net_device *netdev = ifa->idev->dev;
 	struct ib_event gid_event;
 	struct ocrdma_dev *dev;
 	bool found = false;
 	bool updated = false;
 	bool is_vlan = false;
-	u16 vid = 0;
 
 	is_vlan = netdev->priv_flags & IFF_802_1Q_VLAN;
-	if (is_vlan) {
-		vid = vlan_dev_vlan_id(netdev);
+	if (is_vlan)
 		netdev = vlan_dev_real_dev(netdev);
-	}
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(dev, &ocrdma_dev_list, entry) {
@@ -222,16 +140,14 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 
 	if (!found)
 		return NOTIFY_DONE;
-	if (!rdma_link_local_addr((struct in6_addr *)&ifa->addr))
-		return NOTIFY_DONE;
 
 	mutex_lock(&dev->dev_lock);
 	switch (event) {
 	case NETDEV_UP:
-		updated = ocrdma_add_sgid(dev, netdev->dev_addr, is_vlan, vid);
+		updated = ocrdma_add_sgid(dev, gid);
 		break;
 	case NETDEV_DOWN:
-		updated = ocrdma_del_sgid(dev, netdev->dev_addr, is_vlan, vid);
+		updated = ocrdma_del_sgid(dev, gid);
 		break;
 	default:
 		break;
@@ -247,6 +163,32 @@ static int ocrdma_inet6addr_event(struct notifier_block *notifier,
 	return NOTIFY_OK;
 }
 
+static int ocrdma_inetaddr_event(struct notifier_block *notifier,
+				  unsigned long event, void *ptr)
+{
+	struct in_ifaddr *ifa = ptr;
+	union ib_gid gid;
+	struct net_device *netdev = ifa->ifa_dev->dev;
+
+	ipv6_addr_set_v4mapped(ifa->ifa_address, (struct in6_addr *)&gid);
+	return ocrdma_addr_event(event, netdev, &gid);
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+
+static int ocrdma_inet6addr_event(struct notifier_block *notifier,
+				  unsigned long event, void *ptr)
+{
+	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
+	union  ib_gid *gid = (union ib_gid *)&ifa->addr;
+	struct net_device *netdev = ifa->idev->dev;
+	return ocrdma_addr_event(event, netdev, gid);
+}
+
+static struct notifier_block ocrdma_inetaddr_notifier = {
+	.notifier_call = ocrdma_inetaddr_event
+};
+
 static struct notifier_block ocrdma_inet6addr_notifier = {
 	.notifier_call = ocrdma_inet6addr_event
 };
@@ -423,10 +365,6 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	if (status)
 		goto alloc_err;
 
-	status = ocrdma_build_sgid_tbl(dev);
-	if (status)
-		goto alloc_err;
-
 	status = ocrdma_register_device(dev);
 	if (status)
 		goto alloc_err;
@@ -553,6 +491,10 @@ static int __init ocrdma_init_module(void)
 {
 	int status;
 
+	status = register_inetaddr_notifier(&ocrdma_inetaddr_notifier);
+	if (status)
+		return status;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	status = register_inet6addr_notifier(&ocrdma_inet6addr_notifier);
 	if (status)
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index a0f1c47..aa92f40 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1327,7 +1327,7 @@ int ocrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	spin_unlock_irqrestore(&qp->q_lock, flags);
 
 	if (!ib_modify_qp_is_ok(old_qps, new_qps, ibqp->qp_type, attr_mask,
-				IB_LINK_LAYER_UNSPECIFIED)) {
+				IB_LINK_LAYER_ETHERNET)) {
 		pr_err("%s(%d) invalid attribute mask=0x%x specified for\n"
 		       "qpn=0x%x of type=0x%x old_qps=0x%x, new_qps=0x%x\n",
 		       __func__, dev->id, attr_mask, qp->id, ibqp->qp_type,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
