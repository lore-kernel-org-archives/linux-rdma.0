From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 30/43] mlx4: Support the new memory registration API
Date: Wed, 22 Jul 2015 09:55:30 +0300
Message-ID: <1437548143-24893-31-git-send-email-sagig@mellanox.com>
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
 drivers/infiniband/hw/mlx4/main.c    |  1 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  3 +++
 drivers/infiniband/hw/mlx4/mr.c      | 11 +++++++++++
 drivers/infiniband/hw/mlx4/qp.c      | 27 +++++++++++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 829fcf4..f2d101c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2298,6 +2298,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.rereg_user_mr	= mlx4_ib_rereg_user_mr;
 	ibdev->ib_dev.dereg_mr		= mlx4_ib_dereg_mr;
 	ibdev->ib_dev.alloc_mr		= mlx4_ib_alloc_mr;
+	ibdev->ib_dev.map_mr_sg		= mlx4_ib_map_mr_sg;
 	ibdev->ib_dev.alloc_fast_reg_page_list = mlx4_ib_alloc_fast_reg_page_list;
 	ibdev->ib_dev.free_fast_reg_page_list  = mlx4_ib_free_fast_reg_page_list;
 	ibdev->ib_dev.attach_mcast	= mlx4_ib_mcg_attach;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index a9a4a7f..e5c7292 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -689,6 +689,9 @@ struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_entries,
 			       u32 flags);
+int mlx4_ib_map_mr_sg(struct ib_mr *ibmr,
+		      struct scatterlist *sg,
+		      unsigned short sg_nents);
 struct ib_fast_reg_page_list *mlx4_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
 							       int page_list_len);
 void mlx4_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 01e16bc..9a86829 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -574,3 +574,14 @@ int mlx4_ib_fmr_dealloc(struct ib_fmr *ibfmr)
 
 	return err;
 }
+
+int mlx4_ib_map_mr_sg(struct ib_mr *ibmr,
+		      struct scatterlist *sg,
+		      unsigned short sg_nents)
+{
+	struct mlx4_ib_mr *mr = to_mmr(ibmr);
+
+	return ib_sg_to_pages(sg, sg_nents, mr->max_pages,
+			      mr->pl, &mr->npages,
+			      &ibmr->length, &ibmr->iova);
+}
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c5a3a5f..492e799 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2401,6 +2401,25 @@ static __be32 convert_access(int acc)
 		cpu_to_be32(MLX4_WQE_FMR_PERM_LOCAL_READ);
 }
 
+static void set_fastreg_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
+{
+	struct mlx4_ib_mr *mr = to_mmr(wr->wr.fastreg.mr);
+	int i;
+
+	for (i = 0; i < mr->npages; ++i)
+		mr->mpl[i] = cpu_to_be64(mr->pl[i] | MLX4_MTT_FLAG_PRESENT);
+
+	fseg->flags		= convert_access(mr->ibmr.access);
+	fseg->mem_key		= cpu_to_be32(wr->wr.fastreg.key);
+	fseg->buf_list		= cpu_to_be64(mr->pl_map);
+	fseg->start_addr	= cpu_to_be64(mr->ibmr.iova);
+	fseg->reg_len		= cpu_to_be64(mr->ibmr.length);
+	fseg->offset		= 0; /* XXX -- is this just for ZBVA? */
+	fseg->page_size		= cpu_to_be32(PAGE_SHIFT);
+	fseg->reserved[0]	= 0;
+	fseg->reserved[1]	= 0;
+}
+
 static void set_fmr_seg(struct mlx4_wqe_fmr_seg *fseg, struct ib_send_wr *wr)
 {
 	struct mlx4_ib_fast_reg_page_list *mfrpl = to_mfrpl(wr->wr.fast_reg.page_list);
@@ -2759,6 +2778,14 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				size += sizeof (struct mlx4_wqe_fmr_seg) / 16;
 				break;
 
+			case IB_WR_FASTREG_MR:
+				ctrl->srcrb_flags |=
+					cpu_to_be32(MLX4_WQE_CTRL_STRONG_ORDER);
+				set_fastreg_seg(wqe, wr);
+				wqe  += sizeof (struct mlx4_wqe_fmr_seg);
+				size += sizeof (struct mlx4_wqe_fmr_seg) / 16;
+				break;
+
 			case IB_WR_BIND_MW:
 				ctrl->srcrb_flags |=
 					cpu_to_be32(MLX4_WQE_CTRL_STRONG_ORDER);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
