From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 06/14] {net,IB}/mlx5: Manage port association for multiport RoCE
Date: Thu,  4 Jan 2018 17:25:36 +0200
Message-ID: <20180104152544.28919-7-leon@kernel.org>
References: <20180104152544.28919-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104152544.28919-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When mlx5_ib_add is called determine if the mlx5 core device being
added is capable of dual port RoCE operation. If it is, determine
whether it is a master device or a slave device using the
num_vhca_ports and affiliate_nic_vport_criteria capabilities.

If the device is a slave, attempt to find a master device to affiliate it
with. Devices that can be affiliated will share a system image guid. If
none are found place it on a list of unaffiliated ports. If a master is
found bind the port to it by configuring the port affiliation in the NIC
vport context.

Similarly when mlx5_ib_remove is called determine the port type. If it's
a slave port, unaffiliate it from the master device, otherwise just
remove it from the unaffiliated port list.

The IB device is registered as a multiport device, even if a 2nd port is
not available for affiliation. When the 2nd port is affiliated later the
GID cache must be refreshed in order to get the default GIDs for the 2nd
port in the cache. Export roce_rescan_device to provide a mechanism to
refresh the cache after a new port is bound.

In a multiport configuration all IB object (QP, MR, PD, etc) related
commands should flow through the master mlx5_core_dev, other commands
must be sent to the slave port mlx5_core_mdev, an interface is provide
to get the correct mdev for non IB object commands.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cache.c                    |   2 +-
 drivers/infiniband/core/core_priv.h                |   1 -
 drivers/infiniband/core/roce_gid_mgmt.c            |  11 +-
 drivers/infiniband/hw/mlx5/main.c                  | 421 +++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  40 ++
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  58 +++
 include/linux/mlx5/driver.h                        |  22 +-
 include/linux/mlx5/mlx5_ifc.h                      |  31 +-
 include/linux/mlx5/vport.h                         |   4 +
 include/rdma/ib_verbs.h                            |   8 +
 12 files changed, 562 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index fc4022884dbb..e9a409d7f4e2 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -821,7 +821,7 @@ static int gid_table_setup_one(struct ib_device *ib_dev)
 	if (err)
 		return err;
 
-	roce_rescan_device(ib_dev);
+	rdma_roce_rescan_device(ib_dev);
 
 	return err;
 }
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 6b58267b64c6..833ea36e823b 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -138,7 +138,6 @@ int ib_cache_gid_del_all_netdev_gids(struct ib_device *ib_dev, u8 port,
 int roce_gid_mgmt_init(void);
 void roce_gid_mgmt_cleanup(void);
 
-void roce_rescan_device(struct ib_device *ib_dev);
 unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u8 port);
 
 int ib_cache_setup_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index ebfe45739ca7..5a52ec77940a 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -410,13 +410,18 @@ static void enum_all_gids_of_dev_cb(struct ib_device *ib_dev,
 	rtnl_unlock();
 }
 
-/* This function will rescan all of the network devices in the system
- * and add their gids, as needed, to the relevant RoCE devices. */
-void roce_rescan_device(struct ib_device *ib_dev)
+/**
+ * rdma_roce_rescan_device - Rescan all of the network devices in the system
+ * and add their gids, as needed, to the relevant RoCE devices.
+ *
+ * @device:         the rdma device
+ */
+void rdma_roce_rescan_device(struct ib_device *ib_dev)
 {
 	ib_enum_roce_netdev(ib_dev, pass_all_filter, NULL,
 			    enum_all_gids_of_dev_cb, NULL);
 }
