From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/7] RDMA/netdev: Hoist alloc_netdev_mqs out of the driver
Date: Wed, 10 Oct 2018 18:24:38 -0700
Message-ID: <20181011012444.28194-2-saeedm@mellanox.com>
References: <20181011012444.28194-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181011012444.28194-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Denis Drozdov <denisd@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Denis Drozdov <denisd@mellanox.com>

netdev has several interfaces that expect to call alloc_netdev_mqs from
the core code, with the driver only providing the arguments.  This is
incompatible with the rdma_netdev interface that returns the netdev
directly.

Thus re-organize the API used by ipoib so that the verbs core code calls
alloc_netdev_mqs for the driver. This is done by allowing the drivers to
provide the allocation parameters via a 'get_params' callback and then
initializing an allocated netdev as a second step.

Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Denis Drozdov <denisd@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/core/verbs.c               | 32 +++++++
 drivers/infiniband/hw/mlx5/main.c             | 23 ++---
 drivers/infiniband/ulp/ipoib/ipoib_main.c     | 21 ++---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 87 ++++++++++---------
 include/linux/mlx5/driver.h                   | 14 +--
 include/rdma/ib_verbs.h                       | 23 ++++-
 6 files changed, 119 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6ee03d6089eb..2f34d3412097 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2621,3 +2621,35 @@ void ib_drain_qp(struct ib_qp *qp)
 		ib_drain_rq(qp);
 }
 EXPORT_SYMBOL(ib_drain_qp);
+
+struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
+				     enum rdma_netdev_t type, const char *name,
+				     unsigned char name_assign_type,
+				     void (*setup)(struct net_device *))
+{
+	struct rdma_netdev_alloc_params params;
+	struct net_device *netdev;
+	int rc;
+
+	if (!device->rdma_netdev_get_params)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	rc = device->rdma_netdev_get_params(device, port_num, type, &params);
+	if (rc)
+		return ERR_PTR(rc);
+
+	netdev = alloc_netdev_mqs(params.sizeof_priv, name, name_assign_type,
+				  setup, params.txqs, params.rxqs);
+	if (!netdev)
+		return ERR_PTR(-ENOMEM);
+
+	rc = params.initialize_rdma_netdev(device, port_num, netdev,
+					   params.param);
+	if (rc) {
+		free_netdev(netdev);
+		return ERR_PTR(rc);
+	}
+
+	return netdev;
+}
+EXPORT_SYMBOL(rdma_alloc_netdev);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c414f3809e5c..5d9b7f62a0ba 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5163,22 +5163,14 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	return num_counters;
 }
 
-static struct net_device*
-mlx5_ib_alloc_rdma_netdev(struct ib_device *hca,
-			  u8 port_num,
-			  enum rdma_netdev_t type,
-			  const char *name,
-			  unsigned char name_assign_type,
-			  void (*setup)(struct net_device *))
+static int mlx5_ib_rn_get_params(struct ib_device *device, u8 port_num,
+				 enum rdma_netdev_t type,
+				 struct rdma_netdev_alloc_params *params)
 {
-	struct net_device *netdev;
-
 	if (type != RDMA_NETDEV_IPOIB)
-		return ERR_PTR(-EOPNOTSUPP);
+		return -EOPNOTSUPP;
 
-	netdev = mlx5_rdma_netdev_alloc(to_mdev(hca)->mdev, hca,
-					name, setup);
-	return netdev;
+	return mlx5_rdma_rn_get_params(to_mdev(device)->mdev, device, params);
 }
 
 static void delay_drop_debugfs_cleanup(struct mlx5_ib_dev *dev)
@@ -5824,8 +5816,9 @@ int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
 	dev->ib_dev.get_vector_affinity	= mlx5_ib_get_vector_affinity;
