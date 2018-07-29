From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 06/10] RDMA/netdev: Use priv_destructor for netdev cleanup
Date: Sun, 29 Jul 2018 11:34:56 +0300
Message-ID: <20180729083500.5352-7-leon@kernel.org>
References: <20180729083500.5352-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Now that the unregister_netdev flow for IPoIB no longer relies on external
code we can now introduce the use of priv_destructor and
needs_free_netdev.

The rdma_netdev flow is switched to use the netdev common priv_destructor
instead of the special free_rdma_netdev and the IPOIB ULP adjusted:
 - priv_destructor needs to switch to point to the ULP's destructor
   which will then call the rdma_ndev's in the right order
 - We need to be careful around the error unwind of register_netdev
   as it sometimes calls priv_destructor on failure
 - ULPs need to use ndo_init/uninit to ensure proper ordering
   of failures around register_netdev

Switching to priv_destructor is a necessary pre-requisite to using
the rtnl new_link mechanism.

The VNIC user for rdma_netdev should also be revised, but that is left for
another patch.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Denis Drozdov <denisd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c                  |  10 --
 drivers/infiniband/ulp/ipoib/ipoib.h               |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 101 +++++++++++++--------
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |  68 ++++++++------
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  37 ++++----
 include/linux/mlx5/driver.h                        |   3 -
 include/rdma/ib_verbs.h                            |   6 +-
 7 files changed, 129 insertions(+), 98 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a93ef6367d38..9011187ca081 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5157,11 +5157,6 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }

-static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
-{
-	return mlx5_rdma_netdev_free(netdev);
-}
-
 static struct net_device*
 mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
 			  u8 port_num,
@@ -5171,17 +5166,12 @@ mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
 			  void (*setup)(struct net_device *))
 {
 	struct net_device *netdev;
-	struct rdma_netdev *rn;

 	if (type != RDMA_NETDEV_IPOIB)
 		return ERR_PTR(-EOPNOTSUPP);

 	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
 					name, setup);
-	if (likely(!IS_ERR_OR_NULL(netdev))) {
-		rn = netdev_priv(netdev);
-		rn->free_rdma_netdev = mlx5_ib_free_rdma_netdev;
-	}
 	return netdev;
 }

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 02ad1a60dc80..d2cb0a8500e3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -323,6 +323,7 @@ struct ipoib_dev_priv {
 	spinlock_t lock;

 	struct net_device *dev;
+	void (*next_priv_destructor)(struct net_device *dev);

 	struct napi_struct send_napi;
 	struct napi_struct recv_napi;
@@ -481,6 +482,7 @@ static inline void ipoib_put_ah(struct ipoib_ah *ah)
 	kref_put(&ah->ref, ipoib_free_ah);
 }
 int ipoib_open(struct net_device *dev);
+void ipoib_intf_free(struct net_device *dev);
 int ipoib_add_pkey_attr(struct net_device *dev);
 int ipoib_add_umcast_attr(struct net_device *dev);

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 67ab52eec3e9..73d917d57f93 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2062,6 +2062,13 @@ void ipoib_setup_common(struct net_device *dev)
 	netif_keep_dst(dev);

 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
+
+	/*
+	 * unregister_netdev always frees the netdev, we use this mode
+	 * consistently to unify all the various unregister paths, including
+	 * those connected to rtnl_link_ops which require it.
+	 */
+	dev->needs_free_netdev = true;
 }

 static void ipoib_build_priv(struct net_device *dev)
@@ -2116,9 +2123,7 @@ static struct net_device
 	rn->send = ipoib_send;
 	rn->attach_mcast = ipoib_mcast_attach;
 	rn->detach_mcast = ipoib_mcast_detach;
-	rn->free_rdma_netdev = free_netdev;
 	rn->hca = hca;
-
 	dev->netdev_ops = &ipoib_netdev_default_pf;

 	return dev;
@@ -2173,6 +2178,15 @@ struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,

 	rn = netdev_priv(dev);
 	rn->clnt_priv = priv;
+
+	/*
+	 * Only the child register_netdev flows can handle priv_destructor
+	 * being set, so we force it to NULL here and handle manually until it
+	 * is safe to turn on.
+	 */
+	priv->next_priv_destructor = dev->priv_destructor;
+	dev->priv_destructor = NULL;
+
 	ipoib_build_priv(dev);

 	return priv;
