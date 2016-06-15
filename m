From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Tue, 14 Jun 2016 23:15:25 -0400
Message-ID: <20160615031525.14794.69066.stgit@manet.1015granger.net>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160615030626.14794.43805.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

kmalloc doesn't guarantee the returned memory is all on one page.

Fixes: 1b2cd0fc673c ("IB/mlx4: Support the new memory ... ")
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 -
 drivers/infiniband/hw/mlx4/mr.c      |   42 +++++-----------------------------
 2 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6c5ac5d..4a8bbe4 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -139,7 +139,6 @@ struct mlx4_ib_mr {
 	u32			max_pages;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
-	void			*pages_alloc;
 };
 
 struct mlx4_ib_mw {
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 6312721..c4c2044 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -278,30 +278,13 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 		      int max_pages)
 {
 	int size = max_pages * sizeof(u64);
-	int add_size;
-	int ret;
-
-	add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
 
-	mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
-	if (!mr->pages_alloc)
+	mr->pages = dma_alloc_coherent(device->dma_device, size,
+				       &mr->page_map, GFP_KERNEL);
+	if (!mr->pages)
 		return -ENOMEM;
 
-	mr->pages = PTR_ALIGN(mr->pages_alloc, MLX4_MR_PAGES_ALIGN);
-
-	mr->page_map = dma_map_single(device->dma_device, mr->pages,
-				      size, DMA_TO_DEVICE);
-
-	if (dma_mapping_error(device->dma_device, mr->page_map)) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
 	return 0;
-err:
-	kfree(mr->pages_alloc);
-
-	return ret;
 }
 
 static void
@@ -311,9 +294,8 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 		struct ib_device *device = mr->ibmr.device;
 		int size = mr->max_pages * sizeof(u64);
 
-		dma_unmap_single(device->dma_device, mr->page_map,
-				 size, DMA_TO_DEVICE);
-		kfree(mr->pages_alloc);
+		dma_free_coherent(device->dma_device, size,
+				  mr->pages, mr->page_map);
 		mr->pages = NULL;
 	}
 }
@@ -532,19 +514,7 @@ int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 		      unsigned int *sg_offset)
 {
 	struct mlx4_ib_mr *mr = to_mmr(ibmr);
-	int rc;
 
 	mr->npages = 0;
-
-	ib_dma_sync_single_for_cpu(ibmr->device, mr->page_map,
-				   sizeof(u64) * mr->max_pages,
-				   DMA_TO_DEVICE);
-
-	rc = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
-
-	ib_dma_sync_single_for_device(ibmr->device, mr->page_map,
-				      sizeof(u64) * mr->max_pages,
-				      DMA_TO_DEVICE);
-
-	return rc;
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
