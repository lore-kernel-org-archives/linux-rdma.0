From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 03/25] net/mlx5: Set uid as part of RQ commands
Date: Mon, 17 Sep 2018 14:03:56 +0300
Message-ID: <20180917110418.18937-4-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of RQ commands so that the firmware can manage the
RQ object in a secured way.

That will enable using an RQ that was created by verbs application
to be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 16 ++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h                |  6 +++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index 04f72a1cdbcc..0ca68ef54d93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -540,6 +540,17 @@ int mlx5_core_xrcd_dealloc(struct mlx5_core_dev *dev, u32 xrcdn)
 }
 EXPORT_SYMBOL_GPL(mlx5_core_xrcd_dealloc);
 
+static void destroy_rq_tracked(struct mlx5_core_dev *dev, u32 rqn, u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_rq_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(destroy_rq_out)] = {0};
+
+	MLX5_SET(destroy_rq_in, in, opcode, MLX5_CMD_OP_DESTROY_RQ);
+	MLX5_SET(destroy_rq_in, in, rqn, rqn);
+	MLX5_SET(destroy_rq_in, in, uid, uid);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
 int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 				struct mlx5_core_qp *rq)
 {
@@ -550,6 +561,7 @@ int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 	if (err)
 		return err;
 
+	rq->uid = MLX5_GET(create_rq_in, in, uid);
 	rq->qpn = rqn;
 	err = create_resource_common(dev, rq, MLX5_RES_RQ);
 	if (err)
@@ -558,7 +570,7 @@ int mlx5_core_create_rq_tracked(struct mlx5_core_dev *dev, u32 *in, int inlen,
 	return 0;
 
 err_destroy_rq:
-	mlx5_core_destroy_rq(dev, rq->qpn);
+	destroy_rq_tracked(dev, rq->qpn, rq->uid);
 
 	return err;
 }
@@ -568,7 +580,7 @@ void mlx5_core_destroy_rq_tracked(struct mlx5_core_dev *dev,
 				  struct mlx5_core_qp *rq)
 {
 	destroy_resource_common(dev, rq);
-	mlx5_core_destroy_rq(dev, rq->qpn);
+	destroy_rq_tracked(dev, rq->qpn, rq->uid);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_rq_tracked);
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e5a0d3ecfaad..01b707666fb4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5489,7 +5489,7 @@ enum {
 
 struct mlx5_ifc_modify_rq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6165,7 +6165,7 @@ struct mlx5_ifc_destroy_rq_out_bits {
 
 struct mlx5_ifc_destroy_rq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -6848,7 +6848,7 @@ struct mlx5_ifc_create_rq_out_bits {
 
 struct mlx5_ifc_create_rq_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.14.4
