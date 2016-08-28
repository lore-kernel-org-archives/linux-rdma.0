From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 9/9] IB/mlx5: Don't return errors from poll_cq
Date: Sun, 28 Aug 2016 10:58:38 +0300
Message-ID: <1472371118-8260-10-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remove returning errors from mlx5 poll_cq function. Polling CQ
operation in kernel never fails by Mellanox HCA architecture and
respective driver design.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 308a358..e4fac929 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -553,12 +553,6 @@ repoll:
 		 * from the table.
 		 */
 		mqp = __mlx5_qp_lookup(dev->mdev, qpn);
-		if (unlikely(!mqp)) {
-			mlx5_ib_warn(dev, "CQE@CQ %06x for unknown QPN %6x\n",
-				     cq->mcq.cqn, qpn);
-			return -EINVAL;
-		}
-
 		*cur_qp = to_mibqp(mqp);
 	}

@@ -619,13 +613,6 @@ repoll:
 		read_lock(&dev->mdev->priv.mkey_table.lock);
 		mmkey = __mlx5_mr_lookup(dev->mdev,
 					 mlx5_base_mkey(be32_to_cpu(sig_err_cqe->mkey)));
-		if (unlikely(!mmkey)) {
-			read_unlock(&dev->mdev->priv.mkey_table.lock);
-			mlx5_ib_warn(dev, "CQE@CQ %06x for unknown MR %6x\n",
-				     cq->mcq.cqn, be32_to_cpu(sig_err_cqe->mkey));
-			return -EINVAL;
-		}
-
 		mr = to_mibmr(mmkey);
 		get_sig_err_item(sig_err_cqe, &mr->sig->err_item);
 		mr->sig->sig_err_exists = true;
@@ -676,7 +663,6 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	unsigned long flags;
 	int soft_polled = 0;
 	int npolled;
-	int err = 0;

 	spin_lock_irqsave(&cq->lock, flags);
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR) {
@@ -688,8 +674,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 		soft_polled = poll_soft_wc(cq, num_entries, wc);

 	for (npolled = 0; npolled < num_entries - soft_polled; npolled++) {
-		err = mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled);
-		if (err)
+		if (mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled))
 			break;
 	}

@@ -698,10 +683,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 out:
 	spin_unlock_irqrestore(&cq->lock, flags);

-	if (err == 0 || err == -EAGAIN)
-		return soft_polled + npolled;
-	else
-		return err;
+	return soft_polled + npolled;
 }

 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
