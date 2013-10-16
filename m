From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 3/7] IB/ipoib: Fix deadlock between dev_change_flags to __ipoib_dev_flush
Date: Wed, 16 Oct 2013 17:37:49 +0300
Message-ID: <1381934273-29683-4-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When ipoib interface is going down it takes all its childs with it, under mutex.

For each child dev_change_flags is called, that function calls
ipoib_stop via the ndo, and causes flush of the workqueue. Sometimes
in the workqueue an __ipoib_dev_flush work is waiting and when invoked
tries to get the same mutex, which leads to a deadlock, as seen below.

The solution is to switch to rw-sem instead of mutex.

The deadlock:
[11028.165303]  [<ffffffff812b0977>] ? vgacon_scroll+0x107/0x2e0
[11028.171844]  [<ffffffff814eaac5>] schedule_timeout+0x215/0x2e0
[11028.178465]  [<ffffffff8105a5c3>] ? perf_event_task_sched_out+0x33/0x80
[11028.185962]  [<ffffffff814ea743>] wait_for_common+0x123/0x180
[11028.192491]  [<ffffffff8105fa40>] ? default_wake_function+0x0/0x20
[11028.199504]  [<ffffffff814ea85d>] wait_for_completion+0x1d/0x20
[11028.206224]  [<ffffffff8108b4f1>] flush_cpu_workqueue+0x61/0x90
[11028.212948]  [<ffffffff8108b5a0>] ? wq_barrier_func+0x0/0x20
[11028.219375]  [<ffffffff8108bfc4>] flush_workqueue+0x54/0x80
[11028.225712]  [<ffffffffa05a0576>] ipoib_mcast_stop_thread+0x66/0x90 [ib_ipoib]
[11028.233988]  [<ffffffffa059ccea>] ipoib_ib_dev_down+0x6a/0x100 [ib_ipoib]
[11028.241678]  [<ffffffffa059849a>] ipoib_stop+0x8a/0x140 [ib_ipoib]
[11028.248692]  [<ffffffff8142adf1>] dev_close+0x71/0xc0
[11028.254447]  [<ffffffff8142a631>] dev_change_flags+0xa1/0x1d0
[11028.261062]  [<ffffffffa059851b>] ipoib_stop+0x10b/0x140 [ib_ipoib]
[11028.268172]  [<ffffffff8142adf1>] dev_close+0x71/0xc0
[11028.273922]  [<ffffffff8142a631>] dev_change_flags+0xa1/0x1d0
[11028.280452]  [<ffffffff8148f20b>] devinet_ioctl+0x5eb/0x6a0
[11028.286786]  [<ffffffff814903b8>] inet_ioctl+0x88/0xa0
[11028.292633]  [<ffffffff8141591a>] sock_ioctl+0x7a/0x280
[11028.298576]  [<ffffffff81189012>] vfs_ioctl+0x22/0xa0
[11028.304326]  [<ffffffff81140540>] ? unmap_region+0x110/0x130
[11028.310756]  [<ffffffff811891b4>] do_vfs_ioctl+0x84/0x580
[11028.316897]  [<ffffffff81189731>] sys_ioctl+0x81/0xa0

and

