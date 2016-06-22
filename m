From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 11/11] IB/mlx4: Prevent cross page boundary allocation
Date: Wed, 22 Jun 2016 17:27:32 +0300
Message-ID: <1466605652-24798-12-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Prevent cross page boundary allocation by allocating
new page, this is required to be aligned with ConnectX-3 HW
requirements.

Not doing that might cause to "RDMA read local protection" error.

Fixes: 1b2cd0fc673c ('IB/mlx4: Support the new memory registration API')
Suggested-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  2 +-
 drivers/infiniband/hw/mlx4/mr.c      | 34 +++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6c5ac5d..29acda2 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -139,7 +139,7 @@ struct mlx4_ib_mr {
 	u32			max_pages;
 	struct mlx4_mr		mmr;
 	struct ib_umem	       *umem;
-	void			*pages_alloc;
+	size_t			page_map_size;
 };
 
 struct mlx4_ib_mw {
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 6312721..5d73989 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -277,20 +277,23 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 		      struct mlx4_ib_mr *mr,
 		      int max_pages)
 {
-	int size = max_pages * sizeof(u64);
-	int add_size;
 	int ret;
 
-	add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
+	/* Ensure that size is aligned to DMA cacheline
+	 * requirements.
+	 * max_pages is limited to MLX4_MAX_FAST_REG_PAGES
+	 * so page_map_size will never cross PAGE_SIZE.
+	 */
+	mr->page_map_size = roundup(max_pages * sizeof(u64),
+				    MLX4_MR_PAGES_ALIGN);
 
-	mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
-	if (!mr->pages_alloc)
+	/* Prevent cross page boundary allocation. */
+	mr->pages = (__be64 *)get_zeroed_page(GFP_KERNEL);
+	if (!mr->pages)
 		return -ENOMEM;
 
-	mr->pages = PTR_ALIGN(mr->pages_alloc, MLX4_MR_PAGES_ALIGN);
-
 	mr->page_map = dma_map_single(device->dma_device, mr->pages,
-				      size, DMA_TO_DEVICE);
+				      mr->page_map_size, DMA_TO_DEVICE);
 
 	if (dma_mapping_error(device->dma_device, mr->page_map)) {
 		ret = -ENOMEM;
@@ -298,9 +301,9 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 	}
 
 	return 0;
-err:
-	kfree(mr->pages_alloc);
 
+err:
+	free_page((unsigned long)mr->pages);
 	return ret;
 }
 
@@ -309,11 +312,10 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 {
 	if (mr->pages) {
 		struct ib_device *device = mr->ibmr.device;
-		int size = mr->max_pages * sizeof(u64);
 
 		dma_unmap_single(device->dma_device, mr->page_map,
-				 size, DMA_TO_DEVICE);
-		kfree(mr->pages_alloc);
+				 mr->page_map_size, DMA_TO_DEVICE);
+		free_page((unsigned long)mr->pages);
 		mr->pages = NULL;
 	}
 }
@@ -537,14 +539,12 @@ int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 	mr->npages = 0;
 
 	ib_dma_sync_single_for_cpu(ibmr->device, mr->page_map,
-				   sizeof(u64) * mr->max_pages,
-				   DMA_TO_DEVICE);
+				   mr->page_map_size, DMA_TO_DEVICE);
 
 	rc = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
 
 	ib_dma_sync_single_for_device(ibmr->device, mr->page_map,
-				      sizeof(u64) * mr->max_pages,
-				      DMA_TO_DEVICE);
+				      mr->page_map_size, DMA_TO_DEVICE);
 
 	return rc;
 }
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
