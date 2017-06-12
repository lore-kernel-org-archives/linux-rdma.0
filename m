From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-next 07/10] IB/qib: Replace deprecated pci functions
 with new API
Date: Mon, 12 Jun 2017 02:57:51 -0700
Message-ID: <20170612095751.GA2396@infradead.org>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
 <20170609230004.26710.93484.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170609230004.26710.93484.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 09, 2017 at 04:00:06PM -0700, Dennis Dalessandro wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> pci_enable_msix_range() and pci_disable_msix() have been deprecated.
> Updating to the new pci_alloc_irq_vectors() interface.

This should go a lot further to remove all the dealing with
low-level pci bits and storing the absolute vector number.

Untested idea below.  Btw, we should also move the post-reset
restoring of the various pci configuration bits to the PCI
core, and hfi1 should get a similar treatment to this.

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index a3e21a25cea5..df89380aa523 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1,7 +1,7 @@
 #ifndef _QIB_KERNEL_H
 #define _QIB_KERNEL_H
 /*
- * Copyright (c) 2012, 2013 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012 - 2017 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
  *
@@ -443,14 +443,12 @@ struct qib_irq_notify;
 #endif
 
 struct qib_msix_entry {
-	struct msix_entry msix;
 	void *arg;
 #ifdef CONFIG_INFINIBAND_QIB_DCA
 	int dca;
 	int rcv;
 	struct qib_irq_notify *notifier;
 #endif
-	char name[MAX_NAME_SIZE];
 	cpumask_var_t mask;
 };
 
@@ -1433,11 +1431,8 @@ int qib_pcie_init(struct pci_dev *, const struct pci_device_id *);
 int qib_pcie_ddinit(struct qib_devdata *, struct pci_dev *,
 		    const struct pci_device_id *);
 void qib_pcie_ddcleanup(struct qib_devdata *);
-int qib_pcie_params(struct qib_devdata *, u32, u32 *, struct qib_msix_entry *);
+int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent);
 int qib_reinit_intr(struct qib_devdata *);
-void qib_enable_intx(struct pci_dev *);
-void qib_nomsi(struct qib_devdata *);
-void qib_nomsix(struct qib_devdata *);
 void qib_pcie_getcmd(struct qib_devdata *, u16 *, u8 *, u8 *);
 void qib_pcie_reenable(struct qib_devdata *, u16, u8, u8);
 /* interrupts for device */
