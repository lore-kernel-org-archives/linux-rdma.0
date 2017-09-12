From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 6/6] mlx4: Support WQ object type in direct verb mlx4dv_init_obj
Date: Tue, 12 Sep 2017 15:53:08 +0300
Message-ID: <1505220788-23849-7-git-send-email-yishaih@mellanox.com>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Exposing relevant data-path attributes from the mlx4 object which
is used for WQ (i.e. from mlx4_qp) to let user working directly over
hardware specification.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/man/mlx4dv_init_obj.3 | 20 ++++++++++++++++++++
 providers/mlx4/mlx4.c                | 20 ++++++++++++++++++++
 providers/mlx4/mlx4dv.h              | 19 +++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/providers/mlx4/man/mlx4dv_init_obj.3 b/providers/mlx4/man/mlx4dv_init_obj.3
index c6d8d2b..d2a2bb0 100644
--- a/providers/mlx4/man/mlx4dv_init_obj.3
+++ b/providers/mlx4/man/mlx4dv_init_obj.3
@@ -83,6 +83,26 @@ uint64_t        comp_mask;
 .in -8
 };
 
+struct mlx4dv_rwq {
+.in +8
+__be32          *rdb;
+struct {
+.in +8
+uint32_t        wqe_cnt;
+int             wqe_shift;
+int             offset;
+.in -8
+} rq;
+struct {
+.in +8
+void            *buf;
+size_t          length;
+.in -8
+} buf;
+uint64_t        comp_mask;
+.in -8
+};
+
 struct mlx4dv_obj {
 .in +8
 struct {
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 5daea3b..3571234 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -419,6 +419,24 @@ static int mlx4dv_get_srq(struct ibv_srq *srq_in,
 	return 0;
 }
 
+static int mlx4dv_get_rwq(struct ibv_wq *wq_in, struct mlx4dv_rwq *wq_out)
+{
+	struct mlx4_qp *mqp = wq_to_mqp(wq_in);
+
+	wq_out->comp_mask = 0;
+
+	wq_out->buf.buf = mqp->buf.buf;
+	wq_out->buf.length = mqp->buf.length;
+
+	wq_out->rdb = mqp->db;
+
+	wq_out->rq.wqe_cnt = mqp->rq.wqe_cnt;
+	wq_out->rq.wqe_shift = mqp->rq.wqe_shift;
+	wq_out->rq.offset = mqp->rq.offset;
+
+	return 0;
+}
+
 int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type)
 {
 	int ret = 0;
@@ -429,6 +447,8 @@ int mlx4dv_init_obj(struct mlx4dv_obj *obj, uint64_t obj_type)
 		ret = mlx4dv_get_cq(obj->cq.in, obj->cq.out);
 	if (!ret && (obj_type & MLX4DV_OBJ_SRQ))
 		ret = mlx4dv_get_srq(obj->srq.in, obj->srq.out);
+	if (!ret && (obj_type & MLX4DV_OBJ_RWQ))
+		ret = mlx4dv_get_rwq(obj->rwq.in, obj->rwq.out);
 
 	return ret;
 }
diff --git a/providers/mlx4/mlx4dv.h b/providers/mlx4/mlx4dv.h
index 453de55..d47d3cd 100644
--- a/providers/mlx4/mlx4dv.h
+++ b/providers/mlx4/mlx4dv.h
@@ -197,6 +197,20 @@ struct mlx4dv_srq {
 	uint64_t			comp_mask;
 };
 
+struct mlx4dv_rwq {
+	__be32			*rdb;
+	struct {
+		uint32_t	wqe_cnt;
+		int		wqe_shift;
+		int		offset;
+	} rq;
+	struct {
+		void			*buf;
+		size_t			length;
+	} buf;
+	uint64_t		comp_mask;
+};
+
 struct mlx4dv_obj {
 	struct {
 		struct ibv_qp		*in;
@@ -210,12 +224,17 @@ struct mlx4dv_obj {
 		struct ibv_srq		*in;
 		struct mlx4dv_srq	*out;
 	} srq;
+	struct {
+		struct ibv_wq		*in;
+		struct mlx4dv_rwq	*out;
+	} rwq;
 };
 
 enum mlx4dv_obj_type {
 	MLX4DV_OBJ_QP	= 1 << 0,
 	MLX4DV_OBJ_CQ	= 1 << 1,
 	MLX4DV_OBJ_SRQ	= 1 << 2,
+	MLX4DV_OBJ_RWQ	= 1 << 3,
 };
 
 /*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
