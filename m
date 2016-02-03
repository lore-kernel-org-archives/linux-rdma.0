From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 38/54] staging/rdma/hfi1: Implement LED beaconing for
 maintenance
Date: Wed, 03 Feb 2016 14:35:57 -0800
Message-ID: <20160203223554.5923.10838.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch implements LED beaconing for maintenance. A MAD packet with
the LEDInfo attribute set to 1 will enable LED beaconing with a duty
cycle of 2s on and 1.5s off. A MAD packet with the LEDInfo attribute
set to 0 will disable beaconing and return the LED to normal operation.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |   81 +++++++++++++++++-------------------
 drivers/staging/rdma/hfi1/hfi.h    |   29 +++++++------
 drivers/staging/rdma/hfi1/init.c   |    6 ++-
 drivers/staging/rdma/hfi1/mad.c    |    9 +++-
 4 files changed, 64 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 59ce85f..5d012fe 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -1172,63 +1172,64 @@ int hfi1_set_lid(struct hfi1_pportdata *ppd, u32 lid, u8 lmc)
 	return 0;
 }
 
-/*
- * Following deal with the "obviously simple" task of overriding the state
- * of the LEDs, which normally indicate link physical and logical status.
- * The complications arise in dealing with different hardware mappings
- * and the board-dependent routine being called from interrupts.
- * and then there's the requirement to _flash_ them.
- */
-#define LED_OVER_FREQ_SHIFT 8
-#define LED_OVER_FREQ_MASK (0xFF<<LED_OVER_FREQ_SHIFT)
-/* Below is "non-zero" to force override, but both actual LEDs are off */
-#define LED_OVER_BOTH_OFF (8)
+void shutdown_led_override(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+
+	if (atomic_read(&ppd->led_override_timer_active)) {
+		del_timer_sync(&ppd->led_override_timer);
+		atomic_set(&ppd->led_override_timer_active, 0);
+	}
+
+	/* Shut off LEDs after we are sure timer is not running */
+	setextled(dd, 0);
+}
 
 static void run_led_override(unsigned long opaque)
 {
 	struct hfi1_pportdata *ppd = (struct hfi1_pportdata *)opaque;
 	struct hfi1_devdata *dd = ppd->dd;
-	int timeoff;
-	int ph_idx;
+	unsigned long timeout;
+	int phase_idx;
 
 	if (!(dd->flags & HFI1_INITTED))
 		return;
 
-	ph_idx = ppd->led_override_phase++ & 1;
-	ppd->led_override = ppd->led_override_vals[ph_idx];
-	timeoff = ppd->led_override_timeoff;
+	phase_idx = ppd->led_override_phase & 1;
+	setextled(dd, phase_idx);
+
+	timeout = ppd->led_override_vals[phase_idx];
+	/* Set up for next phase */
+	ppd->led_override_phase = !ppd->led_override_phase;
 
 	/*
 	 * don't re-fire the timer if user asked for it to be off; we let
 	 * it fire one more time after they turn it off to simplify
 	 */
 	if (ppd->led_override_vals[0] || ppd->led_override_vals[1])
-		mod_timer(&ppd->led_override_timer, jiffies + timeoff);
+		mod_timer(&ppd->led_override_timer, jiffies + timeout);
+	else
+		/* Hand control of the LED to the DC for normal operation */
+		write_csr(dd, DCC_CFG_LED_CNTRL, 0);
 }
 
