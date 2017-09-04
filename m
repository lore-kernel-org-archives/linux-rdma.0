From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx5: External memory binding for HW resources
Date: Mon,  4 Sep 2017 16:55:02 +0300
Message-ID: <1504533302-11998-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Xueming Li <xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a new DV API mlx5dv_set_context_attr() to enable setting an external
memory allocator. This API will allow the application to use specific
decisions about the memory allocation of HW resources (e.g. DV objects).
Some examples are managing numa pinning per object, managing a
hugepages resource pool, shared memory regions.

Also extend mlx5dv_get_qp() to return UAR mapping info. This can allow a
process to share its doorbell access with secondary process by re-mmap
the UAR address on the device and make it accessible as a user space
address.

Signed-off-by: Xueming Li <xuemingl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/209

 providers/mlx5/buf.c       | 51 +++++++++++++++++++++++++++++++++++++++++++++-
 providers/mlx5/cq.c        |  2 +-
 providers/mlx5/dbrec.c     | 13 ++++++++++--
 providers/mlx5/libmlx5.map |  1 +
 providers/mlx5/mlx5.c      | 43 ++++++++++++++++++++++++++++++++------
 providers/mlx5/mlx5.h      | 10 ++++++++-
 providers/mlx5/mlx5dv.h    | 25 +++++++++++++++++++++++
 providers/mlx5/verbs.c     |  9 +++++---
 8 files changed, 140 insertions(+), 14 deletions(-)

diff --git a/providers/mlx5/buf.c b/providers/mlx5/buf.c
index 853450a..8196db6 100644
--- a/providers/mlx5/buf.c
+++ b/providers/mlx5/buf.c
@@ -320,6 +320,36 @@ static void free_huge_buf(struct mlx5_context *ctx, struct mlx5_buf *buf)
 		mlx5_spin_unlock(&ctx->hugetlb_lock);
 }
 
+void mlx5_free_buf_extern(struct mlx5_context *ctx, struct mlx5_buf *buf)
+{
+	ibv_dofork_range(buf->buf, buf->length);
+	ctx->extern_alloc.free(buf->buf, ctx->extern_alloc.data);
+}
+
+int mlx5_alloc_buf_extern(struct mlx5_context *ctx, struct mlx5_buf *buf,
+		size_t size)
+{
+	void *addr;
+
+	addr = ctx->extern_alloc.alloc(size, ctx->extern_alloc.data);
+	if (addr || size == 0) {
+		if (ibv_dontfork_range(addr, size)) {
+			mlx5_dbg(stderr, MLX5_DBG_CONTIG,
+				"External mode dontfork_range failed\n");
+			ctx->extern_alloc.free(addr,
+				ctx->extern_alloc.data);
+			return -1;
+		}
+		buf->buf = addr;
+		buf->length = size;
+		buf->type = MLX5_ALLOC_TYPE_EXTERNAL;
+		return 0;
+	}
+
+	mlx5_dbg(stderr, MLX5_DBG_CONTIG, "External alloc failed\n");
+	return -1;
+}
+
 int mlx5_alloc_prefered_buf(struct mlx5_context *mctx,
 			    struct mlx5_buf *buf,
 			    size_t size, int page_size,
@@ -362,6 +392,9 @@ int mlx5_alloc_prefered_buf(struct mlx5_context *mctx,
 			 "Contig allocation failed, fallback to default mode\n");
 	}
 
+	if (type == MLX5_ALLOC_TYPE_EXTERNAL)
+		return mlx5_alloc_buf_extern(mctx, buf, size);
+
 	return mlx5_alloc_buf(buf, size, page_size);
 
 }
@@ -382,6 +415,11 @@ int mlx5_free_actual_buf(struct mlx5_context *ctx, struct mlx5_buf *buf)
 	case MLX5_ALLOC_TYPE_CONTIG:
 		mlx5_free_buf_contig(ctx, buf);
 		break;
+
+	case MLX5_ALLOC_TYPE_EXTERNAL:
+		mlx5_free_buf_extern(ctx, buf);
+		break;
+
 	default:
 		fprintf(stderr, "Bad allocation type\n");
 	}
