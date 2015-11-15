From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 6/7] Optimize poll_cq
Date: Sun, 15 Nov 2015 14:30:33 +0200
Message-ID: <1447590634-12858-7-git-send-email-matanb@mellanox.com>
References: <1447590634-12858-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447590634-12858-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current ibv_poll_cq_ex mechanism needs to query every field
for its existence. In order to avoid this penalty at runtime,
add optimized functions for special cases.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    | 363 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
 src/mlx5.h  |  10 ++
 src/verbs.c |   9 +-
 3 files changed, 310 insertions(+), 72 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 5e06990..fcb4237 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -41,6 +41,7 @@
 #include <netinet/in.h>
 #include <string.h>
 #include <errno.h>
+#include <assert.h>
 #include <unistd.h>
 
 #include <infiniband/opcode.h>
@@ -207,73 +208,91 @@ union wc_buffer {
 	uint64_t	*b64;
 };
 
+#define IS_IN_WC_FLAGS(yes, no, maybe, flag) (((yes) & (flag)) ||    \
+					      (!((no) & (flag)) && \
+					       ((maybe) & (flag))))
 static inline void handle_good_req_ex(struct ibv_wc_ex *wc_ex,
 				      union wc_buffer *pwc_buffer,
 				      struct mlx5_cqe64 *cqe,
 				      uint64_t wc_flags,
-				      uint32_t qpn)
+				      uint64_t wc_flags_yes,
+				      uint64_t wc_flags_no,
+				      uint32_t qpn, uint64_t *wc_flags_out)
 {
 	union wc_buffer wc_buffer = *pwc_buffer;
 
 	switch (ntohl(cqe->sop_drop_qpn) >> 24) {
 	case MLX5_OPCODE_RDMA_WRITE_IMM:
-		wc_ex->wc_flags |= IBV_WC_EX_IMM;
+		*wc_flags_out |= IBV_WC_EX_IMM;
 	case MLX5_OPCODE_RDMA_WRITE:
 		wc_ex->opcode    = IBV_WC_RDMA_WRITE;
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN))
 			wc_buffer.b32++;
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	case MLX5_OPCODE_SEND_IMM:
-		wc_ex->wc_flags |= IBV_WC_EX_IMM;
+		*wc_flags_out |= IBV_WC_EX_IMM;
 	case MLX5_OPCODE_SEND:
 	case MLX5_OPCODE_SEND_INVAL:
 		wc_ex->opcode    = IBV_WC_SEND;
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN))
 			wc_buffer.b32++;
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	case MLX5_OPCODE_RDMA_READ:
 		wc_ex->opcode    = IBV_WC_RDMA_READ;
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN)) {
 			*wc_buffer.b32++ = ntohl(cqe->byte_cnt);
-			wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+			*wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	case MLX5_OPCODE_ATOMIC_CS:
 		wc_ex->opcode    = IBV_WC_COMP_SWAP;
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN)) {
 			*wc_buffer.b32++ = 8;
-			wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+			*wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	case MLX5_OPCODE_ATOMIC_FA:
 		wc_ex->opcode    = IBV_WC_FETCH_ADD;
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN)) {
 			*wc_buffer.b32++ = 8;
-			wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+			*wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 		}
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	case MLX5_OPCODE_BIND_MW:
 		wc_ex->opcode    = IBV_WC_BIND_MW;
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN))
 			wc_buffer.b32++;
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	}
 
-	if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_QP_NUM)) {
 		*wc_buffer.b32++ = qpn;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_QP_NUM;
+		*wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
 	}
 
 	*pwc_buffer = wc_buffer;
