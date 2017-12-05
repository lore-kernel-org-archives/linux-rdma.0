From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 8/8] verbs: Get rid of verbs_set_ctx_op
Date: Tue,  5 Dec 2017 16:17:21 -0700
Message-ID: <20171205231721.19410-9-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

No longer necessary now that the providers are private to verbs.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h    |  5 -----
 providers/mlx4/mlx4.c | 34 +++++++++++++++++-----------------
 providers/mlx5/mlx5.c | 34 +++++++++++++++++-----------------
 3 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 34995d9c4437fa..58d8d8e3c31509 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1703,11 +1703,6 @@ static inline struct verbs_context *verbs_get_ctx(struct ibv_context *ctx)
 	(!__vctx || (__vctx->sz < sizeof(*__vctx) - offsetof(struct verbs_context, op)) || \
 	 !__vctx->op) ? NULL : __vctx; })
 
-#define verbs_set_ctx_op(_vctx, op, ptr) ({ \
-	struct verbs_context *vctx = _vctx; \
-	if (vctx && (vctx->sz >= sizeof(*vctx) - offsetof(struct verbs_context, op))) \
-		vctx->op = ptr; })
-
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 1ba2b427071fcb..d2ccd328625c80 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -238,23 +238,23 @@ static int mlx4_init_context(struct verbs_device *v_device,
 			mlx4_map_internal_clock(dev, ibv_ctx);
 	}
 
-	verbs_set_ctx_op(verbs_ctx, close_xrcd, mlx4_close_xrcd);
-	verbs_set_ctx_op(verbs_ctx, open_xrcd, mlx4_open_xrcd);
-	verbs_set_ctx_op(verbs_ctx, create_srq_ex, mlx4_create_srq_ex);
-	verbs_set_ctx_op(verbs_ctx, get_srq_num, verbs_get_srq_num);
-	verbs_set_ctx_op(verbs_ctx, create_qp_ex, mlx4_create_qp_ex);
-	verbs_set_ctx_op(verbs_ctx, open_qp, mlx4_open_qp);
-	verbs_set_ctx_op(verbs_ctx, ibv_create_flow, mlx4_create_flow);
-	verbs_set_ctx_op(verbs_ctx, ibv_destroy_flow, mlx4_destroy_flow);
-	verbs_set_ctx_op(verbs_ctx, create_cq_ex, mlx4_create_cq_ex);
-	verbs_set_ctx_op(verbs_ctx, query_device_ex, mlx4_query_device_ex);
-	verbs_set_ctx_op(verbs_ctx, query_rt_values, mlx4_query_rt_values);
-	verbs_set_ctx_op(verbs_ctx, create_wq, mlx4_create_wq);
-	verbs_set_ctx_op(verbs_ctx, modify_wq, mlx4_modify_wq);
-	verbs_set_ctx_op(verbs_ctx, destroy_wq, mlx4_destroy_wq);
-	verbs_set_ctx_op(verbs_ctx, create_rwq_ind_table, mlx4_create_rwq_ind_table);
-	verbs_set_ctx_op(verbs_ctx, destroy_rwq_ind_table, mlx4_destroy_rwq_ind_table);
-	verbs_set_ctx_op(verbs_ctx, modify_cq, mlx4_modify_cq);
+	verbs_ctx->close_xrcd = mlx4_close_xrcd;
+	verbs_ctx->open_xrcd = mlx4_open_xrcd;
+	verbs_ctx->create_srq_ex = mlx4_create_srq_ex;
+	verbs_ctx->get_srq_num = verbs_get_srq_num;
+	verbs_ctx->create_qp_ex = mlx4_create_qp_ex;
+	verbs_ctx->open_qp = mlx4_open_qp;
+	verbs_ctx->ibv_create_flow = mlx4_create_flow;
+	verbs_ctx->ibv_destroy_flow = mlx4_destroy_flow;
+	verbs_ctx->create_cq_ex = mlx4_create_cq_ex;
+	verbs_ctx->query_device_ex = mlx4_query_device_ex;
+	verbs_ctx->query_rt_values = mlx4_query_rt_values;
+	verbs_ctx->create_wq = mlx4_create_wq;
+	verbs_ctx->modify_wq = mlx4_modify_wq;
+	verbs_ctx->destroy_wq = mlx4_destroy_wq;
+	verbs_ctx->create_rwq_ind_table = mlx4_create_rwq_ind_table;
+	verbs_ctx->destroy_rwq_ind_table = mlx4_destroy_rwq_ind_table;
+	verbs_ctx->modify_cq = mlx4_modify_cq;
 
 	return 0;
 
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 70afbd46f57b05..f1379abac482e1 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -999,23 +999,23 @@ static int mlx5_init_context(struct verbs_device *vdev,
 
 	context->ibv_ctx.ops = mlx5_ctx_ops;
 
-	verbs_set_ctx_op(v_ctx, create_qp_ex, mlx5_create_qp_ex);
-	verbs_set_ctx_op(v_ctx, open_xrcd, mlx5_open_xrcd);
-	verbs_set_ctx_op(v_ctx, close_xrcd, mlx5_close_xrcd);
-	verbs_set_ctx_op(v_ctx, create_srq_ex, mlx5_create_srq_ex);
-	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
-	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
-	verbs_set_ctx_op(v_ctx, query_rt_values, mlx5_query_rt_values);
-	verbs_set_ctx_op(v_ctx, ibv_create_flow, mlx5_create_flow);
-	verbs_set_ctx_op(v_ctx, ibv_destroy_flow, mlx5_destroy_flow);
-	verbs_set_ctx_op(v_ctx, create_cq_ex, mlx5_create_cq_ex);
-	verbs_set_ctx_op(v_ctx, create_wq, mlx5_create_wq);
-	verbs_set_ctx_op(v_ctx, modify_wq, mlx5_modify_wq);
-	verbs_set_ctx_op(v_ctx, destroy_wq, mlx5_destroy_wq);
-	verbs_set_ctx_op(v_ctx, create_rwq_ind_table, mlx5_create_rwq_ind_table);
-	verbs_set_ctx_op(v_ctx, destroy_rwq_ind_table, mlx5_destroy_rwq_ind_table);
-	verbs_set_ctx_op(v_ctx, post_srq_ops, mlx5_post_srq_ops);
-	verbs_set_ctx_op(v_ctx, modify_cq, mlx5_modify_cq);
+	v_ctx->create_qp_ex = mlx5_create_qp_ex;
+	v_ctx->open_xrcd = mlx5_open_xrcd;
+	v_ctx->close_xrcd = mlx5_close_xrcd;
+	v_ctx->create_srq_ex = mlx5_create_srq_ex;
+	v_ctx->get_srq_num = mlx5_get_srq_num;
+	v_ctx->query_device_ex = mlx5_query_device_ex;
+	v_ctx->query_rt_values = mlx5_query_rt_values;
+	v_ctx->ibv_create_flow = mlx5_create_flow;
+	v_ctx->ibv_destroy_flow = mlx5_destroy_flow;
+	v_ctx->create_cq_ex = mlx5_create_cq_ex;
+	v_ctx->create_wq = mlx5_create_wq;
+	v_ctx->modify_wq = mlx5_modify_wq;
+	v_ctx->destroy_wq = mlx5_destroy_wq;
+	v_ctx->create_rwq_ind_table = mlx5_create_rwq_ind_table;
+	v_ctx->destroy_rwq_ind_table = mlx5_destroy_rwq_ind_table;
+	v_ctx->post_srq_ops = mlx5_post_srq_ops;
+	v_ctx->modify_cq = mlx5_modify_cq;
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
