From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libmlx5 4/7] Add ability to poll CQs through iterator's style API
Date: Tue,  7 Jun 2016 15:11:36 +0300
Message-ID: <1465301499-21234-5-git-send-email-yishaih@mellanox.com>
References: <1465301499-21234-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465301499-21234-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The new poll CQ API is based on an iterator's style API.
The user calls start_poll_cq and next_poll_cq, query whatever valid
and initialized (initialized attributes are attributes which were
stated when the CQ was created) attributes and call end_poll_cq at
the end.

This patch implements this methodology in mlx5 user space vendor
driver. In order to make start and end efficient, we use specialized
functions for every case - locked, adapttive- stall and their
combination. This spares if conditions in the data path.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c   | 255 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mlx5.h |   2 +
 2 files changed, 257 insertions(+)

diff --git a/src/cq.c b/src/cq.c
index d3bd006..bf2bbed 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -831,6 +831,261 @@ static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 	return err == CQ_POLL_ERR ? err : npolled;
 }
 
+enum  polling_mode {
+	POLLING_MODE_NO_STALL,
+	POLLING_MODE_STALL,
+	POLLING_MODE_STALL_ADAPTIVE
+};
+
+static inline void _mlx5_end_poll(struct ibv_cq_ex *ibcq,
+				  int lock, enum polling_mode stall)
+				  __attribute__((always_inline));
+static inline void _mlx5_end_poll(struct ibv_cq_ex *ibcq,
+				  int lock, enum polling_mode stall)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	update_cons_index(cq);
+
+	if (lock)
+		mlx5_spin_unlock(&cq->lock);
+
+	if (stall) {
+		if (stall == POLLING_MODE_STALL_ADAPTIVE) {
+			if (!(cq->flags & MLX5_CQ_FLAGS_FOUND_CQES)) {
+				cq->stall_cycles = max(cq->stall_cycles - mlx5_stall_cq_dec_step,
+						       mlx5_stall_cq_poll_min);
+				mlx5_get_cycles(&cq->stall_last_count);
+			} else if (cq->flags & MLX5_CQ_FLAGS_EMPTY_DURING_POLL) {
+				cq->stall_cycles = min(cq->stall_cycles + mlx5_stall_cq_inc_step,
+						       mlx5_stall_cq_poll_max);
+				mlx5_get_cycles(&cq->stall_last_count);
+			} else {
+				cq->stall_cycles = max(cq->stall_cycles - mlx5_stall_cq_dec_step,
+						       mlx5_stall_cq_poll_min);
+				cq->stall_last_count = 0;
+			}
+		} else if (!(cq->flags & MLX5_CQ_FLAGS_FOUND_CQES)) {
+			cq->stall_next_poll = 1;
+		}
+
+		cq->flags &= ~(MLX5_CQ_FLAGS_FOUND_CQES | MLX5_CQ_FLAGS_EMPTY_DURING_POLL);
+	}
+}
+
+static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr,
+				  int lock, enum polling_mode stall, int cqe_version)
+				  __attribute__((always_inline));
+static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr,
+				  int lock, enum polling_mode stall, int cqe_version)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	struct mlx5_cqe64 *cqe64;
+	void *cqe;
+	int err;
+
+	if (unlikely(attr->comp_mask))
+		return EINVAL;
+
+	if (stall) {
+		if (stall == POLLING_MODE_STALL_ADAPTIVE) {
+			if (cq->stall_last_count)
+				mlx5_stall_cycles_poll_cq(cq->stall_last_count + cq->stall_cycles);
+		} else if (cq->stall_next_poll) {
+			cq->stall_next_poll = 0;
+			mlx5_stall_poll_cq();
+		}
+	}
+
+	if (lock)
+		mlx5_spin_lock(&cq->lock);
+
+	cq->cur_rsc = NULL;
+	cq->cur_srq = NULL;
+
+	err = mlx5_get_next_cqe(cq, &cqe64, &cqe);
+	if (err == CQ_EMPTY) {
+		if (lock)
+			mlx5_spin_unlock(&cq->lock);
+
+		if (stall) {
+			if (stall == POLLING_MODE_STALL_ADAPTIVE) {
+				cq->stall_cycles = max(cq->stall_cycles - mlx5_stall_cq_dec_step,
+						mlx5_stall_cq_poll_min);
+				mlx5_get_cycles(&cq->stall_last_count);
+			} else {
+				cq->stall_next_poll = 1;
+			}
+		}
+
+		return ENOENT;
+	}
+
+	if (stall)
+		cq->flags |= MLX5_CQ_FLAGS_FOUND_CQES;
+
+	err = mlx5_parse_lazy_cqe(cq, cqe64, cqe, cqe_version);
+	if (lock && err)
+		mlx5_spin_unlock(&cq->lock);
+
+	if (stall && err) {
+		if (stall == POLLING_MODE_STALL_ADAPTIVE) {
+			cq->stall_cycles = max(cq->stall_cycles - mlx5_stall_cq_dec_step,
+						mlx5_stall_cq_poll_min);
+			cq->stall_last_count = 0;
+		}
+
+		cq->flags &= ~(MLX5_CQ_FLAGS_FOUND_CQES);
+	}
+
+	return err;
+}
+
+static inline int mlx5_next_poll(struct ibv_cq_ex *ibcq,
+				 enum polling_mode stall, int cqe_version)
+				 __attribute__((always_inline));
+static inline int mlx5_next_poll(struct ibv_cq_ex *ibcq,
+				 enum polling_mode stall,
+				 int cqe_version)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	struct mlx5_cqe64 *cqe64;
+	void *cqe;
+	int err;
+
+	err = mlx5_get_next_cqe(cq, &cqe64, &cqe);
+	if (err == CQ_EMPTY) {
+		if (stall == POLLING_MODE_STALL_ADAPTIVE)
+			cq->flags |= MLX5_CQ_FLAGS_EMPTY_DURING_POLL;
+
+		return ENOENT;
+	}
+
+	return mlx5_parse_lazy_cqe(cq, cqe64, cqe, cqe_version);
+}
+
+static inline int mlx5_next_poll_adaptive_v0(struct ibv_cq_ex *ibcq)
+{
+	return mlx5_next_poll(ibcq, POLLING_MODE_STALL_ADAPTIVE, 0);
+}
+
+static inline int mlx5_next_poll_adaptive_v1(struct ibv_cq_ex *ibcq)
+{
+	return mlx5_next_poll(ibcq, POLLING_MODE_STALL_ADAPTIVE, 1);
+}
+
+static inline int mlx5_next_poll_v0(struct ibv_cq_ex *ibcq)
+{
+	return mlx5_next_poll(ibcq, 0, 0);
+}
+
+static inline int mlx5_next_poll_v1(struct ibv_cq_ex *ibcq)
+{
+	return mlx5_next_poll(ibcq, 0, 1);
+}
+
+static inline int mlx5_start_poll_v0(struct ibv_cq_ex *ibcq,
+				     struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, 0, 0);
+}
+
+static inline int mlx5_start_poll_v1(struct ibv_cq_ex *ibcq,
+				     struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, 0, 1);
+}
+
+static inline int mlx5_start_poll_v0_lock(struct ibv_cq_ex *ibcq,
+					  struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, 0, 0);
+}
+
+static inline int mlx5_start_poll_v1_lock(struct ibv_cq_ex *ibcq,
+					  struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, 0, 1);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v0_lock(struct ibv_cq_ex *ibcq,
+							 struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 0);
+}
+
+static inline int mlx5_start_poll_stall_v0_lock(struct ibv_cq_ex *ibcq,
+						struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 0);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v1_lock(struct ibv_cq_ex *ibcq,
+							 struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 1);
+}
+
+static inline int mlx5_start_poll_stall_v1_lock(struct ibv_cq_ex *ibcq,
+						struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 1);
+}
+
+static inline int mlx5_start_poll_stall_v0(struct ibv_cq_ex *ibcq,
+					   struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 0);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v0(struct ibv_cq_ex *ibcq,
+						    struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 0);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v1(struct ibv_cq_ex *ibcq,
+						    struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 1);
+}
+
+static inline int mlx5_start_poll_stall_v1(struct ibv_cq_ex *ibcq,
+					   struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 1);
+}
+
+static inline void mlx5_end_poll_adaptive_stall_lock(struct ibv_cq_ex *ibcq)
+{
+	_mlx5_end_poll(ibcq, 1, POLLING_MODE_STALL_ADAPTIVE);
+}
+
+static inline void mlx5_end_poll_stall_lock(struct ibv_cq_ex *ibcq)
+{
+	_mlx5_end_poll(ibcq, 1, POLLING_MODE_STALL);
+}
+
+static inline void mlx5_end_poll_adaptive_stall(struct ibv_cq_ex *ibcq)
+{
+	_mlx5_end_poll(ibcq, 0, POLLING_MODE_STALL_ADAPTIVE);
+}
+
+static inline void mlx5_end_poll_stall(struct ibv_cq_ex *ibcq)
+{
+	_mlx5_end_poll(ibcq, 0, POLLING_MODE_STALL);
+}
+
+static inline void mlx5_end_poll(struct ibv_cq_ex *ibcq)
+{
+	_mlx5_end_poll(ibcq, 0, 0);
+}
+
+static inline void mlx5_end_poll_lock(struct ibv_cq_ex *ibcq)
+{
+	_mlx5_end_poll(ibcq, 1, 0);
+}
+
 int mlx5_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 {
 	return poll_cq(ibcq, ne, wc, 0);
diff --git a/src/mlx5.h b/src/mlx5.h
index 99bee10..15510cf 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -366,6 +366,8 @@ enum {
 
 enum {
 	MLX5_CQ_FLAGS_RX_CSUM_VALID = 1 << 0,
+	MLX5_CQ_FLAGS_EMPTY_DURING_POLL = 1 << 1,
+	MLX5_CQ_FLAGS_FOUND_CQES = 1 << 2,
 };
 
 struct mlx5_cq {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
