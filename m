From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v4 01/12] net: Introduce ndo_get_port_parent_id()
Date: Wed,  6 Feb 2019 09:45:35 -0800
Message-ID: <20190206174546.23597-2-f.fainelli@gmail.com>
References: <20190206174546.23597-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190206174546.23597-1-f.fainelli@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: netdev@vger.kernel.org
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Florian Fainelli <f.fainelli@gmail.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, Ido Schimmel <idosch@mellanox.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-rdma@vger.kernel.org

In preparation for getting rid of switchdev_ops, create a dedicated NDO
operation for getting the port's parent identifier. There are
essentially two classes of drivers that need to implement getting the
port's parent ID which are VF/PF drivers with a built-in switch, and
pure switchdev drivers such as mlxsw, ocelot, dsa etc.

We introduce a helper function: dev_get_port_parent_id() which supports
recursion into the lower devices to obtain the first port's parent ID.

Convert the bridge, core and ipv4 multicast routing code to check for
such ndo_get_port_parent_id() and call the helper function when valid
before falling back to switchdev_port_attr_get(). This will allow us to
convert all relevant drivers in one go instead of having to implement
both switchdev_port_attr_get() and ndo_get_port_parent_id() operations,
then get rid of switchdev_port_attr_get().

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/netdevice.h |  9 +++++++
 net/bridge/br_switchdev.c |  9 +++++--
 net/core/dev.c            | 57 +++++++++++++++++++++++++++++++++++++++
 net/core/net-sysfs.c      |  7 ++++-
 net/core/rtnetlink.c      |  6 ++++-
 net/ipv4/ipmr.c           |  8 +++++-
 6 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ba57d0ba425e..1d95e634f3fe 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1188,6 +1188,10 @@ struct dev_ifalias {
  *	not implement this, it is assumed that the hw is not able to have
  *	multiple net devices on single physical port.
  *
+ * int (*ndo_get_port_parent_id)(struct net_device *dev,
+ *				 struct netdev_phys_item_id *ppid)
+ *	Called to get the parent ID of the physical port of this device.
+ *
  * void (*ndo_udp_tunnel_add)(struct net_device *dev,
  *			      struct udp_tunnel_info *ti);
  *	Called by UDP tunnel to notify a driver about the UDP port and socket
@@ -1412,6 +1416,8 @@ struct net_device_ops {
 						      bool new_carrier);
 	int			(*ndo_get_phys_port_id)(struct net_device *dev,
 							struct netdev_phys_item_id *ppid);
+	int			(*ndo_get_port_parent_id)(struct net_device *dev,
+							  struct netdev_phys_item_id *ppid);
 	int			(*ndo_get_phys_port_name)(struct net_device *dev,
 							  char *name, size_t len);
 	void			(*ndo_udp_tunnel_add)(struct net_device *dev,
@@ -3651,6 +3657,9 @@ int dev_get_phys_port_id(struct net_device *dev,
 			 struct netdev_phys_item_id *ppid);
 int dev_get_phys_port_name(struct net_device *dev,
 			   char *name, size_t len);
+int dev_get_port_parent_id(struct net_device *dev,
+			   struct netdev_phys_item_id *ppid, bool recurse);
+bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
 int dev_change_proto_down(struct net_device *dev, bool proto_down);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 4d2b9eb7604a..06b0ae44585f 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -14,7 +14,8 @@ static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
 
 	/* dev is yet to be added to the port list. */
 	list_for_each_entry(p, &br->port_list, list) {
-		if (switchdev_port_same_parent_id(dev, p->dev))
+		if (netdev_port_same_parent_id(dev, p->dev) ||
+		    switchdev_port_same_parent_id(dev, p->dev))
 			return p->offload_fwd_mark;
 	}
 
@@ -23,6 +24,7 @@ static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
 
 int nbp_switchdev_mark_set(struct net_bridge_port *p)
 {
+	const struct net_device_ops *ops = p->dev->netdev_ops;
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
 		.id = SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
@@ -31,7 +33,10 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 
 	ASSERT_RTNL();
 
-	err = switchdev_port_attr_get(p->dev, &attr);
+	if (ops->ndo_get_port_parent_id)
+		err = dev_get_port_parent_id(p->dev, &attr.u.ppid, true);
+	else
+		err = switchdev_port_attr_get(p->dev, &attr);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
diff --git a/net/core/dev.c b/net/core/dev.c
index bfa4be42afff..8c6d5cf8a308 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7877,6 +7877,63 @@ int dev_get_phys_port_name(struct net_device *dev,
 }
 EXPORT_SYMBOL(dev_get_phys_port_name);
 
+/**
+ *	dev_get_port_parent_id - Get the device's port parent identifier
+ *	@dev: network device
+ *	@ppid: pointer to a storage for the port's parent identifier
+ *	@recurse: allow/disallow recursion to lower devices
+ *
+ *	Get the devices's port parent identifier
+ */
+int dev_get_port_parent_id(struct net_device *dev,
+			   struct netdev_phys_item_id *ppid,
+			   bool recurse)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct netdev_phys_item_id first = { };
+	struct net_device *lower_dev;
+	struct list_head *iter;
+	int err = -EOPNOTSUPP;
+
+	if (ops->ndo_get_port_parent_id)
+		return ops->ndo_get_port_parent_id(dev, ppid);
+
+	if (!recurse)
+		return err;
+
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		err = dev_get_port_parent_id(lower_dev, ppid, recurse);
+		if (err)
+			break;
+		if (!first.id_len)
+			first = *ppid;
+		else if (memcmp(&first, ppid, sizeof(*ppid)))
+			return -ENODATA;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(dev_get_port_parent_id);
+
+/**
+ *	netdev_port_same_parent_id - Indicate if two network devices have
+ *	the same port parent identifier
+ *	@a: first network device
+ *	@b: second network device
+ */
+bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b)
+{
+	struct netdev_phys_item_id a_id = { };
+	struct netdev_phys_item_id b_id = { };
+
+	if (dev_get_port_parent_id(a, &a_id, true) ||
+	    dev_get_port_parent_id(b, &b_id, true))
+		return false;
+
+	return netdev_phys_item_id_same(&a_id, &b_id);
+}
+EXPORT_SYMBOL(netdev_port_same_parent_id);
+
 /**
  *	dev_change_proto_down - update protocol port state information
  *	@dev: device
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ff9fd2bb4ce4..4eace9f1dcf9 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -495,6 +495,7 @@ static ssize_t phys_switch_id_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct net_device *netdev = to_net_dev(dev);
+	const struct net_device_ops *ops = netdev->netdev_ops;
 	ssize_t ret = -EINVAL;
 
 	if (!rtnl_trylock())
@@ -507,7 +508,11 @@ static ssize_t phys_switch_id_show(struct device *dev,
 			.flags = SWITCHDEV_F_NO_RECURSE,
 		};
 
-		ret = switchdev_port_attr_get(netdev, &attr);
+		if (ops->ndo_get_port_parent_id)
+			ret = dev_get_port_parent_id(netdev, &attr.u.ppid,
+						     false);
+		else
+			ret = switchdev_port_attr_get(netdev, &attr);
 		if (!ret)
 			ret = sprintf(buf, "%*phN\n", attr.u.ppid.id_len,
 				      attr.u.ppid.id);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f5a98082ac7a..90dd02c1f561 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1146,6 +1146,7 @@ static int rtnl_phys_port_name_fill(struct sk_buff *skb, struct net_device *dev)
 
 static int rtnl_phys_switch_id_fill(struct sk_buff *skb, struct net_device *dev)
 {
+	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 	struct switchdev_attr attr = {
 		.orig_dev = dev,
@@ -1153,7 +1154,10 @@ static int rtnl_phys_switch_id_fill(struct sk_buff *skb, struct net_device *dev)
 		.flags = SWITCHDEV_F_NO_RECURSE,
 	};
 
-	err = switchdev_port_attr_get(dev, &attr);
+	if (ops->ndo_get_port_parent_id)
+		err = dev_get_port_parent_id(dev, &attr.u.ppid, false);
+	else
+		err = switchdev_port_attr_get(dev, &attr);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index fb99002c3d4e..c71bcc42d66d 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -837,6 +837,7 @@ static void ipmr_update_thresholds(struct mr_table *mrt, struct mr_mfc *cache,
 static int vif_add(struct net *net, struct mr_table *mrt,
 		   struct vifctl *vifc, int mrtsock)
 {
+	const struct net_device_ops *ops;
 	int vifi = vifc->vifc_vifi;
 	struct switchdev_attr attr = {
 		.id = SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
@@ -920,7 +921,12 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 			(VIFF_TUNNEL | VIFF_REGISTER));
 
 	attr.orig_dev = dev;
-	if (!switchdev_port_attr_get(dev, &attr)) {
+	ops = dev->netdev_ops;
+	if (ops->ndo_get_port_parent_id &&
+	    !dev_get_port_parent_id(dev, &attr.u.ppid, true)) {
+		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
+		v->dev_parent_id.id_len = attr.u.ppid.id_len;
+	} else if (!switchdev_port_attr_get(dev, &attr)) {
 		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
 		v->dev_parent_id.id_len = attr.u.ppid.id_len;
 	} else {
-- 
2.17.1
