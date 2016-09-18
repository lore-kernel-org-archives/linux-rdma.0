From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/5] IB/mlx5: LAG QP load balancing
Date: Sun, 18 Sep 2016 13:08:16 +0300
Message-ID: <1474193296-28062-6-git-send-email-leon@kernel.org>
References: <1474193296-28062-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474193296-28062-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When LAG is active, QP tx affinity (the physical port
to which a QP is affined, or the TIS in case of raw-eth)
is set in a round robin fashion during state transition
from RESET to INIT.

Signed-off-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 61 +++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b13063a..27894e7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -603,6 +603,7 @@ struct mlx5_roce {
 	rwlock_t		netdev_lock;
 	struct net_device	*netdev;
 	struct notifier_block	nb;
+	atomic_t		next_port;
 };
 
 struct mlx5_ib_dev {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0dd7d93..4616dac 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1854,7 +1854,7 @@ static void get_cqs(enum ib_qp_type qp_type,
 }
 
 static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
-				u16 operation);
+				u16 operation, u8 lag_tx_affinity);
 
 static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
@@ -1885,7 +1885,7 @@ static void destroy_qp_common(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 						  &base->mqp);
 		} else {
 			err = modify_raw_packet_qp(dev, qp,
-						   MLX5_CMD_OP_2RST_QP);
+						   MLX5_CMD_OP_2RST_QP, 0);
 		}
 		if (err)
 			mlx5_ib_warn(dev, "mlx5_ib: modify QP 0x%06x to RESET failed\n",
@@ -2151,6 +2151,31 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
 	return err;
 }
 
+static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
+					 struct mlx5_ib_sq *sq, u8 tx_affinity)
+{
+	void *in;
+	void *tisc;
+	int inlen;
+	int err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_tis_in);
+	in = mlx5_vzalloc(inlen);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_tis_in, in, bitmask.lag_tx_port_affinity, 1);
+
+	tisc = MLX5_ADDR_OF(modify_tis_in, in, ctx);
+	MLX5_SET(tisc, tisc, lag_tx_port_affinity, tx_affinity);
+
+	err = mlx5_core_modify_tis(dev, sq->tisn, in, inlen);
+
+	kvfree(in);
+
+	return err;
+}
+
 static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			 const struct ib_ah_attr *ah,
 			 struct mlx5_qp_path *path, u8 port, int attr_mask,
@@ -2420,7 +2445,7 @@ out:
 }
 
 static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
-				u16 operation)
+				u16 operation, u8 tx_affinity)
 {
 	struct mlx5_ib_raw_packet_qp *raw_packet_qp = &qp->raw_packet_qp;
 	struct mlx5_ib_rq *rq = &raw_packet_qp->rq;
@@ -2459,8 +2484,16 @@ static int modify_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			return err;
 	}
 
-	if (qp->sq.wqe_cnt)
+	if (qp->sq.wqe_cnt) {
+		if (tx_affinity) {
+			err = modify_raw_packet_tx_affinity(dev->mdev, sq,
+							    tx_affinity);
+			if (err)
+				return err;
+		}
+
 		return modify_raw_packet_qp_sq(dev->mdev, sq, sq_state);
+	}
 
 	return 0;
 }
@@ -2519,6 +2552,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	int mlx5_st;
 	int err;
 	u16 op;
+	u8 tx_affinity = 0;
 
 	in = kzalloc(sizeof(*in), GFP_KERNEL);
 	if (!in)
@@ -2549,6 +2583,23 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 
+	if ((cur_state == IB_QPS_RESET) && (new_state == IB_QPS_INIT)) {
+		if ((ibqp->qp_type == IB_QPT_RC) ||
+		    (ibqp->qp_type == IB_QPT_UD &&
+		     !(qp->flags & MLX5_IB_QP_SQPN_QP1)) ||
+		    (ibqp->qp_type == IB_QPT_UC) ||
+		    (ibqp->qp_type == IB_QPT_RAW_PACKET) ||
+		    (ibqp->qp_type == IB_QPT_XRC_INI) ||
+		    (ibqp->qp_type == IB_QPT_XRC_TGT)) {
+			if (mlx5_lag_is_active(dev->mdev)) {
+				tx_affinity = (unsigned int)atomic_add_return(1,
+						&dev->roce.next_port) %
+						MLX5_MAX_PORTS + 1;
+				context->flags |= cpu_to_be32(tx_affinity << 24);
+			}
+		}
+	}
+
 	if (is_sqp(ibqp->qp_type)) {
 		context->mtu_msgmax = (IB_MTU_256 << 5) | 8;
 	} else if (ibqp->qp_type == IB_QPT_UD ||
@@ -2692,7 +2743,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	in->optparam = cpu_to_be32(optpar);
 
 	if (qp->ibqp.qp_type == IB_QPT_RAW_PACKET)
-		err = modify_raw_packet_qp(dev, qp, op);
+		err = modify_raw_packet_qp(dev, qp, op, tx_affinity);
 	else
 		err = mlx5_core_qp_modify(dev->mdev, op, in, sqd_event,
 					  &base->mqp);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
