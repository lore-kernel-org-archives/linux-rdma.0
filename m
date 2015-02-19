From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 19/30] IB/mlx4: Replace spin_lock with rw_semaphore
Date: Thu, 19 Feb 2015 15:53:11 +0530
Message-ID: <76210c39-4080-458e-99d6-3a9149cc2ffa@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Protection on iboe->netdevs is no longer required to be from an atomic context.
Replacing a spin_lock with a semaphore is allowed and makes more sense.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |   27 ++++++++++-----------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    2 +-
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 91caffc..d8b227e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -369,7 +369,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->active_mtu	= IB_MTU_256;
 	if (is_bonded)
 		rtnl_lock(); /* required to get upper dev */
-	spin_lock_bh(&iboe->lock);
+	down_read(&iboe->sem);
 	ndev = iboe->netdevs[port - 1];
 	if (ndev && is_bonded)
 		ndev = netdev_master_upper_dev_get(ndev);
@@ -383,7 +383,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
 out_unlock:
-	spin_unlock_bh(&iboe->lock);
+	up_read(&iboe->sem);
 	if (is_bonded)
 		rtnl_unlock();
 out:
@@ -825,11 +825,11 @@ int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 	if (!mqp->port)
 		return 0;
 
-	spin_lock_bh(&mdev->iboe.lock);
+	down_read(&mdev->iboe.sem);
 	ndev = mdev->iboe.netdevs[mqp->port - 1];
 	if (ndev)
 		dev_hold(ndev);
-	spin_unlock_bh(&mdev->iboe.lock);
+	up_read(&mdev->iboe.sem);
 
 	if (ndev) {
 		ret = 1;
@@ -1330,7 +1330,6 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
 	struct mlx4_dev *dev = mdev->dev;
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
-	struct net_device *ndev;
 	struct mlx4_ib_gid_entry *ge;
 	enum mlx4_protocol prot =  MLX4_PROT_IB_IPV6;
 	struct mlx4_flow_reg_id reg_id = {0, 0};
@@ -1370,13 +1369,6 @@ static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	mutex_lock(&mqp->mutex);
 	ge = find_gid_entry(mqp, gid->raw);
 	if (ge) {
-		spin_lock_bh(&mdev->iboe.lock);
-		ndev = ge->added ? mdev->iboe.netdevs[ge->port - 1] : NULL;
-		if (ndev)
-			dev_hold(ndev);
-		spin_unlock_bh(&mdev->iboe.lock);
-		if (ndev)
-			dev_put(ndev);
 		list_del(&ge->list);
 		kfree(ge);
 	} else
@@ -1543,7 +1535,7 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 
 	iboe = &ibdev->iboe;
 
-	spin_lock_bh(&iboe->lock);
+	down_write(&iboe->sem);
 	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
 
 		iboe->netdevs[port - 1] =
@@ -1555,7 +1547,7 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 			update_qps_port = port;
 
 	}
-	spin_unlock_bh(&iboe->lock);
+	up_write(&iboe->sem);
 
 	if (update_qps_port > 0)
 		mlx4_ib_update_qps(ibdev, dev, update_qps_port);
@@ -1848,7 +1840,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	mlx4_ib_alloc_eqs(dev, ibdev);
 
-	spin_lock_init(&iboe->lock);
+	init_rwsem(&iboe->sem);
 
 	if (init_node_data(ibdev))
 		goto err_map;
@@ -2153,7 +2145,8 @@ static void handle_bonded_port_state_event(struct work_struct *work)
 	struct ib_event ibev;
 
 	kfree(ew);
-	spin_lock_bh(&ibdev->iboe.lock);
+
+	down_read(&ibdev->iboe.sem);
 	for (i = 0; i < MLX4_MAX_PORTS; ++i) {
 		struct net_device *curr_netdev = ibdev->iboe.netdevs[i];
 
@@ -2165,7 +2158,7 @@ static void handle_bonded_port_state_event(struct work_struct *work)
 		bonded_port_state = (bonded_port_state != IB_PORT_ACTIVE) ?
 			curr_port_state : IB_PORT_ACTIVE;
 	}
-	spin_unlock_bh(&ibdev->iboe.lock);
+	up_read(&ibdev->iboe.sem);
 
 	ibev.device = &ibdev->ib_dev;
 	ibev.element.port_num = 1;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e3805a4..166ebf9 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -455,7 +455,7 @@ struct mlx4_ib_sriov {
 };
 
 struct mlx4_ib_iboe {
-	spinlock_t		lock;
+	struct rw_semaphore	sem; /* guard from concurrent access to data in this struct */
 	struct net_device      *netdevs[MLX4_MAX_PORTS];
 	atomic64_t		mac[MLX4_MAX_PORTS];
 	struct notifier_block 	nb;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
