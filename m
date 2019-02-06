From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v4 03/12] liquidio: Implement ndo_get_port_parent_id()
Date: Wed,  6 Feb 2019 09:45:37 -0800
Message-ID: <20190206174546.23597-4-f.fainelli@gmail.com>
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

Liquidio only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it
a great candidate to be converted to use the ndo_get_port_parent_id()
NDO instead of implementing switchdev_port_attr_get().

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 22 ++++------------
 .../net/ethernet/cavium/liquidio/lio_vf_rep.c | 25 ++++++-------------
 2 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 3d24133e5e49..e97e6754ee09 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -21,7 +21,6 @@
 #include <linux/firmware.h>
 #include <net/vxlan.h>
 #include <linux/kthread.h>
-#include <net/switchdev.h>
 #include "liquidio_common.h"
 #include "octeon_droq.h"
 #include "octeon_iq.h"
@@ -3184,7 +3183,8 @@ static const struct devlink_ops liquidio_devlink_ops = {
 };
 
 static int
-lio_pf_switchdev_attr_get(struct net_device *dev, struct switchdev_attr *attr)
+liquidio_get_port_parent_id(struct net_device *dev,
+			    struct netdev_phys_item_id *ppid)
 {
 	struct lio *lio = GET_LIO(dev);
 	struct octeon_device *oct = lio->oct_dev;
@@ -3192,24 +3192,12 @@ lio_pf_switchdev_attr_get(struct net_device *dev, struct switchdev_attr *attr)
 	if (oct->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
 		return -EOPNOTSUPP;
 
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = ETH_ALEN;
-		ether_addr_copy(attr->u.ppid.id,
-				(void *)&lio->linfo.hw_addr + 2);
-		break;
-
-	default:
-		return -EOPNOTSUPP;
-	}
+	ppid->id_len = ETH_ALEN;
+	ether_addr_copy(ppid->id, (void *)&lio->linfo.hw_addr + 2);
 
 	return 0;
 }
 
-static const struct switchdev_ops lio_pf_switchdev_ops = {
-	.switchdev_port_attr_get = lio_pf_switchdev_attr_get,
-};
-
 static int liquidio_get_vf_stats(struct net_device *netdev, int vfidx,
 				 struct ifla_vf_stats *vf_stats)
 {
@@ -3259,6 +3247,7 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_set_vf_trust	= liquidio_set_vf_trust,
 	.ndo_set_vf_link_state  = liquidio_set_vf_link_state,
 	.ndo_get_vf_stats	= liquidio_get_vf_stats,
+	.ndo_get_port_parent_id	= liquidio_get_port_parent_id,
 };
 
 /** \brief Entry point for the liquidio module
@@ -3534,7 +3523,6 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		 * netdev tasks.
 		 */
 		netdev->netdev_ops = &lionetdevops;
-		SWITCHDEV_SET_OPS(netdev, &lio_pf_switchdev_ops);
 
 		retval = netif_set_real_num_rx_queues(netdev, num_oqueues);
 		if (retval) {
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index de61060721c4..f3f2e71431ac 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -25,7 +25,6 @@
 #include "octeon_nic.h"
 #include "octeon_main.h"
 #include "octeon_network.h"
-#include <net/switchdev.h>
 #include "lio_vf_rep.h"
 
 static int lio_vf_rep_open(struct net_device *ndev);
@@ -38,6 +37,8 @@ static int lio_vf_rep_phys_port_name(struct net_device *dev,
 static void lio_vf_rep_get_stats64(struct net_device *dev,
 				   struct rtnl_link_stats64 *stats64);
 static int lio_vf_rep_change_mtu(struct net_device *ndev, int new_mtu);
+static int lio_vf_get_port_parent_id(struct net_device *dev,
+				     struct netdev_phys_item_id *ppid);
 
 static const struct net_device_ops lio_vf_rep_ndev_ops = {
 	.ndo_open = lio_vf_rep_open,
@@ -47,6 +48,7 @@ static const struct net_device_ops lio_vf_rep_ndev_ops = {
 	.ndo_get_phys_port_name = lio_vf_rep_phys_port_name,
 	.ndo_get_stats64 = lio_vf_rep_get_stats64,
 	.ndo_change_mtu = lio_vf_rep_change_mtu,
+	.ndo_get_port_parent_id = lio_vf_get_port_parent_id,
 };
 
 static int
@@ -443,31 +445,19 @@ lio_vf_rep_pkt_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
-static int
-lio_vf_rep_attr_get(struct net_device *dev, struct switchdev_attr *attr)
+static int lio_vf_get_port_parent_id(struct net_device *dev,
+				     struct netdev_phys_item_id *ppid)
 {
 	struct lio_vf_rep_desc *vf_rep = netdev_priv(dev);
 	struct net_device *parent_ndev = vf_rep->parent_ndev;
 	struct lio *lio = GET_LIO(parent_ndev);
 
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = ETH_ALEN;
-		ether_addr_copy(attr->u.ppid.id,
-				(void *)&lio->linfo.hw_addr + 2);
-		break;
-
-	default:
-		return -EOPNOTSUPP;
-	}
+	ppid->id_len = ETH_ALEN;
+	ether_addr_copy(ppid->id, (void *)&lio->linfo.hw_addr + 2);
 
 	return 0;
 }
 
-static const struct switchdev_ops lio_vf_rep_switchdev_ops = {
-	.switchdev_port_attr_get        = lio_vf_rep_attr_get,
-};
-
 static void
 lio_vf_rep_fetch_stats(struct work_struct *work)
 {
@@ -524,7 +514,6 @@ lio_vf_rep_create(struct octeon_device *oct)
 		ndev->min_mtu = LIO_MIN_MTU_SIZE;
 		ndev->max_mtu = LIO_MAX_MTU_SIZE;
 		ndev->netdev_ops = &lio_vf_rep_ndev_ops;
-		SWITCHDEV_SET_OPS(ndev, &lio_vf_rep_switchdev_ops);
 
 		vf_rep = netdev_priv(ndev);
 		memset(vf_rep, 0, sizeof(*vf_rep));
-- 
2.17.1
