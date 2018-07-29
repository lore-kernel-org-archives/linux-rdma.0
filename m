From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 01/10] IB/ipoib: Get rid of IPOIB_FLAG_GOING_DOWN
Date: Sun, 29 Jul 2018 11:34:51 +0300
Message-ID: <20180729083500.5352-2-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

This essentially duplicates the netdev's reg_state, so just use that
directly. The reg_state is updated under the rntl_lock, and all places
using GOING_DOWN already acquire the rtnl_lock so checking is safe.

Since the only place we use GOING_DOWN is for the parent device this
does not fix any bugs, but it is a step to tidy up the unregister flow
so that after later patches the flow is uniform and sane.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   |  9 ++++++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  3 ---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 18 ++++++++++++------
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index e255a7e5a4c3..9eebb705d994 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -95,7 +95,6 @@ enum {
 	IPOIB_NEIGH_TBL_FLUSH	  = 12,
 	IPOIB_FLAG_DEV_ADDR_SET	  = 13,
 	IPOIB_FLAG_DEV_ADDR_CTRL  = 14,
-	IPOIB_FLAG_GOING_DOWN	  = 15,
 
 	IPOIB_MAX_BACKOFF_SECONDS = 16,
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 8b44f33c7ae0..83fa402e5d03 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1516,9 +1516,6 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 	int ret;
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
-	if (test_bit(IPOIB_FLAG_GOING_DOWN, &priv->flags))
-		return -EPERM;
-
 	if (!mutex_trylock(&priv->sysfs_mutex))
 		return restart_syscall();
 
@@ -1527,6 +1524,12 @@ static ssize_t set_mode(struct device *d, struct device_attribute *attr,
 		return restart_syscall();
 	}
 
+	if (dev->reg_state != NETREG_REGISTERED) {
+		rtnl_unlock();
+		mutex_unlock(&priv->sysfs_mutex);
+		return -EPERM;
+	}
+
 	ret = ipoib_set_mode(dev, buf);
 
 	/* The assumption is that the function ipoib_set_mode returned
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 82f0e3869b04..7ca9013bf05c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2406,9 +2406,6 @@ static void ipoib_remove_one(struct ib_device *device, void *client_data)
 		ib_unregister_event_handler(&priv->event_handler);
 		flush_workqueue(ipoib_workqueue);
 
-		/* mark interface in the middle of destruction */
-		set_bit(IPOIB_FLAG_GOING_DOWN, &priv->flags);
-
 		rtnl_lock();
 		dev_change_flags(priv->dev, priv->dev->flags & ~IFF_UP);
 		rtnl_unlock();
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index b067ad5e4c7e..1b7bfd500893 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -127,9 +127,6 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 
 	ppriv = ipoib_priv(pdev);
 
-	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
-		return -EPERM;
-
 	snprintf(intf_name, sizeof(intf_name), "%s.%04x",
 		 ppriv->dev->name, pkey);
 
@@ -141,6 +138,12 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		return restart_syscall();
 	}
 
+	if (pdev->reg_state != NETREG_REGISTERED) {
+		rtnl_unlock();
+		mutex_unlock(&ppriv->sysfs_mutex);
+		return -EPERM;
+	}
+
 	if (!down_write_trylock(&ppriv->vlan_rwsem)) {
 		rtnl_unlock();
 		mutex_unlock(&ppriv->sysfs_mutex);
@@ -199,9 +202,6 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 
 	ppriv = ipoib_priv(pdev);
 
-	if (test_bit(IPOIB_FLAG_GOING_DOWN, &ppriv->flags))
-		return -EPERM;
-
 	if (!mutex_trylock(&ppriv->sysfs_mutex))
 		return restart_syscall();
 
@@ -210,6 +210,12 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 		return restart_syscall();
 	}
 
+	if (pdev->reg_state != NETREG_REGISTERED) {
+		rtnl_unlock();
+		mutex_unlock(&ppriv->sysfs_mutex);
+		return -EPERM;
+	}
+
 	if (!down_write_trylock(&ppriv->vlan_rwsem)) {
 		rtnl_unlock();
 		mutex_unlock(&ppriv->sysfs_mutex);
-- 
2.14.4
