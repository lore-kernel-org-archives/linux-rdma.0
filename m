From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/8] IB/hfi1: Load fallback platform configuration
 per HFI device
Date: Sun, 13 Aug 2017 08:08:40 -0700
Message-ID: <20170813150839.23208.92277.stgit@scvm10.sc.intel.com>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813150659.23208.66243.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently fallback configuration is loaded once per driver instance.
With multiple HFI devices in the same system the current code may not
load the platform config data for the device. Change fallback platform
config data loading to be per device.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.h     |    1 -
 drivers/infiniband/hw/hfi1/firmware.c |   51 ++-------------------------------
 drivers/infiniband/hw/hfi1/platform.c |   41 ++++++++++++++++++---------
 3 files changed, 31 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index f708302..fc21097 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -648,7 +648,6 @@ u64 create_pbc(struct hfi1_pportdata *ppd, u64 flags, int srate_mbs, u32 vl,
 #define NUM_PCIE_SERDES 16	/* number of PCIe serdes on the SBus */
 extern const u8 pcie_serdes_broadcast[];
 extern const u8 pcie_pcs_addrs[2][NUM_PCIE_SERDES];
-extern uint platform_config_load;
 
 /* SBus commands */
 #define RESET_SBUS_RECEIVER 0x20
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index fb095e6..5aea8f4 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -64,7 +64,6 @@
 #define DEFAULT_FW_FABRIC_NAME "hfi1_fabric.fw"
 #define DEFAULT_FW_SBUS_NAME "hfi1_sbus.fw"
 #define DEFAULT_FW_PCIE_NAME "hfi1_pcie.fw"
-#define DEFAULT_PLATFORM_CONFIG_NAME "hfi1_platform.dat"
 #define ALT_FW_8051_NAME_ASIC "hfi1_dc8051_d.fw"
 #define ALT_FW_FABRIC_NAME "hfi1_fabric_d.fw"
 #define ALT_FW_SBUS_NAME "hfi1_sbus_d.fw"
@@ -76,19 +75,11 @@
 static uint fw_pcie_serdes_load = 1;
 static uint fw_sbus_load = 1;
 
-/*
- * Access required in platform.c
- * Maintains state of whether the platform config was fetched via the
- * fallback option
- */
-uint platform_config_load;
-
 /* Firmware file names get set in hfi1_firmware_init() based on the above */
 static char *fw_8051_name;
 static char *fw_fabric_serdes_name;
 static char *fw_sbus_name;
 static char *fw_pcie_serdes_name;
-static char *platform_config_name;
 
 #define SBUS_MAX_POLL_COUNT 100
 #define SBUS_COUNTER(reg, name) \
@@ -178,7 +169,6 @@ enum fw_state {
 static struct firmware_details fw_fabric;
 static struct firmware_details fw_pcie;
 static struct firmware_details fw_sbus;
-static const struct firmware *platform_config;
 
 /* flags for turn_off_spicos() */
 #define SPICO_SBUS   0x1
@@ -684,7 +674,6 @@ static void __obtain_firmware(struct hfi1_devdata *dd)
 static int obtain_firmware(struct hfi1_devdata *dd)
 {
 	unsigned long timeout;
-	int err = 0;
 
 	mutex_lock(&fw_mutex);
 
@@ -708,38 +697,11 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 	}
 	/* not in FW_TRY state */
 
-	if (fw_state == FW_FINAL) {
-		if (platform_config) {
-			dd->platform_config.data = platform_config->data;
-			dd->platform_config.size = platform_config->size;
-		}
-		goto done;	/* already acquired */
-	} else if (fw_state == FW_ERR) {
-		goto done;	/* already tried and failed */
-	}
-	/* fw_state is FW_EMPTY */
-
 	/* set fw_state to FW_TRY, FW_FINAL, or FW_ERR, and fw_err */
-	__obtain_firmware(dd);
-
-	if (platform_config_load) {
-		platform_config = NULL;
-		err = request_firmware(&platform_config, platform_config_name,
-				       &dd->pcidev->dev);
-		if (err) {
-			platform_config = NULL;
-			dd_dev_err(dd,
-				   "%s: No default platform config file found\n",
-				   __func__);
-			goto done;
-		}
-		dd->platform_config.data = platform_config->data;
-		dd->platform_config.size = platform_config->size;
-	}
+	if (fw_state == FW_EMPTY)
+		__obtain_firmware(dd);
 
-done:
 	mutex_unlock(&fw_mutex);
-
 	return fw_err;
 }
 
@@ -761,9 +723,6 @@ void dispose_firmware(void)
 	dispose_one_firmware(&fw_pcie);
 	dispose_one_firmware(&fw_sbus);
 
-	release_firmware(platform_config);
-	platform_config = NULL;
-
 	/* retain the error state, otherwise revert to empty */
 	if (fw_state != FW_ERR)
 		fw_state = FW_EMPTY;
@@ -1725,10 +1684,8 @@ int hfi1_firmware_init(struct hfi1_devdata *dd)
 	}
 
 	/* no 8051 or QSFP on simulator */
