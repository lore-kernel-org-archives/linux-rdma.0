From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-next 24/32] IB/mlx4: Implement ib_device callback - get_netdev
Date: Wed, 11 Mar 2015 10:26:16 +0530
Message-ID: <10010fab-c551-4eb8-9179-7459dca06d6f@CMEXHTCAS2.ad.emulex.com>
References: <1426049785-30364-1-git-send-email-somnath.kotur@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426049785-30364-1-git-send-email-somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is a new callback that is required for RoCEv2 support.
In port aggregation mode it is required to return the netdev of the
active port so  support in mlx4 core driver to figure out that port
identity is required.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c         | 29 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/main.c | 18 ++++++++++++++++++
 include/linux/mlx4/driver.h               |  1 +
 3 files changed, 48 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bf87a95..04e6603 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -47,6 +47,8 @@
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
 
+#include <net/bonding.h>
+
 #include <linux/mlx4/driver.h>
 #include <linux/mlx4/cmd.h>
 #include <linux/mlx4/qp.h>
@@ -1527,6 +1529,32 @@ unlock:
 	mutex_unlock(&ibdev->qp1_proxy_lock[port - 1]);
 }
 
+static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_num)
+{
+	struct mlx4_ib_dev *ibdev = to_mdev(device);
+
+	if (mlx4_is_bonded(ibdev->dev)) {
+		struct net_device *dev;
+		struct net_device *upper = NULL;
+
+		rcu_read_lock();
+
+		dev = mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port_num);
+		if (dev)
+			upper = netdev_master_upper_dev_get_rcu(dev);
+		else
+			goto unlock;
+		if (upper)
+			dev = bond_option_active_slave_get_rcu(netdev_priv(upper));
+unlock:
+		rcu_read_unlock();
+
+		return dev;
+	}
+
+	return mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port_num);
+}
+
 static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 				 struct net_device *dev,
 				 unsigned long event)
@@ -1806,6 +1834,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
+	ibdev->ib_dev.get_netdev	= mlx4_ib_get_netdev;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 1893a57..6311897 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1237,6 +1237,24 @@ int mlx4_port_map_set(struct mlx4_dev *dev, struct mlx4_port_map *v2p)
 }
 EXPORT_SYMBOL_GPL(mlx4_port_map_set);
 
+int mlx4_port_map_get(struct mlx4_dev *dev, u8 vport, u8 *pport)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	if (!pport)
+		return -EINVAL;
+	*pport = 0;
+
+	if (vport == 1)
+		*pport = priv->v2p.port1;
+	else if (vport == 2)
+		*pport = priv->v2p.port2;
+	if (!*pport)
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_port_map_get);
+
 static int mlx4_load_fw(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index 5a06d96..a992971 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -81,6 +81,7 @@ struct mlx4_port_map {
 };
 
 int mlx4_port_map_set(struct mlx4_dev *dev, struct mlx4_port_map *v2p);
+int mlx4_port_map_get(struct mlx4_dev *dev, u8 vport, u8 *pport);
 
 void *mlx4_get_protocol_dev(struct mlx4_dev *dev, enum mlx4_protocol proto, int port);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
