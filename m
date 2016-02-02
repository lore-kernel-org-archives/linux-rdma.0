From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 6/7] Allocate separate RQ and SQ buffers for Raw Packet QP
Date: Tue,  2 Feb 2016 20:51:00 +0200
Message-ID: <1454439061-929-7-git-send-email-majd@mellanox.com>
References: <1454439061-929-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454439061-929-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In case of Raw Packet QP, the RQ and SQ aren't
contiguous, therefore we need to allocate each one of them
separately and pass the buffer address to the kernel.

Reviewed-by:: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5-abi.h |  2 ++
 src/mlx5.h     |  4 +++
 src/qp.c       |  4 +--
 src/verbs.c    | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
 src/wqe.h      | 11 ++++++++
 5 files changed, 92 insertions(+), 11 deletions(-)

diff --git a/src/mlx5-abi.h b/src/mlx5-abi.h
index 6427cca..f4247e0 100644
--- a/src/mlx5-abi.h
+++ b/src/mlx5-abi.h
@@ -132,6 +132,8 @@ struct mlx5_create_qp {
 	__u32				flags;
 	__u32                           uidx;
 	__u32                           reserved;
+	/* SQ buffer address - used for Raw Packet QP */
+	__u64                           sq_buf_addr;
 };
 
 struct mlx5_create_qp_resp {
diff --git a/src/mlx5.h b/src/mlx5.h
index 6b982c4..4fa0f46 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -427,8 +427,12 @@ struct mlx5_qp {
 	struct verbs_qp			verbs_qp;
 	struct ibv_qp		       *ibv_qp;
 	struct mlx5_buf                 buf;
+	void				*sq_start;
 	int                             max_inline_data;
 	int                             buf_size;
+	/* For Raw Packet QP, use different buffers for the SQ and RQ */
+	struct mlx5_buf                 sq_buf;
+	int				sq_buf_size;
 	struct mlx5_bf		       *bf;
 
 	uint8_t	                        sq_signal_bits;
diff --git a/src/qp.c b/src/qp.c
index 67ded0d..8556714 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -145,7 +145,7 @@ int mlx5_copy_to_send_wqe(struct mlx5_qp *qp, int idx, void *buf, int size)
 
 void *mlx5_get_send_wqe(struct mlx5_qp *qp, int n)
 {
-	return qp->buf.buf + qp->sq.offset + (n << MLX5_SEND_WQE_SHIFT);
+	return qp->sq_start + (n << MLX5_SEND_WQE_SHIFT);
 }
 
 void mlx5_init_qp_indices(struct mlx5_qp *qp)
@@ -214,7 +214,7 @@ static void mlx5_bf_copy(unsigned long long *dst, unsigned long long *src,
 		*dst++ = *src++;
 		bytecnt -= 8 * sizeof(unsigned long long);
 		if (unlikely(src == qp->sq.qend))
-			src = qp->buf.buf + qp->sq.offset;
+			src = qp->sq_start;
 	}
 }
 
diff --git a/src/verbs.c b/src/verbs.c
index 541a0bd..da62775 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -600,6 +600,11 @@ static int sq_overhead(enum ibv_qp_type	qp_type)
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
@@ -802,7 +807,8 @@ static const char *qptype2key(enum ibv_qp_type type)
 }
 
 static int mlx5_alloc_qp_buf(struct ibv_context *context,
-			     struct ibv_qp_cap *cap, struct mlx5_qp *qp,
+			     struct ibv_qp_init_attr_ex *attr,
+			     struct mlx5_qp *qp,
 			     int size)
 {
 	int err;
@@ -856,8 +862,26 @@ static int mlx5_alloc_qp_buf(struct ibv_context *context,
 
 	memset(qp->buf.buf, 0, qp->buf_size);
 
-	return 0;
+	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
+		size_t aligned_sq_buf_size = align(qp->sq_buf_size,
+						   to_mdev(context->device)->page_size);
+		/* For Raw Packet QP, allocate a separate buffer for the SQ */
+		err = mlx5_alloc_prefered_buf(to_mctx(context), &qp->sq_buf,
+					      aligned_sq_buf_size,
+					      to_mdev(context->device)->page_size,
+					      alloc_type,
+					      MLX5_QP_PREFIX);
+		if (err) {
+			err = -ENOMEM;
+			goto rq_buf;
+		}
 
+		memset(qp->sq_buf.buf, 0, aligned_sq_buf_size);
+	}
+
+	return 0;
+rq_buf:
+	mlx5_free_actual_buf(to_mctx(qp->verbs_qp.qp.context), &qp->buf);
 ex_wrid:
 	if (qp->rq.wrid)
 		free(qp->rq.wrid);
@@ -876,6 +900,10 @@ static void mlx5_free_qp_buf(struct mlx5_qp *qp)
 	struct mlx5_context *ctx = to_mctx(qp->ibv_qp->context);
 
 	mlx5_free_actual_buf(ctx, &qp->buf);
+
+	if (qp->sq_buf.buf)
+		mlx5_free_actual_buf(ctx, &qp->sq_buf);
+
 	if (qp->rq.wrid)
 		free(qp->rq.wrid);
 
@@ -922,15 +950,31 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 		errno = -ret;
 		goto err;
 	}
