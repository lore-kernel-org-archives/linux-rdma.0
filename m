From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 09/13] mlxsw: switchx2: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri,  1 Feb 2019 14:06:53 -0800
Message-ID: <20190201220657.30170-10-f.fainelli@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <viv>
List-Id: linux-rdma@vger.kernel.org

Following patches will change the way we communicate getting or setting
a port's attribute and use a blocking notifier to perform those tasks.

Prepare bnxt to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET and simply translate that into the existing
switchdev_ops::switchdev_port_attr_get operation.

We register a single blocking switchdev notifier for the entire driver
instance and check that thet network device maps to the one that
switchx2 manages.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/mellanox/mlxsw/switchx2.c    | 43 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 2d4f213e154d..82fb8f1bb6e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -923,6 +923,36 @@ static const struct switchdev_ops mlxsw_sx_port_switchdev_ops = {
 	.switchdev_port_attr_get	= mlxsw_sx_port_attr_get,
 };
 
+static int mlxsw_sx_port_attr_event(unsigned long event,
+		struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	rc = mlxsw_sx_port_attr_get(dev, port_attr_info->attr);
+	port_attr_info->handled = true;
+	return notifier_from_errno(rc);
+}
+
+static int mlxsw_sx_swdev_blocking_event(struct notifier_block *nb,
+					 unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+
+	if (dev->netdev_ops != &mlxsw_sx_port_netdev_ops)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return mlxsw_sx_port_attr_event(event, dev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int mlxsw_sx_hw_id_get(struct mlxsw_sx *mlxsw_sx)
 {
 	char spad_pl[MLXSW_REG_SPAD_LEN] = {0};
@@ -1638,6 +1668,10 @@ static void mlxsw_sx_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sx_ports_remove(mlxsw_sx);
 }
 
+static struct notifier_block mlxsw_sx_swdev_nb = {
+	.notifier_call	= mlxsw_sx_swdev_blocking_event,
+};
+
 static const struct mlxsw_config_profile mlxsw_sx_config_profile = {
 	.used_max_vepa_channels		= 1,
 	.max_vepa_channels		= 0,
@@ -1698,10 +1732,14 @@ static int __init mlxsw_sx_module_init(void)
 {
 	int err;
 
-	err = mlxsw_core_driver_register(&mlxsw_sx_driver);
+	err = register_switchdev_blocking_notifier(&mlxsw_sx_swdev_nb);
 	if (err)
 		return err;
 
+	err = mlxsw_core_driver_register(&mlxsw_sx_driver);
+	if (err)
+		goto err_unregister_notifier;
+
 	err = mlxsw_pci_driver_register(&mlxsw_sx_pci_driver);
 	if (err)
 		goto err_pci_driver_register;
@@ -1710,6 +1748,8 @@ static int __init mlxsw_sx_module_init(void)
 
 err_pci_driver_register:
 	mlxsw_core_driver_unregister(&mlxsw_sx_driver);
+err_unregister_notifier:
+	unregister_switchdev_blocking_notifier(&mlxsw_sx_swdev_nb);
 	return err;
 }
 
@@ -1717,6 +1757,7 @@ static void __exit mlxsw_sx_module_exit(void)
 {
 	mlxsw_pci_driver_unregister(&mlxsw_sx_pci_driver);
 	mlxsw_core_driver_unregister(&mlxsw_sx_driver);
+	unregister_switchdev_blocking_notifier(&mlxsw_sx_swdev_nb);
 }
 
 module_init(mlxsw_sx_module_init);
-- 
2.17.1
