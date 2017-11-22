From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/3] mlx5: Allow creation of a Multi-Packet RQ using direct verbs
Date: Wed, 22 Nov 2017 14:11:08 +0200
Message-ID: <1511352668-1441-4-git-send-email-yishaih@mellanox.com>
References: <1511352668-1441-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511352668-1441-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add needed definitions to allow creation of a Multi-Packet RQ using the
mlx5 direct verbs interface.

In order to create a Multi-Packet RQ, one needs to provide a
mlx5dv_wq_init_attr containing the following information in its
striding_rq_attrs struct:
- single_stride_log_num_of_bytes: log of size of each stride
- single_wqe_log_num_of_strides: log of number of strides per WQE
- two_byte_shift_en: When enabled, hardware pads 2 bytes of zeros
  before writing the message to memory (e.g. for IP alignment).

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/ibverbs-providers.symbols |  2 ++
 providers/mlx5/CMakeLists.txt    |  2 +-
 providers/mlx5/libmlx5.map       |  5 +++
 providers/mlx5/mlx5-abi.h        |  8 ++++-
 providers/mlx5/mlx5dv.h          | 46 +++++++++++++++++++++++++-
 providers/mlx5/verbs.c           | 71 ++++++++++++++++++++++++++++++++++++----
 6 files changed, 125 insertions(+), 9 deletions(-)

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index cb21dc5..08ff906 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -8,8 +8,10 @@ libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13
  MLX5_1.1@MLX5_1.1 14
  MLX5_1.2@MLX5_1.2 15
+ MLX5_1.3@MLX5_1.3 16
  mlx5dv_init_obj@MLX5_1.0 13
  mlx5dv_init_obj@MLX5_1.2 15
  mlx5dv_query_device@MLX5_1.0 13
  mlx5dv_create_cq@MLX5_1.1 14
  mlx5dv_set_context_attr@MLX5_1.2 15
