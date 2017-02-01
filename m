From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 06/10] mlx4: Add inline functions to read completion's attributes
Date: Wed,  1 Feb 2017 09:39:32 +0200
Message-ID: <1485934776-715-7-git-send-email-yishaih@mellanox.com>
References: <1485934776-715-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485934776-715-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add inline functions in order to read various completion's
attributes. These functions will be assigned in the ibv_cq_ex
structure in order to allow the user to read the completion's
attributes.

Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx4/cq.c   | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++
 providers/mlx4/mlx4.h |  13 +++--
 2 files changed, 157 insertions(+), 3 deletions(-)

diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
index 6c4b3c4..dc5e8b6 100644
--- a/providers/mlx4/cq.c
+++ b/providers/mlx4/cq.c
@@ -416,6 +416,153 @@ int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
 	return err == CQ_POLL_ERR ? err : npolled;
 }
 
+static enum ibv_wc_opcode mlx4_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	if (cq->cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK) {
+		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_OPCODE_RDMA_WRITE_IMM:
+		case MLX4_OPCODE_RDMA_WRITE:
+			return IBV_WC_RDMA_WRITE;
+		case MLX4_OPCODE_SEND_INVAL:
+		case MLX4_OPCODE_SEND_IMM:
+		case MLX4_OPCODE_SEND:
+			return IBV_WC_SEND;
+		case MLX4_OPCODE_RDMA_READ:
+			return IBV_WC_RDMA_READ;
+		case MLX4_OPCODE_ATOMIC_CS:
+			return IBV_WC_COMP_SWAP;
+		case MLX4_OPCODE_ATOMIC_FA:
+			return IBV_WC_FETCH_ADD;
+		case MLX4_OPCODE_LOCAL_INVAL:
+			return IBV_WC_LOCAL_INV;
+		case MLX4_OPCODE_BIND_MW:
+			return IBV_WC_BIND_MW;
+		}
+	} else {
+		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
+			return IBV_WC_RECV_RDMA_WITH_IMM;
+		case MLX4_RECV_OPCODE_SEND_INVAL:
+		case MLX4_RECV_OPCODE_SEND_IMM:
+		case MLX4_RECV_OPCODE_SEND:
+			return IBV_WC_RECV;
+		}
+	}
+
+	return 0;
+}
+
+static uint32_t mlx4_cq_read_wc_qp_num(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohl(cq->cqe->vlan_my_qpn) & MLX4_CQE_QPN_MASK;
+}
+
+static int mlx4_cq_read_wc_flags(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	int is_send  = cq->cqe->owner_sr_opcode & MLX4_CQE_IS_SEND_MASK;
+	int wc_flags = 0;
+
+	if (is_send) {
+		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_OPCODE_RDMA_WRITE_IMM:
+		case MLX4_OPCODE_SEND_IMM:
+			wc_flags |= IBV_WC_WITH_IMM;
+			break;
+		}
+	} else {
+		if (cq->flags & MLX4_CQ_FLAGS_RX_CSUM_VALID)
+			wc_flags |= ((cq->cqe->status &
+				htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) ==
+				htonl(MLX4_CQE_STATUS_IPV4_CSUM_OK)) <<
+				IBV_WC_IP_CSUM_OK_SHIFT;
+
+		switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+		case MLX4_RECV_OPCODE_RDMA_WRITE_IMM:
+		case MLX4_RECV_OPCODE_SEND_IMM:
+			wc_flags |= IBV_WC_WITH_IMM;
+			break;
+		case MLX4_RECV_OPCODE_SEND_INVAL:
+			wc_flags |= IBV_WC_WITH_INV;
+			break;
+		}
+		wc_flags |= (ntohl(cq->cqe->g_mlpath_rqpn) & 0x80000000) ? IBV_WC_GRH : 0;
+	}
+
+	return wc_flags;
+}
+
+static uint32_t mlx4_cq_read_wc_byte_len(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohl(cq->cqe->byte_cnt);
+}
+
+static uint32_t mlx4_cq_read_wc_vendor_err(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+	struct mlx4_err_cqe *ecqe = (struct mlx4_err_cqe *)cq->cqe;
+
+	return ecqe->vendor_err;
+}
+
+static uint32_t mlx4_cq_read_wc_imm_data(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	switch (cq->cqe->owner_sr_opcode & MLX4_CQE_OPCODE_MASK) {
+	case MLX4_RECV_OPCODE_SEND_INVAL:
+		return ntohl(cq->cqe->immed_rss_invalid);
+	default:
+		return cq->cqe->immed_rss_invalid;
+	}
+}
+
+static uint32_t mlx4_cq_read_wc_slid(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return (uint32_t)ntohs(cq->cqe->rlid);
+}
+
+static uint8_t mlx4_cq_read_wc_sl(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	if ((cq->cur_qp) && (cq->cur_qp->link_layer == IBV_LINK_LAYER_ETHERNET))
+		return ntohs(cq->cqe->sl_vid) >> 13;
+	else
+		return ntohs(cq->cqe->sl_vid) >> 12;
+}
+
+static uint32_t mlx4_cq_read_wc_src_qp(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ntohl(cq->cqe->g_mlpath_rqpn) & 0xffffff;
+}
+
+static uint8_t mlx4_cq_read_wc_dlid_path_bits(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return (ntohl(cq->cqe->g_mlpath_rqpn) >> 24) & 0x7f;
+}
+
+static uint64_t mlx4_cq_read_wc_completion_ts(struct ibv_cq_ex *ibcq)
+{
+	struct mlx4_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
+
+	return ((uint64_t)ntohl(cq->cqe->ts_47_16) << 16) |
+			       (cq->cqe->ts_15_8   <<  8) |
+			       (cq->cqe->ts_7_0);
+}
+
 int mlx4_arm_cq(struct ibv_cq *ibvcq, int solicited)
 {
 	struct mlx4_cq *cq = to_mcq(ibvcq);
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index e9b0230..25b009b 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -272,13 +272,20 @@ struct mlx4_cqe {
 	uint32_t	vlan_my_qpn;
 	uint32_t	immed_rss_invalid;
 	uint32_t	g_mlpath_rqpn;
-	uint16_t	sl_vid;
-	uint16_t	rlid;
+	union {
+		struct {
+			uint16_t	sl_vid;
+			uint16_t	rlid;
+		};
+		uint32_t ts_47_16;
+	};
 	uint32_t	status;
 	uint32_t	byte_cnt;
 	uint16_t	wqe_index;
 	uint16_t	checksum;
-	uint8_t		reserved3[3];
+	uint8_t		reserved3;
+	uint8_t		ts_15_8;
+	uint8_t		ts_7_0;
 	uint8_t		owner_sr_opcode;
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
