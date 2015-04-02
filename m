From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/ipoib: Use one linear skb in RX flow
Date: Thu,  2 Apr 2015 13:39:00 +0300
Message-ID: <1427971145-26943-2-git-send-email-ogerlitz@mellanox.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The current code in the RX flow uses two sg entries for each incoming
packet, the first one was for the IB headers and the second for the rest
of the data, that causes two  dma map/unmap and two allocations, and few
more actions that were done at the data path.

Use only one linear skb on each incoming packet, for the data (IB
headers and payload), that reduces the packet processing in the
data-path (only one skb, no frags, the first frag was not used anyway,
less memory allocations) and the dma handling (only one dma map/unmap
over each incoming packet instead of two map/unmap per each incoming packet).

After commit 73d3fe6d1c6d ("gro: fix aggregation for skb using frag_list") from
Eric Dumazet, we will get full aggregation for large packets.

When running bandwidth tests before and after the (over the card's numa node),
using "netperf -H 1.1.1.3 -T -t TCP_STREAM", the results before are ~12Gbs before
and after ~16Gbs on my setup (Mellanox's ConnectX3).

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h       |    5 --
 drivers/infiniband/ulp/ipoib/ipoib_ib.c    |   67 ++++------------------------
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |   13 ++----
 3 files changed, 13 insertions(+), 72 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index c79dcd5..769044c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -434,11 +434,6 @@ struct ipoib_neigh {
 #define IPOIB_UD_MTU(ib_mtu)		(ib_mtu - IPOIB_ENCAP_LEN)
 #define IPOIB_UD_BUF_SIZE(ib_mtu)	(ib_mtu + IB_GRH_BYTES)
 
-static inline int ipoib_ud_need_sg(unsigned int ib_mtu)
-{
-	return IPOIB_UD_BUF_SIZE(ib_mtu) > PAGE_SIZE;
-}
-
 void ipoib_neigh_dtor(struct ipoib_neigh *neigh);
 static inline void ipoib_neigh_put(struct ipoib_neigh *neigh)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index e144d07..29b376d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -94,39 +94,9 @@ void ipoib_free_ah(struct kref *kref)
 static void ipoib_ud_dma_unmap_rx(struct ipoib_dev_priv *priv,
 				  u64 mapping[IPOIB_UD_RX_SG])
 {
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_UD_HEAD_SIZE,
-				    DMA_FROM_DEVICE);
-		ib_dma_unmap_page(priv->ca, mapping[1], PAGE_SIZE,
-				  DMA_FROM_DEVICE);
-	} else
-		ib_dma_unmap_single(priv->ca, mapping[0],
-				    IPOIB_UD_BUF_SIZE(priv->max_ib_mtu),
-				    DMA_FROM_DEVICE);
-}
-
-static void ipoib_ud_skb_put_frags(struct ipoib_dev_priv *priv,
-				   struct sk_buff *skb,
-				   unsigned int length)
-{
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
-		unsigned int size;
-		/*
-		 * There is only two buffers needed for max_payload = 4K,
-		 * first buf size is IPOIB_UD_HEAD_SIZE
-		 */
-		skb->tail += IPOIB_UD_HEAD_SIZE;
-		skb->len  += length;
-
-		size = length - IPOIB_UD_HEAD_SIZE;
-
-		skb_frag_size_set(frag, size);
-		skb->data_len += size;
-		skb->truesize += PAGE_SIZE;
-	} else
-		skb_put(skb, length);
-
+	ib_dma_unmap_single(priv->ca, mapping[0],
+			    IPOIB_UD_BUF_SIZE(priv->max_ib_mtu),
+			    DMA_FROM_DEVICE);
 }
 
 static int ipoib_ib_post_receive(struct net_device *dev, int id)
@@ -156,18 +126,11 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
 	int buf_size;
-	int tailroom;
 	u64 *mapping;
 
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		buf_size = IPOIB_UD_HEAD_SIZE;
-		tailroom = 128; /* reserve some tailroom for IP/TCP headers */
-	} else {
-		buf_size = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
-		tailroom = 0;
-	}
+	buf_size = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
 
-	skb = dev_alloc_skb(buf_size + tailroom + 4);
+	skb = dev_alloc_skb(buf_size + IPOIB_ENCAP_LEN);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -184,23 +147,8 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	if (unlikely(ib_dma_mapping_error(priv->ca, mapping[0])))
 		goto error;
 
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		struct page *page = alloc_page(GFP_ATOMIC);
-		if (!page)
-			goto partial_error;
-		skb_fill_page_desc(skb, 0, page, 0, PAGE_SIZE);
-		mapping[1] =
-			ib_dma_map_page(priv->ca, page,
-					0, PAGE_SIZE, DMA_FROM_DEVICE);
-		if (unlikely(ib_dma_mapping_error(priv->ca, mapping[1])))
-			goto partial_error;
-	}
-
 	priv->rx_ring[id].skb = skb;
 	return skb;
-
-partial_error:
-	ib_dma_unmap_single(priv->ca, mapping[0], buf_size, DMA_FROM_DEVICE);
 error:
 	dev_kfree_skb_any(skb);
 	return NULL;
@@ -278,7 +226,8 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		       wc->byte_len, wc->slid);
 
 	ipoib_ud_dma_unmap_rx(priv, mapping);
-	ipoib_ud_skb_put_frags(priv, skb, wc->byte_len);
+
+	skb_put(skb, wc->byte_len);
 
 	/* First byte of dgid signals multicast when 0xff */
 	dgid = &((struct ib_grh *)skb->data)->dgid;
@@ -296,6 +245,8 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, IPOIB_ENCAP_LEN);
 
+	skb->truesize = SKB_TRUESIZE(skb->len);
+
 	++dev->stats.rx_packets;
 	dev->stats.rx_bytes += skb->len;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 3462840..e5cc430 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -227,15 +227,10 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->tx_wr.send_flags	= IB_SEND_SIGNALED;
 
 	priv->rx_sge[0].lkey = priv->mr->lkey;
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		priv->rx_sge[0].length = IPOIB_UD_HEAD_SIZE;
-		priv->rx_sge[1].length = PAGE_SIZE;
-		priv->rx_sge[1].lkey = priv->mr->lkey;
-		priv->rx_wr.num_sge = IPOIB_UD_RX_SG;
-	} else {
-		priv->rx_sge[0].length = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
-		priv->rx_wr.num_sge = 1;
-	}
+
+	priv->rx_sge[0].length = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
+	priv->rx_wr.num_sge = 1;
+
 	priv->rx_wr.next = NULL;
 	priv->rx_wr.sg_list = priv->rx_sge;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
