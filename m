From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ib/ipoib: fix CM crash after commit b13912bbb4a2
Date: Mon,  4 Feb 2013 17:29:10 +0200
Message-ID: <1359991750-16346-1-git-send-email-shlomop@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

after commit b13912bbb4a2 "IPoIB: Call skb_dst_drop() once skb is enqueued for sending"
using connected mode and running multithreaded iperf for long time
that is iperf -c <IP> -P 16 -t 3600 results with a crash.

solution is to always perform the skb_orphan and skb_dst_drop before the transmission.
In case error occures than it will be no different than the regular case where dev_free_skb_any
in the completion path which is assumed to be after these two routines.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c |    6 +++---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 03103d2..67b0c1d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -741,6 +741,9 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 
 	tx_req->mapping = addr;
 
+	skb_orphan(skb);
+	skb_dst_drop(skb);
+
 	rc = post_send(priv, tx, tx->tx_head & (ipoib_sendq_size - 1),
 		       addr, skb->len);
 	if (unlikely(rc)) {
@@ -752,9 +755,6 @@ void ipoib_cm_send(struct net_device *dev, struct sk_buff *skb, struct ipoib_cm_
 		dev->trans_start = jiffies;
 		++tx->tx_head;
 
-		skb_orphan(skb);
-		skb_dst_drop(skb);
-
 		if (++priv->tx_outstanding == ipoib_sendq_size) {
 			ipoib_dbg(priv, "TX ring 0x%x full, stopping kernel net queue\n",
 				  tx->qp->qp_num);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index a1bca70..2cfa76f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -600,6 +600,9 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 		netif_stop_queue(dev);
 	}
 
+	skb_orphan(skb);
+	skb_dst_drop(skb);
+
 	rc = post_send(priv, priv->tx_head & (ipoib_sendq_size - 1),
 		       address->ah, qpn, tx_req, phead, hlen);
 	if (unlikely(rc)) {
@@ -615,9 +618,6 @@ void ipoib_send(struct net_device *dev, struct sk_buff *skb,
 
 		address->last_send = priv->tx_head;
 		++priv->tx_head;
-
-		skb_orphan(skb);
-		skb_dst_drop(skb);
 	}
 
 	if (unlikely(priv->tx_outstanding > MAX_SEND_CQE))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
