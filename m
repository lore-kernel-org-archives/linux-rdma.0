From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/4] mlx4: Add support for CQ moderation
Date: Mon, 30 Oct 2017 16:09:02 +0200
Message-ID: <1509372543-26603-4-git-send-email-yishaih@mellanox.com>
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
 providers/mlx4/mlx4.c  | 1 +
 providers/mlx4/mlx4.h  | 1 +
 providers/mlx4/verbs.c | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 6de0bee..9d521a7 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -256,6 +256,7 @@ static int mlx4_init_context(struct verbs_device *v_device,
 	verbs_set_ctx_op(verbs_ctx, destroy_wq, mlx4_destroy_wq);
 	verbs_set_ctx_op(verbs_ctx, create_rwq_ind_table, mlx4_create_rwq_ind_table);
 	verbs_set_ctx_op(verbs_ctx, destroy_rwq_ind_table, mlx4_destroy_rwq_ind_table);
+	verbs_set_ctx_op(verbs_ctx, modify_cq, mlx4_modify_cq);
 
 	return 0;
 
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 14f2720..8283260 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -350,6 +350,7 @@ void mlx4_cq_fill_pfns(struct mlx4_cq *cq, const struct ibv_cq_init_attr_ex *cq_
 int mlx4_alloc_cq_buf(struct mlx4_device *dev, struct mlx4_buf *buf, int nent,
 		      int entry_size);
 int mlx4_resize_cq(struct ibv_cq *cq, int cqe);
+int mlx4_modify_cq(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr);
 int mlx4_destroy_cq(struct ibv_cq *cq);
 int mlx4_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int mlx4_arm_cq(struct ibv_cq *cq, int solicited);
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index b966ef2..1c33f8b 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -1609,3 +1609,10 @@ int mlx4_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table)
 	free(rwq_ind_table);
 	return 0;
 }
+
+int mlx4_modify_cq(struct ibv_cq *cq, struct ibv_modify_cq_attr *attr)
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
