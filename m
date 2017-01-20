From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 21/37] IB/mlx5: Switch from dma_device to dev.parent
Date: Fri, 20 Jan 2017 13:04:21 -0800
Message-ID: <20170120210437.26389-22-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |  2 +-
 drivers/infiniband/hw/mlx5/mr.c   | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d566f6738833..da3bf6c081de 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3075,7 +3075,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.phys_port_cnt     = dev->num_ports;
 	dev->ib_dev.num_comp_vectors    =
 		dev->mdev->priv.eq_table.num_comp_vectors;
-	dev->ib_dev.dma_device	= &mdev->pdev->dev;
+	dev->ib_dev.dev.parent		= &mdev->pdev->dev;
 
 	dev->ib_dev.uverbs_abi_ver	= MLX5_IB_UVERBS_ABI_VERSION;
 	dev->ib_dev.uverbs_cmd_mask	=
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8f608debe141..87ca81b85fd0 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -767,7 +767,7 @@ static int dma_map_mr_pas(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 			  __be64 **mr_pas, dma_addr_t *dma)
 {
 	__be64 *pas;
-	struct device *ddev = dev->ib_dev.dma_device;
+	struct device *ddev = dev->ib_dev.dev.parent;
 
 	/*
 	 * UMR copies MTTs in units of MLX5_UMR_MTT_ALIGNMENT bytes.
@@ -896,7 +896,7 @@ static struct mlx5_ib_mr *reg_umr(struct ib_pd *pd, struct ib_umem *umem,
 				  int page_shift, int order, int access_flags)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct device *ddev = dev->ib_dev.dma_device;
+	struct device *ddev = dev->ib_dev.dev.parent;
 	struct umr_common *umrc = &dev->umrc;
 	struct mlx5_ib_umr_context umr_context;
 	struct mlx5_umr_wr umrwr = {};
@@ -974,7 +974,7 @@ int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index, int npages,
 		       int zap)
 {
 	struct mlx5_ib_dev *dev = mr->dev;
-	struct device *ddev = dev->ib_dev.dma_device;
+	struct device *ddev = dev->ib_dev.dev.parent;
 	struct umr_common *umrc = &dev->umrc;
 	struct mlx5_ib_umr_context umr_context;
 	struct ib_umem *umem = mr->umem;
@@ -1288,7 +1288,7 @@ static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
 		     int access_flags, int flags)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct device *ddev = dev->ib_dev.dma_device;
+	struct device *ddev = dev->ib_dev.dev.parent;
 	struct mlx5_ib_umr_context umr_context;
 	struct ib_send_wr *bad;
 	struct mlx5_umr_wr umrwr = {};
@@ -1461,9 +1461,9 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 
 	mr->descs = PTR_ALIGN(mr->descs_alloc, MLX5_UMR_ALIGN);
 
-	mr->desc_map = dma_map_single(device->dma_device, mr->descs,
+	mr->desc_map = dma_map_single(device->dev.parent, mr->descs,
 				      size, DMA_TO_DEVICE);
-	if (dma_mapping_error(device->dma_device, mr->desc_map)) {
+	if (dma_mapping_error(device->dev.parent, mr->desc_map)) {
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -1482,7 +1482,7 @@ mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_descs * mr->desc_size;
 
-		dma_unmap_single(device->dma_device, mr->desc_map,
+		dma_unmap_single(device->dev.parent, mr->desc_map,
 				 size, DMA_TO_DEVICE);
 		kfree(mr->descs_alloc);
 		mr->descs = NULL;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
