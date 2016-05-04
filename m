From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/IPoIB: Allow setting the device address
Date: Wed,  4 May 2016 08:36:47 +0300
Message-ID: <1462340207-16174-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In IPoIB/rdmacm networks, the device address of an IPoIB
interface is used to exchange information between nodes
needed for communication.

Currently an IPoIB interface will always be created with a
constant device address based on its node GUID.

This change adds the ability to set the device address of an IPoIB
interface by value. The mac address ndo is used for that.

The control flow can be divided to two parts:
1) The GID value is already in the GID table,
   in this case the interface will be able to set carrier up.

2) The GID value is not yet in the GID table,
   in this case the interface won't try to join the multicast group
   and will wait (listen on GID_CHANGE event) until the GID is inserted.

In order to track those changes, we will add a new flag:
* IPOIB_FLAG_DEV_ADDR_SET.

When this flag is set, it will indicate that the dev_addr is a
based on a value in the GID table. The dev_addr change will
trigger the bit clear operation.

Per IB specification the port GUID can't be changed if the
module is loaded. Port GUID is the basis for GID at index 0
which is the basis for the default device address of a IPoIB
interface.

There are devices that don't follow the spec and they change
the port GUID while HCA is powered on, so in order do not break
existing user space applications, the following flow is suggested.

We will check if the user wants to control the device address
and we will assume that he no longer wishes to control it, if
he sets the device address back to be based on GID index 0.

In order to track this, we will add an additional flag:
* IPOIB_FLAG_DEV_ADDR_CTRL

When setting the device address, there is lack of validation for
12 upper bytes of the device address (flags, qpn, subnet prefix)
as those bytes are not under the control of the user.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Available in the "topic/ipoib-device-address" topic branch of this git repo:

git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:

https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/ipoib-device-address

---
 drivers/infiniband/ulp/ipoib/ipoib.h           |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 103 ++++++++++++++++++++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  38 +++++++++
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  15 +++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   3 +
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   1 +
 6 files changed, 156 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index caec8e9..7830bde 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -92,6 +92,8 @@ enum {
 	IPOIB_FLAG_UMCAST	  = 10,
 	IPOIB_STOP_NEIGH_GC	  = 11,
 	IPOIB_NEIGH_TBL_FLUSH	  = 12,
+	IPOIB_FLAG_DEV_ADDR_SET	  = 13,
+	IPOIB_FLAG_DEV_ADDR_CTRL  = 14,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index f0e55e4..be98f9f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -999,6 +999,100 @@ static inline int update_child_pkey(struct ipoib_dev_priv *priv)
 	return 0;
 }
 
+/*
+ * returns true if the device address of the ipoib interface has changed and the
+ * new address is a valid one (i.e in the gid table), return false otherwise.
+ */
+static bool ipoib_dev_addr_changed_valid(struct ipoib_dev_priv *priv)
+{
+	union ib_gid search_gid;
+	union ib_gid gid0;
+	int err;
+	u16 index;
+	u8 port;
+	bool ret = false;
+
+	if (ib_query_gid(priv->ca, priv->port, 0, &gid0, NULL))
+		return false;
+
+	netif_addr_lock(priv->dev);
+
+	search_gid.global.interface_id = priv->local_gid.global.interface_id;
+
+	netif_addr_unlock(priv->dev);
+
+	/* The subnet prefix may have changed, search using the currect one */
+	search_gid.global.subnet_prefix = gid0.global.subnet_prefix;
+
+	err = ib_find_gid(priv->ca, &search_gid, IB_GID_TYPE_IB,
+			  priv->dev, &port, &index);
+
+	netif_addr_lock(priv->dev);
+
+	if (search_gid.global.interface_id !=
+	    priv->local_gid.global.interface_id)
+		/* There was a change while we were looking up the gid, bail
+		 * here and let the next work sort this out
+		 */
+		goto out;
+
+	/* The next section of code needs some background:
+	 * Per IB spec the port GUID can't change if the HCA is powered on.
+	 * port GUID is the basis for GID at index 0 which is the basis for
+	 * the default device address of a ipoib interface.
+	 *
+	 * so it seems the flow should be:
+	 * if user_changed_dev_addr && gid in gid tbl
+	 *	set bit dev_addr_set
+	 *	return true
+	 * else
+	 *	return false
+	 *
+	 * The issue is that there are devices that don't follow the spec,
+	 * they change the port GUID when the HCA is powered, so in order
+	 * not to break userspace applications, We need to check if the
+	 * user wanted to control the device address and we assume that
+	 * if he sets the device address back to be based on GID index 0,
+	 * he no longer wishs to control it.
+	 *
+	 * If the user doesn't control the the device address,
+	 * IPOIB_FLAG_DEV_ADDR_SET is set and ib_find_gid failed it means
+	 * the port GUID has changed and GID at index 0 has changed
+	 * so we need to change priv->local_gid and priv->dev->dev_addr
+	 * to reflect the new GID.
+	 */
+	if (!test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
+		if (!err && port == priv->port) {
+			set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
+			if (index == 0)
+				clear_bit(IPOIB_FLAG_DEV_ADDR_CTRL,
+					  &priv->flags);
+			else
+				set_bit(IPOIB_FLAG_DEV_ADDR_CTRL, &priv->flags);
+			ret = true;
+		} else {
+			ret = false;
+		}
+	} else {
+		if (!err && port == priv->port) {
+			ret = true;
+		} else {
+			if (!test_bit(IPOIB_FLAG_DEV_ADDR_CTRL, &priv->flags)) {
+				memcpy(&priv->local_gid, &gid0,
+				       sizeof(priv->local_gid));
+				memcpy(priv->dev->dev_addr + 4, &gid0,
+				       sizeof(priv->local_gid));
+				ret = true;
+			}
+		}
+	}
+
+out:
+	netif_addr_unlock(priv->dev);
+
+	return ret;
+}
+
 static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 				enum ipoib_flush_level level,
 				int nesting)
