From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 06/11] IB/ipoib: Add multicast packets statistics
Date: Wed, 26 Jul 2017 21:12:27 +0300
Message-ID: <20170726181232.7363-7-leon@kernel.org>
References: <20170726181232.7363-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update the multicast counter when multicast packets are received and
provide this information through ethtool support.

Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 3 ++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 7871379342f4..184a22f48027 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -52,7 +52,8 @@ static const struct ipoib_stats ipoib_gstrings_stats[] = {
 	IPOIB_NETDEV_STAT(tx_bytes),
 	IPOIB_NETDEV_STAT(tx_errors),
 	IPOIB_NETDEV_STAT(rx_dropped),
-	IPOIB_NETDEV_STAT(tx_dropped)
+	IPOIB_NETDEV_STAT(tx_dropped),
+	IPOIB_NETDEV_STAT(multicast),
 };
 
 #define IPOIB_GLOBAL_STATS_LEN	ARRAY_SIZE(ipoib_gstrings_stats)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 57a9655e844d..02eda1f53a67 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -256,6 +256,8 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 
 	++dev->stats.rx_packets;
 	dev->stats.rx_bytes += skb->len;
+	if (skb->pkt_type == PACKET_MULTICAST)
+		dev->stats.multicast++;
 
 	skb->dev = dev;
 	if ((dev->features & NETIF_F_RXCSUM) &&
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
