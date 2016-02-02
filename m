From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 v2 7/7] Add Raw Packet QP data-path functionality
Date: Tue,  2 Feb 2016 21:29:51 +0200
Message-ID: <1454441391-30494-8-git-send-email-majd@mellanox.com>
References: <1454441391-30494-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454441391-30494-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Raw Ethernet WQE is composed of the following segments:
1. Control segment
2. Eth segment
3. Data segment

The Eth segment contains packet headers and information for stateless
offloading. When posting a Raw Ethernet WQE, the library should copy
the L2 headers into the Eth segment, otherwise the packet is dropped
in the TX. The Data segment should include all the payload except the
headers that were copied to the Eth segment.

Raw Packet QP is composed of RQ and SQ in the hardware. Once the QP's
state is modified to INIT, the RQ is already in RDY state and thus
can receive packets. To avoid this behavior that contradicts the IB
spec, we don't update the doorbell record as long as the QP isn't in
RTR state, and once the QP is modified to RTR, the doorbell record is
update, which allows receiving packets.

Reviewed-by:: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/qp.c  | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 src/wqe.h |   9 +++++
 2 files changed, 110 insertions(+), 13 deletions(-)

diff --git a/src/qp.c b/src/qp.c
index 8556714..60f2bdc 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -188,11 +188,12 @@ static void set_datagram_seg(struct mlx5_wqe_datagram_seg *dseg,
 	dseg->av.key.qkey.qkey = htonl(wr->wr.ud.remote_qkey);
 }
 
-static void set_data_ptr_seg(struct mlx5_wqe_data_seg *dseg, struct ibv_sge *sg)
+static void set_data_ptr_seg(struct mlx5_wqe_data_seg *dseg, struct ibv_sge *sg,
+			     int offset)
 {
-	dseg->byte_count = htonl(sg->length);
+	dseg->byte_count = htonl(sg->length - offset);
 	dseg->lkey       = htonl(sg->lkey);
-	dseg->addr       = htonll(sg->addr);
+	dseg->addr       = htonll(sg->addr + offset);
 }
 
 /*
@@ -230,7 +231,8 @@ static uint32_t send_ieth(struct ibv_send_wr *wr)
 }
 
 static int set_data_inl_seg(struct mlx5_qp *qp, struct ibv_send_wr *wr,
-			    void *wqe, int *sz)
+			    void *wqe, int *sz,
+			    struct mlx5_sg_copy_ptr *sg_copy_ptr)
 {
 	struct mlx5_wqe_inline_seg *seg;
 	void *addr;
@@ -239,13 +241,15 @@ static int set_data_inl_seg(struct mlx5_qp *qp, struct ibv_send_wr *wr,
 	int inl = 0;
 	void *qend = qp->sq.qend;
 	int copy;
+	int offset = sg_copy_ptr->offset;
 
 	seg = wqe;
 	wqe += sizeof *seg;
-	for (i = 0; i < wr->num_sge; ++i) {
-		addr = (void *) (unsigned long)(wr->sg_list[i].addr);
-		len  = wr->sg_list[i].length;
+	for (i = sg_copy_ptr->index; i < wr->num_sge; ++i) {
+		addr = (void *) (unsigned long)(wr->sg_list[i].addr + offset);
+		len  = wr->sg_list[i].length - offset;
 		inl += len;
+		offset = 0;
 
 		if (unlikely(inl > qp->max_inline_data)) {
 			errno = ENOMEM;
@@ -317,6 +321,63 @@ void *mlx5_get_atomic_laddr(struct mlx5_qp *qp, uint16_t idx, int *byte_count)
 	return addr;
 }
 
+static inline int copy_eth_inline_headers(struct ibv_qp *ibqp,
+					  struct ibv_send_wr *wr,
+					  struct mlx5_wqe_eth_seg *eseg,
+					  struct mlx5_sg_copy_ptr *sg_copy_ptr)
+{
+	int inl_hdr_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
+	int inl_hdr_copy_size = 0;
+	int j = 0;
+#ifdef MLX5_DEBUG
+	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
+#endif
+
+	if (unlikely(wr->num_sge < 1)) {
+		mlx5_dbg(fp, MLX5_DBG_QP_SEND, "illegal num_sge: %d, minimum is 1\n",
+			 wr->num_sge);
+		return EINVAL;
+	}
+
+	if (likely(wr->sg_list[0].length >= MLX5_ETH_L2_INLINE_HEADER_SIZE)) {
+		inl_hdr_copy_size = MLX5_ETH_L2_INLINE_HEADER_SIZE;
+		memcpy(eseg->inline_hdr_start,
+		       (void *)(uintptr_t)wr->sg_list[0].addr,
+		       inl_hdr_copy_size);
+	} else {
+		for (j = 0; j < wr->num_sge && inl_hdr_size > 0; ++j) {
+			inl_hdr_copy_size = min(wr->sg_list[j].length,
+						inl_hdr_size);
+			memcpy(eseg->inline_hdr_start +
+			       (MLX5_ETH_L2_INLINE_HEADER_SIZE - inl_hdr_size),
+			       (void *)(uintptr_t)wr->sg_list[j].addr,
+			       inl_hdr_copy_size);
+			inl_hdr_size -= inl_hdr_copy_size;
+		}
+		if (unlikely(inl_hdr_size)) {
+			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "Ethernet headers < 16 bytes\n");
+			return EINVAL;
+		}
+		--j;
+	}
+
+
+	eseg->inline_hdr_sz = htons(MLX5_ETH_L2_INLINE_HEADER_SIZE);
+
+	/* If we copied all the sge into the inline-headers, then we need to
+	 * start copying from the next sge into the data-segment.
+	 */
+	if (unlikely(wr->sg_list[j].length == inl_hdr_copy_size)) {
+		++j;
+		inl_hdr_copy_size = 0;
+	}
+
+	sg_copy_ptr->index = j;
+	sg_copy_ptr->offset = inl_hdr_copy_size;
+
+	return 0;
+}
+
 int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			  struct ibv_send_wr **bad_wr)
 {
@@ -325,6 +386,7 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	void *seg;
 	struct mlx5_wqe_ctrl_seg *ctrl = NULL;
 	struct mlx5_wqe_data_seg *dpseg;
+	struct mlx5_sg_copy_ptr sg_copy_ptr = {.index = 0, .offset = 0};
 	int nreq;
 	int inl = 0;
 	int err = 0;
@@ -438,6 +500,22 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				seg = mlx5_get_send_wqe(qp, 0);
 			break;
 
+		case IBV_QPT_RAW_PACKET:
+			memset(seg, 0, sizeof(struct mlx5_wqe_eth_seg));
+
+			err = copy_eth_inline_headers(ibqp, wr, seg, &sg_copy_ptr);
+			if (unlikely(err)) {
+				*bad_wr = wr;
+				mlx5_dbg(fp, MLX5_DBG_QP_SEND,
+					 "copy_eth_inline_headers failed, err: %d\n",
+					 err);
+				goto out;
+			}
+
+			seg += sizeof(struct mlx5_wqe_eth_seg);
+			size += sizeof(struct mlx5_wqe_eth_seg) / 16;
+			break;
+
 		default:
 			break;
 		}
