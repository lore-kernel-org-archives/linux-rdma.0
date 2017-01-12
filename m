From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 16/26] IB/IPoIB: Inline ib_dma_map_*() functions
Date: Thu, 12 Jan 2017 11:07:08 -0800
Message-ID: <20170112190718.6728-17-bart.vanassche@sandisk.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112190718.6728-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 34 +++++++++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 42 +++++++++++++++++----------------
 2 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 096c4f6fbd65..6d91593852e9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -83,10 +83,12 @@ static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv, int frags,
 {
 	int i;
 
-	ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_single(priv->ca->dma_device, mapping[0], IPOIB_CM_HEAD_SIZE,
+			 DMA_FROM_DEVICE);
 
 	for (i = 0; i < frags; ++i)
-		ib_dma_unmap_page(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_page(priv->ca->dma_device, mapping[i + 1], PAGE_SIZE,
+			       DMA_FROM_DEVICE);
 }
 
 static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
@@ -158,9 +160,9 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 	 */
 	skb_reserve(skb, IPOIB_CM_RX_RESERVE);
 
-	mapping[0] = ib_dma_map_single(priv->ca, skb->data, IPOIB_CM_HEAD_SIZE,
-				       DMA_FROM_DEVICE);
-	if (unlikely(ib_dma_mapping_error(priv->ca, mapping[0]))) {
+	mapping[0] = dma_map_single(priv->ca->dma_device, skb->data,
+				    IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(priv->ca->dma_device, mapping[0]))) {
 		dev_kfree_skb_any(skb);
 		return NULL;
 	}
@@ -172,9 +174,9 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 			goto partial_error;
 		skb_fill_page_desc(skb, i, page, 0, PAGE_SIZE);
 
-		mapping[i + 1] = ib_dma_map_page(priv->ca, page,
-						 0, PAGE_SIZE, DMA_FROM_DEVICE);
-		if (unlikely(ib_dma_mapping_error(priv->ca, mapping[i + 1])))
+		mapping[i + 1] = dma_map_page(priv->ca->dma_device, page,
+					      0, PAGE_SIZE, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(priv->ca->dma_device, mapping[i + 1])))
 			goto partial_error;
 	}
 
