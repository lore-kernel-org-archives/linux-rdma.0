From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx4 1/2] Add Memory Windows support
Date: Thu,  5 Feb 2015 14:28:32 +0200
Message-ID: <1423139313-17418-2-git-send-email-majd@mellanox.com>
References: <1423139313-17418-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423139313-17418-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Implement the following libibvebrs Memory Window verbs:
1. ibv_alloc_mw
2. ibv_dealloc_mw
3. ibv_bind_mw

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/cq.c    |    3 ++
 src/mlx4.c  |    3 ++
 src/mlx4.h  |    5 ++++
 src/qp.c    |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 src/verbs.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/wqe.h   |   19 +++++++++++++++++
 6 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/src/cq.c b/src/cq.c
index 8b27795..77eb6c2 100644
--- a/src/cq.c
+++ b/src/cq.c
@@ -288,6 +288,9 @@ static int mlx4_poll_one(struct mlx4_cq *cq,
 			wc->opcode    = IBV_WC_FETCH_ADD;
 			wc->byte_len  = 8;
 			break;
+		case MLX4_OPCODE_LOCAL_INVAL:
+			wc->opcode    = IBV_WC_LOCAL_INV;
+			break;
 		case MLX4_OPCODE_BIND_MW:
 			wc->opcode    = IBV_WC_BIND_MW;
 			break;
diff --git a/src/mlx4.c b/src/mlx4.c
index 2999150..b99f244 100644
--- a/src/mlx4.c
+++ b/src/mlx4.c
@@ -93,6 +93,9 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.dealloc_pd    = mlx4_free_pd,
 	.reg_mr	       = mlx4_reg_mr,
 	.dereg_mr      = mlx4_dereg_mr,
+	.alloc_mw      = mlx4_alloc_mw,
+	.dealloc_mw    = mlx4_dealloc_mw,
+	.bind_mw       = mlx4_bind_mw,
 	.create_cq     = mlx4_create_cq,
 	.poll_cq       = mlx4_poll_cq,
 	.req_notify_cq = mlx4_arm_cq,
diff --git a/src/mlx4.h b/src/mlx4.h
index d71450f..2c521f1 100644
--- a/src/mlx4.h
+++ b/src/mlx4.h
@@ -365,6 +365,11 @@ struct ibv_mr *mlx4_reg_mr(struct ibv_pd *pd, void *addr,
 			    size_t length, int access);
 int mlx4_dereg_mr(struct ibv_mr *mr);
 
+struct ibv_mw *mlx4_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type);
+int mlx4_dealloc_mw(struct ibv_mw *mw);
+int mlx4_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
+		 struct ibv_mw_bind *mw_bind);
+
 struct ibv_cq *mlx4_create_cq(struct ibv_context *context, int cqe,
 			       struct ibv_comp_channel *channel,
 			       int comp_vector);
diff --git a/src/qp.c b/src/qp.c
index 721bed4..80a21da 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -54,6 +54,8 @@ static const uint32_t mlx4_ib_opcode[] = {
 	[IBV_WR_RDMA_READ]		= MLX4_OPCODE_RDMA_READ,
 	[IBV_WR_ATOMIC_CMP_AND_SWP]	= MLX4_OPCODE_ATOMIC_CS,
 	[IBV_WR_ATOMIC_FETCH_AND_ADD]	= MLX4_OPCODE_ATOMIC_FA,
+	[IBV_WR_LOCAL_INV]		= MLX4_OPCODE_LOCAL_INVAL,
+	[IBV_WR_BIND_MW]		= MLX4_OPCODE_BIND_MW,
 };
 
 static void *get_recv_wqe(struct mlx4_qp *qp, int n)
@@ -118,6 +120,40 @@ static int wq_overflow(struct mlx4_wq *wq, int nreq, struct mlx4_cq *cq)
 	return cur + nreq >= wq->max_post;
 }
 
