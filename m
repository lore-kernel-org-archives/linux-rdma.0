From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Tue, 12 Jan 2016 12:32:12 +0200
Message-ID: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

mlx5 keeps a lot of internal accounting for wr processing.
mlx5_ib_wq consists of multiple arrays:
struct mlx5_ib_wq {
	u64		       *wrid;
	u32		       *wr_data;
	struct wr_list	       *w_list;
	unsigned	       *wqe_head;
	...
}

Each time we access each of these arrays, even for a single index
we fetch a cacheline. Reduce cacheline bounces by fitting these members
in a cacheline aligned struct (swr_ctx) and allocate an array. Accessing
this array will fetch all of these members in a single shot.

Since the receive queue needs only the wrid we use a nameless union
where in the rwr_ctx we only have wrid member.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c      | 18 +++++++--------
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 21 +++++++++++++----
 drivers/infiniband/hw/mlx5/qp.c      | 45 +++++++++++++++---------------------
 3 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b14316603e44..5eb0fcac72b1 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -102,7 +102,7 @@ static void *next_cqe_sw(struct mlx5_ib_cq *cq)
 
 static enum ib_wc_opcode get_umr_comp(struct mlx5_ib_wq *wq, int idx)
 {
-	switch (wq->wr_data[idx]) {
+	switch (wq->swr_ctx[idx].wr_data) {
 	case MLX5_IB_WR_UMR:
 		return 0;
 
@@ -194,7 +194,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 		}
 	} else {
 		wq	  = &qp->rq;
-		wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+		wc->wr_id = wq->rwr_ctx[wq->tail & (wq->wqe_cnt - 1)].wrid;
 		++wq->tail;
 	}
 	wc->byte_len = be32_to_cpu(cqe->byte_cnt);
@@ -378,9 +378,9 @@ static void handle_atomics(struct mlx5_ib_qp *qp, struct mlx5_cqe64 *cqe64,
 		if (idx == head)
 			break;
 
-		tail = qp->sq.w_list[idx].next;
+		tail = qp->sq.swr_ctx[idx].w_list.next;
 	} while (1);
-	tail = qp->sq.w_list[idx].next;
+	tail = qp->sq.swr_ctx[idx].w_list.next;
 	qp->sq.last_poll = tail;
 }
 
@@ -490,8 +490,8 @@ repoll:
 		idx = wqe_ctr & (wq->wqe_cnt - 1);
 		handle_good_req(wc, cqe64, wq, idx);
 		handle_atomics(*cur_qp, cqe64, wq->last_poll, idx);
-		wc->wr_id = wq->wrid[idx];
-		wq->tail = wq->wqe_head[idx] + 1;
+		wc->wr_id = wq->swr_ctx[idx].wrid;
+		wq->tail = wq->swr_ctx[idx].wqe_head + 1;
 		wc->status = IB_WC_SUCCESS;
 		break;
 	case MLX5_CQE_RESP_WR_IMM:
@@ -516,8 +516,8 @@ repoll:
 			wq = &(*cur_qp)->sq;
 			wqe_ctr = be16_to_cpu(cqe64->wqe_counter);
 			idx = wqe_ctr & (wq->wqe_cnt - 1);
-			wc->wr_id = wq->wrid[idx];
-			wq->tail = wq->wqe_head[idx] + 1;
+			wc->wr_id = wq->swr_ctx[idx].wrid;
+			wq->tail = wq->swr_ctx[idx].wqe_head + 1;
 		} else {
 			struct mlx5_ib_srq *srq;
 
@@ -528,7 +528,7 @@ repoll:
 				mlx5_ib_free_srq_wqe(srq, wqe_ctr);
 			} else {
 				wq = &(*cur_qp)->rq;
-				wc->wr_id = wq->wrid[wq->tail & (wq->wqe_cnt - 1)];
+				wc->wr_id = wq->rwr_ctx[wq->tail & (wq->wqe_cnt - 1)].wrid;
 				++wq->tail;
 			}
 		}
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d4b227126265..84cb8fc072a1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -129,11 +129,24 @@ struct wr_list {
 	u16	next;
 };
 
