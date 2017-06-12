From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/3] IB/mlx5: Support out of order data placement
Date: Mon, 12 Jun 2017 09:49:18 +0300
Message-ID: <20170612064918.12510-4-leon@kernel.org>
References: <20170612064918.12510-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170612064918.12510-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch sets out of order data placement capability whenever
device supports it. Currently its supports on RC and XRC QPs.
It also extends the support to set such attribute for a QP during
state transition.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 12 ++++++++++++
 drivers/infiniband/hw/mlx5/qp.c   | 25 +++++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h     |  5 ++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 0c79983c8b1a..7f5284c08b8d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -572,6 +572,16 @@ static int mlx5_query_node_desc(struct mlx5_ib_dev *dev, char *node_desc)
 				    MLX5_REG_NODE_DESC, 0, 0);
 }
 
+static void mlx5_ib_fill_ooo_caps(struct mlx5_ib_dev *dev,
+				  struct ib_ooo_caps *caps)
+{
+	if (MLX5_CAP_GEN(dev->mdev, multi_path_rc_rdma))
+		caps->rc_caps |= IB_OOO_RW_DATA_PLACEMENT;
+
+	if (MLX5_CAP_GEN(dev->mdev, multi_path_xrc_rdma))
+		caps->xrc_caps |= IB_OOO_RW_DATA_PLACEMENT;
+}
+
 static int mlx5_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props,
 				struct ib_udata *uhw)
@@ -765,6 +775,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
 	}
 
+	mlx5_ib_fill_ooo_caps(dev, &props->ooo_caps);
+
 	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
 		resp.cqe_comp_caps.max_num =
 			MLX5_CAP_GEN(dev->mdev, cqe_compression) ?
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ebb6768684de..bbe616e373b3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -54,6 +54,10 @@ enum {
 	MLX5_IB_SQ_STRIDE	= 6,
 };
 
+enum {
+	MLX5_QP_OOO_ATTR	= 25,
+};
+
 static const u32 mlx5_ib_opcode[] = {
 	[IB_WR_SEND]				= MLX5_OPCODE_SEND,
 	[IB_WR_LSO]				= MLX5_OPCODE_LSO,
@@ -2810,6 +2814,27 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (qp->flags & MLX5_IB_QP_SQPN_QP1)
 		context->deth_sqpn = cpu_to_be32(1);
 
+	if (attr_mask & IB_QP_OOO_RW_DATA_PLACEMENT) {
+		if (ibqp->qp_type == IB_QPT_RC) {
+			if (MLX5_CAP_GEN(dev->mdev, multi_path_rc_rdma)) {
+				context->flags_pd |=
+					cpu_to_be32(1 << MLX5_QP_OOO_ATTR);
+			} else {
+				err = -EINVAL;
+				goto out;
+			}
+		} else if (ibqp->qp_type == IB_QPT_XRC_INI ||
+			   ibqp->qp_type == IB_QPT_XRC_TGT) {
+			if (MLX5_CAP_GEN(dev->mdev, multi_path_xrc_rdma)) {
+				context->flags_pd |=
+					cpu_to_be32(1 << MLX5_QP_OOO_ATTR);
+			} else {
+				err = -EINVAL;
+				goto out;
+			}
+		}
+	}
+
 	mlx5_cur = to_mlx5_state(cur_state);
 	mlx5_new = to_mlx5_state(new_state);
 	mlx5_st = to_mlx5_st(ibqp->qp_type);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index edafedb7b509..3d1e77e97552 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -856,7 +856,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         pps[0x1];
 	u8         pps_modify[0x1];
 	u8         log_max_msg[0x5];
-	u8         reserved_at_1c8[0x4];
+	u8         multi_path_xrc_rdma[0x1];
+	u8         reserved_at_1c9[0x1];
+	u8         multi_path_rc_rdma[0x1];
+	u8         reserved_at_1cb[0x1];
 	u8         max_tc[0x4];
 	u8         reserved_at_1d0[0x1];
 	u8         dcbx[0x1];
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
