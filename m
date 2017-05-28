From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v2 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Sun, 28 May 2017 11:07:05 +0200
Message-ID: <20170528090705.GM13083@lst.de>
References: <1495957991-19223-1-git-send-email-maxg@mellanox.com> <1495957991-19223-2-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495957991-19223-2-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 28, 2017 at 10:53:11AM +0300, Max Gurtovoy wrote:
> Cache the needed umr_fence and set the wqe ctrl segmennt
> accordingly.

Looks good,

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

But that whole fence logic looks awkward to me.  Does the following
patch to reorder it make sense to you?

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0e08a58de673..bdcf25410c99 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -349,7 +349,7 @@ struct mlx5_ib_qp {
 	struct mlx5_ib_wq	rq;
 
 	u8			sq_signal_bits;
-	u8			fm_cache;
+	u8			next_fence;
 	struct mlx5_ib_wq	sq;
 
 	/* serialize qp state modifications
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 876a42908e4d..ebb6768684de 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3738,23 +3738,6 @@ static void dump_wqe(struct mlx5_ib_qp *qp, int idx, int size_16)
 	}
 }
 
-static u8 get_fence(u8 fence, struct ib_send_wr *wr, struct mlx5_ib_dev *dev)
-{
-	if (wr->opcode == IB_WR_LOCAL_INV || wr->opcode == IB_WR_REG_MR)
-		return dev->umr_fence;
-
-	if (unlikely(fence)) {
-		if (wr->send_flags & IB_SEND_FENCE)
-			return MLX5_FENCE_MODE_SMALL_AND_FENCE;
-		else
-			return fence;
-	} else if (unlikely(wr->send_flags & IB_SEND_FENCE)) {
-		return MLX5_FENCE_MODE_FENCE;
-	}
-
-	return 0;
-}
-
 static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
 		     struct mlx5_wqe_ctrl_seg **ctrl,
 		     struct ib_send_wr *wr, unsigned *idx,
@@ -3783,8 +3766,7 @@ static int begin_wqe(struct mlx5_ib_qp *qp, void **seg,
 static void finish_wqe(struct mlx5_ib_qp *qp,
 		       struct mlx5_wqe_ctrl_seg *ctrl,
 		       u8 size, unsigned idx, u64 wr_id,
-		       int nreq, u8 fence, u8 next_fence,
-		       u32 mlx5_opcode)
+		       int nreq, u8 fence, u32 mlx5_opcode)
 {
 	u8 opmod = 0;
 
@@ -3792,7 +3774,6 @@ static void finish_wqe(struct mlx5_ib_qp *qp,
 					     mlx5_opcode | ((u32)opmod << 24));
 	ctrl->qpn_ds = cpu_to_be32(size | (qp->trans_qp.base.mqp.qpn << 8));
 	ctrl->fm_ce_se |= fence;
-	qp->fm_cache = next_fence;
 	if (unlikely(qp->wq_sig))
 		ctrl->signature = wq_sig(ctrl);
 
@@ -3852,7 +3833,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			goto out;
 		}
 
-		fence = qp->fm_cache;
 		num_sge = wr->num_sge;
 		if (unlikely(num_sge > qp->sq.max_gs)) {
 			mlx5_ib_warn(dev, "\n");
@@ -3869,6 +3849,19 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			goto out;
 		}
 
+		if (wr->opcode == IB_WR_LOCAL_INV ||
+		    wr->opcode == IB_WR_REG_MR) {
+			fence = dev->umr_fence;
+			next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
+		} else if (wr->send_flags & IB_SEND_FENCE) {
+			if (qp->next_fence)
+				fence = MLX5_FENCE_MODE_SMALL_AND_FENCE;
+			else
+				fence = MLX5_FENCE_MODE_FENCE;
+		} else {
+			fence = qp->next_fence;
+		}
+
 		switch (ibqp->qp_type) {
 		case IB_QPT_XRC_INI:
 			xrc = seg;
@@ -3895,7 +3888,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				goto out;
 
 			case IB_WR_LOCAL_INV:
-				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 				qp->sq.wr_data[idx] = IB_WR_LOCAL_INV;
 				ctrl->imm = cpu_to_be32(wr->ex.invalidate_rkey);
 				set_linv_wr(qp, &seg, &size);
@@ -3903,7 +3895,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				break;
 
 			case IB_WR_REG_MR:
-				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 				qp->sq.wr_data[idx] = IB_WR_REG_MR;
 				ctrl->imm = cpu_to_be32(reg_wr(wr)->key);
 				err = set_reg_wr(qp, reg_wr(wr), &seg, &size);
@@ -3926,9 +3917,8 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					goto out;
 				}
 
-				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
-					   nreq, get_fence(fence, wr, dev),
-					   next_fence, MLX5_OPCODE_UMR);
+				finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq,
+					   fence, MLX5_OPCODE_UMR);
 				/*
 				 * SET_PSV WQEs are not signaled and solicited
 				 * on error
@@ -3953,9 +3943,8 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					goto out;
 				}
 
-				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
-					   nreq, get_fence(fence, wr, dev),
-					   next_fence, MLX5_OPCODE_SET_PSV);
+				finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq,
+					   fence, MLX5_OPCODE_SET_PSV);
 				err = begin_wqe(qp, &seg, &ctrl, wr,
 						&idx, &size, nreq);
 				if (err) {
@@ -3965,7 +3954,6 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					goto out;
 				}
 
-				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 				err = set_psv_wr(&sig_handover_wr(wr)->sig_attrs->wire,
 						 mr->sig->psv_wire.psv_idx, &seg,
 						 &size);
@@ -3975,9 +3963,9 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 					goto out;
 				}
 
-				finish_wqe(qp, ctrl, size, idx, wr->wr_id,
-					   nreq, get_fence(fence, wr, dev),
-					   next_fence, MLX5_OPCODE_SET_PSV);
+				finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq,
+					   fence, MLX5_OPCODE_SET_PSV);
+				qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 				num_sge = 0;
 				goto skip_psv;
 
@@ -4088,8 +4076,8 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 		}
 
-		finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq,
-			   get_fence(fence, wr, dev), next_fence,
+		qp->next_fence = next_fence;
+		finish_wqe(qp, ctrl, size, idx, wr->wr_id, nreq, fence,
 			   mlx5_ib_opcode[wr->opcode]);
 skip_psv:
 		if (0)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
