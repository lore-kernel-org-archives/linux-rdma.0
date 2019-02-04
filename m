From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 06/12] mscc: ocelot: Implement ndo_get_port_parent_id()
Date: Mon,  4 Feb 2019 15:36:27 -0800
Message-ID: <20190204233633.20421-7-f.fainelli@gmail.com>
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

Ocelot only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID as a valid
switchdev attribute getter, convert it to use ndo_get_port_parent_id()
and get rid of the switchdev_ops::switchdev_port_attr_get altogether.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 33 ++++++++++++------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c6a575eb0ff5..195306d05bcd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -916,6 +916,18 @@ static int ocelot_set_features(struct net_device *dev,
 	return 0;
 }
 
+static int ocelot_get_port_parent_id(struct net_device *dev,
+				     struct netdev_phys_item_id *ppid)
+{
+	struct ocelot_port *ocelot_port = netdev_priv(dev);
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	ppid->id_len = sizeof(ocelot->base_mac);
+	memcpy(&ppid->id, &ocelot->base_mac, ppid->id_len);
+
+	return 0;
+}
+
 static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_open			= ocelot_port_open,
 	.ndo_stop			= ocelot_port_stop,
@@ -930,6 +942,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_vlan_rx_add_vid		= ocelot_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
 	.ndo_set_features		= ocelot_set_features,
+	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
 };
 
 static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
@@ -1013,25 +1026,6 @@ static const struct ethtool_ops ocelot_ethtool_ops = {
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 };
 
-static int ocelot_port_attr_get(struct net_device *dev,
-				struct switchdev_attr *attr)
-{
-	struct ocelot_port *ocelot_port = netdev_priv(dev);
-	struct ocelot *ocelot = ocelot_port->ocelot;
-
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = sizeof(ocelot->base_mac);
-		memcpy(&attr->u.ppid.id, &ocelot->base_mac,
-		       attr->u.ppid.id_len);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
 static int ocelot_port_attr_stp_state_set(struct ocelot_port *ocelot_port,
 					  struct switchdev_trans *trans,
 					  u8 state)
@@ -1331,7 +1325,6 @@ static int ocelot_port_obj_del(struct net_device *dev,
 }
 
 static const struct switchdev_ops ocelot_port_switchdev_ops = {
-	.switchdev_port_attr_get	= ocelot_port_attr_get,
 	.switchdev_port_attr_set	= ocelot_port_attr_set,
 };
 
-- 
2.17.1
