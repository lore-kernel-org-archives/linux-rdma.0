From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V2 19/22] {NET,IB}/mlx4: Activate SRIOV mode for IB
Date: Fri,  3 Aug 2012 11:40:55 +0300
Message-ID: <1343983258-6268-20-git-send-email-jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343983258-6268-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the error returns for IB ports from mlx4_ib_add,
mlx4_INIT_PORT_wrapper, and mlx4_CLOSE_PORT_wrapper.

Currently, SRIOV is supported only for devices for which the
link-layer is IB on all ports; RoCE support will be implemented at later time.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c       |    8 ++++++--
 drivers/net/ethernet/mellanox/mlx4/fw.c |    6 ------
 include/linux/mlx4/device.h             |    4 ++++
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1166379..00384b3 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1292,11 +1292,15 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	pr_info_once("%s", mlx4_ib_version);
 
-	if (mlx4_is_mfunc(dev)) {
-		pr_warn("IB not yet supported in SRIOV\n");
+	mlx4_foreach_non_ib_transport_port(i, dev)
+		num_ports++;
+
+	if (mlx4_is_mfunc(dev) && num_ports) {
+		dev_err(&dev->pdev->dev, "RoCE is not supported over SRIOV as yet\n");
 		return NULL;
 	}
 
+	num_ports = 0;
 	mlx4_foreach_ib_transport_port(i, dev)
 		num_ports++;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index 1d11e81..e36cbdb 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1391,9 +1391,6 @@ int mlx4_INIT_PORT_wrapper(struct mlx4_dev *dev, int slave,
 	if (priv->mfunc.master.slave_state[slave].init_port_mask & (1 << port))
 		return 0;
 
-	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_IB)
-		return -ENODEV;
-
 	if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB) {
 		/* Enable port only if it was previously disabled */
 		if (!priv->mfunc.master.init_port_ref[port]) {
@@ -1489,9 +1486,6 @@ int mlx4_CLOSE_PORT_wrapper(struct mlx4_dev *dev, int slave,
 	    (1 << port)))
 		return 0;
 
-	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_IB)
-		return -ENODEV;
-
 	if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB) {
 		if (priv->mfunc.master.init_port_ref[port] == 1) {
 			err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT,
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 863fcea..f8c9316 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -697,6 +697,10 @@ struct mlx4_init_port_param {
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	\
 		if ((type) == (dev)->caps.port_mask[(port)])
 
+#define mlx4_foreach_non_ib_transport_port(port, dev)                     \
+	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	  \
+		if (((dev)->caps.port_mask[port] != MLX4_PORT_TYPE_IB))
+
 #define mlx4_foreach_ib_transport_port(port, dev)                         \
 	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	  \
 		if (((dev)->caps.port_mask[port] == MLX4_PORT_TYPE_IB) || \
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
