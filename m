From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 12/25] IB/mlx5: Set uid as part of TIR commands
Date: Mon, 17 Sep 2018 14:04:05 +0300
Message-ID: <20180917110418.18937-13-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Set uid as part of TIR commands so that the firmware can manage the
TIR object in a secured way.

That will enable using a TIR that was created by verbs application to
be used by the DEVX flow in case the uid is equal.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c | 11 +++++++++++
 drivers/infiniband/hw/mlx5/cmd.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c  | 24 ++++++++++++++++--------
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index c84fef9a8a08..e150ae44e06a 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -197,3 +197,14 @@ int mlx5_cmd_query_ext_ppcnt_counters(struct mlx5_core_dev *dev, void *out)
 	return  mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPCNT,
 				     0, 0);
 }
+
+void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_tir_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(destroy_tir_out)] = {0};
+
+	MLX5_SET(destroy_tir_in, in, opcode, MLX5_CMD_OP_DESTROY_TIR);
+	MLX5_SET(destroy_tir_in, in, tirn, tirn);
+	MLX5_SET(destroy_tir_in, in, uid, uid);
+	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 88cbb1c41703..274090a38c4b 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -47,4 +47,5 @@ int mlx5_cmd_modify_cong_params(struct mlx5_core_dev *mdev,
 int mlx5_cmd_alloc_memic(struct mlx5_memic *memic, phys_addr_t *addr,
 			 u64 length, u32 alignment);
 int mlx5_cmd_dealloc_memic(struct mlx5_memic *memic, u64 addr, u64 length);
+void mlx5_cmd_destroy_tir(struct mlx5_core_dev *dev, u32 tirn, u16 uid);
 #endif /* MLX5_IB_CMD_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 24370635008e..07bf5128bee4 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -37,6 +37,7 @@
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
 #include "ib_rep.h"
+#include "cmd.h"
 
 /* not supported currently */
 static int wq_signature;
@@ -1262,17 +1263,19 @@ static bool tunnel_offload_supported(struct mlx5_core_dev *dev)
 
 static void destroy_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 				      struct mlx5_ib_rq *rq,
-				      u32 qp_flags_en)
+				      u32 qp_flags_en,
+				      u16 uid)
 {
 	if (qp_flags_en & (MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC |
 			   MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC))
 		mlx5_ib_disable_lb(dev, false, true);
-	mlx5_core_destroy_tir(dev->mdev, rq->tirn);
+	mlx5_cmd_destroy_tir(dev->mdev, rq->tirn, uid);
 }
 
 static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_rq *rq, u32 tdn,
-				    u32 *qp_flags_en)
+				    u32 *qp_flags_en,
+				    u16 uid)
 {
 	u8 lb_flag = 0;
 	u32 *in;
@@ -1285,6 +1288,7 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 	if (!in)
 		return -ENOMEM;
 
+	MLX5_SET(create_tir_in, in, uid, uid);
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 	MLX5_SET(tirc, tirc, disp_type, MLX5_TIRC_DISP_TYPE_DIRECT);
 	MLX5_SET(tirc, tirc, inline_rqn, rq->base.mqp.qpn);
@@ -1311,7 +1315,7 @@ static int create_raw_packet_qp_tir(struct mlx5_ib_dev *dev,
 		err = mlx5_ib_enable_lb(dev, false, true);
 
 		if (err)
-			destroy_raw_packet_qp_tir(dev, rq, 0);
+			destroy_raw_packet_qp_tir(dev, rq, 0, uid);
 	}
 	kvfree(in);
 
@@ -1356,8 +1360,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			goto err_destroy_sq;
 
-
-		err = create_raw_packet_qp_tir(dev, rq, tdn, &qp->flags_en);
+		err = create_raw_packet_qp_tir(dev, rq, tdn, &qp->flags_en,
+					       uid);
 		if (err)
 			goto err_destroy_rq;
 	}
@@ -1385,9 +1389,10 @@ static void destroy_raw_packet_qp(struct mlx5_ib_dev *dev,
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
 	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
 	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
+	u16 uid = to_mucontext(qp->ibqp.uobject->context)->devx_uid;
 
 	if (qp->rq.wqe_cnt) {
-		destroy_raw_packet_qp_tir(dev, rq, qp->flags_en);
+		destroy_raw_packet_qp_tir(dev, rq, qp->flags_en, uid);
 		destroy_raw_packet_qp_rq(dev, rq);
 	}
 
@@ -1411,10 +1416,12 @@ static void raw_packet_qp_copy_info(struct mlx5_ib_qp *qp,
 
 static void destroy_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
+	u16 uid = to_mucontext(qp->ibqp.uobject->context)->devx_uid;
+
 	if (qp->flags_en & (MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_UC |
 			    MLX5_QP_FLAG_TIR_ALLOW_SELF_LB_MC))
 		mlx5_ib_disable_lb(dev, false, true);
-	mlx5_core_destroy_tir(dev->mdev, qp->rss_qp.tirn);
+	mlx5_cmd_destroy_tir(dev->mdev, qp->rss_qp.tirn, uid);
 }
 
 static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
@@ -1512,6 +1519,7 @@ static int create_rss_raw_qp_tir(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (!in)
 		return -ENOMEM;
 
+	MLX5_SET(create_tir_in, in, uid, mucontext->devx_uid);
 	tirc = MLX5_ADDR_OF(create_tir_in, in, ctx);
 	MLX5_SET(tirc, tirc, disp_type,
 		 MLX5_TIRC_DISP_TYPE_INDIRECT);
-- 
2.14.4
