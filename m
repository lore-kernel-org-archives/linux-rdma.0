From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/ipoib: fix dangling pointer references to
	ipoib_neigh and ipoib_path
Date: Mon, 1 Mar 2010 17:50:25 -0800
Message-ID: <1267494625.3001.50.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When using connected mode, ipoib_cm_create_tx() kmallocs a
struct ipoib_cm_tx which contains pointers to ipoib_neigh and
ipoib_path. If the paths are flushed or the struct neighbour is
destroyed, the pointers held by struct ipoib_cm_tx can reference
freed memory.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

I was able to remove the kref_t added to struct ipoib_path and ipoib_neigh.
The key is to delete references to ipoib_neigh and ipoib_path
when ipoib_neigh_cleanup() is called.

 drivers/infiniband/ulp/ipoib/ipoib.h           |   24 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  105 +++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  267 +++++++++++-------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   95 +++------
 4 files changed, 222 insertions(+), 269 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..84bb561 100644
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
@@ -567,9 +566,10 @@ void ipoib_cm_dev_stop(struct net_device *dev);
 int ipoib_cm_dev_init(struct net_device *dev);
 int ipoib_cm_add_mode_attr(struct net_device *dev);
 void ipoib_cm_dev_cleanup(struct net_device *dev);
-struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
-				    struct ipoib_neigh *neigh);
+void ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
+			struct ipoib_neigh *neigh);
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx);
+void ipoib_cm_flush_path(struct net_device *dev, struct ipoib_path *path);
 void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff *skb,
 			   unsigned int mtu);
 void ipoib_cm_handle_rx_wc(struct net_device *dev, struct ib_wc *wc);
@@ -646,10 +646,10 @@ void ipoib_cm_dev_cleanup(struct net_device *dev)
 }
 
 static inline
-struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
-				    struct ipoib_neigh *neigh)
+void ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
+			struct ipoib_neigh *neigh)
 {
-	return NULL;
+	return;
 }
 
 static inline
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
index 30bdf42..4ec4ebc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -794,31 +794,14 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 
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
@@ -1199,7 +1182,6 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 	struct ipoib_cm_tx *tx = cm_id->context;
 	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
 	struct net_device *dev = priv->dev;
-	struct ipoib_neigh *neigh;
 	unsigned long flags;
 	int ret;
 
@@ -1221,22 +1203,8 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
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
@@ -1248,35 +1216,61 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 	return 0;
 }
 
-struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
-				       struct ipoib_neigh *neigh)
+void ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
+			struct ipoib_neigh *neigh)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_cm_tx *tx;
 
 	tx = kzalloc(sizeof *tx, GFP_ATOMIC);
 	if (!tx)
-		return NULL;
+		return;
 
 	neigh->cm = tx;
 	tx->neigh = neigh;
 	tx->path = path;
 	tx->dev = dev;
 	list_add(&tx->list, &priv->cm.start_list);
-	set_bit(IPOIB_FLAG_INITIALIZED, &tx->flags);
 	queue_work(ipoib_workqueue, &priv->cm.start_task);
-	return tx;
 }
 
+/*
+ * Note: this is called with netif_tx_lock_bh() and priv->lock held.
+ */
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
-	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
+	struct ipoib_neigh *neigh = tx->neigh;
+
+	if (neigh) {
+		struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
+
+		neigh->cm = NULL;
+		tx->neigh = NULL;
 		list_move(&tx->list, &priv->cm.reap_list);
 		queue_work(ipoib_workqueue, &priv->cm.reap_task);
 		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
-			  tx->neigh->dgid.raw);
-		tx->neigh = NULL;
+			  neigh->dgid.raw);
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
+	struct ipoib_cm_tx *tx;
+
+	list_for_each_entry(tx, &priv->cm.start_list, list) {
+		tx = list_entry(priv->cm.start_list.next, typeof(*tx), list);
+		if (tx->path == path) {
+			tx->path = NULL;
+			list_del_init(&tx->list);
+			break;
+		}
 	}
 }
 
