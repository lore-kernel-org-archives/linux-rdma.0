From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/54] staging/rdma/hfi1: Add active and optical cable
 support
Date: Wed, 03 Feb 2016 14:31:14 -0800
Message-ID: <20160203223110.5923.43958.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brent R Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch qualifies and tunes active and optical cables for optimal
bit error rate and signal integrity settings. These settings are
fetched from the platform configuration data.

Based on attributes of the QSFP cable as read from the SFF-8636
compliant memory map, we select the appropriate settings from the
platform configuration data (examples: TX/RX equalization, enabling
cable high power, enabling TX/RX clock data recovery mechanisms, and RX
amplitude control) and apply them to the SERDES and QSFP cable.

The platform configuration data also contains system parameters such
as maximum power dissipation supported, and the cables are qualified
based on these parameters. As part of qualifying the cables, the
correct OfflineDisabledReasons are set for the appropriate scenarios.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Brent R Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile          |    2 
 drivers/staging/rdma/hfi1/chip.c            |  296 +++++-----
 drivers/staging/rdma/hfi1/chip.h            |    8 
 drivers/staging/rdma/hfi1/hfi.h             |    5 
 drivers/staging/rdma/hfi1/init.c            |   10 
 drivers/staging/rdma/hfi1/platform.c        |  838 +++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/platform.h        |   44 +
 drivers/staging/rdma/hfi1/qsfp.h            |    3 
 8 files changed, 1032 insertions(+), 174 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/platform.c
 rename drivers/staging/rdma/hfi1/{platform_config.h => platform.h} (91%)

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index ca2dea5..9b3f7e9 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -8,7 +8,7 @@
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
 hfi1-y := chip.o device.o diag.o driver.o efivar.o eprom.o file_ops.o firmware.o \
-	init.o intr.o mad.o pcie.o pio.o pio_copy.o \
+	init.o intr.o mad.o pcie.o pio.o pio_copy.o platform.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_exp_rcv.o user_pages.o user_sdma.o verbs.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 16e2ff2..4d70a96 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -64,6 +64,7 @@
 #include "sdma.h"
 #include "eprom.h"
 #include "efivar.h"
+#include "platform.h"
 
 #define NUM_IB_PORTS 1
 
@@ -5826,7 +5827,7 @@ static void is_various_int(struct hfi1_devdata *dd, unsigned int source)
 
 static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 {
-	/* source is always zero */
+	/* src_ctx is always zero */
 	struct hfi1_pportdata *ppd = dd->pport;
 	unsigned long flags;
 	u64 qsfp_int_mgmt = (u64)(QSFP_HFI0_INT_N | QSFP_HFI0_MODPRST_N);
@@ -5849,14 +5850,13 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 			 * an interrupt when a cable is inserted
 			 */
 			ppd->qsfp_info.cache_valid = 0;
-			ppd->qsfp_info.qsfp_interrupt_functional = 0;
+			ppd->qsfp_info.reset_needed = 0;
+			ppd->qsfp_info.limiting_active = 0;
 			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
 						flags);
-			write_csr(dd,
-					dd->hfi1_id ?
-						ASIC_QSFP2_INVERT :
-						ASIC_QSFP1_INVERT,
-				qsfp_int_mgmt);
+			/* Invert the ModPresent pin now to detect plug-in */
+			write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_INVERT :
+				  ASIC_QSFP1_INVERT, qsfp_int_mgmt);
 
 			if ((ppd->offline_disabled_reason >
 			  HFI1_ODR_MASK(
@@ -5883,12 +5883,16 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
 						flags);
 
+			/*
+			 * Stop inversion of ModPresent pin to detect
+			 * removal of the cable
+			 */
 			qsfp_int_mgmt &= ~(u64)QSFP_HFI0_MODPRST_N;
-			write_csr(dd,
-					dd->hfi1_id ?
-						ASIC_QSFP2_INVERT :
-						ASIC_QSFP1_INVERT,
-				qsfp_int_mgmt);
+			write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_INVERT :
+				  ASIC_QSFP1_INVERT, qsfp_int_mgmt);
+
+			ppd->offline_disabled_reason =
+				HFI1_ODR_MASK(OPA_LINKDOWN_REASON_TRANSIENT);
 		}
 	}
 
@@ -5898,7 +5902,6 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 				__func__);
 		spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 		ppd->qsfp_info.check_interrupt_flags = 1;
-		ppd->qsfp_info.qsfp_interrupt_functional = 1;
 		spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
 	}
 
@@ -6666,6 +6669,7 @@ void handle_link_up(struct work_struct *work)
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SPEED_POLICY, 0,
 			OPA_LINKDOWN_REASON_SPEED_POLICY);
 		set_link_state(ppd, HLS_DN_OFFLINE);
+		tune_serdes(ppd);
 		start_link(ppd);
 	}
 }
@@ -6691,7 +6695,13 @@ void handle_link_down(struct work_struct *work)
 	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
 								link_down_work);
 
-	/* go offline first, then deal with reasons */
+	if ((ppd->host_link_state &
+	     (HLS_DN_POLL | HLS_VERIFY_CAP | HLS_GOING_UP)) &&
+	     ppd->port_type == PORT_TYPE_FIXED)
+		ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NOT_INSTALLED);
+
+	/* Go offline first, then deal with reading/writing through 8051 */
 	set_link_state(ppd, HLS_DN_OFFLINE);
 
 	lcl_reason = 0;
@@ -6713,10 +6723,12 @@ void handle_link_down(struct work_struct *work)
 
 	/* If there is no cable attached, turn the DC off. Otherwise,
 	 * start the link bring up. */
-	if (!qsfp_mod_present(ppd))
+	if (!qsfp_mod_present(ppd)) {
 		dc_shutdown(ppd->dd);
-	else
+	} else {
+		tune_serdes(ppd);
 		start_link(ppd);
+	}
 }
 
 void handle_link_bounce(struct work_struct *work)
@@ -6729,6 +6741,7 @@ void handle_link_bounce(struct work_struct *work)
 	 */
 	if (ppd->host_link_state & HLS_UP) {
 		set_link_state(ppd, HLS_DN_OFFLINE);
+		tune_serdes(ppd);
 		start_link(ppd);
 	} else {
 		dd_dev_info(ppd->dd, "%s: link not up (%s), nothing to do\n",
@@ -7237,6 +7250,7 @@ done:
 		set_link_down_reason(ppd, OPA_LINKDOWN_REASON_WIDTH_POLICY, 0,
 		  OPA_LINKDOWN_REASON_WIDTH_POLICY);
 		set_link_state(ppd, HLS_DN_OFFLINE);
+		tune_serdes(ppd);
 		start_link(ppd);
 	}
 }
@@ -8235,8 +8249,8 @@ static int set_physical_link_state(struct hfi1_devdata *dd, u64 state)
 	return do_8051_command(dd, HCMD_CHANGE_PHY_STATE, state, NULL);
 }
 
