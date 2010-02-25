From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/ipoib: fix dangling pointer references to ipoib_neigh
	and ipoib_path
Date: Thu, 25 Feb 2010 11:29:02 -0800
Message-ID: <1267126142.30294.25.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 4a2f3a9685fd82b57e75a31d04d6967d7d9b33c2 Mon Sep 17 00:00:00 2001
From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Date: Thu, 25 Feb 2010 11:22:02 -0800
Subject: [PATCH] IB/ipoib: fix dangling pointer references to ipoib_neigh and ipoib_path

When using connected mode, ipoib_cm_create_tx() kmallocs a
struct ipoib_cm_tx which contains pointers to ipoib_neigh and
ipoib_path. If the paths are flushed or the struct neighbour is
destroyed, the pointers held by struct ipoib_cm_tx can reference
freed memory. The fix is to add reference counts to struct
ipoib_neigh and ipoib_path and to add locking when getting
new references.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |   42 +++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   91 +++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  322 +++++++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   94 +++-----
 4 files changed, 280 insertions(+), 269 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 753a983..49c9097 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -379,6 +379,7 @@ struct ipoib_path {
 	struct rb_node	      rb_node;
 	struct list_head      list;
 	int  		      valid;
+	struct kref	      ref;
 };
 
 struct ipoib_neigh {
@@ -393,6 +394,7 @@ struct ipoib_neigh {
 	struct net_device *dev;
 
 	struct list_head    list;
+	struct kref         ref;
 };
 
 #define IPOIB_UD_MTU(ib_mtu)		(ib_mtu - IPOIB_ENCAP_LEN)
@@ -415,12 +417,33 @@ static inline struct ipoib_neigh **to_ipoib_neigh(struct neighbour *neigh)
 				     INFINIBAND_ALEN, sizeof(void *));
 }
 
-struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neigh,
-				      struct net_device *dev);
-void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh);
+void ipoib_neigh_flush(struct ipoib_neigh *neigh);
+void ipoib_neigh_free(struct kref *kref);
+void ipoib_path_free(struct kref *kref);
 
 extern struct workqueue_struct *ipoib_workqueue;
 
+static inline void ipoib_path_get(struct ipoib_path *path)
+{
+	kref_get(&path->ref);
+}
+
+/* This should not be called while holding priv->lock */
+static inline void ipoib_path_put(struct ipoib_path *path)
+{
+	kref_put(&path->ref, ipoib_path_free);
+}
+
+static inline void ipoib_neigh_get(struct ipoib_neigh *neigh)
+{
+	kref_get(&neigh->ref);
+}
+
+static inline void ipoib_neigh_put(struct ipoib_neigh *neigh)
+{
+	kref_put(&neigh->ref, ipoib_neigh_free);
+}
+
 /* functions */
 
 int ipoib_poll(struct napi_struct *napi, int budget);
@@ -464,7 +487,8 @@ void ipoib_dev_cleanup(struct net_device *dev);
 
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb);
+void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb,
+		      struct ipoib_neigh *neigh);
 
 void ipoib_mcast_restart_task(struct work_struct *work);
 int ipoib_mcast_start_thread(struct net_device *dev);
@@ -567,8 +591,8 @@ void ipoib_cm_dev_stop(struct net_device *dev);
 int ipoib_cm_dev_init(struct net_device *dev);
 int ipoib_cm_add_mode_attr(struct net_device *dev);
 void ipoib_cm_dev_cleanup(struct net_device *dev);
-struct ipoib_cm_tx *ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
-				    struct ipoib_neigh *neigh);
+void ipoib_cm_create_tx(struct net_device *dev, struct ipoib_path *path,
+			struct ipoib_neigh *neigh);
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx);
 void ipoib_cm_skb_too_long(struct net_device *dev, struct sk_buff *skb,
 			   unsigned int mtu);
@@ -646,10 +670,10 @@ void ipoib_cm_dev_cleanup(struct net_device *dev)
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
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 30bdf42..0a7343e 100644
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
@@ -1188,6 +1171,10 @@ timeout:
 
 	if (p->qp)
 		ib_destroy_qp(p->qp);
+	if (p->neigh)
+		ipoib_neigh_put(p->neigh);
+	if (p->path)
+		ipoib_path_put(p->path);
 
 	vfree(p->tx_ring);
 	kfree(p);
