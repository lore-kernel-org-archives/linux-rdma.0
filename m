From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] mlx4: Add inline-receive support
Date: Sun, 10 Sep 2017 12:45:49 +0300
Message-ID: <1505036749-12297-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When inline-receive is enabled, the HCA may write received
data into the receive WQE.

Each single-packet message with payload not exceeding the receive
WQE size will be delivered to the work queue. The completion report
will indicate that the payload was placed to the WQE.

It includes:
1) Add direct verb query device function.
2) Add direct verb create QP function, inline-receive size will be
passed in the vendor data part.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/216

 debian/ibverbs-providers.symbols         |  2 ++
 providers/mlx4/libmlx4.map               |  2 ++
 providers/mlx4/man/CMakeLists.txt        |  1 +
 providers/mlx4/man/mlx4dv_query_device.3 | 42 ++++++++++++++++++++++++++++++++
 providers/mlx4/mlx4-abi.h                |  5 +++-
 providers/mlx4/mlx4.c                    | 13 ++++++++++
 providers/mlx4/mlx4.h                    |  4 ++-
 providers/mlx4/mlx4dv.h                  | 33 +++++++++++++++++++++++++
 providers/mlx4/qp.c                      | 14 +++++++++--
 providers/mlx4/verbs.c                   | 37 +++++++++++++++++++++++-----
 10 files changed, 143 insertions(+), 10 deletions(-)
 create mode 100644 providers/mlx4/man/mlx4dv_query_device.3

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index b03c33a..69722ec 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -1,6 +1,8 @@
 libmlx4.so.1 ibverbs-providers #MINVER#
  MLX4_1.0@MLX4_1.0 15
  mlx4dv_init_obj@MLX4_1.0 15
+ mlx4dv_query_device@MLX4_1.0 15
+ mlx4dv_create_qp@MLX4_1.0 15
 libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13
  MLX5_1.1@MLX5_1.1 14
diff --git a/providers/mlx4/libmlx4.map b/providers/mlx4/libmlx4.map
index 0e53f83..6de4348 100644
--- a/providers/mlx4/libmlx4.map
+++ b/providers/mlx4/libmlx4.map
@@ -3,5 +3,7 @@
 MLX4_1.0 {
 	global:
 		mlx4dv_init_obj;
+		mlx4dv_query_device;
+		mlx4dv_create_qp;
 	local: *;
 };
diff --git a/providers/mlx4/man/CMakeLists.txt b/providers/mlx4/man/CMakeLists.txt
index c44c7c3..99a7510 100644
--- a/providers/mlx4/man/CMakeLists.txt
+++ b/providers/mlx4/man/CMakeLists.txt
@@ -1,4 +1,5 @@
 rdma_man_pages(
   mlx4dv_init_obj.3
+  mlx4dv_query_device.3
   mlx4dv.7
 )
diff --git a/providers/mlx4/man/mlx4dv_query_device.3 b/providers/mlx4/man/mlx4dv_query_device.3
new file mode 100644
index 0000000..53cf416
--- /dev/null
+++ b/providers/mlx4/man/mlx4dv_query_device.3
@@ -0,0 +1,42 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX4DV_QUERY_DEVICE 3 2017-06-27 1.0.0
+.SH "NAME"
+mlx4dv_query_device \- Query device capabilities specific to mlx4
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/mlx4dv.h>
+.sp
+.BI "int mlx4dv_query_device(struct ibv_context *ctx_in,
+.BI "                        struct mlx4dv_context *attrs_out);
+.fi
+.SH "DESCRIPTION"
+.B mlx4dv_query_device()
+Query HW device-specific information which is important for data-path, but isn't provided by
+\fBibv_query_device\fR(3).
+.PP
+This function returns version and compatibility mask. The version represents the format
+of the internal hardware structures that mlx4dv.h represents. Additions of new fields to the existed
+structures are handled by comp_mask field.
+.PP
+.nf
+struct mlx4dv_context {
+.in +8
+uint8_t         version;
+uint32_t        max_inl_recv_sz; /* Maximum supported size of inline receive  */
+uint64_t        comp_mask;
+.in -8
+};
+
+.fi
+.SH "RETURN VALUE"
+0 on success or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+ * Compatibility mask (comp_mask) is in/out field.
+.SH "SEE ALSO"
+.BR mlx4dv (7),
+.BR ibv_query_device (3)
+.SH "AUTHORS"
+.TP
+Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index 7d89505..ded1a4c 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -104,6 +104,8 @@ struct mlx4_query_device_ex_resp {
 	__u32				comp_mask;
 	__u32				response_length;
 	__u64				hca_core_clock_offset;
+	__u32				max_inl_recv_sz;
+	__u32				reserved;
 };
 
 struct mlx4_query_device_ex {
@@ -135,7 +137,8 @@ struct mlx4_create_qp {
 	__u8				log_sq_bb_count;
 	__u8				log_sq_stride;
 	__u8				sq_no_prefetch;	/* was reserved in ABI 2 */
-	__u8				reserved[5];
+	__u8				reserved;
+	__u32				inl_recv_sz;
 };
 
 struct mlx4_create_qp_drv_ex {
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index eecb9c7..bd4cd5e 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -427,3 +427,16 @@ int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type)
 
 	return ret;
 }
