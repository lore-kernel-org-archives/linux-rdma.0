From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4] IB/ipoib: fix dangling pointer references to
 ipoib_neigh and ipoib_path
Date: Wed, 5 May 2010 16:30:26 -0700
Message-ID: <1273102226.28097.337.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Basically, a struct sk_buff has a pointer to a struct dst_entry
which has a pointer to a struct neighbour. IPoIB uses
struct neighbour.ha to store the IB "hardware address" and a pointer
to a struct ipoib_neigh. When using connected mode, struct ipoib_neigh
has a pointer to struct ipoib_cm_tx which contains pointers back to struct
ipoib_neigh and ipoib_path. The core network code will call
ipoib_neigh_cleanup() when it is destroying struct neighbour and IPoIB
should guarantee that the struct ipoib_neigh and all the memory it points
to are destroyed. Also, the connected mode RC QP contains a pointer back
to the struct ipoib_cm_tx which can be dereferenced in the CQ completion handler.
The problem is that there are several places where the struct ipoib_cm_tx
can be used after it has been freed. The easiest way to reproduce this
bug is to run a UDP bandwidth test while loading/unloading the IPoIB module
or ifup/ifdown the interface.
The fix is rather complex since the RC QP connection setup, tear down,
and CQ completion draining are asynchronous processes. The struct ipoib_cm_tx
goes through four "states":
1) created, flags==0, and linked on the priv->cm.start_list.
2) not on the start_list, flags==0, and in the process of creating the RC QP.
3) not on the start_list, flags & IPOIB_FLAG_INITIALIZED, and RC QP created.
4) on the priv->cm.reap_task list or being destroyed by ipoib_cm_tx_reap().

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

I updated the description to be more detailed.
I stripped out as much non-functional code changes as I could.

 drivers/infiniband/ulp/ipoib/ipoib.h           |   14 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  108 +++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  259 +++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   76 ++-----
 4 files changed, 215 insertions(+), 242 deletions(-)


diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..5a842d7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -415,9 +415,7 @@ static inline struct ipoib_neigh **to_ipoib_neigh(struct neighbour *neigh)
 				     INFINIBAND_ALEN, sizeof(void *));
 }
 
-struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neigh,
-				      struct net_device *dev);
-void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh);
+void ipoib_neigh_flush(struct ipoib_neigh *neigh);
 
 extern struct workqueue_struct *ipoib_workqueue;
 
@@ -464,7 +462,8 @@ void ipoib_dev_cleanup(struct net_device *dev);
 
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb);
+void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb,
+		      struct ipoib_neigh *neigh);
 
 void ipoib_mcast_restart_task(struct work_struct *work);
 int ipoib_mcast_start_thread(struct net_device *dev);
@@ -570,6 +569,7 @@ void ipoib_cm_dev_cleanup(struct net_device *dev);
 struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
 				    struct ipoib_neigh *neigh);
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx);
+void ipoib_cm_flush_path(struct net_device *dev, struct ipoib_path *path);
 void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff *skb,
 			   unsigned int mtu);
 void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc);
@@ -659,6 +659,12 @@ void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 }
 
 static inline
