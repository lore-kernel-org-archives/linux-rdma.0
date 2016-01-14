From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH] IB/mlx5: Expose correct maximum number of CQE capacity
Date: Thu, 14 Jan 2016 08:11:40 +0200
Message-ID: <1452751900-23680-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Maximum number of EQE capacity per CQ was mistakenly exposed
as CQE. Fix that.

Fixes: 938fe83c8dcb ("net/mlx5_core: New device capabilities handling")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5e3d3aea35bc..155dbe3826f8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -515,7 +515,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_sge = min(max_rq_sg, max_sq_sg);
 	props->max_sge_rd = props->max_sge;
 	props->max_cq		   = 1 << MLX5_CAP_GEN(mdev, log_max_cq);
-	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_eq_sz)) - 1;
+	props->max_cqe = (1 << MLX5_CAP_GEN(mdev, log_max_cq_sz)) - 1;
 	props->max_mr		   = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
 	props->max_pd		   = 1 << MLX5_CAP_GEN(mdev, log_max_pd);
 	props->max_qp_rd_atom	   = 1 << MLX5_CAP_GEN(mdev, log_max_ra_req_qp);
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
