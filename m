From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/5] IB/mlx5: Add Scatter FCS support for Raw Packet QP
Date: Sun, 17 Apr 2016 17:19:37 +0300
Message-ID: <1460902778-5977-5-git-send-email-matanb@mellanox.com>
References: <1460902778-5977-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460902778-5977-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable Scatter FCS in the RQ context when the user passes
Scatter FCS create flag.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f16c818..ac23780 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -356,6 +356,7 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_SIGNATURE_HANDLING           = 1 << 5,
 	/* QP uses 1 as its source QP number */
 	MLX5_IB_QP_SQPN_QP1			= 1 << 6,
+	MLX5_IB_QP_CAP_SCATTER_FCS		= 1 << 7,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8dee8bc..5041176 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1028,6 +1028,7 @@ static int get_rq_pas_size(void *qpc)
 static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 				   struct mlx5_ib_rq *rq, void *qpin)
 {
+	struct mlx5_ib_qp *mqp = rq->base.container_mibqp;
 	__be64 *pas;
 	__be64 *qp_pas;
 	void *in;
@@ -1051,6 +1052,9 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	MLX5_SET(rqc, rqc, user_index, MLX5_GET(qpc, qpc, user_index));
 	MLX5_SET(rqc, rqc, cqn, MLX5_GET(qpc, qpc, cqn_rcv));
 
+	if (mqp->flags & MLX5_IB_QP_CAP_SCATTER_FCS)
+		MLX5_SET(rqc, rqc, scatter_fcs, 1);
+
 	wq = MLX5_ADDR_OF(rqc, rqc, wq);
 	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
 	MLX5_SET(wq, wq, end_padding_mode,
@@ -1136,11 +1140,12 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	if (qp->rq.wqe_cnt) {
+		rq->base.container_mibqp = qp;
+
 		err = create_raw_packet_qp_rq(dev, rq, in);
 		if (err)
 			goto err_destroy_sq;
 
-		rq->base.container_mibqp = qp;
 
 		err = create_raw_packet_qp_tir(dev, rq, tdn);
 		if (err)
@@ -1252,6 +1257,19 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			return -EOPNOTSUPP;
 		}
 
+	if (init_attr->create_flags & IB_QP_CREATE_SCATTER_FCS) {
+		if (init_attr->qp_type != IB_QPT_RAW_PACKET) {
+			mlx5_ib_dbg(dev, "Scatter FCS is supported only for Raw Packet QPs");
+			return -EOPNOTSUPP;
+		}
+		if (!MLX5_CAP_GEN(dev->mdev, eth_net_offloads) ||
+		    !MLX5_CAP_ETH(dev->mdev, scatter_fcs)) {
+			mlx5_ib_dbg(dev, "Scatter FCS isn't supported\n");
+			return -EOPNOTSUPP;
+		}
+		qp->flags |= MLX5_IB_QP_CAP_SCATTER_FCS;
+	}
+
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
 
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
