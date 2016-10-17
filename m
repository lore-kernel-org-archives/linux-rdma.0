From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/12] IB/hfi1: Add active channel and backplane support for
 integrated devices
Date: Mon, 17 Oct 2016 04:19:47 -0700
Message-ID: <20161017111946.7934.39706.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use scratch registers within the HFI1 device to recover signal
integrity information that is then used to tune the channel. While
there, update error messages to better convey the result of falling
back to a backup file.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip_registers.h |    3 +
 drivers/infiniband/hw/hfi1/firmware.c       |  136 +++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/hfi.h            |   16 +++
 drivers/infiniband/hw/hfi1/platform.c       |  149 ++++++++++++++++++++++-----
 drivers/infiniband/hw/hfi1/platform.h       |  117 +++++++++++++++++++++
 5 files changed, 376 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip_registers.h b/drivers/infiniband/hw/hfi1/chip_registers.h
index 5b99938..5bfa839 100644
--- a/drivers/infiniband/hw/hfi1/chip_registers.h
+++ b/drivers/infiniband/hw/hfi1/chip_registers.h
@@ -415,6 +415,9 @@
 #define ASIC_CFG_SBUS_REQUEST_DATA_IN_SHIFT 32
 #define ASIC_CFG_SBUS_REQUEST_RECEIVER_ADDR_SHIFT 0
 #define ASIC_CFG_SCRATCH (ASIC + 0x000000000020)
+#define ASIC_CFG_SCRATCH_1 (ASIC_CFG_SCRATCH + 0x08)
+#define ASIC_CFG_SCRATCH_2 (ASIC_CFG_SCRATCH + 0x10)
+#define ASIC_CFG_SCRATCH_3 (ASIC_CFG_SCRATCH + 0x18)
 #define ASIC_CFG_THERM_POLL_EN (ASIC + 0x000000000050)
 #define ASIC_EEP_ADDR_CMD (ASIC + 0x000000000308)
 #define ASIC_EEP_ADDR_CMD_EP_ADDR_MASK 0xFFFFFFull
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 13db8eb..9a36c8c 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -707,6 +707,9 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 				       &dd->pcidev->dev);
 		if (err) {
 			platform_config = NULL;
+			dd_dev_err(dd,
+				   "%s: No default platform config file found\n",
+				   __func__);
 			goto done;
 		}
 		dd->platform_config.data = platform_config->data;
@@ -1761,8 +1764,17 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	u32 record_idx = 0, table_type = 0, table_length_dwords = 0;
 	int ret = -EINVAL; /* assume failure */
 
+	/*
+	 * For integrated devices that did not fall back to the default file,
+	 * the SI tuning information for active channels is acquired from the
+	 * scratch register bitmap, thus there is no platform config to parse.
+	 * Skip parsing in these situations.
+	 */
+	if (is_integrated(dd) && !platform_config_load)
+		return 0;
+
 	if (!dd->platform_config.data) {
-		dd_dev_info(dd, "%s: Missing config file\n", __func__);
+		dd_dev_err(dd, "%s: Missing config file\n", __func__);
 		goto bail;
 	}
 	ptr = (u32 *)dd->platform_config.data;
@@ -1770,7 +1782,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 	magic_num = *ptr;
 	ptr++;
 	if (magic_num != PLATFORM_CONFIG_MAGIC_NUM) {
-		dd_dev_info(dd, "%s: Bad config file\n", __func__);
+		dd_dev_err(dd, "%s: Bad config file\n", __func__);
 		goto bail;
 	}
 
@@ -1797,9 +1809,9 @@ int parse_platform_config(struct hfi1_devdata *dd)
 		header1 = *ptr;
 		header2 = *(ptr + 1);
 		if (header1 != ~header2) {
-			dd_dev_info(dd, "%s: Failed validation at offset %ld\n",
-				    __func__, (ptr - (u32 *)
-					       dd->platform_config.data));
+			dd_dev_err(dd, "%s: Failed validation at offset %ld\n",
+				   __func__, (ptr - (u32 *)
+					      dd->platform_config.data));
 			goto bail;
 		}
 
