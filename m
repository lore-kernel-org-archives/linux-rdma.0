From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Eliminate 64 bit jiffies
Date: Wed, 9 Nov 2011 13:36:08 -0500
Message-ID: <20111109183608.10405.31269.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The qib driver makes use of the the 64 bit jiffies API.

Code inspection reveals that that version of the API is not
really required.  This patch converts to use the "normal"
jiffies.

Reviewed-by: Ram Vepa <ram.vepa-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_7220.h    |    2 +-
 drivers/infiniband/hw/qib/qib_iba7220.c |    6 +++---
 drivers/infiniband/hw/qib/qib_iba7322.c |   32 +++++++++++++++----------------
 drivers/infiniband/hw/qib/qib_qsfp.h    |    2 +-
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_7220.h b/drivers/infiniband/hw/qib/qib_7220.h
index 21f374a..a5356cb 100644
--- a/drivers/infiniband/hw/qib/qib_7220.h
+++ b/drivers/infiniband/hw/qib/qib_7220.h
@@ -97,7 +97,7 @@ struct qib_chippport_specific {
 	u64 iblnkerrsnap;
 	u64 ibcctrl; /* kr_ibcctrl shadow */
 	u64 ibcddrctrl; /* kr_ibcddrctrl shadow */
-	u64 chase_end;
+	unsigned long chase_end;
 	u32 last_delay_mult;
 };
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 439d3c5..9dd886c 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1051,7 +1051,7 @@ static void reenable_7220_chase(unsigned long opaque)
 static void handle_7220_chase(struct qib_pportdata *ppd, u64 ibcst)
 {
 	u8 ibclt;
-	u64 tnow;
+	unsigned long tnow;
 
 	ibclt = (u8)SYM_FIELD(ibcst, IBCStatus, LinkTrainingState);
 
@@ -1066,9 +1066,9 @@ static void handle_7220_chase(struct qib_pportdata *ppd, u64 ibcst)
 	case IB_7220_LT_STATE_CFGWAITRMT:
 	case IB_7220_LT_STATE_TXREVLANES:
 	case IB_7220_LT_STATE_CFGENH:
-		tnow = get_jiffies_64();
+		tnow = jiffies;
 		if (ppd->cpspec->chase_end &&
-		    time_after64(tnow, ppd->cpspec->chase_end)) {
+		    time_after(tnow, ppd->cpspec->chase_end)) {
 			ppd->cpspec->chase_end = 0;
 			qib_set_ib_7220_lstate(ppd,
 				QLOGIC_IB_IBCC_LINKCMD_DOWN,
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 9294161..631511e 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -614,8 +614,8 @@ struct qib_chippport_specific {
 	u64 ibmalfsnap;
 	u64 ibcctrl_a; /* krp_ibcctrl_a shadow */
 	u64 ibcctrl_b; /* krp_ibcctrl_b shadow */
-	u64 qdr_dfe_time;
-	u64 chase_end;
+	unsigned long qdr_dfe_time;
+	unsigned long chase_end;
 	u32 autoneg_tries;
 	u32 recovery_init;
 	u32 qdr_dfe_on;
@@ -1671,7 +1671,8 @@ static void reenable_chase(unsigned long opaque)
 		QLOGIC_IB_IBCC_LINKINITCMD_POLL);
 }
 
-static void disable_chase(struct qib_pportdata *ppd, u64 tnow, u8 ibclt)
+static void disable_chase(struct qib_pportdata *ppd, unsigned long tnow,
+		u8 ibclt)
 {
 	ppd->cpspec->chase_end = 0;
 
@@ -1687,7 +1688,7 @@ static void disable_chase(struct qib_pportdata *ppd, u64 tnow, u8 ibclt)
 static void handle_serdes_issues(struct qib_pportdata *ppd, u64 ibcst)
 {
 	u8 ibclt;
-	u64 tnow;
+	unsigned long tnow;
 
 	ibclt = (u8)SYM_FIELD(ibcst, IBCStatusA_0, LinkTrainingState);
 
@@ -1702,9 +1703,9 @@ static void handle_serdes_issues(struct qib_pportdata *ppd, u64 ibcst)
 	case IB_7322_LT_STATE_CFGWAITRMT:
 	case IB_7322_LT_STATE_TXREVLANES:
 	case IB_7322_LT_STATE_CFGENH:
-		tnow = get_jiffies_64();
+		tnow = jiffies;
 		if (ppd->cpspec->chase_end &&
-		     time_after64(tnow, ppd->cpspec->chase_end))
+		     time_after(tnow, ppd->cpspec->chase_end))
 			disable_chase(ppd, tnow, ibclt);
 		else if (!ppd->cpspec->chase_end)
 			ppd->cpspec->chase_end = tnow + QIB_CHASE_TIME;
@@ -2716,7 +2717,7 @@ static noinline void unknown_7322_gpio_intr(struct qib_devdata *dd)
 			pins >>= SYM_LSB(EXTStatus, GPIOIn);
 			if (!(pins & mask)) {
 				++handled;
-				qd->t_insert = get_jiffies_64();
+				qd->t_insert = jiffies;
 				queue_work(ib_wq, &qd->work);
 			}
 		}
@@ -4841,7 +4842,7 @@ static void qib_get_7322_faststats(unsigned long opaque)
 		    (ppd->lflags & (QIBL_LINKINIT | QIBL_LINKARMED |
 				    QIBL_LINKACTIVE)) &&
 		    ppd->cpspec->qdr_dfe_time &&
-		    time_after64(get_jiffies_64(), ppd->cpspec->qdr_dfe_time)) {
+		    time_is_before_jiffies(ppd->cpspec->qdr_dfe_time)) {
 			ppd->cpspec->qdr_dfe_on = 0;
 
 			qib_write_kreg_port(ppd, krp_static_adapt_dis(2),
@@ -5287,7 +5288,7 @@ static int qib_7322_ib_updown(struct qib_pportdata *ppd, int ibup, u64 ibcs)
 			/* schedule the qsfp refresh which should turn the link
 			   off */
 			if (ppd->dd->flags & QIB_HAS_QSFP) {
-				qd->t_insert = get_jiffies_64();
+				qd->t_insert = jiffies;
 				queue_work(ib_wq, &qd->work);
 			}
 			spin_lock_irqsave(&ppd->sdma_lock, flags);
@@ -5639,7 +5640,7 @@ static void qsfp_7322_event(struct work_struct *work)
 {
 	struct qib_qsfp_data *qd;
 	struct qib_pportdata *ppd;
-	u64 pwrup;
+	unsigned long pwrup;
 	unsigned long flags;
 	int ret;
 	u32 le2;
@@ -5667,8 +5668,7 @@ static void qsfp_7322_event(struct work_struct *work)
 		 * to insertion.
 		 */
 		while (1) {
-			u64 now = get_jiffies_64();
-			if (time_after64(now, pwrup))
+			if (time_is_before_jiffies(pwrup))
 				break;
 			msleep(20);
 		}
@@ -7551,7 +7551,7 @@ static int serdes_7322_init_old(struct qib_pportdata *ppd)
 
 static int serdes_7322_init_new(struct qib_pportdata *ppd)
 {
-	u64 tstart;
+	unsigned long tend;
 	u32 le_val, rxcaldone;
 	int chan, chan_done = (1 << SERDES_CHANS) - 1;
 
@@ -7656,10 +7656,8 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 	msleep(20);
 	/*       Start Calibration */
 	ibsd_wr_allchans(ppd, 4, (1 << 10), BMASK(10, 10));
-	tstart = get_jiffies_64();
-	while (chan_done &&
-	       !time_after64(get_jiffies_64(),
-			tstart + msecs_to_jiffies(500))) {
+	tend = jiffies + msecs_to_jiffies(500);
+	while (chan_done && !time_is_before_jiffies(tend)) {
 		msleep(20);
 		for (chan = 0; chan < SERDES_CHANS; ++chan) {
 			rxcaldone = ahb_mod(ppd->dd, IBSD(ppd->hw_pidx),
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.h b/drivers/infiniband/hw/qib/qib_qsfp.h
index 46002a9..91908f5 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.h
+++ b/drivers/infiniband/hw/qib/qib_qsfp.h
@@ -177,7 +177,7 @@ struct qib_qsfp_data {
 	struct qib_pportdata *ppd;
 	struct work_struct work;
 	struct qib_qsfp_cache cache;
-	u64 t_insert;
+	unsigned long t_insert;
 	u8 modpresent;
 };
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
