From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 06/10] mlx5: Tag matching post list operation
Date: Mon, 23 Oct 2017 16:17:57 +0300
Message-ID: <1508764681-4531-7-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Implement ibv_post_srq_ops verb to perform tag matching
list add/remove operations.

To support this, the patch adds tag state tracking infrastructure to
manage the list operation and their coming completions as described
below.

Vector of struct mlx5_tag_entry (mlx5_srq.tm_list) shadows HW tag
matching list.

Initially all tags are held in a free tag list FIFO (mlx5_srq.tm_head,
mlx5_srq.tm_tail).

FIFO of operations waiting for CQE (mlx5_srq.op, op_head, op_tail)
allows to match received list operation completions with tag entry
basing of guaranteed ordering of command QP work request processing.
TM data receive completions have tag index in CQE and may be accessed
via vector by this index.

List add operation:
* removes a tag from head of free tag list FIFO
* increments expected cqe (for tag consumed completion)
* if (SIGNALED)
*     store tag wr_id, phase_cnt (unexpected_cnt) if provided
*     enqueues new op to the tail of waiting for CQE FIFO
*     store op wr_id, wqe_head
*     increments expected cqe
* posts list add operation work request on command QP
* returns index of tag to caller

List remove operation:
* looks up tag by index in tag list vector
* if (SIGNALED)
*     enqueues new op to the tail of waiting for CQE FIFO
*     store op wr_id, wqe_head
*     increments expected cqe
* posts list remove operation work request on command QP

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/mlx5.c   |   1 +
 providers/mlx5/mlx5.h   |  48 +++++++-
 providers/mlx5/mlx5dv.h |  12 ++
 providers/mlx5/qp.c     | 303 +++++++++++++++++++++++++++++++++++++++++-------
 providers/mlx5/verbs.c  |  25 +++-
 5 files changed, 344 insertions(+), 45 deletions(-)

diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 15f258d..2414881 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -965,6 +965,7 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, destroy_wq, mlx5_destroy_wq);
 	verbs_set_ctx_op(v_ctx, create_rwq_ind_table, mlx5_create_rwq_ind_table);
 	verbs_set_ctx_op(v_ctx, destroy_rwq_ind_table, mlx5_destroy_rwq_ind_table);
