From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 04/12] Clean status from mthca_eq
Date: Thu, 7 Jul 2011 12:21:28 -0500
Message-ID: <20110707172128.GE10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_eq.c |   43 +++++++------------------------
 1 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 76785c6..7c9d35f 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -474,7 +474,6 @@ static int mthca_create_eq(struct mthca_dev *dev,
 	struct mthca_eq_context *eq_context;
 	int err = -ENOMEM;
 	int i;
-	u8 status;
 
 	eq->dev  = dev;
 	eq->nent = roundup_pow_of_two(max(nent, 2));
@@ -543,15 +542,9 @@ static int mthca_create_eq(struct mthca_dev *dev,
 	eq_context->intr            = intr;
 	eq_context->lkey            = cpu_to_be32(eq->mr.ibmr.lkey);
 
-	err = mthca_SW2HW_EQ(dev, mailbox, eq->eqn, &status);
+	err = mthca_SW2HW_EQ(dev, mailbox, eq->eqn);
 	if (err) {
-		mthca_warn(dev, "SW2HW_EQ failed (%d)\n", err);
-		goto err_out_free_mr;
-	}
-	if (status) {
-		mthca_warn(dev, "SW2HW_EQ returned status 0x%02x\n",
-			   status);
-		err = -EINVAL;
+		mthca_warn(dev, "SW2HW_EQ returned %d\n", err);
 		goto err_out_free_mr;
 	}
 
@@ -597,7 +590,6 @@ static void mthca_free_eq(struct mthca_dev *dev,
 {
 	struct mthca_mailbox *mailbox;
 	int err;
-	u8 status;
 	int npages = (eq->nent * MTHCA_EQ_ENTRY_SIZE + PAGE_SIZE - 1) /
 		PAGE_SIZE;
 	int i;
@@ -606,11 +598,9 @@ static void mthca_free_eq(struct mthca_dev *dev,
 	if (IS_ERR(mailbox))
 		return;
 
-	err = mthca_HW2SW_EQ(dev, mailbox, eq->eqn, &status);
+	err = mthca_HW2SW_EQ(dev, mailbox, eq->eqn);
 	if (err)
-		mthca_warn(dev, "HW2SW_EQ failed (%d)\n", err);
-	if (status)
-		mthca_warn(dev, "HW2SW_EQ returned status 0x%02x\n", status);
+		mthca_warn(dev, "HW2SW_EQ returned %d\n", err);
 
 	dev->eq_table.arm_mask &= ~eq->eqn_mask;
 
@@ -738,7 +728,6 @@ static void mthca_unmap_eq_regs(struct mthca_dev *dev)
 int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt)
 {
 	int ret;
-	u8 status;
 
 	/*
 	 * We assume that mapping one page is enough for the whole EQ
@@ -757,9 +746,7 @@ int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt)
 		return -ENOMEM;
 	}
 
-	ret = mthca_MAP_ICM_page(dev, dev->eq_table.icm_dma, icm_virt, &status);
-	if (!ret && status)
-		ret = -EINVAL;
+	ret = mthca_MAP_ICM_page(dev, dev->eq_table.icm_dma, icm_virt);
 	if (ret) {
 		pci_unmap_page(dev->pdev, dev->eq_table.icm_dma, PAGE_SIZE,
 			       PCI_DMA_BIDIRECTIONAL);
@@ -771,9 +758,7 @@ int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt)
 
 void mthca_unmap_eq_icm(struct mthca_dev *dev)
 {
-	u8 status;
-
-	mthca_UNMAP_ICM(dev, dev->eq_table.icm_virt, 1, &status);
+	mthca_UNMAP_ICM(dev, dev->eq_table.icm_virt, 1);
 	pci_unmap_page(dev->pdev, dev->eq_table.icm_dma, PAGE_SIZE,
 		       PCI_DMA_BIDIRECTIONAL);
 	__free_page(dev->eq_table.icm_page);
@@ -782,7 +767,6 @@ void mthca_unmap_eq_icm(struct mthca_dev *dev)
 int mthca_init_eq_table(struct mthca_dev *dev)
 {
 	int err;
-	u8 status;
 	u8 intr;
 	int i;
 
@@ -864,22 +848,16 @@ int mthca_init_eq_table(struct mthca_dev *dev)
 	}
 
 	err = mthca_MAP_EQ(dev, async_mask(dev),
-			   0, dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn, &status);
+			   0, dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn);
 	if (err)
 		mthca_warn(dev, "MAP_EQ for async EQ %d failed (%d)\n",
 			   dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn, err);
-	if (status)
-		mthca_warn(dev, "MAP_EQ for async EQ %d returned status 0x%02x\n",
-			   dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn, status);
 
 	err = mthca_MAP_EQ(dev, MTHCA_CMD_EVENT_MASK,
-			   0, dev->eq_table.eq[MTHCA_EQ_CMD].eqn, &status);
+			   0, dev->eq_table.eq[MTHCA_EQ_CMD].eqn);
 	if (err)
 		mthca_warn(dev, "MAP_EQ for cmd EQ %d failed (%d)\n",
 			   dev->eq_table.eq[MTHCA_EQ_CMD].eqn, err);
-	if (status)
-		mthca_warn(dev, "MAP_EQ for cmd EQ %d returned status 0x%02x\n",
-			   dev->eq_table.eq[MTHCA_EQ_CMD].eqn, status);
 
 	for (i = 0; i < MTHCA_NUM_EQ; ++i)
 		if (mthca_is_memfree(dev))
@@ -909,15 +887,14 @@ err_out_free:
 
 void mthca_cleanup_eq_table(struct mthca_dev *dev)
 {
-	u8 status;
 	int i;
 
 	mthca_free_irqs(dev);
 
 	mthca_MAP_EQ(dev, async_mask(dev),
-		     1, dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn, &status);
+		     1, dev->eq_table.eq[MTHCA_EQ_ASYNC].eqn);
 	mthca_MAP_EQ(dev, MTHCA_CMD_EVENT_MASK,
-		     1, dev->eq_table.eq[MTHCA_EQ_CMD].eqn, &status);
+		     1, dev->eq_table.eq[MTHCA_EQ_CMD].eqn);
 
 	for (i = 0; i < MTHCA_NUM_EQ; ++i)
 		mthca_free_eq(dev, &dev->eq_table.eq[i]);
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
