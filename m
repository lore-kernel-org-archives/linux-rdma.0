From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 3/5] IB/mlx5: Port status track LAG master, when LAG is active
Date: Sun, 18 Sep 2016 20:48:02 +0300
Message-ID: <1474220884-21341-4-git-send-email-leon@kernel.org>
References: <1474220884-21341-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474220884-21341-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When LAG is active, port up/down events should be triggered
by tracking the LAG master, and not one of the two slave
netdevs.

In the same manner, ib_query_port() should return the details
of the LAG master.

Signed-off-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index acb1891..47f8088 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -118,8 +118,17 @@ static int mlx5_netdev_event(struct notifier_block *this,
 		break;
 
 	case NETDEV_UP:
-	case NETDEV_DOWN:
-		if (ndev == ibdev->roce.netdev && ibdev->ib_active) {
+	case NETDEV_DOWN: {
+		struct net_device *lag_ndev = mlx5_lag_get_roce_netdev(ibdev->mdev);
+		struct net_device *upper = NULL;
+
+		if (lag_ndev) {
+			upper = netdev_master_upper_dev_get(lag_ndev);
+			dev_put(lag_ndev);
+		}
+
+		if ((upper == ndev || (!upper && ndev == ibdev->roce.netdev))
+		    && ibdev->ib_active) {
 			struct ib_event ibev = {0};
 
 			ibev.device = &ibdev->ib_dev;
@@ -129,6 +138,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
 			ib_dispatch_event(&ibev);
 		}
 		break;
+	}
 
 	default:
 		break;
@@ -143,6 +153,10 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 	struct mlx5_ib_dev *ibdev = to_mdev(device);
 	struct net_device *ndev;
 
+	ndev = mlx5_lag_get_roce_netdev(ibdev->mdev);
+	if (ndev)
+		return ndev;
+
 	/* Ensure ndev does not disappear before we invoke dev_hold()
 	 */
 	read_lock(&ibdev->roce.netdev_lock);
@@ -158,7 +172,7 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 				struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
-	struct net_device *ndev;
+	struct net_device *ndev, *upper;
 	enum ib_mtu ndev_ib_mtu;
 	u16 qkey_viol_cntr;
 
@@ -182,6 +196,17 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	if (!ndev)
 		return 0;
 
+	if (mlx5_lag_is_active(dev->mdev)) {
+		rcu_read_lock();
+		upper = netdev_master_upper_dev_get_rcu(ndev);
+		if (upper) {
+			dev_put(ndev);
+			ndev = upper;
+			dev_hold(ndev);
+		}
+		rcu_read_unlock();
+	}
+
 	if (netif_running(ndev) && netif_carrier_ok(ndev)) {
 		props->state      = IB_PORT_ACTIVE;
 		props->phys_state = 5;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