@@ -1199,7 +1186,6 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 	struct ipoib_cm_tx *tx = cm_id->context;
 	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
 	struct net_device *dev = priv->dev;
-	struct ipoib_neigh *neigh;
 	unsigned long flags;
 	int ret;
 
@@ -1221,22 +1207,8 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
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
 
-			tx->neigh = NULL;
-		}
-
-		if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
-			list_move(&tx->list, &priv->cm.reap_list);
-			queue_work(ipoib_workqueue, &priv->cm.reap_task);
-		}
+		ipoib_cm_destroy_tx(tx);
 
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
@@ -1248,35 +1220,43 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
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
+	ipoib_neigh_get(neigh);
 	tx->path = path;
+	ipoib_path_get(path);
 	tx->dev = dev;
 	list_add(&tx->list, &priv->cm.start_list);
 	set_bit(IPOIB_FLAG_INITIALIZED, &tx->flags);
 	queue_work(ipoib_workqueue, &priv->cm.start_task);
-	return tx;
 }
 
+/*
+ * Note: this is called with the priv->lock held.
+ */
 void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &tx->flags)) {
+		struct ipoib_dev_priv *priv = netdev_priv(tx->dev);
+		struct ipoib_neigh *neigh = tx->neigh;
+
+		neigh->cm = NULL;
+		tx->neigh = NULL;
 		list_move(&tx->list, &priv->cm.reap_list);
 		queue_work(ipoib_workqueue, &priv->cm.reap_task);
 		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
-			  tx->neigh->dgid.raw);
-		tx->neigh = NULL;
+			  neigh->dgid.raw);
+		ipoib_neigh_put(neigh);
 	}
 }
 
@@ -1286,6 +1266,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 						   cm.start_task);
 	struct net_device *dev = priv->dev;
 	struct ipoib_neigh *neigh;
+	struct ipoib_path *path;
 	struct ipoib_cm_tx *p;
 	unsigned long flags;
 	int ret;
@@ -1300,13 +1281,27 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		p = list_entry(priv->cm.start_list.next, typeof(*p), list);
 		list_del_init(&p->list);
 		neigh = p->neigh;
-		qpn = IPOIB_QPN(neigh->neighbour->ha);
-		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
+		path = p->path;
+		p->path = NULL;
+		memcpy(&pathrec, &path->pathrec, sizeof pathrec);
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
+		ipoib_path_put(path);
+
+		if (qpn)
+			ret = ipoib_cm_tx_init(p, qpn, &pathrec);
+		else
+			ret = -1;
 
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
@@ -1315,12 +1310,8 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 			neigh = p->neigh;
 			if (neigh) {
 				neigh->cm = NULL;
-				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
+				ipoib_neigh_put(neigh);
 			}
-			list_del(&p->list);
 			kfree(p);
 		}
 	}
@@ -1342,7 +1333,7 @@ static void ipoib_cm_tx_reap(struct work_struct *work)
 
 	while (!list_empty(&priv->cm.reap_list)) {
 		p = list_entry(priv->cm.reap_list.next, typeof(*p), list);
-		list_del(&p->list);
+		list_del_init(&p->list);
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 		ipoib_cm_tx_destroy(p);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index df3eb8c..c87cf29 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -91,6 +91,9 @@ struct workqueue_struct *ipoib_workqueue;
 
 struct ib_sa_client ipoib_sa_client;
 
+static struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
+					     struct net_device *dev);
+
 static void ipoib_add_one(struct ib_device *device);
 static void ipoib_remove_one(struct ib_device *device);
 
@@ -224,14 +227,16 @@ static struct ipoib_path *__path_find(struct net_device *dev, void *gid)
 			n = n->rb_left;
 		else if (ret > 0)
 			n = n->rb_right;
-		else
+		else {
+			ipoib_path_get(path);
 			return path;
+		}
 	}
 
 	return NULL;
 }
 
-static int __path_add(struct net_device *dev, struct ipoib_path *path)
+static void __path_add(struct net_device *dev, struct ipoib_path *path)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node **n = &priv->path_tree.rb_node;
@@ -249,44 +254,29 @@ static int __path_add(struct net_device *dev, struct ipoib_path *path)
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
 
