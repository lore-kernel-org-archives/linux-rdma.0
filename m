From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/IPoIB: Forward MTU change to driver below
Date: Tue, 23 May 2017 11:42:52 +0300
Message-ID: <20170523084252.16018-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch checks if there is a driver below that
needs to be updated on the new MTU and calls it
accordingly.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2869d1adb1de..28068140800c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -233,6 +233,7 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
 static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	int ret = 0;

 	/* dev->mtu > 2K ==> connected mode */
 	if (ipoib_cm_admin_enabled(dev)) {
@@ -256,9 +257,23 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 		ipoib_dbg(priv, "MTU must be smaller than the underlying "
 				"link layer MTU - 4 (%u)\n", priv->mcast_mtu);

-	dev->mtu = min(priv->mcast_mtu, priv->admin_mtu);
+	new_mtu = min(priv->mcast_mtu, priv->admin_mtu);

-	return 0;
+	if (priv->rn_ops->ndo_change_mtu) {
+		bool carrier_status = netif_carrier_ok(dev);
+
+		netif_carrier_off(dev);
+
+		/* notify lower level on the real mtu */
+		ret = priv->rn_ops->ndo_change_mtu(dev, new_mtu);
+
+		if (carrier_status)
+			netif_carrier_on(dev);
+	} else {
+		dev->mtu = new_mtu;
+	}
+
+	return ret;
 }

 /* Called with an RCU read lock taken */
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