+EXPORT_SYMBOL(rdma_roce_rescan_device);
 
 static void callback_for_addr_gid_device_scan(struct ib_device *device,
 					      u8 port,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5fcb2ed94c11..4fbbe4c7a99b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -74,6 +74,23 @@ enum {
 	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
 };
 
+static LIST_HEAD(mlx5_ib_unaffiliated_port_list);
+static LIST_HEAD(mlx5_ib_dev_list);
+/*
+ * This mutex should be held when accessing either of the above lists
+ */
+static DEFINE_MUTEX(mlx5_ib_multiport_mutex);
+
+struct mlx5_ib_dev *mlx5_ib_get_ibdev_from_mpi(struct mlx5_ib_multiport_info *mpi)
+{
+	struct mlx5_ib_dev *dev;
+
+	mutex_lock(&mlx5_ib_multiport_mutex);
+	dev = mpi->ibdev;
+	mutex_unlock(&mlx5_ib_multiport_mutex);
+	return dev;
+}
+
 static enum rdma_link_layer
 mlx5_port_type_cap_to_rdma_ll(int port_type_cap)
 {
@@ -120,7 +137,9 @@ static int mlx5_netdev_event(struct notifier_block *this,
 	struct mlx5_ib_dev *ibdev;
 
 	ibdev = roce->dev;
-	mdev = ibdev->mdev;
+	mdev = mlx5_ib_get_native_port_mdev(ibdev, port_num, NULL);
+	if (!mdev)
+		return NOTIFY_DONE;
 
 	switch (event) {
 	case NETDEV_REGISTER:
@@ -175,6 +194,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
 		break;
 	}
 done:
+	mlx5_ib_put_native_port_mdev(ibdev, port_num);
 	return NOTIFY_DONE;
 }
 
@@ -183,10 +203,15 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 {
 	struct mlx5_ib_dev *ibdev = to_mdev(device);
 	struct net_device *ndev;
+	struct mlx5_core_dev *mdev;
+
+	mdev = mlx5_ib_get_native_port_mdev(ibdev, port_num, NULL);
+	if (!mdev)
+		return NULL;
 
-	ndev = mlx5_lag_get_roce_netdev(ibdev->mdev);
+	ndev = mlx5_lag_get_roce_netdev(mdev);
 	if (ndev)
-		return ndev;
+		goto out;
 
 	/* Ensure ndev does not disappear before we invoke dev_hold()
 	 */
@@ -196,9 +221,70 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 		dev_hold(ndev);
 	read_unlock(&ibdev->roce[port_num - 1].netdev_lock);
 
+out:
+	mlx5_ib_put_native_port_mdev(ibdev, port_num);
 	return ndev;
 }
 
+struct mlx5_core_dev *mlx5_ib_get_native_port_mdev(struct mlx5_ib_dev *ibdev,
+						   u8 ib_port_num,
+						   u8 *native_port_num)
+{
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&ibdev->ib_dev,
+							  ib_port_num);
+	struct mlx5_core_dev *mdev = NULL;
+	struct mlx5_ib_multiport_info *mpi;
+	struct mlx5_ib_port *port;
+
+	if (native_port_num)
+		*native_port_num = 1;
+
+	if (!mlx5_core_mp_enabled(ibdev->mdev) || ll != IB_LINK_LAYER_ETHERNET)
+		return ibdev->mdev;
+
+	port = &ibdev->port[ib_port_num - 1];
+	if (!port)
+		return NULL;
+
+	spin_lock(&port->mp.mpi_lock);
+	mpi = ibdev->port[ib_port_num - 1].mp.mpi;
+	if (mpi && !mpi->unaffiliate) {
+		mdev = mpi->mdev;
+		/* If it's the master no need to refcount, it'll exist
+		 * as long as the ib_dev exists.
+		 */
+		if (!mpi->is_master)
+			mpi->mdev_refcnt++;
+	}
+	spin_unlock(&port->mp.mpi_lock);
+
+	return mdev;
+}
+
+void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *ibdev, u8 port_num)
+{
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&ibdev->ib_dev,
+							  port_num);
+	struct mlx5_ib_multiport_info *mpi;
+	struct mlx5_ib_port *port;
+
+	if (!mlx5_core_mp_enabled(ibdev->mdev) || ll != IB_LINK_LAYER_ETHERNET)
+		return;
+
+	port = &ibdev->port[port_num - 1];
+
+	spin_lock(&port->mp.mpi_lock);
+	mpi = ibdev->port[port_num - 1].mp.mpi;
+	if (mpi->is_master)
+		goto out;
+
+	mpi->mdev_refcnt--;
+	if (mpi->unaffiliate)
+		complete(&mpi->unref_comp);
+out:
+	spin_unlock(&port->mp.mpi_lock);
+}
+
 static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
 				    u8 *active_width)
 {
@@ -3160,12 +3246,11 @@ static void get_ext_port_caps(struct mlx5_ib_dev *dev)
 		mlx5_query_ext_port_caps(dev, port);
 }
 
-static int get_port_caps(struct mlx5_ib_dev *dev)
+static int get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 {
 	struct ib_device_attr *dprops = NULL;
 	struct ib_port_attr *pprops = NULL;
 	int err = -ENOMEM;
-	int port;
 	struct ib_udata uhw = {.inlen = 0, .outlen = 0};
 
 	pprops = kmalloc(sizeof(*pprops), GFP_KERNEL);
@@ -3186,22 +3271,21 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
 		goto out;
 	}
 
