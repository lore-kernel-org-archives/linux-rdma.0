From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] staging/rdma/hfi1: Tune for unknown channel if
 configuration file is absent
Date: Tue, 09 Feb 2016 14:29:22 -0800
Message-ID: <20160209222918.7444.89803.stgit@scvm10.sc.intel.com>
References: <20160209222705.7444.85189.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209222705.7444.85189.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, the driver fails to tune the SerDes and therefore prevents
link up if the configuration file is missing or fails parsing or
validation. This patch adds a fallback option so that the 8051 is asked
to tune for an unknown channel and possibly get the link up if tuning
succeeds. It also adds a user-friendly message to update the
configuration file if it is out-of-date.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.h     |    4 +
 drivers/staging/rdma/hfi1/firmware.c |   49 ++++++++++++++++-
 drivers/staging/rdma/hfi1/platform.c |   97 ++++++++++++++++++----------------
 drivers/staging/rdma/hfi1/qsfp.c     |    1 
 4 files changed, 99 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 3b041dc..b86c220 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -390,6 +390,10 @@
 #define LINK_QUALITY_INFO            0x14
 #define REMOTE_DEVICE_ID	     0x15
 
+/* 8051 lane specific register field IDs */
+#define TX_EQ_SETTINGS		0x00
+#define CHANNEL_LOSS_SETTINGS	0x05
+
 /* Lane ID for general configuration registers */
 #define GENERAL_CONFIG 4
 
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index d2ec6c5..35084b7 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -703,8 +703,6 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 						&dd->pcidev->dev);
 		if (err) {
 			platform_config = NULL;
-			fw_state = FW_ERR;
-			fw_err = -ENOENT;
 			goto done;
 		}
 		dd->platform_config.data = platform_config->data;
@@ -1470,12 +1468,51 @@ int hfi1_firmware_init(struct hfi1_devdata *dd)
 	return obtain_firmware(dd);
 }
 
