From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 06/25] net/mlx5: Set uid as part of DCT commands
Date: Mon, 17 Sep 2018 14:03:59 +0300
Message-ID: <20180917110418.18937-7-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of DCT commands so that the firmware can manage the
DCT object in a secured way.

That will enable using a DCT that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 4 ++++
 include/linux/mlx5/mlx5_ifc.h                | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 9bdb3dc425ce..30f0e5ea7b2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -211,6 +211,7 @@ int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 	}
 
 	qp->qpn = MLX5_GET(create_dct_out, out, dctn);
+	qp->uid = MLX5_GET(create_dct_in, in, uid);
 	err = create_resource_common(dev, qp, MLX5_RES_DCT);
 	if (err)
 		goto err_cmd;
@@ -219,6 +220,7 @@ int mlx5_core_create_dct(struct mlx5_core_dev *dev,
 err_cmd:
 	MLX5_SET(destroy_dct_in, din, opcode, MLX5_CMD_OP_DESTROY_DCT);
 	MLX5_SET(destroy_dct_in, din, dctn, qp->qpn);
+	MLX5_SET(destroy_dct_in, din, uid, qp->uid);
 	mlx5_cmd_exec(dev, (void *)&in, sizeof(din),
 		      (void *)&out, sizeof(dout));
 	return err;
@@ -277,6 +279,7 @@ static int mlx5_core_drain_dct(struct mlx5_core_dev *dev,
 
 	MLX5_SET(drain_dct_in, in, opcode, MLX5_CMD_OP_DRAIN_DCT);
 	MLX5_SET(drain_dct_in, in, dctn, qp->qpn);
+	MLX5_SET(drain_dct_in, in, uid, qp->uid);
 	return mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
 			     (void *)&out, sizeof(out));
 }
@@ -303,6 +306,7 @@ int mlx5_core_destroy_dct(struct mlx5_core_dev *dev,
 	destroy_resource_common(dev, &dct->mqp);
 	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
 	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
+	MLX5_SET(destroy_dct_in, in, uid, qp->uid);
 	err = mlx5_cmd_exec(dev, (void *)&in, sizeof(in),
 			    (void *)&out, sizeof(out));
 	return err;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a2f0b02483a..efa4a60431d4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5919,7 +5919,7 @@ struct mlx5_ifc_drain_dct_out_bits {
 
 struct mlx5_ifc_drain_dct_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6383,7 +6383,7 @@ struct mlx5_ifc_destroy_dct_out_bits {
 
 struct mlx5_ifc_destroy_dct_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7139,7 +7139,7 @@ struct mlx5_ifc_create_dct_out_bits {
 
 struct mlx5_ifc_create_dct_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.14.4
