From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IPoIB: serialize changing on tx_outstanding
Date: Mon, 28 Sep 2015 13:42:10 +0800
Message-ID: <1443418930-18677-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The changing on tx_outstanding should be protected by spinlock or to be
atomic operations.

Such log is found in dmesg:

Sep 16 14:20:53 naep11x06 kernel: ib0: queue stopped 1, tx_head 1034733, tx_tail 1034733, tx_outstanding 359 ipoib_sendq_size: 512
Sep 16 14:21:33 naep11x06 kernel: ib0: transmit timeout: latency 9560 msecs
Sep 16 14:21:33 naep11x06 kernel: ib0: queue stopped 1, tx_head 1034854, tx_tail 1034854, tx_outstanding 511 ipoib_sendq_size: 512
Sep 16 14:21:38 naep11x06 kernel: ib0: transmit timeout: latency 14568 msecs
Sep 16 14:21:38 naep11x06 kernel: ib0: queue stopped 1, tx_head 1034854, tx_tail 1034854, tx_outstanding 511 ipoib_sendq_size: 512

And the send queue of ib0 kept full. When transmit timeout is reported,
queue is reported as "stopped", but the IPoIB stuff tx_head and tx_tail
points to same value. I am not able to see such numbers in ipoib_cm_tx
(for CM) because I have no vmcore. Though I am not quite sure it's caused
by parallel access of tx_outstanding(send path VS interrup path), we really
need to serialize the changeing on tx_outstanding.

This patch also make sure the increase of tx_outstanding prior to the
calling of post_send to avoid the possible decreasing before increasing in
case the running of increasing is scheduled later than the interrupt
handler.

Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 40 +++++++++++++++++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 24 ++++++++++++++++++--
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index c78dc16..044da94 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -710,6 +710,7 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_tx_buf *tx_req;
 	int rc;
+	unsigned long flags;
 
 	if (unlikely(skb->len > tx->mtu)) {
 		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
@@ -742,27 +743,36 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	skb_orphan(skb);
 	skb_dst_drop(skb);
 
+	spin_lock_irqsave(&priv->lock, flags);
+	if (++priv->tx_outstanding == ipoib_sendq_size) {
+		ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
+			  tx->qp->qp_num);
+		netif_stop_queue(dev);
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+	if (netif_queue_stopped(dev)) {
+		rc = ib_req_notify_cq(priv->send_cq,
+			IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+		if (rc < 0)
+			ipoib_warn(priv, "request notify on send CQ failed\n");
+		else if (rc)
+			ipoib_send_comp_handler(priv->send_cq, dev);
+	}
+
 	rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1), tx_req);
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
+		spin_lock_irqsave(&priv->lock, flags);
+		--priv->tx_outstanding;
+		if (netif_queue_stopped(dev))
+			netif_wake_queue(dev);
+		spin_unlock_irqrestore(&priv->lock, flags);
 		ipoib_dma_unmap_tx(priv, tx_req);
 		dev_kfree_skb_any(skb);
 	} else {
 		dev->trans_start = jiffies;
 		++tx->tx_head;
-
-		if (++priv->tx_outstanding == ipoib_sendq_size) {
-			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
-				  tx->qp->qp_num);
-			netif_stop_queue(dev);
-			rc = ib_req_notify_cq(priv->send_cq,
-				IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
-			if (rc < 0)
-				ipoib_warn(priv, "request notify on send CQ failed\n");
-			else if (rc)
-				ipoib_send_comp_handler(priv->send_cq, dev);
-		}
 	}
 }
 
@@ -796,10 +806,13 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	netif_tx_lock(dev);
 
 	++tx->tx_tail;
+
+	spin_lock_irqsave(&priv->lock, flags);
 	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
 	    netif_queue_stopped(dev) &&
 	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		netif_wake_queue(dev);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (wc->status != IB_WC_SUCCESS &&
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
@@ -1169,6 +1182,7 @@ static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
 	struct ipoib_tx_buf *tx_req;
 	unsigned long begin;
+	unsigned long flags;
 
 	ipoib_dbg(priv, "Destroy active connection 0x%x head 0x%x tail 0x%x\n",
 		  p->qp ? p->qp->qp_num : 0, p->tx_head, p->tx_tail);
@@ -1198,10 +1212,12 @@ timeout:
 		dev_kfree_skb_any(tx_req->skb);
 		++p->tx_tail;
 		netif_tx_lock_bh(p->dev);
+		spin_lock_irqsave(&priv->lock, flags);
 		if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
 		    netif_queue_stopped(p->dev) &&
 		    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 			netif_wake_queue(p->dev);
+		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(p->dev);
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index d266667..7616e3c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -377,6 +377,7 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	unsigned int wr_id = wc->wr_id;
 	struct ipoib_tx_buf *tx_req;
+	unsigned long flags;
 
 	ipoib_dbg_data(priv, "send completion: id %d, status: %d\n",
 		       wr_id, wc->status);
@@ -397,10 +398,13 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	dev_kfree_skb_any(tx_req->skb);
 
 	++priv->tx_tail;
+
+	spin_lock_irqsave(&priv->lock, flags);
 	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
 	    netif_queue_stopped(dev) &&
 	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		netif_wake_queue(dev);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	if (wc->status != IB_WC_SUCCESS &&
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
@@ -540,6 +544,7 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	struct ipoib_tx_buf *tx_req;
 	int hlen, rc;
 	void *phead;
+	unsigned long flags;
 
 	if (skb_is_gso(skb)) {
 		hlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
@@ -587,12 +592,22 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	else
 		priv->tx_wr.send_flags &= ~IB_SEND_IP_CSUM;
 
+	spin_lock_irqsave(&priv->lock, flags);
 	if (++priv->tx_outstanding == ipoib_sendq_size) {
 		ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
 		if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
 			ipoib_warn(priv, "request notify on send CQ failed\n");
 		netif_stop_queue(dev);
 	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+	if (netif_queue_stopped(dev)) {
+		rc = ib_req_notify_cq(priv->send_cq,
+			IB_CQ_NEXT_COMP | IB_CQ_REPORT_MISSED_EVENTS);
+		if (rc < 0)
+			ipoib_warn(priv, "request notify on send CQ failed\n");
+		else if (rc)
+			ipoib_send_comp_handler(priv->send_cq, dev);
+	}
 
 	skb_orphan(skb);
 	skb_dst_drop(skb);
@@ -602,11 +617,13 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
+		spin_lock_irqsave(&priv->lock, flags);
 		--priv->tx_outstanding;
-		ipoib_dma_unmap_tx(priv, tx_req);
-		dev_kfree_skb_any(skb);
 		if (netif_queue_stopped(dev))
 			netif_wake_queue(dev);
+		spin_unlock_irqrestore(&priv->lock, flags);
+		ipoib_dma_unmap_tx(priv, tx_req);
+		dev_kfree_skb_any(skb);
 	} else {
 		dev->trans_start = jiffies;
 
@@ -825,6 +842,7 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 	unsigned long begin;
 	struct ipoib_tx_buf *tx_req;
 	int i;
+	unsigned long flags;
 
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 		napi_disable(&priv->napi);
@@ -857,7 +875,9 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 				ipoib_dma_unmap_tx(priv, tx_req);
 				dev_kfree_skb_any(tx_req->skb);
 				++priv->tx_tail;
+				spin_lock_irqsave(&priv->lock, flags);
 				--priv->tx_outstanding;
+				spin_unlock_irqrestore(&priv->lock, flags);
 			}
 
 			for (i = 0; i < ipoib_recvq_size; ++i) {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
