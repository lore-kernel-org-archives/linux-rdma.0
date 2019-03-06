From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] net/mlx5: Fix DCT creation bad flow
Date: Wed,  6 Mar 2019 19:20:50 +0200
Message-ID: <20190306172050.20033-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

In case the DCT creation command has succeeded a DRAIN must be issued
before calling DESTROY.

In addition, the original code used the wrong parameter for the DESTROY
command, 'in' instead of 'din', which caused another creation try
instead of destroying.

Cc: <stable@vger.kernel.org> # 4.15
Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Jason, Doug

If it is possible, I would like to take this patch too:
https://patchwork.kernel.org/patch/10828299/

Thanks
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 64 +++++++++++---------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 370ca94b6775..54cdfb354c0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -40,6 +40,9 @@
 #include "mlx5_core.h"
 #include "lib/eq.h"

+static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
+			       struct mlx5_core_dct *dct);
+
 static struct mlx5_core_rsc_common *
 mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 {
@@ -227,13 +230,40 @@ static void destroy_resource_common(struct mlx5_core_dev *dev,
 	wait_for_completion(&qp->common.free);
 }

+static int _mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
+				  struct mlx5_core_dct *dct, bool need_cleanup)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
+	struct mlx5_core_qp *qp = &dct->mqp;
+	int err;
+
+	err = mlx5_core_drain_dct(dev, dct);
+	if (err) {
+		if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
+			goto destroy;
+		} else {
+			mlx5_core_warn(dev, "failed drain DCT 0x%x with error 0x%x\n", qp->qpn, err);
+			return err;
+		}
+	}
+	wait_for_completion(&dct->drained);
+destroy:
+	if (need_cleanup)
+		destroy_resource_common(dev, &dct->mqp);
+	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
+	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
+	MLX5_SET(destroy_dct_in, in, uid, qp->uid);
+	err = mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
+			    (void *)&out, sizeof(out));
+	return err;
+}
+
 int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 			 struct mlx5_core_dct *dct,
 			 u32 *in, int inlen)
 {
 	u32 out[MLX5_ST_SZ_DW(create_dct_out)]   = {0};
-	u32 din[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
-	u32 dout[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
 	struct mlx5_core_qp *qp = &dct->mqp;
 	int err;

@@ -254,11 +284,7 @@ int mlx5_core_create_dct(struct mlx5_core_dev *dev,

 	return 0;
 err_cmd:
-	MLX5_SET(destroy_dct_in, din, opcode, MLX5_CMD_OP_DESTROY_DCT);
-	MLX5_SET(destroy_dct_in, din, dctn, qp->qpn);
-	MLX5_SET(destroy_dct_in, din, uid, qp->uid);
-	mlx5_cmd_exec(dev, (void *)&in, sizeof(din),
-		      (void *)&out, sizeof(dout));
+	_mlx5_core_destroy_dct(dev, dct, false);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_core_create_dct);
@@ -323,29 +349,7 @@ static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
 int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
 			  struct mlx5_core_dct *dct)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_dct_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)]   = {0};
-	struct mlx5_core_qp *qp = &dct->mqp;
-	int err;
-
-	err = mlx5_core_drain_dct(dev, dct);
-	if (err) {
-		if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
-			goto destroy;
-		} else {
-			mlx5_core_warn(dev, "failed drain DCT 0x%x with error 0x%x\n", qp->qpn, err);
-			return err;
-		}
-	}
-	wait_for_completion(&dct->drained);
-destroy:
-	destroy_resource_common(dev, &dct->mqp);
-	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
-	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
-	MLX5_SET(destroy_dct_in, in, uid, qp->uid);
-	err = mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
-			    (void *)&out, sizeof(out));
-	return err;
+	return _mlx5_core_destroy_dct(dev, dct, true);
 }
 EXPORT_SYMBOL_GPL(mlx5_core_destroy_dct);
