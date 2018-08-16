From: Aaron Knister <aaron.s.knister@nasa.gov>
Subject: [PATCH] avoid race condition between start_xmit and cm_rep_handler
Date: Wed, 15 Aug 2018 21:11:49 -0400
Message-ID: <1534381909-2219-1-git-send-email-aaron.s.knister@nasa.gov>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, John Fleck <john.fleck@intel.com>
List-Id: linux-rdma@vger.kernel.org

Inside of start_xmit() the call to check if the connection is up and the
queueing of the packets for later transmission is not atomic which
leaves a window where cm_rep_handler can run, set the connection up,
dequeue pending packets and leave the subsequently queued packets by
start_xmit() sitting on neigh->queue until they're dropped when the
connection is torn down. This only applies to connected mode. These
dropped packets can really upset TCP, for example,  and cause
multi-minute delays in transmission for open connections.

I've got a reproducer available if it's needed.

Here's the code in start_xmit where we check to see if the connection
is up:

       if (ipoib_cm_get(neigh)) {
               if (ipoib_cm_up(neigh)) {
                       ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
                       goto unref;
               }
       }

The race occurs if cm_rep_handler execution occurs after the above
connection check (specifically if it gets to the point where it acquires
priv->lock to dequeue pending skb's) but before the below code snippet
in start_xmit where packets are queued.

       if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
               push_pseudo_header(skb, phdr->hwaddr);
               spin_lock_irqsave(&priv->lock, flags);
               __skb_queue_tail(&neigh->queue, skb);
               spin_unlock_irqrestore(&priv->lock, flags);
       } else {
               ++dev->stats.tx_dropped;
               dev_kfree_skb_any(skb);
       }

The patch re-checks ipoib_cm_up with priv->lock held to avoid this
race condition. Since odds are the conn should be up most of the time
(and thus the connection *not* down most of the time) we don't hold the
lock for the first check attempt to avoid a slowdown from unecessary
locking for the majority of the packets transmitted during the
connection's life.

Cc: stable@vger.kernel.org
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Aaron Knister <aaron.s.knister@nasa.gov>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 53 +++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 26cde95b..529dbeab 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1093,6 +1093,34 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+static void defer_neigh_skb(struct sk_buff *skb,  struct net_device *dev,
+			    struct ipoib_neigh *neigh,
+			    struct ipoib_pseudo_header *phdr,
+			    unsigned long *flags)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	unsigned long local_flags;
+	int acquire_priv_lock = 0;
+
+	/* Passing in pointer to spin_lock flags indicates spin lock
+	 * already acquired so we don't need to acquire the priv lock */
+	if (flags == NULL) {
+		flags = &local_flags;
+		acquire_priv_lock = 1;
+	}
+
+	if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
+		push_pseudo_header(skb, phdr->hwaddr);
+		if (acquire_priv_lock)
+			spin_lock_irqsave(&priv->lock, *flags);
+		__skb_queue_tail(&neigh->queue, skb);
+		spin_unlock_irqrestore(&priv->lock, *flags);
+	} else {
+		++dev->stats.tx_dropped;
+		dev_kfree_skb_any(skb);
+	}
+}
+
 static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -1160,6 +1188,21 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
 			goto unref;
 		}
+		/*
+		 * Re-check ipoib_cm_up with priv->lock held to avoid
+		 * race condition between start_xmit and skb_dequeue in
+		 * cm_rep_handler. Since odds are the conn should be up
+		 * most of the time, we don't hold the lock for the
+		 * first check above
+		 */
+		spin_lock_irqsave(&priv->lock, flags);
+		if (ipoib_cm_up(neigh)) {
+			spin_unlock_irqrestore(&priv->lock, flags);
+			ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
+		} else  {
+			defer_neigh_skb(skb, dev, neigh, phdr, &flags);
+		}
+		goto unref;
 	} else if (neigh->ah && neigh->ah->valid) {
 		neigh->ah->last_send = rn->send(dev, skb, neigh->ah->ah,
 						IPOIB_QPN(phdr->hwaddr));
@@ -1168,15 +1211,7 @@ static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		neigh_refresh_path(neigh, phdr->hwaddr, dev);
 	}
 
-	if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
-		push_pseudo_header(skb, phdr->hwaddr);
-		spin_lock_irqsave(&priv->lock, flags);
-		__skb_queue_tail(&neigh->queue, skb);
-		spin_unlock_irqrestore(&priv->lock, flags);
-	} else {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
-	}
+	defer_neigh_skb(skb, dev, neigh, phdr, NULL);
 
 unref:
 	ipoib_neigh_put(neigh);
-- 
2.12.3