@@ -345,7 +364,9 @@ static inline int handle_responder_ex(struct ibv_wc_ex *wc_ex,
 				      union wc_buffer *pwc_buffer,
 				      struct mlx5_cqe64 *cqe,
 				      struct mlx5_qp *qp, struct mlx5_srq *srq,
-				      uint64_t wc_flags, uint32_t qpn)
+				      uint64_t wc_flags, uint64_t wc_flags_yes,
+				      uint64_t wc_flags_no, uint32_t qpn,
+				      uint64_t *wc_flags_out)
 {
 	uint16_t wqe_ctr;
 	struct mlx5_wq *wq;
@@ -354,9 +375,10 @@ static inline int handle_responder_ex(struct ibv_wc_ex *wc_ex,
 	int err = 0;
 	uint32_t byte_len = ntohl(cqe->byte_cnt);
 
-	if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_BYTE_LEN)) {
 		*wc_buffer.b32++ = byte_len;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_BYTE_LEN;
+		*wc_flags_out |= IBV_WC_EX_WITH_BYTE_LEN;
 	}
 	if (srq) {
 		wqe_ctr = ntohs(cqe->wqe_counter);
@@ -386,53 +408,62 @@ static inline int handle_responder_ex(struct ibv_wc_ex *wc_ex,
 	switch (cqe->op_own >> 4) {
 	case MLX5_CQE_RESP_WR_IMM:
 		wc_ex->opcode	= IBV_WC_RECV_RDMA_WITH_IMM;
-		wc_ex->wc_flags	= IBV_WC_EX_IMM;
-		if (wc_flags & IBV_WC_EX_WITH_IMM) {
+		*wc_flags_out	= IBV_WC_EX_IMM;
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM)) {
 			*wc_buffer.b32++ = ntohl(cqe->byte_cnt);
-			wc_ex->wc_flags |= IBV_WC_EX_WITH_IMM;
+			*wc_flags_out |= IBV_WC_EX_WITH_IMM;
 		}
 		break;
 	case MLX5_CQE_RESP_SEND:
 		wc_ex->opcode   = IBV_WC_RECV;
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
 		break;
 	case MLX5_CQE_RESP_SEND_IMM:
 		wc_ex->opcode	= IBV_WC_RECV;
-		wc_ex->wc_flags	= IBV_WC_EX_WITH_IMM;
-		if (wc_flags & IBV_WC_EX_WITH_IMM) {
+		*wc_flags_out	= IBV_WC_EX_WITH_IMM;
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM)) {
 			*wc_buffer.b32++ = ntohl(cqe->imm_inval_pkey);
-			wc_ex->wc_flags |= IBV_WC_EX_WITH_IMM;
+			*wc_flags_out |= IBV_WC_EX_WITH_IMM;
 		}
 		break;
 	}
-	if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_QP_NUM)) {
 		*wc_buffer.b32++ = qpn;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_QP_NUM;
+		*wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
 	}
-	if (wc_flags & IBV_WC_EX_WITH_SRC_QP) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_SRC_QP)) {
 		*wc_buffer.b32++ = ntohl(cqe->flags_rqpn) & 0xffffff;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_SRC_QP;
+		*wc_flags_out |= IBV_WC_EX_WITH_SRC_QP;
 	}
-	if (wc_flags & IBV_WC_EX_WITH_PKEY_INDEX) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_PKEY_INDEX)) {
 		*wc_buffer.b16++ = ntohl(cqe->imm_inval_pkey) & 0xffff;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_PKEY_INDEX;
+		*wc_flags_out |= IBV_WC_EX_WITH_PKEY_INDEX;
 	}
-	if (wc_flags & IBV_WC_EX_WITH_SLID) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_SLID)) {
 		*wc_buffer.b16++ = ntohs(cqe->slid);
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_SLID;
+		*wc_flags_out |= IBV_WC_EX_WITH_SLID;
 	}
-	if (wc_flags & IBV_WC_EX_WITH_SL) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_SL)) {
 		*wc_buffer.b8++ = (ntohl(cqe->flags_rqpn) >> 24) & 0xf;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_SL;
+		*wc_flags_out |= IBV_WC_EX_WITH_SL;
 	}
-	if (wc_flags & IBV_WC_EX_WITH_DLID_PATH_BITS) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_DLID_PATH_BITS)) {
 		*wc_buffer.b8++ = cqe->ml_path & 0x7f;
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_DLID_PATH_BITS;
+		*wc_flags_out |= IBV_WC_EX_WITH_DLID_PATH_BITS;
 	}
 
 	g = (ntohl(cqe->flags_rqpn) >> 28) & 3;
-	wc_ex->wc_flags |= g ? IBV_WC_EX_GRH : 0;
+	*wc_flags_out |= g ? IBV_WC_EX_GRH : 0;
 
 	*pwc_buffer = wc_buffer;
 	return IBV_WC_SUCCESS;
@@ -795,6 +826,9 @@ inline int mlx5_poll_one_cqe_err(struct mlx5_context *mctx,
 	return err;
 }
 