diff --git a/drivers/infiniband/hw/qib/qib_7220.h b/drivers/infiniband/hw/qib/qib_7220.h
index a5356cb4252e..4ec3dc1fbfb4 100644
--- a/drivers/infiniband/hw/qib/qib_7220.h
+++ b/drivers/infiniband/hw/qib/qib_7220.h
@@ -67,7 +67,6 @@ struct qib_chip_specific {
 	u32 lastbuf_for_pio;
 	u32 updthresh; /* current AvailUpdThld */
 	u32 updthresh_dflt; /* default AvailUpdThld */
-	int irq;
 	u8 presets_needed;
 	u8 relock_timer_active;
 	char emsgbuf[128];
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index e423b71e6ea0..6236bde06ba9 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 Intel Corporation. All rights reserved.
+ * Copyright (c) 2013 - 2017 Intel Corporation. All rights reserved.
  * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
  * All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
@@ -245,7 +245,6 @@ struct qib_chip_specific {
 	u64 iblnkerrsnap;
 	u64 ibcctrl; /* shadow for kr_ibcctrl */
 	u32 lastlinkrecov; /* link recovery issue */
-	int irq;
 	u32 cntrnamelen;
 	u32 portcntrnamelen;
 	u32 ncntrs;
@@ -1487,11 +1486,8 @@ static void qib_6120_setup_setextled(struct qib_pportdata *ppd, u32 on)
 
 static void qib_6120_free_irq(struct qib_devdata *dd)
 {
-	if (dd->cspec->irq) {
-		free_irq(dd->cspec->irq, dd);
-		dd->cspec->irq = 0;
-	}
-	qib_nomsi(dd);
+	pci_free_irq(dd->pcidev, 0, dd);
+	pci_free_irq_vectors(dd->pcidev);
 }
 
 /**
@@ -1706,6 +1702,8 @@ static irqreturn_t qib_6120intr(int irq, void *data)
  */
 static void qib_setup_6120_interrupt(struct qib_devdata *dd)
 {
+	int ret;
+
 	/*
 	 * If the chip supports added error indication via GPIO pins,
 	 * enable interrupts on those bits so the interrupt routine
@@ -1719,19 +1717,13 @@ static void qib_setup_6120_interrupt(struct qib_devdata *dd)
 		qib_write_kreg(dd, kr_gpio_mask, dd->cspec->gpio_mask);
 	}
 
-	if (!dd->cspec->irq)
-		qib_dev_err(dd,
-			"irq is 0, BIOS error?  Interrupts won't work\n");
-	else {
-		int ret;
 
-		ret = request_irq(dd->cspec->irq, qib_6120intr, 0,
-				  QIB_DRV_NAME, dd);
-		if (ret)
-			qib_dev_err(dd,
-				"Couldn't setup interrupt (irq=%d): %d\n",
-				dd->cspec->irq, ret);
-	}
+	ret = pci_request_irq(dd->pcidev, 0, qib_6120intr, NULL, dd,
+			QIB_DRV_NAME);
+	if (ret)
+		qib_dev_err(dd,
+			"Couldn't setup interrupt (irq=%d): %d\n",
+			pci_irq_vector(dd->pcidev, 0), ret);
 }
 
 /**
@@ -1838,7 +1830,7 @@ static int qib_6120_setup_reset(struct qib_devdata *dd)
 
 bail:
 	if (ret) {
-		if (qib_pcie_params(dd, dd->lbus_width, NULL, NULL))
+		if (qib_pcie_params(dd, dd->lbus_width, NULL))
 			qib_dev_err(dd,
 				"Reset failed to setup PCIe or interrupts; continuing anyway\n");
 		/* clear the reset error, init error/hwerror mask */
@@ -3562,10 +3554,9 @@ struct qib_devdata *qib_init_iba6120_funcs(struct pci_dev *pdev,
 	if (qib_mini_init)
 		goto bail;
 
-	if (qib_pcie_params(dd, 8, NULL, NULL))
+	if (qib_pcie_params(dd, 8, NULL))
 		qib_dev_err(dd,
 			"Failed to setup PCIe or interrupts; continuing anyway\n");
-	dd->cspec->irq = pdev->irq; /* save IRQ */
 
 	/* clear diagctrl register, in case diags were running and crashed */
 	qib_write_kreg(dd, kr_hwdiagctrl, 0);
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index c3679c48e61c..0112f4007b66 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2011 - 2017 Intel Corporation.  All rights reserved.
  * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
  * All rights reserved.
  * Copyright (c) 2003, 2004, 2005, 2006 PathScale, Inc. All rights reserved.
@@ -1781,11 +1782,8 @@ static void qib_setup_7220_setextled(struct qib_pportdata *ppd, u32 on)
 
 static void qib_7220_free_irq(struct qib_devdata *dd)
 {
-	if (dd->cspec->irq) {
-		free_irq(dd->cspec->irq, dd);
-		dd->cspec->irq = 0;
-	}
-	qib_nomsi(dd);
+	pci_free_irq(dd->pcidev, 0, dd);
+	pci_free_irq_vectors(dd->pcidev);
 }
 
 /*
@@ -2025,19 +2023,15 @@ static irqreturn_t qib_7220intr(int irq, void *data)
  */
 static void qib_setup_7220_interrupt(struct qib_devdata *dd)
 {
-	if (!dd->cspec->irq)
-		qib_dev_err(dd,
-			"irq is 0, BIOS error?  Interrupts won't work\n");
-	else {
-		int ret = request_irq(dd->cspec->irq, qib_7220intr,
-			dd->msi_lo ? 0 : IRQF_SHARED,
-			QIB_DRV_NAME, dd);
+	int ret;
 
-		if (ret)
-			qib_dev_err(dd,
-				"Couldn't setup %s interrupt (irq=%d): %d\n",
-				dd->msi_lo ?  "MSI" : "INTx",
-				dd->cspec->irq, ret);
+	ret = pci_request_irq(dd->pcidev, 0, qib_7220intr, NULL, dd,
+			QIB_DRV_NAME);
+	if (ret) {
+		qib_dev_err(dd,
+			"Couldn't setup %s interrupt (irq=%d): %d\n",
+			dd->pcidev->msi_enabled ? "MSI" : "INTx",
+			pci_irq_vector(dd->pcidev, 0), ret);
 	}
 }
 
@@ -2148,7 +2142,7 @@ static int qib_setup_7220_reset(struct qib_devdata *dd)
 
 bail:
 	if (ret) {
-		if (qib_pcie_params(dd, dd->lbus_width, NULL, NULL))
+		if (qib_pcie_params(dd, dd->lbus_width, NULL))
 			qib_dev_err(dd,
 				"Reset failed to setup PCIe or interrupts; continuing anyway\n");
 
@@ -3309,14 +3303,8 @@ static int qib_7220_intr_fallback(struct qib_devdata *dd)
 	qib_devinfo(dd->pcidev,
 		"MSI interrupt not detected, trying INTx interrupts\n");
 	qib_7220_free_irq(dd);
-	qib_enable_intx(dd->pcidev);
-	/*
-	 * Some newer kernels require free_irq before disable_msi,
-	 * and irq can be changed during disable and INTx enable
-	 * and we need to therefore use the pcidev->irq value,
-	 * not our saved MSI value.
-	 */
-	dd->cspec->irq = dd->pcidev->irq;
+	if (pci_alloc_irq_vectors(dd->pcidev, 1, 1, PCI_IRQ_LEGACY) < 0)
+		qib_dev_err(dd,	"Failed to enable INTx\n");
 	qib_setup_7220_interrupt(dd);
 	return 1;
 }
@@ -4619,13 +4607,10 @@ struct qib_devdata *qib_init_iba7220_funcs(struct pci_dev *pdev,
 		minwidth = 8; /* x8 capable boards */
 		break;
 	}
-	if (qib_pcie_params(dd, minwidth, NULL, NULL))
+	if (qib_pcie_params(dd, minwidth, NULL))
 		qib_dev_err(dd,
 			"Failed to setup PCIe or interrupts; continuing anyway\n");
 
-	/* save IRQ for possible later use */
-	dd->cspec->irq = pdev->irq;
-
 	if (qib_read_kreg64(dd, kr_hwerrstatus) &
 	    QLOGIC_IB_HWE_SERDESPLLFAILED)
 		qib_write_kreg(dd, kr_hwerrclear,
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index bb2439fff8fa..9f6d3215284b 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2012 - 2017 Intel Corporation.  All rights reserved.
  * Copyright (c) 2008 - 2012 QLogic Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -553,7 +553,6 @@ struct qib_chip_specific {
 	u32 updthresh; /* current AvailUpdThld */
 	u32 updthresh_dflt; /* default AvailUpdThld */
 	u32 r1;
-	int irq;
 	u32 num_msix_entries;
 	u32 sdmabufcnt;
 	u32 lastbuf_for_pio;
@@ -756,11 +755,9 @@ static void check_7322_rxe_status(struct qib_pportdata *);
 static u32 __iomem *qib_7322_getsendbuf(struct qib_pportdata *, u64, u32 *);
 #ifdef CONFIG_INFINIBAND_QIB_DCA
 static void qib_setup_dca(struct qib_devdata *dd);
-static void setup_dca_notifier(struct qib_devdata *dd,
-			       struct qib_msix_entry *m);
-static void reset_dca_notifier(struct qib_devdata *dd,
-			       struct qib_msix_entry *m);
+static void setup_dca_notifier(struct qib_devdata *dd, int vec);
 #endif
+static void reset_dca_notifier(struct qib_devdata *dd, int vec);
 
 /**
  * qib_read_ureg32 - read 32-bit virtualized per-context register
@@ -2778,7 +2775,7 @@ static void qib_setup_dca(struct qib_devdata *dd)
 		qib_write_kreg(dd, KREG_IDX(DCACtrlB) + i,
 			       cspec->dca_rcvhdr_ctrl[i]);
 	for (i = 0; i < cspec->num_msix_entries; i++)
-		setup_dca_notifier(dd, &cspec->msix_entries[i]);
+		setup_dca_notifier(dd, i);
 }
 
 static void qib_irq_notifier_notify(struct irq_affinity_notify *notify,
@@ -2820,12 +2817,7 @@ static void qib_irq_notifier_release(struct kref *ref)
 }
 #endif
 
-/*
- * Disable MSIx interrupt if enabled, call generic MSIx code
- * to cleanup, and clear pending MSIx interrupts.
- * Used for fallback to INTx, after reset, and when MSIx setup fails.
- */
-static void qib_7322_nomsix(struct qib_devdata *dd)
+static void qib_7322_free_irq(struct qib_devdata *dd)
 {
 	u64 intgranted;
 	int n;
@@ -2837,30 +2829,23 @@ static void qib_7322_nomsix(struct qib_devdata *dd)
 
 		dd->cspec->num_msix_entries = 0;
 		for (i = 0; i < n; i++) {
-#ifdef CONFIG_INFINIBAND_QIB_DCA
-			reset_dca_notifier(dd, &dd->cspec->msix_entries[i]);
-#endif
-			irq_set_affinity_hint(
-			  dd->cspec->msix_entries[i].msix.vector, NULL);
+			reset_dca_notifier(dd, i);
+			irq_set_affinity_hint(pci_irq_vector(dd->pcidev, i),
+					NULL);
 			free_cpumask_var(dd->cspec->msix_entries[i].mask);
-			free_irq(dd->cspec->msix_entries[i].msix.vector,
-			   dd->cspec->msix_entries[i].arg);
+			pci_free_irq(dd->pcidev, i,
+				 dd->cspec->msix_entries[i].arg);
 		}
-		qib_nomsix(dd);
+	} else {
+		pci_free_irq(dd->pcidev, 0, dd);
 	}
+
 	/* make sure no MSIx interrupts are left pending */
 	intgranted = qib_read_kreg64(dd, kr_intgranted);
 	if (intgranted)
 		qib_write_kreg(dd, kr_intgranted, intgranted);
-}
 
-static void qib_7322_free_irq(struct qib_devdata *dd)
-{
-	if (dd->cspec->irq) {
-		free_irq(dd->cspec->irq, dd);
-		dd->cspec->irq = 0;
-	}
-	qib_7322_nomsix(dd);
+	pci_free_irq_vectors(dd->pcidev);
 }
 
 static void qib_setup_7322_cleanup(struct qib_devdata *dd)
@@ -3328,23 +3313,20 @@ static irqreturn_t sdma_cleanup_intr(int irq, void *data)
 }
 
 #ifdef CONFIG_INFINIBAND_QIB_DCA
-
-static void reset_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
+static void reset_dca_notifier(struct qib_devdata *dd, int vec)
 {
-	if (!m->dca)
+	if (!dd->cspec->msix_entries[vec].dca)
 		return;
 	qib_devinfo(dd->pcidev,
-		"Disabling notifier on HCA %d irq %d\n",
-		dd->unit,
-		m->msix.vector);
-	irq_set_affinity_notifier(
-		m->msix.vector,
-		NULL);
-	m->notifier = NULL;
+		"Disabling notifier on HCA %d vector %d\n",
+		dd->unit, pci_irq_vector(dd->pcidev, vec));
+	irq_set_affinity_notifier(pci_irq_vector(dd->pcidev, vec), NULL);
+	dd->cspec->msix_entries[vec].notifier = NULL;
 }
 
-static void setup_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
+static void setup_dca_notifier(struct qib_devdata *dd, int vec)
 {
+	struct qib_msix_entry *m = &dd->cspec->msix_entries[vec];
 	struct qib_irq_notify *n;
 
 	if (!m->dca)
@@ -3354,7 +3336,7 @@ static void setup_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
 		int ret;
 
 		m->notifier = n;
-		n->notify.irq = m->msix.vector;
+		n->notify.irq = pci_irq_vector(dd->pcidev, vec);
 		n->notify.notify = qib_irq_notifier_notify;
 		n->notify.release = qib_irq_notifier_release;
 		n->arg = m->arg;
@@ -3371,7 +3353,10 @@ static void setup_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
 		}
 	}
 }
-
+#else
+static inline void reset_dca_notifier(struct qib_devdata *dd, int vec)
+{
+}
 #endif
 
 /*
@@ -3415,20 +3400,14 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 	if (!dd->cspec->num_msix_entries) {
 		/* Try to get INTx interrupt */
 try_intx:
-		if (!dd->pcidev->irq) {
-			qib_dev_err(dd,
-				"irq is 0, BIOS error?  Interrupts won't work\n");
-			goto bail;
-		}
-		ret = request_irq(dd->pcidev->irq, qib_7322intr,
-				  IRQF_SHARED, QIB_DRV_NAME, dd);
+		ret = pci_request_irq(dd->pcidev, 0, qib_7322intr, NULL, dd,
+				  QIB_DRV_NAME);
 		if (ret) {
 			qib_dev_err(dd,
 				"Couldn't setup INTx interrupt (irq=%d): %d\n",
 				dd->pcidev->irq, ret);
 			goto bail;
 		}
-		dd->cspec->irq = dd->pcidev->irq;
 		dd->cspec->main_int_mask = ~0ULL;
 		goto bail;
 	}
@@ -3459,9 +3438,6 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 		int dca = 0;
 #endif
 
-		dd->cspec->msix_entries[msixnum].
-			name[sizeof(dd->cspec->msix_entries[msixnum].name) - 1]
-			= '\0';
 		if (i < ARRAY_SIZE(irq_table)) {
 			if (irq_table[i].port) {
 				/* skip if for a non-configured port */
@@ -3475,11 +3451,10 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 #endif
 			lsb = irq_table[i].lsb;
 			handler = irq_table[i].handler;
-			snprintf(dd->cspec->msix_entries[msixnum].name,
-				sizeof(dd->cspec->msix_entries[msixnum].name)
-				 - 1,
-				QIB_DRV_NAME "%d%s", dd->unit,
-				irq_table[i].name);
+
+			ret = pci_request_irq(dd->pcidev, i, handler, NULL, arg,
+					QIB_DRV_NAME "%d%s", dd->unit,
+					irq_table[i].name);
 		} else {
 			unsigned ctxt;
 
@@ -3495,15 +3470,11 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 #endif
 			lsb = QIB_I_RCVAVAIL_LSB + ctxt;
 			handler = qib_7322pintr;
-			snprintf(dd->cspec->msix_entries[msixnum].name,
-				sizeof(dd->cspec->msix_entries[msixnum].name)
-				 - 1,
-				QIB_DRV_NAME "%d (kctx)", dd->unit);
+
+			ret = pci_request_irq(dd->pcidev, i, handler, NULL, arg,
+					QIB_DRV_NAME "%d (kctx)", dd->unit);
 		}
-		ret = request_irq(
-			dd->cspec->msix_entries[msixnum].msix.vector,
-			handler, 0, dd->cspec->msix_entries[msixnum].name,
-			arg);
+
 		if (ret) {
 			/*
 			 * Shouldn't happen since the enable said we could
@@ -3511,10 +3482,9 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 			 */
 			qib_dev_err(dd,
 				"Couldn't setup MSIx interrupt (vec=%d, irq=%d): %d\n",
-				msixnum,
-				dd->cspec->msix_entries[msixnum].msix.vector,
+				msixnum, pci_irq_vector(dd->pcidev, i),
 				ret);
-			qib_7322_nomsix(dd);
+			qib_7322_free_irq(dd);
 			goto try_intx;
 		}
 		dd->cspec->msix_entries[msixnum].arg = arg;
@@ -3547,8 +3517,7 @@ static void qib_setup_7322_interrupt(struct qib_devdata *dd, int clearpend)
 				cpumask_set_cpu(firstcpu,
 					dd->cspec->msix_entries[msixnum].mask);
 			}
-			irq_set_affinity_hint(
-				dd->cspec->msix_entries[msixnum].msix.vector,
+			irq_set_affinity_hint(pci_irq_vector(dd->pcidev, i),
 				dd->cspec->msix_entries[msixnum].mask);
 		}
 		msixnum++;
@@ -3670,7 +3639,7 @@ static int qib_do_7322_reset(struct qib_devdata *dd)
 	qib_7322_set_intr_state(dd, 0);
 
 	if (msix_entries) {
-		qib_7322_nomsix(dd);
+		qib_7322_free_irq(dd);
 		/* can be up to 512 bytes, too big for stack */
 		msix_vecsave = kmalloc(2 * dd->cspec->num_msix_entries *
 			sizeof(u64), GFP_KERNEL);
@@ -3744,7 +3713,6 @@ static int qib_do_7322_reset(struct qib_devdata *dd)
 	if (msix_entries) {
 		/* restore the MSIx vector address and data if saved above */
 		for (i = 0; i < msix_entries; i++) {
-			dd->cspec->msix_entries[i].msix.entry = i;
 			if (!msix_vecsave || !msix_vecsave[2 * i])
 				continue;
 			qib_write_kreg(dd, 2 * i +
@@ -3762,8 +3730,7 @@ static int qib_do_7322_reset(struct qib_devdata *dd)
 	write_7322_initregs(dd);
 
 	if (qib_pcie_params(dd, dd->lbus_width,
-			    &dd->cspec->num_msix_entries,
-			    dd->cspec->msix_entries))
+			    &dd->cspec->num_msix_entries))
 		qib_dev_err(dd,
 			"Reset failed to setup PCIe or interrupts; continuing anyway\n");
 
@@ -5194,8 +5161,9 @@ static int qib_7322_intr_fallback(struct qib_devdata *dd)
 
 	qib_devinfo(dd->pcidev,
 		"MSIx interrupt not detected, trying INTx interrupts\n");
-	qib_7322_nomsix(dd);
-	qib_enable_intx(dd->pcidev);
+	qib_7322_free_irq(dd);
+	if (pci_alloc_irq_vectors(dd->pcidev, 1, 1, PCI_IRQ_LEGACY) < 0)
+		qib_dev_err(dd,	"Failed to enable INTx\n");
 	qib_setup_7322_interrupt(dd, 0);
 	return 1;
 }
@@ -7327,10 +7295,7 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 	if (!dd->cspec->msix_entries)
 		tabsize = 0;
 
-	for (i = 0; i < tabsize; i++)
-		dd->cspec->msix_entries[i].msix.entry = i;
-
-	if (qib_pcie_params(dd, 8, &tabsize, dd->cspec->msix_entries))
+	if (qib_pcie_params(dd, 8, &tabsize))
 		qib_dev_err(dd,
 			"Failed to setup PCIe or interrupts; continuing anyway\n");
 	/* may be less than we wanted, if not enough available */
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index c379b8342a09..c98e0e108c03 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2010 - 2017 Intel Corporation.  All rights reserved.
  * Copyright (c) 2008, 2009 QLogic Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -187,112 +188,68 @@ void qib_pcie_ddcleanup(struct qib_devdata *dd)
 	pci_set_drvdata(dd->pcidev, NULL);
 }
 
-static void qib_msix_setup(struct qib_devdata *dd, int pos, u32 *msixcnt,
-			   struct qib_msix_entry *qib_msix_entry)
-{
-	int ret;
-	int nvec = *msixcnt;
-	struct msix_entry *msix_entry;
-	int i;
-
-	ret = pci_msix_vec_count(dd->pcidev);
-	if (ret < 0)
-		goto do_intx;
-
-	nvec = min(nvec, ret);
-
-	/* We can't pass qib_msix_entry array to qib_msix_setup
-	 * so use a dummy msix_entry array and copy the allocated
-	 * irq back to the qib_msix_entry array. */
-	msix_entry = kcalloc(nvec, sizeof(*msix_entry), GFP_KERNEL);
-	if (!msix_entry)
-		goto do_intx;
-
-	for (i = 0; i < nvec; i++)
-		msix_entry[i] = qib_msix_entry[i].msix;
-
-	ret = pci_enable_msix_range(dd->pcidev, msix_entry, 1, nvec);
-	if (ret < 0)
-		goto free_msix_entry;
-	else
-		nvec = ret;
-
-	for (i = 0; i < nvec; i++)
-		qib_msix_entry[i].msix = msix_entry[i];
-
-	kfree(msix_entry);
-	*msixcnt = nvec;
-	return;
-
-free_msix_entry:
-	kfree(msix_entry);
-
-do_intx:
-	qib_dev_err(
-		dd,
-		"pci_enable_msix_range %d vectors failed: %d, falling back to INTx\n",
-		nvec, ret);
-	*msixcnt = 0;
-	qib_enable_intx(dd->pcidev);
-}
-
 /**
  * We save the msi lo and hi values, so we can restore them after
  * chip reset (the kernel PCI infrastructure doesn't yet handle that
  * correctly.
  */
-static int qib_msi_setup(struct qib_devdata *dd, int pos)
+static void qib_msi_setup(struct qib_devdata *dd, int pos)
 {
 	struct pci_dev *pdev = dd->pcidev;
 	u16 control;
-	int ret;
 
-	ret = pci_enable_msi(pdev);
-	if (ret)
-		qib_dev_err(dd,
-			"pci_enable_msi failed: %d, interrupts may not work\n",
-			ret);
-	/* continue even if it fails, we may still be OK... */
-
-	pci_read_config_dword(pdev, pos + PCI_MSI_ADDRESS_LO,
-			      &dd->msi_lo);
-	pci_read_config_dword(pdev, pos + PCI_MSI_ADDRESS_HI,
-			      &dd->msi_hi);
+	pci_read_config_dword(pdev, pos + PCI_MSI_ADDRESS_LO, &dd->msi_lo);
+	pci_read_config_dword(pdev, pos + PCI_MSI_ADDRESS_HI, &dd->msi_hi);
 	pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &control);
+
 	/* now save the data (vector) info */
-	pci_read_config_word(pdev, pos + ((control & PCI_MSI_FLAGS_64BIT)
-				    ? 12 : 8),
+	pci_read_config_word(pdev,
+			     pos + ((control & PCI_MSI_FLAGS_64BIT) ? 12 : 8),
 			     &dd->msi_data);
-	return ret;
 }
 
-int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent,
-		    struct qib_msix_entry *entry)
+int qib_pcie_params(struct qib_devdata *dd, u32 minw, u32 *nent)
 {
 	u16 linkstat, speed;
-	int pos = 0, ret = 1;
+	int nvec;
+	int maxvec;
+	int ret = 0;
 
 	if (!pci_is_pcie(dd->pcidev)) {
 		qib_dev_err(dd, "Can't find PCI Express capability!\n");
 		/* set up something... */
 		dd->lbus_width = 1;
 		dd->lbus_speed = 2500; /* Gen1, 2.5GHz */
+		ret = -1;
 		goto bail;
 	}
 
-	pos = dd->pcidev->msix_cap;
-	if (nent && *nent && pos) {
-		qib_msix_setup(dd, pos, nent, entry);
-		ret = 0; /* did it, either MSIx or INTx */
-	} else {
-		pos = dd->pcidev->msi_cap;
-		if (pos)
-			ret = qib_msi_setup(dd, pos);
-		else
-			qib_dev_err(dd, "No PCI MSI or MSIx capability!\n");
+	maxvec = (nent && *nent) ? *nent : 1;
+	nvec = pci_alloc_irq_vectors(dd->pcidev, 1, maxvec,
+			PCI_IRQ_LEGACY | PCI_IRQ_MSIX | PCI_IRQ_MSI);
+	if (nvec < 0) {
+		ret = nvec;
+		goto bail;
+	}
+
+	if (dd->pcidev->msi_enabled)
+		/* Get msi_lo and msi_hi */
+		qib_msi_setup(dd, dd->pcidev->msi_cap);
+
+	/*
+	 * If nent exists, make sure to record how many vectors were allocated
+	 */
+	if (nent) {
+		*nent = nvec;
+
+		/*
+		 * If we requested (nent) MSIX, but msix_enabled is not set,
+		 * pci_alloc_irq_vectors() enabled INTx.
+		 */
+		if (!dd->pcidev->msix_enabled)
+			qib_dev_err(dd,
+				    "no msix vectors allocated, using INTx\n");
 	}
-	if (!pos)
-		qib_enable_intx(dd->pcidev);
 
 	pcie_capability_read_word(dd->pcidev, PCI_EXP_LNKSTA, &linkstat);
 	/*
@@ -348,7 +305,6 @@ int qib_reinit_intr(struct qib_devdata *dd)
 {
 	int pos;
 	u16 control;
-	int ret = 0;
 
 	/* If we aren't using MSI, don't restore it */
 	if (!dd->msi_lo)
@@ -358,7 +314,6 @@ int qib_reinit_intr(struct qib_devdata *dd)
 	if (!pos) {
 		qib_dev_err(dd,
 			"Can't find MSI capability, can't restore MSI settings\n");
-		ret = 0;
 		/* nothing special for MSIx, just MSI */
 		goto bail;
 	}
@@ -376,69 +331,20 @@ int qib_reinit_intr(struct qib_devdata *dd)
 	pci_write_config_word(dd->pcidev, pos +
 			      ((control & PCI_MSI_FLAGS_64BIT) ? 12 : 8),
 			      dd->msi_data);
-	ret = 1;
-bail:
-	if (!ret && (dd->flags & QIB_HAS_INTX)) {
-		qib_enable_intx(dd->pcidev);
-		ret = 1;
-	}
 
+done:
 	/* and now set the pci master bit again */
 	pci_set_master(dd->pcidev);
-
-	return ret;
-}
-
-/*
- * Disable msi interrupt if enabled, and clear msi_lo.
- * This is used primarily for the fallback to INTx, but
- * is also used in reinit after reset, and during cleanup.
- */
-void qib_nomsi(struct qib_devdata *dd)
-{
-	dd->msi_lo = 0;
-	pci_disable_msi(dd->pcidev);
-}
-
-/*
- * Same as qib_nosmi, but for MSIx.
- */
-void qib_nomsix(struct qib_devdata *dd)
-{
-	pci_disable_msix(dd->pcidev);
-}
-
-/*
- * Similar to pci_intx(pdev, 1), except that we make sure
- * msi(x) is off.
- */
-void qib_enable_intx(struct pci_dev *pdev)
-{
-	u16 cw, new;
-	int pos;
-
-	/* first, turn on INTx */
-	pci_read_config_word(pdev, PCI_COMMAND, &cw);
-	new = cw & ~PCI_COMMAND_INTX_DISABLE;
-	if (new != cw)
-		pci_write_config_word(pdev, PCI_COMMAND, new);
-
-	pos = pdev->msi_cap;
-	if (pos) {
-		/* then turn off MSI */
-		pci_read_config_word(pdev, pos + PCI_MSI_FLAGS, &cw);
-		new = cw & ~PCI_MSI_FLAGS_ENABLE;
-		if (new != cw)
-			pci_write_config_word(pdev, pos + PCI_MSI_FLAGS, new);
-	}
-	pos = pdev->msix_cap;
-	if (pos) {
-		/* then turn off MSIx */
-		pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &cw);
-		new = cw & ~PCI_MSIX_FLAGS_ENABLE;
-		if (new != cw)
-			pci_write_config_word(pdev, pos + PCI_MSIX_FLAGS, new);
+	return 1;
+bail:
+	if (dd->flags & QIB_HAS_INTX) {
+		pci_free_irq_vectors(dd->pcidev);
+		if (pci_alloc_irq_vectors(dd->pcidev, 1, 1, PCI_IRQ_LEGACY) < 0)
+			qib_dev_err(dd,	"Failed to enable INTx\n");
+		goto done;
 	}
+
+	return 0;
 }
 
 /*
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
