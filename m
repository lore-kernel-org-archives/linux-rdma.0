From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/7] IB/IPoIB: Fix race between ipoib_remove_one to sysfs functions
Date: Sat,  4 Jun 2016 15:15:20 +0300
Message-ID: <1465042524-25852-4-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In ipoib_remove_one the driver holds the rtnl_lock and tries to do some
operation like dev_change_flags or unregister_netdev, while sysfs
callback like ipoib_vlan_delete holds sysfs mutex and tries to hold the
rtnl_lock via rtnl_trylock() and restart_syscall() if the lock is not
free, meanwhile ipoib_remove_one tries to get the sysfs lock in order to
free its sysfs directory, and we will get  a->b, b->a deadlock.

    Trace like the following:

        schedule+0x37/0x80
        schedule_preempt_disabled+0xe/0x10
        __mutex_lock_slowpath+0xb5/0x120
        mutex_lock+0x23/0x40
        rtnl_lock+0x15/0x20
        netdev_run_todo+0x17c/0x320
        rtnl_unlock+0xe/0x10
        ipoib_vlan_delete+0x11b/0x1b0 [ib_ipoib]
        delete_child+0x54/0x80 [ib_ipoib]
        dev_attr_store+0x18/0x30
        sysfs_kf_write+0x37/0x40
        mutex_lock+0x16/0x40
        SyS_write+0x55/0xc0
        entry_SYSCALL_64_fastpath+0x16/0x75
    And
        schedule+0x37/0x80
        __kernfs_remove+0x1a8/0x260
        ? wake_atomic_t_function+0x60/0x60
        kernfs_remove+0x25/0x40
        sysfs_remove_dir+0x50/0x80
        kobject_del+0x18/0x50
        device_del+0x19f/0x260
        netdev_unregister_kobject+0x6a/0x80
        rollback_registered_many+0x1fd/0x340
        rollback_registered+0x3c/0x70
        unregister_netdevice_queue+0x55/0xc0
        unregister_netdev+0x20/0x30
        ipoib_remove_one+0x114/0x1b0 [ib_ipoib]
        ib_unregister_client+0x4a/0x170 [ib_core]
        ? find_module_all+0x71/0xa0
        ipoib_cleanup_module+0x10/0x94 [ib_ipoib]
        SyS_delete_module+0x1b5/0x210
        entry_SYSCALL_64_fastpath+0x16/0x75

The fix is by checking the flag IPOIB_FLAG_INTF_ON_DESTROY in order to
get out from the sysfs function.

Fixes: 862096a8bbf8 ("IB/ipoib: Add more rtnl_link_ops callbacks")
Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      | 1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 4 ++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 3 +++
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 6 ++++++
 4 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index bab7db6..4f7d9b4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -94,6 +94,7 @@ enum {
 	IPOIB_NEIGH_TBL_FLUSH	  = 12,
 	IPOIB_FLAG_DEV_ADDR_SET	  = 13,
 	IPOIB_FLAG_DEV_ADDR_CTRL  = 14,
+	IPOIB_FLAG_GOING_DOWN	  = 15,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index b2f4283..951d9ab 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1486,6 +1486,10 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 {
 	struct net_device *dev = to_net_dev(d);
 	int ret;
+	struct ipoib_dev_priv *priv = netdev_priv(dev);
+
+	if (test_bit(IPOIB_FLAG_GOING_DOWN, &priv->flags))
+		return -EPERM;
 
 	if (!rtnl_trylock())
 		return restart_syscall();
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index c558c32..1cd569f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2143,6 +2143,9 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		ib_unregister_event_handler(&priv->event_handler);
 		flush_workqueue(ipoib_workqueue);
 
+		/* mark interface in the middle of destruction */
+		set_bit(IPOIB_FLAG_GOING_DOWN, &priv->flags);
+
 		rtnl_lock();
 		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
 		rtnl_unlock();
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 64a3559..a2f9f29 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -131,6 +131,9 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 	ppriv = netdev_priv(pdev);
 
+	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
+		return -EPERM;
+
 	snprintf(intf_name, sizeof intf_name, "%s.%04x",
 		 ppriv->dev->name, pkey);
 	priv = ipoib_intf_alloc(intf_name);
@@ -183,6 +186,9 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 
 	ppriv = netdev_priv(pdev);
 
+	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
+		return -EPERM;
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
