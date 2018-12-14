From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [RFC PATCH] net/mlx4: Get rid of page operation after dma_alloc_coherent
Date: Fri, 14 Dec 2018 16:32:54 -0700
Message-ID: <20181214233254.5860-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, Wei@wwwdotorg.org, Hu@wwwdotorg.org, "\\ (Xavier\\)" <xavier.huwei@huawei.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This is a port of commit 378efe798ecf ("RDMA/hns: Get rid of page
operation after dma_alloc_coherent") to the mlx4 driver. That change was
described as:

> In general, dma_alloc_coherent() returns a CPU virtual address and
> a DMA address, and we have no guarantee that the underlying memory
> even has an associated struct page at all.
>
> This patch gets rid of the page operation after dma_alloc_coherent,
> and records the VA returned form dma_alloc_coherent in the struct
> of hem in hns RoCE driver.

Differences in this port relative to the hns patch:

1) The hns patch only needed to fix a dma_alloc_coherent path, but this
patch also needs to fix an alloc_pages path. This appears to be simple
except for the next point.

2) The hns patch converted a bunch of code to consistently use
sg_dma_len(mem) rather than a mix of that and mem->length However, it
seems that sg_dma_len(mem) can be modified or zeroed at runtime, and so
using it when calling e.g. __free_pages is problematic. I suspect the
same issue affects mlx4_table_find() somehow too, and similarly I expect
the hns driver has an issue in this area. Instead, this patch converts
everything to use mem->length instead. I'd like some feedback on this
issue.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: I've tested this patch in downstream 4.9 and 4.14 based kernels,
but can't test it in mainline (at least ibping works) since my system
isn't supported their yet. I have compile-tested it in mainline at
least, for ARM64.

 drivers/net/ethernet/mellanox/mlx4/icm.c | 51 ++++++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/icm.h |  1 +
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 4b4351141b94..b14207cef69e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -72,7 +72,7 @@ static void mlx4_free_icm_coherent(struct mlx4_dev *dev, struct mlx4_icm_chunk *
 	for (i = 0; i < chunk->npages; ++i)
 		dma_free_coherent(&dev->persist->pdev->dev,
 				  chunk->mem[i].length,
-				  lowmem_page_address(sg_page(&chunk->mem[i])),
+				  chunk->buf[i],
 				  sg_dma_address(&chunk->mem[i]));
 }
 
@@ -95,9 +95,11 @@ void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm, int coherent)
 	kfree(icm);
 }
 
-static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order,
+static int mlx4_alloc_icm_pages(struct mlx4_icm_chunk *chunk, int order,
 				gfp_t gfp_mask, int node)
 {
+	struct scatterlist *mem = &chunk->mem[chunk->npages];
+	void **buf = &chunk->buf[chunk->npages];
 	struct page *page;
 
 	page = alloc_pages_node(node, gfp_mask, order);
@@ -108,25 +110,30 @@ static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order,
 	}
 
 	sg_set_page(mem, page, PAGE_SIZE << order, 0);
+	*buf = lowmem_page_address(page);
 	return 0;
 }
 
-static int mlx4_alloc_icm_coherent(struct device *dev, struct scatterlist *mem,
-				    int order, gfp_t gfp_mask)
+static int mlx4_alloc_icm_coherent(struct device *dev,
+				   struct mlx4_icm_chunk *chunk, int order,
+				   gfp_t gfp_mask)
 {
-	void *buf = dma_alloc_coherent(dev, PAGE_SIZE << order,
-				       &sg_dma_address(mem), gfp_mask);
-	if (!buf)
+	struct scatterlist *mem = &chunk->mem[chunk->npages];
+	void **buf = &chunk->buf[chunk->npages];
+
+	*buf = dma_alloc_coherent(dev, PAGE_SIZE << order,
+				  &sg_dma_address(mem), gfp_mask);
+	if (!*buf)
 		return -ENOMEM;
 
-	if (offset_in_page(buf)) {
+	if (offset_in_page(*buf)) {
 		dma_free_coherent(dev, PAGE_SIZE << order,
-				  buf, sg_dma_address(mem));
+				  *buf, sg_dma_address(mem));
 		return -ENOMEM;
 	}
 
-	sg_set_buf(mem, buf, PAGE_SIZE << order);
 	sg_dma_len(mem) = PAGE_SIZE << order;
+	mem->length = PAGE_SIZE << order;
 	return 0;
 }
 
@@ -174,6 +181,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 			sg_init_table(chunk->mem, MLX4_ICM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg    = 0;
+			memset(chunk->buf, 0, sizeof(chunk->buf));
 			list_add_tail(&chunk->list, &icm->chunk_list);
 		}
 
@@ -186,11 +194,9 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 
 		if (coherent)
 			ret = mlx4_alloc_icm_coherent(&dev->persist->pdev->dev,
-						      &chunk->mem[chunk->npages],
-						      cur_order, mask);
+						      chunk, cur_order, mask);
 		else
-			ret = mlx4_alloc_icm_pages(&chunk->mem[chunk->npages],
-						   cur_order, mask,
+			ret = mlx4_alloc_icm_pages(chunk, cur_order, mask,
 						   dev->numa_node);
 
 		if (ret) {
@@ -316,11 +322,11 @@ void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj)
 void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 			dma_addr_t *dma_handle)
 {
-	int offset, dma_offset, i;
+	int offset, dma_offset, i, length;
 	u64 idx;
 	struct mlx4_icm_chunk *chunk;
 	struct mlx4_icm *icm;
-	struct page *page = NULL;
+	void *addr = NULL;
 
 	if (!table->lowmem)
 		return NULL;
@@ -336,28 +342,29 @@ void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 
 	list_for_each_entry(chunk, &icm->chunk_list, list) {
 		for (i = 0; i < chunk->npages; ++i) {
+			length = chunk->mem[i].length;
 			if (dma_handle && dma_offset >= 0) {
-				if (sg_dma_len(&chunk->mem[i]) > dma_offset)
+				if (length > dma_offset)
 					*dma_handle = sg_dma_address(&chunk->mem[i]) +
 						dma_offset;
-				dma_offset -= sg_dma_len(&chunk->mem[i]);
+				dma_offset -= length;
 			}
 			/*
 			 * DMA mapping can merge pages but not split them,
 			 * so if we found the page, dma_handle has already
 			 * been assigned to.
 			 */
-			if (chunk->mem[i].length > offset) {
-				page = sg_page(&chunk->mem[i]);
+			if (length > offset) {
+				addr = chunk->buf[i] + offset;
 				goto out;
 			}
-			offset -= chunk->mem[i].length;
+			offset -= length;
 		}
 	}
 
 out:
 	mutex_unlock(&table->mutex);
-	return page ? lowmem_page_address(page) + offset : NULL;
+	return addr;
 }
 
 int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
index c9169a490557..a565188dc391 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.h
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
@@ -52,6 +52,7 @@ struct mlx4_icm_chunk {
 	int			npages;
 	int			nsg;
 	struct scatterlist	mem[MLX4_ICM_CHUNK_LEN];
+	void			*buf[MLX4_ICM_CHUNK_LEN];
 };
 
 struct mlx4_icm {
-- 
2.19.2
