From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rc-fixes 1/2] IB/IPoIB: Fix bad error flow in ipoib_add_port()
Date: Wed,  1 Jul 2015 14:31:01 +0300
Message-ID: <1435750262-32210-2-git-send-email-ogerlitz@mellanox.com>
References: <1435750262-32210-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435750262-32210-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Error values of ib_query_port() and ib_query_device() weren't propagated
correctly. Because of that, ipoib_add_port() could return NULL value,
which escaped the IS_ERR() check in ipoib_add_one() and we crashed.

Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index da149c2..55231bb 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1577,7 +1577,8 @@ static struct net_device *ipoib_add_port(const char *format,
 	SET_NETDEV_DEV(priv->dev, hca->dma_device);
 	priv->dev->dev_id = port - 1;
 
-	if (!ib_query_port(hca, port, &attr))
+	result = ib_query_port(hca, port, &attr);
+	if (!result)
 		priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu);
 	else {
 		printk(KERN_WARNING "%s: ib_query_port %d failed\n",
@@ -1598,7 +1599,8 @@ static struct net_device *ipoib_add_port(const char *format,
 		goto device_init_failed;
 	}
 
-	if (ipoib_set_dev_features(priv, hca))
+	result = ipoib_set_dev_features(priv, hca);
+	if (result)
 		goto device_init_failed;
 
 	/*
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
