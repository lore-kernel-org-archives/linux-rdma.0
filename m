From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libmlx5 2/2] libmlx5: Add CQ ignore overrun creation flag
Date: Sun, 20 Dec 2015 13:23:10 +0200
Message-ID: <1450610590-17361-3-git-send-email-leon@leon.nu>
References: <1450610590-17361-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450610590-17361-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to use CQ for cross-channel operations, the user
needs to configure CQ to ignore overrun creation flag.

This patch adds support of it to libmlx5 library.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h | 14 +++++++++++++
 src/verbs.c    | 62 +++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 769ea811d26b..85f6ee3f691e 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -91,6 +91,20 @@ struct mlx5_create_cq_resp {
 	__u32				cqn;
 };
 
+struct mlx5_create_cq_ex {
+	struct ibv_create_cq_ex		ibv_cmd;
+	__u64				buf_addr;
+	__u64				db_addr;
+	__u32				cqe_size;
+	__u32				comp_mask;
+};
+
+struct mlx5_create_cq_resp_ex {
+	struct ibv_create_cq_resp_ex	ibv_resp;
+	__u32				cqn;
+	__u32				comp_mask;
+};
+
 struct mlx5_create_srq {
 	struct ibv_create_srq		ibv_cmd;
 	__u64				buf_addr;
diff --git a/src/verbs.c b/src/verbs.c
index 1dbee60a6f9a..94a1197351a2 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -250,17 +250,31 @@ enum {
 };
 
 enum {
-	CREATE_CQ_SUPPORTED_FLAGS = IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP
+	CREATE_CQ_SUPPORTED_FLAGS = IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP |
+		IBV_CREATE_CQ_ATTR_IGNORE_OVERRUN
+};
+
+enum cmd_type {
+	LEGACY_CMD,
+	EXTENDED_CMD
 };
 
 static struct ibv_cq *create_cq(struct ibv_context *context,
-				const struct ibv_create_cq_attr_ex *cq_attr)
+				struct ibv_create_cq_attr_ex *cq_attr,
+				enum cmd_type ctype)
 {
 	struct mlx5_create_cq		cmd;
+	struct mlx5_create_cq_ex	cmd_ex;
 	struct mlx5_create_cq_resp	resp;
+	struct mlx5_create_cq_resp_ex	resp_ex;
 	struct mlx5_cq		       *cq;
 	int				cqe_sz;
-	int				ret;
+	/*
+	 * Initialize to non-zero value, because
+	 * ibv_cmd_* should set it to zero in case
+	 * of success execution.
+	 */
+	int				ret = -1;
 	int				ncqe;
 #ifdef MLX5_DEBUG
 	FILE *fp = to_mctx(context)->dbg_fp;
@@ -299,7 +313,6 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 		return NULL;
 	}
 
-	memset(&cmd, 0, sizeof cmd);
 	cq->cons_index = 0;
 
 	if (mlx5_spinlock_init(&cq->lock))
@@ -342,14 +355,30 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 	cq->arm_sn			= 0;
 	cq->cqe_sz			= cqe_sz;
 
-	cmd.buf_addr = (uintptr_t) cq->buf_a.buf;
-	cmd.db_addr  = (uintptr_t) cq->dbrec;
-	cmd.cqe_size = cqe_sz;
+	if (ctype == LEGACY_CMD) {
+		memset(&cmd, 0, sizeof(cmd));
+		cmd.buf_addr = (uintptr_t) cq->buf_a.buf;
+		cmd.db_addr  = (uintptr_t) cq->dbrec;
+		cmd.cqe_size = cqe_sz;
+
+		ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
+					cq_attr->comp_vector,
+					&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
+					&resp.ibv_resp, sizeof resp);
+	}
+	if (ctype == EXTENDED_CMD) {
+		memset(&cmd_ex, 0, sizeof(cmd_ex));
+		cmd_ex.buf_addr = (uintptr_t) cq->buf_a.buf;
+		cmd_ex.db_addr  = (uintptr_t) cq->dbrec;
+		cmd_ex.cqe_size = cqe_sz;
+
+		ret = ibv_cmd_create_cq_ex(context, cq_attr,
+					&cq->ibv_cq, &cmd_ex.ibv_cmd,
+					sizeof(cmd_ex.ibv_cmd), sizeof(cmd_ex),
+					&resp_ex.ibv_resp,
+					sizeof(resp_ex.ibv_resp), sizeof(resp_ex));
+	}
 
-	ret = ibv_cmd_create_cq(context, ncqe - 1, cq_attr->channel,
-				cq_attr->comp_vector,
-				&cq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
-				&resp.ibv_resp, sizeof resp);
 	if (ret) {
 		mlx5_dbg(fp, MLX5_DBG_CQ, "ret %d\n", ret);
 		goto err_db;
@@ -357,7 +386,12 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 
 	cq->active_buf = &cq->buf_a;
 	cq->resize_buf = NULL;
-	cq->cqn = resp.cqn;
+
+	if (ctype == LEGACY_CMD)
+		cq->cqn = resp.cqn;
+	if (ctype == EXTENDED_CMD)
+		cq->cqn = resp_ex.cqn;
+
 	cq->stall_enable = to_mctx(context)->stall_enable;
 	cq->stall_adaptive_enable = to_mctx(context)->stall_adaptive_enable;
 	cq->stall_cycles = to_mctx(context)->stall_cycles;
@@ -390,13 +424,13 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 						.comp_vector = comp_vector,
 						.wc_flags = IBV_WC_STANDARD_FLAGS};
 
-	return create_cq(context, &cq_attr);
+	return create_cq(context, &cq_attr, LEGACY_CMD);
 }
 
 struct ibv_cq *mlx5_create_cq_ex(struct ibv_context *context,
 				 struct ibv_create_cq_attr_ex *cq_attr)
 {
-	return create_cq(context, cq_attr);
+	return create_cq(context, cq_attr, EXTENDED_CMD);
 }
 
 int mlx5_resize_cq(struct ibv_cq *ibcq, int cqe)
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