+/*
+ * This function is a helper function for parse_platform_config(...) and
+ * does not check for validity of the platform configuration cache
+ * (because we know it is invalid as we are building up the cache).
+ * As such, this should not be called from anywhere other than
+ * parse_platform_config
+ */
+static int check_meta_version(struct hfi1_devdata *dd, u32 *system_table)
+{
+	u32 meta_ver, meta_ver_meta, ver_start, ver_len, mask;
+	struct platform_config_cache *pcfgcache = &dd->pcfg_cache;
+
+	if (!system_table)
+		return -EINVAL;
+
+	meta_ver_meta =
+	*(pcfgcache->config_tables[PLATFORM_CONFIG_SYSTEM_TABLE].table_metadata
+	+ SYSTEM_TABLE_META_VERSION);
+
+	mask = ((1 << METADATA_TABLE_FIELD_START_LEN_BITS) - 1);
+	ver_start = meta_ver_meta & mask;
+
+	meta_ver_meta >>= METADATA_TABLE_FIELD_LEN_SHIFT;
+
+	mask = ((1 << METADATA_TABLE_FIELD_LEN_LEN_BITS) - 1);
+	ver_len = meta_ver_meta & mask;
+
+	ver_start /= 8;
+	meta_ver = *((u8 *)system_table + ver_start) & ((1 << ver_len) - 1);
+
+	if (meta_ver < 5) {
+		dd_dev_info(
+			dd, "%s:Please update platform config\n", __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 int parse_platform_config(struct hfi1_devdata *dd)
 {
 	struct platform_config_cache *pcfgcache = &dd->pcfg_cache;
 	u32 *ptr = NULL;
 	u32 header1 = 0, header2 = 0, magic_num = 0, crc = 0, file_length = 0;
 	u32 record_idx = 0, table_type = 0, table_length_dwords = 0;
+	int ret = -EINVAL; /* assume failure */
 
 	if (!dd->platform_config.data) {
 		dd_dev_info(dd, "%s: Missing config file\n", __func__);
@@ -1499,7 +1536,8 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			    __func__);
 		goto bail;
 	} else if (file_length < dd->platform_config.size) {
-		dd_dev_info(dd, "%s:File claims to be smaller than read size\n",
+		dd_dev_info(dd,
+			    "%s:File claims to be smaller than read size, continuing\n",
 			    __func__);
 	}
 	/* exactly equal, perfection */
@@ -1537,6 +1575,9 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			case PLATFORM_CONFIG_SYSTEM_TABLE:
 				pcfgcache->config_tables[table_type].num_table =
 									1;
+				ret = check_meta_version(dd, ptr);
+				if (ret)
+					goto bail;
 				break;
 			case PLATFORM_CONFIG_PORT_TABLE:
 				pcfgcache->config_tables[table_type].num_table =
@@ -1609,7 +1650,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	return 0;
 bail:
 	memset(pcfgcache, 0, sizeof(struct platform_config_cache));
-	return -EINVAL;
+	return ret;
 }
 
 static int get_platform_fw_field_metadata(struct hfi1_devdata *dd, int table,
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 0309c52..2f07bec 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -498,14 +498,14 @@ static void apply_rx_amplitude_settings(
 
 #define OPA_INVALID_INDEX 0xFFF
 
-static void apply_tx_lanes(struct hfi1_pportdata *ppd, u32 config_data,
-			   const char *message)
+static void apply_tx_lanes(struct hfi1_pportdata *ppd, u8 field_id,
+			   u32 config_data, const char *message)
 {
 	u8 i;
 	int ret = HCMD_SUCCESS;
 
 	for (i = 0; i < 4; i++) {
-		ret = load_8051_config(ppd->dd, 0, i, config_data);
+		ret = load_8051_config(ppd->dd, field_id, i, config_data);
 		if (ret != HCMD_SUCCESS) {
 			dd_dev_err(
 				ppd->dd,
@@ -524,6 +524,7 @@ static void apply_tunings(
 	u8 precur = 0, attn = 0, postcur = 0, external_device_config = 0;
 	u8 *cache = ppd->qsfp_info.cache;
 
+	/* Enable external device config if channel is limiting active */
 	read_8051_config(ppd->dd, LINK_OPTIMIZATION_SETTINGS,
 			 GENERAL_CONFIG, &config_data);
 	config_data |= limiting_active;
@@ -536,6 +537,7 @@ static void apply_tunings(
 			__func__);
 
 	config_data = 0; /* re-init  */
+	/* Pass tuning method to 8051 */
 	read_8051_config(ppd->dd, LINK_TUNING_PARAMETERS, GENERAL_CONFIG,
 			 &config_data);
 	config_data |= tuning_method;
@@ -545,47 +547,39 @@ static void apply_tunings(
 		dd_dev_err(ppd->dd, "%s: Failed to set tuning method\n",
 			   __func__);
 
-	external_device_config =
-		((cache[QSFP_MOD_PWR_OFFS] & 0x4) << 3) |
-		((cache[QSFP_MOD_PWR_OFFS] & 0x8) << 2) |
-		((cache[QSFP_EQ_INFO_OFFS] & 0x2) << 1) |
-		(cache[QSFP_EQ_INFO_OFFS] & 0x4);
-
-	config_data = 0; /* re-init  */
-	read_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS, GENERAL_CONFIG,
-			 &config_data);
-	config_data |= (external_device_config << 24);
-	ret = load_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS, GENERAL_CONFIG,
-			       config_data);
-	if (ret != HCMD_SUCCESS)
-		dd_dev_err(
-			ppd->dd,
-			"%s: Failed to set external device config parameters\n",
-			__func__);
-
-	config_data = 0; /* re-init  */
-	read_8051_config(ppd->dd, TX_SETTINGS, GENERAL_CONFIG, &config_data);
-	if ((ppd->link_speed_supported & OPA_LINK_SPEED_25G) &&
-	    (ppd->link_speed_enabled & OPA_LINK_SPEED_25G))
-		config_data |= 0x02;
-	if ((ppd->link_speed_supported & OPA_LINK_SPEED_12_5G) &&
-	    (ppd->link_speed_enabled & OPA_LINK_SPEED_12_5G))
-		config_data |= 0x01;
-	ret = load_8051_config(ppd->dd, TX_SETTINGS, GENERAL_CONFIG,
-			       config_data);
-	if (ret != HCMD_SUCCESS)
-		dd_dev_err(
-			ppd->dd,
-			"%s: Failed to set external device config parameters\n",
-			__func__);
-
-	config_data = (total_atten << 8) | (total_atten);
-
-	apply_tx_lanes(ppd, config_data, "Setting channel loss");
+	/* Set same channel loss for both TX and RX */
+	config_data = 0 | (total_atten << 16) | (total_atten << 24);
+	apply_tx_lanes(ppd, CHANNEL_LOSS_SETTINGS, config_data,
+		       "Setting channel loss");
+
+	/* Inform 8051 of cable capabilities */
+	if (ppd->qsfp_info.cache_valid) {
+		external_device_config =
+			((cache[QSFP_MOD_PWR_OFFS] & 0x4) << 3) |
+			((cache[QSFP_MOD_PWR_OFFS] & 0x8) << 2) |
+			((cache[QSFP_EQ_INFO_OFFS] & 0x2) << 1) |
+			(cache[QSFP_EQ_INFO_OFFS] & 0x4);
+		ret = read_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS,
+				       GENERAL_CONFIG, &config_data);
+		/* Clear, then set the external device config field */
+		config_data &= ~(0xFF << 24);
+		config_data |= (external_device_config << 24);
+		ret = load_8051_config(ppd->dd, DC_HOST_COMM_SETTINGS,
+				       GENERAL_CONFIG, config_data);
+		if (ret != HCMD_SUCCESS)
+			dd_dev_info(ppd->dd,
+				    "%s: Failed set ext device config params\n",
+				    __func__);
+	}
 
-	if (tx_preset_index == OPA_INVALID_INDEX)
+	if (tx_preset_index == OPA_INVALID_INDEX) {
+		if (ppd->port_type == PORT_TYPE_QSFP && limiting_active)
+			dd_dev_info(ppd->dd, "%s: Invalid Tx preset index\n",
+				    __func__);
 		return;
+	}
 
+	/* Following for limiting active channels only */
 	get_platform_config_field(
 		ppd->dd, PLATFORM_CONFIG_TX_PRESET_TABLE, tx_preset_index,
 		TX_PRESET_TABLE_PRECUR, &tx_preset, 4);
@@ -603,7 +597,8 @@ static void apply_tunings(
 
 	config_data = precur | (attn << 8) | (postcur << 16);
 
-	apply_tx_lanes(ppd, config_data, "Applying TX settings");
+	apply_tx_lanes(ppd, TX_EQ_SETTINGS, config_data,
+		       "Applying TX settings");
 }
 
 static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
@@ -766,7 +761,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 	u32 total_atten = 0;
 	u32 remote_atten = 0, platform_atten = 0;
 	u32 rx_preset_index, tx_preset_index;
-	u8 tuning_method = 0;
+	u8 tuning_method = 0, limiting_active = 0;
 	struct hfi1_devdata *dd = ppd->dd;
 
 	rx_preset_index = OPA_INVALID_INDEX;
@@ -789,7 +784,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 					PORT_TABLE_PORT_TYPE, &ppd->port_type,
 					4);
 	if (ret)
-		goto bail;
+		ppd->port_type = PORT_TYPE_UNKNOWN;
 
 	switch (ppd->port_type) {
 	case PORT_TYPE_DISCONNECTED:
@@ -853,6 +848,9 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 				refresh_qsfp_cache(ppd, &ppd->qsfp_info);
 				if (ret)
 					goto bail;
+
+				limiting_active =
+						ppd->qsfp_info.limiting_active;
 			} else {
 				dd_dev_err(dd,
 					   "%s: Reading QSFP memory failed\n",
@@ -866,13 +864,18 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 		break;
 	default:
 		dd_dev_info(ppd->dd, "%s: Unknown port type\n", __func__);
-		goto bail;
+		ppd->port_type = PORT_TYPE_UNKNOWN;
+		tuning_method = OPA_UNKNOWN_TUNING;
+		total_atten = 0;
+		limiting_active = 0;
+		tx_preset_index = OPA_INVALID_INDEX;
+		break;
 	}
+
 	if (ppd->offline_disabled_reason ==
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE))
 		apply_tunings(ppd, tx_preset_index, tuning_method,
-			      total_atten,
-			      ppd->qsfp_info.limiting_active);
+			      total_atten, limiting_active);
 
 	if (!ret)
 		ppd->driver_link_ready = 1;
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index c9d1e64..42e5be4 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -344,7 +344,6 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 	ppd->qsfp_info.cache_valid = 0;
 	spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
 
-	dd_dev_info(ppd->dd, "%s called\n", __func__);
 	if (!qsfp_mod_present(ppd)) {
 		ret = -ENODEV;
 		goto bail;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
