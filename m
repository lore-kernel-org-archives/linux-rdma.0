From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 02/23] staging/rdma/hfi1: Reset ASIC CSRs on FLR, and once per ASIC
Date: Mon, 19 Oct 2015 12:43:26 -0400
Message-ID: <1445273027-29634-3-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ASIC registers were not reset on FLR, and the code to
protect the ASIC block against multiple initializations by
peer HFIs did not extend to multiple ASICs in a system. This
patch addresses this gap.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     | 35 +++++++++++++++--------------------
 drivers/staging/rdma/hfi1/firmware.c |  4 ++++
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 11523596ca57..f300d7fa5e5f 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -9327,8 +9327,6 @@ static void reset_cce_csrs(struct hfi1_devdata *dd)
 /* set ASIC CSRs to chip reset defaults */
 static void reset_asic_csrs(struct hfi1_devdata *dd)
 {
-	static DEFINE_MUTEX(asic_mutex);
-	static int called;
 	int i;
 
 	/*
@@ -9338,15 +9336,8 @@ static void reset_asic_csrs(struct hfi1_devdata *dd)
 	 * a known first load do the reset and blocking all others.
 	 */
 
-	/*
-	 * These CSRs should only be reset once - the first one here will
-	 * do the work.  Use a mutex so that a non-first caller waits until
-	 * the first is finished before it can proceed.
-	 */
-	mutex_lock(&asic_mutex);
-	if (called)
-		goto done;
-	called = 1;
+	if (!(dd->flags & HFI1_DO_INIT_ASIC))
+		return;
 
 	if (dd->icode != ICODE_FPGA_EMULATION) {
 		/* emulation does not have an SBus - leave these alone */
@@ -9366,7 +9357,10 @@ static void reset_asic_csrs(struct hfi1_devdata *dd)
 	for (i = 0; i < ASIC_NUM_SCRATCH; i++)
 		write_csr(dd, ASIC_CFG_SCRATCH + (8 * i), 0);
 	write_csr(dd, ASIC_CFG_MUTEX, 0);	/* this will clear it */
+
+	/* We might want to retain this state across FLR if we ever use it */
 	write_csr(dd, ASIC_CFG_DRV_STR, 0);
+
 	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0);
 	/* ASIC_STS_THERM read-only */
 	/* ASIC_CFG_RESET leave alone */
@@ -9413,9 +9407,6 @@ static void reset_asic_csrs(struct hfi1_devdata *dd)
 	/* this also writes a NOP command, clearing paging mode */
 	write_csr(dd, ASIC_EEP_ADDR_CMD, 0);
 	write_csr(dd, ASIC_EEP_DATA, 0);
-
-done:
-	mutex_unlock(&asic_mutex);
 }
 
 /* set MISC CSRs to chip reset defaults */
@@ -9827,6 +9818,7 @@ static void init_chip(struct hfi1_devdata *dd)
 			restore_pci_variables(dd);
 		}
 
+		reset_asic_csrs(dd);
 	} else {
 		dd_dev_info(dd, "Resetting CSRs with writes\n");
 		reset_cce_csrs(dd);
@@ -9837,6 +9829,7 @@ static void init_chip(struct hfi1_devdata *dd)
 	}
 	/* clear the DC reset */
 	write_csr(dd, CCE_DC_CTRL, 0);
+
 	/* Set the LED off */
 	if (is_a0(dd))
 		setextled(dd, 0);
@@ -10332,7 +10325,7 @@ static void asic_should_init(struct hfi1_devdata *dd)
 }
 
 /**
- * Allocate an initialize the device structure for the hfi.
+ * Allocate and initialize the device structure for the hfi.
  * @dev: the pci_dev for hfi1_ib device
  * @ent: pci_device_id struct for this dev
  *
@@ -10488,6 +10481,12 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	else if (dd->rcv_intr_timeout_csr == 0 && rcv_intr_timeout)
 		dd->rcv_intr_timeout_csr = 1;
 
+	/* needs to be done before we look for the peer device */
+	read_guid(dd);
+
+	/* should this device init the ASIC block? */
+	asic_should_init(dd);
+
 	/* obtain chip sizes, reset chip CSRs */
 	init_chip(dd);
 
@@ -10496,11 +10495,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret)
 		goto bail_cleanup;
 
-	/* needs to be done before we look for the peer device */
-	read_guid(dd);
-
-	asic_should_init(dd);
-
 	/* read in firmware */
 	ret = hfi1_firmware_init(dd);
 	if (ret)
@@ -10715,6 +10709,7 @@ static int thermal_init(struct hfi1_devdata *dd)
 
 	acquire_hw_mutex(dd);
 	dd_dev_info(dd, "Initializing thermal sensor\n");
+
 	/* Thermal Sensor Initialization */
 	/*    Step 1: Reset the Thermal SBus Receiver */
 	ret = sbus_request_slow(dd, SBUS_THERMAL, 0x0,
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 5c2f2ed8f224..15c9cb7a3150 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1614,6 +1614,10 @@ done:
  */
 void read_guid(struct hfi1_devdata *dd)
 {
+	/* Take the DC out of reset to get a valid GUID value */
+	write_csr(dd, CCE_DC_CTRL, 0);
+	(void) read_csr(dd, CCE_DC_CTRL);
+
 	dd->base_guid = read_csr(dd, DC_DC8051_CFG_LOCAL_GUID);
 	dd_dev_info(dd, "GUID %llx",
 		(unsigned long long)dd->base_guid);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