-void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int val)
+/*
+ * To have the LED blink in a particular pattern, provide timeon and timeoff
+ * in milliseconds. To turn off custom blinking and return to normal operation,
+ * provide timeon = timeoff = 0.
+ */
+void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
+			   unsigned int timeoff)
 {
 	struct hfi1_devdata *dd = ppd->dd;
-	int timeoff, freq;
 
 	if (!(dd->flags & HFI1_INITTED))
 		return;
 
-	/* First check if we are blinking. If not, use 1HZ polling */
-	timeoff = HZ;
-	freq = (val & LED_OVER_FREQ_MASK) >> LED_OVER_FREQ_SHIFT;
-
-	if (freq) {
-		/* For blink, set each phase from one nybble of val */
-		ppd->led_override_vals[0] = val & 0xF;
-		ppd->led_override_vals[1] = (val >> 4) & 0xF;
-		timeoff = (HZ << 4)/freq;
-	} else {
-		/* Non-blink set both phases the same. */
-		ppd->led_override_vals[0] = val & 0xF;
-		ppd->led_override_vals[1] = val & 0xF;
-	}
-	ppd->led_override_timeoff = timeoff;
+	/* Convert to jiffies for direct use in timer */
+	ppd->led_override_vals[0] = msecs_to_jiffies(timeoff);
+	ppd->led_override_vals[1] = msecs_to_jiffies(timeon);
+	ppd->led_override_phase = 1; /* Arbitrarily start from LED on phase */
 
 	/*
 	 * If the timer has not already been started, do so. Use a "quick"
@@ -1293,14 +1294,8 @@ int hfi1_reset_device(int unit)
 
 	for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 		ppd = dd->pport + pidx;
-		if (atomic_read(&ppd->led_override_timer_active)) {
-			/* Need to stop LED timer, _then_ shut off LEDs */
-			del_timer_sync(&ppd->led_override_timer);
-			atomic_set(&ppd->led_override_timer_active, 0);
-		}
 
-		/* Shut off LEDs after we are sure timer is not running */
-		ppd->led_override = LED_OVER_BOTH_OFF;
+		shutdown_led_override(ppd);
 	}
 	if (dd->flags & HFI1_HAS_SEND_DMA)
 		sdma_exit(dd);
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index da42991..18508c9 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -7,7 +7,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -20,7 +20,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -669,14 +669,17 @@ struct hfi1_pportdata {
 	u8 overrun_threshold;
 	u8 phy_error_threshold;
 
-	/* used to override LED behavior */
-	u8 led_override;  /* Substituted for normal value, if non-zero */
-	u16 led_override_timeoff; /* delta to next timer event */
-	u8 led_override_vals[2]; /* Alternates per blink-frame */
-	u8 led_override_phase; /* Just counts, LSB picks from vals[] */
+	/* Used to override LED behavior for things like maintenance beaconing*/
+	/*
+	 * Alternates per phase of blink
+	 * [0] holds LED off duration, [1] holds LED on duration
+	 */
+	unsigned long led_override_vals[2];
+	u8 led_override_phase; /* LSB picks from vals[] */
 	atomic_t led_override_timer_active;
 	/* Used to flash LEDs in override mode */
 	struct timer_list led_override_timer;
+
 	u32 sm_trap_qp;
 	u32 sa_qp;
 
@@ -1599,14 +1602,14 @@ void hfi1_free_devdata(struct hfi1_devdata *);
 void cc_state_reclaim(struct rcu_head *rcu);
 struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra);
 
+void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int timeon,
+			   unsigned int timeoff);
 /*
- * Set LED override, only the two LSBs have "public" meaning, but
- * any non-zero value substitutes them for the Link and LinkTrain
- * LED states.
+ * Only to be used for driver unload or device reset where we cannot allow
+ * the timer to fire even the one extra time, else use hfi1_set_led_override
+ * with timeon = timeoff = 0
  */
-#define HFI1_LED_PHYS 1 /* Physical (linktraining) GREEN LED */
-#define HFI1_LED_LOG 2  /* Logical (link) YELLOW LED */
-void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int val);
+void shutdown_led_override(struct hfi1_pportdata *ppd);
 
 #define HFI1_CREDIT_RETURN_RATE (100)
 
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index eec9130..fe5e1e5 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -908,6 +908,8 @@ static void shutdown_device(struct hfi1_devdata *dd)
 		/* disable the send device */
 		pio_send_control(dd, PSC_GLOBAL_DISABLE);
 
+		shutdown_led_override(ppd);
+
 		/*
 		 * Clear SerdesEnable.
 		 * We can't count on interrupts since we are stopping.
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 5146f5d..6976f93 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,7 +18,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2015 Intel Corporation.
+ * Copyright(c) 2015, 2016 Intel Corporation.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -3449,7 +3449,10 @@ static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	setextled(dd, on);
+	if (on)
+		hfi1_set_led_override(dd->pport, 2000, 1500);
+	else
+		hfi1_set_led_override(dd->pport, 0, 0);
 
 	return __subn_get_opa_led_info(smp, am, data, ibdev, port, resp_len);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
