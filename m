From: Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH v4 2/2] net/mlx4: replace pci_{,un}map_sg with dma_{,un}map_sg
Date: Thu,  3 Jan 2019 10:23:24 -0700
Message-ID: <20190103172324.21748-2-swarren@wwwdotorg.org>
References: <20190103172324.21748-1-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190103172324.21748-1-swarren@wwwdotorg.org>
Sender: netdev-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, xavier.huwei@huawei.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, Stephen Warren <swarren@nvidia.com>
List-Id: linux-rdma@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

pci_{,un}map_sg are deprecated and replaced by dma_{,un}map_sg. This is
especially relevant since the rest of the driver uses the DMA API. Fix
the driver to use the replacement APIs.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v4: New patch.
---
 drivers/net/ethernet/mellanox/mlx4/icm.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 76b84d08a058..d89a3da89e5a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -57,8 +57,8 @@ static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chu
 	int i;
 
 	if (chunk->nsg > 0)
-		pci_unmap_sg(dev->persist->pdev, chunk->sg, chunk->npages,
-			     PCI_DMA_BIDIRECTIONAL);
+		dma_unmap_sg(&dev->persist->pdev->dev, chunk->sg, chunk->npages,
+			     DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
 		__free_pages(sg_page(&chunk->sg[i]),
@@ -204,9 +204,9 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 		if (coherent)
 			++chunk->nsg;
 		else if (chunk->npages == MLX4_ICM_CHUNK_LEN) {
-			chunk->nsg = pci_map_sg(dev->persist->pdev, chunk->sg,
-						chunk->npages,
-						PCI_DMA_BIDIRECTIONAL);
+			chunk->nsg = dma_map_sg(&dev->persist->pdev->dev,
+						chunk->sg, chunk->npages,
+						DMA_BIDIRECTIONAL);
 
 			if (chunk->nsg <= 0)
 				goto fail;
@@ -219,9 +219,8 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 	}
 
 	if (!coherent && chunk) {
-		chunk->nsg = pci_map_sg(dev->persist->pdev, chunk->sg,
-					chunk->npages,
-					PCI_DMA_BIDIRECTIONAL);
+		chunk->nsg = dma_map_sg(&dev->persist->pdev->dev, chunk->sg,
+					chunk->npages, DMA_BIDIRECTIONAL);
 
 		if (chunk->nsg <= 0)
 			goto fail;
-- 
2.20.1