+void ipoib_cm_flush_path(struct net_device *dev, struct ipoib_path *path)
+{
+	return;
+}
+
+static inline
 int ipoib_cm_add_mode_attr(struct net_device *dev)
 {
 	return 0;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index bc65837..28c222b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -798,31 +798,14 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 
 	if (wc->status != IB_WC_SUCCESS &&
 	    wc->status != IB_WC_WR_FLUSH_ERR) {
-		struct ipoib_neigh *neigh;
-
 		ipoib_dbg(priv, "failed cm send event "
 			   "(status=%d, wrid=%d vend_err %x)\n",
 			   wc->status, wr_id, wc->vendor_err);
 
 		spin_lock_irqsave(&priv->lock, flags);
-		neigh = tx->neigh;
-
-		if (neigh) {
-			neigh->cm = NULL;
-			list_del(&neigh->list);
-			if (neigh->ah)
-				ipoib_put_ah(neigh->ah);
-			ipoib_neigh_free(dev, neigh);
-
-			tx->neigh = NULL;
-		}
-
-		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
-			list_move(&tx->list, &priv->cm.reap_list);
-			queue_work(ipoib_workqueue, &priv->cm.reap_task);
-		}
 
 		clear_bit(IPOIB_FLAG_OPER_UP, &tx->flags);
+		ipoib_cm_destroy_tx(tx);
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
@@ -1203,7 +1186,6 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 	struct ipoib_cm_tx *tx = cm_id->context;
 	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
 	struct net_device *dev = priv->dev;
-	struct ipoib_neigh *neigh;
 	unsigned long flags;
 	int ret;
 
@@ -1225,22 +1207,8 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 		ipoib_dbg(priv, "CM error %d.\n", event->event);
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
-		neigh = tx->neigh;
-
-		if (neigh) {
-			neigh->cm = NULL;
-			list_del(&neigh->list);
-			if (neigh->ah)
-				ipoib_put_ah(neigh->ah);
-			ipoib_neigh_free(dev, neigh);
-
-			tx->neigh = NULL;
-		}
 
-		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
-			list_move(&tx->list, &priv->cm.reap_list);
-			queue_work(ipoib_workqueue, &priv->cm.reap_task);
-		}
+		ipoib_cm_destroy_tx(tx);
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
@@ -1267,20 +1235,62 @@ struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path
 	tx->path = path;
 	tx->dev = dev;
 	list_add(&tx->list, &priv->cm.start_list);
-	set_bit(IPOIB_FLAG_INITIALIZED, &tx->flags);
 	queue_work(ipoib_workqueue, &priv->cm.start_task);
 	return tx;
 }
 
+/*
+ * Note: this is called with netif_tx_lock_bh() and priv->lock held.
+ */
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
-	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
+	struct ipoib_neigh *neigh = tx->neigh;
+
+	if (!neigh)
+		return;
+
+	ipoib_dbg(priv, "Reap connection for gid %pI6\n", neigh->dgid.raw);
+	neigh->cm = NULL;
+	tx->neigh = NULL;
+
+	/* Force ipoib_start_xmit() to start a new connection if called */
+	if (neigh->ah) {
+		ipoib_put_ah(neigh->ah);
+		neigh->ah = NULL;
+		memset(&neigh->dgid.raw, 0, sizeof(union ib_gid));
+	}
+
+	/*
+	 * If ipoib_cm_tx_start() is actively using this tx,
+	 * don't delete it by putting it on the reap_list.
+	 * Instead, ipoib_cm_tx_start() will handle the destruction.
+	 */
+	if (!list_empty(&tx->list) ||
+	    test_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
 		list_move(&tx->list, &priv->cm.reap_list);
 		queue_work(ipoib_workqueue, &priv->cm.reap_task);
-		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
-			  tx->neigh->dgid.raw);
-		tx->neigh = NULL;
+	}
+}
+
+/*
+ * Search the list of connections to be started and remove any entries
+ * which match the path being destroyed.
+ *
+ * This should be called with netif_tx_lock_bh() and priv->lock held.
+ */
+void ipoib_cm_flush_path(struct net_device *dev, struct ipoib_path *path)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_cm_tx *tx, *nx;
+
+	list_for_each_entry_safe(tx, nx, &priv->cm.start_list, list) {
+		tx = list_entry(priv->cm.start_list.next, typeof(*tx), list);
+		if (tx->path == path) {
+			list_del(&tx->list);
+			kfree(tx);
+			break;
+		}
 	}
 }
 
@@ -1306,6 +1316,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		neigh = p->neigh;
 		qpn = IPOIB_QPN(neigh->neighbour->ha);
 		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
