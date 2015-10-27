From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 libmlx4 7/7] Optimize ibv_poll_cq_ex for common scenarios
Date: Tue, 27 Oct 2015 19:08:57 +0200
Message-ID: <1445965737-14187-8-git-send-email-matanb@mellanox.com>
References: <1445965737-14187-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445965737-14187-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current ibv_poll_cq_ex mechanism needs to query every field
for its existence. In order to avoid this penalty at runtime,
add optimized functions for special cases.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 configure.ac |  17 ++++
 src/cq.c     | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 src/mlx4.h   |  20 ++++-
 src/verbs.c  |  10 +--
 4 files changed, 271 insertions(+), 44 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6e98f20..9dbbb4b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,6 +45,23 @@ AC_CHECK_MEMBER([struct verbs_context.ibv_create_flow], [],
     [AC_MSG_ERROR([libmlx4 requires libibverbs >= 1.2.0])],
     [[#include <infiniband/verbs.h>]])
 
+AC_MSG_CHECKING("always inline")
+CFLAGS_BAK="$CFLAGS"
+CFLAGS="$CFLAGS -Werror"
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+	static inline int f(void)
+		__attribute((always_inline));
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
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
 AC_CHECK_SIZEOF(long)
diff --git a/src/cq.c b/src/cq.c
index 1f2d572..56c0fa4 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -377,10 +377,22 @@ union wc_buffer {
 	uint64_t	*b64;
 };
 
+#define IS_IN_WC_FLAGS(yes, no, maybe, flag) (((yes) & (flag)) ||    \
+					      (!((no) & (flag)) && \
+					       ((maybe) & (flag))))
 static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
 				    struct mlx4_qp **cur_qp,
 				    struct ibv_wc_ex **pwc_ex,
-				    uint64_t wc_flags)
+				    uint64_t wc_flags,
+				    uint64_t yes_wc_flags,
+				    uint64_t no_wc_flags)
+	ALWAYS_INLINE;
+static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
+				    struct mlx4_qp **cur_qp,
+				    struct ibv_wc_ex **pwc_ex,
+				    uint64_t wc_flags,
+				    uint64_t wc_flags_yes,
+				    uint64_t wc_flags_no)
 {
 	struct mlx4_cqe *cqe;
 	uint32_t qpn;
@@ -392,14 +404,14 @@ static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
 	uint64_t wc_flags_out = 0;
 
 	wc_buffer.b64 = (uint64_t *)&wc_ex->buffer;
-	wc_ex->wc_flags = 0;
 	wc_ex->reserved = 0;
 	err = mlx4_handle_cq(cq, cur_qp, &wc_ex->wr_id, &wc_ex->status,
 			     &wc_ex->vendor_err, &cqe, &qpn, &is_send);
 	if (err != CQ_CONTINUE)
 		return err;
 
-	if (wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)) {
 		uint16_t timestamp_0_15 = cqe->timestamp_0_7 |
 			cqe->timestamp_8_15 << 8;
 
@@ -415,80 +427,101 @@ static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
 			wc_flags_out |= IBV_WC_EX_IMM;
 		case MLX4_OPCODE_RDMA_WRITE:
 			wc_ex->opcode    = IBV_WC_RDMA_WRITE;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN))
 				wc_buffer.b32++;
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		case MLX4_OPCODE_SEND_IMM:
 			wc_flags_out |= IBV_WC_EX_IMM;
 		case MLX4_OPCODE_SEND:
 			wc_ex->opcode    = IBV_WC_SEND;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN))
 				wc_buffer.b32++;
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		case MLX4_OPCODE_RDMA_READ:
 			wc_ex->opcode    = IBV_WC_RDMA_READ;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN)) {
 				*wc_buffer.b32++  = ntohl(cqe->byte_cnt);
 				wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 			}
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		case MLX4_OPCODE_ATOMIC_CS:
 			wc_ex->opcode    = IBV_WC_COMP_SWAP;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN)) {
 				*wc_buffer.b32++  = 8;
 				wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 			}
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		case MLX4_OPCODE_ATOMIC_FA:
 			wc_ex->opcode    = IBV_WC_FETCH_ADD;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN)) {
 				*wc_buffer.b32++  = 8;
 				wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 			}
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		case MLX4_OPCODE_BIND_MW:
 			wc_ex->opcode    = IBV_WC_BIND_MW;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN))
 				wc_buffer.b32++;
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		default:
 			/* assume it's a send completion */
 			wc_ex->opcode    = IBV_WC_SEND;
