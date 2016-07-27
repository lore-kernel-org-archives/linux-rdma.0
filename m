From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 4/6] fix check of mlx5_store_uidx return
Date: Wed, 27 Jul 2016 15:17:25 -0400
Message-ID: <1469647047-7544-5-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

mlx5_store_uidx() returns an int32_t, but create_qp was storing the return
in a uint32_t, and then checking for a value less than 0, which is
impossible with the uint32_t. Use a local int32_t for the return, check
for < 0, then cast to uint32_t and save the result for later use.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/verbs.c b/src/verbs.c
index 7ed394e..d64e406 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1224,11 +1224,13 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		cmd.uidx = 0xffffff;
 		pthread_mutex_lock(&ctx->qp_table_mutex);
 	} else if (!is_xrc_tgt(attr->qp_type)) {
-		usr_idx = mlx5_store_uidx(ctx, qp);
-		if (usr_idx < 0) {
+		int32_t uidx_ret;
+		uidx_ret = mlx5_store_uidx(ctx, qp);
+		if (uidx_ret < 0) {
 			mlx5_dbg(fp, MLX5_DBG_QP, "Couldn't find free user index\n");
 			goto err_rq_db;
 		}
+		usr_idx = (uint32_t)uidx_ret;
 
 		cmd.uidx = usr_idx;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
