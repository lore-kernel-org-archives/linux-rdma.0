From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/4] mlx5: Add support for CQ moderation
Date: Mon, 30 Oct 2017 16:09:03 +0200
Message-ID: <1509372543-26603-5-git-send-email-yishaih@mellanox.com>
References: <1509372543-26603-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1509372543-26603-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Support CQ moderation via modify_cq verb.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c  | 1 +
 providers/mlx5/mlx5.h  | 1 +
 providers/mlx5/verbs.c | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 2414881..e63586b 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -966,6 +966,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_rwq_ind_table, mlx5_create_rwq_ind_table);
 	verbs_set_ctx_op(v_ctx, destroy_rwq_ind_table, mlx5_destroy_rwq_ind_table);
 	verbs_set_ctx_op(v_ctx, post_srq_ops, mlx5_post_srq_ops);
+	verbs_set_ctx_op(v_ctx, modify_cq, mlx5_modify_cq);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 5b7d5c0..c26421c 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -661,6 +661,7 @@ int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 		      struct mlx5_buf *buf, int nent, int cqe_sz);
 int mlx5_free_cq_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
 int mlx5_resize_cq(struct ibv_cq *cq, int cqe);
+int mlx5_modify_cq(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
 int mlx5_destroy_cq(struct ibv_cq *cq);
 int mlx5_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int mlx5_poll_cq_v1(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index b073d7b..4de4fa1 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -2378,3 +2378,10 @@ int mlx5_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
 	free(rwq_ind_table);
 	return 0;
 }
+
+int mlx5_modify_cq(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr)
+{
+	struct ibv_modify_cq cmd = {};
+
+	return ibv_cmd_modify_cq(cq, attr, &cmd, sizeof(cmd));
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
