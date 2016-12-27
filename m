From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/9] IB/ipoib: Set device connection mode only when needed
Date: Tue, 27 Dec 2016 15:39:04 +0200
Message-ID: <20161227133911.14340-3-leon@kernel.org>
References: <20161227133911.14340-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161227133911.14340-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When changing the connection mode, the ipoib_set_mode function
did not check if the previous connection mode equals to the
new one. This commit adds the required check and return 0 if the new
mode equals to the previous one.

Fixes: 839fcaba355a ("IPoIB: Connected mode experimental support")
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a550cc6..1787f6b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -474,6 +474,14 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+	if ((test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
+	     !strcmp(buf, "connected\n")) ||
+	     (!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
+	     !strcmp(buf, "datagram\n"))) {
+		ipoib_dbg(priv, "already in that mode, goes out.\n");
+		return 0;
+	}
+
 	/* flush paths if we switch modes so that connections are restarted */
 	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
 		set_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