@@ -1841,11 +1853,11 @@ int parse_platform_config(struct hfi1_devdata *dd)
 							table_length_dwords;
 				break;
 			default:
-				dd_dev_info(dd,
-					    "%s: Unknown data table %d, offset %ld\n",
-					    __func__, table_type,
-					    (ptr - (u32 *)
-					     dd->platform_config.data));
+				dd_dev_err(dd,
+					   "%s: Unknown data table %d, offset %ld\n",
+					   __func__, table_type,
+					   (ptr - (u32 *)
+					    dd->platform_config.data));
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table = ptr;
@@ -1865,11 +1877,11 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			case PLATFORM_CONFIG_VARIABLE_SETTINGS_TABLE:
 				break;
 			default:
-				dd_dev_info(dd,
-					    "%s: Unknown meta table %d, offset %ld\n",
-					    __func__, table_type,
-					    (ptr -
-					     (u32 *)dd->platform_config.data));
+				dd_dev_err(dd,
+					   "%s: Unknown meta table %d, offset %ld\n",
+					   __func__, table_type,
+					   (ptr -
+					    (u32 *)dd->platform_config.data));
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table_metadata =
@@ -1884,10 +1896,9 @@ int parse_platform_config(struct hfi1_devdata *dd)
 		/* Jump the table */
 		ptr += table_length_dwords;
 		if (crc != *ptr) {
-			dd_dev_info(dd, "%s: Failed CRC check at offset %ld\n",
-				    __func__, (ptr -
-					       (u32 *)
-					       dd->platform_config.data));
+			dd_dev_err(dd, "%s: Failed CRC check at offset %ld\n",
+				   __func__, (ptr -
+				   (u32 *)dd->platform_config.data));
 			goto bail;
 		}
 		/* Jump the CRC DWORD */
@@ -1901,6 +1912,84 @@ bail:
 	return ret;
 }
 