-	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads))
-		dev->ib_dev.alloc_rdma_netdev	= mlx5_ib_alloc_rdma_netdev;
+	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads) &&
+	    IS_ENABLED(CONFIG_MLX5_CORE_IPOIB))
+		dev->ib_dev.rdma_netdev_get_params = mlx5_ib_rn_get_params;
 
 	if (mlx5_core_is_pf(mdev)) {
 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e3d28f9ad9c0..9c816cd41724 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2146,20 +2146,15 @@ static struct net_device *ipoib_get_netdev(struct ib_device *hca, u8 port,
 {
 	struct net_device *dev;
 
-	if (hca->alloc_rdma_netdev) {
-		dev = hca->alloc_rdma_netdev(hca, port,
-					     RDMA_NETDEV_IPOIB, name,
-					     NET_NAME_UNKNOWN,
-					     ipoib_setup_common);
-		if (IS_ERR_OR_NULL(dev) && PTR_ERR(dev) != -EOPNOTSUPP)
-			return NULL;
-	}
-
-	if (!hca->alloc_rdma_netdev || PTR_ERR(dev) == -EOPNOTSUPP)
-		dev = ipoib_create_netdev_default(hca, name, NET_NAME_UNKNOWN,
-						  ipoib_setup_common);
+	dev = rdma_alloc_netdev(hca, port, RDMA_NETDEV_IPOIB, name,
+				NET_NAME_UNKNOWN, ipoib_setup_common);
+	if (!IS_ERR(dev))
+		return dev;
+	if (PTR_ERR(dev) != -EOPNOTSUPP)
+		return NULL;
 
-	return dev;
+	return ipoib_create_netdev_default(hca, name, NET_NAME_UNKNOWN,
+					   ipoib_setup_common);
 }
 
 struct ipoib_dev_priv *ipoib_intf_alloc(struct ib_device *hca, u8 port,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 299e2a897f7e..af1a95f80404 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -658,53 +658,36 @@ static void mlx5_rdma_netdev_free(struct net_device *netdev)
 	}
 }
 
-struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
-					  struct ib_device *ibdev,
-					  const char *name,
-					  void (*setup)(struct net_device *))
+static bool mlx5_is_sub_interface(struct mlx5_core_dev *mdev)
 {
-	const struct mlx5e_profile *profile;
-	struct net_device *netdev;
+	return mdev->mlx5e_res.pdn != 0;
+}
+
+static const struct mlx5e_profile *mlx5_get_profile(struct mlx5_core_dev *mdev)
+{
+	if (mlx5_is_sub_interface(mdev))
+		return mlx5i_pkey_get_profile();
+	return &mlx5i_nic_profile;
+}
+
+static int mlx5_rdma_setup_rn(struct ib_device *ibdev, u8 port_num,
+			      struct net_device *netdev, void *param)
+{
+	struct mlx5_core_dev *mdev = (struct mlx5_core_dev *)param;
+	const struct mlx5e_profile *prof = mlx5_get_profile(mdev);
 	struct mlx5i_priv *ipriv;
 	struct mlx5e_priv *epriv;
 	struct rdma_netdev *rn;
-	bool sub_interface;
-	int nch;
 	int err;
 
-	if (mlx5i_check_required_hca_cap(mdev)) {
-		mlx5_core_warn(mdev, "Accelerated mode is not supported\n");
-		return ERR_PTR(-EOPNOTSUPP);
-	}
-
-	/* TODO: Need to find a better way to check if child device*/
-	sub_interface = (mdev->mlx5e_res.pdn != 0);
-
-	if (sub_interface)
-		profile = mlx5i_pkey_get_profile();
-	else
-		profile = &mlx5i_nic_profile;
-
-	nch = profile->max_nch(mdev);
-
-	netdev = alloc_netdev_mqs(sizeof(struct mlx5i_priv) + sizeof(struct mlx5e_priv),
-				  name, NET_NAME_UNKNOWN,
-				  setup,
-				  nch * MLX5E_MAX_NUM_TC,
-				  nch);
-	if (!netdev) {
-		mlx5_core_warn(mdev, "alloc_netdev_mqs failed\n");
-		return NULL;
-	}
-
 	ipriv = netdev_priv(netdev);
 	epriv = mlx5i_epriv(netdev);
 
 	epriv->wq = create_singlethread_workqueue("mlx5i");
 	if (!epriv->wq)
-		goto err_free_netdev;
+		return -ENOMEM;
 
-	ipriv->sub_interface = sub_interface;
+	ipriv->sub_interface = mlx5_is_sub_interface(mdev);
 	if (!ipriv->sub_interface) {
 		err = mlx5i_pkey_qpn_ht_init(netdev);
 		if (err) {
@@ -718,7 +701,7 @@ struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 			goto destroy_ht;
 	}
 
-	profile->init(mdev, netdev, profile, ipriv);
+	prof->init(mdev, netdev, prof, ipriv);
 
 	mlx5e_attach_netdev(epriv);
 	netif_carrier_off(netdev);
@@ -734,15 +717,37 @@ struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 	netdev->priv_destructor = mlx5_rdma_netdev_free;
 	netdev->needs_free_netdev = 1;
 
-	return netdev;
+	return 0;
 
 destroy_ht:
 	mlx5i_pkey_qpn_ht_cleanup(netdev);
 destroy_wq:
 	destroy_workqueue(epriv->wq);
-err_free_netdev:
-	free_netdev(netdev);
+	return err;
+}
+
+int mlx5_rdma_rn_get_params(struct mlx5_core_dev *mdev,
+			    struct ib_device *device,
+			    struct rdma_netdev_alloc_params *params)
+{
+	int nch;
+	int rc;
+
+	rc = mlx5i_check_required_hca_cap(mdev);
+	if (rc)
+		return rc;
 
-	return NULL;
+	nch = mlx5_get_profile(mdev)->max_nch(mdev);
+
+	*params = (struct rdma_netdev_alloc_params){
+		.sizeof_priv = sizeof(struct mlx5i_priv) +
+			       sizeof(struct mlx5e_priv),
+		.txqs = nch * MLX5E_MAX_NUM_TC,
+		.rxqs = nch,
+		.param = mdev,
+		.initialize_rdma_netdev = mlx5_rdma_setup_rn,
+	};
+
+	return 0;
 }
-EXPORT_SYMBOL(mlx5_rdma_netdev_alloc);
+EXPORT_SYMBOL(mlx5_rdma_rn_get_params);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 26a92462f4ce..4b75796cac23 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1228,21 +1228,15 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
 
-#ifndef CONFIG_MLX5_CORE_IPOIB
-static inline
-struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
-					  struct ib_device *ibdev,
-					  const char *name,
-					  void (*setup)(struct net_device *))
-{
-	return ERR_PTR(-EOPNOTSUPP);
-}
-#else
+#ifdef CONFIG_MLX5_CORE_IPOIB
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 					  struct ib_device *ibdev,
 					  const char *name,
 					  void (*setup)(struct net_device *));
 #endif /* CONFIG_MLX5_CORE_IPOIB */
