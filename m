From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 40/54] staging/rdma/hfi1: Correct TWSI reset
Date: Wed, 03 Feb 2016 14:36:14 -0800
Message-ID: <20160203223611.5923.573.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pablo Cacho <pablo.cacho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change the TWSI reset function so it will stop the reset
once the lines are in an expected state.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Pablo Cacho <pablo.cacho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qsfp.c |   10 ++----
 drivers/staging/rdma/hfi1/twsi.c |   64 +++++++++++++++++---------------------
 drivers/staging/rdma/hfi1/twsi.h |    7 ++--
 3 files changed, 36 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 0e1a492..c9d1e64 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
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
@@ -106,7 +106,6 @@ int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	if (ret) {
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "I2C write interface reset failed\n");
-		ret = -EIO;
 		goto done;
 	}
 
@@ -179,7 +178,6 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	if (ret) {
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "I2C read interface reset failed\n");
-		ret = -EIO;
 		goto done;
 	}
 
@@ -213,7 +211,7 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "QSFP write interface reset failed\n");
 		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
-		return -EIO;
+		return ret;
 	}
 
 	while (count < len) {
@@ -279,7 +277,7 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "QSFP read interface reset failed\n");
 		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
-		return -EIO;
+		return ret;
 	}
 
 	while (count < len) {
diff --git a/drivers/staging/rdma/hfi1/twsi.c b/drivers/staging/rdma/hfi1/twsi.c
index 7c579b3..d7dfdd2 100644
--- a/drivers/staging/rdma/hfi1/twsi.c
+++ b/drivers/staging/rdma/hfi1/twsi.c
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
@@ -136,6 +136,19 @@ static void scl_out(struct hfi1_devdata *dd, u32 target, u8 bit)
 	i2c_wait_for_writes(dd, target);
 }
 
+static u8 scl_in(struct hfi1_devdata *dd, u32 target, int wait)
+{
+	u32 read_val, mask;
+
+	mask = QSFP_HFI0_I2CCLK;
+	/* SCL is meant to be bare-drain, so never set "OUT", just DIR */
+	hfi1_gpio_mod(dd, target, 0, 0, mask);
+	read_val = hfi1_gpio_mod(dd, target, 0, 0, 0);
+	if (wait)
+		i2c_wait_for_writes(dd, target);
+	return (read_val & mask) >> GPIO_SCL_NUM;
+}
+
 static void sda_out(struct hfi1_devdata *dd, u32 target, u8 bit)
 {
 	u32 mask;
@@ -274,13 +287,12 @@ static void stop_cmd(struct hfi1_devdata *dd, u32 target)
 /**
  * hfi1_twsi_reset - reset I2C communication
  * @dd: the hfi1_ib device
+ * returns 0 if ok, -EIO on error
  */
-
 int hfi1_twsi_reset(struct hfi1_devdata *dd, u32 target)
 {
 	int clock_cycles_left = 9;
-	int was_high = 0;
-	u32 pins, mask;
+	u32 mask;
 
 	/* Both SCL and SDA should be high. If not, there
 	 * is something wrong.
@@ -294,43 +306,23 @@ int hfi1_twsi_reset(struct hfi1_devdata *dd, u32 target)
 	 */
 	hfi1_gpio_mod(dd, target, 0, 0, mask);
 
-	/*
-	 * Clock nine times to get all listeners into a sane state.
-	 * If SDA does not go high at any point, we are wedged.
-	 * One vendor recommends then issuing START followed by STOP.
-	 * we cannot use our "normal" functions to do that, because
-	 * if SCL drops between them, another vendor's part will
-	 * wedge, dropping SDA and keeping it low forever, at the end of
-	 * the next transaction (even if it was not the device addressed).
-	 * So our START and STOP take place with SCL held high.
+	/* Check if SCL is low, if it is low then we have a slave device
+	 * misbehaving and there is not much we can do.
+	 */
+	if (!scl_in(dd, target, 0))
+		return -EIO;
+
+	/* Check if SDA is low, if it is low then we have to clock SDA
+	 * up to 9 times for the device to release the bus
 	 */
 	while (clock_cycles_left--) {
+		if (sda_in(dd, target, 0))
+			return 0;
 		scl_out(dd, target, 0);
 		scl_out(dd, target, 1);
-		/* Note if SDA is high, but keep clocking to sync slave */
-		was_high |= sda_in(dd, target, 0);
-	}
-
-	if (was_high) {
-		/*
-		 * We saw a high, which we hope means the slave is sync'd.
-		 * Issue START, STOP, pause for T_BUF.
-		 */
-
-		pins = hfi1_gpio_mod(dd, target, 0, 0, 0);
-		if ((pins & mask) != mask)
-			dd_dev_err(dd, "GPIO pins not at rest: %d\n",
-				    pins & mask);
-		/* Drop SDA to issue START */
-		udelay(1); /* Guarantee .6 uSec setup */
-		sda_out(dd, target, 0);
-		udelay(1); /* Guarantee .6 uSec hold */
-		/* At this point, SCL is high, SDA low. Raise SDA for STOP */
-		sda_out(dd, target, 1);
-		udelay(TWSI_BUF_WAIT_USEC);
 	}
 
-	return !was_high;
+	return -EIO;
 }
 
 #define HFI1_TWSI_START 0x100
diff --git a/drivers/staging/rdma/hfi1/twsi.h b/drivers/staging/rdma/hfi1/twsi.h
index 5907e02..6cb30e5 100644
--- a/drivers/staging/rdma/hfi1/twsi.h
+++ b/drivers/staging/rdma/hfi1/twsi.h
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
@@ -54,8 +54,9 @@
 
 struct hfi1_devdata;
 
-/* Bit position of SDA pin in ASIC_QSFP* registers  */
+/* Bit position of SDA/SCL pins in ASIC_QSFP* registers  */
 #define  GPIO_SDA_NUM 1
+#define  GPIO_SCL_NUM 0
 
 /* these functions must be called with qsfp_lock held */
 int hfi1_twsi_reset(struct hfi1_devdata *dd, u32 target);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
