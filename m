From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 25/25] IB/mlx4: Workaround for mlx4_alloc_priv_pages()
 array allocator
Date: Mon, 20 Jun 2016 12:12:00 -0400
Message-ID: <20160620161200.10809.45762.stgit@manet.1015granger.net>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620155751.10809.22262.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ensure the MR's PBL array never occupies the last 8 bytes of a page.
This eliminates random "Local Protection Error" flushes when SLUB
debugging is enabled.

Fixes: 1b2cd0fc673c ('IB/mlx4: Support the new memory registration API')
Suggested-by: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    2 +-
 drivers/infiniband/hw/mlx4/mr.c      |   40 +++++++++++++++++++---------------
 2 files changed, 23 insertions(+), 19 deletions(-)

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
index 6312721..b90e47c 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -277,20 +277,27 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 		      struct mlx4_ib_mr *mr,
 		      int max_pages)
 {
-	int size = max_pages * sizeof(u64);
-	int add_size;
 	int ret;
 
-	add_size = max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
-
-	mr->pages_alloc = kzalloc(size + add_size, GFP_KERNEL);
-	if (!mr->pages_alloc)
+	/* Round mapping size up to ensure DMA cacheline
+	 * alignment, and cache the size to avoid mult/div
+	 * in fast path.
+	 */
+	mr->page_map_size = roundup(max_pages * sizeof(u64),
+				    MLX4_MR_PAGES_ALIGN);
+	if (mr->page_map_size > PAGE_SIZE)
+		return -EINVAL;
+
+	/* This is overkill, but hardware requires that the
+	 * PBL array begins at a properly aligned address and
+	 * never occupies the last 8 bytes of a page.
+	 */
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
@@ -298,9 +305,9 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 	}
 
 	return 0;
-err:
-	kfree(mr->pages_alloc);
 
+err:
+	free_page((unsigned long)mr->pages);
 	return ret;
 }
 
@@ -309,11 +316,10 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
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
@@ -537,14 +543,12 @@ int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
