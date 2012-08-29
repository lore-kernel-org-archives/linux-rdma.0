From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes/for-3.6 2/3] IB/ipoib: Fix AB-BA deadlock when deleting neighbours
Date: Wed, 29 Aug 2012 18:14:34 +0300
Message-ID: <1346253275-12347-3-git-send-email-ogerlitz@mellanox.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346253275-12347-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Lockdep pointed on a circular locking dependency betwwen the ipoib device
priv spinlock (priv->lock) and the neighbour table rwlock (ntbl->rwlock).

In normal path e.g. neigbour Garbage Collection task, the neigh table
rwlock is taken first and then if the neighbour need to be deleted,
priv->lock is taken.

However under error flow such as in ipoib_cm_handle_tx_wc, priv->lock is
taken first and then ipoib_neigh_free routine is called which in turn
takes the neighbour table ntbl->rwlock.

The combination would lead to deadlock when a normal flow runs in
parallel to error flow in two different CPUs. The solution was to
drop the neigh table rwlock and use only priv->lock.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h           |    1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   78 +++++++++--------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 -
 3 files changed, 31 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 36b5940..d7927f3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -273,7 +273,6 @@ struct ipoib_neigh_hash {
 
 struct ipoib_neigh_table {
 	struct ipoib_neigh_hash __rcu  *htbl;
-	rwlock_t			rwlock;
 	atomic_t			entries;
 	struct completion		flushed;
 	struct completion		deleted;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 72c1fc2..ad7a456 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -546,15 +546,15 @@ static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
 	struct ipoib_neigh *neigh;
 	unsigned long flags;
 
+	spin_lock_irqsave(&priv->lock, flags);
 	neigh = ipoib_neigh_alloc(daddr, dev);
 	if (!neigh) {
+		spin_unlock_irqrestore(&priv->lock, flags);
 		++dev->stats.tx_dropped;
 		dev_kfree_skb_any(skb);
 		return;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
-
 	path = __path_find(dev, daddr + 4);
 	if (!path) {
 		path = path_rec_create(dev, daddr + 4);
@@ -863,10 +863,10 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
 		return;
 
-	write_lock_bh(&ntbl->rwlock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	htbl = rcu_dereference_protected(ntbl->htbl,
-					 lockdep_is_held(&ntbl->rwlock));
+					 lockdep_is_held(&priv->lock));
 
 	if (!htbl)
 		goto out_unlock;
@@ -883,16 +883,14 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-							  lockdep_is_held(&ntbl->rwlock))) != NULL) {
+				       lockdep_is_held(&priv->lock))) != NULL) {
 			/* was the neigh idle for two GC periods */
 			if (time_after(neigh_obsolete, neigh->alive)) {
 				rcu_assign_pointer(*np,
-						   rcu_dereference_protected(neigh->hnext,
-									     lockdep_is_held(&ntbl->rwlock)));
+					rcu_dereference_protected(neigh->hnext,
+								  lockdep_is_held(&priv->lock)));
 				/* remove from path/mc list */
-				spin_lock_irqsave(&priv->lock, flags);
 				list_del(&neigh->list);
-				spin_unlock_irqrestore(&priv->lock, flags);
 				call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
 			} else {
 				np = &neigh->hnext;
@@ -902,7 +900,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 	}
 
 out_unlock:
-	write_unlock_bh(&ntbl->rwlock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static void ipoib_reap_neigh(struct work_struct *work)
@@ -947,10 +945,8 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 	struct ipoib_neigh *neigh;
 	u32 hash_val;
 
-	write_lock_bh(&ntbl->rwlock);
-
 	htbl = rcu_dereference_protected(ntbl->htbl,
-					 lockdep_is_held(&ntbl->rwlock));
+					 lockdep_is_held(&priv->lock));
 	if (!htbl) {
 		neigh = NULL;
 		goto out_unlock;
@@ -961,10 +957,10 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 	 */
 	hash_val = ipoib_addr_hash(htbl, daddr);
 	for (neigh = rcu_dereference_protected(htbl->buckets[hash_val],
-					       lockdep_is_held(&ntbl->rwlock));
+					       lockdep_is_held(&priv->lock));
 	     neigh != NULL;
 	     neigh = rcu_dereference_protected(neigh->hnext,
-					       lockdep_is_held(&ntbl->rwlock))) {
+					       lockdep_is_held(&priv->lock))) {
 		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
 			/* found, take one ref on behalf of the caller */
 			if (!atomic_inc_not_zero(&neigh->refcnt)) {
@@ -987,12 +983,11 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 	/* put in hash */
 	rcu_assign_pointer(neigh->hnext,
 			   rcu_dereference_protected(htbl->buckets[hash_val],
-						     lockdep_is_held(&ntbl->rwlock)));
+						lockdep_is_held(&priv->lock)));
 	rcu_assign_pointer(htbl->buckets[hash_val], neigh);
 	atomic_inc(&ntbl->entries);
 
 out_unlock:
-	write_unlock_bh(&ntbl->rwlock);
 
 	return neigh;
 }
@@ -1040,35 +1035,29 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
 	struct ipoib_neigh *n;
 	u32 hash_val;
 
