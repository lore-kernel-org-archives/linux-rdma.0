From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/5] IB/mlx5: Port events in RoCE now rely on netdev events
Date: Sun, 18 Sep 2016 13:08:12 +0300
Message-ID: <1474193296-28062-2-git-send-email-leon@kernel.org>
References: <1474193296-28062-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474193296-28062-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since ib_query_port() in RoCE returns the state of its netdev as the port
state, it makes sense to propagate the port up/down events to ib_core
when the netdev port state changes, instead of relying on traditional
core events.

This also keeps both the event and ib_query_port() synchronized.

Signed-off-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 66 ++++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1b4094b..de7558b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -106,13 +106,32 @@ static int mlx5_netdev_event(struct notifier_block *this,
 	struct mlx5_ib_dev *ibdev = container_of(this, struct mlx5_ib_dev,
 						 roce.nb);
 
-	if ((event != NETDEV_UNREGISTER) && (event != NETDEV_REGISTER))
-		return NOTIFY_DONE;
+	switch (event) {
+	case NETDEV_REGISTER:
+	case NETDEV_UNREGISTER:
+		write_lock(&ibdev->roce.netdev_lock);
+		if (ndev->dev.parent == &ibdev->mdev->pdev->dev)
+			ibdev->roce.netdev = (event == NETDEV_UNREGISTER) ?
+					     NULL : ndev;
+		write_unlock(&ibdev->roce.netdev_lock);
+		break;
 
-	write_lock(&ibdev->roce.netdev_lock);
-	if (ndev->dev.parent == &ibdev->mdev->pdev->dev)
-		ibdev->roce.netdev = (event == NETDEV_UNREGISTER) ? NULL : ndev;
-	write_unlock(&ibdev->roce.netdev_lock);
+	case NETDEV_UP:
+	case NETDEV_DOWN:
+		if (ndev == ibdev->roce.netdev && ibdev->ib_active) {
+			struct ib_event ibev = {0};
+
+			ibev.device = &ibdev->ib_dev;
+			ibev.event = (event == NETDEV_UP) ?
+				     IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
+			ibev.element.port_num = 1;
+			ib_dispatch_event(&ibev);
+		}
+		break;
+
+	default:
+		break;
+	}
 
 	return NOTIFY_DONE;
 }
@@ -2097,14 +2116,19 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 		break;
 
 	case MLX5_DEV_EVENT_PORT_UP:
-		ibev.event = IB_EVENT_PORT_ACTIVE;
-		port = (u8)param;
-		break;
-
 	case MLX5_DEV_EVENT_PORT_DOWN:
 	case MLX5_DEV_EVENT_PORT_INITIALIZED:
-		ibev.event = IB_EVENT_PORT_ERR;
 		port = (u8)param;
+
+		/* In RoCE, port up/down events are handled in
+		 * mlx5_netdev_event().
+		 */
+		if (mlx5_ib_port_link_layer(&ibdev->ib_dev, port) ==
+			IB_LINK_LAYER_ETHERNET)
+			return;
+
+		ibev.event = (event == MLX5_DEV_EVENT_PORT_UP) ?
+			     IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
 		break;
 
 	case MLX5_DEV_EVENT_LID_CHANGE:
@@ -2509,14 +2533,24 @@ static void get_dev_fw_str(struct ib_device *ibdev, char *str,
 		       fw_rev_min(dev->mdev), fw_rev_sub(dev->mdev));
 }
 
+static void mlx5_remove_roce_notifier(struct mlx5_ib_dev *dev)
+{
+	if (dev->roce.nb.notifier_call) {
+		unregister_netdevice_notifier(&dev->roce.nb);
+		dev->roce.nb.notifier_call = NULL;
+	}
+}
+
 static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 {
 	int err;
 
 	dev->roce.nb.notifier_call = mlx5_netdev_event;
 	err = register_netdevice_notifier(&dev->roce.nb);
-	if (err)
+	if (err) {
+		dev->roce.nb.notifier_call = NULL;
 		return err;
+	}
 
 	err = mlx5_nic_vport_enable_roce(dev->mdev);
 	if (err)
@@ -2525,14 +2559,13 @@ static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 	return 0;
 
 err_unregister_netdevice_notifier:
-	unregister_netdevice_notifier(&dev->roce.nb);
+	mlx5_remove_roce_notifier(dev);
 	return err;
 }
 
 static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
 {
 	mlx5_nic_vport_disable_roce(dev->mdev);
-	unregister_netdevice_notifier(&dev->roce.nb);
 }
 
 static void mlx5_ib_dealloc_q_counters(struct mlx5_ib_dev *dev)
@@ -2881,8 +2914,10 @@ err_rsrc:
 	destroy_dev_resources(&dev->devr);
 
 err_disable_roce:
-	if (ll == IB_LINK_LAYER_ETHERNET)
+	if (ll == IB_LINK_LAYER_ETHERNET) {
 		mlx5_disable_roce(dev);
+		mlx5_remove_roce_notifier(dev);
+	}
 
 err_free_port:
 	kfree(dev->port);
@@ -2898,6 +2933,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	struct mlx5_ib_dev *dev = context;
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev, 1);
 
+	mlx5_remove_roce_notifier(dev);
 	ib_unregister_device(&dev->ib_dev);
 	mlx5_ib_dealloc_q_counters(dev);
 	destroy_umrc_res(dev);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
