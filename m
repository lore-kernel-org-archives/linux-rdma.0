From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 11/13] nfp: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri,  1 Feb 2019 14:06:55 -0800
Message-ID: <20190201220657.30170-12-f.fainelli@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <viv>
List-Id: linux-rdma@vger.kernel.org

Following patches will change the way we communicate getting or setting
a port's attribute and use a blocking notifier to perform those tasks.

Prepare nfp to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET and simply translate that into the existing
switchdev_ops::switchdev_port_attr_get operation.

We register a single blocking switchdev notifier for the entire driver
instance and we differentiate a "net" from a "repr" by comparing the
network device's netdev_ops with the ones that this driver manages.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c   | 14 +++++++++++++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h    |  3 +++
 .../net/ethernet/netronome/nfp/nfp_net_common.c | 17 +++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_port.c   | 15 +++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_port.h   |  5 ++++-
 5 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 6c10e8d119e4..50c111280cd4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -17,6 +17,7 @@
 #include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <net/devlink.h>
+#include <net/switchdev.h>
 
 #include "nfpcore/nfp.h"
 #include "nfpcore/nfp_cpp.h"
@@ -708,6 +709,10 @@ static void nfp_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static struct notifier_block nfp_swdev_blocking_nb = {
+	.notifier_call	= nfp_switchdev_blocking_event,
+};
+
 static struct pci_driver nfp_pci_driver = {
 	.name			= nfp_driver_name,
 	.id_table		= nfp_pci_device_ids,
@@ -725,9 +730,13 @@ static int __init nfp_main_init(void)
 
 	nfp_net_debugfs_create();
 
+	err = register_switchdev_blocking_notifier(&nfp_swdev_blocking_nb);
+	if (err)
+		goto err_destroy_debugfs;
+
 	err = pci_register_driver(&nfp_pci_driver);
 	if (err < 0)
-		goto err_destroy_debugfs;
+		goto err_unreg_notifier;
 
 	err = pci_register_driver(&nfp_netvf_pci_driver);
 	if (err)
@@ -737,6 +746,8 @@ static int __init nfp_main_init(void)
 
 err_unreg_pf:
 	pci_unregister_driver(&nfp_pci_driver);
+err_unreg_notifier:
+	unregister_switchdev_blocking_notifier(&nfp_swdev_blocking_nb);
 err_destroy_debugfs:
 	nfp_net_debugfs_destroy();
 	return err;
@@ -746,6 +757,7 @@ static void __exit nfp_main_exit(void)
 {
 	pci_unregister_driver(&nfp_netvf_pci_driver);
 	pci_unregister_driver(&nfp_pci_driver);
+	unregister_switchdev_blocking_notifier(&nfp_swdev_blocking_nb);
 	nfp_net_debugfs_destroy();
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index be37c2d6151c..57f7d6d634ea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -915,4 +915,7 @@ static inline void nfp_net_debugfs_dir_clean(struct dentry **dir)
 }
 #endif /* CONFIG_NFP_DEBUG */
 
+int nfp_switchdev_blocking_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr);
+
 #endif /* _NFP_NET_H_ */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 7d2d4241498f..c2c5e7e3aab0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3955,3 +3955,20 @@ void nfp_net_clean(struct nfp_net *nn)
 	unregister_netdev(nn->dp.netdev);
 	nfp_net_reconfig_wait_posted(nn);
 }
+
+int nfp_switchdev_blocking_event(struct notifier_block *nb,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+
+	if (!nfp_netdev_is_nfp_repr(dev) &&
+	    !nfp_netdev_is_nfp_net(dev))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return nfp_port_switchdev_attr_event(event, dev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 86bc149ca231..578477242ae9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -59,6 +59,21 @@ const struct switchdev_ops nfp_port_switchdev_ops = {
 	.switchdev_port_attr_get	= nfp_port_attr_get,
 };
 
+int nfp_port_switchdev_attr_event(unsigned long event,
+		struct net_device *netdev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	rc = nfp_port_attr_get(netdev, port_attr_info->attr);
+	port_attr_info->handled = true;
+
+	return notifier_from_errno(rc);
+}
+
 int nfp_port_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		      void *type_data)
 {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index b2479a2a49e5..35342f88f715 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -10,6 +10,7 @@ struct net_device;
 struct nfp_app;
 struct nfp_pf;
 struct nfp_port;
+struct switchdev_notifier_port_attr_info;
 
 /**
  * enum nfp_port_type - type of port NFP can switch traffic to
@@ -90,7 +91,9 @@ struct nfp_port {
 };
 
 extern const struct ethtool_ops nfp_port_ethtool_ops;
-extern const struct switchdev_ops nfp_port_switchdev_ops;
+
+int nfp_port_switchdev_attr_event(unsigned long event, struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info);
 
 __printf(2, 3) u8 *nfp_pr_et(u8 *data, const char *fmt, ...);
 
-- 
2.17.1
