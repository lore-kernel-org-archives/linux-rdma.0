From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] ib/ipoib: include err code in trace message for
 ib_post_send() failures
Date: Thu, 4 Mar 2010 15:17:37 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1003041516560.2755@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

print the return code of ib_post_send() if it fails
to help debug errors

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    8 +++++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    9 +++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

Index: a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -529,7 +529,7 @@ void ipoib_send(struct net_device *dev,
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_tx_buf *tx_req;
-	int hlen;
+	int hlen, rc;
 	void *phead;

 	if (skb_is_gso(skb)) {
@@ -585,9 +585,10 @@ void ipoib_send(struct net_device *dev,
 		netif_stop_queue(dev);
 	}

-	if (unlikely(post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
-			       address->ah, qpn, tx_req, phead, hlen))) {
-		ipoib_warn(priv, "post_send failed\n");
+	rc = post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
+				address->ah, qpn, tx_req, phead, hlen);
+	if (unlikely(rc)) {
+		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
 		--priv->tx_outstanding;
 		ipoib_dma_unmap_tx(priv->ca, tx_req);
Index: a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
===================================================================
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -708,6 +708,7 @@ void ipoib_cm_send(struct net_device *de
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_tx_buf *tx_req;
 	u64 addr;
+	int rc;

 	if (unlikely(skb->len > tx->mtu)) {
 		ipoib_warn(priv, "packet len %d (> %d) too long to send, dropping\n",
@@ -739,9 +740,10 @@ void ipoib_cm_send(struct net_device *de

 	tx_req->mapping = addr;

-	if (unlikely(post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
-			       addr, skb->len))) {
-		ipoib_warn(priv, "post_send failed\n");
+	rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
+				addr, skb->len);
+	if (unlikely(rc)) {
+		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
 		ib_dma_unmap_single(priv->ca, addr, skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
