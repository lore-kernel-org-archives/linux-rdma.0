From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/mlx5: Set mlx5_query_roce_port's return value to void
Date: Thu, 20 Apr 2017 20:53:32 +0300
Message-ID: <20170420175333.7082-3-leon@kernel.org>
References: <20170420175333.7082-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175333.7082-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case of an error, the properties reported to user
are zeroed out, so no need for a return value.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4dc0a8785fe0..6ba8bbc5c74a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -165,15 +165,20 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 	return ndev;
 }
 
-static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
-				struct ib_port_attr *props)
+static void mlx5_query_port_roce(struct ib_device *device, u8 port_num,
+				 struct ib_port_attr *props)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 	struct net_device *ndev, *upper;
 	enum ib_mtu ndev_ib_mtu;
 	u16 qkey_viol_cntr;
 
-	/* props being zeroed by the caller, avoid zeroing it here */
+	/* Getting netdev before filling out props so in case of an error it
+	 * will still be zeroed out.
+	 */
+	ndev = mlx5_ib_get_netdev(device, port_num);
+	if (!ndev)
+		return;
 
 	props->port_cap_flags  |= IB_PORT_CM_SUP;
 	props->port_cap_flags  |= IB_PORT_IP_BASED_GIDS;
@@ -189,10 +194,6 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev, &qkey_viol_cntr);
 	props->qkey_viol_cntr = qkey_viol_cntr;
 
-	ndev = mlx5_ib_get_netdev(device, port_num);
-	if (!ndev)
-		return 0;
-
 	if (mlx5_lag_is_active(dev->mdev)) {
 		rcu_read_lock();
 		upper = netdev_master_upper_dev_get_rcu(ndev);
@@ -217,8 +218,6 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 
 	props->active_width	= IB_WIDTH_4X;  /* TODO */
 	props->active_speed	= IB_SPEED_QDR; /* TODO */
-
-	return 0;
 }
 
 static void ib_gid_to_mlx5_roce_addr(const union ib_gid *gid,
@@ -924,7 +923,8 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 		return mlx5_query_hca_port(ibdev, port, props);
 
 	case MLX5_VPORT_ACCESS_METHOD_NIC:
-		return mlx5_query_port_roce(ibdev, port, props);
+		mlx5_query_port_roce(ibdev, port, props);
+		return 0;
 
 	default:
 		return -EINVAL;
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
