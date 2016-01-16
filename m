From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH libmlx5 V1 2/2] Add cross-channel work request opcodes
Date: Sat, 16 Jan 2016 17:55:58 +0200
Message-ID: <1452959758-29611-3-git-send-email-leon@leon.nu>
References: <1452959758-29611-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452959758-29611-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The cross-channel feature relies on special primitives to
send and receive work requests.

* WAIT on CQ WR - This work request holds execution of subsequent
  requests on that queue until this number of completions of a CQ
  is met.

=E2=80=A2 SEND_EN WR - This work request specifies value of producer
  index on the controlled send queue. It enables the execution
  of all WQEs up to the work request which is marked by
  IBV_SEND_WAIT_EN_LAST flag.

=E2=80=A2 RECEIVE_EN WR - Same as SEND_EN but related to a receive
  queue.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/mlx5.h  |   9 ++++++
 src/qp.c    | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++----
 src/verbs.c |  14 +++++++++
 src/wqe.h   |   5 +++
 4 files changed, 122 insertions(+), 6 deletions(-)

diff --git a/src/mlx5.h b/src/mlx5.h
index 38f5f518a94b..a8e1ad6dda74 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -208,6 +208,10 @@ enum {
 	MLX5_OPCODE_LOCAL_INVAL		=3D 0x1b,
 	MLX5_OPCODE_CONFIG_CMD		=3D 0x1f,
=20
+	MLX5_OPCODE_SEND_ENABLE         =3D 0x17,
+	MLX5_OPCODE_RECV_ENABLE         =3D 0x16,
+	MLX5_OPCODE_CQE_WAIT            =3D 0x0f,
+
 	MLX5_RECV_OPCODE_RDMA_WRITE_IMM	=3D 0x00,
 	MLX5_RECV_OPCODE_SEND		=3D 0x01,
 	MLX5_RECV_OPCODE_SEND_IMM	=3D 0x02,
@@ -368,6 +372,8 @@ struct mlx5_cq {
 	uint64_t			stall_last_count;
 	int				stall_adaptive_enable;
 	int				stall_cycles;
+	uint32_t			wait_index;
+	uint32_t			wait_count;
 };
=20
 struct mlx5_srq {
@@ -405,6 +411,8 @@ struct mlx5_wq {
 	int				wqe_shift;
 	int				offset;
 	void			       *qend;
+	uint32_t			head_en_index;
+	uint32_t			head_en_count;
 };
=20
 struct mlx5_bf {
@@ -437,6 +445,7 @@ struct mlx5_qp {
 	uint32_t                       *db;
 	struct mlx5_wq                  rq;
 	int                             wq_sig;
+	uint32_t			create_flags;
 };
=20
 struct mlx5_av {
diff --git a/src/qp.c b/src/qp.c
index 67ded0d197d3..f84684e69d86 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -54,8 +54,20 @@ static const uint32_t mlx5_ib_opcode[] =3D {
 	[IBV_WR_RDMA_READ]		=3D MLX5_OPCODE_RDMA_READ,
 	[IBV_WR_ATOMIC_CMP_AND_SWP]	=3D MLX5_OPCODE_ATOMIC_CS,
 	[IBV_WR_ATOMIC_FETCH_AND_ADD]	=3D MLX5_OPCODE_ATOMIC_FA,
+	[IBV_WR_SEND_ENABLE]		=3D MLX5_OPCODE_SEND_ENABLE,
+	[IBV_WR_RECV_ENABLE]		=3D MLX5_OPCODE_RECV_ENABLE,
+	[IBV_WR_CQE_WAIT]		=3D MLX5_OPCODE_CQE_WAIT
 };
=20
+static inline void set_wait_en_seg(void *wqe_seg, uint32_t obj_num, ui=
nt32_t count)
+{
+	struct mlx5_wqe_wait_en_seg *seg =3D (struct mlx5_wqe_wait_en_seg *)w=
qe_seg;
+
+	seg->pi      =3D htonl(count);
+	seg->obj_num =3D htonl(obj_num);
+	return;
+}
+
 static void *get_recv_wqe(struct mlx5_qp *qp, int n)
 {
 	return qp->buf.buf + qp->rq.offset + (n << qp->rq.wqe_shift);
@@ -155,6 +167,10 @@ void mlx5_init_qp_indices(struct mlx5_qp *qp)
 	qp->rq.head	 =3D 0;
 	qp->rq.tail	 =3D 0;
 	qp->sq.cur_post  =3D 0;
+	qp->sq.head_en_index =3D 0;
+	qp->sq.head_en_count =3D 0;
+	qp->rq.head_en_index =3D 0;
+	qp->rq.head_en_count =3D 0;
 }
=20
 static int mlx5_wq_overflow(struct mlx5_wq *wq, int nreq, struct mlx5_=
cq *cq)
@@ -336,6 +352,11 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv=
_send_wr *wr,
 	void *qend =3D qp->sq.qend;
 	uint32_t mlx5_opcode;
 	struct mlx5_wqe_xrc_seg *xrc;
+	struct mlx5_cq *wait_cq;
+	uint32_t wait_index =3D 0;
+	unsigned head_en_index;
+	struct mlx5_wq *wq;
+
 #ifdef MLX5_DEBUG
 	FILE *fp =3D to_mctx(ibqp->context)->dbg_fp;
 #endif
@@ -352,11 +373,10 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ib=
v_send_wr *wr,
 			goto out;
 		}
=20
-		if (unlikely(mlx5_wq_overflow(&qp->sq, nreq,
+		if (unlikely(!(qp->create_flags & IBV_QP_CREATE_IGNORE_SQ_OVERFLOW) =
&& mlx5_wq_overflow(&qp->sq, nreq,
 					      to_mcq(qp->ibv_qp->send_cq)))) {
 			mlx5_dbg(fp, MLX5_DBG_QP_SEND, "work queue overflow\n");
-			errno =3D ENOMEM;
-			err =3D -1;
+			err =3D ENOMEM;
 			*bad_wr =3D wr;
 			goto out;
 		}
@@ -409,7 +429,69 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv=
_send_wr *wr,
 				err =3D ENOSYS;
 				*bad_wr =3D wr;
 				goto out;
+			case IBV_WR_CQE_WAIT:
+				if (!(qp->create_flags & IBV_QP_CREATE_CROSS_CHANNEL)) {
+					err =3D EINVAL;
+					*bad_wr =3D wr;
+					goto out;
+				}
+
+				wait_cq =3D to_mcq(wr->wr.cqe_wait.cq);
+				wait_index =3D wait_cq->wait_index + wr->wr.cqe_wait.cq_count;
+				wait_cq->wait_count =3D max(wait_cq->wait_count, wr->wr.cqe_wait.c=
q_count);
+				if (wr->send_flags & IBV_SEND_WAIT_EN_LAST) {
+					wait_cq->wait_index +=3D wait_cq->wait_count;
+					wait_cq->wait_count =3D 0;
+				}
+				set_wait_en_seg(seg, wait_cq->cqn, wait_index);
+				seg +=3D sizeof(struct mlx5_wqe_wait_en_seg);
+				size +=3D sizeof(struct mlx5_wqe_wait_en_seg) / 16;
+				break;
=20
+			case IBV_WR_SEND_ENABLE:
+			case IBV_WR_RECV_ENABLE:
+				if (((wr->opcode =3D=3D IBV_WR_SEND_ENABLE) &&
+					!(to_mqp(wr->wr.wqe_enable.qp)->create_flags &
+							IBV_QP_CREATE_MANAGED_SEND)) ||
+					((wr->opcode =3D=3D IBV_WR_RECV_ENABLE) &&
+					!(to_mqp(wr->wr.wqe_enable.qp)->create_flags &
+							IBV_QP_CREATE_MANAGED_RECV))) {
+					err =3D EINVAL;
+					*bad_wr =3D wr;
+					goto out;
+				}
+
+				wq =3D (wr->opcode =3D=3D IBV_WR_SEND_ENABLE) ?
+					&to_mqp(wr->wr.wqe_enable.qp)->sq :
+					&to_mqp(wr->wr.wqe_enable.qp)->rq;
+
+				/* If wqe_count is 0 release all WRs from queue */
+				if (wr->wr.wqe_enable.wqe_count) {
+					head_en_index =3D wq->head_en_index +
+								wr->wr.wqe_enable.wqe_count;
+					wq->head_en_count =3D max(wq->head_en_count,
+								wr->wr.wqe_enable.wqe_count);
+
+					if ((int)(wq->head - head_en_index) < 0) {
+						err =3D EINVAL;
+						*bad_wr =3D wr;
+						goto out;
+					}
+				} else {
+					head_en_index =3D wq->head;
+					wq->head_en_count =3D wq->head - wq->head_en_index;
+				}
+
+				if (wr->send_flags & IBV_SEND_WAIT_EN_LAST) {
+					wq->head_en_index +=3D wq->head_en_count;
+					wq->head_en_count =3D 0;
+				}
+
+				set_wait_en_seg(seg, wr->wr.wqe_enable.qp->qp_num, head_en_index);
+
+				seg +=3D sizeof(struct mlx5_wqe_wait_en_seg);
+				size +=3D sizeof(struct mlx5_wqe_wait_en_seg) / 16;
+				break;
 			default:
 				break;
 			}
@@ -492,6 +574,11 @@ out:
 	if (likely(nreq)) {
 		qp->sq.head +=3D nreq;
=20
+		if (qp->create_flags & IBV_QP_CREATE_MANAGED_SEND) {
+			wmb();
+			goto post_send_no_db;
+		}
+
 		/*
 		 * Make sure that descriptors are written before
 		 * updating doorbell record and ringing the doorbell
@@ -528,6 +615,7 @@ out:
 			mlx5_spin_unlock(&bf->lock);
 	}
=20
+post_send_no_db:
 	mlx5_spin_unlock(&qp->sq.lock);
=20
 	return err;
@@ -561,11 +649,11 @@ int mlx5_post_recv(struct ibv_qp *ibqp, struct ib=
v_recv_wr *wr,
 	ind =3D qp->rq.head & (qp->rq.wqe_cnt - 1);
=20
 	for (nreq =3D 0; wr; ++nreq, wr =3D wr->next) {
-		if (unlikely(mlx5_wq_overflow(&qp->rq, nreq,
+		if (unlikely(!(qp->create_flags & IBV_QP_CREATE_IGNORE_RQ_OVERFLOW) =
&&
+				mlx5_wq_overflow(&qp->rq, nreq,
 					      to_mcq(qp->ibv_qp->recv_cq)))) {
-			errno =3D ENOMEM;
+			err =3D ENOMEM;
 			*bad_wr =3D wr;
-			err =3D -1;
 			goto out;
 		}
=20
diff --git a/src/verbs.c b/src/verbs.c
index 064a500b0a06..15e34488883f 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -309,6 +309,9 @@ static struct ibv_cq *create_cq(struct ibv_context =
*context,
 	}
=20
 	cq->cons_index =3D 0;
+	/* Cross-channel wait index should start from value below 0 */
+	cq->wait_index =3D (uint32_t)(-1);
+	cq->wait_count =3D 0;
=20
 	if (mlx5_spinlock_init(&cq->lock))
 		goto err;
@@ -975,6 +978,17 @@ static int init_attr_v2(struct ibv_context *contex=
t, struct mlx5_qp *qp,
 	struct mlx5_create_qp_resp_ex	resp;
 	int err;
=20
+	qp->create_flags =3D (attr->create_flags & (IBV_QP_CREATE_IGNORE_SQ_O=
VERFLOW |
+						  IBV_QP_CREATE_IGNORE_RQ_OVERFLOW |
+						  IBV_QP_CREATE_CROSS_CHANNEL |
+						  IBV_QP_CREATE_MANAGED_SEND |
+						  IBV_QP_CREATE_MANAGED_RECV ));
+	/*
+	 * These QP flags are virtual and don't need to
+	 * be forwarded to the bottom layer.
+	 */
+	attr->create_flags &=3D ~(IBV_QP_CREATE_IGNORE_SQ_OVERFLOW | IBV_QP_C=
REATE_IGNORE_RQ_OVERFLOW);
+
 	memset(&cmd, 0, sizeof(cmd));
 	memset(&resp, 0, sizeof(resp));
 	if (qp->wq_sig)
diff --git a/src/wqe.h b/src/wqe.h
index bd50d9a116e1..73aeb6aedfd9 100644
--- a/src/wqe.h
+++ b/src/wqe.h
@@ -187,5 +187,10 @@ struct mlx5_wqe_inline_seg {
 	uint32_t	byte_count;
 };
=20
+struct mlx5_wqe_wait_en_seg {
+	uint8_t		rsvd0[8];
+	uint32_t	pi;
+	uint32_t	obj_num;
+};
=20
 #endif /* WQE_H */
--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
