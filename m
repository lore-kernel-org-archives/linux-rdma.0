From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 01/10] IB/mlx5: Add support for setting source QP number
Date: Mon, 29 Feb 2016 15:45:03 +0200
Message-ID: <1456753512-17688-2-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In order to create multiple GSI QPs, we need to set the source QP number to
one on all these QPs. Add the necessary definitions and infrastructure to
do that.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 ++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c      | 18 +++++++++++++++++-
 include/linux/mlx5/mlx5_ifc.h        |  3 ++-
 include/linux/mlx5/qp.h              |  3 ++-
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d2b9737baa36..8dc6cd818baf 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -165,6 +165,18 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
 #define MLX5_IB_WR_UMR		IB_WR_RESERVED1
 
+/* Private QP creation flags to be passed in ib_qp_init_attr.create_flags.
+ *
+ * These flags are intended for internal use by the mlx5_ib driver, and they
+ * rely on the range reserved for that use in the ib_qp_create_flags enum.
+ */
+
+/* Create a UD QP whose source QP number is 1 */
+static inline enum ib_qp_create_flags mlx5_ib_create_qp_sqpn_qp1(void)
+{
+	return IB_QP_CREATE_RESERVED_START;
+}
+
 struct wr_list {
 	u16	opcode;
 	u16	next;
@@ -330,6 +342,8 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_CROSS_CHANNEL		= 1 << 2,
 	MLX5_IB_QP_MANAGED_SEND			= 1 << 3,
 	MLX5_IB_QP_MANAGED_RECV			= 1 << 4,
+	/* QP uses 1 as its source QP number */
+	MLX5_IB_QP_SQPN_QP1			= 1 << 5,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 34cb8e87c7b8..7cf789d1aa29 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -783,7 +783,9 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	int err;
 
 	uuari = &dev->mdev->priv.uuari;
-	if (init_attr->create_flags & ~(IB_QP_CREATE_SIGNATURE_EN | IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK))
+	if (init_attr->create_flags & ~(IB_QP_CREATE_SIGNATURE_EN |
+					IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
+					mlx5_ib_create_qp_sqpn_qp1()))
 		return -EINVAL;
 
 	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
@@ -828,6 +830,11 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	(*in)->ctx.params1 |= cpu_to_be32(1 << 11);
 	(*in)->ctx.sq_crq_size |= cpu_to_be16(1 << 4);
 
+	if (init_attr->create_flags & mlx5_ib_create_qp_sqpn_qp1()) {
+		(*in)->ctx.deth_sqpn = cpu_to_be32(1);
+		qp->flags |= MLX5_IB_QP_SQPN_QP1;
+	}
+
 	mlx5_fill_page_array(&qp->buf, (*in)->pas);
 
 	err = mlx5_db_alloc(dev->mdev, &qp->db);
@@ -1271,6 +1278,11 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 					    ucmd.sq_wqe_count, max_wqes);
 				return -EINVAL;
 			}
+			if (init_attr->create_flags &
+			    mlx5_ib_create_qp_sqpn_qp1()) {
+				mlx5_ib_dbg(dev, "user-space is not allowed to create UD QPs spoofing as QP1\n");
+				return -EINVAL;
+			}
 			err = create_user_qp(dev, pd, qp, udata, init_attr, &in,
 					     &resp, &inlen, base);
 			if (err)
@@ -2284,6 +2296,8 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
 		context->sq_crq_size |= cpu_to_be16(1 << 4);
 
+	if (qp->flags & MLX5_IB_QP_SQPN_QP1)
+		context->deth_sqpn = cpu_to_be32(1);
 
 	mlx5_cur = to_mlx5_state(cur_state);
 	mlx5_new = to_mlx5_state(new_state);
@@ -3874,6 +3888,8 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 		qp_init_attr->create_flags |= IB_QP_CREATE_MANAGED_SEND;
 	if (qp->flags & MLX5_IB_QP_MANAGED_RECV)
 		qp_init_attr->create_flags |= IB_QP_CREATE_MANAGED_RECV;
+	if (qp->flags & MLX5_IB_QP_SQPN_QP1)
+		qp_init_attr->create_flags |= mlx5_ib_create_qp_sqpn_qp1();
 
 	qp_init_attr->sq_sig_type = qp->sq_signal_bits & MLX5_WQE_CTRL_CQ_UPDATE ?
 		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 51f1e540fc2b..2b35ee445cc3 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -770,7 +770,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_22e[0x7];
 	u8         qkv[0x1];
 	u8         pkv[0x1];
-	u8         reserved_at_237[0x4];
+	u8         set_deth_sqpn[0x1];
+	u8         reserved_at_239[0x3];
 	u8         xrc[0x1];
 	u8         ud[0x1];
 	u8         uc[0x1];
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 5b8c89ffaa58..e5bbcf06de95 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -499,7 +499,8 @@ struct mlx5_qp_context {
 	u8			reserved2[4];
 	__be32			next_send_psn;
 	__be32			cqn_send;
-	u8			reserved3[8];
+	__be32			deth_sqpn;
+	u8			reserved3[4];
 	__be32			last_acked_psn;
 	__be32			ssn;
 	__be32			params2;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