+
+int mlx4dv_query_device(struct ibv_context *ctx_in,
+			struct mlx4dv_context *attrs_out)
+{
+	struct mlx4_context *mctx = to_mctx(ctx_in);
+
+	attrs_out->version   = 0;
+	attrs_out->comp_mask = 0;
+
+	attrs_out->max_inl_recv_sz = mctx->max_inl_recv_sz;
+
+	return 0;
+}
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 87a24cc..7d463f3 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -133,6 +133,7 @@ struct mlx4_context {
 		uint8_t                 offset_valid;
 	} core_clock;
 	void			       *hca_core_clock;
+	uint32_t			max_inl_recv_sz;
 };
 
 struct mlx4_buf {
@@ -385,7 +386,8 @@ int mlx4_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 			   struct mlx4_qp *qp);
 int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
-		       enum ibv_qp_type type, struct mlx4_qp *qp);
+		       enum ibv_qp_type type, struct mlx4_qp *qp,
+		       struct mlx4dv_qp_init_attr *mlx4qp_attr);
 void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
 		       enum ibv_qp_type type);
 struct mlx4_qp *mlx4_find_qp(struct mlx4_context *ctx, uint32_t qpn);
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 3f50d34..5a47e65 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -379,6 +379,29 @@ struct mlx4_wqe_atomic_seg {
 	__be64			compare;
 };
 
+enum mlx4dv_qp_init_attr_mask {
+	MLX4DV_QP_INIT_ATTR_MASK_INL_RECV	= 1 << 0,
+	MLX4DV_QP_INIT_ATTR_MASK_RESERVED	= 1 << 1,
+};
+
+struct mlx4dv_qp_init_attr {
+	uint64_t comp_mask; /* Use enum mlx4dv_qp_init_attr_mask */
+	uint32_t inl_recv_sz;
+};
+
+struct ibv_qp *mlx4dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *attr,
+				struct mlx4dv_qp_init_attr *mlx4_qp_attr);
+
+/*
+ * Direct verbs device-specific attributes
+ */
+struct mlx4dv_context {
+	uint8_t		version;
+	uint32_t	max_inl_recv_sz;
+	uint64_t	comp_mask;
+};
+
 /*
  * Control segment - contains some control information for the current WQE.
  *
@@ -465,5 +488,15 @@ void mlx4dv_set_data_seg(struct mlx4_wqe_data_seg *seg,
 	seg->lkey       = htobe32(lkey);
 	seg->addr       = htobe64(address);
 }
+
+/* Most device capabilities are exported by ibv_query_device(...),
+ * but there is HW device-specific information which is important
+ * for data-path, but isn't provided.
+ *
+ * Return 0 on success.
+ */
+int mlx4dv_query_device(struct ibv_context *ctx_in,
+			struct mlx4dv_context *attrs_out);
+
 #endif /* _MLX4DV_H_ */
 
diff --git a/providers/mlx4/qp.c b/providers/mlx4/qp.c
index 6d5986e..63f66d7 100644
--- a/providers/mlx4/qp.c
+++ b/providers/mlx4/qp.c
@@ -651,9 +651,17 @@ void mlx4_calc_sq_wqe_size(struct ibv_qp_cap *cap, enum ibv_qp_type type,
 }
 
 int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