+#define IS_IN_WC_FLAGS(yes, no, maybe, flag) (((yes) & (flag)) ||    \
+					      (!((no) & (flag)) && \
+					       ((maybe) & (flag))))
 static inline int mlx5_poll_one(struct mlx5_cq *cq,
 			 struct mlx5_resource **cur_rsc,
 			 struct mlx5_srq **cur_srq,
@@ -874,11 +908,21 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 	return CQ_OK;
 }
 
-inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
-			    struct mlx5_resource **cur_rsc,
-			    struct mlx5_srq **cur_srq,
-			    struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
-			    int cqe_ver)
+static inline int _mlx5_poll_one_ex(struct mlx5_cq *cq,
+				    struct mlx5_resource **cur_rsc,
+				    struct mlx5_srq **cur_srq,
+				    struct ibv_wc_ex **pwc_ex,
+				    uint64_t wc_flags,
+				    uint64_t wc_flags_yes, uint64_t wc_flags_no,
+				    int cqe_ver)
+	__attribute__((always_inline));
+static inline int _mlx5_poll_one_ex(struct mlx5_cq *cq,
+				    struct mlx5_resource **cur_rsc,
+				    struct mlx5_srq **cur_srq,
+				    struct ibv_wc_ex **pwc_ex,
+				    uint64_t wc_flags,
+				    uint64_t wc_flags_yes, uint64_t wc_flags_no,
+				    int cqe_ver)
 {
 	struct mlx5_cqe64 *cqe64;
 	void *cqe;
@@ -888,6 +932,7 @@ inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
 	struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
 	struct ibv_wc_ex *wc_ex = *pwc_ex;
 	union wc_buffer wc_buffer;
+	uint64_t wc_flags_out = 0;
 
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
@@ -913,26 +958,34 @@ inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
 	wc_ex->wc_flags = 0;
 	wc_ex->reserved = 0;
 
-	if (wc_flags & IBV_WC_EX_WITH_COMPLETION_TIMESTAMP) {
+	if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+			   IBV_WC_EX_WITH_COMPLETION_TIMESTAMP)) {
 		*wc_buffer.b64++ = ntohll(cqe64->timestamp);
-		wc_ex->wc_flags |= IBV_WC_EX_WITH_COMPLETION_TIMESTAMP;
+		wc_flags_out |= IBV_WC_EX_WITH_COMPLETION_TIMESTAMP;
 	}
 
 	switch (opcode) {
 	case MLX5_CQE_REQ:
 		err = mlx5_poll_one_cqe_req(cq, cur_rsc, cqe, qpn, cqe_ver,
 					    &wc_ex->wr_id);
-		handle_good_req_ex(wc_ex, &wc_buffer, cqe64, wc_flags, qpn);
+		handle_good_req_ex(wc_ex, &wc_buffer, cqe64, wc_flags,
+				   wc_flags_yes, wc_flags_no, qpn,
+				   &wc_flags_out);
 		wc_ex->status = err;
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
 		break;
 
@@ -950,7 +1003,9 @@ inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
 		wc_ex->status = handle_responder_ex(wc_ex, &wc_buffer, cqe64,
 						    rsc_to_mqp(*cur_rsc),
 						    is_srq ? *cur_srq : NULL,
-						    wc_flags, qpn);
+						    wc_flags, wc_flags_yes,
+						    wc_flags_no, qpn,
+						    &wc_flags_out);
 		break;
 	}
 	case MLX5_CQE_REQ_ERR:
@@ -963,32 +1018,208 @@ inline int mlx5_poll_one_ex(struct mlx5_cq *cq,
 			return err;
 
 	case MLX5_CQE_RESIZE_CQ:
-		if (wc_flags & IBV_WC_EX_WITH_BYTE_LEN)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_BYTE_LEN))
 			wc_buffer.b32++;
-		if (wc_flags & IBV_WC_EX_WITH_IMM)
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_IMM))
 			wc_buffer.b32++;
