From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 23/30] IB/mlx4: Implement ib_device callback - get_netdev
Date: Thu, 19 Feb 2015 15:54:26 +0530
Message-ID: <90084c83-479f-41dd-9d18-8d9f32624e5c@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
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
 drivers/infiniband/hw/mlx4/main.c         |   17 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/main.c |   18 ++++++++++++++++++
 include/linux/mlx4/driver.h               |    1 +
 3 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bf87a95..38061a0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1527,6 +1527,22 @@ unlock:
 	mutex_unlock(&ibdev->qp1_proxy_lock[port - 1]);
 }
 
+static struct net_device *mlx4_ib_get_netdev(struct ib_device *device, u8 port_num)
+{
+	struct mlx4_ib_dev *ibdev = to_mdev(device);
+
+	if (mlx4_is_bonded(ibdev->dev)) {
+		u8 true_port_num;
+
+		if (!mlx4_port_map_get(ibdev->dev, port_num, &true_port_num))
+			port_num = true_port_num;
+		else
+			return NULL;
+	}
+
+	return mlx4_get_protocol_dev(ibdev->dev, MLX4_PROT_ETH, port_num);
+}
+
 static void mlx4_ib_scan_netdevs(struct mlx4_ib_dev *ibdev,
 				 struct net_device *dev,
 				 unsigned long event)
@@ -1806,6 +1822,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
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
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
