From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: add DCA support
Date: Mon, 13 May 2013 12:53:51 -0400
Message-ID: <20130513165351.23161.74325.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds the DCA cache warming for systems that support
DCA.

The code uses cpu affinity notification to react to an
affinity change from a user mode program like irqbalance
and (re-)program the chip accordingly. This notifcation avoids
reading the current cpu on every interrupt.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Kconfig       |    9 +
 drivers/infiniband/hw/qib/qib.h         |   17 ++
 drivers/infiniband/hw/qib/qib_iba6120.c |   10 +
 drivers/infiniband/hw/qib/qib_iba7220.c |   10 +
 drivers/infiniband/hw/qib/qib_iba7322.c |  325 ++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/qib/qib_init.c    |   38 ++++
 6 files changed, 397 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
index 1e603a3..accf9f8 100644
--- a/drivers/infiniband/hw/qib/Kconfig
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -5,3 +5,12 @@ config INFINIBAND_QIB
 	This is a low-level driver for Intel PCIe QLE InfiniBand host
 	channel adapters.  This driver does not support the Intel
 	HyperTransport card (model QHT7140).
+
+config INFINIBAND_QIB_DCA
+	bool "QIB DCA support"
+	depends on DCA && INFINIBAND_QIB
+	default y
+	---help---
+	Setting this enables DCA support on some Intel chip sets
+	with the iba7322 HCA.
+
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 4d11575..5643ce4 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -428,9 +428,23 @@ struct qib_verbs_txreq {
 #define ACTIVITY_TIMER 5
 
 #define MAX_NAME_SIZE 64
+
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+struct qib_irq_notify {
+	int rcv;
+	void *arg;
+	struct irq_affinity_notify notify;
+};
+#endif
+
 struct qib_msix_entry {
 	struct msix_entry msix;
 	void *arg;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	int dca;
+	int rcv;
+	struct qib_irq_notify *notifier;
+#endif
 	char name[MAX_NAME_SIZE];
 	cpumask_var_t mask;
 };
@@ -828,6 +842,9 @@ struct qib_devdata {
 		struct qib_ctxtdata *);
 	void (*f_writescratch)(struct qib_devdata *, u32);
 	int (*f_tempsense_rd)(struct qib_devdata *, int regnum);
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	int (*f_notify_dca)(struct qib_devdata *, unsigned long event);
+#endif
 
 	char *boardname; /* human readable board info */
 
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 0232ae5..84e593d 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -3464,6 +3464,13 @@ static int qib_6120_tempsense_rd(struct qib_devdata *dd, int regnum)
 	return -ENXIO;
 }
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+static int qib_6120_notify_dca(struct qib_devdata *dd, unsigned long event)
+{
+	return 0;
+}
+#endif
+
 /* Dummy function, as 6120 boards never disable EEPROM Write */
 static int qib_6120_eeprom_wen(struct qib_devdata *dd, int wen)
 {
@@ -3539,6 +3546,9 @@ struct qib_devdata *qib_init_iba6120_funcs(struct pci_dev *pdev,
 	dd->f_xgxs_reset        = qib_6120_xgxs_reset;
 	dd->f_writescratch      = writescratch;
 	dd->f_tempsense_rd	= qib_6120_tempsense_rd;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	dd->f_notify_dca = qib_6120_notify_dca;
+#endif
 	/*
 	 * Do remaining pcie setup and save pcie values in dd.
 	 * Any error printing is already done by the init code.
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 64d0ecb..454c2e7 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -4513,6 +4513,13 @@ bail:
 	return ret;
 }
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+static int qib_7220_notify_dca(struct qib_devdata *dd, unsigned long event)
+{
+	return 0;
+}
+#endif
+
 /* Dummy function, as 7220 boards never disable EEPROM Write */
 static int qib_7220_eeprom_wen(struct qib_devdata *dd, int wen)
 {
@@ -4587,6 +4594,9 @@ struct qib_devdata *qib_init_iba7220_funcs(struct pci_dev *pdev,
 	dd->f_xgxs_reset        = qib_7220_xgxs_reset;
 	dd->f_writescratch      = writescratch;
 	dd->f_tempsense_rd	= qib_7220_tempsense_rd;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	dd->f_notify_dca = qib_7220_notify_dca;
+#endif
 	/*
 	 * Do remaining pcie setup and save pcie values in dd.
 	 * Any error printing is already done by the init code.
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 3f6b21e..be67f09 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -44,6 +44,9 @@
 #include <linux/module.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_smi.h>
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+#include <linux/dca.h>
+#endif
 
 #include "qib.h"
 #include "qib_7322_regs.h"
@@ -546,6 +549,12 @@ struct qib_chip_specific {
 	u32 lastbuf_for_pio;
 	u32 stay_in_freeze;
 	u32 recovery_ports_initted;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	u32 dca_ctrl;
+	int rhdr_cpu[18];
+	int sdma_cpu[2];
+	u64 dca_rcvhdr_ctrl[5]; /* B, C, D, E, F */
+#endif
 	struct qib_msix_entry *msix_entries;
 	unsigned long *sendchkenable;
 	unsigned long *sendgrhchk;
@@ -642,28 +651,76 @@ static struct {
 	irq_handler_t handler;
 	int lsb;
 	int port; /* 0 if not port-specific, else port # */
+	int dca;
 } irq_table[] = {
-	{ "", qib_7322intr, -1, 0 },
+	{ "", qib_7322intr, -1, 0, 0 },
 	{ " (buf avail)", qib_7322bufavail,
-		SYM_LSB(IntStatus, SendBufAvail), 0 },
+		SYM_LSB(IntStatus, SendBufAvail), 0, 0},
 	{ " (sdma 0)", sdma_intr,
-		SYM_LSB(IntStatus, SDmaInt_0), 1 },
+		SYM_LSB(IntStatus, SDmaInt_0), 1, 1 },
 	{ " (sdma 1)", sdma_intr,
-		SYM_LSB(IntStatus, SDmaInt_1), 2 },
+		SYM_LSB(IntStatus, SDmaInt_1), 2, 1 },
 	{ " (sdmaI 0)", sdma_idle_intr,
-		SYM_LSB(IntStatus, SDmaIdleInt_0), 1 },
+		SYM_LSB(IntStatus, SDmaIdleInt_0), 1, 1},
 	{ " (sdmaI 1)", sdma_idle_intr,
-		SYM_LSB(IntStatus, SDmaIdleInt_1), 2 },
+		SYM_LSB(IntStatus, SDmaIdleInt_1), 2, 1},
 	{ " (sdmaP 0)", sdma_progress_intr,
-		SYM_LSB(IntStatus, SDmaProgressInt_0), 1 },
+		SYM_LSB(IntStatus, SDmaProgressInt_0), 1, 1 },
 	{ " (sdmaP 1)", sdma_progress_intr,
-		SYM_LSB(IntStatus, SDmaProgressInt_1), 2 },
+		SYM_LSB(IntStatus, SDmaProgressInt_1), 2, 1 },
 	{ " (sdmaC 0)", sdma_cleanup_intr,
-		SYM_LSB(IntStatus, SDmaCleanupDone_0), 1 },
+		SYM_LSB(IntStatus, SDmaCleanupDone_0), 1, 0 },
 	{ " (sdmaC 1)", sdma_cleanup_intr,
-		SYM_LSB(IntStatus, SDmaCleanupDone_1), 2 },
+		SYM_LSB(IntStatus, SDmaCleanupDone_1), 2 , 0},
 };
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+
+static const struct dca_reg_map {
+	int     shadow_inx;
+	int     lsb;
+	u64     mask;
+	u16     regno;
+} dca_rcvhdr_reg_map[] = {
+	{ 0, SYM_LSB(DCACtrlB, RcvHdrq0DCAOPH),
+	   ~SYM_MASK(DCACtrlB, RcvHdrq0DCAOPH) , KREG_IDX(DCACtrlB) },
+	{ 0, SYM_LSB(DCACtrlB, RcvHdrq1DCAOPH),
+	   ~SYM_MASK(DCACtrlB, RcvHdrq1DCAOPH) , KREG_IDX(DCACtrlB) },
+	{ 0, SYM_LSB(DCACtrlB, RcvHdrq2DCAOPH),
+	   ~SYM_MASK(DCACtrlB, RcvHdrq2DCAOPH) , KREG_IDX(DCACtrlB) },
+	{ 0, SYM_LSB(DCACtrlB, RcvHdrq3DCAOPH),
+	   ~SYM_MASK(DCACtrlB, RcvHdrq3DCAOPH) , KREG_IDX(DCACtrlB) },
+	{ 1, SYM_LSB(DCACtrlC, RcvHdrq4DCAOPH),
+	   ~SYM_MASK(DCACtrlC, RcvHdrq4DCAOPH) , KREG_IDX(DCACtrlC) },
+	{ 1, SYM_LSB(DCACtrlC, RcvHdrq5DCAOPH),
+	   ~SYM_MASK(DCACtrlC, RcvHdrq5DCAOPH) , KREG_IDX(DCACtrlC) },
+	{ 1, SYM_LSB(DCACtrlC, RcvHdrq6DCAOPH),
+	   ~SYM_MASK(DCACtrlC, RcvHdrq6DCAOPH) , KREG_IDX(DCACtrlC) },
+	{ 1, SYM_LSB(DCACtrlC, RcvHdrq7DCAOPH),
+	   ~SYM_MASK(DCACtrlC, RcvHdrq7DCAOPH) , KREG_IDX(DCACtrlC) },
+	{ 2, SYM_LSB(DCACtrlD, RcvHdrq8DCAOPH),
+	   ~SYM_MASK(DCACtrlD, RcvHdrq8DCAOPH) , KREG_IDX(DCACtrlD) },
+	{ 2, SYM_LSB(DCACtrlD, RcvHdrq9DCAOPH),
+	   ~SYM_MASK(DCACtrlD, RcvHdrq9DCAOPH) , KREG_IDX(DCACtrlD) },
+	{ 2, SYM_LSB(DCACtrlD, RcvHdrq10DCAOPH),
+	   ~SYM_MASK(DCACtrlD, RcvHdrq10DCAOPH) , KREG_IDX(DCACtrlD) },
+	{ 2, SYM_LSB(DCACtrlD, RcvHdrq11DCAOPH),
+	   ~SYM_MASK(DCACtrlD, RcvHdrq11DCAOPH) , KREG_IDX(DCACtrlD) },
+	{ 3, SYM_LSB(DCACtrlE, RcvHdrq12DCAOPH),
+	   ~SYM_MASK(DCACtrlE, RcvHdrq12DCAOPH) , KREG_IDX(DCACtrlE) },
+	{ 3, SYM_LSB(DCACtrlE, RcvHdrq13DCAOPH),
+	   ~SYM_MASK(DCACtrlE, RcvHdrq13DCAOPH) , KREG_IDX(DCACtrlE) },
+	{ 3, SYM_LSB(DCACtrlE, RcvHdrq14DCAOPH),
+	   ~SYM_MASK(DCACtrlE, RcvHdrq14DCAOPH) , KREG_IDX(DCACtrlE) },
+	{ 3, SYM_LSB(DCACtrlE, RcvHdrq15DCAOPH),
+	   ~SYM_MASK(DCACtrlE, RcvHdrq15DCAOPH) , KREG_IDX(DCACtrlE) },
+	{ 4, SYM_LSB(DCACtrlF, RcvHdrq16DCAOPH),
+	   ~SYM_MASK(DCACtrlF, RcvHdrq16DCAOPH) , KREG_IDX(DCACtrlF) },
+	{ 4, SYM_LSB(DCACtrlF, RcvHdrq17DCAOPH),
+	   ~SYM_MASK(DCACtrlF, RcvHdrq17DCAOPH) , KREG_IDX(DCACtrlF) },
+};
+#endif
+
 /* ibcctrl bits */
 #define QLOGIC_IB_IBCC_LINKINITCMD_DISABLE 1
 /* cycle through TS1/TS2 till OK */
