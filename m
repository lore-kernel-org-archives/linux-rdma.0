From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 09/10] IB/ipoib: Maintain the child_intfs list from ndo_init/uninit
Date: Sun, 29 Jul 2018 11:34:59 +0300
Message-ID: <20180729083500.5352-10-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

This fixes a bug in the netlink path where the vlan_rwsem was not
held around __ipoib_vlan_add causing the child_intfs to be manipulated
unsafely.

In the process this greatly simplifies the vlan_rwsem write side locking
to only cover a single non-sleeping statement.

This also further increases the safety of the removal ordering by holding
the netdev of the parent while the child is active to ensure most bugs
become either an oops on a NULL priv or a deadlock on the netdev refcount.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c    | 16 ++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 14 --------------
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 12 ------------
 3 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b2fe23d60103..e3d28f9ad9c0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1890,6 +1890,12 @@ static void ipoib_child_init(struct net_device *ndev)
 	struct ipoib_dev_priv *priv = ipoib_priv(ndev);
 	struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
 
+	dev_hold(priv->parent);
+
+	down_write(&ppriv->vlan_rwsem);
+	list_add_tail(&priv->list, &ppriv->child_intfs);
+	up_write(&ppriv->vlan_rwsem);
+
 	priv->max_ib_mtu = ppriv->max_ib_mtu;
 	set_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags);
 	memcpy(priv->dev->dev_addr, ppriv->dev->dev_addr, INFINIBAND_ALEN);
@@ -1959,6 +1965,16 @@ static void ipoib_ndo_uninit(struct net_device *dev)
 		destroy_workqueue(priv->wq);
 		priv->wq = NULL;
 	}
+
+	if (priv->parent) {
+		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
+
+		down_write(&ppriv->vlan_rwsem);
+		list_del(&priv->list);
+		up_write(&ppriv->vlan_rwsem);
+
+		dev_put(priv->parent);
+	}
 }
 
 static int ipoib_set_vf_link_state(struct net_device *dev, int vf, int link_state)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index a86928a80c08..7e093b7aad8f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -133,19 +133,6 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
 	return err;
 }
 
-static void ipoib_unregister_child_dev(struct net_device *dev, struct list_head *head)
-{
-	struct ipoib_dev_priv *priv, *ppriv;
-
-	priv = ipoib_priv(dev);
-	ppriv = ipoib_priv(priv->parent);
-
-	down_write(&ppriv->vlan_rwsem);
-	unregister_netdevice_queue(dev, head);
-	list_del(&priv->list);
-	up_write(&ppriv->vlan_rwsem);
-}
-
 static size_t ipoib_get_size(const struct net_device *dev)
 {
 	return nla_total_size(2) +	/* IFLA_IPOIB_PKEY   */
@@ -161,7 +148,6 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.setup		= ipoib_setup_common,
 	.newlink	= ipoib_new_child_link,
 	.changelink	= ipoib_changelink,
-	.dellink	= ipoib_unregister_child_dev,
 	.get_size	= ipoib_get_size,
 	.fill_info	= ipoib_fill_info,
 };
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index fa4dfcee2644..ca3a7f6c0998 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -106,8 +106,6 @@ int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 			goto sysfs_failed;
 	}
 
-	list_add_tail(&priv->list, &ppriv->child_intfs);
-
 	return 0;
 
 sysfs_failed:
@@ -139,11 +137,6 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		return -EPERM;
 	}
 
-	if (!down_write_trylock(&ppriv->vlan_rwsem)) {
-		rtnl_unlock();
-		return restart_syscall();
-	}
-
 	/*
 	 * First ensure this isn't a duplicate. We check the parent device and
 	 * then all of the legacy child interfaces to make sure the Pkey
@@ -175,7 +168,6 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		free_netdev(ndev);
 
 out:
-	up_write(&ppriv->vlan_rwsem);
 	rtnl_unlock();
 
 	return result;
@@ -209,10 +201,6 @@ static void ipoib_vlan_delete_task(struct work_struct *work)
 		struct ipoib_dev_priv *priv = ipoib_priv(dev);
 		struct ipoib_dev_priv *ppriv = ipoib_priv(priv->parent);
 
-		down_write(&ppriv->vlan_rwsem);
-		list_del(&priv->list);
-		up_write(&ppriv->vlan_rwsem);
-
 		ipoib_dbg(ppriv, "delete child vlan %s\n", dev->name);
 		unregister_netdevice(dev);
 	}
-- 
2.14.4
