From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 v2 1/7] Add infrastructure for resource identification
Date: Tue,  2 Feb 2016 21:29:45 +0200
Message-ID: <1454441391-30494-2-git-send-email-majd@mellanox.com>
References: <1454441391-30494-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454441391-30494-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add new struct member, mlx5_resource, for each tracked object,
mlx5_srq and mlx5_qp, to allow retrieving the object in the
poll_cq once we need it.

Reviewed-by:: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/src/mlx5.h b/src/mlx5.h
index 9181ec5..a930bac 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -228,6 +228,18 @@ enum mlx5_alloc_type {
 	MLX5_ALLOC_TYPE_ALL
 };
 
+enum mlx5_rsc_type {
+	MLX5_RSC_TYPE_QP,
+	MLX5_RSC_TYPE_XSRQ,
+	MLX5_RSC_TYPE_SRQ,
+	MLX5_RSC_TYPE_INVAL,
+};
+
+struct mlx5_resource {
+	enum mlx5_rsc_type	type;
+	uint32_t		rsn;
+};
+
 struct mlx5_device {
 	struct verbs_device	verbs_dev;
 	int			page_size;
@@ -341,6 +353,7 @@ struct mlx5_cq {
 };
 
 struct mlx5_srq {
+	struct mlx5_resource            rsc;  /* This struct must be first */
 	struct verbs_srq		vsrq;
 	struct mlx5_buf			buf;
 	struct mlx5_spinlock		lock;
@@ -392,6 +405,7 @@ struct mlx5_mr {
 };
 
 struct mlx5_qp {
+	struct mlx5_resource            rsc; /* This struct must be first */
 	struct verbs_qp			verbs_qp;
 	struct ibv_qp		       *ibv_qp;
 	struct mlx5_buf                 buf;
@@ -491,7 +505,9 @@ static inline struct mlx5_cq *to_mcq(struct ibv_cq *ibcq)
 
 static inline struct mlx5_srq *to_msrq(struct ibv_srq *ibsrq)
 {
-	return (struct mlx5_srq *)ibsrq;
+	struct verbs_srq *vsrq = (struct verbs_srq *)ibsrq;
+
+	return container_of(vsrq, struct mlx5_srq, vsrq);
 }
 
 static inline struct mlx5_qp *to_mqp(struct ibv_qp *ibqp)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
