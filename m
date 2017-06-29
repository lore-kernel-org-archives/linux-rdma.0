From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/7] mlx4: Convert to use predefined get CQE opcodes
Date: Thu, 29 Jun 2017 14:47:06 +0300
Message-ID: <1498736828-17875-6-git-send-email-yishaih@mellanox.com>
References: <1498736828-17875-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498736828-17875-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 068e0d2..50adebb 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -115,7 +115,7 @@ static enum ibv_wc_status mlx4_handle_error_cqe(struct mlx4_err_cqe *cqe)
 static inline void handle_good_req(struct ibv_wc *wc, struct mlx4_cqe *cqe)
 {
 	wc->wc_flags = 0;
-	switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+	switch (mlx4dv_get_cqe_opcode(cqe)) {
 	case MLX4_OPCODE_RDMA_WRITE_IMM:
 		wc->wc_flags |= IBV_WC_WITH_IMM;
 		SWITCH_FALLTHROUGH;
@@ -215,7 +215,7 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
 		wc->qp_num = qpn;
 
 	is_send  = cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
-	is_error = (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) ==
+	is_error = (mlx4dv_get_cqe_opcode(cqe)) ==
 		MLX4_CQE_OPCODE_ERROR;
 
 	if ((qpn & MLX4_XRC_QPN_BIT) && !is_send) {
@@ -278,7 +278,7 @@ static inline int mlx4_parse_cqe(struct mlx4_cq *cq,
 	} else {
 		wc->byte_len = be32toh(cqe->byte_cnt);
 
-		switch (cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		switch (mlx4dv_get_cqe_opcode(cqe)) {
 		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
 			wc->opcode   = IBV_WC_RECV_RDMA_WITH_IMM;
 			wc->wc_flags = IBV_WC_WITH_IMM;
@@ -460,7 +460,7 @@ static enum ibv_wc_opcode mlx4_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
 	if (cq->cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK) {
-		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
 		case MLX4_OPCODE_RDMA_WRITE_IMM:
 		case MLX4_OPCODE_RDMA_WRITE:
 			return IBV_WC_RDMA_WRITE;
@@ -480,7 +480,7 @@ static enum ibv_wc_opcode mlx4_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
 			return IBV_WC_BIND_MW;
 		}
 	} else {
-		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
 		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
 			return IBV_WC_RECV_RDMA_WITH_IMM;
 		case MLX4_RECV_OPCODE_SEND_INVAL:
@@ -507,7 +507,7 @@ static int mlx4_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 	int wc_flags = 0;
 
 	if (is_send) {
-		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
 		case MLX4_OPCODE_RDMA_WRITE_IMM:
 		case MLX4_OPCODE_SEND_IMM:
 			wc_flags |= IBV_WC_WITH_IMM;
@@ -520,7 +520,7 @@ static int mlx4_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
 				htobe32(MLX4_CQE_STATUS_IPV4_CSUM_OK)) <<
 				IBV_WC_IP_CSUM_OK_SHIFT;
 
-		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
 		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
 		case MLX4_RECV_OPCODE_SEND_IMM:
 			wc_flags |= IBV_WC_WITH_IMM;
@@ -554,7 +554,7 @@ static uint32_t mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
 {
 	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
 
-	switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+	switch (mlx4dv_get_cqe_opcode(cq->cqe)) {
 	case MLX4_RECV_OPCODE_SEND_INVAL:
 		return be32toh(cq->cqe->immed_rss_invalid);
 	default:
@@ -756,7 +756,7 @@ void mlx4_cq_resize_copy_cqes(struct mlx4_cq *cq, void *buf, int old_cqe)
 	cqe = get_cqe(cq, (i & old_cqe));
 	cqe += cqe_inc;
 
-	while ((cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) != MLX4_CQE_OPCODE_RESIZE) {
+	while ((mlx4dv_get_cqe_opcode(cqe)) != MLX4_CQE_OPCODE_RESIZE) {
 		cqe->owner_sr_opcode = (cqe->owner_sr_opcode & ~MLX4_CQE_OWNER_MASK) |
 			(((i + 1) & (cq->ibv_cq.cqe + 1)) ? MLX4_CQE_OWNER_MASK : 0);
 		memcpy(buf + ((i + 1) & cq->ibv_cq.cqe) * cq->cqe_size,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
