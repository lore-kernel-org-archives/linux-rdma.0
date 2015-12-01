From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 01/17] staging/rdma/hfi1: Support alternate firmware names
Date: Tue,  1 Dec 2015 15:38:10 -0500
Message-ID: <1449002306-15180-2-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add support for an automatic fallback for firmware names to support
debug-signed and production-signed firmware images.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Added more information in commit message

 drivers/staging/rdma/hfi1/firmware.c |  189 ++++++++++++++++++++++++++++------
 1 files changed, 157 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index f311282..35060de 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -68,6 +68,10 @@
 #define DEFAULT_FW_SBUS_NAME "hfi1_sbus.fw"
 #define DEFAULT_FW_PCIE_NAME "hfi1_pcie.fw"
 #define DEFAULT_PLATFORM_CONFIG_NAME "hfi1_platform.dat"
+#define ALT_FW_8051_NAME_ASIC "hfi1_dc8051_d.fw"
+#define ALT_FW_FABRIC_NAME "hfi1_fabric_d.fw"
+#define ALT_FW_SBUS_NAME "hfi1_sbus_d.fw"
+#define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
 
 static uint fw_8051_load = 1;
 static uint fw_fabric_serdes_load = 1;
@@ -158,7 +162,8 @@ struct firmware_details {
 static DEFINE_MUTEX(fw_mutex);
 enum fw_state {
 	FW_EMPTY,
-	FW_ACQUIRED,
+	FW_TRY,
+	FW_FINAL,
 	FW_ERR
 };
 static enum fw_state fw_state = FW_EMPTY;
@@ -428,8 +433,8 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 
 	ret = request_firmware(&fdet->fw, name, &dd->pcidev->dev);
 	if (ret) {
-		dd_dev_err(dd, "cannot load firmware \"%s\", err %d\n",
-			name, ret);
+		dd_dev_err(dd, "cannot find firmware \"%s\", err %d\n",
+			   name, ret);
 		return ret;
 	}
 
@@ -539,28 +544,53 @@ done:
 static void dispose_one_firmware(struct firmware_details *fdet)
 {
 	release_firmware(fdet->fw);
-	fdet->fw = NULL;
+	/* erase all previous information */
+	memset(fdet, 0, sizeof(*fdet));
 }
 
 /*
- * Called by all HFIs when loading their firmware - i.e. device probe time.
- * The first one will do the actual firmware load.  Use a mutex to resolve
- * any possible race condition.
+ * Obtain the 4 firmwares from the OS.  All must be obtained at once or not
+ * at all.  If called with the firmware state in FW_TRY, use alternate names.
+ * On exit, this routine will have set the firmware state to one of FW_TRY,
+ * FW_FINAL, or FW_ERR.
  *
- * The call to this routine cannot be moved to driver load because the kernel
- * call request_firmware() requires a device which is only available after
- * the first device probe.
+ * Must be holding fw_mutex.
  */
-static int obtain_firmware(struct hfi1_devdata *dd)
+static void __obtain_firmware(struct hfi1_devdata *dd)
 {
 	int err = 0;
 
-	mutex_lock(&fw_mutex);
-	if (fw_state == FW_ACQUIRED) {
-		goto done;	/* already acquired */
-	} else if (fw_state == FW_ERR) {
-		err = fw_err;
-		goto done;	/* already tried and failed */
+	if (fw_state == FW_FINAL)	/* nothing more to obtain */
+		return;
+	if (fw_state == FW_ERR)		/* already in error */
+		return;
+
+	/* fw_state is FW_EMPTY or FW_TRY */
+retry:
+	if (fw_state == FW_TRY) {
+		/*
+		 * We tried the original and it failed.  Move to the
+		 * alternate.
+		 */
+		dd_dev_info(dd, "using alternate firmware names\n");
+		/*
+		 * Let others run.  Some systems, when missing firmware, does
+		 * something that holds for 30 seconds.  If we do that twice
+		 * in a row it triggers task blocked warning.
+		 */
+		cond_resched();
+		if (fw_8051_load)
+			dispose_one_firmware(&fw_8051);
+		if (fw_fabric_serdes_load)
+			dispose_one_firmware(&fw_fabric);
+		if (fw_sbus_load)
+			dispose_one_firmware(&fw_sbus);
+		if (fw_pcie_serdes_load)
+			dispose_one_firmware(&fw_pcie);
+		fw_8051_name = ALT_FW_8051_NAME_ASIC;
+		fw_fabric_serdes_name = ALT_FW_FABRIC_NAME;
+		fw_sbus_name = ALT_FW_SBUS_NAME;
+		fw_pcie_serdes_name = ALT_FW_PCIE_NAME;
 	}
 
 	if (fw_8051_load) {
@@ -588,27 +618,82 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 			goto done;
 	}
 
+done:
+	if (err) {
+		/* oops, had problems obtaining a firmware */
+		if (fw_state == FW_EMPTY) {
+			/* retry with alternate */
+			fw_state = FW_TRY;
+			goto retry;
+		}
+		fw_state = FW_ERR;
+		fw_err = -ENOENT;
+	} else {
+		/* success */
+		if (fw_state == FW_EMPTY)
+			fw_state = FW_TRY;	/* may retry later */
+		else
+			fw_state = FW_FINAL;	/* cannot try again */
+	}
+}
+
+/*
+ * Called by all HFIs when loading their firmware - i.e. device probe time.
+ * The first one will do the actual firmware load.  Use a mutex to resolve
+ * any possible race condition.
+ *
+ * The call to this routine cannot be moved to driver load because the kernel
+ * call request_firmware() requires a device which is only available after
+ * the first device probe.
+ */
+static int obtain_firmware(struct hfi1_devdata *dd)
+{
+	unsigned long timeout;
+	int err = 0;
+
+	mutex_lock(&fw_mutex);
+
+	/* 40s delay due to long delay on missing firmware on some systems */
+	timeout = jiffies + msecs_to_jiffies(40000);
+	while (fw_state == FW_TRY) {
+		/*
+		 * Another device is trying the firmware.  Wait until it
+		 * decides what works (or not).
+		 */
+		if (time_after(jiffies, timeout)) {
+			/* waited too long */
+			dd_dev_err(dd, "Timeout waiting for firmware try");
+			fw_state = FW_ERR;
+			fw_err = -ETIMEDOUT;
+			break;
+		}
+		mutex_unlock(&fw_mutex);
+		msleep(20);	/* arbitrary delay */
+		mutex_lock(&fw_mutex);
+	}
+	/* not in FW_TRY state */
+
+	if (fw_state == FW_FINAL)
+		goto done;	/* already acquired */
+	else if (fw_state == FW_ERR)
+		goto done;	/* already tried and failed */
+	/* fw_state is FW_EMPTY */
+
+	/* set fw_state to FW_TRY, FW_FINAL, or FW_ERR, and fw_err */
+	__obtain_firmware(dd);
+
 	if (platform_config_load) {
 		platform_config = NULL;
 		err = request_firmware(&platform_config, platform_config_name,
 						&dd->pcidev->dev);
-		if (err) {
-			err = 0;
+		if (err)
 			platform_config = NULL;
-		}
 	}
 
-	/* success */
-	fw_state = FW_ACQUIRED;
-
 done:
-	if (err) {
-		fw_err = err;
-		fw_state = FW_ERR;
-	}
 	mutex_unlock(&fw_mutex);
 
-	return err;
+	return fw_err;
 }
 
 /*
@@ -638,6 +723,38 @@ void dispose_firmware(void)
 }
 
 /*
+ * Called with the result of a firmware download.
+ *
+ * Return 1 to retry loading the firmware, 0 to stop.
+ */
+static int retry_firmware(struct hfi1_devdata *dd, int load_result)
+{
+	int retry;
+
+	mutex_lock(&fw_mutex);
+
+	if (load_result == 0) {
+		/*
+		 * The load succeeded, so expect all others to do the same.
+		 * Do not retry again.
+		 */
+		if (fw_state == FW_TRY)
+			fw_state = FW_FINAL;
+		retry = 0;	/* do NOT retry */
+	} else if (fw_state == FW_TRY) {
+		/* load failed, obtain alternate firmware */
+		__obtain_firmware(dd);
+		retry = (fw_state == FW_FINAL);
+	} else {
+		/* else in FW_FINAL or FW_ERR, no retry in either case */
+		retry = 0;
+	}
+
+	mutex_unlock(&fw_mutex);
+	return retry;
+}
+
+/*
  * Write a block of data to a given array CSR.  All calls will be in
  * multiples of 8 bytes.
  */
@@ -1248,7 +1365,9 @@ int load_firmware(struct hfi1_devdata *dd)
 				fabric_serdes_addrs[dd->hfi1_id],
 				NUM_FABRIC_SERDES);
 		turn_off_spicos(dd, SPICO_FABRIC);
-		ret = load_fabric_serdes_firmware(dd, &fw_fabric);
+		do {
+			ret = load_fabric_serdes_firmware(dd, &fw_fabric);
+		} while (retry_firmware(dd, ret));
 
 		clear_sbus_fast_mode(dd);
 		release_hw_mutex(dd);
@@ -1257,7 +1376,9 @@ int load_firmware(struct hfi1_devdata *dd)
 	}
 
 	if (fw_8051_load) {
-		ret = load_8051_firmware(dd, &fw_8051);
+		do {
+			ret = load_8051_firmware(dd, &fw_8051);
+		} while (retry_firmware(dd, ret));
 		if (ret)
 			return ret;
 	}
@@ -1570,7 +1691,9 @@ int load_pcie_firmware(struct hfi1_devdata *dd)
 
 	if (fw_sbus_load) {
 		turn_off_spicos(dd, SPICO_SBUS);
-		ret = load_sbus_firmware(dd, &fw_sbus);
+		do {
+			ret = load_sbus_firmware(dd, &fw_sbus);
+		} while (retry_firmware(dd, ret));
 		if (ret)
 			goto done;
 	}
@@ -1581,7 +1704,9 @@ int load_pcie_firmware(struct hfi1_devdata *dd)
 					pcie_serdes_broadcast[dd->hfi1_id],
 					pcie_serdes_addrs[dd->hfi1_id],
 					NUM_PCIE_SERDES);
-		ret = load_pcie_serdes_firmware(dd, &fw_pcie);
+		do {
+			ret = load_pcie_serdes_firmware(dd, &fw_pcie);
+		} while (retry_firmware(dd, ret));
 		if (ret)
 			goto done;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
