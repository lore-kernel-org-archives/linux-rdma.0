From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/21] IB/hfi1: Always turn on CDRs for low power QSFP
 modules
Date: Tue, 12 Apr 2016 11:25:31 -0700
Message-ID: <20160412182511.25238.84749.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clock and data recovery mechanisms (CDRs) in active QSFP modules
can be turned on or off to improve the bit error rate observed on
the channel. Signal integrity and bit error rate requirements require
us to always turn on any CDRs present in low power cables (power
dissipation 2.5W or lower). However, we adhere to the platform
designer's settings (provided in the platform configuration) for
higher power cables (dissipation 3.5W or higher) if the platform
designer has determined that the platform requires the CDRs to be
turned on (or off) and is capable of supplying and cooling the higher
power modules.

This patch also introduces the get_qsfp_power_class function to
centralize the bit twiddling required to determine the QSFP power class
across the code. Reusing this function improves the readability of code
that depends on knowing the power class of the cable, such as the
active and optical channel tuning algorithm.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |   49 +++------------------------------
 drivers/staging/rdma/hfi1/chip.h     |    1 -
 drivers/staging/rdma/hfi1/hfi.h      |    1 -
 drivers/staging/rdma/hfi1/init.c     |    1 -
 drivers/staging/rdma/hfi1/platform.c |   51 +++++++++++++++++++---------------
 drivers/staging/rdma/hfi1/qsfp.c     |   38 +++++++++++++++++++++++--
 drivers/staging/rdma/hfi1/qsfp.h     |   15 +++++-----
 7 files changed, 74 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b0a0a0d..962cca0 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6199,18 +6199,13 @@ static void hreq_response(struct hfi1_devdata *dd, u8 return_code, u16 rsp_data)
 
 /*
  * Handle host requests from the 8051.
- *
- * This is a work-queue function outside of the interrupt.
  */
-void handle_8051_request(struct work_struct *work)
+static void handle_8051_request(struct hfi1_pportdata *ppd)
 {
-	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
-							dc_host_req_work);
 	struct hfi1_devdata *dd = ppd->dd;
 	u64 reg;
 	u16 data = 0;
-	u8 type, i, lanes, *cache = ppd->qsfp_info.cache;
-	u8 cdr_ctrl_byte = cache[QSFP_CDR_CTRL_BYTE_OFFS];
+	u8 type;
 
 	reg = read_csr(dd, DC_DC8051_CFG_EXT_DEV_1);
 	if ((reg & DC_DC8051_CFG_EXT_DEV_1_REQ_NEW_SMASK) == 0)
@@ -6231,46 +6226,11 @@ void handle_8051_request(struct work_struct *work)
 	case HREQ_READ_CONFIG:
 	case HREQ_SET_TX_EQ_ABS:
 	case HREQ_SET_TX_EQ_REL:
+	case HREQ_ENABLE:
 		dd_dev_info(dd, "8051 request: request 0x%x not supported\n",
 			    type);
 		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
 		break;
-
-	case HREQ_ENABLE:
-		lanes = data & 0xF;
-		for (i = 0; lanes; lanes >>= 1, i++) {
-			if (!(lanes & 1))
-				continue;
-			if (data & 0x200) {
-				/* enable TX CDR */
-				if (cache[QSFP_MOD_PWR_OFFS] & 0x8 &&
-				    cache[QSFP_CDR_INFO_OFFS] & 0x80)
-					cdr_ctrl_byte |= (1 << (i + 4));
-			} else {
-				/* disable TX CDR */
-				if (cache[QSFP_MOD_PWR_OFFS] & 0x8 &&
-				    cache[QSFP_CDR_INFO_OFFS] & 0x80)
-					cdr_ctrl_byte &= ~(1 << (i + 4));
-			}
-
-			if (data & 0x800) {
-				/* enable RX CDR */
-				if (cache[QSFP_MOD_PWR_OFFS] & 0x4 &&
-				    cache[QSFP_CDR_INFO_OFFS] & 0x40)
-					cdr_ctrl_byte |= (1 << i);
-			} else {
-				/* disable RX CDR */
-				if (cache[QSFP_MOD_PWR_OFFS] & 0x4 &&
-				    cache[QSFP_CDR_INFO_OFFS] & 0x40)
-					cdr_ctrl_byte &= ~(1 << i);
-			}
-		}
-		one_qsfp_write(ppd, dd->hfi1_id, QSFP_CDR_CTRL_BYTE_OFFS,
-			       &cdr_ctrl_byte, 1);
-		hreq_response(dd, HREQ_SUCCESS, data);
-		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
-		break;
-
 	case HREQ_CONFIG_DONE:
 		hreq_response(dd, HREQ_SUCCESS, 0);
 		break;
