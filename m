From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/5] mlx5: Implement read_completion_wallclock_ns
Date: Wed, 17 Jan 2018 15:51:33 +0200
Message-ID: <1516197093-20699-6-git-send-email-yishaih@mellanox.com>
References: <1516197093-20699-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197093-20699-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement the read_completion_wallclock_ns CQ reader.
This internally fetches the clock page and converts the
device timestamp using the existing DV api.

The commit also revises mlx5_cq_fill_pfns return value.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c    | 181 +++++++++++++++++++++++++++++++++++++++----------
 providers/mlx5/mlx5.h  |   5 +-
 providers/mlx5/verbs.c |  15 ++--
 3 files changed, 162 insertions(+), 39 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index e96418f..25446d0 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -1004,10 +1004,12 @@ static inline void _mlx5_end_poll(struct ibv_cq_ex *ibcq,
 }
 
 static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr,
-				  int lock, enum polling_mode stall, int cqe_version)
+				  int lock, enum polling_mode stall,
+				  int cqe_version, int clock_update)
 				  ALWAYS_INLINE;
 static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr,
-				  int lock, enum polling_mode stall, int cqe_version)
+				  int lock, enum polling_mode stall,
+				  int cqe_version, int clock_update)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 	struct mlx5_cqe64 *cqe64;
@@ -1066,8 +1068,14 @@ static inline int mlx5_start_poll(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_att
 		}
 
 		cq->flags &= ~(MLX5_CQ_FLAGS_FOUND_CQES);
+
+		goto out;
 	}
 
+	if (clock_update && !err)
+		err = mlx5dv_get_clock_info(ibcq->context, &cq->last_clock_info);
+
+out:
 	return err;
 }
 
@@ -1117,73 +1125,145 @@ static inline int mlx5_next_poll_v1(struct ibv_cq_ex *ibcq)
 static inline int mlx5_start_poll_v0(struct ibv_cq_ex *ibcq,
 				     struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 0, 0, 0);
+	return mlx5_start_poll(ibcq, attr, 0, 0, 0, 0);
 }
 
 static inline int mlx5_start_poll_v1(struct ibv_cq_ex *ibcq,
 				     struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 0, 0, 1);
+	return mlx5_start_poll(ibcq, attr, 0, 0, 1, 0);
 }
 
 static inline int mlx5_start_poll_v0_lock(struct ibv_cq_ex *ibcq,
 					  struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 1, 0, 0);
+	return mlx5_start_poll(ibcq, attr, 1, 0, 0, 0);
 }
 
 static inline int mlx5_start_poll_v1_lock(struct ibv_cq_ex *ibcq,
 					  struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 1, 0, 1);
+	return mlx5_start_poll(ibcq, attr, 1, 0, 1, 0);
 }
 
 static inline int mlx5_start_poll_adaptive_stall_v0_lock(struct ibv_cq_ex *ibcq,
 							 struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 0);
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 0, 0);
 }
 
 static inline int mlx5_start_poll_stall_v0_lock(struct ibv_cq_ex *ibcq,
 						struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 0);
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 0, 0);
 }
 
 static inline int mlx5_start_poll_adaptive_stall_v1_lock(struct ibv_cq_ex *ibcq,
 							 struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 1);
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 1, 0);
 }
 
 static inline int mlx5_start_poll_stall_v1_lock(struct ibv_cq_ex *ibcq,
 						struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 1);
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 1, 0);
 }
 
 static inline int mlx5_start_poll_stall_v0(struct ibv_cq_ex *ibcq,
 					   struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 0);
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 0, 0);
 }
 
 static inline int mlx5_start_poll_adaptive_stall_v0(struct ibv_cq_ex *ibcq,
 						    struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 0);
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 0, 0);
 }
 
 static inline int mlx5_start_poll_adaptive_stall_v1(struct ibv_cq_ex *ibcq,
 						    struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 1);
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 1, 0);
 }
 
 static inline int mlx5_start_poll_stall_v1(struct ibv_cq_ex *ibcq,
 					   struct ibv_poll_cq_attr *attr)
 {
-	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 1);
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 1, 0);
+}
+
+static inline int mlx5_start_poll_v0_lock_clock_update(struct ibv_cq_ex *ibcq,
+						       struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, 0, 0, 1);
+}
+
+static inline int mlx5_start_poll_v1_lock_clock_update(struct ibv_cq_ex *ibcq,
+						       struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, 0, 1, 1);
+}
+
+static inline int mlx5_start_poll_v1_clock_update(struct ibv_cq_ex *ibcq,
+						  struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, 0, 1, 1);
+}
+
+static inline int mlx5_start_poll_v0_clock_update(struct ibv_cq_ex *ibcq,
+						  struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, 0, 0, 1);
+}
+
+static inline int mlx5_start_poll_stall_v1_lock_clock_update(struct ibv_cq_ex *ibcq,
+							     struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 1, 1);
+}
+
+static inline int mlx5_start_poll_stall_v0_lock_clock_update(struct ibv_cq_ex *ibcq,
+							     struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL, 0, 1);
+}
+
+static inline int mlx5_start_poll_stall_v1_clock_update(struct ibv_cq_ex *ibcq,
+							struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 1, 1);
+}
+
+static inline int mlx5_start_poll_stall_v0_clock_update(struct ibv_cq_ex *ibcq,
+							struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL, 0, 1);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v0_lock_clock_update(struct ibv_cq_ex *ibcq,
+								      struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 0, 1);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v1_lock_clock_update(struct ibv_cq_ex *ibcq,
+								      struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 1, POLLING_MODE_STALL_ADAPTIVE, 1, 1);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v0_clock_update(struct ibv_cq_ex *ibcq,
+								 struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 0, 1);
+}
+
+static inline int mlx5_start_poll_adaptive_stall_v1_clock_update(struct ibv_cq_ex *ibcq,
+								 struct ibv_poll_cq_attr *attr)
+{
+	return mlx5_start_poll(ibcq, attr, 0, POLLING_MODE_STALL_ADAPTIVE, 1, 1);
 }
 
 static inline void mlx5_end_poll_adaptive_stall_lock(struct ibv_cq_ex *ibcq)
