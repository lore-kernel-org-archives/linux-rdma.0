From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 3/8] Limit qp resources accepted for ibv_create_qp()
Date: Thu, 20 Sep 2012 23:31:02 +0300
Message-ID: <1348173067-12116-4-git-send-email-ogerlitz@mellanox.com>
References: <1348173067-12116-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173067-12116-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Use the limits reported in ib_query_device(). Make sure that the limits
returned to the caller following qp creation also lie within the
reported device limits.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx4.h  |   14 ++++++++++++++
 src/qp.c    |    6 ++++--
 src/verbs.c |   18 +++++++++++++-----
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/src/mlx4.h b/src/mlx4.h
index efaa7e9..e1daaf7 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -83,6 +83,20 @@
 
 #define PFX		"mlx4: "
 
+#ifndef max
+#define max(a, b) \
+	({ typeof(a) _a = (a); \
+	   typeof(b) _b = (b); \
+	   _a > _b ? _a : _b; })
+#endif
+
+#ifndef min
+#define min(a, b) \
+	({ typeof(a) _a = (a); \
+	   typeof(b) _b = (b); \
+	   _a < _b ? _a : _b; })
+#endif
+
 enum {
 	MLX4_CQ_ENTRY_SIZE		= 0x20
 };
diff --git a/src/qp.c b/src/qp.c
index 90c4e80..0dfe3a7 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -628,6 +628,7 @@ void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
 		       enum ibv_qp_type type)
 {
 	int wqe_size;
+	struct mlx4_context *ctx = to_mctx(qp->ibv_qp.context);
 
 	wqe_size = (1 << qp->sq.wqe_shift) - sizeof (struct mlx4_wqe_ctrl_seg);
 	switch (type) {
@@ -645,8 +646,9 @@ void mlx4_set_sq_sizes(struct mlx4_qp *qp, struct ibv_qp_cap *cap,
 	}
 
 	qp->sq.max_gs	     = wqe_size / sizeof (struct mlx4_wqe_data_seg);
-	cap->max_send_sge    = qp->sq.max_gs;
-	qp->sq.max_post	     = qp->sq.wqe_cnt - qp->sq_spare_wqes;
+	cap->max_send_sge    = min(ctx->max_sge, qp->sq.max_gs);
+	qp->sq.max_post	     = min(ctx->max_qp_wr,
+				   qp->sq.wqe_cnt - qp->sq_spare_wqes);
 	cap->max_send_wr     = qp->sq.max_post;
 
 	/*
diff --git a/src/verbs.c b/src/verbs.c
index 408fc6d..f629275 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -390,12 +390,14 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	struct ibv_create_qp_resp resp;
 	struct mlx4_qp		 *qp;
 	int			  ret;
+	struct mlx4_context	 *context = to_mctx(pd->context);
+
 
 	/* Sanity check QP size before proceeding */
-	if (attr->cap.max_send_wr     > 65536 ||
-	    attr->cap.max_recv_wr     > 65536 ||
-	    attr->cap.max_send_sge    > 64    ||
-	    attr->cap.max_recv_sge    > 64    ||
+	if (attr->cap.max_send_wr     > context->max_qp_wr ||
+	    attr->cap.max_recv_wr     > context->max_qp_wr ||
+	    attr->cap.max_send_sge    > context->max_sge   ||
+	    attr->cap.max_recv_sge    > context->max_sge   ||
 	    attr->cap.max_inline_data > 1024)
 		return NULL;
 
@@ -464,8 +466,14 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 		goto err_destroy;
 	pthread_mutex_unlock(&to_mctx(pd->context)->qp_table_mutex);
 
-	qp->rq.wqe_cnt = qp->rq.max_post = attr->cap.max_recv_wr;
+	qp->rq.wqe_cnt = attr->cap.max_recv_wr;
 	qp->rq.max_gs  = attr->cap.max_recv_sge;
+
+	/* adjust rq maxima to not exceed reported device maxima */
+	attr->cap.max_recv_wr = min(context->max_qp_wr, attr->cap.max_recv_wr);
+	attr->cap.max_recv_sge = min(context->max_sge, attr->cap.max_recv_sge);
+
+	qp->rq.max_post = attr->cap.max_recv_wr;
 	mlx4_set_sq_sizes(qp, &attr->cap, attr->qp_type);
 
 	qp->doorbell_qpn    = htonl(qp->ibv_qp.qp_num << 8);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