-			if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_BYTE_LEN))
 				wc_buffer.b32++;
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		}
 
-		if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_QP_NUM)) {
 			*wc_buffer.b32++  = qpn;
 			wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_SRC_QP)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_SRC_QP))
 			wc_buffer.b32++;
-		if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_PKEY_INDEX))
 			wc_buffer.b16++;
-		if (wc_flags & IBV_WC_EX_WITH_SLID)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_SLID))
 			wc_buffer.b16++;
-		if (wc_flags & IBV_WC_EX_WITH_SL)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_SL))
 			wc_buffer.b8++;
-		if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_DLID_PATH_BITS))
 			wc_buffer.b8++;
 	} else {
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN)) {
 			*wc_buffer.b32++ = ntohl(cqe->byte_cnt);
 			wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 		}
@@ -497,51 +530,60 @@ static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
 		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
 			wc_ex->opcode   = IBV_WC_RECV_RDMA_WITH_IMM;
 			wc_flags_out |= IBV_WC_EX_IMM;
-			if (wc_flags & IBV_WC_EX_WITH_IMM) {
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM)) {
 				*wc_buffer.b32++ = cqe->immed_rss_invalid;
 				wc_flags_out |= IBV_WC_EX_WITH_IMM;
 			}
 			break;
 		case MLX4_RECV_OPCODE_SEND:
 			wc_ex->opcode   = IBV_WC_RECV;
-			if (wc_flags & IBV_WC_EX_WITH_IMM)
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM))
 				wc_buffer.b32++;
 			break;
 		case MLX4_RECV_OPCODE_SEND_IMM:
 			wc_ex->opcode   = IBV_WC_RECV;
 			wc_flags_out |= IBV_WC_EX_IMM;
-			if (wc_flags & IBV_WC_EX_WITH_IMM) {
+			if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+					   IBV_WC_EX_WITH_IMM)) {
 				*wc_buffer.b32++ = cqe->immed_rss_invalid;
 				wc_flags_out |= IBV_WC_EX_WITH_IMM;
 			}
 			break;
 		}
 
-		if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_QP_NUM)) {
 			*wc_buffer.b32++  = qpn;
 			wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
 		}
 		g_mlpath_rqpn	   = ntohl(cqe->g_mlpath_rqpn);
-		if (wc_flags & IBV_WC_EX_WITH_SRC_QP) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_SRC_QP)) {
 			*wc_buffer.b32++  = g_mlpath_rqpn & 0xffffff;
 			wc_flags_out |= IBV_WC_EX_WITH_SRC_QP;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_PKEY_INDEX)) {
 			*wc_buffer.b16++  = ntohl(cqe->immed_rss_invalid) & 0x7f;
 			wc_flags_out |= IBV_WC_EX_WITH_PKEY_INDEX;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_SLID) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_SLID)) {
 			*wc_buffer.b16++  = ntohs(cqe->rlid);
 			wc_flags_out |= IBV_WC_EX_WITH_SLID;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_SL) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_SL)) {
 			wc_flags_out |= IBV_WC_EX_WITH_SL;
 			if ((*cur_qp) && (*cur_qp)->link_layer == IBV_LINK_LAYER_ETHERNET)
 				*wc_buffer.b8++  = ntohs(cqe->sl_vid) >> 13;
 			else
 				*wc_buffer.b8++  = ntohs(cqe->sl_vid) >> 12;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_DLID_PATH_BITS)) {
 			*wc_buffer.b8++  = (g_mlpath_rqpn >> 24) & 0x7f;
 			wc_flags_out |= IBV_WC_EX_WITH_DLID_PATH_BITS;
 		}
