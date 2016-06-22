From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 07/11] IB/mlx4: Fix the SQ size of an RC QP
Date: Wed, 22 Jun 2016 17:27:28 +0300
Message-ID: <1466605652-24798-8-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When calculating the required size of an RC QP send queue, leave
enough space for masked atomic operations, which require more space than
"regular" atomic operation.

Fixes: 6fa8f719844b ("IB/mlx4: Add support for masked atomic operations")
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Reviewed-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 81b0e1f..4cd7bd2 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -362,7 +362,7 @@ static int send_wqe_overhead(enum mlx4_ib_qp_type type, u32 flags)
 			sizeof (struct mlx4_wqe_raddr_seg);
 	case MLX4_IB_QPT_RC:
 		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_atomic_seg) +
+			sizeof(struct mlx4_wqe_masked_atomic_seg) +
 			sizeof (struct mlx4_wqe_raddr_seg);
 	case MLX4_IB_QPT_SMI:
 	case MLX4_IB_QPT_GSI:
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