+		p->path = NULL;
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
@@ -1315,18 +1326,17 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
 
-		if (ret) {
-			neigh = p->neigh;
-			if (neigh) {
+		/*
+		 * If ipoib_cm_destroy_tx() was called or there was an error,
+		 * we need to destroy tx.
+		 */
+		neigh = p->neigh;
+		if (!neigh || ret) {
+			if (neigh)
 				neigh->cm = NULL;
-				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
-			}
-			list_del(&p->list);
 			kfree(p);
-		}
+		} else
+			set_bit(IPOIB_FLAG_INITIALIZED, &p->flags);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index df3eb8c..6fe905a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -91,6 +91,9 @@ struct workqueue_struct *ipoib_workqueue;
 
 struct ib_sa_client ipoib_sa_client;
 
+static struct ipoib_neigh *neigh_alloc(struct neighbour *neighbour,
+				       struct net_device *dev);
+
 static void ipoib_add_one(struct ib_device *device);
 static void ipoib_remove_one(struct ib_device *device);
 
@@ -261,32 +264,16 @@ static int __path_add(struct net_device *dev, struct ipoib_path *path)
 	return 0;
 }
 
-static void path_free(struct net_device *dev, struct ipoib_path *path)
+static void path_free(struct ipoib_path *path)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_neigh *neigh, *tn;
 	struct sk_buff *skb;
-	unsigned long flags;
 
 	while ((skb = __skb_dequeue(&path->queue)))
 		dev_kfree_skb_irq(skb);
 
-	spin_lock_irqsave(&priv->lock, flags);
-
-	list_for_each_entry_safe(neigh, tn, &path->neigh_list, list) {
-		/*
-		 * It's safe to call ipoib_put_ah() inside priv->lock
-		 * here, because we know that path->ah will always
-		 * hold one more reference, so ipoib_put_ah() will
-		 * never do more than decrement the ref count.
-		 */
-		if (neigh->ah)
-			ipoib_put_ah(neigh->ah);
-
-		ipoib_neigh_free(dev, neigh);
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
+	list_for_each_entry_safe(neigh, tn, &path->neigh_list, list)
+		ipoib_neigh_flush(neigh);
 
 	if (path->ah)
 		ipoib_put_ah(path->ah);
@@ -387,10 +374,11 @@ void ipoib_flush_paths(struct net_device *dev)
 	list_for_each_entry_safe(path, tp, &remove_list, list) {
 		if (path->query)
 			ib_sa_cancel_query(path->query_id, path->query);
+		ipoib_cm_flush_path(dev, path);
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 		wait_for_completion(&path->done);
-		path_free(dev, path);
+		path_free(path);
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
 	}
@@ -460,19 +448,15 @@ static void path_rec_completion(int status,
 			memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
 			       sizeof(union ib_gid));
 
-			if (ipoib_cm_enabled(dev, neigh->neighbour)) {
-				if (!ipoib_cm_get(neigh))
-					ipoib_cm_set(neigh, ipoib_cm_create_tx(dev,
-									       path,
-									       neigh));
-				if (!ipoib_cm_get(neigh)) {
-					list_del(&neigh->list);
-					if (neigh->ah)
-						ipoib_put_ah(neigh->ah);
-					ipoib_neigh_free(dev, neigh);
-					continue;
-				}
-			}
+			/*
+			 * If connected mode is enabled but not started,
+			 * start getting a connection.
+			 */
+			if (ipoib_cm_enabled(dev, neigh->neighbour) &&
+			    !ipoib_cm_get(neigh))
+				ipoib_cm_set(neigh, ipoib_cm_create_tx(dev,
+								       path,
+								       neigh));
 
 			while ((skb = __skb_dequeue(&neigh->queue)))
 				__skb_queue_tail(&skqueue, skb);
@@ -520,6 +504,8 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	path->pathrec.numb_path     = 1;
 	path->pathrec.traffic_class = priv->broadcast->mcmember.traffic_class;
 
+	__path_add(dev, path);
+
 	return path;
 }
 
