From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH V2] net/mlx4: Get rid of page operation after dma_alloc_coherent
Date: Tue, 18 Dec 2018 12:06:22 -0700
Message-ID: <20181218190622.13046-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This patch solves a crash at the time of mlx4 driver unload or system
shutdown. The crash occurs because dma_alloc_coherent() returns one
value in mlx4_alloc_icm_coherent(), but a different value is passed to
dma_free_coherent() in mlx4_free_icm_coherent(). In turn this is because
when allocated, that pointer is passed to sg_set_buf() to record it,
then when freed it is re-calculated by calling
lowmem_page_address(sg_page()) which returns a different value. Solve
this by recording the value that dma_alloc_coherent() returns, and
passing this to dma_free_coherent().

This change is equivalent to commit 378efe798ecf ("RDMA/hns: Get rid of
page operation after dma_alloc_coherent"). That change was described as:

> In general, dma_alloc_coherent() returns a CPU virtual address and
> a DMA address, and we have no guarantee that the underlying memory
> even has an associated struct page at all.
>
> This patch gets rid of the page operation after dma_alloc_coherent,
> and records the VA returned form dma_alloc_coherent in the struct
> of hem in hns RoCE driver.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2:
- Rework mlx4_table_find() to explicitly calculate the returned address
  differently depending on wheter the table was allocated using
  dma_alloc_coherent() or alloc_pages(), which in turn allows the
  changes to mlx4_alloc_icm_pages() to be dropped.
- Drop changes to mlx4_alloc/free_icm_pages. This path uses
  pci_map_sg() which can re-write the sg list which in turn would cause
  chunk->mem[] (the sg list) and chunk->buf[] to become inconsistent.
- Enhance commit description.

Note: I've tested this patch in a downstream 4.14 based kernel (using
ibping, ib_read_bw, and ib_write_bw), but can't test it in mainline
since my system isn't supported there yet. I have compile-tested it in
mainline at least, for ARM64.
---
 drivers/net/ethernet/mellanox/mlx4/icm.c | 30 +++++++++++++++---------
 drivers/net/ethernet/mellanox/mlx4/icm.h |  1 +
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 4b4351141b94..901110c7530a 100644
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
 
@@ -112,20 +112,20 @@ static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order,
 }
 
 static int mlx4_alloc_icm_coherent(struct device *dev, struct scatterlist *mem,
-				    int order, gfp_t gfp_mask)
+				   void **buf, int order, gfp_t gfp_mask)
 {
-	void *buf = dma_alloc_coherent(dev, PAGE_SIZE << order,
-				       &sg_dma_address(mem), gfp_mask);
-	if (!buf)
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
+	mem->length = PAGE_SIZE << order;
 	sg_dma_len(mem) = PAGE_SIZE << order;
 	return 0;
 }
@@ -174,6 +174,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 			sg_init_table(chunk->mem, MLX4_ICM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg    = 0;
+			memset(chunk->buf, 0, sizeof(chunk->buf));
 			list_add_tail(&chunk->list, &icm->chunk_list);
 		}
 
@@ -187,6 +188,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 		if (coherent)
 			ret = mlx4_alloc_icm_coherent(&dev->persist->pdev->dev,
 						      &chunk->mem[chunk->npages],
+						      &chunk->buf[chunk->npages],
 						      cur_order, mask);
 		else
 			ret = mlx4_alloc_icm_pages(&chunk->mem[chunk->npages],
@@ -320,7 +322,8 @@ void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 	u64 idx;
 	struct mlx4_icm_chunk *chunk;
 	struct mlx4_icm *icm;
-	struct page *page = NULL;
+	struct page *page;
+	void *addr = NULL;
 
 	if (!table->lowmem)
 		return NULL;
@@ -348,7 +351,12 @@ void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 			 * been assigned to.
 			 */
 			if (chunk->mem[i].length > offset) {
-				page = sg_page(&chunk->mem[i]);
+				if (table->coherent) {
+					addr = chunk->buf[i];
+				} else {
+					page = sg_page(&chunk->mem[i]);
+					addr = lowmem_page_address(page);
+				}
 				goto out;
 			}
 			offset -= chunk->mem[i].length;
@@ -357,7 +365,7 @@ void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 
 out:
 	mutex_unlock(&table->mutex);
-	return page ? lowmem_page_address(page) + offset : NULL;
+	return addr ? addr + offset : NULL;
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
