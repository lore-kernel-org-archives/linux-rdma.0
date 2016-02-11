From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-rc] IB/mlx5: Fix RC transport send queue overhead computation
Date: Thu, 11 Feb 2016 21:09:57 +0200
Message-ID: <1455217797-15635-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the RC QPs send queue overhead computation to take into account
two additional segments in the WQE which are needed for registration
operations.

The ATOMIC and UMR segments can't coexist together, so chose maximum out
of them.

The commit 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead
computation") was intended to update RC transport as commit messages
states, but added the code to UC transport.

Fixes: 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead computation")
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9116bc3..34cb8e8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -270,8 +270,10 @@ static int sq_overhead(enum ib_qp_type qp_type)
 		/* fall through */
 	case IB_QPT_RC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
-			sizeof(struct mlx5_wqe_atomic_seg) +
-			sizeof(struct mlx5_wqe_raddr_seg);
+			max(sizeof(struct mlx5_wqe_atomic_seg) +
+			    sizeof(struct mlx5_wqe_raddr_seg),
+			    sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+			    sizeof(struct mlx5_mkey_seg));
 		break;
 
 	case IB_QPT_XRC_TGT:
@@ -279,9 +281,9 @@ static int sq_overhead(enum ib_qp_type qp_type)
 
 	case IB_QPT_UC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
-			sizeof(struct mlx5_wqe_raddr_seg) +
-			sizeof(struct mlx5_wqe_umr_ctrl_seg) +
-			sizeof(struct mlx5_mkey_seg);
+			max(sizeof(struct mlx5_wqe_raddr_seg),
+			    sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+			    sizeof(struct mlx5_mkey_seg));
 		break;
 
 	case IB_QPT_UD:
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
