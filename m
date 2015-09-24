From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 2/3] mlx5: Add arbitrary sg list support
Date: Thu, 24 Sep 2015 20:41:20 +0300
Message-ID: <1443116481-14533-3-git-send-email-sagig@mellanox.com>
References: <1443116481-14533-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443116481-14533-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allocate proper context for arbitrary scatterlist registration
If ib_alloc_mr is called with IB_MR_MAP_ARB_SG, the driver
allocate a private klm list instead of a private page list.
Set the UMR wqe correctly when posting the fast registration.

Also, expose device cap IB_DEVICE_MAP_ARB_SG according to the
device id (until we have a FW bit that correctly exposes it).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  4 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/mr.c      | 50 +++++++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/qp.c      | 15 +++++++++--
 4 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 32f20d0fd632..0d3988594b2e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -263,6 +263,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->vendor_part_id	   = mdev->pdev->device;
 	props->hw_ver		   = mdev->pdev->revision;
 
+	/* FIXME: Should read cap from FW and not rely on vendor_part_id */
+	if (props->vendor_part_id != 4113 && props->vendor_part_id != 4114)
+		props->device_cap_flags_ex |= IB_DEVICE_SG_GAPS_REG;
+
 	props->max_mr_size	   = ~0ull;
 	props->page_size_cap	   = ~(min_page_size - 1);
 	props->max_qp		   = 1 << MLX5_CAP_GEN(mdev, log_max_qp);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 91062d648125..33d21e0019c7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -324,6 +324,7 @@ struct mlx5_ib_mr {
 	int			ndescs;
 	int			max_descs;
 	int			desc_size;
+	int			access_mode;
 	struct mlx5_core_mr	mmr;
 	struct ib_umem	       *umem;
 	struct mlx5_shared_mr_info	*smr_info;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 580c19b9fd66..6e451ec8b331 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1294,8 +1294,8 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_create_mkey_mbox_in *in;
 	struct mlx5_ib_mr *mr;
-	int access_mode, err;
-	int ndescs = roundup(max_num_sg, 4);
+	int ndescs = ALIGN(max_num_sg, 4);
+	int err;
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
@@ -1313,7 +1313,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
 
 	if (mr_type == IB_MR_TYPE_MEM_REG) {
-		access_mode = MLX5_ACCESS_MODE_MTT;
+		mr->access_mode = MLX5_ACCESS_MODE_MTT;
 		in->seg.log2_page_size = PAGE_SHIFT;
 
 		err = mlx5_alloc_priv_descs(pd->device, mr,
@@ -1323,6 +1323,15 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 
 		mr->desc_size = sizeof(u64);
 		mr->max_descs = ndescs;
+	} else if (mr_type == IB_MR_TYPE_SG_GAPS_REG) {
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
 
@@ -1341,7 +1350,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 		if (err)
 			goto err_free_sig;
 
-		access_mode = MLX5_ACCESS_MODE_KLM;
+		mr->access_mode = MLX5_ACCESS_MODE_KLM;
 		mr->sig->psv_memory.psv_idx = psv_index[0];
 		mr->sig->psv_wire.psv_idx = psv_index[1];
 
@@ -1355,7 +1364,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 		goto err_free_in;
 	}
 
-	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
+	in->seg.flags = MLX5_PERM_UMR_EN | mr->access_mode;
 	err = mlx5_core_create_mkey(dev->mdev, &mr->mmr, in, sizeof(*in),
 				    NULL, NULL, NULL);
 	if (err)
@@ -1430,6 +1439,32 @@ done:
 	return ret;
 }
 
+static int
+mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
+		   struct scatterlist *sgl,
+		   unsigned short sg_nents)
+{
+	struct scatterlist *sg = sgl;
+	struct mlx5_klm *klms = mr->descs;
+	u32 lkey = mr->ibmr.device->local_dma_lkey;
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
@@ -1457,7 +1492,10 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
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
index 96adc6f13dcb..71b51ed9ad77 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1907,6 +1907,11 @@ static void set_reg_umr_seg(struct mlx5_wqe_umr_ctrl_seg *umr,
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
@@ -2001,13 +2006,19 @@ static void set_reg_mkey_seg(struct mlx5_mkey_seg *seg,
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