@@ -1408,6 +1488,15 @@ static inline uint64_t mlx5_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
 	return be64toh(cq->cqe64->timestamp);
 }
 
+static inline uint64_t
+mlx5_cq_read_wc_completion_wallclock_ns(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return mlx5dv_ts_to_ns(&cq->last_clock_info,
+			       mlx5_cq_read_wc_completion_ts(ibcq));
+}
+
 static inline uint16_t mlx5_cq_read_wc_cvlan(struct ibv_cq_ex *ibcq)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
@@ -1437,16 +1526,17 @@ static inline void mlx5_cq_read_wc_tm_info(struct ibv_cq_ex *ibcq,
 #define STALL BIT(1)
 #define V1 BIT(2)
 #define ADAPTIVE BIT(3)
+#define CLOCK_UPDATE BIT(4)
 
-#define mlx5_start_poll_name(cqe_ver, lock, stall, adaptive) \
-	mlx5_start_poll##adaptive##stall##cqe_ver##lock
+#define mlx5_start_poll_name(cqe_ver, lock, stall, adaptive, clock_update) \
+	mlx5_start_poll##adaptive##stall##cqe_ver##lock##clock_update
 #define mlx5_next_poll_name(cqe_ver, adaptive) \
 	mlx5_next_poll##adaptive##cqe_ver
 #define mlx5_end_poll_name(lock, stall, adaptive) \
 	mlx5_end_poll##adaptive##stall##lock
 
-#define POLL_FN_ENTRY(cqe_ver, lock, stall, adaptive) { \
-		.start_poll = &mlx5_start_poll_name(cqe_ver, lock, stall, adaptive), \
+#define POLL_FN_ENTRY(cqe_ver, lock, stall, adaptive, clock_update) { \
+		.start_poll = &mlx5_start_poll_name(cqe_ver, lock, stall, adaptive, clock_update), \
 		.next_poll = &mlx5_next_poll_name(cqe_ver, adaptive), \
 		.end_poll = &mlx5_end_poll_name(lock, stall, adaptive), \
 	}
@@ -1456,29 +1546,44 @@ static const struct op
 	int (*start_poll)(struct ibv_cq_ex *ibcq, struct ibv_poll_cq_attr *attr);
 	int (*next_poll)(struct ibv_cq_ex *ibcq);
 	void (*end_poll)(struct ibv_cq_ex *ibcq);