@@ -1300,27 +1294,32 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		p = list_entry(priv->cm.start_list.next, typeof(*p), list);
 		list_del_init(&p->list);
 		neigh = p->neigh;
-		qpn = IPOIB_QPN(neigh->neighbour->ha);
 		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
+		p->path = NULL;
+		/*
+		 * ipoib_neigh_cleanup() may have been called while waiting
+		 * on the priv->cm.start_list.
+		 */
+		if (neigh->neighbour)
+			qpn = IPOIB_QPN(neigh->neighbour->ha);
+		else
+			qpn = 0;
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 
-		ret = ipoib_cm_tx_init(p, qpn, &pathrec);
+		if (qpn)
+			ret = ipoib_cm_tx_init(p, qpn, &pathrec);
+		else
+			ret = -1;
 
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
 
 		if (ret) {
 			neigh = p->neigh;
-			if (neigh) {
+			if (neigh)
 				neigh->cm = NULL;
-				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
-			}
-			list_del(&p->list);
 			kfree(p);
 		}
 	}
@@ -1342,7 +1341,7 @@ static void ipoib_cm_tx_reap(struct work_struct *work)
 
 	while (!list_empty(&priv->cm.reap_list)) {
 		p = list_entry(priv->cm.reap_list.next, typeof(*p), list);
-		list_del(&p->list);
+		list_del_init(&p->list);
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 		ipoib_cm_tx_destroy(p);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index df3eb8c..89c02a2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -91,6 +91,9 @@ struct workqueue_struct *ipoib_workqueue;
 
 struct ib_sa_client ipoib_sa_client;
 
+static struct ipoib_neigh *neigh_alloc(struct neighbour *neighbour,
+				       struct net_device *dev);
+
 static void ipoib_add_one(struct ib_device *device);
 static void ipoib_remove_one(struct ib_device *device);
 
@@ -231,7 +234,7 @@ static struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 	return NULL;
 }
 
-static int __path_add(struct net_device *dev, struct ipoib_path *path)
+static void __path_add(struct net_device *dev, struct ipoib_path *path)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node **n = &priv->path_tree.rb_node;
@@ -249,44 +252,26 @@ static int __path_add(struct net_device *dev, struct ipoib_path *path)
 			n = &pn->rb_left;
 		else if (ret > 0)
 			n = &pn->rb_right;
-		else
-			return -EEXIST;
+		else /* Should never happen since we always search first */
+			return;
 	}
 
 	rb_link_node(&path->rb_node, pn, n);
 	rb_insert_color(&path->rb_node, &priv->path_tree);
 
 	list_add_tail(&path->list, &priv->path_list);
-
-	return 0;
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
@@ -387,10 +372,11 @@ void ipoib_flush_paths(struct net_device *dev)
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
@@ -460,19 +446,13 @@ static void path_rec_completion(int status,
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
+				ipoib_cm_create_tx(dev, path, neigh);
 
 			while ((skb = __skb_dequeue(&neigh->queue)))
 				__skb_queue_tail(&skqueue, skb);
@@ -520,6 +500,8 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	path->pathrec.numb_path     = 1;
 	path->pathrec.traffic_class = priv->broadcast->mcmember.traffic_class;
 
+	__path_add(dev, path);
+
 	return path;
 }
 
@@ -554,29 +536,23 @@ static int path_rec_start(struct net_device *dev,
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
 
 	list_add_tail(&neigh->list, &path->neigh_list);
@@ -587,16 +563,11 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 		memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
 		       sizeof(union ib_gid));
 
