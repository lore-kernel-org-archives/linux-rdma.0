From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 V1 6/6] Add always_inline check
Date: Thu,  3 Dec 2015 18:02:51 +0200
Message-ID: <1449158571-26228-7-git-send-email-matanb@mellanox.com>
References: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449158571-26228-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Always inline isn't supported by every compiler. Adding it to
configure.ac in order to support it only when possible.
Inline other poll_one data path functions in order to eliminate
"ifs".

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 configure.ac | 17 +++++++++++++++++
 src/cq.c     | 42 +++++++++++++++++++++++++++++-------------
 src/mlx5.h   |  6 ++++++
 3 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/configure.ac b/configure.ac
index fca0b46..50b4f9c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -65,6 +65,23 @@ AC_CHECK_FUNC(ibv_read_sysfs_file, [],
     AC_MSG_ERROR([ibv_read_sysfs_file() not found.  libmlx5 requires libibverbs >= 1.0.3.]))
 AC_CHECK_FUNCS(ibv_dontfork_range ibv_dofork_range ibv_register_driver)
 
+AC_MSG_CHECKING("always inline")
+CFLAGS_BAK="$CFLAGS"
+CFLAGS="$CFLAGS -Werror"
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+	static inline int f(void)
+		__attribute__((always_inline));
+	static inline int f(void)
+	{
+		return 1;
+	}
+]],[[
+		int a = f();
+		a = a;
+]])], [AC_MSG_RESULT([yes]) AC_DEFINE([HAVE_ALWAYS_INLINE], [1], [Define if __attribute((always_inline)).])],
+[AC_MSG_RESULT([no])])
+CFLAGS="$CFLAGS_BAK"
+
 dnl Now check if for libibverbs 1.0 vs 1.1
 dummy=if$$
 cat <<IBV_VERSION > $dummy.c
diff --git a/src/cq.c b/src/cq.c
index fcb4237..41751b7 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -218,6 +218,14 @@ static inline void handle_good_req_ex(struct ibv_wc_ex *wc_ex,
 				      uint64_t wc_flags_yes,
 				      uint64_t wc_flags_no,
 				      uint32_t qpn, uint64_t *wc_flags_out)
