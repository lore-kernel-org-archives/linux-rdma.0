From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/7] mlx5: Use macro for CQE version 1
Date: Thu, 26 Jan 2017 17:56:19 +0200
Message-ID: <1485446182-5109-5-git-send-email-yishaih@mellanox.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485446182-5109-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is macro defined to mark CQE version 1, so let's use it.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 1cf5a5f..980e4df 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -771,7 +771,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	context->cqe_version = resp.cqe_version;
 	if (context->cqe_version) {
-		if (context->cqe_version == 1)
+		if (context->cqe_version == MLX5_CQE_VERSION_V1)
 			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
 		else
 			 goto err_free_bf;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
