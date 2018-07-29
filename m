From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 04/10] IB/ipoib: Make ipoib_neigh_hash_uninit fully fence its work
Date: Sun, 29 Jul 2018 11:34:54 +0300
Message-ID: <20180729083500.5352-5-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

The neigh_reap_task is self restarting, but so long as we call
cancel_delayed_work_sync() it will be guaranteed to not be running and
never start again. Thus there is no longer any purpose to
IPOIB_STOP_NEIGH_GC (which was racy/buggy anyhow), so remove it too.

This fixes a situation where the GC work could have been running

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 25 +++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 48e9ea50ca87..04fc5ad1b69f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -91,7 +91,6 @@ enum {
 	IPOIB_STOP_REAPER	  = 7,
 	IPOIB_FLAG_ADMIN_CM	  = 9,
 	IPOIB_FLAG_UMCAST	  = 10,
-	IPOIB_STOP_NEIGH_GC	  = 11,
 	IPOIB_NEIGH_TBL_FLUSH	  = 12,
 	IPOIB_FLAG_DEV_ADDR_SET	  = 13,
 	IPOIB_FLAG_DEV_ADDR_CTRL  = 14,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 4eec2781e83f..d4e9951dc539 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1305,9 +1305,6 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 	int i;
 	LIST_HEAD(remove_list);
 
-	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
-		return;
-
 	spin_lock_irqsave(&priv->lock, flags);
 
 	htbl = rcu_dereference_protected(ntbl->htbl,
@@ -1319,9 +1316,6 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 	/* neigh is obsolete if it was idle for two GC periods */
 	dt = 2 * arp_tbl.gc_interval;
 	neigh_obsolete = jiffies - dt;
-	/* handle possible race condition */
-	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
-		goto out_unlock;
 
 	for (i = 0; i < htbl->size; i++) {
 		struct ipoib_neigh *neigh;
@@ -1359,9 +1353,8 @@ static void ipoib_reap_neigh(struct work_struct *work)
 
 	__ipoib_reap_neigh(priv);
 
-	if (!test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
-		queue_delayed_work(priv->wq, &priv->neigh_reap_task,
-				   arp_tbl.gc_interval);
+	queue_delayed_work(priv->wq, &priv->neigh_reap_task,
+			   arp_tbl.gc_interval);
 }
 
 
@@ -1523,7 +1516,6 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 	htbl = kzalloc(sizeof(*htbl), GFP_KERNEL);
 	if (!htbl)
 		return -ENOMEM;
-	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	size = roundup_pow_of_two(arp_tbl.gc_thresh3);
 	buckets = kvcalloc(size, sizeof(*buckets), GFP_KERNEL);
 	if (!buckets) {
@@ -1538,7 +1530,6 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 	atomic_set(&ntbl->entries, 0);
 
 	/* start garbage collection */
-	clear_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	queue_delayed_work(priv->wq, &priv->neigh_reap_task,
 			   arp_tbl.gc_interval);
 
@@ -1648,15 +1639,11 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
 static void ipoib_neigh_hash_uninit(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
-	int stopped;
 
 	ipoib_dbg(priv, "ipoib_neigh_hash_uninit\n");
 	init_completion(&priv->ntbl.deleted);
 
-	/* Stop GC if called at init fail need to cancel work */
-	stopped = test_and_set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-	if (!stopped)
-		cancel_delayed_work_sync(&priv->neigh_reap_task);
+	cancel_delayed_work_sync(&priv->neigh_reap_task);
 
 	ipoib_flush_neighs(priv);
 
@@ -1796,12 +1783,15 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		if (ipoib_ib_dev_open(dev)) {
 			pr_warn("%s failed to open device\n", dev->name);
 			ret = -ENODEV;
-			goto out_dev_uninit;
+			goto out_hash_uninit;
 		}
 	}
 
 	return 0;
 
+out_hash_uninit:
+	ipoib_neigh_hash_uninit(dev);
+
 out_dev_uninit:
 	ipoib_ib_dev_cleanup(dev);
 
@@ -1857,7 +1847,6 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 	/* Delete any child interfaces first */
 	list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
 		/* Stop GC on child */
-		set_bit(IPOIB_STOP_NEIGH_GC, &cpriv->flags);
 		cancel_delayed_work_sync(&cpriv->neigh_reap_task);
 		unregister_netdevice_queue(cpriv->dev, &head);
 	}
-- 
2.14.4
