From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 2/5] Add QPs and XSRQs resource tracking
Date: Sun,  6 Sep 2015 12:30:09 +0300
Message-ID: <1441531812-27716-3-git-send-email-hagaya@mellanox.com>
References: <1441531812-27716-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441531812-27716-1-git-send-email-hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add new database that stores all the QPs and XSRQs context. Insertions
and deletions to the database are done using the object's user-index.

This database will allow us to retrieve the objects; QPs and XSRQs; by
their user-index in the poll_one.


Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mlx5.h | 24 ++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/src/mlx5.c b/src/mlx5.c
index d023288..6ce8bd8 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -128,6 +128,73 @@ static int read_number_from_line(const char *line, int *value)
 	return 0;
 }
 
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
+
 static int mlx5_is_sandy_bridge(int *num_cores)
 {
 	char line[128];
diff --git a/src/mlx5.h b/src/mlx5.h
index 4dda0bf..17ef51c 100644
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
@@ -612,6 +624,8 @@ void mlx5_set_sq_sizes(struct mlx5_qp *qp, struct ibv_qp_cap *cap,
 struct mlx5_qp *mlx5_find_qp(struct mlx5_context *ctx, uint32_t qpn);
 int mlx5_store_qp(struct mlx5_context *ctx, uint32_t qpn, struct mlx5_qp *qp);
 void mlx5_clear_qp(struct mlx5_context *ctx, uint32_t qpn);
+int32_t mlx5_store_uidx(struct mlx5_context *ctx, void *rsc);
+void mlx5_clear_uidx(struct mlx5_context *ctx, uint32_t uidx);
 struct mlx5_srq *mlx5_find_srq(struct mlx5_context *ctx, uint32_t srqn);
 int mlx5_store_srq(struct mlx5_context *ctx, uint32_t srqn,
 		   struct mlx5_srq *srq);
@@ -636,6 +650,16 @@ int mlx5_close_xrcd(struct ibv_xrcd *ib_xrcd);
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
