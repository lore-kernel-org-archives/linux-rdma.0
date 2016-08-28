From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/9] IB/mlx4: Don't return errors from poll_cq
Date: Sun, 28 Aug 2016 10:58:33 +0300
Message-ID: <1472371118-8260-5-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove returning errors from mlx4 poll_cq function. Polling CQ
operation in kernel never fails by Mellanox HCA architecture and
respective driver design.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c | 26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 15b6289..5df63da 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -687,12 +687,6 @@ repoll:
 	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
 		MLX4_CQE_OPCODE_ERROR;

-	if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == MLX4_OPCODE_NOP &&
-		     is_send)) {
-		pr_warn("Completion for NOP opcode detected!\n");
-		return -EINVAL;
-	}
-
 	/* Resize CQ in progress */
 	if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == MLX4_CQE_OPCODE_RESIZE)) {
 		if (cq->resize_buf) {
@@ -718,12 +712,6 @@ repoll:
 		 */
 		mqp = __mlx4_qp_lookup(to_mdev(cq->ibcq.device)->dev,
 				       be32_to_cpu(cqe->vlan_my_qpn));
-		if (unlikely(!mqp)) {
-			pr_warn("CQ %06x with entry for unknown QPN %06x\n",
-			       cq->mcq.cqn, be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
-			return -EINVAL;
-		}
-
 		*cur_qp = to_mibqp(mqp);
 	}

@@ -736,11 +724,6 @@ repoll:
 		/* SRQ is also in the radix tree */
 		msrq = mlx4_srq_lookup(to_mdev(cq->ibcq.device)->dev,
 				       srq_num);
-		if (unlikely(!msrq)) {
-			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
-				cq->mcq.cqn, srq_num);
-			return -EINVAL;
-		}
 	}

 	if (is_send) {
@@ -891,7 +874,6 @@ int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	struct mlx4_ib_qp *cur_qp = NULL;
 	unsigned long flags;
 	int npolled;
-	int err = 0;
 	struct mlx4_ib_dev *mdev = to_mdev(cq->ibcq.device);

 	spin_lock_irqsave(&cq->lock, flags);
@@ -901,8 +883,7 @@ int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	}

 	for (npolled = 0; npolled < num_entries; ++npolled) {
-		err = mlx4_ib_poll_one(cq, &cur_qp, wc + npolled);
-		if (err)
+		if (mlx4_ib_poll_one(cq, &cur_qp, wc + npolled))
 			break;
 	}

@@ -911,10 +892,7 @@ int mlx4_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 out:
 	spin_unlock_irqrestore(&cq->lock, flags);

-	if (err == 0 || err == -EAGAIN)
-		return npolled;
-	else
-		return err;
+	return npolled;
 }

 int mlx4_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