-	qp->buf_size = ret;
 
-	if (mlx5_alloc_qp_buf(context, &attr->cap, qp, ret)) {
+	if (attr->qp_type == IBV_QPT_RAW_PACKET) {
+		qp->buf_size = qp->sq.offset;
+		qp->sq_buf_size = ret - qp->buf_size;
+		qp->sq.offset = 0;
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
+		qp->sq_start = qp->sq_buf.buf;
+		qp->sq.qend = qp->sq_buf.buf +
+				(qp->sq.wqe_cnt << qp->sq.wqe_shift);
+	} else {
+		qp->sq_start = qp->buf.buf + qp->sq.offset;
+		qp->sq.qend = qp->buf.buf + qp->sq.offset +
+				(qp->sq.wqe_cnt << qp->sq.wqe_shift);
+	}
+
 	mlx5_init_qp_indices(qp);
 
 	if (mlx5_spinlock_init(&qp->sq.lock) ||
@@ -947,6 +991,8 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	qp->db[MLX5_SND_DBR] = 0;
 
 	cmd.buf_addr = (uintptr_t) qp->buf.buf;
+	cmd.sq_buf_addr = (attr->qp_type == IBV_QPT_RAW_PACKET) ?
+			  (uintptr_t) qp->sq_buf.buf : 0;
 	cmd.db_addr  = (uintptr_t) qp->db;
 	cmd.sq_wqe_count = qp->sq.wqe_cnt;
 	cmd.rq_wqe_count = qp->rq.wqe_cnt;
@@ -1145,6 +1191,7 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
 	struct ibv_modify_qp cmd;
+	struct mlx5_qp *mqp = to_mqp(qp);
 	int ret;
 	uint32_t *db;
 
@@ -1154,19 +1201,36 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 	    (attr_mask & IBV_QP_STATE) &&
 	    attr->qp_state == IBV_QPS_RESET) {
 		if (qp->recv_cq) {
-			mlx5_cq_clean(to_mcq(qp->recv_cq), to_mqp(qp)->rsc.rsn,
+			mlx5_cq_clean(to_mcq(qp->recv_cq), mqp->rsc.rsn,
 				      qp->srq ? to_msrq(qp->srq) : NULL);
 		}
 		if (qp->send_cq != qp->recv_cq && qp->send_cq)
 			mlx5_cq_clean(to_mcq(qp->send_cq),
 				      to_mqp(qp)->rsc.rsn, NULL);
 
-		mlx5_init_qp_indices(to_mqp(qp));
-		db = to_mqp(qp)->db;
+		mlx5_init_qp_indices(mqp);
+		db = mqp->db;
 		db[MLX5_RCV_DBR] = 0;
 		db[MLX5_SND_DBR] = 0;
 	}
 
+	/*
+	 * When the Raw Packet QP is in INIT state, its RQ
+	 * underneath is already in RDY, which means it can
+	 * receive packets. According to the IB spec, a QP can't
+	 * receive packets until moved to RTR state. To achieve this,
+	 * for Raw Packet QPs, we update the doorbell record
+	 * once the QP is moved to RTR.
+	 */
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
index bd50d9a..b875104 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -70,6 +70,17 @@ struct mlx5_eqe_qp_srq {
 	uint32_t	qp_srq_n;
 };
 
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
