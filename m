From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 v2 2/7] Add resource tracking database
Date: Tue,  2 Feb 2016 21:29:46 +0200
Message-ID: <1454441391-30494-3-git-send-email-majd@mellanox.com>
References: <1454441391-30494-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454441391-30494-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new database that stores all the QPs and XSRQs context.
Insertions and deletions to the database are done using the
object's user-index.

This database will allow us to retrieve the objects; QPs and
XSRQs; by their user-index in the poll_one.

Reviewed-by:: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mlx5.h | 24 ++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/src/mlx5.c b/src/mlx5.c
index e44898a..877df12 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -127,6 +127,81 @@ static int read_number_from_line(const char *line, int *value)
 	*value = atoi(ptr);
 	return 0;
 }
+/**
+ * The function looks for the first free user-index in all the
+ * user-index tables. If all are used, returns -1, otherwise
+ * a valid user-index.
+ * In case the reference count of the table is zero, it means the
+ * table is not in use and wasn't allocated yet, therefore the
+ * mlx5_store_uidx allocates the table, and increment the reference
+ * count on the table.
+ */
+static int32_t get_free_uidx(struct mlx5_context *ctx)
+{
+	int32_t tind;
+	int32_t i;
+
+	for (tind = 0; tind < MLX5_UIDX_TABLE_SIZE; tind++) {
+		if (ctx->uidx_table[tind].refcnt < MLX5_UIDX_TABLE_MASK)
+			break;
+	}
+
+	if (tind == MLX5_UIDX_TABLE_SIZE)
+		return -1;
+
+	if (!ctx->uidx_table[tind].refcnt)
+		return tind << MLX5_UIDX_TABLE_SHIFT;
+
+	for (i = 0; i < MLX5_UIDX_TABLE_MASK + 1; i++) {
+		if (!ctx->uidx_table[tind].table[i])
+			break;
+	}
+
+	return (tind << MLX5_UIDX_TABLE_SHIFT) | i;
+}
+
+int32_t mlx5_store_uidx(struct mlx5_context *ctx, void *rsc)
+{
+	int32_t tind;
+	int32_t ret = -1;
+	int32_t uidx;
+
+	pthread_mutex_lock(&ctx->uidx_table_mutex);
+	uidx = get_free_uidx(ctx);
+	if (uidx < 0)
+		goto out;
+
+	tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
+
+	if (!ctx->uidx_table[tind].refcnt) {
+		ctx->uidx_table[tind].table = calloc(MLX5_UIDX_TABLE_MASK + 1,
+						     sizeof(void *));
+		if (!ctx->uidx_table[tind].table)
+			goto out;
+	}
+
+	++ctx->uidx_table[tind].refcnt;
+	ctx->uidx_table[tind].table[uidx & MLX5_UIDX_TABLE_MASK] = rsc;
+	ret = uidx;
+
+out:
+	pthread_mutex_unlock(&ctx->uidx_table_mutex);
+	return ret;
+}
+
+void mlx5_clear_uidx(struct mlx5_context *ctx, uint32_t uidx)
+{
+	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
+
+	pthread_mutex_lock(&ctx->uidx_table_mutex);
+
+	if (!--ctx->uidx_table[tind].refcnt)
+		free(ctx->uidx_table[tind].table);
+	else
+		ctx->uidx_table[tind].table[uidx & MLX5_UIDX_TABLE_MASK] = NULL;
+
+	pthread_mutex_unlock(&ctx->uidx_table_mutex);
+}
 
 static int mlx5_is_sandy_bridge(int *num_cores)
 {
@@ -535,6 +610,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	pthread_mutex_init(&context->qp_table_mutex, NULL);
 	pthread_mutex_init(&context->srq_table_mutex, NULL);
+	pthread_mutex_init(&context->uidx_table_mutex, NULL);
 	for (i = 0; i < MLX5_QP_TABLE_SIZE; ++i)
 		context->qp_table[i].refcnt = 0;
 
diff --git a/src/mlx5.h b/src/mlx5.h
index a930bac..2691031 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -165,6 +165,12 @@ enum {
 };
 
 enum {
+	MLX5_UIDX_TABLE_SHIFT		= 12,
+	MLX5_UIDX_TABLE_MASK		= (1 << MLX5_UIDX_TABLE_SHIFT) - 1,
+	MLX5_UIDX_TABLE_SIZE		= 1 << (24 - MLX5_UIDX_TABLE_SHIFT),
+};
+
+enum {
 	MLX5_SRQ_TABLE_SHIFT		= 12,
 	MLX5_SRQ_TABLE_MASK		= (1 << MLX5_SRQ_TABLE_SHIFT) - 1,
 	MLX5_SRQ_TABLE_SIZE		= 1 << (24 - MLX5_SRQ_TABLE_SHIFT),
@@ -275,6 +281,12 @@ struct mlx5_context {
 	}				srq_table[MLX5_SRQ_TABLE_SIZE];
 	pthread_mutex_t			srq_table_mutex;
 
+	struct {
+		struct mlx5_resource  **table;
+		int                     refcnt;
+	}				uidx_table[MLX5_UIDX_TABLE_SIZE];
+	pthread_mutex_t                 uidx_table_mutex;
+
 	void			       *uar[MLX5_MAX_UAR_PAGES];
 	struct mlx5_spinlock		lock32;
 	struct mlx5_db_page	       *db_list;
@@ -616,6 +628,8 @@ void mlx5_set_sq_sizes(struct mlx5_qp *qp, struct ibv_qp_cap *cap,
 struct mlx5_qp *mlx5_find_qp(struct mlx5_context *ctx, uint32_t qpn);
 int mlx5_store_qp(struct mlx5_context *ctx, uint32_t qpn, struct mlx5_qp *qp);
 void mlx5_clear_qp(struct mlx5_context *ctx, uint32_t qpn);
+int32_t mlx5_store_uidx(struct mlx5_context *ctx, void *rsc);
+void mlx5_clear_uidx(struct mlx5_context *ctx, uint32_t uidx);
 struct mlx5_srq *mlx5_find_srq(struct mlx5_context *ctx, uint32_t srqn);
 int mlx5_store_srq(struct mlx5_context *ctx, uint32_t srqn,
 		   struct mlx5_srq *srq);
@@ -640,6 +654,16 @@ int mlx5_close_xrcd(struct ibv_xrcd *ib_xrcd);
 struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 				   struct ibv_srq_init_attr_ex *attr);
 
+static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
+{
+	int tind = uidx >> MLX5_UIDX_TABLE_SHIFT;
+
+	if (likely(ctx->uidx_table[tind].refcnt))
+		return ctx->uidx_table[tind].table[uidx & MLX5_UIDX_TABLE_MASK];
+
+	return NULL;
+}
+
 static inline int mlx5_spin_lock(struct mlx5_spinlock *lock)
 {
 	if (!mlx5_single_threaded)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
