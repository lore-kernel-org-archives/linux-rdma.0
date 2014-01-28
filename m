From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/mlx5: Fix RC transport send queue overhead computation
Date: Tue, 28 Jan 2014 14:52:47 +0200
Message-ID: <1390913567-4562-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the RC QPs send queue overhead computation to take into account two
additional segments in the WQE which are needed for registration operations.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ae37fb9..492dc33 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -216,7 +216,9 @@ static int sq_overhead(enum ib_qp_type qp_type)
 
 	case IB_QPT_UC:
 		size += sizeof(struct mlx5_wqe_ctrl_seg) +
-			sizeof(struct mlx5_wqe_raddr_seg);
+			sizeof(struct mlx5_wqe_raddr_seg) +
+			sizeof(struct mlx5_wqe_umr_ctrl_seg) +
+			sizeof(struct mlx5_mkey_seg);
 		break;
 
 	case IB_QPT_UD:
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
