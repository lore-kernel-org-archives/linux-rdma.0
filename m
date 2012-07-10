From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Tue, 10 Jul 2012 13:01:35 +0300
Message-ID: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Dave Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> provided a detailed description of why the
way IPoIB is using neighbours for its own ipoib_neigh struct is buggy:

Any time an ipoib_neigh is changed, a sequence like the following is made:

			spin_lock_irqsave(&priv->lock, flags);
			/*
			 * It's safe to call ipoib_put_ah() inside
			 * priv->lock here, because we know that
			 * path->ah will always hold one more reference,
			 * so ipoib_put_ah() will never do more than
			 * decrement the ref count.
			 */
			if (neigh->ah)
				ipoib_put_ah(neigh->ah);
			list_del(&neigh->list);
			ipoib_neigh_free(dev, neigh);
			spin_unlock_irqrestore(&priv->lock, flags);
			ipoib_path_lookup(skb, n, dev);

This doesn't work, because you're leaving a stale pointer to the freed up
ipoib_neigh in the special neigh->ha pointer cookie.  Yes, it even fails
with all the locking done to protect _changes_ to *ipoib_neigh(n), and
with the code in ipoib_neigh_free() that NULLs out the pointer.

The core issue is that read side calls to *to_ipoib_neigh(n) are not
being synchronized at all, they are performed without any locking.  So
whether we hold the lock or not when making changes to *ipoib_neigh(n)
you still can have threads see references to freed up ipoib_neigh
objects.

	cpu 1			cpu 2
	n = *ipoib_neigh()
				*ipoib_neigh() = NULL
				kfree(n)
	n->foo == OOPS

[..]

Perhaps the ipoib code can have a private path database it manages
entirely itself, which holds all the necessary information and is
looked up by some generic key which is available easily at transmit
time and does not involve generic neighbour entries.

See here http://marc.info/?l=linux-rdma&m=132812793105624&w=2 the note, full discussion
http://marc.info/?l=linux-rdma&w=2&r=1&s=allows+references+to+freed+memory&q=b

This patch aims to solve the race conditions found in the IPoIB driver.

The patch breaks the connection between the core networking neighbour structure
and the ipoib_neigh structure. Except for avoiding the race, it allows to in
under a setup where SKBs carrying IP packets that don't have any associated
neighbour are transmitted through IPoIB.

We add an ipoib_neigh hash table with 1024 buckets. The hash table key is the destination
hardware address. Thus the ipoib_neigh is fetched from the hash table and not
dereferenced from the stashed location at the neighbour structure. The hash table uses
both RCU and reference count mechanisms to guarantee that no ipoib_neigh instance is
ever deleted while in use.

Fetching the ipoib_neigh structure instance from the hash also makes the special
code in ipoib_start_xmit that handles remote and local bonding failover redundant.

Note that with bonding the neighbour structure belongs to the bond device and
not to the enslaved device.

Aged ipoib_neigh instances are deleted by a garbage collection task that runs every
30 seconds and deletes every ipoib_neigh instance that was idle for at least 60
seconds. The deletion is safe since the ipoib_neigh instances are protected
using RCU and reference count mechanisms.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

