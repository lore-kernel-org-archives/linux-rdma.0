From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 41/43] mlx5: Add arbitrary sg list support
Date: Wed, 22 Jul 2015 09:55:41 +0300
Message-ID: <1437548143-24893-42-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If ib_alloc_mr is called with IB_MR_MAP_ARB_SG, the driver
allocate a private klm list instead of a private page list.

And set the UMR wqe correctly when posting the fast registration.

Also, expose device cap IB_DEVICE_MAP_ARB_SG

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |  1 +
 drivers/infiniband/hw/mlx5/mr.c   | 30 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c   | 31 ++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a90ef7a..2402563 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -249,6 +249,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, xrc))
 		props->device_cap_flags |= IB_DEVICE_XRC;
 	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	props->device_cap_flags |= IB_DEVICE_MAP_ARB_SG;
 	if (MLX5_CAP_GEN(mdev, sho)) {
 		props->device_cap_flags |= IB_DEVICE_SIGNATURE_HANDOVER;
 		/* At this stage no support for signature handover */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 45209c7..836e717 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1519,12 +1519,42 @@ done:
 	return ret;
 }
 
+static int
+mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
+		   struct scatterlist *sgl,
+		   unsigned short sg_nents)
+{
+	struct scatterlist *sg = sgl;
+	u32 lkey = mr->ibmr.device->local_dma_lkey;
+	int i;
+
+	if (sg_nents > mr->max_descs)
+		return -EINVAL;
+
+	mr->ibmr.iova = sg_dma_address(sg);
+	mr->ibmr.length = 0;
+	mr->ndescs = sg_nents;
+
+	for (i = 0; i < sg_nents; i++) {
+		mr->klms[i].va = cpu_to_be64(sg_dma_address(sg));
+		mr->klms[i].bcount = cpu_to_be32(sg_dma_len(sg));
+		mr->klms[i].key = cpu_to_be32(lkey);
+		mr->ibmr.length += sg_dma_len(sg);
+		sg = sg_next(sg);
+	}
+
+	return 0;
+}
+
 int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
 		      struct scatterlist *sg,
 		      unsigned short sg_nents)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 
+	if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
+		return mlx5_ib_sg_to_klms(mr, sg, sg_nents);
+
 	return ib_sg_to_pages(sg, sg_nents, mr->max_descs,
 			      mr->pl, &mr->ndescs,
 			      &ibmr->length, &ibmr->iova);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f0a03aa..3fb0396 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1909,6 +1909,10 @@ static void set_fastreg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
 {
 	int ndescs = mr->ndescs;
 
+	if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
+		/* KLMs take twice the size of MTTs */
+		ndescs *= 2;
+
 	memset(umr, 0, sizeof(*umr));
 	umr->flags = MLX5_UMR_CHECK_NOT_FREE;
 	umr->klm_octowords = get_klm_octo(ndescs);
@@ -2012,15 +2016,21 @@ static void set_fastreg_mkey_seg(struct mlx5_mkey_seg *seg,
 {
 	int ndescs = ALIGN(mr->ndescs, 8) >> 1;
 
+	if (mr->access_mode == MLX5_ACCESS_MODE_MTT)
+		seg->log2_page_size = PAGE_SHIFT;
+	else if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
+		/* KLMs take twice the size of MTTs */
+		ndescs *= 2;
+
+
 	memset(seg, 0, sizeof(*seg));
-	seg->flags = get_umr_flags(mr->ibmr.access) | MLX5_ACCESS_MODE_MTT;
+	seg->flags = get_umr_flags(mr->ibmr.access) | mr->access_mode;
 	*writ = seg->flags & (MLX5_PERM_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE);
 	seg->qpn_mkey7_0 = cpu_to_be32((key & 0xff) | 0xffffff00);
 	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
 	seg->start_addr = cpu_to_be64(mr->ibmr.iova);
 	seg->len = cpu_to_be64(mr->ibmr.length);
 	seg->xlt_oct_size = cpu_to_be32(ndescs);
-	seg->log2_page_size = PAGE_SHIFT;
 }
 
 static void set_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *wr,
@@ -2069,12 +2079,19 @@ static void set_fastreg_ds(struct mlx5_wqe_data_seg *dseg,
 			   struct mlx5_ib_pd *pd,
 			   int writ)
 {
-	u64 perm = MLX5_EN_RD | (writ ? MLX5_EN_WR : 0);
-	int bcount = sizeof(u64) * mr->ndescs;
-	int i;
+	int bcount;
+
+	if (mr->access_mode == MLX5_ACCESS_MODE_MTT) {
+		u64 perm = MLX5_EN_RD | (writ ? MLX5_EN_WR : 0);
+		int i;
+
+		bcount = sizeof(u64) * mr->ndescs;
+		for (i = 0; i < mr->ndescs; i++)
+			mr->mpl[i] = cpu_to_be64(mr->pl[i] | perm);
+	} else {
+		bcount = sizeof(struct mlx5_klm) * mr->ndescs;
+	}
 
-	for (i = 0; i < mr->ndescs; i++)
-		mr->mpl[i] = cpu_to_be64(mr->pl[i] | perm);
 
 	dseg->addr = cpu_to_be64(mr->pl_map);
 	dseg->byte_count = cpu_to_be32(ALIGN(bcount, 64));
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
