From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 08/10] IB/ipoib: Do not remove child devices from within the ndo_uninit
Date: Sun, 29 Jul 2018 11:34:58 +0300
Message-ID: <20180729083500.5352-9-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Switching to priv_destructor and needs_free_netdev created a subtle
ordering problem in ipoib_remove_one.

Now that unregister_netdev frees the netdev and priv we must ensure that
the children are unregistered before trying to unregister the parent,
or child unregister will use after free.

The solution is to unregister the children, then parent, in the same batch
all while holding the rtnl_lock. This closes all the races where a new
child could have been added and ensures proper ordering.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  7 +++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 28 +++++++++++++++++-----------
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c |  6 ++++++
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 804cb4bee57d..1abe3c62f106 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -330,6 +330,13 @@ struct ipoib_dev_priv {
 
 	unsigned long flags;
 
+	/*
+	 * This protects access to the child_intfs list.
+	 * To READ from child_intfs the RTNL or vlan_rwsem read side must be
+	 * held.  To WRITE RTNL and the vlan_rwsem write side must be held (in
+	 * that order) This lock exists because we have a few contexts where
+	 * we need the child_intfs, but do not want to grab the RTNL.
+	 */
 	struct rw_semaphore vlan_rwsem;
 	struct mutex mcast_mutex;
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e9f4f261fe20..b2fe23d60103 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1939,18 +1939,15 @@ static int ipoib_ndo_init(struct net_device *ndev)
 
 static void ipoib_ndo_uninit(struct net_device *dev)
 {
-	struct ipoib_dev_priv *priv = ipoib_priv(dev), *cpriv, *tcpriv;
-	LIST_HEAD(head);
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	ASSERT_RTNL();
 
-	/* Delete any child interfaces first */
-	list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
-		/* Stop GC on child */
-		cancel_delayed_work_sync(&cpriv->neigh_reap_task);
-		unregister_netdevice_queue(cpriv->dev, &head);
-	}
-	unregister_netdevice_many(&head);
+	/*
+	 * ipoib_remove_one guarantees the children are removed before the
+	 * parent, and that is the only place where a parent can be removed.
+	 */
+	WARN_ON(!list_empty(&priv->child_intfs));
 
 	ipoib_neigh_hash_uninit(dev);
 
@@ -2466,16 +2463,25 @@ static void ipoib_add_one(struct ib_device *device)
 
 static void ipoib_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ipoib_dev_priv *priv, *tmp;
+	struct ipoib_dev_priv *priv, *tmp, *cpriv, *tcpriv;
 	struct list_head *dev_list = client_data;
 
 	if (!dev_list)
 		return;
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
+		LIST_HEAD(head);
 		ipoib_parent_unregister_pre(priv->dev);
 
-		unregister_netdev(priv->dev);
+		rtnl_lock();
+
+		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs,
+					 list)
+			unregister_netdevice_queue(cpriv->dev, &head);
+		unregister_netdevice_queue(priv->dev, &head);
+		unregister_netdevice_many(&head);
+
+		rtnl_unlock();
 	}
 
 	kfree(dev_list);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 891c5b40018a..fa4dfcee2644 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -67,6 +67,12 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 
 	ASSERT_RTNL();
 
+	/*
+	 * Racing with unregister of the parent must be prevented by the
+	 * caller.
+	 */
+	WARN_ON(ppriv->dev->reg_state != NETREG_REGISTERED);
+
 	priv->parent = ppriv->dev;
 	priv->pkey = pkey;
 	priv->child_type = type;
-- 
2.14.4
