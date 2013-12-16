From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 05/10] IB/mlx5: Break wqe handling to begin & finish routines
Date: Mon, 16 Dec 2013 13:26:25 +0200
Message-ID: <1387193190-8837-6-git-send-email-sagig@mellanox.com>
References: <1387193190-8837-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387193190-8837-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As a preliminary step for signature feature which will
reuqire posting multiple (3) WQEs for a single WR, we
break post_send routine WQE indexing into begin and
finish routines.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c |   97 ++++++++++++++++++++++++--------------
 1 files changed, 61 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 07aa3ca..e135d71 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1990,6 +1990,59 @@ static u8 get_fence(u8 fence, struct ib_send_wr *wr)
 	}
 }
 
+static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
+		     struct mlx5_wqe_ctrl_seg **ctrl,
+		     struct ib_send_wr *wr, int *idx,
+		     int *size, int nreq)
+{
+	int err = 0;
+
+	if (unlikely(mlx5_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq))) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	*idx = qp->sq.cur_post & (qp->sq.wqe_cnt - 1);
+	*seg = mlx5_get_send_wqe(qp, *idx);
+	*ctrl = *seg;
+	*(uint32_t *)(*seg + 8) = 0;
+	(*ctrl)->imm = send_ieth(wr);
+	(*ctrl)->fm_ce_se = qp->sq_signal_bits |
+		(wr->send_flags & IB_SEND_SIGNALED ?
+		 MLX5_WQE_CTRL_CQ_UPDATE : 0) |
+		(wr->send_flags & IB_SEND_SOLICITED ?
+		 MLX5_WQE_CTRL_SOLICITED : 0);
+
+	*seg += sizeof(**ctrl);
+	*size = sizeof(**ctrl) / 16;
+
+	return err;
+}
+
+static void finish_wqe(struct mlx5_ib_qp *qp,
+		       struct mlx5_wqe_ctrl_seg *ctrl,
+		       u8 size, unsigned idx, u64 wr_id,
+		       int nreq, u8 fence, u8 next_fence,
+		       u32 mlx5_opcode)
+{
+	u8 opmod = 0;
+
+	ctrl->opmod_idx_opcode = cpu_to_be32(((u32)(qp->sq.cur_post) << 8) |
+					     mlx5_opcode | ((u32)opmod << 24));
+	ctrl->qpn_ds = cpu_to_be32(size | (qp->mqp.qpn << 8));
+	ctrl->fm_ce_se |= fence;
+	qp->fm_cache = next_fence;
+	if (unlikely(qp->wq_sig))
+		ctrl->signature = wq_sig(ctrl);
+
+	qp->sq.wrid[idx] = wr_id;
+	qp->sq.w_list[idx].opcode = mlx5_opcode;
+	qp->sq.wqe_head[idx] = qp->sq.head + nreq;
+	qp->sq.cur_post += DIV_ROUND_UP(size * 16, MLX5_SEND_WQE_BB);
+	qp->sq.w_list[idx].next = qp->sq.cur_post;
+}
+
+
 int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		      struct ib_send_wr **bad_wr)
 {
@@ -2003,7 +2056,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int uninitialized_var(size);
 	void *qend = qp->sq.qend;
 	unsigned long flags;
-	u32 mlx5_opcode;
 	unsigned idx;
 	int err = 0;
 	int inl = 0;
@@ -2012,7 +2064,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	int nreq;
 	int i;
 	u8 next_fence = 0;
-	u8 opmod = 0;
 	u8 fence;
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
@@ -2025,36 +2076,23 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			goto out;
 		}
 
-		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq, qp->ibqp.send_cq))) {
+		fence = qp->fm_cache;
+		num_sge = wr->num_sge;
+		if (unlikely(num_sge > qp->sq.max_gs)) {
 			mlx5_ib_warn(dev, "\n");
 			err = -ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
 
-		fence = qp->fm_cache;
-		num_sge = wr->num_sge;
-		if (unlikely(num_sge > qp->sq.max_gs)) {
+		err = begin_wqe(qp, &seg, &ctrl, wr, &idx, &size, nreq);
+		if (err) {
 			mlx5_ib_warn(dev, "\n");
 			err = -ENOMEM;
 			*bad_wr = wr;
 			goto out;
 		}
 
-		idx = qp->sq.cur_post & (qp->sq.wqe_cnt - 1);
-		seg = mlx5_get_send_wqe(qp, idx);
-		ctrl = seg;
-		*(uint32_t *)(seg + 8) = 0;
-		ctrl->imm = send_ieth(wr);
-		ctrl->fm_ce_se = qp->sq_signal_bits |
-			(wr->send_flags & IB_SEND_SIGNALED ?
-			 MLX5_WQE_CTRL_CQ_UPDATE : 0) |
-			(wr->send_flags & IB_SEND_SOLICITED ?
-			 MLX5_WQE_CTRL_SOLICITED : 0);
-
-		seg += sizeof(*ctrl);
-		size = sizeof(*ctrl) / 16;
-
 		switch (ibqp->qp_type) {
 		case IB_QPT_XRC_INI:
 			xrc = seg;
@@ -2187,22 +2225,9 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 		}
 
-		mlx5_opcode = mlx5_ib_opcode[wr->opcode];
-		ctrl->opmod_idx_opcode = cpu_to_be32(((u32)(qp->sq.cur_post) << 8)	|
-						     mlx5_opcode			|
-						     ((u32)opmod << 24));
-		ctrl->qpn_ds = cpu_to_be32(size | (qp->mqp.qpn << 8));
-		ctrl->fm_ce_se |= get_fence(fence, wr);
-		qp->fm_cache = next_fence;
-		if (unlikely(qp->wq_sig))
-			ctrl->signature = wq_sig(ctrl);
-
-		qp->sq.wrid[idx] = wr->wr_id;
-		qp->sq.w_list[idx].opcode = mlx5_opcode;
-		qp->sq.wqe_head[idx] = qp->sq.head + nreq;
-		qp->sq.cur_post += DIV_ROUND_UP(size * 16, MLX5_SEND_WQE_BB);
-		qp->sq.w_list[idx].next = qp->sq.cur_post;
-
+		finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq,
+			   get_fence(fence, wr), next_fence,
+			   mlx5_ib_opcode[wr->opcode]);
 		if (0)
 			dump_wqe(qp, idx, size);
 	}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
