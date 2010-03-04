From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] ib/ipoib: allow disabling/enabling TSO through ethtool
Date: Thu, 4 Mar 2010 15:16:52 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1003041516300.2755@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

allow disabling/enabling TSO on the fly by ethtool

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6.33/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
===================================================================
--- linux-2.6.33.orig/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ linux-2.6.33/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -49,6 +49,24 @@ static u32 ipoib_get_rx_csum(struct net_
 		!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
 }

+static int ipoib_set_tso(struct net_device *dev, u32 data)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	if (data) {
+		if (!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
+			(dev->features & NETIF_F_SG) &&
+				(priv->hca_caps & IB_DEVICE_UD_TSO))
+			dev->features |= NETIF_F_TSO;
+		else {
+			ipoib_warn(priv, "can't set TSO on\n");
+			return -EOPNOTSUPP;
+		}
+	} else
+		dev->features &= ~NETIF_F_TSO;
+	return 0;
+}
+
 static int ipoib_get_coalesce(struct net_device *dev,
 			      struct ethtool_coalesce *coal)
 {
@@ -131,6 +149,7 @@ static void ipoib_get_ethtool_stats(stru
 static const struct ethtool_ops ipoib_ethtool_ops = {
 	.get_drvinfo		= ipoib_get_drvinfo,
 	.get_rx_csum		= ipoib_get_rx_csum,
+	.set_tso		= ipoib_set_tso,
 	.get_coalesce		= ipoib_get_coalesce,
 	.set_coalesce		= ipoib_set_coalesce,
 	.get_flags		= ethtool_op_get_flags,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