+static void set_bind_seg(struct mlx4_wqe_bind_seg *bseg, struct ibv_send_wr *wr)
+{
+	int acc = wr->bind_mw.bind_info.mw_access_flags;
+	bseg->flags1 = 0;
+	if (acc & IBV_ACCESS_REMOTE_ATOMIC)
+		bseg->flags1 |= htonl(MLX4_WQE_MW_ATOMIC);
+	if (acc & IBV_ACCESS_REMOTE_WRITE)
+		bseg->flags1 |= htonl(MLX4_WQE_MW_REMOTE_WRITE);
+	if (acc & IBV_ACCESS_REMOTE_READ)
+		bseg->flags1 |= htonl(MLX4_WQE_MW_REMOTE_READ);
+
+	bseg->flags2 = 0;
+	if (((struct ibv_mw *)(wr->bind_mw.mw))->type == IBV_MW_TYPE_2)
+		bseg->flags2 |= htonl(MLX4_WQE_BIND_TYPE_2);
+	if (acc & IBV_ACCESS_ZERO_BASED)
+		bseg->flags2 |= htonl(MLX4_WQE_BIND_ZERO_BASED);
+
+	bseg->new_rkey = htonl(wr->bind_mw.rkey);
+	bseg->lkey = htonl(wr->bind_mw.bind_info.mr->lkey);
+	bseg->addr = htobe64((uint64_t) wr->bind_mw.bind_info.addr);
+	bseg->length = htobe64(wr->bind_mw.bind_info.length);
+}
+
+static inline void set_local_inv_seg(struct mlx4_wqe_local_inval_seg *iseg,
+		uint32_t rkey)
+{
+	iseg->mem_key	= htonl(rkey);
+
+	iseg->reserved1    = 0;
+	iseg->reserved2    = 0;
+	iseg->reserved3[0] = 0;
+	iseg->reserved3[1] = 0;
+}
+
 static inline void set_raddr_seg(struct mlx4_wqe_raddr_seg *rseg,
 				 uint64_t remote_addr, uint32_t rkey)
 {
@@ -278,6 +314,24 @@ int mlx4_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 				size += sizeof (struct mlx4_wqe_raddr_seg) / 16;
 
 				break;
+			case IBV_WR_LOCAL_INV:
+				ctrl->srcrb_flags |=
+					htonl(MLX4_WQE_CTRL_STRONG_ORDER);
+				set_local_inv_seg(wqe, wr->imm_data);
+				wqe  += sizeof
+					(struct mlx4_wqe_local_inval_seg);
+				size += sizeof
+					(struct mlx4_wqe_local_inval_seg) / 16;
+				break;
+			case IBV_WR_BIND_MW:
+				ctrl->srcrb_flags |=
+					htonl(MLX4_WQE_CTRL_STRONG_ORDER);
+				set_bind_seg(wqe, wr);
+				wqe  += sizeof
+					(struct mlx4_wqe_bind_seg);
+				size += sizeof
+					(struct mlx4_wqe_bind_seg) / 16;
+				break;
 
 			default:
 				/* No extra segments required for sends */
diff --git a/src/verbs.c b/src/verbs.c
index 623d576..4ff66aa 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -178,6 +178,71 @@ int mlx4_dereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+struct ibv_mw *mlx4_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type)
+{
+	struct ibv_mw *mw;
+	struct ibv_alloc_mw cmd;
+	struct ibv_alloc_mw_resp resp;
+	int ret;
+
+	mw = malloc(sizeof(*mw));
+	if (!mw)
+		return NULL;
+	memset(mw, 0, sizeof(*mw));
+
+	ret = ibv_cmd_alloc_mw(pd, type, mw, &cmd, sizeof(cmd),
+			     &resp, sizeof(resp));
+
+	if (ret) {
+		free(mw);
+		return NULL;
+	}
+
+	return mw;
+}
+
+int mlx4_dealloc_mw(struct ibv_mw *mw)
+{
+	int ret;
+	struct ibv_dealloc_mw cmd;
+
+	ret = ibv_cmd_dealloc_mw(mw, &cmd, sizeof(cmd));
+	if (ret)
+		return ret;
+
+	free(mw);
+	return 0;
+}
+
+int mlx4_bind_mw(struct ibv_qp *qp, struct ibv_mw *mw,
+		 struct ibv_mw_bind *mw_bind)
+{
+	struct ibv_send_wr *bad_wr = NULL;
+	struct ibv_send_wr wr = { };
+	int ret;
+
+
+	wr.opcode = IBV_WR_BIND_MW;
+	wr.next = NULL;
+
+	wr.wr_id = mw_bind->wr_id;
+	wr.send_flags = mw_bind->send_flags;
+
+	wr.bind_mw.mw = mw;
+	wr.bind_mw.rkey = ibv_inc_rkey(mw->rkey);
+	wr.bind_mw.bind_info = mw_bind->bind_info;
+
+	ret = mlx4_post_send(qp, &wr, &bad_wr);
+
+	if (ret)
+		return ret;
+
+	/* updating the mw with the latest rkey. */
+	mw->rkey = wr.bind_mw.rkey;
+
+	return 0;
+}
+
 int align_queue_size(int req)
 {
 	int nent;
diff --git a/src/wqe.h b/src/wqe.h
index bbd22ba..802a744 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -41,6 +41,12 @@ enum {
 	MLX4_WQE_CTRL_FENCE	= 1 << 6,
 	MLX4_WQE_CTRL_CQ_UPDATE	= 3 << 2,
 	MLX4_WQE_CTRL_SOLICIT	= 1 << 1,
+	MLX4_WQE_CTRL_STRONG_ORDER      = 1 << 7,
+};
+
+enum {
+	MLX4_WQE_BIND_TYPE_2     = (1<<31),
+	MLX4_WQE_BIND_ZERO_BASED = (1<<30),
 };
 
 enum {
@@ -98,6 +104,19 @@ struct mlx4_wqe_srq_next_seg {
 	uint32_t		reserved2[3];
 };
 
+struct mlx4_wqe_local_inval_seg {
+	uint64_t		reserved1;
+	uint32_t		mem_key;
+	uint32_t		reserved2;
+	uint64_t		reserved3[2];
+};
+
+enum {
+	MLX4_WQE_MW_REMOTE_READ   = 1 << 29,
+	MLX4_WQE_MW_REMOTE_WRITE  = 1 << 30,
+	MLX4_WQE_MW_ATOMIC        = 1 << 31
+};
+
 struct mlx4_wqe_raddr_seg {
 	uint64_t		raddr;
 	uint32_t		rkey;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