-} ops[ADAPTIVE + V1 + STALL + SINGLE_THREADED + 1] = {
-	[V1] =  POLL_FN_ENTRY(_v1, _lock, , ),
-	[0] =  POLL_FN_ENTRY(_v0, _lock, , ),
-	[V1 | SINGLE_THREADED] =  POLL_FN_ENTRY(_v1, , , ),
-	[SINGLE_THREADED] =  POLL_FN_ENTRY(_v0, , , ),
-	[V1 | STALL] =  POLL_FN_ENTRY(_v1, _lock, _stall, ),
-	[STALL] =  POLL_FN_ENTRY(_v0, _lock, _stall, ),
-	[V1 | SINGLE_THREADED | STALL] =  POLL_FN_ENTRY(_v1, , _stall, ),
-	[SINGLE_THREADED | STALL] =  POLL_FN_ENTRY(_v0, , _stall, ),
-	[V1 | STALL | ADAPTIVE] =  POLL_FN_ENTRY(_v1, _lock, _stall, _adaptive),
-	[STALL | ADAPTIVE] =  POLL_FN_ENTRY(_v0, _lock, _stall, _adaptive),
-	[V1 | SINGLE_THREADED | STALL | ADAPTIVE] =  POLL_FN_ENTRY(_v1, , _stall, _adaptive),
-	[SINGLE_THREADED | STALL | ADAPTIVE] =  POLL_FN_ENTRY(_v0, , _stall, _adaptive),
+} ops[ADAPTIVE + V1 + STALL + SINGLE_THREADED + CLOCK_UPDATE + 1] = {
+	[V1] =  POLL_FN_ENTRY(_v1, _lock, , ,),
+	[0] =  POLL_FN_ENTRY(_v0, _lock, , ,),
+	[V1 | SINGLE_THREADED] =  POLL_FN_ENTRY(_v1, , , , ),
+	[SINGLE_THREADED] =  POLL_FN_ENTRY(_v0, , , , ),
+	[V1 | STALL] =  POLL_FN_ENTRY(_v1, _lock, _stall, , ),
+	[STALL] =  POLL_FN_ENTRY(_v0, _lock, _stall, , ),
+	[V1 | SINGLE_THREADED | STALL] =  POLL_FN_ENTRY(_v1, , _stall, , ),
+	[SINGLE_THREADED | STALL] =  POLL_FN_ENTRY(_v0, , _stall, , ),
+	[V1 | STALL | ADAPTIVE] = POLL_FN_ENTRY(_v1, _lock, _stall, _adaptive, ),
+	[STALL | ADAPTIVE] =  POLL_FN_ENTRY(_v0, _lock, _stall, _adaptive, ),
+	[V1 | SINGLE_THREADED | STALL | ADAPTIVE] = POLL_FN_ENTRY(_v1, , _stall, _adaptive, ),
+	[SINGLE_THREADED | STALL | ADAPTIVE] = POLL_FN_ENTRY(_v0, , _stall, _adaptive, ),
+	[V1 | CLOCK_UPDATE] = POLL_FN_ENTRY(_v1, _lock, , , _clock_update),
+	[0 | CLOCK_UPDATE] = POLL_FN_ENTRY(_v0, _lock, , , _clock_update),
+	[V1 | SINGLE_THREADED | CLOCK_UPDATE] = POLL_FN_ENTRY(_v1, , , , _clock_update),
+	[SINGLE_THREADED | CLOCK_UPDATE] = POLL_FN_ENTRY(_v0, , , , _clock_update),
+	[V1 | STALL | CLOCK_UPDATE] = POLL_FN_ENTRY(_v1, _lock, _stall, , _clock_update),
+	[STALL | CLOCK_UPDATE] = POLL_FN_ENTRY(_v0, _lock, _stall, , _clock_update),
+	[V1 | SINGLE_THREADED | STALL | CLOCK_UPDATE] = POLL_FN_ENTRY(_v1, , _stall, , _clock_update),
+	[SINGLE_THREADED | STALL | CLOCK_UPDATE] = POLL_FN_ENTRY(_v0, , _stall, , _clock_update),
+	[V1 | STALL | ADAPTIVE | CLOCK_UPDATE] = POLL_FN_ENTRY(_v1, _lock, _stall, _adaptive, _clock_update),
+	[STALL | ADAPTIVE | CLOCK_UPDATE] = POLL_FN_ENTRY(_v0, _lock, _stall, _adaptive, _clock_update),
+	[V1 | SINGLE_THREADED | STALL | ADAPTIVE | CLOCK_UPDATE] = POLL_FN_ENTRY(_v1, , _stall, _adaptive, _clock_update),
+	[SINGLE_THREADED | STALL | ADAPTIVE | CLOCK_UPDATE] = POLL_FN_ENTRY(_v0, , _stall, _adaptive, _clock_update),
 };
 
