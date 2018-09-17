From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 16/25] IB/mlx5: Set uid as part of TD commands
Date: Mon, 17 Sep 2018 14:04:09 +0300
Message-ID: <20180917110418.18937-17-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of TD commands so that the firmware can
manage the TD object in a secured way.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c  | 30 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h  |  4 ++++
 drivers/infiniband/hw/mlx5/main.c | 33 ++++++++++++++++++---------------
 3 files changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 5560346102bd..9da10fbb7e23 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -241,3 +241,33 @@ void mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid)
 	MLX5_SET(dealloc_pd_in, in, uid, uid);
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+
+int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
+				    u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(alloc_transport_domain_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_transport_domain_out)] = {0};
+	int err;
+
+	MLX5_SET(alloc_transport_domain_in, in, opcode,
+		 MLX5_CMD_OP_ALLOC_TRANSPORT_DOMAIN);
+
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*tdn = MLX5_GET(alloc_transport_domain_out, out,
+				transport_domain);
+
+	return err;
+}
+
+void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
+				       u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(dealloc_transport_domain_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(dealloc_transport_domain_out)] = {0};
+
+	MLX5_SET(dealloc_transport_domain_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_TRANSPORT_DOMAIN);
+	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index b47e98b8a53a..3a1d611216fb 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -51,4 +51,8 @@ void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
 void mlx5_cmd_destroy_tis(struct mlx5_core_dev *dev, u32 tisn, u16 uid);
 void mlx5_cmd_destroy_rqt(struct mlx5_core_dev *dev, u32 rqtn, u16 uid);
 void mlx5_cmd_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn, u16 uid);
+int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
+				    u16 uid);
+void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
+				       u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7e6fd5553ab3..c1f94bc09606 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1613,14 +1613,15 @@ void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	mutex_unlock(&dev->lb.mutex);
 }
 
-static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn)
+static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn,
+					  u16 uid)
 {
 	int err;
 
 	if (!MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
 		return 0;
 
-	err = mlx5_core_alloc_transport_domain(dev->mdev, tdn);
+	err = mlx5_cmd_alloc_transport_domain(dev->mdev, tdn, uid);
 	if (err)
 		return err;
 
@@ -1632,12 +1633,13 @@ static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn)
 	return mlx5_ib_enable_lb(dev, true, false);
 }
 
-static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn)
+static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn,
+					     u16 uid)
 {
 	if (!MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
 		return;
 
-	mlx5_core_dealloc_transport_domain(dev->mdev, tdn);
+	mlx5_cmd_dealloc_transport_domain(dev->mdev, tdn, uid);
 
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
 	    (!MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) &&
@@ -1756,22 +1758,23 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	context->ibucontext.invalidate_range = &mlx5_ib_invalidate_range;
 #endif
 
-	err = mlx5_ib_alloc_transport_domain(dev, &context->tdn);
-	if (err)
-		goto out_uars;
-
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
 		/* Block DEVX on Infiniband as of SELinux */
 		if (mlx5_ib_port_link_layer(ibdev, 1) != IB_LINK_LAYER_ETHERNET) {
 			err = -EPERM;
-			goto out_td;
+			goto out_uars;
 		}
 
 		err = mlx5_ib_devx_create(dev, context);
 		if (err)
-			goto out_td;
+			goto out_uars;
 	}
 
+	err = mlx5_ib_alloc_transport_domain(dev, &context->tdn,
+					     context->devx_uid);
+	if (err)
+		goto out_devx;
+
 	if (MLX5_CAP_GEN(dev->mdev, dump_fill_mkey)) {
 		err = mlx5_cmd_dump_fill_mkey(dev->mdev, &dump_fill_mkey);
 		if (err)
@@ -1866,10 +1869,10 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	return &context->ibucontext;
 
 out_mdev:
+	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
+out_devx:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX)
 		mlx5_ib_devx_destroy(dev, context);
-out_td:
-	mlx5_ib_dealloc_transport_domain(dev, context->tdn);
 
 out_uars:
 	deallocate_uars(dev, context);
@@ -1892,12 +1895,12 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	struct mlx5_ib_dev *dev = to_mdev(ibcontext->device);
 	struct mlx5_bfreg_info *bfregi;
 
+	bfregi = &context->bfregi;
+	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
+
 	if (context->devx_uid)
 		mlx5_ib_devx_destroy(dev, context);
 
-	bfregi = &context->bfregi;
-	mlx5_ib_dealloc_transport_domain(dev, context->tdn);
-
 	deallocate_uars(dev, context);
 	kfree(bfregi->sys_pages);
 	kfree(bfregi->count);
-- 
2.14.4
