From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 rdma-core 5/6] mlx5: Expose direct create_cq with private data
Date: Thu, 23 Mar 2017 15:55:28 +0200
Message-ID: <1490277329-8738-6-git-send-email-yishaih@mellanox.com>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490277329-8738-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch exposes an API named mlx5dv_create_cq to enable creating a
CQ with some mlx5 private data.

Specifically, it enables creating a CQ in a mode that
few CQEs may be compressed into a single CQE.

To use the shared code of libibverbs when a CQ is created it uses the
verbs_init_cq() helper API that was introduced in previous patch.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/libmlx5.map |  5 +++++
 providers/mlx5/mlx5-abi.h  |  3 +++
 providers/mlx5/mlx5dv.h    | 13 +++++++++++++
 providers/mlx5/verbs.c     | 45 ++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index 7ce3eb1..ffd7b5c 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -6,3 +6,8 @@ MLX5_1.0 {
 		mlx5dv_init_obj;
 	local: *;
 };
+
+MLX5_1.14 {
+	global:
+		mlx5dv_create_cq;
+} MLX5_1.0;
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 487de3a..d05cb40 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -119,6 +119,9 @@ struct mlx5_create_cq {
 	__u64				buf_addr;
 	__u64				db_addr;
 	__u32				cqe_size;
+	__u8                            cqe_comp_en;
+	__u8                            cqe_comp_res_format;
+	__u16                           reserved;
 };
 
 struct mlx5_create_cq_resp {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index a2f7acf..a03b1d7 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -82,6 +82,19 @@ enum mlx5dv_context_flags {
 	MLX5DV_CONTEXT_FLAGS_MPW	= (1 << 1),
 };
 
+enum mlx5dv_cq_init_attr_mask {
+	MLX5DV_CQ_INIT_ATTR_MASK_COMPRESSED_CQE	= 1 << 0,
+	MLX5DV_CQ_INIT_ATTR_MASK_RESERVED	= 1 << 1,
+};
+
+struct mlx5dv_cq_init_attr {
+	uint64_t comp_mask; /* Use enum mlx5dv_cq_init_attr_mask */
+	uint8_t cqe_comp_res_format; /* Use enum mlx5dv_cqe_comp_res_format */
+};
+
+struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
+				   struct ibv_cq_init_attr_ex *cq_attr,
+				   struct mlx5dv_cq_init_attr *mlx5_cq_attr);
 /*
  * Most device capabilities are exported by ibv_query_device(...),
  * but there is HW device-specific information which is important
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index a223291..b7a8502 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -341,7 +341,8 @@ enum {
 
 static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 				   const struct ibv_cq_init_attr_ex *cq_attr,
-				   int cq_alloc_flags)
+				   int cq_alloc_flags,
+				   struct mlx5dv_cq_init_attr *mlx5cq_attr)
 {
 	struct mlx5_create_cq		cmd;
 	struct mlx5_create_cq_resp	resp;
@@ -349,6 +350,7 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	int				cqe_sz;
 	int				ret;
 	int				ncqe;
+	struct mlx5_context *mctx = to_mctx(context);
 	FILE *fp = to_mctx(context)->dbg_fp;
 
 	if (!cq_attr->cqe) {
@@ -428,6 +430,28 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	cmd.db_addr  = (uintptr_t) cq->dbrec;
 	cmd.cqe_size = cqe_sz;
 
+	if (mlx5cq_attr) {
+		if (mlx5cq_attr->comp_mask & ~(MLX5DV_CQ_INIT_ATTR_MASK_RESERVED - 1)) {
+			mlx5_dbg(fp, MLX5_DBG_CQ,
+				   "Unsupported vendor comp_mask for create_cq\n");
+			errno = EINVAL;
+			goto err_db;
+		}
+
+		if (mlx5cq_attr->comp_mask & MLX5DV_CQ_INIT_ATTR_MASK_COMPRESSED_CQE) {
+			if (mctx->cqe_comp_caps.max_num &&
+			    (mlx5cq_attr->cqe_comp_res_format &
+			     mctx->cqe_comp_caps.supported_format)) {
+				cmd.cqe_comp_en = 1;
+				cmd.cqe_comp_res_format = mlx5cq_attr->cqe_comp_res_format;
+			} else {
+				mlx5_dbg(fp, MLX5_DBG_CQ, "CQE Compression is not supported\n");
+				errno = EINVAL;
+				goto err_db;
+			}
+		}
+	}
+
 	ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
 				cq_attr->comp_vector,
 				ibv_cq_ex_to_cq(&cq->ibv_cq), &cmd.ibv_cmd,
@@ -478,14 +502,29 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 		return NULL;
 	}
 
-	cq = create_cq(context, &cq_attr, 0);
+	cq = create_cq(context, &cq_attr, 0, NULL);
 	return cq ? ibv_cq_ex_to_cq(cq) : NULL;
 }
 
 struct ibv_cq_ex *mlx5_create_cq_ex(struct ibv_context *context,
 				    struct ibv_cq_init_attr_ex *cq_attr)
 {
-	return create_cq(context, cq_attr, MLX5_CQ_FLAGS_EXTENDED);
+	return create_cq(context, cq_attr, MLX5_CQ_FLAGS_EXTENDED, NULL);
+}
+
+struct ibv_cq_ex *mlx5dv_create_cq(struct ibv_context *context,
+				      struct ibv_cq_init_attr_ex *cq_attr,
+				      struct mlx5dv_cq_init_attr *mlx5_cq_attr)
+{
+	struct ibv_cq_ex *cq;
+
+	cq = create_cq(context, cq_attr, MLX5_CQ_FLAGS_EXTENDED, mlx5_cq_attr);
+	if (!cq)
+		return NULL;
+
+	verbs_init_cq(ibv_cq_ex_to_cq(cq), context,
+		      cq_attr->channel, cq_attr->cq_context);
+	return cq;
 }
 
 int mlx5_resize_cq(struct ibv_cq *ibcq, int cqe)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
