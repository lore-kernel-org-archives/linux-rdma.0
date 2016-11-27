From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 08/10] IB/mlx5: Refactor registration to netdev notifier
Date: Sun, 27 Nov 2016 16:51:34 +0200
Message-ID: <1480258296-27032-9-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Refactor the netdev notifier registration into a small helper function.

This is a pre-step towards having mlx5 IB device over an Ethernet port
which doesn't support RoCE. Also, renamed the de-registration helper
and the new helper as netdev notifier and not roce, to make it clear
this is not only used with roce.

This patch doesn't change any functionality.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a137254..91921f1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2789,7 +2789,21 @@ static void mlx5_roce_lag_cleanup(struct mlx5_ib_dev *dev)
 	}
 }
 
-static void mlx5_remove_roce_notifier(struct mlx5_ib_dev *dev)
+static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev)
+{
+	int err;
+
+	dev->roce.nb.notifier_call = mlx5_netdev_event;
+	err = register_netdevice_notifier(&dev->roce.nb);
+	if (err) {
+		dev->roce.nb.notifier_call = NULL;
+		return err;
+	}
+
+	return 0;
+}
+
+static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev)
 {
 	if (dev->roce.nb.notifier_call) {
 		unregister_netdevice_notifier(&dev->roce.nb);
@@ -2801,12 +2815,9 @@ static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 {
 	int err;
 
-	dev->roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->roce.nb);
-	if (err) {
-		dev->roce.nb.notifier_call = NULL;
+	err = mlx5_add_netdev_notifier(dev);
+	if (err)
 		return err;
-	}
 
 	err = mlx5_nic_vport_enable_roce(dev->mdev);
 	if (err)
@@ -2822,7 +2833,7 @@ err_disable_roce:
 	mlx5_nic_vport_disable_roce(dev->mdev);
 
 err_unregister_netdevice_notifier:
-	mlx5_remove_roce_notifier(dev);
+	mlx5_remove_netdev_notifier(dev);
 	return err;
 }
 
@@ -3186,7 +3197,7 @@ err_rsrc:
 err_disable_roce:
 	if (ll == IB_LINK_LAYER_ETHERNET) {
 		mlx5_disable_roce(dev);
-		mlx5_remove_roce_notifier(dev);
+		mlx5_remove_netdev_notifier(dev);
 	}
 
 err_free_port:
@@ -3203,7 +3214,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	struct mlx5_ib_dev *dev = context;
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev, 1);
 
-	mlx5_remove_roce_notifier(dev);
+	mlx5_remove_netdev_notifier(dev);
 	ib_unregister_device(&dev->ib_dev);
 	mlx5_ib_dealloc_q_counters(dev);
 	destroy_umrc_res(dev);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
