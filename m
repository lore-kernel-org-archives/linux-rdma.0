From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/5] IB/ipoib: Delete napi in device uninit default
Date: Wed, 14 Jun 2017 09:59:07 +0300
Message-ID: <20170614065909.23650-4-leon@kernel.org>
References: <20170614065909.23650-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614065909.23650-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch mekas init_default and uninit_default symmetric
with a call to delete napi. Additionally, the uninit_default
gained delete napi call in case of init_default fails.

Fixes: 515ed4f3aab4 ('IB/IPoIB: Separate control and data related initializations')
Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 91fae34bdd4f..1015a63de6ae 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1596,6 +1596,8 @@ static void ipoib_dev_uninit_default(struct net_device *dev)
 
 	ipoib_transport_dev_cleanup(dev);
 
+	netif_napi_del(&priv->napi);
+
 	ipoib_cm_dev_cleanup(dev);
 
 	kfree(priv->rx_ring);
@@ -1649,6 +1651,7 @@ static int ipoib_dev_init_default(struct net_device *dev)
 	kfree(priv->rx_ring);
 
 out:
+	netif_napi_del(&priv->napi);
 	return -ENOMEM;
 }
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