@@ -183,10 +185,12 @@ static struct sk_buff *ipoib_cm_alloc_rx_skb(struct net_device *dev,
 
 partial_error:
 
-	ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
+	dma_unmap_single(priv->ca->dma_device, mapping[0], IPOIB_CM_HEAD_SIZE,
+			 DMA_FROM_DEVICE);
 
 	for (; i > 0; --i)
-		ib_dma_unmap_page(priv->ca, mapping[i], PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_unmap_page(priv->ca->dma_device, mapping[i], PAGE_SIZE,
+			       DMA_FROM_DEVICE);
 
 	dev_kfree_skb_any(skb);
 	return NULL;
@@ -626,11 +630,13 @@ void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc)
 		small_skb = dev_alloc_skb(dlen + IPOIB_CM_RX_RESERVE);
 		if (small_skb) {
 			skb_reserve(small_skb, IPOIB_CM_RX_RESERVE);
-			ib_dma_sync_single_for_cpu(priv->ca, rx_ring[wr_id].mapping[0],
-						   dlen, DMA_FROM_DEVICE);
+			dma_sync_single_for_cpu(priv->ca->dma_device,
+						rx_ring[wr_id].mapping[0],
+						dlen, DMA_FROM_DEVICE);
 			skb_copy_from_linear_data(skb, small_skb->data, dlen);
-			ib_dma_sync_single_for_device(priv->ca, rx_ring[wr_id].mapping[0],
-						      dlen, DMA_FROM_DEVICE);
+			dma_sync_single_for_device(priv->ca->dma_device,
+						   rx_ring[wr_id].mapping[0],
+						   dlen, DMA_FROM_DEVICE);
 			skb_put(small_skb, dlen);
 			skb = small_skb;
 			goto copied;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5038f9d2d753..79204bd966bd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -92,9 +92,8 @@ void ipoib_free_ah(struct kref *kref)
 static void ipoib_ud_dma_unmap_rx(struct ipoib_dev_priv *priv,
 				  u64 mapping[IPOIB_UD_RX_SG])
 {
-	ib_dma_unmap_single(priv->ca, mapping[0],
-			    IPOIB_UD_BUF_SIZE(priv->max_ib_mtu),
-			    DMA_FROM_DEVICE);
+	dma_unmap_single(priv->ca->dma_device, mapping[0],
+			 IPOIB_UD_BUF_SIZE(priv->max_ib_mtu), DMA_FROM_DEVICE);
 }
 
 static int ipoib_ib_post_receive(struct net_device *dev, int id)
@@ -139,9 +138,9 @@ static struct sk_buff *ipoib_alloc_rx_skb(struct net_device *dev, int id)
 	skb_reserve(skb, sizeof(struct ipoib_pseudo_header));
 
 	mapping = priv->rx_ring[id].mapping;
-	mapping[0] = ib_dma_map_single(priv->ca, skb->data, buf_size,
-				       DMA_FROM_DEVICE);
-	if (unlikely(ib_dma_mapping_error(priv->ca, mapping[0])))
+	mapping[0] = dma_map_single(priv->ca->dma_device, skb->data, buf_size,
+				    DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(priv->ca->dma_device, mapping[0])))
 		goto error;
 
 	priv->rx_ring[id].skb = skb;
@@ -278,9 +277,9 @@ int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
 	int off;
 
 	if (skb_headlen(skb)) {
-		mapping[0] = ib_dma_map_single(ca, skb->data, skb_headlen(skb),
-					       DMA_TO_DEVICE);
-		if (unlikely(ib_dma_mapping_error(ca, mapping[0])))
+		mapping[0] = dma_map_single(ca->dma_device, skb->data,
+					    skb_headlen(skb), DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(ca->dma_device, mapping[0])))
 			return -EIO;
 
 		off = 1;
@@ -289,11 +288,12 @@ int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		mapping[i + off] = ib_dma_map_page(ca,
-						 skb_frag_page(frag),
-						 frag->page_offset, skb_frag_size(frag),
-						 DMA_TO_DEVICE);
-		if (unlikely(ib_dma_mapping_error(ca, mapping[i + off])))
+		mapping[i + off] = dma_map_page(ca->dma_device,
+						skb_frag_page(frag),
+						frag->page_offset,
+						skb_frag_size(frag),
+						DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(ca->dma_device, mapping[i + off])))
 			goto partial_error;
 	}
 	return 0;
@@ -302,11 +302,13 @@ int ipoib_dma_map_tx(struct ib_device *ca, struct ipoib_tx_buf *tx_req)
 	for (; i > 0; --i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
-		ib_dma_unmap_page(ca, mapping[i - !off], skb_frag_size(frag), DMA_TO_DEVICE);
+		dma_unmap_page(ca->dma_device, mapping[i - !off],
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 	}
 
 	if (off)
-		ib_dma_unmap_single(ca, mapping[0], skb_headlen(skb), DMA_TO_DEVICE);
+		dma_unmap_single(ca->dma_device, mapping[0], skb_headlen(skb),
+				 DMA_TO_DEVICE);
 
 	return -EIO;
 }
@@ -320,8 +322,8 @@ void ipoib_dma_unmap_tx(struct ipoib_dev_priv *priv,
 	int off;
 
 	if (skb_headlen(skb)) {
-		ib_dma_unmap_single(priv->ca, mapping[0], skb_headlen(skb),
-				    DMA_TO_DEVICE);
+		dma_unmap_single(priv->ca->dma_device, mapping[0],
+				 skb_headlen(skb), DMA_TO_DEVICE);
 		off = 1;
 	} else
 		off = 0;
@@ -329,8 +331,8 @@ void ipoib_dma_unmap_tx(struct ipoib_dev_priv *priv,
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; ++i) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		ib_dma_unmap_page(priv->ca, mapping[i + off],
-				  skb_frag_size(frag), DMA_TO_DEVICE);
+		dma_unmap_page(priv->ca->dma_device, mapping[i + off],
+			       skb_frag_size(frag), DMA_TO_DEVICE);
 	}
 }
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
