From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V2] net/mlx4: Get rid of page operation after
 dma_alloc_coherent
Date: Tue, 18 Dec 2018 21:56:49 +0100
Message-ID: <20181218205649.GA17958@lst.de>
References: <20181218190622.13046-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181218190622.13046-1-swarren@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

This goes in the right direction, but I think we need to stop
abusing the scatterlist for the coherent mapping entirely.  Something
like the patch below (based on yours):

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 4b4351141b94..717ee2fad707 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -57,12 +57,12 @@ static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chu
 	int i;
 
 	if (chunk->nsg > 0)
-		pci_unmap_sg(dev->persist->pdev, chunk->mem, chunk->npages,
+		pci_unmap_sg(dev->persist->pdev, chunk->sg, chunk->npages,
 			     PCI_DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
-		__free_pages(sg_page(&chunk->mem[i]),
-			     get_order(chunk->mem[i].length));
+		__free_pages(sg_page(&chunk->sg[i]),
+			     get_order(chunk->sg[i].length));
 }
 
 static void mlx4_free_icm_coherent(struct mlx4_dev *dev, struct mlx4_icm_chunk *chunk)
@@ -71,9 +71,9 @@ static void mlx4_free_icm_coherent(struct mlx4_dev *dev, struct mlx4_icm_chunk *
 
 	for (i = 0; i < chunk->npages; ++i)
 		dma_free_coherent(&dev->persist->pdev->dev,
-				  chunk->mem[i].length,
-				  lowmem_page_address(sg_page(&chunk->mem[i])),
-				  sg_dma_address(&chunk->mem[i]));
+				  chunk->buf[i].size,
+				  chunk->buf[i].addr,
+				  chunk->buf[i].dma_addr);
 }
 
 void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm, int coherent)
@@ -111,22 +111,21 @@ static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order,
 	return 0;
 }
 
