From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] IB/mthca: switch to pci_alloc_irq_vectors
Date: Thu,  9 Feb 2017 16:10:58 +0100
Message-ID: <20170209151058.15632-1-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Trivial switch to the new API for this driver.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_main.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index ded76c101dde..c309e5c96383 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -851,20 +851,18 @@ static int mthca_setup_hca(struct mthca_dev *dev)
 
 static int mthca_enable_msi_x(struct mthca_dev *mdev)
 {
-	struct msix_entry entries[3];
 	int err;
 
-	entries[0].entry = 0;
-	entries[1].entry = 1;
-	entries[2].entry = 2;
-
-	err = pci_enable_msix_exact(mdev->pdev, entries, ARRAY_SIZE(entries));
-	if (err)
+	err = pci_alloc_irq_vectors(mdev->pdev, 3, 3, PCI_IRQ_MSIX);
+	if (err < 0)
 		return err;
 
-	mdev->eq_table.eq[MTHCA_EQ_COMP ].msi_x_vector = entries[0].vector;
-	mdev->eq_table.eq[MTHCA_EQ_ASYNC].msi_x_vector = entries[1].vector;
-	mdev->eq_table.eq[MTHCA_EQ_CMD  ].msi_x_vector = entries[2].vector;
+	mdev->eq_table.eq[MTHCA_EQ_COMP ].msi_x_vector =
+			pci_irq_vector(mdev->pdev, 0);
+	mdev->eq_table.eq[MTHCA_EQ_ASYNC].msi_x_vector =
+			pci_irq_vector(mdev->pdev, 1);
+	mdev->eq_table.eq[MTHCA_EQ_CMD  ].msi_x_vector =
+			pci_irq_vector(mdev->pdev, 2);
 
 	return 0;
 }
@@ -1018,7 +1016,7 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 	err = mthca_setup_hca(mdev);
 	if (err == -EBUSY && (mdev->mthca_flags & MTHCA_FLAG_MSI_X)) {
 		if (mdev->mthca_flags & MTHCA_FLAG_MSI_X)
-			pci_disable_msix(pdev);
+			pci_free_irq_vectors(pdev);
 		mdev->mthca_flags &= ~MTHCA_FLAG_MSI_X;
 
 		err = mthca_setup_hca(mdev);
@@ -1062,7 +1060,7 @@ static int __mthca_init_one(struct pci_dev *pdev, int hca_type)
 
 err_close:
 	if (mdev->mthca_flags & MTHCA_FLAG_MSI_X)
-		pci_disable_msix(pdev);
+		pci_free_irq_vectors(pdev);
 
 	mthca_close_hca(mdev);
 
@@ -1113,7 +1111,7 @@ static void __mthca_remove_one(struct pci_dev *pdev)
 		mthca_cmd_cleanup(mdev);
 
 		if (mdev->mthca_flags & MTHCA_FLAG_MSI_X)
-			pci_disable_msix(pdev);
+			pci_free_irq_vectors(pdev);
 
 		ib_dealloc_device(&mdev->ib_dev);
 		pci_release_regions(pdev);
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