-	write_lock_bh(&ntbl->rwlock);
-
 	htbl = rcu_dereference_protected(ntbl->htbl,
-					lockdep_is_held(&ntbl->rwlock));
+					lockdep_is_held(&priv->lock));
 	if (!htbl)
-		goto out_unlock;
+		return;
 
 	hash_val = ipoib_addr_hash(htbl, neigh->daddr);
 	np = &htbl->buckets[hash_val];
 	for (n = rcu_dereference_protected(*np,
-					    lockdep_is_held(&ntbl->rwlock));
+					    lockdep_is_held(&priv->lock));
 	     n != NULL;
 	     n = rcu_dereference_protected(*np,
-					lockdep_is_held(&ntbl->rwlock))) {
+					lockdep_is_held(&priv->lock))) {
 		if (n == neigh) {
 			/* found */
 			rcu_assign_pointer(*np,
-					   rcu_dereference_protected(neigh->hnext,
-								     lockdep_is_held(&ntbl->rwlock)));
+					rcu_dereference_protected(neigh->hnext,
+								  lockdep_is_held(&priv->lock)));
 			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
-			goto out_unlock;
+			return;
 		} else {
 			np = &n->hnext;
 		}
 	}
-
-out_unlock:
-	write_unlock_bh(&ntbl->rwlock);
-
 }
 
 static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
@@ -1080,7 +1069,6 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 
 	clear_bit(IPOIB_NEIGH_TBL_FLUSH, &priv->flags);
 	ntbl->htbl = NULL;
-	rwlock_init(&ntbl->rwlock);
 	htbl = kzalloc(sizeof(*htbl), GFP_KERNEL);
 	if (!htbl)
 		return -ENOMEM;
@@ -1128,10 +1116,10 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 	int i;
 
 	/* remove all neigh connected to a given path or mcast */
-	write_lock_bh(&ntbl->rwlock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	htbl = rcu_dereference_protected(ntbl->htbl,
-					 lockdep_is_held(&ntbl->rwlock));
+					 lockdep_is_held(&priv->lock));
 
 	if (!htbl)
 		goto out_unlock;
@@ -1141,16 +1129,14 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-							  lockdep_is_held(&ntbl->rwlock))) != NULL) {
+				       lockdep_is_held(&priv->lock))) != NULL) {
 			/* delete neighs belong to this parent */
 			if (!memcmp(gid, neigh->daddr + 4, sizeof (union ib_gid))) {
 				rcu_assign_pointer(*np,
-						   rcu_dereference_protected(neigh->hnext,
-									     lockdep_is_held(&ntbl->rwlock)));
+					rcu_dereference_protected(neigh->hnext,
+								  lockdep_is_held(&priv->lock)));
 				/* remove from parent list */
-				spin_lock_irqsave(&priv->lock, flags);
 				list_del(&neigh->list);
-				spin_unlock_irqrestore(&priv->lock, flags);
 				call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
 			} else {
 				np = &neigh->hnext;
@@ -1159,7 +1145,7 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
 		}
 	}
 out_unlock:
-	write_unlock_bh(&ntbl->rwlock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
@@ -1171,10 +1157,10 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 
 	init_completion(&priv->ntbl.flushed);
 
-	write_lock_bh(&ntbl->rwlock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	htbl = rcu_dereference_protected(ntbl->htbl,
-					lockdep_is_held(&ntbl->rwlock));
+					lockdep_is_held(&priv->lock));
 	if (!htbl)
 		goto out_unlock;
 
@@ -1187,14 +1173,12 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
 
 		while ((neigh = rcu_dereference_protected(*np,
-							  lockdep_is_held(&ntbl->rwlock))) != NULL) {
+				       lockdep_is_held(&priv->lock))) != NULL) {
 			rcu_assign_pointer(*np,
-					   rcu_dereference_protected(neigh->hnext,
-								     lockdep_is_held(&ntbl->rwlock)));
+					rcu_dereference_protected(neigh->hnext,
+								  lockdep_is_held(&priv->lock)));
 			/* remove from path/mc list */
-			spin_lock_irqsave(&priv->lock, flags);
 			list_del(&neigh->list);
-			spin_unlock_irqrestore(&priv->lock, flags);
 			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
 		}
 	}
@@ -1204,7 +1188,7 @@ free_htbl:
 	call_rcu(&htbl->rcu, neigh_hash_free_rcu);
 
 out_unlock:
-	write_unlock_bh(&ntbl->rwlock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 	if (wait_flushed)
 		wait_for_completion(&priv->ntbl.flushed);
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 13f4aa7..7536724 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -707,9 +707,7 @@ out:
 		neigh = ipoib_neigh_get(dev, daddr);
 		spin_lock_irqsave(&priv->lock, flags);
 		if (!neigh) {
-			spin_unlock_irqrestore(&priv->lock, flags);
 			neigh = ipoib_neigh_alloc(daddr, dev);
-			spin_lock_irqsave(&priv->lock, flags);
 			if (neigh) {
 				kref_get(&mcast->ah->ref);
 				neigh->ah	= mcast->ah;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
