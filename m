From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 5/7] mlx5: Convert to use predefined get CQE opcodes
Date: Sun, 12 Feb 2017 16:16:50 +0200
Message-ID: <1486909012-15064-6-git-send-email-yishaih@mellanox.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486909012-15064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/cq.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/providers/mlx5/cq.c b/providers/mlx5/cq.c
index 88bca75..d14d956 100644
--- a/providers/mlx5/cq.c
+++ b/providers/mlx5/cq.c
@@ -87,7 +87,7 @@ static void *get_sw_cqe(struct mlx5_cq *cq, int n)
 
 	cqe64 = (cq->cqe_sz == 64) ? cqe : cqe + 64;
 
-	if (likely((cqe64->op_own) >> 4 != MLX5_CQE_INVALID) &&
+	if (likely(mlx5dv_get_cqe_opcode(cqe64) != MLX5_CQE_INVALID) &&
 	    !((cqe64->op_own & MLX5_CQE_OWNER_MASK) ^ !!(n & (cq->ibv_cq.cqe + 1)))) {
 		return cqe;
 	} else {
@@ -547,7 +547,7 @@ static inline int mlx5_parse_cqe(struct mlx5_cq *cq,
 		wc->qp_num = qpn;
 	}
 
-	opcode = cqe64->op_own >> 4;
+	opcode = mlx5dv_get_cqe_opcode(cqe64);
 	switch (opcode) {
 	case MLX5_CQE_REQ:
 	{
@@ -1056,7 +1056,7 @@ static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
-	switch (cq->cqe64->op_own >> 4) {
+	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_WR_IMM:
 		return IBV_WC_RECV_RDMA_WITH_IMM;
 	case MLX5_CQE_RESP_SEND:
@@ -1114,7 +1114,7 @@ static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
 				IBV_WC_IP_CSUM_OK_SHIFT;
 
-	switch (cq->cqe64->op_own >> 4) {
+	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_WR_IMM:
 	case MLX5_CQE_RESP_SEND_IMM:
 		wc_flags	|= IBV_WC_WITH_IMM;
@@ -1147,7 +1147,7 @@ static inline uint32_t mlx5_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
 {
 	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
-	switch (cq->cqe64->op_own >> 4) {
+	switch (mlx5dv_get_cqe_opcode(cq->cqe64)) {
 	case MLX5_CQE_RESP_SEND_INV:
 		return ntohl(cq->cqe64->imm_inval_pkey);
 	default:
@@ -1329,7 +1329,7 @@ static inline int free_res_cqe(struct mlx5_cqe64 *cqe64, uint32_t rsn,
 {
 	if (cqe_version) {
 		if (is_equal_uidx(cqe64, rsn)) {
-			if (srq && is_responder(cqe64->op_own >> 4))
+			if (srq && is_responder(mlx5dv_get_cqe_opcode(cqe64)))
 				mlx5_free_srq_wqe(srq,
 						  ntohs(cqe64->wqe_counter));
 			return 1;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