@@ -686,6 +743,13 @@ static void write_7322_init_portregs(struct qib_pportdata *);
 static void setup_7322_link_recovery(struct qib_pportdata *, u32);
 static void check_7322_rxe_status(struct qib_pportdata *);
 static u32 __iomem *qib_7322_getsendbuf(struct qib_pportdata *, u64, u32 *);
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+static void qib_setup_dca(struct qib_devdata *dd);
+static void setup_dca_notifier(struct qib_devdata *dd,
+			       struct qib_msix_entry *m);
+static void reset_dca_notifier(struct qib_devdata *dd,
+			       struct qib_msix_entry *m);
+#endif
 
 /**
  * qib_read_ureg32 - read 32-bit virtualized per-context register
@@ -2558,6 +2622,161 @@ static void qib_setup_7322_setextled(struct qib_pportdata *ppd, u32 on)
 		qib_write_kreg_port(ppd, krp_rcvpktledcnt, ledblink);
 }
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+
+static int qib_7322_notify_dca(struct qib_devdata *dd, unsigned long event)
+{
+	switch (event) {
+	case DCA_PROVIDER_ADD:
+		if (dd->flags & QIB_DCA_ENABLED)
+			break;
+		if (!dca_add_requester(&dd->pcidev->dev)) {
+			qib_devinfo(dd->pcidev, "DCA enabled\n");
+			dd->flags |= QIB_DCA_ENABLED;
+			qib_setup_dca(dd);
+		}
+		break;
+	case DCA_PROVIDER_REMOVE:
+		if (dd->flags & QIB_DCA_ENABLED) {
+			dca_remove_requester(&dd->pcidev->dev);
+			dd->flags &= ~QIB_DCA_ENABLED;
+			dd->cspec->dca_ctrl = 0;
+			qib_write_kreg(dd, KREG_IDX(DCACtrlA), dd->cspec->dca_ctrl);
+		}
+		break;
+	}
+	return 0;
+}
+
+static void qib_update_rhdrq_dca(struct qib_ctxtdata *rcd, int cpu)
+{
+	struct qib_devdata *dd = rcd->dd;
+	struct qib_chip_specific *cspec = dd->cspec;
+
+	if (!(dd->flags & QIB_DCA_ENABLED))
+		return;
+	if (cspec->rhdr_cpu[rcd->ctxt] != cpu) {
+		const struct dca_reg_map *rmp;
+
+		cspec->rhdr_cpu[rcd->ctxt] = cpu;
+		rmp = &dca_rcvhdr_reg_map[rcd->ctxt];
+		cspec->dca_rcvhdr_ctrl[rmp->shadow_inx] &= rmp->mask;
+		cspec->dca_rcvhdr_ctrl[rmp->shadow_inx] |=
+			(u64) dca3_get_tag(&dd->pcidev->dev, cpu) << rmp->lsb;
+		qib_devinfo(dd->pcidev,
+			"Ctxt %d cpu %d dca %llx\n", rcd->ctxt, cpu,
+			(long long) cspec->dca_rcvhdr_ctrl[rmp->shadow_inx]);
+		qib_write_kreg(dd, rmp->regno,
+			       cspec->dca_rcvhdr_ctrl[rmp->shadow_inx]);
+		cspec->dca_ctrl |= SYM_MASK(DCACtrlA, RcvHdrqDCAEnable);
+		qib_write_kreg(dd, KREG_IDX(DCACtrlA), cspec->dca_ctrl);
+	}
+}
+
+static void qib_update_sdma_dca(struct qib_pportdata *ppd, int cpu)
+{
+	struct qib_devdata *dd = ppd->dd;
+	struct qib_chip_specific *cspec = dd->cspec;
+	unsigned pidx = ppd->port - 1;
+
+	if (!(dd->flags & QIB_DCA_ENABLED))
+		return;
+	if (cspec->sdma_cpu[pidx] != cpu) {
+		cspec->sdma_cpu[pidx] = cpu;
+		cspec->dca_rcvhdr_ctrl[4] &= ~(ppd->hw_pidx ?
+			SYM_MASK(DCACtrlF, SendDma1DCAOPH) :
+			SYM_MASK(DCACtrlF, SendDma0DCAOPH));
+		cspec->dca_rcvhdr_ctrl[4] |=
+			(u64) dca3_get_tag(&dd->pcidev->dev, cpu) <<
+				(ppd->hw_pidx ?
+					SYM_LSB(DCACtrlF, SendDma1DCAOPH) :
+					SYM_LSB(DCACtrlF, SendDma0DCAOPH));
+		qib_devinfo(dd->pcidev,
+			"sdma %d cpu %d dca %llx\n", ppd->hw_pidx, cpu,
+			(long long) cspec->dca_rcvhdr_ctrl[4]);
+		qib_write_kreg(dd, KREG_IDX(DCACtrlF),
+			       cspec->dca_rcvhdr_ctrl[4]);
+		cspec->dca_ctrl |= ppd->hw_pidx ?
+			SYM_MASK(DCACtrlA, SendDMAHead1DCAEnable) :
+			SYM_MASK(DCACtrlA, SendDMAHead0DCAEnable);
+		qib_write_kreg(dd, KREG_IDX(DCACtrlA), cspec->dca_ctrl);
+	}
+}
+
+static void qib_setup_dca(struct qib_devdata *dd)
+{
+	struct qib_chip_specific *cspec = dd->cspec;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cspec->rhdr_cpu); i++)
+		cspec->rhdr_cpu[i] = -1;
+	for (i = 0; i < ARRAY_SIZE(cspec->sdma_cpu); i++)
+		cspec->sdma_cpu[i] = -1;
+	cspec->dca_rcvhdr_ctrl[0] =
+		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq0DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq1DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq2DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq3DCAXfrCnt));
+	cspec->dca_rcvhdr_ctrl[1] =
+		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq4DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq5DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq6DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq7DCAXfrCnt));
+	cspec->dca_rcvhdr_ctrl[2] =
+		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq8DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq9DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq10DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq11DCAXfrCnt));
+	cspec->dca_rcvhdr_ctrl[3] =
+		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq12DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq13DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq14DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq15DCAXfrCnt));
+	cspec->dca_rcvhdr_ctrl[4] =
+		(1ULL << SYM_LSB(DCACtrlF, RcvHdrq16DCAXfrCnt)) |
+		(1ULL << SYM_LSB(DCACtrlF, RcvHdrq17DCAXfrCnt));
+	for (i = 0; i < ARRAY_SIZE(cspec->sdma_cpu); i++)
+		qib_write_kreg(dd, KREG_IDX(DCACtrlB) + i,
+			       cspec->dca_rcvhdr_ctrl[i]);
+	for (i = 0; i < cspec->num_msix_entries; i++)
+		setup_dca_notifier(dd, &cspec->msix_entries[i]);
+}
+
+void qib_irq_notifier_notify(struct irq_affinity_notify *notify,
+			     const cpumask_t *mask)
+{
+	struct qib_irq_notify *n =
+		container_of(notify, struct qib_irq_notify, notify);
+	int cpu = cpumask_first(mask);
+
+	if (n->rcv) {
+		struct qib_ctxtdata *rcd = (struct qib_ctxtdata *)n->arg;
+		qib_update_rhdrq_dca(rcd, cpu);
+	} else {
+		struct qib_pportdata *ppd = (struct qib_pportdata *)n->arg;
+		qib_update_sdma_dca(ppd, cpu);
+	}
+}
+
+void qib_irq_notifier_release(struct kref *ref)
+{
+	struct qib_irq_notify *n =
+		container_of(ref, struct qib_irq_notify, notify.kref);
+	struct qib_devdata *dd;
+
+	if (n->rcv) {
+		struct qib_ctxtdata *rcd = (struct qib_ctxtdata *)n->arg;
+		dd = rcd->dd;
+	} else {
+		struct qib_pportdata *ppd = (struct qib_pportdata *)n->arg;
+		dd = ppd->dd;
+	}
+	qib_devinfo(dd->pcidev,
+		"release on HCA notify 0x%p n 0x%p\n", ref, n);
+	kfree(n);
+}
+#endif
+
 /*
  * Disable MSIx interrupt if enabled, call generic MSIx code
  * to cleanup, and clear pending MSIx interrupts.
@@ -2575,6 +2794,9 @@ static void qib_7322_nomsix(struct qib_devdata *dd)
 
 		dd->cspec->num_msix_entries = 0;
 		for (i = 0; i < n; i++) {
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+			reset_dca_notifier(dd, &dd->cspec->msix_entries[i]);
+#endif
 			irq_set_affinity_hint(
 			  dd->cspec->msix_entries[i].msix.vector, NULL);
 			free_cpumask_var(dd->cspec->msix_entries[i].mask);
@@ -2602,6 +2824,15 @@ static void qib_setup_7322_cleanup(struct qib_devdata *dd)
 {
 	int i;
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	if (dd->flags & QIB_DCA_ENABLED) {
+		dca_remove_requester(&dd->pcidev->dev);
+		dd->flags &= ~QIB_DCA_ENABLED;
+		dd->cspec->dca_ctrl = 0;
+		qib_write_kreg(dd, KREG_IDX(DCACtrlA), dd->cspec->dca_ctrl);
+	}
+#endif
+
 	qib_7322_free_irq(dd);
 	kfree(dd->cspec->cntrs);
 	kfree(dd->cspec->sendchkenable);
@@ -3068,6 +3299,53 @@ static irqreturn_t sdma_cleanup_intr(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+
+static void reset_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
+{
+	if (!m->dca)
+		return;
+	qib_devinfo(dd->pcidev,
+		"Disabling notifier on HCA %d irq %d\n",
+		dd->unit,
+		m->msix.vector);
+	irq_set_affinity_notifier(
+		m->msix.vector,
+		NULL);
+	m->notifier = NULL;
+}
+
+static void setup_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
+{
+	struct qib_irq_notify *n;
+
+	if (!m->dca)
+		return;
+	n = kzalloc(sizeof(*n), GFP_KERNEL);
+	if (n) {
+		int ret;
+
+		m->notifier = n;
+		n->notify.irq = m->msix.vector;
+		n->notify.notify = qib_irq_notifier_notify;
+		n->notify.release = qib_irq_notifier_release;
+		n->arg = m->arg;
+		n->rcv = m->rcv;
+		qib_devinfo(dd->pcidev,
+			"set notifier irq %d rcv %d notify %p\n",
+			n->notify.irq, n->rcv, &n->notify);
+		ret = irq_set_affinity_notifier(
+				n->notify.irq,
+				&n->notify);
+		if (ret) {
+			m->notifier = NULL;
+			kfree(n);
+		}
+	}
+}
+
+#endif
+
 /*
  * Set up our chip-specific interrupt handler.
  * The interrupt type has already been setup, so
@@ -3149,6 +3427,9 @@ try_intx:
 		void *arg;
 		u64 val;
 		int lsb, reg, sh;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+		int dca = 0;
+#endif
 
 		dd->cspec->msix_entries[msixnum].
 			name[sizeof(dd->cspec->msix_entries[msixnum].name) - 1]
@@ -3161,6 +3442,9 @@ try_intx:
 				arg = dd->pport + irq_table[i].port - 1;
 			} else
 				arg = dd;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+			dca = irq_table[i].dca;
+#endif
 			lsb = irq_table[i].lsb;
 			handler = irq_table[i].handler;
 			snprintf(dd->cspec->msix_entries[msixnum].name,
@@ -3178,6 +3462,9 @@ try_intx:
 				continue;
 			if (qib_krcvq01_no_msi && ctxt < 2)
 				continue;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+			dca = 1;
+#endif
 			lsb = QIB_I_RCVAVAIL_LSB + ctxt;
 			handler = qib_7322pintr;
 			snprintf(dd->cspec->msix_entries[msixnum].name,
@@ -3203,6 +3490,11 @@ try_intx:
 			goto try_intx;
 		}
 		dd->cspec->msix_entries[msixnum].arg = arg;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+		dd->cspec->msix_entries[msixnum].dca = dca;
+		dd->cspec->msix_entries[msixnum].rcv =
+			handler == qib_7322pintr;
+#endif
 		if (lsb >= 0) {
 			reg = lsb / IBA7322_REDIRECT_VEC_PER_REG;
 			sh = (lsb % IBA7322_REDIRECT_VEC_PER_REG) *
@@ -6885,6 +7177,9 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 	dd->f_sdma_init_early   = qib_7322_sdma_init_early;
 	dd->f_writescratch      = writescratch;
 	dd->f_tempsense_rd	= qib_7322_tempsense_rd;
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	dd->f_notify_dca	= qib_7322_notify_dca;
+#endif
 	/*
 	 * Do remaining PCIe setup and save PCIe values in dd.
 	 * Any error printing is already done by the init code.
@@ -6921,7 +7216,7 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 		actual_cnt -= dd->num_pports;
 
 	tabsize = actual_cnt;
-	dd->cspec->msix_entries = kmalloc(tabsize *
+	dd->cspec->msix_entries = kzalloc(tabsize *
 			sizeof(struct qib_msix_entry), GFP_KERNEL);
 	if (!dd->cspec->msix_entries) {
 		qib_dev_err(dd, "No memory for MSIx table\n");
@@ -6941,7 +7236,13 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 
 	/* clear diagctrl register, in case diags were running and crashed */
 	qib_write_kreg(dd, kr_hwdiagctrl, 0);
