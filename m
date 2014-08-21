From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 3/7] IB/mlx4: Reorder steps in RoCE GID table initialization
Date: Thu, 21 Aug 2014 14:28:39 +0300
Message-ID: <1408620523-10616-4-git-send-email-ogerlitz@mellanox.com>
References: <1408620523-10616-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408620523-10616-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There's no need to reset the gid table twice and we need to do it only
for Ethernet ports. Also, no need to actively scan ndetdevs since it's being
done immediatly after we register netdev notifiers.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 61910f4..d95b5fe 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1727,24 +1727,33 @@ static int mlx4_ib_init_gid_table(struct mlx4_ib_dev *ibdev)
 	struct	net_device *dev;
 	struct mlx4_ib_iboe *iboe = &ibdev->iboe;
 	int i;
+	int err = 0;
 
-	for (i = 1; i <= ibdev->num_ports; ++i)
-		if (reset_gid_table(ibdev, i))
-			return -1;
+	for (i = 1; i <= ibdev->num_ports; ++i) {
+		if (rdma_port_get_link_layer(&ibdev->ib_dev, i) ==
+		    IB_LINK_LAYER_ETHERNET) {
+			err = reset_gid_table(ibdev, i);
+			if (err)
+				goto out;
+		}
+	}
 
 	read_lock(&dev_base_lock);
 	spin_lock(&iboe->lock);
 
 	for_each_netdev(&init_net, dev) {
 		u8 port = mlx4_ib_get_dev_port(dev, ibdev);
-		if (port)
+		/* port will be non-zero only for ETH ports */
+		if (port) {
+			mlx4_ib_set_default_gid(ibdev, dev, port);
 			mlx4_ib_get_dev_addr(dev, ibdev, port);
+		}
 	}
 
 	spin_unlock(&iboe->lock);
 	read_unlock(&dev_base_lock);
-
-	return 0;
+out:
+	return err;
 }
 
 static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
@@ -2199,12 +2208,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			}
 		}
 #endif
-		for (i = 1 ; i <= ibdev->num_ports ; ++i)
-			reset_gid_table(ibdev, i);
-		rtnl_lock();
-		mlx4_ib_scan_netdevs(ibdev, NULL, 0);
-		rtnl_unlock();
-		mlx4_ib_init_gid_table(ibdev);
+		if (mlx4_ib_init_gid_table(ibdev))
+			goto err_notif;
 	}
 
 	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
