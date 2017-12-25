From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/9] mlx5: Add support for the ibv_td object and its related verbs
Date: Mon, 25 Dec 2017 15:56:55 +0200
Message-ID: <1514210221-10466-4-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch introduces the initial implementation of the
ibv_alloc/dealloc_td verbs.

Upon TD creation a dedicated BF (blue-flame) register should be attached
to its object and upon destruction the BF will be detached.

The motivation behind this, is to enable an application to create QP(s)
with a given TD (by using the ibv_parent_domain) and then benefit from
dropping the lock around the internal BF register upon post send.

Downstream patches in this series add the above functionality.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c  |  2 ++
 providers/mlx5/mlx5.h  | 14 ++++++++++++++
 providers/mlx5/verbs.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 3648621..d078548 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1026,6 +1026,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	v_ctx->destroy_rwq_ind_table = mlx5_destroy_rwq_ind_table;
 	v_ctx->post_srq_ops = mlx5_post_srq_ops;
 	v_ctx->modify_cq = mlx5_modify_cq;
+	v_ctx->alloc_td = mlx5_alloc_td;
+	v_ctx->dealloc_td = mlx5_dealloc_td;
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 5a1f7c0..4d4c583 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -320,6 +320,12 @@ struct mlx5_buf {
 	enum mlx5_alloc_type		type;
 };
 
+struct mlx5_td {
+	struct ibv_td			ibv_td;
+	struct mlx5_bf			*bf;
+	atomic_int			refcount;
+};
+
 struct mlx5_pd {
 	struct ibv_pd			ibv_pd;
 	uint32_t			pdn;
@@ -568,6 +574,11 @@ static inline struct mlx5_srq *to_msrq(struct ibv_srq *ibsrq)
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
@@ -753,6 +764,9 @@ int mlx5_post_srq_ops(struct ibv_srq *srq,
 		      struct ibv_ops_wr *wr,
 		      struct ibv_ops_wr **bad_wr);
 
+struct ibv_td *mlx5_alloc_td(struct ibv_context *context, struct ibv_td_init_attr *init_attr);
+int mlx5_dealloc_td(struct ibv_td *td);
+
 static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
 {
 	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index a3323fd..43db501 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -153,6 +153,56 @@ struct ibv_pd *mlx5_alloc_pd(struct ibv_context *context)
 	return &pd->ibv_pd;
 }
 
+static struct mlx5_bf *mlx5_attach_dedicated_bf(struct ibv_context *context)
+{
+	return NULL;
+}
+
+static void mlx5_detach_dedicated_bf(struct ibv_context *context, struct mlx5_bf *bf)
+{
+}
+
+struct ibv_td *mlx5_alloc_td(struct ibv_context *context, struct ibv_td_init_attr *init_attr)
+{
+	struct mlx5_td	*td;
+
+	if (init_attr->comp_mask) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	td = calloc(1, sizeof(*td));
+	if (!td) {
+		errno = ENOMEM;
+		return NULL;
+	}
+
+	td->bf = mlx5_attach_dedicated_bf(context);
+	if (!td->bf) {
+		free(td);
+		return NULL;
+	}
+
+	td->ibv_td.context = context;
+	atomic_init(&td->refcount, 1);
+
+	return &td->ibv_td;
+}
+
+int mlx5_dealloc_td(struct ibv_td *ib_td)
+{
+	struct mlx5_td	*td;
+
+	td = to_mtd(ib_td);
+	if (atomic_load(&td->refcount) > 1)
+		return EBUSY;
+
+	mlx5_detach_dedicated_bf(ib_td->context, td->bf);
+	free(td);
+
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