@@ -445,7 +523,7 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		if (wr->send_flags & IBV_SEND_INLINE && wr->num_sge) {
 			int uninitialized_var(sz);
 
-			err = set_data_inl_seg(qp, wr, seg, &sz);
+			err = set_data_inl_seg(qp, wr, seg, &sz, &sg_copy_ptr);
 			if (unlikely(err)) {
 				*bad_wr = wr;
 				mlx5_dbg(fp, MLX5_DBG_QP_SEND,
@@ -456,13 +534,15 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 			size += sz;
 		} else {
 			dpseg = seg;
-			for (i = 0; i < wr->num_sge; ++i) {
+			for (i = sg_copy_ptr.index; i < wr->num_sge; ++i) {
 				if (unlikely(dpseg == qend)) {
 					seg = mlx5_get_send_wqe(qp, 0);
 					dpseg = seg;
 				}
 				if (likely(wr->sg_list[i].length)) {
-					set_data_ptr_seg(dpseg, wr->sg_list + i);
+					set_data_ptr_seg(dpseg, wr->sg_list + i,
+							 sg_copy_ptr.offset);
+					sg_copy_ptr.offset = 0;
 					++dpseg;
 					size += sizeof(struct mlx5_wqe_data_seg) / 16;
 				}
@@ -586,7 +666,7 @@ int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		for (i = 0, j = 0; i < wr->num_sge; ++i) {
 			if (unlikely(!wr->sg_list[i].length))
 				continue;
-			set_data_ptr_seg(scat + j++, wr->sg_list + i);
+			set_data_ptr_seg(scat + j++, wr->sg_list + i, 0);
 		}
 
 		if (j < qp->rq.max_gs) {
@@ -613,8 +693,16 @@ out:
 		 * doorbell record.
 		 */
 		wmb();
-
-		qp->db[MLX5_RCV_DBR] = htonl(qp->rq.head & 0xffff);
+		/*
+		 * For Raw Packet QP, avoid updating the doorbell record
+		 * as long as the QP isn't in RTR state, to avoid receiving
+		 * packets in illegal states.
+		 * This is only for Raw Packet QPs since they are represented
+		 * differently in the hardware.
+		 */
+		if (likely(!(ibqp->qp_type == IBV_QPT_RAW_PACKET &&
+			     ibqp->state < IBV_QPS_RTR)))
+			qp->db[MLX5_RCV_DBR] = htonl(qp->rq.head & 0xffff);
 	}
 
 	mlx5_spin_unlock(&qp->rq.lock);
diff --git a/src/wqe.h b/src/wqe.h
index b875104..eaaf7a6 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -60,6 +60,11 @@ struct mlx5_wqe_data_seg {
 	uint64_t		addr;
 };
 
+struct mlx5_sg_copy_ptr {
+	int	index;
+	int	offset;
+};
+
 struct mlx5_eqe_comp {
 	uint32_t	reserved[6];
 	uint32_t	cqn;
@@ -70,6 +75,10 @@ struct mlx5_eqe_qp_srq {
 	uint32_t	qp_srq_n;
 };
 
+enum {
+	MLX5_ETH_L2_INLINE_HEADER_SIZE	= 18,
+};
+
 struct mlx5_wqe_eth_seg {
 	uint32_t	rsvd0;
 	uint8_t		cs_flags;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