-void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_attr)
+int mlx5_cq_fill_pfns(struct mlx5_cq *cq,
+		      const struct ibv_cq_init_attr_ex *cq_attr,
+		      struct mlx5_context *mctx)
 {
-	struct mlx5_context *mctx = to_mctx(ibv_cq_ex_to_cq(&cq->ibv_cq)->context);
 	const struct op *poll_ops = &ops[((cq->stall_enable && cq->stall_adaptive_enable) ? ADAPTIVE : 0) |
 					 (mctx->cqe_version ? V1 : 0) |
 					 (cq->flags & MLX5_CQ_FLAGS_SINGLE_THREADED ?
 						      SINGLE_THREADED : 0) |
-					 (cq->stall_enable ? STALL : 0)];
+					 (cq->stall_enable ? STALL : 0) |
+					 ((cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP_WALLCLOCK) ?
+							CLOCK_UPDATE : 0)];
 
 	cq->ibv_cq.start_poll = poll_ops->start_poll;
 	cq->ibv_cq.next_poll = poll_ops->next_poll;
@@ -1509,6 +1614,14 @@ void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_
 		cq->ibv_cq.read_flow_tag = mlx5_cq_read_flow_tag;
 	if (cq_attr->wc_flags & IBV_WC_EX_WITH_TM_INFO)
 		cq->ibv_cq.read_tm_info = mlx5_cq_read_wc_tm_info;
+	if (cq_attr->wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP_WALLCLOCK) {
+		if (!mctx->clock_info_page)
+			return EOPNOTSUPP;
+		cq->ibv_cq.read_completion_wallclock_ns =
+		    mlx5_cq_read_wc_completion_wallclock_ns;
+	}
+
+	return 0;
 }
 
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index c0f342d..db80846 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -387,6 +387,7 @@ struct mlx5_cq {
 	struct mlx5_cqe64		*cqe64;
 	uint32_t			flags;
 	int			umr_opcode;
+	struct mlx5dv_clock_info	last_clock_info;
 };
 
 struct mlx5_tag_entry {
@@ -713,7 +714,9 @@ struct ibv_cq *mlx5_create_cq(struct ibv_context *context, int cqe,
 			       int comp_vector);
 struct ibv_cq_ex *mlx5_create_cq_ex(struct ibv_context *context,
 				    struct ibv_cq_init_attr_ex *cq_attr);
-void mlx5_cq_fill_pfns(struct mlx5_cq *cq, const struct ibv_cq_init_attr_ex *cq_attr);
+int mlx5_cq_fill_pfns(struct mlx5_cq *cq,
+		      const struct ibv_cq_init_attr_ex *cq_attr,
+		      struct mlx5_context *mctx);
 int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 		      struct mlx5_buf *buf, int nent, int cqe_sz);
 int mlx5_free_cq_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index dafed18..1557e4f 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -532,7 +532,8 @@ enum {
 				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
 				       IBV_WC_EX_WITH_CVLAN |
 				       IBV_WC_EX_WITH_FLOW_TAG |
-				       IBV_WC_EX_WITH_TM_INFO
+				       IBV_WC_EX_WITH_TM_INFO |
+				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP_WALLCLOCK
 };
 
 enum {
@@ -554,6 +555,7 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	int				cqe_sz;
 	int				ret;
 	int				ncqe;
+	int				rc;
 	struct mlx5_context *mctx = to_mctx(context);
 	FILE *fp = to_mctx(context)->dbg_fp;
 
@@ -590,6 +592,14 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 		return NULL;
 	}
 
+	if (cq_alloc_flags & MLX5_CQ_FLAGS_EXTENDED) {
+		rc = mlx5_cq_fill_pfns(cq, cq_attr, mctx);
+		if (rc) {
+			errno = rc;
+			goto err;
+		}
+	}
+
 	memset(&cmd, 0, sizeof cmd);
 	cq->cons_index = 0;
 
@@ -696,9 +706,6 @@ static struct ibv_cq_ex *create_cq(struct ibv_context *context,
 	cq->stall_adaptive_enable = to_mctx(context)->stall_adaptive_enable;
 	cq->stall_cycles = to_mctx(context)->stall_cycles;
 
-	if (cq_alloc_flags & MLX5_CQ_FLAGS_EXTENDED)
-		mlx5_cq_fill_pfns(cq, cq_attr);
-
 	return &cq->ibv_cq;
 
 err_db:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
