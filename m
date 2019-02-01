From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 03/13] net: dsa: Handle SWITCHDEV_PORT_ATTR_GET/SET
Date: Fri,  1 Feb 2019 14:06:47 -0800
Message-ID: <20190201220657.30170-4-f.fainelli@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <viv>
List-Id: linux-rdma@vger.kernel.org

Following patches will change the way we communicate getting or setting
a port's attribute and use a blocking notifier to perform those tasks.

Prepare DSA to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET/SET and simply translate that into the existing
dsa_slave_port_attr_{set,get} calls.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/slave.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 91de3a663226..bc7d5092a1c7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1549,6 +1549,27 @@ dsa_slave_switchdev_port_obj_event(unsigned long event,
 	return notifier_from_errno(err);
 }
 
+static int
+dsa_slave_switchdev_port_attr_event(unsigned long event,
+		struct net_device *netdev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int err = -EOPNOTSUPP;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = dsa_slave_port_attr_set(netdev, port_attr_info->attr,
+					      port_attr_info->trans);
+		break;
+	case SWITCHDEV_PORT_ATTR_GET:
+		err = dsa_slave_port_attr_get(netdev, port_attr_info->attr);
+		break;
+	}
+
+	port_attr_info->handled = true;
+	return notifier_from_errno(err);
+}
+
 static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 					      unsigned long event, void *ptr)
 {
@@ -1561,6 +1582,9 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 	case SWITCHDEV_PORT_OBJ_ADD: /* fall through */
 	case SWITCHDEV_PORT_OBJ_DEL:
 		return dsa_slave_switchdev_port_obj_event(event, dev, ptr);
+	case SWITCHDEV_PORT_ATTR_SET: /* fallthrough */
+	case SWITCHDEV_PORT_ATTR_GET:
+		return dsa_slave_switchdev_port_attr_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
-- 
2.17.1