11028.017533]  [<ffffffff8105a5c3>] ? perf_event_task_sched_out+0x33/0x80
[11028.025030]  [<ffffffff8100bb8e>] ? apic_timer_interrupt+0xe/0x20
[11028.031945]  [<ffffffff814eb2ae>] __mutex_lock_slowpath+0x13e/0x180
[11028.039053]  [<ffffffff814eb14b>] mutex_lock+0x2b/0x50
[11028.044910]  [<ffffffffa059f7e7>] __ipoib_ib_dev_flush+0x37/0x210 [ib_ipoib]
[11028.052894]  [<ffffffffa059fa00>] ? ipoib_ib_dev_flush_light+0x0/0x20 [ib_ipoib]
[11028.061363]  [<ffffffffa059fa17>] ipoib_ib_dev_flush_light+0x17/0x20 [ib_ipoib]
[11028.069738]  [<ffffffff8108b120>] worker_thread+0x170/0x2a0
[11028.076068]  [<ffffffff81090990>] ? autoremove_wake_function+0x0/0x40
[11028.083374]  [<ffffffff8108afb0>] ? worker_thread+0x0/0x2a0
[11028.089709]  [<ffffffff81090626>] kthread+0x96/0xa0
[11028.095266]  [<ffffffff8100c0ca>] child_rip+0xa/0x20
[11028.100921]  [<ffffffff81090590>] ? kthread+0x0/0xa0
[11028.106573]  [<ffffffff8100c0c0>] ? child_rip+0x0/0x20
[11028.112423] INFO: task ifconfig:23640 blocked for more than 120 seconds.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h         |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c      |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |   10 +++++-----
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c |    4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    |   10 ++++++----
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index eb71aaa..ec9190e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -299,7 +299,7 @@ struct ipoib_dev_priv {
 
 	unsigned long flags;
 
-	struct mutex vlan_mutex;
+	struct rw_semaphore vlan_rwsem;
 
 	struct rb_root  path_tree;
 	struct list_head path_list;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index c14f949..01594de 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -977,7 +977,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	u16 new_index;
 	int result;
 
-	mutex_lock(&priv->vlan_mutex);
+	down_read(&priv->vlan_rwsem);
 
 	/*
 	 * Flush any child interfaces too -- they might be up even if
@@ -986,7 +986,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 	list_for_each_entry(cpriv, &priv->child_intfs, list)
 		__ipoib_ib_dev_flush(cpriv, level);
 
-	mutex_unlock(&priv->vlan_mutex);
+	up_read(&priv->vlan_rwsem);
 
 	if (!test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags)) {
 		/* for non-child devices must check/update the pkey value here */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 82cec1a..dcb50ce 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -119,7 +119,7 @@ int ipoib_open(struct net_device *dev)
 		struct ipoib_dev_priv *cpriv;
 
 		/* Bring up any child interfaces too */
-		mutex_lock(&priv->vlan_mutex);
+		down_read(&priv->vlan_rwsem);
 		list_for_each_entry(cpriv, &priv->child_intfs, list) {
 			int flags;
 
@@ -129,7 +129,7 @@ int ipoib_open(struct net_device *dev)
 
 			dev_change_flags(cpriv->dev, flags | IFF_UP);
 		}
-		mutex_unlock(&priv->vlan_mutex);
+		up_read(&priv->vlan_rwsem);
 	}
 
 	netif_start_queue(dev);
@@ -162,7 +162,7 @@ static int ipoib_stop(struct net_device *dev)
 		struct ipoib_dev_priv *cpriv;
 
 		/* Bring down any child interfaces too */
-		mutex_lock(&priv->vlan_mutex);
+		down_read(&priv->vlan_rwsem);
 		list_for_each_entry(cpriv, &priv->child_intfs, list) {
 			int flags;
 
@@ -172,7 +172,7 @@ static int ipoib_stop(struct net_device *dev)
 
 			dev_change_flags(cpriv->dev, flags & ~IFF_UP);
 		}
-		mutex_unlock(&priv->vlan_mutex);
+		up_read(&priv->vlan_rwsem);
 	}
 
 	return 0;
@@ -1372,7 +1372,7 @@ void ipoib_setup(struct net_device *dev)
 
 	spin_lock_init(&priv->lock);
 
-	mutex_init(&priv->vlan_mutex);
+	init_rwsem(&priv->vlan_rwsem);
 
 	INIT_LIST_HEAD(&priv->path_list);
 	INIT_LIST_HEAD(&priv->child_intfs);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index f81abe1..c29b5c8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -142,10 +142,10 @@ static void ipoib_unregister_child_dev(struct net_device *dev, struct list_head
 	priv = netdev_priv(dev);
 	ppriv = netdev_priv(priv->parent);
 
-	mutex_lock(&ppriv->vlan_mutex);
+	down_write(&ppriv->vlan_rwsem);
 	unregister_netdevice_queue(dev, head);
 	list_del(&priv->list);
-	mutex_unlock(&ppriv->vlan_mutex);
+	up_write(&ppriv->vlan_rwsem);
 }
 
 static size_t ipoib_get_size(const struct net_device *dev)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 8292554..9fad7b5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -140,7 +140,7 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	mutex_lock(&ppriv->vlan_mutex);
+	down_write(&ppriv->vlan_rwsem);
 
 	/*
 	 * First ensure this isn't a duplicate. We check the parent device and
@@ -163,7 +163,7 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 	result = __ipoib_vlan_add(ppriv, priv, pkey, IPOIB_LEGACY_CHILD);
 
 out:
-	mutex_unlock(&ppriv->vlan_mutex);
+	up_write(&ppriv->vlan_rwsem);
 
 	if (result)
 		free_netdev(priv->dev);
@@ -185,7 +185,8 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 
 	if (!rtnl_trylock())
 		return restart_syscall();
-	mutex_lock(&ppriv->vlan_mutex);
+
+	down_write(&ppriv->vlan_rwsem);
 	list_for_each_entry_safe(priv, tpriv, &ppriv->child_intfs, list) {
 		if (priv->pkey == pkey &&
 		    priv->child_type == IPOIB_LEGACY_CHILD) {
@@ -195,7 +196,8 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 			break;
 		}
 	}
-	mutex_unlock(&ppriv->vlan_mutex);
+	up_write(&ppriv->vlan_rwsem);
+
 	rtnl_unlock();
 
 	if (dev) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
