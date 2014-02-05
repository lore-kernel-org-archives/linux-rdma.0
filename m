From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.14 2/5] IB/mlx4: Move rtnl locking to the right location
Date: Wed,  5 Feb 2014 15:12:59 +0200
Message-ID: <1391605982-4348-3-git-send-email-ogerlitz@mellanox.com>
References: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391605982-4348-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

On the one hand, the invocation of netdev_master_upper_dev_get() within
mlx4_ib_scan_netdevs() must be done with rtnl lock held. On the other
hand, it's wrong to call rtnl_lock() from within this function since its
also called by our netdev notifier callback. As such, remove the
locking to take place in mlx4_ib_add() such that both cases are covered.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 06978cd..e05f888 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1707,10 +1707,8 @@ static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev)
 						iboe->netdevs[port - 1], port);
 		if (iboe->netdevs[port - 1] &&
 		    netif_is_bond_slave(iboe->netdevs[port - 1])) {
-			rtnl_lock();
 			iboe->masters[port - 1] = netdev_master_upper_dev_get(
 				iboe->netdevs[port - 1]);
-			rtnl_unlock();
 		}
 		curr_master = iboe->masters[port - 1];
 
@@ -2100,7 +2098,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			}
 		}
 #endif
+		rtnl_lock();
 		mlx4_ib_scan_netdevs(ibdev);
+		rtnl_unlock();
 		mlx4_ib_init_gid_table(ibdev);
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