-	for (port = 1; port <= dev->num_ports; port++) {
-		memset(pprops, 0, sizeof(*pprops));
-		err = mlx5_ib_query_port(&dev->ib_dev, port, pprops);
-		if (err) {
-			mlx5_ib_warn(dev, "query_port %d failed %d\n",
-				     port, err);
-			break;
-		}
-		dev->mdev->port_caps[port - 1].pkey_table_len =
-						dprops->max_pkeys;
-		dev->mdev->port_caps[port - 1].gid_table_len =
-						pprops->gid_tbl_len;
-		mlx5_ib_dbg(dev, "pkey_table_len %d, gid_table_len %d\n",
-			    dprops->max_pkeys, pprops->gid_tbl_len);
+	memset(pprops, 0, sizeof(*pprops));
+	err = mlx5_ib_query_port(&dev->ib_dev, port, pprops);
+	if (err) {
+		mlx5_ib_warn(dev, "query_port %d failed %d\n",
+			     port, err);
+		goto out;
 	}
 
+	dev->mdev->port_caps[port - 1].pkey_table_len =
+					dprops->max_pkeys;
+	dev->mdev->port_caps[port - 1].gid_table_len =
+					pprops->gid_tbl_len;
+	mlx5_ib_dbg(dev, "port %d: pkey_table_len %d, gid_table_len %d\n",
+		    port, dprops->max_pkeys, pprops->gid_tbl_len);
+
 out:
 	kfree(pprops);
 	kfree(dprops);
@@ -4054,8 +4138,203 @@ mlx5_ib_get_vector_affinity(struct ib_device *ibdev, int comp_vector)
 	return mlx5_get_vector_affinity(dev->mdev, comp_vector);
 }
 
