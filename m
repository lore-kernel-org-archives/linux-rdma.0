From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 05/15] IB/mlx5: Make netdev notifications multiport capable
Date: Sun, 24 Dec 2017 14:57:31 +0200
Message-ID: <20171224125741.25464-6-leon@kernel.org>
References: <20171224125741.25464-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125741.25464-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When multiple RoCE ports are supported registration for events on
multiple netdevs is required. Refactor the event registration and
handling to support multiple ports.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 85 +++++++++++++++++++++---------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +-
 drivers/infiniband/hw/mlx5/qp.c      |  3 +-
 include/linux/mlx5/driver.h          |  5 +++
 4 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a28362264d1b..a6dea2a8a455 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -115,24 +115,30 @@ static int get_port_state(struct ib_device *ibdev,
 static int mlx5_netdev_event(struct notifier_block *this,
 			     unsigned long event, void *ptr)
 {
+	struct mlx5_roce *roce = container_of(this, struct mlx5_roce, nb);
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
-	struct mlx5_ib_dev *ibdev = container_of(this, struct mlx5_ib_dev,
-						 roce.nb);
+	u8 port_num = roce->native_port_num;
+	struct mlx5_core_dev *mdev;
+	struct mlx5_ib_dev *ibdev;
+
+	ibdev = roce->dev;
+	mdev = ibdev->mdev;
 
 	switch (event) {
 	case NETDEV_REGISTER:
 	case NETDEV_UNREGISTER:
-		write_lock(&ibdev->roce.netdev_lock);
-		if (ndev->dev.parent == &ibdev->mdev->pdev->dev)
-			ibdev->roce.netdev = (event == NETDEV_UNREGISTER) ?
-					     NULL : ndev;
-		write_unlock(&ibdev->roce.netdev_lock);
+		write_lock(&roce->netdev_lock);
+
+		if (ndev->dev.parent == &mdev->pdev->dev)
+			roce->netdev = (event == NETDEV_UNREGISTER) ?
+					NULL : ndev;
+		write_unlock(&roce->netdev_lock);
 		break;
 
 	case NETDEV_CHANGE:
 	case NETDEV_UP:
 	case NETDEV_DOWN: {
-		struct net_device *lag_ndev = mlx5_lag_get_roce_netdev(ibdev->mdev);
+		struct net_device *lag_ndev = mlx5_lag_get_roce_netdev(mdev);
 		struct net_device *upper = NULL;
 
 		if (lag_ndev) {
@@ -140,27 +146,28 @@ static int mlx5_netdev_event(struct notifier_block *this,
 			dev_put(lag_ndev);
 		}
 
-		if ((upper == ndev || (!upper && ndev == ibdev->roce.netdev))
+		if ((upper == ndev || (!upper && ndev == roce->netdev))
 		    && ibdev->ib_active) {
 			struct ib_event ibev = { };
 			enum ib_port_state port_state;
 
-			if (get_port_state(&ibdev->ib_dev, 1, &port_state))
-				return NOTIFY_DONE;
+			if (get_port_state(&ibdev->ib_dev, port_num,
+					   &port_state))
+				goto done;
 
-			if (ibdev->roce.last_port_state == port_state)
-				return NOTIFY_DONE;
+			if (roce->last_port_state == port_state)
+				goto done;
 
-			ibdev->roce.last_port_state = port_state;
+			roce->last_port_state = port_state;
 			ibev.device = &ibdev->ib_dev;
 			if (port_state == IB_PORT_DOWN)
 				ibev.event = IB_EVENT_PORT_ERR;
 			else if (port_state == IB_PORT_ACTIVE)
 				ibev.event = IB_EVENT_PORT_ACTIVE;
 			else
-				return NOTIFY_DONE;
+				goto done;
 
-			ibev.element.port_num = 1;
+			ibev.element.port_num = port_num;
 			ib_dispatch_event(&ibev);
 		}
 		break;
@@ -169,7 +176,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
 	default:
 		break;
 	}
-
+done:
 	return NOTIFY_DONE;
 }
 
@@ -185,11 +192,11 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 
 	/* Ensure ndev does not disappear before we invoke dev_hold()
 	 */
-	read_lock(&ibdev->roce.netdev_lock);
-	ndev = ibdev->roce.netdev;
+	read_lock(&ibdev->roce[port_num - 1].netdev_lock);
+	ndev = ibdev->roce[port_num - 1].netdev;
 	if (ndev)
 		dev_hold(ndev);
-	read_unlock(&ibdev->roce.netdev_lock);
+	read_unlock(&ibdev->roce[port_num - 1].netdev_lock);
 
 	return ndev;
 }
@@ -3459,33 +3466,33 @@ static void mlx5_eth_lag_cleanup(struct mlx5_ib_dev *dev)
 	}
 }
 
-static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev)
+static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	int err;
 