-static int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
-			    u8 lane_id, u32 config_data)
+int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
+		     u8 lane_id, u32 config_data)
 {
 	u64 data;
 	int ret;
@@ -8258,8 +8272,8 @@ static int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
  * set the result, even on error.
  * Return 0 on success, -errno on failure
  */
-static int read_8051_config(struct hfi1_devdata *dd, u8 field_id, u8 lane_id,
-			    u32 *result)
+int read_8051_config(struct hfi1_devdata *dd, u8 field_id, u8 lane_id,
+		     u32 *result)
 {
 	u64 big_data;
 	u32 addr;
@@ -8881,32 +8895,80 @@ int start_link(struct hfi1_pportdata *ppd)
 	return -EAGAIN;
 }
 
-static void reset_qsfp(struct hfi1_pportdata *ppd)
+static void wait_for_qsfp_init(struct hfi1_pportdata *ppd)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 mask;
+	unsigned long timeout;
+
+	/*
+	 * Check for QSFP interrupt for t_init (SFF 8679)
+	 */
+	timeout = jiffies + msecs_to_jiffies(2000);
+	while (1) {
+		mask = read_csr(dd, dd->hfi1_id ?
+				ASIC_QSFP2_IN : ASIC_QSFP1_IN);
+		if (!(mask & QSFP_HFI0_INT_N)) {
+			write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_CLEAR :
+				  ASIC_QSFP1_CLEAR, QSFP_HFI0_INT_N);
+			break;
+		}
+		if (time_after(jiffies, timeout)) {
+			dd_dev_info(dd, "%s: No IntN detected, reset complete\n",
+				    __func__);
+			break;
+		}
+		udelay(2);
+	}
+}
+
+static void set_qsfp_int_n(struct hfi1_pportdata *ppd, u8 enable)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u64 mask;
+
+	mask = read_csr(dd, dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK);
+	if (enable)
+		mask |= (u64)QSFP_HFI0_INT_N;
+	else
+		mask &= ~(u64)QSFP_HFI0_INT_N;
+	write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK, mask);
+}
+
+void reset_qsfp(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 	u64 mask, qsfp_mask;
 
+	/* Disable INT_N from triggering QSFP interrupts */
+	set_qsfp_int_n(ppd, 0);
+
+	/* Reset the QSFP */
 	mask = (u64)QSFP_HFI0_RESET_N;
-	qsfp_mask = read_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE);
+	qsfp_mask = read_csr(dd, dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE);
 	qsfp_mask |= mask;
 	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE,
-		qsfp_mask);
+		dd->hfi1_id ? ASIC_QSFP2_OE : ASIC_QSFP1_OE, qsfp_mask);
 
-	qsfp_mask = read_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT);
+	qsfp_mask = read_csr(dd, dd->hfi1_id ?
+				ASIC_QSFP2_OUT : ASIC_QSFP1_OUT);
 	qsfp_mask &= ~mask;
 	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT,
-		qsfp_mask);
+		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT, qsfp_mask);
 
 	udelay(10);
 
 	qsfp_mask |= mask;
 	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT,
-		qsfp_mask);
+		dd->hfi1_id ? ASIC_QSFP2_OUT : ASIC_QSFP1_OUT, qsfp_mask);
+
+	wait_for_qsfp_init(ppd);
+
+	/*
+	 * Allow INT_N to trigger the QSFP interrupt to watch
+	 * for alarms and warnings
+	 */
+	set_qsfp_int_n(ppd, 1);
 }
 
 static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
@@ -9018,35 +9080,8 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 	return 0;
 }
 
-static int do_pre_lni_host_behaviors(struct hfi1_pportdata *ppd)
-{
-	refresh_qsfp_cache(ppd, &ppd->qsfp_info);
-
-	return 0;
-}
-
-static int do_qsfp_intr_fallback(struct hfi1_pportdata *ppd)
-{
-	struct hfi1_devdata *dd = ppd->dd;
-	u8 qsfp_interrupt_status = 0;
-
-	if (qsfp_read(ppd, dd->hfi1_id, 2, &qsfp_interrupt_status, 1)
-		!= 1) {
-		dd_dev_info(dd,
-			"%s: Failed to read status of QSFP module\n",
-			__func__);
-		return -EIO;
-	}
-
-	/* We don't care about alarms & warnings with a non-functional INT_N */
-	if (!(qsfp_interrupt_status & QSFP_DATA_NOT_READY))
-		do_pre_lni_host_behaviors(ppd);
-
-	return 0;
-}
-
 /* This routine will only be scheduled if the QSFP module is present */
-static void qsfp_event(struct work_struct *work)
+void qsfp_event(struct work_struct *work)
 {
 	struct qsfp_data *qd;
 	struct hfi1_pportdata *ppd;
@@ -9068,20 +9103,20 @@ static void qsfp_event(struct work_struct *work)
 	dc_start(dd);
 
 	if (qd->cache_refresh_required) {
-		msleep(3000);
-		reset_qsfp(ppd);
 
-		/* Check for QSFP interrupt after t_init (SFF 8679)
-		 * + extra
+		set_qsfp_int_n(ppd, 0);
+
+		wait_for_qsfp_init(ppd);
+
+		/*
+		 * Allow INT_N to trigger the QSFP interrupt to watch
+		 * for alarms and warnings
 		 */
-		msleep(3000);
-		if (!qd->qsfp_interrupt_functional) {
-			if (do_qsfp_intr_fallback(ppd) < 0)
-				dd_dev_info(dd, "%s: QSFP fallback failed\n",
-					__func__);
-			ppd->driver_link_ready = 1;
-			start_link(ppd);
-		}
+		set_qsfp_int_n(ppd, 1);
+
+		tune_serdes(ppd);
+
+		start_link(ppd);
 	}
 
 	if (qd->check_interrupt_flags) {
@@ -9094,50 +9129,50 @@ static void qsfp_event(struct work_struct *work)
 				__func__);
 		} else {
 			unsigned long flags;
-			u8 data_status;
 
+			handle_qsfp_error_conditions(
+					ppd, qsfp_interrupt_status);
 			spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 			ppd->qsfp_info.check_interrupt_flags = 0;
 			spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock,
 								flags);
-
-			if (qsfp_read(ppd, dd->hfi1_id, 2, &data_status, 1)
-				 != 1) {
-				dd_dev_info(dd,
-				"%s: Failed to read status of QSFP module\n",
-					__func__);
-			}
-			if (!(data_status & QSFP_DATA_NOT_READY)) {
-				do_pre_lni_host_behaviors(ppd);
-				start_link(ppd);
-			} else
-				handle_qsfp_error_conditions(ppd,
-						qsfp_interrupt_status);
 		}
 	}
 }
 