+/* The mlx5_ib_multiport_mutex should be held when calling this function */
+static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
+				      struct mlx5_ib_multiport_info *mpi)
+{
+	u8 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
+	struct mlx5_ib_port *port = &ibdev->port[port_num];
+	int comps;
+	int err;
+	int i;
+
+	spin_lock(&port->mp.mpi_lock);
+	if (!mpi->ibdev) {
+		spin_unlock(&port->mp.mpi_lock);
+		return;
+	}
+	mpi->ibdev = NULL;
+
+	spin_unlock(&port->mp.mpi_lock);
+	mlx5_remove_netdev_notifier(ibdev, port_num);
+	spin_lock(&port->mp.mpi_lock);
+
+	comps = mpi->mdev_refcnt;
+	if (comps) {
+		mpi->unaffiliate = true;
+		init_completion(&mpi->unref_comp);
+		spin_unlock(&port->mp.mpi_lock);
+
+		for (i = 0; i < comps; i++)
+			wait_for_completion(&mpi->unref_comp);
+
+		spin_lock(&port->mp.mpi_lock);
+		mpi->unaffiliate = false;
+	}
+
+	port->mp.mpi = NULL;
+
+	list_add_tail(&mpi->list, &mlx5_ib_unaffiliated_port_list);
+
+	spin_unlock(&port->mp.mpi_lock);
+
+	err = mlx5_nic_vport_unaffiliate_multiport(mpi->mdev);
+
+	mlx5_ib_dbg(ibdev, "unaffiliated port %d\n", port_num + 1);
+	/* Log an error, still needed to cleanup the pointers and add
+	 * it back to the list.
+	 */
+	if (err)
+		mlx5_ib_err(ibdev, "Failed to unaffiliate port %u\n",
+			    port_num + 1);
+
+	ibdev->roce[port_num].last_port_state = IB_PORT_DOWN;
+}
+
+/* The mlx5_ib_multiport_mutex should be held when calling this function */
+static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
+				    struct mlx5_ib_multiport_info *mpi)
+{
+	u8 port_num = mlx5_core_native_port_num(mpi->mdev) - 1;
+	int err;
+
+	spin_lock(&ibdev->port[port_num].mp.mpi_lock);
+	if (ibdev->port[port_num].mp.mpi) {
+		mlx5_ib_warn(ibdev, "port %d already affiliated.\n",
+			     port_num + 1);
+		spin_unlock(&ibdev->port[port_num].mp.mpi_lock);
+		return false;
+	}
+
+	ibdev->port[port_num].mp.mpi = mpi;
+	mpi->ibdev = ibdev;
+	spin_unlock(&ibdev->port[port_num].mp.mpi_lock);
+
+	err = mlx5_nic_vport_affiliate_multiport(ibdev->mdev, mpi->mdev);
+	if (err)
+		goto unbind;
+
+	err = get_port_caps(ibdev, mlx5_core_native_port_num(mpi->mdev));
+	if (err)
+		goto unbind;
+
+	err = mlx5_add_netdev_notifier(ibdev, port_num);
+	if (err) {
+		mlx5_ib_err(ibdev, "failed adding netdev notifier for port %u\n",
+			    port_num + 1);
+		goto unbind;
+	}
+
+	return true;
+
+unbind:
+	mlx5_ib_unbind_slave_port(ibdev, mpi);
+	return false;
+}
+
+static int mlx5_ib_init_multiport_master(struct mlx5_ib_dev *dev)
+{
+	int port_num = mlx5_core_native_port_num(dev->mdev) - 1;
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev,
+							  port_num + 1);
+	struct mlx5_ib_multiport_info *mpi;
+	int err;
+	int i;
+
+	if (!mlx5_core_is_mp_master(dev->mdev) || ll != IB_LINK_LAYER_ETHERNET)
+		return 0;
+
+	err = mlx5_query_nic_vport_system_image_guid(dev->mdev,
+						     &dev->sys_image_guid);
+	if (err)
+		return err;
+
+	err = mlx5_nic_vport_enable_roce(dev->mdev);
+	if (err)
+		return err;
+
+	mutex_lock(&mlx5_ib_multiport_mutex);
+	for (i = 0; i < dev->num_ports; i++) {
+		bool bound = false;
+
+		/* build a stub multiport info struct for the native port. */
+		if (i == port_num) {
+			mpi = kzalloc(sizeof(*mpi), GFP_KERNEL);
+			if (!mpi) {
+				mutex_unlock(&mlx5_ib_multiport_mutex);
+				mlx5_nic_vport_disable_roce(dev->mdev);
+				return -ENOMEM;
+			}
+
+			mpi->is_master = true;
+			mpi->mdev = dev->mdev;
+			mpi->sys_image_guid = dev->sys_image_guid;
+			dev->port[i].mp.mpi = mpi;
+			mpi->ibdev = dev;
+			mpi = NULL;
+			continue;
+		}
+
+		list_for_each_entry(mpi, &mlx5_ib_unaffiliated_port_list,
+				    list) {
+			if (dev->sys_image_guid == mpi->sys_image_guid &&
+			    (mlx5_core_native_port_num(mpi->mdev) - 1) == i) {
+				bound = mlx5_ib_bind_slave_port(dev, mpi);
+			}
+
+			if (bound) {
+				dev_dbg(&mpi->mdev->pdev->dev, "removing port from unaffiliated list.\n");
+				mlx5_ib_dbg(dev, "port %d bound\n", i + 1);
+				list_del(&mpi->list);
+				break;
+			}
+		}
+		if (!bound) {
+			get_port_caps(dev, i + 1);
+			mlx5_ib_dbg(dev, "no free port found for port %d\n",
+				    i + 1);
+		}
+	}
+
+	list_add_tail(&dev->ib_dev_list, &mlx5_ib_dev_list);
+	mutex_unlock(&mlx5_ib_multiport_mutex);
+	return err;
+}
+
+static void mlx5_ib_cleanup_multiport_master(struct mlx5_ib_dev *dev)
+{
+	int port_num = mlx5_core_native_port_num(dev->mdev) - 1;
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev,
+							  port_num + 1);
+	int i;
+
+	if (!mlx5_core_is_mp_master(dev->mdev) || ll != IB_LINK_LAYER_ETHERNET)
+		return;
+
+	mutex_lock(&mlx5_ib_multiport_mutex);
+	for (i = 0; i < dev->num_ports; i++) {
+		if (dev->port[i].mp.mpi) {
+			/* Destroy the native port stub */
+			if (i == port_num) {
+				kfree(dev->port[i].mp.mpi);
+				dev->port[i].mp.mpi = NULL;
+			} else {
+				mlx5_ib_dbg(dev, "unbinding port_num: %d\n", i + 1);
+				mlx5_ib_unbind_slave_port(dev, dev->port[i].mp.mpi);
+			}
+		}
+	}
+
+	mlx5_ib_dbg(dev, "removing from devlist\n");
+	list_del(&dev->ib_dev_list);
+	mutex_unlock(&mlx5_ib_multiport_mutex);
+
+	mlx5_nic_vport_disable_roce(dev->mdev);
+}
+
 static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
