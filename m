From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 19/25] IB/mlx5: Set uid as part of XRCD commands
Date: Mon, 17 Sep 2018 14:04:12 +0300
Message-ID: <20180917110418.18937-20-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of XRCD commands so that the firmware can manage the
XRCD object in a secured way.

That will enable using an XRCD that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c     | 25 +++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/cmd.h     |  2 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      |  8 ++++++--
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 9da10fbb7e23..51c39bc77ac7 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -271,3 +271,28 @@ void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
 	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
+
+int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid)
+{
+	u32 out[MLX5_ST_SZ_DW(alloc_xrcd_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(alloc_xrcd_in)]   = {0};
+	int err;
+
+	MLX5_SET(alloc_xrcd_in, in, opcode, MLX5_CMD_OP_ALLOC_XRCD);
+	MLX5_SET(alloc_xrcd_in, in, uid, uid);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (!err)
+		*xrcdn = MLX5_GET(alloc_xrcd_out, out, xrcd);
+	return err;
+}
+
+int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_xrcd_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_xrcd_in)]   = {0};
+
+	MLX5_SET(dealloc_xrcd_in, in, opcode, MLX5_CMD_OP_DEALLOC_XRCD);
+	MLX5_SET(dealloc_xrcd_in, in, xrcd, xrcdn);
+	MLX5_SET(dealloc_xrcd_in, in, uid, uid);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 3a1d611216fb..76823e86fd17 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -55,4 +55,6 @@ int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
 				    u16 uid);
 void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
 				       u16 uid);
+int mlx5_cmd_xrcd_alloc(struct mlx5_core_dev *dev, u32 *xrcdn, u16 uid);
+int mlx5_cmd_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 88ea0df71d94..f582bd05c180 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -548,6 +548,7 @@ struct mlx5_ib_srq {
 struct mlx5_ib_xrcd {
 	struct ib_xrcd		ibxrcd;
 	u32			xrcdn;
+	u16			uid;
 };
 
 enum mlx5_ib_mtt_access_flags {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1a3b79405260..00b36b971ffa 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5341,6 +5341,7 @@ struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_xrcd *xrcd;
 	int err;
+	u16 uid;
 
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
 		return ERR_PTR(-ENOSYS);
@@ -5349,12 +5350,14 @@ struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 	if (!xrcd)
 		return ERR_PTR(-ENOMEM);
 
-	err = mlx5_core_xrcd_alloc(dev->mdev, &xrcd->xrcdn);
+	uid = context ? to_mucontext(context)->devx_uid : 0;
+	err = mlx5_cmd_xrcd_alloc(dev->mdev, &xrcd->xrcdn, uid);
 	if (err) {
 		kfree(xrcd);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	xrcd->uid = uid;
 	return &xrcd->ibxrcd;
 }
 
@@ -5362,9 +5365,10 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 {
 	struct mlx5_ib_dev *dev = to_mdev(xrcd->device);
 	u32 xrcdn = to_mxrcd(xrcd)->xrcdn;
+	u16 uid =  to_mxrcd(xrcd)->uid;
 	int err;
 
-	err = mlx5_core_xrcd_dealloc(dev->mdev, xrcdn);
+	err = mlx5_cmd_xrcd_dealloc(dev->mdev, xrcdn, uid);
 	if (err)
 		mlx5_ib_warn(dev, "failed to dealloc xrcdn 0x%x\n", xrcdn);
 
-- 
2.14.4
