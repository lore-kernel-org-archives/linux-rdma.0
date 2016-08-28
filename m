From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Refactor raw packet QP modify function
Date: Sun, 28 Aug 2016 12:25:52 +0300
Message-ID: <1472376353-632-2-git-send-email-leon@kernel.org>
References: <1472376353-632-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472376353-632-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added a struct for modifying raw QP, this will allow modifying
multiple parameters in raw packet QP RQ and can also be used for
SQ in the future.

Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f3c943f..7686ee8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -77,6 +77,10 @@ struct mlx5_wqe_eth_pad {
 	u8 rsvd0[16];
 };
 
+struct mlx5_modify_raw_qp_param {
+	u16 operation;
+};
+
 static void get_cqs(enum ib_qp_type qp_type,
 		    struct ib_cq *ib_send_cq, struct ib_cq *ib_recv_cq,
 		    struct mlx5_ib_cq **send_cq, struct mlx5_ib_cq **recv_cq);
@@ -1862,7 +1866,7 @@ static void get_cqs(enum ib_qp_type qp_type,
 }
 
 static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
-				u16 operation);
+				const struct mlx5_modify_raw_qp_param *raw_qp_param);
 
 static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
@@ -1887,8 +1891,11 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 						  MLX5_CMD_OP_2RST_QP, 0,
 						  NULL, &base->mqp);
 		} else {
-			err = modify_raw_packet_qp(dev, qp,
-						   MLX5_CMD_OP_2RST_QP);
+			struct mlx5_modify_raw_qp_param raw_qp_param = {
+				.operation = MLX5_CMD_OP_2RST_QP
+			};
+
+			err = modify_raw_packet_qp(dev, qp, &raw_qp_param);
 		}
 		if (err)
 			mlx5_ib_warn(dev, "mlx5_ib: modify QP 0x%06x to RESET failed\n",
@@ -2421,7 +2428,7 @@ out:
 }
 
 static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
-				u16 operation)
+				const struct mlx5_modify_raw_qp_param *raw_qp_param)
 {
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
 	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
@@ -2430,7 +2437,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	int sq_state;
 	int err;
 
-	switch (operation) {
+	switch (raw_qp_param->operation) {
 	case MLX5_CMD_OP_RST2INIT_QP:
 		rq_state = MLX5_RQC_STATE_RDY;
 		sq_state = MLX5_SQC_STATE_RDY;
@@ -2689,11 +2696,16 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	optpar = ib_mask_to_mlx5_opt(attr_mask);
 	optpar &= opt_mask[mlx5_cur][mlx5_new][mlx5_st];
 
-	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET)
-		err = modify_raw_packet_qp(dev, qp, op);
-	else
+	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET) {
+		struct mlx5_modify_raw_qp_param raw_qp_param = {};
+
+		raw_qp_param.operation = op;
+		err = modify_raw_packet_qp(dev, qp, &raw_qp_param);
+	} else {
 		err = mlx5_core_qp_modify(dev->mdev, op, optpar, context,
 					  &base->mqp);
+	}
+
 	if (err)
 		goto out;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
