From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-core 4/4] Export mlx5dv_create_qp() from libmlx5
Date: Sun, 26 Nov 2017 19:45:17 +0200
Message-ID: <1511718317-3381-7-git-send-email-alexma@mellanox.com>
References: <1511718317-3381-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511718317-3381-1-git-send-email-alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/libmlx5.map | 1 +
 1 file changed, 1 insertion(+)

diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index 09d886d..efd0ccb 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -10,6 +10,7 @@ MLX5_1.0 {
 MLX5_1.1 {
 	global:
 		mlx5dv_create_cq;
+		mlx5dv_create_qp;
 } MLX5_1.0;
 
 MLX5_1.2 {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