+int mlx5_rdma_rn_get_params(struct mlx5_core_dev *mdev,
+			    struct ib_device *device,
+			    struct rdma_netdev_alloc_params *params);
 
 struct mlx5_profile {
 	u64	mask;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e950c2a68f06..020216cee8f1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2223,6 +2223,16 @@ struct rdma_netdev {
 			    union ib_gid *gid, u16 mlid);
 };
 
+struct rdma_netdev_alloc_params {
+	size_t sizeof_priv;
+	unsigned int txqs;
+	unsigned int rxqs;
+	void *param;
+
+	int (*initialize_rdma_netdev)(struct ib_device *device, u8 port_num,
+				      struct net_device *netdev, void *param);
+};
+
 struct ib_port_pkey_list {
 	/* Lock to hold while modifying the list. */
 	spinlock_t                    list_lock;
@@ -2523,8 +2533,8 @@ struct ib_device {
 	/**
 	 * rdma netdev operation
 	 *
-	 * Driver implementing alloc_rdma_netdev must return -EOPNOTSUPP if it
-	 * doesn't support the specified rdma netdev type.
+	 * Driver implementing alloc_rdma_netdev or rdma_netdev_get_params
+	 * must return -EOPNOTSUPP if it doesn't support the specified type.
 	 */
 	struct net_device *(*alloc_rdma_netdev)(
 					struct ib_device *device,
@@ -2534,6 +2544,10 @@ struct ib_device {
 					unsigned char name_assign_type,
 					void (*setup)(struct net_device *));
 
+	int (*rdma_netdev_get_params)(struct ib_device *device, u8 port_num,
+				      enum rdma_netdev_t type,
+				      struct rdma_netdev_alloc_params *params);
+
 	struct module               *owner;
 	struct device                dev;
 	struct kobject               *ports_parent;
@@ -4179,4 +4193,9 @@ struct ib_ucontext *ib_uverbs_get_ucontext(struct ib_uverbs_file *ufile);
 
 int uverbs_destroy_def_handler(struct ib_uverbs_file *file,
 			       struct uverbs_attr_bundle *attrs);
+
+struct net_device *rdma_alloc_netdev(struct ib_device *device, u8 port_num,
+				     enum rdma_netdev_t type, const char *name,
+				     unsigned char name_assign_type,
+				     void (*setup)(struct net_device *));
 #endif /* IB_VERBS_H */
-- 
2.17.1