@@ -1020,6 +1114,9 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 
 	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags) &&
 	    level != IPOIB_FLUSH_HEAVY) {
+		/* Make sure the dev_addr is set even if not flushing */
+		if (level == IPOIB_FLUSH_LIGHT)
+			ipoib_dev_addr_changed_valid(priv);
 		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_INITIALIZED not set.\n");
 		return;
 	}
@@ -1031,7 +1128,8 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 				update_parent_pkey(priv);
 			else
 				update_child_pkey(priv);
-		}
+		} else if (level == IPOIB_FLUSH_LIGHT)
+			ipoib_dev_addr_changed_valid(priv);
 		ipoib_dbg(priv, "Not flushing - IPOIB_FLAG_ADMIN_UP not set.\n");
 		return;
 	}
@@ -1083,7 +1181,8 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	if (test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags)) {
 		if (level >= IPOIB_FLUSH_NORMAL)
 			ipoib_ib_dev_up(dev);
-		ipoib_mcast_restart_task(&priv->restart_task);
+		if (ipoib_dev_addr_changed_valid(priv))
+			ipoib_mcast_restart_task(&priv->restart_task);
 	}
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 80807d6..976bbdc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -99,6 +99,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 		struct ib_device *dev, u8 port, u16 pkey,
 		const union ib_gid *gid, const struct sockaddr *addr,
 		void *client_data);
+static int ipoib_set_mac(struct net_device *dev, void *addr);
 
 static struct ib_client ipoib_client = {
 	.name   = "ipoib",
@@ -1649,6 +1650,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
 	.ndo_get_vf_config	 = ipoib_get_vf_config,
 	.ndo_get_vf_stats	 = ipoib_get_vf_stats,
 	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
+	.ndo_set_mac_address	 = ipoib_set_mac,
 };
 
 static const struct net_device_ops ipoib_netdev_ops_vf = {
@@ -1771,6 +1773,41 @@ int ipoib_add_umcast_attr(struct net_device *dev)
 	return device_create_file(&dev->dev, &dev_attr_umcast);
 }
 
+static void set_base_guid(struct ipoib_dev_priv *priv, union ib_gid *gid,
+			  int nesting)
+{
+	struct ipoib_dev_priv *child_priv;
+	struct net_device *netdev = priv->dev;
+
+	netif_addr_lock(netdev);
+
+	if (!nesting)
+		memcpy(&priv->local_gid.global.interface_id,
+		       &gid->global.interface_id,
+		       sizeof(gid->global.interface_id));
+	memcpy(netdev->dev_addr + 4, &priv->local_gid, sizeof(priv->local_gid));
+	clear_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
+
+	netif_addr_unlock(netdev);
+
+	down_read_nested(&priv->vlan_rwsem, nesting);
+	list_for_each_entry(child_priv, &priv->child_intfs, list)
+		set_base_guid(child_priv, gid, nesting + 1);
+	up_read(&priv->vlan_rwsem);
+}
+
+static int ipoib_set_mac(struct net_device *dev, void *addr)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct sockaddr_storage *ss = addr;
+
+	set_base_guid(priv, (union ib_gid *)(ss->__data + 4), 0);
+
+	queue_work(ipoib_workqueue, &priv->flush_light);
+
+	return 0;
+}
+
 static ssize_t create_child(struct device *dev,
 			    struct device_attribute *attr,
 			    const char *buf, size_t count)
@@ -1894,6 +1931,7 @@ static struct net_device *ipoib_add_port(const char *format,
 		goto device_init_failed;
 	} else
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
+	set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
 
 	result = ipoib_dev_init(priv->dev, hca, port);
 	if (result < 0) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 2588931..a51f81d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -570,11 +570,18 @@ void ipoib_mcast_join_task(struct work_struct *work)
 		return;
 	}
 	priv->local_lid = port_attr.lid;
+	netif_addr_lock(dev);
 
-	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid, NULL))
-		ipoib_warn(priv, "ib_query_gid() failed\n");
-	else
-		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
+	if (test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
+		priv->local_gid.global.subnet_prefix =
+			cpu_to_be64(port_attr.subnet_prefix);
+		memcpy(dev->dev_addr + 4, priv->local_gid.raw,
+		       sizeof(union ib_gid));
+		netif_addr_unlock(dev);
+	} else {
+		netif_addr_unlock(dev);
+		return;
+	}
 
 	spin_lock_irq(&priv->lock);
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index b809c37..1e7cbba 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -307,5 +307,8 @@ void ipoib_event(struct ib_event_handler *handler,
 		queue_work(ipoib_workqueue, &priv->flush_normal);
 	} else if (record->event == IB_EVENT_PKEY_CHANGE) {
 		queue_work(ipoib_workqueue, &priv->flush_heavy);
+	} else if (record->event == IB_EVENT_GID_CHANGE &&
+		   !test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
+		queue_work(ipoib_workqueue, &priv->flush_light);
 	}
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index fca1a88..7e5f171 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -68,6 +68,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 	priv->pkey = pkey;
 
 	memcpy(priv->dev->dev_addr, ppriv->dev->dev_addr, INFINIBAND_ALEN);
+	set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
 	priv->dev->broadcast[8] = pkey >> 8;
 	priv->dev->broadcast[9] = pkey & 0xff;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
