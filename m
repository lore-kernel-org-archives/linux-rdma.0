From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC/PATCH v3] IPoIB: Leave space in skb linear buffer for IP headers
Date: Mon,  8 Apr 2013 14:43:01 -0700
Message-ID: <1365457381-10184-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> noticed that IPoIB was
spending significant time doing memcpy() in __pskb_pull_tail().  He
found that this is because his adapter reports a maximum MTU of 4K,
which causes IPoIB datagram mode to receive all the actual data in a
separate page in the fragment list.

We're already allocating extra tailroom for the skb linear part, so we
might as well use it.

Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
v3: avoid adding pages to the frag list with no data in them

 drivers/infiniband/ulp/ipoib/ipoib.h    |  4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 77 +++++++++++++++++++--------------
 2 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index eb71aaa..5f0d34c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -64,7 +64,8 @@ enum ipoib_flush_level {
 enum {
 	IPOIB_ENCAP_LEN		  = 4,
 
-	IPOIB_UD_HEAD_SIZE	  = IB_GRH_BYTES + IPOIB_ENCAP_LEN,
+	/* add 128 bytes of tailroom for IP/TCP headers */
+	IPOIB_UD_HEAD_SIZE	  = IB_GRH_BYTES + IPOIB_ENCAP_LEN + 128,
 	IPOIB_UD_RX_SG		  = 2, /* max buffer needed for 4K mtu */
 
 	IPOIB_CM_MTU		  = 0x10000 - 0x10, /* padding to align header to 16 */
@@ -155,6 +156,7 @@ struct ipoib_mcast {
 
 struct ipoib_rx_buf {
 	struct sk_buff *skb;
+	struct page    *page;
 	u64		mapping[IPOIB_UD_RX_SG];
 };
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2cfa76f..890e2c8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -92,13 +92,15 @@ void ipoib_free_ah(struct kref *kref)
 }
 
 static void ipoib_ud_dma_unmap_rx(struct ipoib_dev_priv *priv,
+				  struct page *page,
 				  u64 mapping[IPOIB_UD_RX_SG])
 {
 	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
 		ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_UD_HEAD_SIZE,
 				    DMA_FROM_DEVICE);
-		ib_dma_unmap_page(priv->ca, mapping[1], PAGE_SIZE,
-				  DMA_FROM_DEVICE);
+		if (page)
+			ib_dma_unmap_page(priv->ca, mapping[1], PAGE_SIZE,
+					  DMA_FROM_DEVICE);
 	} else
 		ib_dma_unmap_single(priv->ca, mapping[0],
 				    IPOIB_UD_BUF_SIZE(priv->max_ib_mtu),
@@ -107,23 +109,18 @@ static void ipoib_ud_dma_unmap_rx(struct ipoib_dev_priv *priv,
 
 static void ipoib_ud_skb_put_frags(struct ipoib_dev_priv *priv,
 				   struct sk_buff *skb,
+				   struct page *page,
 				   unsigned int length)
 {
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		skb_frag_t *frag = &skb_shinfo(skb)->frags[0];
-		unsigned int size;
+	if (ipoib_ud_need_sg(priv->max_ib_mtu) &&
+	    length > IPOIB_UD_HEAD_SIZE) {
 		/*
-		 * There is only two buffers needed for max_payload = 4K,
+		 * There are only two buffers needed for max_payload = 4K,
 		 * first buf size is IPOIB_UD_HEAD_SIZE
 		 */
-		skb->tail += IPOIB_UD_HEAD_SIZE;
-		skb->len  += length;
-
-		size = length - IPOIB_UD_HEAD_SIZE;
-
-		skb_frag_size_set(frag, size);
-		skb->data_len += size;
-		skb->truesize += PAGE_SIZE;
+		skb_put(skb, IPOIB_UD_HEAD_SIZE);
+		skb_add_rx_frag(skb, 0, page, 0,
+				length - IPOIB_UD_HEAD_SIZE, PAGE_SIZE);
 	} else
 		skb_put(skb, length);
 
@@ -143,9 +140,11 @@ static int ipoib_ib_post_receive(struct net_device *dev, int id)
 	ret = ib_post_recv(priv->qp, &priv->rx_wr, &bad_wr);
 	if (unlikely(ret)) {
 		ipoib_warn(priv, "receive failed for buf %d (%d)\n", id, ret);
-		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[id].mapping);
+		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[id].page, priv->rx_ring[id].mapping);
 		dev_kfree_skb_any(priv->rx_ring[id].skb);
 		priv->rx_ring[id].skb = NULL;
+		put_page(priv->rx_ring[id].page);
+		priv->rx_ring[id].page = NULL;
 	}
 
 	return ret;
@@ -156,18 +155,13 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct sk_buff *skb;
 	int buf_size;
-	int tailroom;
 	u64 *mapping;
+	struct page **page;
 
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		buf_size = IPOIB_UD_HEAD_SIZE;
-		tailroom = 128; /* reserve some tailroom for IP/TCP headers */
-	} else {
-		buf_size = IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
-		tailroom = 0;
-	}
+	buf_size = ipoib_ud_need_sg(priv->max_ib_mtu) ?
+		IPOIB_UD_HEAD_SIZE : IPOIB_UD_BUF_SIZE(priv->max_ib_mtu);
 
-	skb = dev_alloc_skb(buf_size + tailroom + 4);
+	skb = dev_alloc_skb(buf_size + 4);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -184,21 +178,24 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	if (unlikely(ib_dma_mapping_error(priv->ca, mapping[0])))
 		goto error;
 
-	if (ipoib_ud_need_sg(priv->max_ib_mtu)) {
-		struct page *page = alloc_page(GFP_ATOMIC);
-		if (!page)
+	page = &priv->rx_ring[id].page;
+	if (ipoib_ud_need_sg(priv->max_ib_mtu) && !*page) {
+		*page = alloc_page(GFP_ATOMIC);
+		if (!*page)
 			goto partial_error;
-		skb_fill_page_desc(skb, 0, page, 0, PAGE_SIZE);
 		mapping[1] =
-			ib_dma_map_page(priv->ca, page,
+			ib_dma_map_page(priv->ca, *page,
 					0, PAGE_SIZE, DMA_FROM_DEVICE);
 		if (unlikely(ib_dma_mapping_error(priv->ca, mapping[1])))
-			goto partial_error;
+			goto map_error;
 	}
 
 	priv->rx_ring[id].skb = skb;
 	return skb;
 
+map_error:
+	put_page(*page);
+	*page = NULL;
 partial_error:
 	ib_dma_unmap_single(priv->ca, mapping[0], buf_size, DMA_FROM_DEVICE);
 error:
@@ -230,6 +227,7 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned int wr_id = wc->wr_id & ~IPOIB_OP_RECV;
 	struct sk_buff *skb;
+	struct page *page;
 	u64 mapping[IPOIB_UD_RX_SG];
 	union ib_gid *dgid;
 
@@ -249,9 +247,11 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 			ipoib_warn(priv, "failed recv event "
 				   "(status=%d, wrid=%d vend_err %x)\n",
 				   wc->status, wr_id, wc->vendor_err);
-		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[wr_id].mapping);
+		ipoib_ud_dma_unmap_rx(priv, priv->rx_ring[wr_id].page, priv->rx_ring[wr_id].mapping);
 		dev_kfree_skb_any(skb);
 		priv->rx_ring[wr_id].skb = NULL;
+		put_page(priv->rx_ring[wr_id].page);
+		priv->rx_ring[wr_id].page = NULL;
 		return;
 	}
 
@@ -265,20 +265,28 @@ static void ipoib_ib_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 	memcpy(mapping, priv->rx_ring[wr_id].mapping,
 	       IPOIB_UD_RX_SG * sizeof *mapping);
 
+	if (wc->byte_len > IPOIB_UD_HEAD_SIZE) {
+		page = priv->rx_ring[wr_id].page;
+		priv->rx_ring[wr_id].page = NULL;
+	} else {
+		page = NULL;
+	}
+
 	/*
 	 * If we can't allocate a new RX buffer, dump
 	 * this packet and reuse the old buffer.
 	 */
 	if (unlikely(!ipoib_alloc_rx_skb(dev, wr_id))) {
 		++dev->stats.rx_dropped;
+		priv->rx_ring[wr_id].page = page;
 		goto repost;
 	}
 
 	ipoib_dbg_data(priv, "received %d bytes, SLID 0x%04x\n",
 		       wc->byte_len, wc->slid);
 
-	ipoib_ud_dma_unmap_rx(priv, mapping);
-	ipoib_ud_skb_put_frags(priv, skb, wc->byte_len);
+	ipoib_ud_dma_unmap_rx(priv, page, mapping);
+	ipoib_ud_skb_put_frags(priv, skb, page, wc->byte_len);
 
 	/* First byte of dgid signals multicast when 0xff */
 	dgid = &((struct ib_grh *)skb->data)->dgid;
@@ -861,9 +869,12 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 				if (!rx_req->skb)
 					continue;
 				ipoib_ud_dma_unmap_rx(priv,
+						      priv->rx_ring[i].page,
 						      priv->rx_ring[i].mapping);
 				dev_kfree_skb_any(rx_req->skb);
 				rx_req->skb = NULL;
+				put_page(priv->rx_ring[i].page);
+				priv->rx_ring[i].page = NULL;
 			}
 
 			goto timeout;
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