-		       enum ibv_qp_type type, struct mlx4_qp *qp)
+		      enum ibv_qp_type type, struct mlx4_qp *qp,
+		      struct mlx4dv_qp_init_attr *mlx4qp_attr)
 {
+	int wqe_size;
+
 	qp->rq.max_gs	 = cap->max_recv_sge;
+	wqe_size = qp->rq.max_gs * sizeof(struct mlx4_wqe_data_seg);
+	if (mlx4qp_attr &&
+	    mlx4qp_attr->comp_mask & MLX4DV_QP_INIT_ATTR_MASK_INL_RECV &&
+	    mlx4qp_attr->inl_recv_sz > wqe_size)
+		wqe_size = mlx4qp_attr->inl_recv_sz;
 
 	if (qp->sq.wqe_cnt) {
 		qp->sq.wrid = malloc(qp->sq.wqe_cnt * sizeof (uint64_t));
@@ -670,9 +678,11 @@ int mlx4_alloc_qp_buf(struct ibv_context *context, struct ibv_qp_cap *cap,
 	}
 
 	for (qp->rq.wqe_shift = 4;
-	     1 << qp->rq.wqe_shift < qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg);
+	     1 << qp->rq.wqe_shift < wqe_size;
 	     qp->rq.wqe_shift++)
 		; /* nothing */
+	if (mlx4qp_attr)
+		mlx4qp_attr->inl_recv_sz = 1 << qp->rq.wqe_shift;
 
 	qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
 		(qp->sq.wqe_cnt << qp->sq.wqe_shift);
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 6a240c5..abb447d 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -91,6 +91,7 @@ int mlx4_query_device_ex(struct ibv_context *context,
 		mctx->core_clock.offset = resp.hca_core_clock_offset;
 		mctx->core_clock.offset_valid = 1;
 	}
+	mctx->max_inl_recv_sz = resp.max_inl_recv_sz;
 
 	major     = (raw_fw_ver >> 32) & 0xffff;
 	minor     = (raw_fw_ver >> 16) & 0xffff;
@@ -781,12 +782,13 @@ enum {
 	MLX4_CREATE_QP_EX2_COMP_MASK = (IBV_QP_INIT_ATTR_CREATE_FLAGS),
 };
 
-struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
-				 struct ibv_qp_init_attr_ex *attr)
+static struct ibv_qp *create_qp_ex(struct ibv_context *context,
+				   struct ibv_qp_init_attr_ex *attr,
+				   struct mlx4dv_qp_init_attr *mlx4qp_attr)
 {
 	struct mlx4_context *ctx = to_mctx(context);
-	struct mlx4_create_qp     cmd;
-	struct ibv_create_qp_resp resp;
+	struct mlx4_create_qp     cmd = {};
+	struct ibv_create_qp_resp resp = {};
 	struct mlx4_qp		 *qp;
 	int			  ret;
 
@@ -837,7 +839,8 @@ struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
 			attr->cap.max_recv_wr = 1;
 	}
 
-	if (mlx4_alloc_qp_buf(context, &attr->cap, attr->qp_type, qp))
+	if (mlx4_alloc_qp_buf(context, &attr->cap, attr->qp_type, qp,
+			      mlx4qp_attr))
 		goto err;
 
 	mlx4_init_qp_indices(qp);
@@ -846,6 +849,15 @@ struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
 	    pthread_spin_init(&qp->rq.lock, PTHREAD_PROCESS_PRIVATE))
 		goto err_free;
 
+	if (mlx4qp_attr) {
+		if (mlx4qp_attr->comp_mask &
+		    ~(MLX4DV_QP_INIT_ATTR_MASK_RESERVED - 1)) {
+			errno = EINVAL;
+			goto err_free;
+		}
+		if (mlx4qp_attr->comp_mask & MLX4DV_QP_INIT_ATTR_MASK_INL_RECV)
+			cmd.inl_recv_sz = mlx4qp_attr->inl_recv_sz;
+	}
 	if (attr->cap.max_recv_sge) {
 		qp->db = mlx4_alloc_db(to_mctx(context), MLX4_DB_TYPE_RQ);
 		if (!qp->db)
@@ -864,9 +876,9 @@ struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
 	     ++cmd.log_sq_bb_count)
 		; /* nothing */
 	cmd.sq_no_prefetch = 0;	/* OK for ABI 2: just a reserved field */
-	memset(cmd.reserved, 0, sizeof cmd.reserved);
 	pthread_mutex_lock(&to_mctx(context)->qp_table_mutex);
 
+
 	if (attr->comp_mask & MLX4_CREATE_QP_EX2_COMP_MASK)
 		ret = mlx4_cmd_create_qp_ex(context, attr, &cmd, qp);
 	else
@@ -917,6 +929,19 @@ err:
 	return NULL;
 }
 
+struct ibv_qp *mlx4_create_qp_ex(struct ibv_context *context,
+				 struct ibv_qp_init_attr_ex *attr)
+{
+	return create_qp_ex(context, attr, NULL);
+}
+
+struct ibv_qp *mlx4dv_create_qp(struct ibv_context *context,
+				struct ibv_qp_init_attr_ex *attr,
+				struct mlx4dv_qp_init_attr *mlx4_qp_attr)
+{
+	return create_qp_ex(context, attr, mlx4_qp_attr);
+}
+
 struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 {
 	struct ibv_qp_init_attr_ex attr_ex;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