-		if (ipoib_cm_enabled(dev, neigh->neighbour)) {
+		if (ipoib_cm_enabled(dev, n)) {
+			if (!ipoib_cm_get(neigh))
+				ipoib_cm_create_tx(dev, path, neigh);
 			if (!ipoib_cm_get(neigh))
-				ipoib_cm_set(neigh, ipoib_cm_create_tx(dev, path, neigh));
-			if (!ipoib_cm_get(neigh)) {
-				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
 				goto err_drop;
-			}
 			if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
 				__skb_queue_tail(&neigh->queue, skb);
 			else {
@@ -606,12 +577,10 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -622,10 +591,7 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
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
@@ -633,20 +599,22 @@ err_drop:
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
@@ -659,35 +627,13 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
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
 
@@ -699,12 +645,16 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
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
@@ -714,31 +664,23 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
 
@@ -748,7 +690,8 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				return NETDEV_TX_OK;
 			}
 		} else if (neigh->ah) {
-			ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(skb_dst(skb)->neighbour->ha));
+			ipoib_send(dev, skb, neigh->ah,
+				   IPOIB_QPN(skb_dst(skb)->neighbour->ha));
 			return NETDEV_TX_OK;
 		}
 
@@ -770,7 +713,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			phdr->hwaddr[8] = (priv->pkey >> 8) & 0xff;
 			phdr->hwaddr[9] = priv->pkey & 0xff;
 
-			ipoib_mcast_send(dev, phdr->hwaddr + 4, skb);
+			ipoib_mcast_send(dev, phdr->hwaddr + 4, skb, NULL);
 		} else {
 			/* unicast GID -- should be ARP or RARP reply */
 
@@ -847,34 +790,45 @@ static void ipoib_neigh_cleanup(struct neighbour *n)
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
 
@@ -882,27 +836,58 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
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
 	if (ipoib_cm_get(neigh))
 		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
-	kfree(neigh);
+	ah = neigh->ah;
+	neigh->ah = NULL;
+	memset(&neigh->dgid.raw, 0, sizeof(union ib_gid));
+	list_del_init(&neigh->list);
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
index 8763c1e..0ae4ad2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -67,35 +67,21 @@ struct ipoib_mcast_iter {
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
 
 	while (!skb_queue_empty(&mcast->pkt_queue)) {
 		++tx_dropped;
-		dev_kfree_skb_any(skb_dequeue(&mcast->pkt_queue));
+		dev_kfree_skb_irq(skb_dequeue(&mcast->pkt_queue));
 	}
 
 	netif_tx_lock_bh(dev);
@@ -149,7 +135,7 @@ static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid
 	return NULL;
 }
 
-static int __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
+static void __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node **n = &priv->multicast_tree.rb_node, *pn = NULL;
@@ -167,14 +153,12 @@ static int __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
 			n = &pn->rb_left;
 		else if (ret > 0)
 			n = &pn->rb_right;
-		else
-			return -EEXIST;
+		else /* Should never happen since we always search first */
+			return;
 	}
 
 	rb_link_node(&mcast->rb_node, pn, n);
 	rb_insert_color(&mcast->rb_node, &priv->multicast_tree);
-
-	return 0;
 }
 
 static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
@@ -654,7 +638,8 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	return 0;
 }
 
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
+void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb,
+		      struct ipoib_neigh *neigh)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_mcast *mcast;
@@ -664,11 +649,8 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 
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
@@ -680,9 +662,7 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 		if (!mcast) {
 			ipoib_warn(priv, "unable to allocate memory for "
 				   "multicast structure\n");
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
-			goto out;
+			goto drop;
 		}
 
 		set_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags);
@@ -692,48 +672,33 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
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
-
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ipoib_send(dev, skb, mcast->ah, IB_MULTICAST_QPN);
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
@@ -741,16 +706,14 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	LIST_HEAD(remove_list);
 	struct ipoib_mcast *mcast, *tmcast;
-	unsigned long flags;
 
 	ipoib_dbg_mcast(priv, "flushing multicast list\n");
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irq(&priv->lock);
 
 	list_for_each_entry_safe(mcast, tmcast, &priv->multicast_list, list) {
-		list_del(&mcast->list);
 		rb_erase(&mcast->rb_node, &priv->multicast_tree);
-		list_add_tail(&mcast->list, &remove_list);
+		list_move_tail(&mcast->list, &remove_list);
 	}
 
 	if (priv->broadcast) {
@@ -759,7 +722,7 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
 		priv->broadcast = NULL;
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irq(&priv->lock);
 
 	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
 		ipoib_mcast_leave(dev, mcast);
-- 
1.6.0.6



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