-		if (wc_flags & IBV_WC_EX_WITH_QP_NUM) {
+		if (IS_IN_WC_FLAGS(wc_flags_yes, wc_flags_no, wc_flags,
+				   IBV_WC_EX_WITH_QP_NUM)) {
 			*wc_buffer.b32++ = qpn;
-			wc_ex->wc_flags |= IBV_WC_EX_WITH_QP_NUM;
+			wc_flags_out |= IBV_WC_EX_WITH_QP_NUM;
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
 		break;
 	}
 
+	wc_ex->wc_flags = wc_flags_out;
 	*pwc_ex = (struct ibv_wc_ex *)((uintptr_t)(wc_buffer.b8 + sizeof(uint64_t) - 1) &
 				       ~(sizeof(uint64_t) - 1));
 	return CQ_OK;
 }
 
+int mlx5_poll_one_ex(struct mlx5_cq *cq,
+		     struct mlx5_resource **cur_rsc,
+		     struct mlx5_srq **cur_srq,
+		     struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+		     int cqe_ver)
+{
+	return _mlx5_poll_one_ex(cq, cur_rsc, cur_srq, pwc_ex, wc_flags, 0, 0,
+				 cqe_ver);
+}
+
+#define MLX5_POLL_ONE_EX_WC_FLAGS_NAME(wc_flags_yes, wc_flags_no) \
+	mlx5_poll_one_ex_custom##wc_flags_yes ## _ ## wc_flags_no
+
+/* The compiler will create one function per wc_flags combination. Since
+ * _mlx5_poll_one_ex  is always inlined (for compilers that supports that),
+ * the compiler drops the if statements and merge all wc_flags_out ORs/ANDs.
+ */
+#define MLX5_POLL_ONE_EX_WC_FLAGS(wc_flags_yes, wc_flags_no)	\
+static int MLX5_POLL_ONE_EX_WC_FLAGS_NAME(wc_flags_yes, wc_flags_no)		\
+						(struct mlx5_cq *cq,		\
+						 struct mlx5_resource **cur_rsc,\
+						 struct mlx5_srq **cur_srq,	\
+						 struct ibv_wc_ex **pwc_ex,	\
+						 uint64_t wc_flags,		\
+						 int cqe_ver)			\
+{									        \
+	return _mlx5_poll_one_ex(cq, cur_rsc, cur_srq, pwc_ex, wc_flags,        \
+				 wc_flags_yes, wc_flags_no, cqe_ver);	        \
+}
+
+/*
+	Since we use the preprocessor here, we have to calculate the Or value
+	ourselves:
+	IBV_WC_EX_GRH			= 1 << 0,
+	IBV_WC_EX_IMM			= 1 << 1,
+	IBV_WC_EX_WITH_BYTE_LEN		= 1 << 2,
+	IBV_WC_EX_WITH_IMM		= 1 << 3,
+	IBV_WC_EX_WITH_QP_NUM		= 1 << 4,
+	IBV_WC_EX_WITH_SRC_QP		= 1 << 5,
+	IBV_WC_EX_WITH_PKEY_INDEX	= 1 << 6,
+	IBV_WC_EX_WITH_SLID		= 1 << 7,
+	IBV_WC_EX_WITH_SL		= 1 << 8,
+	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 9,
+	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP = 1 << 10,
+*/
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
+#define OPTIMIZE_POLL_CQ	/* All maybe - must be in table! */	    \
+				OP(0, 0)				SEP \
+				/* No options */			    \
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
+#define OP	MLX5_POLL_ONE_EX_WC_FLAGS
+#define SEP	;
+
+/* Declare optimized poll_one function for popular scenarios. Each function
+ * has a name of
+ * mlx5_poll_one_ex_custom<supported_wc_flags>_<not_supported_wc_flags>.
+ * Since the supported and not supported wc_flags are given beforehand,
+ * the compiler could optimize the if and or statements and create optimized
+ * code.
+ */
+OPTIMIZE_POLL_CQ
+
+#define ADD_POLL_ONE(_wc_flags_yes, _wc_flags_no)			\
+				{.wc_flags_yes = _wc_flags_yes,		\
+				 .wc_flags_no = _wc_flags_no,		\
+				 .fn = MLX5_POLL_ONE_EX_WC_FLAGS_NAME(  \
+					_wc_flags_yes, _wc_flags_no)	\
+				}
+
+#undef OP
+#undef SEP
+#define OP	ADD_POLL_ONE
+#define SEP	,
+
+struct {
+	int (*fn)(struct mlx5_cq *cq,
+		  struct mlx5_resource **cur_rsc,
+		  struct mlx5_srq **cur_srq,
+		  struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+		  int cqe_ver);
+	uint64_t wc_flags_yes;
+	uint64_t wc_flags_no;
+} mlx5_poll_one_ex_fns[] = {
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
+ * of type  *	int (*fn)(struct mlx5_cq *cq,
+		  struct mlx5_resource **cur_rsc,
+		  struct mlx5_srq **cur_srq,
+		  struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+		  int cqe_ver);
+ * The returned function is one of the custom poll one functions declared in
+ * mlx5_poll_one_ex_fns. The function is chosen as the function which the
+ * number of wc_flags_maybe bits (the fields that aren't in the yes/no parts)
+ * is the smallest.
+ */
+int (*mlx5_get_poll_one_fn(uint64_t wc_flags))(struct mlx5_cq *cq,
+					       struct mlx5_resource **cur_rsc,
+					       struct mlx5_srq **cur_srq,
+					       struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
+					       int cqe_ver)
+{
+	unsigned int i = 0;
+	uint8_t min_bits = -1;
+	int min_index = 0xff;
+
+	for (i = 0;
+	     i < sizeof(mlx5_poll_one_ex_fns) / sizeof(mlx5_poll_one_ex_fns[0]);
+	     i++) {
+		uint64_t bits;
+		uint8_t nbits;
+
+		/* Can't have required flags in "no" */
+		if (wc_flags & mlx5_poll_one_ex_fns[i].wc_flags_no)
+			continue;
+
+		/* Can't have not required flags in yes */
+		if (~wc_flags & mlx5_poll_one_ex_fns[i].wc_flags_yes)
+			continue;
+
+		/* Number of wc_flags_maybe. See above comment for more details */
+		bits = (wc_flags  ^ mlx5_poll_one_ex_fns[i].wc_flags_yes) |
+		       ((~wc_flags ^ mlx5_poll_one_ex_fns[i].wc_flags_no) &
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
+	assert(min_index >= 0);
+
+	return mlx5_poll_one_ex_fns[min_index].fn;
+}
+
 static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
 __attribute__((always_inline));
 static inline void mlx5_poll_cq_stall_start(struct mlx5_cq *cq)
diff --git a/src/mlx5.h b/src/mlx5.h
index 818fe85..9287fbd 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -109,6 +109,10 @@
 
 #define PFX		"mlx5: "
 
+enum {
+	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
+				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+};
 
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
@@ -623,6 +627,12 @@ int mlx5_poll_one_ex(struct mlx5_cq *cq,
 		     struct mlx5_srq **cur_srq,
 		     struct ibv_wc_ex **pwc_ex, uint64_t wc_flags,
 		     int cqe_ver);
+int (*mlx5_get_poll_one_fn(uint64_t wc_flags))(struct mlx5_cq *cq,
+					       struct mlx5_resource **cur_rsc,
+					       struct mlx5_srq **cur_srq,
+					       struct ibv_wc_ex **pwc_ex,
+					       uint64_t wc_flags,
+					       int cqe_ver);
 int mlx5_alloc_cq_buf(struct mlx5_context *mctx, struct mlx5_cq *cq,
 		      struct mlx5_buf *buf, int nent, int cqe_sz);
 int mlx5_free_cq_buf(struct mlx5_context *ctx, struct mlx5_buf *buf);
diff --git a/src/verbs.c b/src/verbs.c
index 50955ae..86d0951 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -287,11 +287,6 @@ static int qp_sig_enabled(void)
 }
 
 enum {
-	CREATE_CQ_SUPPORTED_WC_FLAGS = IBV_WC_STANDARD_FLAGS	|
-				       IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
-};
-
-enum {
 	CREATE_CQ_SUPPORTED_COMP_MASK = IBV_CREATE_CQ_ATTR_FLAGS
 };
 
@@ -407,7 +402,9 @@ static struct ibv_cq *create_cq(struct ibv_context *context,
 	cq->stall_cycles = to_mctx(context)->stall_cycles;
 
 	cq->wc_flags = cq_attr->wc_flags;
-	cq->poll_one = mlx5_poll_one_ex;
+	cq->poll_one = mlx5_get_poll_one_fn(cq->wc_flags);
+	if (!cq->poll_one)
+		cq->poll_one = mlx5_poll_one_ex;
 
 	return &cq->ibv_cq;
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