@@ -554,32 +540,27 @@ static int path_rec_start(struct net_device *dev,
 	return 0;
 }
 
-static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
+static void neigh_add_path(struct sk_buff *skb, struct net_device *dev,
+			   struct ipoib_neigh *neigh)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_path *path;
-	struct ipoib_neigh *neigh;
+	struct neighbour *n;
 	unsigned long flags;
 
-	neigh = ipoib_neigh_alloc(skb_dst(skb)->neighbour, skb->dev);
-	if (!neigh) {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
-		return;
-	}
+	n = skb_dst(skb)->neighbour;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	path = __path_find(dev, skb_dst(skb)->neighbour->ha + 4);
+	path = __path_find(dev, n->ha + 4);
 	if (!path) {
-		path = path_rec_create(dev, skb_dst(skb)->neighbour->ha + 4);
+		path = path_rec_create(dev, n->ha + 4);
 		if (!path)
-			goto err_path;
-
-		__path_add(dev, path);
+			goto err_drop;
 	}
 
-	list_add_tail(&neigh->list, &path->neigh_list);
+	if (list_empty(&neigh->list))
+		list_add_tail(&neigh->list, &path->neigh_list);
 
 	if (path->ah) {
 		kref_get(&path->ah->ref);
@@ -587,16 +568,11 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 		memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
 		       sizeof(union ib_gid));
 
-		if (ipoib_cm_enabled(dev, neigh->neighbour)) {
+		if (ipoib_cm_enabled(dev, n)) {
 			if (!ipoib_cm_get(neigh))
 				ipoib_cm_set(neigh, ipoib_cm_create_tx(dev, path, neigh));
-			if (!ipoib_cm_get(neigh)) {
-				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
+			if (!ipoib_cm_get(neigh))
 				goto err_drop;
-			}
 			if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
 				__skb_queue_tail(&neigh->queue, skb);
 			else {
@@ -606,12 +582,10 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 			}
 		} else {
 			spin_unlock_irqrestore(&priv->lock, flags);
-			ipoib_send(dev, skb, path->ah, IPOIB_QPN(skb_dst(skb)->neighbour->ha));
+			ipoib_send(dev, skb, path->ah, IPOIB_QPN(n->ha));
 			return;
 		}
 	} else {
-		neigh->ah  = NULL;
-
 		if (!path->query && path_rec_start(dev, path))
 			goto err_list;
 
@@ -622,10 +596,7 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 	return;
 
 err_list:
-	list_del(&neigh->list);
-
-err_path:
-	ipoib_neigh_free(dev, neigh);
+	list_del_init(&neigh->list);
 err_drop:
 	++dev->stats.tx_dropped;
 	dev_kfree_skb_any(skb);
@@ -633,20 +604,22 @@ err_drop:
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static void ipoib_path_lookup(struct sk_buff *skb, struct net_device *dev)
+static void path_lookup(struct sk_buff *skb, struct net_device *dev,
+			struct ipoib_neigh *neigh)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(skb->dev);
+	struct ipoib_dev_priv *priv;
 
 	/* Look up path record for unicasts */
 	if (skb_dst(skb)->neighbour->ha[4] != 0xff) {
-		neigh_add_path(skb, dev);
+		neigh_add_path(skb, dev, neigh);
 		return;
 	}
 
 	/* Add in the P_Key for multicasts */
+	priv = netdev_priv(dev);
 	skb_dst(skb)->neighbour->ha[8] = (priv->pkey >> 8) & 0xff;
 	skb_dst(skb)->neighbour->ha[9] = priv->pkey & 0xff;
-	ipoib_mcast_send(dev, skb_dst(skb)->neighbour->ha + 4, skb);
+	ipoib_mcast_send(dev, skb_dst(skb)->neighbour->ha + 4, skb, neigh);
 }
 
 static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
