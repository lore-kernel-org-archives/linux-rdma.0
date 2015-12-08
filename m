From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC libmlx5 PATCH] Add contiguous pages support
Date: Tue,  8 Dec 2015 17:17:33 +0200
Message-ID: <1449587853-26537-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for contiguous pages allocation when it
asked for.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.c  |  1 +
 src/mlx5.h  |  6 ++++-
 src/verbs.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index e44898a..cfe63c1 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -584,6 +584,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
+	verbs_set_ctx_op(v_ctx, get_mr_access_flags, mlx5_get_mr_access_flags);
 
 	return 0;
 
diff --git a/src/mlx5.h b/src/mlx5.h
index 92ef33d..66f7657 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -388,7 +388,7 @@ struct mlx5_bf {
 struct mlx5_mr {
 	struct ibv_mr			ibv_mr;
 	struct mlx5_buf			buf;
-	uint32_t			alloc_flags;
+	int				access_flags;
 };
 
 struct mlx5_qp {
@@ -621,6 +621,7 @@ struct ibv_xrcd *mlx5_open_xrcd(struct ibv_context *context,
 				struct ibv_xrcd_init_attr *xrcd_init_attr);
 int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num);
 int mlx5_close_xrcd(struct ibv_xrcd *ib_xrcd);
+int mlx5_get_mr_access_flags(struct ibv_mr *ibv_mr);
 struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 				   struct ibv_srq_init_attr_ex *attr);
 
@@ -695,4 +696,7 @@ static inline uint8_t calc_sig(void *wqe, int size)
 	return ~res;
 }
 
+void mlx5_get_alloc_type(const char *component,
+			 enum mlx5_alloc_type *alloc_type,
+			 enum mlx5_alloc_type default_type);
 #endif /* MLX5_H */
diff --git a/src/verbs.c b/src/verbs.c
index 895f77b..7791b77 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -115,6 +115,52 @@ int mlx5_free_pd(struct ibv_pd *pd)
 	return 0;
 }
 
+static void *alloc_buf(struct mlx5_mr *mr,
+                       struct ibv_pd *pd,
+                       size_t length,
+                       void *contig_addr)
+{
+	size_t alloc_length;
+	int force_anon = 0;
+	int force_contig = 0;
+	enum mlx5_alloc_type alloc_type;
+	int page_size = to_mdev(pd->context->device)->page_size;
+	int err;
+
+	mlx5_get_alloc_type(MLX5_MR_PREFIX, &alloc_type, MLX5_ALLOC_TYPE_ALL);
+
+	if (alloc_type == MLX5_ALLOC_TYPE_CONTIG)
+	        force_contig = 1;
+	else if (alloc_type == MLX5_ALLOC_TYPE_ANON)
+	        force_anon = 1;
+
+	if (force_anon) {
+	        err = mlx5_alloc_buf(&mr->buf, align(length, page_size),
+	                             page_size);
+	        if (err)
+	                return NULL;
+
+	        return mr->buf.buf;
+	}
+
+	alloc_length = align(length, page_size);
+
+	err = mlx5_alloc_buf_contig(to_mctx(pd->context), &mr->buf,
+	                            alloc_length, page_size, MLX5_MR_PREFIX);
+	if (!err)
+		return mr->buf.buf;
+
+	if (force_contig)
+		return NULL;
+
+	err = mlx5_alloc_buf(&mr->buf, alloc_length,
+	             page_size);
+	if (err)
+		return NULL;
+
+        return mr->buf.buf;
+}
+
 struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 			   int acc)
 {
@@ -122,11 +168,30 @@ struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	struct ibv_reg_mr cmd;
 	int ret;
 	enum ibv_access_flags access = (enum ibv_access_flags)acc;
+	int is_contig;
 
 	mr = calloc(1, sizeof(*mr));
 	if (!mr)
 		return NULL;
 
+	mr->access_flags = acc;
+	/*
+	 * if addr is NULL and IBV_ACCESS_ALLOC_MR is set,
+	 * allocates contiguous memory
+	 */
+	is_contig = !addr && (access & IBV_ACCESS_ALLOC_MR);
+	if (is_contig) {
+		addr = alloc_buf(mr, pd, length, addr);
+		if (!addr) {
+			free(mr);
+			return NULL;
+		}
+
+		/*
+		 * set the allocated address for the verbs consumer
+		 */
+		mr->ibv_mr.addr = addr;
+	}
 #ifdef IBV_CMD_REG_MR_HAS_RESP_PARAMS
 	{
 		struct ibv_reg_mr_resp resp;
@@ -141,8 +206,15 @@ struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 			      &(mr->ibv_mr),
 			     &cmd, sizeof cmd);
 #endif
+
 	if (ret) {
-		mlx5_free_buf(&(mr->buf));
+		if (is_contig) {
+			if (mr->buf.type == MLX5_ALLOC_TYPE_CONTIG)
+				mlx5_free_buf_contig(to_mctx(pd->context),
+						     &mr->buf);
+			else
+				mlx5_free_buf(&(mr->buf));
+		}
 		free(mr);
 		return NULL;
 	}
@@ -159,6 +231,13 @@ int mlx5_dereg_mr(struct ibv_mr *ibmr)
 	if (ret)
 		return ret;
 
+	if ((mr->access_flags & IBV_ACCESS_ALLOC_MR)) {
+		if (mr->buf.type == MLX5_ALLOC_TYPE_CONTIG)
+			mlx5_free_buf_contig(to_mctx(ibmr->context), &mr->buf);
+		else
+			mlx5_free_buf(&(mr->buf));
+	}
+
 	free(mr);
 	return 0;
 }
@@ -1178,6 +1257,13 @@ struct ibv_qp *mlx5_create_qp_ex(struct ibv_context *context,
 	return create_qp(context, &attrx);
 }
 
+int mlx5_get_mr_access_flags(struct ibv_mr *ibv_mr)
+{
+	struct mlx5_mr * mmr = to_mmr(ibv_mr);
+
+	return mmr->access_flags;
+}
+
 int mlx5_get_srq_num(struct ibv_srq *srq, uint32_t *srq_num)
 {
 	struct mlx5_srq *msrq = to_msrq(srq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