@@ -6278,7 +6238,6 @@ void handle_8051_request(struct work_struct *work)
 	case HREQ_INTERFACE_TEST:
 		hreq_response(dd, HREQ_SUCCESS, data);
 		break;
-
 	default:
 		dd_dev_err(dd, "8051 request: unknown request 0x%x\n", type);
 		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
@@ -7534,7 +7493,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			host_msg &= ~(u64)LINKUP_ACHIEVED;
 		}
 		if (host_msg & EXT_DEVICE_CFG_REQ) {
-			queue_work(ppd->hfi1_wq, &ppd->dc_host_req_work);
+			handle_8051_request(ppd);
 			host_msg &= ~(u64)EXT_DEVICE_CFG_REQ;
 		}
 		if (host_msg & VERIFY_CAP_FRAME) {
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 4f3b878..e02e006 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -691,7 +691,6 @@ void handle_verify_cap(struct work_struct *work);
 void handle_freeze(struct work_struct *work);
 void handle_link_up(struct work_struct *work);
 void handle_link_down(struct work_struct *work);
-void handle_8051_request(struct work_struct *work);
 void handle_link_downgrade(struct work_struct *work);
 void handle_link_bounce(struct work_struct *work);
 void handle_sma_message(struct work_struct *work);
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index b1d4f60..7b78d56 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -606,7 +606,6 @@ struct hfi1_pportdata {
 	struct work_struct link_vc_work;
 	struct work_struct link_up_work;
 	struct work_struct link_down_work;
-	struct work_struct dc_host_req_work;
 	struct work_struct sma_message_work;
 	struct work_struct freeze_work;
 	struct work_struct link_downgrade_work;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index cfcdc16..991a49d 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -496,7 +496,6 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	INIT_WORK(&ppd->link_vc_work, handle_verify_cap);
 	INIT_WORK(&ppd->link_up_work, handle_link_up);
 	INIT_WORK(&ppd->link_down_work, handle_link_down);
-	INIT_WORK(&ppd->dc_host_req_work, handle_8051_request);
 	INIT_WORK(&ppd->freeze_work, handle_freeze);
 	INIT_WORK(&ppd->link_downgrade_work, handle_link_downgrade);
 	INIT_WORK(&ppd->sma_message_work, handle_sma_message);
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 0a1d074..19d0223 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -114,21 +114,11 @@ static int qual_power(struct hfi1_pportdata *ppd)
 	if (ret)
 		return ret;
 
-	if (QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]) != 4)
-		cable_power_class = QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]);
-	else
-		cable_power_class = QSFP_PWR(cache[QSFP_MOD_PWR_OFFS]);
+	cable_power_class = get_qsfp_power_class(cache[QSFP_MOD_PWR_OFFS]);
 
-	if (cable_power_class <= 3 && cable_power_class > (power_class_max - 1))
-		ppd->offline_disabled_reason =
-			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY);
-	else if (cable_power_class > 4 && cable_power_class > (power_class_max))
+	if (cable_power_class > power_class_max)
 		ppd->offline_disabled_reason =
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY);
-	/*
-	 * cable_power_class will never have value 4 as this simply
-	 * means the high power settings are unused
-	 */
 
 	if (ppd->offline_disabled_reason ==
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_POWER_POLICY)) {
@@ -173,12 +163,9 @@ static int set_qsfp_high_power(struct hfi1_pportdata *ppd)
 	u8 *cache = ppd->qsfp_info.cache;
 	int ret;
 
-	if (QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]) != 4)
-		cable_power_class = QSFP_HIGH_PWR(cache[QSFP_MOD_PWR_OFFS]);
-	else
-		cable_power_class = QSFP_PWR(cache[QSFP_MOD_PWR_OFFS]);
+	cable_power_class = get_qsfp_power_class(cache[QSFP_MOD_PWR_OFFS]);
 
