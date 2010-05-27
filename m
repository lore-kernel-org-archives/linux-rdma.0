From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: remove DCA support until feature is finished
Date: Thu, 27 May 2010 10:59:10 -0700
Message-ID: <20100527175910.3248.62775.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The DCA code was left over from internal development to test
the hardware feature and allow performance testing.
The results were mixed and will require some additional work
to make full use of the feature. Therefore, it is being removed
for now.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_iba7322.c |  189 -------------------------------
 1 files changed, 0 insertions(+), 189 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 23fb9ef..503992d 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -42,9 +42,6 @@
 #include <linux/jiffies.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_smi.h>
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-#include <linux/dca.h>
-#endif
 
 #include "qib.h"
 #include "qib_7322_regs.h"
@@ -518,12 +515,6 @@ struct qib_chip_specific {
 	u32 lastbuf_for_pio;
 	u32 stay_in_freeze;
 	u32 recovery_ports_initted;
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	u32 dca_ctrl;
-	int rhdr_cpu[18];
-	int sdma_cpu[2];
-	u64 dca_rcvhdr_ctrl[5]; /* B, C, D, E, F */
-#endif
 	struct msix_entry *msix_entries;
 	void  **msix_arg;
 	unsigned long *sendchkenable;
@@ -642,52 +633,6 @@ static struct {
 		SYM_LSB(IntStatus, SDmaCleanupDone_1), 2 },
 };
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-static const struct dca_reg_map {
-	int     shadow_inx;
-	int     lsb;
-	u64     mask;
-	u16     regno;
-} dca_rcvhdr_reg_map[] = {
-	{ 0, SYM_LSB(DCACtrlB, RcvHdrq0DCAOPH),
-	   ~SYM_MASK(DCACtrlB, RcvHdrq0DCAOPH) , KREG_IDX(DCACtrlB) },
-	{ 0, SYM_LSB(DCACtrlB, RcvHdrq1DCAOPH),
-	   ~SYM_MASK(DCACtrlB, RcvHdrq1DCAOPH) , KREG_IDX(DCACtrlB) },
-	{ 0, SYM_LSB(DCACtrlB, RcvHdrq2DCAOPH),
-	   ~SYM_MASK(DCACtrlB, RcvHdrq2DCAOPH) , KREG_IDX(DCACtrlB) },
-	{ 0, SYM_LSB(DCACtrlB, RcvHdrq3DCAOPH),
-	   ~SYM_MASK(DCACtrlB, RcvHdrq3DCAOPH) , KREG_IDX(DCACtrlB) },
-	{ 1, SYM_LSB(DCACtrlC, RcvHdrq4DCAOPH),
-	   ~SYM_MASK(DCACtrlC, RcvHdrq4DCAOPH) , KREG_IDX(DCACtrlC) },
-	{ 1, SYM_LSB(DCACtrlC, RcvHdrq5DCAOPH),
-	   ~SYM_MASK(DCACtrlC, RcvHdrq5DCAOPH) , KREG_IDX(DCACtrlC) },
-	{ 1, SYM_LSB(DCACtrlC, RcvHdrq6DCAOPH),
-	   ~SYM_MASK(DCACtrlC, RcvHdrq6DCAOPH) , KREG_IDX(DCACtrlC) },
-	{ 1, SYM_LSB(DCACtrlC, RcvHdrq7DCAOPH),
-	   ~SYM_MASK(DCACtrlC, RcvHdrq7DCAOPH) , KREG_IDX(DCACtrlC) },
-	{ 2, SYM_LSB(DCACtrlD, RcvHdrq8DCAOPH),
-	   ~SYM_MASK(DCACtrlD, RcvHdrq8DCAOPH) , KREG_IDX(DCACtrlD) },
-	{ 2, SYM_LSB(DCACtrlD, RcvHdrq9DCAOPH),
-	   ~SYM_MASK(DCACtrlD, RcvHdrq9DCAOPH) , KREG_IDX(DCACtrlD) },
-	{ 2, SYM_LSB(DCACtrlD, RcvHdrq10DCAOPH),
-	   ~SYM_MASK(DCACtrlD, RcvHdrq10DCAOPH) , KREG_IDX(DCACtrlD) },
-	{ 2, SYM_LSB(DCACtrlD, RcvHdrq11DCAOPH),
-	   ~SYM_MASK(DCACtrlD, RcvHdrq11DCAOPH) , KREG_IDX(DCACtrlD) },
-	{ 3, SYM_LSB(DCACtrlE, RcvHdrq12DCAOPH),
-	   ~SYM_MASK(DCACtrlE, RcvHdrq12DCAOPH) , KREG_IDX(DCACtrlE) },
-	{ 3, SYM_LSB(DCACtrlE, RcvHdrq13DCAOPH),
-	   ~SYM_MASK(DCACtrlE, RcvHdrq13DCAOPH) , KREG_IDX(DCACtrlE) },
-	{ 3, SYM_LSB(DCACtrlE, RcvHdrq14DCAOPH),
-	   ~SYM_MASK(DCACtrlE, RcvHdrq14DCAOPH) , KREG_IDX(DCACtrlE) },
-	{ 3, SYM_LSB(DCACtrlE, RcvHdrq15DCAOPH),
-	   ~SYM_MASK(DCACtrlE, RcvHdrq15DCAOPH) , KREG_IDX(DCACtrlE) },
-	{ 4, SYM_LSB(DCACtrlF, RcvHdrq16DCAOPH),
-	   ~SYM_MASK(DCACtrlF, RcvHdrq16DCAOPH) , KREG_IDX(DCACtrlF) },
-	{ 4, SYM_LSB(DCACtrlF, RcvHdrq17DCAOPH),
-	   ~SYM_MASK(DCACtrlF, RcvHdrq17DCAOPH) , KREG_IDX(DCACtrlF) },
-};
-#endif
-
 /* ibcctrl bits */
 #define QLOGIC_IB_IBCC_LINKINITCMD_DISABLE 1
 /* cycle through TS1/TS2 till OK */
