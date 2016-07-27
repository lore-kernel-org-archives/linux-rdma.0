From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
Date: Wed, 27 Jul 2016 01:24:53 -0700
Message-ID: <1469607893-10657-3-git-send-email-yuval.shaia@oracle.com>
References: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469607893-10657-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Error code EAGAIN should be used when errors are temporary and next call
might succeeds.
When error code other than EAGAIN is returned, the caller (mlx4_ib_poll)
will assume all CQE in the same bunch are error too and will drop them all.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 4c2e1b0..4516282 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -690,7 +690,7 @@ repoll:
 	if (unlikely((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) == MLX4_OPCODE_NOP &&
 		     is_send)) {
 		pr_warn("Completion for NOP opcode detected!\n");
-		return -EINVAL;
+		return -EAGAIN;
 	}
 
 	/* Resize CQ in progress */
@@ -721,7 +721,7 @@ repoll:
 		if (unlikely(!mqp)) {
 			pr_warn("CQ %06x with entry for unknown QPN %06x\n",
 			       cq->mcq.cqn, be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK);
-			return -EINVAL;
+			return -EAGAIN;
 		}
 
 		*cur_qp = to_mibqp(mqp);
@@ -739,7 +739,7 @@ repoll:
 		if (unlikely(!msrq)) {
 			pr_warn("CQ %06x with entry for unknown SRQN %06x\n",
 				cq->mcq.cqn, srq_num);
-			return -EINVAL;
+			return -EAGAIN;
 		}
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