-
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	if (!dca_add_requester(&pdev->dev)) {
+		qib_devinfo(dd->pcidev, "DCA enabled\n");
+		dd->flags |= QIB_DCA_ENABLED;
+		qib_setup_dca(dd);
+	}
+#endif
 	goto bail;
 
 bail_cleanup:
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 173f805..6176dfa 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -39,6 +39,9 @@
 #include <linux/idr.h>
 #include <linux/module.h>
 #include <linux/printk.h>
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+#include <linux/dca.h>
+#endif
 
 #include "qib.h"
 #include "qib_common.h"
@@ -1158,6 +1161,35 @@ struct pci_driver qib_driver = {
 	.err_handler = &qib_pci_err_handler,
 };
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+
+static int qib_notify_dca(struct notifier_block *, unsigned long, void *);
+static struct notifier_block dca_notifier = {
+	.notifier_call  = qib_notify_dca,
+	.next           = NULL,
+	.priority       = 0
+};
+
+static int qib_notify_dca_device(struct device *device, void *data)
+{
+	struct qib_devdata *dd = dev_get_drvdata(device);
+	unsigned long event = *(unsigned long *)data;
+
+	return dd->f_notify_dca(dd, event);
+}
+
+static int qib_notify_dca(struct notifier_block *nb, unsigned long event,
+					  void *p)
+{
+	int rval;
+
+	rval = driver_for_each_device(&qib_driver.driver, NULL,
+				      &event, qib_notify_dca_device);
+	return rval ? NOTIFY_BAD : NOTIFY_DONE;
+}
+
+#endif
+
 /*
  * Do all the generic driver unit- and chip-independent memory
  * allocation and initialization.
@@ -1182,6 +1214,9 @@ static int __init qlogic_ib_init(void)
 	 */
 	idr_init(&qib_unit_table);
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	dca_register_notify(&dca_notifier);
+#endif
 	ret = pci_register_driver(&qib_driver);
 	if (ret < 0) {
 		pr_err("Unable to register driver: error %d\n", -ret);
@@ -1217,6 +1252,9 @@ static void __exit qlogic_ib_cleanup(void)
 			"Unable to cleanup counter filesystem: error %d\n",
 			-ret);
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+	dca_unregister_notify(&dca_notifier);
+#endif
 	pci_unregister_driver(&qib_driver);
 
 	destroy_workqueue(qib_cq_wq);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