@@ -659,35 +632,13 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 	spin_lock_irqsave(&priv->lock, flags);
 
 	path = __path_find(dev, phdr->hwaddr + 4);
-	if (!path || !path->valid) {
-		int new_path = 0;
-
-		if (!path) {
-			path = path_rec_create(dev, phdr->hwaddr + 4);
-			new_path = 1;
-		}
-		if (path) {
-			/* put pseudoheader back on for next time */
-			skb_push(skb, sizeof *phdr);
-			__skb_queue_tail(&path->queue, skb);
-
-			if (!path->query && path_rec_start(dev, path)) {
-				spin_unlock_irqrestore(&priv->lock, flags);
-				if (new_path)
-					path_free(dev, path);
-				return;
-			} else
-				__path_add(dev, path);
-		} else {
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
-		}
-
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return;
+	if (!path) {
+		path = path_rec_create(dev, phdr->hwaddr + 4);
+		if (!path)
+			goto drop;
 	}
 
-	if (path->ah) {
+	if (path->valid && path->ah) {
 		ipoib_dbg(priv, "Send unicast ARP to %04x\n",
 			  be16_to_cpu(path->pathrec.dlid));
 
@@ -699,12 +650,16 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 		/* put pseudoheader back on for next time */
 		skb_push(skb, sizeof *phdr);
 		__skb_queue_tail(&path->queue, skb);
-	} else {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
-	}
+	} else
+		goto drop;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
+	return;
+
+drop:
+	++dev->stats.tx_dropped;
+	dev_kfree_skb_any(skb);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -714,31 +669,23 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 
 	if (likely(skb_dst(skb) && skb_dst(skb)->neighbour)) {
-		if (unlikely(!*to_ipoib_neigh(skb_dst(skb)->neighbour))) {
-			ipoib_path_lookup(skb, dev);
+		neigh = *to_ipoib_neigh(skb_dst(skb)->neighbour);
+
+		if (unlikely(!neigh)) {
+			neigh = neigh_alloc(skb_dst(skb)->neighbour, skb->dev);
+			if (!neigh) {
+				++dev->stats.tx_dropped;
+				dev_kfree_skb_any(skb);
+			} else
+				path_lookup(skb, dev, neigh);
 			return NETDEV_TX_OK;
 		}
 
-		neigh = *to_ipoib_neigh(skb_dst(skb)->neighbour);
-
 		if (unlikely((memcmp(&neigh->dgid.raw,
 				     skb_dst(skb)->neighbour->ha + 4,
 				     sizeof(union ib_gid))) ||
 			     (neigh->dev != dev))) {
-			spin_lock_irqsave(&priv->lock, flags);
-			/*
-			 * It's safe to call ipoib_put_ah() inside
-			 * priv->lock here, because we know that
-			 * path->ah will always hold one more reference,
-			 * so ipoib_put_ah() will never do more than
-			 * decrement the ref count.
-			 */
-			if (neigh->ah)
-				ipoib_put_ah(neigh->ah);
-			list_del(&neigh->list);
-			ipoib_neigh_free(dev, neigh);
-			spin_unlock_irqrestore(&priv->lock, flags);
-			ipoib_path_lookup(skb, dev);
+			path_lookup(skb, dev, neigh);
 			return NETDEV_TX_OK;
 		}
 
@@ -770,7 +717,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			phdr->hwaddr[8] = (priv->pkey >> 8) & 0xff;
 			phdr->hwaddr[9] = priv->pkey & 0xff;
 
-			ipoib_mcast_send(dev, phdr->hwaddr + 4, skb);
+			ipoib_mcast_send(dev, phdr->hwaddr + 4, skb, NULL);
 		} else {
 			/* unicast GID -- should be ARP or RARP reply */
 
@@ -847,34 +794,45 @@ static void ipoib_neigh_cleanup(struct neighbour *n)
 {
 	struct ipoib_neigh *neigh;
 	struct ipoib_dev_priv *priv = netdev_priv(n->dev);
+	struct sk_buff *skb;
 	unsigned long flags;
-	struct ipoib_ah *ah = NULL;
+
+	spin_lock_irqsave(&priv->lock, flags);
 
 	neigh = *to_ipoib_neigh(n);
-	if (neigh)
-		priv = netdev_priv(neigh->dev);
-	else
+	if (!neigh) {
+		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
+	}
+	*to_ipoib_neigh(n) = NULL;
+	neigh->neighbour = NULL;
+
 	ipoib_dbg(priv,
 		  "neigh_cleanup for %06x %pI6\n",
 		  IPOIB_QPN(n->ha),
 		  n->ha + 4);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	if (ipoib_cm_get(neigh))
+		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
 
-	if (neigh->ah)
-		ah = neigh->ah;
-	list_del(&neigh->list);
-	ipoib_neigh_free(n->dev, neigh);
+	if (!list_empty(&neigh->list))
+		list_del_init(&neigh->list);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ah)
-		ipoib_put_ah(ah);
+	while ((skb = __skb_dequeue(&neigh->queue))) {
+		++n->dev->stats.tx_dropped;
+		dev_kfree_skb_any(skb);
+	}
+
+	if (neigh->ah)
+		ipoib_put_ah(neigh->ah);
+
+	kfree(neigh);
 }
 
-struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
-				      struct net_device *dev)
+static struct ipoib_neigh *neigh_alloc(struct neighbour *neighbour,
+				       struct net_device *dev)
 {
 	struct ipoib_neigh *neigh;
 
@@ -882,27 +840,58 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
 	if (!neigh)
 		return NULL;
 
+	neigh->ah = NULL;
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
 	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
 	*to_ipoib_neigh(neighbour) = neigh;
 	skb_queue_head_init(&neigh->queue);
+	INIT_LIST_HEAD(&neigh->list);
 	ipoib_cm_set(neigh, NULL);
 
 	return neigh;
 }
 
-void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh)
+/*
+ * This is called when flushing the path or multicast GID from the
+ * struct ipoib_neigh. ipoib_start_xmit() will then try to reinitialize
+ * the address the next time it is called.
+ * Note that the "neigh" pointer passed should not be used after calling this.
+ */
+void ipoib_neigh_flush(struct ipoib_neigh *neigh)
 {
+	struct net_device *dev = neigh->dev;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct sk_buff_head skqueue;
 	struct sk_buff *skb;
-	*to_ipoib_neigh(neigh->neighbour) = NULL;
-	while ((skb = __skb_dequeue(&neigh->queue))) {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
-	}
+	struct ipoib_ah *ah;
+	unsigned long flags;
+
+	skb_queue_head_init(&skqueue);
+
+	netif_tx_lock_bh(dev);
+	spin_lock_irqsave(&priv->lock, flags);
+
+	while ((skb = __skb_dequeue(&neigh->queue)))
+		__skb_queue_tail(&skqueue, skb);
+
+	ah = neigh->ah;
+	neigh->ah = NULL;
+	memset(&neigh->dgid.raw, 0, sizeof(union ib_gid));
+	list_del_init(&neigh->list);
 	if (ipoib_cm_get(neigh))
 		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
-	kfree(neigh);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	netif_tx_unlock_bh(dev);
+
+	while ((skb = __skb_dequeue(&skqueue))) {
+		++dev->stats.tx_dropped;
+		dev_kfree_skb_irq(skb);
+	}
+
+	if (ah)
+		ipoib_put_ah(ah);
 }
 
 static int ipoib_neigh_setup_dev(struct net_device *dev, struct neigh_parms *parms)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index d41ea27..3863302 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -67,28 +67,14 @@ struct ipoib_mcast_iter {
 static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 {
 	struct net_device *dev = mcast->dev;
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_neigh *neigh, *tmp;
 	int tx_dropped = 0;
 
 	ipoib_dbg_mcast(netdev_priv(dev), "deleting multicast group %pI6\n",
 			mcast->mcmember.mgid.raw);
 
-	spin_lock_irq(&priv->lock);
-
-	list_for_each_entry_safe(neigh, tmp, &mcast->neigh_list, list) {
-		/*
-		 * It's safe to call ipoib_put_ah() inside priv->lock
-		 * here, because we know that mcast->ah will always
-		 * hold one more reference, so ipoib_put_ah() will
-		 * never do more than decrement the ref count.
-		 */
-		if (neigh->ah)
-			ipoib_put_ah(neigh->ah);
-		ipoib_neigh_free(dev, neigh);
-	}
-
-	spin_unlock_irq(&priv->lock);
+	list_for_each_entry_safe(neigh, tmp, &mcast->neigh_list, list)
+		ipoib_neigh_flush(neigh);
 
 	if (mcast->ah)
 		ipoib_put_ah(mcast->ah);
@@ -654,7 +640,8 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	return 0;
 }
 
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
+void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb,
+		      struct ipoib_neigh *neigh)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_mcast *mcast;
@@ -664,11 +651,8 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)		||
 	    !priv->broadcast					||