The patch is against net-next, we have some issues here with the latest which were
reported over netdev and being looked up by Dave, so for the time being, this is generated
against commit 700db99d0 "ipoib: Need to do dst_neigh_lookup_skb() outside of priv->lock"

 drivers/infiniband/ulp/ipoib/ipoib.h           |   53 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   16 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  479 ++++++++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   51 +--
 4 files changed, 378 insertions(+), 221 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 86df632..07f6414 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -92,6 +92,7 @@ enum {
 	IPOIB_STOP_REAPER	  = 7,
 	IPOIB_FLAG_ADMIN_CM	  = 9,
 	IPOIB_FLAG_UMCAST	  = 10,
+	IPOIB_STOP_NEIGH_GC	  = 11,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
@@ -260,6 +261,22 @@ struct ipoib_ethtool_st {
 	u16     max_coalesced_frames;
 };
 
+struct ipoib_hash_bucket {
+	struct list_head hnext;
+};
+
+enum {
+	IPOIB_NEIGH_LOG_INIT_SIZE	= 10,
+	IPOIB_NEIGH_GC_SEC		= 30
+};
+
+struct ipoib_hash_table {
+	struct ipoib_hash_bucket *buckets;
+	rwlock_t rwlock;
+	u32 mask;
+	u32 size;
+};
+
 /*
  * Device private locking: network stack tx_lock protects members used
  * in TX fast path, lock protects everything else.  lock nests inside
@@ -279,6 +296,8 @@ struct ipoib_dev_priv {
 	struct rb_root  path_tree;
 	struct list_head path_list;
 
+	struct ipoib_hash_table neigh_htbl;
+
 	struct ipoib_mcast *broadcast;
 	struct list_head multicast_list;
 	struct rb_root multicast_tree;
@@ -291,7 +310,7 @@ struct ipoib_dev_priv {
 	struct work_struct flush_heavy;
 	struct work_struct restart_task;
 	struct delayed_work ah_reap_task;
-
+	struct delayed_work neigh_reap_task;
 	struct ib_device *ca;
 	u8		  port;
 	u16		  pkey;
@@ -377,13 +396,16 @@ struct ipoib_neigh {
 #ifdef CONFIG_INFINIBAND_IPOIB_CM
 	struct ipoib_cm_tx *cm;
 #endif
-	union ib_gid	    dgid;
+	u8     daddr[INFINIBAND_ALEN];
 	struct sk_buff_head queue;
 
-	struct neighbour   *neighbour;
 	struct net_device *dev;
 
 	struct list_head    list;
+	struct list_head    hnext;
+	struct rcu_head     rcu;
+	struct kref         ref;
+	unsigned long       alive;
 };
 
 #define IPOIB_UD_MTU(ib_mtu)		(ib_mtu - IPOIB_ENCAP_LEN)
@@ -394,21 +416,15 @@ static inline int ipoib_ud_need_sg(unsigned int ib_mtu)
 	return IPOIB_UD_BUF_SIZE(ib_mtu) > PAGE_SIZE;
 }
 
-/*
- * We stash a pointer to our private neighbour information after our
- * hardware address in neigh->ha.  The ALIGN() expression here makes
- * sure that this pointer is stored aligned so that an unaligned
- * load is not needed to dereference it.
- */
-static inline struct ipoib_neigh **to_ipoib_neigh(struct neighbour *neigh)
+void ipoib_neigh_dtor(struct kref *kref);
+static inline void ipoib_neigh_put(struct ipoib_neigh *neigh)
 {
-	return (void*) neigh + ALIGN(offsetof(struct neighbour, ha) +
-				     INFINIBAND_ALEN, sizeof(void *));
+	kref_put(&neigh->ref, ipoib_neigh_dtor);
 }
-
-struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neigh,
+struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr);
+struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 				      struct net_device *dev);
-void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh);
+void ipoib_neigh_free(struct ipoib_neigh *neigh);
 
 extern struct workqueue_struct *ipoib_workqueue;
 
@@ -425,7 +441,6 @@ static inline void ipoib_put_ah(struct ipoib_ah *ah)
 {
 	kref_put(&ah->ref, ipoib_free_ah);
 }
-
 int ipoib_open(struct net_device *dev);
 int ipoib_add_pkey_attr(struct net_device *dev);
 int ipoib_add_umcast_attr(struct net_device *dev);
@@ -455,7 +470,7 @@ void ipoib_dev_cleanup(struct net_device *dev);
 
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb);
+void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb);
 
 void ipoib_mcast_restart_task(struct work_struct *work);
 int ipoib_mcast_start_thread(struct net_device *dev);
@@ -517,10 +532,10 @@ static inline int ipoib_cm_admin_enabled(struct net_device *dev)
 		test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
 }
 
-static inline int ipoib_cm_enabled(struct net_device *dev, struct neighbour *n)
+static inline int ipoib_cm_enabled(struct net_device *dev, u8 *hwaddr)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	return IPOIB_CM_SUPPORTED(n->ha) &&
+	return IPOIB_CM_SUPPORTED(hwaddr) &&
 		test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 014504d..cacc46e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -811,9 +811,7 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev, struct ib_wc *wc)
 		if (neigh) {
 			neigh->cm = NULL;
 			list_del(&neigh->list);
-			if (neigh->ah)
-				ipoib_put_ah(neigh->ah);
-			ipoib_neigh_free(dev, neigh);
+			ipoib_neigh_free(neigh);
 
 			tx->neigh = NULL;
 		}
@@ -1230,9 +1228,7 @@ static int ipoib_cm_tx_handler(struct ib_cm_id *cm_id,
 		if (neigh) {
 			neigh->cm = NULL;
 			list_del(&neigh->list);
-			if (neigh->ah)
-				ipoib_put_ah(neigh->ah);
-			ipoib_neigh_free(dev, neigh);
+			ipoib_neigh_free(neigh);
 
 			tx->neigh = NULL;
 		}
@@ -1279,7 +1275,7 @@ void ipoib_cm_destroy_tx(struct ipoib_cm_tx *tx)
 		list_move(&tx->list, &priv->cm.reap_list);
 		queue_work(ipoib_workqueue, &priv->cm.reap_task);
 		ipoib_dbg(priv, "Reap connection for gid %pI6\n",
-			  tx->neigh->dgid.raw);
+			  tx->neigh->daddr + 4);
 		tx->neigh = NULL;
 	}
 }
