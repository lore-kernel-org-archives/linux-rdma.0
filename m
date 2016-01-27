From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Add support for create/destroy flow
Date: Wed, 27 Jan 2016 16:26:36 +0200
Message-ID: <1453904796-17573-1-git-send-email-maorg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a call to the extended version of ibv_create_flow and
ibv_destroy_flow.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/mlx5.c b/src/mlx5.c
index e44898a..9dff4cc 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -584,6 +584,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
+	verbs_set_ctx_op(v_ctx, ibv_create_flow, ibv_cmd_create_flow);
+	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 
 	return 0;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
