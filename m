From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] staging/rdma/hfi1: Fetch platform configuration data
 from EFI variable
Date: Tue, 09 Feb 2016 14:29:13 -0800
Message-ID: <20160209222907.7444.72182.stgit@scvm10.sc.intel.com>
References: <20160209222705.7444.85189.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160209222705.7444.85189.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The platform configuration data has been moved into the EFI variable
store where it is populated by the HFI1 option ROM. This patch pulls
the configuration data from the new location, retaining a fallback to
request_firmware.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |    3 +
 drivers/staging/rdma/hfi1/chip.h     |    2 +
 drivers/staging/rdma/hfi1/firmware.c |   69 +++++++++++++++++++++++++++-------
 drivers/staging/rdma/hfi1/hfi.h      |    1 
 drivers/staging/rdma/hfi1/init.c     |    1 
 drivers/staging/rdma/hfi1/platform.c |   58 +++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/platform.h |    9 ++++
 7 files changed, 121 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 77b07c3..4750e3c 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -14096,6 +14096,9 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret)
 		goto bail_cleanup;
 
+	/* Needs to be called before hfi1_firmware_init */
+	get_platform_config(dd);
+
 	/* read in firmware */
 	ret = hfi1_firmware_init(dd);
 	if (ret)
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 0e95f0b..3b041dc 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -617,6 +617,8 @@ u64 create_pbc(struct hfi1_pportdata *ppd, u64, int, u32, u32);
 #define NUM_PCIE_SERDES 16	/* number of PCIe serdes on the SBus */
 extern const u8 pcie_serdes_broadcast[];
 extern const u8 pcie_pcs_addrs[2][NUM_PCIE_SERDES];
+extern uint platform_config_load;
+
 /* SBus commands */
 #define RESET_SBUS_RECEIVER 0x20
 #define WRITE_SBUS_RECEIVER 0x21
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 0b23e3e..d2ec6c5 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -77,7 +77,13 @@ static uint fw_8051_load = 1;
 static uint fw_fabric_serdes_load = 1;
 static uint fw_pcie_serdes_load = 1;
 static uint fw_sbus_load = 1;
-static uint platform_config_load = 1;
+
+/*
+ * Access required in platform.c
+ * Maintains state of whether the platform config was fetched via the
+ * fallback option
+ */
+uint platform_config_load;
 
 /* Firmware file names get set in hfi1_firmware_init() based on the above */
 static char *fw_8051_name;
@@ -677,10 +683,15 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 	}
 	/* not in FW_TRY state */
 
-	if (fw_state == FW_FINAL)
+	if (fw_state == FW_FINAL) {
+		if (platform_config) {
+			dd->platform_config.data = platform_config->data;
+			dd->platform_config.size = platform_config->size;
+		}
 		goto done;	/* already acquired */
-	else if (fw_state == FW_ERR)
+	} else if (fw_state == FW_ERR) {
 		goto done;	/* already tried and failed */
+	}
 	/* fw_state is FW_EMPTY */
 
 	/* set fw_state to FW_TRY, FW_FINAL, or FW_ERR, and fw_err */
@@ -690,8 +701,14 @@ static int obtain_firmware(struct hfi1_devdata *dd)
 		platform_config = NULL;
 		err = request_firmware(&platform_config, platform_config_name,
 						&dd->pcidev->dev);
-		if (err)
+		if (err) {
 			platform_config = NULL;
+			fw_state = FW_ERR;
+			fw_err = -ENOENT;
+			goto done;
+		}
+		dd->platform_config.data = platform_config->data;
+		dd->platform_config.size = platform_config->size;
 	}
 
 done:
@@ -1457,14 +1474,14 @@ int parse_platform_config(struct hfi1_devdata *dd)
 {
 	struct platform_config_cache *pcfgcache = &dd->pcfg_cache;
 	u32 *ptr = NULL;
-	u32 header1 = 0, header2 = 0, magic_num = 0, crc = 0;
+	u32 header1 = 0, header2 = 0, magic_num = 0, crc = 0, file_length = 0;
 	u32 record_idx = 0, table_type = 0, table_length_dwords = 0;
 
-	if (platform_config == NULL) {
+	if (!dd->platform_config.data) {
 		dd_dev_info(dd, "%s: Missing config file\n", __func__);
 		goto bail;
 	}
-	ptr = (u32 *)platform_config->data;
+	ptr = (u32 *)dd->platform_config.data;
 
 	magic_num = *ptr;
 	ptr++;
@@ -1473,12 +1490,31 @@ int parse_platform_config(struct hfi1_devdata *dd)
 		goto bail;
 	}
 
-	while (ptr < (u32 *)(platform_config->data + platform_config->size)) {
+	/* Field is file size in DWORDs */
+	file_length = (*ptr) * 4;
+	ptr++;
+
+	if (file_length > dd->platform_config.size) {
+		dd_dev_info(dd, "%s:File claims to be larger than read size\n",
+			    __func__);
+		goto bail;
+	} else if (file_length < dd->platform_config.size) {
+		dd_dev_info(dd, "%s:File claims to be smaller than read size\n",
+			    __func__);
+	}
+	/* exactly equal, perfection */
+
+	/*
+	 * In both cases where we proceed, using the self-reported file length
+	 * is the safer option
+	 */
+	while (ptr < (u32 *)(dd->platform_config.data + file_length)) {
 		header1 = *ptr;
 		header2 = *(ptr + 1);
 		if (header1 != ~header2) {
 			dd_dev_info(dd, "%s: Failed validation at offset %ld\n",
-				__func__, (ptr - (u32 *)platform_config->data));
+				__func__, (ptr -
+					   (u32 *)dd->platform_config.data));
 			goto bail;
 		}
 
@@ -1520,7 +1556,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 				dd_dev_info(dd,
 				      "%s: Unknown data table %d, offset %ld\n",
 					__func__, table_type,
-				       (ptr - (u32 *)platform_config->data));
+				       (ptr - (u32 *)dd->platform_config.data));
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table = ptr;
@@ -1541,9 +1577,10 @@ int parse_platform_config(struct hfi1_devdata *dd)
 				break;
 			default:
 				dd_dev_info(dd,
-				  "%s: Unknown metadata table %d, offset %ld\n",
-				  __func__, table_type,
-				  (ptr - (u32 *)platform_config->data));
+					    "%s: Unknown meta table %d, offset %ld\n",
+					    __func__, table_type,
+					    (ptr -
+					     (u32 *)dd->platform_config.data));
 				goto bail; /* We don't trust this file now */
 			}
 			pcfgcache->config_tables[table_type].table_metadata =
@@ -1559,7 +1596,9 @@ int parse_platform_config(struct hfi1_devdata *dd)
 		ptr += table_length_dwords;
 		if (crc != *ptr) {
 			dd_dev_info(dd, "%s: Failed CRC check at offset %ld\n",
-				__func__, (ptr - (u32 *)platform_config->data));
+				    __func__, (ptr -
+					       (u32 *)
+					       dd->platform_config.data));
 			goto bail;
 		}
 		/* Jump the CRC DWORD */
@@ -1675,7 +1714,7 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 		}
 		break;
 	case PLATFORM_CONFIG_PORT_TABLE:
