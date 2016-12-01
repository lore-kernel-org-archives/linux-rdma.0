From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 4/4] IB/mlx5: Update the rate limit according to user setting for RAW QP
Date: Thu,  1 Dec 2016 13:43:16 +0200
Message-ID: <1480592596-20126-5-git-send-email-leon@kernel.org>
References: <1480592596-20126-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480592596-20126-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

- Add MODIFY_QP_EX CMD to extend modify_qp.
- Rate limit will be updated in the following state transactions: RTR2RTS,
  RTS2RTS. The limit will be removed when SQ is in RST and ERR state.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  3 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 74 ++++++++++++++++++++++++++++++++----
 3 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fba8cab..4d22cce 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3030,7 +3030,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.uverbs_ex_cmd_mask =
 		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
 		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ)	|
-		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP);
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_QP)	|
+		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_QP);
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 854748b..907d749 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -387,6 +387,7 @@ struct mlx5_ib_qp {
 	struct list_head	qps_list;
 	struct list_head	cq_recv_list;
 	struct list_head	cq_send_list;
+	u32			rate_limit;
 };
 
 struct mlx5_ib_cq_buf {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d1e9218..5e89fb25 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -77,12 +77,14 @@ struct mlx5_wqe_eth_pad {
 
 enum raw_qp_set_mask_map {
 	MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID		= 1UL << 0,
+	MLX5_RAW_QP_RATE_LIMIT			= 1UL << 1,
 };
 
 struct mlx5_modify_raw_qp_param {
 	u16 operation;
 
 	u32 set_mask; /* raw_qp_set_mask_map */
+	u32 rate_limit;
 	u8 rq_q_ctr_id;
 };
 
@@ -2442,8 +2444,14 @@ static int modify_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 }
 
 static int modify_raw_packet_qp_sq(struct mlx5_core_dev *dev,
-				   struct mlx5_ib_sq *sq, int new_state)
+				   struct mlx5_ib_sq *sq,
+				   int new_state,
+				   const struct mlx5_modify_raw_qp_param *raw_qp_param)
 {
+	struct mlx5_ib_qp *ibqp = sq->base.container_mibqp;
+	u32 old_rate = ibqp->rate_limit;
+	u32 new_rate = old_rate;
+	u16 rl_index = 0;
 	void *in;
 	void *sqc;
 	int inlen;
@@ -2459,10 +2467,44 @@ static int modify_raw_packet_qp_sq(struct mlx5_core_dev *dev,
 	sqc = MLX5_ADDR_OF(modify_sq_in, in, ctx);
 	MLX5_SET(sqc, sqc, state, new_state);
 
+	if (raw_qp_param->set_mask & MLX5_RAW_QP_RATE_LIMIT) {
+		if (new_state != MLX5_SQC_STATE_RDY)
+			pr_warn("%s: Rate limit can only be changed when SQ is moving to RDY\n",
+				__func__);
+		else
+			new_rate = raw_qp_param->rate_limit;
+	}
+
+	if (old_rate != new_rate) {
+		if (new_rate) {
+			err = mlx5_rl_add_rate(dev, new_rate, &rl_index);
+			if (err) {
+				pr_err("Failed configuring rate %u: %d\n",
+				       new_rate, err);
+				goto out;
+			}
+		}
+
+		MLX5_SET64(modify_sq_in, in, modify_bitmask, 1);
+		MLX5_SET(sqc, sqc, packet_pacing_rate_limit_index, rl_index);
+	}
+
 	err = mlx5_core_modify_sq(dev, sq->base.mqp.qpn, in, inlen);
-	if (err)
+	if (err) {
+		/* Remove new rate from table if failed */
+		if (new_rate &&
+		    old_rate != new_rate)
+			mlx5_rl_remove_rate(dev, new_rate);
 		goto out;
+	}
 
+	/* Only remove the old rate after new rate was set */
+	if ((old_rate &&
+	    (old_rate != new_rate)) ||
+	    (new_state != MLX5_SQC_STATE_RDY))
+		mlx5_rl_remove_rate(dev, old_rate);
+
+	ibqp->rate_limit = new_rate;
 	sq->state = new_state;
 
 out:
@@ -2477,6 +2519,8 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
 	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
 	struct mlx5_ib_sq *sq = &raw_packet_qp->sq;
+	int modify_rq = !!qp->rq.wqe_cnt;
+	int modify_sq = !!qp->sq.wqe_cnt;
 	int rq_state;
 	int sq_state;
 	int err;
@@ -2494,10 +2538,18 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		rq_state = MLX5_RQC_STATE_RST;
 		sq_state = MLX5_SQC_STATE_RST;
 		break;
-	case MLX5_CMD_OP_INIT2INIT_QP:
-	case MLX5_CMD_OP_INIT2RTR_QP:
 	case MLX5_CMD_OP_RTR2RTS_QP:
 	case MLX5_CMD_OP_RTS2RTS_QP:
+		if (raw_qp_param->set_mask ==
+		    MLX5_RAW_QP_RATE_LIMIT) {
+			modify_rq = 0;
+			sq_state = sq->state;
+		} else {
+			return raw_qp_param->set_mask ? -EINVAL : 0;
+		}
+		break;
+	case MLX5_CMD_OP_INIT2INIT_QP:
+	case MLX5_CMD_OP_INIT2RTR_QP:
 		if (raw_qp_param->set_mask)
 			return -EINVAL;
 		else
@@ -2507,13 +2559,13 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		return -EINVAL;
 	}
 
-	if (qp->rq.wqe_cnt) {
-		err = modify_raw_packet_qp_rq(dev, rq, rq_state, raw_qp_param);
+	if (modify_rq) {
+		err =  modify_raw_packet_qp_rq(dev, rq, rq_state, raw_qp_param);
 		if (err)
 			return err;
 	}
 
-	if (qp->sq.wqe_cnt) {
+	if (modify_sq) {
 		if (tx_affinity) {
 			err = modify_raw_packet_tx_affinity(dev->mdev, sq,
 							    tx_affinity);
@@ -2521,7 +2573,7 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 				return err;
 		}
 
-		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state);
+		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state, raw_qp_param);
 	}
 
 	return 0;
@@ -2776,6 +2828,12 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			raw_qp_param.rq_q_ctr_id = mibport->q_cnt_id;
 			raw_qp_param.set_mask |= MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID;
 		}
+
+		if (attr_mask & IB_QP_RATE_LIMIT) {
+			raw_qp_param.rate_limit = attr->rate_limit;
+			raw_qp_param.set_mask |= MLX5_RAW_QP_RATE_LIMIT;
+		}
+
 		err = modify_raw_packet_qp(dev, qp, &raw_qp_param, tx_affinity);
 	} else {
 		err = mlx5_core_qp_modify(dev->mdev, op, optpar, context,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
