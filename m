From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 07/10] IB/ipoib: Get rid of the sysfs_mutex
Date: Sun, 29 Jul 2018 11:34:57 +0300
Message-ID: <20180729083500.5352-8-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

This mutex was introduced to deal with the deadlock formed by calling
unregister_netdev from within the sysfs callback of a netdev.

Now that we have priv_destructor and needs_free_netdev we can switch
to the more targeted solution of running the unregister from a
work queue. This avoids the deadlock and gets rid of the mutex.

The next patch in the series needs this mutex eliminated to create
atomicity of unregisteration.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  7 ---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  7 +--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 98 ++++++++++++++++++++-----------
 4 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index d2cb0a8500e3..804cb4bee57d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -332,7 +332,6 @@ struct ipoib_dev_priv {
 
 	struct rw_semaphore vlan_rwsem;
 	struct mutex mcast_mutex;
-	struct mutex sysfs_mutex;
 
 	struct rb_root  path_tree;
 	struct list_head path_list;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 83fa402e5d03..04785d3f8195 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1514,19 +1514,13 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 {
 	struct net_device *dev = to_net_dev(d);
 	int ret;
-	struct ipoib_dev_priv *priv = ipoib_priv(dev);
-
-	if (!mutex_trylock(&priv->sysfs_mutex))
-		return restart_syscall();
 
 	if (!rtnl_trylock()) {
-		mutex_unlock(&priv->sysfs_mutex);
 		return restart_syscall();
 	}
 
 	if (dev->reg_state != NETREG_REGISTERED) {
 		rtnl_unlock();
-		mutex_unlock(&priv->sysfs_mutex);
 		return -EPERM;
 	}
 
@@ -1538,7 +1532,6 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 	 */
 	if (ret != -EBUSY)
 		rtnl_unlock();
-	mutex_unlock(&priv->sysfs_mutex);
 
 	return (!ret || ret == -EBUSY) ? count : ret;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 73d917d57f93..e9f4f261fe20 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2079,7 +2079,6 @@ static void ipoib_build_priv(struct net_device *dev)
 	spin_lock_init(&priv->lock);
 	init_rwsem(&priv->vlan_rwsem);
 	mutex_init(&priv->mcast_mutex);
-	mutex_init(&priv->sysfs_mutex);
 
 	INIT_LIST_HEAD(&priv->path_list);
 	INIT_LIST_HEAD(&priv->child_intfs);
@@ -2476,10 +2475,7 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		ipoib_parent_unregister_pre(priv->dev);
 
-		/* Wrap rtnl_lock/unlock with mutex to protect sysfs calls */
-		mutex_lock(&priv->sysfs_mutex);
 		unregister_netdev(priv->dev);
-		mutex_unlock(&priv->sysfs_mutex);
 	}
 
 	kfree(dev_list);
@@ -2527,8 +2523,7 @@ static int __init ipoib_init_module(void)
 	 * its private workqueue, and we only queue up flush events
 	 * on our global flush workqueue.  This avoids the deadlocks.
 	 */
-	ipoib_workqueue = alloc_ordered_workqueue("ipoib_flush",
-						  WQ_MEM_RECLAIM);
+	ipoib_workqueue = alloc_ordered_workqueue("ipoib_flush", 0);
 	if (!ipoib_workqueue) {
 		ret = -ENOMEM;
 		goto err_fs;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 7776334cf8c5..891c5b40018a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -125,23 +125,16 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	snprintf(intf_name, sizeof(intf_name), "%s.%04x",
 		 ppriv->dev->name, pkey);
 
-	if (!mutex_trylock(&ppriv->sysfs_mutex))
+	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (!rtnl_trylock()) {
-		mutex_unlock(&ppriv->sysfs_mutex);
-		return restart_syscall();
-	}
-
 	if (pdev->reg_state != NETREG_REGISTERED) {
 		rtnl_unlock();
-		mutex_unlock(&ppriv->sysfs_mutex);
 		return -EPERM;
 	}
 
 	if (!down_write_trylock(&ppriv->vlan_rwsem)) {
 		rtnl_unlock();
-		mutex_unlock(&ppriv->sysfs_mutex);
 		return restart_syscall();
 	}
 
@@ -178,58 +171,95 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 out:
 	up_write(&ppriv->vlan_rwsem);
 	rtnl_unlock();
-	mutex_unlock(&ppriv->sysfs_mutex);
 
 	return result;
 }
 
+struct ipoib_vlan_delete_work {
+	struct work_struct work;
+	struct net_device *dev;
+};
+
+/*
+ * sysfs callbacks of a netdevice cannot obtain the rtnl lock as
+ * unregister_netdev ultimately deletes the sysfs files while holding the rtnl
+ * lock. This deadlocks the system.
+ *
+ * A callback can use rtnl_trylock to avoid the deadlock but it cannot call
+ * unregister_netdev as that internally takes and releases the rtnl_lock.  So
+ * instead we find the netdev to unregister and then do the actual unregister
+ * from the global work queue where we can obtain the rtnl_lock safely.
+ */
+static void ipoib_vlan_delete_task(struct work_struct *work)
+{
+	struct ipoib_vlan_delete_work *pwork =
+		container_of(work, struct ipoib_vlan_delete_work, work);
+	struct net_device *dev = pwork->dev;
+
+	rtnl_lock();
+
+	/* Unregistering tasks can race with another task or parent removal */
+	if (dev->reg_state == NETREG_REGISTERED) {
+		struct ipoib_dev_priv *priv = ipoib_priv(dev);
+		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
+
+		down_write(&ppriv->vlan_rwsem);
+		list_del(&priv->list);
+		up_write(&ppriv->vlan_rwsem);
+
+		ipoib_dbg(ppriv, "delete child vlan %s\n", dev->name);
+		unregister_netdevice(dev);
+	}
+
+	rtnl_unlock();
+
+	kfree(pwork);
+}
+
 int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 {
 	struct ipoib_dev_priv *ppriv, *priv, *tpriv;
-	struct net_device *dev = NULL;
+	int rc;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	ppriv = ipoib_priv(pdev);
-
-	if (!mutex_trylock(&ppriv->sysfs_mutex))
+	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (!rtnl_trylock()) {
-		mutex_unlock(&ppriv->sysfs_mutex);
-		return restart_syscall();
-	}
-
 	if (pdev->reg_state != NETREG_REGISTERED) {
 		rtnl_unlock();
-		mutex_unlock(&ppriv->sysfs_mutex);
 		return -EPERM;
 	}
 
-	if (!down_write_trylock(&ppriv->vlan_rwsem)) {
-		rtnl_unlock();
-		mutex_unlock(&ppriv->sysfs_mutex);
-		return restart_syscall();
-	}
+	ppriv = ipoib_priv(pdev);
 
+	rc = -ENODEV;
 	list_for_each_entry_safe(priv, tpriv, &ppriv->child_intfs, list) {
 		if (priv->pkey == pkey &&
 		    priv->child_type == IPOIB_LEGACY_CHILD) {
-			list_del(&priv->list);
-			dev = priv->dev;
+			struct ipoib_vlan_delete_work *work;
+
+			work = kmalloc(sizeof(*work), GFP_KERNEL);
+			if (!work) {
+				rc = -ENOMEM;
+				goto out;
+			}
+
+			down_write(&ppriv->vlan_rwsem);
+			list_del_init(&priv->list);
+			up_write(&ppriv->vlan_rwsem);
+			work->dev = priv->dev;
+			INIT_WORK(&work->work, ipoib_vlan_delete_task);
+			queue_work(ipoib_workqueue, &work->work);
+
+			rc = 0;
 			break;
 		}
 	}
-	up_write(&ppriv->vlan_rwsem);
-
-	if (dev) {
-		ipoib_dbg(ppriv, "delete child vlan %s\n", dev->name);
-		unregister_netdevice(dev);
-	}
 
+out:
 	rtnl_unlock();
-	mutex_unlock(&ppriv->sysfs_mutex);
 
-	return (dev) ? 0 : -ENODEV;
+	return rc;
 }
-- 
2.14.4
