From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 12/15] mlx5: Fix error code translation from firmware to driver
Date: Wed, 11 Sep 2013 16:35:33 +0300
Message-ID: <1378906536-6925-13-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Limits exceeded should be translated to ENOMEM.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d4a3b4e..18fcdd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1512,7 +1512,7 @@ int mlx5_cmd_status_to_err(struct mlx5_outbox_hdr *hdr)
 	case MLX5_CMD_STAT_BAD_SYS_STATE_ERR:		return -EIO;
 	case MLX5_CMD_STAT_BAD_RES_ERR:			return -EINVAL;
 	case MLX5_CMD_STAT_RES_BUSY:			return -EBUSY;
-	case MLX5_CMD_STAT_LIM_ERR:			return -EINVAL;
+	case MLX5_CMD_STAT_LIM_ERR:			return -ENOMEM;
 	case MLX5_CMD_STAT_BAD_RES_STATE_ERR:		return -EINVAL;
 	case MLX5_CMD_STAT_IX_ERR:			return -EINVAL;
 	case MLX5_CMD_STAT_NO_RES_ERR:			return -EAGAIN;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
