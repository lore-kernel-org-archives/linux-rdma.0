From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 01/12] net: Introduce ndo_get_port_parent_id()
Date: Mon,  4 Feb 2019 15:36:22 -0800
Message-ID: <20190204233633.20421-2-f.fainelli@gmail.com>
References: <20190204233633.20421-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190204233633.20421-1-f.fainelli@gmail.com>
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
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, John Hurley <john.hurley@netronome.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Tyler Hicks <tyhicks@canonical.com>, Ivan Vecera <ivecera@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, Amritha Nambiar <amritha.nambiar@intel.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Petr Machata <petrm@mellanox.com>, Vivien Didelot <vivien.didelot@gmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>, open list:S
List-Id: linux-rdma@vger.kernel.org

In preparation for getting rid of switchdev_ops, create a dedicated NDO
operation for getting the port's parent identifier. There are
essentially two classes of drivers that need to implement getting the
port's parent ID which are VF/PF drivers with a built-in switch, and
pure switchdev drivers such as mlxsw, ocelot, dsa etc.

Convert the bridge, core and ipv4 multicast routing code to check for
such ndo_get_port_parent_id() and call it when valid before falling back
to switchdev_port_attr_get(). This will allow us to convert all relevant
drivers in one go instead of having to implement both
switchdev_port_attr_get() and ndo_get_port_parent_id() operations.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/netdevice.h | 6 ++++++
 net/bridge/br_switchdev.c | 6 +++++-
 net/core/net-sysfs.c      | 6 +++++-
 net/core/rtnetlink.c      | 6 +++++-
 net/ipv4/ipmr.c           | 8 +++++++-
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ba57d0ba425e..1bdfbbe1e768 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1188,6 +1188,10 @@ struct dev_ifalias {
  *	not implement this, it is assumed that the hw is not able to have
  *	multiple net devices on single physical port.
  *
+ * int (*ndo_get_port_parent_id)(struct net_device *dev,
+ *				 struct netdev_phys_item_id *ppid);
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
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 4d2b9eb7604a..501a4221220a 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -23,6 +23,7 @@ static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
 
 int nbp_switchdev_mark_set(struct net_bridge_port *p)
 {
+	const struct net_device_ops *ops = p->dev->netdev_ops;
 	struct switchdev_attr attr = {
 		.orig_dev = p->dev,
 		.id = SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
@@ -31,7 +32,10 @@ int nbp_switchdev_mark_set(struct net_bridge_port *p)
 
 	ASSERT_RTNL();
 
-	err = switchdev_port_attr_get(p->dev, &attr);
+	if (ops->ndo_get_port_parent_id)
+		err = ops->ndo_get_port_parent_id(p->dev, &attr.u.ppid);
+	else
+		err = switchdev_port_attr_get(p->dev, &attr);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ff9fd2bb4ce4..cc05e8b72657 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -495,6 +495,7 @@ static ssize_t phys_switch_id_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
 	struct net_device *netdev = to_net_dev(dev);
+	const struct net_device_ops *ops = netdev->netdev_ops;
 	ssize_t ret = -EINVAL;
 
 	if (!rtnl_trylock())
@@ -507,7 +508,10 @@ static ssize_t phys_switch_id_show(struct device *dev,
 			.flags = SWITCHDEV_F_NO_RECURSE,
 		};
 
-		ret = switchdev_port_attr_get(netdev, &attr);
+		if (ops->ndo_get_port_parent_id)
+			ret = ops->ndo_get_port_parent_id(netdev, &attr.u.ppid);
+		else
+			ret = switchdev_port_attr_get(netdev, &attr);
 		if (!ret)
 			ret = sprintf(buf, "%*phN\n", attr.u.ppid.id_len,
 				      attr.u.ppid.id);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f5a98082ac7a..ed8564eb97c8 100644
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
+		err = ops->ndo_get_port_parent_id(dev, &attr.u.ppid);
+	else
+		err = switchdev_port_attr_get(dev, &attr);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			return 0;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index fb99002c3d4e..9f67394b6691 100644
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
+	    !ops->ndo_get_port_parent_id(dev, &attr.ppid)) {
+		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
+		v->dev_parent_id.id_len = attr.u.ppid.id_len;
+	} else if (!switchdev_port_attr_get(dev, &attr)) {
 		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
 		v->dev_parent_id.id_len = attr.u.ppid.id_len;
 	} else {
-- 
2.17.1
