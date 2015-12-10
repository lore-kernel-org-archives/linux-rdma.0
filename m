From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Add Raw Packet Queue Pair (QP) support
Date: Thu, 10 Dec 2015 21:55:16 +0200
Message-ID: <1449777316-9663-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. Add support for RAW Packet WQEs in the  post send.
2. Allocate different buffers for RQ and SQ to ensure
   alignment of the SQ buffer.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Eli,

This patch adds support for Raw Packet QP in libmlx5.

Raw Packet QP enables the user to send and receive raw packets. The user is
responsible of building the packet including the headers.

Since the SQ and RQ work-queue (WQ) buffers are not contiguous like
other QPs, we allocate separate buffers and pass them to the kernel
driver.

The added support in post send includes building the WQE according
to the hardware requirements.

This patch depends on "Support CQE versions" series.

Regards,
Majd

 src/mlx5-abi.h |   2 ++
 src/mlx5.h     |   4 +++
 src/qp.c       | 100 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 src/verbs.c    |  73 +++++++++++++++++++++++++++++++++++------
 src/wqe.h      |  25 +++++++++++++++
 5 files changed, 180 insertions(+), 24 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 21f576e..e68a328 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -124,6 +124,8 @@ struct mlx5_create_qp {
 	__u32				flags;
 	__u32                           uidx;
 	__u32                           reserved;
+	/* SQ buffer address - used for Raw Packet QP */
+	__u64                           sq_buf_addr;
 };
 
 struct mlx5_create_qp_resp {
diff --git a/src/mlx5.h b/src/mlx5.h
index 9561417..0b06a1f 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -428,8 +428,12 @@ struct mlx5_qp {
 	struct verbs_qp			verbs_qp;
 	struct ibv_qp			ibv_qp;
 	struct mlx5_buf                 buf;
+	void				*sqstart;
 	int                             max_inline_data;
 	int                             buf_size;
+	/* For Raw Packet QP, use different buffers for the SQ and RQ */
+	struct mlx5_buf                 sq_buf;
+	int				sq_buf_size;
 	struct mlx5_bf		       *bf;
 
 	uint8_t	                        sq_signal_bits;
diff --git a/src/qp.c b/src/qp.c
index eeb0c92..5ff1f00 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -145,7 +145,7 @@ int mlx5_copy_to_send_wqe(struct mlx5_qp *qp, int idx, void *buf, int size)
 
 void *mlx5_get_send_wqe(struct mlx5_qp *qp, int n)
 {
-	return qp->buf.buf + qp->sq.offset + (n << MLX5_SEND_WQE_SHIFT);
+	return qp->sqstart + (n << MLX5_SEND_WQE_SHIFT);
 }
 
 void mlx5_init_qp_indices(struct mlx5_qp *qp)
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
@@ -214,7 +215,7 @@ static void mlx5_bf_copy(unsigned long long *dst, unsigned long long *src,
 		*dst++ = *src++;
 		bytecnt -= 8 * sizeof(unsigned long long);
 		if (unlikely(src == qp->sq.qend))
-			src = qp->buf.buf + qp->sq.offset;
+			src = qp->sqstart;
 	}
 }
 
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
@@ -317,6 +321,56 @@ void *mlx5_get_atomic_laddr(struct mlx5_qp *qp, uint16_t idx, int *byte_count)
 	return addr;
 }
 
+static inline int copy_inline_headers(struct ibv_send_wr *wr,
+				      struct mlx5_wqe_eth_seg *eseg,
+				      struct mlx5_sg_copy_ptr *sg_copy_ptr)
+{
+	int inl_hdr_size = MLX5_ETH_INLINE_HEADER_SIZE;
+	int inl_hdr_copy_size = 0;
+	int j = 0;
+
+	inl_hdr_size = MLX5_ETH_INLINE_HEADER_SIZE;
+	inl_hdr_copy_size = 0;
+
+	if (likely(wr->sg_list[0].length >= MLX5_ETH_INLINE_HEADER_SIZE)) {
+		inl_hdr_copy_size = MLX5_ETH_INLINE_HEADER_SIZE;
+		memcpy(eseg->inline_hdr_start,
+		       (void *)(uintptr_t)wr->sg_list[0].addr,
+		       inl_hdr_copy_size);
+	} else {
+		for (j = 0; j < wr->num_sge && inl_hdr_size > 0; ++j) {
+			inl_hdr_copy_size = min(wr->sg_list[j].length,
+						inl_hdr_size);
+			memcpy(eseg->inline_hdr_start +
+			       (MLX5_ETH_INLINE_HEADER_SIZE - inl_hdr_size),
+			       (void *)(uintptr_t)wr->sg_list[j].addr,
+			       inl_hdr_copy_size);
+			inl_hdr_size -= inl_hdr_copy_size;
+		}
+		--j;
+		if (unlikely(inl_hdr_size)) {
+			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "Ethernet headers < 16 bytes\n");
+			return EINVAL;
+		}
+	}
+
+
+	eseg->inline_hdr_sz = htons(MLX5_ETH_INLINE_HEADER_SIZE);
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
@@ -325,6 +379,8 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	void *seg;
 	struct mlx5_wqe_ctrl_seg *ctrl = NULL;
 	struct mlx5_wqe_data_seg *dpseg;
