From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes/for-3.6 1/3] IB/ipoib: Fix memory leak in the neigh table deletion flow
Date: Wed, 29 Aug 2012 18:14:33 +0300
Message-ID: <1346253275-12347-2-git-send-email-ogerlitz@mellanox.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346253275-12347-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If the neighbours hash table is empty when unloading the module,
then ipoib_flush_neighs, the cleanup routine wasn't called, and
the memory used for the hash table itself leaked.

To fix this, ipoib_flush_neighs is allways called, and another
completion object was added to signal when the table is freed.

Once inovked, ipoib_flush_neighs flushes all the neighbours
(if there are any), calls the the hash table RCU free routine,
(which now signals completion of the deletion process) and
waits for the last neighbour to be freed.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    3 +++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   23 +++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index ca43901..36b5940 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -262,7 +262,9 @@ struct ipoib_ethtool_st {
 	u16     max_coalesced_frames;
 };
 
+struct ipoib_neigh_table;
 struct ipoib_neigh_hash {
+	struct ipoib_neigh_table       *ntbl;
 	struct ipoib_neigh __rcu      **buckets;
 	struct rcu_head			rcu;
 	u32				mask;
@@ -274,6 +276,7 @@ struct ipoib_neigh_table {
 	rwlock_t			rwlock;
 	atomic_t			entries;
 	struct completion		flushed;
+	struct completion		deleted;
 };
 
 /*
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3e2085a..72c1fc2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1095,6 +1095,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 	htbl->mask = (size - 1);
 	htbl->buckets = buckets;
 	ntbl->htbl = htbl;
+	htbl->ntbl = ntbl;
 	atomic_set(&ntbl->entries, 0);
 
 	/* start garbage collection */
@@ -1111,9 +1112,11 @@ static void neigh_hash_free_rcu(struct rcu_head *head)
 						    struct ipoib_neigh_hash,
 						    rcu);
 	struct ipoib_neigh __rcu **buckets = htbl->buckets;
+	struct ipoib_neigh_table *ntbl = htbl->ntbl;
 
 	kfree(buckets);
 	kfree(htbl);
+	complete(&ntbl->deleted);
 }
 
 void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
@@ -1164,7 +1167,9 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	unsigned long flags;
-	int i;
+	int i, wait_flushed = 0;
+
+	init_completion(&priv->ntbl.flushed);
 
 	write_lock_bh(&ntbl->rwlock);
 
@@ -1173,6 +1178,10 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 	if (!htbl)
 		goto out_unlock;
 
+	wait_flushed = atomic_read(&priv->ntbl.entries);
+	if (!wait_flushed)
+		goto free_htbl;
+
 	for (i = 0; i < htbl->size; i++) {
 		struct ipoib_neigh *neigh;
 		struct ipoib_neigh __rcu **np = &htbl->buckets[i];
@@ -1190,11 +1199,14 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 		}
 	}
 
+free_htbl:
 	rcu_assign_pointer(ntbl->htbl, NULL);
 	call_rcu(&htbl->rcu, neigh_hash_free_rcu);
 
 out_unlock:
 	write_unlock_bh(&ntbl->rwlock);
+	if (wait_flushed)
+		wait_for_completion(&priv->ntbl.flushed);
 }
 
 static void ipoib_neigh_hash_uninit(struct net_device *dev)
@@ -1203,7 +1215,7 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 	int stopped;
 
 	ipoib_dbg(priv, "ipoib_neigh_hash_uninit\n");
-	init_completion(&priv->ntbl.flushed);
+	init_completion(&priv->ntbl.deleted);
 	set_bit(IPOIB_NEIGH_TBL_FLUSH, &priv->flags);
 
 	/* Stop GC if called at init fail need to cancel work */
@@ -1211,10 +1223,9 @@ static void ipoib_neigh_hash_uninit(struct net_device *dev)
 	if (!stopped)
 		cancel_delayed_work(&priv->neigh_reap_task);
 
-	if (atomic_read(&priv->ntbl.entries)) {
-		ipoib_flush_neighs(priv);
-		wait_for_completion(&priv->ntbl.flushed);
-	}
+	ipoib_flush_neighs(priv);
+
+	wait_for_completion(&priv->ntbl.deleted);
 }
 
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
