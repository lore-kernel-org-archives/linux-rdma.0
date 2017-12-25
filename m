From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/9] mlx5: Add support for ibv_parent_domain
Date: Mon, 25 Dec 2017 15:56:56 +0200
Message-ID: <1514210221-10466-5-git-send-email-yishaih@mellanox.com>
References: <1514210221-10466-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514210221-10466-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds support for ibv_alloc_parent domain verb in the mlx5
driver.

The driver uses internally the mlx5_pd structure which as its
prefix holds the core ibv_pd so that the return ibv_pd can be used
with any verb that gets a protection domain.

A parent domain must include a valid protection domain pointer and
optionally can hold a thread domain.

When used as a parent domain the core ibv_pd completely duplicates the
protection domain core fields, so the two pointers are totally
interchangeable in all core APIs, minimizing driver changes.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c  |  1 +
 providers/mlx5/mlx5.h  | 31 ++++++++++++++++++++++++-
 providers/mlx5/verbs.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index d078548..d76964f 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1028,6 +1028,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	v_ctx->modify_cq = mlx5_modify_cq;
 	v_ctx->alloc_td = mlx5_alloc_td;
 	v_ctx->dealloc_td = mlx5_dealloc_td;
+	v_ctx->alloc_parent_domain = mlx5_alloc_parent_domain;
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 4d4c583..ed75409 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -329,6 +329,13 @@ struct mlx5_td {
 struct mlx5_pd {
 	struct ibv_pd			ibv_pd;
 	uint32_t			pdn;
+	atomic_int			refcount;
+	struct mlx5_pd			*mprotection_domain;
+};
+
+struct mlx5_parent_domain {
+	struct mlx5_pd mpd;
+	struct mlx5_td *mtd;
 };
 
 enum {
@@ -557,9 +564,27 @@ static inline struct mlx5_context *to_mctx(struct ibv_context *ibctx)
 	return to_mxxx(ctx, context);
 }
 
+/* to_mpd always returns the real mlx5_pd object ie the protection domain. */
 static inline struct mlx5_pd *to_mpd(struct ibv_pd *ibpd)
 {
-	return to_mxxx(pd, pd);
+	struct mlx5_pd *mpd = to_mxxx(pd, pd);
+
+	if (mpd->mprotection_domain)
+		return mpd->mprotection_domain;
+
+	return mpd;
+}
+
+static inline struct mlx5_parent_domain *to_mparent_domain(struct ibv_pd *ibpd)
+{
+	struct mlx5_parent_domain *mparent_domain =
+	    ibpd ? container_of(ibpd, struct mlx5_parent_domain, mpd.ibv_pd) : NULL;
+
+	if (mparent_domain && mparent_domain->mpd.mprotection_domain)
+		return mparent_domain;
+
+	/* Otherwise ibpd isn't a parent_domain */
+	return NULL;
 }
 
 static inline struct mlx5_cq *to_mcq(struct ibv_cq *ibcq)
@@ -767,6 +792,10 @@ int mlx5_post_srq_ops(struct ibv_srq *srq,
 struct ibv_td *mlx5_alloc_td(struct ibv_context *context, struct ibv_td_init_attr *init_attr);
 int mlx5_dealloc_td(struct ibv_td *td);
 
+struct ibv_pd *mlx5_alloc_parent_domain(struct ibv_context *context,
+					struct ibv_parent_domain_init_attr *attr);
+
+
 static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
 {
 	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index 43db501..13af0c2 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -148,6 +148,7 @@ struct ibv_pd *mlx5_alloc_pd(struct ibv_context *context)
 		return NULL;
 	}
 
+	atomic_init(&pd->refcount, 1);
 	pd->pdn = resp.pdn;
 
 	return &pd->ibv_pd;
@@ -203,15 +204,73 @@ int mlx5_dealloc_td(struct ibv_td *ib_td)
 	return 0;
 }
 
+struct ibv_pd *
+mlx5_alloc_parent_domain(struct ibv_context *context,
+			 struct ibv_parent_domain_init_attr *attr)
+{
+	struct mlx5_parent_domain *mparent_domain;
+
+	if (ibv_check_alloc_parent_domain(attr))
+		return NULL;
+
+	if (attr->comp_mask) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	mparent_domain = calloc(1, sizeof(*mparent_domain));
+	if (!mparent_domain) {
+		errno = ENOMEM;
+		return NULL;
+	}
+
+	if (attr->td) {
+		mparent_domain->mtd = to_mtd(attr->td);
+		atomic_fetch_add(&mparent_domain->mtd->refcount, 1);
+	}
+
+	mparent_domain->mpd.mprotection_domain = to_mpd(attr->pd);
+	atomic_fetch_add(&mparent_domain->mpd.mprotection_domain->refcount, 1);
+	atomic_init(&mparent_domain->mpd.refcount, 1);
+
+	ibv_initialize_parent_domain(
+	    &mparent_domain->mpd.ibv_pd,
+	    &mparent_domain->mpd.mprotection_domain->ibv_pd);
+
+	return &mparent_domain->mpd.ibv_pd;
+}
+
+static int mlx5_dealloc_parent_domain(struct mlx5_parent_domain *mparent_domain)
+{
+	if (atomic_load(&mparent_domain->mpd.refcount) > 1)
+		return EBUSY;
+
+	atomic_fetch_sub(&mparent_domain->mpd.mprotection_domain->refcount, 1);
+
+	if (mparent_domain->mtd)
+		atomic_fetch_sub(&mparent_domain->mtd->refcount, 1);
+
+	free(mparent_domain);
+	return 0;
+}
+
 int mlx5_free_pd(struct ibv_pd *pd)
 {
 	int ret;
+	struct mlx5_parent_domain *mparent_domain = to_mparent_domain(pd);
+	struct mlx5_pd *mpd = to_mpd(pd);
+
+	if (mparent_domain)
+		return mlx5_dealloc_parent_domain(mparent_domain);
+
+	if (atomic_load(&mpd->refcount) > 1)
+		return EBUSY;
 
 	ret = ibv_cmd_dealloc_pd(pd);
 	if (ret)
 		return ret;
 
-	free(to_mpd(pd));
+	free(mpd);
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