@@ -2181,6 +2195,27 @@ struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
 	return NULL;
 }

+void ipoib_intf_free(struct net_device *dev)
+{
+	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	struct rdma_netdev *rn = netdev_priv(dev);
+
+	dev->priv_destructor = priv->next_priv_destructor;
+	if (dev->priv_destructor)
+		dev->priv_destructor(dev);
+
+	/*
+	 * There are some error flows around register_netdev failing that may
+	 * attempt to call priv_destructor twice, prevent that from happening.
+	 */
+	dev->priv_destructor = NULL;
+
+	/* unregister/destroy is very complicated. Make bugs more obvious. */
+	rn->clnt_priv = NULL;
+
+	kfree(priv);
+}
+
 static ssize_t show_pkey(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
@@ -2341,7 +2376,7 @@ static struct net_device *ipoib_add_port(const char *format,
 					 struct ib_device *hca, u8 port)
 {
 	struct ipoib_dev_priv *priv;
-	struct rdma_netdev *rn;
+	struct net_device *ndev;
 	int result;

 	priv = ipoib_intf_alloc(hca, port, format);
@@ -2349,6 +2384,7 @@ static struct net_device *ipoib_add_port(const char *format,
 		pr_warn("%s, %d: ipoib_intf_alloc failed\n", hca->name, port);
 		return ERR_PTR(-ENOMEM);
 	}
+	ndev = priv->dev;

 	INIT_IB_EVENT_HANDLER(&priv->event_handler,
 			      priv->ca, ipoib_event);
@@ -2357,38 +2393,43 @@ static struct net_device *ipoib_add_port(const char *format,
 	/* call event handler to ensure pkey in sync */
 	queue_work(ipoib_workqueue, &priv->flush_heavy);

-	result = register_netdev(priv->dev);
+	result = register_netdev(ndev);
 	if (result) {
 		pr_warn("%s: couldn't register ipoib port %d; error %d\n",
 			hca->name, port, result);
-		ipoib_parent_unregister_pre(priv->dev);
-		goto device_init_failed;
+
+		ipoib_parent_unregister_pre(ndev);
+		ipoib_intf_free(ndev);
+		free_netdev(ndev);
+
+		return ERR_PTR(result);
 	}

-	result = -ENOMEM;
-	if (ipoib_cm_add_mode_attr(priv->dev))
+	/*
+	 * We cannot set priv_destructor before register_netdev because we
+	 * need priv to be always valid during the error flow to execute
+	 * ipoib_parent_unregister_pre(). Instead handle it manually and only
+	 * enter priv_destructor mode once we are completely registered.
+	 */
+	ndev->priv_destructor = ipoib_intf_free;
+
+	if (ipoib_cm_add_mode_attr(ndev))
 		goto sysfs_failed;
-	if (ipoib_add_pkey_attr(priv->dev))
+	if (ipoib_add_pkey_attr(ndev))
 		goto sysfs_failed;
-	if (ipoib_add_umcast_attr(priv->dev))
+	if (ipoib_add_umcast_attr(ndev))
 		goto sysfs_failed;
-	if (device_create_file(&priv->dev->dev, &dev_attr_create_child))
+	if (device_create_file(&ndev->dev, &dev_attr_create_child))
 		goto sysfs_failed;
-	if (device_create_file(&priv->dev->dev, &dev_attr_delete_child))
+	if (device_create_file(&ndev->dev, &dev_attr_delete_child))
 		goto sysfs_failed;

-	return priv->dev;
+	return ndev;

 sysfs_failed:
-	ipoib_parent_unregister_pre(priv->dev);
-	unregister_netdev(priv->dev);
-
-device_init_failed:
-	rn = netdev_priv(priv->dev);
-	rn->free_rdma_netdev(priv->dev);
-	kfree(priv);
-
-	return ERR_PTR(result);
+	ipoib_parent_unregister_pre(ndev);
+	unregister_netdev(ndev);
+	return ERR_PTR(-ENOMEM);
 }

 static void ipoib_add_one(struct ib_device *device)
@@ -2426,33 +2467,19 @@ static void ipoib_add_one(struct ib_device *device)

 static void ipoib_remove_one(struct ib_device *device, void *client_data)
 {
-	struct ipoib_dev_priv *priv, *tmp, *cpriv, *tcpriv;
+	struct ipoib_dev_priv *priv, *tmp;
 	struct list_head *dev_list = client_data;

 	if (!dev_list)
 		return;

 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
-		struct rdma_netdev *parent_rn = netdev_priv(priv->dev);
-
 		ipoib_parent_unregister_pre(priv->dev);

 		/* Wrap rtnl_lock/unlock with mutex to protect sysfs calls */
 		mutex_lock(&priv->sysfs_mutex);
 		unregister_netdev(priv->dev);
 		mutex_unlock(&priv->sysfs_mutex);
-
-		parent_rn->free_rdma_netdev(priv->dev);
-
-		list_for_each_entry_safe(cpriv, tcpriv, &priv->child_intfs, list) {
-			struct rdma_netdev *child_rn;
-
-			child_rn = netdev_priv(cpriv->dev);
-			child_rn->free_rdma_netdev(cpriv->dev);
-			kfree(cpriv);
-		}
-
-		kfree(priv);
 	}

 	kfree(dev_list);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
index 3103729a73fd..7776334cf8c5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
@@ -50,31 +50,53 @@ static ssize_t show_parent(struct device *d, struct device_attribute *attr,
 }
 static DEVICE_ATTR(parent, S_IRUGO, show_parent, NULL);

+/*
+ * NOTE: If this function fails then the priv->dev will remain valid, however
+ * priv can have been freed and must not be touched by caller in the error
+ * case.
+ *
+ * If (ndev->reg_state == NETREG_UNINITIALIZED) then it is up to the caller to
+ * free the net_device (just as rtnl_newlink does) otherwise the net_device
+ * will be freed when the rtnl is unlocked.
+ */
 int __ipoib_vlan_add(struct ipoib_dev_priv *ppriv, struct ipoib_dev_priv *priv,
 		     u16 pkey, int type)
 {
+	struct net_device *ndev = priv->dev;
 	int result;

+	ASSERT_RTNL();
+
 	priv->parent = ppriv->dev;
 	priv->pkey = pkey;
 	priv->child_type = type;

-	result = register_netdevice(priv->dev);
+	/* We do not need to touch priv if register_netdevice fails */
+	ndev->priv_destructor = ipoib_intf_free;
+
+	result = register_netdevice(ndev);
 	if (result) {
 		ipoib_warn(priv, "failed to initialize; error %i", result);
+
+		/*
+		 * register_netdevice sometimes calls priv_destructor,
+		 * sometimes not. Make sure it was done.
+		 */
+		if (ndev->priv_destructor)
+			ndev->priv_destructor(ndev);
 		return result;
 	}

 	/* RTNL childs don't need proprietary sysfs entries */
 	if (type == IPOIB_LEGACY_CHILD) {
-		if (ipoib_cm_add_mode_attr(priv->dev))
+		if (ipoib_cm_add_mode_attr(ndev))
 			goto sysfs_failed;
-		if (ipoib_add_pkey_attr(priv->dev))
+		if (ipoib_add_pkey_attr(ndev))
 			goto sysfs_failed;
-		if (ipoib_add_umcast_attr(priv->dev))
+		if (ipoib_add_umcast_attr(ndev))
 			goto sysfs_failed;

-		if (device_create_file(&priv->dev->dev, &dev_attr_parent))
+		if (device_create_file(&ndev->dev, &dev_attr_parent))
 			goto sysfs_failed;
 	}

@@ -91,6 +113,7 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 {
 	struct ipoib_dev_priv *ppriv, *priv;
 	char intf_name[IFNAMSIZ];
+	struct net_device *ndev;
 	struct ipoib_dev_priv *tpriv;
 	int result;

@@ -122,12 +145,6 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		return restart_syscall();
 	}

-	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
-	if (!priv) {
-		result = -ENOMEM;
-		goto out;
-	}
-
 	/*
 	 * First ensure this isn't a duplicate. We check the parent device and
 	 * then all of the legacy child interfaces to make sure the Pkey
@@ -146,21 +163,23 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
 		}
 	}

+	priv = ipoib_intf_alloc(ppriv->ca, ppriv->port, intf_name);
+	if (!priv) {
+		result = -ENOMEM;
+		goto out;
+	}
+	ndev = priv->dev;
+
 	result = __ipoib_vlan_add(ppriv, priv, pkey, IPOIB_LEGACY_CHILD);

+	if (result && ndev->reg_state == NETREG_UNINITIALIZED)
+		free_netdev(ndev);
+
 out:
 	up_write(&ppriv->vlan_rwsem);
 	rtnl_unlock();
 	mutex_unlock(&ppriv->sysfs_mutex);

-	if (result && priv) {
-		struct rdma_netdev *rn;
-
-		rn = netdev_priv(priv->dev);
-		rn->free_rdma_netdev(priv->dev);
-		kfree(priv);
-	}
-
 	return result;
 }

@@ -212,14 +231,5 @@ int ipoib_vlan_delete(struct net_device *pdev, unsigned short pkey)
 	rtnl_unlock();
 	mutex_unlock(&ppriv->sysfs_mutex);

-	if (dev) {
-		struct rdma_netdev *rn;
-
-		rn = netdev_priv(dev);
-		rn->free_rdma_netdev(priv->dev);
-		kfree(priv);
-		return 0;
-	}
-
-	return -ENODEV;
+	return (dev) ? 0 : -ENODEV;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index af3bb2f7a504..b8d150d2fd72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -580,6 +580,22 @@ static int mlx5i_check_required_hca_cap(struct mlx5_core_dev *mdev)
 	return 0;
 }

+static void mlx5_rdma_netdev_free(struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
+	struct mlx5i_priv *ipriv = priv->ppriv;
+	const struct mlx5e_profile *profile = priv->profile;
+
+	mlx5e_detach_netdev(priv);
+	profile->cleanup(priv);
+	destroy_workqueue(priv->wq);
+
+	if (!ipriv->sub_interface) {
+		mlx5i_pkey_qpn_ht_cleanup(netdev);
+		mlx5e_destroy_mdev_resources(priv->mdev);
+	}
+}
+
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 					  struct ib_device *ibdev,
 					  const char *name,
@@ -653,6 +669,9 @@ struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 	rn->detach_mcast = mlx5i_detach_mcast;
 	rn->set_id = mlx5i_set_pkey_index;

+	netdev->priv_destructor = mlx5_rdma_netdev_free;
+	netdev->needs_free_netdev = 1;
+
 	return netdev;

 destroy_ht:
@@ -665,21 +684,3 @@ struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 	return NULL;
 }
 EXPORT_SYMBOL(mlx5_rdma_netdev_alloc);
-
-void mlx5_rdma_netdev_free(struct net_device *netdev)
-{
-	struct mlx5e_priv *priv = mlx5i_epriv(netdev);
-	struct mlx5i_priv *ipriv = priv->ppriv;
-	const struct mlx5e_profile *profile = priv->profile;
-
-	mlx5e_detach_netdev(priv);
-	profile->cleanup(priv);
-	destroy_workqueue(priv->wq);
-
-	if (!ipriv->sub_interface) {
-		mlx5i_pkey_qpn_ht_cleanup(netdev);
-		mlx5e_destroy_mdev_resources(priv->mdev);
-	}
-	free_netdev(netdev);
-}
-EXPORT_SYMBOL(mlx5_rdma_netdev_free);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0c1beb14837b..789489e3aa76 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1218,14 +1218,11 @@ struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
-
-static inline void mlx5_rdma_netdev_free(struct net_device *netdev) {}
 #else
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 					  struct ib_device *ibdev,
 					  const char *name,
 					  void (*setup)(struct net_device *));
-void mlx5_rdma_netdev_free(struct net_device *netdev);
 #endif /* CONFIG_MLX5_CORE_IPOIB */

 struct mlx5_profile {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 42cbf8eabe9d..73c780c99482 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2202,7 +2202,11 @@ struct rdma_netdev {
 	struct ib_device  *hca;
 	u8                 port_num;

-	/* cleanup function must be specified */
+	/*
+	 * cleanup function must be specified.
+	 * FIXME: This is only used for OPA_VNIC and that usage should be
+	 * removed too.
+	 */
 	void (*free_rdma_netdev)(struct net_device *netdev);

 	/* control functions */