+	/* The list holds a reference. */
+	ipoib_path_get(path);
 	list_add_tail(&path->list, &priv->path_list);
-
-	return 0;
 }
 
-static void path_free(struct net_device *dev, struct ipoib_path *path)
+void ipoib_path_free(struct kref *kref)
 {
-	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_path *path = container_of(kref, struct ipoib_path, ref);
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
@@ -390,7 +380,7 @@ void ipoib_flush_paths(struct net_device *dev)
 		spin_unlock_irqrestore(&priv->lock, flags);
 		netif_tx_unlock_bh(dev);
 		wait_for_completion(&path->done);
-		path_free(dev, path);
+		ipoib_path_put(path);
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);
 	}
@@ -440,9 +430,6 @@ static void path_rec_completion(int status,
 		ipoib_dbg(priv, "created address handle %p for LID 0x%04x, SL %d\n",
 			  ah, be16_to_cpu(pathrec->dlid), pathrec->sl);
 
-		while ((skb = __skb_dequeue(&path->queue)))
-			__skb_queue_tail(&skqueue, skb);
-
 		list_for_each_entry_safe(neigh, tn, &path->neigh_list, list) {
 			if (neigh->ah) {
 				WARN_ON(neigh->ah != old_ah);
@@ -460,24 +447,17 @@ static void path_rec_completion(int status,
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
-
-			while ((skb = __skb_dequeue(&neigh->queue)))
-				__skb_queue_tail(&skqueue, skb);
+			/*
+			 * If connected mode is enabled but not started,
+			 * start getting a connection.
+			 */
+			if (ipoib_cm_enabled(dev, neigh->neighbour) &&
+			    !ipoib_cm_get(neigh))
+				ipoib_cm_create_tx(dev, path, neigh);
 		}
 		path->valid = 1;
+		while ((skb = __skb_dequeue(&path->queue)))
+			__skb_queue_tail(&skqueue, skb);
 	}
 
 	path->query = NULL;
@@ -513,6 +493,7 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	skb_queue_head_init(&path->queue);
 
 	INIT_LIST_HEAD(&path->neigh_list);
+	kref_init(&path->ref);
 
 	memcpy(path->pathrec.dgid.raw, gid, sizeof (union ib_gid));
 	path->pathrec.sgid	    = priv->local_gid;
@@ -520,6 +501,8 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	path->pathrec.numb_path     = 1;
 	path->pathrec.traffic_class = priv->broadcast->mcmember.traffic_class;
 
+	__path_add(dev, path);
+
 	return path;
 }
 
@@ -554,31 +537,26 @@ static int path_rec_start(struct net_device *dev,
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
+			goto err_unlock;
 	}
 
+	ipoib_neigh_get(neigh);
 	list_add_tail(&neigh->list, &path->neigh_list);
 
 	if (path->ah) {
@@ -587,31 +565,24 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 		memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
 		       sizeof(union ib_gid));
 
-		if (ipoib_cm_enabled(dev, neigh->neighbour)) {
+		if (ipoib_cm_enabled(dev, n)) {
 			if (!ipoib_cm_get(neigh))
-				ipoib_cm_set(neigh, ipoib_cm_create_tx(dev, path, neigh));
-			if (!ipoib_cm_get(neigh)) {
-				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
-				goto err_drop;
-			}
+				ipoib_cm_create_tx(dev, path, neigh);
+			if (!ipoib_cm_get(neigh))
+				goto err_unlock;
 			if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
 				__skb_queue_tail(&neigh->queue, skb);
 			else {
 				ipoib_warn(priv, "queue length limit %d. Packet drop.\n",
 					   skb_queue_len(&neigh->queue));
-				goto err_drop;
+				goto err_unlock;
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
 
@@ -622,31 +593,32 @@ static void neigh_add_path(struct sk_buff *skb, struct net_device *dev)
 	return;
 
 err_list:
-	list_del(&neigh->list);
-
-err_path:
-	ipoib_neigh_free(dev, neigh);
-err_drop:
+	list_del_init(&neigh->list);
+	ipoib_neigh_put(neigh);
+err_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	if (path)
+		ipoib_path_put(path);
 	++dev->stats.tx_dropped;
 	dev_kfree_skb_any(skb);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
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
@@ -659,35 +631,13 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
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
 
@@ -699,12 +649,37 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
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
+	ipoib_path_put(path);
+	return;
+
+drop:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	if (path)
+		ipoib_path_put(path);
+	++dev->stats.tx_dropped;
+	dev_kfree_skb_any(skb);
+}
+
+/*
+ * Return a reference to the private ipoib_neigh data.
+ */
+static struct ipoib_neigh *neighbour_priv(struct ipoib_dev_priv *priv,
+					  struct neighbour *n)
+{
+	struct ipoib_neigh *neigh;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	neigh = *to_ipoib_neigh(n);
+	if (neigh)
+		ipoib_neigh_get(neigh);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return neigh;
 }
 
 static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -714,41 +689,40 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 
 	if (likely(skb_dst(skb) && skb_dst(skb)->neighbour)) {
-		if (unlikely(!*to_ipoib_neigh(skb_dst(skb)->neighbour))) {
-			ipoib_path_lookup(skb, dev);
+		neigh = neighbour_priv(priv, skb_dst(skb)->neighbour);
+
+		if (unlikely(!neigh)) {
+			neigh = ipoib_neigh_alloc(skb_dst(skb)->neighbour,
+						  skb->dev);
+			if (!neigh) {
+				++dev->stats.tx_dropped;
+				dev_kfree_skb_any(skb);
+			} else {
+				path_lookup(skb, dev, neigh);
+				ipoib_neigh_put(neigh);
+			}
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
+			ipoib_neigh_put(neigh);
 			return NETDEV_TX_OK;
 		}
 
 		if (ipoib_cm_get(neigh)) {
 			if (ipoib_cm_up(neigh)) {
 				ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
+				ipoib_neigh_put(neigh);
 				return NETDEV_TX_OK;
 			}
 		} else if (neigh->ah) {
-			ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(skb_dst(skb)->neighbour->ha));
+			ipoib_send(dev, skb, neigh->ah,
+				   IPOIB_QPN(skb_dst(skb)->neighbour->ha));
+			ipoib_neigh_put(neigh);
 			return NETDEV_TX_OK;
 		}
 
@@ -760,6 +734,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			++dev->stats.tx_dropped;
 			dev_kfree_skb_any(skb);
 		}
+		ipoib_neigh_put(neigh);
 	} else {
 		struct ipoib_pseudoheader *phdr =
 			(struct ipoib_pseudoheader *) skb->data;
@@ -770,7 +745,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			phdr->hwaddr[8] = (priv->pkey >> 8) & 0xff;
 			phdr->hwaddr[9] = priv->pkey & 0xff;
 
-			ipoib_mcast_send(dev, phdr->hwaddr + 4, skb);
+			ipoib_mcast_send(dev, phdr->hwaddr + 4, skb, NULL);
 		} else {
 			/* unicast GID -- should be ARP or RARP reply */
 
@@ -848,61 +823,112 @@ static void ipoib_neigh_cleanup(struct neighbour *n)
 	struct ipoib_neigh *neigh;
 	struct ipoib_dev_priv *priv = netdev_priv(n->dev);
 	unsigned long flags;
-	struct ipoib_ah *ah = NULL;
+
+	spin_lock_irqsave(&priv->lock, flags);
 
 	neigh = *to_ipoib_neigh(n);
-	if (neigh)
-		priv = netdev_priv(neigh->dev);
-	else
+	if (neigh) {
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
+	if (!list_empty(&neigh->list)) {
+		list_del_init(&neigh->list);
+		/* we still hold a reference to neigh */
+		ipoib_neigh_put(neigh);
+	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ah)
-		ipoib_put_ah(ah);
+	ipoib_neigh_put(neigh);
 }
 
 struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
 				      struct net_device *dev)
 {
+	struct ipoib_dev_priv *priv;
 	struct ipoib_neigh *neigh;
+	unsigned long flags;
 
 	neigh = kmalloc(sizeof *neigh, GFP_ATOMIC);
 	if (!neigh)
 		return NULL;
 
+	neigh->ah = NULL;
 	neigh->neighbour = neighbour;
 	neigh->dev = dev;
 	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
-	*to_ipoib_neigh(neighbour) = neigh;
 	skb_queue_head_init(&neigh->queue);
+	INIT_LIST_HEAD(&neigh->list);
+	kref_init(&neigh->ref);
 	ipoib_cm_set(neigh, NULL);
 
+	priv = netdev_priv(dev);
+	spin_lock_irqsave(&priv->lock, flags);
+	ipoib_neigh_get(neigh);
+	*to_ipoib_neigh(neighbour) = neigh;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 	return neigh;
 }
 
-void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh)
+void ipoib_neigh_free(struct kref *kref)
 {
 	struct sk_buff *skb;
-	*to_ipoib_neigh(neigh->neighbour) = NULL;
+	struct ipoib_neigh *neigh = container_of(kref, struct ipoib_neigh, ref);
+	struct net_device *dev = neigh->dev;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	if (neigh->neighbour)
+		ipoib_warn(priv, "non-NULL neighbour %p\n", neigh->neighbour);
+	if (!list_empty(&neigh->list))
+		ipoib_warn(priv, "ipoib_neigh on path or multi list\n");
+	if (ipoib_cm_get(neigh))
+		ipoib_warn(priv, "non-NULL CM %p\n", ipoib_cm_get(neigh));
+
 	while ((skb = __skb_dequeue(&neigh->queue))) {
 		++dev->stats.tx_dropped;
 		dev_kfree_skb_any(skb);
 	}
+	if (neigh->ah)
+		ipoib_put_ah(neigh->ah);
+
+	kfree(neigh);
+}
+
+/*
+ * This is called when flushing the path or multicast GID from the
+ * struct ipoib_neigh. ipoib_start_xmit() will then try to reinitialize
+ * the address the next time it is called.
+ * Note that the "neigh" pointer passed should not be used after calling this.
+ */
+void ipoib_neigh_flush(struct ipoib_neigh *neigh)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(neigh->dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
 	if (ipoib_cm_get(neigh))
 		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
-	kfree(neigh);
+	if (neigh->ah) {
+		ipoib_put_ah(neigh->ah);
+		neigh->ah = NULL;
+	}
+	memset(&neigh->dgid.raw, 0, sizeof(union ib_gid));
+	list_del_init(&neigh->list);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	ipoib_neigh_put(neigh);
 }
 
 static int ipoib_neigh_setup_dev(struct net_device *dev, struct neigh_parms *parms)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 8763c1e..13d2477 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -70,26 +70,18 @@ static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_neigh *neigh, *tmp;
 	int tx_dropped = 0;
+	LIST_HEAD(remove_list);
 
 	ipoib_dbg_mcast(netdev_priv(dev), "deleting multicast group %pI6\n",
 			mcast->mcmember.mgid.raw);
 
 	spin_lock_irq(&priv->lock);
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
+	list_splice(&mcast->neigh_list, &remove_list);
 	spin_unlock_irq(&priv->lock);
 
+	list_for_each_entry_safe(neigh, tmp, &remove_list, list)
+		ipoib_neigh_flush(neigh);
+
 	if (mcast->ah)
 		ipoib_put_ah(mcast->ah);
 
@@ -149,7 +141,7 @@ static struct ipoib_mcast *__ipoib_mcast_find(struct net_device *dev, void *mgid
 	return NULL;
 }
 
-static int __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
+static void __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct rb_node **n = &priv->multicast_tree.rb_node, *pn = NULL;
@@ -167,14 +159,12 @@ static int __ipoib_mcast_add(struct net_device *dev, struct ipoib_mcast *mcast)
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
@@ -654,7 +644,8 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	return 0;
 }
 
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
+void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb,
+		      struct ipoib_neigh *neigh)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_mcast *mcast;
@@ -664,11 +655,8 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 
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
@@ -680,9 +668,7 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 		if (!mcast) {
 			ipoib_warn(priv, "unable to allocate memory for "
 				   "multicast structure\n");
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
-			goto out;
+			goto drop;
 		}
 
 		set_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags);
@@ -692,48 +678,34 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
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
+			ipoib_neigh_get(neigh);
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
@@ -741,16 +713,14 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
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
@@ -759,7 +729,7 @@ void ipoib_mcast_dev_flush(struct net_device *dev)
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
