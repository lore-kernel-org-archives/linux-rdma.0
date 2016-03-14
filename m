From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 2/2] Update consumer index after resize CQ operation
Date: Mon, 14 Mar 2016 13:47:35 +0200
Message-ID: <1457956055-2593-3-git-send-email-noaos@mellanox.com>
References: <1457956055-2593-1-git-send-email-noaos@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457956055-2593-1-git-send-email-noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Abramonvsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The resize CQ operation generates a special CQE to indicate that the
resize is done. After consuming this CQE, we need to increment the
consumer index and update the doorbell record in the hardware as well.

Before this patch, we didn't update the doorbell record in the hardware,
which could resulted in CQ overrun.

Signed-off-by: Haggai Abramovsky <hagaya-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 9 ++-------
 src/mlx4.h  | 6 ++++++
 src/verbs.c | 1 +
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 32c9070..0bfbce4 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -116,11 +116,6 @@ static struct mlx4_cqe *next_cqe_sw(struct mlx4_cq *cq)
 	return get_sw_cqe(cq, cq->cons_index);
 }
 
-static void update_cons_index(struct mlx4_cq *cq)
-{
-	*cq->set_ci_db = htonl(cq->cons_index & 0xffffff);
-}
-
 static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe, struct ibv_wc *wc)
 {
 	if (cqe->syndrome == MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR)
@@ -356,7 +351,7 @@ int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	}
 
 	if (npolled || err == CQ_POLL_ERR)
-		update_cons_index(cq);
+		mlx4_update_cons_index(cq);
 
 	pthread_spin_unlock(&cq->lock);
 
@@ -448,7 +443,7 @@ void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq)
 		 * updating consumer index.
 		 */
 		wmb();
-		update_cons_index(cq);
+		mlx4_update_cons_index(cq);
 	}
 }
 
diff --git a/src/mlx4.h b/src/mlx4.h
index f8d2051..53ea4cb 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -35,6 +35,7 @@
 #define MLX4_H
 
 #include <stddef.h>
+#include <netinet/in.h>
 
 #include <infiniband/driver.h>
 #include <infiniband/arch.h>
@@ -378,6 +379,11 @@ static inline struct mlx4_ah *to_mah(struct ibv_ah *ibah)
 	return to_mxxx(ah, ah);
 }
 
+static inline void mlx4_update_cons_index(struct mlx4_cq *cq)
+{
+	*cq->set_ci_db = htonl(cq->cons_index & 0xffffff);
+}
+
 int mlx4_alloc_buf(struct mlx4_buf *buf, size_t size, int page_size);
 void mlx4_free_buf(struct mlx4_buf *buf);
 
diff --git a/src/verbs.c b/src/verbs.c
index 2cb1f8a..a4f90bf 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -332,6 +332,7 @@ int mlx4_resize_cq(struct ibv_cq *ibcq, int cqe)
 
 	mlx4_free_buf(&cq->buf);
 	cq->buf = buf;
+	mlx4_update_cons_index(cq);
 
 out:
 	pthread_spin_unlock(&cq->lock);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
