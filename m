From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 02/10] IB/mlx5: Support IB device's callback for getting its netdev
Date: Wed, 23 Dec 2015 18:47:17 +0200
Message-ID: <1450889245-30347-3-git-send-email-matanb@mellanox.com>
References: <1450889245-30347-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450889245-30347-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For Eth ports only:
Maintain a net device pointer in mlx5_ib_device and update it
upon NETDEV_REGISTER and NETDEV_UNREGISTER events if the
net-device and IB device have the same PCI parent device.
Implement the get_netdev callback to return this net device.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 64 +++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 ++++++
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a3295bb..8c6e144 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -85,6 +85,41 @@ mlx5_ib_port_link_layer(struct ib_device *device, u8 port_num)
 	return mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 }
 
+static int mlx5_netdev_event(struct notifier_block *this,
+			     unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct mlx5_ib_dev *ibdev = container_of(this, struct mlx5_ib_dev,
+						 roce.nb);
+
+	if ((event != NETDEV_UNREGISTER) && (event != NETDEV_REGISTER))
+		return NOTIFY_DONE;
+
+	write_lock(&ibdev->roce.netdev_lock);
+	if (ndev->dev.parent == &ibdev->mdev->pdev->dev)
+		ibdev->roce.netdev = (event == NETDEV_UNREGISTER) ? NULL : ndev;
+	write_unlock(&ibdev->roce.netdev_lock);
+
+	return NOTIFY_DONE;
+}
+
+static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
+					     u8 port_num)
+{
+	struct mlx5_ib_dev *ibdev = to_mdev(device);
+	struct net_device *ndev;
+
+	/* Ensure ndev does not disappear before we invoke dev_hold()
+	 */
+	read_lock(&ibdev->roce.netdev_lock);
+	ndev = ibdev->roce.netdev;
+	if (ndev)
+		dev_hold(ndev);
+	read_unlock(&ibdev->roce.netdev_lock);
+
+	return ndev;
+}
+
 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
 	return !dev->mdev->issi;
@@ -1329,6 +1364,17 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
+{
+	dev->roce.nb.notifier_call = mlx5_netdev_event;
+	return register_netdevice_notifier(&dev->roce.nb);
+}
+
+static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
+{
+	unregister_netdevice_notifier(&dev->roce.nb);
+}
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -1352,6 +1398,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	dev->mdev = mdev;
 
+	rwlock_init(&dev->roce.netdev_lock);
 	err = get_port_caps(dev);
 	if (err)
 		goto err_dealloc;
@@ -1402,6 +1449,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
 	dev->ib_dev.get_link_layer	= mlx5_ib_port_link_layer;
+	if (ll == IB_LINK_LAYER_ETHERNET)
+		dev->ib_dev.get_netdev	= mlx5_ib_get_netdev;
 	dev->ib_dev.query_gid		= mlx5_ib_query_gid;
 	dev->ib_dev.query_pkey		= mlx5_ib_query_pkey;
 	dev->ib_dev.modify_device	= mlx5_ib_modify_device;
@@ -1458,9 +1507,15 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	mutex_init(&dev->cap_mask_mutex);
 
+	if (ll == IB_LINK_LAYER_ETHERNET) {
+		err = mlx5_enable_roce(dev);
+		if (err)
+			goto err_dealloc;
+	}
+
 	err = create_dev_resources(&dev->devr);
 	if (err)
-		goto err_dealloc;
+		goto err_disable_roce;
 
 	err = mlx5_ib_odp_init_one(dev);
 	if (err)
@@ -1497,6 +1552,10 @@ err_odp:
 err_rsrc:
 	destroy_dev_resources(&dev->devr);
 
+err_disable_roce:
+	if (ll == IB_LINK_LAYER_ETHERNET)
+		mlx5_disable_roce(dev);
+
 err_dealloc:
 	ib_dealloc_device((struct ib_device *)dev);
 
@@ -1506,11 +1565,14 @@ err_dealloc:
 static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 {
 	struct mlx5_ib_dev *dev = context;
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev, 1);
 
 	ib_unregister_device(&dev->ib_dev);
 	destroy_umrc_res(dev);
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
+	if (ll == IB_LINK_LAYER_ETHERNET)
+		mlx5_disable_roce(dev);
 	ib_dealloc_device(&dev->ib_dev);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6333472..1eaa611 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -407,9 +407,19 @@ struct mlx5_ib_resources {
 	struct ib_srq	*s1;
 };
 
+struct mlx5_roce {
+	/* Protect mlx5_ib_get_netdev from invoking dev_hold() with a NULL
+	 * netdev pointer
+	 */
+	rwlock_t		netdev_lock;
+	struct net_device	*netdev;
+	struct notifier_block	nb;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
+	struct mlx5_roce		roce;
 	MLX5_DECLARE_DOORBELL_LOCK(uar_lock);
 	int				num_ports;
 	/* serialize update of capability mask
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