+	ALWAYS_INLINE;
+static inline void handle_good_req_ex(struct ibv_wc_ex *wc_ex,
+				      union wc_buffer *pwc_buffer,
+				      struct mlx5_cqe64 *cqe,
+				      uint64_t wc_flags,
+				      uint64_t wc_flags_yes,
+				      uint64_t wc_flags_no,
+				      uint32_t qpn, uint64_t *wc_flags_out)
 {
 	union wc_buffer wc_buffer = *pwc_buffer;
 
@@ -367,6 +375,14 @@ static inline int handle_responder_ex(struct ibv_wc_ex *wc_ex,
 				      uint64_t wc_flags, uint64_t wc_flags_yes,
 				      uint64_t wc_flags_no, uint32_t qpn,
 				      uint64_t *wc_flags_out)
+	ALWAYS_INLINE;
+static inline int handle_responder_ex(struct ibv_wc_ex *wc_ex,
+				      union wc_buffer *pwc_buffer,
+				      struct mlx5_cqe64 *cqe,
+				      struct mlx5_qp *qp, struct mlx5_srq *srq,
+				      uint64_t wc_flags, uint64_t wc_flags_yes,
+				      uint64_t wc_flags_no, uint32_t qpn,
+				      uint64_t *wc_flags_out)
 {
 	uint16_t wqe_ctr;
 	struct mlx5_wq *wq;
@@ -573,7 +589,7 @@ static void mlx5_get_cycles(uint64_t *cycles)
 static inline struct mlx5_qp *get_req_context(struct mlx5_context *mctx,
 					      struct mlx5_resource **cur_rsc,
 					      uint32_t rsn, int cqe_ver)
-					      __attribute__((always_inline));
+					      ALWAYS_INLINE;
 static inline struct mlx5_qp *get_req_context(struct mlx5_context *mctx,
 					      struct mlx5_resource **cur_rsc,
 					      uint32_t rsn, int cqe_ver)
@@ -589,7 +605,7 @@ static inline int get_resp_cxt_v1(struct mlx5_context *mctx,
 				  struct mlx5_resource **cur_rsc,
 				  struct mlx5_srq **cur_srq,
 				  uint32_t uidx, int *is_srq)
-				  __attribute__((always_inline));
+				  ALWAYS_INLINE;
 static inline int get_resp_cxt_v1(struct mlx5_context *mctx,
 				  struct mlx5_resource **cur_rsc,
 				  struct mlx5_srq **cur_srq,
@@ -625,7 +641,7 @@ static inline int get_resp_cxt_v1(struct mlx5_context *mctx,
 static inline int get_resp_ctx(struct mlx5_context *mctx,
 			       struct mlx5_resource **cur_rsc,
 			       uint32_t qpn)
-			       __attribute__((always_inline));
+			       ALWAYS_INLINE;
 static inline int get_resp_ctx(struct mlx5_context *mctx,
 			       struct mlx5_resource **cur_rsc,
 			       uint32_t qpn)
@@ -647,7 +663,7 @@ static inline int get_resp_ctx(struct mlx5_context *mctx,
 static inline int get_srq_ctx(struct mlx5_context *mctx,
 			      struct mlx5_srq **cur_srq,
 			      uint32_t srqn_uidx)
-			      __attribute__((always_inline));
+			      ALWAYS_INLINE;
 static inline int get_srq_ctx(struct mlx5_context *mctx,
 			      struct mlx5_srq **cur_srq,
 			      uint32_t srqn)
@@ -662,7 +678,7 @@ static inline int get_srq_ctx(struct mlx5_context *mctx,
 }
 
 static inline void dump_cqe_debug(FILE *fp, struct mlx5_cqe64 *cqe64)
-	__attribute__((always_inline));
+	ALWAYS_INLINE;
 static inline void dump_cqe_debug(FILE *fp, struct mlx5_cqe64 *cqe64)
 {
 #ifdef MLX5_DEBUG
@@ -676,7 +692,7 @@ static inline void dump_cqe_debug(FILE *fp, struct mlx5_cqe64 *cqe64)
 inline int mlx5_poll_one_cqe_req(struct mlx5_cq *cq,
 				 struct mlx5_resource **cur_rsc,
 				 void *cqe, uint32_t qpn, int cqe_ver,
-				 uint64_t *wr_id) __attribute__((always_inline));
+				 uint64_t *wr_id) ALWAYS_INLINE;
 inline int mlx5_poll_one_cqe_req(struct mlx5_cq *cq,
 				 struct mlx5_resource **cur_rsc,
 				 void *cqe, uint32_t qpn, int cqe_ver,
@@ -719,7 +735,7 @@ inline int mlx5_poll_one_cqe_resp(struct mlx5_context *mctx,
 				  struct mlx5_srq **cur_srq,
 				  struct mlx5_cqe64 *cqe64, int cqe_ver,
 				  uint32_t qpn, int *is_srq)
-	__attribute__((always_inline));
+	ALWAYS_INLINE;
 inline int mlx5_poll_one_cqe_resp(struct mlx5_context *mctx,
 				  struct mlx5_resource **cur_rsc,
 				  struct mlx5_srq **cur_srq,
@@ -750,7 +766,7 @@ inline int mlx5_poll_one_cqe_err(struct mlx5_context *mctx,
 				 uint32_t qpn, uint32_t *pwc_status,
 				 uint32_t *pwc_vendor_err,
 				 uint64_t *pwc_wr_id, uint8_t opcode)
-	__attribute__((always_inline));
+	ALWAYS_INLINE;
 inline int mlx5_poll_one_cqe_err(struct mlx5_context *mctx,
 				 struct mlx5_resource **cur_rsc,
 				 struct mlx5_srq **cur_srq,
@@ -833,7 +849,7 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 			 struct mlx5_resource **cur_rsc,
 			 struct mlx5_srq **cur_srq,
 			 struct ibv_wc *wc, int cqe_ver)
-			 __attribute__((always_inline));
+			 ALWAYS_INLINE;
 static inline int mlx5_poll_one(struct mlx5_cq *cq,
 			 struct mlx5_resource **cur_rsc,
 			 struct mlx5_srq **cur_srq,
@@ -915,7 +931,7 @@ static inline int _mlx5_poll_one_ex(struct mlx5_cq *cq,
 				    uint64_t wc_flags,
 				    uint64_t wc_flags_yes, uint64_t wc_flags_no,
 				    int cqe_ver)
-	__attribute__((always_inline));
+	ALWAYS_INLINE;
 static inline int _mlx5_poll_one_ex(struct mlx5_cq *cq,
 				    struct mlx5_resource **cur_rsc,
 				    struct mlx5_srq **cur_srq,
@@ -1221,7 +1237,7 @@ int (*mlx5_get_poll_one_fn(uint64_t wc_flags))(struct mlx5_cq *cq,
 }
 
 static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
-__attribute__((always_inline));
+ALWAYS_INLINE;
 static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
 {
 	if (cq->stall_enable) {
@@ -1236,7 +1252,7 @@ static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
 }
 
 static inline void mlx5_poll_cq_stall_end(struct mlx5_cq *cq, int ne,
-					  int npolled, int err) __attribute__((always_inline));
+					  int npolled, int err) ALWAYS_INLINE;
 static inline void mlx5_poll_cq_stall_end(struct mlx5_cq *cq, int ne,
 					  int npolled, int err)
 {
@@ -1263,7 +1279,7 @@ static inline void mlx5_poll_cq_stall_end(struct mlx5_cq *cq, int ne,
 
 static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 			  struct ibv_wc *wc, int cqe_ver)
-	__attribute__((always_inline));
+	ALWAYS_INLINE;
 static inline int poll_cq(struct ibv_cq *ibcq, int ne,
 			  struct ibv_wc *wc, int cqe_ver)
 {
diff --git a/src/mlx5.h b/src/mlx5.h
index 6c40d6d..2f2e2f7 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -114,6 +114,12 @@ enum {
 				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
 };
 
+#ifdef HAVE_ALWAYS_INLINE
+#define ALWAYS_INLINE __attribute__((always_inline))
+#else
+#define ALWAYS_INLINE
+#endif
+
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
 	MLX5_IB_MMAP_CMD_MASK	= 0xff,
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
