From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/28] IB/hfi1: Read all firmware versions
Date: Mon, 25 Jul 2016 13:39:02 -0700
Message-ID: <20160725203901.4800.39232.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Read the version of the SBus, PCIe SerDes, and Fabric Serdes
firmwares at driver load time.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c           |   25 -----
 drivers/infiniband/hw/hfi1/chip.h           |    1 
 drivers/infiniband/hw/hfi1/chip_registers.h |    4 +
 drivers/infiniband/hw/hfi1/firmware.c       |  125 +++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index f3782b3..faeed29 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8826,30 +8826,6 @@ static int write_tx_settings(struct hfi1_devdata *dd,
 	return load_8051_config(dd, TX_SETTINGS, GENERAL_CONFIG, frame);
 }
 
-static void check_fabric_firmware_versions(struct hfi1_devdata *dd)
-{
-	u32 frame, version, prod_id;
-	int ret, lane;
-
-	/* 4 lanes */
-	for (lane = 0; lane < 4; lane++) {
-		ret = read_8051_config(dd, SPICO_FW_VERSION, lane, &frame);
-		if (ret) {
-			dd_dev_err(dd,
-				   "Unable to read lane %d firmware details\n",
-				   lane);
-			continue;
-		}
-		version = (frame >> SPICO_ROM_VERSION_SHIFT)
-					& SPICO_ROM_VERSION_MASK;
-		prod_id = (frame >> SPICO_ROM_PROD_ID_SHIFT)
-					& SPICO_ROM_PROD_ID_MASK;
-		dd_dev_info(dd,
-			    "Lane %d firmware: version 0x%04x, prod_id 0x%04x\n",
-			    lane, version, prod_id);
-	}
-}
-
 /*
  * Read an idle LCB message.
  *
@@ -14621,7 +14597,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	ret = load_firmware(dd); /* asymmetric with dispose_firmware() */
 	if (ret)
 		goto bail_clear_intr;
-	check_fabric_firmware_versions(dd);
 
 	thermal_init(dd);
 
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index d0a4ddb..f07bc4c 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -640,6 +640,7 @@ extern uint platform_config_load;
 /* SBus commands */
 #define RESET_SBUS_RECEIVER 0x20
 #define WRITE_SBUS_RECEIVER 0x21
