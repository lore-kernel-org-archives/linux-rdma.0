From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/ipoib: Get rid of the tx_outstanding variable in all modes
Date: Mon, 16 Oct 2017 08:48:59 +0300
Message-ID: <20171016054901.32479-2-leon@kernel.org>
References: <20171016054901.32479-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054901.32479-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The first step toward using NAPI in the UD/TX flow is to separate
between two flows, the NAPI and the xmit, meaning no use of shared
variables between both flows.

This patch takes out the tx_outstanding variable that was used in both
flows and instead the driver uses the 2 cyclic ring variables: tx_head
and tx_tail, tx_head used in the xmit flow and tx_tail in the NAPI flow.

Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h    |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 10 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 10 ++++------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 4a5c7a07a631..882faffa4103 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -381,7 +381,6 @@ struct ipoib_dev_priv {
 	unsigned	     tx_tail;
 	struct ib_sge	     tx_sge[MAX_SKB_FRAGS + 1];
 	struct ib_ud_wr      tx_wr;
-	unsigned	     tx_outstanding;
 	struct ib_wc	     send_wc[MAX_SEND_CQE];
 
 	struct ib_recv_wr    rx_wr;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 7500c28eac6b..6e0fc592791e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -769,8 +769,8 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 	} else {
 		netif_trans_update(dev);
 		++tx->tx_head;
-
-		if (++priv->tx_outstanding == ipoib_sendq_size) {
+		++priv->tx_head;
+		if ((priv->tx_head - priv->tx_tail) == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
 			netif_stop_queue(dev);
@@ -814,7 +814,8 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	netif_tx_lock(dev);
 
 	++tx->tx_tail;
-	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
+	++priv->tx_tail;
+	if (unlikely((priv->tx_head - priv->tx_tail) == ipoib_sendq_size >> 1) &&
 	    netif_queue_stopped(dev) &&
 	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		netif_wake_queue(dev);
@@ -1220,8 +1221,9 @@ static void ipoib_cm_tx_destroy(struct ipoib_cm_tx *p)
 		ipoib_dma_unmap_tx(priv, tx_req);
 		dev_kfree_skb_any(tx_req->skb);
 		++p->tx_tail;
+		++priv->tx_tail;
 		netif_tx_lock_bh(p->dev);
-		if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
+		if (unlikely(priv->tx_head - priv->tx_tail == ipoib_sendq_size >> 1) &&
 		    netif_queue_stopped(p->dev) &&
 		    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 			netif_wake_queue(p->dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index bcb8d501618b..25f3118b9e1f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -406,7 +406,7 @@ static void ipoib_ib_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 	dev_kfree_skb_any(tx_req->skb);
 
 	++priv->tx_tail;
-	if (unlikely(--priv->tx_outstanding == ipoib_sendq_size >> 1) &&
+	if (unlikely((priv->tx_head - priv->tx_tail) == ipoib_sendq_size >> 1) &&
 	    netif_queue_stopped(dev) &&
 	    test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
 		netif_wake_queue(dev);
@@ -611,8 +611,8 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		priv->tx_wr.wr.send_flags |= IB_SEND_IP_CSUM;
 	else
 		priv->tx_wr.wr.send_flags &= ~IB_SEND_IP_CSUM;
-
-	if (++priv->tx_outstanding == ipoib_sendq_size) {
+	/* increase the tx_head after send success, but use it for queue state */
+	if (priv->tx_head - priv->tx_tail == ipoib_sendq_size - 1) {
 		ipoib_dbg(priv, "TX ring full, stopping kernel net queue\n");
 		if (ib_req_notify_cq(priv->send_cq, IB_CQ_NEXT_COMP))
 			ipoib_warn(priv, "request notify on send CQ failed\n");
@@ -627,7 +627,6 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	if (unlikely(rc)) {
 		ipoib_warn(priv, "post_send failed, error %d\n", rc);
 		++dev->stats.tx_errors;
-		--priv->tx_outstanding;
 		ipoib_dma_unmap_tx(priv, tx_req);
 		dev_kfree_skb_any(skb);
 		if (netif_queue_stopped(dev))
@@ -640,7 +639,7 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		++priv->tx_head;
 	}
 
-	if (unlikely(priv->tx_outstanding > MAX_SEND_CQE))
+	if (unlikely(priv->tx_head - priv->tx_tail > MAX_SEND_CQE))
 		while (poll_tx(priv))
 			; /* nothing */
 
@@ -773,7 +772,6 @@ int ipoib_ib_dev_stop_default(struct net_device *dev)
 				ipoib_dma_unmap_tx(priv, tx_req);
 				dev_kfree_skb_any(tx_req->skb);
 				++priv->tx_tail;
-				--priv->tx_outstanding;
 			}
 
 			for (i = 0; i < ipoib_recvq_size; ++i) {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