@@ -1304,7 +1300,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 		p = list_entry(priv->cm.start_list.next, typeof(*p), list);
 		list_del_init(&p->list);
 		neigh = p->neigh;
-		qpn = IPOIB_QPN(neigh->neighbour->ha);
+		qpn = IPOIB_QPN(neigh->daddr);
 		memcpy(&pathrec, &p->path->pathrec, sizeof pathrec);
 
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -1320,9 +1316,7 @@ static void ipoib_cm_tx_start(struct work_struct *work)
 			if (neigh) {
 				neigh->cm = NULL;
 				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
+				ipoib_neigh_free(neigh);
 			}
 			list_del(&p->list);
 			kfree(p);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index bbee4b2..32a3a6f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -46,7 +46,7 @@
 #include <linux/ip.h>
 #include <linux/in.h>
 
-#include <net/dst.h>
+#include <linux/jhash.h>
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("IP-over-InfiniBand net driver");
@@ -274,18 +274,8 @@ static void path_free(struct net_device *dev, struct ipoib_path *path)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
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
+	list_for_each_entry_safe(neigh, tn, &path->neigh_list, list)
+		ipoib_neigh_free(neigh);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -458,19 +448,15 @@ static void path_rec_completion(int status,
 			}
 			kref_get(&path->ah->ref);
 			neigh->ah = path->ah;
-			memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
-			       sizeof(union ib_gid));
 
