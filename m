From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ipoib: fix the function that performs dma unmap of memory buffers
Date: Tue, 18 Oct 2011 15:22:14 +0200
Message-ID: <201110181522.15087.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Pages that were mapped using ib_dma_map_page() should be unmapped using the
right function (i.e. ib_dma_unmap_page()).

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 39913a0..483b098 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -84,7 +84,7 @@ static void ipoib_cm_dma_unmap_rx(struct ipoib_dev_priv *priv, int frags,
 	ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
 
 	for (i = 0; i < frags; ++i)
-		ib_dma_unmap_single(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
+		ib_dma_unmap_page(priv->ca, mapping[i + 1], PAGE_SIZE, DMA_FROM_DEVICE);
 }
 
 static int ipoib_cm_post_receive_srq(struct net_device *dev, int id)
@@ -183,7 +183,7 @@ partial_error:
 	ib_dma_unmap_single(priv->ca, mapping[0], IPOIB_CM_HEAD_SIZE, DMA_FROM_DEVICE);
 
 	for (; i > 0; --i)
-		ib_dma_unmap_single(priv->ca, mapping[i], PAGE_SIZE, DMA_FROM_DEVICE);
+		ib_dma_unmap_page(priv->ca, mapping[i], PAGE_SIZE, DMA_FROM_DEVICE);
 
 	dev_kfree_skb_any(skb);
 	return NULL;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
