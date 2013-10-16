From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 2/7] IB/ipoib: Change CM skb memory allocation to be non-atomic on init flow
Date: Wed, 16 Oct 2013 17:37:48 +0300
Message-ID: <1381934273-29683-3-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Change CM skb memory allocation to use GFP_KERNEL when possible.

During device init there's no need to use GFP_ATOMIC when allocationg memory
for the CM skb's, use GFP_KERNEL instead.

Signed-off-by: Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 7a31754..1377f85 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -140,7 +140,8 @@ static int ipoib_cm_post_receive_nonsrq(struct net_device *dev,
 static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 					     struct ipoib_cm_rx_buf *rx_ring,
 					     int id, int frags,
-					     u64 mapping[IPOIB_CM_RX_SG])
+					     u64 mapping[IPOIB_CM_RX_SG],
+					     gfp_t gfp)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
@@ -164,7 +165,7 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 	}
 
 	for (i = 0; i < frags; i++) {
-		struct page *page = alloc_page(GFP_ATOMIC);
+		struct page *page = alloc_page(gfp);
 
 		if (!page)
 			goto partial_error;
@@ -382,7 +383,8 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 
 	for (i = 0; i < ipoib_recvq_size; ++i) {
 		if (!ipoib_cm_alloc_rx_skb(dev, rx->rx_ring, i, IPOIB_CM_RX_SG - 1,
-					   rx->rx_ring[i].mapping)) {
+					   rx->rx_ring[i].mapping,
+					   GFP_KERNEL)) {
 			ipoib_warn(priv, "failed to allocate receive buffer %d\n", i);
 				ret = -ENOMEM;
 				goto err_count;
@@ -639,7 +641,8 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	frags = PAGE_ALIGN(wc->byte_len - min(wc->byte_len,
 					      (unsigned)IPOIB_CM_HEAD_SIZE)) / PAGE_SIZE;
 
-	newskb = ipoib_cm_alloc_rx_skb(dev, rx_ring, wr_id, frags, mapping);
+	newskb = ipoib_cm_alloc_rx_skb(dev, rx_ring, wr_id, frags,
+				       mapping, GFP_ATOMIC);
 	if (unlikely(!newskb)) {
 		/*
 		 * If we can't allocate a new RX buffer, dump
@@ -1556,7 +1559,8 @@ int ipoib_cm_dev_init(struct net_device *dev)
 		for (i = 0; i < ipoib_recvq_size; ++i) {
 			if (!ipoib_cm_alloc_rx_skb(dev, priv->cm.srq_ring, i,
 						   priv->cm.num_frags - 1,
-						   priv->cm.srq_ring[i].mapping)) {
+						   priv->cm.srq_ring[i].mapping,
+						   GFP_KERNEL)) {
 				ipoib_warn(priv, "failed to allocate "
 					   "receive buffer %d\n", i);
 				ipoib_cm_dev_cleanup(dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
