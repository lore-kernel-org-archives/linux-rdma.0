From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one"
Date: Sun, 28 Aug 2016 10:58:32 +0300
Message-ID: <1472371118-8260-4-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

By Mellanox HW design and SW implementation poll_cq never
fails and returns errors, so all these prints are to catch ULP bugs.

In case of such bug, the reverted patch patch will cause to reentry
(EAGAIN) and kprints storm again and again.

It is undesired and misleading behaviour.

This reverts commit 5412352fcd8f ("IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one")

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 006db64..15b6289 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -690,7 +690,7 @@ repoll:
 	if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == MLX4_OPCODE_NOP &&
 		     is_send)) {
 		pr_warn("Completion for NOP opcode detected!\n");
-		return -EAGAIN;
+		return -EINVAL;
 	}

 	/* Resize CQ in progress */
@@ -721,7 +721,7 @@ repoll:
 		if (unlikely(!mqp)) {
 			pr_warn("CQ %06x with entry for unknown QPN %06x\n",
 			       cq->mcq.cqn, be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
-			return -EAGAIN;
+			return -EINVAL;
 		}

 		*cur_qp = to_mibqp(mqp);
@@ -739,7 +739,7 @@ repoll:
 		if (unlikely(!msrq)) {
 			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
 				cq->mcq.cqn, srq_num);
-			return -EAGAIN;
+			return -EINVAL;
 		}
 	}

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