+	verbs_set_ctx_op(v_ctx, post_srq_ops, mlx5_post_srq_ops);
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(ctx, NULL, &device_attr,
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index d16b5f5..d7eb477 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -132,6 +132,12 @@ enum {
 };
 
 enum {
+	MLX5_TM_OPCODE_NOP		= 0x00,
+	MLX5_TM_OPCODE_APPEND		= 0x01,
+	MLX5_TM_OPCODE_REMOVE		= 0x02,
+};
+
+enum {
 	MLX5_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
 	MLX5_RECV_OPCODE_SEND		= 0x01,
 	MLX5_RECV_OPCODE_SEND_IMM	= 0x02,
@@ -142,7 +148,9 @@ enum {
 };
 
 enum {
-	MLX5_SRQ_FLAG_SIGNATURE		= 1 << 0,
+	MLX5_SRQ_FLAG_SIGNATURE		= (1 << 0),
+	MLX5_SRQ_FLAG_TM_SW_CNT		= (1 << 6),
+	MLX5_SRQ_FLAG_TM_CQE_REQ	= (1 << 7),
 };
 
 enum {
@@ -345,6 +353,22 @@ struct mlx5_cq {
 	int			umr_opcode;
 };
 
+struct mlx5_tag_entry {
+	struct mlx5_tag_entry *next;
+	uint64_t	       wr_id;
+	int		       phase_cnt;
+	void		      *ptr;
+	uint32_t	       size;
+	int8_t		       expect_cqe;
+};
+
+struct mlx5_srq_op {
+	struct mlx5_tag_entry *tag;
+	uint64_t	       wr_id;
+	/* we need to advance tail pointer */
+	uint32_t	       wqe_head;
+};
+
 struct mlx5_srq {
 	struct mlx5_resource            rsc;  /* This struct must be first */
 	struct verbs_srq		vsrq;
@@ -361,8 +385,27 @@ struct mlx5_srq {
 	uint16_t			counter;
 	int				wq_sig;
 	struct ibv_qp		       *cmd_qp;
+	struct mlx5_tag_entry	       *tm_list; /* vector of all tags */
+	struct mlx5_tag_entry	       *tm_head; /* queue of free tags */
+	struct mlx5_tag_entry	       *tm_tail;
+	struct mlx5_srq_op	       *op;
+	int				op_head;
+	int				op_tail;
+	int				unexp_in;
+	int				unexp_out;
 };
 
+
+static inline void mlx5_tm_release_tag(struct mlx5_srq *srq,
+				       struct mlx5_tag_entry *tag)
+{
+	if (!--tag->expect_cqe) {
+		tag->next = NULL;
+		srq->tm_tail->next = tag;
+		srq->tm_tail = tag;
+	}
+}
+
 struct wr_list {
 	uint16_t	opcode;
 	uint16_t	next;
@@ -693,6 +736,9 @@ struct ibv_rwq_ind_table *mlx5_create_rwq_ind_table(struct ibv_context *context,
 int mlx5_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
 struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 				   struct ibv_srq_init_attr_ex *attr);
+int mlx5_post_srq_ops(struct ibv_srq *srq,
+		      struct ibv_ops_wr *wr,
+		      struct ibv_ops_wr **bad_wr);
 
 static inline void *mlx5_find_uidx(struct mlx5_context *ctx, uint32_t uidx)
 {
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index ffe2c55..e6cb610 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -217,6 +217,7 @@ enum {
 	MLX5_OPCODE_LOCAL_INVAL		= 0x1b,
 	MLX5_OPCODE_CONFIG_CMD		= 0x1f,
 	MLX5_OPCODE_UMR			= 0x25,
+	MLX5_OPCODE_TAG_MATCHING	= 0x28
 };
 
 /*
@@ -451,6 +452,17 @@ struct mlx5_wqe_eth_seg {
 	uint8_t		inline_hdr[16];
 };
 
+struct mlx5_wqe_tm_seg {
+	uint8_t		opcode;
+	uint8_t		flags;
+	__be16		index;
+	uint8_t		rsvd0[2];
+	__be16		sw_cnt;
+	uint8_t		rsvd1[8];
+	__be64		append_tag;
+	__be64		append_mask;
+};
+
 /*
  * Control segment - contains some control information for the current WQE.
  *
diff --git a/providers/mlx5/qp.c b/providers/mlx5/qp.c
index d5e677f..20e97e4 100644
--- a/providers/mlx5/qp.c
+++ b/providers/mlx5/qp.c
@@ -194,6 +194,26 @@ static inline void set_raddr_seg(struct mlx5_wqe_raddr_seg *rseg,
 	rseg->reserved = 0;
 }
 
+static void set_tm_seg(struct mlx5_wqe_tm_seg *tmseg, int op,
+		       struct ibv_ops_wr *wr, int index)
+{
+	tmseg->flags = 0;
+	if (wr->flags & IBV_OPS_SIGNALED)
+		tmseg->flags |= MLX5_SRQ_FLAG_TM_CQE_REQ;
+	if (wr->flags & IBV_OPS_TM_SYNC) {
+		tmseg->flags |= MLX5_SRQ_FLAG_TM_SW_CNT;
+		tmseg->sw_cnt = htobe16(wr->tm.unexpected_cnt);
+	}
+	tmseg->opcode = op << 4;
+	if (op == MLX5_TM_OPCODE_NOP)
+		return;
+	tmseg->index = htobe16(index);
+	if (op == MLX5_TM_OPCODE_REMOVE)
+		return;
+	tmseg->append_tag = htobe64(wr->tm.add.tag);
+	tmseg->append_mask = htobe64(wr->tm.add.mask);
+}
+
 static void set_atomic_seg(struct mlx5_wqe_atomic_seg *aseg,
 			   enum ibv_wr_opcode   opcode,
 			   uint64_t swap,
@@ -231,6 +251,13 @@ static void set_data_ptr_seg_atomic(struct mlx5_wqe_data_seg *dseg,
 	dseg->addr       = htobe64(sg->addr);
 }
 
+static void set_data_ptr_seg_end(struct mlx5_wqe_data_seg *dseg)
+{
+	dseg->byte_count = 0;
+	dseg->lkey       = htobe32(MLX5_INVALID_LKEY);
+	dseg->addr       = 0;
+}
+
 /*
  * Avoid using memcpy() to copy to BlueFlame page, since memcpy()
  * implementations may use move-string-buffer assembler instructions,
@@ -661,10 +688,61 @@ static inline int mlx5_post_send_underlay(struct mlx5_qp *qp, struct ibv_send_wr
 	return 0;
 }
 
+static inline void post_send_db(struct mlx5_qp *qp, struct mlx5_bf *bf,
+				int nreq, int inl, int size,
+				uint8_t next_fence, void *ctrl)
+{
+	struct mlx5_context *ctx;
+
+	if (unlikely(!nreq))
+		return;
+
+	qp->sq.head += nreq;
+	qp->fm_cache = next_fence;
+
+	/*
+	 * Make sure that descriptors are written before
+	 * updating doorbell record and ringing the doorbell
+	 */
+	udma_to_device_barrier();
+	qp->db[MLX5_SND_DBR] = htobe32(qp->sq.cur_post & 0xffff);
+
+	/* Make sure that the doorbell write happens before the memcpy
+	 * to WC memory below
+	 */
+	ctx = to_mctx(qp->ibv_qp->context);
+	if (bf->need_lock)
+		mmio_wc_spinlock(&bf->lock.lock);
+	else
+		mmio_wc_start();
+
+	if (!ctx->shut_up_bf && nreq == 1 && bf->uuarn &&
+	    (inl || ctx->prefer_bf) && size > 1 &&
+	    size <= bf->buf_size / 16)
+		mlx5_bf_copy(bf->reg + bf->offset, ctrl,
+			     align(size * 16, 64), qp);
+	else
+		mmio_write64_be(bf->reg + bf->offset, *(__be64 *)ctrl);
+
+	/*
+	 * use mmio_flush_writes() to ensure write combining buffers are
+	 * flushed out of the running CPU. This must be carried inside
+	 * the spinlock. Otherwise, there is a potential race. In the
+	 * race, CPU A writes doorbell 1, which is waiting in the WC
+	 * buffer. CPU B writes doorbell 2, and it's write is flushed
+	 * earlier. Since the mmio_flush_writes is CPU local, this will
+	 * result in the HCA seeing doorbell 2, followed by doorbell 1.
+	 * Flush before toggling bf_offset to be latency oriented.
+	 */
+	mmio_flush_writes();
+	bf->offset ^= bf->buf_size;
+	if (bf->need_lock)
+		mlx5_spin_unlock(&bf->lock);
+}
+
 static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				  struct ibv_send_wr **bad_wr)
 {
-	struct mlx5_context *ctx;
 	struct mlx5_qp *qp = to_mqp(ibqp);
 	void *seg;
 	struct mlx5_wqe_eth_seg *eseg;
@@ -977,48 +1055,7 @@ static inline int _mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	}
 
 out:
-	if (likely(nreq)) {
-		qp->sq.head += nreq;
-		qp->fm_cache = next_fence;
-
-		/*
-		 * Make sure that descriptors are written before
-		 * updating doorbell record and ringing the doorbell
-		 */
-		udma_to_device_barrier();
-		qp->db[MLX5_SND_DBR] = htobe32(qp->sq.cur_post & 0xffff);
-
-		/* Make sure that the doorbell write happens before the memcpy
-		 * to WC memory below */
-		ctx = to_mctx(ibqp->context);
-		if (bf->need_lock)
-			mmio_wc_spinlock(&bf->lock.lock);
-		else
-			mmio_wc_start();
-
-		if (!ctx->shut_up_bf && nreq == 1 && bf->uuarn &&
-		    (inl || ctx->prefer_bf) && size > 1 &&
-		    size <= bf->buf_size / 16)
-			mlx5_bf_copy(bf->reg + bf->offset, (uint64_t *)ctrl,
-				     align(size * 16, 64), qp);
-		else
-			mmio_write64_be(bf->reg + bf->offset, *(__be64 *)ctrl);
-
-		/*
-		 * use mmio_flush_writes() to ensure write combining buffers are flushed out
-		 * of the running CPU. This must be carried inside the spinlock.
-		 * Otherwise, there is a potential race. In the race, CPU A
-		 * writes doorbell 1, which is waiting in the WC buffer. CPU B
-		 * writes doorbell 2, and it's write is flushed earlier. Since
-		 * the mmio_flush_writes is CPU local, this will result in the HCA seeing
-		 * doorbell 2, followed by doorbell 1.
-		 * Flush before toggling bf_offset to be latency oriented.
-		 */
-		mmio_flush_writes();
-		bf->offset ^= bf->buf_size;
-		if (bf->need_lock)
-			mlx5_spin_unlock(&bf->lock);
-	}
+	post_send_db(qp, bf, nreq, inl, size, next_fence, ctrl);
 
 	mlx5_spin_unlock(&qp->sq.lock);
 
@@ -1275,6 +1312,186 @@ out:
 	return err;
 }
 
+static void mlx5_tm_add_op(struct mlx5_srq *srq, struct mlx5_tag_entry *tag,
+			   uint64_t wr_id, int nreq)
+{
+	struct mlx5_qp *qp = to_mqp(srq->cmd_qp);
+	struct mlx5_srq_op *op;
+
+	op = srq->op + (srq->op_tail++ & (qp->sq.wqe_cnt - 1));
+	op->tag = tag;
+	op->wr_id = wr_id;
+	/* Will point to next available WQE */
+	op->wqe_head = qp->sq.head + nreq;
+	if (tag)
+		tag->expect_cqe++;
+}
+
+int mlx5_post_srq_ops(struct ibv_srq *ibsrq, struct ibv_ops_wr *wr,
+		      struct ibv_ops_wr **bad_wr)
+{
+	struct mlx5_context *ctx = to_mctx(ibsrq->context);
+	struct mlx5_srq *srq = to_msrq(ibsrq);
+	struct mlx5_wqe_ctrl_seg *ctrl = NULL;
+	struct mlx5_tag_entry *tag;
+	struct mlx5_bf *bf;
+	struct mlx5_qp *qp;
+	unsigned int idx;
+	int size = 0;
+	int nreq = 0;
+	int err = 0;
+	void *qend;
+	void *seg;
+	FILE *fp = ctx->dbg_fp;
+
+	if (unlikely(!srq->cmd_qp)) {
+		*bad_wr = wr;
+		return EINVAL;
+	}
+
+	qp = to_mqp(srq->cmd_qp);
+	bf = qp->bf;
+	qend = qp->sq.qend;
+	mlx5_spin_lock(&srq->lock);
+
+	for (nreq = 0; wr; ++nreq, wr = wr->next) {
+		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq,
+					      to_mcq(qp->ibv_qp->send_cq)))) {
+			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "work queue overflow\n");
+			err = ENOMEM;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		idx = qp->sq.cur_post & (qp->sq.wqe_cnt - 1);
+		ctrl = seg = mlx5_get_send_wqe(qp, idx);
+		*(uint32_t *)(seg + 8) = 0;
+		ctrl->imm = 0;
+		ctrl->fm_ce_se = 0;
+
+		seg += sizeof(*ctrl);
+		size = sizeof(*ctrl) / 16;
+
+		switch (wr->opcode) {
+		case IBV_WR_TAG_ADD:
+			if (unlikely(!srq->tm_head->next)) {
+				mlx5_dbg(fp, MLX5_DBG_QP_SEND, "tag matching list is full\n");
+				err = ENOMEM;
+				*bad_wr = wr;
+				goto out;
+			}
+			tag = srq->tm_head;
+#ifdef MLX5_DEBUG
+			if (wr->tm.add.num_sge > 1) {
+				mlx5_dbg(fp, MLX5_DBG_QP_SEND, "num_sge must be at most 1\n");
+				err = EINVAL;
+				*bad_wr = wr;
+				goto out;
+			}
+
+			if (tag->expect_cqe) {
+				mlx5_dbg(fp, MLX5_DBG_QP_SEND, "tag matching list is corrupted\n");
+				err = ENOMEM;
+				*bad_wr = wr;
+				goto out;
+			}
+#endif
+			srq->tm_head = tag->next;
+			/* place index of next entry into TM segment */
+			set_tm_seg(seg, MLX5_TM_OPCODE_APPEND, wr,
+				   tag->next - srq->tm_list);
+			tag->next = NULL;
+			tag->wr_id = wr->tm.add.recv_wr_id;
+			if (wr->flags & IBV_OPS_TM_SYNC)
+				srq->unexp_out = wr->tm.unexpected_cnt;
+			tag->phase_cnt = srq->unexp_out;
+			tag->expect_cqe++;
+
+			if (wr->flags & IBV_OPS_SIGNALED)
+				mlx5_tm_add_op(srq, tag, wr->wr_id, nreq);
+
+			wr->tm.handle = tag - srq->tm_list;
+			seg += sizeof(struct mlx5_wqe_tm_seg);
+			size += sizeof(struct mlx5_wqe_tm_seg) / 16;
+
+			if (unlikely(seg == qend))
+				seg = mlx5_get_send_wqe(qp, 0);
+
+			/* message is allowed to be empty */
+			if (wr->tm.add.num_sge && wr->tm.add.sg_list->length) {
+				set_data_ptr_seg(seg, wr->tm.add.sg_list, 0);
+				tag->ptr = (void *)(uintptr_t)wr->tm.add.sg_list->addr;
+				tag->size = wr->tm.add.sg_list->length;
+			} else {
+				set_data_ptr_seg_end(seg);
+			}
+			size += sizeof(struct mlx5_wqe_data_seg) / 16;
+			break;
+
+		case IBV_WR_TAG_DEL:
+			tag = &srq->tm_list[wr->tm.handle];
+
+#ifdef MLX5_DEBUG
+			if (!tag->expect_cqe) {
+				mlx5_dbg(fp, MLX5_DBG_QP_SEND, "removing tag which isn't in HW ownership\n");
+				err = ENOMEM;
+				*bad_wr = wr;
+				goto out;
+			}
+#endif
+			set_tm_seg(seg, MLX5_TM_OPCODE_REMOVE, wr,
+				   wr->tm.handle);
+
+			if (wr->flags & IBV_OPS_SIGNALED)
+				mlx5_tm_add_op(srq, tag, wr->wr_id, nreq);
+			else
+				mlx5_tm_release_tag(srq, tag);
+
+			seg += sizeof(struct mlx5_wqe_tm_seg);
+			size += sizeof(struct mlx5_wqe_tm_seg) / 16;
+			break;
+
+		case IBV_WR_TAG_SYNC:
+			set_tm_seg(seg, MLX5_TM_OPCODE_NOP, wr, 0);
+
+			if (wr->flags & IBV_OPS_SIGNALED)
+				mlx5_tm_add_op(srq, NULL, wr->wr_id, nreq);
+
+			seg += sizeof(struct mlx5_wqe_tm_seg);
+			size += sizeof(struct mlx5_wqe_tm_seg) / 16;
+			break;
+
+		default:
+			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "bad opcode %d\n",
+				 wr->opcode);
+			err = EINVAL;
+			*bad_wr = wr;
+			goto out;
+		}
+
+		ctrl->opmod_idx_opcode = htobe32(MLX5_OPCODE_TAG_MATCHING |
+				((qp->sq.cur_post & 0xffff) << 8));
+		ctrl->qpn_ds = htobe32(size | (srq->cmd_qp->qp_num << 8));
+
+		if (unlikely(qp->wq_sig))
+			ctrl->signature = wq_sig(ctrl);
+
+		qp->sq.cur_post += DIV_ROUND_UP(size * 16, MLX5_SEND_WQE_BB);
+
+#ifdef MLX5_DEBUG
+		if (mlx5_debug_mask & MLX5_DBG_QP_SEND)
+			dump_wqe(fp, idx, size, qp);
+#endif
+	}
+
+out:
+	post_send_db(qp, bf, nreq, 0, size, 0, ctrl);
+
+	mlx5_spin_unlock(&srq->lock);
+
+	return err;
+}
+
 int mlx5_use_huge(const char *key)
 {
 	char *e;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index a26b631..f935fc8 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -757,7 +757,9 @@ int mlx5_destroy_srq(struct ibv_srq *srq)
 
 	mlx5_free_db(ctx, msrq->db);
 	mlx5_free_buf(&msrq->buf);
+	free(msrq->tm_list);
 	free(msrq->wrid);
+	free(msrq->op);
 	free(msrq);
 
 	return 0;
@@ -2025,15 +2027,33 @@ struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 		goto err_free_uidx;
 
 	if (attr->srq_type == IBV_SRQT_TM) {
+		int i;
+
 		msrq->cmd_qp = create_cmd_qp(context, attr, ibsrq);
 		if (!msrq->cmd_qp)
 			goto err_destroy;
+
+		msrq->tm_list = calloc(attr->tm_cap.max_num_tags + 1,
+				       sizeof(struct mlx5_tag_entry));
+		if (!msrq->tm_list)
+			goto err_free_cmd;
+		for (i = 0; i < attr->tm_cap.max_num_tags; i++)
+			msrq->tm_list[i].next = &msrq->tm_list[i + 1];
+		msrq->tm_head = &msrq->tm_list[0];
+		msrq->tm_tail = &msrq->tm_list[attr->tm_cap.max_num_tags];
+
+		msrq->op = calloc(to_mqp(msrq->cmd_qp)->sq.wqe_cnt,
+				  sizeof(struct mlx5_srq_op));
+		if (!msrq->op)
+			goto err_free_tm;
+		msrq->op_head = 0;
+		msrq->op_tail = 0;
 	}
 
 	if (!ctx->cqe_version) {
 		err = mlx5_store_srq(to_mctx(context), resp.srqn, msrq);
 		if (err)
-			goto err_free_cmd;
+			goto err_free_tm;
 
 		pthread_mutex_unlock(&ctx->srq_table_mutex);
 	}
@@ -2044,6 +2064,9 @@ struct ibv_srq *mlx5_create_srq_ex(struct ibv_context *context,
 
 	return ibsrq;
 
+err_free_tm:
+	free(msrq->tm_list);
+	free(msrq->op);
 err_free_cmd:
 	if (msrq->cmd_qp)
 		mlx5_destroy_qp(msrq->cmd_qp);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
