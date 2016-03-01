From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/10] IB/ipoib: Add ndo operations for configuring VFs
Date: Tue,  1 Mar 2016 18:52:18 +0200
Message-ID: <1456851143-138332-6-git-send-email-eli@mellanox.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456851143-138332-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add ndo operations to the network driver that enables configuring the
following operations:

ipoib_set_vf_link_state - configure the VF link policy
ipoib_get_vf_config - get link state configuration
ipoib_set_vf_guid - set a VF port or node GUID
ipoib_get_vf_stats - get statistics of a VF

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 65 ++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 25509bbd4a05..80807d6e5c4c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -51,6 +51,7 @@
 #include <net/addrconf.h>
 #include <linux/inetdevice.h>
 #include <rdma/ib_cache.h>
+#include <linux/pci.h>
 
 #define DRV_VERSION "1.0.0"
 
@@ -1590,11 +1591,67 @@ void ipoib_dev_cleanup(struct net_device *dev)
 	priv->tx_ring = NULL;
 }
 
+static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_state)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	return ib_set_vf_link_state(priv->ca, vf, priv->port, link_state);
+}
+
+static int ipoib_get_vf_config(struct net_device *dev, int vf,
+			       struct ifla_vf_info *ivf)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	int err;
+
+	err = ib_get_vf_config(priv->ca, vf, priv->port, ivf);
+	if (err)
+		return err;
+
+	ivf->vf = vf;
+
+	return 0;
+}
+
+static int ipoib_set_vf_guid(struct net_device *dev, int vf, u64 guid, int type)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	if (type != IFLA_VF_IB_NODE_GUID && type != IFLA_VF_IB_PORT_GUID)
+		return -EINVAL;
+
+	return ib_set_vf_guid(priv->ca, vf, priv->port, guid, type);
+}
+
+static int ipoib_get_vf_stats(struct net_device *dev, int vf,
+			      struct ifla_vf_stats *vf_stats)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	return ib_get_vf_stats(priv->ca, vf, priv->port, vf_stats);
+}
+
 static const struct header_ops ipoib_header_ops = {
 	.create	= ipoib_hard_header,
 };
 
-static const struct net_device_ops ipoib_netdev_ops = {
+static const struct net_device_ops ipoib_netdev_ops_pf = {
+	.ndo_uninit		 = ipoib_uninit,
+	.ndo_open		 = ipoib_open,
+	.ndo_stop		 = ipoib_stop,
+	.ndo_change_mtu		 = ipoib_change_mtu,
+	.ndo_fix_features	 = ipoib_fix_features,
+	.ndo_start_xmit		 = ipoib_start_xmit,
+	.ndo_tx_timeout		 = ipoib_timeout,
+	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
+	.ndo_get_iflink		 = ipoib_get_iflink,
+	.ndo_set_vf_link_state	 = ipoib_set_vf_link_state,
+	.ndo_get_vf_config	 = ipoib_get_vf_config,
+	.ndo_get_vf_stats	 = ipoib_get_vf_stats,
+	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
+};
+
+static const struct net_device_ops ipoib_netdev_ops_vf = {
 	.ndo_uninit		 = ipoib_uninit,
 	.ndo_open		 = ipoib_open,
 	.ndo_stop		 = ipoib_stop,
@@ -1610,7 +1667,11 @@ void ipoib_setup(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
-	dev->netdev_ops		 = &ipoib_netdev_ops;
+	if (priv->hca_caps & IB_DEVICE_VIRTUAL_FUNCTION)
+		dev->netdev_ops	= &ipoib_netdev_ops_vf;
+	else
+		dev->netdev_ops	= &ipoib_netdev_ops_pf;
+
 	dev->header_ops		 = &ipoib_header_ops;
 
 	ipoib_set_ethtool_ops(dev);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
