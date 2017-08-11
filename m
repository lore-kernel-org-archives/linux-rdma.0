From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 21/22] IB/ipoib: Sync between remove_one to sysfs calls that use rtnl_lock
Date: Fri, 11 Aug 2017 13:50:02 +0300
Message-ID: <20170811105003.7661-22-leon@kernel.org>
References: <20170811105003.7661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811105003.7661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to avoid deadlock between sysfs functions (like create/delete
child) and remove_one (both of them are using the sysfs lock and
rtnl_lock) the driver will use a state mutex for sync.

That will fix traces as the following:
schedule+0x3e/0x90
kernfs_drain+0x75/0xf0
? wait_woken+0x90/0x90
__kernfs_remove+0x12e/0x1c0
kernfs_remove+0x25/0x40
sysfs_remove_dir+0x57/0x90
kobject_del+0x22/0x60
device_del+0x195/0x230
 pm_runtime_set_memalloc_noio+0xac/0xf0
netdev_unregister_kobject+0x71/0x80
rollback_registered_many+0x205/0x2f0
rollback_registered+0x31/0x40
unregister_netdevice_queue+0x58/0xb0
unregister_netdev+0x20/0x30
ipoib_remove_one+0xb7/0x240 [ib_ipoib]
ib_unregister_device+0xbc/0x1b0 [ib_core]
ib_unregister_mad_agent+0x29/0x30 [ib_core]
mlx4_ib_remove+0x67/0x280 [mlx4_ib]
INFO: task echo:24082 blocked for more than 120 seconds.
Tainted: G           OE   4.1.12-37.5.1.el6uek.x86_64 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
Call Trace:
schedule+0x3e/0x90
schedule_preempt_disabled+0xe/0x10
__mutex_lock_slowpath+0x95/0x110
? _rcu_barrier+0x177/0x220
mutex_lock+0x23/0x40
rtnl_lock+0x15/0x20
netdev_run_todo+0x81/0x1f0
rtnl_unlock+0xe/0x10
ipoib_vlan_delete+0x12f/0x1c0 [ib_ipoib]
delete_child+0x69/0x80 [ib_ipoib]
dev_attr_store+0x20/0x30
sysfs_kf_write+0x41/0x50

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  8 +++++++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  5 +++++
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 22 ++++++++++++++++++----
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index ff50a7bd66d8..f69a8346a26d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -336,6 +336,7 @@ struct ipoib_dev_priv {
 	unsigned long flags;
 
 	struct rw_semaphore vlan_rwsem;
+	struct mutex        sysfs_lock; /* Protect sysfs running*/
 
 	struct rb_root  path_tree;
 	struct list_head path_list;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index f87d104837dc..85ef9f10bdee 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1507,9 +1507,14 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 	if (test_bit(IPOIB_FLAG_GOING_DOWN, &priv->flags))
 		return -EPERM;
 
-	if (!rtnl_trylock())
+	if (!mutex_trylock(&priv->sysfs_lock))
 		return restart_syscall();
 
+	if (!rtnl_trylock()) {
+		mutex_unlock(&priv->sysfs_lock);
+		return restart_syscall();
+	}
+
 	ret = ipoib_set_mode(dev, buf);
 
 	/* The assumption is that the function ipoib_set_mode returned
@@ -1518,6 +1523,7 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 	 */
 	if (ret != -EBUSY)
 		rtnl_unlock();
+	mutex_unlock(&priv->sysfs_lock);
 
 	return (!ret || ret == -EBUSY) ? count : ret;
 }
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 645217232250..627ff8fb59b0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1876,6 +1876,7 @@ static void ipoib_build_priv(struct net_device *dev)
 	priv->dev = dev;
 	spin_lock_init(&priv->lock);
 	init_rwsem(&priv->vlan_rwsem);
+	mutex_init(&priv->sysfs_lock);
 
 	INIT_LIST_HEAD(&priv->path_list);
 	INIT_LIST_HEAD(&priv->child_intfs);
@@ -2325,7 +2326,11 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		cancel_delayed_work(&priv->neigh_reap_task);
 		flush_workqueue(priv->wq);
 
+		/* Wrap rtnl_lock/unlock with mutex to protect sysfs calls */
+		mutex_lock(&priv->sysfs_lock);
 		unregister_netdev(priv->dev);
+		mutex_unlock(&priv->sysfs_lock);
+
 		rn->free_rdma_netdev(priv->dev);
 
 		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 081b33deff1b..dd46abcf53c2 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -133,12 +133,20 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	snprintf(intf_name, sizeof intf_name, "%s.%04x",
 		 ppriv->dev->name, pkey);
 
-	if (!rtnl_trylock())
+	if (!mutex_trylock(&ppriv->sysfs_lock))
 		return restart_syscall();
 
+	if (!rtnl_trylock()) {
+		mutex_unlock(&ppriv->sysfs_lock);
+		return restart_syscall();
+	}
+
 	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
-	if (!priv)
+	if (!priv) {
+		rtnl_unlock();
+		mutex_unlock(&ppriv->sysfs_lock);
 		return -ENOMEM;
+	}
 
 	down_write(&ppriv->vlan_rwsem);
 
@@ -164,8 +172,8 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 out:
 	up_write(&ppriv->vlan_rwsem);
-
 	rtnl_unlock();
+	mutex_unlock(&ppriv->sysfs_lock);
 
 	if (result) {
 		free_netdev(priv->dev);
@@ -188,8 +196,13 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
 		return -EPERM;
 
-	if (!rtnl_trylock())
+	if (!mutex_trylock(&ppriv->sysfs_lock))
+		return restart_syscall();
+
+	if (!rtnl_trylock()) {
+		mutex_unlock(&ppriv->sysfs_lock);
 		return restart_syscall();
+	}
 
 	down_write(&ppriv->vlan_rwsem);
 	list_for_each_entry_safe(priv, tpriv, &ppriv->child_intfs, list) {
@@ -208,6 +221,7 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	}
 
 	rtnl_unlock();
+	mutex_unlock(&ppriv->sysfs_lock);
 
 	if (dev) {
 		free_netdev(dev);
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
