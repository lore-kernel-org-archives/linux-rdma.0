From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 08/11] IB/ipoib: Clean error paths in add port
Date: Wed, 26 Jul 2017 21:12:29 +0300
Message-ID: <20170726181232.7363-9-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Refactor error paths in ipoib_add_port() function. The code flow
ensures that the function terminates on every error flow and it makes
redundant all "else" cases.

The functions are called during the flow are returning "result < 0", in
case of error, so there is no need to check it explicitly.

Fixes: 58e9cc90cda7 ("IB/IPoIB: Fix bad error flow in ipoib_add_port()")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 24fa87fe0952..6c77df34869d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2175,14 +2175,14 @@ static struct net_device *ipoib_add_port(const char *format,
 	priv->dev->dev_id = port - 1;
 
 	result = ib_query_port(hca, port, &attr);
-	if (!result)
-		priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu);
-	else {
+	if (result) {
 		printk(KERN_WARNING "%s: ib_query_port %d failed\n",
 		       hca->name, port);
 		goto device_init_failed;
 	}
 
+	priv->max_ib_mtu = ib_mtu_enum_to_int(attr.max_mtu);
+
 	/* MTU will be reset when mcast join happens */
 	priv->dev->mtu  = IPOIB_UD_MTU(priv->max_ib_mtu);
 	priv->mcast_mtu  = priv->admin_mtu = priv->dev->mtu;
@@ -2213,12 +2213,14 @@ static struct net_device *ipoib_add_port(const char *format,
 		printk(KERN_WARNING "%s: ib_query_gid port %d failed (ret = %d)\n",
 		       hca->name, port, result);
 		goto device_init_failed;
-	} else
-		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
+	}
+
+	memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw,
+	       sizeof(union ib_gid));
 	set_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags);
 
 	result = ipoib_dev_init(priv->dev, hca, port);
-	if (result < 0) {
+	if (result) {
 		printk(KERN_WARNING "%s: failed to initialize port %d (ret = %d)\n",
 		       hca->name, port, result);
 		goto device_init_failed;
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
