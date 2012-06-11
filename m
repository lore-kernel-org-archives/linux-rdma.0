From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 29/29] {NET,IB}/mlx4: Activate SRIOV mode for IB
Date: Mon, 11 Jun 2012 13:46:10 +0300
Message-ID: <1339411570-4689-30-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Note: RoCE is still not supported on slaves. This
patch will be changed for V1 to reflect this.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c       |    5 -----
 drivers/net/ethernet/mellanox/mlx4/fw.c |    6 ------
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 444c2fb..1d6ec3e 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1255,11 +1255,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	pr_info_once("%s", mlx4_ib_version);
 
-	if (mlx4_is_mfunc(dev)) {
-		pr_warn("IB not yet supported in SRIOV\n");
-		return NULL;
-	}
-
 	mlx4_foreach_ib_transport_port(i, dev)
 		num_ports++;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index bf93191..67d7482 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1342,9 +1342,6 @@ int mlx4_INIT_PORT_wrapper(struct mlx4_dev *dev, int slave,
 	if (priv->mfunc.master.slave_state[slave].init_port_mask & (1 << port))
 		return 0;
 
-	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_IB)
-		return -ENODEV;
-
 	if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB) {
 		/* Enable port only if it was previously disabled */
 		if (!priv->mfunc.master.init_port_ref[port]) {
@@ -1440,9 +1437,6 @@ int mlx4_CLOSE_PORT_wrapper(struct mlx4_dev *dev, int slave,
 	    (1 << port)))
 		return 0;
 
-	if (dev->caps.port_mask[port] == MLX4_PORT_TYPE_IB)
-		return -ENODEV;
-
 	if (dev->caps.port_mask[port] != MLX4_PORT_TYPE_IB) {
 		if (priv->mfunc.master.init_port_ref[port] == 1) {
 			err = mlx4_cmd(dev, 0, port, 0, MLX4_CMD_CLOSE_PORT,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
