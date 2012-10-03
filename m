From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next: Tree for Oct 2 (ipoib_netlink.c)
Date: Tue,  2 Oct 2012 21:33:00 -0700
Message-ID: <1349238780-27850-1-git-send-email-roland@kernel.org>
References: <10635.1349221831@neuling.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10635.1349221831-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

I'll be sending the following to Linus shortly:

[PATCH] IPoIB: Fix build with CONFIG_INFINIBAND_IPOIB_CM=n

With the new netlink support in commit 862096a8bbf8 ("IB/ipoib: Add more
rtnl_link_ops callbacks") we need ipoib_set_mode() to be available even
if connected mode isn't built.  Move the function from ipoib_cm.c to
ipoib_main.c (and make a few CM-related macros available unconditonally).

This fixes the build error

    drivers/built-in.o: In function 'ipoib_changelink':
    ipoib_netlink.c:(.text+0x6a5fc9): undefined reference to 'ipoib_set_mode'
    ipoib_netlink.c:(.text+0x6a5fe3): undefined reference to 'ipoib_set_mode'

when CONFIG_INFINIBAND_IPOIB_CM isn't set.

Reported-by: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |   31 -----------------------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   31 +++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 196eb52..07ca6fd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -535,14 +535,14 @@ void ipoib_drain_cq(struct net_device *dev);
 void ipoib_set_ethtool_ops(struct net_device *dev);
 int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca);
 
-#ifdef CONFIG_INFINIBAND_IPOIB_CM
-
 #define IPOIB_FLAGS_RC		0x80
 #define IPOIB_FLAGS_UC		0x40
 
 /* We don't support UC connections at the moment */
 #define IPOIB_CM_SUPPORTED(ha)   (ha[0] & (IPOIB_FLAGS_RC))
 
+#ifdef CONFIG_INFINIBAND_IPOIB_CM
+
 extern int ipoib_max_conn_qp;
 
 static inline int ipoib_cm_admin_enabled(struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 175581c..72ae63f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1448,37 +1448,6 @@ static ssize_t show_mode(struct device *d, struct device_attribute *attr,
 		return sprintf(buf, "datagram\n");
 }
 
-int ipoib_set_mode(struct net_device *dev, const char *buf)
-{
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
-
-	/* flush paths if we switch modes so that connections are restarted */
-	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
-		set_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
-		ipoib_warn(priv, "enabling connected mode "
-			   "will cause multicast packet drops\n");
-		netdev_update_features(dev);
-		rtnl_unlock();
-		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
-
-		ipoib_flush_paths(dev);
-		rtnl_lock();
-		return 0;
-	}
-
-	if (!strcmp(buf, "datagram\n")) {
-		clear_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
-		netdev_update_features(dev);
-		dev_set_mtu(dev, min(priv->mcast_mtu, dev->mtu));
-		rtnl_unlock();
-		ipoib_flush_paths(dev);
-		rtnl_lock();
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 			const char *buf, size_t count)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index d576c7a..6fdc9e7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -215,6 +215,37 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+int ipoib_set_mode(struct net_device *dev, const char *buf)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	/* flush paths if we switch modes so that connections are restarted */
+	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
+		set_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
+		ipoib_warn(priv, "enabling connected mode "
+			   "will cause multicast packet drops\n");
+		netdev_update_features(dev);
+		rtnl_unlock();
+		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
+
+		ipoib_flush_paths(dev);
+		rtnl_lock();
+		return 0;
+	}
+
+	if (!strcmp(buf, "datagram\n")) {
+		clear_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
+		netdev_update_features(dev);
+		dev_set_mtu(dev, min(priv->mcast_mtu, dev->mtu));
+		rtnl_unlock();
+		ipoib_flush_paths(dev);
+		rtnl_lock();
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
