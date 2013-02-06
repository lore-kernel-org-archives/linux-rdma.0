From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 09/10] IB/mlx4_ib: Support memory window binding
Date: Wed,  6 Feb 2013 18:19:15 +0200
Message-ID: <1360167556-20756-10-git-send-email-ogerlitz@mellanox.com>
References: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360167556-20756-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

* Implement memory windows binding in mlx4_ib_post_send.

* Implement mlx4_ib_bind_mw by deferring to mlx4_ib_post_send.

* Rename MLX4_WQE_FMR_PERM_* flags to MLX4_WQE_FMR_AND_BIND_PERM_*,
  indicating that they are used both for fast registration work
  requests, and for memory window bind work requests.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    2 +
 drivers/infiniband/hw/mlx4/mr.c      |   22 +++++++++++++++++++++
 drivers/infiniband/hw/mlx4/qp.c      |   35 +++++++++++++++++++++++++++++++--
 include/linux/mlx4/qp.h              |   11 +++++++--
 4 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6d28491..5a21783 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -592,6 +592,8 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  struct ib_udata *udata);
 int mlx4_ib_dereg_mr(struct ib_mr *mr);
 struct ib_mw *mlx4_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
+int mlx4_ib_bind_mw(struct ib_qp *qp, struct ib_mw *mw,
+		    struct ib_mw_bind *mw_bind);
 int mlx4_ib_dealloc_mw(struct ib_mw *mw);
 struct ib_mr *mlx4_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 5adf4c4..e471f08 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -231,6 +231,28 @@ err_free:
 	return ERR_PTR(err);
 }
 
+int mlx4_ib_bind_mw(struct ib_qp *qp, struct ib_mw *mw,
+		    struct ib_mw_bind *mw_bind)
+{
+	struct ib_send_wr  wr;
+	struct ib_send_wr *bad_wr;
+	int ret;
+
+	memset(&wr, 0, sizeof(wr));
+	wr.opcode               = IB_WR_BIND_MW;
+	wr.wr_id                = mw_bind->wr_id;
+	wr.send_flags           = mw_bind->send_flags;
+	wr.wr.bind_mw.mw        = mw;
+	wr.wr.bind_mw.bind_info = mw_bind->bind_info;
+	wr.wr.bind_mw.rkey      = ib_inc_rkey(mw->rkey);
+
+	ret = mlx4_ib_post_send(qp, &wr, &bad_wr);
+	if (!ret)
+		mw->rkey = wr.wr.bind_mw.rkey;
+
+	return ret;
+}
+
 int mlx4_ib_dealloc_mw(struct ib_mw *ibmw)
 {
 	struct mlx4_ib_mw *mw = to_mmw(ibmw);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c6dde71..93bdae5 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -104,6 +104,7 @@ static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_FAST_REG_MR]			= cpu_to_be32(MLX4_OPCODE_FMR),
 	[IB_WR_MASKED_ATOMIC_CMP_AND_SWP]	= cpu_to_be32(MLX4_OPCODE_MASKED_ATOMIC_CS),
 	[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD]	= cpu_to_be32(MLX4_OPCODE_MASKED_ATOMIC_FA),
+	[IB_WR_BIND_MW]				= cpu_to_be32(MLX4_OPCODE_BIND_MW),
 };
 
 static struct mlx4_ib_sqp *to_msqp(struct mlx4_ib_qp *mqp)
@@ -1953,9 +1954,12 @@ static int mlx4_wq_overflow(struct mlx4_ib_wq *wq, int nreq, struct ib_cq *ib_cq
 
 static __be32 convert_access(int acc)
 {
-	return (acc & IB_ACCESS_REMOTE_ATOMIC ? cpu_to_be32(MLX4_WQE_FMR_PERM_ATOMIC)       : 0) |
-	       (acc & IB_ACCESS_REMOTE_WRITE  ? cpu_to_be32(MLX4_WQE_FMR_PERM_REMOTE_WRITE) : 0) |
-	       (acc & IB_ACCESS_REMOTE_READ   ? cpu_to_be32(MLX4_WQE_FMR_PERM_REMOTE_READ)  : 0) |
+	return (acc & IB_ACCESS_REMOTE_ATOMIC ?
+		cpu_to_be32(MLX4_WQE_FMR_AND_BIND_PERM_ATOMIC)       : 0) |
+	       (acc & IB_ACCESS_REMOTE_WRITE  ?
+		cpu_to_be32(MLX4_WQE_FMR_AND_BIND_PERM_REMOTE_WRITE) : 0) |
+	       (acc & IB_ACCESS_REMOTE_READ   ?
+		cpu_to_be32(MLX4_WQE_FMR_AND_BIND_PERM_REMOTE_READ)  : 0) |
 	       (acc & IB_ACCESS_LOCAL_WRITE   ? cpu_to_be32(MLX4_WQE_FMR_PERM_LOCAL_WRITE)  : 0) |
 		cpu_to_be32(MLX4_WQE_FMR_PERM_LOCAL_READ);
 }
@@ -1981,6 +1985,24 @@ static void set_fmr_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
 	fseg->reserved[1]	= 0;
 }
 