+#define READ_SBUS_RECEIVER  0x22
 void sbus_request(struct hfi1_devdata *dd,
 		  u8 receiver_addr, u8 data_addr, u8 command, u32 data_in);
 int sbus_request_slow(struct hfi1_devdata *dd,
diff --git a/drivers/infiniband/hw/hfi1/chip_registers.h b/drivers/infiniband/hw/hfi1/chip_registers.h
index 8744de6..5b99938 100644
--- a/drivers/infiniband/hw/hfi1/chip_registers.h
+++ b/drivers/infiniband/hw/hfi1/chip_registers.h
@@ -471,6 +471,10 @@
 #define ASIC_STS_SBUS_RESULT (ASIC + 0x000000000010)
 #define ASIC_STS_SBUS_RESULT_DONE_SMASK 0x1ull
 #define ASIC_STS_SBUS_RESULT_RCV_DATA_VALID_SMASK 0x2ull
+#define ASIC_STS_SBUS_RESULT_RESULT_CODE_SHIFT 2
+#define ASIC_STS_SBUS_RESULT_RESULT_CODE_MASK 0x7ull
+#define ASIC_STS_SBUS_RESULT_DATA_OUT_SHIFT 32
+#define ASIC_STS_SBUS_RESULT_DATA_OUT_MASK 0xFFFFFFFFull
 #define ASIC_STS_THERM (ASIC + 0x000000000058)
 #define ASIC_STS_THERM_CRIT_TEMP_MASK 0x7FFull
 #define ASIC_STS_THERM_CRIT_TEMP_SHIFT 18
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index ed680fd..13db8eb 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -206,6 +206,9 @@ static const struct firmware *platform_config;
 /* the number of fabric SerDes on the SBus */
 #define NUM_FABRIC_SERDES 4
 
+/* ASIC_STS_SBUS_RESULT.RESULT_CODE value */
+#define SBUS_READ_COMPLETE 0x4
+
 /* SBus fabric SerDes addresses, one set per HFI */
 static const u8 fabric_serdes_addrs[2][NUM_FABRIC_SERDES] = {
 	{ 0x01, 0x02, 0x03, 0x04 },
@@ -240,6 +243,7 @@ static const u8 all_pcie_serdes_broadcast = 0xe0;
 static void dispose_one_firmware(struct firmware_details *fdet);
 static int load_fabric_serdes_firmware(struct hfi1_devdata *dd,
 				       struct firmware_details *fdet);
+static void dump_fw_version(struct hfi1_devdata *dd);
 
 /*
  * Read a single 64-bit value from 8051 data memory.
@@ -1079,6 +1083,44 @@ void sbus_request(struct hfi1_devdata *dd,
 }
 
 /*
+ * Read a value from the SBus.
+ *
+ * Requires the caller to be in fast mode
+ */
+static u32 sbus_read(struct hfi1_devdata *dd, u8 receiver_addr, u8 data_addr,
+		     u32 data_in)
+{
+	u64 reg;
+	int retries;
+	int success = 0;
+	u32 result = 0;
+	u32 result_code = 0;
+
+	sbus_request(dd, receiver_addr, data_addr, READ_SBUS_RECEIVER, data_in);
+
+	for (retries = 0; retries < 100; retries++) {
+		usleep_range(1000, 1200); /* arbitrary */
+		reg = read_csr(dd, ASIC_STS_SBUS_RESULT);
+		result_code = (reg >> ASIC_STS_SBUS_RESULT_RESULT_CODE_SHIFT)
+				& ASIC_STS_SBUS_RESULT_RESULT_CODE_MASK;
+		if (result_code != SBUS_READ_COMPLETE)
+			continue;
+
+		success = 1;
+		result = (reg >> ASIC_STS_SBUS_RESULT_DATA_OUT_SHIFT)
+			   & ASIC_STS_SBUS_RESULT_DATA_OUT_MASK;
+		break;
+	}
+
+	if (!success) {
+		dd_dev_err(dd, "%s: read failed, result code 0x%x\n", __func__,
+			   result_code);
+	}
+
+	return result;
+}
+
+/*
  * Turn off the SBus and fabric serdes spicos.
  *
  * + Must be called with Sbus fast mode turned on.
@@ -1636,6 +1678,7 @@ int load_firmware(struct hfi1_devdata *dd)
 			return ret;
 	}
 
+	dump_fw_version(dd);
 	return 0;
 }
 
@@ -2054,3 +2097,85 @@ void read_guid(struct hfi1_devdata *dd)
 	dd_dev_info(dd, "GUID %llx",
 		    (unsigned long long)dd->base_guid);
 }
+
+/* read and display firmware version info */
+static void dump_fw_version(struct hfi1_devdata *dd)
+{
+	u32 pcie_vers[NUM_PCIE_SERDES];
+	u32 fabric_vers[NUM_FABRIC_SERDES];
+	u32 sbus_vers;
+	int i;
+	int all_same;
+	int ret;
+	u8 rcv_addr;
+
+	ret = acquire_chip_resource(dd, CR_SBUS, SBUS_TIMEOUT);
+	if (ret) {
+		dd_dev_err(dd, "Unable to acquire SBus to read firmware versions\n");
+		return;
+	}
+
+	/* set fast mode */
+	set_sbus_fast_mode(dd);
+
+	/* read version for SBus Master */
+	sbus_request(dd, SBUS_MASTER_BROADCAST, 0x02, WRITE_SBUS_RECEIVER, 0);
+	sbus_request(dd, SBUS_MASTER_BROADCAST, 0x07, WRITE_SBUS_RECEIVER, 0x1);
+	/* wait for interrupt to be processed */
+	usleep_range(10000, 11000);
+	sbus_vers = sbus_read(dd, SBUS_MASTER_BROADCAST, 0x08, 0x1);
+	dd_dev_info(dd, "SBus Master firmware version 0x%08x\n", sbus_vers);
+
+	/* read version for PCIe SerDes */
+	all_same = 1;
+	pcie_vers[0] = 0;
+	for (i = 0; i < NUM_PCIE_SERDES; i++) {
+		rcv_addr = pcie_serdes_addrs[dd->hfi1_id][i];
+		sbus_request(dd, rcv_addr, 0x03, WRITE_SBUS_RECEIVER, 0);
+		/* wait for interrupt to be processed */
+		usleep_range(10000, 11000);
+		pcie_vers[i] = sbus_read(dd, rcv_addr, 0x04, 0x0);
+		if (i > 0 && pcie_vers[0] != pcie_vers[i])
+			all_same = 0;
+	}
+
+	if (all_same) {
+		dd_dev_info(dd, "PCIe SerDes firmware version 0x%x\n",
+			    pcie_vers[0]);
+	} else {
+		dd_dev_warn(dd, "PCIe SerDes do not have the same firmware version\n");
+		for (i = 0; i < NUM_PCIE_SERDES; i++) {
+			dd_dev_info(dd,
+				    "PCIe SerDes lane %d firmware version 0x%x\n",
+				    i, pcie_vers[i]);
+		}
+	}
+
+	/* read version for fabric SerDes */
+	all_same = 1;
+	fabric_vers[0] = 0;
+	for (i = 0; i < NUM_FABRIC_SERDES; i++) {
+		rcv_addr = fabric_serdes_addrs[dd->hfi1_id][i];
+		sbus_request(dd, rcv_addr, 0x03, WRITE_SBUS_RECEIVER, 0);
+		/* wait for interrupt to be processed */
+		usleep_range(10000, 11000);
+		fabric_vers[i] = sbus_read(dd, rcv_addr, 0x04, 0x0);
+		if (i > 0 && fabric_vers[0] != fabric_vers[i])
+			all_same = 0;
+	}
+
+	if (all_same) {
+		dd_dev_info(dd, "Fabric SerDes firmware version 0x%x\n",
+			    fabric_vers[0]);
+	} else {
+		dd_dev_warn(dd, "Fabric SerDes do not have the same firmware version\n");
+		for (i = 0; i < NUM_FABRIC_SERDES; i++) {
+			dd_dev_info(dd,
+				    "Fabric SerDes lane %d firmware version 0x%x\n",
+				    i, fabric_vers[i]);
+		}
+	}
+
+	clear_sbus_fast_mode(dd);
+	release_chip_resource(dd, CR_SBUS);
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
