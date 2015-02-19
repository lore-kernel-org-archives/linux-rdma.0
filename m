From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH v2 1/1] IB/mthca: remove deprecated use of pci api
Date: Thu, 19 Feb 2015 10:43:19 +0100
Message-ID: <20150219094319.GA11743@sloth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Replace occurences of the pci api by appropriate call to the dma api.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr)

@deprecated@
idexpression id;
position p;
@@

(
  pci_dma_supported@p ( id, ...)
|
  pci_alloc_consistent@p ( id, ...)
)

@bad1@
idexpression id;
position deprecated.p;
@@
...when != &id->dev
   when != pci_get_drvdata ( id )
   when != pci_enable_device ( id )
(
  pci_dma_supported@p ( id, ...)
|
  pci_alloc_consistent@p ( id, ...)
)

@depends on !bad1@
idexpression id;
expression direction;
position deprecated.p;
@@

(
- pci_dma_supported@p ( id,
+ dma_supported ( &id->dev,
...
+ , GFP_ATOMIC
  )
|
- pci_alloc_consistent@p ( id,
+ dma_alloc_coherent ( &id->dev,
...
+ , GFP_ATOMIC
  )
)

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 Changes since v1:
   - replace cast from pci enum to dma enum with approriate
     dma enum value as suggested by Roland Dreier

 drivers/infiniband/hw/mthca/mthca_eq.c      | 18 ++++++++++--------
 drivers/infiniband/hw/mthca/mthca_main.c    |  8 ++++----
 drivers/infiniband/hw/mthca/mthca_memfree.c | 23 ++++++++++++++---------
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 6902017..fd0c437 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -617,7 +617,7 @@ static void mthca_free_eq(struct mthca_dev *dev,
 
 	mthca_free_mr(dev, &eq->mr);
 	for (i = 0; i < npages; ++i)
-		pci_free_consistent(dev->pdev, PAGE_SIZE,
+		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
 				    eq->page_list[i].buf,
 				    dma_unmap_addr(&eq->page_list[i], mapping));
 
@@ -739,17 +739,19 @@ int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt)
 	dev->eq_table.icm_page = alloc_page(GFP_HIGHUSER);
 	if (!dev->eq_table.icm_page)
 		return -ENOMEM;
-	dev->eq_table.icm_dma  = pci_map_page(dev->pdev, dev->eq_table.icm_page, 0,
-					      PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(dev->pdev, dev->eq_table.icm_dma)) {
+	dev->eq_table.icm_dma  = dma_map_page(&dev->pdev->dev,
+					      dev->eq_table.icm_page, 0,
+					      PAGE_SIZE, DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(&dev->pdev->dev, dev->eq_table.icm_dma)) {
 		__free_page(dev->eq_table.icm_page);
 		return -ENOMEM;
 	}
 
 	ret = mthca_MAP_ICM_page(dev, dev->eq_table.icm_dma, icm_virt);
 	if (ret) {
-		pci_unmap_page(dev->pdev, dev->eq_table.icm_dma, PAGE_SIZE,
-			       PCI_DMA_BIDIRECTIONAL);
+		dma_unmap_page(&dev->pdev->dev, dev->eq_table.icm_dma,
+			       PAGE_SIZE, DMA_BIDIRECTIONAL);
 		__free_page(dev->eq_table.icm_page);
 	}
 
@@ -759,8 +761,8 @@ int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt)
 void mthca_unmap_eq_icm(struct mthca_dev *dev)
 {
 	mthca_UNMAP_ICM(dev, dev->eq_table.icm_virt, 1);
-	pci_unmap_page(dev->pdev, dev->eq_table.icm_dma, PAGE_SIZE,
-		       PCI_DMA_BIDIRECTIONAL);
+	dma_unmap_page(&dev->pdev->dev, dev->eq_table.icm_dma, PAGE_SIZE,
+		       DMA_BIDIRECTIONAL);
 	__free_page(dev->eq_table.icm_page);
 }
 
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index ded76c1..2b52416 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -940,20 +940,20 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting.\n");
 			goto err_free_res;
 		}
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
 			 "consistent PCI DMA mask.\n");
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, "
 				"aborting.\n");
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 7d2e42d..3bca68f 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -66,8 +66,8 @@ static void mthca_free_icm_pages(struct mthca_dev *dev, struct mthca_icm_chunk *
 	int i;
 
 	if (chunk->nsg > 0)
-		pci_unmap_sg(dev->pdev, chunk->mem, chunk->npages,
-			     PCI_DMA_BIDIRECTIONAL);
+		dma_unmap_sg(&dev->pdev->dev, chunk->mem, chunk->npages,
+			     DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
 		__free_pages(sg_page(&chunk->mem[i]),
@@ -184,9 +184,10 @@ struct mthca_icm *mthca_alloc_icm(struct mthca_dev *dev, int npages,
 			if (coherent)
 				++chunk->nsg;
 			else if (chunk->npages == MTHCA_ICM_CHUNK_LEN) {
-				chunk->nsg = pci_map_sg(dev->pdev, chunk->mem,
+				chunk->nsg = dma_map_sg(&dev->pdev->dev,
+							chunk->mem,
 							chunk->npages,
-							PCI_DMA_BIDIRECTIONAL);
+							DMA_BIDIRECTIONAL);
 
 				if (chunk->nsg <= 0)
 					goto fail;
@@ -204,9 +205,10 @@ struct mthca_icm *mthca_alloc_icm(struct mthca_dev *dev, int npages,
 	}
 
 	if (!coherent && chunk) {
-		chunk->nsg = pci_map_sg(dev->pdev, chunk->mem,
+		chunk->nsg = dma_map_sg(&dev->pdev->dev,
+					chunk->mem,
 					chunk->npages,
-					PCI_DMA_BIDIRECTIONAL);
+					DMA_BIDIRECTIONAL);
 
 		if (chunk->nsg <= 0)
 			goto fail;
@@ -480,7 +482,8 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 	sg_set_page(&db_tab->page[i].mem, pages[0], MTHCA_ICM_PAGE_SIZE,
 			uaddr & ~PAGE_MASK);
 
-	ret = pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
+	ret = dma_map_sg(&dev->pdev->dev, &db_tab->page[i].mem, 1,
+			 DMA_TO_DEVICE);
 	if (ret < 0) {
 		put_page(pages[0]);
 		goto out;
@@ -489,7 +492,8 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 	ret = mthca_MAP_ICM_page(dev, sg_dma_address(&db_tab->page[i].mem),
 				 mthca_uarc_virt(dev, uar, i));
 	if (ret) {
-		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
+		dma_unmap_sg(&dev->pdev->dev, &db_tab->page[i].mem, 1,
+			     DMA_TO_DEVICE);
 		put_page(sg_page(&db_tab->page[i].mem));
 		goto out;
 	}
@@ -555,7 +559,8 @@ void mthca_cleanup_user_db_tab(struct mthca_dev *dev, struct mthca_uar *uar,
 	for (i = 0; i < dev->uar_table.uarc_size / MTHCA_ICM_PAGE_SIZE; ++i) {
 		if (db_tab->page[i].uvirt) {
 			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
-			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
+			dma_unmap_sg(&dev->pdev->dev, &db_tab->page[i].mem, 1,
+				     DMA_TO_DEVICE);
 			put_page(sg_page(&db_tab->page[i].mem));
 		}
 	}
-- 
1.9.1
