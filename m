From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 07/13] bnxt: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri,  1 Feb 2019 14:06:51 -0800
Message-ID: <20190201220657.30170-8-f.fainelli@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
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
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, John Hurley <john.hurley@netronome.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, "Francois H. Theron" <francois.theron@netronome.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Ivan Vecera <ivecera@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Vivien Didelot <vivien.didelot@gmail.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Daniel Borkmann <daniel@iogearbox.net>, Simon Horman <simon.horman@netronome.com>, Satanand Burla <sburla@marvell.com>, Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@>
List-Id: linux-rdma@vger.kernel.org

Following patches will change the way we communicate getting or setting
a port's attribute and use a blocking notifier to perform those tasks.

Prepare bnxt to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET and simply translate that into the existing
switchdev_ops::switchdev_port_attr_get operation.

We register a single blocking switchdev notifier for the entire driver
instance and we differentiate a PF from a VF by comparing the network
device's netdev_ops with the ones that this driver manages.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 58 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h |  8 +++
 3 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a512871176b..c3178ca4a004 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10045,6 +10045,45 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_get_phys_port_name = bnxt_get_phys_port_name
 };
 
+static int bnxt_swdev_port_attr_event(unsigned long event,
+		struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	if (bnxt_dev_is_vf_rep(dev))
+		rc = bnxt_vf_rep_port_attr_get(dev, port_attr_info->attr);
+	else
+		rc = bnxt_port_attr_get(netdev_priv(dev), port_attr_info->attr);
+
+	port_attr_info->handled = true;
+	return notifier_from_errno(rc);
+}
+
+static int bnxt_switchdev_blocking_event(struct notifier_block *nb,
+					 unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+
+	if (dev->netdev_ops != &bnxt_netdev_ops &&
+	    !bnxt_dev_is_vf_rep(dev))
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return bnxt_swdev_port_attr_event(event, dev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block bnxt_swdev_blocking_nb = {
+	.notifier_call = bnxt_switchdev_blocking_event,
+};
+
 static void bnxt_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
@@ -10817,8 +10856,24 @@ static struct pci_driver bnxt_pci_driver = {
 
 static int __init bnxt_init(void)
 {
+	int rc;
+
 	bnxt_debug_init();
-	return pci_register_driver(&bnxt_pci_driver);
+	rc = register_switchdev_blocking_notifier(&bnxt_swdev_blocking_nb);
+	if (rc)
+		goto err_debug;
+
+	rc = pci_register_driver(&bnxt_pci_driver);
+	if (rc)
+		goto err_unreg_notifier;
+
+	return rc;
+
+err_unreg_notifier:
+	unregister_switchdev_notifier(&bnxt_swdev_blocking_nb);
+err_debug:
+	bnxt_debug_exit();
+	return rc;
 }
 
 static void __exit bnxt_exit(void)
@@ -10826,6 +10881,7 @@ static void __exit bnxt_exit(void)
 	pci_unregister_driver(&bnxt_pci_driver);
 	if (bnxt_pf_wq)
 		destroy_workqueue(bnxt_pf_wq);
+	unregister_switchdev_notifier(&bnxt_swdev_blocking_nb);
 	bnxt_debug_exit();
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 9a25c05aa571..a06f93b49dd5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -237,8 +237,8 @@ static void bnxt_vf_rep_get_drvinfo(struct net_device *dev,
 	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
-static int bnxt_vf_rep_port_attr_get(struct net_device *dev,
-				     struct switchdev_attr *attr)
+int bnxt_vf_rep_port_attr_get(struct net_device *dev,
+			      struct switchdev_attr *attr)
 {
 	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
index d7287651422f..ba24ac222182 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h
@@ -32,6 +32,8 @@ bool bnxt_dev_is_vf_rep(struct net_device *dev);
 int bnxt_dl_eswitch_mode_get(struct devlink *devlink, u16 *mode);
 int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 			     struct netlink_ext_ack *extack);
+int bnxt_vf_rep_port_attr_get(struct net_device *dev,
+			      struct switchdev_attr *attr);
 
 #else
 
@@ -61,5 +63,11 @@ static inline bool bnxt_dev_is_vf_rep(struct net_device *dev)
 {
 	return false;
 }
+
+static inline int bnxt_vf_rep_port_attr_get(struct net_device *dev,
+					    struct switchdev_attr *attr)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_BNXT_SRIOV */
 #endif /* BNXT_VFR_H */
-- 
2.17.1
