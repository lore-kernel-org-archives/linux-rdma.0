From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 04/10] mlx4: Refactor mlx4_poll_one
Date: Wed,  1 Feb 2017 09:39:30 +0200
Message-ID: <1485934776-715-5-git-send-email-yishaih@mellanox.com>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since downstream patches aim to provide lazy CQE polling, which
let the user poll the CQE's attributes via inline functions, we
refactor poll_one:
* Return status instead of writing directly to the WC as part of
  handle_error_cqe.
* Introduce mlx4_get_next_cqe which will be used to advance the
  CQE iterator.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c | 88 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 23cc3ed..8f67c90 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -114,7 +114,7 @@ static struct mlx4_cqe *next_cqe_sw(struct mlx4_cq *cq)
 	return get_sw_cqe(cq, cq->cons_index);
 }
 
-static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe, struct ibv_wc *wc)
+static enum ibv_wc_status mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe)
 {
 	if (cqe->syndrome == MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR)
 		printf(PFX "local QP operation err "
@@ -126,64 +126,43 @@ static void mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe, struct ibv_wc *wc)
 
 	switch (cqe->syndrome) {
 	case MLX4_CQE_SYNDROME_LOCAL_LENGTH_ERR:
-		wc->status = IBV_WC_LOC_LEN_ERR;
-		break;
+		return IBV_WC_LOC_LEN_ERR;
 	case MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR:
-		wc->status = IBV_WC_LOC_QP_OP_ERR;
-		break;
+		return IBV_WC_LOC_QP_OP_ERR;
 	case MLX4_CQE_SYNDROME_LOCAL_PROT_ERR:
-		wc->status = IBV_WC_LOC_PROT_ERR;
-		break;
+		return IBV_WC_LOC_PROT_ERR;
 	case MLX4_CQE_SYNDROME_WR_FLUSH_ERR:
-		wc->status = IBV_WC_WR_FLUSH_ERR;
-		break;
+		return IBV_WC_WR_FLUSH_ERR;
 	case MLX4_CQE_SYNDROME_MW_BIND_ERR:
-		wc->status = IBV_WC_MW_BIND_ERR;
-		break;
+		return IBV_WC_MW_BIND_ERR;
 	case MLX4_CQE_SYNDROME_BAD_RESP_ERR:
-		wc->status = IBV_WC_BAD_RESP_ERR;
-		break;
+		return IBV_WC_BAD_RESP_ERR;
 	case MLX4_CQE_SYNDROME_LOCAL_ACCESS_ERR:
-		wc->status = IBV_WC_LOC_ACCESS_ERR;
-		break;
+		return IBV_WC_LOC_ACCESS_ERR;
 	case MLX4_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR:
-		wc->status = IBV_WC_REM_INV_REQ_ERR;
-		break;
+		return IBV_WC_REM_INV_REQ_ERR;
 	case MLX4_CQE_SYNDROME_REMOTE_ACCESS_ERR:
-		wc->status = IBV_WC_REM_ACCESS_ERR;
-		break;
+		return IBV_WC_REM_ACCESS_ERR;
 	case MLX4_CQE_SYNDROME_REMOTE_OP_ERR:
-		wc->status = IBV_WC_REM_OP_ERR;
-		break;
+		return IBV_WC_REM_OP_ERR;
 	case MLX4_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RETRY_EXC_ERR;
-		break;
+		return IBV_WC_RETRY_EXC_ERR;
 	case MLX4_CQE_SYNDROME_RNR_RETRY_EXC_ERR:
-		wc->status = IBV_WC_RNR_RETRY_EXC_ERR;
-		break;
+		return IBV_WC_RNR_RETRY_EXC_ERR;
 	case MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR:
-		wc->status = IBV_WC_REM_ABORT_ERR;
-		break;
+		return IBV_WC_REM_ABORT_ERR;
 	default:
-		wc->status = IBV_WC_GENERAL_ERR;
-		break;
+		return IBV_WC_GENERAL_ERR;
 	}
-
-	wc->vendor_err = cqe->vendor_err;
 }
 
-static int mlx4_poll_one(struct mlx4_cq *cq,
-			 struct mlx4_qp **cur_qp,
-			 struct ibv_wc *wc)
+static inline int mlx4_get_next_cqe(struct mlx4_cq *cq,
+				    struct mlx4_cqe **pcqe)
+				    ALWAYS_INLINE;
+static inline int mlx4_get_next_cqe(struct mlx4_cq *cq,
+				    struct mlx4_cqe **pcqe)
 {
-	struct mlx4_wq *wq;
 	struct mlx4_cqe *cqe;
-	struct mlx4_srq *srq;
-	uint32_t qpn;
-	uint32_t g_mlpath_rqpn;
-	uint16_t wqe_index;
-	int is_error;
-	int is_send;
 
 	cqe = next_cqe_sw(cq);
 	if (!cqe)
@@ -202,6 +181,28 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	 */
 	rmb();
 
+	*pcqe = cqe;
+
+	return CQ_OK;
+}
+
+static int mlx4_poll_one(struct mlx4_cq *cq,
+			 struct mlx4_qp **cur_qp,
+			 struct ibv_wc *wc)
+{
+	struct mlx4_wq *wq;
+	struct mlx4_cqe *cqe;
+	struct mlx4_srq *srq;
+	uint32_t qpn;
+	uint32_t g_mlpath_rqpn;
+	uint16_t wqe_index;
+	struct mlx4_err_cqe *ecqe;
+	int is_error;
+	int is_send;
+
+	if  (mlx4_get_next_cqe(cq, &cqe) == CQ_EMPTY)
+		return CQ_EMPTY;
+
 	qpn = ntohl(cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;
 	wc->qp_num = qpn;
 
@@ -250,7 +251,10 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 	}
 
 	if (is_error) {
-		mlx4_handle_error_cqe((struct mlx4_err_cqe *) cqe, wc);
+		ecqe = (struct mlx4_err_cqe *)cqe;
+		wc->status = mlx4_handle_error_cqe(ecqe);
+		wc->vendor_err = ecqe->vendor_err;
+
 		return CQ_OK;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