-	if (cable_power_class) {
+	if (cable_power_class > QSFP_POWER_CLASS_1) {
 		power_ctrl_byte = cache[QSFP_PWR_CTRL_BYTE_OFFS];
 
 		power_ctrl_byte |= 1;
@@ -190,8 +177,7 @@ static int set_qsfp_high_power(struct hfi1_pportdata *ppd)
 		if (ret != 1)
 			return -EIO;
 
-		if (cable_power_class > 3) {
-			/* > power class 4*/
+		if (cable_power_class > QSFP_POWER_CLASS_4) {
 			power_ctrl_byte |= (1 << 2);
 			ret = qsfp_write(ppd, ppd->dd->hfi1_id,
 					 QSFP_PWR_CTRL_BYTE_OFFS,
@@ -212,12 +198,21 @@ static void apply_rx_cdr(struct hfi1_pportdata *ppd,
 {
 	u32 rx_preset;
 	u8 *cache = ppd->qsfp_info.cache;
+	int cable_power_class;
 
 	if (!((cache[QSFP_MOD_PWR_OFFS] & 0x4) &&
 	      (cache[QSFP_CDR_INFO_OFFS] & 0x40)))
 		return;
 
-	/* rx_preset preset to zero to catch error */
+	/* RX CDR present, bypass supported */
+	cable_power_class = get_qsfp_power_class(cache[QSFP_MOD_PWR_OFFS]);
+
+	if (cable_power_class <= QSFP_POWER_CLASS_3) {
+		/* Power class <= 3, ignore config & turn RX CDR on */
+		*cdr_ctrl_byte |= 0xF;
+		return;
+	}
+
 	get_platform_config_field(
 		ppd->dd, PLATFORM_CONFIG_RX_PRESET_TABLE,
 		rx_preset_index, RX_PRESET_TABLE_QSFP_RX_CDR_APPLY,
@@ -250,15 +245,25 @@ static void apply_rx_cdr(struct hfi1_pportdata *ppd,
 
 static void apply_tx_cdr(struct hfi1_pportdata *ppd,
 			 u32 tx_preset_index,
-			 u8 *ctr_ctrl_byte)
+			 u8 *cdr_ctrl_byte)
 {
 	u32 tx_preset;
 	u8 *cache = ppd->qsfp_info.cache;
+	int cable_power_class;
 
 	if (!((cache[QSFP_MOD_PWR_OFFS] & 0x8) &&
 	      (cache[QSFP_CDR_INFO_OFFS] & 0x80)))
 		return;
 
+	/* TX CDR present, bypass supported */
+	cable_power_class = get_qsfp_power_class(cache[QSFP_MOD_PWR_OFFS]);
+
+	if (cable_power_class <= QSFP_POWER_CLASS_3) {
+		/* Power class <= 3, ignore config & turn TX CDR on */
+		*cdr_ctrl_byte |= 0xF0;
+		return;
+	}
+
 	get_platform_config_field(
 		ppd->dd,
 		PLATFORM_CONFIG_TX_PRESET_TABLE, tx_preset_index,
@@ -282,10 +287,10 @@ static void apply_tx_cdr(struct hfi1_pportdata *ppd,
 			(tx_preset << 2) | (tx_preset << 3));
 
 	if (tx_preset)
-		*ctr_ctrl_byte |= (tx_preset << 4);
+		*cdr_ctrl_byte |= (tx_preset << 4);
 	else
 		/* Preserve current/determined RX CDR status */
-		*ctr_ctrl_byte &= ((tx_preset << 4) | 0xF);
+		*cdr_ctrl_byte &= ((tx_preset << 4) | 0xF);
 }
 
 static void apply_cdr_settings(
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index ac03d80..dc5d186 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -466,7 +466,28 @@ const char * const hfi1_qsfp_devtech[16] = {
 #define QSFP_DUMP_CHUNK 16 /* Holds longest string */
 #define QSFP_DEFAULT_HDR_CNT 224
 
-static const char *pwr_codes = "1.5W2.0W2.5W3.5W";
+#define QSFP_PWR(pbyte) (((pbyte) >> 6) & 3)
+#define QSFP_HIGH_PWR(pbyte) ((pbyte) & 3)
+/* For use with QSFP_HIGH_PWR macro */
+#define QSFP_HIGH_PWR_UNUSED	0 /* Bits [1:0] = 00 implies low power module */
+
+/*
+ * Takes power class byte [Page 00 Byte 129] in SFF 8636
+ * Returns power class as integer (1 through 7, per SFF 8636 rev 2.4)
+ */
+int get_qsfp_power_class(u8 power_byte)
+{
+	if (QSFP_HIGH_PWR(power_byte) == QSFP_HIGH_PWR_UNUSED)
+		/* power classes count from 1, their bit encodings from 0 */
+		return (QSFP_PWR(power_byte) + 1);
+	/*
+	 * 00 in the high power classes stands for unused, bringing
+	 * balance to the off-by-1 offset above, we add 4 here to
+	 * account for the difference between the low and high power
+	 * groups
+	 */
+	return (QSFP_HIGH_PWR(power_byte) + 4);
+}
 
 int qsfp_mod_present(struct hfi1_pportdata *ppd)
 {
@@ -537,6 +558,16 @@ set_zeroes:
 	return ret;
 }
 
+static const char *pwr_codes[8] = {"N/AW",
+				  "1.5W",
+				  "2.0W",
+				  "2.5W",
+				  "3.5W",
+				  "4.0W",
+				  "4.5W",
+				  "5.0W"
+				 };
+
 int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
 {
 	u8 *cache = &ppd->qsfp_info.cache[0];
@@ -546,6 +577,7 @@ int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
 	int bidx = 0;
 	u8 *atten = &cache[QSFP_ATTEN_OFFS];
 	u8 *vendor_oui = &cache[QSFP_VOUI_OFFS];
+	u8 power_byte = 0;
 
 	sofar = 0;
 	lenstr[0] = ' ';
@@ -555,9 +587,9 @@ int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
 		if (QSFP_IS_CU(cache[QSFP_MOD_TECH_OFFS]))
 			sprintf(lenstr, "%dM ", cache[QSFP_MOD_LEN_OFFS]);
 
+		power_byte = cache[QSFP_MOD_PWR_OFFS];
 		sofar += scnprintf(buf + sofar, len - sofar, "PWR:%.3sW\n",
-				pwr_codes +
-				(QSFP_PWR(cache[QSFP_MOD_PWR_OFFS]) * 4));
+				pwr_codes[get_qsfp_power_class(power_byte)]);
 
 		sofar += scnprintf(buf + sofar, len - sofar, "TECH:%s%s\n",
 				lenstr,
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index 831fe4c..dadc66c 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -82,8 +82,9 @@
 /* Byte 128 is Identifier: must be 0x0c for QSFP, or 0x0d for QSFP+ */
 #define QSFP_MOD_ID_OFFS 128
 /*
- * Byte 129 is "Extended Identifier". We only care about D7,D6: Power class
- *  0:1.5W, 1:2.0W, 2:2.5W, 3:3.5W
+ * Byte 129 is "Extended Identifier".
+ * For bits [7:6]: 0:1.5W, 1:2.0W, 2:2.5W, 3:3.5W
+ * For bits [1:0]: 0:Unused, 1:4W, 2:4.5W, 3:5W
  */
 #define QSFP_MOD_PWR_OFFS 129
 /* Byte 130 is Connector type. Not Intel req'd */
@@ -190,6 +191,9 @@ extern const char *const hfi1_qsfp_devtech[16];
 #define QSFP_HIGH_BIAS_WARNING		0x22
 #define QSFP_LOW_BIAS_WARNING		0x11
 
+#define QSFP_ATTEN_SDR(attenarray) (attenarray[0])
+#define QSFP_ATTEN_DDR(attenarray) (attenarray[1])
+
 /*
  * struct qsfp_data encapsulates state of QSFP device for one port.
  * it will be part of port-specific data if a board supports QSFP.
@@ -201,12 +205,6 @@ extern const char *const hfi1_qsfp_devtech[16];
  * and let the qsfp_lock arbitrate access to common resources.
  *
  */
-
-#define QSFP_PWR(pbyte) (((pbyte) >> 6) & 3)
-#define QSFP_HIGH_PWR(pbyte) (((pbyte) & 3) | 4)
-#define QSFP_ATTEN_SDR(attenarray) (attenarray[0])
-#define QSFP_ATTEN_DDR(attenarray) (attenarray[1])
-
 struct qsfp_data {
 	/* Helps to find our way */
 	struct hfi1_pportdata *ppd;
@@ -223,6 +221,7 @@ struct qsfp_data {
 
 int refresh_qsfp_cache(struct hfi1_pportdata *ppd,
 		       struct qsfp_data *cp);
+int get_qsfp_power_class(u8 power_byte);
 int qsfp_mod_present(struct hfi1_pportdata *ppd);
 int get_cable_info(struct hfi1_devdata *dd, u32 port_num, u32 addr,
 		   u32 len, u8 *data);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
