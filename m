From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] mlx5: Add arbitrary sg list support
Date: Mon, 29 Feb 2016 19:07:33 +0200
Message-ID: <1456765654-27592-3-git-send-email-sagig@mellanox.com>
References: <1456765654-27592-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456765654-27592-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allocate proper context for arbitrary scatterlist registration
If ib_alloc_mr is called with IB_MR_MAP_ARB_SG, the driver
allocate a private klm list instead of a private page list.
Set the UMR wqe correctly when posting the fast registration.

Also, expose device cap IB_DEVICE_MAP_ARB_SG according to the
device id (until we have a FW bit that correctly exposes it).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  2 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/mr.c      | 50 +++++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/qp.c      | 15 +++++++++--
 4 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bccd11837bcf..90c5e2423242 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -491,6 +491,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_MEM_WINDOW |
 					   IB_DEVICE_MEM_WINDOW_TYPE_2B;
 		props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
+		/* We support 'Gappy' memory registration too */
+		props->device_cap_flags |= IB_DEVICE_SG_GAPS_REG;
 	}
 	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	if (MLX5_CAP_GEN(mdev, sho)) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 86ab9b83a1fd..b007f66c6bed 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -413,6 +413,7 @@ struct mlx5_ib_mr {
 	int			ndescs;
 	int			max_descs;
 	int			desc_size;
+	int			access_mode;
 	struct mlx5_core_mkey	mmkey;
 	struct ib_umem	       *umem;
 	struct mlx5_shared_mr_info	*smr_info;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 25c56b562315..967ac89a1d7f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1300,8 +1300,8 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_create_mkey_mbox_in *in;
 	struct mlx5_ib_mr *mr;
-	int access_mode, err;
-	int ndescs = roundup(max_num_sg, 4);
+	int ndescs = ALIGN(max_num_sg, 4);
+	int err;
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
@@ -1319,7 +1319,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
 
 	if (mr_type == IB_MR_TYPE_MEM_REG) {
-		access_mode = MLX5_ACCESS_MODE_MTT;
+		mr->access_mode = MLX5_ACCESS_MODE_MTT;
 		in->seg.log2_page_size = PAGE_SHIFT;
 
 		err = mlx5_alloc_priv_descs(pd->device, mr,
@@ -1329,6 +1329,15 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 
 		mr->desc_size = sizeof(u64);
 		mr->max_descs = ndescs;
+	} else if (mr_type == IB_MR_TYPE_SG_GAPS) {
+		mr->access_mode = MLX5_ACCESS_MODE_KLM;
+
+		err = mlx5_alloc_priv_descs(pd->device, mr,
+					    ndescs, sizeof(struct mlx5_klm));
+		if (err)
+			goto err_free_in;
+		mr->desc_size = sizeof(struct mlx5_klm);
+		mr->max_descs = ndescs;
 	} else if (mr_type == IB_MR_TYPE_SIGNATURE) {
 		u32 psv_index[2];
 
@@ -1347,7 +1356,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 		if (err)
 			goto err_free_sig;
 
-		access_mode = MLX5_ACCESS_MODE_KLM;
+		mr->access_mode = MLX5_ACCESS_MODE_KLM;
 		mr->sig->psv_memory.psv_idx = psv_index[0];
 		mr->sig->psv_wire.psv_idx = psv_index[1];
 
@@ -1361,7 +1370,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 		goto err_free_in;
 	}
 
-	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
+	in->seg.flags = MLX5_PERM_UMR_EN | mr->access_mode;
 	err = mlx5_core_create_mkey(dev->mdev, &mr->mmkey, in, sizeof(*in),
 				    NULL, NULL, NULL);
 	if (err)
@@ -1482,6 +1491,32 @@ done:
 	return ret;
 }
 
+static int
+mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
+		   struct scatterlist *sgl,
+		   unsigned short sg_nents)
+{
+	struct scatterlist *sg = sgl;
+	struct mlx5_klm *klms = mr->descs;
+	u32 lkey = mr->ibmr.pd->local_dma_lkey;
+	int i;
+
+	mr->ibmr.iova = sg_dma_address(sg);
+	mr->ibmr.length = 0;
+	mr->ndescs = sg_nents;
+
+	for_each_sg(sgl, sg, sg_nents, i) {
+		if (unlikely(i > mr->max_descs))
+			break;
+		klms[i].va = cpu_to_be64(sg_dma_address(sg));
+		klms[i].bcount = cpu_to_be32(sg_dma_len(sg));
+		klms[i].key = cpu_to_be32(lkey);
+		mr->ibmr.length += sg_dma_len(sg);
+	}
+
+	return i;
+}
+
 static int mlx5_set_page(struct ib_mr *ibmr, u64 addr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
@@ -1509,7 +1544,10 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
 				   mr->desc_size * mr->max_descs,
 				   DMA_TO_DEVICE);
 
-	n = ib_sg_to_pages(ibmr, sg, sg_nents, mlx5_set_page);
+	if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
+		n = mlx5_ib_sg_to_klms(mr, sg, sg_nents);
+	else
+		n = ib_sg_to_pages(ibmr, sg, sg_nents, mlx5_set_page);
 
 	ib_dma_sync_single_for_device(ibmr->device, mr->desc_map,
 				      mr->desc_size * mr->max_descs,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 34cb8e87c7b8..3aff9658696e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2509,6 +2509,11 @@ static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
 	int ndescs = mr->ndescs;
 
 	memset(umr, 0, sizeof(*umr));
+
+	if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
+		/* KLMs take twice the size of MTTs */
+		ndescs *= 2;
+
 	umr->flags = MLX5_UMR_CHECK_NOT_FREE;
 	umr->klm_octowords = get_klm_octo(ndescs);
 	umr->mkey_mask = frwr_mkey_mask();
@@ -2603,13 +2608,19 @@ static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
 	int ndescs = ALIGN(mr->ndescs, 8) >> 1;
 
 	memset(seg, 0, sizeof(*seg));
-	seg->flags = get_umr_flags(access) | MLX5_ACCESS_MODE_MTT;
+
+	if (mr->access_mode == MLX5_ACCESS_MODE_MTT)
+		seg->log2_page_size = ilog2(mr->ibmr.page_size);
+	else if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
+		/* KLMs take twice the size of MTTs */
+		ndescs *= 2;
+
+	seg->flags = get_umr_flags(access) | mr->access_mode;
 	seg->qpn_mkey7_0 = cpu_to_be32((key & 0xff) | 0xffffff00);
 	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
 	seg->start_addr = cpu_to_be64(mr->ibmr.iova);
 	seg->len = cpu_to_be64(mr->ibmr.length);
 	seg->xlt_oct_size = cpu_to_be32(ndescs);
-	seg->log2_page_size = ilog2(mr->ibmr.page_size);
 }
 
 static void set_linv_mkey_seg(struct mlx5_mkey_seg *seg)
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
