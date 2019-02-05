From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v2 07/12] nfp: Implement ndo_get_port_parent_id()
Date: Tue,  5 Feb 2019 14:13:06 -0800
Message-ID: <20190205221311.18476-8-f.fainelli@gmail.com>
References: <20190205221311.18476-1-f.fainelli@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190205221311.18476-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

NFP only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
great candidate to be converted to use the ndo_get_port_parent_id() NDO
instead of implementing switchdev_port_attr_get().

Since NFP uses switchdev_port_same_parent_id() convert it to use
netdev_port_same_parent_id().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../ethernet/netronome/nfp/flower/action.c    |  3 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 +---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  4 +---
 drivers/net/ethernet/netronome/nfp/nfp_port.c | 23 +++++--------------
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  4 +++-
 5 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 8d54b36afee8..7b217d7285c7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -3,7 +3,6 @@
 
 #include <linux/bitfield.h>
 #include <net/pkt_cls.h>
-#include <net/switchdev.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_mirred.h>
@@ -137,7 +136,7 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 
 		if (nfp_netdev_is_nfp_repr(in_dev)) {
 			/* Confirm ingress and egress are on same device. */
-			if (!switchdev_port_same_parent_id(in_dev, out_dev))
+			if (!netdev_port_same_parent_id(in_dev, out_dev))
 				return -EOPNOTSUPP;
 		}
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 7d2d4241498f..776f6c07701b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -36,7 +36,6 @@
 #include <linux/vmalloc.h>
 #include <linux/ktime.h>
 
-#include <net/switchdev.h>
 #include <net/vxlan.h>
 
 #include "nfpcore/nfp_nsp.h"
@@ -3531,6 +3530,7 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_udp_tunnel_add	= nfp_net_add_vxlan_port,
 	.ndo_udp_tunnel_del	= nfp_net_del_vxlan_port,
 	.ndo_bpf		= nfp_net_xdp,
+	.ndo_get_port_parent_id	= nfp_port_get_port_parent_id,
 };
 
 /**
@@ -3815,8 +3815,6 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	netdev->netdev_ops = &nfp_net_netdev_ops;
 	netdev->watchdog_timeo = msecs_to_jiffies(5 * 1000);
 
-	SWITCHDEV_SET_OPS(netdev, &nfp_port_switchdev_ops);
-
 	/* MTU range: 68 - hw-specific max */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = nn->max_mtu;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 69d7aebda09b..62839807e21e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -5,7 +5,6 @@
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/lockdep.h>
 #include <net/dst_metadata.h>
-#include <net/switchdev.h>
 
 #include "nfpcore/nfp_cpp.h"
 #include "nfpcore/nfp_nsp.h"
@@ -273,6 +272,7 @@ const struct net_device_ops nfp_repr_netdev_ops = {
 	.ndo_fix_features	= nfp_repr_fix_features,
 	.ndo_set_features	= nfp_port_set_features,
 	.ndo_set_mac_address    = eth_mac_addr,
+	.ndo_get_port_parent_id	= nfp_port_get_port_parent_id,
 };
 
 void
@@ -336,8 +336,6 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	netdev->max_mtu = pf_netdev->max_mtu;
 
-	SWITCHDEV_SET_OPS(netdev, &nfp_port_switchdev_ops);
-
 	/* Set features the lower device can support with representors */
 	if (repr_cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 86bc149ca231..b9aa7eb99067 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -31,34 +31,23 @@ struct nfp_port *nfp_port_from_netdev(struct net_device *netdev)
 	return NULL;
 }
 
-static int
-nfp_port_attr_get(struct net_device *netdev, struct switchdev_attr *attr)
+int nfp_port_get_port_parent_id(struct net_device *netdev,
+				struct netdev_phys_item_id *ppid)
 {
 	struct nfp_port *port;
+	const u8 *serial;
 
 	port = nfp_port_from_netdev(netdev);
 	if (!port)
 		return -EOPNOTSUPP;
 
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID: {
-		const u8 *serial;
-		/* N.B: attr->u.ppid.id is binary data */
-		attr->u.ppid.id_len = nfp_cpp_serial(port->app->cpp, &serial);
-		memcpy(&attr->u.ppid.id, serial, attr->u.ppid.id_len);
-		break;
-	}
-	default:
-		return -EOPNOTSUPP;
-	}
+	/* N.B: attr->u.ppid.id is binary data */
+	ppid->id_len = nfp_cpp_serial(port->app->cpp, &serial);
+	memcpy(&ppid->id, serial, ppid->id_len);
 
 	return 0;
 }
 
-const struct switchdev_ops nfp_port_switchdev_ops = {
-	.switchdev_port_attr_get	= nfp_port_attr_get,
-};
-
 int nfp_port_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		      void *type_data)
 {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index b2479a2a49e5..90ae053f5c07 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -7,6 +7,7 @@
 #include <net/devlink.h>
 
 struct net_device;
+struct netdev_phys_item_id;
 struct nfp_app;
 struct nfp_pf;
 struct nfp_port;
@@ -90,7 +91,6 @@ struct nfp_port {
 };
 
 extern const struct ethtool_ops nfp_port_ethtool_ops;
-extern const struct switchdev_ops nfp_port_switchdev_ops;
 
 __printf(2, 3) u8 *nfp_pr_et(u8 *data, const char *fmt, ...);
 
@@ -106,6 +106,8 @@ int
 nfp_port_set_features(struct net_device *netdev, netdev_features_t features);
 
 struct nfp_port *nfp_port_from_netdev(struct net_device *netdev);
+int nfp_port_get_port_parent_id(struct net_device *netdev,
+				struct netdev_phys_item_id *ppid);
 struct nfp_port *
 nfp_port_from_id(struct nfp_pf *pf, enum nfp_port_type type, unsigned int id);
 struct nfp_eth_table_port *__nfp_port_get_eth_port(struct nfp_port *port);
-- 
2.17.1
