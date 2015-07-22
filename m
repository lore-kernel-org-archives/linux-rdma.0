From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 29/43] mlx5: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:29 +0300
Message-ID: <1437548143-24893-30-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just duplicated the functions to take the needed
arguments from the private MR context. The old
fast_reg routines will be dropped later.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 ++
 drivers/infiniband/hw/mlx5/mr.c      | 11 +++++
 drivers/infiniband/hw/mlx5/qp.c      | 90 ++++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ce75875..a90ef7a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1503,6 +1503,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
 	dev->ib_dev.process_mad		= mlx5_ib_process_mad;
 	dev->ib_dev.alloc_mr		= mlx5_ib_alloc_mr;
+	dev->ib_dev.map_mr_sg		= mlx5_ib_map_mr_sg;
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index df5e959..7017a1a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -582,6 +582,9 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_entries,
 			       u32 flags);
+int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
+		      struct scatterlist *sg,
+		      unsigned short sg_nents);
 struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
 							       int page_list_len);
 void mlx5_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1075065..7a030a2 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1471,3 +1471,14 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 done:
 	return ret;
 }
+
+int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
+		      struct scatterlist *sg,
+		      unsigned short sg_nents)
+{
+	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, mr->max_descs,
+			      mr->pl, &mr->ndescs,
+			      &ibmr->length, &ibmr->iova);
+}
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 203c8a4..f0a03aa 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -65,6 +65,7 @@ static const u32 mlx5_ib_opcode[] = {
 	[IB_WR_SEND_WITH_INV]			= MLX5_OPCODE_SEND_INVAL,
 	[IB_WR_LOCAL_INV]			= MLX5_OPCODE_UMR,
 	[IB_WR_FAST_REG_MR]			= MLX5_OPCODE_UMR,
+	[IB_WR_FASTREG_MR]			= MLX5_OPCODE_UMR,
 	[IB_WR_MASKED_ATOMIC_CMP_AND_SWP]	= MLX5_OPCODE_ATOMIC_MASKED_CS,
 	[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD]	= MLX5_OPCODE_ATOMIC_MASKED_FA,
 	[MLX5_IB_WR_UMR]			= MLX5_OPCODE_UMR,
@@ -1903,6 +1904,17 @@ static __be64 sig_mkey_mask(void)
 	return cpu_to_be64(result);
 }
 
+static void set_fastreg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
+				struct mlx5_ib_mr *mr)
+{
+	int ndescs = mr->ndescs;
+
+	memset(umr, 0, sizeof(*umr));
+	umr->flags = MLX5_UMR_CHECK_NOT_FREE;
+	umr->klm_octowords = get_klm_octo(ndescs);
+	umr->mkey_mask = frwr_mkey_mask();
+}
+
 static void set_frwr_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 				 struct ib_send_wr *wr, int li)
 {
@@ -1994,6 +2006,23 @@ static u8 get_umr_flags(int acc)
 		MLX5_PERM_LOCAL_READ | MLX5_PERM_UMR_EN;
 }
 
+static void set_fastreg_mkey_seg(struct mlx5_mkey_seg *seg,
+				 struct mlx5_ib_mr *mr, u32 key,
+				 int *writ)
+{
+	int ndescs = ALIGN(mr->ndescs, 8) >> 1;
+
+	memset(seg, 0, sizeof(*seg));
+	seg->flags = get_umr_flags(mr->ibmr.access) | MLX5_ACCESS_MODE_MTT;
+	*writ = seg->flags & (MLX5_PERM_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE);
+	seg->qpn_mkey7_0 = cpu_to_be32((key & 0xff) | 0xffffff00);
+	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
+	seg->start_addr = cpu_to_be64(mr->ibmr.iova);
+	seg->len = cpu_to_be64(mr->ibmr.length);
+	seg->xlt_oct_size = cpu_to_be32(ndescs);
+	seg->log2_page_size = PAGE_SHIFT;
+}
+
 static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
 			     int li, int *writ)
 {
@@ -2035,6 +2064,23 @@ static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *w
 				       mlx5_mkey_variant(umrwr->mkey));
 }
 
+static void set_fastreg_ds(struct mlx5_wqe_data_seg *dseg,
+			   struct mlx5_ib_mr *mr,
+			   struct mlx5_ib_pd *pd,
+			   int writ)
+{
+	u64 perm = MLX5_EN_RD | (writ ? MLX5_EN_WR : 0);
+	int bcount = sizeof(u64) * mr->ndescs;
+	int i;
+
+	for (i = 0; i < mr->ndescs; i++)
+		mr->mpl[i] = cpu_to_be64(mr->pl[i] | perm);
+
+	dseg->addr = cpu_to_be64(mr->pl_map);
+	dseg->byte_count = cpu_to_be32(ALIGN(bcount, 64));
+	dseg->lkey = cpu_to_be32(pd->pa_lkey);
+}
+
 static void set_frwr_pages(struct mlx5_wqe_data_seg *dseg,
 			   struct ib_send_wr *wr,
 			   struct mlx5_core_dev *mdev,
@@ -2440,6 +2486,37 @@ static int set_psv_wr(struct ib_sig_domain *domain,
 	return 0;
 }
 
+static int set_fastreg_wr(struct mlx5_ib_qp *qp,
+			  struct ib_send_wr *wr,
+			  void **seg, int *size)
+{
+	struct mlx5_ib_mr *mr = to_mmr(wr->wr.fastreg.mr);
+	struct mlx5_ib_pd *pd = to_mpd(qp->ibqp.pd);
+	u32 key = wr->wr.fastreg.key;
+	int writ = 0;
+
+	if (unlikely(wr->send_flags & IB_SEND_INLINE))
+		return -EINVAL;
+
+	set_fastreg_umr_seg(*seg, mr);
+	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
+	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	set_fastreg_mkey_seg(*seg, mr, key, &writ);
+	*seg += sizeof(struct mlx5_mkey_seg);
+	*size += sizeof(struct mlx5_mkey_seg) / 16;
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	set_fastreg_ds(*seg, mr, pd, writ);
+	*seg += sizeof(struct mlx5_wqe_data_seg);
+	*size += (sizeof(struct mlx5_wqe_data_seg) / 16);
+
+	return 0;
+}
+
 static int set_frwr_li_wr(void **seg, struct ib_send_wr *wr, int *size,
 			  struct mlx5_core_dev *mdev, struct mlx5_ib_pd *pd, struct mlx5_ib_qp *qp)
 {
@@ -2683,6 +2760,19 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				num_sge = 0;
 				break;
 
+			case IB_WR_FASTREG_MR:
+				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
+				qp->sq.wr_data[idx] = IB_WR_FASTREG_MR;
+				ctrl->imm = cpu_to_be32(wr->wr.fastreg.key);
+				err = set_fastreg_wr(qp, wr, &seg, &size);
+				if (err) {
+					mlx5_ib_warn(dev, "\n");
+					*bad_wr = wr;
+					goto out;
+				}
+				num_sge = 0;
+				break;
+
 			case IB_WR_REG_SIG_MR:
 				qp->sq.wr_data[idx] = IB_WR_REG_SIG_MR;
 				mr = to_mmr(wr->wr.sig_handover.sig_mr);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
