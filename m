From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4] Add receive flow steering support
Date: Thu,  6 Feb 2014 14:21:36 +0200
Message-ID: <1391689296-13090-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The implementation uses the default commands from libibverbs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/mlx4.c b/src/mlx4.c
index 58f5435..f73e23b 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -209,6 +209,8 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, drv_ibv_create_ah_ex, mlx4_create_ah_ex);
 	verbs_set_ctx_op(verbs_ctx, drv_query_port_ex,
 			 mlx4_query_port_ex);
+	verbs_set_ctx_op(verbs_ctx, drv_ibv_create_flow, ibv_cmd_create_flow);
+	verbs_set_ctx_op(verbs_ctx, drv_ibv_destroy_flow, ibv_cmd_destroy_flow);
 	verbs_ctx->has_comp_mask = VERBS_CONTEXT_CREATE_AH;
 
 	return 0;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
