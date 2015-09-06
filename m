From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 1/5] Add infrastructure for resource tracking
Date: Sun,  6 Sep 2015 12:30:08 +0300
Message-ID: <1441531812-27716-2-git-send-email-hagaya@mellanox.com>
References: <1441531812-27716-1-git-send-email-hagaya@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441531812-27716-1-git-send-email-hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add new struct member, mlx5_resource, for each tracked object, to allow
retrieving the object in the  poll_cq once we need it.


Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/src/mlx5.h b/src/mlx5.h
index 6ad79fe..4dda0bf 100644
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
+	enum mlx5_rsc_type      type;
+	uint32_t                rsn;
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
 	struct ibv_qp			ibv_qp;
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