@@ -564,9 +606,159 @@ static inline int _mlx4_poll_one_ex(struct mlx4_cq *cq,
 
 int mlx4_poll_one_ex(struct mlx4_cq *cq,
 		     struct mlx4_qp **cur_qp,
-		     struct ibv_wc_ex **pwc_ex)
+		     struct ibv_wc_ex **pwc_ex,
+		     uint64_t wc_flags)
+{
+	return _mlx4_poll_one_ex(cq, cur_qp, pwc_ex, wc_flags, 0, 0);
+}
+
+#define MLX4_POLL_ONE_EX_WC_FLAGS_NAME(wc_flags_yes, wc_flags_no) \
+	mlx4_poll_one_ex_custom##wc_flags_yes ## _ ## wc_flags_no
+
+/* The compiler will create one function per wc_flags combination. Since
+ * _mlx4_poll_one_ex  is always inlined (for compilers that supports that),
+ * the compiler drops the if statements and merge all wc_flags_out ORs/ANDs.
+ */
+#define MLX4_POLL_ONE_EX_WC_FLAGS(wc_flags_yes, wc_flags_no)	\
+static int MLX4_POLL_ONE_EX_WC_FLAGS_NAME(wc_flags_yes, wc_flags_no)	       \
+						   (struct mlx4_cq *cq,        \
+						    struct mlx4_qp **cur_qp,   \
+						    struct ibv_wc_ex **pwc_ex, \
+						    uint64_t wc_flags)	       \
+{									       \
+	return _mlx4_poll_one_ex(cq, cur_qp, pwc_ex, wc_flags,		       \
+				 wc_flags_yes, wc_flags_no);		       \
+}
+
+/*
+ *	Since we use the preprocessor here, we have to calculate the Or value
+ *	ourselves:
+ *	IBV_WC_EX_GRH			= 1 << 0,
+ *	IBV_WC_EX_IMM			= 1 << 1,
+ *	IBV_WC_EX_WITH_BYTE_LEN		= 1 << 2,
+ *	IBV_WC_EX_WITH_IMM		= 1 << 3,
+ *	IBV_WC_EX_WITH_QP_NUM		= 1 << 4,
+ *	IBV_WC_EX_WITH_SRC_QP		= 1 << 5,
+ *	IBV_WC_EX_WITH_PKEY_INDEX	= 1 << 6,
+ *	IBV_WC_EX_WITH_SLID		= 1 << 7,
+ *	IBV_WC_EX_WITH_SL		= 1 << 8,
+ *	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 9,
+ *	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP = 1 << 10,
+ */
+
+/* Bitwise or of all flags between IBV_WC_EX_WITH_BYTE_LEN and
+ * IBV_WC_EX_WITH_COMPLETION_TIMESTAMP.
+ */
+#define SUPPORTED_WC_ALL_FLAGS	2045
+/* Bitwise or of all flags between IBV_WC_EX_WITH_BYTE_LEN and
+ * IBV_WC_EX_WITH_DLID_PATH_BITS (all the fields that are available
+ * in the legacy WC).
+ */
+#define SUPPORTED_WC_STD_FLAGS  1020
+
+#define OPTIMIZE_POLL_CQ	/* No options */			    \
+				OP(0, SUPPORTED_WC_ALL_FLAGS)		SEP \
+				/* All options */			    \
+				OP(SUPPORTED_WC_ALL_FLAGS, 0)		SEP \
+				/* All standard options */		    \
+				OP(SUPPORTED_WC_STD_FLAGS, 1024)	SEP \
+				/* Just Bytelen - for DPDK */		    \
+				OP(4, 1016)				SEP \
+				/* Timestmap only, for FSI */		    \
+				OP(1024, 1020)				SEP
+
+#define OP	MLX4_POLL_ONE_EX_WC_FLAGS
+#define SEP	;
+
+/* Declare optimized poll_one function for popular scenarios. Each function
+ * has a name of
+ * mlx4_poll_one_ex_custom<supported_wc_flags>_<not_supported_wc_flags>.
+ * Since the supported and not supported wc_flags are given beforehand,
+ * the compiler could optimize the if and or statements and create optimized
+ * code.
+ */
+OPTIMIZE_POLL_CQ
+
+#define ADD_POLL_ONE(_wc_flags_yes, _wc_flags_no)			\
+				{.wc_flags_yes = _wc_flags_yes,		\
+				 .wc_flags_no = _wc_flags_no,		\
+				 .fn = MLX4_POLL_ONE_EX_WC_FLAGS_NAME(  \
+					_wc_flags_yes, _wc_flags_no)	\
+				}
+
+#undef OP
+#undef SEP
+#define OP	ADD_POLL_ONE
+#define SEP	,
+
+struct {
+	int (*fn)(struct mlx4_cq *cq,
+		  struct mlx4_qp **cur_qp,
+		  struct ibv_wc_ex **pwc_ex,
+		  uint64_t wc_flags);
+	uint64_t wc_flags_yes;
+	uint64_t wc_flags_no;
+} mlx4_poll_one_ex_fns[] = {
+	/* This array contains all the custom poll_one functions. Every entry
+	 * in this array looks like:
+	 * {.wc_flags_yes = <flags that are always in the wc>,
+	 *  .wc_flags_no = <flags that are never in the wc>,
+	 *  .fn = <the custom poll one function}.
+	 * The .fn function is optimized according to the .wc_flags_yes and
+	 * .wc_flags_no flags. Other flags have the "if statement".
+	 */
+	OPTIMIZE_POLL_CQ
+};
+
+/* This function gets wc_flags as an argument and returns a function pointer
+ * of type int (*func)(struct mlx4_cq *cq, struct mlx4_qp **cur_qp,
+ *		       struct ibv_wc_ex **pwc_ex, uint64_t wc_flags).
+ * The returned function is one of the custom poll one functions declared in
+ * mlx4_poll_one_ex_fns. The function is chosen as the function which the
+ * number of wc_flags_maybe bits (the fields that aren't in the yes/no parts)
+ * is the smallest.
+ */
+int (*mlx4_get_poll_one_fn(uint64_t wc_flags))(struct mlx4_cq *cq,
+					       struct mlx4_qp **cur_qp,
+					       struct ibv_wc_ex **pwc_ex,
+					       uint64_t wc_flags)
 {
-	return _mlx4_poll_one_ex(cq, cur_qp, pwc_ex, cq->wc_flags);
+	unsigned int i = 0;
+	uint8_t min_bits = -1;
+	int min_index = 0xff;
+
+	for (i = 0;
+	     i < sizeof(mlx4_poll_one_ex_fns) / sizeof(mlx4_poll_one_ex_fns[0]);
+	     i++) {
+		uint64_t bits;
+		uint8_t nbits;
+
+		/* Can't have required flags in "no" */
+		if (wc_flags & mlx4_poll_one_ex_fns[i].wc_flags_no)
+			continue;
+
+		/* Can't have not required flags in yes */
+		if (~wc_flags & mlx4_poll_one_ex_fns[i].wc_flags_yes)
+			continue;
+
+		/* Number of wc_flags_maybe. See above comment for more details */
+		bits = (wc_flags  & ~mlx4_poll_one_ex_fns[i].wc_flags_yes) |
+		       (~wc_flags & ~mlx4_poll_one_ex_fns[i].wc_flags_no &
+			CREATE_CQ_SUPPORTED_WC_FLAGS);
+
+		nbits = ibv_popcount64(bits);
+
+		/* Look for the minimum number of bits */
+		if (nbits < min_bits) {
+			min_bits = nbits;
+			min_index = i;
+		}
+	}
+
+	if (min_index >= 0)
+		return mlx4_poll_one_ex_fns[min_index].fn;
+
+	return NULL;
 }
 
 int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