+static void get_integrated_platform_config_field(
+		struct hfi1_devdata *dd,
+		enum platform_config_table_type_encoding table_type,
+		int field_index, u32 *data)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+	u8 *cache = ppd->qsfp_info.cache;
+	u32 tx_preset = 0;
+
+	switch (table_type) {
+	case PLATFORM_CONFIG_SYSTEM_TABLE:
+		if (field_index == SYSTEM_TABLE_QSFP_POWER_CLASS_MAX)
+			*data = ppd->max_power_class;
+		else if (field_index == SYSTEM_TABLE_QSFP_ATTENUATION_DEFAULT_25G)
+			*data = ppd->default_atten;
+		break;
+	case PLATFORM_CONFIG_PORT_TABLE:
+		if (field_index == PORT_TABLE_PORT_TYPE)
+			*data = ppd->port_type;
+		else if (field_index == PORT_TABLE_LOCAL_ATTEN_25G)
+			*data = ppd->local_atten;
+		else if (field_index == PORT_TABLE_REMOTE_ATTEN_25G)
+			*data = ppd->remote_atten;
+		break;
+	case PLATFORM_CONFIG_RX_PRESET_TABLE:
+		if (field_index == RX_PRESET_TABLE_QSFP_RX_CDR_APPLY)
+			*data = (ppd->rx_preset & QSFP_RX_CDR_APPLY_SMASK) >>
+				QSFP_RX_CDR_APPLY_SHIFT;
+		else if (field_index == RX_PRESET_TABLE_QSFP_RX_EMP_APPLY)
+			*data = (ppd->rx_preset & QSFP_RX_EMP_APPLY_SMASK) >>
+				QSFP_RX_EMP_APPLY_SHIFT;
+		else if (field_index == RX_PRESET_TABLE_QSFP_RX_AMP_APPLY)
+			*data = (ppd->rx_preset & QSFP_RX_AMP_APPLY_SMASK) >>
+				QSFP_RX_AMP_APPLY_SHIFT;
+		else if (field_index == RX_PRESET_TABLE_QSFP_RX_CDR)
+			*data = (ppd->rx_preset & QSFP_RX_CDR_SMASK) >>
+				QSFP_RX_CDR_SHIFT;
+		else if (field_index == RX_PRESET_TABLE_QSFP_RX_EMP)
+			*data = (ppd->rx_preset & QSFP_RX_EMP_SMASK) >>
+				QSFP_RX_EMP_SHIFT;
+		else if (field_index == RX_PRESET_TABLE_QSFP_RX_AMP)
+			*data = (ppd->rx_preset & QSFP_RX_AMP_SMASK) >>
+				QSFP_RX_AMP_SHIFT;
+		break;
+	case PLATFORM_CONFIG_TX_PRESET_TABLE:
+		if (cache[QSFP_EQ_INFO_OFFS] & 0x4)
+			tx_preset = ppd->tx_preset_eq;
+		else
+			tx_preset = ppd->tx_preset_noeq;
+		if (field_index == TX_PRESET_TABLE_PRECUR)
+			*data = (tx_preset & TX_PRECUR_SMASK) >>
+				TX_PRECUR_SHIFT;
+		else if (field_index == TX_PRESET_TABLE_ATTN)
+			*data = (tx_preset & TX_ATTN_SMASK) >>
+				TX_ATTN_SHIFT;
+		else if (field_index == TX_PRESET_TABLE_POSTCUR)
+			*data = (tx_preset & TX_POSTCUR_SMASK) >>
+				TX_POSTCUR_SHIFT;
+		else if (field_index == TX_PRESET_TABLE_QSFP_TX_CDR_APPLY)
+			*data = (tx_preset & QSFP_TX_CDR_APPLY_SMASK) >>
+				QSFP_TX_CDR_APPLY_SHIFT;
+		else if (field_index == TX_PRESET_TABLE_QSFP_TX_EQ_APPLY)
+			*data = (tx_preset & QSFP_TX_EQ_APPLY_SMASK) >>
+				QSFP_TX_EQ_APPLY_SHIFT;
+		else if (field_index == TX_PRESET_TABLE_QSFP_TX_CDR)
+			*data = (tx_preset & QSFP_TX_CDR_SMASK) >>
+				QSFP_TX_CDR_SHIFT;
+		else if (field_index == TX_PRESET_TABLE_QSFP_TX_EQ)
+			*data = (tx_preset & QSFP_TX_EQ_SMASK) >>
+				QSFP_TX_EQ_SHIFT;
+		break;
+	case PLATFORM_CONFIG_QSFP_ATTEN_TABLE:
+	case PLATFORM_CONFIG_VARIABLE_SETTINGS_TABLE:
+	default:
+		break;
+	}
+}
+
 static int get_platform_fw_field_metadata(struct hfi1_devdata *dd, int table,
 					  int field, u32 *field_len_bits,
 					  u32 *field_start_bits)
@@ -1976,6 +2065,15 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 	else
 		return -EINVAL;
 
+	if (is_integrated(dd) && !platform_config_load) {
+		/*
+		 * Use saved configuration from ppd for integrated platforms
+		 */
+		get_integrated_platform_config_field(dd, table_type,
+						     field_index, data);
+		return 0;
+	}
+
 	ret = get_platform_fw_field_metadata(dd, table_type, field_index,
 					     &field_len_bits,
 					     &field_start_bits);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index bec4607..94cc5f2 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -582,8 +582,16 @@ struct hfi1_pportdata {
 	struct kobject vl2mtu_kobj;
 
 	/* PHY support */
-	u32 port_type;
 	struct qsfp_data qsfp_info;
+	/* Values for SI tuning of SerDes */
+	u32 port_type;
+	u32 tx_preset_eq;
+	u32 tx_preset_noeq;
+	u32 rx_preset;
+	u8  local_atten;
+	u8  remote_atten;
+	u8  default_atten;
+	u8  max_power_class;
 
 	/* GUIDs for this interface, in host order, guids[0] is a port guid */
 	u64 guids[HFI1_GUIDS_PER_PORT];
@@ -2037,6 +2045,12 @@ static inline u32 qsfp_resource(struct hfi1_devdata *dd)
 	return i2c_target(dd->hfi1_id);
 }
 