+	mlx5_ib_cleanup_multiport_master(dev);
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	cleanup_srcu_struct(&dev->mr_srcu);
 #endif
@@ -4067,16 +4346,36 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	const char *name;
 	int err;
+	int i;
 
 	dev->port = kcalloc(dev->num_ports, sizeof(*dev->port),
 			    GFP_KERNEL);
 	if (!dev->port)
 		return -ENOMEM;
 
-	err = get_port_caps(dev);
+	for (i = 0; i < dev->num_ports; i++) {
+		spin_lock_init(&dev->port[i].mp.mpi_lock);
+		rwlock_init(&dev->roce[i].netdev_lock);
+	}
+
+	err = mlx5_ib_init_multiport_master(dev);
 	if (err)
 		goto err_free_port;
 
+	if (!mlx5_core_mp_enabled(mdev)) {
+		int i;
+
+		for (i = 1; i <= dev->num_ports; i++) {
+			err = get_port_caps(dev, i);
+			if (err)
+				break;
+		}
+	} else {
+		err = get_port_caps(dev, mlx5_core_native_port_num(mdev));
+	}
+	if (err)
+		goto err_mp;
+
 	if (mlx5_use_mad_ifc(dev))
 		get_ext_port_caps(dev);
 
@@ -4106,6 +4405,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 #endif
 
 	return 0;
+err_mp:
+	mlx5_ib_cleanup_multiport_master(dev);
 
 err_free_port:
 	kfree(dev->port);
