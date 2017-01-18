From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Add port counter support for Receive WQs
Date: Wed, 18 Jan 2017 15:25:10 +0200
Message-ID: <20170118132510.4586-2-leon@kernel.org>
References: <20170118132510.4586-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118132510.4586-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Counters weren't updated due to Receive WQs' traffic since the
counter-id was not associated with the RQ.

Added support for associating the q-counter-id with the Receive WQ.
The attachment is done only when changing WQ's state from RESET to
READY in modify-WQ command.

FW support is required for the above, without this support
Receive WQ counters will not count.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 12 +++++++++++-
 include/linux/mlx5/mlx5_ifc.h   |  2 +-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index aebd808..d2b9267 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2422,7 +2422,7 @@ static int modify_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 	if (raw_qp_param->set_mask & MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID) {
 		if (MLX5_CAP_GEN(dev->mdev, modify_rq_counter_set_id)) {
 			MLX5_SET64(modify_rq_in, in, modify_bitmask,
-				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_MODIFY_RQ_COUNTER_SET_ID);
+				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
 			MLX5_SET(rqc, rqc, counter_set_id, raw_qp_param->rq_q_ctr_id);
 		} else
 			pr_info_once("%s: RAW PACKET QP counters are not supported on current FW\n",
@@ -4896,6 +4896,16 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 	MLX5_SET(modify_rq_in, in, rq_state, curr_wq_state);
 	MLX5_SET(rqc, rqc, state, wq_state);
 
+	if (curr_wq_state == IB_WQS_RESET && wq_state == IB_WQS_RDY) {
+		if (MLX5_CAP_GEN(dev->mdev, modify_rq_counter_set_id)) {
+			MLX5_SET64(modify_rq_in, in, modify_bitmask,
+				   MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID);
+			MLX5_SET(rqc, rqc, counter_set_id, dev->port->q_cnts.set_id);
+		} else
+			pr_info_once("%s: Receive WQ counters are not supported on current FW\n",
+				     dev->ib_dev.name);
+	}
+
 	err = mlx5_core_modify_rq(dev->mdev, rwq->core_qp.qpn, in, inlen);
 	kvfree(in);
 	if (!err)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1223fef..162e948 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5017,7 +5017,7 @@ struct mlx5_ifc_modify_rq_out_bits {
 
 enum {
 	MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_VSD = 1ULL << 1,
-	MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_MODIFY_RQ_COUNTER_SET_ID = 1ULL << 3,
+	MLX5_MODIFY_RQ_IN_MODIFY_BITMASK_RQ_COUNTER_SET_ID = 1ULL << 3,
 };
 
 struct mlx5_ifc_modify_rq_in_bits {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