+/* Please don't let this exceed a single cacheline */
+struct swr_ctx {
+	u64		wrid;
+	u32		wr_data;
+	struct wr_list	w_list;
+	u32		wqe_head;
+	u8		rsvd[12];
+}__packed;
+
+struct rwr_ctx {
+	u64		       wrid;
+}__packed;
+
 struct mlx5_ib_wq {
-	u64		       *wrid;
-	u32		       *wr_data;
-	struct wr_list	       *w_list;
-	unsigned	       *wqe_head;
+	union {
+		struct swr_ctx *swr_ctx;
+		struct rwr_ctx *rwr_ctx;
+	};
 	u16		        unsig_count;
 
 	/* serialize post to the work queue
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1ea049ed87da..a6b88902d7af 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -794,14 +794,11 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 		goto err_free;
 	}
 
-	qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wrid), GFP_KERNEL);
-	qp->sq.wr_data = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wr_data), GFP_KERNEL);
-	qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(*qp->rq.wrid), GFP_KERNEL);
-	qp->sq.w_list = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.w_list), GFP_KERNEL);
-	qp->sq.wqe_head = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wqe_head), GFP_KERNEL);
-
-	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid ||
-	    !qp->sq.w_list || !qp->sq.wqe_head) {
+	qp->sq.swr_ctx = kcalloc(qp->sq.wqe_cnt, sizeof(*qp->sq.swr_ctx),
+				 GFP_KERNEL);
+	qp->rq.rwr_ctx = kcalloc(qp->rq.wqe_cnt, sizeof(*qp->sq.rwr_ctx),
+				 GFP_KERNEL);
+	if (!qp->sq.swr_ctx || !qp->rq.rwr_ctx) {
 		err = -ENOMEM;
 		goto err_wrid;
 	}
@@ -811,11 +808,8 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 
 err_wrid:
 	mlx5_db_free(dev->mdev, &qp->db);
-	kfree(qp->sq.wqe_head);
-	kfree(qp->sq.w_list);
-	kfree(qp->sq.wrid);
-	kfree(qp->sq.wr_data);
-	kfree(qp->rq.wrid);
+	kfree(qp->sq.swr_ctx);
+	kfree(qp->rq.rwr_ctx);
 
 err_free:
 	kvfree(*in);
@@ -831,11 +825,8 @@ err_uuar:
 static void destroy_qp_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
 	mlx5_db_free(dev->mdev, &qp->db);
-	kfree(qp->sq.wqe_head);
-	kfree(qp->sq.w_list);
-	kfree(qp->sq.wrid);
-	kfree(qp->sq.wr_data);
-	kfree(qp->rq.wrid);
+	kfree(qp->sq.swr_ctx);
+	kfree(qp->rq.rwr_ctx);
 	mlx5_buf_free(dev->mdev, &qp->buf);
 	free_uuar(&dev->mdev->priv.uuari, qp->bf->uuarn);
 }
@@ -2623,11 +2614,11 @@ static void finish_wqe(struct mlx5_ib_qp *qp,
 	if (unlikely(qp->wq_sig))
 		ctrl->signature = wq_sig(ctrl);
 
-	qp->sq.wrid[idx] = wr_id;
-	qp->sq.w_list[idx].opcode = mlx5_opcode;
-	qp->sq.wqe_head[idx] = qp->sq.head + nreq;
+	qp->sq.swr_ctx[idx].wrid = wr_id;
+	qp->sq.swr_ctx[idx].w_list.opcode = mlx5_opcode;
+	qp->sq.swr_ctx[idx].wqe_head = qp->sq.head + nreq;
 	qp->sq.cur_post += DIV_ROUND_UP(size * 16, MLX5_SEND_WQE_BB);
-	qp->sq.w_list[idx].next = qp->sq.cur_post;
+	qp->sq.swr_ctx[idx].w_list.next = qp->sq.cur_post;
 }
 
 
@@ -2708,7 +2699,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 			case IB_WR_LOCAL_INV:
 				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
-				qp->sq.wr_data[idx] = IB_WR_LOCAL_INV;
+				qp->sq.swr_ctx[idx].wr_data = IB_WR_LOCAL_INV;
 				ctrl->imm = cpu_to_be32(wr->ex.invalidate_rkey);
 				set_linv_wr(qp, &seg, &size);
 				num_sge = 0;
@@ -2716,7 +2707,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 			case IB_WR_REG_MR:
 				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
-				qp->sq.wr_data[idx] = IB_WR_REG_MR;
+				qp->sq.swr_ctx[idx].wr_data = IB_WR_REG_MR;
 				ctrl->imm = cpu_to_be32(reg_wr(wr)->key);
 				err = set_reg_wr(qp, reg_wr(wr), &seg, &size);
 				if (err) {
@@ -2727,7 +2718,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				break;
 
 			case IB_WR_REG_SIG_MR:
-				qp->sq.wr_data[idx] = IB_WR_REG_SIG_MR;
+				qp->sq.swr_ctx[idx].wr_data = IB_WR_REG_SIG_MR;
 				mr = to_mmr(sig_handover_wr(wr)->sig_mr);
 
 				ctrl->imm = cpu_to_be32(mr->ibmr.rkey);
@@ -2829,7 +2820,7 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				mlx5_ib_warn(dev, "bad opcode\n");
 				goto out;
 			}
-			qp->sq.wr_data[idx] = MLX5_IB_WR_UMR;
+			qp->sq.swr_ctx[idx].wr_data = MLX5_IB_WR_UMR;
 			ctrl->imm = cpu_to_be32(umr_wr(wr)->mkey);
 			set_reg_umr_segment(seg, wr);
 			seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
@@ -2977,7 +2968,7 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			set_sig_seg(sig, (qp->rq.max_gs + 1) << 2);
 		}
 
-		qp->rq.wrid[ind] = wr->wr_id;
+		qp->rq.rwr_ctx[ind].wrid = wr->wr_id;
 
 		ind = (ind + 1) & (qp->rq.wqe_cnt - 1);
 	}
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
