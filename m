From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 12/20] IB/hfi1: Add a patch value to the firmware version
 string
Date: Mon, 20 Mar 2017 17:25:48 -0700
Message-ID: <20170321002547.28538.72730.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The HFI firmware now includes a patch level in its version.
Updating the necessary code to include the patch version in the
firmware string.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   23 +++++++++++++++--------
 drivers/infiniband/hw/hfi1/chip.h     |   18 +++++++++++-------
 drivers/infiniband/hw/hfi1/firmware.c |   14 ++++++++------
 drivers/infiniband/hw/hfi1/hfi.h      |    9 +++++----
 drivers/infiniband/hw/hfi1/verbs.c    |   14 ++++++++------
 5 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index f9d0d8c..77f4b41 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -7166,7 +7166,7 @@ static void get_link_widths(struct hfi1_devdata *dd, u16 *tx_width,
 	 * set the max_rate field in handle_verify_cap until v0.19.
 	 */
 	if ((dd->icode == ICODE_RTL_SILICON) &&
-	    (dd->dc8051_ver < dc8051_ver(0, 19))) {
+	    (dd->dc8051_ver < dc8051_ver(0, 19, 0))) {
 		/* max_rate: 0 = 12.5G, 1 = 25G */
 		switch (max_rate) {
 		case 0:
@@ -7351,7 +7351,7 @@ void handle_verify_cap(struct work_struct *work)
 	}
 
 	ppd->link_speed_active = 0;	/* invalid value */
-	if (dd->dc8051_ver < dc8051_ver(0, 20)) {
+	if (dd->dc8051_ver < dc8051_ver(0, 20, 0)) {
 		/* remote_tx_rate: 0 = 12.5G, 1 = 25G */
 		switch (remote_tx_rate) {
 		case 0:
@@ -8422,7 +8422,7 @@ static int write_lcb_via_8051(struct hfi1_devdata *dd, u32 addr, u64 data)
 	int ret;
 
 	if (dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
-	    (dd->dc8051_ver < dc8051_ver(0, 20))) {
+	    (dd->dc8051_ver < dc8051_ver(0, 20, 0))) {
 		if (acquire_lcb_access(dd, 0) == 0) {
 			write_csr(dd, addr, data);
 			release_lcb_access(dd, 0);
@@ -8728,13 +8728,20 @@ static void read_remote_device_id(struct hfi1_devdata *dd, u16 *device_id,
 			& REMOTE_DEVICE_REV_MASK;
 }
 
-void read_misc_status(struct hfi1_devdata *dd, u8 *ver_a, u8 *ver_b)
+void read_misc_status(struct hfi1_devdata *dd, u8 *ver_major, u8 *ver_minor,
+		      u8 *ver_patch)
 {
 	u32 frame;
 
 	read_8051_config(dd, MISC_STATUS, GENERAL_CONFIG, &frame);
-	*ver_a = (frame >> STS_FM_VERSION_A_SHIFT) & STS_FM_VERSION_A_MASK;
-	*ver_b = (frame >> STS_FM_VERSION_B_SHIFT) & STS_FM_VERSION_B_MASK;
+	*ver_major = (frame >> STS_FM_VERSION_MAJOR_SHIFT) &
+		STS_FM_VERSION_MAJOR_MASK;
+	*ver_minor = (frame >> STS_FM_VERSION_MINOR_SHIFT) &
+		STS_FM_VERSION_MINOR_MASK;
+
+	read_8051_config(dd, VERSION_PATCH, GENERAL_CONFIG, &frame);
+	*ver_patch = (frame >> STS_FM_VERSION_PATCH_SHIFT) &
+		STS_FM_VERSION_PATCH_MASK;
 }
 
 static void read_vc_remote_phy(struct hfi1_devdata *dd, u8 *power_management,
@@ -9130,7 +9137,7 @@ static int set_local_link_attributes(struct hfi1_pportdata *ppd)
 	if (ret)
 		goto set_local_link_attributes_fail;
 
-	if (dd->dc8051_ver < dc8051_ver(0, 20)) {
+	if (dd->dc8051_ver < dc8051_ver(0, 20, 0)) {
 		/* set the tx rate to the fastest enabled */
 		if (ppd->link_speed_enabled & OPA_LINK_SPEED_25G)
 			ppd->local_tx_rate = 1;
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 043fd21..24df45f 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -1,7 +1,7 @@
 #ifndef _CHIP_H
 #define _CHIP_H
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -394,7 +394,8 @@
 #define LAST_REMOTE_STATE_COMPLETE   0x13
 #define LINK_QUALITY_INFO            0x14
 #define REMOTE_DEVICE_ID	     0x15
-#define LINK_DOWN_REASON	     0x16
+#define LINK_DOWN_REASON	     0x16 /* first byte of offset 0x16 */
+#define VERSION_PATCH		     0x16 /* last byte of offset 0x16 */
 
 /* 8051 lane specific register field IDs */
 #define TX_EQ_SETTINGS		0x00
@@ -524,10 +525,12 @@ enum {
 #define SUPPORTED_CRCS (CAP_CRC_14B | CAP_CRC_48B)
 
 /* misc status version fields */
-#define STS_FM_VERSION_A_SHIFT 16
-#define STS_FM_VERSION_A_MASK  0xff
-#define STS_FM_VERSION_B_SHIFT 24
-#define STS_FM_VERSION_B_MASK  0xff
+#define STS_FM_VERSION_MINOR_SHIFT 16
+#define STS_FM_VERSION_MINOR_MASK  0xff
+#define STS_FM_VERSION_MAJOR_SHIFT 24
+#define STS_FM_VERSION_MAJOR_MASK  0xff
+#define STS_FM_VERSION_PATCH_SHIFT 24
+#define STS_FM_VERSION_PATCH_MASK  0xff
 
 /* LCB_CFG_CRC_MODE TX_VAL and RX_VAL CRC mode values */
 #define LCB_CRC_16B			0x0	/* 16b CRC */
@@ -698,7 +701,8 @@ bool check_chip_resource(struct hfi1_devdata *dd, u32 resource,
 int read_8051_data(struct hfi1_devdata *dd, u32 addr, u32 len, u64 *result);
 
 /* chip.c */
-void read_misc_status(struct hfi1_devdata *dd, u8 *ver_a, u8 *ver_b);
+void read_misc_status(struct hfi1_devdata *dd, u8 *ver_major, u8 *ver_minor,
+		      u8 *ver_patch);
 void read_guid(struct hfi1_devdata *dd);
 int wait_fm_ready(struct hfi1_devdata *dd, u32 mstimeout);
 void set_link_down_reason(struct hfi1_pportdata *ppd, u8 lcl_reason,
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 0dd50cd..4042c11 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2015, 2016 Intel Corporation.
+ * Copyright(c) 2015 - 2017 Intel Corporation.
  *
  * This file is provided under a dual BSD/GPLv2 license.  When using or
  * redistributing this file, you may do so under either license.
@@ -1004,7 +1004,9 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 {
 	u64 reg;
 	int ret;
-	u8 ver_a, ver_b;
+	u8 ver_major;
+	u8 ver_minor;
+	u8 ver_patch;
 
 	/*
 	 * DC Reset sequence
@@ -1073,10 +1075,10 @@ static int load_8051_firmware(struct hfi1_devdata *dd,
 		return -ETIMEDOUT;
 	}
 
-	read_misc_status(dd, &ver_a, &ver_b);
-	dd_dev_info(dd, "8051 firmware version %d.%d\n",
-		    (int)ver_b, (int)ver_a);
-	dd->dc8051_ver = dc8051_ver(ver_b, ver_a);
+	read_misc_status(dd, &ver_major, &ver_minor, &ver_patch);
+	dd_dev_info(dd, "8051 firmware version %d.%d.%d\n",
+		    (int)ver_major, (int)ver_minor, (int)ver_patch);
+	dd->dc8051_ver = dc8051_ver(ver_major, ver_minor, ver_patch);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index b69ab47..a31638c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1020,7 +1020,7 @@ struct hfi1_devdata {
 	u8 qos_shift;
 
 	u16 irev;	/* implementation revision */
-	u16 dc8051_ver; /* 8051 firmware version */
+	u32 dc8051_ver; /* 8051 firmware version */
 
 	spinlock_t hfi1_diag_trans_lock; /* protect diag observer ops */
 	struct platform_config platform_config;
@@ -1173,9 +1173,10 @@ struct hfi1_devdata {
 };
 
 /* 8051 firmware version helper */
-#define dc8051_ver(a, b) ((a) << 8 | (b))
-#define dc8051_ver_maj(a) ((a & 0xff00) >> 8)
-#define dc8051_ver_min(a)  (a & 0x00ff)
+#define dc8051_ver(a, b, c) ((a) << 16 | (b) << 8 | (c))
+#define dc8051_ver_maj(a) (((a) & 0xff0000) >> 16)
+#define dc8051_ver_min(a) (((a) & 0x00ff00) >> 8)
+#define dc8051_ver_patch(a) ((a) & 0x0000ff)
 
 /* f_put_tid types */
 #define PT_EXPECTED 0
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 8d71654..928918c 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1236,12 +1236,14 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 {
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
-	u16 ver = dd->dc8051_ver;
+	u32 ver = dd->dc8051_ver;
 
 	memset(&rdi->dparms.props, 0, sizeof(rdi->dparms.props));
 
-	rdi->dparms.props.fw_ver = ((u64)(dc8051_ver_maj(ver)) << 16) |
-				    (u64)dc8051_ver_min(ver);
+	rdi->dparms.props.fw_ver = ((u64)(dc8051_ver_maj(ver)) << 32) |
+		((u64)(dc8051_ver_min(ver)) << 16) |
+		(u64)dc8051_ver_patch(ver);
+
 	rdi->dparms.props.device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
 			IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
 			IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
@@ -1520,10 +1522,10 @@ static void hfi1_get_dev_fw_str(struct ib_device *ibdev, char *str,
 {
 	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
 	struct hfi1_ibdev *dev = dev_from_rdi(rdi);
-	u16 ver = dd_from_dev(dev)->dc8051_ver;
+	u32 ver = dd_from_dev(dev)->dc8051_ver;
 
-	snprintf(str, str_len, "%u.%u", dc8051_ver_maj(ver),
-		 dc8051_ver_min(ver));
+	snprintf(str, str_len, "%u.%u.%u", dc8051_ver_maj(ver),
+		 dc8051_ver_min(ver), dc8051_ver_patch(ver));
 }
 
 static const char * const driver_cntr_names[] = {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
