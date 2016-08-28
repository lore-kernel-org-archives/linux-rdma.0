From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 8/9] IB/mlx5: Use TIR number based on selector
Date: Sun, 28 Aug 2016 10:58:37 +0300
Message-ID: <1472371118-8260-9-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use TIR number based on selector, it should be done to differentiate
between RSS QP to RAW one.

Reported-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 6 +++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
 drivers/infiniband/hw/mlx5/qp.c      | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1b4094b..8150ea3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1849,6 +1849,7 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 					   int domain)
 {
 	struct mlx5_ib_dev *dev = to_mdev(qp->device);
+	struct mlx5_ib_qp *mqp = to_mqp(qp);
 	struct mlx5_ib_flow_handler *handler = NULL;
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_ib_flow_prio *ft_prio;
@@ -1875,7 +1876,10 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 	}
 
 	dst->type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-	dst->tir_num = to_mqp(qp)->raw_packet_qp.rq.tirn;
+	if (mqp->flags & MLX5_IB_QP_RSS)
+		dst->tir_num = mqp->rss_qp.tirn;
+	else
+		dst->tir_num = mqp->raw_packet_qp.rq.tirn;
 
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
 		if (flow_attr->flags & IB_FLOW_ATTR_FLAGS_DONT_TRAP)  {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 372385d..95146f4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -402,6 +402,7 @@ enum mlx5_ib_qp_flags {
 	/* QP uses 1 as its source QP number */
 	MLX5_IB_QP_SQPN_QP1			= 1 << 6,
 	MLX5_IB_QP_CAP_SCATTER_FCS		= 1 << 7,
+	MLX5_IB_QP_RSS				= 1 << 8,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 67b58f7..fc5030f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1449,6 +1449,7 @@ create_tir:
 	kvfree(in);
 	/* qpn is reserved for that QP */
 	qp->trans_qp.base.mqp.qpn = 0;
+	qp->flags |= MLX5_IB_QP_RSS;
 	return 0;
 
 err:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
