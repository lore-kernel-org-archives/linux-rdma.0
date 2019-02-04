From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 02/12] bnxt: Implement ndo_get_port_parent_id()
Date: Mon,  4 Feb 2019 15:36:23 -0800
Message-ID: <20190204233633.20421-3-f.fainelli@gmail.com>
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

BNXT only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
great candidate to be converted to use the ndo_get_port_parent_id() NDO
instead of implementing switchdev_port_attr_get(). The conversion is
straight forward here since the PF and VF code use the same getter.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 28 ++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  4 +--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 12 +++-----
 4 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a512871176b..1c2987c3d708 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9981,8 +9981,11 @@ static int bnxt_get_phys_port_name(struct net_device *dev, char *buf,
 	return 0;
 }
 
-int bnxt_port_attr_get(struct bnxt *bp, struct switchdev_attr *attr)
+int bnxt_get_port_parent_id(struct net_device *dev,
+			    struct netdev_phys_item_id *ppid)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
 	if (bp->eswitch_mode != DEVLINK_ESWITCH_MODE_SWITCHDEV)
 		return -EOPNOTSUPP;
 
@@ -9990,27 +9993,12 @@ int bnxt_port_attr_get(struct bnxt *bp, struct switchdev_attr *attr)
 	if (!BNXT_PF(bp))
 		return -EOPNOTSUPP;
 
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = sizeof(bp->switch_id);
-		memcpy(attr->u.ppid.id, bp->switch_id, attr->u.ppid.id_len);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
+	ppid->id_len = sizeof(bp->switch_id);
+	memcpy(ppid->id, bp->switch_id, ppid->id_len);
 
-static int bnxt_swdev_port_attr_get(struct net_device *dev,
-				    struct switchdev_attr *attr)
-{
-	return bnxt_port_attr_get(netdev_priv(dev), attr);
+	return 0;
 }
 
-static const struct switchdev_ops bnxt_switchdev_ops = {
-	.switchdev_port_attr_get	= bnxt_swdev_port_attr_get
-};
-
 static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_open		= bnxt_open,
 	.ndo_start_xmit		= bnxt_start_xmit,
@@ -10042,6 +10030,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_bpf		= bnxt_xdp,
 	.ndo_bridge_getlink	= bnxt_bridge_getlink,
 	.ndo_bridge_setlink	= bnxt_bridge_setlink,
+	.ndo_get_port_parent_id	= bnxt_get_port_parent_id,
 	.ndo_get_phys_port_name = bnxt_get_phys_port_name
 };
 
@@ -10400,7 +10389,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops = &bnxt_netdev_ops;
 	dev->watchdog_timeo = BNXT_TX_TIMEOUT;
 	dev->ethtool_ops = &bnxt_ethtool_ops;
-	SWITCHDEV_SET_OPS(dev, &bnxt_switchdev_ops);
 	pci_set_drvdata(pdev, dev);
 
 	rc = bnxt_alloc_hwrm_resources(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5c886a700bcc..17554d4be651 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -22,7 +22,6 @@
 #include <linux/rhashtable.h>
 #include <net/devlink.h>
 #include <net/dst_metadata.h>
-#include <net/switchdev.h>
 #include <net/xdp.h>
 #include <linux/net_dim.h>
 
@@ -1795,7 +1794,8 @@ int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc);
 int bnxt_get_max_rings(struct bnxt *, int *, int *, bool);
 int bnxt_restore_pf_fw_resources(struct bnxt *bp);
-int bnxt_port_attr_get(struct bnxt *bp, struct switchdev_attr *attr);
+int bnxt_get_port_parent_id(struct net_device *dev,
+			    struct netdev_phys_item_id *ppid);
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index c683b5e96b1d..a3a772fb6d67 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -12,6 +12,7 @@
 #include <linux/if_vlan.h>
 #include <net/flow_dissector.h>
 #include <net/pkt_cls.h>
+#include <net/switchdev.h>
 #include <net/tc_act/tc_gact.h>
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_mirred.h>
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 9a25c05aa571..29d03c0f4693 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -237,21 +237,17 @@ static void bnxt_vf_rep_get_drvinfo(struct net_device *dev,
 	strlcpy(info->version, DRV_MODULE_VERSION, sizeof(info->version));
 }
 
-static int bnxt_vf_rep_port_attr_get(struct net_device *dev,
-				     struct switchdev_attr *attr)
+static int bnxt_vf_rep_get_port_parent_id(struct net_device *dev,
+					  struct netdev_phys_item_id *ppid)
 {
 	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
 
 	/* as only PORT_PARENT_ID is supported currently use common code
 	 * between PF and VF-rep for now.
 	 */
-	return bnxt_port_attr_get(vf_rep->bp, attr);
+	return bnxt_get_port_parent_id(vf_rep->bp->dev, attr);
 }
 
-static const struct switchdev_ops bnxt_vf_rep_switchdev_ops = {
-	.switchdev_port_attr_get	= bnxt_vf_rep_port_attr_get
-};
-
 static const struct ethtool_ops bnxt_vf_rep_ethtool_ops = {
 	.get_drvinfo		= bnxt_vf_rep_get_drvinfo
 };
@@ -262,6 +258,7 @@ static const struct net_device_ops bnxt_vf_rep_netdev_ops = {
 	.ndo_start_xmit		= bnxt_vf_rep_xmit,
 	.ndo_get_stats64	= bnxt_vf_rep_get_stats64,
 	.ndo_setup_tc		= bnxt_vf_rep_setup_tc,
+	.ndo_get_port_parent_id	= bnxt_vf_rep_get_port_parent_id,
 	.ndo_get_phys_port_name = bnxt_vf_rep_get_phys_port_name
 };
 
@@ -392,7 +389,6 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 
 	dev->netdev_ops = &bnxt_vf_rep_netdev_ops;
 	dev->ethtool_ops = &bnxt_vf_rep_ethtool_ops;
-	SWITCHDEV_SET_OPS(dev, &bnxt_vf_rep_switchdev_ops);
 	/* Just inherit all the featues of the parent PF as the VF-R
 	 * uses the RX/TX rings of the parent PF
 	 */
-- 
2.17.1