-	dev->roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->roce.nb);
+	dev->roce[port_num].nb.notifier_call = mlx5_netdev_event;
+	err = register_netdevice_notifier(&dev->roce[port_num].nb);
 	if (err) {
-		dev->roce.nb.notifier_call = NULL;
+		dev->roce[port_num].nb.notifier_call = NULL;
 		return err;
 	}
 
 	return 0;
 }
 
-static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev)
+static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
-	if (dev->roce.nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->roce.nb);
-		dev->roce.nb.notifier_call = NULL;
+	if (dev->roce[port_num].nb.notifier_call) {
+		unregister_netdevice_notifier(&dev->roce[port_num].nb);
+		dev->roce[port_num].nb.notifier_call = NULL;
 	}
 }
 
-static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
+static int mlx5_enable_eth(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	int err;
 
-	err = mlx5_add_netdev_notifier(dev);
+	err = mlx5_add_netdev_notifier(dev, port_num);
 	if (err)
 		return err;
 
@@ -3506,7 +3513,7 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 		mlx5_nic_vport_disable_roce(dev->mdev);
 
 err_unregister_netdevice_notifier:
-	mlx5_remove_netdev_notifier(dev);
+	mlx5_remove_netdev_notifier(dev, port_num);
 	return err;
 }
 
@@ -3966,7 +3973,6 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	if (!dev->port)
 		return -ENOMEM;
 
-	rwlock_init(&dev->roce.netdev_lock);
 	err = get_port_caps(dev);
 	if (err)
 		goto err_free_port;
@@ -4140,12 +4146,21 @@ static int mlx5_ib_stage_roce_init(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
+	u8 port_num = 0;
 	int err;
+	int i;
 
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
+		for (i = 0; i < dev->num_ports; i++) {
+			rwlock_init(&dev->roce[i].netdev_lock);
+			dev->roce[i].dev = dev;
+			dev->roce[i].native_port_num = i + 1;
+			dev->roce[i].last_port_state = IB_PORT_DOWN;
+		}
+
 		dev->ib_dev.get_netdev	= mlx5_ib_get_netdev;
 		dev->ib_dev.create_wq	 = mlx5_ib_create_wq;
 		dev->ib_dev.modify_wq	 = mlx5_ib_modify_wq;
@@ -4158,10 +4173,9 @@ static int mlx5_ib_stage_roce_init(struct mlx5_ib_dev *dev)
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ) |
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
-		err = mlx5_enable_eth(dev);
+		err = mlx5_enable_eth(dev, port_num);
 		if (err)
 			return err;
-		dev->roce.last_port_state = IB_PORT_DOWN;
 	}
 
 	return 0;
@@ -4172,13 +4186,14 @@ static void mlx5_ib_stage_roce_cleanup(struct mlx5_ib_dev *dev)
 	struct mlx5_core_dev *mdev = dev->mdev;
 	enum rdma_link_layer ll;
 	int port_type_cap;
+	u8 port_num = 0;
 
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
 		mlx5_disable_eth(dev);
-		mlx5_remove_netdev_notifier(dev);
+		mlx5_remove_netdev_notifier(dev, port_num);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8f762ac4a659..1107047c6f83 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -647,6 +647,8 @@ struct mlx5_roce {
 	struct notifier_block	nb;
 	atomic_t		next_port;
 	enum ib_port_state last_port_state;
+	struct mlx5_ib_dev	*dev;
+	u8			native_port_num;
 };
 
 struct mlx5_ib_dbg_param {
@@ -749,7 +751,7 @@ struct mlx5_ib_odp {
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
-	struct mlx5_roce		roce;
+	struct mlx5_roce		roce[MLX5_MAX_PORTS];
 	int				num_ports;
 	/* serialize update of capability mask
 	 */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2b5cd7bd58d1..33b132a9a0fc 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2796,8 +2796,9 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		    (ibqp->qp_type == IB_QPT_XRC_INI) ||
 		    (ibqp->qp_type == IB_QPT_XRC_TGT)) {
 			if (mlx5_lag_is_active(dev->mdev)) {
+				u8 p = mlx5_core_native_port_num(dev->mdev);
 				tx_affinity = (unsigned int)atomic_add_return(1,
-						&dev->roce.next_port) %
+						&dev->roce[p].next_port) %
 						MLX5_MAX_PORTS + 1;
 				context->flags |= cpu_to_be32(tx_affinity << 24);
 			}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 8becaa54aeea..cfcb91975323 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1219,6 +1219,11 @@ static inline bool mlx5_rl_is_supported(struct mlx5_core_dev *dev)
 	return !!(dev->priv.rl_table.max_size);
 }
 
+static inline int mlx5_core_native_port_num(struct mlx5_core_dev *dev)
+{
+	return 1;
+}
+
 enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
