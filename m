From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v4 10/12] staging: fsl-dpaa2: ethsw: Implement
 ndo_get_port_parent_id()
Date: Wed,  6 Feb 2019 09:45:44 -0800
Message-ID: <20190206174546.23597-11-f.fainelli@gmail.com>
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

ethsw implements SWITCHDEV_ATTR_ID_PORT_PARENT_ID and we want to get rid
of switchdev_ops eventually, ease that migration by implementing a
ndo_get_port_parent_id() function which returns what
switchdev_port_attr_get() would do.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index daabaceeea52..e559f4c25cf7 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -505,6 +505,17 @@ static netdev_tx_t port_dropframe(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int swdev_get_port_parent_id(struct net_device *dev,
+				    struct netdev_phys_item_id *ppid)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(dev);
+
+	ppid->id_len = 1;
+	ppid->id[0] = port_priv->ethsw_data->dev_id;
+
+	return 0;
+}
+
 static const struct net_device_ops ethsw_port_ops = {
 	.ndo_open		= port_open,
 	.ndo_stop		= port_stop,
@@ -515,6 +526,7 @@ static const struct net_device_ops ethsw_port_ops = {
 	.ndo_get_offload_stats	= port_get_offload_stats,
 
 	.ndo_start_xmit		= port_dropframe,
+	.ndo_get_port_parent_id	= swdev_get_port_parent_id,
 };
 
 static void ethsw_links_state_update(struct ethsw_core *ethsw)
@@ -634,10 +646,6 @@ static int swdev_port_attr_get(struct net_device *netdev,
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 
 	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = 1;
-		attr->u.ppid.id[0] = port_priv->ethsw_data->dev_id;
-		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		attr->u.brport_flags =
 			(port_priv->ethsw_data->learning ? BR_LEARNING : 0) |
-- 
2.17.1
