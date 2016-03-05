From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/17] IB/hfi1: Change SBus handling to use resource
 reservation
Date: Sat, 05 Mar 2016 08:50:01 -0800
Message-ID: <20160305165000.32025.35668.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The SBus resource includes SBUS, PCIE, and THERM registers.
Change SBus handling to use the new ASIC resource reservation system.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |    9 +++++-
 drivers/infiniband/hw/hfi1/chip.h     |    3 ++
 drivers/infiniband/hw/hfi1/firmware.c |   46 +++++++++++++++++----------------
 drivers/infiniband/hw/hfi1/pcie.c     |   13 ++++++---
 4 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 98ebee4..269c977 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14324,7 +14324,12 @@ static int thermal_init(struct hfi1_devdata *dd)
 	    !(dd->flags & HFI1_DO_INIT_ASIC))
 		return ret;
 
-	acquire_hw_mutex(dd);
+	ret = acquire_chip_resource(dd, CR_SBUS, SBUS_TIMEOUT);
+	if (ret) {
+		THERM_FAILURE(dd, ret, "Acquire SBus");
+		return ret;
+	}
+
 	dd_dev_info(dd, "Initializing thermal sensor\n");
 	/* Disable polling of thermal readings */
 	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0x0);
@@ -14372,7 +14377,7 @@ static int thermal_init(struct hfi1_devdata *dd)
 	/* Enable polling of thermal readings */
 	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0x1);
 done:
-	release_hw_mutex(dd);
+	release_chip_resource(dd, CR_SBUS);
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index dc684bc..311e6e8 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -669,6 +669,9 @@ bool check_chip_resource(struct hfi1_devdata *dd, u32 resource,
 void init_chip_resources(struct hfi1_devdata *dd);
 void finish_chip_resources(struct hfi1_devdata *dd);
 
+/* ms wait time for access to an SBus resoure */
+#define SBUS_TIMEOUT 4000 /* long enough for a FW download and SBR */
+
 void fabric_serdes_reset(struct hfi1_devdata *dd);
 int read_8051_data(struct hfi1_devdata *dd, u32 addr, u32 len, u64 *result);
 
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 140dd86..1ea1ad8 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1125,15 +1125,23 @@ static void turn_off_spicos(struct hfi1_devdata *dd, int flags)
  */
 void fabric_serdes_reset(struct hfi1_devdata *dd)
 {
+	int ret;
+
 	if (!fw_fabric_serdes_load)
 		return;
 
+	ret = acquire_chip_resource(dd, CR_SBUS, SBUS_TIMEOUT);
+	if (ret) {
+		dd_dev_err(dd,
+			   "Cannot acquire SBus resource to reset fabric SerDes - perhaps you should reboot\n");
+		return;
+	}
+	set_sbus_fast_mode(dd);
+
 	if (is_ax(dd)) {
 		/* A0 serdes do not work with a re-download */
 		u8 ra = fabric_serdes_broadcast[dd->hfi1_id];
 
-		acquire_hw_mutex(dd);
-		set_sbus_fast_mode(dd);
 		/* place SerDes in reset and disable SPICO */
 		sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000011);
 		/* wait 100 refclk cycles @ 156.25MHz => 640ns */
@@ -1142,26 +1150,20 @@ void fabric_serdes_reset(struct hfi1_devdata *dd)
 		sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000010);
 		/* turn SPICO enable on */
 		sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000002);
-		clear_sbus_fast_mode(dd);
-		release_hw_mutex(dd);
-		return;
+	} else {
+		turn_off_spicos(dd, SPICO_FABRIC);
+		/*
+		 * No need for firmware retry - what to download has already
+		 * been decided.
+		 * No need to pay attention to the load return - the only
+		 * failure is a validation failure, which has already been
+		 * checked by the initial download.
+		 */
+		(void)load_fabric_serdes_firmware(dd, &fw_fabric);
 	}
 
-	acquire_hw_mutex(dd);
-	set_sbus_fast_mode(dd);
-
-	turn_off_spicos(dd, SPICO_FABRIC);
-	/*
-	 * No need for firmware retry - what to download has already been
-	 * decided.
-	 * No need to pay attention to the load return - the only failure
-	 * is a validation failure, which has already been checked by the
-	 * initial download.
-	 */
-	(void)load_fabric_serdes_firmware(dd, &fw_fabric);
-
 	clear_sbus_fast_mode(dd);
-	release_hw_mutex(dd);
+	release_chip_resource(dd, CR_SBUS);
 }
 
 /* Access to the SBus in this routine should probably be serialized */
@@ -1598,7 +1600,7 @@ int load_firmware(struct hfi1_devdata *dd)
 	int ret;
 
 	if (fw_fabric_serdes_load) {
-		ret = acquire_hw_mutex(dd);
+		ret = acquire_chip_resource(dd, CR_SBUS, SBUS_TIMEOUT);
 		if (ret)
 			return ret;
 
@@ -1614,7 +1616,7 @@ int load_firmware(struct hfi1_devdata *dd)
 		} while (retry_firmware(dd, ret));
 
 		clear_sbus_fast_mode(dd);
-		release_hw_mutex(dd);
+		release_chip_resource(dd, CR_SBUS);
 		if (ret)
 			return ret;
 	}
@@ -1995,7 +1997,7 @@ int get_platform_config_field(struct hfi1_devdata *dd,
  * Download the firmware needed for the Gen3 PCIe SerDes.  An update
  * to the SBus firmware is needed before updating the PCIe firmware.
  *
- * Note: caller must be holding the HW mutex.
+ * Note: caller must be holding the SBus resource.
  */
 int load_pcie_firmware(struct hfi1_devdata *dd)
 {
diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 1adfa8b..42a409f 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -773,7 +773,7 @@ static int load_eq_table(struct hfi1_devdata *dd, const u8 eq[11][3], u8 fs,
 /*
  * Steps to be done after the PCIe firmware is downloaded and
  * before the SBR for the Pcie Gen3.
- * The hardware mutex is already being held.
+ * The SBus resource is already being held.
  */
 static void pcie_post_steps(struct hfi1_devdata *dd)
 {
@@ -1012,10 +1012,13 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 		goto done_no_mutex;
 	}
 
-	/* hold the HW mutex across the firmware download and SBR */
-	ret = acquire_hw_mutex(dd);
-	if (ret)
+	/* hold the SBus resource across the firmware download and SBR */
+	ret = acquire_chip_resource(dd, CR_SBUS, SBUS_TIMEOUT);
+	if (ret) {
+		dd_dev_err(dd, "%s: unable to acquire SBus resource\n",
+			   __func__);
 		return ret;
+	}
 
 	/* make sure thermal polling is not causing interrupts */
 	therm = read_csr(dd, ASIC_CFG_THERM_POLL_EN);
@@ -1324,7 +1327,7 @@ done:
 		dd_dev_info(dd, "%s: Re-enable therm polling\n",
 			    __func__);
 	}
-	release_hw_mutex(dd);
+	release_chip_resource(dd, CR_SBUS);
 done_no_mutex:
 	/* return no error if it is OK to be at current speed */
 	if (ret && !return_error) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