@@ -4252,16 +4553,16 @@ static int mlx5_ib_stage_roce_init(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
-	u8 port_num = 0;
+	u8 port_num;
 	int err;
 	int i;
 
+	port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
 		for (i = 0; i < dev->num_ports; i++) {
-			rwlock_init(&dev->roce[i].netdev_lock);
 			dev->roce[i].dev = dev;
 			dev->roce[i].native_port_num = i + 1;
 			dev->roce[i].last_port_state = IB_PORT_DOWN;
@@ -4292,8 +4593,9 @@ static void mlx5_ib_stage_roce_cleanup(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
-	u8 port_num = 0;
+	u8 port_num;
 
+	port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
@@ -4443,6 +4745,8 @@ static void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 	ib_dealloc_device((struct ib_device *)dev);
 }
 
+static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev, u8 port_num);
+
 static void *__mlx5_ib_add(struct mlx5_core_dev *mdev,
 			   const struct mlx5_ib_profile *profile)
 {
@@ -4457,7 +4761,8 @@ static void *__mlx5_ib_add(struct mlx5_core_dev *mdev,
 		return NULL;
 
 	dev->mdev = mdev;
-	dev->num_ports = MLX5_CAP_GEN(mdev, num_ports);
+	dev->num_ports = max(MLX5_CAP_GEN(mdev, num_ports),
+			     MLX5_CAP_GEN(mdev, num_vhca_ports));
 
 	for (i = 0; i < MLX5_IB_STAGE_MAX; i++) {
 		if (profile->stage[i].init) {
@@ -4520,15 +4825,81 @@ static const struct mlx5_ib_profile pf_profile = {
 		     NULL),
 };
 
+static void *mlx5_ib_add_slave_port(struct mlx5_core_dev *mdev, u8 port_num)
+{
+	struct mlx5_ib_multiport_info *mpi;
+	struct mlx5_ib_dev *dev;
+	bool bound = false;
+	int err;
+
+	mpi = kzalloc(sizeof(*mpi), GFP_KERNEL);
+	if (!mpi)
+		return NULL;
+
+	mpi->mdev = mdev;
+
+	err = mlx5_query_nic_vport_system_image_guid(mdev,
+						     &mpi->sys_image_guid);
+	if (err) {
+		kfree(mpi);
+		return NULL;
+	}
+
+	mutex_lock(&mlx5_ib_multiport_mutex);
+	list_for_each_entry(dev, &mlx5_ib_dev_list, ib_dev_list) {
+		if (dev->sys_image_guid == mpi->sys_image_guid)
+			bound = mlx5_ib_bind_slave_port(dev, mpi);
+
+		if (bound) {
+			rdma_roce_rescan_device(&dev->ib_dev);
+			break;
+		}
+	}
+
+	if (!bound) {
+		list_add_tail(&mpi->list, &mlx5_ib_unaffiliated_port_list);
+		dev_dbg(&mdev->pdev->dev, "no suitable IB device found to bind to, added to unaffiliated list.\n");
+	} else {
+		mlx5_ib_dbg(dev, "bound port %u\n", port_num + 1);
+	}
+	mutex_unlock(&mlx5_ib_multiport_mutex);
+
+	return mpi;
+}
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
+	enum rdma_link_layer ll;
+	int port_type_cap;
+
+	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
+	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
+
+	if (mlx5_core_is_mp_slave(mdev) && ll == IB_LINK_LAYER_ETHERNET) {
+		u8 port_num = mlx5_core_native_port_num(mdev) - 1;
+
+		return mlx5_ib_add_slave_port(mdev, port_num);
+	}
+
 	return __mlx5_ib_add(mdev, &pf_profile);
 }
 
 static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 {
-	struct mlx5_ib_dev *dev = context;
+	struct mlx5_ib_multiport_info *mpi;
+	struct mlx5_ib_dev *dev;
+
+	if (mlx5_core_is_mp_slave(mdev)) {
+		mpi = context;
+		mutex_lock(&mlx5_ib_multiport_mutex);
+		if (mpi->ibdev)
+			mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
+		list_del(&mpi->list);
+		mutex_unlock(&mlx5_ib_multiport_mutex);
+		return;
+	}
 
+	dev = context;
 	__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6106dde35144..e1667e72ad49 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -654,8 +654,17 @@ struct mlx5_ib_counters {
 	u16 set_id;
 };
 
+struct mlx5_ib_multiport_info;
+
+struct mlx5_ib_multiport {
+	struct mlx5_ib_multiport_info *mpi;
+	/* To be held when accessing the multiport info */
+	spinlock_t mpi_lock;
+};
+
 struct mlx5_ib_port {
 	struct mlx5_ib_counters cnts;
+	struct mlx5_ib_multiport mp;
 };
 
 struct mlx5_roce {
@@ -756,6 +765,29 @@ struct mlx5_ib_profile {
 	struct mlx5_ib_stage stage[MLX5_IB_STAGE_MAX];
 };
 
+struct mlx5_ib_odp {
+	struct ib_odp_caps	caps;
+	u64			max_size;
+	/*
+	 * Sleepable RCU that prevents destruction of MRs while they are still
+	 * being used by a page fault handler.
+	 */
+	struct srcu_struct      mr_srcu;
+	u32			null_mkey;
+	void			(*sync)(struct mlx5_ib_dev *dev);
+};
+
+struct mlx5_ib_multiport_info {
+	struct list_head list;
+	struct mlx5_ib_dev *ibdev;
+	struct mlx5_core_dev *mdev;
+	struct completion unref_comp;
+	u64 sys_image_guid;
+	u32 mdev_refcnt;
+	bool is_master;
+	bool unaffiliate;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -800,6 +832,8 @@ struct mlx5_ib_dev {
 	struct mutex		lb_mutex;
 	u32			user_td;
 	u8			umr_fence;
+	struct list_head	ib_dev_list;
+	u64			sys_image_guid;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
@@ -1071,6 +1105,12 @@ int mlx5_ib_generate_wc(struct ib_cq *ibcq, struct ib_wc *wc);
 
 void mlx5_ib_free_bfreg(struct mlx5_ib_dev *dev, struct mlx5_bfreg_info *bfregi,
 			int bfregn);
+struct mlx5_ib_dev *mlx5_ib_get_ibdev_from_mpi(struct mlx5_ib_multiport_info *mpi);
+struct mlx5_core_dev *mlx5_ib_get_native_port_mdev(struct mlx5_ib_dev *dev,
+						   u8 ib_port_num,
+						   u8 *native_port_num);
+void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *dev,
+				  u8 port_num);
 
 static inline void init_query_mad(struct ib_smp *mad)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index c4392f741c5f..c841b03c3e48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -688,7 +688,7 @@ static inline int mlx5_fpga_conn_init_qp(struct mlx5_fpga_conn *conn)
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_RC);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
 	MLX5_SET(qpc, qpc, primary_address_path.pkey_index, MLX5_FPGA_PKEY_INDEX);
-	MLX5_SET(qpc, qpc, primary_address_path.port, MLX5_FPGA_PORT_NUM);
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, MLX5_FPGA_PORT_NUM);
 	MLX5_SET(qpc, qpc, pd, conn->fdev->conn_res.pdn);
 	MLX5_SET(qpc, qpc, cqn_snd, conn->cq.mcq.cqn);
 	MLX5_SET(qpc, qpc, cqn_rcv, conn->cq.mcq.cqn);
@@ -727,7 +727,7 @@ static inline int mlx5_fpga_conn_rtr_qp(struct mlx5_fpga_conn *conn)
 	MLX5_SET(qpc, qpc, next_rcv_psn,
 		 MLX5_GET(fpga_qpc, conn->fpga_qpc, next_send_psn));
 	MLX5_SET(qpc, qpc, primary_address_path.pkey_index, MLX5_FPGA_PKEY_INDEX);
-	MLX5_SET(qpc, qpc, primary_address_path.port, MLX5_FPGA_PORT_NUM);
+	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, MLX5_FPGA_PORT_NUM);
 	ether_addr_copy(MLX5_ADDR_OF(qpc, qpc, primary_address_path.rmac_47_32),
 			MLX5_ADDR_OF(fpga_qpc, conn->fpga_qpc, fpga_mac_47_32));
 	MLX5_SET(qpc, qpc, primary_address_path.udp_sport,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index d2a66dc4adc6..261b95d014a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -187,7 +187,7 @@ int mlx5i_create_underlay_qp(struct mlx5_core_dev *mdev, struct mlx5_core_qp *qp
 		 MLX5_QP_ENHANCED_ULP_STATELESS_MODE);
 
 	addr_path = MLX5_ADDR_OF(qpc, qpc, primary_address_path);
-	MLX5_SET(ads, addr_path, port, 1);
+	MLX5_SET(ads, addr_path, vhca_port_num, 1);
 	MLX5_SET(ads, addr_path, grh, 1);
 
 	ret = mlx5_core_create_qp(mdev, qp, in, inlen);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 916523103f16..9cb939b6a859 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1121,3 +1121,61 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_modify_hca_vport_context);
+
+int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
+				       struct mlx5_core_dev *port_mdev)
+{
+	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
+	void *in;
+	int err;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	err = mlx5_nic_vport_enable_roce(port_mdev);
+	if (err)
+		goto free;
+
+	MLX5_SET(modify_nic_vport_context_in, in, field_select.affiliation, 1);
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 nic_vport_context.affiliated_vhca_id,
+		 MLX5_CAP_GEN(master_mdev, vhca_id));
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 nic_vport_context.affiliation_criteria,
+		 MLX5_CAP_GEN(port_mdev, affiliate_nic_vport_criteria));
+
+	err = mlx5_modify_nic_vport_context(port_mdev, in, inlen);
+	if (err)
+		mlx5_nic_vport_disable_roce(port_mdev);
+
+free:
+	kvfree(in);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_nic_vport_affiliate_multiport);
+
+int mlx5_nic_vport_unaffiliate_multiport(struct mlx5_core_dev *port_mdev)
+{
+	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
+	void *in;
+	int err;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_nic_vport_context_in, in, field_select.affiliation, 1);
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 nic_vport_context.affiliated_vhca_id, 0);
+	MLX5_SET(modify_nic_vport_context_in, in,
+		 nic_vport_context.affiliation_criteria, 0);
+
+	err = mlx5_modify_nic_vport_context(port_mdev, in, inlen);
+	if (!err)
+		mlx5_nic_vport_disable_roce(port_mdev);
+
+	kvfree(in);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mlx5_nic_vport_unaffiliate_multiport);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 28733529f6ff..d5c787519e06 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1234,9 +1234,29 @@ static inline bool mlx5_rl_is_supported(struct mlx5_core_dev *dev)
 	return !!(dev->priv.rl_table.max_size);
 }
 
