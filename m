From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/10] IB/hfi1: Improve LED beaconing
Date: Mon, 07 Mar 2016 11:35:03 -0800
Message-ID: <20160307193502.4913.56224.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The current LED beaconing code is unclear and uses the timer handler to
turn off the timer. This patch simplifies the code by removing the
special semantics of timeon = timeoff = 0 being interpreted as a request
to turn off the beaconing.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |   59 +++++++++++++++--------------------
 drivers/infiniband/hw/hfi1/hfi.h    |   10 ++----
 drivers/infiniband/hw/hfi1/mad.c    |   20 ++++++------
 3 files changed, 38 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 4581864..914beed 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1170,18 +1170,20 @@ void shutdown_led_override(struct hfi1_pportdata *ppd)
 	struct hfi1_devdata *dd = ppd->dd;
 
 	/*
-	 * This pairs with the memory barrier implied by the atomic_dec in
-	 * hfi1_set_led_override to ensure that we read the correct state of
-	 * LED beaconing represented by led_override_timer_active
+	 * This pairs with the memory barrier in hfi1_start_led_override to
+	 * ensure that we read the correct state of LED beaconing represented
+	 * by led_override_timer_active
 	 */
-	smp_mb();
+	smp_rmb();
 	if (atomic_read(&ppd->led_override_timer_active)) {
 		del_timer_sync(&ppd->led_override_timer);
 		atomic_set(&ppd->led_override_timer_active, 0);
+		/* Ensure the atomic_set is visible to all CPUs */
+		smp_wmb();
 	}
 
-	/* Shut off LEDs after we are sure timer is not running */
-	setextled(dd, 0);
+	/* Hand control of the LED to the DC for normal operation */
+	write_csr(dd, DCC_CFG_LED_CNTRL, 0);
 }
 
 static void run_led_override(unsigned long opaque)
@@ -1195,59 +1197,48 @@ static void run_led_override(unsigned long opaque)
 		return;
 
 	phase_idx = ppd->led_override_phase & 1;
+
 	setextled(dd, phase_idx);
 
 	timeout = ppd->led_override_vals[phase_idx];
+
 	/* Set up for next phase */
 	ppd->led_override_phase = !ppd->led_override_phase;
 
-	/*
-	 * don't re-fire the timer if user asked for it to be off; we let
-	 * it fire one more time after they turn it off to simplify
-	 */
-	if (ppd->led_override_vals[0] || ppd->led_override_vals[1]) {
-		mod_timer(&ppd->led_override_timer, jiffies + timeout);
-	} else {
-		/* Hand control of the LED to the DC for normal operation */
-		write_csr(dd, DCC_CFG_LED_CNTRL, 0);
-		/* Record that we did not re-fire the timer */
-		atomic_dec(&ppd->led_override_timer_active);
-	}
+	mod_timer(&ppd->led_override_timer, jiffies + timeout);
 }
 
 /*
  * To have the LED blink in a particular pattern, provide timeon and timeoff
- * in milliseconds. To turn off custom blinking and return to normal operation,
- * provide timeon = timeoff = 0.
+ * in milliseconds.
+ * To turn off custom blinking and return to normal operation, use
+ * shutdown_led_override()
  */
-void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
-			   unsigned int timeoff)
+void hfi1_start_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
+			     unsigned int timeoff)
 {
-	struct hfi1_devdata *dd = ppd->dd;
-
-	if (!(dd->flags & HFI1_INITTED))
+	if (!(ppd->dd->flags & HFI1_INITTED))
 		return;
 
 	/* Convert to jiffies for direct use in timer */
 	ppd->led_override_vals[0] = msecs_to_jiffies(timeoff);
 	ppd->led_override_vals[1] = msecs_to_jiffies(timeon);
-	ppd->led_override_phase = 1; /* Arbitrarily start from LED on phase */
+
+	/* Arbitrarily start from LED on phase */
+	ppd->led_override_phase = 1;
 
 	/*
 	 * If the timer has not already been started, do so. Use a "quick"
-	 * timeout so the function will be called soon, to look at our request.
+	 * timeout so the handler will be called soon to look at our request.
 	 */
-	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
-		/* Need to start timer */
+	if (!timer_pending(&ppd->led_override_timer)) {
 		setup_timer(&ppd->led_override_timer, run_led_override,
 			    (unsigned long)ppd);
-
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
-	} else {
-		if (ppd->led_override_vals[0] || ppd->led_override_vals[1])
-			mod_timer(&ppd->led_override_timer, jiffies + 1);
-		atomic_dec(&ppd->led_override_timer_active);
+		atomic_set(&ppd->led_override_timer_active, 1);
+		/* Ensure the atomic_set is visible to all CPUs */
+		smp_wmb();
 	}
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 035a151..5722883 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1623,13 +1623,9 @@ void hfi1_free_devdata(struct hfi1_devdata *);
 void cc_state_reclaim(struct rcu_head *rcu);
 struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra);
 
-void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
-			   unsigned int timeoff);
-/*
- * Only to be used for driver unload or device reset where we cannot allow
- * the timer to fire even the one extra time, else use hfi1_set_led_override
- * with timeon = timeoff = 0
- */
+/* LED beaconing functions */
+void hfi1_start_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
+			     unsigned int timeoff);
 void shutdown_led_override(struct hfi1_pportdata *ppd);
 
 #define HFI1_CREDIT_RETURN_RATE (100)
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 5925798..0ec748e 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -583,11 +583,11 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	pi->port_states.ledenable_offlinereason |=
 		ppd->is_sm_config_started << 5;
 	/*
-	 * This pairs with the memory barrier implied by the atomic_dec in
-	 * hfi1_set_led_override to ensure that we read the correct state of
-	 * LED beaconing represented by led_override_timer_active
+	 * This pairs with the memory barrier in hfi1_start_led_override to
+	 * ensure that we read the correct state of LED beaconing represented
+	 * by led_override_timer_active
 	 */
-	smp_mb();
+	smp_rmb();
 	is_beaconing_active = !!atomic_read(&ppd->led_override_timer_active);
 	pi->port_states.ledenable_offlinereason |= is_beaconing_active << 6;
 	pi->port_states.ledenable_offlinereason |=
@@ -3598,11 +3598,11 @@ static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 	}
 
 	/*
-	 * This pairs with the memory barrier implied by the atomic_dec in
-	 * hfi1_set_led_override to ensure that we read the correct state of
-	 * LED beaconing represented by led_override_timer_active
+	 * This pairs with the memory barrier in hfi1_start_led_override to
+	 * ensure that we read the correct state of LED beaconing represented
+	 * by led_override_timer_active
 	 */
-	smp_mb();
+	smp_rmb();
 	is_beaconing_active = !!atomic_read(&ppd->led_override_timer_active);
 	p->rsvd_led_mask = cpu_to_be32(is_beaconing_active << OPA_LED_SHIFT);
 
@@ -3627,9 +3627,9 @@ static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 	}
 
 	if (on)
-		hfi1_set_led_override(dd->pport, 2000, 1500);
+		hfi1_start_led_override(dd->pport, 2000, 1500);
 	else
-		hfi1_set_led_override(dd->pport, 0, 0);
+		shutdown_led_override(dd->pport);
 
 	return __subn_get_opa_led_info(smp, am, data, ibdev, port, resp_len);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
