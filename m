From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core 4/5] mlx5: Add support for ibv_parent domain and its related verbs
Date: Sun, 12 Nov 2017 23:41:42 +0200
Message-ID: <1510522903-6838-5-git-send-email-yishaih@mellanox.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510522903-6838-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch is the initial implementation of ibv_alloc/dealloc_parent
domain verbs in the mlx5 driver.

The driver uses internally mlx5_pd structure which its prefix holds
the legacy ibv_pd so that the return ibv_pd can be used with any verb
around that gets a protection domain.

In addition, the driver saves an indication whether this ibv_pd is a
parent domain and as such may hold a thread domain and a pointer to a
previously allocated protection domain.

In downstream patches the mlx5 driver will consider upon getting an
ibv_pd which fields should be used based on the above indicator.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c  |  2 ++
 providers/mlx5/mlx5.h  |  9 +++++++++
 providers/mlx5/verbs.c | 23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 0c073e2..b160373 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1011,6 +1011,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, post_srq_ops, mlx5_post_srq_ops);
 	verbs_set_ctx_op(v_ctx, alloc_td, mlx5_alloc_td);
 	verbs_set_ctx_op(v_ctx, dealloc_td, mlx5_dealloc_td);
+	verbs_set_ctx_op(v_ctx, alloc_parent_domain, mlx5_alloc_parent_domain);
+	verbs_set_ctx_op(v_ctx, dealloc_parent_domain, mlx5_dealloc_parent_domain);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index da0aa91..f9b83ad 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -319,6 +319,9 @@ struct mlx5_buf {
 struct mlx5_pd {
 	struct ibv_pd			ibv_pd;
 	uint32_t			pdn;
+	int 				is_parent_domain;
+	struct ibv_td			*td;
+	struct ibv_pd			*protection_domain;
 };
 
 struct mlx5_td {
@@ -766,6 +769,12 @@ int mlx5_post_srq_ops(struct ibv_srq *srq,
 struct ibv_td *mlx5_alloc_td(struct ibv_context *context);
 int mlx5_dealloc_td(struct ibv_td *td);
 
+struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
+					struct ibv_parent_domain_init_attr *attr);
+
+int mlx5_dealloc_parent_domain(struct ibv_pd *parent_domain);
+
+
 static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
 {
 	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 8cf14c0..13844b3 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -196,6 +196,29 @@ int mlx5_dealloc_td(struct ibv_td *ib_td)
 	return 0;
 }
 
+struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
+			struct ibv_parent_domain_init_attr *attr)
+{
+	struct mlx5_pd	*pd;
+
+	pd = calloc(1, sizeof *pd);
+	if (!pd)
+		return NULL;
+
+	pd->is_parent_domain = 1;
+	pd->td = attr->td;
+	pd->protection_domain= attr->pd;
+
+	pd->ibv_pd.context = context;
+	return &pd->ibv_pd;
+}
+
+int mlx5_dealloc_parent_domain(struct ibv_pd *parent_domain)
+{
+	free(to_mpd(parent_domain));
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