+/* Is this device integrated or discrete? */
+static inline bool is_integrated(struct hfi1_devdata *dd)
+{
+	return dd->pcidev->device == PCI_DEVICE_ID_INTEL1;
+}
+
 int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp);
 
 #define DD_DEV_ENTRY(dd)       __string(dev, dev_name(&(dd)->pcidev->dev))
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 2024331..0e70438 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -49,6 +49,90 @@
 #include "efivar.h"
 #include "eprom.h"
 
+static int validate_scratch_checksum(struct hfi1_devdata *dd)
+{
+	u64 checksum = 0, temp_scratch = 0;
+	int i, j, version;
+
+	temp_scratch = read_csr(dd, ASIC_CFG_SCRATCH);
+	version = (temp_scratch & BITMAP_VERSION_SMASK) >> BITMAP_VERSION_SHIFT;
+
+	/* Prevent power on default of all zeroes from passing checksum */
+	if (!version)
+		return 0;
+
+	/*
+	 * ASIC scratch 0 only contains the checksum and bitmap version as
+	 * fields of interest, both of which are handled separately from the
+	 * loop below, so skip it
+	 */
+	checksum += version;
+	for (i = 1; i < ASIC_NUM_SCRATCH; i++) {
+		temp_scratch = read_csr(dd, ASIC_CFG_SCRATCH + (8 * i));
+		for (j = sizeof(u64); j != 0; j -= 2) {
+			checksum += (temp_scratch & 0xFFFF);
+			temp_scratch >>= 16;
+		}
+	}
+
+	while (checksum >> 16)
+		checksum = (checksum & CHECKSUM_MASK) + (checksum >> 16);
+
+	temp_scratch = read_csr(dd, ASIC_CFG_SCRATCH);
+	temp_scratch &= CHECKSUM_SMASK;
+	temp_scratch >>= CHECKSUM_SHIFT;
+
+	if (checksum + temp_scratch == 0xFFFF)
+		return 1;
+	return 0;
+}
+
+static void save_platform_config_fields(struct hfi1_devdata *dd)
+{
+	struct hfi1_pportdata *ppd = dd->pport;
+	u64 temp_scratch = 0, temp_dest = 0;
+
+	temp_scratch = read_csr(dd, ASIC_CFG_SCRATCH_1);
+
+	temp_dest = temp_scratch &
+		    (dd->hfi1_id ? PORT1_PORT_TYPE_SMASK :
+		     PORT0_PORT_TYPE_SMASK);
+	ppd->port_type = temp_dest >>
+			 (dd->hfi1_id ? PORT1_PORT_TYPE_SHIFT :
+			  PORT0_PORT_TYPE_SHIFT);
+
+	temp_dest = temp_scratch &
+		    (dd->hfi1_id ? PORT1_LOCAL_ATTEN_SMASK :
+		     PORT0_LOCAL_ATTEN_SMASK);
+	ppd->local_atten = temp_dest >>
+			   (dd->hfi1_id ? PORT1_LOCAL_ATTEN_SHIFT :
+			    PORT0_LOCAL_ATTEN_SHIFT);
+
+	temp_dest = temp_scratch &
+		    (dd->hfi1_id ? PORT1_REMOTE_ATTEN_SMASK :
+		     PORT0_REMOTE_ATTEN_SMASK);
+	ppd->remote_atten = temp_dest >>
+			    (dd->hfi1_id ? PORT1_REMOTE_ATTEN_SHIFT :
+			     PORT0_REMOTE_ATTEN_SHIFT);
+
+	temp_dest = temp_scratch &
+		    (dd->hfi1_id ? PORT1_DEFAULT_ATTEN_SMASK :
+		     PORT0_DEFAULT_ATTEN_SMASK);
+	ppd->default_atten = temp_dest >>
+			     (dd->hfi1_id ? PORT1_DEFAULT_ATTEN_SHIFT :
+			      PORT0_DEFAULT_ATTEN_SHIFT);
+
+	temp_scratch = read_csr(dd, dd->hfi1_id ? ASIC_CFG_SCRATCH_3 :
+				ASIC_CFG_SCRATCH_2);
+
+	ppd->tx_preset_eq = (temp_scratch & TX_EQ_SMASK) >> TX_EQ_SHIFT;
+	ppd->tx_preset_noeq = (temp_scratch & TX_NO_EQ_SMASK) >> TX_NO_EQ_SHIFT;
+	ppd->rx_preset = (temp_scratch & RX_SMASK) >> RX_SHIFT;
+
+	ppd->max_power_class = (temp_scratch & QSFP_MAX_POWER_SMASK) >>
+				QSFP_MAX_POWER_SHIFT;
+}
+
 void get_platform_config(struct hfi1_devdata *dd)
 {
 	int ret = 0;
@@ -56,38 +140,49 @@ void get_platform_config(struct hfi1_devdata *dd)
 	u8 *temp_platform_config = NULL;
 	u32 esize;
 
-	ret = eprom_read_platform_config(dd, (void **)&temp_platform_config,
-					 &esize);
-	if (!ret) {
-		/* success */
-		size = esize;
-		goto success;
+	if (is_integrated(dd)) {
+		if (validate_scratch_checksum(dd)) {
+			save_platform_config_fields(dd);
+			return;
+		}
+		dd_dev_err(dd, "%s: Config bitmap corrupted/uninitialized\n",
+			   __func__);
+		dd_dev_err(dd,
+			   "%s: Please update your BIOS to support active channels\n",
+			   __func__);
+	} else {
+		ret = eprom_read_platform_config(dd,
+						 (void **)&temp_platform_config,
+						 &esize);
+		if (!ret) {
+			/* success */
+			dd->platform_config.data = temp_platform_config;
+			dd->platform_config.size = esize;
+			return;
+		}
+		/* fail, try EFI variable */
+
+		ret = read_hfi1_efi_var(dd, "configuration", &size,
+					(void **)&temp_platform_config);
+		if (!ret) {
+			dd->platform_config.data = temp_platform_config;
+			dd->platform_config.size = size;
+			return;
+		}
 	}
-	/* fail, try EFI variable */
-
-	ret = read_hfi1_efi_var(dd, "configuration", &size,
-				(void **)&temp_platform_config);
-	if (!ret)
-		goto success;
-
-	dd_dev_info(dd,
-		    "%s: Failed to get platform config from UEFI, falling back to request firmware\n",
-		    __func__);
+	dd_dev_err(dd,
+		   "%s: Failed to get platform config, falling back to sub-optimal default file\n",
+		   __func__);
 	/* fall back to request firmware */
 	platform_config_load = 1;
-	return;
-
-success:
-	dd->platform_config.data = temp_platform_config;
-	dd->platform_config.size = size;
 }
 
 void free_platform_config(struct hfi1_devdata *dd)
 {
 	if (!platform_config_load) {
 		/*
-		 * was loaded from EFI, release memory
-		 * allocated by read_efi_var
+		 * was loaded from EFI or the EPROM, release memory
+		 * allocated by read_efi_var/eprom_read_platform_config
 		 */
 		kfree(dd->platform_config.data);
 	}
@@ -100,12 +195,16 @@ void free_platform_config(struct hfi1_devdata *dd)
 void get_port_type(struct hfi1_pportdata *ppd)
 {
 	int ret;
+	u32 temp;
 
 	ret = get_platform_config_field(ppd->dd, PLATFORM_CONFIG_PORT_TABLE, 0,
-					PORT_TABLE_PORT_TYPE, &ppd->port_type,
+					PORT_TABLE_PORT_TYPE, &temp,
 					4);
-	if (ret)
+	if (ret) {
 		ppd->port_type = PORT_TYPE_UNKNOWN;
+		return;
+	}
+	ppd->port_type = temp;
 }
 
 int set_qsfp_tx(struct hfi1_pportdata *ppd, int on)
diff --git a/drivers/infiniband/hw/hfi1/platform.h b/drivers/infiniband/hw/hfi1/platform.h
index e2c2161..3115540 100644
--- a/drivers/infiniband/hw/hfi1/platform.h
+++ b/drivers/infiniband/hw/hfi1/platform.h
@@ -295,6 +295,123 @@ enum link_tuning_encoding {
 	OPA_UNKNOWN_TUNING
 };
 
+/*
+ * Shifts and masks for the link SI tuning values stuffed into the ASIC scratch
+ * registers for integrated platforms
+ */
+#define PORT0_PORT_TYPE_SHIFT		0
+#define PORT0_LOCAL_ATTEN_SHIFT		4
+#define PORT0_REMOTE_ATTEN_SHIFT	10
+#define PORT0_DEFAULT_ATTEN_SHIFT	32
+
+#define PORT1_PORT_TYPE_SHIFT		16
+#define PORT1_LOCAL_ATTEN_SHIFT		20
+#define PORT1_REMOTE_ATTEN_SHIFT	26
+#define PORT1_DEFAULT_ATTEN_SHIFT	40
+
+#define PORT0_PORT_TYPE_MASK		0xFUL
+#define PORT0_LOCAL_ATTEN_MASK		0x3FUL
+#define PORT0_REMOTE_ATTEN_MASK		0x3FUL
+#define PORT0_DEFAULT_ATTEN_MASK	0xFFUL
+
+#define PORT1_PORT_TYPE_MASK		0xFUL
+#define PORT1_LOCAL_ATTEN_MASK		0x3FUL
+#define PORT1_REMOTE_ATTEN_MASK		0x3FUL
+#define PORT1_DEFAULT_ATTEN_MASK	0xFFUL
+
+#define PORT0_PORT_TYPE_SMASK		(PORT0_PORT_TYPE_MASK << \
+					 PORT0_PORT_TYPE_SHIFT)
+#define PORT0_LOCAL_ATTEN_SMASK		(PORT0_LOCAL_ATTEN_MASK << \
+					 PORT0_LOCAL_ATTEN_SHIFT)
+#define PORT0_REMOTE_ATTEN_SMASK	(PORT0_REMOTE_ATTEN_MASK << \
+					 PORT0_REMOTE_ATTEN_SHIFT)
+#define PORT0_DEFAULT_ATTEN_SMASK	(PORT0_DEFAULT_ATTEN_MASK << \
+					 PORT0_DEFAULT_ATTEN_SHIFT)
+
+#define PORT1_PORT_TYPE_SMASK		(PORT1_PORT_TYPE_MASK << \
+					 PORT1_PORT_TYPE_SHIFT)
+#define PORT1_LOCAL_ATTEN_SMASK		(PORT1_LOCAL_ATTEN_MASK << \
+					 PORT1_LOCAL_ATTEN_SHIFT)
+#define PORT1_REMOTE_ATTEN_SMASK	(PORT1_REMOTE_ATTEN_MASK << \
+					 PORT1_REMOTE_ATTEN_SHIFT)
+#define PORT1_DEFAULT_ATTEN_SMASK	(PORT1_DEFAULT_ATTEN_MASK << \
+					 PORT1_DEFAULT_ATTEN_SHIFT)
+
+#define QSFP_MAX_POWER_SHIFT		0
+#define TX_NO_EQ_SHIFT			4
+#define TX_EQ_SHIFT			25
+#define RX_SHIFT			46
+
+#define QSFP_MAX_POWER_MASK		0xFUL
+#define TX_NO_EQ_MASK			0x1FFFFFUL
+#define TX_EQ_MASK			0x1FFFFFUL
+#define RX_MASK				0xFFFFUL
+
+#define QSFP_MAX_POWER_SMASK		(QSFP_MAX_POWER_MASK << \
+					 QSFP_MAX_POWER_SHIFT)
+#define TX_NO_EQ_SMASK			(TX_NO_EQ_MASK << TX_NO_EQ_SHIFT)
+#define TX_EQ_SMASK			(TX_EQ_MASK << TX_EQ_SHIFT)
+#define RX_SMASK			(RX_MASK << RX_SHIFT)
+
+#define TX_PRECUR_SHIFT			0
+#define TX_ATTN_SHIFT			4
+#define QSFP_TX_CDR_APPLY_SHIFT		9
+#define QSFP_TX_EQ_APPLY_SHIFT		10
+#define QSFP_TX_CDR_SHIFT		11
+#define QSFP_TX_EQ_SHIFT		12
+#define TX_POSTCUR_SHIFT		16
+
+#define TX_PRECUR_MASK			0xFUL
+#define TX_ATTN_MASK			0x1FUL
+#define QSFP_TX_CDR_APPLY_MASK		0x1UL
+#define QSFP_TX_EQ_APPLY_MASK		0x1UL
+#define QSFP_TX_CDR_MASK		0x1UL
+#define QSFP_TX_EQ_MASK			0xFUL
+#define TX_POSTCUR_MASK			0x1FUL
+
+#define TX_PRECUR_SMASK			(TX_PRECUR_MASK << TX_PRECUR_SHIFT)
+#define TX_ATTN_SMASK			(TX_ATTN_MASK << TX_ATTN_SHIFT)
+#define QSFP_TX_CDR_APPLY_SMASK		(QSFP_TX_CDR_APPLY_MASK << \
+					 QSFP_TX_CDR_APPLY_SHIFT)
+#define QSFP_TX_EQ_APPLY_SMASK		(QSFP_TX_EQ_APPLY_MASK << \
+					 QSFP_TX_EQ_APPLY_SHIFT)
+#define QSFP_TX_CDR_SMASK		(QSFP_TX_CDR_MASK << QSFP_TX_CDR_SHIFT)
+#define QSFP_TX_EQ_SMASK		(QSFP_TX_EQ_MASK << QSFP_TX_EQ_SHIFT)
+#define TX_POSTCUR_SMASK		(TX_POSTCUR_MASK << TX_POSTCUR_SHIFT)
+
+#define QSFP_RX_CDR_APPLY_SHIFT		0
+#define QSFP_RX_EMP_APPLY_SHIFT		1
+#define QSFP_RX_AMP_APPLY_SHIFT		2
+#define QSFP_RX_CDR_SHIFT		3
+#define QSFP_RX_EMP_SHIFT		4
+#define QSFP_RX_AMP_SHIFT		8
+
+#define QSFP_RX_CDR_APPLY_MASK		0x1UL
+#define QSFP_RX_EMP_APPLY_MASK		0x1UL
+#define QSFP_RX_AMP_APPLY_MASK		0x1UL
+#define QSFP_RX_CDR_MASK		0x1UL
+#define QSFP_RX_EMP_MASK		0xFUL
+#define QSFP_RX_AMP_MASK		0x3UL
+
+#define QSFP_RX_CDR_APPLY_SMASK		(QSFP_RX_CDR_APPLY_MASK << \
+					 QSFP_RX_CDR_APPLY_SHIFT)
+#define QSFP_RX_EMP_APPLY_SMASK		(QSFP_RX_EMP_APPLY_MASK << \
+					 QSFP_RX_EMP_APPLY_SHIFT)
+#define QSFP_RX_AMP_APPLY_SMASK		(QSFP_RX_AMP_APPLY_MASK << \
+					 QSFP_RX_AMP_APPLY_SHIFT)
+#define QSFP_RX_CDR_SMASK		(QSFP_RX_CDR_MASK << QSFP_RX_CDR_SHIFT)
+#define QSFP_RX_EMP_SMASK		(QSFP_RX_EMP_MASK << QSFP_RX_EMP_SHIFT)
+#define QSFP_RX_AMP_SMASK		(QSFP_RX_AMP_MASK << QSFP_RX_AMP_SHIFT)
+
+#define BITMAP_VERSION			1
+#define BITMAP_VERSION_SHIFT		44
+#define BITMAP_VERSION_MASK		0xFUL
+#define BITMAP_VERSION_SMASK		(BITMAP_VERSION_MASK << \
+					 BITMAP_VERSION_SHIFT)
+#define CHECKSUM_SHIFT			48
+#define CHECKSUM_MASK			0xFFFFUL
+#define CHECKSUM_SMASK			(CHECKSUM_MASK << CHECKSUM_SHIFT)
+
 /* platform.c */
 void get_platform_config(struct hfi1_devdata *dd);
 void free_platform_config(struct hfi1_devdata *dd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