-static int mlx4_alloc_icm_coherent(struct device *dev, struct scatterlist *mem,
-				    int order, gfp_t gfp_mask)
+static int mlx4_alloc_icm_coherent(struct device *dev, struct mlx4_icm_buf *buf,
+				   int order, gfp_t gfp_mask)
 {
-	void *buf = dma_alloc_coherent(dev, PAGE_SIZE << order,
-				       &sg_dma_address(mem), gfp_mask);
-	if (!buf)
+	buf->addr = dma_alloc_coherent(dev, PAGE_SIZE << order,
+				  &buf->dma_addr, gfp_mask);
+	if (!buf->addr)
 		return -ENOMEM;
 
-	if (offset_in_page(buf)) {
-		dma_free_coherent(dev, PAGE_SIZE << order,
-				  buf, sg_dma_address(mem));
+	if (offset_in_page(buf->addr)) {
+		dma_free_coherent(dev, PAGE_SIZE << order, buf->addr,
+				  buf->dma_addr);
 		return -ENOMEM;
 	}
 
-	sg_set_buf(mem, buf, PAGE_SIZE << order);
-	sg_dma_len(mem) = PAGE_SIZE << order;
+	buf->size = PAGE_SIZE << order;
 	return 0;
 }
 
@@ -159,21 +158,20 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 
 	while (npages > 0) {
 		if (!chunk) {
-			chunk = kmalloc_node(sizeof(*chunk),
+			chunk = kzalloc_node(sizeof(*chunk),
 					     gfp_mask & ~(__GFP_HIGHMEM |
 							  __GFP_NOWARN),
 					     dev->numa_node);
 			if (!chunk) {
-				chunk = kmalloc(sizeof(*chunk),
+				chunk = kzalloc(sizeof(*chunk),
 						gfp_mask & ~(__GFP_HIGHMEM |
 							     __GFP_NOWARN));
 				if (!chunk)
 					goto fail;
 			}
 
-			sg_init_table(chunk->mem, MLX4_ICM_CHUNK_LEN);
-			chunk->npages = 0;
-			chunk->nsg    = 0;
+			if (!coherent)
+				sg_init_table(chunk->sg, MLX4_ICM_CHUNK_LEN);
 			list_add_tail(&chunk->list, &icm->chunk_list);
 		}
 
@@ -186,10 +184,10 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 
 		if (coherent)
 			ret = mlx4_alloc_icm_coherent(&dev->persist->pdev->dev,
-						      &chunk->mem[chunk->npages],
+						      &chunk->buf[chunk->npages],
 						      cur_order, mask);
 		else
-			ret = mlx4_alloc_icm_pages(&chunk->mem[chunk->npages],
+			ret = mlx4_alloc_icm_pages(&chunk->sg[chunk->npages],
 						   cur_order, mask,
 						   dev->numa_node);
 
@@ -205,7 +203,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 		if (coherent)
 			++chunk->nsg;
 		else if (chunk->npages == MLX4_ICM_CHUNK_LEN) {
-			chunk->nsg = pci_map_sg(dev->persist->pdev, chunk->mem,
+			chunk->nsg = pci_map_sg(dev->persist->pdev, chunk->sg,
 						chunk->npages,
 						PCI_DMA_BIDIRECTIONAL);
 
@@ -220,7 +218,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 	}
 
 	if (!coherent && chunk) {
-		chunk->nsg = pci_map_sg(dev->persist->pdev, chunk->mem,
+		chunk->nsg = pci_map_sg(dev->persist->pdev, chunk->sg,
 					chunk->npages,
 					PCI_DMA_BIDIRECTIONAL);
 
@@ -320,7 +318,7 @@ void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 	u64 idx;
 	struct mlx4_icm_chunk *chunk;
 	struct mlx4_icm *icm;
-	struct page *page = NULL;
+	void *addr = NULL;
 
 	if (!table->lowmem)
 		return NULL;
@@ -336,28 +334,48 @@ void *mlx4_table_find(struct mlx4_icm_table *table, u32 obj,
 
 	list_for_each_entry(chunk, &icm->chunk_list, list) {
 		for (i = 0; i < chunk->npages; ++i) {
+			dma_addr_t dma_addr;
+			size_t len;
+
+			if (table->coherent) {
+				len = chunk->buf[i].size;
+				dma_addr = chunk->buf[i].dma_addr;
+				addr = chunk->buf[i].addr;
+			} else {
+				len = sg_dma_len(&chunk->sg[i]);
+				dma_addr = sg_dma_address(&chunk->sg[i]);
+
+				/*
+				 * XXX: we should never do this for highmem
+				 * allocation.  This function either needs
+				 * to be split, or the kernel virtual address
+				 * return needs to be made optional.
+				 */
+				addr = lowmem_page_address(
+						sg_page(&chunk->sg[i]));
+			}
+
 			if (dma_handle && dma_offset >= 0) {
-				if (sg_dma_len(&chunk->mem[i]) > dma_offset)
-					*dma_handle = sg_dma_address(&chunk->mem[i]) +
-						dma_offset;
-				dma_offset -= sg_dma_len(&chunk->mem[i]);
+				if (len > dma_offset)
+					*dma_handle = dma_addr + dma_offset;
+				dma_offset -= len;
 			}
+
 			/*
 			 * DMA mapping can merge pages but not split them,
 			 * so if we found the page, dma_handle has already
 			 * been assigned to.
 			 */
-			if (chunk->mem[i].length > offset) {
-				page = sg_page(&chunk->mem[i]);
+			if (len > offset)
 				goto out;
-			}
-			offset -= chunk->mem[i].length;
+			offset -= len;
 		}
 	}
 
+	addr = NULL;
 out:
 	mutex_unlock(&table->mutex);
-	return page ? lowmem_page_address(page) + offset : NULL;
+	return addr ? addr + offset : NULL;
 }
 
 int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
index c9169a490557..5ccf08ac47a3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.h
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
@@ -47,11 +47,20 @@ enum {
 	MLX4_ICM_PAGE_SIZE	= 1 << MLX4_ICM_PAGE_SHIFT,
 };
 
+struct mlx4_icm_buf {
+	void			*addr;
+	size_t			size;
+	dma_addr_t		dma_addr;
+};
+
 struct mlx4_icm_chunk {
 	struct list_head	list;
 	int			npages;
 	int			nsg;
-	struct scatterlist	mem[MLX4_ICM_CHUNK_LEN];
+	union {
+		struct scatterlist	sg[MLX4_ICM_CHUNK_LEN];
+		struct mlx4_icm_buf	buf[MLX4_ICM_CHUNK_LEN];
+	};
 };
 
 struct mlx4_icm {
@@ -112,14 +121,16 @@ static inline void mlx4_icm_next(struct mlx4_icm_iter *iter)
 	}
 }
 
+/* Note: won't work on coherent tables */
 static inline dma_addr_t mlx4_icm_addr(struct mlx4_icm_iter *iter)
 {
-	return sg_dma_address(&iter->chunk->mem[iter->page_idx]);
+	return sg_dma_address(&iter->chunk->sg[iter->page_idx]);
 }
 
+/* Note: won't work on coherent tables */
 static inline unsigned long mlx4_icm_size(struct mlx4_icm_iter *iter)
 {
-	return sg_dma_len(&iter->chunk->mem[iter->page_idx]);
+	return sg_dma_len(&iter->chunk->sg[iter->page_idx]);
 }
 
 int mlx4_MAP_ICM_AUX(struct mlx4_dev *dev, struct mlx4_icm *icm);
