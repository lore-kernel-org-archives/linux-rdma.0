From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 40/43] mlx5: Allocate private context for arbitrary scatterlist registration
Date: Wed, 22 Jul 2015 09:55:40 +0300
Message-ID: <1437548143-24893-41-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++-
 drivers/infiniband/hw/mlx5/mr.c      | 71 ++++++++++++++++++++++++++++++------
 2 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7017a1a..fb3ac22 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -315,11 +315,15 @@ enum mlx5_ib_mtt_access_flags {
 
 struct mlx5_ib_mr {
 	struct ib_mr		ibmr;
-	u64		        *pl;
+	union {
+		__be64			*pl;
+		struct mlx5_klm		*klms;
+	};
 	__be64			*mpl;
 	dma_addr_t		pl_map;
 	int			ndescs;
 	int			max_descs;
+	int			access_mode;
 	struct mlx5_core_mr	mmr;
 	struct ib_umem	       *umem;
 	struct mlx5_shared_mr_info	*smr_info;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7a030a2..45209c7 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1168,6 +1168,40 @@ error:
 }
 
 static int
+mlx5_alloc_klm_list(struct ib_device *device,
+		    struct mlx5_ib_mr *mr, int ndescs)
+{
+	int size = sizeof(struct mlx5_klm) * ndescs;
+
+	size += max_t(int, MLX5_UMR_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
+	mr->klms = kzalloc(size, GFP_KERNEL);
+	if (!mr->klms)
+		return -ENOMEM;
+
+	mr->pl_map = dma_map_single(device->dma_device, mr->klms,
+				    size, DMA_TO_DEVICE);
+	if (dma_mapping_error(device->dma_device, mr->pl_map))
+		goto err;
+
+	return 0;
+err:
+	kfree(mr->klms);
+
+	return -ENOMEM;
+}
+
+static void
+mlx5_free_klm_list(struct mlx5_ib_mr *mr)
+{
+	struct ib_device *device = mr->ibmr.device;
+	int size = mr->max_descs * sizeof(struct mlx5_klm);
+
+	kfree(mr->klms);
+	dma_unmap_single(device->dma_device, mr->pl_map, size, DMA_TO_DEVICE);
+	mr->klms = NULL;
+}
+
+static int
 mlx5_alloc_page_list(struct ib_device *device,
 		     struct mlx5_ib_mr *mr, int ndescs)
 {
@@ -1222,7 +1256,10 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 		mr->sig = NULL;
 	}
 
-	mlx5_free_page_list(mr);
+	if (mr->access_mode == MLX5_ACCESS_MODE_MTT)
+		mlx5_free_page_list(mr);
+	else
+		mlx5_free_klm_list(mr);
 
 	if (!umred) {
 		err = destroy_mkey(dev, mr);
@@ -1293,10 +1330,10 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_create_mkey_mbox_in *in;
 	struct mlx5_ib_mr *mr;
-	int access_mode, err;
-	int ndescs = roundup(max_entries, 4);
+	int ndescs = ALIGN(max_entries, 4);
+	int err;
 
-	if (flags)
+	if (flags & ~IB_MR_MAP_ARB_SG)
 		return ERR_PTR(-EINVAL);
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
@@ -1315,13 +1352,20 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
 
 	if (mr_type == IB_MR_TYPE_FAST_REG) {
-		access_mode = MLX5_ACCESS_MODE_MTT;
-		in->seg.log2_page_size = PAGE_SHIFT;
+		if (flags & IB_MR_MAP_ARB_SG) {
+			mr->access_mode = MLX5_ACCESS_MODE_KLM;
 
-		err = mlx5_alloc_page_list(pd->device, mr, ndescs);
-		if (err)
-			goto err_free_in;
+			err = mlx5_alloc_klm_list(pd->device, mr, ndescs);
+			if (err)
+				goto err_free_in;
+		} else {
+			mr->access_mode = MLX5_ACCESS_MODE_MTT;
+			in->seg.log2_page_size = PAGE_SHIFT;
 
+			err = mlx5_alloc_page_list(pd->device, mr, ndescs);
+			if (err)
+				goto err_free_in;
+		}
 		mr->max_descs = ndescs;
 	} else if (mr_type == IB_MR_TYPE_SIGNATURE) {
 		u32 psv_index[2];
@@ -1341,7 +1385,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 		if (err)
 			goto err_free_sig;
 
-		access_mode = MLX5_ACCESS_MODE_KLM;
+		mr->access_mode = MLX5_ACCESS_MODE_KLM;
 		mr->sig->psv_memory.psv_idx = psv_index[0];
 		mr->sig->psv_wire.psv_idx = psv_index[1];
 
@@ -1355,7 +1399,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 		goto err_free_in;
 	}
 
-	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
+	in->seg.flags = MLX5_PERM_UMR_EN | mr->access_mode;
 	err = mlx5_core_create_mkey(dev->mdev, &mr->mmr, in, sizeof(*in),
 				    NULL, NULL, NULL);
 	if (err)
@@ -1379,7 +1423,10 @@ err_destroy_psv:
 			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
 				     mr->sig->psv_wire.psv_idx);
 	}
-	mlx5_free_page_list(mr);
+	if (mr->access_mode == MLX5_ACCESS_MODE_MTT)
+		mlx5_free_page_list(mr);
+	else
+		mlx5_free_klm_list(mr);
 err_free_sig:
 	kfree(mr->sig);
 err_free_in:
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
