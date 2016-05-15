From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is disabled
Date: Sun, 15 May 2016 15:57:46 +0300
Message-ID: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On some environments, such as certain SRIOV VF configurations, RoCE is
not supported for an Ethernet port. Currently, the driver will not
open IB device on that port.

This is problematic, since we do want user-space RAW Ethernet (RAW_PACKET
QPs) functionality to remain in place. For that end, enhance the relevant
driver flows such that we do create a device instance in that case.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 55 +++++++++++++++------------------------
 1 file changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4cb81f6..965e414 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2195,6 +2195,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, 1);
 	int err;
 
 	err = mlx5_ib_query_port(ibdev, port_num, &attr);
@@ -2204,37 +2206,12 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 	immutable->core_cap_flags = get_core_cap_flags(ibdev);
-	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+	if ((ll == IB_LINK_LAYER_INFINIBAND) || MLX5_CAP_GEN(dev->mdev, roce))
+		immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
 
-static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
-{
-	int err;
-
-	dev->roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->roce.nb);
-	if (err)
-		return err;
-
-	err = mlx5_nic_vport_enable_roce(dev->mdev);
-	if (err)
-		goto err_unregister_netdevice_notifier;
-
-	return 0;
-
-err_unregister_netdevice_notifier:
-	unregister_netdevice_notifier(&dev->roce.nb);
-	return err;
-}
-
-static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
-{
-	mlx5_nic_vport_disable_roce(dev->mdev);
-	unregister_netdevice_notifier(&dev->roce.nb);
-}
-
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -2246,9 +2223,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
-	if ((ll == IB_LINK_LAYER_ETHERNET) && !MLX5_CAP_GEN(mdev, roce))
-		return NULL;
-
 	printk_once(KERN_INFO "%s", mlx5_version);
 
 	dev = (struct mlx5_ib_dev *)ib_alloc_device(sizeof(*dev));
@@ -2396,9 +2370,15 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	mutex_init(&dev->cap_mask_mutex);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
-		err = mlx5_enable_roce(dev);
+		dev->roce.nb.notifier_call = mlx5_netdev_event;
+		err = register_netdevice_notifier(&dev->roce.nb);
 		if (err)
 			goto err_dealloc;
+		if (MLX5_CAP_GEN(mdev, roce)) {
+			err = mlx5_nic_vport_enable_roce(dev->mdev);
+			if (err)
+				goto err_unreg_notifier;
+		}
 	}
 
 	err = create_dev_resources(&dev->devr);
@@ -2441,8 +2421,12 @@ err_rsrc:
 	destroy_dev_resources(&dev->devr);
 
 err_disable_roce:
+	if (ll == IB_LINK_LAYER_ETHERNET && MLX5_CAP_GEN(mdev, roce))
+		mlx5_nic_vport_disable_roce(dev->mdev);
+
+err_unreg_notifier:
 	if (ll == IB_LINK_LAYER_ETHERNET)
-		mlx5_disable_roce(dev);
+		unregister_netdevice_notifier(&dev->roce.nb);
 
 err_dealloc:
 	ib_dealloc_device((struct ib_device *)dev);
@@ -2459,8 +2443,11 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	destroy_umrc_res(dev);
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
-	if (ll == IB_LINK_LAYER_ETHERNET)
-		mlx5_disable_roce(dev);
+	if (ll == IB_LINK_LAYER_ETHERNET) {
+		if (MLX5_CAP_GEN(mdev, roce))
+			mlx5_nic_vport_disable_roce(dev->mdev);
+		unregister_netdevice_notifier(&dev->roce.nb);
+	}
 	ib_dealloc_device(&dev->ib_dev);
 }
 
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
