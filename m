From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 09/10] IB/mlx5: Rename RoCE related helpers to reflect being Eth ones
Date: Sun, 27 Nov 2016 16:51:35 +0200
Message-ID: <1480258296-27032-10-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is a pre-step towards having mlx5 IB device also over Eth ports where
RoCE is not supported. We change the roce enable/disable and roce_lag
init/fini function names to have _eth instead of _roce.

This patch doesn't change any functionality.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 91921f1..b811c70 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2748,7 +2748,7 @@ static void get_dev_fw_str(struct ib_device *ibdev, char *str,
 		       fw_rev_min(dev->mdev), fw_rev_sub(dev->mdev));
 }
 
-static int mlx5_roce_lag_init(struct mlx5_ib_dev *dev)
+static int mlx5_eth_lag_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(mdev,
@@ -2777,7 +2777,7 @@ err_destroy_vport_lag:
 	return err;
 }
 
-static void mlx5_roce_lag_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_eth_lag_cleanup(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
 
@@ -2811,7 +2811,7 @@ static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev)
 	}
 }
 
-static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
+static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 {
 	int err;
 
@@ -2823,7 +2823,7 @@ static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 	if (err)
 		goto err_unregister_netdevice_notifier;
 
-	err = mlx5_roce_lag_init(dev);
+	err = mlx5_eth_lag_init(dev);
 	if (err)
 		goto err_disable_roce;
 
@@ -2837,9 +2837,9 @@ err_unregister_netdevice_notifier:
 	return err;
 }
 
-static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
+static void mlx5_disable_eth(struct mlx5_ib_dev *dev)
 {
-	mlx5_roce_lag_cleanup(dev);
+	mlx5_eth_lag_cleanup(dev);
 	mlx5_nic_vport_disable_roce(dev->mdev);
 }
 
@@ -3143,14 +3143,14 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	spin_lock_init(&dev->reset_flow_resource_lock);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
-		err = mlx5_enable_roce(dev);
+		err = mlx5_enable_eth(dev);
 		if (err)
 			goto err_free_port;
 	}
 
 	err = create_dev_resources(&dev->devr);
 	if (err)
-		goto err_disable_roce;
+		goto err_disable_eth;
 
 	err = mlx5_ib_odp_init_one(dev);
 	if (err)
@@ -3194,9 +3194,9 @@ err_odp:
 err_rsrc:
 	destroy_dev_resources(&dev->devr);
 
-err_disable_roce:
+err_disable_eth:
 	if (ll == IB_LINK_LAYER_ETHERNET) {
-		mlx5_disable_roce(dev);
+		mlx5_disable_eth(dev);
 		mlx5_remove_netdev_notifier(dev);
 	}
 
@@ -3221,7 +3221,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
 	if (ll == IB_LINK_LAYER_ETHERNET)
-		mlx5_disable_roce(dev);
+		mlx5_disable_eth(dev);
 	kfree(dev->port);
 	ib_dealloc_device(&dev->ib_dev);
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
