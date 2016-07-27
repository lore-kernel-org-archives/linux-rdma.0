From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 5/6] fix alloc of mlx5_resource table
Date: Wed, 27 Jul 2016 15:17:26 -0400
Message-ID: <1469647047-7544-6-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Defect type: CLANG_WARNING

libmlx5-1.2.1/src/mlx5.c:184:33: note: Result of 'calloc' is converted
to a pointer of type 'struct mlx5_resource *', which is incompatible with
sizeof operand type 'void *'

 #                 ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
 #                                               ^~~~~~
 #   182|
 #   183|   	if (!ctx->uidx_table[tind].refcnt) {
 #   184|-> 		ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
 #   185|   						     sizeof(void *));
 #   186|   		if (!ctx->uidx_table[tind].table)

Use sizeof(struct mlx5_resource *) for calloc size argument instead.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/mlx5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index a5f8daf..99221e6 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -182,7 +182,7 @@ int32_t mlx5_store_uidx(struct mlx5_context *ctx, void *rsc)
 
 	if (!ctx->uidx_table[tind].refcnt) {
 		ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
-						     sizeof(void *));
+						     sizeof(struct mlx5_resource *));
 		if (!ctx->uidx_table[tind].table)
 			goto out;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
