From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/iopib: Report SG feature regardless of HW UD CSUM capability
Date: Sun, 17 Jul 2016 04:08:48 -0700
Message-ID: <1468753728-13369-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Decouple SG support from HW ability to do UD checksum.
This coupling is for historical reasons and removed with commit
ec5f06156423 ("net: Kill link between CSUM and SG features.")

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5f58c41..119790c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1967,8 +1967,7 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 	priv->hca_caps = hca->attrs.device_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features = NETIF_F_SG |
-			NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		priv->dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
 
 		if (priv->hca_caps & IB_DEVICE_UD_TSO)
 			priv->dev->hw_features |= NETIF_F_TSO;
@@ -1976,6 +1975,8 @@ int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 		priv->dev->features |= priv->dev->hw_features;
 	}
 
+	priv->dev->features |= NETIF_F_SG;
+
 	return 0;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