@@ -602,7 +794,9 @@ int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
 	int err = CQ_OK;
 	unsigned int ne = attr->max_entries;
 	int (*poll_fn)(struct mlx4_cq *cq, struct mlx4_qp **cur_qp,
-		       struct ibv_wc_ex **wc_ex) = cq->mlx4_poll_one;
+		       struct ibv_wc_ex **wc_ex, uint64_t wc_flags) =
+		cq->mlx4_poll_one;
+	uint64_t wc_flags = cq->wc_flags;
 
 	if (attr->comp_mask)
 		return -EINVAL;
@@ -610,7 +804,7 @@ int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
 	pthread_spin_lock(&cq->lock);
 
 	for (npolled = 0; npolled < ne; ++npolled) {
-		err = poll_fn(cq, &qp, &wc);
+		err = poll_fn(cq, &qp, &wc, wc_flags);
 		if (err != CQ_OK)
 			break;
 	}
diff --git a/src/mlx4.h b/src/mlx4.h
index 46a18d6..f8a0d57 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -88,6 +88,17 @@
 
 #define PFX		"mlx4: "
 
+#ifdef HAVE_ALWAYS_INLINE
+#define ALWAYS_INLINE __attribute((always_inline))
+#else
+#define ALWAYS_INLINE
+#endif
+
+enum {
+	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
+				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+};
+
 enum {
 	MLX4_STAT_RATE_OFFSET		= 5
 };
