From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/8] mlx4: Add ability to poll CQs through iterator's style API
Date: Wed, 25 Jan 2017 16:49:48 +0200
Message-ID: <1485355791-27646-6-git-send-email-yishaih@mellanox.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485355791-27646-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The new poll CQ API is based on an iterator's style API.
The user calls start_poll_cq and next_poll_cq, query whatever valid
and initialized (initialized attributes are attributes which were
stated when the CQ was created) attributes and call end_poll_cq at
the end.

This patch implements this methodology in mlx4 user space vendor
driver. In order to make start and end efficient, we use specialized
functions for every case - locked and single threaded(unlocked).

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c   | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++
 providers/mlx4/mlx4.h | 10 ++++++-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index a80b2fb..728efde 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -416,6 +416,89 @@ int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	return err == CQ_POLL_ERR ? err : npolled;
 }
 
+static inline void _mlx4_end_poll(struct ibv_cq_ex *ibcq, int lock)
+				  ALWAYS_INLINE;
+static inline void _mlx4_end_poll(struct ibv_cq_ex *ibcq, int lock)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	mlx4_update_cons_index(cq);
+
+	if (lock)
+		pthread_spin_unlock(&cq->lock);
+}
+
+static inline int _mlx4_start_poll(struct ibv_cq_ex *ibcq,
+				   struct ibv_poll_cq_attr *attr,
+				   int lock)
+				   ALWAYS_INLINE;
+static inline int _mlx4_start_poll(struct ibv_cq_ex *ibcq,
+				   struct ibv_poll_cq_attr *attr,
+				   int lock)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	struct mlx4_cqe *cqe;
+	int err;
+
+	if (unlikely(attr->comp_mask))
+		return EINVAL;
+
+	if (lock)
+		pthread_spin_lock(&cq->lock);
+
+	cq->cur_qp = NULL;
+
+	err = mlx4_get_next_cqe(cq, &cqe);
+	if (err == CQ_EMPTY) {
+		if (lock)
+			pthread_spin_unlock(&cq->lock);
+		return ENOENT;
+	}
+
+	err = mlx4_parse_lazy_cqe(cq, cqe);
+	if (lock && err)
+		pthread_spin_unlock(&cq->lock);
+
+	return err;
+}
+
+static inline int mlx4_next_poll(struct ibv_cq_ex *ibcq)
+				 ALWAYS_INLINE;
+static inline int mlx4_next_poll(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	struct mlx4_cqe *cqe;
+	int err;
+
+	err = mlx4_get_next_cqe(cq, &cqe);
+	if (err == CQ_EMPTY)
+		return ENOENT;
+
+	return mlx4_parse_lazy_cqe(cq, cqe);
+}
+
+static inline void mlx4_end_poll(struct ibv_cq_ex *ibcq)
+{
+	_mlx4_end_poll(ibcq, 0);
+}
+
+static inline void mlx4_end_poll_lock(struct ibv_cq_ex *ibcq)
+{
+	_mlx4_end_poll(ibcq, 1);
+}
+
+static inline int mlx4_start_poll(struct ibv_cq_ex *ibcq,
+				  struct ibv_poll_cq_attr *attr)
+{
+	return _mlx4_start_poll(ibcq, attr, 0);
+}
+
+static inline int mlx4_start_poll_lock(struct ibv_cq_ex *ibcq,
+				       struct ibv_poll_cq_attr *attr)
+{
+	return _mlx4_start_poll(ibcq, attr, 1);
+}
+
 static inline enum ibv_wc_opcode mlx4_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 {
 	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 5ab083c..cb4c8d4 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -59,12 +59,20 @@ enum {
 
 #ifndef likely
 #ifdef __GNUC__
-#define likely(x)       __builtin_expect(!!(x),1)
+#define likely(x)       __builtin_expect(!!(x), 1)
 #else
 #define likely(x)      (x)
 #endif
 #endif
 
+#ifndef unlikely
+#ifdef __GNUC__
+#define unlikely(x)	    __builtin_expect(!!(x), 0)
+#else
+#define unlikely(x)	   (x)
+#endif
+#endif
+
 enum {
 	MLX4_QP_TABLE_BITS		= 8,
 	MLX4_QP_TABLE_SIZE		= 1 << MLX4_QP_TABLE_BITS,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
