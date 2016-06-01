From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 1/7] Refactor mlx5_poll_one
Date: Wed,  1 Jun 2016 16:47:56 +0300
Message-ID: <1464788882-1876-2-git-send-email-yishaih@mellanox.com>
References: <1464788882-1876-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464788882-1876-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since downstream patches aim to provide lazy CQE polling, which
let the user poll the CQE's attribute via inline function, we
refactor poll_one:
* Pass out pointer instead of writing to the wc directly as part of
  handle_error_cqe.
* Introduce mlx5_get_next_cqe which will be used to advance the
  CQE iterator.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c | 112 ++++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 67 insertions(+), 45 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index ce18ac9..d3f2ada 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -298,54 +298,52 @@ static void dump_cqe(FILE *fp, void *buf)
 }
 
 static void mlx5_handle_error_cqe(struct mlx5_err_cqe *cqe,
-				  struct ibv_wc *wc)
+				  enum ibv_wc_status *pstatus)
 {
 	switch (cqe->syndrome) {
 	case MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR:
-		wc->status = IBV_WC_LOC_LEN_ERR;
+		*pstatus = IBV_WC_LOC_LEN_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR:
-		wc->status = IBV_WC_LOC_QP_OP_ERR;
+		*pstatus = IBV_WC_LOC_QP_OP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_PROT_ERR:
-		wc->status = IBV_WC_LOC_PROT_ERR;
+		*pstatus = IBV_WC_LOC_PROT_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_WR_FLUSH_ERR:
-		wc->status = IBV_WC_WR_FLUSH_ERR;
+		*pstatus = IBV_WC_WR_FLUSH_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_MW_BIND_ERR:
-		wc->status = IBV_WC_MW_BIND_ERR;
+		*pstatus = IBV_WC_MW_BIND_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_BAD_RESP_ERR:
-		wc->status = IBV_WC_BAD_RESP_ERR;
+		*pstatus = IBV_WC_BAD_RESP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_LOCAL_ACCESS_ERR:
-		wc->status = IBV_WC_LOC_ACCESS_ERR;
+		*pstatus = IBV_WC_LOC_ACCESS_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
-		wc->status = IBV_WC_REM_INV_REQ_ERR;
+		*pstatus = IBV_WC_REM_INV_REQ_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_ACCESS_ERR:
-		wc->status = IBV_WC_REM_ACCESS_ERR;
+		*pstatus = IBV_WC_REM_ACCESS_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_OP_ERR:
-		wc->status = IBV_WC_REM_OP_ERR;
+		*pstatus = IBV_WC_REM_OP_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RETRY_EXC_ERR;
+		*pstatus = IBV_WC_RETRY_EXC_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_RNR_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RNR_RETRY_EXC_ERR;
+		*pstatus = IBV_WC_RNR_RETRY_EXC_ERR;
 		break;
 	case MLX5_CQE_SYNDROME_REMOTE_ABORTED_ERR:
-		wc->status = IBV_WC_REM_ABORT_ERR;
+		*pstatus = IBV_WC_REM_ABORT_ERR;
 		break;
 	default:
-		wc->status = IBV_WC_GENERAL_ERR;
+		*pstatus = IBV_WC_GENERAL_ERR;
 		break;
 	}
-
-	wc->vendor_err = cqe->vendor_err_synd;
 }
 
 #if defined(__x86_64__) || defined (__i386__)
@@ -504,36 +502,21 @@ static inline int get_cur_rsc(struct mlx5_context *mctx,
 
 }
 
