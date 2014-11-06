From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 5/5] mlx5_core: Update mlx5_command_str with DC commands
Date: Thu,  6 Nov 2014 17:52:39 +0200
Message-ID: <1415289159-4376-6-git-send-email-eli@mellanox.com>
References: <1415289159-4376-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415289159-4376-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for DC commands and make a few other minor fixes.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 368c6c5ea014..37786ea6ad6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -289,10 +289,10 @@ const char *mlx5_command_str(int command)
 		return "TEARDOWN_HCA";
 
 	case MLX5_CMD_OP_ENABLE_HCA:
-		return "MLX5_CMD_OP_ENABLE_HCA";
+		return "ENABLE_HCA";
 
 	case MLX5_CMD_OP_DISABLE_HCA:
-		return "MLX5_CMD_OP_DISABLE_HCA";
+		return "DISABLE_HCA";
 
 	case MLX5_CMD_OP_QUERY_PAGES:
 		return "QUERY_PAGES";
@@ -390,6 +390,21 @@ const char *mlx5_command_str(int command)
 	case MLX5_CMD_OP_RESIZE_SRQ:
 		return "RESIZE_SRQ";
 
+	case MLX5_CMD_OP_CREATE_DCT:
+		return "CREATE_DCT";
+
+	case MLX5_CMD_OP_DESTROY_DCT:
+		return "DESTROY_DCT";
+
+	case MLX5_CMD_OP_DRAIN_DCT:
+		return "DRAIN_DCT";
+
+	case MLX5_CMD_OP_QUERY_DCT:
+		return "QUERY_DCT";
+
+	case MLX5_CMD_OP_ARM_DCT_FOR_KEY_VIOLATION:
+		return "ARM_DCT";
+
 	case MLX5_CMD_OP_ALLOC_PD:
 		return "ALLOC_PD";
 
@@ -415,7 +430,7 @@ const char *mlx5_command_str(int command)
 		return "DEALLOC_XRCD";
 
 	case MLX5_CMD_OP_ACCESS_REG:
-		return "MLX5_CMD_OP_ACCESS_REG";
+		return "ACCESS_REG";
 
 	default: return "unknown command opcode";
 	}
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
