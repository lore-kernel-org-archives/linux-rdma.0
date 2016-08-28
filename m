From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Add port counter support for raw packet QP
Date: Sun, 28 Aug 2016 12:25:53 +0300
Message-ID: <1472376353-632-3-git-send-email-leon@kernel.org>
References: <1472376353-632-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472376353-632-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Counters weren't updated due to raw packet QPs' traffic since the
counter-id was not associated with the QP. Added support for
associating the q-counter-id with the raw packet QP. The attachment
is done only when changing RQ raw packet QP state from RST to INIT
in modify-RQ command. FW support is required for the above, without
this support raw packet QP counters will not count.

Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7686ee8..b4dc71b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -77,8 +77,15 @@ struct mlx5_wqe_eth_pad {
 	u8 rsvd0[16];
 };
 
+enum raw_qp_set_mask_map {
+	MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID		= 1UL << 0,
+};
+
 struct mlx5_modify_raw_qp_param {
 	u16 operation;
+
+	u32 set_mask; /* raw_qp_set_mask_map */
+	u8 rq_q_ctr_id;
 };
 
 static void get_cqs(enum ib_qp_type qp_type,
@@ -2369,8 +2376,9 @@ static int ib_mask_to_mlx5_opt(int ib_mask)
 	return result;
 }
 
-static int modify_raw_packet_qp_rq(struct mlx5_core_dev *dev,
-				   struct mlx5_ib_rq *rq, int new_state)
+static int modify_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
+				   struct mlx5_ib_rq *rq, int new_state,
+				   const struct mlx5_modify_raw_qp_param *raw_qp_param)
 {
 	void *in;
 	void *rqc;
@@ -2387,7 +2395,17 @@ static int modify_raw_packet_qp_rq(struct mlx5_core_dev *dev,
 	rqc = MLX5_ADDR_OF(modify_rq_in, in, ctx);
 	MLX5_SET(rqc, rqc, state, new_state);
 
-	err = mlx5_core_modify_rq(dev, rq->base.mqp.qpn, in, inlen);
+	if (raw_qp_param->set_mask & MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID) {
+		if (MLX5_CAP_GEN(dev->mdev, modify_rq_counter_set_id)) {
+			MLX5_SET64(modify_rq_in, in, modify_bitmask,
+				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_MODIFY_RQ_COUNTER_SET_ID);
+			MLX5_SET(rqc, rqc, counter_set_id, raw_qp_param->rq_q_ctr_id);
+		} else
+			pr_info_once("%s: RAW PACKET QP counters are not supported on current FW\n",
+				     dev->ib_dev.name);
+	}
+
+	err = mlx5_core_modify_rq(dev->mdev, rq->base.mqp.qpn, in, inlen);
 	if (err)
 		goto out;
 
@@ -2454,15 +2472,17 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	case MLX5_CMD_OP_INIT2RTR_QP:
 	case MLX5_CMD_OP_RTR2RTS_QP:
 	case MLX5_CMD_OP_RTS2RTS_QP:
-		/* Nothing to do here... */
-		return 0;
+		if (raw_qp_param->set_mask)
+			return -EINVAL;
+		else
+			return 0;
 	default:
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
 	if (qp->rq.wqe_cnt) {
-		err =  modify_raw_packet_qp_rq(dev->mdev, rq, rq_state);
+		err = modify_raw_packet_qp_rq(dev, rq, rq_state, raw_qp_param);
 		if (err)
 			return err;
 	}
@@ -2520,6 +2540,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	struct mlx5_ib_cq *send_cq, *recv_cq;
 	struct mlx5_qp_context *context;
 	struct mlx5_ib_pd *pd;
+	struct mlx5_ib_port *mibport = NULL;
 	enum mlx5_qp_state mlx5_cur, mlx5_new;
 	enum mlx5_qp_optpar optpar;
 	int sqd_event;
@@ -2660,8 +2681,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		u8 port_num = (attr_mask & IB_QP_PORT ? attr->port_num :
 			       qp->port) - 1;
-		struct mlx5_ib_port *mibport = &dev->port[port_num];
-
+		mibport = &dev->port[port_num];
 		context->qp_counter_set_usr_page |=
 			cpu_to_be32((u32)(mibport->q_cnt_id) << 24);
 	}
@@ -2700,6 +2720,10 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		struct mlx5_modify_raw_qp_param raw_qp_param = {};
 
 		raw_qp_param.operation = op;
+		if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+			raw_qp_param.rq_q_ctr_id = mibport->q_cnt_id;
+			raw_qp_param.set_mask |= MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID;
+		}
 		err = modify_raw_packet_qp(dev, qp, &raw_qp_param);
 	} else {
 		err = mlx5_core_qp_modify(dev->mdev, op, optpar, context,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