@@ -2538,95 +2483,6 @@ static void qib_setup_7322_setextled(struct qib_pportdata *ppd, u32 on)
 		qib_write_kreg_port(ppd, krp_rcvpktledcnt, ledblink);
 }
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-static void qib_update_rhdrq_dca(struct qib_ctxtdata *rcd)
-{
-	struct qib_devdata *dd = rcd->dd;
-	struct qib_chip_specific *cspec = dd->cspec;
-	int cpu = get_cpu();
-
-	if (cspec->rhdr_cpu[rcd->ctxt] != cpu) {
-		const struct dca_reg_map *rmp;
-
-		cspec->rhdr_cpu[rcd->ctxt] = cpu;
-		rmp = &dca_rcvhdr_reg_map[rcd->ctxt];
-		cspec->dca_rcvhdr_ctrl[rmp->shadow_inx] &= rmp->mask;
-		cspec->dca_rcvhdr_ctrl[rmp->shadow_inx] |=
-			(u64) dca3_get_tag(&dd->pcidev->dev, cpu) << rmp->lsb;
-		qib_write_kreg(dd, rmp->regno,
-			       cspec->dca_rcvhdr_ctrl[rmp->shadow_inx]);
-		cspec->dca_ctrl |= SYM_MASK(DCACtrlA, RcvHdrqDCAEnable);
-		qib_write_kreg(dd, KREG_IDX(DCACtrlA), cspec->dca_ctrl);
-	}
-	put_cpu();
-}
-
-static void qib_update_sdma_dca(struct qib_pportdata *ppd)
-{
-	struct qib_devdata *dd = ppd->dd;
-	struct qib_chip_specific *cspec = dd->cspec;
-	int cpu = get_cpu();
-	unsigned pidx = ppd->port - 1;
-
-	if (cspec->sdma_cpu[pidx] != cpu) {
-		cspec->sdma_cpu[pidx] = cpu;
-		cspec->dca_rcvhdr_ctrl[4] &= ~(ppd->hw_pidx ?
-			SYM_MASK(DCACtrlF, SendDma1DCAOPH) :
-			SYM_MASK(DCACtrlF, SendDma0DCAOPH));
-		cspec->dca_rcvhdr_ctrl[4] |=
-			(u64) dca3_get_tag(&dd->pcidev->dev, cpu) <<
-				(ppd->hw_pidx ?
-					SYM_LSB(DCACtrlF, SendDma1DCAOPH) :
-					SYM_LSB(DCACtrlF, SendDma0DCAOPH));
-		qib_write_kreg(dd, KREG_IDX(DCACtrlF),
-			       cspec->dca_rcvhdr_ctrl[4]);
-		cspec->dca_ctrl |= ppd->hw_pidx ?
-			SYM_MASK(DCACtrlA, SendDMAHead1DCAEnable) :
-			SYM_MASK(DCACtrlA, SendDMAHead0DCAEnable);
-		qib_write_kreg(dd, KREG_IDX(DCACtrlA), cspec->dca_ctrl);
-	}
-	put_cpu();
-}
-
-static void qib_setup_dca(struct qib_devdata *dd)
-{
-	struct qib_chip_specific *cspec = dd->cspec;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(cspec->rhdr_cpu); i++)
-		cspec->rhdr_cpu[i] = -1;
-	for (i = 0; i < ARRAY_SIZE(cspec->sdma_cpu); i++)
-		cspec->sdma_cpu[i] = -1;
-	cspec->dca_rcvhdr_ctrl[0] =
-		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq0DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq1DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq2DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlB, RcvHdrq3DCAXfrCnt));
-	cspec->dca_rcvhdr_ctrl[1] =
-		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq4DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq5DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq6DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlC, RcvHdrq7DCAXfrCnt));
-	cspec->dca_rcvhdr_ctrl[2] =
-		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq8DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq9DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq10DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlD, RcvHdrq11DCAXfrCnt));
-	cspec->dca_rcvhdr_ctrl[3] =
-		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq12DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq13DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq14DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlE, RcvHdrq15DCAXfrCnt));
-	cspec->dca_rcvhdr_ctrl[4] =
-		(1ULL << SYM_LSB(DCACtrlF, RcvHdrq16DCAXfrCnt)) |
-		(1ULL << SYM_LSB(DCACtrlF, RcvHdrq17DCAXfrCnt));
-	for (i = 0; i < ARRAY_SIZE(cspec->sdma_cpu); i++)
-		qib_write_kreg(dd, KREG_IDX(DCACtrlB) + i,
-			       cspec->dca_rcvhdr_ctrl[i]);
-}
-
-#endif
-
 /*
  * Disable MSIx interrupt if enabled, call generic MSIx code
  * to cleanup, and clear pending MSIx interrupts.
@@ -2667,15 +2523,6 @@ static void qib_setup_7322_cleanup(struct qib_devdata *dd)
 {
 	int i;
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	if (dd->flags & QIB_DCA_ENABLED) {
-		dca_remove_requester(&dd->pcidev->dev);
-		dd->flags &= ~QIB_DCA_ENABLED;
-		dd->cspec->dca_ctrl = 0;
-		qib_write_kreg(dd, KREG_IDX(DCACtrlA), dd->cspec->dca_ctrl);
-	}
-#endif
-
 	qib_7322_free_irq(dd);
 	kfree(dd->cspec->cntrs);
 	kfree(dd->cspec->sendchkenable);
@@ -2983,11 +2830,6 @@ static irqreturn_t qib_7322pintr(int irq, void *data)
 	if (dd->int_counter != (u32) -1)
 		dd->int_counter++;
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	if (dd->flags & QIB_DCA_ENABLED)
-		qib_update_rhdrq_dca(rcd);
-#endif
-
 	/* Clear the interrupt bit we expect to be set. */
 	qib_write_kreg(dd, kr_intclear, ((1ULL << QIB_I_RCVAVAIL_LSB) |
 		       (1ULL << QIB_I_RCVURG_LSB)) << rcd->ctxt);