+ mlx5dv_create_wq@MLX5_1.3 16
diff --git a/providers/mlx5/CMakeLists.txt b/providers/mlx5/CMakeLists.txt
index ab6a42d..88a406d 100644
--- a/providers/mlx5/CMakeLists.txt
+++ b/providers/mlx5/CMakeLists.txt
@@ -11,7 +11,7 @@ if (MLX5_MW_DEBUG)
 endif()
 
 rdma_shared_provider(mlx5 libmlx5.map
-  1 1.2.${PACKAGE_VERSION}
+  1 1.3.${PACKAGE_VERSION}
   buf.c
   cq.c
   dbrec.c
diff --git a/providers/mlx5/libmlx5.map b/providers/mlx5/libmlx5.map
index 09d886d..b1402dc 100644
--- a/providers/mlx5/libmlx5.map
+++ b/providers/mlx5/libmlx5.map
@@ -17,3 +17,8 @@ MLX5_1.2 {
 		mlx5dv_init_obj;
 		mlx5dv_set_context_attr;
 } MLX5_1.1;
+
+MLX5_1.3 {
+	global:
+		mlx5dv_create_wq;
+} MLX5_1.2;
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index b569bd4..e1aa618 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -210,6 +210,10 @@ struct mlx5_create_qp_resp {
 	__u32				uuar_index;
 };
 
+enum mlx5_create_wq_comp_mask {
+	MLX5_IB_CREATE_WQ_STRIDING_RQ =		1 << 0,
+};
+
 struct mlx5_drv_create_wq {
 	__u64		buf_addr;
 	__u64		db_addr;
@@ -218,7 +222,9 @@ struct mlx5_drv_create_wq {
 	__u32		user_index;
 	__u32		flags;
 	__u32		comp_mask;
-	__u32		reserved;
+	__u32		single_stride_log_num_of_bytes;
+	__u32		single_wqe_log_num_of_strides;
+	__u32		two_byte_shift_en;
 };
 
 struct mlx5_create_wq {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 3566bcb..9a30546 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -213,6 +213,43 @@ enum mlx5dv_obj_type {
 	MLX5DV_OBJ_RWQ	= 1 << 3,
 };
 
+enum mlx5dv_wq_init_attr_mask {
+	MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ	= 1 << 0,
+};
+
+struct mlx5dv_striding_rq_init_attr {
+	uint32_t	single_stride_log_num_of_bytes;
+	uint32_t	single_wqe_log_num_of_strides;
+	uint8_t		two_byte_shift_en;
+};
+
+struct mlx5dv_wq_init_attr {
+	uint64_t				comp_mask; /* Use enum mlx5dv_wq_init_attr_mask */
+	struct mlx5dv_striding_rq_init_attr	striding_rq_attrs;
+};
+
+/*
+ * This function creates a work queue object with extra properties
+ * defined by mlx5dv_wq_init_attr struct.
+ *
+ * For each bit in the comp_mask, a field in mlx5dv_wq_init_attr
+ * should follow.
+ *
+ * MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ: Create a work queue with
+ * striding RQ capabilities.
+ * - single_stride_log_num_of_bytes represents the size of each stride in the
+ *   WQE and its value should be between min_single_stride_log_num_of_bytes
+ *   and max_single_stride_log_num_of_bytes that are reported in
+ *   mlx5dv_query_device.
+ * - single_wqe_log_num_of_strides represents the number of strides in each WQE.
+ *   Its value should be between min_single_wqe_log_num_of_strides and
+ *   max_single_wqe_log_num_of_strides that are reported in mlx5dv_query_device.
+ * - two_byte_shift_en: When enabled, hardware pads 2 bytes of zeroes
+ *   before writing the message to memory (e.g. for IP alignment)
+ */
+struct ibv_wq *mlx5dv_create_wq(struct ibv_context *context,
+				struct ibv_wq_init_attr *wq_init_attr,
+				struct mlx5dv_wq_init_attr *mlx5_wq_attr);
 /*
  * This function will initialize mlx5dv_xxx structs based on supplied type.
  * The information for initialization is taken from ibv_xx structs supplied
@@ -328,7 +365,9 @@ struct mlx5_tm_cqe {
 struct mlx5_cqe64 {
 	union {
 		struct {
-			uint8_t		rsvd0[17];
+			uint8_t		rsvd0[2];
+			__be16		wqe_id;
+			uint8_t		rsvd4[13];
 			uint8_t		ml_path;
 			uint8_t		rsvd20[4];
 			__be16		slid;
@@ -455,6 +494,11 @@ struct mlx5_wqe_ctrl_seg {
 	__be32		imm;
 };
 
+struct mlx5_mprq_wqe {
+	struct mlx5_wqe_srq_next_seg	nseg;
+	struct mlx5_wqe_data_seg	dseg;
+};
+
 struct mlx5_wqe_av {
 	union {
 		struct {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index dc12cd8..d8ec300 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -952,21 +952,36 @@ static int mlx5_calc_sq_size(struct mlx5_context *ctx,
 	return wq_size;
 }
 
+enum {
+	DV_CREATE_WQ_SUPPORTED_COMP_MASK = MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ
+};
+
 static int mlx5_calc_rwq_size(struct mlx5_context *ctx,
 			      struct mlx5_rwq *rwq,
-			      struct ibv_wq_init_attr *attr)
+			      struct ibv_wq_init_attr *attr,
+			      struct mlx5dv_wq_init_attr *mlx5wq_attr)
 {
 	size_t wqe_size;
 	int wq_size;
 	uint32_t num_scatter;
+	int is_mprq = 0;
 	int scat_spc;
 
 	if (!attr->max_wr)
 		return -EINVAL;
+	if (mlx5wq_attr) {
+		if (!check_comp_mask(mlx5wq_attr->comp_mask,
+				     DV_CREATE_WQ_SUPPORTED_COMP_MASK))
+			return -EINVAL;
+
+		is_mprq = !!(mlx5wq_attr->comp_mask &
+			     MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ);
+	}
 
 	/* TBD: check caps for RQ */
 	num_scatter = max_t(uint32_t, attr->max_sge, 1);
-	wqe_size = sizeof(struct mlx5_wqe_data_seg) * num_scatter;
+	wqe_size = sizeof(struct mlx5_wqe_data_seg) * num_scatter +
+		sizeof(struct mlx5_wqe_srq_next_seg) * is_mprq;
 
 	if (rwq->wq_sig)
 		wqe_size += sizeof(struct mlx5_rwqe_sig);
@@ -981,7 +996,8 @@ static int mlx5_calc_rwq_size(struct mlx5_context *ctx,
 	rwq->rq.wqe_shift = mlx5_ilog2(wqe_size);
 	rwq->rq.max_post = 1 << mlx5_ilog2(wq_size / wqe_size);
 	scat_spc = wqe_size -
-		((rwq->wq_sig) ? sizeof(struct mlx5_rwqe_sig) : 0);
+		((rwq->wq_sig) ? sizeof(struct mlx5_rwqe_sig) : 0) -
+		is_mprq * sizeof(struct mlx5_wqe_srq_next_seg);
 	rwq->rq.max_gs = scat_spc / sizeof(struct mlx5_wqe_data_seg);
 	return wq_size;
 }
@@ -2226,8 +2242,9 @@ static int mlx5_alloc_rwq_buf(struct ibv_context *context,
 	return 0;
 }
 
-struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
-			      struct ibv_wq_init_attr *attr)
+static struct ibv_wq *create_wq(struct ibv_context *context,
+			 struct ibv_wq_init_attr *attr,
+			 struct mlx5dv_wq_init_attr *mlx5wq_attr)
 {
 	struct mlx5_create_wq		cmd;
 	struct mlx5_create_wq_resp		resp;
@@ -2252,7 +2269,7 @@ struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
 	if (rwq->wq_sig)
 		cmd.drv.flags = MLX5_RWQ_FLAG_SIGNATURE;
 
-	ret = mlx5_calc_rwq_size(ctx, rwq, attr);
+	ret = mlx5_calc_rwq_size(ctx, rwq, attr, mlx5wq_attr);
 	if (ret < 0) {
 		errno = -ret;
 		goto err;
@@ -2286,6 +2303,35 @@ struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
 	}
 
 	cmd.drv.user_index = usr_idx;
+
+	if (mlx5wq_attr) {
+		if (mlx5wq_attr->comp_mask & MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ) {
+			if ((mlx5wq_attr->striding_rq_attrs.single_stride_log_num_of_bytes <
+			    ctx->striding_rq_caps.min_single_stride_log_num_of_bytes) ||
+			    (mlx5wq_attr->striding_rq_attrs.single_stride_log_num_of_bytes >
+			     ctx->striding_rq_caps.max_single_stride_log_num_of_bytes)) {
+				errno = EINVAL;
+				goto err_create;
+			}
+
+			if ((mlx5wq_attr->striding_rq_attrs.single_wqe_log_num_of_strides <
+			     ctx->striding_rq_caps.min_single_wqe_log_num_of_strides) ||
+			    (mlx5wq_attr->striding_rq_attrs.single_wqe_log_num_of_strides >
+			     ctx->striding_rq_caps.max_single_wqe_log_num_of_strides)) {
+				errno = EINVAL;
+				goto err_create;
+			}
+
+			cmd.drv.single_stride_log_num_of_bytes =
+				mlx5wq_attr->striding_rq_attrs.single_stride_log_num_of_bytes;
+			cmd.drv.single_wqe_log_num_of_strides =
+				mlx5wq_attr->striding_rq_attrs.single_wqe_log_num_of_strides;
+			cmd.drv.two_byte_shift_en =
+				mlx5wq_attr->striding_rq_attrs.two_byte_shift_en;
+			cmd.drv.comp_mask |= MLX5_IB_CREATE_WQ_STRIDING_RQ;
+		}
+	}
+
 	err = ibv_cmd_create_wq(context, attr, &rwq->wq, &cmd.ibv_cmd,
 				sizeof(cmd.ibv_cmd),
 				sizeof(cmd),
@@ -2311,6 +2357,19 @@ err:
 	return NULL;
 }
 
+struct ibv_wq *mlx5_create_wq(struct ibv_context *context,
+			      struct ibv_wq_init_attr *attr)
+{
+	return create_wq(context, attr, NULL);
+}
+
+struct ibv_wq *mlx5dv_create_wq(struct ibv_context *context,
+				struct ibv_wq_init_attr *attr,
+				struct mlx5dv_wq_init_attr *mlx5_wq_attr)
+{
+	return create_wq(context, attr, mlx5_wq_attr);
+}
+
 int mlx5_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr)
 {
 	struct mlx5_modify_wq	cmd = {};
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
