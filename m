From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: Hold links until tuning data is available
Date: Wed, 19 Oct 2011 18:46:40 -0400
Message-ID: <20111019224640.24717.88712.stgit@kop-dev-sles11-04.qlogic.org>
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

Hold the link state machine until the tuning data is read
from the QSFP EEPROM so correct tuning settings are applied
before the state machine attempts to bring the link up.
Link is also held on cable unplug in case a different cable is
used.

Signed-off-by: Mitko Haralanov <mitko-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |  118 ++++++++++++++++++++-----------
 drivers/infiniband/hw/qib/qib_init.c    |    4 -
 drivers/infiniband/hw/qib/qib_qsfp.c    |   25 ++++---
 drivers/infiniband/hw/qib/qib_qsfp.h    |    2 +
 4 files changed, 92 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index ebc5266..424b5f4 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -2380,17 +2380,17 @@ static int qib_7322_bringup_serdes(struct qib_pportdata *ppd)
 	ppd->cpspec->ibcctrl_a |= SYM_MASK(IBCCtrlA_0, IBLinkEn);
 	set_vls(ppd);
 
+	/* Hold the link state machine for mezz boards */
+	qib_set_ib_7322_lstate(ppd, 0,
+			       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
+
+
 	/* be paranoid against later code motion, etc. */
 	spin_lock_irqsave(&dd->cspec->rcvmod_lock, flags);
 	ppd->p_rcvctrl |= SYM_MASK(RcvCtrl_0, RcvIBPortEnable);
 	qib_write_kreg_port(ppd, krp_rcvctrl, ppd->p_rcvctrl);
 	spin_unlock_irqrestore(&dd->cspec->rcvmod_lock, flags);
 
-	/* Hold the link state machine for mezz boards */
-	if (IS_QMH(dd) || IS_QME(dd))
-		qib_set_ib_7322_lstate(ppd, 0,
-				       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
-
 	/* Also enable IBSTATUSCHG interrupt.  */
 	val = qib_read_kreg_port(ppd, krp_errmask);
 	qib_write_kreg_port(ppd, krp_errmask,
@@ -5276,6 +5276,8 @@ static int qib_7322_ib_updown(struct qib_pportdata *ppd, int ibup, u64 ibcs)
 				     QIBL_IB_AUTONEG_INPROG)))
 			set_7322_ibspeed_fast(ppd, ppd->link_speed_enabled);
 		if (!(ppd->lflags & QIBL_IB_AUTONEG_INPROG)) {
+			struct qib_qsfp_data *qd =
+				&ppd->cpspec->qsfp_data;
 			/* unlock the Tx settings, speed may change */
 			qib_write_kreg_port(ppd, krp_tx_deemph_override,
 				SYM_MASK(IBSD_TX_DEEMPHASIS_OVERRIDE_0,
@@ -5283,6 +5285,10 @@ static int qib_7322_ib_updown(struct qib_pportdata *ppd, int ibup, u64 ibcs)
 			qib_cancel_sends(ppd);
 			/* on link down, ensure sane pcs state */
 			qib_7322_mini_pcs_reset(ppd);
+			/* schedule the qsfp refresh which should turn the link
+			   off */
+			qd->t_insert = get_jiffies_64();
+			schedule_work(&qd->work);
 			spin_lock_irqsave(&ppd->sdma_lock, flags);
 			if (__qib_sdma_running(ppd))
 				__qib_sdma_process_event(ppd,
@@ -5638,38 +5644,62 @@ static void qsfp_7322_event(struct work_struct *work)
 
 	qd = container_of(work, struct qib_qsfp_data, work);
 	ppd = qd->ppd;
-	pwrup = qd->t_insert + msecs_to_jiffies(QSFP_PWR_LAG_MSEC);
+	pwrup = qd->t_insert +
+		msecs_to_jiffies(QSFP_PWR_LAG_MSEC - QSFP_MODPRS_LAG_MSEC);
 
-	/*
-	 * Some QSFP's not only do not respond until the full power-up
-	 * time, but may behave badly if we try. So hold off responding
-	 * to insertion.
-	 */
-	while (1) {
-		u64 now = get_jiffies_64();
-		if (time_after64(now, pwrup))
-			break;
-		msleep(20);
-	}
-	ret = qib_refresh_qsfp_cache(ppd, &qd->cache);
-	/*
-	 * Need to change LE2 back to defaults if we couldn't
-	 * read the cable type (to handle cable swaps), so do this
-	 * even on failure to read cable information.  We don't
-	 * get here for QME, so IS_QME check not needed here.
-	 */
-	if (!ret && !ppd->dd->cspec->r1) {
-		if (QSFP_IS_ACTIVE_FAR(qd->cache.tech))
-			le2 = LE2_QME;
-		else if (qd->cache.atten[1] >= qib_long_atten &&
-			 QSFP_IS_CU(qd->cache.tech))
-			le2 = LE2_5m;
-		else
+	/* Delay for 20 msecs to allow ModPrs resistor to setup */
+	mdelay(QSFP_MODPRS_LAG_MSEC);
+
+	if (!qib_qsfp_mod_present(ppd))
+		/* Set the physical link to disabled */
+		qib_set_ib_7322_lstate(ppd, 0,
+				       QLOGIC_IB_IBCC_LINKINITCMD_DISABLE);
+	else {
+		/*
+		 * Some QSFP's not only do not respond until the full power-up
+		 * time, but may behave badly if we try. So hold off responding
+		 * to insertion.
+		 */
+		while (1) {
+			u64 now = get_jiffies_64();
+			if (time_after64(now, pwrup))
+				break;
+			msleep(20);
+		}
+
+		ret = qib_refresh_qsfp_cache(ppd, &qd->cache);
+
+		/*
+		 * Need to change LE2 back to defaults if we couldn't
+		 * read the cable type (to handle cable swaps), so do this
+		 * even on failure to read cable information.  We don't
+		 * get here for QME, so IS_QME check not needed here.
+		 */
+		if (!ret && !ppd->dd->cspec->r1) {
+			if (QSFP_IS_ACTIVE_FAR(qd->cache.tech))
+				le2 = LE2_QME;
+			else if (qd->cache.atten[1] >= qib_long_atten &&
+				 QSFP_IS_CU(qd->cache.tech))
+				le2 = LE2_5m;
+			else
+				le2 = LE2_DEFAULT;
+		} else
 			le2 = LE2_DEFAULT;
-	} else
-		le2 = LE2_DEFAULT;
-	ibsd_wr_allchans(ppd, 13, (le2 << 7), BMASK(9, 7));
-	init_txdds_table(ppd, 0);
+		ibsd_wr_allchans(ppd, 13, (le2 << 7), BMASK(9, 7));
+		/*
+		 * We always change parameteters, since we can choose
+		 * values for cables without eeproms, and the cable may have
+		 * changed from a cable with full or partial eeprom content
+		 * to one with partial or no content.
+		 */
+		init_txdds_table(ppd, 0);
+		/* The physical link is being re-enabled only when the
+		   previous state was DISABLED. This should only happen when
+		   the cable has been physically pulled. */
+		if (ppd->lflags & QIBL_IB_LINK_DISABLED)
+			qib_set_ib_7322_lstate(ppd, 0,
+				QLOGIC_IB_IBCC_LINKINITCMD_SLEEP);
+	}
 }
 
 /*
@@ -5773,7 +5803,8 @@ static void set_no_qsfp_atten(struct qib_devdata *dd, int change)
 			/* now change the IBC and serdes, overriding generic */
 			init_txdds_table(ppd, 1);
 			/* Re-enable the physical state machine on mezz boards
-			 * now that the correct settings have been set. */
+			 * now that the correct settings have been set.
+			 * QSFP boards are handles by the QSFP event handler */
 			if (IS_QMH(dd) || IS_QME(dd))
 				qib_set_ib_7322_lstate(ppd, 0,
 					    QLOGIC_IB_IBCC_LINKINITCMD_SLEEP);
@@ -7193,7 +7224,8 @@ static void find_best_ent(struct qib_pportdata *ppd,
 		}
 	}
 
-	/* Lookup serdes setting by cable type and attenuation */
+	/* Active cables don't have attenuation so we only set SERDES
+	 * settings to account for the attenuation of the board traces. */
 	if (!override && QSFP_IS_ACTIVE(qd->tech)) {
 		*sdr_dds = txdds_sdr + ppd->dd->board_atten;
 		*ddr_dds = txdds_ddr + ppd->dd->board_atten;
@@ -7510,12 +7542,6 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 	u32 le_val, rxcaldone;
 	int chan, chan_done = (1 << SERDES_CHANS) - 1;
 
-	/*
-	 * Initialize the Tx DDS tables.  Also done every QSFP event,
-	 * for adapters with QSFP
-	 */
-	init_txdds_table(ppd, 0);
-
 	/* Clear cmode-override, may be set from older driver */
 	ahb_mod(ppd->dd, IBSD(ppd->hw_pidx), 5, 10, 0 << 14, 1 << 14);
 
@@ -7701,6 +7727,12 @@ static int serdes_7322_init_new(struct qib_pportdata *ppd)
 	/* VGA output common mode */
 	ibsd_wr_allchans(ppd, 12, (3 << 2), BMASK(3, 2));
 
+	/*
+	 * Initialize the Tx DDS tables.  Also done every QSFP event,
+	 * for adapters with QSFP
+	 */
+	init_txdds_table(ppd, 0);
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 3f0bfc3..d604fc1 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -584,10 +584,6 @@ int qib_init(struct qib_devdata *dd, int reinit)
 			continue;
 		}
 
-		/* let link come up, and enable IBC */
-		spin_lock_irqsave(&ppd->lflags_lock, flags);
-		ppd->lflags &= ~QIBL_IB_LINK_DISABLED;
-		spin_unlock_irqrestore(&ppd->lflags_lock, flags);
 		portok++;
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.c b/drivers/infiniband/hw/qib/qib_qsfp.c
index 3374a52..e06c4ed 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.c
+++ b/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -273,18 +273,12 @@ int qib_refresh_qsfp_cache(struct qib_pportdata *ppd, struct qib_qsfp_cache *cp)
 	int ret;
 	int idx;
 	u16 cks;
-	u32 mask;
 	u8 peek[4];
 
 	/* ensure sane contents on invalid reads, for cable swaps */
 	memset(cp, 0, sizeof(*cp));
 
-	mask = QSFP_GPIO_MOD_PRS_N;
-	if (ppd->hw_pidx)
-		mask <<= QSFP_GPIO_PORT2_SHIFT;
-
-	ret = ppd->dd->f_gpio_mod(ppd->dd, 0, 0, 0);
-	if (ret & mask) {
+	if (!qib_qsfp_mod_present(ppd)) {
 		ret = -ENODEV;
 		goto bail;
 	}
@@ -444,6 +438,19 @@ const char * const qib_qsfp_devtech[16] = {
 
 static const char *pwr_codes = "1.5W2.0W2.5W3.5W";
 
+int qib_qsfp_mod_present(struct qib_pportdata *ppd)
+{
+	u32 mask;
+	int ret;
+
+	mask = QSFP_GPIO_MOD_PRS_N <<
+		(ppd->hw_pidx * QSFP_GPIO_PORT2_SHIFT);
+	ret = ppd->dd->f_gpio_mod(ppd->dd, 0, 0, 0);
+
+	return !((ret & mask) >>
+		 ((ppd->hw_pidx * QSFP_GPIO_PORT2_SHIFT) + 3));
+}
+
 /*
  * Initialize structures that control access to QSFP. Called once per port
  * on cards that support QSFP.
@@ -452,7 +459,6 @@ void qib_qsfp_init(struct qib_qsfp_data *qd,
 		   void (*fevent)(struct work_struct *))
 {
 	u32 mask, highs;
-	int pins;
 
 	struct qib_devdata *dd = qd->ppd->dd;
 
@@ -480,8 +486,7 @@ void qib_qsfp_init(struct qib_qsfp_data *qd,
 		mask <<= QSFP_GPIO_PORT2_SHIFT;
 
 	/* Do not try to wait here. Better to let event handle it */
-	pins = dd->f_gpio_mod(dd, 0, 0, 0);
-	if (pins & mask)
+	if (!qib_qsfp_mod_present(qd->ppd))
 		goto bail;
 	/* We see a module, but it may be unwise to look yet. Just schedule */
 	qd->t_insert = get_jiffies_64();
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.h b/drivers/infiniband/hw/qib/qib_qsfp.h
index c109bbd..786a92a 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.h
+++ b/drivers/infiniband/hw/qib/qib_qsfp.h
@@ -34,6 +34,7 @@
 
 #define QSFP_DEV 0xA0
 #define QSFP_PWR_LAG_MSEC 2000
+#define QSFP_MODPRS_LAG_MSEC 20
 
 /*
  * Below are masks for various QSFP signals, for Port 1.
@@ -181,6 +182,7 @@ struct qib_qsfp_data {
 
 extern int qib_refresh_qsfp_cache(struct qib_pportdata *ppd,
 				  struct qib_qsfp_cache *cp);
+extern int qib_qsfp_mod_present(struct qib_pportdata *ppd);
 extern void qib_qsfp_init(struct qib_qsfp_data *qd,
 			  void (*fevent)(struct work_struct *));
 extern void qib_qsfp_deinit(struct qib_qsfp_data *qd);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