@@ -3051,11 +2893,6 @@ static irqreturn_t sdma_intr(int irq, void *data)
 	if (dd->int_counter != (u32) -1)
 		dd->int_counter++;
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	if (dd->flags & QIB_DCA_ENABLED)
-		qib_update_sdma_dca(ppd);
-#endif
-
 	/* Clear the interrupt bit we expect to be set. */
 	qib_write_kreg(dd, kr_intclear, ppd->hw_pidx ?
 		       INT_MASK_P(SDma, 1) : INT_MASK_P(SDma, 0));
@@ -3085,11 +2922,6 @@ static irqreturn_t sdma_idle_intr(int irq, void *data)
 	if (dd->int_counter != (u32) -1)
 		dd->int_counter++;
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	if (dd->flags & QIB_DCA_ENABLED)
-		qib_update_sdma_dca(ppd);
-#endif
-
 	/* Clear the interrupt bit we expect to be set. */
 	qib_write_kreg(dd, kr_intclear, ppd->hw_pidx ?
 		       INT_MASK_P(SDmaIdle, 1) : INT_MASK_P(SDmaIdle, 0));
@@ -3119,11 +2951,6 @@ static irqreturn_t sdma_progress_intr(int irq, void *data)
 	if (dd->int_counter != (u32) -1)
 		dd->int_counter++;
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	if (dd->flags & QIB_DCA_ENABLED)
-		qib_update_sdma_dca(ppd);
-#endif
-
 	/* Clear the interrupt bit we expect to be set. */
 	qib_write_kreg(dd, kr_intclear, ppd->hw_pidx ?
 		       INT_MASK_P(SDmaProgress, 1) :
@@ -3154,11 +2981,6 @@ static irqreturn_t sdma_cleanup_intr(int irq, void *data)
 	if (dd->int_counter != (u32) -1)
 		dd->int_counter++;
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	if (dd->flags & QIB_DCA_ENABLED)
-		qib_update_sdma_dca(ppd);
-#endif
-
 	/* Clear the interrupt bit we expect to be set. */
 	qib_write_kreg(dd, kr_intclear, ppd->hw_pidx ?
 		       INT_MASK_PM(SDmaCleanupDone, 1) :
@@ -4265,10 +4087,6 @@ static void rcvctrl_7322_mod(struct qib_pportdata *ppd, unsigned int op,
 		qib_write_kreg_ctxt(dd, krc_rcvhdraddr, ctxt,
 				    rcd->rcvhdrq_phys);
 		rcd->seq_cnt = 1;
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-		if (dd->flags & QIB_DCA_ENABLED)
-			qib_update_rhdrq_dca(rcd);
-#endif
 	}
 	if (op & QIB_RCVCTRL_CTXT_DIS)
 		ppd->p_rcvctrl &=
@@ -6893,13 +6711,6 @@ struct qib_devdata *qib_init_iba7322_funcs(struct pci_dev *pdev,
 	/* clear diagctrl register, in case diags were running and crashed */
 	qib_write_kreg(dd, kr_hwdiagctrl, 0);
 
-#if defined(CONFIG_DCA) || defined(CONFIG_DCA_MODULE)
-	ret = dca_add_requester(&pdev->dev);
-	if (!ret) {
-		dd->flags |= QIB_DCA_ENABLED;
-		qib_setup_dca(dd);
-	}
-#endif
 	goto bail;
 
 bail_cleanup:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
