From: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] Update ibv_create_flow/ibv_destroy_flow according to change of libibverbs
Date: Wed, 16 Sep 2015 19:01:53 +0300
Message-ID: <dcad1dc2e480fefaf359c96f8bdf2fa87ee983fa.1442412742.git.bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 2999150..9fe8c6a 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -203,8 +203,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, get_srq_num, verbs_get_srq_num);
 	verbs_set_ctx_op(verbs_ctx, create_qp_ex, mlx4_create_qp_ex);
 	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
-	verbs_set_ctx_op(verbs_ctx, drv_ibv_create_flow, ibv_cmd_create_flow);
-	verbs_set_ctx_op(verbs_ctx, drv_ibv_destroy_flow, ibv_cmd_destroy_flow);
+	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, ibv_cmd_create_flow);
+	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, ibv_cmd_destroy_flow);
 
 	return 0;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
