From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 11/12] Clear status reporting from mthca_memfree
Date: Thu, 7 Jul 2011 12:23:15 -0500
Message-ID: <20110707172314.GL10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_memfree.c |   45 +++++++++------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index 8c2a837..9d9ca45 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -223,7 +223,6 @@ int mthca_table_get(struct mthca_dev *dev, struct mthca_icm_table *table, int ob
 {
 	int i = (obj & (table->num_obj - 1)) * table->obj_size / MTHCA_TABLE_CHUNK_SIZE;
 	int ret = 0;
-	u8 status;
 
 	mutex_lock(&table->mutex);
 
@@ -240,11 +239,10 @@ int mthca_table_get(struct mthca_dev *dev, struct mthca_icm_table *table, int ob
 		goto out;
 	}
 
-	if (mthca_MAP_ICM(dev, table->icm[i], table->virt + i * MTHCA_TABLE_CHUNK_SIZE,
-			  &status) || status) {
+	if (mthca_MAP_ICM(dev, table->icm[i], 
+				table->virt + i * MTHCA_TABLE_CHUNK_SIZE)) {
 		mthca_free_icm(dev, table->icm[i], table->coherent);
 		table->icm[i] = NULL;
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -258,7 +256,6 @@ out:
 void mthca_table_put(struct mthca_dev *dev, struct mthca_icm_table *table, int obj)
 {
 	int i;
-	u8 status;
 
 	if (!mthca_is_memfree(dev))
 		return;
@@ -269,8 +266,7 @@ void mthca_table_put(struct mthca_dev *dev, struct mthca_icm_table *table, int o
 
 	if (--table->icm[i]->refcount == 0) {
 		mthca_UNMAP_ICM(dev, table->virt + i * MTHCA_TABLE_CHUNK_SIZE,
-				MTHCA_TABLE_CHUNK_SIZE / MTHCA_ICM_PAGE_SIZE,
-				&status);
+				MTHCA_TABLE_CHUNK_SIZE / MTHCA_ICM_PAGE_SIZE);
 		mthca_free_icm(dev, table->icm[i], table->coherent);
 		table->icm[i] = NULL;
 	}
@@ -366,7 +362,6 @@ struct mthca_icm_table *mthca_alloc_icm_table(struct mthca_dev *dev,
 	int num_icm;
 	unsigned chunk_size;
 	int i;
-	u8 status;
 
 	obj_per_chunk = MTHCA_TABLE_CHUNK_SIZE / obj_size;
 	num_icm = DIV_ROUND_UP(nobj, obj_per_chunk);
@@ -396,8 +391,8 @@ struct mthca_icm_table *mthca_alloc_icm_table(struct mthca_dev *dev,
 						__GFP_NOWARN, use_coherent);
 		if (!table->icm[i])
 			goto err;
-		if (mthca_MAP_ICM(dev, table->icm[i], virt + i * MTHCA_TABLE_CHUNK_SIZE,
-				  &status) || status) {
+		if (mthca_MAP_ICM(dev, table->icm[i],
+					virt + i * MTHCA_TABLE_CHUNK_SIZE)) {
 			mthca_free_icm(dev, table->icm[i], table->coherent);
 			table->icm[i] = NULL;
 			goto err;
@@ -416,8 +411,7 @@ err:
 	for (i = 0; i < num_icm; ++i)
 		if (table->icm[i]) {
 			mthca_UNMAP_ICM(dev, virt + i * MTHCA_TABLE_CHUNK_SIZE,
-					MTHCA_TABLE_CHUNK_SIZE / MTHCA_ICM_PAGE_SIZE,
-					&status);
+				MTHCA_TABLE_CHUNK_SIZE / MTHCA_ICM_PAGE_SIZE);
 			mthca_free_icm(dev, table->icm[i], table->coherent);
 		}
 
@@ -429,13 +423,12 @@ err:
 void mthca_free_icm_table(struct mthca_dev *dev, struct mthca_icm_table *table)
 {
 	int i;
-	u8 status;
 
 	for (i = 0; i < table->num_icm; ++i)
 		if (table->icm[i]) {
-			mthca_UNMAP_ICM(dev, table->virt + i * MTHCA_TABLE_CHUNK_SIZE,
-					MTHCA_TABLE_CHUNK_SIZE / MTHCA_ICM_PAGE_SIZE,
-					&status);
+			mthca_UNMAP_ICM(dev,
+				table->virt + i * MTHCA_TABLE_CHUNK_SIZE,
+				MTHCA_TABLE_CHUNK_SIZE / MTHCA_ICM_PAGE_SIZE);
 			mthca_free_icm(dev, table->icm[i], table->coherent);
 		}
 
@@ -454,7 +447,6 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 {
 	struct page *pages[1];
 	int ret = 0;
-	u8 status;
 	int i;
 
 	if (!mthca_is_memfree(dev))
@@ -494,9 +486,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 	}
 
 	ret = mthca_MAP_ICM_page(dev, sg_dma_address(&db_tab->page[i].mem),
-				 mthca_uarc_virt(dev, uar, i), &status);
-	if (!ret && status)
-		ret = -EINVAL;
+				 mthca_uarc_virt(dev, uar, i));
 	if (ret) {
 		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 		put_page(sg_page(&db_tab->page[i].mem));
@@ -557,14 +547,13 @@ void mthca_cleanup_user_db_tab(struct mthca_dev *dev, struct mthca_uar *uar,
 			       struct mthca_user_db_table *db_tab)
 {
 	int i;
-	u8 status;
 
 	if (!mthca_is_memfree(dev))
 		return;
 
 	for (i = 0; i < dev->uar_table.uarc_size / MTHCA_ICM_PAGE_SIZE; ++i) {
 		if (db_tab->page[i].uvirt) {
-			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1, &status);
+			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
 			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 			put_page(sg_page(&db_tab->page[i].mem));
 		}
@@ -581,7 +570,6 @@ int mthca_alloc_db(struct mthca_dev *dev, enum mthca_db_type type,
 	int i, j;
 	struct mthca_db_page *page;
 	int ret = 0;
-	u8 status;
 
 	mutex_lock(&dev->db_tab->mutex);
 
@@ -644,9 +632,7 @@ alloc:
 	memset(page->db_rec, 0, MTHCA_ICM_PAGE_SIZE);
 
 	ret = mthca_MAP_ICM_page(dev, page->mapping,
-				 mthca_uarc_virt(dev, &dev->driver_uar, i), &status);
-	if (!ret && status)
-		ret = -EINVAL;
+				 mthca_uarc_virt(dev, &dev->driver_uar, i));
 	if (ret) {
 		dma_free_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
 				  page->db_rec, page->mapping);
@@ -678,7 +664,6 @@ void mthca_free_db(struct mthca_dev *dev, int type, int db_index)
 {
 	int i, j;
 	struct mthca_db_page *page;
-	u8 status;
 
 	i = db_index / MTHCA_DB_REC_PER_PAGE;
 	j = db_index % MTHCA_DB_REC_PER_PAGE;
@@ -694,7 +679,7 @@ void mthca_free_db(struct mthca_dev *dev, int type, int db_index)
 
 	if (bitmap_empty(page->used, MTHCA_DB_REC_PER_PAGE) &&
 	    i >= dev->db_tab->max_group1 - 1) {
-		mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, &dev->driver_uar, i), 1, &status);
+		mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, &dev->driver_uar, i), 1);
 
 		dma_free_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
 				  page->db_rec, page->mapping);
@@ -745,7 +730,6 @@ int mthca_init_db_tab(struct mthca_dev *dev)
 void mthca_cleanup_db_tab(struct mthca_dev *dev)
 {
 	int i;
-	u8 status;
 
 	if (!mthca_is_memfree(dev))
 		return;
@@ -763,7 +747,8 @@ void mthca_cleanup_db_tab(struct mthca_dev *dev)
 		if (!bitmap_empty(dev->db_tab->page[i].used, MTHCA_DB_REC_PER_PAGE))
 			mthca_warn(dev, "Kernel UARC page %d not empty\n", i);
 
-		mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, &dev->driver_uar, i), 1, &status);
+		mthca_UNMAP_ICM(dev,
+			mthca_uarc_virt(dev, &dev->driver_uar, i), 1);
 
 		dma_free_coherent(&dev->pdev->dev, MTHCA_ICM_PAGE_SIZE,
 				  dev->db_tab->page[i].db_rec,
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
