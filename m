From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/6] mlx4: Introduce the direct verb mlx4dv_set_ctx_attr
Date: Tue, 12 Sep 2017 15:53:04 +0300
Message-ID: <1505220788-23849-3-git-send-email-yishaih@mellanox.com>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

mlx4dv_set_ctx_attr lets the user application to set for a mlx4
context varied attributes which are exposed in mlx4dv.h.

First attribute type which is introduced here is used to set the
WQs range size.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/ibverbs-providers.symbols |  1 +
 providers/mlx4/libmlx4.map       |  1 +
 providers/mlx4/mlx4.c            | 17 +++++++++++++++++
 providers/mlx4/mlx4dv.h          | 13 ++++++++++++-
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/debian/ibverbs-providers.symbols b/debian/ibverbs-providers.symbols
index 34d1315..cb21dc5 100644
--- a/debian/ibverbs-providers.symbols
+++ b/debian/ibverbs-providers.symbols
@@ -3,6 +3,7 @@ libmlx4.so.1 ibverbs-providers #MINVER#
  mlx4dv_init_obj@MLX4_1.0 15
  mlx4dv_query_device@MLX4_1.0 15
  mlx4dv_create_qp@MLX4_1.0 15
+ mlx4dv_set_context_attr@MLX4_1.0 15
 libmlx5.so.1 ibverbs-providers #MINVER#
  MLX5_1.0@MLX5_1.0 13
  MLX5_1.1@MLX5_1.1 14
diff --git a/providers/mlx4/libmlx4.map b/providers/mlx4/libmlx4.map
index 6de4348..ac2c772 100644
--- a/providers/mlx4/libmlx4.map
+++ b/providers/mlx4/libmlx4.map
@@ -5,5 +5,6 @@ MLX4_1.0 {
 		mlx4dv_init_obj;
 		mlx4dv_query_device;
 		mlx4dv_create_qp;
+		mlx4dv_set_context_attr;
 	local: *;
 };
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 600daea..6158924 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -443,3 +443,20 @@ int mlx4dv_query_device(struct ibv_context *ctx_in,
 
 	return 0;
 }
+
+int mlx4dv_set_context_attr(struct ibv_context *context,
+			    enum mlx4dv_set_ctx_attr_type attr_type,
+			    void *attr)
+{
+	struct mlx4_context *ctx = to_mctx(context);
+
+	switch (attr_type) {
+	case MLX4DV_SET_CTX_ATTR_LOG_WQS_RANGE_SZ:
+		ctx->log_wqs_range_sz = *((uint8_t *)attr);
+		break;
+	default:
+		return ENOTSUP;
+	}
+
+	return 0;
+}
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 5a47e65..453de55 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -498,5 +498,16 @@ void mlx4dv_set_data_seg(struct mlx4_wqe_data_seg *seg,
 int mlx4dv_query_device(struct ibv_context *ctx_in,
 			struct mlx4dv_context *attrs_out);
 
-#endif /* _MLX4DV_H_ */
+enum mlx4dv_set_ctx_attr_type {
+	/* Attribute type uint8_t */
+	MLX4DV_SET_CTX_ATTR_LOG_WQS_RANGE_SZ	= 0,
+};
 
+/*
+ * Returns 0 on success, or the value of errno on failure
+ * (which indicates the failure reason).
+ */
+int mlx4dv_set_context_attr(struct ibv_context *context,
+			    enum mlx4dv_set_ctx_attr_type attr_type,
+			    void *attr);
+#endif /* _MLX4DV_H_ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
