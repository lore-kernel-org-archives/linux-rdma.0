From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] vmw_pvrdma: switch to pci_alloc_irq_vectors
Date: Thu,  9 Feb 2017 16:11:43 +0100
Message-ID: <20170209151143.15684-1-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

.. and greatly clean up the irq handling boilerplate code.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |   7 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |   6 -
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 166 +++++-----------------
 3 files changed, 35 insertions(+), 144 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 71e1d55d69d6..afe0a85fe3c0 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -196,13 +196,6 @@ struct pvrdma_dev {
 	spinlock_t cmd_lock; /* Command lock. */
 	struct semaphore cmd_sema;
 	struct completion cmd_done;
-	struct {
-		enum pvrdma_intr_type type; /* Intr type */
-		struct msix_entry msix_entry[PVRDMA_MAX_INTERRUPTS];
-		irq_handler_t handler[PVRDMA_MAX_INTERRUPTS];
-		u8 enabled[PVRDMA_MAX_INTERRUPTS];
-		u8 size;
-	} intr;
 
 	/* RDMA-related device information. */
 	union ib_gid *sgid_tbl;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
index c06768635d65..e69d6f3cae32 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
@@ -149,12 +149,6 @@ enum pvrdma_intr_cause {
 	PVRDMA_INTR_CAUSE_CQ		= (1 << PVRDMA_INTR_VECTOR_CQ),
 };
 
-enum pvrdma_intr_type {
-	PVRDMA_INTR_TYPE_INTX,		/* Legacy. */
-	PVRDMA_INTR_TYPE_MSI,		/* MSI. */
-	PVRDMA_INTR_TYPE_MSIX,		/* MSI-X. */
-};
-
 enum pvrdma_gos_bits {
 	PVRDMA_GOS_BITS_UNK,		/* Unknown. */
 	PVRDMA_GOS_BITS_32,		/* 32-bit. */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 231a1ce1f4be..dccda92f090d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -282,7 +282,7 @@ static irqreturn_t pvrdma_intr0_handler(int irq, void *dev_id)
 
 	dev_dbg(&dev->pdev->dev, "interrupt 0 (response) handler\n");
 
-	if (dev->intr.type != PVRDMA_INTR_TYPE_MSIX) {
+	if (!dev->pdev->msix_enabled) {
 		/* Legacy intr */
 		icr = pvrdma_read_reg(dev, PVRDMA_REG_ICR);
 		if (icr == 0)
@@ -489,31 +489,14 @@ static irqreturn_t pvrdma_intrx_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void pvrdma_disable_msi_all(struct pvrdma_dev *dev)
-{
-	if (dev->intr.type == PVRDMA_INTR_TYPE_MSIX)
-		pci_disable_msix(dev->pdev);
-	else if (dev->intr.type == PVRDMA_INTR_TYPE_MSI)
-		pci_disable_msi(dev->pdev);
-}
-
 static void pvrdma_free_irq(struct pvrdma_dev *dev)
 {
-	int i;
-
 	dev_dbg(&dev->pdev->dev, "freeing interrupts\n");
-
-	if (dev->intr.type == PVRDMA_INTR_TYPE_MSIX) {
-		for (i = 0; i < dev->intr.size; i++) {
-			if (dev->intr.enabled[i]) {
-				free_irq(dev->intr.msix_entry[i].vector, dev);
-				dev->intr.enabled[i] = 0;
-			}
-		}
-	} else if (dev->intr.type == PVRDMA_INTR_TYPE_INTX ||
-		   dev->intr.type == PVRDMA_INTR_TYPE_MSI) {
-		free_irq(dev->pdev->irq, dev);
+	if (dev->pdev->msix_enabled) {
+		free_irq(pci_irq_vector(dev->pdev, 2), dev);
+		free_irq(pci_irq_vector(dev->pdev, 1), dev);
 	}
+	free_irq(pci_irq_vector(dev->pdev, 0), dev);
 }
 
 static void pvrdma_enable_intrs(struct pvrdma_dev *dev)
@@ -528,126 +511,47 @@ static void pvrdma_disable_intrs(struct pvrdma_dev *dev)
 	pvrdma_write_reg(dev, PVRDMA_REG_IMR, ~0);
 }
 
-static int pvrdma_enable_msix(struct pci_dev *pdev, struct pvrdma_dev *dev)
-{
-	int i;
-	int ret;
-
-	for (i = 0; i < PVRDMA_MAX_INTERRUPTS; i++) {
-		dev->intr.msix_entry[i].entry = i;
-		dev->intr.msix_entry[i].vector = i;
-
-		switch (i) {
-		case 0:
-			/* CMD ring handler */
-			dev->intr.handler[i] = pvrdma_intr0_handler;
-			break;
-		case 1:
-			/* Async event ring handler */
-			dev->intr.handler[i] = pvrdma_intr1_handler;
-			break;
-		default:
-			/* Completion queue handler */
-			dev->intr.handler[i] = pvrdma_intrx_handler;
-			break;
-		}
-	}
-
-	ret = pci_enable_msix(pdev, dev->intr.msix_entry,
-			      PVRDMA_MAX_INTERRUPTS);
-	if (!ret) {
-		dev->intr.type = PVRDMA_INTR_TYPE_MSIX;
-		dev->intr.size = PVRDMA_MAX_INTERRUPTS;
-	} else if (ret > 0) {
-		ret = pci_enable_msix(pdev, dev->intr.msix_entry, ret);
-		if (!ret) {
-			dev->intr.type = PVRDMA_INTR_TYPE_MSIX;
-			dev->intr.size = ret;
-		} else {
-			dev->intr.size = 0;
-		}
-	}
-
-	dev_dbg(&pdev->dev, "using interrupt type %d, size %d\n",
-		dev->intr.type, dev->intr.size);
-
-	return ret;
-}
-
 static int pvrdma_alloc_intrs(struct pvrdma_dev *dev)
 {
-	int ret = 0;
-	int i;
-
-	if (pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX) &&
-	    pvrdma_enable_msix(dev->pdev, dev)) {
-		/* Try MSI */
-		ret = pci_enable_msi(dev->pdev);
-		if (!ret) {
-			dev->intr.type = PVRDMA_INTR_TYPE_MSI;
-		} else {
-			/* Legacy INTR */
-			dev->intr.type = PVRDMA_INTR_TYPE_INTX;
-		}
+	struct pci_dev *pdev = dev->pdev;
+	int ret = 0, nr_vectors, i = 0;
+
+	nr_vectors = pci_alloc_irq_vectors(pdev, 1, PVRDMA_MAX_INTERRUPTS,
+			PCI_IRQ_MSIX);
+	if (nr_vectors < 0) {
+		ret = pci_alloc_irq_vectors(pdev, 1, 1,
+				PCI_IRQ_MSI | PCI_IRQ_LEGACY);
+		if (nr_vectors < 0)
+			return nr_vectors;
 	}
 
-	/* Request First IRQ */
-	switch (dev->intr.type) {
-	case PVRDMA_INTR_TYPE_INTX:
-	case PVRDMA_INTR_TYPE_MSI:
-		ret = request_irq(dev->pdev->irq, pvrdma_intr0_handler,
-				  IRQF_SHARED, DRV_NAME, dev);
-		if (ret) {
-			dev_err(&dev->pdev->dev,
-				"failed to request interrupt\n");
-			goto disable_msi;
-		}
-		break;
-	case PVRDMA_INTR_TYPE_MSIX:
-		ret = request_irq(dev->intr.msix_entry[0].vector,
-				  pvrdma_intr0_handler, 0, DRV_NAME, dev);
-		if (ret) {
-			dev_err(&dev->pdev->dev,
-				"failed to request interrupt 0\n");
-			goto disable_msi;
-		}
-		dev->intr.enabled[0] = 1;
-		break;
-	default:
-		/* Not reached */
-		break;
+	ret = request_irq(pci_irq_vector(dev->pdev, 0), pvrdma_intr0_handler,
+			pdev->msix_enabled ? 0 : IRQF_SHARED, DRV_NAME, dev);
+	if (ret) {
+		dev_err(&dev->pdev->dev,
+			"failed to request interrupt 0\n");
+		goto out_free_vectors;
 	}
 
-	/* For MSIX: request intr for each vector */
-	if (dev->intr.size > 1) {
-		ret = request_irq(dev->intr.msix_entry[1].vector,
-				  pvrdma_intr1_handler, 0, DRV_NAME, dev);
+	for (i = i; i < nr_vectors; i++) {
+		ret = request_irq(pci_irq_vector(dev->pdev, 0),
+				i == 1 ? pvrdma_intr1_handler :
+					 pvrdma_intrx_handler,
+				0, DRV_NAME, dev);
 		if (ret) {
 			dev_err(&dev->pdev->dev,
-				"failed to request interrupt 1\n");
-			goto free_irq;
-		}
-		dev->intr.enabled[1] = 1;
-
-		for (i = 2; i < dev->intr.size; i++) {
-			ret = request_irq(dev->intr.msix_entry[i].vector,
-					  pvrdma_intrx_handler, 0,
-					  DRV_NAME, dev);
-			if (ret) {
-				dev_err(&dev->pdev->dev,
-					"failed to request interrupt %d\n", i);
-				goto free_irq;
-			}
-			dev->intr.enabled[i] = 1;
+				"failed to request interrupt %d\n", i);
+			goto free_irqs;
 		}
 	}
 
 	return 0;
 
-free_irq:
-	pvrdma_free_irq(dev);
-disable_msi:
-	pvrdma_disable_msi_all(dev);
+free_irqs:
+	while (--i >= 0)
+		free_irq(pci_irq_vector(dev->pdev, i), dev);
+out_free_vectors:
+	pci_free_irq_vectors(pdev);
 	return ret;
 }
 
@@ -1091,7 +995,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	pvrdma_uar_table_cleanup(dev);
 err_free_intrs:
 	pvrdma_free_irq(dev);
-	pvrdma_disable_msi_all(dev);
+	pci_free_irq_vectors(pdev);
 err_netdevice:
 	unregister_netdevice_notifier(&dev->nb_netdev);
 err_free_cq_ring:
@@ -1143,7 +1047,7 @@ static void pvrdma_pci_remove(struct pci_dev *pdev)
 
 	pvrdma_disable_intrs(dev);
 	pvrdma_free_irq(dev);
-	pvrdma_disable_msi_all(dev);
+	pci_free_irq_vectors(pdev);
 
 	/* Deactivate pvrdma device */
 	pvrdma_write_reg(dev, PVRDMA_REG_CTL, PVRDMA_DEVICE_CTL_RESET);
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