-			if (ipoib_cm_enabled(dev, neigh->neighbour)) {
+			if (ipoib_cm_enabled(dev, neigh->daddr)) {
 				if (!ipoib_cm_get(neigh))
 					ipoib_cm_set(neigh, ipoib_cm_create_tx(dev,
 									       path,
 									       neigh));
 				if (!ipoib_cm_get(neigh)) {
 					list_del(&neigh->list);
-					if (neigh->ah)
-						ipoib_put_ah(neigh->ah);
-					ipoib_neigh_free(dev, neigh);
+					ipoib_neigh_free(neigh);
 					continue;
 				}
 			}
@@ -555,15 +541,15 @@ static int path_rec_start(struct net_device *dev,
 	return 0;
 }
 
-/* called with rcu_read_lock */
-static void neigh_add_path(struct sk_buff *skb, struct neighbour *n, struct net_device *dev)
+static void neigh_add_path(struct sk_buff *skb, u8 *daddr,
+				struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_path *path;
 	struct ipoib_neigh *neigh;
 	unsigned long flags;
 
-	neigh = ipoib_neigh_alloc(n, skb->dev);
+	neigh = ipoib_neigh_alloc(daddr, dev);
 	if (!neigh) {
 		++dev->stats.tx_dropped;
 		dev_kfree_skb_any(skb);
@@ -572,9 +558,9 @@ static void neigh_add_path(struct sk_buff *skb, struct neighbour *n, struct net_
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	path = __path_find(dev, n->ha + 4);
+	path = __path_find(dev, daddr + 4);
 	if (!path) {
-		path = path_rec_create(dev, n->ha + 4);
+		path = path_rec_create(dev, daddr + 4);
 		if (!path)
 			goto err_path;
 
@@ -586,17 +572,13 @@ static void neigh_add_path(struct sk_buff *skb, struct neighbour *n, struct net_
 	if (path->ah) {
 		kref_get(&path->ah->ref);
 		neigh->ah = path->ah;
-		memcpy(&neigh->dgid.raw, &path->pathrec.dgid.raw,
-		       sizeof(union ib_gid));
 
-		if (ipoib_cm_enabled(dev, neigh->neighbour)) {
+		if (ipoib_cm_enabled(dev, neigh->daddr)) {
 			if (!ipoib_cm_get(neigh))
 				ipoib_cm_set(neigh, ipoib_cm_create_tx(dev, path, neigh));
 			if (!ipoib_cm_get(neigh)) {
 				list_del(&neigh->list);
-				if (neigh->ah)
-					ipoib_put_ah(neigh->ah);
-				ipoib_neigh_free(dev, neigh);
+				ipoib_neigh_free(neigh);
 				goto err_drop;
 			}
 			if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE)
@@ -608,7 +590,8 @@ static void neigh_add_path(struct sk_buff *skb, struct neighbour *n, struct net_
 			}
 		} else {
 			spin_unlock_irqrestore(&priv->lock, flags);
-			ipoib_send(dev, skb, path->ah, IPOIB_QPN(n->ha));
+			ipoib_send(dev, skb, path->ah, IPOIB_QPN(daddr));
+			ipoib_neigh_put(neigh);
 			return;
 		}
 	} else {
@@ -621,35 +604,20 @@ static void neigh_add_path(struct sk_buff *skb, struct neighbour *n, struct net_
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
+	ipoib_neigh_put(neigh);
 	return;
 
 err_list:
 	list_del(&neigh->list);
 
 err_path:
-	ipoib_neigh_free(dev, neigh);
+	ipoib_neigh_free(neigh);
 err_drop:
 	++dev->stats.tx_dropped;
 	dev_kfree_skb_any(skb);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-/* called with rcu_read_lock */
-static void ipoib_path_lookup(struct sk_buff *skb, struct neighbour *n, struct net_device *dev)
-{
-	struct ipoib_dev_priv *priv = netdev_priv(skb->dev);
-
-	/* Look up path record for unicasts */
-	if (n->ha[4] != 0xff) {
-		neigh_add_path(skb, n, dev);
-		return;
-	}
-
-	/* Add in the P_Key for multicasts */
-	n->ha[8] = (priv->pkey >> 8) & 0xff;
-	n->ha[9] = priv->pkey & 0xff;
-	ipoib_mcast_send(dev, n->ha + 4, skb);
+	ipoib_neigh_put(neigh);
 }
 
 static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
@@ -710,96 +678,80 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ipoib_neigh *neigh;
-	struct neighbour *n = NULL;
+	struct ipoib_cb *cb = (struct ipoib_cb *) skb->cb;
+	struct ipoib_header *header;
 	unsigned long flags;
 
-	rcu_read_lock();
-	if (likely(skb_dst(skb))) {
-		n = dst_neigh_lookup_skb(skb_dst(skb), skb);
-		if (!n) {
+	header = (struct ipoib_header *) skb->data;
+
+	if (unlikely(cb->hwaddr[4] == 0xff)) {
+		/* multicast, arrange "if" according to probability */
+		if ((header->proto != htons(ETH_P_IP)) &&
+		    (header->proto != htons(ETH_P_IPV6)) &&
+		    (header->proto != htons(ETH_P_ARP)) &&
+		    (header->proto != htons(ETH_P_RARP))) {
+			/* ethertype not supported by IPoIB */
 			++dev->stats.tx_dropped;
 			dev_kfree_skb_any(skb);
-			goto unlock;
+			return NETDEV_TX_OK;
 		}
+		/* Add in the P_Key for multicast*/
+		cb->hwaddr[8] = (priv->pkey >> 8) & 0xff;
+		cb->hwaddr[9] = priv->pkey & 0xff;
+
+		neigh = ipoib_neigh_get(dev, cb->hwaddr);
+		if (likely(neigh))
+			goto send_using_neigh;
+		ipoib_mcast_send(dev, cb->hwaddr, skb);
+		return NETDEV_TX_OK;
 	}
-	if (likely(n)) {
-		if (unlikely(!*to_ipoib_neigh(n))) {
-			ipoib_path_lookup(skb, n, dev);
-			goto unlock;
-		}
-
-		neigh = *to_ipoib_neigh(n);
 
-		if (unlikely((memcmp(&neigh->dgid.raw,
-				     n->ha + 4,
-				     sizeof(union ib_gid))) ||
-			     (neigh->dev != dev))) {
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
-			ipoib_path_lookup(skb, n, dev);
-			goto unlock;
+	/* unicast, arrange "switch" according to probability */
+	switch (header->proto) {
+	case htons(ETH_P_IP):
+	case htons(ETH_P_IPV6):
+		neigh = ipoib_neigh_get(dev, cb->hwaddr);
+		if (unlikely(!neigh)) {
+			neigh_add_path(skb, cb->hwaddr, dev);
+			return NETDEV_TX_OK;
 		}
+		break;
+	case htons(ETH_P_ARP):
+	case htons(ETH_P_RARP):
+		/* for unicast ARP and RARP should always perform path find */
+		unicast_arp_send(skb, dev, cb);
+		return NETDEV_TX_OK;
+	default:
+		/* ethertype not supported by IPoIB */
+		++dev->stats.tx_dropped;
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
 
-		if (ipoib_cm_get(neigh)) {
-			if (ipoib_cm_up(neigh)) {
-				ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
-				goto unlock;
-			}
-		} else if (neigh->ah) {
-			ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(n->ha));
-			goto unlock;
+send_using_neigh:
+	/* note we now hold a ref to neigh */
+	if (ipoib_cm_get(neigh)) {
+		if (ipoib_cm_up(neigh)) {
+			ipoib_cm_send(dev, skb, ipoib_cm_get(neigh));
+			goto unref;
 		}
+	} else if (neigh->ah) {
+		ipoib_send(dev, skb, neigh->ah, IPOIB_QPN(cb->hwaddr));
+		goto unref;
+	}
 
-		if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
-			spin_lock_irqsave(&priv->lock, flags);
-			__skb_queue_tail(&neigh->queue, skb);
-			spin_unlock_irqrestore(&priv->lock, flags);
-		} else {
-			++dev->stats.tx_dropped;
-			dev_kfree_skb_any(skb);
-		}
+	if (skb_queue_len(&neigh->queue) < IPOIB_MAX_PATH_REC_QUEUE) {
+		spin_lock_irqsave(&priv->lock, flags);
+		__skb_queue_tail(&neigh->queue, skb);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	} else {
-		struct ipoib_cb *cb = (struct ipoib_cb *) skb->cb;
-
-		if (cb->hwaddr[4] == 0xff) {
-			/* Add in the P_Key for multicast*/
-			cb->hwaddr[8] = (priv->pkey >> 8) & 0xff;
-			cb->hwaddr[9] = priv->pkey & 0xff;
+		++dev->stats.tx_dropped;
+		dev_kfree_skb_any(skb);
+	}
 
-			ipoib_mcast_send(dev, cb->hwaddr + 4, skb);
-		} else {
-			/* unicast GID -- should be ARP or RARP reply */
-
-			if ((be16_to_cpup((__be16 *) skb->data) != ETH_P_ARP) &&
-			    (be16_to_cpup((__be16 *) skb->data) != ETH_P_RARP)) {
-				ipoib_warn(priv, "Unicast, no %s: type %04x, QPN %06x %pI6\n",
-					   skb_dst(skb) ? "neigh" : "dst",
-					   be16_to_cpup((__be16 *) skb->data),
-					   IPOIB_QPN(cb->hwaddr),
-					   cb->hwaddr + 4);
-				dev_kfree_skb_any(skb);
-				++dev->stats.tx_dropped;
-				goto unlock;
-			}
+unref:
+	ipoib_neigh_put(neigh);
 
-			unicast_arp_send(skb, dev, cb);
-		}
-	}
-unlock:
-	if (n)
-		neigh_release(n);
-	rcu_read_unlock();
 	return NETDEV_TX_OK;
 }
 
@@ -821,6 +773,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
 			     const void *daddr, const void *saddr, unsigned len)
 {
 	struct ipoib_header *header;
+	struct ipoib_cb *cb = (struct ipoib_cb *) skb->cb;
 
 	header = (struct ipoib_header *) skb_push(skb, sizeof *header);
 
@@ -828,14 +781,11 @@ static int ipoib_hard_header(struct sk_buff *skb,
 	header->reserved = 0;
 
 	/*
-	 * If we don't have a dst_entry structure, stuff the
+	 * we don't rely on dst_entry structure,  always stuff the
 	 * destination address into skb->cb so we can figure out where
 	 * to send the packet later.
 	 */
-	if (!skb_dst(skb)) {
-		struct ipoib_cb *cb = (struct ipoib_cb *) skb->cb;
-		memcpy(cb->hwaddr, daddr, INFINIBAND_ALEN);
-	}
+	memcpy(cb->hwaddr, daddr, INFINIBAND_ALEN);
 
 	return 0;
 }
@@ -852,37 +802,113 @@ static void ipoib_set_mcast_list(struct net_device *dev)
 	queue_work(ipoib_workqueue, &priv->restart_task);
 }
 
-static void ipoib_neigh_cleanup(struct neighbour *n)
+static u32 ipoib_addr_hash(struct ipoib_hash_table *htbl, u8 *daddr)
+{
+	/*
+	 * Use only the address parts that contributes to spreading
+	 * The subnet prefix is not used as one can not connect to
+	 * same remote port (GUID) using the same remote QPN via two
+	 * different subnets.
+	 */
+	 /* qpn octets[1:4) & port GUID octets[12:20) */
+	return jhash(daddr+12, 8, 0xFFFFFF & *(u32 *) daddr) & htbl->mask;
+}
+
+static struct ipoib_neigh *ipoib_neigh_lookup(struct ipoib_hash_table *htbl,
+						u8 *daddr)
+{
+	struct ipoib_hash_bucket *bucket;
+	struct ipoib_neigh *neigh;
+	u32 hash_val;
+
+	if (!htbl->buckets)
+		return NULL;
+
+	hash_val = ipoib_addr_hash(htbl, daddr);
+	bucket = &htbl->buckets[hash_val];
+	rcu_read_lock();
+	list_for_each_entry_rcu(neigh, &bucket->hnext, hnext) {
+		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
+			/* found, take one ref on behalf of the caller */
+			kref_get(&neigh->ref);
+			neigh->alive = jiffies;
+			rcu_read_unlock();
+			return neigh;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
+struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
 {
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_hash_table *htbl = &priv->neigh_htbl;
 	struct ipoib_neigh *neigh;
-	struct ipoib_dev_priv *priv = netdev_priv(n->dev);
+
+	read_lock_bh(&htbl->rwlock);
+	neigh = ipoib_neigh_lookup(htbl, daddr);
+	read_unlock_bh(&htbl->rwlock);
+
+	return neigh;
+}
+
+static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_neigh *neigh, *tn;
+	struct ipoib_hash_table *htbl = &priv->neigh_htbl;
+	struct ipoib_hash_bucket *bucket;
+	unsigned long neigh_obsolete;
+	unsigned long dt;
 	unsigned long flags;
-	struct ipoib_ah *ah = NULL;
+	int i;
 
-	neigh = *to_ipoib_neigh(n);
-	if (neigh)
-		priv = netdev_priv(neigh->dev);
-	else
+	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
 		return;
-	ipoib_dbg(priv,
-		  "neigh_cleanup for %06x %pI6\n",
-		  IPOIB_QPN(n->ha),
-		  n->ha + 4);
 
-	spin_lock_irqsave(&priv->lock, flags);
+	if (!htbl->buckets)
+		return;
 
-	if (neigh->ah)
-		ah = neigh->ah;
-	list_del(&neigh->list);
-	ipoib_neigh_free(n->dev, neigh);
+	/* neigh is obsolete if it was idle for two GC periods */
+	dt = msecs_to_jiffies(2 * 1000 * IPOIB_NEIGH_GC_SEC);
+	neigh_obsolete = jiffies - dt;
+	bucket = htbl->buckets;
+	read_lock_bh(&htbl->rwlock);
+	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags)) {
+		/* handle possible race condition */
+		read_unlock_bh(&htbl->rwlock);
+		return;
+	}
+	for (i = 0; i < htbl->size; i++) {
+		list_for_each_entry_safe(neigh, tn, &bucket->hnext, hnext) {
+			/* was the neigh idle for two GC periods */
+			if (time_after(neigh_obsolete, neigh->alive)) {
+				spin_lock_irqsave(&priv->lock, flags);
+				list_del(&neigh->list);
+				spin_unlock_irqrestore(&priv->lock, flags);
+				ipoib_neigh_free(neigh);
+			}
+		}
+		bucket++;
+	}
+	read_unlock_bh(&htbl->rwlock);
+}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+static void ipoib_reap_neigh(struct work_struct *work)
+{
+	struct ipoib_dev_priv *priv =
+		container_of(work, struct ipoib_dev_priv, neigh_reap_task.work);
+	unsigned long dt = msecs_to_jiffies(1000 * IPOIB_NEIGH_GC_SEC);
+
+	__ipoib_reap_neigh(priv);
 
-	if (ah)
-		ipoib_put_ah(ah);
+	if (!test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
+		queue_delayed_work(ipoib_workqueue, &priv->neigh_reap_task,
+			round_jiffies_relative(dt));
 }
 
-struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
+
+static struct ipoib_neigh *ipoib_neigh_ctor(u8 *daddr,
 				      struct net_device *dev)
 {
 	struct ipoib_neigh *neigh;
@@ -891,47 +917,169 @@ struct ipoib_neigh *ipoib_neigh_alloc(struct neighbour *neighbour,
 	if (!neigh)
 		return NULL;
 
-	neigh->neighbour = neighbour;
 	neigh->dev = dev;
-	memset(&neigh->dgid.raw, 0, sizeof (union ib_gid));
-	*to_ipoib_neigh(neighbour) = neigh;
+	memcpy(&neigh->daddr, daddr, sizeof(neigh->daddr));
 	skb_queue_head_init(&neigh->queue);
+	INIT_LIST_HEAD(&neigh->list);
 	ipoib_cm_set(neigh, NULL);
+	/* one ref on behalf of the caller */
+	kref_init(&neigh->ref);
+
+	return neigh;
+}
+
+struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
+				      struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_hash_table *htbl = &priv->neigh_htbl;
+	struct ipoib_neigh *neigh;
+	struct ipoib_hash_bucket *bucket;
+	u32 hash_val;
+
+	if (!htbl->buckets)
+		return NULL;
+
+	write_lock_bh(&htbl->rwlock);
+	/*
+	 * need to add a new neigh, but maybe some other thered succeded ?
+	 * recalc hash, maybe hash resize took place so we do a search
+	 */
+	neigh = ipoib_neigh_lookup(htbl, daddr);
+	if (neigh) {
+		write_unlock_bh(&htbl->rwlock);
+		return neigh;
+	}
+
+	neigh = ipoib_neigh_ctor(daddr, dev);
+	if (!neigh) {
+		write_unlock_bh(&htbl->rwlock);
+		return NULL;
+	}
+
+	/* one ref on behalf of the hash table */
+	kref_get(&neigh->ref);
+	neigh->alive = jiffies;
+	/* put in hash */
+	hash_val = ipoib_addr_hash(htbl, daddr);
+	bucket = &htbl->buckets[hash_val];
+	list_add_rcu(&neigh->hnext, &bucket->hnext);
+
+	write_unlock_bh(&htbl->rwlock);
 
 	return neigh;
 }
 
-void ipoib_neigh_free(struct net_device *dev, struct ipoib_neigh *neigh)
+void ipoib_neigh_dtor(struct kref *kref)
 {
+	/* neigh reference count was dropprd to zero */
+	struct ipoib_neigh *neigh = container_of(kref, struct ipoib_neigh, ref);
+	struct net_device *dev = neigh->dev;
 	struct sk_buff *skb;
-	*to_ipoib_neigh(neigh->neighbour) = NULL;
+	if (neigh->ah)
+		ipoib_put_ah(neigh->ah);
 	while ((skb = __skb_dequeue(&neigh->queue))) {
 		++dev->stats.tx_dropped;
 		dev_kfree_skb_any(skb);
 	}
 	if (ipoib_cm_get(neigh))
 		ipoib_cm_destroy_tx(ipoib_cm_get(neigh));
+	ipoib_dbg(netdev_priv(dev),
+		  "neigh free for %06x %pI6\n",
+		  IPOIB_QPN(neigh->daddr),
+		  neigh->daddr + 4);
 	kfree(neigh);
 }
 
-static int ipoib_neigh_setup_dev(struct net_device *dev, struct neigh_parms *parms)
+static void ipoib_neigh_reclaim(struct rcu_head *rp)
 {
-	parms->neigh_cleanup = ipoib_neigh_cleanup;
+	/* Called as a result of removal from hash table */
+	struct ipoib_neigh *neigh = container_of(rp, struct ipoib_neigh, rcu);
+	/* note TX context may hold another ref */
+	ipoib_neigh_put(neigh);
+}
+
+void ipoib_neigh_free(struct ipoib_neigh *neigh)
+{
+	/* remove from hash table */
+	list_del_rcu(&neigh->hnext);
+	call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
+}
+
+static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
+{
+	struct ipoib_hash_table *htbl = &priv->neigh_htbl;
+	struct ipoib_hash_bucket *buckets;
+	unsigned long dt = msecs_to_jiffies(1000 * IPOIB_NEIGH_GC_SEC);
+	u32 size;
+	int i;
+
+	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
+	size = 1 << IPOIB_NEIGH_LOG_INIT_SIZE;
+	buckets = kzalloc(size * sizeof(*buckets), GFP_KERNEL);
+	if (!buckets)
+		return -ENOMEM;
+	rwlock_init(&htbl->rwlock);
+	for (i = 0; i < size; i++)
+		INIT_LIST_HEAD(&(buckets + i)->hnext);
+	htbl->size = size;
+	htbl->mask = (size - 1);
+	htbl->buckets = buckets;
+
+	/* Start GC */
+	clear_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
+	queue_delayed_work(ipoib_workqueue, &priv->neigh_reap_task,
+			round_jiffies_relative(dt));
 
 	return 0;
 }
 
+static void ipoib_neigh_hash_uninit(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+	struct ipoib_hash_table *htbl = &priv->neigh_htbl;
+	struct ipoib_hash_bucket *bucket;
+	struct ipoib_neigh *neigh, *tn;
+	unsigned long flags;
+	int stopped, i;
+
+	/* Stop GC if called at init fail need to cancel work */
+	stopped = test_and_set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
+	if (!stopped)
+		cancel_delayed_work(&priv->neigh_reap_task);
+
+	if (!htbl->buckets)
+		return;
+
+	bucket = htbl->buckets;
+	write_lock_bh(&htbl->rwlock);
+	for (i = 0; i < htbl->size; i++) {
+		list_for_each_entry_safe(neigh, tn, &bucket->hnext, hnext) {
+			spin_lock_irqsave(&priv->lock, flags);
+			list_del(&neigh->list);
+			spin_unlock_irqrestore(&priv->lock, flags);
+			ipoib_neigh_free(neigh);
+		}
+		bucket++;
+	}
+	kfree(htbl->buckets);
+	htbl->buckets = NULL;
+	write_unlock_bh(&htbl->rwlock);
+}
+
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
+	if (ipoib_neigh_hash_init(priv) < 0)
+		goto out;
 	/* Allocate RX/TX "rings" to hold queued skbs */
 	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
 				GFP_KERNEL);
 	if (!priv->rx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate RX ring (%d entries)\n",
 		       ca->name, ipoib_recvq_size);
-		goto out;
+		goto out_neigh_hash_clenup;
 	}
 
 	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
@@ -954,6 +1102,8 @@ out_tx_ring_cleanup:
 out_rx_ring_cleanup:
 	kfree(priv->rx_ring);
 
+out_neigh_hash_clenup:
+	ipoib_neigh_hash_uninit(dev);
 out:
 	return -ENOMEM;
 }
@@ -966,6 +1116,9 @@ void ipoib_dev_cleanup(struct net_device *dev)
 
 	/* Delete any child interfaces first */
 	list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
+		/* Stop GC on child */
+		set_bit(IPOIB_STOP_NEIGH_GC, &cpriv->flags);
+		cancel_delayed_work(&cpriv->neigh_reap_task);
 		unregister_netdev(cpriv->dev);
 		ipoib_dev_cleanup(cpriv->dev);
 		free_netdev(cpriv->dev);
@@ -978,6 +1131,8 @@ void ipoib_dev_cleanup(struct net_device *dev)
 
 	priv->rx_ring = NULL;
 	priv->tx_ring = NULL;
+
+	ipoib_neigh_hash_uninit(dev);
 }
 
 static const struct header_ops ipoib_header_ops = {
@@ -992,7 +1147,6 @@ static const struct net_device_ops ipoib_netdev_ops = {
 	.ndo_start_xmit	 	 = ipoib_start_xmit,
 	.ndo_tx_timeout		 = ipoib_timeout,
 	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
-	.ndo_neigh_setup	 = ipoib_neigh_setup_dev,
 };
 
 static void ipoib_setup(struct net_device *dev)
@@ -1041,6 +1195,7 @@ static void ipoib_setup(struct net_device *dev)
 	INIT_WORK(&priv->flush_heavy,   ipoib_ib_dev_flush_heavy);
 	INIT_WORK(&priv->restart_task, ipoib_mcast_restart_task);
 	INIT_DELAYED_WORK(&priv->ah_reap_task, ipoib_reap_ah);
+	INIT_DELAYED_WORK(&priv->neigh_reap_task, ipoib_reap_neigh);
 }
 
 struct ipoib_dev_priv *ipoib_intf_alloc(const char *name)
@@ -1281,6 +1436,9 @@ sysfs_failed:
 
 register_failed:
 	ib_unregister_event_handler(&priv->event_handler);
+	/* Stop GC if started before flush */
+	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
+	cancel_delayed_work(&priv->neigh_reap_task);
 	flush_workqueue(ipoib_workqueue);
 
 event_failed:
@@ -1347,6 +1505,9 @@ static void ipoib_remove_one(struct ib_device *device)
 		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
 		rtnl_unlock();
 
+		/* Stop GC */
+		set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
+		cancel_delayed_work(&priv->neigh_reap_task);
 		flush_workqueue(ipoib_workqueue);
 
 		unregister_netdev(priv->dev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 7cecb16..6ad94ee 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -78,17 +78,8 @@ static void ipoib_mcast_free(struct ipoib_mcast *mcast)
 
 	spin_lock_irq(&priv->lock);
 
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
+	list_for_each_entry_safe(neigh, tmp, &mcast->neigh_list, list)
+		ipoib_neigh_free(neigh);
 
 	spin_unlock_irq(&priv->lock);
 
@@ -655,17 +646,12 @@ static int ipoib_mcast_leave(struct net_device *dev, struct ipoib_mcast *mcast)
 	return 0;
 }
 
-void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
+void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buff *skb)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	struct dst_entry *dst = skb_dst(skb);
 	struct ipoib_mcast *mcast;
-	struct neighbour *n;
 	unsigned long flags;
-
-	n = NULL;
-	if (dst)
-		n = dst_neigh_lookup_skb(dst, skb);
+	void *mgid = daddr + 4;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -721,28 +707,29 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 
 out:
 	if (mcast && mcast->ah) {
-		if (n) {
-			if (!*to_ipoib_neigh(n)) {
-				struct ipoib_neigh *neigh;
-
-				neigh = ipoib_neigh_alloc(n, skb->dev);
-				if (neigh) {
-					kref_get(&mcast->ah->ref);
-					neigh->ah	= mcast->ah;
-					list_add_tail(&neigh->list,
-						      &mcast->neigh_list);
-				}
+		struct ipoib_neigh *neigh;
+
+		spin_unlock_irqrestore(&priv->lock, flags);
+		neigh = ipoib_neigh_get(dev, daddr);
+		spin_lock_irqsave(&priv->lock, flags);
+		if (!neigh) {
+			spin_unlock_irqrestore(&priv->lock, flags);
+			neigh = ipoib_neigh_alloc(daddr, dev);
+			spin_lock_irqsave(&priv->lock, flags);
+			if (neigh) {
+				kref_get(&mcast->ah->ref);
+				neigh->ah	= mcast->ah;
+				list_add_tail(&neigh->list, &mcast->neigh_list);
 			}
-			neigh_release(n);
 		}
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ipoib_send(dev, skb, mcast->ah, IB_MULTICAST_QPN);
+		if (neigh)
+			ipoib_neigh_put(neigh);
 		return;
 	}
 
 unlock:
-	if (n)
-		neigh_release(n);
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
