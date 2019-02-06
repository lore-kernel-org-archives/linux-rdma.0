From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v4 08/12] rocker: Implement ndo_get_port_parent_id()
Date: Wed,  6 Feb 2019 09:45:42 -0800
Message-ID: <20190206174546.23597-9-f.fainelli@gmail.com>
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

mlxsw implements SWITCHDEV_ATTR_ID_PORT_PARENT_ID and we want to get rid
of switchdev_ops eventually, ease that migration by implementing a
ndo_get_port_parent_id() function which returns what
switchdev_port_attr_get() would do.

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/rocker/rocker_main.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 62a205eba9f7..596f44dbfae1 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2026,6 +2026,18 @@ static void rocker_port_neigh_destroy(struct net_device *dev,
 			    err);
 }
 
+static int rocker_port_get_port_parent_id(struct net_device *dev,
+					  struct netdev_phys_item_id *ppid)
+{
+	const struct rocker_port *rocker_port = netdev_priv(dev);
+	const struct rocker *rocker = rocker_port->rocker;
+
+	ppid->id_len = sizeof(rocker->hw.id);
+	memcpy(&ppid->id, &rocker->hw.id, ppid->id_len);
+
+	return 0;
+}
+
 static const struct net_device_ops rocker_port_netdev_ops = {
 	.ndo_open			= rocker_port_open,
 	.ndo_stop			= rocker_port_stop,
@@ -2035,6 +2047,7 @@ static const struct net_device_ops rocker_port_netdev_ops = {
 	.ndo_get_phys_port_name		= rocker_port_get_phys_port_name,
 	.ndo_change_proto_down		= rocker_port_change_proto_down,
 	.ndo_neigh_destroy		= rocker_port_neigh_destroy,
+	.ndo_get_port_parent_id		= rocker_port_get_port_parent_id,
 };
 
 /********************
@@ -2049,10 +2062,6 @@ static int rocker_port_attr_get(struct net_device *dev,
 	int err = 0;
 
 	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = sizeof(rocker->hw.id);
-		memcpy(&attr->u.ppid.id, &rocker->hw.id, attr->u.ppid.id_len);
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = rocker_world_port_attr_bridge_flags_get(rocker_port,
 							      &attr->u.brport_flags);
-- 
2.17.1
