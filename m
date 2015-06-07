From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/ipoib: Change To max_cm_mtu when changing mode to connected
Date: Sun,  7 Jun 2015 13:36:11 +0300
Message-ID: <1433673371-5355-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When switching between modes (datagram / connected) change the MTU
accordingly.
datagram mode up to 4K, connected mode up to (64K - 0x10).

Signed-off-by: ELi Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 9e1b203..5b74184 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -232,6 +232,7 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 		ipoib_warn(priv, "enabling connected mode "
 			   "will cause multicast packet drops\n");
 		netdev_update_features(dev);
+		dev_set_mtu(dev, ipoib_cm_max_mtu(dev));
 		rtnl_unlock();
 		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
 
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
