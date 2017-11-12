From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core 3/5] mlx5: Add support for ibv_td object and its related verbs
Date: Sun, 12 Nov 2017 23:41:41 +0200
Message-ID: <1510522903-6838-4-git-send-email-yishaih@mellanox.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510522903-6838-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch introduces the initial implementation of the
ibv_alloc/dealloc_td verbs.

Upon td creation a dedicated UAR should be attached to this thread
domain object and upon destruction the UAR is detached.

The motivation behind this is to let an application supply this ibv_td
as part of QP creation (by using the ibv_parent_domain) so that this
internal UAR will be used by both QPs, dropping any need to take a lock
upon post_send when those QPs will be used.

A full implementation of the attach/detach dedicated UAR will be given
post the acceptance of the RFC API as part of the final series.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c  |  2 ++
 providers/mlx5/mlx5.h  | 13 +++++++++++++
 providers/mlx5/verbs.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index cbdfc40..0c073e2 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1009,6 +1009,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_rwq_ind_table, mlx5_create_rwq_ind_table);
 	verbs_set_ctx_op(v_ctx, destroy_rwq_ind_table, mlx5_destroy_rwq_ind_table);
 	verbs_set_ctx_op(v_ctx, post_srq_ops, mlx5_post_srq_ops);
+	verbs_set_ctx_op(v_ctx, alloc_td, mlx5_alloc_td);
+	verbs_set_ctx_op(v_ctx, dealloc_td, mlx5_dealloc_td);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 5978e2e..da0aa91 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -321,6 +321,11 @@ struct mlx5_pd {
 	uint32_t			pdn;
 };
 
+struct mlx5_td {
+	struct ibv_td			ibv_td;
+	struct mlx5_bf			*bf;
+};
+
 enum {
 	MLX5_CQ_SET_CI	= 0,
 	MLX5_CQ_ARM_DB	= 1,
@@ -569,6 +574,11 @@ static inline struct mlx5_srq *to_msrq(struct ibv_srq *ibsrq)
 	return container_of(vsrq, struct mlx5_srq, vsrq);
 }
 
+static inline struct mlx5_td *to_mtd(struct ibv_td *ibtd)
+{
+	return to_mxxx(td, td);
+}
+
 static inline struct mlx5_qp *to_mqp(struct ibv_qp *ibqp)
 {
 	struct verbs_qp *vqp = (struct verbs_qp *)ibqp;
@@ -753,6 +763,9 @@ int mlx5_post_srq_ops(struct ibv_srq *srq,
 		      struct ibv_ops_wr *wr,
 		      struct ibv_ops_wr **bad_wr);
 
+struct ibv_td *mlx5_alloc_td(struct ibv_context *context);
+int mlx5_dealloc_td(struct ibv_td *td);
+
 static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
 {
 	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index fea81f9..8cf14c0 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -153,6 +153,49 @@ struct ibv_pd *mlx5_alloc_pd(struct ibv_context *context)
 	return &pd->ibv_pd;
 }
 
+static struct mlx5_bf *mlx5_attach_dedicated_bf(struct ibv_context *context)
+{
+	/* TBD: allocate a dedciated BF to be used by that thread domain */
+	return NULL;
+}
+
+static int mlx5_detach_dedicated_bf(struct mlx5_bf *bf)
+{
+	/* TBD */
+	return 0;
+}
+
+struct ibv_td *mlx5_alloc_td(struct ibv_context *context)
+{
+	struct mlx5_td	*td;
+
+	td = calloc(1, sizeof *td);
+	if (!td)
+		return NULL;
+
+	td->bf = mlx5_attach_dedicated_bf(context);
+	if (td->bf)
+		return NULL;
+
+	td->ibv_td.context = context;
+	return &td->ibv_td;
+}
+
+int mlx5_dealloc_td(struct ibv_td *ib_td)
+{
+	struct mlx5_td	*td;
+	int err;
+
+	td = to_mtd(ib_td);
+	err = mlx5_detach_dedicated_bf(td->bf);
+
+	if (err)
+		return err;
+
+	free(td);
+	return 0;
+}
+
 int mlx5_free_pd(struct ibv_pd *pd)
 {
 	int ret;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
