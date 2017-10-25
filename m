From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/mlx4: Fix RSS's QPC attributes assignments
Date: Wed, 25 Oct 2017 22:39:35 +0300
Message-ID: <20171025193935.1075-3-leon@kernel.org>
References: <20171025193935.1075-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025193935.1075-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In the modify QP handler the base_qpn_udp field in the RSS QPC is
overwrite later by irrelevant value assignment. Hence, ingress packets
which gets to the RSS QP will be steered then to a garbage QPN.

The patch fixes this by skipping the above assignment when a RSS QP is
modified, also, the RSS context's attributes assignments are relocated
just before the context is posted to avoid future issues like this.

Additionally, this patch takes the opportunity to change the code to be
disciplined to the device's manual and assigns the RSS QP context just at
RESET to INIT transition.

Fixes:3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index b6b33d99b0b4..26f3345948e2 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2182,11 +2182,6 @@ static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 	context->flags = cpu_to_be32((to_mlx4_state(new_state) << 28) |
 				     (to_mlx4_st(dev, qp->mlx4_ib_qp_type) << 16));
 
-	if (rwq_ind_tbl) {
-		fill_qp_rss_context(context, qp);
-		context->flags |= cpu_to_be32(1 << MLX4_RSS_QPC_FLAG_OFFSET);
-	}
-
 	if (!(attr_mask & IB_QP_PATH_MIG_STATE))
 		context->flags |= cpu_to_be32(MLX4_QP_PM_MIGRATED << 11);
 	else {
@@ -2387,6 +2382,7 @@ static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 	context->pd = cpu_to_be32(pd->pdn);
 
 	if (!rwq_ind_tbl) {
+		context->params1 = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
 		get_cqs(qp, src_type, &send_cq, &recv_cq);
 	} else { /* Set dummy CQs to be compatible with HV and PRM */
 		send_cq = to_mcq(rwq_ind_tbl->ind_tbl[0]->cq);
@@ -2394,7 +2390,6 @@ static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 	}
 	context->cqn_send = cpu_to_be32(send_cq->mcq.cqn);
 	context->cqn_recv = cpu_to_be32(recv_cq->mcq.cqn);
-	context->params1  = cpu_to_be32(MLX4_IB_ACK_REQ_FREQ << 28);
 
 	/* Set "fast registration enabled" for all kernel QPs */
 	if (!ibuobject)
@@ -2513,7 +2508,7 @@ static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 					MLX4_IB_LINK_TYPE_ETH;
 		if (dev->dev->caps.tunnel_offload_mode ==  MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
 			/* set QP to receive both tunneled & non-tunneled packets */
-			if (!(context->flags & cpu_to_be32(1 << MLX4_RSS_QPC_FLAG_OFFSET)))
+			if (!rwq_ind_tbl)
 				context->srqn = cpu_to_be32(7 << 28);
 		}
 	}
@@ -2562,6 +2557,13 @@ static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 		}
 	}
 
+	if (rwq_ind_tbl	&&
+	    cur_state == IB_QPS_RESET &&
+	    new_state == IB_QPS_INIT) {
+		fill_qp_rss_context(context, qp);
+		context->flags |= cpu_to_be32(1 << MLX4_RSS_QPC_FLAG_OFFSET);
+	}
+
 	err = mlx4_qp_modify(dev->dev, &qp->mtt, to_mlx4_state(cur_state),
 			     to_mlx4_state(new_state), context, optpar,
 			     sqd_event, &qp->mqp);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
