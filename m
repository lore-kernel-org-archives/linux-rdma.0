From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-2.6.38 2/2] IB/ipoib: add GRO support
Date: Wed, 15 Dec 2010 13:25:16 +0200
Message-ID: <Pine.LNX.4.64.1012151324340.24022@zuben.voltaire.com>
References: <Pine.LNX.4.64.1012151321250.24022@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1012151321250.24022-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Ben Hutchings <bhutchings-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

add GRO support

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
tested with 2.6.37-rc5

 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/infiniband/ulp/ipoib/ipoib_main.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1159,6 +1159,8 @@ int ipoib_set_dev_features(struct ipoib_
 		priv->dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM;
 	}

+	priv->dev->features |= NETIF_F_GRO;
+
 	if (priv->dev->features & NETIF_F_SG && priv->hca_caps & IB_DEVICE_UD_TSO)
 		priv->dev->features |= NETIF_F_TSO;

Index: b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -295,7 +295,7 @@ static void ipoib_ib_handle_rx_wc(struct
 	if (test_bit(IPOIB_FLAG_CSUM, &priv->flags) && likely(wc->csum_ok))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;

-	netif_receive_skb(skb);
+	napi_gro_receive(&priv->napi, skb);

 repost:
 	if (unlikely(ipoib_ib_post_receive(dev, wr_id)))
Index: b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1480,6 +1480,7 @@ static ssize_t set_mode(struct device *d

 		if (test_bit(IPOIB_FLAG_CSUM, &priv->flags)) {
 			dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+			priv->dev->features |= NETIF_F_GRO;
 			if (priv->hca_caps & IB_DEVICE_UD_TSO)
 				dev->features |= NETIF_F_TSO;
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