@@ -414,7 +452,13 @@ static uint32_t mlx5_get_block_order(uint32_t v)
 	return r;
 }
 
-void mlx5_get_alloc_type(const char *component,
+bool mlx5_is_extern_alloc(struct mlx5_context *context)
+{
+	return context->extern_alloc.alloc && context->extern_alloc.free;
+}
+
+void mlx5_get_alloc_type(struct mlx5_context *context,
+			 const char *component,
 			 enum mlx5_alloc_type *alloc_type,
 			 enum mlx5_alloc_type default_type)
 
@@ -422,6 +466,11 @@ void mlx5_get_alloc_type(const char *component,
 	char *env_value;
 	char name[128];
 
+	if (mlx5_is_extern_alloc(context)) {
+		*alloc_type = MLX5_ALLOC_TYPE_EXTERNAL;
+		return;
+	}
+
 	snprintf(name, sizeof(name), "%s_ALLOC_TYPE", component);
 
 	*alloc_type = default_type;
diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index ebcb5b7..de261dd 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1497,7 +1497,7 @@ int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 	if (mlx5_use_huge("HUGE_CQ"))
 		default_type = MLX5_ALLOC_TYPE_HUGE;
 
-	mlx5_get_alloc_type(MLX5_CQ_PREFIX, &type, default_type);
+	mlx5_get_alloc_type(mctx, MLX5_CQ_PREFIX, &type, default_type);
 
 	ret = mlx5_alloc_prefered_buf(mctx, buf,
 				      align(nent * cqe_sz, dev->page_size),
diff --git a/providers/mlx5/dbrec.c b/providers/mlx5/dbrec.c
index 20e37ca..17aee0b 100644
--- a/providers/mlx5/dbrec.c
+++ b/providers/mlx5/dbrec.c
@@ -53,6 +53,7 @@ static struct mlx5_db_page *__add_page(struct mlx5_context *context)
 	int pp;
 	int i;
 	int nlong;
+	int ret;
 
 	pp = ps / context->cache_line_size;
 	nlong = (pp + 8 * sizeof(long) - 1) / (8 * sizeof(long));
@@ -61,7 +62,11 @@ static struct mlx5_db_page *__add_page(struct mlx5_context *context)
 	if (!page)
 		return NULL;
 
-	if (mlx5_alloc_buf(&page->buf, ps, ps)) {
+	if (mlx5_is_extern_alloc(context))
+		ret = mlx5_alloc_buf_extern(context, &page->buf, ps);
+	else
+		ret = mlx5_alloc_buf(&page->buf, ps, ps);
+	if (ret) {
 		free(page);
 		return NULL;
 	}
@@ -139,7 +144,11 @@ void mlx5_free_db(struct mlx5_context *context, __be32 *db)
 		if (page->next)
 			page->next->prev = page->prev;
 
-		mlx5_free_buf(&page->buf);
+		if (page->buf.type == MLX5_ALLOC_TYPE_EXTERNAL)
+			mlx5_free_buf_extern(context, &page->buf);
+		else
+			mlx5_free_buf(&page->buf);
+
 		free(page);
 	}
 
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index e7fe9f4..09d886d 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -15,4 +15,5 @@ MLX5_1.1 {
 MLX5_1.2 {
 	global:
 		mlx5dv_init_obj;
+		mlx5dv_set_context_attr;
 } MLX5_1.1;
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 19e2aef..0e4d65f 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -642,8 +642,8 @@ static int mlx5dv_get_qp(struct ibv_qp *qp_in,
 			 struct mlx5dv_qp *qp_out)
 {
 	struct mlx5_qp *mqp = to_mqp(qp_in);
+	uint64_t mask_out = 0;
 
-	qp_out->comp_mask = 0;
 	qp_out->dbrec     = mqp->db;
 
 	if (mqp->sq_buf_size)
@@ -658,13 +658,20 @@ static int mlx5dv_get_qp(struct ibv_qp *qp_in,
 	qp_out->rq.wqe_cnt = mqp->rq.wqe_cnt;
 	qp_out->rq.stride  = 1 << mqp->rq.wqe_shift;
 
-	qp_out->bf.reg    = mqp->bf->reg;
+	qp_out->bf.reg	   = mqp->bf->reg;
+
+	if (qp_out->comp_mask & MLX5DV_QP_MASK_UAR_MMAP_OFFSET) {
+		qp_out->uar_mmap_offset = mqp->bf->uar_mmap_offset;
+		mask_out |= MLX5DV_QP_MASK_UAR_MMAP_OFFSET;
+	}
 
 	if (mqp->bf->uuarn > 0)
 		qp_out->bf.size = mqp->bf->buf_size;
 	else
 		qp_out->bf.size = 0;
 
+	qp_out->comp_mask = mask_out;
+
 	return 0;
 }
 
@@ -752,6 +759,31 @@ COMPAT_SYMVER_FUNC(mlx5dv_init_obj, 1_0, "MLX5_1.0",
 	return ret;
 }
 
+static off_t get_uar_mmap_offset(int idx, int page_size)
+{
+	off_t offset = 0;
+
+	set_command(MLX5_MMAP_GET_REGULAR_PAGES_CMD, &offset);
+	set_index(idx, &offset);
+	return offset * page_size;
+}
+
+int mlx5dv_set_context_attr(struct ibv_context *ibv_ctx,
+			enum mlx5dv_set_ctx_attr_type type, void *attr)
+{
+	struct mlx5_context *ctx = to_mctx(ibv_ctx);
+
+	switch (type) {
+	case MLX5DV_CTX_ATTR_BUF_ALLOCATORS:
+		ctx->extern_alloc = *((struct mlx5dv_ctx_allocators *)attr);
+		break;
+	default:
+		return ENOTSUP;
+	}
+
+	return 0;
+}
+
 static void adjust_uar_info(struct mlx5_device *mdev,
 			    struct mlx5_context *context,
 			    struct mlx5_alloc_ucontext_resp resp)
@@ -878,11 +910,9 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	num_sys_page_map = context->tot_uuars / (context->num_uars_per_page * MLX5_NUM_NON_FP_BFREGS_PER_UAR);
 	for (i = 0; i < num_sys_page_map; ++i) {
-		offset = 0;
-		set_command(MLX5_MMAP_GET_REGULAR_PAGES_CMD, &offset);
-		set_index(i, &offset);
+		offset = get_uar_mmap_offset(i, page_size);
 		context->uar[i] = mmap(NULL, page_size, PROT_WRITE, MAP_SHARED,
-				       cmd_fd, page_size * offset);
+				       cmd_fd, offset);
 		if (context->uar[i] == MAP_FAILED) {
 			context->uar[i] = NULL;
 			goto err_free_bf;
@@ -901,6 +931,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 				if (bfi)
 					context->bfs[bfi].buf_size = context->bf_reg_size / 2;
 				context->bfs[bfi].uuarn = bfi;
+				context->bfs[bfi].uar_mmap_offset = get_uar_mmap_offset(i, page_size);
 			}
 		}
 	}
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 4c494dd..ad36cbf 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -164,6 +164,7 @@ enum mlx5_alloc_type {
 	MLX5_ALLOC_TYPE_CONTIG,
 	MLX5_ALLOC_TYPE_PREFER_HUGE,
 	MLX5_ALLOC_TYPE_PREFER_CONTIG,
+	MLX5_ALLOC_TYPE_EXTERNAL,
 	MLX5_ALLOC_TYPE_ALL
 };
 
@@ -267,6 +268,7 @@ struct mlx5_context {
 	uint32_t			uar_size;
 	uint64_t			vendor_cap_flags; /* Use enum mlx5_vendor_cap_flags */
 	struct mlx5dv_cqe_comp_caps	cqe_comp_caps;
+	struct mlx5dv_ctx_allocators	extern_alloc;
 };
 
 struct mlx5_bitmap {
@@ -385,6 +387,7 @@ struct mlx5_bf {
 	unsigned			offset;
 	unsigned			buf_size;
 	unsigned			uuarn;
+	off_t				uar_mmap_offset;
 };
 
 struct mlx5_mr {
@@ -556,10 +559,15 @@ int mlx5_alloc_prefered_buf(struct mlx5_context *mctx,
 			    enum mlx5_alloc_type alloc_type,
 			    const char *component);
 int mlx5_free_actual_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
-void mlx5_get_alloc_type(const char *component,
+void mlx5_get_alloc_type(struct mlx5_context *context,
+			 const char *component,
 			 enum mlx5_alloc_type *alloc_type,
 			 enum mlx5_alloc_type default_alloc_type);
 int mlx5_use_huge(const char *key);
+bool mlx5_is_extern_alloc(struct mlx5_context *context);
+int mlx5_alloc_buf_extern(struct mlx5_context *ctx, struct mlx5_buf *buf,
+			  size_t size);
+void mlx5_free_buf_extern(struct mlx5_context *ctx, struct mlx5_buf *buf);
 
 __be32 *mlx5_alloc_dbrec(struct mlx5_context *context);
 void mlx5_free_db(struct mlx5_context *context, __be32 *db);
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 2219e62..967aa17 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -106,6 +106,10 @@ struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
 int mlx5dv_query_device(struct ibv_context *ctx_in,
 			struct mlx5dv_context *attrs_out);
 
+enum mlx5dv_qp_comp_mask {
+	MLX5DV_QP_MASK_UAR_MMAP_OFFSET		= 1 << 0,
+};
+
 struct mlx5dv_qp {
 	__be32			*dbrec;
 	struct {
@@ -123,6 +127,7 @@ struct mlx5dv_qp {
 		uint32_t	size;
 	} bf;
 	uint64_t		comp_mask;
+	off_t			uar_mmap_offset;
 };
 
 struct mlx5dv_cq {
@@ -619,4 +624,24 @@ void mlx5dv_set_eth_seg(struct mlx5_wqe_eth_seg *seg, uint8_t cs_flags,
 	seg->inline_hdr_sz	= htobe16(inline_hdr_sz);
 	memcpy(seg->inline_hdr_start, inline_hdr_start, inline_hdr_sz);
 }
+
+enum mlx5dv_set_ctx_attr_type {
+	MLX5DV_CTX_ATTR_BUF_ALLOCATORS = 1,
+};
+
+struct mlx5dv_ctx_allocators {
+	void *(*alloc)(size_t size, void *priv_data);
+	void (*free)(void *ptr, void *priv_data);
+	void *data;
+};
+
+/*
+ * Generic context attributes set API
+ *
+ * Returns 0 on success, or the value of errno on failure
+ * (which indicates the failure reason).
+ */
+int mlx5dv_set_context_attr(struct ibv_context *context,
+		enum mlx5dv_set_ctx_attr_type type, void *attr);
+
 #endif /* _MLX5DV_H_ */
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index c18adf9..fc63ae9 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1079,7 +1079,7 @@ static int mlx5_alloc_qp_buf(struct ibv_context *context,
 	if (mlx5_use_huge(qp_huge_key))
 		default_alloc_type = MLX5_ALLOC_TYPE_HUGE;
 
-	mlx5_get_alloc_type(MLX5_QP_PREFIX, &alloc_type,
+	mlx5_get_alloc_type(to_mctx(context), MLX5_QP_PREFIX, &alloc_type,
 			    default_alloc_type);
 
 	err = mlx5_alloc_prefered_buf(to_mctx(context), &qp->buf,
@@ -2004,7 +2004,10 @@ static int mlx5_alloc_rwq_buf(struct ibv_context *context,
 			      int size)
 {
 	int err;
-	enum mlx5_alloc_type default_alloc_type = MLX5_ALLOC_TYPE_PREFER_CONTIG;
+	enum mlx5_alloc_type alloc_type;
+
+	mlx5_get_alloc_type(to_mctx(context), MLX5_RWQ_PREFIX,
+			    &alloc_type, MLX5_ALLOC_TYPE_ANON);
 
 	rwq->rq.wrid = malloc(rwq->rq.wqe_cnt * sizeof(uint64_t));
 	if (!rwq->rq.wrid) {
@@ -2016,7 +2019,7 @@ static int mlx5_alloc_rwq_buf(struct ibv_context *context,
 				      align(rwq->buf_size, to_mdev
 				      (context->device)->page_size),
 				      to_mdev(context->device)->page_size,
-				      default_alloc_type,
+				      alloc_type,
 				      MLX5_RWQ_PREFIX);
 
 	if (err) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
