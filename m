From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 8/8] IB/hfi1: Always perform offline transition
Date: Sat, 29 Jul 2017 08:44:01 -0700
Message-ID: <20170729154400.21487.84086.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Always initiate an offline transition request
when a link down occurs. The firmware will
use this request to confirm that the driver
has seen the link down message. A host version
is set to indicate this driver behavior to the
firmware.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   66 +++++++++++++++++----------------
 drivers/infiniband/hw/hfi1/chip.h     |    5 +++
 drivers/infiniband/hw/hfi1/firmware.c |    8 ++++
 3 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index a3af46c..101fbbb 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8832,6 +8832,20 @@ static void read_remote_device_id(struct hfi1_devdata *dd, u16 *device_id,
 			& REMOTE_DEVICE_REV_MASK;
 }
 
+int write_host_interface_version(struct hfi1_devdata *dd, u8 version)
+{
+	u32 frame;
+	u32 mask;
+
+	mask = (HOST_INTERFACE_VERSION_MASK << HOST_INTERFACE_VERSION_SHIFT);
+	read_8051_config(dd, RESERVED_REGISTERS, GENERAL_CONFIG, &frame);
+	/* Clear, then set field */
+	frame &= ~mask;
+	frame |= ((u32)version << HOST_INTERFACE_VERSION_SHIFT);
+	return load_8051_config(dd, RESERVED_REGISTERS, GENERAL_CONFIG,
+				frame);
+}
+
 void read_misc_status(struct hfi1_devdata *dd, u8 *ver_major, u8 *ver_minor,
 		      u8 *ver_patch)
 {
@@ -10262,49 +10276,35 @@ static void force_logical_link_state_down(struct hfi1_pportdata *ppd)
 static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 {
 	struct hfi1_devdata *dd = ppd->dd;
-	u32 pstate, previous_state;
+	u32 previous_state;
 	int ret;
-	int do_transition;
-	int do_wait;
 
 	update_lcb_cache(dd);
 
 	previous_state = ppd->host_link_state;
 	ppd->host_link_state = HLS_GOING_OFFLINE;
-	pstate = read_physical_state(dd);
-	if (pstate == PLS_OFFLINE) {
-		do_transition = 0;	/* in right state */
-		do_wait = 0;		/* ...no need to wait */
-	} else if ((pstate & 0xf0) == PLS_OFFLINE) {
-		do_transition = 0;	/* in an offline transient state */
-		do_wait = 1;		/* ...wait for it to settle */
-	} else {
-		do_transition = 1;	/* need to move to offline */
-		do_wait = 1;		/* ...will need to wait */
-	}
 
-	if (do_transition) {
-		ret = set_physical_link_state(dd,
-					      (rem_reason << 8) | PLS_OFFLINE);
+	/* start offline transition */
+	ret = set_physical_link_state(dd, (rem_reason << 8) | PLS_OFFLINE);
 
-		if (ret != HCMD_SUCCESS) {
-			dd_dev_err(dd,
-				   "Failed to transition to Offline link state, return %d\n",
-				   ret);
-			return -EINVAL;
-		}
-		if (ppd->offline_disabled_reason ==
-				HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE))
-			ppd->offline_disabled_reason =
-			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_TRANSIENT);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd,
+			   "Failed to transition to Offline link state, return %d\n",
+			   ret);
+		return -EINVAL;
 	}
+	if (ppd->offline_disabled_reason ==
+			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE))
+		ppd->offline_disabled_reason =
+		HFI1_ODR_MASK(OPA_LINKDOWN_REASON_TRANSIENT);
 
-	if (do_wait) {
-		/* it can take a while for the link to go down */
-		ret = wait_physical_linkstate(ppd, PLS_OFFLINE, 10000);
-		if (ret < 0)
-			return ret;
-	}
+	/*
+	 * Wait for offline transition. It can take a while for
+	 * the link to go down.
+	 */
+	ret = wait_physical_linkstate(ppd, PLS_OFFLINE, 10000);
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * Now in charge of LCB - must be after the physical state is
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index bef6301..6a0c691 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -384,6 +384,7 @@
 #define VERIFY_CAP_LOCAL_FABRIC	     0x08
 #define VERIFY_CAP_LOCAL_LINK_WIDTH  0x09
 #define LOCAL_DEVICE_ID		     0x0a
+#define RESERVED_REGISTERS	     0x0b
 #define LOCAL_LNI_INFO		     0x0c
 #define REMOTE_LNI_INFO              0x0d
 #define MISC_STATUS		     0x0e
@@ -506,6 +507,9 @@
 #define DOWN_REMOTE_REASON_SHIFT 16
 #define DOWN_REMOTE_REASON_MASK  0xff
 
+#define HOST_INTERFACE_VERSION_SHIFT 16
+#define HOST_INTERFACE_VERSION_MASK  0xff
+
 /* verify capability PHY power management bits */
 #define PWRM_BER_CONTROL	0x1
 #define PWRM_BANDWIDTH_CONTROL	0x2
@@ -704,6 +708,7 @@ bool check_chip_resource(struct hfi1_devdata *dd, u32 resource,
 /* chip.c */
 void read_misc_status(struct hfi1_devdata *dd, u8 *ver_major, u8 *ver_minor,
 		      u8 *ver_patch);
+int write_host_interface_version(struct hfi1_devdata *dd, u8 version);
 void read_guid(struct hfi1_devdata *dd);
 int wait_fm_ready(struct hfi1_devdata *dd, u32 mstimeout);
 void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 83efd6b..885714b 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -69,6 +69,7 @@
 #define ALT_FW_FABRIC_NAME "hfi1_fabric_d.fw"
 #define ALT_FW_SBUS_NAME "hfi1_sbus_d.fw"
 #define ALT_FW_PCIE_NAME "hfi1_pcie_d.fw"
+#define HOST_INTERFACE_VERSION 1
 
 static uint fw_8051_load = 1;
 static uint fw_fabric_serdes_load = 1;
@@ -1087,6 +1088,13 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 	dd_dev_info(dd, "8051 firmware version %d.%d.%d\n",
 		    (int)ver_major, (int)ver_minor, (int)ver_patch);
 	dd->dc8051_ver = dc8051_ver(ver_major, ver_minor, ver_patch);
+	ret = write_host_interface_version(dd, HOST_INTERFACE_VERSION);
+	if (ret != HCMD_SUCCESS) {
+		dd_dev_err(dd,
+			   "Failed to set host interface version, return 0x%x\n",
+			   ret);
+		return -EIO;
+	}
 
 	return 0;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
