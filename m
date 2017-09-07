From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/3] mlx5: Add support for sending UD packets with source QPN
Date: Thu,  7 Sep 2017 15:12:07 +0300
Message-ID: <1504786327-820-4-git-send-email-yishaih@mellanox.com>
References: <1504786327-820-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504786327-820-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It includes:
- Update WQE size to match the addition required segments.
- Build a proper packet as part of the post send flow.

The specific IPoIB handling as of copying from the application gather
data into the header is some device limitation to support sending IPoIB
packets. This is not required in the general case but will work as well.
Future devices may work properly without that need, once be ready we may
have some device capability exposed from kernel and clean this specific
handling.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/qp.c    | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++
 providers/mlx5/verbs.c | 10 +++++---
 providers/mlx5/wqe.h   |  6 +++++
 3 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index 2960ba0..d5e677f 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -604,6 +604,63 @@ static inline int set_tso_eth_seg(void **seg, struct ibv_send_wr *wr,
 	return 0;
 }
 
+static inline int mlx5_post_send_underlay(struct mlx5_qp *qp, struct ibv_send_wr *wr,
+					  void **pseg, int *total_size,
+					  struct mlx5_sg_copy_ptr *sg_copy_ptr)
+{
+	struct mlx5_wqe_eth_seg *eseg;
+	int inl_hdr_copy_size;
+	void *seg = *pseg;
+	int size = 0;
+
+	if (unlikely(wr->opcode == IBV_WR_SEND_WITH_IMM))
+		return EINVAL;
+
+	memset(seg, 0, sizeof(struct mlx5_wqe_eth_pad));
+	size += sizeof(struct mlx5_wqe_eth_pad);
+	seg += sizeof(struct mlx5_wqe_eth_pad);
+	eseg = seg;
+	*((uint64_t *)eseg) = 0;
+	eseg->rsvd2 = 0;
+
+	if (wr->send_flags & IBV_SEND_IP_CSUM) {
+		if (!(qp->qp_cap_cache & MLX5_CSUM_SUPPORT_UNDERLAY_UD))
+			return EINVAL;
+
+		eseg->cs_flags |= MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
+	}
+
+	if (likely(wr->sg_list[0].length >= MLX5_SOURCE_QPN_INLINE_MAX_HEADER_SIZE))
+		/* Copying the minimum required data unless inline mode is set */
+		inl_hdr_copy_size = (wr->send_flags & IBV_SEND_INLINE) ?
+				MLX5_SOURCE_QPN_INLINE_MAX_HEADER_SIZE :
+				MLX5_IPOIB_INLINE_MIN_HEADER_SIZE;
+	else {
+		inl_hdr_copy_size = MLX5_IPOIB_INLINE_MIN_HEADER_SIZE;
+		/* We expect at least 4 bytes as part of first entry to hold the IPoIB header */
+		if (unlikely(wr->sg_list[0].length < inl_hdr_copy_size))
+			return EINVAL;
+	}
+
+	memcpy(eseg->inline_hdr_start, (void *)(uintptr_t)wr->sg_list[0].addr,
+	       inl_hdr_copy_size);
+	eseg->inline_hdr_sz = htobe16(inl_hdr_copy_size);
+	size += sizeof(struct mlx5_wqe_eth_seg);
+	seg += sizeof(struct mlx5_wqe_eth_seg);
+
+	/* If we copied all the sge into the inline-headers, then we need to
+	 * start copying from the next sge into the data-segment.
+	 */
+	if (unlikely(wr->sg_list[0].length == inl_hdr_copy_size))
+		sg_copy_ptr->index++;
+	else
+		sg_copy_ptr->offset = inl_hdr_copy_size;
+
+	*pseg = seg;
+	*total_size += (size / 16);
+	return 0;
+}
+
 static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				  struct ibv_send_wr **bad_wr)
 {
@@ -806,6 +863,14 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			size += sizeof(struct mlx5_wqe_datagram_seg) / 16;
 			if (unlikely((seg == qend)))
 				seg = mlx5_get_send_wqe(qp, 0);
+
+			if (unlikely(qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY)) {
+				err = mlx5_post_send_underlay(qp, wr, &seg, &size, &sg_copy_ptr);
+				if (unlikely(err)) {
+					*bad_wr = wr;
+					goto out;
+				}
+			}
 			break;
 
 		case IBV_QPT_RAW_PACKET:
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index a469c93..5a360a9 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -756,7 +756,7 @@ int mlx5_destroy_srq(struct ibv_srq *srq)
 	return 0;
 }
 
-static int sq_overhead(enum ibv_qp_type	qp_type)
+static int sq_overhead(struct mlx5_qp *qp, enum ibv_qp_type qp_type)
 {
 	size_t size = 0;
 	size_t mw_bind_size =
@@ -781,6 +781,10 @@ static int sq_overhead(enum ibv_qp_type	qp_type)
 	case IBV_QPT_UD:
 		size = sizeof(struct mlx5_wqe_ctrl_seg) +
 			sizeof(struct mlx5_wqe_datagram_seg);
+
+		if (qp->flags & MLX5_QP_FLAGS_USE_UNDERLAY)
+			size += (sizeof(struct mlx5_wqe_eth_seg) + sizeof(struct mlx5_wqe_eth_pad));
+
 		break;
 
 	case IBV_QPT_XRC_SEND:
@@ -814,7 +818,7 @@ static int mlx5_calc_send_wqe(struct mlx5_context *ctx,
 	int max_gather;
 	int tot_size;
 
-	size = sq_overhead(attr->qp_type);
+	size = sq_overhead(qp, attr->qp_type);
 	if (size < 0)
 		return size;
 
@@ -887,7 +891,7 @@ static int mlx5_calc_sq_size(struct mlx5_context *ctx,
 		return -EINVAL;
 	}
 
-	qp->max_inline_data = wqe_size - sq_overhead(attr->qp_type) -
+	qp->max_inline_data = wqe_size - sq_overhead(qp, attr->qp_type) -
 		sizeof(struct mlx5_wqe_inl_data_seg);
 	attr->cap.max_inline_data = qp->max_inline_data;
 
diff --git a/providers/mlx5/wqe.h b/providers/mlx5/wqe.h
index 063dc9a..5bf536c 100644
--- a/providers/mlx5/wqe.h
+++ b/providers/mlx5/wqe.h
@@ -50,6 +50,10 @@ struct mlx5_eqe_qp_srq {
 	uint32_t	qp_srq_n;
 };
 
+struct mlx5_wqe_eth_pad {
+	uint8_t rsvd0[16];
+};
+
 struct mlx5_wqe_xrc_seg {
 	__be32		xrc_srqn;
 	uint8_t		rsvd[12];
@@ -63,6 +67,8 @@ struct mlx5_wqe_masked_atomic_seg {
 };
 
 enum {
+	MLX5_IPOIB_INLINE_MIN_HEADER_SIZE	= 4,
+	MLX5_SOURCE_QPN_INLINE_MAX_HEADER_SIZE	= 18,
 	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
 	MLX5_ETH_L2_MIN_HEADER_SIZE	= 14,
 };
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