-void init_qsfp(struct hfi1_pportdata *ppd)
+static void init_qsfp_int(struct hfi1_devdata *dd)
 {
-	struct hfi1_devdata *dd = ppd->dd;
-	u64 qsfp_mask;
+	struct hfi1_pportdata *ppd = dd->pport;
+	u64 qsfp_mask, cce_int_mask;
+	const int qsfp1_int_smask = QSFP1_INT % 64;
+	const int qsfp2_int_smask = QSFP2_INT % 64;
 
-	if (loopback == LOOPBACK_SERDES || loopback == LOOPBACK_LCB ||
-			ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
-		ppd->driver_link_ready = 1;
-		return;
+	/*
+	 * disable QSFP1 interrupts for HFI1, QSFP2 interrupts for HFI0
+	 * Qsfp1Int and Qsfp2Int are adjacent bits in the same CSR,
+	 * therefore just one of QSFP1_INT/QSFP2_INT can be used to find
+	 * the index of the appropriate CSR in the CCEIntMask CSR array
+	 */
+	cce_int_mask = read_csr(dd, CCE_INT_MASK +
+				(8 * (QSFP1_INT / 64)));
+	if (dd->hfi1_id) {
+		cce_int_mask &= ~((u64)1 << qsfp1_int_smask);
+		write_csr(dd, CCE_INT_MASK + (8 * (QSFP1_INT / 64)),
+			  cce_int_mask);
+	} else {
+		cce_int_mask &= ~((u64)1 << qsfp2_int_smask);
+		write_csr(dd, CCE_INT_MASK + (8 * (QSFP2_INT / 64)),
+			  cce_int_mask);
 	}
 
-	ppd->qsfp_info.ppd = ppd;
-	INIT_WORK(&ppd->qsfp_info.qsfp_work, qsfp_event);
-
 	qsfp_mask = (u64)(QSFP_HFI0_INT_N | QSFP_HFI0_MODPRST_N);
 	/* Clear current status to avoid spurious interrupts */
-	write_csr(dd,
-			dd->hfi1_id ?
-				ASIC_QSFP2_CLEAR :
-				ASIC_QSFP1_CLEAR,
-		qsfp_mask);
+	write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_CLEAR : ASIC_QSFP1_CLEAR,
+		  qsfp_mask);
+	write_csr(dd, dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK,
+		  qsfp_mask);
+
+	set_qsfp_int_n(ppd, 0);
 
 	/* Handle active low nature of INT_N and MODPRST_N pins */
 	if (qsfp_mod_present(ppd))
@@ -9145,29 +9180,6 @@ void init_qsfp(struct hfi1_pportdata *ppd)
 	write_csr(dd,
 		  dd->hfi1_id ? ASIC_QSFP2_INVERT : ASIC_QSFP1_INVERT,
 		  qsfp_mask);
-
-	/* Allow only INT_N and MODPRST_N to trigger QSFP interrupts */
-	qsfp_mask |= (u64)QSFP_HFI0_MODPRST_N;
-	write_csr(dd,
-		dd->hfi1_id ? ASIC_QSFP2_MASK : ASIC_QSFP1_MASK,
-		qsfp_mask);
-
-	if (qsfp_mod_present(ppd)) {
-		msleep(3000);
-		reset_qsfp(ppd);
-
-		/* Check for QSFP interrupt after t_init (SFF 8679)
-		 * + extra
-		 */
-		msleep(3000);
-		if (!ppd->qsfp_info.qsfp_interrupt_functional) {
-			if (do_qsfp_intr_fallback(ppd) < 0)
-				dd_dev_info(dd,
-					"%s: QSFP fallback failed\n",
-					__func__);
-			ppd->driver_link_ready = 1;
-		}
-	}
 }
 
 /*
@@ -9203,8 +9215,6 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
 		ppd->guid = guid;
 	}
 
-	/* the link defaults to enabled */
-	ppd->link_enabled = 1;
 	/* Set linkinit_reason on power up per OPA spec */
 	ppd->linkinit_reason = OPA_LINKINIT_REASON_LINKUP;
 
@@ -9217,6 +9227,12 @@ int bringup_serdes(struct hfi1_pportdata *ppd)
 			return ret;
 	}
 
+	/* tune the SERDES to a ballpark setting for
+	 * optimal signal and bit error rate
+	 * Needs to be done before starting the link
+	 */
+	tune_serdes(ppd);
+
 	return start_link(ppd);
 }
 
@@ -9234,6 +9250,8 @@ void hfi1_quiet_serdes(struct hfi1_pportdata *ppd)
 	ppd->driver_link_ready = 0;
 	ppd->link_enabled = 0;
 
+	ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_SMA_DISABLED);
 	set_link_down_reason(ppd, OPA_LINKDOWN_REASON_SMA_DISABLED, 0,
 	  OPA_LINKDOWN_REASON_SMA_DISABLED);
 	set_link_state(ppd, HLS_DN_OFFLINE);
@@ -9649,6 +9667,12 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 	write_csr(dd, DC_LCB_ERR_EN, ~0ull); /* watch LCB errors */
 	ppd->host_link_state = HLS_LINK_COOLDOWN; /* LCB access allowed */
 