-static inline int mlx5_poll_one(struct mlx5_cq *cq,
-			 struct mlx5_resource **cur_rsc,
-			 struct mlx5_srq **cur_srq,
-			 struct ibv_wc *wc, int cqe_ver)
-			 __attribute__((always_inline));
-static inline int mlx5_poll_one(struct mlx5_cq *cq,
-			 struct mlx5_resource **cur_rsc,
-			 struct mlx5_srq **cur_srq,
-			 struct ibv_wc *wc, int cqe_ver)
+static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
+				    struct mlx5_cqe64 **pcqe64,
+				    void **pcqe)
+				    __attribute__((always_inline));
+static inline int mlx5_get_next_cqe(struct mlx5_cq *cq,
+				    struct mlx5_cqe64 **pcqe64,
+				    void **pcqe)
 {
-	struct mlx5_cqe64 *cqe64;
-	struct mlx5_wq *wq;
-	uint16_t wqe_ctr;
 	void *cqe;
-	uint32_t qpn;
-	uint32_t srqn_uidx;
-	int idx;
-	uint8_t opcode;
-	struct mlx5_err_cqe *ecqe;
-	int err;
-	struct mlx5_qp *mqp;
-	struct mlx5_context *mctx;
-	uint8_t is_srq = 0;
+	struct mlx5_cqe64 *cqe64;
 
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
 		return CQ_EMPTY;
 
-	mctx = to_mctx(cq->ibv_cq.context);
-
 	cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
 
 	++cq->cons_index;
@@ -547,14 +530,52 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 	rmb();
 
 #ifdef MLX5_DEBUG
-	if (mlx5_debug_mask & MLX5_DBG_CQ_CQE) {
-		FILE *fp = mctx->dbg_fp;
+	{
+		struct mlx5_context *mctx = to_mctx(cq->ibv_cq.context);
+
+		if (mlx5_debug_mask & MLX5_DBG_CQ_CQE) {
+			FILE *fp = mctx->dbg_fp;
 
-		mlx5_dbg(fp, MLX5_DBG_CQ_CQE, "dump cqe for cqn 0x%x:\n", cq->cqn);
-		dump_cqe(fp, cqe64);
+			mlx5_dbg(fp, MLX5_DBG_CQ_CQE, "dump cqe for cqn 0x%x:\n", cq->cqn);
+			dump_cqe(fp, cqe64);
+		}
 	}
 #endif
+	*pcqe64 = cqe64;
+	*pcqe = cqe;
+
+	return CQ_OK;
+}
+
+static inline int mlx5_poll_one(struct mlx5_cq *cq,
+				struct mlx5_resource **cur_rsc,
+				struct mlx5_srq **cur_srq,
+				struct ibv_wc *wc, int cqe_ver)
+				__attribute__((always_inline));
+static inline int mlx5_poll_one(struct mlx5_cq *cq,
+				struct mlx5_resource **cur_rsc,
+				struct mlx5_srq **cur_srq,
+				struct ibv_wc *wc, int cqe_ver)
+{
+	struct mlx5_cqe64 *cqe64;
+	struct mlx5_wq *wq;
+	uint16_t wqe_ctr;
+	void *cqe;
+	uint32_t qpn;
+	uint32_t srqn_uidx;
+	int idx;
+	uint8_t opcode;
+	struct mlx5_err_cqe *ecqe;
+	int err;
+	struct mlx5_qp *mqp;
+	struct mlx5_context *mctx;
+	uint8_t is_srq = 0;
 
+	err = mlx5_get_next_cqe(cq, &cqe64, &cqe);
+	if (err == CQ_EMPTY)
+		return err;
+
+	mctx = to_mctx(cq->ibv_cq.context);
 	qpn = ntohl(cqe64->sop_drop_qpn) & 0xffffff;
 	wc->wc_flags = 0;
 	wc->qp_num = qpn;
@@ -602,7 +623,8 @@ static inline int mlx5_poll_one(struct mlx5_cq *cq,
 	case MLX5_CQE_RESP_ERR:
 		srqn_uidx = ntohl(cqe64->srqn_uidx) & 0xffffff;
 		ecqe = (struct mlx5_err_cqe *)cqe64;
-		mlx5_handle_error_cqe(ecqe, wc);
+		mlx5_handle_error_cqe(ecqe, &wc->status);
+		wc->vendor_err = ecqe->vendor_err_synd;
 		if (unlikely(ecqe->syndrome != MLX5_CQE_SYNDROME_WR_FLUSH_ERR &&
 			     ecqe->syndrome != MLX5_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR)) {
 			FILE *fp = mctx->dbg_fp;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