+static void set_bind_seg(struct mlx4_wqe_bind_seg *bseg, struct ib_send_wr *wr)
+{
+	bseg->flags1 =
+		convert_access(wr->wr.bind_mw.bind_info.mw_access_flags) &
+		cpu_to_be32(MLX4_WQE_FMR_AND_BIND_PERM_REMOTE_READ  |
+			    MLX4_WQE_FMR_AND_BIND_PERM_REMOTE_WRITE |
+			    MLX4_WQE_FMR_AND_BIND_PERM_ATOMIC);
+	bseg->flags2 = 0;
+	if (wr->wr.bind_mw.mw->type == IB_MW_TYPE_2)
+		bseg->flags2 |= cpu_to_be32(MLX4_WQE_BIND_TYPE_2);
+	if (wr->wr.bind_mw.bind_info.mw_access_flags & IB_ZERO_BASED)
+		bseg->flags2 |= cpu_to_be32(MLX4_WQE_BIND_ZERO_BASED);
+	bseg->new_rkey = cpu_to_be32(wr->wr.bind_mw.rkey);
+	bseg->lkey = cpu_to_be32(wr->wr.bind_mw.bind_info.mr->lkey);
+	bseg->addr = cpu_to_be64(wr->wr.bind_mw.bind_info.addr);
+	bseg->length = cpu_to_be64(wr->wr.bind_mw.bind_info.length);
+}
+
 static void set_local_inv_seg(struct mlx4_wqe_local_inval_seg *iseg, u32 rkey)
 {
 	memset(iseg, 0, sizeof(*iseg));
@@ -2289,6 +2311,13 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				size += sizeof (struct mlx4_wqe_fmr_seg) / 16;
 				break;
 
+			case IB_WR_BIND_MW:
+				ctrl->srcrb_flags |=
+					cpu_to_be32(MLX4_WQE_CTRL_STRONG_ORDER);
+				set_bind_seg(wqe, wr);
+				wqe  += sizeof(struct mlx4_wqe_bind_seg);
+				size += sizeof(struct mlx4_wqe_bind_seg) / 16;
+				break;
 			default:
 				/* No extra segments required for sends */
 				break;
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 6c8a68c..77ca1a4 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -265,6 +265,11 @@ struct mlx4_wqe_lso_seg {
 	__be32			header[0];
 };
 
+enum mlx4_wqe_bind_seg_flags2 {
+	MLX4_WQE_BIND_TYPE_2     = (1<<31),
+	MLX4_WQE_BIND_ZERO_BASED = (1<<30),
+};
+
 struct mlx4_wqe_bind_seg {
 	__be32			flags1;
 	__be32			flags2;
@@ -277,9 +282,9 @@ struct mlx4_wqe_bind_seg {
 enum {
 	MLX4_WQE_FMR_PERM_LOCAL_READ	= 1 << 27,
 	MLX4_WQE_FMR_PERM_LOCAL_WRITE	= 1 << 28,
-	MLX4_WQE_FMR_PERM_REMOTE_READ	= 1 << 29,
-	MLX4_WQE_FMR_PERM_REMOTE_WRITE	= 1 << 30,
-	MLX4_WQE_FMR_PERM_ATOMIC	= 1 << 31
+	MLX4_WQE_FMR_AND_BIND_PERM_REMOTE_READ	= 1 << 29,
+	MLX4_WQE_FMR_AND_BIND_PERM_REMOTE_WRITE	= 1 << 30,
+	MLX4_WQE_FMR_AND_BIND_PERM_ATOMIC	= 1 << 31
 };
 
 struct mlx4_wqe_fmr_seg {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
