From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] IB/qib: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:45:35 -0700
Message-ID: <20171005004535.GA22628@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
helper to pass the timer pointer explicitly.

Cc: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/infiniband/hw/qib/qib.h         |  4 ++--
 drivers/infiniband/hw/qib/qib_7220.h    |  1 +
 drivers/infiniband/hw/qib/qib_driver.c  |  9 ++++-----
 drivers/infiniband/hw/qib/qib_iba6120.c | 19 +++++++++----------
 drivers/infiniband/hw/qib/qib_iba7220.c | 20 ++++++++++----------
 drivers/infiniband/hw/qib/qib_iba7322.c | 17 ++++++++---------
 drivers/infiniband/hw/qib/qib_init.c    | 29 +++++++++++------------------
 drivers/infiniband/hw/qib/qib_intr.c    |  6 +++---
 drivers/infiniband/hw/qib/qib_mad.c     | 12 +++++-------
 drivers/infiniband/hw/qib/qib_sd7220.c  | 10 ++++------
 drivers/infiniband/hw/qib/qib_tx.c      |  4 ++--
 drivers/infiniband/hw/qib/qib_verbs.c   |  6 +++---
 12 files changed, 62 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index f9e1c69603a5..f9541a0ee5cd 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1188,7 +1188,7 @@ int qib_set_lid(struct qib_pportdata *, u32, u8);
 void qib_hol_down(struct qib_pportdata *);
 void qib_hol_init(struct qib_pportdata *);
 void qib_hol_up(struct qib_pportdata *);
-void qib_hol_event(unsigned long);
+void qib_hol_event(struct timer_list *);
 void qib_disable_after_error(struct qib_devdata *);
 int qib_set_uevent_bits(struct qib_pportdata *, const int);
 
@@ -1302,7 +1302,7 @@ void qib_get_eeprom_info(struct qib_devdata *);
 #define qib_inc_eeprom_err(dd, eidx, incr)
 void qib_dump_lookup_output_queue(struct qib_devdata *);
 void qib_force_pio_avail_update(struct qib_devdata *);
-void qib_clear_symerror_on_linkup(unsigned long opaque);
+void qib_clear_symerror_on_linkup(struct timer_list *t);
 
 /*
  * Set LED override, only the two LSBs have "public" meaning, but
diff --git a/drivers/infiniband/hw/qib/qib_7220.h b/drivers/infiniband/hw/qib/qib_7220.h
index a5356cb4252e..c467a6076aa8 100644
--- a/drivers/infiniband/hw/qib/qib_7220.h
+++ b/drivers/infiniband/hw/qib/qib_7220.h
@@ -75,6 +75,7 @@ struct qib_chip_specific {
 	char bitsmsgbuf[64];
 	struct timer_list relock_timer;
 	unsigned int relock_interval; /* in jiffies */