+	if (ppd->port_type == PORT_TYPE_QSFP &&
+	    ppd->qsfp_info.limiting_active &&
+	    qsfp_mod_present(ppd)) {
+		set_qsfp_tx(ppd, 0);
+	}
+
 	/*
 	 * The LNI has a mandatory wait time after the physical state
 	 * moves to Offline.Quiet.  The wait time may be different
@@ -12078,31 +12102,11 @@ void set_intr_state(struct hfi1_devdata *dd, u32 enable)
 	 * In HFI, the mask needs to be 1 to allow interrupts.
 	 */
 	if (enable) {
-		u64 cce_int_mask;
-		const int qsfp1_int_smask = QSFP1_INT % 64;
-		const int qsfp2_int_smask = QSFP2_INT % 64;
-
 		/* enable all interrupts */
 		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
 			write_csr(dd, CCE_INT_MASK + (8*i), ~(u64)0);
 
-		/*
-		 * disable QSFP1 interrupts for HFI1, QSFP2 interrupts for HFI0
-		 * Qsfp1Int and Qsfp2Int are adjacent bits in the same CSR,
-		 * therefore just one of QSFP1_INT/QSFP2_INT can be used to find
-		 * the index of the appropriate CSR in the CCEIntMask CSR array
-		 */
-		cce_int_mask = read_csr(dd, CCE_INT_MASK +
-						(8*(QSFP1_INT/64)));
-		if (dd->hfi1_id) {
-			cce_int_mask &= ~((u64)1 << qsfp1_int_smask);
-			write_csr(dd, CCE_INT_MASK + (8*(QSFP1_INT/64)),
-					cce_int_mask);
-		} else {
-			cce_int_mask &= ~((u64)1 << qsfp2_int_smask);
-			write_csr(dd, CCE_INT_MASK + (8*(QSFP2_INT/64)),
-					cce_int_mask);
-		}
+		init_qsfp_int(dd);
 	} else {
 		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
 			write_csr(dd, CCE_INT_MASK + (8*i), 0ull);
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 78ba425..5e4fe43 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -371,6 +371,9 @@
 #define NUM_LANE_FIELDS    0x8
 
 /* 8051 general register Field IDs */
+#define LINK_OPTIMIZATION_SETTINGS   0x00
+#define LINK_TUNING_PARAMETERS	     0x02
+#define DC_HOST_COMM_SETTINGS	     0x03
 #define TX_SETTINGS		     0x06
 #define VERIFY_CAP_LOCAL_PHY	     0x07
 #define VERIFY_CAP_LOCAL_FABRIC	     0x08
@@ -647,10 +650,13 @@ void handle_link_down(struct work_struct *work);
 void handle_link_downgrade(struct work_struct *work);
 void handle_link_bounce(struct work_struct *work);
 void handle_sma_message(struct work_struct *work);
+void reset_qsfp(struct hfi1_pportdata *ppd);
+void qsfp_event(struct work_struct *work);
 void start_freeze_handling(struct hfi1_pportdata *ppd, int flags);
 int send_idle_sma(struct hfi1_devdata *dd, u64 message);
+int load_8051_config(struct hfi1_devdata *, u8, u8, u32);
+int read_8051_config(struct hfi1_devdata *, u8, u8, u32 *);
 int start_link(struct hfi1_pportdata *ppd);
-void init_qsfp(struct hfi1_pportdata *ppd);
 int bringup_serdes(struct hfi1_pportdata *ppd);
 void set_intr_state(struct hfi1_devdata *dd, u32 enable);
 void apply_link_downgrade_policy(struct hfi1_pportdata *ppd,
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 57014b0..f79b070 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -74,7 +74,7 @@
 #include "chip.h"
 #include "mad.h"
 #include "qsfp.h"
-#include "platform_config.h"
+#include "platform.h"
 
 /* bumped 1 from s/w major version of TrueScale */
 #define HFI1_CHIP_VERS_MAJ 3U
@@ -563,7 +563,8 @@ struct hfi1_pportdata {
 	struct kobject sl2sc_kobj;
 	struct kobject vl2mtu_kobj;
 
-	/* QSFP support */
+	/* PHY support */
+	u32 port_type;
 	struct qsfp_data qsfp_info;
 
 	/* GUID for this interface, in host order */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 7def3f3..354935f 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -500,10 +500,13 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	INIT_WORK(&ppd->sma_message_work, handle_sma_message);
 	INIT_WORK(&ppd->link_bounce_work, handle_link_bounce);
 	INIT_WORK(&ppd->linkstate_active_work, receive_interrupt_work);
+	INIT_WORK(&ppd->qsfp_info.qsfp_work, qsfp_event);
+
 	mutex_init(&ppd->hls_lock);
 	spin_lock_init(&ppd->sdma_alllock);
 	spin_lock_init(&ppd->qsfp_info.qsfp_lock);
 
+	ppd->qsfp_info.ppd = ppd;
 	ppd->sm_trap_qp = 0x0;
 	ppd->sa_qp = 0x1;
 
@@ -781,13 +784,6 @@ done:
 		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
 			ppd = dd->pport + pidx;
 
-			/* initialize the qsfp if it exists
-			 * Requires interrupts to be enabled so we are notified
-			 * when the QSFP completes reset, and has
-			 * to be done before bringing up the SERDES
-			 */
-			init_qsfp(ppd);
-
 			/* start the serdes - must be after interrupts are
 			   enabled so we are notified when the link goes up */
 			lastfail = bringup_serdes(ppd);
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
new file mode 100644
index 0000000..9aa5e06
--- /dev/null
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -0,0 +1,838 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#include "hfi.h"
+
+int set_qsfp_tx(struct hfi1_pportdata *ppd, int on)
+{
+	u8 tx_ctrl_byte = on ? 0x0 : 0xF;
+	int ret = 0;
+
+	ret = qsfp_write(ppd, ppd->dd->hfi1_id, QSFP_TX_CTRL_BYTE_OFFS,
+			 &tx_ctrl_byte, 1);
+	/* we expected 1, so consider 0 an error */
+	if (ret == 0)
+		ret = -EIO;
+	else if (ret == 1)
+		ret = 0;
+	return ret;
+}
+
+static int qual_power(struct hfi1_pportdata *ppd)
+{
+	u32 cable_power_class = 0, power_class_max = 0;
+	u8 *cache = ppd->qsfp_info.cache;
+	int ret = 0;
+
+	ret = get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_SYSTEM_TABLE, 0,
+		SYSTEM_TABLE_QSFP_POWER_CLASS_MAX, &power_class_max, 4);
+	if (ret)
+		return ret;
+
+	if (QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]) != 4)
+		cable_power_class = QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]);
+	else
+		cable_power_class = QSFP_PWR(cache[QSFP_MOD_PWR_OFFS]);
+
+	if (cable_power_class <= 3 && cable_power_class > (power_class_max - 1))
+		ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY);
+	else if (cable_power_class > 4 && cable_power_class > (power_class_max))
+		ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY);
+	/*
+	 * cable_power_class will never have value 4 as this simply
+	 * means the high power settings are unused
+	 */
+
+	if (ppd->offline_disabled_reason ==
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY)) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: Port disabled due to system power restrictions\n",
+			__func__);
+		ret = -EPERM;
+	}
+	return ret;
+}
+
+static int qual_bitrate(struct hfi1_pportdata *ppd)
+{
+	u16 lss = ppd->link_speed_supported, lse = ppd->link_speed_enabled;
+	u8 *cache = ppd->qsfp_info.cache;
+
+	if ((lss & OPA_LINK_SPEED_25G) && (lse & OPA_LINK_SPEED_25G) &&
+	    cache[QSFP_NOM_BIT_RATE_250_OFFS] < 0x64)
+		ppd->offline_disabled_reason =
+			   HFI1_ODR_MASK(OPA_LINKDOWN_REASON_LINKSPEED_POLICY);
+
+	if ((lss & OPA_LINK_SPEED_12_5G) && (lse & OPA_LINK_SPEED_12_5G) &&
+	    cache[QSFP_NOM_BIT_RATE_100_OFFS] < 0x7D)
+		ppd->offline_disabled_reason =
+			   HFI1_ODR_MASK(OPA_LINKDOWN_REASON_LINKSPEED_POLICY);
+
+	if (ppd->offline_disabled_reason ==
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_LINKSPEED_POLICY)) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: Cable failed bitrate check, disabling port\n",
+			__func__);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static int set_qsfp_high_power(struct hfi1_pportdata *ppd)
+{
+	u8 cable_power_class = 0, power_ctrl_byte = 0;
+	u8 *cache = ppd->qsfp_info.cache;
+	int ret;
+
+	if (QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]) != 4)
+		cable_power_class = QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]);
+	else
+		cable_power_class = QSFP_PWR(cache[QSFP_MOD_PWR_OFFS]);
+
+	if (cable_power_class) {
+		power_ctrl_byte = cache[QSFP_PWR_CTRL_BYTE_OFFS];
+
+		power_ctrl_byte |= 1;
+		power_ctrl_byte &= ~(0x2);
+
+		ret = qsfp_write(ppd, ppd->dd->hfi1_id,
+				 QSFP_PWR_CTRL_BYTE_OFFS,
+				 &power_ctrl_byte, 1);
+		if (ret != 1)
+			return -EIO;
+
+		if (cable_power_class > 3) {
+			/* > power class 4*/
+			power_ctrl_byte |= (1 << 2);
+			ret = qsfp_write(ppd, ppd->dd->hfi1_id,
+					 QSFP_PWR_CTRL_BYTE_OFFS,
+					 &power_ctrl_byte, 1);
+			if (ret != 1)
+				return -EIO;
+		}
+
+		/* SFF 8679 rev 1.7 LPMode Deassert time */
+		msleep(300);
+	}
+	return 0;
+}
+
+static void apply_rx_cdr(struct hfi1_pportdata *ppd,
+			 u32 rx_preset_index,
+			 u8 *cdr_ctrl_byte)
+{
+	u32 rx_preset;
+	u8 *cache = ppd->qsfp_info.cache;
+
+	if (!((cache[QSFP_MOD_PWR_OFFS] & 0x4) &&
+	      (cache[QSFP_CDR_INFO_OFFS] & 0x40)))
+		return;
+
+	/* rx_preset preset to zero to catch error */
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_RX_PRESET_TABLE,
+		rx_preset_index, RX_PRESET_TABLE_QSFP_RX_CDR_APPLY,
+		&rx_preset, 4);
+
+	if (!rx_preset) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: RX_CDR_APPLY is set to disabled\n",
+			__func__);
+		return;
+	}
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_RX_PRESET_TABLE,
+		rx_preset_index, RX_PRESET_TABLE_QSFP_RX_CDR,
+		&rx_preset, 4);
+
+	/* Expand cdr setting to all 4 lanes */
+	rx_preset = (rx_preset | (rx_preset << 1) |
+			(rx_preset << 2) | (rx_preset << 3));
+
+	if (rx_preset) {
+		*cdr_ctrl_byte |= rx_preset;
+	} else {
+		*cdr_ctrl_byte &= rx_preset;
+		/* Preserve current TX CDR status */
+		*cdr_ctrl_byte |= (cache[QSFP_CDR_CTRL_BYTE_OFFS] & 0xF0);
+	}
+}
+
+static void apply_tx_cdr(struct hfi1_pportdata *ppd,
+			 u32 tx_preset_index,
+			 u8 *ctr_ctrl_byte)
+{
+	u32 tx_preset;
+	u8 *cache = ppd->qsfp_info.cache;
+
+	if (!((cache[QSFP_MOD_PWR_OFFS] & 0x8) &&
+	      (cache[QSFP_CDR_INFO_OFFS] & 0x80)))
+		return;
+
+	get_platform_config_field(
+		ppd->dd,
+		PLATFORM_CONFIG_TX_PRESET_TABLE, tx_preset_index,
+		TX_PRESET_TABLE_QSFP_TX_CDR_APPLY, &tx_preset, 4);
+
+	if (!tx_preset) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: TX_CDR_APPLY is set to disabled\n",
+			__func__);
+		return;
+	}
+	get_platform_config_field(
+		ppd->dd,
+		PLATFORM_CONFIG_TX_PRESET_TABLE,
+		tx_preset_index,
+		TX_PRESET_TABLE_QSFP_TX_CDR, &tx_preset, 4);
+
+	/* Expand cdr setting to all 4 lanes */
+	tx_preset = (tx_preset | (tx_preset << 1) |
+			(tx_preset << 2) | (tx_preset << 3));
+
+	if (tx_preset)
+		*ctr_ctrl_byte |= (tx_preset << 4);
+	else
+		/* Preserve current/determined RX CDR status */
+		*ctr_ctrl_byte &= ((tx_preset << 4) | 0xF);
+}
+
+static void apply_cdr_settings(
+		struct hfi1_pportdata *ppd, u32 rx_preset_index,
+		u32 tx_preset_index)
+{
+	u8 *cache = ppd->qsfp_info.cache;
+	u8 cdr_ctrl_byte = cache[QSFP_CDR_CTRL_BYTE_OFFS];
+
+	apply_rx_cdr(ppd, rx_preset_index, &cdr_ctrl_byte);
+
+	apply_tx_cdr(ppd, tx_preset_index, &cdr_ctrl_byte);
+
+	qsfp_write(ppd, ppd->dd->hfi1_id, QSFP_CDR_CTRL_BYTE_OFFS,
+		   &cdr_ctrl_byte, 1);
+}
+
+static void apply_tx_eq_auto(struct hfi1_pportdata *ppd)
+{
+	u8 *cache = ppd->qsfp_info.cache;
+	u8 tx_eq;
+
+	if (!(cache[QSFP_EQ_INFO_OFFS] & 0x8))
+		return;
+	/* Disable adaptive TX EQ if present */
+	tx_eq = cache[(128 * 3) + 241];
+	tx_eq &= 0xF0;
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 241, &tx_eq, 1);
+}
+
+static void apply_tx_eq_prog(struct hfi1_pportdata *ppd, u32 tx_preset_index)
+{
+	u8 *cache = ppd->qsfp_info.cache;
+	u32 tx_preset;
+	u8 tx_eq;
+
+	if (!(cache[QSFP_EQ_INFO_OFFS] & 0x4))
+		return;
+
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_TX_PRESET_TABLE,
+		tx_preset_index, TX_PRESET_TABLE_QSFP_TX_EQ_APPLY,
+		&tx_preset, 4);
+	if (!tx_preset) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: TX_EQ_APPLY is set to disabled\n",
+			__func__);
+		return;
+	}
+	get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_TX_PRESET_TABLE,
+			tx_preset_index, TX_PRESET_TABLE_QSFP_TX_EQ,
+			&tx_preset, 4);
+
+	if (((cache[(128 * 3) + 224] & 0xF0) >> 4) < tx_preset) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: TX EQ %x unsupported\n",
+			__func__, tx_preset);
+
+		dd_dev_info(
+			ppd->dd,
+			"%s: Applying EQ %x\n",
+			__func__, cache[608] & 0xF0);
+
+		tx_preset = (cache[608] & 0xF0) >> 4;
+	}
+
+	tx_eq = tx_preset | (tx_preset << 4);
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 234, &tx_eq, 1);
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 235, &tx_eq, 1);
+}
+
+static void apply_rx_eq_emp(struct hfi1_pportdata *ppd, u32 rx_preset_index)
+{
+	u32 rx_preset;
+	u8 rx_eq, *cache = ppd->qsfp_info.cache;
+
+	if (!(cache[QSFP_EQ_INFO_OFFS] & 0x2))
+		return;
+	get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_RX_PRESET_TABLE,
+			rx_preset_index, RX_PRESET_TABLE_QSFP_RX_EMP_APPLY,
+			&rx_preset, 4);
+
+	if (!rx_preset) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: RX_EMP_APPLY is set to disabled\n",
+			__func__);
+		return;
+	}
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_RX_PRESET_TABLE,
+		rx_preset_index, RX_PRESET_TABLE_QSFP_RX_EMP,
+		&rx_preset, 4);
+
+	if ((cache[(128 * 3) + 224] & 0xF) < rx_preset) {
+		dd_dev_info(
+			ppd->dd,
+			"%s: Requested RX EMP %x\n",
+			__func__, rx_preset);
+
+		dd_dev_info(
+			ppd->dd,
+			"%s: Applying supported EMP %x\n",
+			__func__, cache[608] & 0xF);
+
+		rx_preset = cache[608] & 0xF;
+	}
+
+	rx_eq = rx_preset | (rx_preset << 4);
+
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 236, &rx_eq, 1);
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 237, &rx_eq, 1);
+}
+
+static void apply_eq_settings(struct hfi1_pportdata *ppd,
+			      u32 rx_preset_index, u32 tx_preset_index)
+{
+	u8 *cache = ppd->qsfp_info.cache;
+
+	/* no point going on w/o a page 3 */
+	if (cache[2] & 4) {
+		dd_dev_info(ppd->dd,
+			    "%s: Upper page 03 not present\n",
+			    __func__);
+		return;
+	}
+
+	apply_tx_eq_auto(ppd);
+
+	apply_tx_eq_prog(ppd, tx_preset_index);
+
+	apply_rx_eq_emp(ppd, rx_preset_index);
+}
+
+static void apply_rx_amplitude_settings(
+		struct hfi1_pportdata *ppd, u32 rx_preset_index,
+		u32 tx_preset_index)
+{
+	u32 rx_preset;
+	u8 rx_amp = 0, i = 0, preferred = 0, *cache = ppd->qsfp_info.cache;
+
+	/* no point going on w/o a page 3 */
+	if (cache[2] & 4) {
+		dd_dev_info(ppd->dd,
+			    "%s: Upper page 03 not present\n",
+			    __func__);
+		return;
+	}
+	if (!(cache[QSFP_EQ_INFO_OFFS] & 0x1)) {
+		dd_dev_info(ppd->dd,
+			    "%s: RX_AMP_APPLY is set to disabled\n",
+			    __func__);
+		return;
+	}
+
+	get_platform_config_field(ppd->dd,
+				  PLATFORM_CONFIG_RX_PRESET_TABLE,
+				  rx_preset_index,
+				  RX_PRESET_TABLE_QSFP_RX_AMP_APPLY,
+				  &rx_preset, 4);
+
+	if (!rx_preset) {
+		dd_dev_info(ppd->dd,
+			    "%s: RX_AMP_APPLY is set to disabled\n",
+			    __func__);
+		return;
+	}
+	get_platform_config_field(ppd->dd,
+				  PLATFORM_CONFIG_RX_PRESET_TABLE,
+				  rx_preset_index,
+				  RX_PRESET_TABLE_QSFP_RX_AMP,
+				  &rx_preset, 4);
+
+	dd_dev_info(ppd->dd,
+		    "%s: Requested RX AMP %x\n",
+		    __func__,
+		    rx_preset);
+
+	for (i = 0; i < 4; i++) {
+		if (cache[(128 * 3) + 225] & (1 << i)) {
+			preferred = i;
+			if (preferred == rx_preset)
+				break;
+		}
+	}
+
+	/*
+	 * Verify that preferred RX amplitude is not just a
+	 * fall through of the default
+	 */
+	if (!preferred && !(cache[(128 * 3) + 225] & 0x1)) {
+		dd_dev_info(ppd->dd, "No supported RX AMP, not applying\n");
+		return;
+	}
+
+	dd_dev_info(ppd->dd,
+		    "%s: Applying RX AMP %x\n", __func__, preferred);
+
+	rx_amp = preferred | (preferred << 4);
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 238, &rx_amp, 1);
+	qsfp_write(ppd, ppd->dd->hfi1_id, (256 * 3) + 239, &rx_amp, 1);
+}
+
+#define OPA_INVALID_INDEX 0xFFF
+
+static void apply_tx_lanes(struct hfi1_pportdata *ppd, u32 config_data,
+			   const char *message)
+{
+	u8 i;
+	int ret = HCMD_SUCCESS;
+
+	for (i = 0; i < 4; i++) {
+		ret = load_8051_config(ppd->dd, 0, i, config_data);
+		if (ret != HCMD_SUCCESS) {
+			dd_dev_err(
+				ppd->dd,
+				"%s: %s for lane %u failed\n",
+				message, __func__, i);
+		}
+	}
+}
+
+static void apply_tunings(
+		struct hfi1_pportdata *ppd, u32 tx_preset_index,
+		u8 tuning_method, u32 total_atten, u8 limiting_active)
+{
+	int ret = 0;
+	u32 config_data = 0, tx_preset = 0;
+	u8 precur = 0, attn = 0, postcur = 0, external_device_config = 0;
+	u8 *cache = ppd->qsfp_info.cache;
+
+	read_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
+			 GENERAL_CONFIG, &config_data);
+	config_data |= limiting_active;
+	ret = load_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
+			       GENERAL_CONFIG, config_data);
+	if (ret != HCMD_SUCCESS)
+		dd_dev_err(
+			ppd->dd,
+			"%s: Failed to set enable external device config\n",
+			__func__);
+
+	config_data = 0; /* re-init  */
+	read_8051_config(ppd->dd, LINK_TUNING_PARAMETERS, GENERAL_CONFIG,
+			 &config_data);
+	config_data |= tuning_method;
+	ret = load_8051_config(ppd->dd, LINK_TUNING_PARAMETERS, GENERAL_CONFIG,
+			       config_data);
+	if (ret != HCMD_SUCCESS)
+		dd_dev_err(ppd->dd, "%s: Failed to set tuning method\n",
+			   __func__);
+
+	external_device_config =
+		((cache[QSFP_MOD_PWR_OFFS] & 0x4) << 3) |
+		((cache[QSFP_MOD_PWR_OFFS] & 0x8) << 2) |
+		((cache[QSFP_EQ_INFO_OFFS] & 0x2) << 1) |
+		(cache[QSFP_EQ_INFO_OFFS] & 0x4);
+
+	config_data = 0; /* re-init  */
+	read_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS, GENERAL_CONFIG,
+			 &config_data);
+	config_data |= (external_device_config << 24);
+	ret = load_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS, GENERAL_CONFIG,
+			       config_data);
+	if (ret != HCMD_SUCCESS)
+		dd_dev_err(
+			ppd->dd,
+			"%s: Failed to set external device config parameters\n",
+			__func__);
+
+	config_data = 0; /* re-init  */
+	read_8051_config(ppd->dd, TX_SETTINGS, GENERAL_CONFIG, &config_data);
+	if ((ppd->link_speed_supported & OPA_LINK_SPEED_25G) &&
+	    (ppd->link_speed_enabled & OPA_LINK_SPEED_25G))
+		config_data |= 0x02;
+	if ((ppd->link_speed_supported & OPA_LINK_SPEED_12_5G) &&
+	    (ppd->link_speed_enabled & OPA_LINK_SPEED_12_5G))
+		config_data |= 0x01;
+	ret = load_8051_config(ppd->dd, TX_SETTINGS, GENERAL_CONFIG,
+			       config_data);
+	if (ret != HCMD_SUCCESS)
+		dd_dev_err(
+			ppd->dd,
+			"%s: Failed to set external device config parameters\n",
+			__func__);
+
+	config_data = (total_atten << 8) | (total_atten);
+
+	apply_tx_lanes(ppd, config_data, "Setting channel loss");
+
+	if (tx_preset_index == OPA_INVALID_INDEX)
+		return;
+
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_TX_PRESET_TABLE, tx_preset_index,
+		TX_PRESET_TABLE_PRECUR, &tx_preset, 4);
+	precur = tx_preset;
+
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_TX_PRESET_TABLE,
+		tx_preset_index, TX_PRESET_TABLE_ATTN, &tx_preset, 4);
+	attn = tx_preset;
+
+	get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_TX_PRESET_TABLE,
+		tx_preset_index, TX_PRESET_TABLE_POSTCUR, &tx_preset, 4);
+	postcur = tx_preset;
+
+	config_data = precur | (attn << 8) | (postcur << 16);
+
+	apply_tx_lanes(ppd, config_data, "Applying TX settings");
+}
+
+static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
+			    u32 *ptr_rx_preset, u32 *ptr_total_atten)
+{
+	int ret = 0;
+	u16 lss = ppd->link_speed_supported, lse = ppd->link_speed_enabled;
+	u8 *cache = ppd->qsfp_info.cache;
+
+	ppd->qsfp_info.limiting_active = 1;
+
+	ret = set_qsfp_tx(ppd, 0);
+	if (ret)
+		return ret;
+
+	ret = qual_power(ppd);
+	if (ret)
+		return ret;
+
+	ret = qual_bitrate(ppd);
+	if (ret)
+		return ret;
+
+	if (ppd->qsfp_info.reset_needed) {
+		reset_qsfp(ppd);
+		ppd->qsfp_info.reset_needed = 0;
+		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
+	} else {
+		ppd->qsfp_info.reset_needed = 1;
+	}
+
+	ret = set_qsfp_high_power(ppd);
+	if (ret)
+		return ret;
+
+	if (cache[QSFP_EQ_INFO_OFFS] & 0x4) {
+		ret = get_platform_config_field(
+			ppd->dd,
+			PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_TX_PRESET_IDX_ACTIVE_EQ,
+			ptr_tx_preset, 4);
+		if (ret) {
+			*ptr_tx_preset = OPA_INVALID_INDEX;
+			return ret;
+		}
+	} else {
+		ret = get_platform_config_field(
+			ppd->dd,
+			PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_TX_PRESET_IDX_ACTIVE_NO_EQ,
+			ptr_tx_preset, 4);
+		if (ret) {
+			*ptr_tx_preset = OPA_INVALID_INDEX;
+			return ret;
+		}
+	}
+
+	ret = get_platform_config_field(
+		ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+		PORT_TABLE_RX_PRESET_IDX, ptr_rx_preset, 4);
+	if (ret) {
+		*ptr_rx_preset = OPA_INVALID_INDEX;
+		return ret;
+	}
+
+	if ((lss & OPA_LINK_SPEED_25G) && (lse & OPA_LINK_SPEED_25G))
+		get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_LOCAL_ATTEN_25G, ptr_total_atten, 4);
+	else if ((lss & OPA_LINK_SPEED_12_5G) && (lse & OPA_LINK_SPEED_12_5G))
+		get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_LOCAL_ATTEN_12G, ptr_total_atten, 4);
+
+	apply_cdr_settings(ppd, *ptr_rx_preset, *ptr_tx_preset);
+
+	apply_eq_settings(ppd, *ptr_rx_preset, *ptr_tx_preset);
+
+	apply_rx_amplitude_settings(ppd, *ptr_rx_preset, *ptr_tx_preset);
+
+	ret = set_qsfp_tx(ppd, 1);
+	return ret;
+}
+
+static int tune_qsfp(struct hfi1_pportdata *ppd,
+		     u32 *ptr_tx_preset, u32 *ptr_rx_preset,
+		     u8 *ptr_tuning_method, u32 *ptr_total_atten)
+{
+	u32 cable_atten = 0, remote_atten = 0, platform_atten = 0;
+	u16 lss = ppd->link_speed_supported, lse = ppd->link_speed_enabled;
+	int ret = 0;
+	u8 *cache = ppd->qsfp_info.cache;
+
+	switch ((cache[QSFP_MOD_TECH_OFFS] & 0xF0) >> 4) {
+	case 0xA ... 0xB:
+		ret = get_platform_config_field(
+			ppd->dd,
+			PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_LOCAL_ATTEN_25G,
+			&platform_atten, 4);
+		if (ret)
+			return ret;
+
+		if ((lss & OPA_LINK_SPEED_25G) && (lse & OPA_LINK_SPEED_25G))
+			cable_atten = cache[QSFP_CU_ATTEN_12G_OFFS];
+		else if ((lss & OPA_LINK_SPEED_12_5G) &&
+			 (lse & OPA_LINK_SPEED_12_5G))
+			cable_atten = cache[QSFP_CU_ATTEN_7G_OFFS];
+
+		/* Fallback to configured attenuation if cable memory is bad */
+		if (cable_atten == 0 || cable_atten > 36) {
+			ret = get_platform_config_field(
+				ppd->dd,
+				PLATFORM_CONFIG_SYSTEM_TABLE, 0,
+				SYSTEM_TABLE_QSFP_ATTENUATION_DEFAULT_25G,
+				&cable_atten, 4);
+			if (ret)
+				return ret;
+		}
+
+		ret = get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_REMOTE_ATTEN_25G, &remote_atten, 4);
+		if (ret)
+			return ret;
+
+		*ptr_total_atten = platform_atten + cable_atten + remote_atten;
+
+		*ptr_tuning_method = OPA_PASSIVE_TUNING;
+		break;
+	case 0x0 ... 0x9: /* fallthrough */
+	case 0xC: /* fallthrough */
+	case 0xE:
+		ret = tune_active_qsfp(ppd, ptr_tx_preset, ptr_rx_preset,
+				       ptr_total_atten);
+		if (ret)
+			return ret;
+
+		*ptr_tuning_method = OPA_ACTIVE_TUNING;
+		break;
+	case 0xD: /* fallthrough */
+	case 0xF:
+	default:
+		dd_dev_info(ppd->dd, "%s: Unknown/unsupported cable\n",
+			    __func__);
+		break;
+	}
+	return ret;
+}
+
+/*
+ * This function communicates its success or failure via ppd->driver_link_ready
+ * Thus, it depends on its association with start_link(...) which checks
+ * driver_link_ready before proceeding with the link negotiation and
+ * initialization process.
+ */
+void tune_serdes(struct hfi1_pportdata *ppd)
+{
+	int ret = 0;
+	u32 total_atten = 0;
+	u32 remote_atten = 0, platform_atten = 0;
+	u32 rx_preset_index, tx_preset_index;
+	u8 tuning_method = 0;
+	struct hfi1_devdata *dd = ppd->dd;
+
+	rx_preset_index = OPA_INVALID_INDEX;
+	tx_preset_index = OPA_INVALID_INDEX;
+
+	/* the link defaults to enabled */
+	ppd->link_enabled = 1;
+	/* the driver link ready state defaults to not ready */
+	ppd->driver_link_ready = 0;
+	ppd->offline_disabled_reason = HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE);
+
+	if (loopback == LOOPBACK_SERDES || loopback == LOOPBACK_LCB ||
+	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
+	    !dd->pcfg_cache.cache_valid) {
+		ppd->driver_link_ready = 1;
+		return;
+	}
+
+	ret = get_platform_config_field(ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+					PORT_TABLE_PORT_TYPE, &ppd->port_type,
+					4);
+	if (ret)
+		goto bail;
+
+	switch (ppd->port_type) {
+	case PORT_TYPE_DISCONNECTED:
+		ppd->offline_disabled_reason =
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_DISCONNECTED);
+		dd_dev_info(dd, "%s: Port disconnected, disabling port\n",
+			    __func__);
+		goto bail;
+	case PORT_TYPE_FIXED:
+		/* platform_atten, remote_atten pre-zeroed to catch error */
+		get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_LOCAL_ATTEN_25G, &platform_atten, 4);
+
+		get_platform_config_field(
+			ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+			PORT_TABLE_REMOTE_ATTEN_25G, &remote_atten, 4);
+
+		total_atten = platform_atten + remote_atten;
+
+		tuning_method = OPA_PASSIVE_TUNING;
+		break;
+	case PORT_TYPE_VARIABLE:
+		if (qsfp_mod_present(ppd)) {
+			/*
+			 * platform_atten, remote_atten pre-zeroed to
+			 * catch error
+			 */
+			get_platform_config_field(
+				ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+				PORT_TABLE_LOCAL_ATTEN_25G,
+				&platform_atten, 4);
+
+			get_platform_config_field(
+				ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
+				PORT_TABLE_REMOTE_ATTEN_25G,
+				&remote_atten, 4);
+
+			total_atten = platform_atten + remote_atten;
+
+			tuning_method = OPA_PASSIVE_TUNING;
+		} else
+			ppd->offline_disabled_reason =
+			     HFI1_ODR_MASK(OPA_LINKDOWN_REASON_CHASSIS_CONFIG);
+		break;
+	case PORT_TYPE_QSFP:
+		if (qsfp_mod_present(ppd)) {
+			refresh_qsfp_cache(ppd, &ppd->qsfp_info);
+
+			if (ppd->qsfp_info.cache_valid) {
+				ret = tune_qsfp(ppd,
+						&tx_preset_index,
+						&rx_preset_index,
+						&tuning_method,
+						&total_atten);
+				if (ret)
+					goto bail;
+			} else {
+				dd_dev_err(dd,
+					   "%s: Reading QSFP memory failed\n",
+					   __func__);
+				goto bail;
+			}
+		} else
+			ppd->offline_disabled_reason =
+			   HFI1_ODR_MASK(
+				OPA_LINKDOWN_REASONLOCAL_MEDIA_NOT_INSTALLED);
+		break;
+	default:
+		dd_dev_info(ppd->dd, "%s: Unknown port type\n", __func__);
+		break;
+	}
+	if (ppd->offline_disabled_reason ==
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE))
+		apply_tunings(ppd, tx_preset_index, tuning_method,
+			      total_atten,
+			      ppd->qsfp_info.limiting_active);
+
+	if (ppd->port_type == PORT_TYPE_QSFP)
+		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
+
+	ppd->driver_link_ready = 1;
+
+	return;
+bail:
+	ppd->driver_link_ready = 0;
+}
diff --git a/drivers/staging/rdma/hfi1/platform_config.h b/drivers/staging/rdma/hfi1/platform.h
similarity index 91%
rename from drivers/staging/rdma/hfi1/platform_config.h
rename to drivers/staging/rdma/hfi1/platform.h
index 8a94a83..5b53d71 100644
--- a/drivers/staging/rdma/hfi1/platform_config.h
+++ b/drivers/staging/rdma/hfi1/platform.h
@@ -47,8 +47,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
-#ifndef __PLATFORM_CONFIG_H
-#define __PLATFORM_CONFIG_H
+#ifndef __PLATFORM_H
+#define __PLATFORM_H
 
 #define METADATA_TABLE_FIELD_START_SHIFT		0
 #define METADATA_TABLE_FIELD_START_LEN_BITS		15
