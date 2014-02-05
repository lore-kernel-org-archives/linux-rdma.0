From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 3/5] IB/mlx4: Do IBoE locking earlier when initializing the GID table
Date: Wed,  5 Feb 2014 15:13:00 +0200
Message-ID: <1391605982-4348-4-git-send-email-ogerlitz@mellanox.com>
References: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391605982-4348-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Updating the GID table under IBoE requires read/write from/to shared
data structures. These data structures are protected with the device
iboe lock. The flows that modify the GID table start from

1. Initializing the GID table
2. NETDEV events
3. INET or INET6 events

This patch makes sure that the flow of initializing the GID table is
consistent with the other two flow w.r.t on what step the lock is taken.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e05f888..00a1651 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1570,7 +1570,6 @@ static u8 mlx4_ib_get_dev_port(struct net_device *dev,
 				rdma_vlan_dev_real_dev(dev) : dev;
 
 	iboe = &ibdev->iboe;
-	spin_lock(&iboe->lock);
 
 	for (port = 1; port <= MLX4_MAX_PORTS; ++port)
 		if ((netif_is_bond_master(real_dev) &&
@@ -1579,8 +1578,6 @@ static u8 mlx4_ib_get_dev_port(struct net_device *dev,
 		     (real_dev == iboe->netdevs[port - 1])))
 			break;
 
-	spin_unlock(&iboe->lock);
-
 	if ((port == 0) || (port > MLX4_MAX_PORTS))
 		return 0;
 	else
@@ -1672,11 +1669,13 @@ static void mlx4_ib_set_default_gid(struct mlx4_ib_dev *ibdev,
 static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 {
 	struct	net_device *dev;
+	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
 
 	if (reset_gid_table(ibdev))
 		return -1;
 
 	read_lock(&dev_base_lock);
+	spin_lock(&iboe->lock);
 
 	for_each_netdev(&init_net, dev) {
 		u8 port = mlx4_ib_get_dev_port(dev, ibdev);
@@ -1684,6 +1683,7 @@ static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 			mlx4_ib_get_dev_addr(dev, ibdev, port);
 	}
 
+	spin_unlock(&iboe->lock);
 	read_unlock(&dev_base_lock);
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