@@ -216,7 +227,7 @@ struct mlx4_cq {
 	struct ibv_cq			ibv_cq;
 	uint64_t			wc_flags;
 	int (*mlx4_poll_one)(struct mlx4_cq *cq, struct mlx4_qp **cur_qp,
-			     struct ibv_wc_ex **wc_ex);
+			     struct ibv_wc_ex **wc_ex, uint64_t wc_flags);
 	struct mlx4_buf			buf;
 	struct mlx4_buf			resize_buf;
 	pthread_spinlock_t		lock;
@@ -436,7 +447,12 @@ int mlx4_poll_cq_ex(struct ibv_cq *ibcq,
 		    struct ibv_poll_cq_ex_attr *attr);
 int mlx4_poll_one_ex(struct mlx4_cq *cq,
 		     struct mlx4_qp **cur_qp,
-		     struct ibv_wc_ex **pwc_ex);
+		     struct ibv_wc_ex **pwc_ex,
+		     uint64_t wc_flags);
+int (*mlx4_get_poll_one_fn(uint64_t wc_flags))(struct mlx4_cq *cq,
+					       struct mlx4_qp **cur_qp,
+					       struct ibv_wc_ex **pwc_ex,
+					       uint64_t wc_flags);
 int mlx4_arm_cq(struct ibv_cq *cq, int solicited);
 void mlx4_cq_event(struct ibv_cq *cq);
 void __mlx4_cq_clean(struct mlx4_cq *cq, uint32_t qpn, struct mlx4_srq *srq);
diff --git a/src/verbs.c b/src/verbs.c
index 62908c1..3bc29f8 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -330,11 +330,6 @@ enum {
 	CREATE_CQ_SUPPORTED_FLAGS = IBV_CREATE_CQ_ATTR_COMPLETION_TIMESTAMP
 };
 
-enum {
-	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
-				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
-};
-
 static struct ibv_cq *create_cq(struct ibv_context *context,
 				struct ibv_create_cq_attr_ex *cq_attr,
 				enum cmd_type cmd_type)
@@ -435,6 +430,11 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 	cq->mlx4_poll_one = mlx4_poll_one_ex;
 	cq->creation_flags = cmd_e.ibv_cmd.flags;
 	cq->wc_flags = cq_attr->wc_flags;
+
+	cq->mlx4_poll_one = mlx4_get_poll_one_fn(cq->wc_flags);
+	if (!cq->mlx4_poll_one)
+		cq->mlx4_poll_one = mlx4_poll_one_ex;
+
 	cq->cqn = resp.cqn;
 
 	return &cq->ibv_cq;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