-	if (dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
+	if (dd->icode == ICODE_FUNCTIONAL_SIMULATOR)
 		fw_8051_load = 0;
-		platform_config_load = 0;
-	}
 
 	if (!fw_8051_name) {
 		if (dd->icode == ICODE_RTL_SILICON)
@@ -1742,8 +1699,6 @@ int hfi1_firmware_init(struct hfi1_devdata *dd)
 		fw_sbus_name = DEFAULT_FW_SBUS_NAME;
 	if (!fw_pcie_serdes_name)
 		fw_pcie_serdes_name = DEFAULT_FW_PCIE_NAME;
-	if (!platform_config_name)
-		platform_config_name = DEFAULT_PLATFORM_CONFIG_NAME;
 
 	return obtain_firmware(dd);
 }
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index ab221b0..8004f1d 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -45,10 +45,14 @@
  *
  */
 
+#include <linux/firmware.h>
+
 #include "hfi.h"
 #include "efivar.h"
 #include "eprom.h"
 
+#define DEFAULT_PLATFORM_CONFIG_NAME "hfi1_platform.dat"
+
 static int validate_scratch_checksum(struct hfi1_devdata *dd)
 {
 	u64 checksum = 0, temp_scratch = 0;
@@ -147,6 +151,7 @@ void get_platform_config(struct hfi1_devdata *dd)
 	int ret = 0;
 	u8 *temp_platform_config = NULL;
 	u32 esize;
+	const struct firmware *platform_config_file = NULL;
 
 	if (is_integrated(dd)) {
 		if (validate_scratch_checksum(dd)) {
@@ -167,23 +172,33 @@ void get_platform_config(struct hfi1_devdata *dd)
 	dd_dev_err(dd,
 		   "%s: Failed to get platform config, falling back to sub-optimal default file\n",
 		   __func__);
-	/* fall back to request firmware */
-	platform_config_load = 1;
-}
 
-void free_platform_config(struct hfi1_devdata *dd)
-{
-	if (!platform_config_load) {
-		/*
-		 * was loaded from EFI or the EPROM, release memory
-		 * allocated by read_efi_var/eprom_read_platform_config
-		 */
-		kfree(dd->platform_config.data);
+	ret = request_firmware(&platform_config_file,
+			       DEFAULT_PLATFORM_CONFIG_NAME,
+			       &dd->pcidev->dev);
+	if (ret) {
+		dd_dev_err(dd,
+			   "%s: No default platform config file found\n",
+			   __func__);
+		return;
 	}
+
 	/*
-	 * else do nothing, dispose_firmware will release
-	 * struct firmware platform_config on driver exit
+	 * Allocate separate memory block to store data and free firmware
+	 * structure. This allows free_platform_config to treat EPROM and
+	 * fallback configs in the same manner.
 	 */
+	dd->platform_config.data = kmemdup(platform_config_file->data,
+					   platform_config_file->size,
+					   GFP_KERNEL);
+	dd->platform_config.size = platform_config_file->size;
+	release_firmware(platform_config_file);
+}
+
+void free_platform_config(struct hfi1_devdata *dd)
+{
+	/* Release memory allocated for eprom or fallback file read. */
+	kfree(dd->platform_config.data);
 }
 
 void get_port_type(struct hfi1_pportdata *ppd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
