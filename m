From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 4/8] IB/hfi1: Prevent LNI out of sync by resetting
 host interface version
Date: Mon, 02 Oct 2017 11:04:26 -0700
Message-ID: <20171002180424.31117.29079.stgit@scvm10.sc.intel.com>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002180204.31117.12254.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the link is disabled and re-enabled, the host version bit is not
set again, so the firmware behaves as though it’s interacting with an
old driver. This causes LNI to get out of sync. The host version bit
needs to be set at load_8051_firmware() and _dc_start(). Currently, it's
only set at load_8051_firmware().

Create a common function to set the bit with the intent to make the code
more maintainable in the future, set the host version bit at _dc_start()
and modify the 8051 command API to prevent a deadlock as _dc_start() is
already holding the dc8051 lock.

Fixes: 913cc67159bc ("IB/hfi1: Always perform offline transition")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   77 +++++++++++++++++++++++----------
 drivers/infiniband/hw/hfi1/chip.h     |    1 
 drivers/infiniband/hw/hfi1/firmware.c |   63 ++++++++++++++++++++-------
 3 files changed, 101 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 764a066..56bba8d 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6520,12 +6520,11 @@ static void _dc_start(struct hfi1_devdata *dd)
 	if (!dd->dc_shutdown)
 		return;
 
-	/* Take the 8051 out of reset */
-	write_csr(dd, DC_DC8051_CFG_RST, 0ull);
-	/* Wait until 8051 is ready */
-	if (wait_fm_ready(dd, TIMEOUT_8051_START))
-		dd_dev_err(dd, "%s: timeout starting 8051 firmware\n",
-			   __func__);
+	/*
+	 * Take the 8051 out of reset, wait until 8051 is ready, and set host
+	 * version bit.
+	 */
+	release_and_wait_ready_8051_firmware(dd);
 
 	/* Take away reset for LCB and RX FPE (set in lcb_shutdown). */
 	write_csr(dd, DCC_CFG_RESET, 0x10);
@@ -8595,30 +8594,23 @@ int write_lcb_csr(struct hfi1_devdata *dd, u32 addr, u64 data)
 }
 
 /*
+ * If the 8051 is in reset mode (dd->dc_shutdown == 1), this function
+ * will still continue executing.
+ *
  * Returns:
  *	< 0 = Linux error, not able to get access
  *	> 0 = 8051 command RETURN_CODE
  */
-static int do_8051_command(
-	struct hfi1_devdata *dd,
-	u32 type,
-	u64 in_data,
-	u64 *out_data)
+static int _do_8051_command(struct hfi1_devdata *dd, u32 type, u64 in_data,
+			    u64 *out_data)
 {
 	u64 reg, completed;
 	int return_code;
 	unsigned long timeout;
 
+	lockdep_assert_held(&dd->dc8051_lock);
 	hfi1_cdbg(DC8051, "type %d, data 0x%012llx", type, in_data);
 
-	mutex_lock(&dd->dc8051_lock);
-
-	/* We can't send any commands to the 8051 if it's in reset */
-	if (dd->dc_shutdown) {
-		return_code = -ENODEV;
-		goto fail;
-	}
-
 	/*
 	 * If an 8051 host command timed out previously, then the 8051 is
 	 * stuck.
@@ -8719,6 +8711,29 @@ static int do_8051_command(
 	write_csr(dd, DC_DC8051_CFG_HOST_CMD_0, 0);
 
 fail:
+	return return_code;
+}
+
+/*
+ * Returns:
+ *	< 0 = Linux error, not able to get access
+ *	> 0 = 8051 command RETURN_CODE
+ */
+static int do_8051_command(struct hfi1_devdata *dd, u32 type, u64 in_data,
+			   u64 *out_data)
+{
+	int return_code;
+
+	mutex_lock(&dd->dc8051_lock);
+	/* We can't send any commands to the 8051 if it's in reset */
+	if (dd->dc_shutdown) {
+		return_code = -ENODEV;
+		goto fail;
+	}
+
+	return_code = _do_8051_command(dd, type, in_data, out_data);
+
+fail:
 	mutex_unlock(&dd->dc8051_lock);
 	return return_code;
 }
@@ -8728,16 +8743,17 @@ static int set_physical_link_state(struct hfi1_devdata *dd, u64 state)
 	return do_8051_command(dd, HCMD_CHANGE_PHY_STATE, state, NULL);
 }
 