+	struct qib_devdata *dd;
 };
 
 struct qib_chippport_specific {
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 719906a9fd51..33d3335385e8 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -682,9 +682,10 @@ int qib_set_lid(struct qib_pportdata *ppd, u32 lid, u8 lmc)
 /* Below is "non-zero" to force override, but both actual LEDs are off */
 #define LED_OVER_BOTH_OFF (8)
 
-static void qib_run_led_override(unsigned long opaque)
+static void qib_run_led_override(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+	struct qib_pportdata *ppd = from_timer(ppd, t,
+						    led_override_timer);
 	struct qib_devdata *dd = ppd->dd;
 	int timeoff;
 	int ph_idx;
@@ -735,9 +736,7 @@ void qib_set_led_override(struct qib_pportdata *ppd, unsigned int val)
 	 */
 	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&ppd->led_override_timer);
-		ppd->led_override_timer.function = qib_run_led_override;
-		ppd->led_override_timer.data = (unsigned long) ppd;
+		timer_setup(&ppd->led_override_timer, qib_run_led_override, 0);
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
 	} else {
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index 3259a60e4f4f..0113b4e60447 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -266,6 +266,7 @@ struct qib_chip_specific {
 	u64 rpkts; /* total packets received (sample result) */
 	u64 xmit_wait; /* # of ticks no data sent (sample result) */
 	struct timer_list pma_timer;
+	struct qib_pportdata *ppd;
 	char emsgbuf[128];
 	char bitsmsgbuf[64];
 	u8 pma_sample_status;
@@ -2647,9 +2648,9 @@ static void qib_chk_6120_errormask(struct qib_devdata *dd)
  * need traffic_wds done the way it is
  * called from add_timer
  */
-static void qib_get_6120_faststats(unsigned long opaque)
+static void qib_get_6120_faststats(struct timer_list *t)
 {
-	struct qib_devdata *dd = (struct qib_devdata *) opaque;
+	struct qib_devdata *dd = from_timer(dd, t, stats_timer);
 	struct qib_pportdata *ppd = dd->pport;
 	unsigned long flags;
 	u64 traffic_wds;
@@ -2937,10 +2938,10 @@ static int qib_6120_set_loopback(struct qib_pportdata *ppd, const char *what)
 	return ret;
 }
 
-static void pma_6120_timer(unsigned long data)
+static void pma_6120_timer(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)data;
-	struct qib_chip_specific *cs = ppd->dd->cspec;
+	struct qib_chip_specific *cs = from_timer(cs, t, pma_timer);
+	struct qib_pportdata *ppd = cs->ppd;
 	struct qib_ibport *ibp = &ppd->ibport_data;
 	unsigned long flags;
 
@@ -3205,6 +3206,7 @@ static int init_6120_variables(struct qib_devdata *dd)
 	dd->num_pports = 1;
 
 	dd->cspec = (struct qib_chip_specific *)(ppd + dd->num_pports);
+	dd->cspec->ppd = ppd;
 	ppd->cpspec = NULL; /* not used in this chip */
 
 	spin_lock_init(&dd->cspec->kernel_tid_lock);
@@ -3289,11 +3291,8 @@ static int init_6120_variables(struct qib_devdata *dd)
 	dd->rhdrhead_intr_off = 1ULL << 32;
 
 	/* setup the stats timer; the add_timer is done at end of init */
-	setup_timer(&dd->stats_timer, qib_get_6120_faststats,
-		    (unsigned long)dd);
-
-	setup_timer(&dd->cspec->pma_timer, pma_6120_timer,
-		    (unsigned long)ppd);
+	timer_setup(&dd->stats_timer, qib_get_6120_faststats, 0);
+	timer_setup(&dd->cspec->pma_timer, pma_6120_timer, 0);
 
 	dd->ureg_align = qib_read_kreg32(dd, kr_palign);
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index 04bdd3d487b1..d400aa7c73b4 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -1042,9 +1042,11 @@ static int qib_decode_7220_err(struct qib_devdata *dd, char *buf, size_t blen,
 	return iserr;
 }
 
-static void reenable_7220_chase(unsigned long opaque)
+static void reenable_7220_chase(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+	struct qib_chippport_specific *cpspec = from_timer(cpspec, t,
+							 chase_timer);
+	struct qib_pportdata *ppd = &cpspec->pportdata;
 
 	ppd->cpspec->chase_timer.expires = 0;
 	qib_set_ib_7220_lstate(ppd, QLOGIC_IB_IBCC_LINKCMD_DOWN,
@@ -1663,7 +1665,7 @@ static void qib_7220_quiet_serdes(struct qib_pportdata *ppd)
 		       dd->control | QLOGIC_IB_C_FREEZEMODE);
 
 	ppd->cpspec->chase_end = 0;
-	if (ppd->cpspec->chase_timer.data) /* if initted */
+	if (ppd->cpspec->chase_timer.function) /* if initted */
 		del_timer_sync(&ppd->cpspec->chase_timer);
 
 	if (ppd->cpspec->ibsymdelta || ppd->cpspec->iblnkerrdelta ||
@@ -3263,9 +3265,9 @@ static u32 qib_read_7220portcntrs(struct qib_devdata *dd, loff_t pos, u32 port,
  * need traffic_wds done the way it is
  * called from add_timer
  */
-static void qib_get_7220_faststats(unsigned long opaque)
+static void qib_get_7220_faststats(struct timer_list *t)
 {
-	struct qib_devdata *dd = (struct qib_devdata *) opaque;
+	struct qib_devdata *dd = from_timer(dd, t, stats_timer);
 	struct qib_pportdata *ppd = dd->pport;
 	unsigned long flags;
 	u64 traffic_wds;
@@ -3997,6 +3999,7 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	dd->num_pports = 1;
 
 	dd->cspec = (struct qib_chip_specific *)(cpspec + dd->num_pports);
+	dd->cspec->dd = dd;
 	ppd->cpspec = cpspec;
 
 	spin_lock_init(&dd->cspec->sdepb_lock);
@@ -4069,8 +4072,7 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	if (!qib_mini_init)
 		qib_write_kreg(dd, kr_rcvbthqp, QIB_KD_QP);
 
-	setup_timer(&ppd->cpspec->chase_timer, reenable_7220_chase,
-		    (unsigned long)ppd);
+	timer_setup(&ppd->cpspec->chase_timer, reenable_7220_chase, 0);
 
 	qib_num_cfg_vls = 1; /* if any 7220's, only one VL */
 
@@ -4095,9 +4097,7 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	dd->rhdrhead_intr_off = 1ULL << 32;
 
 	/* setup the stats timer; the add_timer is done at end of init */
-	init_timer(&dd->stats_timer);
-	dd->stats_timer.function = qib_get_7220_faststats;
-	dd->stats_timer.data = (unsigned long) dd;
+	timer_setup(&dd->stats_timer, qib_get_7220_faststats, 0);
 	dd->stats_timer.expires = jiffies + ACTIVITY_TIMER * HZ;
 
 	/*
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 14cadf6d6214..a432d8e450b4 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1739,9 +1739,10 @@ static void qib_error_tasklet(unsigned long data)
 	qib_write_kreg(dd, kr_errmask, dd->cspec->errormask);
 }
 
-static void reenable_chase(unsigned long opaque)
+static void reenable_chase(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+	struct qib_chippport_specific *cp = from_timer(cp, t, chase_timer);
+	struct qib_pportdata *ppd = cp->ppd;
 
 	ppd->cpspec->chase_timer.expires = 0;
 	qib_set_ib_7322_lstate(ppd, QLOGIC_IB_IBCC_LINKCMD_DOWN,
@@ -2531,7 +2532,7 @@ static void qib_7322_mini_quiet_serdes(struct qib_pportdata *ppd)
 		cancel_delayed_work_sync(&ppd->cpspec->ipg_work);
 
 	ppd->cpspec->chase_end = 0;
-	if (ppd->cpspec->chase_timer.data) /* if initted */
+	if (ppd->cpspec->chase_timer.function) /* if initted */
 		del_timer_sync(&ppd->cpspec->chase_timer);
 
 	/*
@@ -5138,9 +5139,9 @@ static u32 qib_read_7322portcntrs(struct qib_devdata *dd, loff_t pos, u32 port,
  *
  * called from add_timer
  */
-static void qib_get_7322_faststats(unsigned long opaque)
+static void qib_get_7322_faststats(struct timer_list *t)
 {
-	struct qib_devdata *dd = (struct qib_devdata *) opaque;
+	struct qib_devdata *dd = from_timer(dd, t, stats_timer);
 	struct qib_pportdata *ppd;
 	unsigned long flags;
 	u64 traffic_wds;
@@ -6614,8 +6615,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		if (!qib_mini_init)
 			write_7322_init_portregs(ppd);
 
-		setup_timer(&cp->chase_timer, reenable_chase,
-			    (unsigned long)ppd);
+		timer_setup(&cp->chase_timer, reenable_chase, 0);
 
 		ppd++;
 	}
@@ -6641,8 +6641,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 		(u64) rcv_int_count << IBA7322_HDRHEAD_PKTINT_SHIFT;
 
 	/* setup the stats timer; the add_timer is done at end of init */
-	setup_timer(&dd->stats_timer, qib_get_7322_faststats,
-		    (unsigned long)dd);
+	timer_setup(&dd->stats_timer, qib_get_7322_faststats, 0);
 
 	dd->ureg_align = 0x10000;  /* 64KB alignment */
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index c5a4c65636d6..5243ad30dfc0 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -93,7 +93,7 @@ unsigned qib_cc_table_size;
 module_param_named(cc_table_size, qib_cc_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(cc_table_size, "Congestion control table entries 0 (CCA disabled - default), min = 128, max = 1984");
 
-static void verify_interrupt(unsigned long);
+static void verify_interrupt(struct timer_list *);
 
 static struct idr qib_unit_table;
 u32 qib_cpulist_count;
@@ -233,8 +233,7 @@ int qib_init_pportdata(struct qib_pportdata *ppd, struct qib_devdata *dd,
 	spin_lock_init(&ppd->cc_shadow_lock);
 	init_waitqueue_head(&ppd->state_wait);
 
-	setup_timer(&ppd->symerr_clear_timer, qib_clear_symerror_on_linkup,
-		    (unsigned long)ppd);
+	timer_setup(&ppd->symerr_clear_timer, qib_clear_symerror_on_linkup, 0);
 
 	ppd->qib_wq = NULL;
 	ppd->ibport_data.pmastats =
@@ -428,8 +427,7 @@ static int loadtime_init(struct qib_devdata *dd)
 	qib_get_eeprom_info(dd);
 
 	/* setup time (don't start yet) to verify we got interrupt */
-	setup_timer(&dd->intrchk_timer, verify_interrupt,
-		    (unsigned long)dd);
+	timer_setup(&dd->intrchk_timer, verify_interrupt, 0);
 done:
 	return ret;
 }
@@ -493,9 +491,9 @@ static void enable_chip(struct qib_devdata *dd)
 	}
 }
 
-static void verify_interrupt(unsigned long opaque)
+static void verify_interrupt(struct timer_list *t)
 {
-	struct qib_devdata *dd = (struct qib_devdata *) opaque;
+	struct qib_devdata *dd = from_timer(dd, t, intrchk_timer);
 	u64 int_counter;
 
 	if (!dd)
@@ -753,8 +751,7 @@ int qib_init(struct qib_devdata *dd, int reinit)
 				continue;
 			if (dd->flags & QIB_HAS_SEND_DMA)
 				ret = qib_setup_sdma(ppd);
-			setup_timer(&ppd->hol_timer, qib_hol_event,
-				    (unsigned long)ppd);
+			timer_setup(&ppd->hol_timer, qib_hol_event, 0);
 			ppd->hol_state = QIB_HOL_UP;
 		}
 
@@ -815,23 +812,19 @@ static void qib_stop_timers(struct qib_devdata *dd)
 	struct qib_pportdata *ppd;
 	int pidx;
 
-	if (dd->stats_timer.data) {
+	if (dd->stats_timer.function)
 		del_timer_sync(&dd->stats_timer);
-		dd->stats_timer.data = 0;
-	}
-	if (dd->intrchk_timer.data) {
+	if (dd->intrchk_timer.function)
 		del_timer_sync(&dd->intrchk_timer);
-		dd->intrchk_timer.data = 0;
-	}
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
-		if (ppd->hol_timer.data)
+		if (ppd->hol_timer.function)
 			del_timer_sync(&ppd->hol_timer);
-		if (ppd->led_override_timer.data) {
+		if (ppd->led_override_timer.function) {
 			del_timer_sync(&ppd->led_override_timer);
 			atomic_set(&ppd->led_override_timer_active, 0);
 		}
-		if (ppd->symerr_clear_timer.data)
+		if (ppd->symerr_clear_timer.function)
 			del_timer_sync(&ppd->symerr_clear_timer);
 	}
 }
diff --git a/drivers/infiniband/hw/qib/qib_intr.c b/drivers/infiniband/hw/qib/qib_intr.c
index a014fd4cd076..65c3b964ad1b 100644
--- a/drivers/infiniband/hw/qib/qib_intr.c
+++ b/drivers/infiniband/hw/qib/qib_intr.c
@@ -141,7 +141,7 @@ void qib_handle_e_ibstatuschanged(struct qib_pportdata *ppd, u64 ibcs)
 			qib_hol_up(ppd); /* useful only for 6120 now */
 			*ppd->statusp |=
 				QIB_STATUS_IB_READY | QIB_STATUS_IB_CONF;
-			qib_clear_symerror_on_linkup((unsigned long)ppd);
+			qib_clear_symerror_on_linkup(&ppd->symerr_clear_timer);
 			spin_lock_irqsave(&ppd->lflags_lock, flags);
 			ppd->lflags |= QIBL_LINKACTIVE | QIBL_LINKV;
 			ppd->lflags &= ~(QIBL_LINKINIT |
@@ -170,9 +170,9 @@ void qib_handle_e_ibstatuschanged(struct qib_pportdata *ppd, u64 ibcs)
 		signal_ib_event(ppd, ev);
 }
 
-void qib_clear_symerror_on_linkup(unsigned long opaque)
+void qib_clear_symerror_on_linkup(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+	struct qib_pportdata *ppd = from_timer(ppd, t, symerr_clear_timer);
 
 	if (ppd->lflags & QIBL_LINKACTIVE)
 		return;
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 82d9da9b6997..dd0992e9ab50 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2446,9 +2446,9 @@ int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	return ret;
 }
 
-static void xmit_wait_timer_func(unsigned long opaque)
+static void xmit_wait_timer_func(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+	struct qib_pportdata *ppd = from_timer(ppd, t, cong_stats.timer);
 	struct qib_devdata *dd = dd_from_ppd(ppd);
 	unsigned long flags;
 	u8 status;
@@ -2478,10 +2478,8 @@ void qib_notify_create_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 
 	/* Initialize xmit_wait structure */
 	dd->pport[port_idx].cong_stats.counter = 0;
-	init_timer(&dd->pport[port_idx].cong_stats.timer);
-	dd->pport[port_idx].cong_stats.timer.function = xmit_wait_timer_func;
-	dd->pport[port_idx].cong_stats.timer.data =
-		(unsigned long)(&dd->pport[port_idx]);
+	timer_setup(&dd->pport[port_idx].cong_stats.timer,
+		    xmit_wait_timer_func, 0);
 	dd->pport[port_idx].cong_stats.timer.expires = 0;
 	add_timer(&dd->pport[port_idx].cong_stats.timer);
 }
@@ -2492,7 +2490,7 @@ void qib_notify_free_mad_agent(struct rvt_dev_info *rdi, int port_idx)
 	struct qib_devdata *dd = container_of(ibdev,
 					      struct qib_devdata, verbs_dev);
 
-	if (dd->pport[port_idx].cong_stats.timer.data)
+	if (dd->pport[port_idx].cong_stats.timer.function)
 		del_timer_sync(&dd->pport[port_idx].cong_stats.timer);
 
 	if (dd->pport[port_idx].ibport_data.smi_ah)
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index c72775f27212..c06bcb1a208d 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -1390,11 +1390,11 @@ module_param_named(relock_by_timer, qib_relock_by_timer, uint,
 		   S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(relock_by_timer, "Allow relock attempt if link not up");
 
-static void qib_run_relock(unsigned long opaque)
+static void qib_run_relock(struct timer_list *t)
 {
-	struct qib_devdata *dd = (struct qib_devdata *)opaque;
+	struct qib_chip_specific *cs = from_timer(cs, t, relock_timer);
+	struct qib_devdata *dd = cs->dd;
 	struct qib_pportdata *ppd = dd->pport;
-	struct qib_chip_specific *cs = dd->cspec;
 	int timeoff;
 
 	/*
@@ -1440,9 +1440,7 @@ void set_7220_relock_poll(struct qib_devdata *dd, int ibup)
 		/* If timer has not yet been started, do so. */
 		if (!cs->relock_timer_active) {
 			cs->relock_timer_active = 1;
-			init_timer(&cs->relock_timer);
-			cs->relock_timer.function = qib_run_relock;
-			cs->relock_timer.data = (unsigned long) dd;
+			timer_setup(&cs->relock_timer, qib_run_relock, 0);
 			cs->relock_interval = timeout;
 			cs->relock_timer.expires = jiffies + timeout;
 			add_timer(&cs->relock_timer);
diff --git a/drivers/infiniband/hw/qib/qib_tx.c b/drivers/infiniband/hw/qib/qib_tx.c
index eface3b3dacf..db6e925058b7 100644
--- a/drivers/infiniband/hw/qib/qib_tx.c
+++ b/drivers/infiniband/hw/qib/qib_tx.c
@@ -552,9 +552,9 @@ void qib_hol_up(struct qib_pportdata *ppd)
 /*
  * This is only called via the timer.
  */
-void qib_hol_event(unsigned long opaque)
+void qib_hol_event(struct timer_list *t)
 {
-	struct qib_pportdata *ppd = (struct qib_pportdata *)opaque;
+	struct qib_pportdata *ppd = from_timer(ppd, t, hol_timer);
 
 	/* If hardware error, etc, skip. */
 	if (!(ppd->dd->flags & QIB_INITTED))
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9d92aeb8d9a1..db958b1f60b1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -389,9 +389,9 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
  * This is called from a timer to check for QPs
  * which need kernel memory in order to send a packet.
  */
-static void mem_timer(unsigned long data)
+static void mem_timer(struct timer_list *t)
 {
-	struct qib_ibdev *dev = (struct qib_ibdev *) data;
+	struct qib_ibdev *dev = from_timer(dev, t, mem_timer);
 	struct list_head *list = &dev->memwait;
 	struct rvt_qp *qp = NULL;
 	struct qib_qp_priv *priv = NULL;
@@ -1532,7 +1532,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 		init_ibport(ppd + i);
 
 	/* Only need to initialize non-zero fields. */
-	setup_timer(&dev->mem_timer, mem_timer, (unsigned long)dev);
+	timer_setup(&dev->mem_timer, mem_timer, 0);
 
 	INIT_LIST_HEAD(&dev->piowait);
 	INIT_LIST_HEAD(&dev->dmawait);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