-	    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags)) {
-		++dev->stats.tx_dropped;
-		dev_kfree_skb_any(skb);
-		goto unlock;
-	}
+	    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags))
+		goto drop;
 
 	mcast = __ipoib_mcast_find(dev, mgid);
 	if (!mcast) {
@@ -680,9 +664,7 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 		if (!mcast) {
 			ipoib_warn(priv, "unable to allocate memory for "
 				   "multicast structure\n");
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
-			goto out;
+			goto drop;
 		}
 
 		set_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags);
@@ -692,39 +674,20 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 	}
 
 	if (!mcast->ah) {
-		if (skb_queue_len(&mcast->pkt_queue) < IPOIB_MAX_MCAST_QUEUE)
-			skb_queue_tail(&mcast->pkt_queue, skb);
-		else {
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
-		}
-
+		if (skb_queue_len(&mcast->pkt_queue) >= IPOIB_MAX_MCAST_QUEUE)
+			goto drop;
+		skb_queue_tail(&mcast->pkt_queue, skb);
 		if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
 			ipoib_dbg_mcast(priv, "no address vector, "
 					"but multicast join already started\n");
 		else if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags))
 			ipoib_mcast_sendonly_join(mcast);
-
-		/*
-		 * If lookup completes between here and out:, don't
-		 * want to send packet twice.
-		 */
-		mcast = NULL;
-	}
-
-out:
-	if (mcast && mcast->ah) {
-		if (skb_dst(skb)		&&
-		    skb_dst(skb)->neighbour &&
-		    !*to_ipoib_neigh(skb_dst(skb)->neighbour)) {
-			struct ipoib_neigh *neigh = ipoib_neigh_alloc(skb_dst(skb)->neighbour,
-									skb->dev);
-
-			if (neigh) {
-				kref_get(&mcast->ah->ref);
-				neigh->ah	= mcast->ah;
-				list_add_tail(&neigh->list, &mcast->neigh_list);
-			}
+	} else {
+		if (neigh && list_empty(&neigh->list)) {
+			kref_get(&mcast->ah->ref);
+			neigh->ah = mcast->ah;
+			memcpy(neigh->dgid.raw, mgid, sizeof(union ib_gid));
+			list_add_tail(&neigh->list, &mcast->neigh_list);
 		}
 
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -732,8 +695,13 @@ out:
 		return;
 	}
 
-unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	return;
+
+drop:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	++dev->stats.tx_dropped;
+	dev_kfree_skb_any(skb);
 }
 
 void ipoib_mcast_dev_flush(struct net_device *dev)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
