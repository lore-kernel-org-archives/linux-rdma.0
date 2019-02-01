From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 04/13] mlxsw: spectrum_switchdev: Handle SWITCHDEV_PORT_ATTR_GET/SET
Date: Fri,  1 Feb 2019 14:06:48 -0800
Message-ID: <20190201220657.30170-5-f.fainelli@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <viv>
List-Id: linux-rdma@vger.kernel.org

Following patches will change the way we communicate getting or setting
a port's attribute and use a blocking notifier to perform those tasks.

Prepare mlxsw to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET/SET and simply translate that into the existing
mlxsw_sp_port_attr_{set,get} calls.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 0f4e68d31cc3..7c0df736587c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3442,6 +3442,26 @@ mlxsw_sp_switchdev_handle_vxlan_obj_del(struct net_device *vxlan_dev,
 	}
 }
 
+static int
+mlxsw_sp_switchdev_port_attr_event(unsigned long event, struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int err = -EOPNOTSUPP;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = mlxsw_sp_port_attr_set(dev, port_attr_info->attr,
+					     port_attr_info->trans);
+		break;
+	case SWITCHDEV_PORT_ATTR_GET:
+		err = mlxsw_sp_port_attr_get(dev, port_attr_info->attr);
+		break;
+	}
+
+	port_attr_info->handled = true;
+	return notifier_from_errno(err);
+}
+
 static int mlxsw_sp_switchdev_blocking_event(struct notifier_block *unused,
 					     unsigned long event, void *ptr)
 {
@@ -3465,6 +3485,9 @@ static int mlxsw_sp_switchdev_blocking_event(struct notifier_block *unused,
 							mlxsw_sp_port_dev_check,
 							mlxsw_sp_port_obj_del);
 		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+	case SWITCHDEV_PORT_ATTR_GET:
+		return mlxsw_sp_switchdev_port_attr_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
-- 
2.17.1
