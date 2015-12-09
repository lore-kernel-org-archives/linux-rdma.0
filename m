From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5] Add support for standard atomic operations
Date: Wed,  9 Dec 2015 16:24:06 +0200
Message-ID: <1449671047-17834-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Eli,
Added here support for atomic standard operations.
Kernel part of query_device was sent to the mailing list also.
Obviously, it will functionality work only with kernel patches applied.

Thanks,
Eran
 src/mlx5.c  |  8 ++++++++
 src/mlx5.h  |  2 ++
 src/qp.c    | 50 +++++++++++++++++++++++++++++++++++++++++++++-----
 src/verbs.c |  2 ++
 4 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/src/mlx5.c b/src/mlx5.c
index e44898a..078ac8a 100644
--- a/src/mlx5.c
+++ b/src/mlx5.c
@@ -472,6 +472,8 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	off_t				offset;
 	struct mlx5_device	       *mdev;
 	struct verbs_context	       *v_ctx;
+	struct ibv_device_attr		attr;
+	int				err;
 
 	mdev = to_mdev(&vdev->device);
 	v_ctx = verbs_get_ctx(ctx);
@@ -585,6 +587,12 @@ static int mlx5_init_context(struct verbs_device *vdev,
 	verbs_set_ctx_op(v_ctx, get_srq_num, mlx5_get_srq_num);
 	verbs_set_ctx_op(v_ctx, query_device_ex, mlx5_query_device_ex);
 
+	err = mlx5_query_device(ctx, &attr);
+	if (err)
+		goto err_free_bf;
+
+	context->atomic_cap = attr.atomic_cap;
+
 	return 0;
 
 err_free_bf:
diff --git a/src/mlx5.h b/src/mlx5.h
index 9181ec5..704a922 100644
--- a/src/mlx5.h
+++ b/src/mlx5.h
@@ -282,6 +282,7 @@ struct mlx5_context {
 	char				hostname[40];
 	struct mlx5_spinlock            hugetlb_lock;
 	struct list_head                hugetlb_list;
+	enum ibv_atomic_cap             atomic_cap;
 };
 
 struct mlx5_bitmap {
@@ -405,6 +406,7 @@ struct mlx5_qp {
 	uint32_t                       *db;
 	struct mlx5_wq                  rq;
 	int                             wq_sig;
+	int				atomics_enabled;
 };
 
 struct mlx5_av {
diff --git a/src/qp.c b/src/qp.c
index 67ded0d..841788c 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -180,6 +180,20 @@ static inline void set_raddr_seg(struct mlx5_wqe_raddr_seg *rseg,
 	rseg->reserved = 0;
 }
 
+static void set_atomic_seg(struct mlx5_wqe_atomic_seg *aseg,
+			   enum ibv_wr_opcode   opcode,
+			   uint64_t swap,
+			   uint64_t compare_add)
+{
+	if (opcode == IBV_WR_ATOMIC_CMP_AND_SWP) {
+		aseg->swap_add = htonll(swap);
+		aseg->compare  = htonll(compare_add);
+	} else {
+		aseg->swap_add = htonll(compare_add);
+		aseg->compare  = 0;
+	}
+}
+
 static void set_datagram_seg(struct mlx5_wqe_datagram_seg *dseg,
 			     struct ibv_send_wr *wr)
 {
@@ -336,6 +350,7 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	void *qend = qp->sq.qend;
 	uint32_t mlx5_opcode;
 	struct mlx5_wqe_xrc_seg *xrc;
+	int atom_arg = 0;
 #ifdef MLX5_DEBUG
 	FILE *fp = to_mctx(ibqp->context)->dbg_fp;
 #endif
@@ -405,10 +420,25 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 
 			case IBV_WR_ATOMIC_CMP_AND_SWP:
 			case IBV_WR_ATOMIC_FETCH_AND_ADD:
-				fprintf(stderr, "atomic operations are not supported yet\n");
-				err = ENOSYS;
-				*bad_wr = wr;
-				goto out;
+				if (unlikely(!qp->atomics_enabled)) {
+					mlx5_dbg(fp, MLX5_DBG_QP_SEND, "atomic operations are not supported\n");
+					err = ENOSYS;
+					*bad_wr = wr;
+					goto out;
+				}
+				set_raddr_seg(seg, wr->wr.atomic.remote_addr,
+					      wr->wr.atomic.rkey);
+				seg  += sizeof(struct mlx5_wqe_raddr_seg);
+
+				set_atomic_seg(seg, wr->opcode,
+					       wr->wr.atomic.swap,
+					       wr->wr.atomic.compare_add);
+				seg  += sizeof(struct mlx5_wqe_atomic_seg);
+
+				size += (sizeof(struct mlx5_wqe_raddr_seg) +
+				sizeof(struct mlx5_wqe_atomic_seg)) / 16;
+				atom_arg = 8;
+				break;
 
 			default:
 				break;
@@ -462,7 +492,17 @@ int mlx5_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 					dpseg = seg;
 				}
 				if (likely(wr->sg_list[i].length)) {
-					set_data_ptr_seg(dpseg, wr->sg_list + i);
+					struct ibv_sge sge;
+					struct ibv_sge *psge;
+
+					if (unlikely(atom_arg)) {
+						sge = wr->sg_list[i];
+						sge.length = atom_arg;
+						psge = &sge;
+					} else {
+						psge = wr->sg_list + i;
+					}
+					set_data_ptr_seg(dpseg, psge);
 					++dpseg;
 					size += sizeof(struct mlx5_wqe_data_seg) / 16;
 				}
diff --git a/src/verbs.c b/src/verbs.c
index 8cbdd68..f96790b 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1001,6 +1001,8 @@ struct ibv_qp *create_qp(struct ibv_context *context,
 	qp->db[MLX5_RCV_DBR] = 0;
 	qp->db[MLX5_SND_DBR] = 0;
 
+	if (ctx->atomic_cap == IBV_ATOMIC_HCA)
+		qp->atomics_enabled = 1;
 
 	pthread_mutex_lock(&ctx->qp_table_mutex);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
