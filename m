From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4] Align the Flow Steering support with libibverbs
Date: Wed, 14 May 2014 16:44:49 +0300
Message-ID: <1400075090-14296-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix the implementation of receive flow steering in libmlx4 to
use the right verbs entries according to the verbs extensions scheme.

The implementation uses the default commands from libibverbs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 2999150..1ee0338 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -203,8 +203,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, get_srq_num, verbs_get_srq_num);
 	verbs_set_ctx_op(verbs_ctx, create_qp_ex, mlx4_create_qp_ex);
 	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
-	verbs_set_ctx_op(verbs_ctx, drv_ibv_create_flow, ibv_cmd_create_flow);
-	verbs_set_ctx_op(verbs_ctx, drv_ibv_destroy_flow, ibv_cmd_destroy_flow);
+	verbs_set_ctx_op(verbs_ctx, create_flow, ibv_cmd_create_flow);
+	verbs_set_ctx_op(verbs_ctx, destroy_flow, ibv_cmd_destroy_flow);
 
 	return 0;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
