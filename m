From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/ipoib: Enable ioctl for to IPoIB rdma netdevs
Date: Wed, 23 Aug 2017 08:37:21 +0300
Message-ID: <20170823053721.18510-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Adds support for ioctl callback in the RDMA netdevs to allow
supporting functions not handled by the generic interface code.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9e8dce6e9fc2..cc3615dd6f1a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -99,6 +99,8 @@ static struct net_device *ipoib_get_net_dev_by_params(
 		const union ib_gid *gid, const struct sockaddr *addr,
 		void *client_data);
 static int ipoib_set_mac(struct net_device *dev, void *addr);
+static int ipoib_ioctl(struct net_device *dev, struct ifreq *ifr,
+		       int cmd);

 static struct ib_client ipoib_client = {
 	.name   = "ipoib",
@@ -1680,6 +1682,17 @@ static int ipoib_dev_init_default(struct net_device *dev)
 	return -ENOMEM;
 }

+static int ipoib_ioctl(struct net_device *dev, struct ifreq *ifr,
+		       int cmd)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+
+	if (!priv->rn_ops->ndo_do_ioctl)
+		return -EOPNOTSUPP;
+
+	return priv->rn_ops->ndo_do_ioctl(dev, ifr, cmd);
+}
+
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -1834,6 +1847,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
 	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
 	.ndo_set_mac_address	 = ipoib_set_mac,
 	.ndo_get_stats64	 = ipoib_get_stats,
+	.ndo_do_ioctl		 = ipoib_ioctl,
 };

 static const struct net_device_ops ipoib_netdev_ops_vf = {
@@ -1847,6 +1861,7 @@ static const struct net_device_ops ipoib_netdev_ops_vf = {
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
 	.ndo_get_iflink		 = ipoib_get_iflink,
 	.ndo_get_stats64	 = ipoib_get_stats,
+	.ndo_do_ioctl		 = ipoib_ioctl,
 };

 void ipoib_setup_common(struct net_device *dev)
--
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
