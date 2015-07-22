From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 21/43] mlx5: Allocate a private page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:21 +0300
Message-ID: <1437548143-24893-22-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 ++++
 drivers/infiniband/hw/mlx5/mr.c      | 45 ++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c2916f1..df5e959 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -315,6 +315,11 @@ enum mlx5_ib_mtt_access_flags {
 
 struct mlx5_ib_mr {
 	struct ib_mr		ibmr;
+	u64		        *pl;
+	__be64			*mpl;
+	dma_addr_t		pl_map;
+	int			ndescs;
+	int			max_descs;
 	struct mlx5_core_mr	mmr;
 	struct ib_umem	       *umem;
 	struct mlx5_shared_mr_info	*smr_info;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index c8de302..1075065 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1167,6 +1167,42 @@ error:
 	return err;
 }
 
+static int
+mlx5_alloc_page_list(struct ib_device *device,
+		     struct mlx5_ib_mr *mr, int ndescs)
+{
+	int size = ndescs * sizeof(u64);
+
+	mr->pl = kcalloc(ndescs, sizeof(u64), GFP_KERNEL);
+	if (!mr->pl)
+		return -ENOMEM;
+
+	mr->mpl = dma_alloc_coherent(device->dma_device, size,
+				     &mr->pl_map, GFP_KERNEL);
+	if (!mr->mpl)
+		goto err;
+
+	return 0;
+err:
+	kfree(mr->pl);
+
+	return -ENOMEM;
+}
+
+static void
+mlx5_free_page_list(struct mlx5_ib_mr *mr)
+{
+	struct ib_device *device = mr->ibmr.device;
+	int size = mr->max_descs * sizeof(u64);
+
+	kfree(mr->pl);
+	if (mr->mpl)
+		dma_free_coherent(device->dma_device, size,
+				  mr->mpl, mr->pl_map);
+	mr->pl = NULL;
+	mr->mpl = NULL;
+}
+
 static int clean_mr(struct mlx5_ib_mr *mr)
 {
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
@@ -1186,6 +1222,8 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 		mr->sig = NULL;
 	}
 
+	mlx5_free_page_list(mr);
+
 	if (!umred) {
 		err = destroy_mkey(dev, mr);
 		if (err) {
@@ -1279,6 +1317,12 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 	if (mr_type == IB_MR_TYPE_FAST_REG) {
 		access_mode = MLX5_ACCESS_MODE_MTT;
 		in->seg.log2_page_size = PAGE_SHIFT;
+
+		err = mlx5_alloc_page_list(pd->device, mr, ndescs);
+		if (err)
+			goto err_free_in;
+
+		mr->max_descs = ndescs;
 	} else if (mr_type == IB_MR_TYPE_SIGNATURE) {
 		u32 psv_index[2];
 
@@ -1335,6 +1379,7 @@ err_destroy_psv:
 			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
 				     mr->sig->psv_wire.psv_idx);
 	}
+	mlx5_free_page_list(mr);
 err_free_sig:
 	kfree(mr->sig);
 err_free_in:
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
