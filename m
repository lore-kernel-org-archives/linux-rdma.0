From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 08/13] liquidio: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri,  1 Feb 2019 14:06:52 -0800
Message-ID: <20190201220657.30170-9-f.fainelli@gmail.com>
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

We register a single blocking switchdev notifier for the PF part of the
driver, and we register another blocking switchdev notifier, following
what was done with the existing netdevice notifier within the VF
representor driver.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 48 ++++++++++++++++++-
 .../net/ethernet/cavium/liquidio/lio_vf_rep.c | 45 ++++++++++++++++-
 2 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 3d24133e5e49..b9d48e4181fc 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -162,6 +162,8 @@ static int liquidio_set_vf_link_state(struct net_device *netdev, int vfidx,
 
 static struct handshake handshake[MAX_OCTEON_DEVICES];
 static struct completion first_stage;
+static int liquidio_switchdev_blocking_event(struct notifier_block *nb,
+					     unsigned long event, void *ptr);
 
 static void octeon_droq_bh(unsigned long pdev)
 {
@@ -469,12 +471,25 @@ static struct pci_driver liquidio_pci_driver = {
 #endif
 };
 
+static struct notifier_block liquidio_blocking_nb = {
+	.notifier_call = liquidio_switchdev_blocking_event,
+};
+
 /**
  * \brief register PCI driver
  */
 static int liquidio_init_pci(void)
 {
-	return pci_register_driver(&liquidio_pci_driver);
+	int rc;
+
+	rc = register_switchdev_blocking_notifier(&liquidio_blocking_nb);
+	if (rc)
+		return rc;
+	rc = pci_register_driver(&liquidio_pci_driver);
+	if (rc)
+		unregister_switchdev_blocking_notifier(&liquidio_blocking_nb);
+
+	return rc;
 }
 
 /**
@@ -483,6 +498,7 @@ static int liquidio_init_pci(void)
 static void liquidio_deinit_pci(void)
 {
 	pci_unregister_driver(&liquidio_pci_driver);
+	unregister_switchdev_blocking_notifier(&liquidio_blocking_nb);
 }
 
 /**
@@ -3261,6 +3277,36 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_get_vf_stats	= liquidio_get_vf_stats,
 };
 
+static int lio_pf_attr_event(unsigned long event, struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	rc = lio_pf_switchdev_attr_get(dev, port_attr_info->attr);
+
+	port_attr_info->handled = true;
+	return notifier_from_errno(rc);
+}
+
+static int liquidio_switchdev_blocking_event(struct notifier_block *nb,
+					     unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+
+	if (dev->netdev_ops != &lionetdevops)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return lio_pf_attr_event(event, dev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
 /** \brief Entry point for the liquidio module
  */
 static int __init liquidio_init(void)
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index de61060721c4..d396c004c1be 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -468,6 +468,21 @@ static const struct switchdev_ops lio_vf_rep_switchdev_ops = {
 	.switchdev_port_attr_get        = lio_vf_rep_attr_get,
 };
 
+static int lio_vf_rep_swdev_port_attr_event(unsigned long event,
+		struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	rc = lio_vf_rep_attr_get(dev, port_attr_info->attr);
+	port_attr_info->handled = true;
+
+	return notifier_from_errno(rc);
+}
+
 static void
 lio_vf_rep_fetch_stats(struct work_struct *work)
 {
@@ -538,7 +553,6 @@ lio_vf_rep_create(struct octeon_device *oct)
 
 		if (register_netdev(ndev)) {
 			dev_err(&oct->pci_dev->dev, "VF rep nerdev registration failed\n");
-
 			free_netdev(ndev);
 			goto cleanup;
 		}
@@ -664,20 +678,49 @@ static struct notifier_block lio_vf_rep_netdev_notifier = {
 	.notifier_call = lio_vf_rep_netdev_event,
 };
 
+static int lio_vf_rep_swdev_event(struct notifier_block *nb,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
+
+	if (ndev->netdev_ops != &lio_vf_rep_ndev_ops)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return lio_vf_rep_swdev_port_attr_event(event, ndev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block lio_vf_rep_swdev_nb = {
+	.notifier_call = lio_vf_rep_swdev_event,
+};
+
 int
 lio_vf_rep_modinit(void)
 {
+	int rc;
+
 	if (register_netdevice_notifier(&lio_vf_rep_netdev_notifier)) {
 		pr_err("netdev notifier registration failed\n");
 		return -EFAULT;
 	}
 
+	rc = register_switchdev_blocking_notifier(&lio_vf_rep_swdev_nb);
+	if (rc) {
+		unregister_netdevice_notifier(&lio_vf_rep_netdev_notifier);
+		return rc;
+	}
+
 	return 0;
 }
 
 void
 lio_vf_rep_modexit(void)
 {
+	unregister_switchdev_blocking_notifier(&lio_vf_rep_swdev_nb);
 	if (unregister_netdevice_notifier(&lio_vf_rep_netdev_notifier))
 		pr_err("netdev notifier unregister failed\n");
 }
-- 
2.17.1