+	struct mlx5_sg_copy_ptr sg_copy_ptr = {.index = 0, .offset = 0};
+	struct mlx5_wqe_eth_seg *eseg;
 	int nreq;
 	int inl = 0;
 	int err = 0;
@@ -438,6 +494,18 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				seg = mlx5_get_send_wqe(qp, 0);
 			break;
 
+		case IBV_QPT_RAW_PACKET:
+			eseg = seg;
+			memset(eseg, 0, sizeof(*eseg));
+
+			err = copy_inline_headers(wr, eseg, &sg_copy_ptr);
+			if (unlikely(err))
+				return err;
+
+			seg += sizeof(struct mlx5_wqe_eth_seg);
+			size += sizeof(struct mlx5_wqe_eth_seg) / 16;
+			break;
+
 		default:
 			break;
 		}
@@ -445,7 +513,7 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		if (wr->send_flags & IBV_SEND_INLINE && wr->num_sge) {
 			int uninitialized_var(sz);
 
-			err = set_data_inl_seg(qp, wr, seg, &sz);
+			err = set_data_inl_seg(qp, wr, seg, &sz, &sg_copy_ptr);
 			if (unlikely(err)) {
 				*bad_wr = wr;
 				mlx5_dbg(fp, MLX5_DBG_QP_SEND,
@@ -456,13 +524,15 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
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
@@ -586,7 +656,7 @@ int mlx5_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		for (i = 0, j = 0; i < wr->num_sge; ++i) {
 			if (unlikely(!wr->sg_list[i].length))
 				continue;
-			set_data_ptr_seg(scat + j++, wr->sg_list + i);
+			set_data_ptr_seg(scat + j++, wr->sg_list + i, 0);
 		}
 
 		if (j < qp->rq.max_gs) {
@@ -614,7 +684,9 @@ out:
 		 */
 		wmb();
 
-		qp->db[MLX5_RCV_DBR] = htonl(qp->rq.head & 0xffff);
+		if (likely(!(ibqp->qp_type == IBV_QPT_RAW_PACKET &&
+			     ibqp->state < IBV_QPS_RTR)))
+			qp->db[MLX5_RCV_DBR] = htonl(qp->rq.head & 0xffff);
 	}
 
 	mlx5_spin_unlock(&qp->rq.lock);
diff --git a/src/verbs.c b/src/verbs.c
index 2c9afe2..f98fc3a 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -646,6 +646,11 @@ static int sq_overhead(enum ibv_qp_type	qp_type)
 			sizeof(struct mlx5_wqe_raddr_seg);
 		break;
 
+	case IBV_QPT_RAW_PACKET:
+		size = sizeof(struct mlx5_wqe_ctrl_seg) +
+			sizeof(struct mlx5_wqe_eth_seg);
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -848,7 +853,8 @@ static const char *qptype2key(enum ibv_qp_type type)
 }
 
 static int mlx5_alloc_qp_buf(struct ibv_context *context,
-			     struct ibv_qp_cap *cap, struct mlx5_qp *qp,
+			     struct ibv_qp_init_attr_ex *attr,
+			     struct mlx5_qp *qp,
 			     int size)
 {
 	int err;
@@ -902,8 +908,25 @@ static int mlx5_alloc_qp_buf(struct ibv_context *context,
 
 	memset(qp->buf.buf, 0, qp->buf_size);
 
-	return 0;
+	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
+		/* For Raw Packet QP, allocate a separate buffer for the SQ */
+		err = mlx5_alloc_prefered_buf(to_mctx(context), &qp->sq_buf,
+					      align(qp->sq_buf_size, to_mdev
+					      (context->device)->page_size),
+					      to_mdev(context->device)->page_size,
+					      alloc_type,
+					      MLX5_QP_PREFIX);
+		if (err) {
+			err = -ENOMEM;
+			goto rq_buf;
+		}
+
+		memset(qp->sq_buf.buf, 0, qp->buf_size - qp->sq.offset);
+	}
 
+	return 0;
+rq_buf:
+	mlx5_free_actual_buf(to_mctx(qp->verbs_qp.qp.context), &qp->buf);
 ex_wrid:
 	if (qp->rq.wrid)
 		free(qp->rq.wrid);
@@ -922,6 +945,10 @@ static void mlx5_free_qp_buf(struct mlx5_qp *qp)
 	struct mlx5_context *ctx = to_mctx(qp->ibv_qp.context);
 
 	mlx5_free_actual_buf(ctx, &qp->buf);
+
+	if (qp->sq_buf.buf)
+		mlx5_free_actual_buf(ctx, &qp->sq_buf);
+
 	if (qp->rq.wrid)
 		free(qp->rq.wrid);
 
@@ -982,6 +1009,8 @@ static int init_attr_v1(struct ibv_context *context, struct mlx5_qp *qp,
 		cmd.flags |= MLX5_QP_FLAG_SCATTER_CQE;
 
 	cmd.buf_addr = (uintptr_t) qp->buf.buf;
+	cmd.sq_buf_addr = (attr->qp_type == IBV_QPT_RAW_PACKET) ?
+			  (uintptr_t) qp->sq_buf.buf : 0;
 	cmd.db_addr  = (uintptr_t) qp->db;
 	cmd.sq_wqe_count = qp->sq.wqe_cnt;
 	cmd.rq_wqe_count = qp->rq.wqe_cnt;
@@ -1043,15 +1072,29 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		errno = -ret;
 		goto err;
 	}
-	qp->buf_size = ret;
 
-	if (mlx5_alloc_qp_buf(context, &attr->cap, qp, ret)) {
+	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
+		qp->buf_size = qp->sq.offset;
+		qp->sq_buf_size = ret - qp->buf_size;
+	} else {
+		qp->buf_size = ret;
+		qp->sq_buf_size = 0;
+	}
+
+	if (mlx5_alloc_qp_buf(context, attr, qp, ret)) {
 		mlx5_dbg(fp, MLX5_DBG_QP, "\n");
 		goto err;
 	}
 
-	qp->sq.qend = qp->buf.buf + qp->sq.offset +
-		(qp->sq.wqe_cnt << qp->sq.wqe_shift);
+	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
+		qp->sqstart = qp->sq_buf.buf;
+		qp->sq.qend = qp->sq_buf.buf +
+				(qp->sq.wqe_cnt << qp->sq.wqe_shift);
+	} else {
+		qp->sqstart = qp->buf.buf + qp->sq.offset;
+		qp->sq.qend = qp->buf.buf + qp->sq.offset +
+				(qp->sq.wqe_cnt << qp->sq.wqe_shift);
+	}
 	mlx5_init_qp_indices(qp);
 
 	if (mlx5_spinlock_init(&qp->sq.lock) ||
@@ -1256,6 +1299,7 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
 	struct ibv_modify_qp cmd;
+	struct mlx5_qp *mqp = to_mqp(qp);
 	int ret;
 	uint32_t *db;
 
@@ -1265,18 +1309,27 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	    (attr_mask & IBV_QP_STATE) &&
 	    attr->qp_state == IBV_QPS_RESET) {
 		if (qp->recv_cq) {
-			mlx5_cq_clean(to_mcq(qp->recv_cq), to_mqp(qp)->rsc.rsn,
+			mlx5_cq_clean(to_mcq(qp->recv_cq), mqp->rsc.rsn,
 				      qp->srq ? to_msrq(qp->srq) : NULL);
 		}
 		if (qp->send_cq != qp->recv_cq && qp->send_cq)
-			mlx5_cq_clean(to_mcq(qp->send_cq), to_mqp(qp)->rsc.rsn, NULL);
+			mlx5_cq_clean(to_mcq(qp->send_cq), mqp->rsc.rsn, NULL);
 
-		mlx5_init_qp_indices(to_mqp(qp));
-		db = to_mqp(qp)->db;
+		mlx5_init_qp_indices(mqp);
+		db = mqp->db;
 		db[MLX5_RCV_DBR] = 0;
 		db[MLX5_SND_DBR] = 0;
 	}
 
+	if (!ret &&
+	    (attr_mask & IBV_QP_STATE) &&
+	    attr->qp_state == IBV_QPS_RTR &&
+	    qp->qp_type == IBV_QPT_RAW_PACKET) {
+		mlx5_spin_lock(&mqp->rq.lock);
+		mqp->db[MLX5_RCV_DBR] = htonl(mqp->rq.head & 0xffff);
+		mlx5_spin_unlock(&mqp->rq.lock);
+	}
+
 	return ret;
 }
 
diff --git a/src/wqe.h b/src/wqe.h
index bd50d9a..7fb57d2 100644
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
@@ -70,6 +75,26 @@ struct mlx5_eqe_qp_srq {
 	uint32_t	qp_srq_n;
 };
 
+enum {
+	MLX5_ETH_WQE_L3_CSUM	=	(1 << 6),
+	MLX5_ETH_WQE_L4_CSUM	=	(1 << 7),
+};
+
+enum {
+	MLX5_ETH_INLINE_HEADER_SIZE =	18,
+};
+
+struct mlx5_wqe_eth_seg {
+	uint32_t	rsvd0;
+	uint8_t		cs_flags;
+	uint8_t		rsvd1;
+	uint16_t	mss;
+	uint32_t	rsvd2;
+	uint16_t	inline_hdr_sz;
+	uint8_t		inline_hdr_start[2];
+	uint8_t		inline_hdr[16];
+};
+
 struct mlx5_wqe_ctrl_seg {
 	uint32_t	opmod_idx_opcode;
 	uint32_t	qpn_ds;
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
