From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 03/10] IB/ipoib: Move all uninit code into ndo_uninit
Date: Sun, 29 Jul 2018 11:34:53 +0300
Message-ID: <20180729083500.5352-4-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Currently uninit is sometimes done twice in error flows, and is sprinkled
a bit all over the place.

Improve the clarity of the design by moving all uninit only into
ndo_uinit.

Some duplication is removed:
 - Sometimes IPOIB_STOP_NEIGH_GC was done before unregister, but
   this duplicates the process in ipoib_neigh_hash_init
 - Flushing priv->wq was sometimes done before unregister,
   but that duplicates what has been done in ndo_uninit

Uniniting the IB event queue must remain before unregister_netdev as it
requires the RTNL lock to be dropped, this is moved to a helper to make
that flow really clear and remove some duplication in error flows.

If register_netdev fails (and ndo_init is NULL) then it almost always
calls ndo_uninit, which lets us remove all the extra code from the error
unwinds. The next patch in the series will close the 'almost always' hole
by pairing a proper ndo_init with ndo_uninit.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 62 ++++++++++++++++---------------
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c |  5 +--
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 9eebb705d994..48e9ea50ca87 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -510,7 +510,6 @@ int ipoib_ib_dev_stop_default(struct net_device *dev);
 void ipoib_pkey_dev_check_presence(struct net_device *dev);
 
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
-void ipoib_dev_cleanup(struct net_device *dev);
 
 void ipoib_mcast_join_task(struct work_struct *work);
 void ipoib_mcast_carrier_on_task(struct work_struct *work);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7cd42619deb2..4eec2781e83f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -215,11 +215,6 @@ static int ipoib_stop(struct net_device *dev)
 	return 0;
 }
 
-static void ipoib_uninit(struct net_device *dev)
-{
-	ipoib_dev_cleanup(dev);
-}
-
 static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_features_t features)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
@@ -1826,7 +1821,33 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	return ret;
 }
 
-void ipoib_dev_cleanup(struct net_device *dev)
+/*
+ * This must be called before doing an unregister_netdev on a parent device to
+ * shutdown the IB event handler.
+ */
+static void ipoib_parent_unregister_pre(struct net_device *ndev)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(ndev);
+
+	/*
+	 * ipoib_set_mac checks netif_running before pushing work, clearing
+	 * running ensures the it will not add more work.
+	 */
+	rtnl_lock();
+	dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
+	rtnl_unlock();
+
+	/* ipoib_event() cannot be running once this returns */
+	ib_unregister_event_handler(&priv->event_handler);
+
+	/*
+	 * Work on the queue grabs the rtnl lock, so this cannot be done while
+	 * also holding it.
+	 */
+	flush_workqueue(ipoib_workqueue);
+}
+
+static void ipoib_ndo_uninit(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev), *cpriv, *tcpriv;
 	LIST_HEAD(head);
@@ -1899,7 +1920,7 @@ static const struct header_ops ipoib_header_ops = {
 };
 
 static const struct net_device_ops ipoib_netdev_ops_pf = {
-	.ndo_uninit		 = ipoib_uninit,
+	.ndo_uninit		 = ipoib_ndo_uninit,
 	.ndo_open		 = ipoib_open,
 	.ndo_stop		 = ipoib_stop,
 	.ndo_change_mtu		 = ipoib_change_mtu,
@@ -1918,7 +1939,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
 };
 
 static const struct net_device_ops ipoib_netdev_ops_vf = {
-	.ndo_uninit		 = ipoib_uninit,
+	.ndo_uninit		 = ipoib_ndo_uninit,
 	.ndo_open		 = ipoib_open,
 	.ndo_stop		 = ipoib_stop,
 	.ndo_change_mtu		 = ipoib_change_mtu,
@@ -2321,7 +2342,8 @@ static struct net_device *ipoib_add_port(const char *format,
 	if (result) {
 		pr_warn("%s: couldn't register ipoib port %d; error %d\n",
 			hca->name, port, result);
-		goto register_failed;
+		ipoib_parent_unregister_pre(priv->dev);
+		goto device_init_failed;
 	}
 
 	result = -ENOMEM;
@@ -2339,17 +2361,9 @@ static struct net_device *ipoib_add_port(const char *format,
 	return priv->dev;
 
 sysfs_failed:
+	ipoib_parent_unregister_pre(priv->dev);
 	unregister_netdev(priv->dev);
 
-register_failed:
-	ib_unregister_event_handler(&priv->event_handler);
-	flush_workqueue(ipoib_workqueue);
-	/* Stop GC if started before flush */
-	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-	cancel_delayed_work_sync(&priv->neigh_reap_task);
-	flush_workqueue(priv->wq);
-	ipoib_dev_cleanup(priv->dev);
-
 device_init_failed:
 	rn = netdev_priv(priv->dev);
 	rn->free_rdma_netdev(priv->dev);
@@ -2403,17 +2417,7 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		struct rdma_netdev *parent_rn = netdev_priv(priv->dev);
 
-		ib_unregister_event_handler(&priv->event_handler);
-		flush_workqueue(ipoib_workqueue);
-
-		rtnl_lock();
-		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
-		rtnl_unlock();
-
-		/* Stop GC */
-		set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-		cancel_delayed_work_sync(&priv->neigh_reap_task);
-		flush_workqueue(priv->wq);
+		ipoib_parent_unregister_pre(priv->dev);
 
 		/* Wrap rtnl_lock/unlock with mutex to protect sysfs calls */
 		mutex_lock(&priv->sysfs_mutex);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 1b7bfd500893..b62ab85c8ead 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -83,7 +83,7 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 	result = register_netdevice(priv->dev);
 	if (result) {
 		ipoib_warn(priv, "failed to initialize; error %i", result);
-		goto register_failed;
+		goto err;
 	}
 
 	/* RTNL childs don't need proprietary sysfs entries */
@@ -108,9 +108,6 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 	result = -ENOMEM;
 	unregister_netdevice(priv->dev);
 
-register_failed:
-	ipoib_dev_cleanup(priv->dev);
-
 err:
 	return result;
 }
-- 
2.14.4