-int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
-		     u8 lane_id, u32 config_data)
+int _load_8051_config(struct hfi1_devdata *dd, u8 field_id,
+		      u8 lane_id, u32 config_data)
 {
 	u64 data;
 	int ret;
 
+	lockdep_assert_held(&dd->dc8051_lock);
 	data = (u64)field_id << LOAD_DATA_FIELD_ID_SHIFT
 		| (u64)lane_id << LOAD_DATA_LANE_ID_SHIFT
 		| (u64)config_data << LOAD_DATA_DATA_SHIFT;
-	ret = do_8051_command(dd, HCMD_LOAD_CONFIG_DATA, data, NULL);
+	ret = _do_8051_command(dd, HCMD_LOAD_CONFIG_DATA, data, NULL);
 	if (ret != HCMD_SUCCESS) {
 		dd_dev_err(dd,
 			   "load 8051 config: field id %d, lane %d, err %d\n",
@@ -8746,6 +8762,18 @@ int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
 	return ret;
 }
 
+int load_8051_config(struct hfi1_devdata *dd, u8 field_id,
+		     u8 lane_id, u32 config_data)
+{
+	int return_code;
+
+	mutex_lock(&dd->dc8051_lock);
+	return_code = _load_8051_config(dd, field_id, lane_id, config_data);
+	mutex_unlock(&dd->dc8051_lock);
+
+	return return_code;
+}
+
 /*
  * Read the 8051 firmware "registers".  Use the RAM directly.  Always
  * set the result, even on error.
@@ -8861,13 +8889,14 @@ int write_host_interface_version(struct hfi1_devdata *dd, u8 version)
 	u32 frame;
 	u32 mask;
 
+	lockdep_assert_held(&dd->dc8051_lock);
 	mask = (HOST_INTERFACE_VERSION_MASK << HOST_INTERFACE_VERSION_SHIFT);
 	read_8051_config(dd, RESERVED_REGISTERS, GENERAL_CONFIG, &frame);
 	/* Clear, then set field */
 	frame &= ~mask;
 	frame |= ((u32)version << HOST_INTERFACE_VERSION_SHIFT);
-	return load_8051_config(dd, RESERVED_REGISTERS, GENERAL_CONFIG,
-				frame);
+	return _load_8051_config(dd, RESERVED_REGISTERS, GENERAL_CONFIG,
+				 frame);
 }
 
 void read_misc_status(struct hfi1_devdata *dd, u8 *ver_major, u8 *ver_minor,
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 50b8645..213b6a3 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -710,6 +710,7 @@ void read_misc_status(struct hfi1_devdata *dd, u8 *ver_major, u8 *ver_minor,
 		      u8 *ver_patch);
 int write_host_interface_version(struct hfi1_devdata *dd, u8 version);
 void read_guid(struct hfi1_devdata *dd);
+int release_and_wait_ready_8051_firmware(struct hfi1_devdata *dd);
 int wait_fm_ready(struct hfi1_devdata *dd, u32 mstimeout);
 void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
 			  u8 neigh_reason, u8 rem_reason);
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 9471c40..dee3c67 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -971,6 +971,46 @@ int wait_fm_ready(struct hfi1_devdata *dd, u32 mstimeout)
 }
 
 /*
+ * Clear all reset bits, releasing the 8051.
+ * Wait for firmware to be ready to accept host requests.
+ * Then, set host version bit.
+ *
+ * This function executes even if the 8051 is in reset mode when
+ * dd->dc_shutdown == 1.
+ *
+ * Expects dd->dc8051_lock to be held.
+ */
+int release_and_wait_ready_8051_firmware(struct hfi1_devdata *dd)
+{
+	int ret;
+
+	lockdep_assert_held(&dd->dc8051_lock);
+	/* clear all reset bits, releasing the 8051 */
+	write_csr(dd, DC_DC8051_CFG_RST, 0ull);
+
+	/*
+	 * Wait for firmware to be ready to accept host
+	 * requests.
+	 */
+	ret = wait_fm_ready(dd, TIMEOUT_8051_START);
+	if (ret) {
+		dd_dev_err(dd, "8051 start timeout, current FW state 0x%x\n",
+			   get_firmware_state(dd));
+		return ret;
+	}
+
+	ret = write_host_interface_version(dd, HOST_INTERFACE_VERSION);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd,
+			   "Failed to set host interface version, return 0x%x\n",
+			   ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
  * Load the 8051 firmware.
  */
 static int load_8051_firmware(struct hfi1_devdata *dd,
@@ -1035,31 +1075,22 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 	if (ret)
 		return ret;
 
-	/* clear all reset bits, releasing the 8051 */
-	write_csr(dd, DC_DC8051_CFG_RST, 0ull);
-
 	/*
+	 * Clear all reset bits, releasing the 8051.
 	 * DC reset step 5. Wait for firmware to be ready to accept host
 	 * requests.
+	 * Then, set host version bit.
 	 */
-	ret = wait_fm_ready(dd, TIMEOUT_8051_START);
-	if (ret) { /* timed out */
-		dd_dev_err(dd, "8051 start timeout, current state 0x%x\n",
-			   get_firmware_state(dd));
-		return -ETIMEDOUT;
-	}
+	mutex_lock(&dd->dc8051_lock);
+	ret = release_and_wait_ready_8051_firmware(dd);
+	mutex_unlock(&dd->dc8051_lock);
+	if (ret)
+		return ret;
 
 	read_misc_status(dd, &ver_major, &ver_minor, &ver_patch);
 	dd_dev_info(dd, "8051 firmware version %d.%d.%d\n",
 		    (int)ver_major, (int)ver_minor, (int)ver_patch);
 	dd->dc8051_ver = dc8051_ver(ver_major, ver_minor, ver_patch);
-	ret = write_host_interface_version(dd, HOST_INTERFACE_VERSION);
-	if (ret != HCMD_SUCCESS) {
-		dd_dev_err(dd,
-			   "Failed to set host interface version, return 0x%x\n",
-			   ret);
-		return -EIO;
-	}
 
 	return 0;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
