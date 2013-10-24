From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 3/4] IB/mlx5: Update opt param mask for RTS2RTS
Date: Thu, 24 Oct 2013 12:01:02 +0300
Message-ID: <1382605263-6822-4-git-send-email-eli@mellanox.com>
References: <1382605263-6822-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382605263-6822-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RTS to RTS transition should allow update of alternate path.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2e4c465..5bcf579 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1317,9 +1317,11 @@ static enum mlx5_qp_optpar opt_mask[MLX5_QP_NUM_STATE][MLX5_QP_NUM_STATE][MLX5_Q
 					  MLX5_QP_OPTPAR_RAE		|
 					  MLX5_QP_OPTPAR_RWE		|
 					  MLX5_QP_OPTPAR_RNR_TIMEOUT	|
-					  MLX5_QP_OPTPAR_PM_STATE,
+					  MLX5_QP_OPTPAR_PM_STATE	|
+					  MLX5_QP_OPTPAR_ALT_ADDR_PATH,
 			[MLX5_QP_ST_UC] = MLX5_QP_OPTPAR_RWE		|
-					  MLX5_QP_OPTPAR_PM_STATE,
+					  MLX5_QP_OPTPAR_PM_STATE	|
+					  MLX5_QP_OPTPAR_ALT_ADDR_PATH,
 			[MLX5_QP_ST_UD] = MLX5_QP_OPTPAR_Q_KEY		|
 					  MLX5_QP_OPTPAR_SRQN		|
 					  MLX5_QP_OPTPAR_CQN_RCV,
-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