-		/* Port table is 4 DWORDS in META_VERSION 0 */
+		/* Port table is 4 DWORDS */
 		src_ptr = dd->hfi1_id ?
 			pcfgcache->config_tables[table_type].table + 4 :
 			pcfgcache->config_tables[table_type].table;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 585485b..702723b 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1028,6 +1028,7 @@ struct hfi1_devdata {
 	u16 irev;	/* implementation revision */
 	u16 dc8051_ver; /* 8051 firmware version */
 
+	struct platform_config platform_config;
 	struct platform_config_cache pcfg_cache;
 	/* control high-level access to qsfp */
 	struct mutex qsfp_i2c_mutex;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index fe5e1e5..112cb6c 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -983,6 +983,7 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	idr_remove(&hfi1_unit_table, dd->unit);
 	list_del(&dd->list);
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+	free_platform_config(dd);
 	hfi1_dbg_ibdev_exit(&dd->verbs_dev);
 	rcu_barrier(); /* wait for rcu callbacks to complete */
 	free_percpu(dd->int_counter);
diff --git a/drivers/staging/rdma/hfi1/platform.c b/drivers/staging/rdma/hfi1/platform.c
index 506a827..0309c52 100644
--- a/drivers/staging/rdma/hfi1/platform.c
+++ b/drivers/staging/rdma/hfi1/platform.c
@@ -47,7 +47,48 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
+
 #include "hfi.h"
+#include "efivar.h"
+
+void get_platform_config(struct hfi1_devdata *dd)
+{
+	int ret = 0;
+	unsigned long size = 0;
+	u8 *temp_platform_config = NULL;
+
+	ret = read_hfi1_efi_var(dd, "configuration", &size,
+				(void **)&temp_platform_config);
+	if (ret) {
+		dd_dev_info(dd,
+			    "%s: Failed to get platform config from UEFI, falling back to request firmware\n",
+			    __func__);
+		/* fall back to request firmware */
+		platform_config_load = 1;
+		goto bail;
+	}
+
+	dd->platform_config.data = temp_platform_config;
+	dd->platform_config.size = size;
+
+bail:
+	/* exit */;
+}
+
+void free_platform_config(struct hfi1_devdata *dd)
+{
+	if (!platform_config_load) {
+		/*
+		 * was loaded from EFI, release memory
+		 * allocated by read_efi_var
+		 */
+		kfree(dd->platform_config.data);
+	}
+	/*
+	 * else do nothing, dispose_firmware will release
+	 * struct firmware platform_config on driver exit
+	 */
+}
 
 int set_qsfp_tx(struct hfi1_pportdata *ppd, int on)
 {
@@ -739,8 +780,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 
 	/* Skip the tuning for testing (loopback != none) and simulations */
 	if (loopback != LOOPBACK_NONE ||
-	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
-	    !dd->pcfg_cache.cache_valid) {
+	    ppd->dd->icode == ICODE_FUNCTIONAL_SIMULATOR) {
 		ppd->driver_link_ready = 1;
 		return;
 	}
@@ -805,6 +845,12 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 						&rx_preset_index,
 						&tuning_method,
 						&total_atten);
+
+				/*
+				 * We may have modified the QSFP memory, so
+				 * update the cache to reflect the changes
+				 */
+				refresh_qsfp_cache(ppd, &ppd->qsfp_info);
 				if (ret)
 					goto bail;
 			} else {
@@ -820,7 +866,7 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 		break;
 	default:
 		dd_dev_info(ppd->dd, "%s: Unknown port type\n", __func__);
-		break;
+		goto bail;
 	}
 	if (ppd->offline_disabled_reason ==
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE))
@@ -828,10 +874,8 @@ void tune_serdes(struct hfi1_pportdata *ppd)
 			      total_atten,
 			      ppd->qsfp_info.limiting_active);
 
-	if (ppd->port_type == PORT_TYPE_QSFP)
-		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
-
-	ppd->driver_link_ready = 1;
+	if (!ret)
+		ppd->driver_link_ready = 1;
 
 	return;
 bail:
diff --git a/drivers/staging/rdma/hfi1/platform.h b/drivers/staging/rdma/hfi1/platform.h
index 5b53d71..cc280cc 100644
--- a/drivers/staging/rdma/hfi1/platform.h
+++ b/drivers/staging/rdma/hfi1/platform.h
@@ -150,6 +150,11 @@ enum platform_config_variable_settings_table_fields {
 	VARIABLE_SETTINGS_TABLE_MAX
 };
 
+struct platform_config {
+	size_t size;
+	const u8 *data;
+};
+
 struct platform_config_data {
 	u32 *table;
 	u32 *table_metadata;
@@ -293,6 +298,10 @@ enum link_tuning_encoding {
 	OPA_UNKNOWN_TUNING
 };
 
+/* platform.c */
+void get_platform_config(struct hfi1_devdata *dd);
+void free_platform_config(struct hfi1_devdata *dd);
 int set_qsfp_tx(struct hfi1_pportdata *ppd, int on);
 void tune_serdes(struct hfi1_pportdata *ppd);
+
 #endif			/*__PLATFORM_H*/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
