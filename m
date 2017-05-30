From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/3] IB/mlx5: Add raw ethernet local loopback support
Date: Tue, 30 May 2017 09:42:54 +0300
Message-ID: <20170530064255.3745-3-leon@kernel.org>
References: <20170530064255.3745-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530064255.3745-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, unicast/multicast loopback raw ethernet
(non-RDMA) packets are sent back to the vport.
A unicast loopback packet is the packet with destination
MAC address the same as the source MAC address.
For multicast, the destination MAC address is in the
vport's multicast filter list.

Moreover, the local loopback is not needed if
there is one or none user space context.

After this patch, the raw ethernet unicast and multicast
local loopback are disabled by default. When there is more
than one user space context, the local loopback is enabled.

Note that when local loopback is disabled, raw ethernet
packets are not looped back to the vport and are forwarded
to the next routing level (eswitch, or multihost switch,
or out to the wire depending on the configuration).

Signed-off-by: Huy Nguyen <huyn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c              | 51 ++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |  4 ++
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 19 ++++++++++
 3 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d45772da0963..69412baf2bf9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -58,6 +58,7 @@
 #include <linux/mlx5/vport.h>
 #include "mlx5_ib.h"
 #include "cmd.h"
+#include <linux/mlx5/vport.h>

 #define DRIVER_NAME "mlx5_ib"
 #define DRIVER_VERSION "2.2-1"
@@ -1201,6 +1202,45 @@ static int deallocate_uars(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *con
 	return 0;
 }

+static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn)
+{
+	int err;
+
+	err = mlx5_core_alloc_transport_domain(dev->mdev, tdn);
+	if (err)
+		return err;
+
+	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
+	    !MLX5_CAP_GEN(dev->mdev, disable_local_lb))
+		return err;
+
+	mutex_lock(&dev->lb_mutex);
+	dev->user_td++;
+
+	if (dev->user_td == 2)
+		err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+
+	mutex_unlock(&dev->lb_mutex);
+	return err;
+}
+
+static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn)
+{
+	mlx5_core_dealloc_transport_domain(dev->mdev, tdn);
+
+	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
+	    !MLX5_CAP_GEN(dev->mdev, disable_local_lb))
+		return;
+
+	mutex_lock(&dev->lb_mutex);
+	dev->user_td--;
+
+	if (dev->user_td < 2)
+		mlx5_nic_vport_update_local_lb(dev->mdev, false);
+
+	mutex_unlock(&dev->lb_mutex);
+}
+
 static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 						  struct ib_udata *udata)
 {
@@ -1309,8 +1349,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	mutex_init(&context->upd_xlt_page_mutex);

 	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain)) {
-		err = mlx5_core_alloc_transport_domain(dev->mdev,
-						       &context->tdn);
+		err = mlx5_ib_alloc_transport_domain(dev, &context->tdn);
 		if (err)
 			goto out_page;
 	}
@@ -1376,7 +1415,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,

 out_td:
 	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
-		mlx5_core_dealloc_transport_domain(dev->mdev, context->tdn);
+		mlx5_ib_dealloc_transport_domain(dev, context->tdn);

 out_page:
 	free_page(context->upd_xlt_page);
@@ -1404,7 +1443,7 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)

 	bfregi = &context->bfregi;
 	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
-		mlx5_core_dealloc_transport_domain(dev->mdev, context->tdn);
+		mlx5_ib_dealloc_transport_domain(dev, context->tdn);

 	free_page(context->upd_xlt_page);
 	deallocate_uars(dev, context);
@@ -3788,6 +3827,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 			goto err_umrc;
 	}

+	if ((MLX5_CAP_GEN(mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
+	    MLX5_CAP_GEN(mdev, disable_local_lb))
+		mutex_init(&dev->lb_mutex);
+
 	dev->ib_active = true;

 	return dev;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 38c877bc45e5..a6a563b9c92c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -654,6 +654,10 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_port	*port;
 	struct mlx5_sq_bfreg     bfreg;
 	struct mlx5_sq_bfreg     fp_bfreg;
+
+	/* protect the user_td */
+	struct mutex             lb_mutex;
+	u32                      user_td;
 };

 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0c123d571b4c..1cafcae97aea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -47,6 +47,7 @@
 #include <linux/debugfs.h>
 #include <linux/kmod.h>
 #include <linux/mlx5/mlx5_ifc.h>
+#include <linux/mlx5/vport.h>
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
 #endif
@@ -574,6 +575,18 @@ static int set_hca_ctrl(struct mlx5_core_dev *dev)
 	return err;
 }

+static int mlx5_core_set_hca_defaults(struct mlx5_core_dev *dev)
+{
+	int ret = 0;
+
+	/* Disable local_lb by default */
+	if ((MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
+	    MLX5_CAP_GEN(dev, disable_local_lb))
+		ret = mlx5_nic_vport_update_local_lb(dev, false);
+
+	return ret;
+}
+
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
 {
 	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {0};
@@ -1137,6 +1150,12 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_fs;
 	}

+	err = mlx5_core_set_hca_defaults(dev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set hca defaults\n");
+		goto err_fs;
+	}
+
 #ifdef CONFIG_MLX5_CORE_EN
 	mlx5_eswitch_attach(dev->priv.eswitch);
 #endif
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
