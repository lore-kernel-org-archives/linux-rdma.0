From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libmlx5 3/7] Add inline functions to read completion's attributes
Date: Tue,  7 Jun 2016 15:11:35 +0300
Message-ID: <1465301499-21234-4-git-send-email-yishaih@mellanox.com>
References: <1465301499-21234-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465301499-21234-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add inline functions in order to read various completion's
attributes. These functions will be assigned in the ibv_cq_ex
structure in order to allow the user to read the completion's
attributes.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/src/cq.c b/src/cq.c
index a76fed3..d3bd006 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -841,6 +841,133 @@ int mlx5_poll_cq_v1(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	return poll_cq(ibcq, ne, wc, 1);
 }
 
+static inline enum ibv_wc_opcode mlx5_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	switch (cq->cqe64->op_own >> 4) {
+	case MLX5_CQE_RESP_WR_IMM:
+		return IBV_WC_RECV_RDMA_WITH_IMM;
+	case MLX5_CQE_RESP_SEND:
+	case MLX5_CQE_RESP_SEND_IMM:
+		return IBV_WC_RECV;
+	case MLX5_CQE_REQ:
+		switch (ntohl(cq->cqe64->sop_drop_qpn) >> 24) {
+		case MLX5_OPCODE_RDMA_WRITE_IMM:
+		case MLX5_OPCODE_RDMA_WRITE:
+			return IBV_WC_RDMA_WRITE;
+		case MLX5_OPCODE_SEND_IMM:
+		case MLX5_OPCODE_SEND:
+		case MLX5_OPCODE_SEND_INVAL:
+			return IBV_WC_SEND;
+		case MLX5_OPCODE_RDMA_READ:
+			return IBV_WC_RDMA_READ;
+		case MLX5_OPCODE_ATOMIC_CS:
+			return IBV_WC_COMP_SWAP;
+		case MLX5_OPCODE_ATOMIC_FA:
+			return IBV_WC_FETCH_ADD;
+		case MLX5_OPCODE_BIND_MW:
+			return IBV_WC_BIND_MW;
+		}
+	}
+
+#ifdef MLX5_DEBUG
+{
+	struct mlx5_context *ctx = to_mctx(ibcq->context);
+
+	mlx5_dbg(ctx->dbg_fp, MLX5_DBG_CQ_CQE, "un-expected opcode in cqe\n");
+}
+#endif
+	return 0;
+}
+
+static inline uint32_t mlx5_cq_read_wc_qp_num(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohl(cq->cqe64->sop_drop_qpn) & 0xffffff;
+}
+
+static inline int mlx5_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	int wc_flags = 0;
+
+	if (cq->flags & MLX5_CQ_FLAGS_RX_CSUM_VALID)
+		wc_flags = (!!(cq->cqe64->hds_ip_ext & MLX5_CQE_L4_OK) &
+				 !!(cq->cqe64->hds_ip_ext & MLX5_CQE_L3_OK) &
+				 (get_cqe_l3_hdr_type(cq->cqe64) ==
+				  MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
+				IBV_WC_IP_CSUM_OK_SHIFT;
+
+	switch (cq->cqe64->op_own >> 4) {
+	case MLX5_CQE_RESP_WR_IMM:
+	case MLX5_CQE_RESP_SEND_IMM:
+		wc_flags	|= IBV_WC_WITH_IMM;
+		break;
+	}
+
+	wc_flags |= ((ntohl(cq->cqe64->flags_rqpn) >> 28) & 3) ? IBV_WC_GRH : 0;
+	return wc_flags;
+}
+
+static inline uint32_t mlx5_cq_read_wc_byte_len(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohl(cq->cqe64->byte_cnt);
+}
+
+static inline uint32_t mlx5_cq_read_wc_vendor_err(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	struct mlx5_err_cqe *ecqe = (struct mlx5_err_cqe *)cq->cqe64;
+
+	return ecqe->vendor_err_synd;
+}
+
+static inline uint32_t mlx5_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return cq->cqe64->imm_inval_pkey;
+}
+
+static inline uint32_t mlx5_cq_read_wc_slid(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return (uint32_t)ntohs(cq->cqe64->slid);
+}
+
+static inline uint8_t mlx5_cq_read_wc_sl(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return (ntohl(cq->cqe64->flags_rqpn) >> 24) & 0xf;
+}
+
+static inline uint32_t mlx5_cq_read_wc_src_qp(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohl(cq->cqe64->flags_rqpn) & 0xffffff;
+}
+
+static inline uint8_t mlx5_cq_read_wc_dlid_path_bits(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return cq->cqe64->ml_path & 0x7f;
+}
+
+static inline uint64_t mlx5_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
+{
+	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohll(cq->cqe64->timestamp);
+}
+
 int mlx5_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx5_cq *cq = to_mcq(ibvcq);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
