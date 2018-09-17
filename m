From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 01/25] net/mlx5: Set uid as part of CQ commands
Date: Mon, 17 Sep 2018 14:03:54 +0300
Message-ID: <20180917110418.18937-2-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of CQ commands so that the firmware can manage the CQ
object in a secured way.

This will enable using a CQ that was created by verbs application to be
used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c | 4 ++++
 include/linux/mlx5/cq.h                      | 1 +
 include/linux/mlx5/mlx5_ifc.h                | 6 +++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index a4179122a279..4b85abb5c9f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -109,6 +109,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	cq->cons_index = 0;
 	cq->arm_sn     = 0;
 	cq->eq         = eq;
+	cq->uid = MLX5_GET(create_cq_in, in, uid);
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 	if (!cq->comp)
@@ -144,6 +145,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	memset(dout, 0, sizeof(dout));
 	MLX5_SET(destroy_cq_in, din, opcode, MLX5_CMD_OP_DESTROY_CQ);
 	MLX5_SET(destroy_cq_in, din, cqn, cq->cqn);
+	MLX5_SET(destroy_cq_in, din, uid, cq->uid);
 	mlx5_cmd_exec(dev, din, sizeof(din), dout, sizeof(dout));
 	return err;
 }
@@ -165,6 +167,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 
 	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
 	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
+	MLX5_SET(destroy_cq_in, in, uid, cq->uid);
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 	if (err)
 		return err;
@@ -196,6 +199,7 @@ int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {0};
 
 	MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
+	MLX5_SET(modify_cq_in, in, uid, cq->uid);
 	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 }
 EXPORT_SYMBOL(mlx5_core_modify_cq);
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 0ef6138eca49..31a750570c38 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -61,6 +61,7 @@ struct mlx5_core_cq {
 	int			reset_notify_added;
 	struct list_head	reset_notify;
 	struct mlx5_eq		*eq;
+	u16 uid;
 };
 
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a14c4eaff53f..e62a0825d35c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5630,7 +5630,7 @@ enum {
 
 struct mlx5_ifc_modify_cq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6405,7 +6405,7 @@ struct mlx5_ifc_destroy_cq_out_bits {
 
 struct mlx5_ifc_destroy_cq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7165,7 +7165,7 @@ struct mlx5_ifc_create_cq_out_bits {
 
 struct mlx5_ifc_create_cq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.14.4
