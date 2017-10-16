From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] IB/hfi1: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 15:51:54 -0700
Message-ID: <20171016225154.GA98893@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. Switches test of .data field to
.function, since .data will be going away.

Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/aspm.h   |  7 +++----
 drivers/infiniband/hw/hfi1/chip.c   | 19 ++++++++-----------
 drivers/infiniband/hw/hfi1/driver.c |  7 +++----
 drivers/infiniband/hw/hfi1/init.c   |  2 +-
 drivers/infiniband/hw/hfi1/mad.c    |  4 ++--
 drivers/infiniband/hw/hfi1/mad.h    |  2 +-
 drivers/infiniband/hw/hfi1/sdma.c   |  8 ++++----
 drivers/infiniband/hw/hfi1/verbs.c  |  9 ++++-----
 8 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/aspm.h b/drivers/infiniband/hw/hfi1/aspm.h
index 522b40ed9937..e8133870ee87 100644
--- a/drivers/infiniband/hw/hfi1/aspm.h
+++ b/drivers/infiniband/hw/hfi1/aspm.h
@@ -218,9 +218,9 @@ static inline void aspm_ctx_disable(struct hfi1_ctxtdata *rcd)
 }
 
 /* Timer function for re-enabling ASPM in the absence of interrupt activity */
-static inline void aspm_ctx_timer_function(unsigned long data)
+static inline void aspm_ctx_timer_function(struct timer_list *t)
 {
-	struct hfi1_ctxtdata *rcd = (struct hfi1_ctxtdata *)data;
+	struct hfi1_ctxtdata *rcd = from_timer(rcd, t, aspm_timer);
 	unsigned long flags;
 
 	spin_lock_irqsave(&rcd->aspm_lock, flags);
@@ -281,8 +281,7 @@ static inline void aspm_enable_all(struct hfi1_devdata *dd)
 static inline void aspm_ctx_init(struct hfi1_ctxtdata *rcd)
 {
 	spin_lock_init(&rcd->aspm_lock);
-	setup_timer(&rcd->aspm_timer, aspm_ctx_timer_function,
-		    (unsigned long)rcd);
+	timer_setup(&rcd->aspm_timer, aspm_ctx_timer_function, 0);
 	rcd->aspm_intr_supported = rcd->dd->aspm_supported &&
 		aspm_mode == ASPM_MODE_DYNAMIC &&
 		rcd->ctxt < rcd->dd->first_dyn_alloc_ctxt;
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index d2d72e07b924..7d7b17047f6f 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5538,9 +5538,9 @@ static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
  * associated with them.
  */
 #define RCVERR_CHECK_TIME 10
-static void update_rcverr_timer(unsigned long opaque)
+static void update_rcverr_timer(struct timer_list *t)
 {
-	struct hfi1_devdata *dd = (struct hfi1_devdata *)opaque;
+	struct hfi1_devdata *dd = from_timer(dd, t, rcverr_timer);
 	struct hfi1_pportdata *ppd = dd->pport;
 	u32 cur_ovfl_cnt = read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL);
 
@@ -5559,7 +5559,7 @@ static void update_rcverr_timer(unsigned long opaque)
 
 static int init_rcverr(struct hfi1_devdata *dd)
 {
-	setup_timer(&dd->rcverr_timer, update_rcverr_timer, (unsigned long)dd);
+	timer_setup(&dd->rcverr_timer, update_rcverr_timer, 0);
 	/* Assume the hardware counter has been reset */
 	dd->rcv_ovfl_cnt = 0;
 	return mod_timer(&dd->rcverr_timer, jiffies + HZ * RCVERR_CHECK_TIME);
@@ -5567,9 +5567,8 @@ static int init_rcverr(struct hfi1_devdata *dd)
 
 static void free_rcverr(struct hfi1_devdata *dd)
 {
-	if (dd->rcverr_timer.data)
+	if (dd->rcverr_timer.function)
 		del_timer_sync(&dd->rcverr_timer);
-	dd->rcverr_timer.data = 0;
 }
 
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
@@ -12122,9 +12121,8 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	struct hfi1_pportdata *ppd;
 	int i;
 
-	if (dd->synth_stats_timer.data)
+	if (dd->synth_stats_timer.function)
 		del_timer_sync(&dd->synth_stats_timer);
-	dd->synth_stats_timer.data = 0;
 	ppd = (struct hfi1_pportdata *)(dd + 1);
 	for (i = 0; i < dd->num_pports; i++, ppd++) {
 		kfree(ppd->cntrs);
@@ -12400,9 +12398,9 @@ static void do_update_synth_timer(struct work_struct *work)
 	}
 }
 
-static void update_synth_timer(unsigned long opaque)
+static void update_synth_timer(struct timer_list *t)
 {
-	struct hfi1_devdata *dd = (struct hfi1_devdata *)opaque;
+	struct hfi1_devdata *dd = from_timer(dd, t, synth_stats_timer);
 
 	queue_work(dd->update_cntr_wq, &dd->update_cntr_work);
 	mod_timer(&dd->synth_stats_timer, jiffies + HZ * SYNTH_CNT_TIME);
@@ -12420,8 +12418,7 @@ static int init_cntrs(struct hfi1_devdata *dd)
 	const int bit_type_32_sz = strlen(bit_type_32);
 
 	/* set up the stats timer; the add_timer is done at the end */
-	setup_timer(&dd->synth_stats_timer, update_synth_timer,
-		    (unsigned long)dd);
+	timer_setup(&dd->synth_stats_timer, update_synth_timer, 0);
 
 	/***********************/
 	/* per device counters */
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 85a425ef740e..880a0e75ad0a 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1252,9 +1252,9 @@ void shutdown_led_override(struct hfi1_pportdata *ppd)
 	write_csr(dd, DCC_CFG_LED_CNTRL, 0);
 }
 
-static void run_led_override(unsigned long opaque)
+static void run_led_override(struct timer_list *t)
 {
-	struct hfi1_pportdata *ppd = (struct hfi1_pportdata *)opaque;
+	struct hfi1_pportdata *ppd = from_timer(ppd, t, led_override_timer);
 	struct hfi1_devdata *dd = ppd->dd;
 	unsigned long timeout;
 	int phase_idx;
@@ -1298,8 +1298,7 @@ void hfi1_start_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
 	 * timeout so the handler will be called soon to look at our request.
 	 */
 	if (!timer_pending(&ppd->led_override_timer)) {
-		setup_timer(&ppd->led_override_timer, run_led_override,
-			    (unsigned long)ppd);
+		timer_setup(&ppd->led_override_timer, run_led_override, 0);
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
 		atomic_set(&ppd->led_override_timer_active, 1);
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 36c8a4ae8278..b5c2efce73f2 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1025,7 +1025,7 @@ static void stop_timers(struct hfi1_devdata *dd)
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
-		if (ppd->led_override_timer.data) {
+		if (ppd->led_override_timer.function) {
 			del_timer_sync(&ppd->led_override_timer);
 			atomic_set(&ppd->led_override_timer_active, 0);
 		}
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 07b80faf1675..081fb5f4cff3 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -399,9 +399,9 @@ static void send_trap(struct hfi1_ibport *ibp, struct trap_node *trap)
 		ib_free_send_mad(send_buf);
 }
 
-void hfi1_handle_trap_timer(unsigned long data)
+void hfi1_handle_trap_timer(struct timer_list *t)
 {
-	struct hfi1_ibport *ibp = (struct hfi1_ibport *)data;
+	struct hfi1_ibport *ibp = from_timer(ibp, t, rvp.trap_timer);
 	struct trap_node *trap = NULL;
 	unsigned long flags;
 	int i;
diff --git a/drivers/infiniband/hw/hfi1/mad.h b/drivers/infiniband/hw/hfi1/mad.h
index 4c1245072093..a4f8ac16332c 100644
--- a/drivers/infiniband/hw/hfi1/mad.h
+++ b/drivers/infiniband/hw/hfi1/mad.h
@@ -428,6 +428,6 @@ struct sc2vlnt {
 		    COUNTER_MASK(1, 4))
 
 void hfi1_event_pkey_change(struct hfi1_devdata *dd, u8 port);
-void hfi1_handle_trap_timer(unsigned long data);
+void hfi1_handle_trap_timer(struct timer_list *t);
 
 #endif				/* _HFI1_MAD_H */
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index e7df7794c97e..dabd71495b1b 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -491,10 +491,10 @@ static void sdma_err_progress_check_schedule(struct sdma_engine *sde)
 	}
 }
 
-static void sdma_err_progress_check(unsigned long data)
+static void sdma_err_progress_check(struct timer_list *t)
 {
 	unsigned index;
-	struct sdma_engine *sde = (struct sdma_engine *)data;
+	struct sdma_engine *sde = from_timer(sde, t, err_progress_check_timer);
 
 	dd_dev_err(sde->dd, "SDE progress check event\n");
 	for (index = 0; index < sde->dd->num_sdma; index++) {
@@ -1453,8 +1453,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 
 		sde->progress_check_head = 0;
 
-		setup_timer(&sde->err_progress_check_timer,
-			    sdma_err_progress_check, (unsigned long)sde);
+		timer_setup(&sde->err_progress_check_timer,
+			    sdma_err_progress_check, 0);
 
 		sde->descq = dma_zalloc_coherent(
 			&dd->pcidev->dev,
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index e232f3c608b4..038fe221c27f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -667,9 +667,9 @@ void hfi1_16B_rcv(struct hfi1_packet *packet)
  * This is called from a timer to check for QPs
  * which need kernel memory in order to send a packet.
  */
-static void mem_timer(unsigned long data)
+static void mem_timer(struct timer_list *t)
 {
-	struct hfi1_ibdev *dev = (struct hfi1_ibdev *)data;
+	struct hfi1_ibdev *dev = from_timer(dev, t, mem_timer);
 	struct list_head *list = &dev->memwait;
 	struct rvt_qp *qp = NULL;
 	struct iowait *wait;
@@ -1636,8 +1636,7 @@ static void init_ibport(struct hfi1_pportdata *ppd)
 
 	for (i = 0; i < RVT_MAX_TRAP_LISTS ; i++)
 		INIT_LIST_HEAD(&ibp->rvp.trap_lists[i].list);
-	setup_timer(&ibp->rvp.trap_timer, hfi1_handle_trap_timer,
-		    (unsigned long)ibp);
+	timer_setup(&ibp->rvp.trap_timer, hfi1_handle_trap_timer, 0);
 
 	spin_lock_init(&ibp->rvp.lock);
 	/* Set the prefix to the default value (see ch. 4.1.1) */
@@ -1844,7 +1843,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 
-	setup_timer(&dev->mem_timer, mem_timer, (unsigned long)dev);
+	timer_setup(&dev->mem_timer, mem_timer, 0);
 
 	seqlock_init(&dev->iowait_lock);
 	seqlock_init(&dev->txwait_lock);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
