From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/10] IB/mlx5: Support RAW Ethernet when RoCE is disabled
Date: Sun, 27 Nov 2016 16:51:36 +0200
Message-ID: <1480258296-27032-11-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On some environments, such as certain SRIOV VF configurations, RoCE is
not supported for mlx5 Ethernet ports. Currently, the driver will not
open IB device on that port.

This is problematic, since we do want user-space RAW Ethernet (RAW_PACKET
QPs) functionality to remain in place. For that end, enhance the relevant
driver flows such that we do create a device instance in that case.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b811c70..c0462d1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2724,6 +2724,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, port_num);
 	int err;
 
 	immutable->core_cap_flags = get_core_cap_flags(ibdev);
@@ -2734,7 +2736,8 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
-	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
+	if ((ll == IB_LINK_LAYER_INFINIBAND) || MLX5_CAP_GEN(dev->mdev, roce))
+		immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
 	return 0;
 }
@@ -2819,9 +2822,11 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
-	err = mlx5_nic_vport_enable_roce(dev->mdev);
-	if (err)
-		goto err_unregister_netdevice_notifier;
+	if (MLX5_CAP_GEN(dev->mdev, roce)) {
+		err = mlx5_nic_vport_enable_roce(dev->mdev);
+		if (err)
+			goto err_unregister_netdevice_notifier;
+	}
 
 	err = mlx5_eth_lag_init(dev);
 	if (err)
@@ -2830,7 +2835,8 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 	return 0;
 
 err_disable_roce:
-	mlx5_nic_vport_disable_roce(dev->mdev);
+	if (MLX5_CAP_GEN(dev->mdev, roce))
+		mlx5_nic_vport_disable_roce(dev->mdev);
 
 err_unregister_netdevice_notifier:
 	mlx5_remove_netdev_notifier(dev);
@@ -2840,7 +2846,8 @@ err_unregister_netdevice_notifier:
 static void mlx5_disable_eth(struct mlx5_ib_dev *dev)
 {
 	mlx5_eth_lag_cleanup(dev);
-	mlx5_nic_vport_disable_roce(dev->mdev);
+	if (MLX5_CAP_GEN(dev->mdev, roce))
+		mlx5_nic_vport_disable_roce(dev->mdev);
 }
 
 static void mlx5_ib_dealloc_q_counters(struct mlx5_ib_dev *dev)
@@ -2962,9 +2969,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
-	if ((ll == IB_LINK_LAYER_ETHERNET) && !MLX5_CAP_GEN(mdev, roce))
-		return NULL;
-
 	printk_once(KERN_INFO "%s", mlx5_version);
 
 	dev = (struct mlx5_ib_dev *)ib_alloc_device(sizeof(*dev));
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
