From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] mlx4: remove unneeded code
Date: Sun, 11 Oct 2009 17:34:16 +0200
Message-ID: <20091011153416.GA29606@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no such flag DE - the field is reserved and should be zero.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index cde2bdc..d4ffff9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -899,7 +899,6 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 
 	context->flags = cpu_to_be32((to_mlx4_state(new_state) << 28) |
 				     (to_mlx4_st(ibqp->qp_type) << 16));
-	context->flags     |= cpu_to_be32(1 << 8); /* DE? */
 
 	if (!(attr_mask & IB_QP_PATH_MIG_STATE))
 		context->flags |= cpu_to_be32(MLX4_QP_PM_MIGRATED << 11);
-- 
1.6.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
