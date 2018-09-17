From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 04/25] net/mlx5: Set uid as part of SQ commands
Date: Mon, 17 Sep 2018 14:03:57 +0300
Message-ID: <20180917110418.18937-5-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of SQ commands so that the firmware can manage the
SQ object in a secured way.

That will enable using an SQ that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 16 ++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h                |  6 +++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 0ca68ef54d93..9bdb3dc425ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -584,6 +584,17 @@ void mlx5_core_destroy_rq_tracked(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_core_destroy_rq_tracked);
 
+static void destroy_sq_tracked(struct mlx5_core_dev *dev, u32 sqn, u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_sq_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(destroy_sq_out)] = {0};
+
+	MLX5_SET(destroy_sq_in, in, opcode, MLX5_CMD_OP_DESTROY_SQ);
+	MLX5_SET(destroy_sq_in, in, sqn, sqn);
+	MLX5_SET(destroy_sq_in, in, uid, uid);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
 int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 				struct mlx5_core_qp *sq)
 {
@@ -594,6 +605,7 @@ int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 	if (err)
 		return err;
 
+	sq->uid = MLX5_GET(create_sq_in, in, uid);
 	sq->qpn = sqn;
 	err = create_resource_common(dev, sq, MLX5_RES_SQ);
 	if (err)
@@ -602,7 +614,7 @@ int mlx5_core_create_sq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 	return 0;
 
 err_destroy_sq:
-	mlx5_core_destroy_sq(dev, sq->qpn);
+	destroy_sq_tracked(dev, sq->qpn, sq->uid);
 
 	return err;
 }
@@ -612,7 +624,7 @@ void mlx5_core_destroy_sq_tracked(struct mlx5_core_dev *dev,
 				  struct mlx5_core_qp *sq)
 {
 	destroy_resource_common(dev, sq);
-	mlx5_core_destroy_sq(dev, sq->qpn);
+	destroy_sq_tracked(dev, sq->qpn, sq->uid);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_sq_tracked);
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 01b707666fb4..8151488f6570 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5382,7 +5382,7 @@ struct mlx5_ifc_modify_sq_out_bits {
 
 struct mlx5_ifc_modify_sq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6097,7 +6097,7 @@ struct mlx5_ifc_destroy_sq_out_bits {
 
 struct mlx5_ifc_destroy_sq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6770,7 +6770,7 @@ struct mlx5_ifc_create_sq_out_bits {
 
 struct mlx5_ifc_create_sq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.14.4
