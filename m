From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: Fix over-scheduling of QSFP work.
Date: Wed, 9 Nov 2011 17:07:22 -0500
Message-ID: <20111109220722.22712.28527.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Don't over-schedule QSFP work on driver initialization.
It could end up being run simultaneously on two different
CPUs resulting in bad EEPROM reads.
The above, in combination withe setting the physical IB
link state prior to the IBC being brought out of reset
can cause the link state machine to start training early
with wrong settings.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   16 ++++++++--------
 drivers/infiniband/hw/qib/qib_qsfp.c    |   12 ------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 9be77c5..9294161 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2306,19 +2306,11 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 		SYM_LSB(IBCCtrlA_0, MaxPktLen);
 	ppd->cpspec->ibcctrl_a = ibc; /* without linkcmd or linkinitcmd! */
 
-	/* initially come up waiting for TS1, without sending anything. */
-	val = ppd->cpspec->ibcctrl_a | (QLOGIC_IB_IBCC_LINKINITCMD_DISABLE <<
-		QLOGIC_IB_IBCC_LINKINITCMD_SHIFT);
-
-	ppd->cpspec->ibcctrl_a = val;
 	/*
 	 * Reset the PCS interface to the serdes (and also ibc, which is still
 	 * in reset from above).  Writes new value of ibcctrl_a as last step.
 	 */
 	qib_7322_mini_pcs_reset(ppd);
-	qib_write_kreg(dd, kr_scratch, 0ULL);
-	/* clear the linkinit cmds */
-	ppd->cpspec->ibcctrl_a &= ~SYM_MASK(IBCCtrlA_0, LinkInitCmd);
 
 	if (!ppd->cpspec->ibcctrl_b) {
 		unsigned lse = ppd->link_speed_enabled;
@@ -2384,6 +2376,14 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	ppd->cpspec->ibcctrl_a |= SYM_MASK(IBCCtrlA_0, IBLinkEn);
 	set_vls(ppd);
 
+	/* initially come up DISABLED, without sending anything. */
+	val = ppd->cpspec->ibcctrl_a | (QLOGIC_IB_IBCC_LINKINITCMD_DISABLE <<
+					QLOGIC_IB_IBCC_LINKINITCMD_SHIFT);
+	qib_write_kreg_port(ppd, krp_ibcctrl_a, val);
+	qib_write_kreg(dd, kr_scratch, 0ULL);
+	/* clear the linkinit cmds */
+	ppd->cpspec->ibcctrl_a = val & ~SYM_MASK(IBCCtrlA_0, LinkInitCmd);
+
 	/* be paranoid against later code motion, etc. */
 	spin_lock_irqsave(&dd->cspec->rcvmod_lock, flags);
 	ppd->p_rcvctrl |= SYM_MASK(RcvCtrl_0, RcvIBPortEnable);
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.c b/drivers/infiniband/hw/qib/qib_qsfp.c
index e06c4ed..fa71b1e 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.c
+++ b/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -480,18 +480,6 @@ void qib_qsfp_init(struct qib_qsfp_data *qd,
 	udelay(20); /* Generous RST dwell */
 
 	dd->f_gpio_mod(dd, mask, mask, mask);
-	/* Spec says module can take up to two seconds! */
-	mask = QSFP_GPIO_MOD_PRS_N;
-	if (qd->ppd->hw_pidx)
-		mask <<= QSFP_GPIO_PORT2_SHIFT;
-
-	/* Do not try to wait here. Better to let event handle it */
-	if (!qib_qsfp_mod_present(qd->ppd))
-		goto bail;
-	/* We see a module, but it may be unwise to look yet. Just schedule */
-	qd->t_insert = get_jiffies_64();
-	queue_work(ib_wq, &qd->work);
-bail:
 	return;
 }
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