+static inline int mlx5_core_is_mp_slave(struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, affiliate_nic_vport_criteria) &&
+	       MLX5_CAP_GEN(dev, num_vhca_ports) <= 1;
+}
+
+static inline int mlx5_core_is_mp_master(struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, num_vhca_ports) > 1;
+}
+
+static inline int mlx5_core_mp_enabled(struct mlx5_core_dev *dev)
+{
+	return mlx5_core_is_mp_slave(dev) ||
+	       mlx5_core_is_mp_master(dev);
+}
+
 static inline int mlx5_core_native_port_num(struct mlx5_core_dev *dev)
 {
-	return 1;
+	if (!mlx5_core_mp_enabled(dev))
+		return 1;
+
+	return MLX5_CAP_GEN(dev, native_port_num);
 }
 
 enum {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b1c81d7a86cb..7e88c8e7f374 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -502,7 +502,7 @@ struct mlx5_ifc_ads_bits {
 	u8         dei_cfi[0x1];
 	u8         eth_prio[0x3];
 	u8         sl[0x4];
-	u8         port[0x8];
+	u8         vhca_port_num[0x8];
 	u8         rmac_47_32[0x10];
 
 	u8         rmac_31_0[0x20];
@@ -794,7 +794,10 @@ enum {
 };
 
 struct mlx5_ifc_cmd_hca_cap_bits {
-	u8         reserved_at_0[0x80];
+	u8         reserved_at_0[0x30];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_40[0x40];
 
 	u8         log_max_srq_sz[0x8];
 	u8         log_max_qp_sz[0x8];
@@ -1066,8 +1069,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_5f8[0x3];
 	u8         log_max_xrq[0x5];
 
-	u8         reserved_at_600[0x1e];
-	u8	   sw_owner_id;
+	u8	   affiliate_nic_vport_criteria[0x8];
+	u8	   native_port_num[0x8];
+	u8	   num_vhca_ports[0x8];
+	u8	   reserved_at_618[0x6];
+	u8	   sw_owner_id[0x1];
 	u8	   reserved_at_61f[0x1e1];
 };
 
@@ -2617,7 +2623,12 @@ struct mlx5_ifc_nic_vport_context_bits {
 	u8         event_on_mc_address_change[0x1];
 	u8         event_on_uc_address_change[0x1];
 
-	u8         reserved_at_40[0xf0];
+	u8         reserved_at_40[0xc];
+
+	u8	   affiliation_criteria[0x4];
+	u8	   affiliated_vhca_id[0x10];
+
+	u8	   reserved_at_60[0xd0];
 
 	u8         mtu[0x10];
 
@@ -3260,7 +3271,8 @@ struct mlx5_ifc_set_roce_address_in_bits {
 	u8         op_mod[0x10];
 
 	u8         roce_address_index[0x10];
-	u8         reserved_at_50[0x10];
+	u8         reserved_at_50[0xc];
+	u8	   vhca_port_num[0x4];
 
 	u8         reserved_at_60[0x20];
 
@@ -3880,7 +3892,8 @@ struct mlx5_ifc_query_roce_address_in_bits {
 	u8         op_mod[0x10];
 
 	u8         roce_address_index[0x10];
-	u8         reserved_at_50[0x10];
+	u8         reserved_at_50[0xc];
+	u8	   vhca_port_num[0x4];
 
 	u8         reserved_at_60[0x20];
 };
@@ -5312,7 +5325,9 @@ struct mlx5_ifc_modify_nic_vport_context_out_bits {
 };
 
 struct mlx5_ifc_modify_nic_vport_field_select_bits {
-	u8         reserved_at_0[0x14];
+	u8         reserved_at_0[0x12];
+	u8	   affiliation[0x1];
+	u8	   reserved_at_e[0x1];
 	u8         disable_uc_local_lb[0x1];
 	u8         disable_mc_local_lb[0x1];
 	u8         node_guid[0x1];
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index aaa0bb9e7655..64e193e87394 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -116,4 +116,8 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 				       struct mlx5_hca_vport_context *req);
 int mlx5_nic_vport_update_local_lb(struct mlx5_core_dev *mdev, bool enable);
 int mlx5_nic_vport_query_local_lb(struct mlx5_core_dev *mdev, bool *status);
+
+int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
+				       struct mlx5_core_dev *port_mdev);
+int mlx5_nic_vport_unaffiliate_multiport(struct mlx5_core_dev *port_mdev);
 #endif /* __MLX5_VPORT_H__ */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0c8ec8c0211e..41d4f59cac5e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3871,4 +3871,12 @@ ib_get_vector_affinity(struct ib_device *device, int comp_vector)
 
 }
 
+/**
+ * rdma_roce_rescan_device - Rescan all of the network devices in the system
+ * and add their gids, as needed, to the relevant RoCE devices.
+ *
+ * @device:         the rdma device
+ */
+void rdma_roce_rescan_device(struct ib_device *ibdev);
+
 #endif /* IB_VERBS_H */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