@@ -94,17 +94,18 @@ enum platform_config_system_table_fields {
 enum platform_config_port_table_fields {
 	PORT_TABLE_RESERVED,
 	PORT_TABLE_PORT_TYPE,
-	PORT_TABLE_ATTENUATION_12G,
-	PORT_TABLE_ATTENUATION_25G,
+	PORT_TABLE_LOCAL_ATTEN_12G,
+	PORT_TABLE_LOCAL_ATTEN_25G,
 	PORT_TABLE_LINK_SPEED_SUPPORTED,
 	PORT_TABLE_LINK_WIDTH_SUPPORTED,
+	PORT_TABLE_AUTO_LANE_SHEDDING_ENABLED,
+	PORT_TABLE_EXTERNAL_LOOPBACK_ALLOWED,
 	PORT_TABLE_VL_CAP,
 	PORT_TABLE_MTU_CAP,
 	PORT_TABLE_TX_LANE_ENABLE_MASK,
 	PORT_TABLE_LOCAL_MAX_TIMEOUT,
-	PORT_TABLE_AUTO_LANE_SHEDDING_ENABLED,
-	PORT_TABLE_EXTERNAL_LOOPBACK_ALLOWED,
-	PORT_TABLE_TX_PRESET_IDX_PASSIVE_CU,
+	PORT_TABLE_REMOTE_ATTEN_12G,
+	PORT_TABLE_REMOTE_ATTEN_25G,
 	PORT_TABLE_TX_PRESET_IDX_ACTIVE_NO_EQ,
 	PORT_TABLE_TX_PRESET_IDX_ACTIVE_EQ,
 	PORT_TABLE_RX_PRESET_IDX,
@@ -115,10 +116,10 @@ enum platform_config_port_table_fields {
 enum platform_config_rx_preset_table_fields {
 	RX_PRESET_TABLE_RESERVED,
 	RX_PRESET_TABLE_QSFP_RX_CDR_APPLY,
-	RX_PRESET_TABLE_QSFP_RX_EQ_APPLY,
+	RX_PRESET_TABLE_QSFP_RX_EMP_APPLY,
 	RX_PRESET_TABLE_QSFP_RX_AMP_APPLY,
 	RX_PRESET_TABLE_QSFP_RX_CDR,
-	RX_PRESET_TABLE_QSFP_RX_EQ,
+	RX_PRESET_TABLE_QSFP_RX_EMP,
 	RX_PRESET_TABLE_QSFP_RX_AMP,
 	RX_PRESET_TABLE_MAX
 };
@@ -179,9 +180,11 @@ static const u32 platform_config_table_limits[PLATFORM_CONFIG_TABLE_MAX] = {
  * fields defined for each table above
  */
 
-/*=====================================================
+/*
+ *=====================================================
  *  System table encodings
- *====================================================*/
+ *====================================================
+ */
 #define PLATFORM_CONFIG_MAGIC_NUM		0x3d4f5041
 #define PLATFORM_CONFIG_MAGIC_NUMBER_LEN	4
 
@@ -199,12 +202,13 @@ enum platform_config_qsfp_power_class_encoding {
 	QSFP_POWER_CLASS_7
 };
 
-
-/*=====================================================
+/*
+ *=====================================================
  *  Port table encodings
- *==================================================== */
+ *====================================================
+ */
 enum platform_config_port_type_encoding {
-	PORT_TYPE_RESERVED,
+	PORT_TYPE_UNKNOWN,
 	PORT_TYPE_DISCONNECTED,
 	PORT_TYPE_FIXED,
 	PORT_TYPE_VARIABLE,
@@ -283,4 +287,12 @@ enum platform_config_local_max_timeout_encoding {
 	LOCAL_MAX_TIMEOUT_1000_S
 };
 
-#endif			/*__PLATFORM_CONFIG_H*/
+enum link_tuning_encoding {
+	OPA_PASSIVE_TUNING,
+	OPA_ACTIVE_TUNING,
+	OPA_UNKNOWN_TUNING
+};
+
+int set_qsfp_tx(struct hfi1_pportdata *ppd, int on);
+void tune_serdes(struct hfi1_pportdata *ppd);
+#endif			/*__PLATFORM_H*/
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index 3422250..b1b9e4a 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -213,7 +213,8 @@ struct qsfp_data {
 	u8 cache[QSFP_MAX_NUM_PAGES*128];
 	spinlock_t qsfp_lock;
 	u8 check_interrupt_flags;
-	u8 qsfp_interrupt_functional;
+	u8 reset_needed;
+	u8 limiting_active;
 	u8 cache_valid;
 	u8 cache_refresh_required;
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
