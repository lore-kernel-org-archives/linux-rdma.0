From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/qib: Fix issue with link states and QSFP cables
Date: Wed, 19 Oct 2011 18:46:47 -0400
Message-ID: <20111019224647.24717.27366.stgit@kop-dev-sles11-04.qlogic.org>
References: <20111019224632.24717.17782.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111019224632.24717.17782.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

Fix an issue where the link would come up after replugging
a cable even if it has been DISABLED manually.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   30 ++++++++++++++++++++----------
 drivers/infiniband/hw/qib/qib_qsfp.h    |    1 +
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 424b5f4..62005c7 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2309,12 +2309,15 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	val = ppd->cpspec->ibcctrl_a | (QLOGIC_IB_IBCC_LINKINITCMD_DISABLE <<
 		QLOGIC_IB_IBCC_LINKINITCMD_SHIFT);
 
+	ppd->cpspec->ibcctrl_a = val;
 	/*
 	 * Reset the PCS interface to the serdes (and also ibc, which is still
 	 * in reset from above).  Writes new value of ibcctrl_a as last step.
 	 */
 	qib_7322_mini_pcs_reset(ppd);
 	qib_write_kreg(dd, kr_scratch, 0ULL);
+	/* clear the linkinit cmds */
+	ppd->cpspec->ibcctrl_a &= ~SYM_MASK(IBCCtrlA_0, LinkInitCmd);
 
 	if (!ppd->cpspec->ibcctrl_b) {
 		unsigned lse = ppd->link_speed_enabled;
@@ -2380,11 +2383,6 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	ppd->cpspec->ibcctrl_a |= SYM_MASK(IBCCtrlA_0, IBLinkEn);
 	set_vls(ppd);
 
-	/* Hold the link state machine for mezz boards */
-	qib_set_ib_7322_lstate(ppd, 0,
-			       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
-
-
 	/* be paranoid against later code motion, etc. */
 	spin_lock_irqsave(&dd->cspec->rcvmod_lock, flags);
 	ppd->p_rcvctrl |= SYM_MASK(RcvCtrl_0, RcvIBPortEnable);
@@ -5639,6 +5637,7 @@ static void qsfp_7322_event(struct work_struct *work)
 	struct qib_qsfp_data *qd;
 	struct qib_pportdata *ppd;
 	u64 pwrup;
+	unsigned long flags;
 	int ret;
 	u32 le2;
 
@@ -5650,11 +5649,15 @@ static void qsfp_7322_event(struct work_struct *work)
 	/* Delay for 20 msecs to allow ModPrs resistor to setup */
 	mdelay(QSFP_MODPRS_LAG_MSEC);
 
-	if (!qib_qsfp_mod_present(ppd))
+	if (!qib_qsfp_mod_present(ppd)) {
+		ppd->cpspec->qsfp_data.modpresent = 0;
 		/* Set the physical link to disabled */
 		qib_set_ib_7322_lstate(ppd, 0,
 				       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
-	else {
+		spin_lock_irqsave(&ppd->lflags_lock, flags);
+		ppd->lflags &= ~QIBL_LINKV;
+		spin_unlock_irqrestore(&ppd->lflags_lock, flags);
+	} else {
 		/*
 		 * Some QSFP's not only do not respond until the full power-up
 		 * time, but may behave badly if we try. So hold off responding
@@ -5694,11 +5697,18 @@ static void qsfp_7322_event(struct work_struct *work)
 		 */
 		init_txdds_table(ppd, 0);
 		/* The physical link is being re-enabled only when the
-		   previous state was DISABLED. This should only happen when
-		   the cable has been physically pulled. */
-		if (ppd->lflags & QIBL_IB_LINK_DISABLED)
+		 * previous state was DISABLED and the VALID bit is not
+		 * set. This should only happen when  the cable has been
+		 * physically pulled. */
+		if (!ppd->cpspec->qsfp_data.modpresent &&
+		    (ppd->lflags & (QIBL_LINKV | QIBL_IB_LINK_DISABLED))) {
+			ppd->cpspec->qsfp_data.modpresent = 1;
 			qib_set_ib_7322_lstate(ppd, 0,
 				QLOGIC_IB_IBCC_LINKINITCMD_SLEEP);
+			spin_lock_irqsave(&ppd->lflags_lock, flags);
+			ppd->lflags |= QIBL_LINKV;
+			spin_unlock_irqrestore(&ppd->lflags_lock, flags);
+		}
 	}
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.h b/drivers/infiniband/hw/qib/qib_qsfp.h
index 786a92a..46002a9 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.h
+++ b/drivers/infiniband/hw/qib/qib_qsfp.h
@@ -178,6 +178,7 @@ struct qib_qsfp_data {
 	struct work_struct work;
 	struct qib_qsfp_cache cache;
 	u64 t_insert;
+	u8 modpresent;
 };
 
 extern int qib_refresh_qsfp_cache(struct qib_pportdata *ppd,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
