Received: from mail02.habana.ai (habanamailrelay.habana.ai [213.57.90.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5480A13D53E;
	Thu, 13 Jun 2024 08:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.57.90.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718267003; cv=none; b=d0sHUK3yIhqDVtRH6Xb9e3o0J2rLxHb/rHTqCo/KgqpLSRJTNTPCOzBHscEwd5oce+zGc3tNr80LgzVizkf07S9HljqTnSGxv7cDLLVkafITOk+kGYnUycA1/InuK1qDLrU5sEiH7Y1RQsCKKgN7lP4fIr5E2yeNhuyexUghDAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718267003; c=relaxed/simple;
	bh=hxsSR8mvsDaoDaOg4lYIJoAebQ0l5pnm1QjYovtxLJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NJGHzz8AD7GpLm8Dl4X6F6gBhcRXmg8IlWOpC0J2lJdOXUDiiU8EMGM2tWkXbI4bnDUaESKkvi+4/rXqmlD/piwlvhH5GYjxWgB1r7p1L0vgf503ImdYv9rpDg3DiJocoEjkOKT9cD5fexFjLnZyQuY/9NnTr/4Y8lgt+iU1e20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=habana.ai; spf=pass smtp.mailfrom=habana.ai; dkim=pass (2048-bit key) header.d=habana.ai header.i=@habana.ai header.b=UXDXSsbo; arc=none smtp.client-ip=213.57.90.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=habana.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=habana.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=habana.ai header.i=@habana.ai header.b="UXDXSsbo"
Received: internal info suppressed
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=habana.ai; s=default;
	t=1718266950; bh=hxsSR8mvsDaoDaOg4lYIJoAebQ0l5pnm1QjYovtxLJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXDXSsboQ21G985NMhs/JiPD+4sakPERUx9hc2XPylkqQvVDsM4BrDnWhNfMeMmm2
	 5/Sr7pR3louymxRfCpBmCmB4NWXE+vOgTE0clBg8ukyXPABJMFcYou/SfjUnqfDUZZ
	 1q75u/E3ad0UzbMt6jwoCqAOXbKeKfucM6ckKIt1jA0Z1UfEtkrJfqHUgkVzoFdIBK
	 0CLWVLYVwkFyXStO8QZKCmg2X06XUQUj24NIupnHHpe9JcR1w5y+BJsmCB3Ovxf1su
	 ZCZixtNwCFlfws000XVol9BFTr652w/hElORxahYewe2/TIGt7Mvo+gpdzRVzjKkbc
	 ZNBdW+Cq3+tug==
Received: from oshpigelman-vm-u22.habana-labs.com (localhost [127.0.0.1])
	by oshpigelman-vm-u22.habana-labs.com (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 45D8M8hd1440009;
	Thu, 13 Jun 2024 11:22:11 +0300
From: Omer Shpigelman <oshpigelman@habana.ai>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: ogabbay@kernel.org, oshpigelman@habana.ai, zyehudai@habana.ai
Subject: [PATCH 08/15] net: hbl_cn: gaudi2: ASIC specific support
Date: Thu, 13 Jun 2024 11:22:01 +0300
Message-Id: <20240613082208.1439968-9-oshpigelman@habana.ai>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240613082208.1439968-1-oshpigelman@habana.ai>
References: <20240613082208.1439968-1-oshpigelman@habana.ai>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add GAUDI2 ASIC support which includes HW specific configurations and
operations.
It is initialized on top of the common device layer and has dedicated data
structures which are passed via auxiliary bus.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Co-developed-by: Abhilash K V <kvabhilash@habana.ai>
Signed-off-by: Abhilash K V <kvabhilash@habana.ai>
Co-developed-by: Andrey Agranovich <aagranovich@habana.ai>
Signed-off-by: Andrey Agranovich <aagranovich@habana.ai>
Co-developed-by: Bharat Jauhari <bjauhari@habana.ai>
Signed-off-by: Bharat Jauhari <bjauhari@habana.ai>
Co-developed-by: David Meriin <dmeriin@habana.ai>
Signed-off-by: David Meriin <dmeriin@habana.ai>
Co-developed-by: Sagiv Ozeri <sozeri@habana.ai>
Signed-off-by: Sagiv Ozeri <sozeri@habana.ai>
Co-developed-by: Zvika Yehudai <zyehudai@habana.ai>
Signed-off-by: Zvika Yehudai <zyehudai@habana.ai>
---
 MAINTAINERS                                   |    1 +
 drivers/net/ethernet/intel/hbl_cn/Makefile    |    3 +
 .../net/ethernet/intel/hbl_cn/common/hbl_cn.c |    2 +
 .../net/ethernet/intel/hbl_cn/common/hbl_cn.h |    2 +
 .../net/ethernet/intel/hbl_cn/gaudi2/Makefile |    3 +
 .../ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.c  | 5689 +++++++++++++++++
 .../ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.h  |  427 ++
 .../intel/hbl_cn/gaudi2/gaudi2_cn_debugfs.c   |  319 +
 .../intel/hbl_cn/gaudi2/gaudi2_cn_eq.c        |  732 +++
 .../intel/hbl_cn/gaudi2/gaudi2_cn_phy.c       | 2743 ++++++++
 include/linux/net/intel/gaudi2.h              |  432 ++
 include/linux/net/intel/gaudi2_aux.h          |   94 +
 12 files changed, 10447 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/hbl_cn/gaudi2/Makefile
 create mode 100644 drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.c
 create mode 100644 drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.h
 create mode 100644 drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_debugfs.c
 create mode 100644 drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_eq.c
 create mode 100644 drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_phy.c
 create mode 100644 include/linux/net/intel/gaudi2.h
 create mode 100644 include/linux/net/intel/gaudi2_aux.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 906224204aba..096439a62129 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9615,6 +9615,7 @@ F:	Documentation/networking/device_drivers/ethernet/intel/hbl.rst
 F:	drivers/net/ethernet/intel/hbl_cn/
 F:	include/linux/habanalabs/
 F:	include/linux/net/intel/cn*
+F:	include/linux/net/intel/gaudi2*
 
 HACKRF MEDIA DRIVER
 L:	linux-media@vger.kernel.org
diff --git a/drivers/net/ethernet/intel/hbl_cn/Makefile b/drivers/net/ethernet/intel/hbl_cn/Makefile
index c2c4142f18a0..836b7f7824b4 100644
--- a/drivers/net/ethernet/intel/hbl_cn/Makefile
+++ b/drivers/net/ethernet/intel/hbl_cn/Makefile
@@ -8,4 +8,7 @@ obj-$(CONFIG_HABANA_CN) := habanalabs_cn.o
 include $(src)/common/Makefile
 habanalabs_cn-y += $(HBL_CN_COMMON_FILES)
 
+include $(src)/gaudi2/Makefile
+habanalabs_cn-y += $(HBL_CN_GAUDI2_FILES)
+
 habanalabs_cn-$(CONFIG_DEBUG_FS) += common/hbl_cn_debugfs.o
diff --git a/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.c b/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.c
index fc7bd6474404..b493b681a3b2 100644
--- a/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.c
+++ b/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.c
@@ -1747,6 +1747,8 @@ static int hbl_cn_set_asic_funcs(struct hbl_cn_device *hdev)
 {
 	switch (hdev->asic_type) {
 	case HBL_ASIC_GAUDI2:
+		gaudi2_cn_set_asic_funcs(hdev);
+		break;
 	default:
 		dev_err(hdev->dev, "Unrecognized ASIC type %d\n", hdev->asic_type);
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.h b/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.h
index 0b96cd3db719..0627a2aa6f0c 100644
--- a/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.h
+++ b/drivers/net/ethernet/intel/hbl_cn/common/hbl_cn.h
@@ -1644,6 +1644,8 @@ void hbl_cn_fw_status_work(struct work_struct *work);
 int hbl_cn_get_src_ip(struct hbl_cn_port *cn_port, u32 *src_ip);
 void hbl_cn_ctx_resources_destroy(struct hbl_cn_device *hdev, struct hbl_cn_ctx *ctx);
 
+void gaudi2_cn_set_asic_funcs(struct hbl_cn_device *hdev);
+
 int __hbl_cn_ports_reopen(struct hbl_cn_device *hdev);
 void __hbl_cn_hard_reset_prepare(struct hbl_cn_device *hdev, bool fw_reset, bool in_teardown);
 void __hbl_cn_stop(struct hbl_cn_device *hdev);
diff --git a/drivers/net/ethernet/intel/hbl_cn/gaudi2/Makefile b/drivers/net/ethernet/intel/hbl_cn/gaudi2/Makefile
new file mode 100644
index 000000000000..889776350452
--- /dev/null
+++ b/drivers/net/ethernet/intel/hbl_cn/gaudi2/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+HBL_CN_GAUDI2_FILES := gaudi2/gaudi2_cn.o gaudi2/gaudi2_cn_phy.o \
+	gaudi2/gaudi2_cn_eq.o gaudi2/gaudi2_cn_debugfs.o
diff --git a/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.c b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.c
new file mode 100644
index 000000000000..a1b01c729c31
--- /dev/null
+++ b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.c
@@ -0,0 +1,5689 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#include "gaudi2_cn.h"
+
+#include <linux/circ_buf.h>
+#include <linux/units.h>
+
+#define CFG_BAR_ID	0
+
+#define GAUDI2_NIC_WTD_BP_UPPER_TH_DIFF		24
+#define GAUDI2_NIC_WTD_BP_LOWER_TH_DIFF		26
+#define GAUDI2_NIC_MIN_WQ_SIZE_BP_ENABLED	32
+#define GAUDI2_NIC_MTU_DEFAULT			SZ_8K /* 8KB */
+#define QPC_SANITY_CHECK_INTERVAL_MS		1 /* 1 msec */
+#define NIC_TMR_TIMEOUT_PLDM_US			1000 /* 1 msec */
+#define NIC_TMR_TIMEOUT_PLDM_GRAN		7 /* 512 us */
+
+#define PERF_BW_WINDOW_MSEC 100
+#define PERF_BW_WINDOW_USEC (PERF_BW_WINDOW_MSEC * USEC_PER_MSEC)
+/* Convert bytes per window into gigabytes per second */
+#define PERF_BW_WINDOW_DIV  ((GIGA * PERF_BW_WINDOW_MSEC) / MSEC_PER_SEC)
+
+#define IPV4_PROTOCOL_UDP			17
+#define DUMMY_UDP_PORT				8224
+#define GAUDI2_USER_ENCAP_ID			0
+
+#define GAUDI2_PFC_PRIO_DRIVER			0
+#define GAUDI2_PFC_PRIO_USER_BASE		1
+
+#define GAUDI2_NIC_MAX_CONG_WND			BIT(23)
+#define GAUDI2_NIC_MAX_SPEED			SPEED_100000
+
+#define RETRY_COUNT_QPC_SANITY			10
+#define GAUDI2_NIC_MAX_TIMEOUT_RETRIES		0xFE
+#define GAUDI2_NIC_MAX_SEQ_ERR_RETRIES		0xFE
+
+/* Actual mask used by HW is smaller than the one declared in
+ * NIC0_QPC0_WQ_BP_2ARC_ADDR_VAL_MASK and NIC0_QPC0_WQ_BP_2QMAN_ADDR_VAL_MASK
+ */
+#define WQ_BP_ADDR_VAL_MASK			0x7FFFFFF
+
+/* User encapsulation 32 bit register offset. */
+#define encap_offset(id) ((id) * 4)
+
+/* We have fixed mapping between SW and HW IDs. */
+#define db_fifo_hw_id(id) ((id) - 1)
+
+/* User doorbell fifo 32 bit register offset. */
+#define db_fifo_offset(id) (db_fifo_hw_id(id) * 4)
+
+/* User doorbell fifo 64 bit register offset. */
+#define db_fifo_offset64(id) (db_fifo_hw_id(id) * 8)
+
+static int gaudi2_cn_ctx_init(struct hbl_cn_ctx *ctx);
+static void gaudi2_cn_ctx_fini(struct hbl_cn_ctx *ctx);
+static void gaudi2_qp_sanity_fini(struct gaudi2_cn_port *gaudi2_port);
+static int gaudi2_qp_sanity_init(struct gaudi2_cn_port *gaudi2_port);
+static void gaudi2_get_default_encap_id(struct hbl_cn_port *cn_port, u32 *id);
+static int gaudi2_encap_set(struct hbl_cn_port *cn_port, u32 encap_id,
+			    struct hbl_cn_encap_xarray_pdata *xa_pdata);
+static void gaudi2_user_cq_set_overrun(struct hbl_cn_user_cq *user_cq, bool set_overrun);
+static int gaudi2_cn_poll_reg(struct hbl_cn_device *hdev, u32 reg, u64 timeout_us,
+			      hbl_cn_poll_cond_func func, void *arg);
+
+enum gaudi2_cn_user_bp_offs {
+	HBL_CNI_USER_BP_OFFS_FW,
+	HBL_CNI_USER_BP_OFFS_QMAN
+};
+
+struct gaudi2_cn_stat {
+	char str[ETH_GSTRING_LEN];
+};
+
+static struct gaudi2_cn_stat gaudi2_cn_err_stats[] = {
+	{"Congestion Q err"},
+	{"Eth DB fifo overrun"}
+};
+
+/* Gaudi2 FEC (Fwd Error Correction) Stats */
+static struct gaudi2_cn_stat gaudi2_cn_mac_fec_stats[] = {
+	{"cw_corrected_accum"},
+	{"cw_uncorrect_accum"},
+	{"cw_corrected"},
+	{"cw_uncorrect"},
+	{"symbol_err_corrected_lane_0"},
+	{"symbol_err_corrected_lane_1"},
+	{"symbol_err_corrected_lane_2"},
+	{"symbol_err_corrected_lane_3"},
+	{"pre_FEC_SER_int"},
+	{"pre_FEC_SER_exp (negative)"},
+	{"post_FEC_SER_int"},
+	{"post_FEC_SER_exp (negative)"},
+};
+
+/* Gaudi2 performance Stats */
+static struct gaudi2_cn_stat gaudi2_cn_perf_stats[] = {
+	{"bandwidth_gbps_int"},
+	{"bandwidth_gbps_frac"},
+	{"last_data_latency_usec_int"},
+	{"last_data_latency_usec_frac"},
+};
+
+static size_t gaudi2_cn_err_stats_len = ARRAY_SIZE(gaudi2_cn_err_stats);
+static size_t gaudi2_cn_mac_fec_stats_len = ARRAY_SIZE(gaudi2_cn_mac_fec_stats);
+static size_t gaudi2_cn_perf_stats_len = ARRAY_SIZE(gaudi2_cn_perf_stats);
+
+#define GAUDI2_SYNDROME_TYPE(syndrome)	(((syndrome) >> 6) & 0x3)
+#define GAUDI2_MAX_SYNDROME_STRING_LEN	256
+#define GAUDI2_MAX_SYNDROME_TYPE	3
+
+#define GAUDI2_NUM_OF_NIC_RXB_CORE_SEI_CAUSE	2
+#define GAUDI2_NUM_OF_NIC_RXB_CORE_SPI_CAUSE	6
+#define GAUDI2_NUM_OF_NIC_RXE_SEI_CAUSE		4
+#define GAUDI2_NUM_OF_NIC_RXE_SPI_CAUSE		24
+#define GAUDI2_NUM_OF_NIC_QPC_RESP_ERR_CAUSE	7
+
+static const char * const
+gaudi2_cn_rxb_core_sei_interrupts_cause[GAUDI2_NUM_OF_NIC_RXB_CORE_SEI_CAUSE] = {
+	"HBW RRESP error",
+	"LBW RRESP error"
+};
+
+static const char * const
+gaudi2_cn_rxb_core_spi_interrupts_cause[GAUDI2_NUM_OF_NIC_RXB_CORE_SPI_CAUSE] = {
+	"Packet dropped due to no available buffers",
+	"Control pointers count illegal port 0",
+	"Control pointers count illegal port 1",
+	"Control pointers count illegal port 2",
+	"Control pointers count illegal port 3",
+	"Scatter pointers count illegal"
+};
+
+static const char * const
+gaudi2_cn_qpc_resp_err_interrupts_cause[GAUDI2_NUM_OF_NIC_QPC_RESP_ERR_CAUSE] = {
+	"ARC SEI error",
+	"QPC LBW AXI write slv decode err",
+	"QPC LBW AXI write slv err",
+	"QPC HBW AXI write slv decode err",
+	"QPC HBW AXI write slv err",
+	"QPC HBW AXI read slv decode err",
+	"QPC HBW AXI read slv err"
+};
+
+static const char * const gaudi2_cn_rxe_sei_interrupts_cause[GAUDI2_NUM_OF_NIC_RXE_SEI_CAUSE] = {
+	"HBW RRESP error WQE",
+	"HBW RRESP error FNA",
+	"LBW BRESP error",
+	"HBW BRESP error"
+};
+
+static const char * const gaudi2_cn_rxe_spi_interrupts_cause[GAUDI2_NUM_OF_NIC_RXE_SPI_CAUSE] = {
+	"QP invalid",
+	"TS mismatch",
+	"Request CS invalid",
+	"Response CS invalid",
+	"Request PSN invalid",
+	"Request PSN unsent",
+	"Response RKEY invalid",
+	"Response RESYNC invalid",
+	"Packet bad format",
+	"Invalid opcode",
+	"Invalid syndrome",
+	"Invalid min packet size RC",
+	"Invalid max packet size RC",
+	"Invalid min packet size raw",
+	"Invalid max packet size raw",
+	"Tunnel invalid",
+	"WQE index mismatch",
+	"WQ WR opcode invalid",
+	"WQ RDV opcode invalid",
+	"WQ RD opcode invalid",
+	"WQE WR zero",
+	"WQE multi zero",
+	"WQE WE send big",
+	"WQE multi big"
+};
+
+static char qp_syndromes[NIC_MAX_QP_ERR_SYNDROMES][GAUDI2_MAX_SYNDROME_STRING_LEN] = {
+	/* Rx packet errors*/
+	[0x1]  = "[RX] pkt err, pkt bad format",
+	[0x2]  = "[RX] pkt err, pkt tunnel invalid",
+	[0x3]  = "[RX] pkt err, BTH opcode invalid",
+	[0x4]  = "[RX] pkt err, syndrome invalid",
+	[0x5]  = "[RX] pkt err, Reliable QP max size invalid",
+	[0x6]  = "[RX] pkt err, Reliable QP min size invalid",
+	[0x7]  = "[RX] pkt err, Raw min size invalid",
+	[0x8]  = "[RX] pkt err, Raw max size invalid",
+	[0x9]  = "[RX] pkt err, QP invalid",
+	[0xa]  = "[RX] pkt err, Transport Service mismatch",
+	[0xb]  = "[RX] pkt err, QPC Requester QP state invalid",
+	[0xc]  = "[RX] pkt err, QPC Responder QP state invalid",
+	[0xd]  = "[RX] pkt err, QPC Responder resync invalid",
+	[0xe]  = "[RX] pkt err, QPC Requester PSN invalid",
+	[0xf]  = "[RX] pkt err, QPC Requester PSN unset",
+	[0x10] = "[RX] pkt err, QPC Responder RKEY invalid",
+	[0x11] = "[RX] pkt err, WQE index mismatch",
+	[0x12] = "[RX] pkt err, WQE write opcode invalid",
+	[0x13] = "[RX] pkt err, WQE Rendezvous opcode invalid",
+	[0x14] = "[RX] pkt err, WQE Read  opcode invalid",
+	[0x15] = "[RX] pkt err, WQE Write Zero",
+	[0x16] = "[RX] pkt err, WQE multi zero",
+	[0x17] = "[RX] pkt err, WQE Write send big",
+	[0x18] = "[RX] pkt err, WQE multi big",
+
+	/* QPC errors */
+	[0x40] = "[qpc] [TMR] max-retry-cnt exceeded",
+	[0x41] = "[qpc] [req DB] QP not valid",
+	[0x42] = "[qpc] [req DB] security check",
+	[0x43] = "[qpc] [req DB] PI > last-index",
+	[0x44] = "[qpc] [req DB] wq-type is READ",
+	[0x45] = "[qpc] [req TX] QP not valid",
+	[0x46] = "[qpc] [req TX] Rendezvous WQE but wq-type is not WRITE",
+	[0x47] = "[qpc] [req RX] QP not valid",
+	[0x48] = "[qpc] [req RX] max-retry-cnt exceeded",
+	[0x49] = "[qpc] [req RDV] QP not valid",
+	[0x4a] = "[qpc] [req RDV] wrong wq-type",
+	[0x4b] = "[qpc] [req RDV] PI > last-index",
+	[0x4c] = "[qpc] [res TX] QP not valid",
+	[0x4d] = "[qpc] [res RX] QP not valid",
+
+	/* tx packet error */
+	[0x80] = "[TX] pkt error, QPC.wq_type is write does not support WQE.opcode",
+	[0x81] = "[TX] pkt error, QPC.wq_type is rendezvous does not support WQE.opcode",
+	[0x82] = "[TX] pkt error, QPC.wq_type is read does not support WQE.opcode",
+	[0x83] = "[TX] pkt error, QPC.gaudi1 is set does not support WQE.opcode",
+	[0x84] = "[TX] pkt error, WQE.opcode is write but WQE.size is 0",
+	[0x85] =
+		"[TX] pkt error, WQE.opcode is multi-stride|local-stride|multi-dual but WQE.size is 0",
+	[0x86] = "[TX] pkt error, WQE.opcode is send but WQE.size is 0",
+	[0x87] = "[TX] pkt error, WQE.opcode is rendezvous-write|rendezvous-read but WQE.size is 0",
+	[0x88] = "[TX] pkt error, WQE.opcode is write but size > configured max-write-send-size",
+	[0x89] =
+		"[TX] pkt error, WQE.opcode is multi-stride|local-stride|multi-dual but size > configured max-stride-size",
+	[0x8a] =
+		"[TX] pkt error, WQE.opcode is rendezvous-write|rendezvous-read but QPC.remote_wq_log_size <= configured min-remote-log-size",
+	[0x8b] =
+		"[TX] pkt error, WQE.opcode is rendezvous-write but WQE.size != configured rdv-wqe-size (per granularity)",
+	[0x8c] =
+		"[TX] pkt error, WQE.opcode is rendezvous-read but WQE.size != configured rdv-wqe-size (per granularity)",
+	[0x8d] =
+		"[TX] pkt error, WQE.inline is set but WQE.size != configured inline-wqe-size (per granularity)",
+	[0x8e] = "[TX] pkt error, QPC.gaudi1 is set but WQE.inline is set",
+	[0x8f] =
+		"[TX] pkt error, WQE.opcode is multi-stride|local-stride|multi-dual but QPC.swq_granularity is 0",
+	[0x90] = "[TX] pkt error, WQE.opcode != NOP but WQE.reserved0 != 0",
+	[0x91] = "[TX] pkt error, WQE.opcode != NOP but WQE.wqe_index != execution-index [7.0]",
+	[0x92] =
+		"[TX] pkt error, WQE.opcode is multi-stride|local-stride|multi-dual but WQE.size < stride-size",
+	[0x93] =
+		"[TX] pkt error, WQE.reduction_opcode is upscale but WQE.remote_address LSB is not 0",
+	[0x94] = "[TX] pkt error, WQE.reduction_opcode is upscale but does not support WQE.opcode",
+	[0x95] = "[TX] pkt error, RAW packet but WQE.size not supported",
+	[0xB0] = "WQE.opcode is QoS but WQE.inline is set",
+	[0xB1] = "WQE.opcode above 15",
+	[0xB2] = "RAW above MIN",
+	[0xB3] = "RAW below MAX",
+	[0xB4] = "WQE.reduction is disable but reduction-opcode is not 0",
+	[0xB5] = "WQE.opcode is READ-RDV but WQE.inline is set",
+	[0xB6] = "WQE fetch WR size not 4",
+	[0xB7] = "WQE fetch WR addr not mod4",
+	[0xB8] = "RDV last-index",
+	[0xB9] = "Gaudi1 multi-dual",
+	[0xBA] = "WQE bad opcode",
+	[0xBB] = "WQE bad size",
+	[0xBC] = "WQE SE not RAW",
+	[0xBD] = "Gaudi1 tunnal",
+	[0xBE] = "Tunnel 0-size",
+	[0xBF] = "Tunnel max size",
+};
+
+char *gaudi2_cn_qp_err_syndrome_to_str(u32 syndrome)
+{
+	int syndrome_type;
+	char *str;
+
+	/* syndrome comprised from 8 bits
+	 * [2:type, 6:syndrome]
+	 * 6 bits for syndrome
+	 * 2 bits for type
+	 *   0 - rx packet error
+	 *   1 - qp error
+	 *   2 - tx packet error
+	 */
+
+	if (syndrome >= NIC_MAX_QP_ERR_SYNDROMES)
+		return "syndrome unknown";
+
+	syndrome_type = GAUDI2_SYNDROME_TYPE(syndrome);
+
+	str = qp_syndromes[syndrome];
+	if (strlen(str))
+		return str;
+
+	switch (syndrome_type) {
+	case 0:
+		str = "RX packet syndrome unknown";
+		break;
+	case 1:
+		str = "QPC syndrome unknown";
+		break;
+	case 2:
+		str = "TX packet syndrome unknown";
+		break;
+	default:
+		str = "syndrome unknown";
+		break;
+	}
+
+	return str;
+}
+
+static void db_fifo_toggle_err_evt(struct hbl_cn_port *cn_port, bool enable)
+{
+	u32 mask = NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERR_FIFO_NON_V_MASK |
+		   NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_ERR_PI_EX_LAST_MASK;
+	u32 val = enable ? (mask >> __ffs(mask)) : 0;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	NIC_RMWREG32_SHIFTED(NIC0_QPC0_REQ_STATIC_CONFIG, val, mask);
+}
+
+static void __gaudi2_cn_get_db_fifo_umr(struct hbl_cn_port *cn_port, u32 block_id, u32 offset_id,
+					u64 *umr_block_addr, u32 *umr_db_offset)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port, odd_db_offset;
+	struct gaudi2_cn_device *gaudi2;
+
+	gaudi2 = hdev->asic_specific;
+	odd_db_offset = NIC0_UMR0_0_UNSECURE_DOORBELL1_UNSECURE_DB_FIRST32 -
+			NIC0_UMR0_0_UNSECURE_DOORBELL0_UNSECURE_DB_FIRST32;
+
+	/* UMR base address we map to userspace */
+	*umr_block_addr = gaudi2->cfg_base +
+			  NIC_CFG_BASE(port, NIC0_UMR0_0_UNSECURE_DOORBELL0_BASE) +
+			  NIC0_UMR0_0_UNSECURE_DOORBELL0_BASE + (block_id * NIC_UMR_OFFSET);
+
+	/* Each UMR block hosts 2 doorbell fifos. Get byte offset. */
+	*umr_db_offset = (offset_id & 1) ? odd_db_offset : 0;
+}
+
+static void gaudi2_cn_get_db_fifo_umr(struct hbl_cn_port *cn_port, u32 id, u64 *umr_block_addr,
+				      u32 *umr_db_offset)
+{
+	__gaudi2_cn_get_db_fifo_umr(cn_port, db_fifo_hw_id(id) / 2, db_fifo_hw_id(id),
+				    umr_block_addr, umr_db_offset);
+}
+
+static void db_fifo_push_dummy(struct hbl_cn_port *cn_port, u32 id, int n_dummy, bool is_eth)
+{
+	u32 port, umr_db_offset, offset_0_31, offset_32_64, db_dummy[2];
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_cn_device *gaudi2;
+	u64 umr_block_addr;
+	int i;
+
+	gaudi2 = hdev->asic_specific;
+	port = cn_port->port;
+
+	/* 8 bytes dummy doorbell packet with unused QP ID. */
+	db_dummy[0] = 0;
+	db_dummy[1] = NIC_MAX_QP_NUM;
+
+	/* Get DB fifo offset in register configuration space. */
+	gaudi2_cn_get_db_fifo_umr(cn_port, id, &umr_block_addr, &umr_db_offset);
+	offset_0_31 = umr_block_addr - gaudi2->cfg_base + umr_db_offset;
+	offset_32_64 = offset_0_31 + (NIC0_UMR0_0_UNSECURE_DOORBELL0_UNSECURE_DB_SECOND32 -
+				      NIC0_UMR0_0_UNSECURE_DOORBELL0_UNSECURE_DB_FIRST32);
+
+	/* Split user doorbell fifo packets to fit 32 bit registers. */
+	for (i = 0; i < n_dummy; i++)
+		if (is_eth) {
+			NIC_WREG32(NIC0_QPC0_SECURED_DB_FIRST32, db_dummy[0]);
+			NIC_WREG32(NIC0_QPC0_SECURED_DB_SECOND32, db_dummy[1]);
+		} else {
+			WREG32(offset_0_31, db_dummy[0]);
+			WREG32(offset_32_64, db_dummy[1]);
+		}
+
+	if (gaudi2->flush_db_fifo) {
+		if (is_eth)
+			NIC_RREG32(NIC0_QPC0_SECURED_DB_FIRST32);
+		else
+			RREG32(offset_0_31);
+	}
+}
+
+static bool db_fifo_reset_cond_func1(u32 val, void *arg)
+{
+	return val;
+}
+
+static bool db_fifo_reset_cond_func2(u32 val, void *arg)
+{
+	return val == (NIC_FIFO_DB_SIZE - 1);
+}
+
+/* Doorbell fifo H/W bug. There is no provision for S/W to reset H/W CI.
+ * Hence, we implement workaround. Push dummy doorbells to db fifos till
+ * CI wraps.
+ */
+static void __db_fifo_reset(struct hbl_cn_port *cn_port, u32 *ci_cpu_addr, u32 id, bool is_eth)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	u32 ci = *ci_cpu_addr, port;
+	struct hbl_aux_dev *aux_dev;
+	int rc;
+
+	aux_dev = hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	/* no need to push dummy doorbells, as the hard will reset itself. However, reset the memory
+	 * where the last CI is stored at.
+	 */
+	if (!hdev->operational) {
+		*ci_cpu_addr = 0;
+		return;
+	}
+
+	port = cn_port->port;
+
+	/* Stop HW from throwing below error events.
+	 * 1. Requester DB, invalid QP
+	 * 2. Requester DB, PI > last WQ index
+	 *
+	 * Dummy doorbell piggybacks on the idea that HW updates CI
+	 * even for invalid doorbells. However, EQ error events are
+	 * generated and fifo is pushed to error state.
+	 */
+	db_fifo_toggle_err_evt(cn_port, false);
+
+	/* 1. Another User doorbell fifo HW bug. CI updated by HW is one
+	 * less than number of doorbells pushed.
+	 * 2. We cannot assert if user has pushed any doorbells. i.e
+	 * CI buffer is default 0 or HW updated zero.
+	 *
+	 * To handle above scenario we push 2 dummy doorbells if CI is zero.
+	 * This forces HW to update CI buffer. Hence, ensuring we are not
+	 * dealing with default zero memory.
+	 * Note, driver ensures CI buffer is zeroed out before passing it on to HW.
+	 */
+	if (!ci) {
+		db_fifo_push_dummy(cn_port, id, 2, is_eth);
+
+		rc = gaudi2_aux_ops->poll_mem(aux_dev, ci_cpu_addr, &ci, db_fifo_reset_cond_func1);
+		if (rc && !ci)
+			dev_err(hdev->dev, "Doorbell fifo reset timed out\n");
+	}
+
+	/* Push dummy doorbells such that HW CI points to fifo base. */
+	db_fifo_push_dummy(cn_port, id, NIC_FIFO_DB_SIZE - ci - 1, is_eth);
+
+	/* Wait for HW to absorb dummy doorbells and update CI. */
+	rc = gaudi2_aux_ops->poll_mem(aux_dev, ci_cpu_addr, &ci, db_fifo_reset_cond_func2);
+	if (rc && (ci != (NIC_FIFO_DB_SIZE - 1)))
+		dev_err(hdev->dev, "Doorbell fifo reset timed out, ci: %d\n", ci);
+
+	db_fifo_toggle_err_evt(cn_port, true);
+
+	/* Zero out HW CI buffer address register for added safety. */
+	if (is_eth) {
+		NIC_WREG32(NIC0_QPC0_DBFIFOSECUR_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_31_7, 0);
+		NIC_WREG32(NIC0_QPC0_DBFIFOSECUR_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_63_32, 0);
+	} else {
+		NIC_WREG32(NIC0_QPC0_DBFIFO0_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_31_7 +
+			   db_fifo_offset64(id), 0);
+		NIC_WREG32(NIC0_QPC0_DBFIFO0_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_63_32 +
+			   db_fifo_offset64(id), 0);
+	}
+}
+
+static void gaudi2_cn_db_fifo_reset(struct hbl_aux_dev *aux_dev, u32 port)
+{
+	struct hbl_cn_device *hdev = container_of(aux_dev, struct hbl_cn_device, en_aux_dev);
+	struct hbl_cn_port *cn_port = &hdev->cn_ports[port];
+	struct gaudi2_cn_port *gaudi2_port;
+	u32 *ci_cpu_addr;
+
+	gaudi2_port = cn_port->cn_specific;
+	ci_cpu_addr = (u32 *)RING_BUF_ADDRESS(&gaudi2_port->fifo_ring);
+
+	gaudi2_port->db_fifo_pi = 0;
+
+	__db_fifo_reset(cn_port, ci_cpu_addr, 0, true);
+}
+
+static int gaudi2_cn_config_wqe_asid(struct hbl_cn_port *cn_port, u32 asid, bool set_asid)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	int rc;
+
+	rc = hbl_cn_send_cpucp_packet(hdev, port, set_asid ? CPUCP_PACKET_NIC_WQE_ASID_SET :
+				      CPUCP_PACKET_NIC_WQE_ASID_UNSET, asid);
+	if (rc)
+		dev_err(hdev->dev, "Failed to %s WQE ASID, port %d, rc %d\n",
+			set_asid ? "set" : "unset", port, rc);
+
+	return rc;
+}
+
+static int gaudi2_cn_disable_wqe_index_checker(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	int rc;
+
+	rc = hbl_cn_send_cpucp_packet(hdev, port, CPUCP_PACKET_NIC_SET_CHECKERS,
+				      RX_WQE_IDX_MISMATCH);
+
+	if (rc) {
+		dev_err(hdev->dev,
+			"Failed to disable Rx WQE idx mismatch checker, port %d, rc %d\n", port,
+			rc);
+		return rc;
+	}
+
+	rc = hbl_cn_send_cpucp_packet(hdev, port, CPUCP_PACKET_NIC_SET_CHECKERS,
+				      TX_WQE_IDX_MISMATCH);
+	if (rc) {
+		dev_err(hdev->dev,
+			"Failed to disable Tx WQE idx mismatch checker, port %d, rc %d\n", port,
+			rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void *gaudi2_cn_dma_alloc_coherent(struct hbl_cn_device *hdev, size_t size,
+					  dma_addr_t *dma_handle, gfp_t flag)
+{
+	const struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct hbl_aux_dev *aux_dev = hdev->cn_aux_dev;
+
+	return gaudi2->cn_aux_ops->dma_alloc_coherent(aux_dev, size, dma_handle, flag);
+}
+
+static void gaudi2_cn_dma_free_coherent(struct hbl_cn_device *hdev, size_t size, void *cpu_addr,
+					dma_addr_t dma_handle)
+{
+	const struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct hbl_aux_dev *aux_dev = hdev->cn_aux_dev;
+
+	gaudi2->cn_aux_ops->dma_free_coherent(aux_dev, size, cpu_addr, dma_handle);
+}
+
+static void *gaudi2_cn_dma_pool_zalloc(struct hbl_cn_device *hdev, size_t size, gfp_t mem_flags,
+				       dma_addr_t *dma_handle)
+{
+	const struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct hbl_aux_dev *aux_dev = hdev->cn_aux_dev;
+
+	return gaudi2->cn_aux_ops->dma_pool_zalloc(aux_dev, size, mem_flags, dma_handle);
+}
+
+static void gaudi2_cn_dma_pool_free(struct hbl_cn_device *hdev, void *vaddr, dma_addr_t dma_addr)
+{
+	const struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct hbl_aux_dev *aux_dev = hdev->cn_aux_dev;
+
+	gaudi2->cn_aux_ops->dma_pool_free(aux_dev, vaddr, dma_addr);
+}
+
+static int gaudi2_cn_send_cpu_message(struct hbl_cn_device *hdev, u32 *msg, u16 len, u32 timeout,
+				      u64 *result)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+
+	aux_dev = hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	return gaudi2_aux_ops->send_cpu_message(aux_dev, msg, len, timeout, result);
+}
+
+static int gaudi2_cn_poll_reg(struct hbl_cn_device *hdev, u32 reg, u64 timeout_us,
+			      hbl_cn_poll_cond_func func, void *arg)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+
+	aux_dev = hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	return gaudi2_aux_ops->poll_reg(aux_dev, reg, timeout_us, func, arg);
+}
+
+static int gaudi2_cn_alloc_cq_rings(struct gaudi2_cn_port *gaudi2_port)
+{
+	u32 elem_size, queue_size, total_queues_size, count;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	struct hbl_cn_ring *ring;
+	dma_addr_t dma_addr;
+	void *cpu_addr;
+	int rc, i;
+
+	elem_size = sizeof(struct gaudi2_cqe);
+	count = NIC_CQ_MAX_ENTRIES;
+	queue_size = elem_size * count;
+	total_queues_size = queue_size * GAUDI2_NIC_MAX_CQS_NUM;
+
+	/* The HW expects that all CQs will be located in a physically consecutive memory one after
+	 * the other. Hence we allocate all of them in one chunk.
+	 */
+	cpu_addr = hbl_cn_dma_alloc_coherent(hdev, total_queues_size, &dma_addr, GFP_KERNEL);
+	if (!cpu_addr)
+		return -ENOMEM;
+
+	for (i = 0; i < NIC_CQS_NUM; i++) {
+		ring = &gaudi2_port->cq_rings[i];
+		RING_BUF_ADDRESS(ring) = cpu_addr + i * queue_size;
+		RING_BUF_DMA_ADDRESS(ring) = dma_addr + i * queue_size;
+		/* prevent freeing memory fragments by individual Qs */
+		RING_BUF_SIZE(ring) = i ? 0 : total_queues_size;
+		ring->count = count;
+		ring->elem_size = elem_size;
+		ring->asid = hdev->kernel_asid;
+	}
+
+	for (i = 0; i < NIC_CQS_NUM; i++) {
+		ring = &gaudi2_port->cq_rings[i];
+		RING_PI_SIZE(ring) = sizeof(u64);
+		RING_PI_ADDRESS(ring) = hbl_cn_dma_pool_zalloc(hdev, RING_PI_SIZE(ring),
+							       GFP_KERNEL | __GFP_ZERO,
+							       &RING_PI_DMA_ADDRESS(ring));
+		if (!RING_PI_ADDRESS(ring)) {
+			rc = -ENOMEM;
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	/* free the allocated rings indices */
+	for (--i; i >= 0; i--) {
+		ring = &gaudi2_port->cq_rings[i];
+		hbl_cn_dma_pool_free(hdev, RING_PI_ADDRESS(ring), RING_PI_DMA_ADDRESS(ring));
+	}
+
+	/* free rings memory */
+	hbl_cn_dma_free_coherent(hdev, total_queues_size, cpu_addr, dma_addr);
+
+	return rc;
+}
+
+static void gaudi2_cn_free_cq_rings(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	struct hbl_cn_ring *ring;
+	int i;
+
+	for (i = 0; i < NIC_CQS_NUM; i++) {
+		ring = &gaudi2_port->cq_rings[i];
+		hbl_cn_dma_pool_free(hdev, RING_PI_ADDRESS(ring), RING_PI_DMA_ADDRESS(ring));
+	}
+
+	/* the entire CQs memory is allocated as one chunk and stored at index 0 */
+	ring = &gaudi2_port->cq_rings[0];
+	hbl_cn_dma_free_coherent(hdev, RING_BUF_SIZE(ring), RING_BUF_ADDRESS(ring),
+				 RING_BUF_DMA_ADDRESS(ring));
+}
+
+static int gaudi2_cn_alloc_rings_resources(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	int rc;
+
+	rc = hbl_cn_alloc_ring(hdev, &gaudi2_port->fifo_ring,
+			       ALIGN(sizeof(u32), DEVICE_CACHE_LINE_SIZE), 1);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to allocate fifo ring\n");
+		return rc;
+	}
+
+	rc = hbl_cn_alloc_ring(hdev, &gaudi2_port->rx_ring, NIC_RAW_ELEM_SIZE,
+			       NIC_RX_RING_PKT_NUM);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to allocate RX ring\n");
+		goto err_rx_ring;
+	}
+
+	rc = hbl_cn_alloc_ring(hdev, &gaudi2_port->wq_ring, sizeof(struct gaudi2_sq_wqe),
+			       QP_WQE_NUM_REC);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to allocate WQ ring\n");
+		goto err_wq_ring;
+	}
+
+	rc = hbl_cn_alloc_ring(hdev, &gaudi2_port->eq_ring, sizeof(struct hbl_cn_eqe),
+			       NIC_EQ_RING_NUM_REC);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to allocate EQ ring\n");
+		goto err_eq_ring;
+	}
+
+	rc = gaudi2_cn_alloc_cq_rings(gaudi2_port);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to allocate CQ rings\n");
+		goto err_cq_rings;
+	}
+
+	return 0;
+
+err_cq_rings:
+	hbl_cn_free_ring(hdev, &gaudi2_port->eq_ring);
+err_eq_ring:
+	hbl_cn_free_ring(hdev, &gaudi2_port->wq_ring);
+err_wq_ring:
+	hbl_cn_free_ring(hdev, &gaudi2_port->rx_ring);
+err_rx_ring:
+	hbl_cn_free_ring(hdev, &gaudi2_port->fifo_ring);
+
+	return rc;
+}
+
+static void gaudi2_cn_free_rings_resources(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+
+	gaudi2_cn_free_cq_rings(gaudi2_port);
+	hbl_cn_free_ring(hdev, &gaudi2_port->eq_ring);
+	hbl_cn_free_ring(hdev, &gaudi2_port->wq_ring);
+	hbl_cn_free_ring(hdev, &gaudi2_port->rx_ring);
+	hbl_cn_free_ring(hdev, &gaudi2_port->fifo_ring);
+}
+
+static void gaudi2_cn_reset_rings(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_ring *cq_ring;
+
+	/* Reset CQ ring HW PI and shadow PI/CI */
+	cq_ring = &gaudi2_port->cq_rings[NIC_CQ_RDMA_IDX];
+	*((u32 *)RING_PI_ADDRESS(cq_ring)) = 0;
+	cq_ring->pi_shadow = 0;
+	cq_ring->ci_shadow = 0;
+}
+
+static void gaudi2_cn_port_sw_fini(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+
+	mutex_destroy(&gaudi2_port->qp_destroy_lock);
+	mutex_destroy(&gaudi2_port->cfg_lock);
+
+	hbl_cn_eq_dispatcher_fini(cn_port);
+	gaudi2_cn_free_rings_resources(gaudi2_port);
+}
+
+static void link_eqe_init(struct hbl_cn_port *cn_port)
+{
+	/* Init only header. Data field(i.e. link status) would be updated
+	 * when event is ready to be sent to user.
+	 */
+	cn_port->link_eqe.data[0] = EQE_HEADER(true, EQE_LINK_STATUS);
+}
+
+static int gaudi2_cn_port_sw_init(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct gaudi2_cn_device *gaudi2;
+	u32 port = cn_port->port;
+	int rc;
+
+	gaudi2 = hdev->asic_specific;
+	gaudi2_port = &gaudi2->cn_ports[port];
+	gaudi2_port->hdev = hdev;
+	gaudi2_port->cn_port = cn_port;
+	cn_port->cn_specific = gaudi2_port;
+
+	cn_port->cn_macro = &hdev->cn_macros[port >> 1];
+
+	INIT_DELAYED_WORK(&cn_port->fw_status_work, hbl_cn_fw_status_work);
+
+	rc = gaudi2_cn_alloc_rings_resources(gaudi2_port);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to alloc rings, port: %d, %d\n", port, rc);
+		return rc;
+	}
+
+	hbl_cn_eq_dispatcher_init(gaudi2_port->cn_port);
+
+	mutex_init(&gaudi2_port->cfg_lock);
+	mutex_init(&gaudi2_port->qp_destroy_lock);
+
+	/* Userspace might not be notified immediately of link event from HW.
+	 * e.g. if serdes is not yet configured or link is not stable, SW might
+	 * defer sending link event to userspace.
+	 * Hence we cache HW link EQE and updated with real link status just
+	 * before sending to userspace.
+	 */
+	link_eqe_init(cn_port);
+
+	return 0;
+}
+
+static int gaudi2_cn_macro_sw_init(struct hbl_cn_macro *cn_macro)
+{
+	return 0;
+}
+
+static void gaudi2_cn_macro_sw_fini(struct hbl_cn_macro *cn_macro)
+{
+}
+
+static int gaudi2_cn_set_pfc(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port, val = 0;
+	int i, start_lane;
+
+	val |= NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_TX_ENA_MASK |
+		NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_RX_ENA_MASK |
+		NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_PROMIS_EN_MASK |
+		NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_TX_PAD_EN_MASK;
+
+	if (cn_port->pfc_enable) {
+		val |= NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_PFC_MODE_MASK;
+	} else {
+		val |= NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_PAUSE_IGNORE_MASK |
+		       NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG_CNTL_FRAME_ENA_MASK;
+	}
+
+	/* Write the value for each lane under this port */
+	start_lane = (port & 1) ? (NIC_MAC_NUM_OF_LANES / 2) : NIC_MAC_LANES_START;
+
+	for (i = start_lane; i < start_lane + (NIC_MAC_NUM_OF_LANES / 2); i++)
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG + MAC_CH_OFFSET(i), val);
+
+	return 0;
+}
+
+static int gaudi2_cn_config_port_hw_txs(struct gaudi2_cn_port *gaudi2_port)
+{
+	u32 txs_schedq, txs_fence_idx, txs_pi, txs_ci, txs_tail, txs_head, txs_timeout_31_0,
+	    timeout_47_32, prio, txs_port, rl_en_log_time;
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct cpucp_cn_init_hw_mem_packet pkt;
+	struct hbl_cn_properties *cn_prop;
+	struct hbl_cn_device *hdev;
+	u32 port = cn_port->port;
+	bool use_cpucp;
+	u64 txs_addr;
+	int i, rc;
+
+	hdev = gaudi2_port->hdev;
+	cn_prop = &hdev->cn_props;
+
+	txs_addr = cn_prop->txs_base_addr + port * cn_prop->txs_base_size;
+
+	use_cpucp = !!(hdev->fw_app_cpu_boot_dev_sts0 & CPU_BOOT_DEV_STS0_NIC_MEM_CLEAR_EN);
+	if (use_cpucp) {
+		memset(&pkt, 0, sizeof(pkt));
+		pkt.cpucp_pkt.ctl = cpu_to_le32(CPUCP_PACKET_NIC_INIT_TXS_MEM <<
+						CPUCP_PKT_CTL_OPCODE_SHIFT);
+		pkt.cpucp_pkt.port_index = cpu_to_le32(port);
+		pkt.mem_base_addr = cpu_to_le64(txs_addr + TXS_FREE_OFFS);
+		pkt.num_entries = cpu_to_le16(TXS_FREE_NUM_ENTRIES);
+		pkt.entry_size = cpu_to_le16(TXS_ENT_SIZE);
+		pkt.granularity = cpu_to_le16(TXS_GRANULARITY);
+
+		rc = gaudi2_cn_send_cpu_message(hdev, (u32 *)&pkt, sizeof(pkt), 0, NULL);
+
+		if (rc) {
+			dev_err(hdev->dev,
+				"Failed to handle CPU-CP pkt %u, error %d\n",
+				CPUCP_PACKET_NIC_INIT_TXS_MEM, rc);
+			return rc;
+		}
+	} else {
+		/* TX sched-Qs list */
+		for (i = 0; i < TXS_FREE_NUM_ENTRIES; i++)
+			hbl_cn_dram_writel(hdev, TXS_GRANULARITY + i,
+					   txs_addr + TXS_FREE_OFFS + i * TXS_ENT_SIZE);
+
+		/* Perform read to flush the writes */
+		hbl_cn_dram_readl(hdev, txs_addr);
+	}
+
+	WARN_ON_CACHE_UNALIGNED(txs_addr + TXS_FIFO_OFFS);
+
+	/* set TX sched queues address */
+	NIC_WREG32(NIC0_TXS0_BASE_ADDRESS_63_32, upper_32_bits(txs_addr + TXS_FIFO_OFFS));
+	NIC_WREG32(NIC0_TXS0_BASE_ADDRESS_31_7, lower_32_bits(txs_addr + TXS_FIFO_OFFS) >> 7);
+
+	/* Set access to bypass the MMU (old style configuration) */
+	NIC_WREG32(NIC0_TXS0_AXI_USER_LO, 0x400);
+
+	NIC_WREG32(NIC0_TXS0_FREE_LIST_PUSH_MASK_EN, 1);
+
+	txs_fence_idx = 0;
+	txs_pi = 0;
+	txs_ci = 0;
+	txs_tail = 0;
+	txs_head = 0;
+	txs_timeout_31_0 = 0;
+	timeout_47_32 = 0;
+	prio = 0;
+	txs_port = 0;
+	rl_en_log_time = 0;
+
+	/* Gaudi2 TXS implements 256 schedule-Qs.
+	 * These queues are hard-divided to 4x64 priority groups of Qs.
+	 *    (The first and last Q group-relative numbers of each group (0-63) can be configured
+	 *     via NIC0_TXS0_FIRST_SCHEDQ_ID and NIC0_TXS0_LAST_SCHEDQ_ID, We will use its
+	 *     default values of 0 and 63 respectively).
+	 * From the above pools we need to allocate and configure:
+	 *   256 Qs (0-255) are evenly divided between the 4 possible ports so each port is
+	 *       assigned with 64 Qs.
+	 *   The 64 Qs are divided between the 4 possible priorities generating 16
+	 *   priority-granularity groups of which:
+	 *   - The Last group is dedicated for Ethernet (RAW_SCHED_Q).
+	 *   - The last-1 group is dedicated for the RDMA responder (RES_SCHED_Q)
+	 *   - The Last-2 group is dedicated for the RDMA Req (REQ_SCHED_Q)
+	 *   - The remaining Qs will be used by the BBR when supported.
+	 */
+	for (i = 0; i < TXS_SCHEDQ; i++) {
+		/* main sched Qs */
+		txs_port = i / TXS_PORT_NUM_SCHEDQS;
+
+		prio = i % HBL_EN_PFC_PRIO_NUM;
+		txs_schedq = (timeout_47_32 & 0xFFFF) | ((prio & 0x3) << 16) |
+			     ((txs_port & 1) << 18) | ((rl_en_log_time & 0x3F) << 19);
+		txs_tail = i;
+		txs_head = i;
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_31_0, txs_fence_idx);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_63_32, txs_pi);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_95_64, txs_ci);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_127_96, txs_tail);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_159_128, txs_head);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_191_160, txs_timeout_31_0);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_DESC_217_192, txs_schedq);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_FIFO, i);
+		NIC_WREG32(NIC0_TXS0_SCHEDQ_UPDATE_EN, 1);
+	}
+
+	NIC_WREG32(NIC0_TXS0_TICK_WRAP, 100);
+
+	NIC_WREG32(NIC0_TXS0_SCAN_TIME_COMPARE_0, 4);
+	NIC_WREG32(NIC0_TXS0_SCAN_TIME_COMPARE_1, 0);
+	NIC_WREG32(NIC0_TXS0_TMR_SCAN_EN, 1);
+
+	NIC_WREG32(NIC0_TXS0_BASE_ADDRESS_FREE_LIST_63_32,
+		   upper_32_bits(txs_addr + TXS_FREE_OFFS));
+
+	NIC_WREG32(NIC0_TXS0_BASE_ADDRESS_FREE_LIST_31_0,
+		   lower_32_bits(txs_addr + TXS_FREE_OFFS));
+
+	NIC_WREG32(NIC0_TXS0_LIST_MASK,
+		   ~(0xFFFFFFFF << (ilog2(TXS_FREE_NUM_ENTRIES) - 5)));
+	NIC_WREG32(NIC0_TXS0_PRODUCER_UPDATE, TXS_FREE_NUM_ENTRIES);
+	NIC_WREG32(NIC0_TXS0_PRODUCER_UPDATE_EN, 1);
+	NIC_WREG32(NIC0_TXS0_PRODUCER_UPDATE_EN, 0);
+	NIC_WREG32(NIC0_TXS0_LIST_MEM_READ_MASK, 0);
+	NIC_WREG32(NIC0_TXS0_PUSH_LOCK_EN, 1);
+
+	/* disable burst size optimization */
+	NIC_WREG32(NIC0_TXS0_IGNORE_BURST_EN, 0);
+
+	return 0;
+}
+
+static void gaudi2_cn_config_port_hw_txe(struct gaudi2_cn_port *gaudi2_port, u64 mac_addr)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	struct hbl_cn_properties *cn_prop;
+	u32 port;
+
+	cn_prop = &hdev->cn_props;
+	port = gaudi2_port->cn_port->port;
+
+	/* set the base address of the raw wq */
+	NIC_WREG32(NIC0_TXE0_SQ_BASE_ADDRESS_63_32_0,
+		   upper_32_bits(RING_BUF_DMA_ADDRESS(&gaudi2_port->wq_ring)));
+
+	NIC_WREG32(NIC0_TXE0_SQ_BASE_ADDRESS_31_0_0,
+		   lower_32_bits(RING_BUF_DMA_ADDRESS(&gaudi2_port->wq_ring)));
+
+	NIC_WREG32(NIC0_TXE0_LOG_MAX_WQ_SIZE_0, WQ_BUFFER_LOG_SIZE - 2);
+
+	/* map: prio#0-dscp#0, prio#1-dscp#0, prio#2-dscp#16, prio#3-dscp#24 */
+	NIC_WREG32(NIC0_TXE0_PRIO_TO_DSCP_0, 0x18100000);
+
+	NIC_WREG32(NIC0_TXE0_PORT0_MAC_CFG_47_32, (mac_addr >> 32) & 0xFFFF);
+	NIC_WREG32(NIC0_TXE0_PORT0_MAC_CFG_31_0, mac_addr & 0xFFFFFFFF);
+	NIC_WREG32(NIC0_TXE0_PORT1_MAC_CFG_47_32, (mac_addr >> 32) & 0xFFFF);
+	NIC_WREG32(NIC0_TXE0_PORT1_MAC_CFG_31_0, mac_addr & 0xFFFFFFFF);
+
+	/* set MMU bypass for kernel WQ */
+	NIC_WREG32(NIC0_TXE0_WQE_USER_CFG, 0x1);
+
+	NIC_WREG32(NIC0_TXE0_WQE_PREFETCH_CFG, 0x3);
+
+	NIC_WREG32(NIC0_TXE0_BTH_MKEY, 0xffff);
+
+	/* 100ms BW window size */
+	NIC_WREG32(NIC0_TXE0_STATS_CFG0, cn_prop->clk * PERF_BW_WINDOW_USEC);
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG1, 1, NIC0_TXE0_STATS_CFG1_LATENCY_ENABLE_MASK);
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG1, 0, NIC0_TXE0_STATS_CFG1_WIN_TYPE_MASK);
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG1, 0, NIC0_TXE0_STATS_CFG1_WIN_SAMP_LATENCY_MASK);
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG1, 3, NIC0_TXE0_STATS_CFG1_TOT_TYPE_MASK);
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG1, 1, NIC0_TXE0_STATS_CFG1_ENABLE_MASK);
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG2, 0, NIC0_TXE0_STATS_CFG2_LATENCY_WRAP_EN_MASK);
+	/* 2us latency window size */
+	NIC_RMWREG32(NIC0_TXE0_STATS_CFG2, 2 * cn_prop->clk,
+		     NIC0_TXE0_STATS_CFG2_LATENCY_MAX_VAL_MASK);
+}
+
+static void gaudi2_cn_config_port_hw_qpc(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	u64 req_qpc_base_addr, res_qpc_base_addr;
+	struct hbl_cn_properties *cn_prop;
+	struct hbl_cn_device *hdev;
+	u32 port = cn_port->port;
+
+	hdev = gaudi2_port->hdev;
+	cn_prop = &hdev->cn_props;
+
+	req_qpc_base_addr = cn_prop->req_qpc_base_addr + port * cn_prop->req_qpc_base_size;
+	res_qpc_base_addr = cn_prop->res_qpc_base_addr + port * cn_prop->res_qpc_base_size;
+
+	WARN_ON_CACHE_UNALIGNED(req_qpc_base_addr);
+	WARN_ON_CACHE_UNALIGNED(res_qpc_base_addr);
+
+	NIC_WREG32(NIC0_QPC0_REQ_BASE_ADDRESS_63_32, upper_32_bits(req_qpc_base_addr));
+	NIC_WREG32(NIC0_QPC0_REQ_BASE_ADDRESS_31_7, lower_32_bits(req_qpc_base_addr) >> 7);
+
+	NIC_WREG32(NIC0_QPC0_RES_BASE_ADDRESS_63_32, upper_32_bits(res_qpc_base_addr));
+	NIC_WREG32(NIC0_QPC0_RES_BASE_ADDRESS_31_7, lower_32_bits(res_qpc_base_addr) >> 7);
+
+	NIC_WREG32(NIC0_QPC0_RES_QPC_CACHE_INVALIDATE, 1);
+	NIC_WREG32(NIC0_QPC0_REQ_QPC_CACHE_INVALIDATE, 1);
+	NIC_WREG32(NIC0_QPC0_RES_QPC_CACHE_INVALIDATE, 0);
+	NIC_WREG32(NIC0_QPC0_REQ_QPC_CACHE_INVALIDATE, 0);
+
+	NIC_WREG32(NIC0_QPC0_INTERRUPT_CAUSE, 0);
+
+	/* Configure MMU-BP override for DB-FIFOs */
+	NIC_WREG32(NIC0_QPC0_AXUSER_DB_FIFO_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_DB_FIFO_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	WARN_ON_CACHE_UNALIGNED(RING_BUF_DMA_ADDRESS(&gaudi2_port->fifo_ring));
+
+	/* Configure doorbell */
+	NIC_WREG32(NIC0_QPC0_DBFIFOSECUR_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_63_32,
+		   upper_32_bits(RING_BUF_DMA_ADDRESS(&gaudi2_port->fifo_ring)));
+	NIC_WREG32(NIC0_QPC0_DBFIFOSECUR_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_31_7,
+		   lower_32_bits(RING_BUF_DMA_ADDRESS(&gaudi2_port->fifo_ring)) >> 7);
+
+	gaudi2_cn_eq_dispatcher_register_db(gaudi2_port, hdev->kernel_asid,
+					    GAUDI2_DB_FIFO_SECURE_HW_ID);
+
+	/* Configure MMU-BP override for error-FIFO */
+	NIC_WREG32(NIC0_QPC0_AXUSER_ERR_FIFO_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_ERR_FIFO_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	NIC_WREG32(NIC0_QPC0_RETRY_COUNT_MAX,
+		   (GAUDI2_NIC_MAX_TIMEOUT_RETRIES << NIC0_QPC0_RETRY_COUNT_MAX_TIMEOUT_SHIFT) |
+		   (GAUDI2_NIC_MAX_SEQ_ERR_RETRIES <<
+			NIC0_QPC0_RETRY_COUNT_MAX_SEQUENCE_ERROR_SHIFT));
+
+	/* Configure MMU-BP override for QPCs */
+	NIC_WREG32(NIC0_QPC0_AXUSER_QPC_REQ_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_QPC_REQ_HB_RD_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_QPC_RESP_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_QPC_RESP_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	/* Configure MMU-BP override for Congestion-Queue */
+	NIC_WREG32(NIC0_QPC0_AXUSER_CONG_QUE_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_CONG_QUE_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	NIC_RMWREG32(NIC0_QPC0_REQ_STATIC_CONFIG, 1,
+		     NIC0_QPC0_REQ_STATIC_CONFIG_QM_MOVEQP2ERR_SECUR_ERR_MASK);
+	NIC_RMWREG32(NIC0_QPC0_REQ_STATIC_CONFIG, 0,
+		     NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERROR_ASID_MASK);
+	NIC_RMWREG32(NIC0_QPC0_REQ_STATIC_CONFIG, 1,
+		     NIC0_QPC0_REQ_STATIC_CONFIG_QM_UPD_IGNORE_ASID_ERR_MASK);
+	NIC_RMWREG32(NIC0_QPC0_REQ_STATIC_CONFIG, 0,
+		     NIC0_QPC0_REQ_STATIC_CONFIG_QM_MOVEQP2ERR_ASID_ERR_MASK);
+	NIC_RMWREG32(NIC0_QPC0_REQ_STATIC_CONFIG, 1,
+		     NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERROR_SECURITY_MASK);
+
+	/* Disable the WTD back-pressure mechanism to ARC and QMAN - it will be
+	 * enabled later on by the user.
+	 */
+	NIC_RMWREG32_SHIFTED(NIC0_QPC0_WTD_CONFIG, 0, NIC0_QPC0_WTD_CONFIG_WQ_BP_2ARC_EN_MASK |
+			     NIC0_QPC0_WTD_CONFIG_WQ_BP_2QMAN_EN_MASK);
+}
+
+static void gaudi2_cn_config_port_hw_rxe(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_ring *cq_ring = &gaudi2_port->cq_rings[NIC_CQ_RAW_IDX];
+	struct hbl_cn_properties *cn_prop = &gaudi2_port->hdev->cn_props;
+	struct hbl_cn_ring *rx_ring = &gaudi2_port->rx_ring;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = gaudi2_port->cn_port->port;
+	u32 rx_mem_addr_lo, rx_mem_addr_hi;
+	int i;
+
+	rx_mem_addr_lo = lower_32_bits(RING_BUF_DMA_ADDRESS(rx_ring));
+	rx_mem_addr_hi = upper_32_bits(RING_BUF_DMA_ADDRESS(rx_ring));
+
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P0_0, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P0_1, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P1_0, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P1_1, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P2_0, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P2_1, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P3_0, RAW_QPN);
+	NIC_WREG32(NIC0_RXE0_RAW_QPN_P3_1, RAW_QPN);
+
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P0_0, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P0_1, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P0_0, rx_mem_addr_hi);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P0_1, rx_mem_addr_hi);
+
+	/* #define NIC5_RXE1_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_SHIFT 0   */
+	/* #define NIC5_RXE1_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK  0xF */
+
+	/* #define NIC5_RXE1_RAW_MISC_P2_LOG_BUFFER_SIZE_MASK_P2_SHIFT 15 */
+	/* #define NIC5_RXE1_RAW_MISC_P2_LOG_BUFFER_SIZE_MASK_P2_MASK     */
+	/* 0xF8000                                                        */
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P0_0,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P0_1,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P1_0, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P1_1, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P1_0, rx_mem_addr_hi);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P1_1, rx_mem_addr_hi);
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P1_0,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P1_1,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P2_0, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P2_1, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P2_0, rx_mem_addr_hi);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P2_1, rx_mem_addr_hi);
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P2_0,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P2_1,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P3_0, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_LO_P3_1, rx_mem_addr_lo);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P3_0, rx_mem_addr_hi);
+	NIC_WREG32(NIC0_RXE0_RAW_BASE_HI_P3_1, rx_mem_addr_hi);
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P3_0,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_RAW_MISC_P3_1,
+		   (ilog2(rx_ring->elem_size) & NIC0_RXE0_RAW_MISC_P2_LOG_RAW_ENTRY_SIZE_P2_MASK) |
+		   ((ilog2(rx_ring->count) & 0x1F) << 15));
+
+	NIC_WREG32(NIC0_RXE0_CQ_BASE_ADDR_63_32, upper_32_bits(RING_BUF_DMA_ADDRESS(cq_ring)));
+	NIC_WREG32(NIC0_RXE0_CQ_BASE_ADDR_31_7,
+		   lower_32_bits(RING_BUF_DMA_ADDRESS(cq_ring)) & 0xFFFFFF80);
+
+	NIC_WREG32(NIC0_RXE0_CQ_PI_ADDR_HI_0,
+		   upper_32_bits(RING_PI_DMA_ADDRESS(cq_ring)));
+	NIC_WREG32(NIC0_RXE0_CQ_PI_ADDR_LO_0,
+		   lower_32_bits(RING_PI_DMA_ADDRESS(cq_ring)) & 0xFFFFFF80);
+
+	/* Set the max CQ size */
+	NIC_WREG32(NIC0_RXE0_CQ_LOG_MAX_SIZE, ilog2(NIC_CQ_MAX_ENTRIES));
+
+	/* Set the actual single CQ size log2(number of entries in cq)*/
+	NIC_WREG32(NIC0_RXE0_CQ_LOG_SIZE_0, ilog2(cq_ring->count));
+
+	/* Initialize MMU-BP for all CQs */
+	for (i = 0; i < cn_prop->max_cqs; i++)
+		NIC_WREG32(NIC0_RXE0_AXUSER_AXUSER_CQ0_HB_WR_OVRD_LO +
+			   (i * NIC_RXE_AXUSER_AXUSER_CQ_OFFSET), 0xFFFFFBFF);
+
+	NIC_WREG32(NIC0_RXE0_CQ_WRITE_INDEX_0, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_PRODUCER_INDEX_0, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_CONSUMER_INDEX_0, 0);
+
+	/* enable, pi-update and completion-events */
+	NIC_WREG32(NIC0_RXE0_CQ_CFG_0, 1 << NIC0_RXE0_CQ_CFG_WRITE_PI_EN_SHIFT |
+		   1 << NIC0_RXE0_CQ_CFG_ENABLE_SHIFT);
+
+	/* disable all RDMA CQs */
+	for (i = 1; i < cn_prop->max_cqs; i++)
+		NIC_WREG32(NIC0_RXE0_CQ_CFG_0 + i * 4, 0);
+
+	/* set MMU bypass for kernel WQ */
+	NIC_WREG32(NIC0_RXE0_ARUSER_MMU_BP, 0x1);
+
+	/* set SPMU RXE counters of Group 1 */
+	NIC_WREG32(NIC0_RXE0_DBG_SPMU_SELECT, 0x1);
+}
+
+static void gaudi2_cn_config_hw_mac_filter(struct gaudi2_cn_port *gaudi2_port, u64 mac_addr)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+
+	if (cn_port->eth_enable) {
+		if (port & 1) {
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_31_0_2,
+					 mac_addr & 0xFFFFFFFF);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_47_32_2,
+					 (mac_addr >> 32) & 0xFFFF);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_31_0_MASK_2, 0);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_47_32_MASK_2, 0);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_31_0_2,
+					 mac_addr & 0xFFFFFFFF);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_47_32_2,
+					 (mac_addr >> 32) & 0xFFFF);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_31_0_MASK_2, 0);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_47_32_MASK_2, 0);
+		} else {
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_31_0_0,
+					 mac_addr & 0xFFFFFFFF);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_47_32_0,
+					 (mac_addr >> 32) & 0xFFFF);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_31_0_MASK_0, 0);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_47_32_MASK_0, 0);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_31_0_0,
+					 mac_addr & 0xFFFFFFFF);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_47_32_0,
+					 (mac_addr >> 32) & 0xFFFF);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_31_0_MASK_0, 0);
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RAW0_MAC_47_32_MASK_0, 0);
+		}
+	} else {
+		if (port & 1) {
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_31_0_MASK_2, 0xFFFFFFFF);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_47_32_MASK_2, 0xFFFF);
+		} else {
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_31_0_MASK_0, 0xFFFFFFFF);
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TS_RC_MAC_47_32_MASK_0, 0xFFFF);
+		}
+	}
+}
+
+static int gaudi2_cn_hw_mac_ch_reset(struct gaudi2_cn_port *gaudi2_port, int lane)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = gaudi2_port->cn_port->port;
+	ktime_t timeout;
+	u32 read_reg;
+
+	if (hdev->skip_mac_reset)
+		return 0;
+
+	timeout = ktime_add_ms(ktime_get(), hdev->pending_reset_long_timeout * 1000ull);
+
+	do {
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_CONTROL1 + MAC_CH_OFFSET(lane),
+				 BIT(NIC0_MAC_CH0_MAC_PCS_CONTROL1_FLD_RESET_SHIFT));
+		usleep_range(50, 200);
+
+		read_reg = NIC_MACRO_RREG32(NIC0_MAC_CH0_MAC_PCS_CONTROL1 + MAC_CH_OFFSET(lane));
+	} while ((read_reg & NIC0_MAC_CH0_MAC_PCS_CONTROL1_FLD_RESET_MASK) &&
+		ktime_compare(ktime_get(), timeout) < 0);
+
+	if (read_reg & NIC0_MAC_CH0_MAC_PCS_CONTROL1_FLD_RESET_MASK) {
+		dev_err(hdev->dev, "Timeout while MAC channel %d reset\n", lane);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void gaudi2_cn_hw_mac_port_config_lane_speed(struct gaudi2_cn_port *gaudi2_port, int i)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+
+	switch (cn_port->speed) {
+	case SPEED_25000:
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL_INTVL + MAC_CH_OFFSET(i),
+				 REGMASK(0x4FFF,
+					 NIC0_MAC_CH0_MAC_PCS_VENDOR_VL_INTVL_MARKER_COUNTER));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_PCS_MODE + MAC_CH_OFFSET(i),
+				 REGMASK(1, NIC0_MAC_CH0_MAC_PCS_VENDOR_PCS_MODE_ENA_CLAUSE49) |
+				 REGMASK(1, NIC0_MAC_CH0_MAC_PCS_VENDOR_PCS_MODE_HI_BER25));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC1, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0_M0) |
+				 REGMASK(0x68, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x21, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xF0, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0_M0) |
+				 REGMASK(0xC4, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xE6, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC5, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0_M0) |
+				 REGMASK(0x65, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x9B, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xA2, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0_M0) |
+				 REGMASK(0x79, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x3D,  NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_1_M2));
+		break;
+	case SPEED_50000:
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL_INTVL + MAC_CH_OFFSET(i),
+				 REGMASK(0x4FFF,
+					 NIC0_MAC_CH0_MAC_PCS_VENDOR_VL_INTVL_MARKER_COUNTER));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_PCS_MODE + MAC_CH_OFFSET(i), 0x0);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x90, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0_M0) |
+				 REGMASK(0x76, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x47, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xF0, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0_M0) |
+				 REGMASK(0xC4, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xE6, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC5, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0_M0) |
+				 REGMASK(0x65, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x9B, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xA2, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0_M0) |
+				 REGMASK(0x79, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x3D, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_1_M2));
+		break;
+	case SPEED_100000:
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL_INTVL + MAC_CH_OFFSET(i),
+				 REGMASK(0x3FFF,
+					 NIC0_MAC_CH0_MAC_PCS_VENDOR_VL_INTVL_MARKER_COUNTER));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_PCS_MODE + MAC_CH_OFFSET(i), 0x0);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC1, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0_M0) |
+				 REGMASK(0x68, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x21, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL0_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x9D, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0_M0) |
+				 REGMASK(0x71, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x8E, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL1_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x59, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0_M0) |
+				 REGMASK(0x4B, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xE8, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL2_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x4D, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0_M0) |
+				 REGMASK(0x95, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_0_M1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x7B, NIC0_MAC_CH0_MAC_PCS_VENDOR_VL3_1_M2));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL4_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x7F5, NIC0_MAC_CH0_MAC_PCS_VL4_0_VL4_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL4_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x9, NIC0_MAC_CH0_MAC_PCS_VL4_1_VL4_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL5_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x14DD, NIC0_MAC_CH0_MAC_PCS_VL5_0_VL5_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL5_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC2, NIC0_MAC_CH0_MAC_PCS_VL5_1_VL5_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL6_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x4A9A, NIC0_MAC_CH0_MAC_PCS_VL6_0_VL6_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL6_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x26, NIC0_MAC_CH0_MAC_PCS_VL6_1_VL6_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL7_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x457B, NIC0_MAC_CH0_MAC_PCS_VL7_0_VL7_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL7_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x66, NIC0_MAC_CH0_MAC_PCS_VL7_1_VL7_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL8_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x24A0, NIC0_MAC_CH0_MAC_PCS_VL8_0_VL8_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL8_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x76, NIC0_MAC_CH0_MAC_PCS_VL8_1_VL8_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL9_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC968, NIC0_MAC_CH0_MAC_PCS_VL9_0_VL9_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL9_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xFB, NIC0_MAC_CH0_MAC_PCS_VL9_1_VL9_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL10_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x6CFD, NIC0_MAC_CH0_MAC_PCS_VL10_0_VL10_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL10_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x99, NIC0_MAC_CH0_MAC_PCS_VL10_1_VL10_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL11_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x91B9, NIC0_MAC_CH0_MAC_PCS_VL11_0_VL11_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL11_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x55, NIC0_MAC_CH0_MAC_PCS_VL11_1_VL11_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL12_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xB95C, NIC0_MAC_CH0_MAC_PCS_VL12_0_VL12_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL12_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xB2, NIC0_MAC_CH0_MAC_PCS_VL12_1_VL12_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL13_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xF81A, NIC0_MAC_CH0_MAC_PCS_VL13_0_VL13_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL13_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xBD, NIC0_MAC_CH0_MAC_PCS_VL13_1_VL13_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL14_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xC783, NIC0_MAC_CH0_MAC_PCS_VL14_0_VL14_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL14_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xCA, NIC0_MAC_CH0_MAC_PCS_VL14_1_VL14_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL15_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x3635, NIC0_MAC_CH0_MAC_PCS_VL15_0_VL15_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL15_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xCD, NIC0_MAC_CH0_MAC_PCS_VL15_1_VL15_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL16_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x31C4, NIC0_MAC_CH0_MAC_PCS_VL16_0_VL16_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL16_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x4C, NIC0_MAC_CH0_MAC_PCS_VL16_1_VL16_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL17_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xD6AD, NIC0_MAC_CH0_MAC_PCS_VL17_0_VL17_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL17_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xB7, NIC0_MAC_CH0_MAC_PCS_VL17_1_VL17_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL18_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0x665F, NIC0_MAC_CH0_MAC_PCS_VL18_0_VL18_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL18_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0x2A, NIC0_MAC_CH0_MAC_PCS_VL18_1_VL18_1));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL19_0 + MAC_CH_OFFSET(i),
+				 REGMASK(0xF0C0, NIC0_MAC_CH0_MAC_PCS_VL19_0_VL19_0));
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_PCS_VL19_1 + MAC_CH_OFFSET(i),
+				 REGMASK(0xE5, NIC0_MAC_CH0_MAC_PCS_VL19_1_VL19_1));
+		break;
+	default:
+		dev_err(hdev->dev, "unknown port %d speed %dMb/s, cannot set MAC XPCS\n", port,
+			cn_port->speed);
+		return;
+	}
+}
+
+static void gaudi2_cn_hw_mac_port_config(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+	int i, start_lane;
+
+	start_lane = (port & 1) ? (NIC_MAC_NUM_OF_LANES / 2) : NIC_MAC_LANES_START;
+
+	for (i = start_lane; i < start_lane + (NIC_MAC_NUM_OF_LANES / 2); i++) {
+		gaudi2_cn_hw_mac_ch_reset(gaudi2_port, i);
+
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_FRM_LENGTH + MAC_CH_OFFSET(i),
+				 NIC_MAC_MAX_FRM_LEN);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_COMMAND_CONFIG + MAC_CH_OFFSET(i), 0x2913);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_TX_FIFO_SECTIONS + MAC_CH_OFFSET(i), 0x4);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_RX_FIFO_SECTIONS + MAC_CH_OFFSET(i), 0x4);
+
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL01_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL01_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL23_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL23_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL45_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL45_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL67_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL67_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL89_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL89_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL1011_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL1011_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL1213_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL1213_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL1415_PAUSE_QUANTA + MAC_CH_OFFSET(i),
+				 0xFFFFFFFF);
+		NIC_MACRO_WREG32(NIC0_MAC_CH0_MAC_128_CL1415_QUANTA_THRESH + MAC_CH_OFFSET(i),
+				 0x7FFF7FFF);
+
+		gaudi2_cn_hw_mac_port_config_lane_speed(gaudi2_port, i);
+	}
+}
+
+static void gaudi2_cn_enable_port_interrupts(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	/* enable RXE block interrupts. RXE SPI interrupts should stay masked out,
+	 * they generate a lot of events which are not fatal errors
+	 */
+	NIC_WREG32(NIC0_RXE0_SEI_INTR_MASK, 0x0);
+
+	/* enable TXS block interrupts */
+	NIC_WREG32(NIC0_TXS0_INTERRUPT_MASK, 0x0);
+
+	/* enable TXE block interrupts */
+	NIC_WREG32(NIC0_TXE0_INTERRUPT_MASK, 0x0);
+
+	/* enable QPC response error interrupts */
+	NIC_WREG32(NIC0_QPC0_INTERRUPT_RESP_ERR_MASK, 0x0);
+}
+
+static void gaudi2_cn_disable_port_interrupts(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	/* disable RXE block interrupts */
+	NIC_WREG32(NIC0_RXE0_SEI_INTR_MASK, 0xF);
+
+	/* disable TXS block interrupts */
+	NIC_WREG32(NIC0_TXS0_INTERRUPT_MASK, 0xF);
+
+	/* disable TXE block interrupts */
+	NIC_WREG32(NIC0_TXE0_INTERRUPT_MASK, 0x7F);
+
+	/* disable QPC response error interrupts */
+	NIC_WREG32(NIC0_QPC0_INTERRUPT_RESP_ERR_MASK, 0x7F);
+}
+
+static int gaudi2_cn_hw_port_config(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+	u64 mac_addr = 0;
+	int i, rc = 0;
+
+	for (i = 0; i < ETH_ALEN; i++) {
+		mac_addr <<= 8;
+		mac_addr |= hdev->cpucp_info->mac_addrs[port].mac_addr[i];
+	}
+
+	/* TXS Configuration */
+	rc = gaudi2_cn_config_port_hw_txs(gaudi2_port);
+	if (rc)
+		return rc;
+
+	/* TXE Configuration */
+	gaudi2_cn_config_port_hw_txe(gaudi2_port, mac_addr);
+
+	/* QPC Configuration */
+	gaudi2_cn_config_port_hw_qpc(gaudi2_port);
+
+	/* RXE Configuration */
+	gaudi2_cn_config_port_hw_rxe(gaudi2_port);
+
+	/* MAC filtering */
+	gaudi2_cn_config_hw_mac_filter(gaudi2_port, mac_addr);
+
+	/* Lanes Configuration */
+	gaudi2_cn_hw_mac_port_config(gaudi2_port);
+
+	/* PFC Configuration */
+	gaudi2_cn_set_pfc(cn_port);
+
+	/* Enable port GIC interrupts - required only if running on PLDM */
+	if (hdev->pldm)
+		gaudi2_cn_enable_port_interrupts(cn_port);
+
+	return rc;
+}
+
+void gaudi2_cn_hw_mac_loopback_cfg(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port;
+	struct hbl_cn_device *hdev;
+	u32 port, val;
+
+	cn_port = gaudi2_port->cn_port;
+	hdev = cn_port->hdev;
+	port = cn_port->port;
+	val = !!cn_port->mac_loopback;
+
+	if (port & 1) {
+		/* odd ports use lanes 2,3 */
+		NIC_MACRO_RMWREG32(NIC0_MAC_CH2_MAC_PCS_CONTROL1, val,
+				   NIC0_MAC_CH0_MAC_PCS_CONTROL1_LOOPBACK_MASK);
+		NIC_MACRO_RMWREG32(NIC0_MAC_CH3_MAC_PCS_CONTROL1, val,
+				   NIC0_MAC_CH0_MAC_PCS_CONTROL1_LOOPBACK_MASK);
+	} else {
+		/* even ports use lanes 0,1 */
+		NIC_MACRO_RMWREG32(NIC0_MAC_CH0_MAC_PCS_CONTROL1, val,
+				   NIC0_MAC_CH0_MAC_PCS_CONTROL1_LOOPBACK_MASK);
+		NIC_MACRO_RMWREG32(NIC0_MAC_CH1_MAC_PCS_CONTROL1, val,
+				   NIC0_MAC_CH0_MAC_PCS_CONTROL1_LOOPBACK_MASK);
+	}
+
+	/* flush cfg */
+	NIC_MACRO_RREG32(NIC0_MAC_CH0_MAC_PCS_CONTROL1);
+}
+
+bool gaudi2_cn_is_cq_in_overrun(struct hbl_cn_port *cn_port, u8 cq_id)
+{
+	struct hbl_cn_user_cq *user_cq;
+	bool is_cq_in_overrun = false;
+
+	user_cq = hbl_cn_user_cq_get(cn_port, cq_id);
+	if (user_cq) {
+		is_cq_in_overrun = user_cq->qp_set_overrun_cnt > 0;
+		hbl_cn_user_cq_put(user_cq);
+	}
+
+	return is_cq_in_overrun;
+}
+
+static void gaudi2_cn_qp_pre_destroy(struct hbl_cn_qp *qp)
+{
+	struct hbl_cn_port *cn_port = qp->cn_port;
+	struct gaudi2_cn_port *gaudi2_port;
+
+	gaudi2_port = cn_port->cn_specific;
+
+	mutex_lock(&gaudi2_port->qp_destroy_lock);
+
+	/* only the first QP should enable MAC loopback */
+	if (++gaudi2_port->qp_destroy_cnt == 1 && !cn_port->mac_loopback && !cn_port->pcs_link) {
+		cn_port->mac_loopback = true;
+		gaudi2_cn_hw_mac_loopback_cfg(gaudi2_port);
+		gaudi2_port->qp_destroy_mac_lpbk = true;
+	}
+
+	mutex_unlock(&gaudi2_port->qp_destroy_lock);
+}
+
+static void gaudi2_cn_qp_post_destroy(struct hbl_cn_qp *qp)
+{
+	struct hbl_cn_port *cn_port = qp->cn_port;
+	struct gaudi2_cn_port *gaudi2_port;
+
+	gaudi2_port = cn_port->cn_specific;
+
+	mutex_lock(&gaudi2_port->qp_destroy_lock);
+
+	/* only the last QP should disable MAC loopback */
+	if (!--gaudi2_port->qp_destroy_cnt && gaudi2_port->qp_destroy_mac_lpbk) {
+		cn_port->mac_loopback = false;
+		gaudi2_cn_hw_mac_loopback_cfg(gaudi2_port);
+		gaudi2_port->qp_destroy_mac_lpbk = false;
+	}
+
+	mutex_unlock(&gaudi2_port->qp_destroy_lock);
+}
+
+static int gaudi2_cn_hw_config(struct gaudi2_cn_port *gaudi2_port)
+{
+	int rc = 0;
+
+	rc = gaudi2_cn_hw_port_config(gaudi2_port);
+	if (rc)
+		return rc;
+
+	gaudi2_cn_hw_mac_loopback_cfg(gaudi2_port);
+
+	return rc;
+}
+
+static int gaudi2_cn_port_hw_init(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+	int rc;
+
+	gaudi2_cn_reset_rings(gaudi2_port);
+
+	/* register the Eth CQ with the event dispatcher */
+	rc = hbl_cn_eq_dispatcher_register_cq(cn_port, gaudi2_port->cq_rings[NIC_CQ_RAW_IDX].asid,
+					      NIC_CQ_RAW_IDX);
+	if (rc) {
+		dev_err(hdev->dev, "failed to register port %d CQ %d with cn_eq_sw\n", port,
+			NIC_CQ_RAW_IDX);
+		goto cq_register_fail;
+	}
+
+	rc = gaudi2_cn_hw_config(gaudi2_port);
+	if (rc)
+		goto cq_init_fail;
+
+	cn_port->eq_handler_enable = true;
+
+	rc = gaudi2_qp_sanity_init(gaudi2_port);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to init QP sanity, port: %d, %d\n", port, rc);
+		goto cq_init_fail;
+	}
+
+	return 0;
+
+cq_init_fail:
+	cn_port->eq_handler_enable = false;
+	hbl_cn_eq_dispatcher_unregister_cq(cn_port, NIC_CQ_RAW_IDX);
+cq_register_fail:
+
+	return rc;
+}
+
+static void gaudi2_cn_port_hw_fini(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+
+	/* Disable port GIC interrupts - required only if running on PLDM */
+	if (hdev->pldm)
+		gaudi2_cn_disable_port_interrupts(cn_port);
+
+	gaudi2_qp_sanity_fini(gaudi2_port);
+
+	cn_port->eq_handler_enable = false;
+
+	hbl_cn_eq_dispatcher_unregister_cq(cn_port, NIC_CQ_RAW_IDX);
+	hbl_cn_eq_dispatcher_unregister_db(cn_port, GAUDI2_DB_FIFO_SECURE_HW_ID);
+
+	hbl_cn_eq_dispatcher_reset(cn_port);
+}
+
+static bool qpc_op_cond_func(u32 val, void *arg)
+{
+	return !val;
+}
+
+/* must be called under mutex_lock(&cn_port->qpc_lock) */
+static int gaudi2_cn_qpc_op(struct hbl_cn_port *cn_port, u64 ctrl, bool wait_for_completion)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	int rc = 0;
+
+	NIC_WREG32(NIC0_QPC0_GW_CTRL, ctrl);
+
+	NIC_WREG32(NIC0_QPC0_GW_BUSY, 1);
+
+	/* do not poll on registers when reset was initiated by FW */
+	if (wait_for_completion && !hdev->fw_reset) {
+		u32 addr = NIC0_QPC0_GW_BUSY + NIC_CFG_BASE(port, NIC0_QPC0_GW_BUSY);
+
+		rc = gaudi2_cn_poll_reg(hdev, addr, hdev->qpc_cache_inv_timeout, qpc_op_cond_func,
+					NULL);
+	}
+
+	return rc;
+}
+
+static int gaudi2_cn_qpc_write_masked(struct hbl_cn_port *cn_port, const void *qpc_data,
+				      const struct qpc_mask *qpc_mask, u32 qpn, bool is_req,
+				      bool force_doorbell)
+{
+	struct hbl_cn_device *hdev;
+	u32 port, data_size, ctrl;
+	const u32 *mask, *data;
+	int i, rc;
+
+	hdev = cn_port->hdev;
+	port = cn_port->port;
+	data_size = is_req ? sizeof(struct gaudi2_qpc_requester) :
+		    sizeof(struct gaudi2_qpc_responder);
+	mask = (const u32 *)qpc_mask;
+	data = qpc_data;
+
+	/* Don't write to the Gw if its busy with prev operation */
+	if (NIC_RREG32(NIC0_QPC0_GW_BUSY)) {
+		if (hbl_cn_comp_device_operational(hdev))
+			dev_err(hdev->dev, "Cannot write to port %d QP %d %s QPC, GW is busy\n",
+				port, qpn, is_req ? "requester" : "responder");
+
+		return (hdev->in_teardown && hdev->hw_invalid_while_teardown) ? 0 : -EBUSY;
+	}
+
+	/* Copy the mask and data to the gateway regs.
+	 * Only the data bits with their corresponding mask-bits set will be written
+	 * to the HW.
+	 */
+	for (i = 0; i < (sizeof(struct qpc_mask) / sizeof(u32)); i++)
+		NIC_WREG32(NIC0_QPC0_GW_MASK_0 + i * sizeof(u32), mask[i]);
+
+	for (i = 0; i < (data_size / sizeof(u32)); i++)
+		NIC_WREG32(NIC0_QPC0_GW_DATA_0 + i * sizeof(u32), data[i]);
+
+	ctrl = (is_req << NIC0_QPC0_GW_CTRL_REQUESTER_SHIFT) | qpn |
+	       (!!force_doorbell << NIC0_QPC0_GW_CTRL_DOORBELL_FORCE_SHIFT);
+
+	rc = gaudi2_cn_qpc_op(cn_port, ctrl, true);
+	if (rc && hbl_cn_comp_device_operational(hdev))
+		/* Device might not respond during reset if the reset was due to error */
+		dev_err(hdev->dev, "%s QPC GW write timeout, port: %d, qpn: %u\n",
+			is_req ? "requester" : "responder", port, qpn);
+
+	return rc;
+}
+
+bool gaudi2_handle_qp_error_retry(struct hbl_cn_port *cn_port, u32 qpn)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct hbl_cn_asic_port_funcs *port_funcs;
+	struct gaudi2_qpc_requester req_qpc = {};
+	struct qpc_mask mask = {};
+	int port = cn_port->port;
+	u8 max_retry_timeout;
+	struct hbl_cn_qp *qp;
+	int rc, retry = 5;
+	u8 timeout_max;
+	u64 wq_delay;
+
+	port_funcs = hdev->asic_funcs->port_funcs;
+	port_funcs->cfg_lock(cn_port);
+	qp = xa_load(&cn_port->qp_ids, qpn);
+
+	if (!qp) {
+		port_funcs->cfg_unlock(cn_port);
+		dev_err(hdev->dev, "adaptive retry, port %d, QP: %d is null\n",
+			port, qpn);
+
+		return false;
+	}
+
+	cancel_delayed_work(&qp->adaptive_tmr_reset);
+
+	timeout_max = qp->timeout_granularity + NIC_ADAPTIVE_TIMEOUT_RANGE / 2;
+	if (qp->timeout_curr < timeout_max) {
+		qp->timeout_curr++;
+		/* clear QP error */
+		REQ_QPC_SET_ERR(mask, 1);
+		REQ_QPC_SET_ERR(req_qpc, 0);
+		REQ_QPC_SET_TIMEOUT_RETRY_COUNT(mask, 0xff);
+		REQ_QPC_SET_TIMEOUT_RETRY_COUNT(req_qpc, 0);
+		REQ_QPC_SET_TM_GRANULARITY(mask, 0x7f);
+		REQ_QPC_SET_TM_GRANULARITY(req_qpc, qp->timeout_curr);
+
+		do {
+			rc = gaudi2_cn_qpc_write_masked(cn_port, &req_qpc, &mask, qp->qp_id,
+							true, true);
+			if (rc)
+				dev_err(hdev->dev, "failed to write QPC port %d, %d, err %d\n",
+					port, qpn, rc);
+
+			rc = gaudi2_cn_qpc_read(cn_port, &req_qpc, qp->qp_id, true);
+			if (rc)
+				dev_err(hdev->dev, "failed to read QPC port %d, %d, err %d\n",
+					port, qpn, rc);
+			if (!REQ_QPC_GET_ERROR(req_qpc))
+				break;
+			retry--;
+		} while (retry);
+
+		if (!retry) {
+			port_funcs->cfg_unlock(cn_port);
+			dev_err(hdev->dev, "failed to clear QPC error port %d, %d\n", port, qpn);
+
+			return false;
+		}
+
+		dev_dbg_ratelimited(hdev->dev, "dropping Port-%d QP error on qp %d\n",
+				    port, qp->qp_id);
+
+		max_retry_timeout = GAUDI2_NIC_MAX_TIMEOUT_RETRIES / NIC_ADAPTIVE_TIMEOUT_RANGE;
+		wq_delay = NIC_GRAN_TO_USEC(qp->timeout_curr) * max_retry_timeout *
+			   NIC_TMR_RESET_FACTOR;
+		queue_delayed_work(cn_port->qp_wq, &qp->adaptive_tmr_reset,
+				   msecs_to_jiffies(wq_delay / 1000));
+
+		port_funcs->cfg_unlock(cn_port);
+
+		return true;
+	}
+
+	qp->timeout_curr = qp->timeout_granularity - (NIC_ADAPTIVE_TIMEOUT_RANGE >> 1);
+
+	port_funcs->cfg_unlock(cn_port);
+
+	return false;
+}
+
+static int gaudi2_cn_qpc_write(struct hbl_cn_port *cn_port, void *qpc, struct qpc_mask *qpc_mask,
+			       u32 qpn, bool is_req)
+{
+	u32 data_size = is_req ? sizeof(struct gaudi2_qpc_requester) :
+			sizeof(struct gaudi2_qpc_responder);
+	struct qpc_mask mask = {};
+
+	if (!qpc_mask) {
+		/* NULL mask flags full QPC write */
+		memset(&mask, 0xFF, data_size);
+		qpc_mask = &mask;
+	}
+
+	return gaudi2_cn_qpc_write_masked(cn_port, qpc, qpc_mask, qpn, is_req, false);
+}
+
+static int gaudi2_cn_qpc_invalidate(struct hbl_cn_port *cn_port, struct hbl_cn_qp *qp, bool is_req)
+{
+	struct gaudi2_qpc_requester req_qpc = {};
+	struct gaudi2_qpc_responder res_qpc = {};
+	struct qpc_mask mask = {};
+	void *qpc;
+	int rc;
+
+	if (is_req) {
+		/* use Congestion window mode with RTT state disabled &
+		 * window size 0 to force REQ Tx stop, while Rx remains
+		 * active.
+		 */
+		REQ_QPC_SET_CONGESTION_MODE(mask, 3);
+		REQ_QPC_SET_RTT_STATE(mask, 3);
+		REQ_QPC_SET_CONGESTION_WIN(mask, GENMASK(23, 0));
+
+		REQ_QPC_SET_CONGESTION_MODE(req_qpc, 2);
+		REQ_QPC_SET_RTT_STATE(req_qpc, 0);
+		REQ_QPC_SET_CONGESTION_WIN(req_qpc, 0);
+		qpc = &req_qpc;
+	} else {
+		RES_QPC_SET_VALID(mask, 1);
+		RES_QPC_SET_VALID(res_qpc, 0);
+		qpc = &res_qpc;
+	}
+
+	rc = gaudi2_cn_qpc_write_masked(cn_port, qpc, &mask, qp->qp_id, is_req, false);
+
+	if (is_req) {
+		/* Allow CQ overrun to make sure QP drain is successful. In case PFC is sent due to
+		 * CQ overflow, no Tx can be sent until CQ releases the back-pressure. If in the
+		 * meanwhile a QP needs to be invalidated, no tx will be sent in the QP drain stage.
+		 * This will cause Tx slices to be stuck after the QP drain stage has finished.
+		 * Next when the CQ will be destroyed, it will release the back-pressure, causing
+		 * the stuck Tx slices to be sent (as there's no more back-pressure). Since no QP
+		 * is allocated anymore, AXI errors and QP invalid errors will be received.
+		 * As a workaround to the issue above, allow overrun to the associated CQ of the
+		 * invalidated QP. This will release the back-pressure before the drain stage, and
+		 * will allow all needed tx packets to be drained successfully. Once the drain stage
+		 * is done, and the QP is cleared, disable CQ overrun.
+		 */
+		if (!qp->force_cq_overrun && qp->req_user_cq) {
+			qp->force_cq_overrun = true;
+			gaudi2_user_cq_set_overrun(qp->req_user_cq, true);
+		}
+
+		/* H/W bug H6-3379: the TXE WQ cache is disabled, thus no need to invalidate it */
+	}
+
+	return rc;
+}
+
+static int gaudi2_cn_qpc_clear(struct hbl_cn_port *cn_port, struct hbl_cn_qp *qp, bool is_req)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_qpc_requester req_qpc = {};
+	struct gaudi2_qpc_responder res_qpc = {};
+	u32 port = cn_port->port;
+	struct qpc_mask mask;
+	void *qpc;
+	int rc;
+
+	qpc = is_req ? (void *)&req_qpc : (void *)&res_qpc;
+
+	if (qp->force_cq_overrun && is_req) {
+		qp->force_cq_overrun = false;
+		if (qp->req_user_cq)
+			gaudi2_user_cq_set_overrun(qp->req_user_cq, false);
+	}
+
+	memset(&mask, 0xFF, sizeof(mask));
+
+	rc =  gaudi2_cn_qpc_write_masked(cn_port, qpc, &mask, qp->qp_id, is_req, false);
+	if (rc)
+		return rc;
+
+	if (is_req) {
+		/* Invalidate RXE WQE cache */
+		NIC_RMWREG32(NIC0_RXE0_CACHE_CFG, 1, NIC0_RXE0_CACHE_CFG_INVALIDATION_MASK);
+		NIC_RREG32(NIC0_RXE0_CACHE_CFG);
+
+		NIC_RMWREG32(NIC0_RXE0_CACHE_CFG, 0, NIC0_RXE0_CACHE_CFG_INVALIDATION_MASK);
+		NIC_RREG32(NIC0_RXE0_CACHE_CFG);
+	}
+
+	return 0;
+}
+
+int gaudi2_cn_qpc_read(struct hbl_cn_port *cn_port, void *qpc, u32 qpn, bool is_req)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	bool force_doorbell = false;
+	u32 *data, port, size;
+	int i, rc;
+	u64 ctrl;
+
+	port = cn_port->port;
+	data = qpc;
+	size = is_req ? sizeof(struct gaudi2_qpc_requester) : sizeof(struct gaudi2_qpc_responder);
+
+	/* Don't write to the Gw if its busy with prev operation */
+	if (NIC_RREG32(NIC0_QPC0_GW_BUSY)) {
+		if (hbl_cn_comp_device_operational(hdev))
+			dev_err(hdev->dev, "Cannot read from port %d QP %d %s QPC, GW is busy\n",
+				port, qpn, is_req ? "requester" : "responder");
+
+		return (hdev->in_teardown && hdev->hw_invalid_while_teardown) ? 0 : -EBUSY;
+	}
+
+	/* Clear the mask gateway regs which will cause the operation to be a read */
+	for (i = 0; i < QPC_GW_MASK_REG_NUM; i++)
+		NIC_WREG32(NIC0_QPC0_GW_MASK_0 + i * sizeof(u32), 0);
+
+	ctrl = (is_req << NIC0_QPC0_GW_CTRL_REQUESTER_SHIFT) | qpn |
+	       (!!force_doorbell << NIC0_QPC0_GW_CTRL_DOORBELL_FORCE_SHIFT);
+	rc = gaudi2_cn_qpc_op(cn_port, ctrl, true);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < size / sizeof(u32); i++)
+		data[i] = NIC_RREG32(NIC0_QPC0_GW_DATA_0 + i * sizeof(u32));
+
+	return 0;
+}
+
+static int gaudi2_cn_qpc_query(struct hbl_cn_port *cn_port, u32 qpn, bool is_req,
+			       struct hbl_cn_qpc_attr *attr)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_qpc_requester req_qpc;
+	struct gaudi2_qpc_responder res_qpc;
+	u32 port = cn_port->port;
+	int rc;
+
+	if (is_req) {
+		rc = gaudi2_cn_qpc_read(cn_port, (void *)&req_qpc, qpn, is_req);
+		if (rc)
+			goto out_err;
+
+		attr->valid = REQ_QPC_GET_VALID(req_qpc);
+		attr->in_work = REQ_QPC_GET_IN_WORK(req_qpc);
+		attr->error = REQ_QPC_GET_ERROR(req_qpc);
+	} else {
+		rc = gaudi2_cn_qpc_read(cn_port, (void *)&res_qpc, qpn, is_req);
+		if (rc)
+			goto out_err;
+
+		attr->valid = RES_QPC_GET_VALID(res_qpc);
+		attr->in_work = RES_QPC_GET_IN_WORK(res_qpc);
+		attr->conn_state = RES_QPC_GET_CONN_STATE(res_qpc);
+	}
+
+	return 0;
+
+out_err:
+	dev_err(hdev->dev, "%s QPC GW read timeout, port: %d, qpn: %u\n",
+		is_req ? "requester" : "responder", port, qpn);
+	return rc;
+}
+
+int gaudi2_cn_wqe_read(struct hbl_cn_port *cn_port, void *wqe, u32 qpn, u32 wqe_idx, bool is_tx)
+{
+	u64 wq_base_addr_upper, wq_base_addr_lower, wq_size_cline_log, ctrl,
+	    req_qpc_base_addr_upper, req_qpc_base_addr_lower, wqe_offset;
+	u32 *data, port, wqe_cline_idx, num_of_wqe_in_cline;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	int i, rc;
+
+	port = cn_port->port;
+	data = wqe;
+
+	if (is_tx) {
+		wq_base_addr_upper = NIC_RREG32(NIC0_TXE0_SQ_BASE_ADDRESS_63_32_1);
+		wq_base_addr_lower = NIC_RREG32(NIC0_TXE0_SQ_BASE_ADDRESS_31_0_1);
+		wq_size_cline_log = NIC_RREG32(NIC0_TXE0_LOG_MAX_WQ_SIZE_1);
+		num_of_wqe_in_cline = TX_WQE_NUM_IN_CLINE;
+	} else {
+		wq_base_addr_upper = NIC_RREG32(NIC0_RXE0_WIN1_WQ_BASE_HI);
+		wq_base_addr_lower = NIC_RREG32(NIC0_RXE0_WIN1_WQ_BASE_LO);
+		wq_size_cline_log = NIC_RREG32(NIC0_RXE0_WIN1_WQ_MISC);
+		num_of_wqe_in_cline = RX_WQE_NUM_IN_CLINE;
+	}
+	wqe_cline_idx = wqe_idx / num_of_wqe_in_cline;
+
+	req_qpc_base_addr_upper = NIC_RREG32(NIC0_TXE0_SQ_BASE_ADDRESS_63_32_1);
+	req_qpc_base_addr_lower = NIC_RREG32(NIC0_QPC0_REQ_BASE_ADDRESS_31_7);
+
+	/* Don't write to the Gw if its busy with prev operation */
+	if (NIC_RREG32(NIC0_QPC0_GW_BUSY)) {
+		if (hbl_cn_comp_device_operational(hdev))
+			dev_err(hdev->dev,
+				"Cannot read wqe from port %d QP %d, GW is busy\n", port, qpn);
+
+		return -EBUSY;
+	}
+
+	WARN_ON_CACHE_UNALIGNED(wq_base_addr_lower);
+
+	/* Hacking the QPC base address to read WQ */
+	NIC_WREG32(NIC0_QPC0_REQ_BASE_ADDRESS_63_32, wq_base_addr_upper);
+	NIC_WREG32(NIC0_QPC0_REQ_BASE_ADDRESS_31_7, wq_base_addr_lower >> 7);
+
+	/* Clear the mask gateway regs which will cause the operation to be a read */
+	for (i = 0; i < QPC_GW_MASK_REG_NUM; i++)
+		NIC_WREG32(NIC0_QPC0_GW_MASK_0 + i * sizeof(u32), 0);
+
+	/* Calculate the WQE offset in cache line units */
+	wqe_offset = (1ULL << wq_size_cline_log) * qpn + wqe_cline_idx;
+	ctrl = NIC0_QPC0_GW_CTRL_REQUESTER_MASK + wqe_offset;
+	rc = gaudi2_cn_qpc_op(cn_port, ctrl, true);
+	if (rc)
+		goto exit;
+
+	/* H/W reads in cache line size */
+	for (i = 0; i < 32; i++)
+		data[i] = NIC_RREG32(NIC0_QPC0_GW_DATA_0 + i * sizeof(u32));
+
+exit:
+	/* Restore the configuration */
+	NIC_WREG32(NIC0_QPC0_REQ_BASE_ADDRESS_63_32, req_qpc_base_addr_upper);
+	NIC_WREG32(NIC0_QPC0_REQ_BASE_ADDRESS_31_7, req_qpc_base_addr_lower);
+
+	return rc;
+}
+
+static bool is_valid_mtu(u16 mtu)
+{
+	return (mtu == SZ_1K) || (mtu == SZ_2K) || (mtu == SZ_4K) || (mtu == SZ_8K);
+}
+
+static int normalize_priority(struct hbl_cn_device *hdev, u32 priority, enum hbl_ts_type type,
+			      bool is_req, u32 *norm_priority)
+{
+	/* Ethernet and Responder get the highest priority */
+	if (!is_req || type == TS_RAW) {
+		*norm_priority = GAUDI2_PFC_PRIO_DRIVER;
+		return 0;
+	}
+
+	/* Req priority can vary from 1 to 3 */
+	if (priority < GAUDI2_PFC_PRIO_USER_BASE || priority >= HBL_EN_PFC_PRIO_NUM)
+		return -EINVAL;
+
+	*norm_priority = priority;
+	return 0;
+}
+
+static u32 gaudi2_cn_txs_get_schedq_num(u32 priority, bool is_req)
+{
+	u32 prio_q_group;
+
+	/* prio-group numbering start from 1 - normalize it to Zero */
+	prio_q_group = (is_req ? TXS_PORT_REQ_SCHED_Q : TXS_PORT_RES_SCHED_Q);
+
+	return prio_q_group * HBL_EN_PFC_PRIO_NUM + priority;
+}
+
+static void gaudi2_default_encap_set(struct hbl_cn_port *cn_port, u32 *encap_id, u32 src_ip)
+{
+	struct hbl_cn_encap_xarray_pdata encap_data;
+	u8 dummy_hdr[NIC_MAX_TNL_HDR_SIZE] = {};
+
+	gaudi2_get_default_encap_id(cn_port, encap_id);
+
+	if (!src_ip && hbl_cn_get_src_ip(cn_port, &src_ip)) {
+		dev_dbg(cn_port->hdev->dev, "failed to get interface IP, using 0\n");
+		src_ip = 0;
+	}
+
+	memset(dummy_hdr, 0xa5, sizeof(dummy_hdr));
+
+	encap_data.port = cn_port->port;
+	encap_data.id = *encap_id;
+	encap_data.src_ip = src_ip;
+	encap_data.encap_type = HBL_CNI_ENCAP_OVER_UDP;
+	encap_data.encap_type_data = DUMMY_UDP_PORT;
+	encap_data.encap_header = dummy_hdr;
+	encap_data.encap_header_size = sizeof(dummy_hdr);
+
+	gaudi2_encap_set(cn_port, *encap_id, &encap_data);
+}
+
+static int gaudi2_cn_validate_timeout(u8 gran)
+{
+	u64 tmr_timeout_us;
+	int ret = 0;
+
+	tmr_timeout_us = NIC_GRAN_TO_USEC(gran);
+
+	/* This check guarantees that we can't overflow the PSN window within a timer period,
+	 * meaning that it needs to ensure that the time it takes to transmit the total amount
+	 * of bits ofall packets is greater than the timeout value. note that we take the
+	 * "worst case" values, i.e. min MTU and max speed.
+	 *
+	 * MAX_CONG_WND * MIN_MTU [bits]
+	 * ----------------------------- > TIMEOUT [s]
+	 *      SPEED [bits/s]
+	 *
+	 * ==>
+	 *
+	 * GAUDI2_NIC_MAX_CONG_WND * (NIC_RAW_MIN_MTU [bytes] * BITS_PER_BYTE)
+	 * ------------------------------------------------------------------- >
+	 *                 GAUDI2_NIC_MAX_SPEED [Mbits/sec] * 1M
+	 *
+	 * NIC_TMR_TIMEOUT_US [usec]
+	 * -------------------------
+	 *      1M
+	 * ==>
+	 *
+	 * GAUDI2_NIC_MAX_CONG_WND * (NIC_RAW_MIN_MTU * BITS_PER_BYTE) >
+	 *    NIC_TMR_TIMEOUT_US * GAUDI2_NIC_MAX_SPEED
+	 */
+	if ((((u64)GAUDI2_NIC_MAX_CONG_WND) * ((u64)(NIC_RAW_MIN_MTU * BITS_PER_BYTE))) <=
+	    (tmr_timeout_us * ((u64)GAUDI2_NIC_MAX_SPEED)))
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static int gaudi2_set_req_qp_ctx(struct hbl_cn_device *hdev, struct hbl_cni_req_conn_ctx_in *in,
+				 struct hbl_cn_qp *qp)
+{
+	u8 mac[ETH_ALEN], cqn, encap_en, timer_granularity;
+	struct gaudi2_qpc_requester req_qpc;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_user_cq *user_cq;
+	struct hbl_en_aux_ops *aux_ops;
+	u32 port, priority, encap_id;
+	struct hbl_cn_port *cn_port;
+	struct hbl_aux_dev *aux_dev;
+	int rc;
+
+	port = in->port;
+	cn_port = &hdev->cn_ports[port];
+	gaudi2_port = cn_port->cn_specific;
+	aux_dev = &hdev->en_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+
+	/* In case user didn't set encap, unset for internal ports. */
+	encap_id = 0;
+	encap_en = 0;
+
+	/* Enforce sender (remote) WQ to be at least 4 times bigger than receiver WQ to avoid H/W
+	 * bug - RDV roll-back may stuck the QP.
+	 */
+	if (in->wq_type == QPC_REQ_WQ_TYPE_WRITE && in->wq_remote_log_size &&
+	    (in->wq_size * 4 > BIT(in->wq_remote_log_size))) {
+		dev_dbg(hdev->dev, "Invalid RDV WQ size. local %d, remote %lu, port %d\n",
+			in->wq_size, BIT(in->wq_remote_log_size), port);
+		return -EINVAL;
+	}
+
+	if (in->mtu && !is_valid_mtu(in->mtu)) {
+		dev_dbg(hdev->dev, "MTU of %u is not supported, port %d\n", in->mtu, port);
+		return -EINVAL;
+	}
+
+	if (normalize_priority(hdev, in->priority, TS_RC, true, &priority)) {
+		dev_dbg(hdev->dev, "Unsupported priority value %u, port %d\n", in->priority, port);
+		return -EINVAL;
+	}
+
+	/* H6-3399: Below configuration isn't valid due to H/W bug, i.e.: using encap_id for src IP
+	 * settings w/o encapsulation isn't allowed.
+	 */
+	if (!in->encap_en && in->encap_id) {
+		dev_dbg(hdev->dev,
+			"Encapsulation ID %d can't be set when encapsulation disable, port %d\n",
+			in->encap_id, port);
+		return -EINVAL;
+	}
+
+	/* Due to H/W bug H6-3280, it was decided to allow congestion control for external ports
+	 * only - the user shouldn't enable it for internal ports.
+	 */
+	if (!cn_port->eth_enable && in->congestion_en) {
+		dev_err(hdev->dev,
+			"congestion control should be disabled for internal ports, port %d mode %u\n",
+			port, in->congestion_en);
+		return -EINVAL;
+	}
+
+	if (cn_port->bp_enable && in->wq_size < GAUDI2_NIC_MIN_WQ_SIZE_BP_ENABLED) {
+		dev_err(hdev->dev,
+			"WQ size (%d) can't be smaller than %d when back pressure is enabled, port %d\n",
+			in->wq_size, GAUDI2_NIC_MIN_WQ_SIZE_BP_ENABLED, port);
+		return -EINVAL;
+	}
+
+	timer_granularity = hdev->pldm ? NIC_TMR_TIMEOUT_PLDM_GRAN : in->timer_granularity;
+
+	/* gran 0 is a special case for the highest timeout supported by hw */
+	if (timer_granularity && gaudi2_cn_validate_timeout(timer_granularity)) {
+		dev_err(hdev->dev,
+			"timer granularity %d is not supported\n", timer_granularity);
+		return -EINVAL;
+	}
+
+	if (gaudi2_port->adaptive_timeout_en) {
+		qp->timeout_granularity = timer_granularity;
+		qp->timeout_curr = timer_granularity - (NIC_ADAPTIVE_TIMEOUT_RANGE >> 1);
+		timer_granularity = qp->timeout_curr;
+	}
+
+	if (in->cq_number) {
+		/* User CQ. */
+		cqn = in->cq_number;
+
+		user_cq = hbl_cn_user_cq_get(cn_port, cqn);
+		if (!user_cq) {
+			dev_dbg(hdev->dev, "CQ %d is invalid, port %d\n", cqn, port);
+			return -EINVAL;
+		}
+
+		qp->req_user_cq = user_cq;
+	} else {
+		/* No CQ. */
+		cqn = NIC_CQ_RDMA_IDX;
+	}
+
+	if (cn_port->eth_enable)
+		memcpy(mac, in->dst_mac_addr, ETH_ALEN);
+	else
+		/* in this case the MAC is irrelevant so use broadcast */
+		eth_broadcast_addr(mac);
+
+	memset(&req_qpc, 0, sizeof(req_qpc));
+
+	REQ_QPC_SET_DST_QP(req_qpc, in->dst_conn_id);
+	REQ_QPC_SET_PORT(req_qpc, 0); /* Always select lane 0 */
+	REQ_QPC_SET_PRIORITY(req_qpc, 3);
+	REQ_QPC_SET_RKEY(req_qpc, qp->remote_key);
+	REQ_QPC_SET_DST_IP(req_qpc, in->dst_ip_addr);
+	REQ_QPC_SET_DST_MAC_LSB(req_qpc, *(u32 *)mac);
+	REQ_QPC_SET_DST_MAC_MSB(req_qpc, *(u16 *)(mac + 4));
+
+	REQ_QPC_SET_SCHD_Q_NUM(req_qpc, gaudi2_cn_txs_get_schedq_num(priority, true));
+	REQ_QPC_SET_TM_GRANULARITY(req_qpc, timer_granularity);
+
+	REQ_QPC_SET_TRANSPORT_SERVICE(req_qpc, TS_RC);
+	REQ_QPC_SET_BURST_SIZE(req_qpc, QPC_REQ_BURST_SIZE);
+	REQ_QPC_SET_LAST_IDX(req_qpc, in->wq_size - 1);
+
+	REQ_QPC_SET_WQ_BASE_ADDR(req_qpc, 1);
+
+	/* In case the user didn't specify MTU, set the one from netdev.
+	 * If there is no netdev, use the default value.
+	 */
+	if (in->mtu) {
+		qp->mtu = in->mtu;
+		qp->mtu_type = MTU_FROM_USER;
+	} else if (cn_port->eth_enable) {
+		if (aux_ops->get_mtu)
+			qp->mtu = aux_ops->get_mtu(aux_dev, port) + HBL_EN_MAX_HEADERS_SZ;
+		else
+			qp->mtu = GAUDI2_NIC_MTU_DEFAULT;
+
+		qp->mtu_type = MTU_FROM_NETDEV;
+	} else {
+		qp->mtu = GAUDI2_NIC_MTU_DEFAULT;
+		qp->mtu_type = MTU_DEFAULT;
+	}
+
+	REQ_QPC_SET_MTU(req_qpc, ilog2(roundup_pow_of_two(qp->mtu)) - 10);
+
+	/* GAUDI1 mode is not used and hence set to 0 */
+	REQ_QPC_SET_MOD_GAUDI1(req_qpc, 0);
+	REQ_QPC_SET_SWQ_GRANULARITY(req_qpc, in->swq_granularity);
+	REQ_QPC_SET_CQ_NUM(req_qpc, cqn);
+
+	/* Protect the HW from zero value */
+	REQ_QPC_SET_REMOTE_WQ_LOG_SZ(req_qpc, in->wq_remote_log_size ? in->wq_remote_log_size : 2);
+
+	/* config MMU-BP */
+	REQ_QPC_SET_DATA_MMU_BYPASS(req_qpc, 0);
+
+	/* ASID is also used as protection-domain, so always configure it */
+	REQ_QPC_SET_ASID(req_qpc, qp->ctx->user_asid);
+
+	REQ_QPC_SET_ACKREQ_FREQ(req_qpc, 8);
+	REQ_QPC_SET_WQ_TYPE(req_qpc, in->wq_type);
+
+	/* user QP - unsecured trust level */
+	REQ_QPC_SET_TRUST_LEVEL(req_qpc, UNSECURED);
+
+	/* Congestion control configurations are done for external ports only - for internal ports
+	 * congestion control will be disabled.
+	 */
+	if (cn_port->eth_enable) {
+		u32 congestion_wnd;
+
+		if (in->congestion_wnd > GAUDI2_NIC_MAX_CONG_WND) {
+			dev_dbg(hdev->dev,
+				"Congestion window size(%u) can't be > max allowed size(%lu), port %d\n",
+				in->congestion_wnd, GAUDI2_NIC_MAX_CONG_WND, port);
+		return -EINVAL;
+		}
+
+		/* congestion_mode:
+		 * 0: no congestion
+		 * 1: congestion control (BBR/SWIFT)
+		 * 2: congestion window
+		 *
+		 * REQ_QPC_SET_CONGESTION_MODE set those modes.
+		 * REQ_QPC_SET_RTT_STATE enable the CC-CQ mechanism (relevant for BBR/SWIFT only).
+		 * when user does not set congestion_en we set congestion to mode 2
+		 * so we still have cc via the CONGESTION_WIN.
+		 */
+		REQ_QPC_SET_CONGESTION_MODE(req_qpc, (in->congestion_en) ? 1 : 2);
+
+		REQ_QPC_SET_RTT_STATE(req_qpc, in->congestion_en);
+
+		congestion_wnd = in->congestion_wnd ? in->congestion_wnd : GAUDI2_NIC_MAX_CONG_WND;
+		REQ_QPC_SET_CONGESTION_WIN(req_qpc, congestion_wnd);
+	}
+
+	if (in->encap_en) {
+		encap_id = in->encap_id;
+		encap_en = in->encap_en;
+	} else if (cn_port->eth_enable) {
+		gaudi2_get_default_encap_id(cn_port, &encap_id);
+		encap_en = 1;
+	}
+
+	REQ_QPC_SET_ENCAP_ENABLE(req_qpc, encap_en);
+	REQ_QPC_SET_ENCAP_TYPE(req_qpc, encap_id);
+
+	REQ_QPC_SET_VALID(req_qpc, 1);
+
+	rc = gaudi2_cn_qpc_write(cn_port, &req_qpc, NULL, in->conn_id, true);
+	if (rc)
+		goto qpc_write_fail;
+
+	if (gaudi2_port->advanced && cn_port->bp_enable &&
+	    in->wq_size < gaudi2_port->min_qp_size) {
+		gaudi2_port->min_qp_size = in->wq_size;
+
+		/* The back-pressure thresholds values describe the occupancy of the QP,
+		 * thus should be configured to be the size of the smallest QP minus some
+		 * defined numbers (currently 24/26 for the upper/lower thresholds
+		 * respectively).
+		 */
+		NIC_WREG32(NIC0_QPC0_WQ_UPPER_THRESHOLD,
+			   gaudi2_port->min_qp_size - GAUDI2_NIC_WTD_BP_UPPER_TH_DIFF);
+		NIC_WREG32(NIC0_QPC0_WQ_LOWER_THRESHOLD,
+			   gaudi2_port->min_qp_size - GAUDI2_NIC_WTD_BP_LOWER_TH_DIFF);
+	}
+
+	return 0;
+
+qpc_write_fail:
+	if (qp->req_user_cq) {
+		hbl_cn_user_cq_put(qp->req_user_cq);
+		qp->req_user_cq = NULL;
+	}
+
+	return rc;
+}
+
+static int gaudi2_set_res_qp_ctx(struct hbl_cn_device *hdev, struct hbl_cni_res_conn_ctx_in *in,
+				 struct hbl_cn_qp *qp)
+{
+	u8 mac[ETH_ALEN], cqn, encap_en, wq_mmu_bypass;
+	u32 port = in->port, priority, encap_id;
+	struct gaudi2_qpc_responder res_qpc;
+	struct hbl_cn_user_cq *user_cq;
+	struct hbl_cn_port *cn_port;
+	int rc;
+
+	cn_port = &hdev->cn_ports[port];
+
+	/* In case user didn't set encap, unset for internal ports. */
+	encap_id = 0;
+	encap_en = 0;
+
+	/* H6-3399: Below configuration isn't valid due to H/W bug, i.e.: using encap_id for src IP
+	 * settings w/o encapsulation isn't allowed.
+	 */
+	if (!in->encap_en && in->encap_id) {
+		dev_dbg(hdev->dev,
+			"Encapsulation ID %d can't be set when encapsulation disable, port %d\n",
+			in->encap_id, port);
+		return -EINVAL;
+	}
+
+	if (cn_port->eth_enable)
+		memcpy(mac, in->dst_mac_addr, ETH_ALEN);
+	else
+		/* in this case the MAC is irrelevant so use broadcast */
+		eth_broadcast_addr(mac);
+
+	if (normalize_priority(hdev, in->priority, TS_RC, false, &priority)) {
+		dev_dbg(hdev->dev, "Unsupported priority value %u, port %d\n", in->priority, port);
+		return -EINVAL;
+	}
+
+	if (in->cq_number) {
+		/* User CQ. */
+		cqn = in->cq_number;
+
+		user_cq = hbl_cn_user_cq_get(cn_port, cqn);
+		if (!user_cq) {
+			dev_dbg(hdev->dev, "CQ %d is invalid, port %d\n", cqn, port);
+			return -EINVAL;
+		}
+
+		qp->res_user_cq = user_cq;
+	} else {
+		/* No CQ. */
+		cqn = NIC_CQ_RDMA_IDX;
+	}
+
+	memset(&res_qpc, 0, sizeof(res_qpc));
+
+	RES_QPC_SET_DST_QP(res_qpc, in->dst_conn_id);
+	RES_QPC_SET_PORT(res_qpc, 0); /* Always select lane 0 */
+	RES_QPC_SET_PRIORITY(res_qpc, 2);
+	RES_QPC_SET_LKEY(res_qpc, qp->local_key);
+	RES_QPC_SET_DST_IP(res_qpc, in->dst_ip_addr);
+	RES_QPC_SET_DST_MAC_LSB(res_qpc, *(u32 *)mac);
+	RES_QPC_SET_DST_MAC_MSB(res_qpc, *(u16 *)(mac + 4));
+
+	RES_QPC_SET_TRANSPORT_SERVICE(res_qpc, TS_RC);
+
+	/* config MMU-BP
+	 * In RDV QPs, the responded side is not used for 'real' user data but
+	 * rather to pass WQEs as data, therefore the QPC MMU-BP attribute shall
+	 * be taken according to the configuration of the WQ array.
+	 */
+	wq_mmu_bypass = cn_port->wq_arr_props[HBL_CNI_USER_WQ_SEND].wq_mmu_bypass;
+
+	if (!(in->rdv && wq_mmu_bypass))
+		RES_QPC_SET_DATA_MMU_BYPASS(res_qpc, 0);
+	else
+		RES_QPC_SET_DATA_MMU_BYPASS(res_qpc, 1);
+
+	/* ASID is also used as protection-domain, so always configure it */
+	RES_QPC_SET_ASID(res_qpc, qp->ctx->user_asid);
+
+	RES_QPC_SET_PEER_QP(res_qpc, in->conn_peer);
+	RES_QPC_SET_SCHD_Q_NUM(res_qpc, gaudi2_cn_txs_get_schedq_num(priority, false));
+
+	/* for rdv QPs RXE responder takes its security-level from QPC */
+	if (in->rdv)
+		RES_QPC_SET_TRUST_LEVEL(res_qpc, SECURED);
+	else
+		RES_QPC_SET_TRUST_LEVEL(res_qpc, UNSECURED);
+
+	/* GAUDI1 mode is not used and hence set to 0 */
+	RES_QPC_SET_MOD_GAUDI1(res_qpc, 0);
+
+	RES_QPC_SET_CQ_NUM(res_qpc, cqn);
+	RES_QPC_SET_PEER_WQ_GRAN(res_qpc, in->wq_peer_granularity);
+
+	if (in->encap_en) {
+		encap_id = in->encap_id;
+		encap_en = in->encap_en;
+	} else if (cn_port->eth_enable) {
+		gaudi2_get_default_encap_id(cn_port, &encap_id);
+		encap_en = 1;
+	}
+
+	RES_QPC_SET_ENCAP_ENABLE(res_qpc, encap_en);
+	RES_QPC_SET_ENCAP_TYPE(res_qpc, encap_id);
+
+	RES_QPC_SET_VALID(res_qpc, 1);
+
+	rc = gaudi2_cn_qpc_write(cn_port, &res_qpc, NULL, in->conn_id, false);
+	if (rc)
+		goto qpc_write_fail;
+
+	return 0;
+
+qpc_write_fail:
+	if (qp->res_user_cq) {
+		hbl_cn_user_cq_put(qp->res_user_cq);
+		qp->res_user_cq = NULL;
+	}
+
+	return rc;
+}
+
+static int gaudi2_cn_update_qp_mtu(struct hbl_cn_port *cn_port, struct hbl_cn_qp *qp, u32 mtu)
+{
+	struct gaudi2_qpc_requester req_qpc = {};
+	struct qpc_mask mask = {};
+
+	/* MTU field is 2 bits wide */
+	REQ_QPC_SET_MTU(mask, 0x3);
+	REQ_QPC_SET_MTU(req_qpc, ilog2(roundup_pow_of_two(mtu)) - 10);
+
+	return gaudi2_cn_qpc_write_masked(cn_port, &req_qpc, &mask, qp->qp_id, true, false);
+}
+
+static int gaudi2_user_wq_arr_set(struct hbl_cn_device *hdev, struct hbl_cni_user_wq_arr_set_in *in,
+				  struct hbl_cni_user_wq_arr_set_out *out, struct hbl_cn_ctx *ctx)
+{
+	u64 wq_base_addr, wq_size_cline_log, wq_size, wq_arr_size, num_of_wqs, num_of_wq_entries;
+	u32 wqe_size, rw_asid, type, port, wqe_asid, alignment_size;
+	struct hbl_cn_wq_array_properties *wq_arr_props;
+	struct hbl_cn_mem_data mem_data = {};
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_port *cn_port;
+	bool phys_addr = true;
+	int rc;
+
+	type = in->type;
+	port = in->port;
+	cn_port = &hdev->cn_ports[port];
+	gaudi2_port = cn_port->cn_specific;
+
+	wq_arr_props = &cn_port->wq_arr_props[type];
+	num_of_wqs = in->num_of_wqs;
+
+	if (wq_arr_props->is_send) {
+		wqe_size = (in->swq_granularity == HBL_CNI_SWQE_GRAN_64B) ?
+			   NIC_SEND_WQE_SIZE_MULTI_STRIDE : NIC_SEND_WQE_SIZE;
+		cn_port->swqe_size = wqe_size;
+	} else {
+		wqe_size = NIC_RECV_WQE_SIZE;
+	}
+
+	if (in->mem_id == HBL_CNI_MEM_HOST) {
+		alignment_size = PAGE_SIZE / min(NIC_SEND_WQE_SIZE, NIC_RECV_WQE_SIZE);
+		num_of_wq_entries = ALIGN(in->num_of_wq_entries, alignment_size);
+		wq_size = num_of_wq_entries * wqe_size;
+		wqe_asid = ctx->asid;
+		wq_arr_props->wq_size = wq_size;
+		wq_size_cline_log = ilog2(wq_size / DEVICE_CACHE_LINE_SIZE);
+		mem_data.mem_id = HBL_CN_DRV_MEM_HOST_DMA_COHERENT;
+	} else {
+		num_of_wq_entries = in->num_of_wq_entries;
+		wq_size = ALIGN(num_of_wq_entries * wqe_size, DEVICE_CACHE_LINE_SIZE);
+		mem_data.mem_id = HBL_CN_DRV_MEM_DEVICE;
+		mem_data.in.device_mem_data.port = port;
+		mem_data.in.device_mem_data.type = type;
+		wqe_asid = hdev->kernel_asid;
+		/* device wants the size in units of cache-line */
+		wq_size_cline_log = ilog2((num_of_wq_entries * wqe_size) / DEVICE_CACHE_LINE_SIZE);
+	}
+
+	wq_arr_size = num_of_wqs * wq_size;
+
+	/* We use the MMU whenever the WQ allocation is more than the 4MB DMA coherent memory
+	 * constraint. We need not allocate memory if we are using MMU. We reserve the VA in the
+	 * PMMU and allocate the actual memory inside set_req_qp_ctx and map to this virtual address
+	 * space.
+	 */
+	if (wq_arr_size > DMA_COHERENT_MAX_SIZE && in->mem_id == HBL_CNI_MEM_HOST) {
+		if (!hdev->mmu_enable) {
+			dev_dbg(hdev->dev,
+				"MMU not enabled. For allocations greater than %llx, MMU needs to be enabled, wq_arr_size : 0x%llx, port: %d\n",
+				(u64)DMA_COHERENT_MAX_SIZE, wq_arr_size, port);
+			return -EINVAL;
+		}
+		phys_addr = false;
+
+		rc = hbl_cn_reserve_wq_dva(ctx, cn_port, wq_arr_size, type, &wq_base_addr);
+		if (rc)
+			return rc;
+	} else {
+		mem_data.size = wq_arr_size;
+
+		rc = hbl_cn_mem_alloc(ctx, &mem_data);
+		if (rc) {
+			dev_dbg(hdev->dev, "Failed to allocate WQ: %d\n", rc);
+			return rc;
+		}
+
+		wq_base_addr = mem_data.addr;
+		wq_arr_props->handle = mem_data.handle;
+	}
+
+	wq_arr_props->on_device_mem = in->mem_id == HBL_CNI_MEM_DEVICE;
+
+	dev_dbg(hdev->dev,
+		"port %d: WQ-> type:%u addr=0x%llx log_size:%llu wqe_asid:%u mmu_bp:%u\n", port,
+		type, wq_base_addr, wq_size_cline_log, wqe_asid, phys_addr ? 1 : 0);
+
+	if (wq_arr_props->is_send) {
+		NIC_WREG32(NIC0_TXE0_SQ_BASE_ADDRESS_63_32_1, upper_32_bits(wq_base_addr));
+		NIC_WREG32(NIC0_TXE0_SQ_BASE_ADDRESS_31_0_1, lower_32_bits(wq_base_addr));
+
+		NIC_WREG32(NIC0_TXE0_LOG_MAX_WQ_SIZE_1, wq_size_cline_log);
+
+		/* configure WQ MMU
+		 * currently user app has the index of 1
+		 */
+		if (phys_addr)
+			NIC_WREG32(NIC0_TXE0_WQE_USER_CFG,
+				   NIC_RREG32(NIC0_TXE0_WQE_USER_CFG) | (1 << 1));
+		else
+			NIC_WREG32(NIC0_TXE0_WQE_USER_CFG,
+				   NIC_RREG32(NIC0_TXE0_WQE_USER_CFG) & ~(1 << 1));
+
+		/* Set secured ASID config. The security is enabled for WQs on HBM such that it can
+		 * be accessed only with process whose ASID is wqe_asid. Here we program ASID '0' so
+		 * that only the CN HW can access the WQs on HBM.
+		 * There is a provision to unset the previous ASID settings, so we set the
+		 * ASID only in case of WQ on HBM and unset it in the wq_arr_unset.
+		 */
+		if (wqe_asid != ctx->asid) {
+			rc = gaudi2_cn_config_wqe_asid(cn_port, wqe_asid, true);
+			if (rc)
+				goto set_asid_fail;
+		}
+
+		rw_asid = (ctx->asid <<	ARC_FARM_KDMA_CTX_AXUSER_HB_ASID_RD_SHIFT) |
+			  (ctx->asid << ARC_FARM_KDMA_CTX_AXUSER_HB_ASID_WR_SHIFT);
+
+		NIC_WREG32(NIC0_QM0_AXUSER_NONSECURED_HB_ASID, rw_asid);
+		NIC_WREG32(NIC0_QM0_AXUSER_NONSECURED_HB_MMU_BP, phys_addr ? 0x1 : 0);
+
+		if (gaudi2_port->advanced) {
+			/* enable override of asid */
+			NIC_WREG32(NIC0_QPC0_AXUSER_TXWQE_LBW_QMAN_BP_HB_WR_OVRD_LO, 0xfffff800);
+			NIC_WREG32(NIC0_QPC0_AXUSER_TXWQE_LBW_QMAN_BP_HB_RD_OVRD_LO, 0xfffff800);
+			NIC_WREG32(NIC0_QPC0_AXUSER_TXWQE_LBW_QMAN_BP_HB_ASID, wqe_asid);
+			/* Configure MMU-BP override for TX-WQs */
+			NIC_WREG32(NIC0_QPC0_AXUSER_TXWQE_LBW_QMAN_BP_HB_MMU_BP,
+				   phys_addr ? 0x1 : 0);
+
+			/* configure the QPC with the Tx WQ parameters */
+			NIC_WREG32(NIC0_QPC0_TX_WQ_BASE_ADDR_63_32_1,
+				   upper_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_QPC0_TX_WQ_BASE_ADDR_31_0_1, lower_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_QPC0_LOG_MAX_TX_WQ_SIZE_1, wq_size_cline_log);
+			NIC_WREG32(NIC0_QPC0_MMU_BYPASS_TX_WQ_1, phys_addr ? 0x1 : 0);
+
+			/* rendezvous configuration for send work queue */
+			NIC_WREG32(NIC0_RXE0_RDV_SEND_WQ_BASE_ADDR_HI,
+				   upper_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_RXE0_RDV_SEND_WQ_BASE_ADDR_LO,
+				   lower_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_RXE0_RDV_LOG_MAX_WQ_SIZE, wq_size_cline_log);
+
+			if (num_of_wq_entries < gaudi2_port->min_qp_size) {
+				gaudi2_port->min_qp_size = (u32)num_of_wq_entries;
+
+				/* The back-pressure thresholds values describe the occupancy of
+				 * the QP, thus should be configured to be the size of the smallest
+				 * QP minus some defined numbers (currently 4/8 for the
+				 * upper/lower thresholds respectively).
+				 */
+				NIC_WREG32(NIC0_QPC0_WQ_UPPER_THRESHOLD,
+					   gaudi2_port->min_qp_size -
+					   GAUDI2_NIC_WTD_BP_UPPER_TH_DIFF);
+				NIC_WREG32(NIC0_QPC0_WQ_LOWER_THRESHOLD,
+					   gaudi2_port->min_qp_size -
+					   GAUDI2_NIC_WTD_BP_LOWER_TH_DIFF);
+			}
+		}
+	} else {
+		NIC_WREG32(NIC0_RXE0_WIN1_WQ_BASE_HI, upper_32_bits(wq_base_addr));
+		NIC_WREG32(NIC0_RXE0_WIN1_WQ_BASE_LO, lower_32_bits(wq_base_addr));
+
+		NIC_WREG32(NIC0_RXE0_WIN1_WQ_MISC, wq_size_cline_log);
+
+		/* configure WQ MMU for RXE */
+		if (phys_addr)
+			NIC_WREG32(NIC0_RXE0_ARUSER_MMU_BP,
+				   NIC_RREG32(NIC0_RXE0_ARUSER_MMU_BP) | (1 << 1));
+		else
+			NIC_WREG32(NIC0_RXE0_ARUSER_MMU_BP,
+				   NIC_RREG32(NIC0_RXE0_ARUSER_MMU_BP) & ~(1 << 1));
+
+		if (wqe_asid != ctx->asid) {
+			/* enable override of asid bit before changing asid */
+			NIC_WREG32(NIC0_RXE0_WQE_ARUSER_HB_RD_OVRD_LO, 0xFFFFFc00);
+			/* change asid to secured asid */
+			NIC_WREG32(NIC0_RXE0_WQE_ARUSER_HB_ASID, wqe_asid);
+		} else {
+			NIC_WREG32(NIC0_RXE0_WQE_ARUSER_HB_RD_OVRD_LO, 0xFFFFFFFF);
+		}
+
+		if (gaudi2_port->advanced) {
+			/* enable override of asid */
+			NIC_WREG32(NIC0_QPC0_AXUSER_RXWQE_HB_WR_OVRD_LO, 0xFFFFF800);
+			NIC_WREG32(NIC0_QPC0_AXUSER_RXWQE_HB_RD_OVRD_LO, 0xFFFFF800);
+			NIC_WREG32(NIC0_QPC0_AXUSER_RXWQE_HB_ASID, wqe_asid);
+			/* Configure MMU-BP override for RX-WQs */
+			NIC_WREG32(NIC0_QPC0_AXUSER_RXWQE_HB_MMU_BP, phys_addr ? 0x1 : 0);
+
+			/* configure the QPC with the Rx WQ parameters */
+			NIC_WREG32(NIC0_QPC0_RX_WQ_BASE_ADDR_63_32_1,
+				   upper_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_QPC0_RX_WQ_BASE_ADDR_31_0_1,
+				   lower_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_QPC0_LOG_MAX_RX_WQ_SIZE_1, wq_size_cline_log);
+			NIC_WREG32(NIC0_QPC0_MMU_BYPASS_RX_WQ_1, phys_addr ? 0x1 : 0);
+
+			/* rendezvous configuration for receive work queue */
+			NIC_WREG32(NIC0_RXE0_WIN0_WQ_BASE_HI, (upper_32_bits(wq_base_addr)));
+			NIC_WREG32(NIC0_RXE0_WIN0_WQ_BASE_LO, lower_32_bits(wq_base_addr));
+			NIC_WREG32(NIC0_RXE0_WIN0_WQ_MISC, wq_size_cline_log);
+		}
+	}
+
+	/* We are using a separate flag for wq mmu bypass as the hdev->mmu_bypass is being used by
+	 * other CN data structures.
+	 */
+	wq_arr_props->wq_mmu_bypass = phys_addr;
+
+	return 0;
+
+set_asid_fail:
+	if (phys_addr)
+		hbl_cn_mem_destroy(hdev, mem_data.handle);
+	else
+		hbl_cn_unreserve_dva_block(ctx, wq_arr_props->dva_base, wq_arr_props->dva_size);
+
+	return rc;
+}
+
+static int gaudi2_user_wq_arr_unset(struct hbl_cn_ctx *ctx, struct hbl_cn_port *cn_port, u32 type)
+{
+	struct hbl_cn_wq_array_properties *wq_arr_props = &cn_port->wq_arr_props[type];
+	struct hbl_cn_device *hdev = ctx->hdev;
+	u32 port = cn_port->port;
+	int rc = 0;
+
+	if (wq_arr_props->is_send) {
+		NIC_WREG32(NIC0_QPC0_TX_WQ_BASE_ADDR_63_32_1, 0);
+		NIC_WREG32(NIC0_QPC0_TX_WQ_BASE_ADDR_31_0_1, 0);
+		NIC_WREG32(NIC0_QPC0_LOG_MAX_TX_WQ_SIZE_1, 0);
+
+		NIC_WREG32(NIC0_TXE0_SQ_BASE_ADDRESS_63_32_1, 0);
+		NIC_WREG32(NIC0_TXE0_SQ_BASE_ADDRESS_31_0_1, 0);
+		NIC_WREG32(NIC0_TXE0_LOG_MAX_WQ_SIZE_1, 0);
+
+		if (wq_arr_props->on_device_mem)
+			gaudi2_cn_config_wqe_asid(cn_port, 0, false);
+	} else {
+		NIC_WREG32(NIC0_QPC0_RX_WQ_BASE_ADDR_63_32_1, 0);
+		NIC_WREG32(NIC0_QPC0_RX_WQ_BASE_ADDR_31_0_1, 0);
+		NIC_WREG32(NIC0_QPC0_LOG_MAX_RX_WQ_SIZE_1, 0);
+
+		NIC_WREG32(NIC0_RXE0_WIN1_WQ_BASE_LO, 0);
+		NIC_WREG32(NIC0_RXE0_WIN1_WQ_BASE_HI, 0);
+		NIC_WREG32(NIC0_RXE0_WIN1_WQ_MISC, 0);
+	}
+
+	if (wq_arr_props->dva_base) {
+		hbl_cn_unreserve_wq_dva(ctx, cn_port, type);
+	} else {
+		rc = hbl_cn_mem_destroy(hdev, wq_arr_props->handle);
+		if (!rc)
+			wq_arr_props->handle = 0;
+	}
+
+	return rc;
+}
+
+static void gaudi2_get_cq_id_range(struct hbl_cn_port *cn_port, u32 *min_id, u32 *max_id)
+{
+	*min_id = NIC_MIN_CQ_ID;
+	*max_id = NIC_MAX_CQ_ID;
+}
+
+static int gaudi2_user_cq_set(struct hbl_cn_user_cq *user_cq,
+			      struct hbl_cni_user_cq_set_in_params *in,
+			      struct hbl_cni_user_cq_set_out_params *out)
+{
+	u64 mem_handle, pi_handle, regs_handle, pi_device_addr, umr_block_addr;
+	u32 port, id = user_cq->id, offset = id * 4, regs_offset;
+	struct hbl_cn_port *cn_port = user_cq->cn_port;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct hbl_cn_ctx *ctx = user_cq->ctx;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct gaudi2_cn_device *gaudi2;
+	struct hbl_cn_mem_data mem_data;
+	int rc;
+
+	gaudi2 = hdev->asic_specific;
+	port = cn_port->port;
+
+	if (!hdev->mmu_bypass) {
+		dev_dbg(hdev->dev,
+			"Allocation of non physical CQ %d dma-mem is not supported, port %d\n", id,
+			port);
+		return -EOPNOTSUPP;
+	}
+
+	gaudi2_port = &gaudi2->cn_ports[port];
+
+	memset(&mem_data, 0, sizeof(mem_data));
+	mem_data.mem_id = HBL_CN_DRV_MEM_HOST_MAP_ONLY;
+	mem_data.in.host_map_data.bus_address = RING_BUF_DMA_ADDRESS(&gaudi2_port->cq_rings[0]) +
+						(id * NIC_TOTAL_CQ_MEM_SIZE);
+	mem_data.in.host_map_data.kernel_address = RING_BUF_ADDRESS(&gaudi2_port->cq_rings[0]) +
+						   (id * NIC_TOTAL_CQ_MEM_SIZE);
+	mem_data.size = in->num_of_cqes * CQE_SIZE;
+	rc = hbl_cn_mem_alloc(ctx, &mem_data);
+	if (rc) {
+		dev_dbg(hdev->dev, "user CQ %d buffer allocation failed, rc %d, port %d\n", id, rc,
+			port);
+		return rc;
+	}
+
+	mem_handle = mem_data.handle;
+
+	/* Allocate a producer-index (PI) buffer in host kernel.
+	 * HW updates PI when it pushes an entry to a CQ.
+	 * User mmaps PI buffer and may poll to read current PI.
+	 *
+	 * Allocate page size, else we risk exposing kernel data to userspace inadvertently.
+	 */
+	memset(&mem_data, 0, sizeof(mem_data));
+	mem_data.mem_id = HBL_CN_DRV_MEM_HOST_DMA_COHERENT;
+	mem_data.size = PAGE_SIZE;
+	rc = hbl_cn_mem_alloc(ctx, &mem_data);
+	if (rc) {
+		dev_dbg(hdev->dev, "user CQ %d PI buffer allocation failed, rc %d, port %d\n", id,
+			rc, port);
+		goto pi_alloc_fail;
+	}
+
+	pi_handle = mem_data.handle;
+	pi_device_addr = mem_data.addr;
+
+	NIC_WREG32(NIC0_RXE0_CQ_LOG_SIZE_0 + offset, ilog2(in->num_of_cqes));
+	NIC_WREG32(NIC0_RXE0_CQ_PI_ADDR_HI_0 + offset, upper_32_bits(pi_device_addr));
+	NIC_WREG32(NIC0_RXE0_CQ_PI_ADDR_LO_0 + offset, lower_32_bits(pi_device_addr));
+
+	/* reset the PI+CI for this CQ */
+	NIC_WREG32(NIC0_RXE0_CQ_WRITE_INDEX_0 + offset, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_PRODUCER_INDEX_0 + offset, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_CONSUMER_INDEX_0 + offset, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_CFG_0 + offset, NIC0_RXE0_CQ_CFG_WRITE_PI_EN_MASK |
+		   NIC0_RXE0_CQ_CFG_ENABLE_MASK);
+
+	/* CQs 0 and 1 are secured and hence reserved so skip them for block addr calculation */
+	__gaudi2_cn_get_db_fifo_umr(cn_port, (id >> 1) - 1, id, &umr_block_addr, &regs_offset);
+
+	/* add CQ offset */
+	regs_offset += NIC0_UMR0_0_COMPLETION_QUEUE_CI_1_CQ_NUMBER -
+		       NIC0_UMR0_0_UNSECURE_DOORBELL1_UNSECURE_DB_FIRST32;
+
+	/* get mmap handle for UMR block */
+	rc = hbl_cn_get_hw_block_handle(hdev, umr_block_addr, &regs_handle);
+	if (rc) {
+		dev_dbg(hdev->dev, "Failed to get user CQ %d UMR block, rc %d, port %d\n", id, rc,
+			port);
+		goto umr_get_fail;
+	}
+
+	rc = hbl_cn_eq_dispatcher_register_cq(cn_port, ctx->asid, id);
+	if (rc) {
+		dev_err(hdev->dev, "failed to register CQ %d, rc %d, port %d\n", id, rc, port);
+		goto eq_register_fail;
+	}
+
+	out->mem_handle = mem_handle;
+	out->regs_handle = regs_handle;
+	out->regs_offset = regs_offset;
+	out->pi_handle = pi_handle;
+
+	user_cq->mem_handle = mem_handle;
+	user_cq->pi_handle = pi_handle;
+
+	return 0;
+
+eq_register_fail:
+umr_get_fail:
+	hbl_cn_mem_destroy(hdev, pi_handle);
+pi_alloc_fail:
+	hbl_cn_mem_destroy(hdev, mem_handle);
+
+	return rc;
+}
+
+static int gaudi2_user_cq_unset(struct hbl_cn_user_cq *user_cq)
+{
+	struct hbl_cn_port *cn_port = user_cq->cn_port;
+	u32 port, id = user_cq->id, offset = id * 4;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+
+	port = cn_port->port;
+
+	hbl_cn_eq_dispatcher_unregister_cq(cn_port, id);
+
+	NIC_RMWREG32(NIC0_RXE0_CQ_CFG_0 + offset, 0, NIC0_RXE0_CQ_CFG_WRITE_PI_EN_MASK);
+	/* flush the new cfg */
+	NIC_RREG32(NIC0_RXE0_CQ_CFG_0 + offset);
+
+	NIC_WREG32(NIC0_RXE0_CQ_PI_ADDR_HI_0 + offset, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_PI_ADDR_LO_0 + offset, 0);
+
+	/* only unmaps as the HW might still access this memory */
+	hbl_cn_mem_destroy(hdev, user_cq->mem_handle);
+	/* unmaps and frees as we disabled the PI flag and the HW won't access this memory */
+	hbl_cn_mem_destroy(hdev, user_cq->pi_handle);
+
+	return 0;
+}
+
+static void gaudi2_user_cq_set_overrun(struct hbl_cn_user_cq *user_cq, bool set_overrun)
+{
+	struct hbl_cn_port *cn_port = user_cq->cn_port;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port, offset = user_cq->id * 4;
+	bool update_cq_cfg = false;
+
+	port = cn_port->port;
+
+	mutex_lock(&user_cq->overrun_lock);
+
+	/* only the first QP should enable CQ overrun, and the last QP should disable overrun */
+	if (set_overrun && user_cq->qp_set_overrun_cnt == 0) {
+		user_cq->qp_set_overrun_cnt++;
+		update_cq_cfg = true;
+	} else if (!set_overrun && user_cq->qp_set_overrun_cnt == 1) {
+		user_cq->qp_set_overrun_cnt--;
+		update_cq_cfg = true;
+	}
+
+	if (update_cq_cfg)
+		NIC_RMWREG32(NIC0_RXE0_CQ_CFG_0 + offset, set_overrun,
+			     NIC0_RXE0_CQ_CFG_OVERRUN_EN_MASK);
+
+	mutex_unlock(&user_cq->overrun_lock);
+}
+
+static void gaudi2_user_cq_destroy(struct hbl_cn_user_cq *user_cq)
+{
+	struct hbl_cn_port *cn_port = user_cq->cn_port;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port, offset = user_cq->id * 4;
+
+	port = cn_port->port;
+
+	NIC_WREG32(NIC0_RXE0_CQ_CFG_0 + offset, 0);
+	NIC_WREG32(NIC0_RXE0_CQ_LOG_SIZE_0 + offset, 0);
+}
+
+static void gaudi2_set_advanced_op_mask(struct hbl_cn_device *hdev, bool advanced)
+{
+	u64 advanced_op_mask = BIT(HBL_CNI_OP_USER_CCQ_SET) | BIT(HBL_CNI_OP_USER_CCQ_UNSET);
+
+	if (advanced)
+		hdev->ctrl_op_mask |= advanced_op_mask;
+	else
+		hdev->ctrl_op_mask &= ~advanced_op_mask;
+}
+
+static int gaudi2_user_set_app_params(struct hbl_cn_device *hdev,
+				      struct hbl_cni_set_user_app_params_in *in,
+				      bool *modify_wqe_checkers, struct hbl_cn_ctx *ctx)
+{
+	u32 port = in->port, bp_offs_fw, bp_offs_qman, encap_id, wtd_config;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_port *cn_port;
+
+	cn_port = &hdev->cn_ports[port];
+
+	if (cn_port->set_app_params) {
+		dev_dbg(hdev->dev, "App params were already set, port %d\n", port);
+		return -EPERM;
+	}
+
+	gaudi2_port = cn_port->cn_specific;
+	gaudi2_port->advanced = in->advanced;
+	gaudi2_port->adaptive_timeout_en = in->adaptive_timeout_en;
+
+	/* Enable\disable advanced operations */
+	gaudi2_set_advanced_op_mask(hdev, (bool)gaudi2_port->advanced);
+
+	bp_offs_fw = in->bp_offs[HBL_CNI_USER_BP_OFFS_FW];
+	bp_offs_qman = in->bp_offs[HBL_CNI_USER_BP_OFFS_QMAN];
+
+	/* Validate the parameters before performing any register changes */
+	if ((bp_offs_fw) || (bp_offs_qman)) {
+		if (!gaudi2_port->advanced) {
+			dev_dbg(hdev->dev,
+				"Port %u: advanced flag is disabled - can't set back-pressue\n",
+				port);
+			return -EINVAL;
+		}
+
+		if ((bp_offs_fw) && (bp_offs_fw & ~WQ_BP_ADDR_VAL_MASK)) {
+			dev_dbg(hdev->dev, "Port %u: invalid ARC BP offset 0x%x\n", port,
+				bp_offs_fw);
+			return -EINVAL;
+		}
+
+		if ((bp_offs_qman) && (bp_offs_qman & ~WQ_BP_ADDR_VAL_MASK)) {
+			dev_dbg(hdev->dev, "Port %u: invalid QMAN BP offset 0x%x\n", port,
+				bp_offs_qman);
+			return -EINVAL;
+		}
+
+		gaudi2_port->min_qp_size = U32_MAX;
+
+		/* Enable BP for DB */
+		wtd_config = NIC_RREG32(NIC0_QPC0_WTD_CONFIG) |
+			     NIC0_QPC0_WTD_CONFIG_WQ_BP_DB_ACCOUNTED_MASK;
+
+		if (bp_offs_fw) {
+			/* Enable WTD BP to ARC */
+			wtd_config |= NIC0_QPC0_WTD_CONFIG_WQ_BP_2ARC_EN_MASK;
+
+			/* Set the offset in the ARC memory to signal the BP*/
+			NIC_WREG32(NIC0_QPC0_WQ_BP_2ARC_ADDR, bp_offs_fw);
+		}
+
+		if (bp_offs_qman) {
+			/* Enable WTD BP to QMAN */
+			wtd_config |= NIC0_QPC0_WTD_CONFIG_WQ_BP_2QMAN_EN_MASK;
+
+			/* Set the offset in the QMAN memory to signal the BP*/
+			NIC_WREG32(NIC0_QPC0_WQ_BP_2QMAN_ADDR, bp_offs_qman);
+		}
+
+		NIC_WREG32(NIC0_QPC0_WTD_CONFIG, wtd_config);
+
+		*modify_wqe_checkers = true;
+		cn_port->bp_enable = true;
+	} else {
+		cn_port->bp_enable = false;
+		*modify_wqe_checkers = false;
+	}
+
+	if (gaudi2_port->adaptive_timeout_en) {
+		u8 max_retry_timeout = GAUDI2_NIC_MAX_TIMEOUT_RETRIES / NIC_ADAPTIVE_TIMEOUT_RANGE;
+
+		NIC_WREG32(NIC0_QPC0_RETRY_COUNT_MAX,
+			   (max_retry_timeout << NIC0_QPC0_RETRY_COUNT_MAX_TIMEOUT_SHIFT) |
+			   (max_retry_timeout << NIC0_QPC0_RETRY_COUNT_MAX_SEQUENCE_ERROR_SHIFT));
+	}
+
+	/* configure port's encapsulation for source ip-address automatically */
+	if (cn_port->eth_enable)
+		gaudi2_default_encap_set(cn_port, &encap_id, 0);
+
+	return 0;
+}
+
+static void gaudi2_user_get_app_params(struct hbl_cn_device *hdev,
+				       struct hbl_cni_get_user_app_params_in *in,
+				       struct hbl_cni_get_user_app_params_out *out)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct hbl_cn_port *cn_port;
+
+	cn_port = gaudi2->cn_ports[in->port].cn_port;
+	out->max_num_of_qps = NIC_MAX_QP_NUM;
+	/* always include the Ethernet QP */
+	out->num_allocated_qps = 1 + atomic_read(&cn_port->num_of_allocated_qps);
+	out->max_allocated_qp_idx = hbl_cn_get_max_qp_id(cn_port);
+	out->max_cq_size = CQE_SIZE * NIC_CQ_MAX_ENTRIES;
+
+	/* Two CQs are reserved - one for the Ethernet and one for the driver CQ. We could use the
+	 * driver CQ as a user CQ but in each UMR there are 2 CQs and since CQ idx 0 is reserved for
+	 * Ethernet, also CQ idx 1 is unavailable.
+	 */
+	out->max_num_of_cqs = GAUDI2_NIC_MAX_CQS_NUM - NIC_CQS_NUM;
+	out->max_num_of_db_fifos = GAUDI2_MAX_DB_FIFO_ID - GAUDI2_MIN_DB_FIFO_ID + 1;
+	out->max_num_of_encaps = GAUDI2_MAX_ENCAP_ID - GAUDI2_MIN_ENCAP_ID + 1;
+}
+
+static void gaudi2_cn_stop_traffic_macro(struct hbl_cn_macro *cn_macro)
+{
+	struct hbl_cn_device *hdev = cn_macro->hdev;
+	u32 port = cn_macro->idx << 1; /* the index of the first port in the macro */
+	int i;
+
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_DROP_THRESHOLD_0 + i * 4, 0);
+
+	usleep_range(1000, 2000);
+
+	NIC_MACRO_RMWREG32(NIC0_TMR_TMR_CACHES_CFG, 1,
+			   NIC0_TMR_TMR_CACHES_CFG_LIST_CACHE_STOP_MASK);
+	NIC_MACRO_RMWREG32(NIC0_TMR_TMR_CACHES_CFG, 1,
+			   NIC0_TMR_TMR_CACHES_CFG_FREE_LIST_CACHE_STOP_MASK);
+	NIC_MACRO_RMWREG32(NIC0_TMR_TMR_CACHES_CFG, 1,
+			   NIC0_TMR_TMR_CACHES_CFG_STATE_CACHE_STOP_MASK);
+
+	usleep_range(1000, 2000);
+
+	/* Flush all the writes */
+	NIC_MACRO_RREG32(NIC0_TMR_TMR_CACHES_CFG);
+}
+
+static void gaudi2_cn_stop_traffic_port(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	NIC_RMWREG32(NIC0_QPC0_REQ_STATIC_CONFIG, 1,
+		     NIC0_QPC0_REQ_STATIC_CONFIG_CACHE_STOP_MASK);
+	NIC_RMWREG32(NIC0_QPC0_RES_STATIC_CONFIG, 1,
+		     NIC0_QPC0_RES_STATIC_CONFIG_CACHE_STOP_MASK);
+	NIC_RMWREG32(NIC0_TXS0_CACHE_CFG, 1,
+		     NIC0_TXS0_CACHE_CFG_LIST_CACHE_STOP_MASK);
+	NIC_RMWREG32(NIC0_TXS0_CACHE_CFG, 1,
+		     NIC0_TXS0_CACHE_CFG_FREE_LIST_CACHE_STOP_MASK);
+
+	/* Flush all the writes */
+	NIC_MACRO_RREG32(NIC0_TXS0_CACHE_CFG);
+}
+
+static bool gaudi2_cn_is_macro_enabled(struct hbl_cn_macro *cn_macro)
+{
+	struct hbl_cn_device *hdev = cn_macro->hdev;
+	u32 port1, port2;
+
+	port1 = cn_macro->idx << 1; /* the index of the first port in the macro */
+	port2 = port1 + 1;
+
+	return (hdev->ports_mask & BIT(port1)) || (hdev->ports_mask & BIT(port2));
+}
+
+/* FW must be aligned with any changes done to this function */
+static void gaudi2_cn_stop_traffic(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_macro *cn_macro;
+	int i;
+
+	for (i = 0; i < hdev->cn_props.num_of_macros; i++) {
+		cn_macro = &hdev->cn_macros[i];
+
+		if (!gaudi2_cn_is_macro_enabled(cn_macro))
+			continue;
+
+		gaudi2_cn_stop_traffic_macro(cn_macro);
+	}
+
+	for (i = 0; i < hdev->cn_props.max_num_of_ports; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		gaudi2_cn_stop_traffic_port(&hdev->cn_ports[i]);
+	}
+}
+
+static void gaudi2_cn_set_speed(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_port *cn_port;
+	int i;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		cn_port = &hdev->cn_ports[i];
+		cn_port->speed = hdev->phy_set_nrz ? SPEED_25000 : SPEED_100000;
+	}
+}
+
+static void gaudi2_cn_config_hw_mac(struct hbl_cn_macro *cn_macro)
+{
+	struct hbl_cn_device *hdev = cn_macro->hdev;
+	struct gaudi2_cn_device *gaudi2;
+	u32 port, speed;
+
+	gaudi2 = hdev->asic_specific;
+	/* the index of the first port in the macro */
+	port = cn_macro->idx << 1;
+	speed = hdev->cn_ports[port].speed;
+
+	switch (speed) {
+	case SPEED_25000:
+		/* AC_SD_CFG: sd_n2 = 0, sd_8x = 0 */
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_SD_CFG, 0xF0FF00);
+
+		/* KP_MODE = 0, FEC91_EN = 1, FEC91_1LANE = 1 */
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_FEC91_CFG, 0x60F);
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_PCS_CFG, 0x0);
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_FC_FEC_CFG, 0x0);
+		break;
+	case SPEED_50000:
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_SD_CFG, 0xF0FFF0);
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_FEC91_CFG, 0xFF);
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_PCS_CFG, 0x0);
+
+		if (gaudi2->mac_rs_fec_ctrl_support) {
+			NIC_MACRO_WREG32(NIC0_MAC_RS_FEC_RSFEC_CONTROL, 0x400);
+			NIC_MACRO_WREG32(NIC0_MAC_RS_FEC_RSFEC1_CONTROL, 0x400);
+			NIC_MACRO_WREG32(NIC0_MAC_RS_FEC_RSFEC2_CONTROL, 0x400);
+			NIC_MACRO_WREG32(NIC0_MAC_RS_FEC_RSFEC3_CONTROL, 0x400);
+		}
+		break;
+	case SPEED_100000:
+		NIC_MACRO_WREG32(PRT0_MAC_CORE_MAC_FEC91_CFG, 0xFF);
+		break;
+	default:
+		dev_err(hdev->dev, "unknown speed %dMb/s, cannot set MAC\n", speed);
+	}
+}
+
+static void gaudi2_cn_config_hw_rxb(struct hbl_cn_macro *cn_macro)
+{
+	u32 dynamic_credits, static_credits, drop_th, small_pkt_drop_th, xoff_th, xon_th, val;
+	struct hbl_cn_device *hdev = cn_macro->hdev;
+	u32 port = cn_macro->idx << 1; /* the index of the first port in the macro */
+	int i;
+
+	/* Set iCRC calculation & verification with reversed bytes */
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_ICRC_CFG, 0x2);
+
+	/* Assuming 1 effective priority per port divided between 2 physical ports. */
+	static_credits = RXB_NUM_STATIC_CREDITS;
+	dynamic_credits = 0;
+	drop_th = static_credits - RXB_DROP_TH_DEPTH;
+	xoff_th = static_credits - RXB_XOFF_TH_DEPTH;
+	xon_th = xoff_th - RXB_XON_TH_DEPTH;
+	small_pkt_drop_th = static_credits - RXB_DROP_SMALL_TH_DEPTH;
+
+	/* Dynamic credits (global) */
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_MAX_DYNAMIC, dynamic_credits);
+
+	val = static_credits | (static_credits << 13);
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_MAX_STATIC_CREDITS_0 + i * 4, val);
+
+	/* Drop threshold (per port/prio) */
+	val = drop_th | (drop_th << 13);
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_DROP_THRESHOLD_0 + i * 4, val);
+
+	/* Drop threshold for small packets (per port/prio) */
+	val = small_pkt_drop_th | (small_pkt_drop_th << 13);
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_DROP_SMALL_THRESHOLD_0 + i * 4, val);
+
+	/* XOFF threshold (per port/prio) */
+	val = xoff_th | (xoff_th << 13);
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_XOFF_THRESHOLD_0 + i * 4, val);
+
+	/* XON threshold (per port/prio) */
+	val = xon_th | (xon_th << 13);
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_XON_THRESHOLD_0 + i * 4, val);
+
+	/* All DSCP values should be mapped to PRIO 0 */
+	for (i = 0; i < 8; i++)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_DSCP2PRIO_0 + i * 4, 0);
+
+	/* set priority 0 as default priority to all ports and set the RXB to take the priority
+	 * according to the incoming port.
+	 */
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_PORT_DEFAULT_PRIO, 0x0);
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_PORT_TRUST_LEVEL, 0);
+
+	/* spread PAUSE on all prios (i.e. global pause) */
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_MAC_PFC_MODE, 0x2);
+}
+
+static void gaudi2_cn_config_hw_txb(struct hbl_cn_macro *cn_macro)
+{
+	struct hbl_cn_device *hdev = cn_macro->hdev;
+	u32 port = cn_macro->idx << 1; /* the index of the first port in the macro */
+	u32 speed;
+
+	speed = hdev->cn_ports[port].speed;
+
+	/* Set iCRC calculation & generation with reversed bytes */
+	NIC_MACRO_WREG32(NIC0_TXB_ICRC_CFG, 0x2);
+
+	NIC_MACRO_WREG32(NIC0_TXB_GLOBAL_PAUSE, 0x0);
+
+	switch (speed) {
+	case SPEED_25000:
+		fallthrough;
+	case SPEED_50000:
+		NIC_MACRO_WREG32(NIC0_TXB_TDM_PORT_ARB_MASK, 0x7BDE);
+		break;
+	case SPEED_100000:
+		NIC_MACRO_WREG32(NIC0_TXB_TDM_PORT_ARB_MASK, 0xBBEE);
+		break;
+	default:
+		dev_err(hdev->dev, "unknown port %d speed %dMb/s, cannot set TDM mask\n", port,
+			speed);
+	}
+}
+
+static int gaudi2_cn_config_hw_tmr(struct hbl_cn_macro *cn_macro)
+{
+	struct cpucp_cn_init_hw_mem_packet pkt;
+	struct hbl_cn_properties *cn_prop;
+	u64 tmr_addr, nic_tmr_timeout_us;
+	struct hbl_cn_device *hdev;
+	bool use_cpucp;
+	int i, rc;
+	u32 port;
+
+	port = cn_macro->idx << 1; /* the index of the first port in the macro */
+	hdev = cn_macro->hdev;
+	cn_prop = &hdev->cn_props;
+
+	tmr_addr = cn_prop->tmr_base_addr + cn_macro->idx * cn_prop->tmr_base_size;
+
+	use_cpucp = !!(hdev->fw_app_cpu_boot_dev_sts0 & CPU_BOOT_DEV_STS0_NIC_MEM_CLEAR_EN);
+	if (use_cpucp) {
+		memset(&pkt, 0, sizeof(pkt));
+		pkt.cpucp_pkt.ctl = cpu_to_le32(CPUCP_PACKET_NIC_INIT_TMR_MEM <<
+						CPUCP_PKT_CTL_OPCODE_SHIFT);
+		pkt.cpucp_pkt.macro_index = cpu_to_le32(cn_macro->idx);
+		pkt.mem_base_addr = cpu_to_le64(tmr_addr + TMR_FREE_OFFS);
+		pkt.num_entries = cpu_to_le16(TMR_FREE_NUM_ENTRIES);
+		pkt.entry_size = cpu_to_le16(TMR_ENT_SIZE);
+		pkt.granularity = cpu_to_le16(TMR_GRANULARITY);
+
+		rc = gaudi2_cn_send_cpu_message(hdev, (u32 *)&pkt, sizeof(pkt), 0, NULL);
+		if (rc) {
+			dev_err(hdev->dev, "Failed to handle CPU-CP pkt %u, error %d\n",
+				CPUCP_PACKET_NIC_INIT_TMR_MEM, rc);
+			return rc;
+		}
+	} else {
+		/* Timer free list */
+		for (i = 0; i < TMR_FREE_NUM_ENTRIES; i++) {
+			hbl_cn_dram_writel(hdev, TMR_GRANULARITY + i,
+					   tmr_addr + TMR_FREE_OFFS + i * TMR_ENT_SIZE);
+
+			if ((i % NIC_MAX_COMBINED_WRITES) == 0)
+				hbl_cn_dram_readl(hdev,
+						  tmr_addr + TMR_FREE_OFFS + i * TMR_ENT_SIZE);
+		}
+
+		/* Perform read to flush the writes */
+		hbl_cn_dram_readl(hdev, tmr_addr);
+	}
+
+	WARN_ON_CACHE_UNALIGNED(tmr_addr + TMR_FIFO_OFFS);
+	WARN_ON_CACHE_UNALIGNED(tmr_addr + TMR_FSM0_OFFS);
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_BASE_ADDRESS_63_32,
+			 upper_32_bits(tmr_addr + TMR_FIFO_OFFS));
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_BASE_ADDRESS_31_7,
+			 lower_32_bits(tmr_addr + TMR_FIFO_OFFS) >> 7);
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_BASE_ADDRESS_FREE_LIST_63_32,
+			 upper_32_bits(tmr_addr + TMR_FREE_OFFS));
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_BASE_ADDRESS_FREE_LIST_31_0,
+			 lower_32_bits(tmr_addr + TMR_FREE_OFFS));
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_CACHE_BASE_ADDR_63_32,
+			 upper_32_bits(tmr_addr + TMR_FSM0_OFFS));
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_CACHE_BASE_ADDR_31_7,
+			 lower_32_bits(tmr_addr + TMR_FSM0_OFFS) >> 7);
+
+	/* configure MMU-BP for TIMERS */
+	NIC_MACRO_WREG32(NIC0_TMR_AXUSER_TMR_FREE_LIST_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_MACRO_WREG32(NIC0_TMR_AXUSER_TMR_FREE_LIST_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	NIC_MACRO_WREG32(NIC0_TMR_AXUSER_TMR_FIFO_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_MACRO_WREG32(NIC0_TMR_AXUSER_TMR_FIFO_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	NIC_MACRO_WREG32(NIC0_TMR_AXUSER_TMR_FSM_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_MACRO_WREG32(NIC0_TMR_AXUSER_TMR_FSM_HB_RD_OVRD_LO, 0xFFFFFBFF);
+	/* Perform read to flush the writes */
+	NIC_MACRO_RREG32(NIC0_TMR_AXUSER_TMR_FSM_HB_RD_OVRD_LO);
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_31_0, 0);
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_63_32, 0);
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_95_64, 0);
+
+	for (i = 0; i < TMR_GRANULARITY; i++) {
+		/* Set the amount of ticks for timeout. */
+		nic_tmr_timeout_us = ((i == 0) || (i >= 32)) ?
+				      GENMASK_ULL(46, 0) :
+				      (u64)(hdev->pldm ? NIC_TMR_TIMEOUT_PLDM_US :
+					    (1ULL << (i + 2)));
+
+		NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_191_160,
+				 lower_32_bits(nic_tmr_timeout_us));
+		NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_216_192,
+				 upper_32_bits(nic_tmr_timeout_us));
+		NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_127_96, i);
+		NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_159_128, i);
+		NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_FIFO, i);
+		NIC_MACRO_WREG32(NIC0_TMR_TMR_SCHEDQ_UPDATE_EN, 1);
+	}
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_SCAN_TIMER_COMP_31_0, 10);
+
+	/* Set the number of clock's cycles for a single tick in order to have 1 usec per tick.
+	 * i.e.: 1/frequency_in_MHz * num_of_clk_cycles = 1 usec
+	 */
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_TICK_WRAP, cn_prop->clk);
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_LIST_MASK,
+			 ~(0xFFFFFFFF << (ilog2(TMR_FREE_NUM_ENTRIES) - 5)));
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_PRODUCER_UPDATE, TMR_FREE_NUM_ENTRIES);
+	/* Latch the TMR value */
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_PRODUCER_UPDATE_EN, 1);
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_PRODUCER_UPDATE_EN, 0);
+
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_LIST_MEM_READ_MASK, 0);
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_PUSH_LOCK_EN, 1);
+	NIC_MACRO_WREG32(NIC0_TMR_TMR_TIMER_EN, 1);
+	NIC_MACRO_WREG32(NIC0_TMR_FREE_LIST_PUSH_MASK_EN, 0);
+
+	/* Perform read from the device to flush all configurations */
+	NIC_MACRO_RREG32(NIC0_TMR_TMR_TIMER_EN);
+
+	return 0;
+}
+
+static void gaudi2_cn_enable_gic_macro_interrupts(struct hbl_cn_macro *cn_macro)
+{
+	struct hbl_cn_device *hdev;
+	u32 port;
+
+	port = cn_macro->idx << 1; /* the index of the first port in the macro */
+	hdev = cn_macro->hdev;
+
+	/* enable TMR block interrupts */
+	NIC_MACRO_WREG32(NIC0_TMR_INTERRUPT_MASK, 0x0);
+
+	/* enable RXB_CORE block interrupts */
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_SEI_INTR_MASK, 0x0);
+	NIC_MACRO_WREG32(NIC0_RXB_CORE_SPI_INTR_MASK, 0x0);
+}
+
+static void gaudi2_cn_disable_gic_macro_interrupts(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_macro *cn_macro;
+	u32 port;
+	int i;
+
+	for (i = 0; i < NIC_NUMBER_OF_MACROS; i++) {
+		cn_macro = &hdev->cn_macros[i];
+		port = cn_macro->idx << 1; /* the index of the first port in the macro */
+
+		/* It's not allowed to configure a macro that both of its ports are not enabled */
+		if (!gaudi2_cn_is_macro_enabled(cn_macro))
+			continue;
+
+		/* disable TMR block interrupts */
+		NIC_MACRO_WREG32(NIC0_TMR_INTERRUPT_MASK, 0xF);
+
+		/* disable RXB_CORE block interrupts */
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_SEI_INTR_MASK, 0x3);
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_SPI_INTR_MASK, 0x3F);
+	}
+}
+
+static int gaudi2_cn_hw_macro_config(struct hbl_cn_macro *cn_macro)
+{
+	int rc;
+
+	/* the following registers are shared between each pair of ports */
+
+	/* MAC Configuration */
+	gaudi2_cn_config_hw_mac(cn_macro);
+
+	/* RXB Configuration */
+	gaudi2_cn_config_hw_rxb(cn_macro);
+
+	/* TXB Configuration */
+	gaudi2_cn_config_hw_txb(cn_macro);
+
+	/* TMR Configuration */
+	rc = gaudi2_cn_config_hw_tmr(cn_macro);
+	if (rc)
+		return rc;
+
+	/* Enable GIC macro interrupts - required only if running on PLDM */
+	if (cn_macro->hdev->pldm)
+		gaudi2_cn_enable_gic_macro_interrupts(cn_macro);
+
+	return rc;
+}
+
+static int gaudi2_cn_macros_hw_config(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_macro *cn_macro;
+	int i, rc = 0;
+
+	for (i = 0; i < NIC_NUMBER_OF_MACROS; i++) {
+		cn_macro = &hdev->cn_macros[i];
+
+		if (!gaudi2_cn_is_macro_enabled(cn_macro))
+			continue;
+
+		rc = gaudi2_cn_hw_macro_config(cn_macro);
+		if (rc)
+			return rc;
+	}
+
+	return rc;
+}
+
+static int gaudi2_cn_core_init(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_properties *cn_prop = &hdev->cn_props;
+	u64 nic_dram_alloc_size;
+	int rc;
+
+	nic_dram_alloc_size = cn_prop->nic_drv_end_addr - cn_prop->nic_drv_base_addr;
+	if (nic_dram_alloc_size > cn_prop->nic_drv_size) {
+		dev_err(hdev->dev, "DRAM allocation for CN (%lluMB) shouldn't exceed %lluMB\n",
+			div_u64(nic_dram_alloc_size, SZ_1M),
+			div_u64(cn_prop->nic_drv_size, SZ_1M));
+		return -ENOMEM;
+	}
+
+	rc = gaudi2_cn_phy_init(hdev);
+	if (rc)
+		return rc;
+
+	/* This function must be called before configuring the macros */
+	gaudi2_cn_set_speed(hdev);
+
+	rc = gaudi2_cn_macros_hw_config(hdev);
+	if (rc)
+		return rc;
+
+	return gaudi2_cn_eq_init(hdev);
+}
+
+static void gaudi2_cn_core_fini(struct hbl_cn_device *hdev)
+{
+	gaudi2_cn_eq_fini(hdev);
+
+	/* Disable GIC macro interrupts - required only if running on PLDM */
+	if (hdev->pldm)
+		gaudi2_cn_disable_gic_macro_interrupts(hdev);
+
+	gaudi2_cn_stop_traffic(hdev);
+}
+
+static int gaudi2_cn_ctx_dispatcher_init(struct hbl_cn_device *hdev, u32 asid)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_port *cn_port;
+	int i, j, rc = 0;
+	u32 port;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		gaudi2_port = &gaudi2->cn_ports[i];
+		cn_port = gaudi2_port->cn_port;
+		port = cn_port->port;
+
+		rc = hbl_cn_eq_dispatcher_associate_dq(gaudi2_port->cn_port, asid);
+		if (rc) {
+			dev_err(hdev->dev,
+				"failed to associate ASID %d with port %d event dispatcher (err %d)\n",
+				asid, port, rc);
+			goto associate_error;
+		}
+	}
+
+	return 0;
+
+associate_error:
+	/* dissociate the associated dqs */
+	for (j = 0; j < i; j++) {
+		gaudi2_port = &gaudi2->cn_ports[j];
+		hbl_cn_eq_dispatcher_dissociate_dq(gaudi2_port->cn_port, asid);
+	}
+
+	return rc;
+}
+
+static void gaudi2_cn_ctx_dispatcher_fini(struct hbl_cn_device *hdev, u32 asid)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	int i;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++)
+		if (hdev->ports_mask & BIT(i)) {
+			gaudi2_port = &gaudi2->cn_ports[i];
+			hbl_cn_eq_dispatcher_dissociate_dq(gaudi2_port->cn_port, asid);
+		}
+}
+
+static int gaudi2_cn_kernel_ctx_init(struct hbl_cn_device *hdev, u32 asid)
+{
+	return gaudi2_cn_ctx_dispatcher_init(hdev, asid);
+}
+
+static void gaudi2_cn_kernel_ctx_fini(struct hbl_cn_device *hdev, u32 asid)
+{
+	gaudi2_cn_ctx_dispatcher_fini(hdev, asid);
+}
+
+static int gaudi2_cn_ctx_init(struct hbl_cn_ctx *ctx)
+{
+	return gaudi2_cn_ctx_dispatcher_init(ctx->hdev, ctx->asid);
+}
+
+static void gaudi2_cn_ctx_fini(struct hbl_cn_ctx *ctx)
+{
+	gaudi2_cn_ctx_dispatcher_fini(ctx->hdev, ctx->asid);
+}
+
+static void gaudi2_cn_configure_cq(struct hbl_aux_dev *aux_dev, u32 port, u16 coalesce_usec,
+				   bool enable)
+{
+	struct hbl_cn_device *hdev = container_of(aux_dev, struct hbl_cn_device, en_aux_dev);
+	struct hbl_cn_properties *cn_prop = &hdev->cn_props;
+	u32 arm_timeout;
+
+	/* Calc timeout in ticks.
+	 * result/value of 0 is interpreted as ASAP but since a value of Zero is an invalid value
+	 * we modify it to 1.
+	 */
+	arm_timeout = coalesce_usec ? cn_prop->clk * coalesce_usec : 1;
+
+	/* disable the current timer before configuring the new time */
+	NIC_RMWREG32(NIC0_RXE0_CQ_ARM_TIMEOUT_EN, 0, BIT(NIC_CQ_RAW_IDX));
+	NIC_RREG32(NIC0_RXE0_CQ_ARM_TIMEOUT_EN);
+
+	/* if enable - configure the new timer and enable it */
+	if (enable) {
+		NIC_WREG32(NIC0_RXE0_CQ_ARM_TIMEOUT, arm_timeout);
+		NIC_RMWREG32(NIC0_RXE0_CQ_ARM_TIMEOUT_EN, 1, BIT(NIC_CQ_RAW_IDX));
+	}
+}
+
+static void gaudi2_cn_arm_cq(struct hbl_aux_dev *aux_dev, u32 port, u32 index)
+{
+	struct hbl_cn_device *hdev = container_of(aux_dev, struct hbl_cn_device, en_aux_dev);
+
+	NIC_WREG32(NIC0_QPC0_ARM_CQ_NUM, NIC_CQ_RAW_IDX);
+	NIC_WREG32(NIC0_QPC0_ARM_CQ_INDEX, index);
+}
+
+static void gaudi2_cn_write_rx_ci(struct hbl_aux_dev *aux_dev, u32 port, u32 ci)
+{
+	struct hbl_cn_device *hdev = container_of(aux_dev, struct hbl_cn_device, en_aux_dev);
+
+	NIC_WREG32(NIC0_QPC0_SECURED_CQ_NUMBER, NIC_CQ_RAW_IDX);
+	NIC_WREG32(NIC0_QPC0_SECURED_CQ_CONSUMER_INDEX, ci);
+}
+
+static void gaudi2_cn_get_pfc_cnts(struct hbl_aux_dev *aux_dev, u32 port, int pfc_prio,
+				   u64 *indications, u64 *requests)
+{
+	struct hbl_cn_device *hdev = container_of(aux_dev, struct hbl_cn_device, en_aux_dev);
+	u64 reg_addr, lo_part, hi_part;
+
+	reg_addr = (port & 1) ? NIC0_MAC_GLOB_STAT_RX2_ACBFCPAUSEFRAMESRECEIVED0_2 :
+		   NIC0_MAC_GLOB_STAT_RX0_ACBFCPAUSEFRAMESRECEIVED0;
+
+	reg_addr += (4 * pfc_prio);
+
+	lo_part = NIC_MACRO_RREG32(reg_addr);
+	hi_part = NIC_MACRO_RREG32(NIC0_MAC_GLOB_STAT_CONTROL_REG_DATA_HI);
+	*indications = lo_part | (hi_part << 32);
+
+	reg_addr = (port & 1) ? NIC0_MAC_GLOB_STAT_TX2_ACBFCPAUSEFRAMESTRANSMITTED0_2 :
+		   NIC0_MAC_GLOB_STAT_TX0_ACBFCPAUSEFRAMESTRANSMITTED0;
+
+	reg_addr += (4 * pfc_prio);
+
+	lo_part = NIC_MACRO_RREG32(reg_addr);
+	hi_part = NIC_MACRO_RREG32(NIC0_MAC_GLOB_STAT_CONTROL_REG_DATA_HI);
+	*requests = lo_part | (hi_part << 32);
+}
+
+static int gaudi2_cn_ring_tx_doorbell(struct hbl_aux_dev *aux_dev, u32 port, u32 pi,
+				      bool *full_after_tx)
+{
+	struct hbl_cn_device *hdev = container_of(aux_dev, struct hbl_cn_device, en_aux_dev);
+	u32 db_fifo_ci = 0, db_fifo_pi = 0, space_left_in_db_fifo = 0;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_port *cn_port;
+
+	cn_port = &hdev->cn_ports[port];
+	gaudi2_port = cn_port->cn_specific;
+
+	db_fifo_ci = *((u32 *)RING_CI_ADDRESS(&gaudi2_port->fifo_ring));
+	db_fifo_pi = gaudi2_port->db_fifo_pi;
+
+	space_left_in_db_fifo = CIRC_SPACE(db_fifo_pi, db_fifo_ci, NIC_FIFO_DB_SIZE);
+
+	if (!space_left_in_db_fifo) {
+		dev_dbg_ratelimited(hdev->dev, "port %d DB fifo full. PI %d, CI %d\n", port,
+				    db_fifo_pi, db_fifo_ci);
+		return -EBUSY;
+	}
+
+	NIC_WREG32(NIC0_QPC0_SECURED_DB_FIRST32, pi);
+	NIC_WREG32(NIC0_QPC0_SECURED_DB_SECOND32, RAW_QPN);
+
+	/* Incrementing local PI and wrap around at the size of NIC_FIFO_DB_SIZE */
+	gaudi2_port->db_fifo_pi = (gaudi2_port->db_fifo_pi + 1) & (NIC_FIFO_DB_SIZE - 1);
+
+	*full_after_tx = !(CIRC_SPACE(gaudi2_port->db_fifo_pi, db_fifo_ci, NIC_FIFO_DB_SIZE));
+
+	return 0;
+}
+
+static void gaudi2_cn_compute_reset_prepare(struct hbl_aux_dev *aux_dev)
+{
+	struct hbl_cn_device *hdev = aux_dev->priv;
+	struct gaudi2_cn_device *gaudi2;
+
+	gaudi2 = hdev->asic_specific;
+	gaudi2->in_compute_reset = true;
+
+	gaudi2_cn_eq_enter_temporal_polling_mode(hdev);
+	gaudi2_cn_phy_flush_link_status_work(hdev);
+}
+
+static void gaudi2_cn_compute_reset_late_init(struct hbl_aux_dev *aux_dev)
+{
+	struct hbl_cn_device *hdev = aux_dev->priv;
+	struct gaudi2_cn_device *gaudi2;
+
+	gaudi2_cn_eq_exit_temporal_polling_mode(hdev);
+
+	gaudi2 = hdev->asic_specific;
+	gaudi2->in_compute_reset = false;
+}
+
+static void gaudi2_handle_cn_port_reset_locked(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_en_aux_ops *gaudi2_en_aux_ops;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_cn_device *gaudi2;
+
+	gaudi2 = hdev->asic_specific;
+	gaudi2_en_aux_ops = &gaudi2->en_aux_ops;
+
+	if (hdev->ext_ports_mask & BIT(cn_port->port)) {
+		dev_err_ratelimited(hdev->dev, "port %d, going to reset\n", cn_port->port);
+		if (gaudi2_en_aux_ops->port_reset_locked)
+			gaudi2_en_aux_ops->port_reset_locked(&hdev->en_aux_dev, cn_port->port);
+	} else {
+		hbl_cn_internal_port_fini_locked(cn_port);
+		hbl_cn_internal_port_init_locked(cn_port);
+	}
+}
+
+static void gaudi2_cn_print_event(struct hbl_cn_device *hdev, u16 event_type, bool ratelimited,
+				  const char *fmt, ...)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+	struct va_format vaf;
+	va_list args;
+	char *name;
+
+	aux_dev = hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	name = gaudi2_aux_ops->get_event_name(aux_dev, event_type);
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (ratelimited)
+		dev_err_ratelimited(hdev->dev, "%s: %pV\n", name, &vaf);
+	else
+		dev_err(hdev->dev, "%s: %pV\n", name, &vaf);
+
+	va_end(args);
+}
+
+static int gaudi2_handle_error(struct hbl_cn_device *hdev, u16 event_type, u8 macro_index,
+			       struct hbl_cn_eq_intr_cause *intr_cause)
+{
+	u32 intr_cause_data, port, first_port, last_port, num_of_ports_in_macro, intr_type,
+	    error_count = 0;
+	int idx, i;
+
+	num_of_ports_in_macro = NIC_NUMBER_OF_ENGINES / NIC_NUMBER_OF_MACROS;
+	first_port = macro_index * num_of_ports_in_macro;
+	last_port = (macro_index + 1) * num_of_ports_in_macro - 1;
+	intr_type = intr_cause->intr_type;
+
+	if (!intr_type || intr_type > HBL_CN_CPUCP_INTR_TXE) {
+		gaudi2_cn_print_event(hdev, event_type, true, "port %u: invalid interrupt type %u",
+				      macro_index, intr_type);
+		return 1;
+	}
+
+	intr_cause_data = (u32)intr_cause->intr_cause[0].intr_cause_data;
+
+	switch (intr_type) {
+	case HBL_CN_CPUCP_INTR_TMR:
+		gaudi2_cn_print_event(hdev, event_type, true,
+				      "TMR error on macro %d cause 0x%x", macro_index,
+				      intr_cause_data);
+		return 1;
+	case HBL_CN_CPUCP_INTR_RXB_CORE_SPI:
+		for (i = 0; i < GAUDI2_NUM_OF_NIC_RXB_CORE_SPI_CAUSE; i++) {
+			if (!(intr_cause_data & BIT(i)))
+				continue;
+
+			gaudi2_cn_print_event(hdev, event_type, true,
+					      "RXB CORE SPI error on macro %d cause: %s. cause bit %d",
+					      macro_index,
+					      gaudi2_cn_rxb_core_spi_interrupts_cause[i], i);
+			error_count++;
+		}
+
+		return error_count;
+	case HBL_CN_CPUCP_INTR_RXB_CORE_SEI:
+		for (i = 0; i < GAUDI2_NUM_OF_NIC_RXB_CORE_SEI_CAUSE; i++) {
+			if (!(intr_cause_data & BIT(i)))
+				continue;
+
+			gaudi2_cn_print_event(hdev, event_type, true,
+					      "RXB CORE SEI error on macro %d cause: %s. cause bit %d",
+					      macro_index,
+					      gaudi2_cn_rxb_core_sei_interrupts_cause[i], i);
+			error_count++;
+		}
+
+		return error_count;
+	}
+
+	for (port = first_port, idx = 0; port <= last_port; port++, idx++) {
+		/* check that port is indeed enabled in the macro */
+		if (!(hdev->ports_mask & BIT(port)))
+			continue;
+
+		intr_cause_data = (u32)intr_cause->intr_cause[idx].intr_cause_data;
+		if (!intr_cause_data)
+			continue;
+
+		switch (intr_type) {
+		case HBL_CN_CPUCP_INTR_QPC_RESP_ERR:
+			for (i = 0; i < GAUDI2_NUM_OF_NIC_QPC_RESP_ERR_CAUSE; i++) {
+				if (!(intr_cause_data & BIT(i)))
+					continue;
+
+				gaudi2_cn_print_event(hdev, event_type, true,
+						      "QPC response error on port %d cause: %s. cause bit %d",
+						      port,
+						      gaudi2_cn_qpc_resp_err_interrupts_cause[i],
+						      i);
+				error_count++;
+			}
+
+			break;
+		case HBL_CN_CPUCP_INTR_RXE_SPI:
+			for (i = 0; i < GAUDI2_NUM_OF_NIC_RXE_SPI_CAUSE; i++) {
+				if (!(intr_cause_data & BIT(i)))
+					continue;
+
+				dev_dbg_ratelimited(hdev->dev,
+						    "RXE SPI error on port %d cause: %s. cause bit %d\n",
+						    port, gaudi2_cn_rxe_spi_interrupts_cause[i],
+						    i);
+				error_count++;
+			}
+
+			break;
+		case HBL_CN_CPUCP_INTR_RXE_SEI:
+			for (i = 0; i < GAUDI2_NUM_OF_NIC_RXE_SEI_CAUSE; i++) {
+				if (!(intr_cause_data & BIT(i)))
+					continue;
+
+				gaudi2_cn_print_event(hdev, event_type, true,
+						      "RXE SEI error on port %d cause: %s. cause bit %d",
+						      port,
+						      gaudi2_cn_rxe_sei_interrupts_cause[i], i);
+				error_count++;
+			}
+
+			break;
+		case HBL_CN_CPUCP_INTR_TXS:
+			gaudi2_cn_print_event(hdev, event_type, true,
+					      "TXS error on port %d cause 0x%x", port,
+					      intr_cause_data);
+			error_count++;
+			break;
+		case HBL_CN_CPUCP_INTR_TXE:
+			gaudi2_cn_print_event(hdev, event_type, true,
+					      "TXE error on port %d cause 0x%x", port,
+					      intr_cause_data);
+			error_count++;
+			break;
+		default:
+			gaudi2_cn_print_event(hdev, event_type, true,
+					      "Invalid interrupt type port %d", port);
+		}
+	}
+
+	return error_count;
+}
+
+static void gaudi2_cn_convert_intr_cause(struct hbl_cn_eq_intr_cause *to,
+					 struct hl_eq_nic_intr_cause *from)
+{
+	int i;
+
+	to->intr_type = le32_to_cpu(from->intr_type);
+
+	for (i = 0; i < MAX_PORTS_PER_NIC; i++)
+		to->intr_cause[i].intr_cause_data =
+						le64_to_cpu(from->intr_cause[i].intr_cause_data);
+}
+
+static int gaudi2_cn_sw_err_event(struct hbl_aux_dev *aux_dev, u16 event_type, u8 macro_index,
+				  struct hl_eq_nic_intr_cause *intr_cause_cpucp)
+{
+	u32 qpc_intr_cause, port, first_port, last_port, num_of_ports_in_macro, error_count = 0;
+	struct hbl_cn_device *hdev = aux_dev->priv;
+	struct hbl_cn_eq_intr_cause intr_cause;
+	struct hbl_cn_port *cn_port;
+
+	gaudi2_cn_convert_intr_cause(&intr_cause, intr_cause_cpucp);
+
+	num_of_ports_in_macro = NIC_NUMBER_OF_ENGINES / NIC_NUMBER_OF_MACROS;
+	first_port = macro_index * num_of_ports_in_macro;
+	last_port = (macro_index + 1) * num_of_ports_in_macro - 1;
+
+	for (port = first_port; port <= last_port; port++) {
+		/* check that port is indeed enabled in the macro */
+		if (!(hdev->ports_mask & BIT(port)))
+			continue;
+
+		qpc_intr_cause = NIC_RREG32(NIC0_QPC0_INTERRUPT_CAUSE);
+
+		/* eqe interrupts are mapped to MSI except interrupt on error event queue
+		 * which is handled here, in such case port reset is required.
+		 */
+		if (!(qpc_intr_cause & 0x400))
+			continue;
+
+		gaudi2_cn_print_event(hdev, event_type, true, "QPC EQ error on port %d", port);
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_CLR, 0x400);
+		error_count++;
+
+		cn_port = &hdev->cn_ports[port];
+		mutex_lock(&cn_port->control_lock);
+		hbl_cn_track_port_reset(cn_port, NIC_EQ_ERR_SYNDROME);
+		gaudi2_handle_cn_port_reset_locked(cn_port);
+		mutex_unlock(&cn_port->control_lock);
+	}
+
+	error_count += gaudi2_handle_error(hdev, event_type, macro_index, &intr_cause);
+
+	return error_count;
+}
+
+static int gaudi2_cn_axi_error_response_event(struct hbl_aux_dev *aux_dev, u16 event_type,
+					      u8 macro_index,
+					      struct hl_eq_nic_intr_cause *intr_cause_cpucp)
+{
+	struct hbl_cn_device *hdev = aux_dev->priv;
+	struct hbl_cn_eq_intr_cause intr_cause;
+
+	gaudi2_cn_convert_intr_cause(&intr_cause, intr_cause_cpucp);
+
+	return gaudi2_handle_error(hdev, event_type, macro_index, &intr_cause);
+}
+
+static void gaudi2_cn_pre_sw_init(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_properties *cn_prop = &hdev->cn_props;
+
+	cn_prop->phy_base_addr = NIC0_PHY_BASE;
+	cn_prop->max_hw_qps_num = NIC_HW_MAX_QP_NUM;
+	cn_prop->max_qps_num = NIC_MAX_QP_NUM;
+	cn_prop->max_hw_user_wqs_num = USER_WQES_MAX_NUM;
+	cn_prop->min_hw_user_wqs_num = USER_WQES_MIN_NUM;
+	cn_prop->rwqe_size = NIC_RECV_WQE_SIZE;
+	cn_prop->force_cq = false;
+	cn_prop->max_num_of_lanes = NIC_MAX_NUM_OF_LANES;
+	cn_prop->num_of_macros = NIC_NUMBER_OF_MACROS;
+	cn_prop->max_cqs = GAUDI2_NIC_MAX_CQS_NUM;
+	cn_prop->max_ccqs = NIC_MAX_CCQS_NUM;
+	cn_prop->max_db_fifos = GAUDI2_NIC_NUM_DB_FIFOS;
+	cn_prop->user_cq_min_entries = NIC_CQ_USER_MIN_ENTRIES;
+	cn_prop->user_cq_max_entries = NIC_CQ_USER_MAX_ENTRIES;
+	cn_prop->cqe_size = CQE_SIZE;
+	cn_prop->max_frm_len = NIC_MAX_FRM_LEN;
+	cn_prop->raw_elem_size = NIC_RAW_ELEM_SIZE;
+	cn_prop->max_raw_mtu = NIC_RAW_MAX_MTU;
+	cn_prop->min_raw_mtu = NIC_RAW_MIN_MTU;
+	cn_prop->max_wq_arr_type = HBL_CNI_USER_WQ_RECV;
+	cn_prop->is_phy_fw_binary = true;
+}
+
+static int gaudi2_cn_sw_init(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_ring **rx_rings, **cq_rings, **wq_rings;
+	struct gaudi2_cn_aux_data *gaudi2_cn_aux_data;
+	struct gaudi2_en_aux_data *gaudi2_en_aux_data;
+	struct gaudi2_en_aux_ops *gaudi2_en_aux_ops;
+	struct hbl_cn_aux_data *cn_aux_data;
+	struct hbl_en_aux_data *en_aux_data;
+	struct hbl_cn_aux_ops *cn_aux_ops;
+	struct hbl_en_aux_ops *en_aux_ops;
+	struct gaudi2_cn_device *gaudi2;
+	struct hbl_aux_dev *cn_aux_dev;
+	struct hbl_aux_dev *en_aux_dev;
+	int rc;
+
+	BUILD_BUG_ON_NOT_POWER_OF_2(NIC_RAW_ELEM_SIZE);
+	BUILD_BUG_ON_NOT_POWER_OF_2(NIC_RX_RING_PKT_NUM);
+	BUILD_BUG_ON_NOT_POWER_OF_2(NIC_CQ_MAX_ENTRIES);
+	BUILD_BUG_ON_NOT_POWER_OF_2(NIC_EQ_RING_NUM_REC);
+
+	gaudi2 = kzalloc(sizeof(*gaudi2), GFP_KERNEL);
+	if (!gaudi2)
+		return -ENOMEM;
+
+	rx_rings = kcalloc(NIC_NUMBER_OF_PORTS, sizeof(*rx_rings), GFP_KERNEL);
+	if (!rx_rings) {
+		rc = -ENOMEM;
+		goto rx_rings_fail;
+	}
+
+	cq_rings = kcalloc(NIC_NUMBER_OF_PORTS, sizeof(*cq_rings), GFP_KERNEL);
+	if (!cq_rings) {
+		rc = -ENOMEM;
+		goto cq_rings_fail;
+	}
+
+	wq_rings = kcalloc(NIC_NUMBER_OF_PORTS, sizeof(*wq_rings), GFP_KERNEL);
+	if (!wq_rings) {
+		rc = -ENOMEM;
+		goto qp_rings_fail;
+	}
+
+	hdev->asic_specific = gaudi2;
+
+	cn_aux_dev = hdev->cn_aux_dev;
+	cn_aux_data = cn_aux_dev->aux_data;
+	cn_aux_ops = cn_aux_dev->aux_ops;
+	gaudi2_cn_aux_data = cn_aux_data->asic_specific;
+	gaudi2->cn_aux_ops = cn_aux_ops->asic_ops;
+
+	gaudi2->temporal_polling = !hdev->poll_enable;
+	gaudi2->fw_security_enabled = gaudi2_cn_aux_data->fw_security_enabled;
+	gaudi2->msix_enabled = gaudi2_cn_aux_data->msix_enabled;
+	gaudi2->cfg_base = gaudi2_cn_aux_data->cfg_base;
+	gaudi2->irq_num_port_base = gaudi2_cn_aux_data->irq_num_port_base;
+	gaudi2->sob_id_base = gaudi2_cn_aux_data->sob_id_base;
+	gaudi2->sob_inc_cfg_val = gaudi2_cn_aux_data->sob_inc_cfg_val;
+	gaudi2->setup_type = gaudi2_cn_aux_data->setup_type;
+
+	gaudi2_en_aux_data = &gaudi2->en_aux_data;
+	gaudi2_en_aux_ops = &gaudi2->en_aux_ops;
+
+	en_aux_dev = &hdev->en_aux_dev;
+	en_aux_data = en_aux_dev->aux_data;
+	en_aux_ops = en_aux_dev->aux_ops;
+	en_aux_data->asic_specific = gaudi2_en_aux_data;
+	en_aux_ops->asic_ops = gaudi2_en_aux_ops;
+
+	gaudi2_en_aux_data->rx_rings = rx_rings;
+	gaudi2_en_aux_data->cq_rings = cq_rings;
+	gaudi2_en_aux_data->wq_rings = wq_rings;
+	gaudi2_en_aux_data->kernel_asid = hdev->kernel_asid;
+	gaudi2_en_aux_data->raw_qpn = RAW_QPN;
+	gaudi2_en_aux_data->tx_ring_len = NIC_TX_BUF_SIZE;
+	gaudi2_en_aux_data->schedq_num = TXS_PORT_RAW_SCHED_Q * HBL_EN_PFC_PRIO_NUM +
+					 GAUDI2_PFC_PRIO_DRIVER;
+
+	/* As a W/A for H/W bug H6-3399, we increase our Tx packets by padding them with bigger
+	 * value than the default. This should keep the MAC in the other side busier on each packet
+	 * processing, hence decrease the rate that it pushes the packet towards the Rx.
+	 */
+	gaudi2_en_aux_data->pad_size = NIC_SKB_PAD_SIZE;
+
+	/* en2cn */
+	gaudi2_en_aux_ops->configure_cq = gaudi2_cn_configure_cq;
+	gaudi2_en_aux_ops->arm_cq = gaudi2_cn_arm_cq;
+	gaudi2_en_aux_ops->write_rx_ci = gaudi2_cn_write_rx_ci;
+	gaudi2_en_aux_ops->get_pfc_cnts = gaudi2_cn_get_pfc_cnts;
+	gaudi2_en_aux_ops->ring_tx_doorbell = gaudi2_cn_ring_tx_doorbell;
+	gaudi2_en_aux_ops->qp_err_syndrome_to_str = gaudi2_cn_qp_err_syndrome_to_str;
+	gaudi2_en_aux_ops->db_fifo_reset = gaudi2_cn_db_fifo_reset;
+
+	hdev->ctrl_op_mask = BIT(HBL_CNI_OP_ALLOC_CONN) |
+			     BIT(HBL_CNI_OP_SET_REQ_CONN_CTX) |
+			     BIT(HBL_CNI_OP_SET_RES_CONN_CTX) |
+			     BIT(HBL_CNI_OP_DESTROY_CONN) |
+			     BIT(HBL_CNI_OP_USER_WQ_SET) |
+			     BIT(HBL_CNI_OP_USER_WQ_UNSET) |
+			     BIT(HBL_CNI_OP_SET_USER_APP_PARAMS) |
+			     BIT(HBL_CNI_OP_GET_USER_APP_PARAMS) |
+			     BIT(HBL_CNI_OP_ALLOC_USER_DB_FIFO) |
+			     BIT(HBL_CNI_OP_USER_DB_FIFO_SET) |
+			     BIT(HBL_CNI_OP_USER_DB_FIFO_UNSET) |
+			     BIT(HBL_CNI_OP_EQ_POLL) |
+			     BIT(HBL_CNI_OP_USER_ENCAP_ALLOC) |
+			     BIT(HBL_CNI_OP_USER_ENCAP_SET) |
+			     BIT(HBL_CNI_OP_USER_ENCAP_UNSET) |
+			     BIT(HBL_CNI_OP_ALLOC_USER_CQ_ID) |
+			     BIT(HBL_CNI_OP_USER_CQ_ID_SET) |
+			     BIT(HBL_CNI_OP_USER_CQ_ID_UNSET) |
+			     BIT(HBL_CNI_OP_DUMP_QP);
+
+	hdev->debugfs_supp_mask = BIT(NIC_MAC_LOOPBACK) |
+				  BIT(NIC_PAM4_TX_TAPS) |
+				  BIT(NIC_NRZ_TX_TAPS) |
+				  BIT(NIC_POLARITY) |
+				  BIT(NIC_QP) |
+				  BIT(NIC_WQE) |
+				  BIT(NIC_RESET_CNT) |
+				  BIT(NIC_MAC_LANE_REMAP) |
+				  BIT(NIC_RAND_STATUS) |
+				  BIT(NIC_MMU_BYPASS) |
+				  BIT(NIC_ETH_LOOPBACK) |
+				  BIT(NIC_PHY_REGS_PRINT) |
+				  BIT(NIC_SHOW_INTERNAL_PORTS_STATUS) |
+				  BIT(NIC_PRINT_FEC_STATS) |
+				  BIT(NIC_DISABLE_DECAP) |
+				  BIT(NIC_PHY_SET_NRZ) |
+				  BIT(NIC_PHY_DUMP_SERDES_PARAMS) |
+				  BIT(NIC_PHY_CALC_BER) |
+				  BIT(NIC_PHY_CALC_BER_WAIT_SEC) |
+				  BIT(NIC_OVERRIDE_PORT_STATUS) |
+				  BIT(NIC_ACCUMULATE_FEC_DURATION) |
+				  BIT(NIC_PHY_FORCE_FIRST_TX_TAPS_CFG);
+
+	hdev->ib_support = true;
+	hdev->qpc_cache_inv_timeout = hdev->pldm ? NIC_PLDM_QPC_INV_USEC :
+				      NIC_QPC_INV_USEC;
+	hdev->qp_wait_for_idle = true;
+	hdev->qp_reset_mode = CN_QP_RESET_MODE_HARD;
+	hdev->hw_invalid_while_teardown = false;
+	hdev->has_eq = true;
+	hdev->umr_support = true;
+	hdev->cc_support = true;
+
+	gaudi2->mac_rs_fec_ctrl_support = true;
+	gaudi2->flush_db_fifo = false;
+
+	hdev->cn_props.max_qp_error_syndromes = NIC_MAX_QP_ERR_SYNDROMES;
+	hdev->cn_props.status_packet_size = sizeof(struct cpucp_nic_status);
+
+	hdev->wq_arrays_pool_enable = true;
+	hdev->mmap_type_flag = HBL_CN_MMAP_TYPE_CN_MEM;
+
+	return 0;
+
+qp_rings_fail:
+	kfree(cq_rings);
+cq_rings_fail:
+	kfree(rx_rings);
+rx_rings_fail:
+	kfree(gaudi2);
+
+	return rc;
+}
+
+static void gaudi2_cn_sw_fini(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_en_aux_data *en_aux_data;
+
+	en_aux_data = &gaudi2->en_aux_data;
+
+	kfree(en_aux_data->wq_rings);
+	kfree(en_aux_data->cq_rings);
+	kfree(en_aux_data->rx_rings);
+	kfree(gaudi2);
+}
+
+static void gaudi2_cn_set_en_data(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_en_aux_data *gaudi2_aux_data;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_en_aux_data *aux_data;
+	struct hbl_en_aux_ops *aux_ops;
+	struct hbl_cn_port *cn_port;
+	struct hbl_aux_dev *aux_dev;
+	int i;
+
+	aux_dev = &hdev->en_aux_dev;
+	aux_data = aux_dev->aux_data;
+	gaudi2_aux_data = &gaudi2->en_aux_data;
+	aux_data->asic_specific = gaudi2_aux_data;
+	aux_ops = aux_dev->aux_ops;
+	aux_ops->asic_ops = &gaudi2->en_aux_ops;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		cn_port = &hdev->cn_ports[i];
+		gaudi2_port = cn_port->cn_specific;
+
+		if (cn_port->eth_enable) {
+			gaudi2_aux_data->rx_rings[i] = &gaudi2_port->rx_ring;
+			gaudi2_aux_data->cq_rings[i] = &gaudi2_port->cq_rings[NIC_CQ_RAW_IDX];
+			gaudi2_aux_data->wq_rings[i] = &gaudi2_port->wq_ring;
+		}
+	}
+}
+
+static int gaudi2_register_qp(struct hbl_cn_port *cn_port, u32 qp_id, u32 asid)
+{
+	return hbl_cn_eq_dispatcher_register_qp(cn_port, asid, qp_id);
+}
+
+static void gaudi2_unregister_qp(struct hbl_cn_port *cn_port, u32 qp_id)
+{
+	hbl_cn_eq_dispatcher_unregister_qp(cn_port, qp_id);
+}
+
+static void gaudi2_get_qp_id_range(struct hbl_cn_port *cn_port, u32 *min_id, u32 *max_id)
+{
+	*min_id = NIC_MIN_CONN_ID;
+	*max_id = NIC_MAX_CONN_ID;
+}
+
+static u8 gaudi2_qp_event_is_req_event(struct hbl_cn_eqe *eqe)
+{
+	char synd_str_to_lower[GAUDI2_MAX_SYNDROME_STRING_LEN] = {};
+	u32 synd = EQE_QP_EVENT_ERR_SYND(eqe);
+	char *synd_str;
+
+	synd_str = gaudi2_cn_qp_err_syndrome_to_str(synd);
+
+	if (strlen(synd_str)) {
+		strscpy(synd_str_to_lower, synd_str, sizeof(synd_str_to_lower));
+		hbl_cn_strtolower(synd_str_to_lower);
+
+		if (strnstr(synd_str_to_lower, "req", strlen(synd_str_to_lower)))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int gaudi2_eq_poll(struct hbl_cn_port *cn_port, u32 asid, struct hbl_cni_eq_poll_out *event)
+{
+	u32 ev_type, ev_valid, port = cn_port->port;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct hbl_cn_eqe eqe;
+	int rc;
+
+	rc = hbl_cn_eq_dispatcher_dequeue(cn_port, asid, &eqe, false);
+	if (rc)
+		return rc;
+
+	ev_valid = EQE_IS_VALID(&eqe);
+	if (!ev_valid) {
+		dev_dbg_ratelimited(hdev->dev,
+				    "got EQE invalid entry while expecting a valid one\n");
+			return -ENODATA;
+	}
+
+	ev_type = EQE_TYPE(&eqe);
+	switch (ev_type) {
+	case EQE_COMP_ERR:
+		event->ev_type = HBL_CNI_EQ_EVENT_TYPE_CQ_ERR;
+		event->idx = EQE_CQ_EVENT_CQ_NUM(&eqe);
+		break;
+	case EQE_QP_ERR:
+		event->ev_type = HBL_CNI_EQ_EVENT_TYPE_QP_ERR;
+		event->idx = EQE_RAW_TX_EVENT_QPN(&eqe);
+		event->rest_occurred = EQE_QP_EVENT_RESET(&eqe);
+		event->is_req = gaudi2_qp_event_is_req_event(&eqe);
+		break;
+	case EQE_DB_FIFO_OVERRUN:
+		event->ev_type = HBL_CNI_EQ_EVENT_TYPE_DB_FIFO_ERR;
+		event->idx = EQE_DB_EVENT_DB_NUM(&eqe);
+		break;
+	case EQE_CONG:
+		/* completion ready in cc comp queue */
+		event->ev_type = HBL_CNI_EQ_EVENT_TYPE_CCQ;
+		event->idx = EQE_CQ_EVENT_CQ_NUM(&eqe);
+		break;
+	case EQE_LINK_STATUS:
+		event->ev_type = HBL_CNI_EQ_EVENT_TYPE_LINK_STATUS;
+		break;
+	case EQE_QP_ALIGN_COUNTERS:
+		event->ev_type = HBL_CNI_EQ_EVENT_TYPE_QP_ALIGN_COUNTERS;
+		event->idx = EQE_SW_EVENT_QPN(&eqe);
+		break;
+	default:
+		/* if the event should not be reported to the user then return
+		 * as if no event was found
+		 */
+		dev_dbg_ratelimited(hdev->dev, "dropping Port-%d event %d report to user\n", port,
+				    ev_type);
+		return -ENODATA;
+	}
+
+	/* fill the vevent-specific data */
+	event->ev_data = eqe.data[2];
+
+	return 0;
+}
+
+static void gaudi2_get_db_fifo_id_range(struct hbl_cn_port *cn_port, u32 *min_id, u32 *max_id)
+{
+	*min_id = GAUDI2_MIN_DB_FIFO_ID;
+	*max_id = GAUDI2_MAX_DB_FIFO_ID;
+}
+
+static void gaudi2_get_db_fifo_hw_id_range(struct hbl_cn_port *cn_port, u32 *min_id, u32 *max_id)
+{
+	*min_id = db_fifo_hw_id(GAUDI2_MIN_DB_FIFO_ID);
+	*max_id = GAUDI2_DB_FIFO_SECURE_HW_ID;
+}
+
+static void gaudi2_get_db_fifo_modes_mask(struct hbl_cn_port *cn_port, u32 *mode_mask)
+{
+	*mode_mask = BIT(HBL_CNI_DB_FIFO_TYPE_DB) | BIT(HBL_CNI_DB_FIFO_TYPE_CC);
+}
+
+static int gaudi2_db_fifo_allocate(struct hbl_cn_port *cn_port,
+				   struct hbl_cn_db_fifo_xarray_pdata *xa_pdata)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 fifo_size;
+
+	switch (xa_pdata->fifo_mode) {
+	case HBL_CNI_DB_FIFO_TYPE_DB:
+	case HBL_CNI_DB_FIFO_TYPE_CC:
+		fifo_size = DB_FIFO_SIZE;
+		break;
+	default:
+		dev_dbg(hdev->dev, "Port %d, invalid DB fifo mode: %d. Allocation failed\n",
+			cn_port->port, xa_pdata->fifo_mode);
+		return -EINVAL;
+	}
+
+	xa_pdata->fifo_size = fifo_size;
+
+	return 0;
+}
+
+static void gaudi2_db_fifo_free(struct hbl_cn_port *cn_port, u32 db_pool_offset, u32 fifo_size)
+{
+}
+
+static int gaudi2_db_fifo_set(struct hbl_cn_port *cn_port, struct hbl_cn_ctx *ctx, u32 id,
+			      u64 ci_device_handle, struct hbl_cn_db_fifo_xarray_pdata *xa_pdata)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	u32 mmu_bypass;
+	u8 is_cc;
+	u32 val;
+	int rc;
+
+	rc = gaudi2_cn_eq_dispatcher_register_db(gaudi2_port, ctx->asid, db_fifo_hw_id(id));
+	if (rc)
+		return rc;
+
+	WARN_ON_CACHE_UNALIGNED(ci_device_handle);
+
+	/* Config HW to use memory buffer for updating
+	 * consumer-index(CI) when it pops fifo.
+	 */
+	NIC_WREG32(NIC0_QPC0_DBFIFO0_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_31_7 + db_fifo_offset64(id),
+		   lower_32_bits(ci_device_handle) >> 7);
+	NIC_WREG32(NIC0_QPC0_DBFIFO0_CI_UPD_ADDR_DBFIFO_CI_UPD_ADDR_63_32 + db_fifo_offset64(id),
+		   upper_32_bits(ci_device_handle));
+
+	is_cc = (xa_pdata->fifo_mode == HBL_CNI_DB_FIFO_TYPE_CC);
+	/* We use generic H/W FIFOs. Configured as a userspace doorbell or congestion control FIFO.
+	 */
+	NIC_WREG32(NIC0_QPC0_DB_FIFO_CFG_0 + db_fifo_offset(id), is_cc);
+
+	mmu_bypass = !!(hdev->mmu_bypass);
+	val = ctx->asid;
+	val |= mmu_bypass << NIC0_QPC0_DB_FIFO_USER_OVRD_MMU_BYPASS_SHIFT;
+	NIC_WREG32(NIC0_QPC0_DB_FIFO_USER_OVRD_0 + db_fifo_offset(id), val);
+
+	return 0;
+}
+
+static void db_fifo_reset(struct hbl_cn_port *cn_port, u32 id, u64 mmap_handle)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct hbl_cn_mem_buf *buf;
+	u32 *ci_cpu_addr;
+
+	buf = hbl_cn_mem_buf_get(hdev, mmap_handle);
+	if (!buf) {
+		dev_err(hdev->dev, "Failed to retrieve port %d db fifo CI memory\n",
+			cn_port->port);
+		return;
+	}
+
+	/* Read latest HW updated CI */
+	ci_cpu_addr = (u32 *)buf->kernel_address;
+
+	__db_fifo_reset(cn_port, ci_cpu_addr, id, false);
+
+	hbl_cn_mem_buf_put(buf);
+}
+
+static void gaudi2_db_fifo_unset(struct hbl_cn_port *cn_port, u32 id,
+				 struct hbl_cn_db_fifo_xarray_pdata *xa_pdata)
+{
+	db_fifo_reset(cn_port, id, xa_pdata->ci_mmap_handle);
+
+	hbl_cn_eq_dispatcher_unregister_db(cn_port, db_fifo_hw_id(id));
+}
+
+static void gaudi2_get_encap_id_range(struct hbl_cn_port *cn_port, u32 *min_id, u32 *max_id)
+{
+	if (cn_port->port & 0x1) {
+		*min_id = GAUDI2_USER_ENCAP_ID + 2;
+		*max_id = GAUDI2_USER_ENCAP_ID + 2;
+	} else {
+		*min_id = GAUDI2_USER_ENCAP_ID;
+		*max_id = GAUDI2_USER_ENCAP_ID;
+	}
+}
+
+static void gaudi2_get_default_encap_id(struct hbl_cn_port *cn_port, u32 *id)
+{
+	u32 min, max;
+
+	gaudi2_get_encap_id_range(cn_port, &min, &max);
+	*id = max + 1;
+}
+
+static int gaudi2_encap_set(struct hbl_cn_port *cn_port, u32 encap_id,
+			    struct hbl_cn_encap_xarray_pdata *xa_pdata)
+{
+	u32 encap_hdr_offset = NIC0_TXE0_ENCAP_DATA_63_32_0 - NIC0_TXE0_ENCAP_DATA_31_0_0;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 *encap_header = xa_pdata->encap_header;
+	u32 encap_cfg = 0, decap_cfg = 0;
+	u32 port = cn_port->port;
+	u32 hdr_size;
+	int i;
+
+	NIC_WREG32(NIC0_TXE0_SOURCE_IP_PORT0_0 + encap_offset(encap_id), xa_pdata->src_ip);
+
+	encap_cfg |= xa_pdata->encap_type_data & NIC0_TXE0_ENCAP_CFG_IPV4_PROTOCOL_UDP_DEST_MASK;
+
+	if (xa_pdata->encap_type == HBL_CNI_ENCAP_NONE) {
+		NIC_WREG32(NIC0_TXE0_ENCAP_CFG_0 + encap_offset(encap_id), encap_cfg);
+		return 0;
+	}
+
+	if (!IS_ALIGNED(xa_pdata->encap_header_size, sizeof(u32))) {
+		dev_err(hdev->dev, "Encap header size(%d) must be a multiple of %ld\n",
+			xa_pdata->encap_header_size, sizeof(u32));
+		return -EINVAL;
+	}
+
+	hdr_size = xa_pdata->encap_header_size / sizeof(u32);
+	encap_cfg |= (hdr_size << NIC0_TXE0_ENCAP_CFG_ENCAP_SIZE_SHIFT) &
+			NIC0_TXE0_ENCAP_CFG_ENCAP_SIZE_MASK;
+
+	if (xa_pdata->encap_type == HBL_CNI_ENCAP_OVER_UDP) {
+		encap_cfg |= BIT(NIC0_TXE0_ENCAP_CFG_HDR_FORMAT_SHIFT);
+		if (!hdev->is_decap_disabled) {
+			decap_cfg |= NIC0_RXB_CORE_TNL_DECAP_UDP_VALID_MASK;
+			decap_cfg |= (xa_pdata->encap_type_data <<
+				      NIC0_RXB_CORE_TNL_DECAP_UDP_UDP_DEST_PORT_SHIFT) &
+				     NIC0_RXB_CORE_TNL_DECAP_UDP_UDP_DEST_PORT_MASK;
+			decap_cfg |= (hdr_size << NIC0_RXB_CORE_TNL_DECAP_UDP_TNL_SIZE_SHIFT) &
+				     NIC0_RXB_CORE_TNL_DECAP_UDP_TNL_SIZE_MASK;
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TNL_DECAP_UDP_0 + encap_offset(encap_id),
+					 decap_cfg);
+		}
+	} else if (xa_pdata->encap_type == HBL_CNI_ENCAP_OVER_IPV4) {
+		if (!hdev->is_decap_disabled) {
+			decap_cfg |= NIC0_RXB_CORE_TNL_DECAP_IPV4_VALID_MASK;
+			decap_cfg |= (xa_pdata->encap_type_data <<
+				      NIC0_RXB_CORE_TNL_DECAP_IPV4_IPV4_PROTOCOL_SHIFT) &
+				     NIC0_RXB_CORE_TNL_DECAP_IPV4_IPV4_PROTOCOL_MASK;
+			decap_cfg |= (hdr_size << NIC0_RXB_CORE_TNL_DECAP_IPV4_TNL_SIZE_SHIFT) &
+				     NIC0_RXB_CORE_TNL_DECAP_IPV4_TNL_SIZE_MASK;
+
+			NIC_MACRO_WREG32(NIC0_RXB_CORE_TNL_DECAP_IPV4_0 + encap_offset(encap_id),
+					 decap_cfg);
+		}
+	}
+
+	NIC_WREG32(NIC0_TXE0_ENCAP_CFG_0 + encap_offset(encap_id), encap_cfg);
+
+	/* Encapsulation header is already aligned to 32 bits. Hence, it's
+	 * safe to access it in chunks of 4 bytes.
+	 */
+	for (i = 0; i * sizeof(u32) < xa_pdata->encap_header_size; i++)
+		NIC_WREG32(NIC0_TXE0_ENCAP_DATA_31_0_0 + encap_hdr_offset * i +
+			   encap_offset(encap_id), encap_header[i]);
+
+	return 0;
+}
+
+static void gaudi2_encap_unset(struct hbl_cn_port *cn_port, u32 encap_id,
+			       struct hbl_cn_encap_xarray_pdata *xa_pdata)
+{
+	u32 encap_hdr_offset = NIC0_TXE0_ENCAP_DATA_63_32_0 - NIC0_TXE0_ENCAP_DATA_31_0_0;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	int i;
+
+	NIC_WREG32(NIC0_TXE0_SOURCE_IP_PORT0_0 + encap_offset(encap_id), 0);
+	NIC_WREG32(NIC0_TXE0_ENCAP_CFG_0 + encap_offset(encap_id), 0);
+
+	if (xa_pdata->encap_type == HBL_CNI_ENCAP_OVER_UDP)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_TNL_DECAP_UDP_0 + encap_offset(encap_id), 0);
+	else if (xa_pdata->encap_type == HBL_CNI_ENCAP_OVER_IPV4)
+		NIC_MACRO_WREG32(NIC0_RXB_CORE_TNL_DECAP_IPV4_0 + encap_offset(encap_id), 0);
+
+	for (i = 0; i * sizeof(u32) < xa_pdata->encap_header_size; i++)
+		NIC_WREG32(NIC0_TXE0_ENCAP_DATA_31_0_0 + encap_hdr_offset * i +
+			   encap_offset(encap_id), 0);
+}
+
+static u32 gaudi2_cn_get_default_port_speed(struct hbl_cn_device *hdev)
+{
+	return SPEED_100000;
+}
+
+static void gaudi2_cn_get_cnts_names(struct hbl_cn_port *cn_port, u8 *data, bool ext)
+{
+	char str[HBL_IB_CNT_NAME_LEN], *rx_fmt, *tx_fmt;
+	struct hbl_cn_stat *spmu_stats;
+	u32 n_spmu_stats;
+	int i, len;
+
+	if (ext) {
+		len = HBL_IB_CNT_NAME_LEN;
+		rx_fmt = "rx_%s";
+		tx_fmt = "tx_%s";
+	} else {
+		len = ETH_GSTRING_LEN;
+		rx_fmt = "%s";
+		tx_fmt = "%s";
+	}
+
+	hbl_cn_spmu_get_stats_info(cn_port, &spmu_stats, &n_spmu_stats);
+
+	for (i = 0; i < n_spmu_stats; i++)
+		memcpy(data + i * len, spmu_stats[i].str, ETH_GSTRING_LEN);
+	data += i * len;
+
+	if (!cn_port->hdev->skip_mac_cnts) {
+		for (i = 0; i < hbl_cn_mac_stats_rx_len; i++) {
+			memset(str, 0, len);
+			snprintf(str, len, rx_fmt, hbl_cn_mac_stats_rx[i].str);
+			memcpy(data + i * len, str, len);
+		}
+		data += i * len;
+
+		for (i = 0; i < gaudi2_cn_mac_fec_stats_len; i++)
+			memcpy(data + i * len, gaudi2_cn_mac_fec_stats[i].str, ETH_GSTRING_LEN);
+		data += i * len;
+
+		for (i = 0; i < hbl_cn_mac_stats_tx_len; i++) {
+			memset(str, 0, len);
+			snprintf(str, len, tx_fmt, hbl_cn_mac_stats_tx[i].str);
+			memcpy(data + i * len, str, len);
+		}
+		data += i * len;
+	}
+
+	for (i = 0; i < gaudi2_cn_err_stats_len; i++)
+		memcpy(data + i * len, gaudi2_cn_err_stats[i].str, ETH_GSTRING_LEN);
+	data += i * len;
+
+	for (i = 0; i < gaudi2_cn_perf_stats_len; i++)
+		memcpy(data + i * len, gaudi2_cn_perf_stats[i].str, ETH_GSTRING_LEN);
+}
+
+static int gaudi2_cn_get_cnts_num(struct hbl_cn_port *cn_port)
+{
+	int n_spmu_stats, mac_counters;
+	struct hbl_cn_stat *ignore;
+
+	hbl_cn_spmu_get_stats_info(cn_port, &ignore, &n_spmu_stats);
+
+	mac_counters = !cn_port->hdev->skip_mac_cnts ? hbl_cn_mac_stats_rx_len +
+		       hbl_cn_mac_stats_tx_len + gaudi2_cn_mac_fec_stats_len : 0;
+
+	return n_spmu_stats + mac_counters + gaudi2_cn_err_stats_len + gaudi2_cn_perf_stats_len;
+}
+
+static int gaudi2_cn_get_mac_tx_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u64 start_reg, lo_part, hi_part;
+	u32 port = cn_port->port;
+	int i;
+
+	start_reg = (port & 1) ? NIC0_MAC_GLOB_STAT_TX2_ETHERSTATSOCTETS_6 :
+		    NIC0_MAC_GLOB_STAT_TX0_ETHERSTATSOCTETS_4;
+
+	for (i = 0; i < hbl_cn_mac_stats_tx_len; i++) {
+		lo_part = NIC_MACRO_RREG32(start_reg + hbl_cn_mac_stats_tx[i].lo_offset);
+		/* Upper part must be read after lower part, since the upper part register
+		 * gets its value only after the lower part was read.
+		 */
+		hi_part = NIC_MACRO_RREG32(NIC0_MAC_GLOB_STAT_CONTROL_REG_DATA_HI);
+
+		data[i] = lo_part | (hi_part << 32);
+	}
+
+	return i;
+}
+
+static int gaudi2_cn_get_mac_rx_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u64 start_reg, lo_part, hi_part;
+	u32 port = cn_port->port;
+	int i;
+
+	start_reg = (port & 1) ? NIC0_MAC_GLOB_STAT_RX2_ETHERSTATSOCTETS_2 :
+		    NIC0_MAC_GLOB_STAT_RX0_ETHERSTATSOCTETS;
+
+	for (i = 0; i < hbl_cn_mac_stats_rx_len; i++) {
+		lo_part = NIC_MACRO_RREG32(start_reg + hbl_cn_mac_stats_rx[i].lo_offset);
+		/* Upper part must be read after lower part, since the upper part register
+		 * gets its value only after the lower part was read.
+		 */
+		hi_part = NIC_MACRO_RREG32(NIC0_MAC_GLOB_STAT_CONTROL_REG_DATA_HI);
+
+		data[i] = lo_part | (hi_part << 32);
+	}
+
+	return i;
+}
+
+static int __gaudi2_cn_get_mac_fec_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	u64 start_jiffies, diff_ms, numerator, denominator, integer, exp;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	int i;
+
+	if (!data)
+		return 0;
+
+	/* Read the relevant registers in order to clear them */
+	if (port & 1) {
+		cn_port->correctable_errors_cnt +=
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_CCW_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_CCW_HI) << 16);
+		cn_port->uncorrectable_errors_cnt +=
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_NCCW_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_NCCW_HI) << 16);
+
+		for (i = 0; i < 8; i++)
+			NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR4_LO + 4 * i);
+	} else {
+		cn_port->correctable_errors_cnt +=
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_CCW_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_CCW_HI) << 16);
+		cn_port->uncorrectable_errors_cnt +=
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_NCCW_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_NCCW_HI) << 16);
+
+		for (i = 0; i < 8; i++)
+			NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR0_LO + 4 * i);
+	}
+
+	start_jiffies = jiffies;
+
+	/* sleep some time to accumulate stats */
+	msleep(hdev->accumulate_fec_duration);
+
+	diff_ms = jiffies_to_msecs(jiffies - start_jiffies);
+
+	if (port & 1) {
+		data[FEC_CW_CORRECTED] = NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_CCW_LO) |
+					 (NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_CCW_HI) << 16);
+		data[FEC_CW_UNCORRECTED] = NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_NCCW_LO) |
+					   (NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC2_NCCW_HI) <<
+					    16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_0] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR4_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR4_HI) <<
+					 16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_1] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR5_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR5_HI) <<
+					 16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_2] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR6_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR6_HI) <<
+					 16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_3] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR7_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR7_HI) <<
+					 16);
+	} else {
+		data[FEC_CW_CORRECTED] = NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_CCW_LO) |
+					 (NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_CCW_HI) << 16);
+		data[FEC_CW_UNCORRECTED] = NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_NCCW_LO) |
+					   (NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_NCCW_HI) <<
+					    16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_0] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR0_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR0_HI) <<
+					 16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_1] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR1_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR1_HI) <<
+					 16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_2] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR2_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR2_HI) <<
+					 16);
+		data[FEC_SYMBOL_ERR_CORRECTED_LANE_3] =
+					NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR3_LO) |
+					(NIC_MACRO_RREG32(NIC0_MAC_RS_FEC_RSFEC_SYMBLERR3_HI) <<
+					 16);
+	}
+
+	cn_port->correctable_errors_cnt += data[FEC_CW_CORRECTED];
+	cn_port->uncorrectable_errors_cnt += data[FEC_CW_UNCORRECTED];
+
+	data[FEC_CW_CORRECTED_ACCUM] = cn_port->correctable_errors_cnt;
+	data[FEC_CW_UNCORRECTED_ACCUM] = cn_port->uncorrectable_errors_cnt;
+
+	/* The denominator is the total number of symbols in the measured time T ms
+	 * (100G bits/sec = 10G sym/sec = 10G * T/1000 sym = 1G * T / 100 sym)
+	 */
+	denominator = div_u64((u64)BIT(30) * diff_ms, 100);
+
+	/* Pre FEC: the numerator is the sum of uncorrected symbols (~= uncorrected_cw * 16) and
+	 * corrected symbols.
+	 */
+	numerator = data[FEC_CW_UNCORRECTED] << 4;
+	for (i = 0; i < 4; i++)
+		numerator += data[FEC_SYMBOL_ERR_CORRECTED_LANE_0 + i];
+
+	hbl_cn_get_frac_info(numerator, denominator, &integer, &exp);
+
+	data[FEC_PRE_FEC_SER_INT] = integer;
+	data[FEC_PRE_FEC_SER_EXP] = exp;
+
+	/* Post FEC: the numerator is the uncorrected symbols (~= uncorrected_cw * 16) */
+	numerator = data[FEC_CW_UNCORRECTED] << 4;
+
+	hbl_cn_get_frac_info(numerator, denominator, &integer, &exp);
+
+	data[FEC_POST_FEC_SER_INT] = integer;
+	data[FEC_POST_FEC_SER_EXP] = exp;
+
+	return (int)gaudi2_cn_mac_fec_stats_len;
+}
+
+static int gaudi2_cn_get_mac_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	int cnt = 0;
+
+	if (cn_port->hdev->skip_mac_cnts)
+		return 0;
+
+	cnt += gaudi2_cn_get_mac_rx_stats(cn_port, &data[cnt]);
+	cnt += __gaudi2_cn_get_mac_fec_stats(cn_port, &data[cnt]);
+	cnt += gaudi2_cn_get_mac_tx_stats(cn_port, &data[cnt]);
+
+	return cnt;
+}
+
+static int gaudi2_cn_get_err_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	struct gaudi2_en_aux_ops *gaudi2_en_aux_ops;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_cn_device *gaudi2;
+	struct hbl_aux_dev *aux_dev;
+	int i = 0;
+
+	gaudi2 = hdev->asic_specific;
+	aux_dev = &hdev->en_aux_dev;
+	gaudi2_en_aux_ops = &gaudi2->en_aux_ops;
+
+	data[i++] = cn_port->cong_q_err_cnt;
+
+	if (cn_port->eth_enable && gaudi2_en_aux_ops->get_overrun_cnt)
+		data[i++] = gaudi2_en_aux_ops->get_overrun_cnt(aux_dev, cn_port->port);
+	else
+		data[i++] = 0;
+
+	return i;
+}
+
+static int gaudi2_cn_get_perf_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	u64 lat_dividend, lat_divisor, lat_int, lat_frac;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct hbl_cn_properties *cn_prop;
+	u64 bw_dividend, bw_int, bw_frac;
+	u32 port = cn_port->port;
+
+	cn_prop = &hdev->cn_props;
+
+	/* Bandwidth calculation */
+	bw_dividend = (((u64)NIC_RREG32(NIC0_TXE0_STATS_MEAS_WIN_BYTES_MSB)) << 32) |
+		      NIC_RREG32(NIC0_TXE0_STATS_MEAS_WIN_BYTES_LSB);
+
+	/* bytes to bits */
+	bw_dividend *= BITS_PER_BYTE;
+
+	bw_int = div_u64(bw_dividend, PERF_BW_WINDOW_DIV);
+	bw_frac = ((bw_dividend - PERF_BW_WINDOW_DIV * bw_int) * 10) / PERF_BW_WINDOW_DIV;
+
+	/* In case there is no traffic (BW=0), the latency will show the last measured value (when
+	 * there was traffic). Therefore, we need to clear it.
+	 */
+	if (bw_int == 0 && bw_frac == 0) {
+		lat_int = 0;
+		lat_frac = 0;
+	} else {
+		/* Latency calculation */
+		lat_dividend = (((u64)NIC_RREG32(NIC0_TXE0_STATS_TOT_BYTES_MSB)) << 32) |
+			       NIC_RREG32(NIC0_TXE0_STATS_TOT_BYTES_LSB);
+		lat_divisor = cn_prop->clk;
+
+		lat_int = div_u64(lat_dividend, lat_divisor);
+		lat_frac = ((lat_dividend - lat_divisor * lat_int) * 10) / lat_divisor;
+	}
+
+	data[PERF_BANDWIDTH_INT] = bw_int;
+	data[PERF_BANDWIDTH_FRAC] = bw_frac;
+	data[PERF_LATENCY_INT] = lat_int;
+	data[PERF_LATENCY_FRAC] = lat_frac;
+
+	return (int)gaudi2_cn_perf_stats_len;
+}
+
+static void gaudi2_cn_get_cnts_values(struct hbl_cn_port *cn_port, u64 *data)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 cnt = 0;
+	int rc;
+
+	rc = hbl_cn_read_spmu_counters(cn_port, &data[cnt], &cnt);
+	if (rc)
+		dev_err(hdev->dev, "Failed to get SPMU counters, port %d\n", cn_port->port);
+
+	cnt += gaudi2_cn_get_mac_stats(cn_port, &data[cnt]);
+	cnt += gaudi2_cn_get_err_stats(cn_port, &data[cnt]);
+	cnt += gaudi2_cn_get_perf_stats(cn_port, &data[cnt]);
+}
+
+static void gaudi2_cn_reset_mac_stats(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	NIC_MACRO_WREG32(NIC0_MAC_GLOB_STAT_CONTROL_REG_STATN_CONFIG,
+			 BIT(NIC0_MAC_GLOB_STAT_CONTROL_REG_STATN_CONFIG_F_RESET_SHIFT));
+}
+
+void gaudi2_cn_get_mac_fec_stats(struct hbl_cn_port *cn_port, u64 *data)
+{
+	__gaudi2_cn_get_mac_fec_stats(cn_port, data);
+}
+
+/* HW bug: QP stuck in limited state in case there is a race between timeout and receive ACK.
+ * Description: When timeout occurs QPC resets NTS to ONA. If an ACK arives to the RX, the RX reads
+ * the QPC and timeout occurs after the read response to the RX and before the RX update indication,
+ * the NTS will rollback to the ONA.
+ * After the RX handles the ACK, it will do an update, and may advance the ONA ahead of the NTS.
+ * In this case the QP will go into limited state forever: NTS - ONA > congestion window
+ */
+static void __qpc_sanity_check(struct gaudi2_cn_port *gaudi2_port, u32 qpn)
+{
+	u32 ona_psn, nts_psn, in_work, bcs_psn, bcc_psn, ona_rem_pi, consumer_idx, execution_idx,
+	    is_valid, port, wq_type;
+	int rc, retry_cnt_in_work = 0, retry_cnt_qpc_timeout = 0;
+	struct gaudi2_qpc_requester req_qpc = {};
+	struct qpc_mask qpc_mask = {};
+	struct hbl_cn_port *cn_port;
+	struct hbl_cn_device *hdev;
+
+	cn_port = gaudi2_port->cn_port;
+	hdev = cn_port->hdev;
+	port = cn_port->port;
+
+retry:
+	rc = gaudi2_cn_qpc_read(cn_port, (void *)&req_qpc, qpn, true);
+	if (rc) {
+		dev_err_ratelimited(hdev->dev, "Requester port %d QPC %d read failed\n", port, qpn);
+		return;
+	}
+
+	is_valid = REQ_QPC_GET_VALID(req_qpc);
+	if (!is_valid)
+		return;
+
+	/* When the timeout retry counter is non zero, an ack could potentially arrive and increase
+	 * ONA, after QPC was read.
+	 */
+	if (REQ_QPC_GET_TIMEOUT_RETRY_COUNT(req_qpc)) {
+		if (retry_cnt_qpc_timeout < RETRY_COUNT_QPC_SANITY) {
+			dev_dbg(hdev->dev, "QPC timeout retry count > 0, trying again #%d\n",
+				retry_cnt_qpc_timeout);
+			usleep_range(1000, 1500);
+			retry_cnt_qpc_timeout++;
+			goto retry;
+		} else {
+			dev_dbg(hdev->dev,
+				"Can't apply fix. QPC timeout retry count > 0, after %d QPC reads",
+				retry_cnt_qpc_timeout);
+			return;
+		}
+	}
+
+	in_work = REQ_QPC_GET_IN_WORK(req_qpc);
+
+	ona_psn = REQ_QPC_GET_ONA_PSN(req_qpc);
+	nts_psn = REQ_QPC_GET_NTS_PSN(req_qpc);
+
+	bcs_psn = REQ_QPC_GET_BCS_PSN(req_qpc);
+	bcc_psn = REQ_QPC_GET_BCC_PSN(req_qpc);
+
+	consumer_idx = REQ_QPC_GET_CONSUMER_IDX(req_qpc);
+	execution_idx = REQ_QPC_GET_EXECUTION_IDX(req_qpc);
+
+	ona_rem_pi = REQ_QPC_GET_OLDEST_UNACKED_REMOTE_PRODUCER_IDX(req_qpc);
+
+	wq_type = REQ_QPC_GET_WQ_TYPE(req_qpc);
+
+	/* We hit the HW bug. Unacknowledged PSN can never be greater than next
+	 * PSN to be sent out.
+	 */
+	if (NIC_IS_PSN_CYCLIC_BIG(ona_psn, nts_psn)) {
+		struct hbl_cn_eqe eqe;
+
+		dev_dbg(hdev->dev,
+			"ona_psn(%d) nts_psn(%d), bcc_psn(%d) bcs_psn(%d), consumer_idx(%d) execution_idx(%d). Retry_cnt %d\n",
+			ona_psn, nts_psn, bcc_psn, bcs_psn, consumer_idx, execution_idx,
+			retry_cnt_in_work);
+
+		/* Wait till HW stops working on QPC. */
+		if (in_work && retry_cnt_in_work < RETRY_COUNT_QPC_SANITY) {
+			usleep_range(1000, 1500);
+			retry_cnt_in_work++;
+			goto retry;
+		}
+
+		dev_dbg(hdev->dev, "Port %d QP %d in limited state. Applying fix.\n", port, qpn);
+
+		/* Force update QPC fields. */
+
+		REQ_QPC_SET_NTS_PSN(qpc_mask, 0xffffff);
+		REQ_QPC_SET_BCS_PSN(qpc_mask, 0xffffff);
+		REQ_QPC_SET_EXECUTION_IDX(qpc_mask, 0x3fffff);
+		if (wq_type == QPC_REQ_WQ_TYPE_WRITE)
+			REQ_QPC_SET_REMOTE_PRODUCER_IDX(qpc_mask, 0x3fffff);
+
+		REQ_QPC_SET_NTS_PSN(req_qpc, ona_psn);
+		REQ_QPC_SET_BCS_PSN(req_qpc, bcc_psn);
+		REQ_QPC_SET_EXECUTION_IDX(req_qpc, consumer_idx);
+		if (wq_type == QPC_REQ_WQ_TYPE_WRITE)
+			REQ_QPC_SET_REMOTE_PRODUCER_IDX(req_qpc, ona_rem_pi);
+
+		rc = gaudi2_cn_qpc_write_masked(cn_port, (void *)&req_qpc, &qpc_mask, qpn, true,
+						true);
+		if (rc)
+			dev_err(hdev->dev, "Requester port %d QPC %d write failed\n", port, qpn);
+
+		eqe.data[0] = EQE_HEADER(true, EQE_QP_ALIGN_COUNTERS);
+		eqe.data[1] = qpn;
+
+		rc = hbl_cn_eq_dispatcher_enqueue(cn_port, &eqe);
+		if (rc)
+			dev_err(hdev->dev, "port %d QPC %d failed dispatching EQ event %d\n", port,
+				qpn, EQE_QP_ALIGN_COUNTERS);
+	}
+}
+
+/* We sanitize one QP at a time since it's high latency operation,
+ * too heavy to do it in one shot. We mitigate this via interleaving
+ * with thread scheduling.
+ */
+static void gaudi2_qp_sanity_work(struct work_struct *work)
+{
+	struct gaudi2_cn_port *gaudi2_port = container_of(work, struct gaudi2_cn_port,
+							  qp_sanity_work.work);
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	unsigned long qp_id = 0;
+	u32 timeout_cnt, port;
+	struct hbl_cn_qp *qp;
+
+	port = cn_port->port;
+	timeout_cnt = NIC_RREG32(NIC0_QPC0_NUM_TIMEOUTS);
+
+	if (gaudi2_port->qp_timeout_cnt == timeout_cnt)
+		goto done;
+
+	gaudi2_port->qp_timeout_cnt = timeout_cnt;
+
+	mutex_lock(&gaudi2_port->cfg_lock);
+	xa_for_each(&cn_port->qp_ids, qp_id, qp)
+		if (qp && qp->is_req)
+			__qpc_sanity_check(gaudi2_port, qp_id);
+	mutex_unlock(&gaudi2_port->cfg_lock);
+
+done:
+	queue_delayed_work(gaudi2_port->qp_sanity_wq, &gaudi2_port->qp_sanity_work,
+			   msecs_to_jiffies(QPC_SANITY_CHECK_INTERVAL_MS));
+}
+
+static int gaudi2_qp_sanity_init(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+	char wq_name[30] = {0};
+
+	/* The qp sanity work is relevant only for external ports */
+	if (!cn_port->eth_enable)
+		return 0;
+
+	snprintf(wq_name, sizeof(wq_name) - 1, "hbl%u-cn%d-qp-sanity", hdev->id, port);
+
+	gaudi2_port->qp_sanity_wq = alloc_ordered_workqueue(wq_name, 0);
+	if (!gaudi2_port->qp_sanity_wq) {
+		dev_err(hdev->dev, "Failed to create QP sanity WQ, port: %d\n", port);
+		return -ENOMEM;
+	}
+
+	INIT_DELAYED_WORK(&gaudi2_port->qp_sanity_work, gaudi2_qp_sanity_work);
+	queue_delayed_work(gaudi2_port->qp_sanity_wq, &gaudi2_port->qp_sanity_work,
+			   msecs_to_jiffies(QPC_SANITY_CHECK_INTERVAL_MS));
+
+	return 0;
+}
+
+static void gaudi2_qp_sanity_fini(struct gaudi2_cn_port *gaudi2_port)
+{
+	if (!gaudi2_port->qp_sanity_wq)
+		return;
+
+	cancel_delayed_work_sync(&gaudi2_port->qp_sanity_work);
+	destroy_workqueue(gaudi2_port->qp_sanity_wq);
+}
+
+static void gaudi2_cn_user_ccq_set(struct hbl_cn_port *cn_port, u64 ccq_device_addr,
+				   u64 pi_device_addr, u32 num_of_entries, u32 *ccqn)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	WARN_ON_CACHE_UNALIGNED(ccq_device_addr);
+	WARN_ON_CACHE_UNALIGNED(pi_device_addr);
+
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_BASE_ADDR_63_32, upper_32_bits(ccq_device_addr));
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_BASE_ADDR_31_7, ((ccq_device_addr >> 7) & 0x1FFFFFF));
+
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_PI_ADDR_63_32, upper_32_bits(pi_device_addr));
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_PI_ADDR_31_7, ((pi_device_addr >> 7) & 0x1FFFFFF));
+
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_WRITE_INDEX, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_PRODUCER_INDEX, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_CONSUMER_INDEX, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_CONSUMER_INDEX_CB, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_LOG_SIZE, ilog2(num_of_entries));
+
+	/* set enable + update-pi
+	 * set overrun-en to allow overrun of ci since a HW bug exist
+	 * in Gaudi2 which prevents updating ci.
+	 */
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_CFG, NIC0_QPC0_CONG_QUE_CFG_ENABLE_MASK |
+		   NIC0_QPC0_CONG_QUE_CFG_OVERRUN_EN_MASK |
+		   NIC0_QPC0_CONG_QUE_CFG_WRITE_PI_EN_MASK);
+
+	/* gaudi2 has only 1 CCQ. Therefore, set 0 as ccqn. */
+	*ccqn = 0;
+}
+
+static void  gaudi2_cn_user_ccq_unset(struct hbl_cn_port *cn_port, u32 *ccqn)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_CFG, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_PI_ADDR_63_32, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_PI_ADDR_31_7, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_BASE_ADDR_63_32, 0);
+	NIC_WREG32(NIC0_QPC0_CONG_QUE_BASE_ADDR_31_7, 0);
+
+	/* gaudi2 has only 1 CCQ. Therefore, set 0 as ccqn. */
+	*ccqn = 0;
+}
+
+static void gaudi2_cn_get_spmu_data(struct hbl_cn_port *cn_port, struct hbl_cn_cpucp_status *status)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u64 spmu_data[NIC_SPMU_STATS_LEN_MAX];
+	u32 port = cn_port->port, ignore;
+	int rc;
+
+	memset(spmu_data, 0, sizeof(spmu_data));
+
+	rc = hbl_cn_read_spmu_counters(cn_port, spmu_data, &ignore);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to get SPMU counters, port %d, %d\n", port, rc);
+		return;
+	}
+
+	status->bad_format_cnt = 0;
+	status->responder_out_of_sequence_psn_cnt = spmu_data[3];
+}
+
+static void gaudi2_cn_get_fec_status(struct hbl_cn_port *cn_port,
+				     struct hbl_cn_cpucp_status *status)
+{
+	u64 fec_data[FEC_STAT_LAST];
+
+	memset(fec_data, 0, sizeof(fec_data));
+
+	gaudi2_cn_get_mac_fec_stats(cn_port, fec_data);
+
+	status->correctable_err_cnt = fec_data[FEC_CW_CORRECTED_ACCUM];
+	status->uncorrectable_err_cnt = fec_data[FEC_CW_UNCORRECTED_ACCUM];
+	status->pre_fec_ser.integer = fec_data[FEC_PRE_FEC_SER_INT];
+	status->pre_fec_ser.exp = fec_data[FEC_PRE_FEC_SER_EXP];
+	status->post_fec_ser.integer = fec_data[FEC_POST_FEC_SER_INT];
+	status->post_fec_ser.exp = fec_data[FEC_POST_FEC_SER_EXP];
+}
+
+static void gaudi2_cn_get_perf_status(struct hbl_cn_port *cn_port,
+				      struct hbl_cn_cpucp_status *status)
+{
+	u64 perf_data[PERF_STAT_LAST];
+
+	memset(perf_data, 0, sizeof(perf_data));
+
+	gaudi2_cn_get_perf_stats(cn_port, perf_data);
+
+	status->bandwidth.integer = perf_data[PERF_BANDWIDTH_INT];
+	status->bandwidth.frac = perf_data[PERF_BANDWIDTH_FRAC];
+	status->lat.integer = perf_data[PERF_LATENCY_INT];
+	status->lat.frac = perf_data[PERF_LATENCY_FRAC];
+}
+
+static u32 gaudi2_cn_get_timeout_retransmission_cnt(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	return NIC_RREG32(NIC0_QPC0_NUM_TIMEOUTS);
+}
+
+static u32 gaudi2_cn_get_high_ber_cnt(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	if (port & 1)
+		return NIC_RREG32(NIC0_MAC_CH2_MAC_PCS_BER_HIGH_ORDER_CNT);
+	else
+		return NIC_RREG32(NIC0_MAC_CH0_MAC_PCS_BER_HIGH_ORDER_CNT);
+}
+
+static void gaudi2_cn_get_status(struct hbl_cn_port *cn_port, struct hbl_cn_cpucp_status *status)
+{
+	u32 timeout_retransmission_cnt, high_ber_cnt;
+
+	gaudi2_cn_get_spmu_data(cn_port, status);
+	gaudi2_cn_get_fec_status(cn_port, status);
+	gaudi2_cn_get_perf_status(cn_port, status);
+
+	timeout_retransmission_cnt = gaudi2_cn_get_timeout_retransmission_cnt(cn_port);
+	high_ber_cnt = gaudi2_cn_get_high_ber_cnt(cn_port);
+
+	status->timeout_retransmission_cnt = timeout_retransmission_cnt;
+	status->high_ber_cnt = high_ber_cnt;
+}
+
+static void gaudi2_cn_cfg_lock(struct hbl_cn_port *cn_port)
+	__acquires(&gaudi2_port->cfg_lock)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+
+	mutex_lock(&gaudi2_port->cfg_lock);
+}
+
+static void gaudi2_cn_cfg_unlock(struct hbl_cn_port *cn_port)
+	__releases(&gaudi2_port->cfg_lock)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+
+	mutex_unlock(&gaudi2_port->cfg_lock);
+}
+
+static bool gaudi2_cn_cfg_is_locked(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+
+	return mutex_is_locked(&gaudi2_port->cfg_lock);
+}
+
+static u32 gaudi2_cn_get_max_msg_sz(struct hbl_cn_device *hdev)
+{
+	return SZ_1G;
+}
+
+static void gaudi2_cn_app_params_clear(struct hbl_cn_device *hdev)
+{
+}
+
+static void gaudi2_cn_set_port_status(struct hbl_cn_port *cn_port, bool up)
+{
+	cn_port->link_eqe.data[2] = !!up;
+}
+
+static void gaudi2_cn_adaptive_tmr_reset(struct hbl_cn_qp *qp)
+{
+	struct hbl_cn_port *cn_port = qp->cn_port;
+	struct hbl_cn_asic_port_funcs *port_funcs;
+	struct gaudi2_qpc_requester req_qpc;
+	struct hbl_cn_device *hdev;
+	u64 retry_count;
+	u8 user_gran;
+	u32 rc;
+
+	hdev = cn_port->hdev;
+	user_gran = qp->timeout_granularity - NIC_ADAPTIVE_TIMEOUT_RANGE / 2;
+
+	port_funcs = hdev->asic_funcs->port_funcs;
+
+	port_funcs->cfg_lock(cn_port);
+	rc = gaudi2_cn_qpc_read(cn_port, &req_qpc, qp->qp_id, true);
+
+	if (rc)
+		goto out;
+
+	retry_count = REQ_QPC_GET_TIMEOUT_RETRY_COUNT(req_qpc);
+
+	if (!retry_count) {
+		if (qp->timeout_curr != user_gran)
+			qp->timeout_curr = user_gran;
+	} else if (qp->timeout_curr == user_gran) {
+		dev_err(hdev->dev, "Retry count is %lld, but current gran is already reset\n",
+			retry_count);
+	} else if (!REQ_QPC_GET_ERROR(req_qpc)) {
+		queue_delayed_work(cn_port->qp_wq, &qp->adaptive_tmr_reset,
+				   msecs_to_jiffies(5));
+	}
+
+out:
+	port_funcs->cfg_unlock(cn_port);
+}
+
+static int gaudi2_cn_send_cpucp_packet(struct hbl_cn_port *cn_port, enum cpucp_packet_id packet_id,
+				       int val)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct cpucp_packet pkt;
+	u32 port;
+	int rc;
+
+	port = cn_port->port;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.ctl = cpu_to_le32(packet_id << CPUCP_PKT_CTL_OPCODE_SHIFT);
+	pkt.value = cpu_to_le64(val);
+	pkt.macro_index = cpu_to_le32(port);
+
+	rc = gaudi2_cn_send_cpu_message(hdev, (u32 *)&pkt, sizeof(pkt), 0, NULL);
+	if (rc)
+		dev_err(hdev->dev,
+			"Failed to send cpucp packet, port %d packet id %d, val %d, error %d\n",
+			port, packet_id, val, rc);
+
+	return rc;
+}
+
+static void gaudi2_cn_spmu_get_stats_info(struct hbl_cn_port *cn_port, struct hbl_cn_stat **stats,
+					  u32 *n_stats)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+
+	aux_dev = cn_port->hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	gaudi2_aux_ops->spmu_get_stats_info(aux_dev, cn_port->port, stats, n_stats);
+}
+
+static int gaudi2_cn_spmu_config(struct hbl_cn_port *cn_port, u32 num_event_types,
+				 u32 event_types[], bool enable)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+
+	aux_dev = cn_port->hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	return gaudi2_aux_ops->spmu_config(aux_dev, cn_port->port, num_event_types, event_types,
+					   enable);
+}
+
+static int gaudi2_cn_spmu_sample(struct hbl_cn_port *cn_port, u32 num_out_data, u64 out_data[])
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+
+	aux_dev = cn_port->hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	return gaudi2_aux_ops->spmu_sample(aux_dev, cn_port->port, num_out_data, out_data);
+}
+
+static void gaudi2_cn_post_send_status(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+	struct hbl_cn_aux_ops *aux_ops;
+	struct hbl_aux_dev *aux_dev;
+
+	aux_dev = cn_port->hdev->cn_aux_dev;
+	aux_ops = aux_dev->aux_ops;
+	gaudi2_aux_ops = aux_ops->asic_ops;
+
+	gaudi2_aux_ops->post_send_status(aux_dev, cn_port->port);
+}
+
+static int gaudi2_cn_inject_rx_err(struct hbl_cn_device *hdev, u8 drop_percent)
+{
+	/* NoOps */
+	return 0;
+}
+
+static bool gaudi2_cn_is_encap_supported(struct hbl_cn_device *hdev,
+					 struct hbl_cni_user_encap_set_in *in)
+{
+	if (in->encap_type != HBL_CNI_ENCAP_OVER_UDP) {
+		dev_dbg(hdev->dev, "Encap type %u is not supported\n", in->encap_type);
+		return false;
+	}
+
+	if (in->tnl_hdr_size != NIC_MAX_TNL_HDR_SIZE) {
+		dev_dbg(hdev->dev, "Encap hdr-size must be %d\n", NIC_MAX_TNL_HDR_SIZE);
+		return false;
+	}
+
+	return true;
+}
+
+static int gaudi2_cn_set_static_properties(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_properties *cn_prop = &hdev->cn_props;
+	struct hbl_cn_aux_data *cn_aux_data;
+	struct hbl_aux_dev *cn_aux_dev;
+
+	cn_aux_dev = hdev->cn_aux_dev;
+	cn_aux_data = cn_aux_dev->aux_data;
+
+	cn_prop->max_num_of_ports = NIC_NUMBER_OF_PORTS;
+	cn_prop->macro_cfg_size = cn_aux_data->macro_cfg_size;
+	cn_prop->txs_base_size = TXS_TOTAL_PORT_SIZE;
+	cn_prop->tmr_base_size = TMR_TOTAL_MACRO_SIZE;
+	cn_prop->req_qpc_base_size = REQ_QPC_TOTAL_PORT_SIZE;
+	cn_prop->res_qpc_base_size = RES_QPC_TOTAL_PORT_SIZE;
+	cn_prop->clk = cn_aux_data->clk;
+
+	return 0;
+}
+
+static int gaudi2_cn_set_dram_properties(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_properties *cn_prop = &hdev->cn_props;
+	struct hbl_cn_aux_data *cn_aux_data;
+	struct hbl_aux_dev *cn_aux_dev;
+	u64 nic_drv_addr, nic_drv_size;
+
+	cn_aux_dev = hdev->cn_aux_dev;
+	cn_aux_data = cn_aux_dev->aux_data;
+	nic_drv_addr = cn_aux_data->nic_drv_addr;
+	nic_drv_size = cn_aux_data->nic_drv_size;
+
+	cn_prop->nic_drv_addr = nic_drv_addr;
+	cn_prop->nic_drv_base_addr = NIC_DRV_BASE_ADDR(nic_drv_addr);
+	cn_prop->nic_drv_end_addr = NIC_DRV_END_ADDR(nic_drv_addr, nic_drv_size);
+	cn_prop->wq_base_addr = WQ_BASE_ADDR(nic_drv_addr);
+	cn_prop->txs_base_addr = TXS_BASE_ADDR(nic_drv_addr);
+	cn_prop->tmr_base_addr = TMR_BASE_ADDR(nic_drv_addr);
+	cn_prop->req_qpc_base_addr = REQ_QPC_BASE_ADDR(nic_drv_addr);
+	cn_prop->res_qpc_base_addr = RES_QPC_BASE_ADDR(nic_drv_addr);
+	cn_prop->nic_drv_size = nic_drv_size;
+	cn_prop->wq_base_size = WQ_BASE_SIZE(nic_drv_addr, nic_drv_size);
+
+	return 0;
+}
+
+static void gaudi2_cn_late_init(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_cn_aux_ops;
+	struct hbl_cn_aux_ops *cn_aux_ops;
+
+	cn_aux_ops = hdev->cn_aux_dev->aux_ops;
+	gaudi2_cn_aux_ops = cn_aux_ops->asic_ops;
+
+	/* compute2cn */
+	gaudi2_cn_aux_ops->reset_prepare = gaudi2_cn_compute_reset_prepare;
+	gaudi2_cn_aux_ops->reset_late_init = gaudi2_cn_compute_reset_late_init;
+	gaudi2_cn_aux_ops->sw_err_event_handler = gaudi2_cn_sw_err_event;
+	gaudi2_cn_aux_ops->axi_error_response_event_handler = gaudi2_cn_axi_error_response_event;
+	gaudi2_cn_aux_ops->ports_stop_prepare = hbl_cn_hard_reset_prepare;
+	gaudi2_cn_aux_ops->send_port_cpucp_status = hbl_cn_send_port_cpucp_status;
+}
+
+static void gaudi2_cn_late_fini(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_aux_ops *gaudi2_cn_aux_ops;
+	struct hbl_cn_aux_ops *cn_aux_ops;
+
+	cn_aux_ops = hdev->cn_aux_dev->aux_ops;
+	gaudi2_cn_aux_ops = cn_aux_ops->asic_ops;
+
+	/* compute2cn */
+	gaudi2_cn_aux_ops->reset_prepare = NULL;
+	gaudi2_cn_aux_ops->reset_late_init = NULL;
+	gaudi2_cn_aux_ops->sw_err_event_handler = NULL;
+	gaudi2_cn_aux_ops->axi_error_response_event_handler = NULL;
+	gaudi2_cn_aux_ops->ports_stop_prepare = NULL;
+	gaudi2_cn_aux_ops->send_port_cpucp_status = NULL;
+}
+
+static int gaudi2_cn_get_hw_block_handle(struct hbl_cn_device *hdev, u64 address, u64 *handle)
+{
+	hbl_cn_get_self_hw_block_handle(hdev, address, handle);
+
+	return 0;
+}
+
+static int gaudi2_cn_get_hw_block_addr(struct hbl_cn_device *hdev, u64 handle, u64 *addr, u64 *size)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	u32 reg;
+	int rc;
+
+	*size = HBL_CN_BLOCK_SIZE;
+	reg = hbl_cn_hw_block_handle_to_addr32(hdev, handle) - lower_32_bits(gaudi2->cfg_base);
+
+	rc = hbl_cn_get_reg_pcie_addr(hdev, CFG_BAR_ID, reg, addr);
+	if (rc)
+		dev_err(hdev->dev, "Failed to get hw block address for register 0x%x", reg);
+
+	return rc;
+}
+
+static struct hbl_cn_asic_port_funcs gaudi2_cn_port_funcs = {
+	.port_hw_init = gaudi2_cn_port_hw_init,
+	.port_hw_fini = gaudi2_cn_port_hw_fini,
+	.phy_port_init = gaudi2_cn_phy_port_init,
+	.phy_port_start_stop = gaudi2_cn_phy_port_start_stop,
+	.phy_port_power_up = gaudi2_cn_phy_port_power_up,
+	.phy_port_reconfig = gaudi2_cn_phy_port_reconfig,
+	.phy_port_fini = gaudi2_cn_phy_port_fini,
+	.phy_link_status_work = gaudi2_cn_phy_link_status_work,
+	.update_qp_mtu = gaudi2_cn_update_qp_mtu,
+	.user_wq_arr_unset = gaudi2_user_wq_arr_unset,
+	.get_cq_id_range = gaudi2_get_cq_id_range,
+	.user_cq_set = gaudi2_user_cq_set,
+	.user_cq_unset = gaudi2_user_cq_unset,
+	.user_cq_destroy = gaudi2_user_cq_destroy,
+	.get_cnts_num = gaudi2_cn_get_cnts_num,
+	.get_cnts_names = gaudi2_cn_get_cnts_names,
+	.get_cnts_values = gaudi2_cn_get_cnts_values,
+	.port_sw_init = gaudi2_cn_port_sw_init,
+	.port_sw_fini = gaudi2_cn_port_sw_fini,
+	.register_qp = gaudi2_register_qp,
+	.unregister_qp = gaudi2_unregister_qp,
+	.get_qp_id_range = gaudi2_get_qp_id_range,
+	.eq_poll = gaudi2_eq_poll,
+	.eq_dispatcher_select_dq = gaudi2_cn_eq_dispatcher_select_dq,
+	.get_db_fifo_id_range = gaudi2_get_db_fifo_id_range,
+	.get_db_fifo_hw_id_range = gaudi2_get_db_fifo_hw_id_range,
+	.db_fifo_set = gaudi2_db_fifo_set,
+	.db_fifo_unset = gaudi2_db_fifo_unset,
+	.get_db_fifo_umr = gaudi2_cn_get_db_fifo_umr,
+	.get_db_fifo_modes_mask = gaudi2_get_db_fifo_modes_mask,
+	.db_fifo_allocate = gaudi2_db_fifo_allocate,
+	.db_fifo_free = gaudi2_db_fifo_free,
+	.set_pfc = gaudi2_cn_set_pfc,
+	.get_encap_id_range = gaudi2_get_encap_id_range,
+	.encap_set = gaudi2_encap_set,
+	.encap_unset = gaudi2_encap_unset,
+	.set_ip_addr_encap = gaudi2_default_encap_set,
+	.qpc_write = gaudi2_cn_qpc_write,
+	.qpc_invalidate = gaudi2_cn_qpc_invalidate,
+	.qpc_query = gaudi2_cn_qpc_query,
+	.qpc_clear = gaudi2_cn_qpc_clear,
+	.user_ccq_set = gaudi2_cn_user_ccq_set,
+	.user_ccq_unset = gaudi2_cn_user_ccq_unset,
+	.reset_mac_stats = gaudi2_cn_reset_mac_stats,
+	.collect_fec_stats = gaudi2_cn_debugfs_collect_fec_stats,
+	.disable_wqe_index_checker = gaudi2_cn_disable_wqe_index_checker,
+	.get_status = gaudi2_cn_get_status,
+	.cfg_lock = gaudi2_cn_cfg_lock,
+	.cfg_unlock = gaudi2_cn_cfg_unlock,
+	.cfg_is_locked = gaudi2_cn_cfg_is_locked,
+	.qp_pre_destroy = gaudi2_cn_qp_pre_destroy,
+	.qp_post_destroy = gaudi2_cn_qp_post_destroy,
+	.set_port_status = gaudi2_cn_set_port_status,
+	.send_cpucp_packet = gaudi2_cn_send_cpucp_packet,
+	.adaptive_tmr_reset = gaudi2_cn_adaptive_tmr_reset,
+	.spmu_get_stats_info = gaudi2_cn_spmu_get_stats_info,
+	.spmu_config = gaudi2_cn_spmu_config,
+	.spmu_sample = gaudi2_cn_spmu_sample,
+	.post_send_status = gaudi2_cn_post_send_status,
+};
+
+static struct hbl_cn_asic_funcs gaudi2_cn_funcs = {
+	.core_init = gaudi2_cn_core_init,
+	.core_fini = gaudi2_cn_core_fini,
+	.set_req_qp_ctx = gaudi2_set_req_qp_ctx,
+	.set_res_qp_ctx = gaudi2_set_res_qp_ctx,
+	.user_wq_arr_set = gaudi2_user_wq_arr_set,
+	.user_set_app_params = gaudi2_user_set_app_params,
+	.user_get_app_params = gaudi2_user_get_app_params,
+	.phy_reset_macro = gaudi2_cn_phy_reset_macro,
+	.phy_get_crc = gaudi2_cn_phy_get_crc,
+	.get_phy_fw_name = gaudi2_cn_phy_get_fw_name,
+	.phy_fw_load_all = gaudi2_cn_phy_fw_load_all,
+	.get_default_port_speed = gaudi2_cn_get_default_port_speed,
+	.pre_sw_init = gaudi2_cn_pre_sw_init,
+	.sw_init = gaudi2_cn_sw_init,
+	.sw_fini = gaudi2_cn_sw_fini,
+	.macro_sw_init = gaudi2_cn_macro_sw_init,
+	.macro_sw_fini = gaudi2_cn_macro_sw_fini,
+	.kernel_ctx_init = gaudi2_cn_kernel_ctx_init,
+	.kernel_ctx_fini = gaudi2_cn_kernel_ctx_fini,
+	.ctx_init = gaudi2_cn_ctx_init,
+	.ctx_fini = gaudi2_cn_ctx_fini,
+	.qp_read = gaudi2_cn_debugfs_qp_read,
+	.wqe_read = gaudi2_cn_debugfs_wqe_read,
+	.set_en_data = gaudi2_cn_set_en_data,
+	.request_irqs = gaudi2_cn_eq_request_irqs,
+	.synchronize_irqs = gaudi2_cn_eq_sync_irqs,
+	.free_irqs = gaudi2_cn_eq_free_irqs,
+	.phy_dump_serdes_params = gaudi2_cn_phy_dump_serdes_params,
+	.get_max_msg_sz = gaudi2_cn_get_max_msg_sz,
+	.qp_syndrome_to_str = gaudi2_cn_qp_err_syndrome_to_str,
+	.app_params_clear = gaudi2_cn_app_params_clear,
+	.inject_rx_err = gaudi2_cn_inject_rx_err,
+	.is_encap_supported = gaudi2_cn_is_encap_supported,
+	.set_static_properties = gaudi2_cn_set_static_properties,
+	.set_dram_properties = gaudi2_cn_set_dram_properties,
+	.late_init = gaudi2_cn_late_init,
+	.late_fini = gaudi2_cn_late_fini,
+	.get_hw_block_handle = gaudi2_cn_get_hw_block_handle,
+	.get_hw_block_addr = gaudi2_cn_get_hw_block_addr,
+	.dma_alloc_coherent = gaudi2_cn_dma_alloc_coherent,
+	.dma_free_coherent = gaudi2_cn_dma_free_coherent,
+	.dma_pool_zalloc = gaudi2_cn_dma_pool_zalloc,
+	.dma_pool_free = gaudi2_cn_dma_pool_free,
+	.send_cpu_message = gaudi2_cn_send_cpu_message,
+	.ports_cancel_status_work = hbl_cn_ports_cancel_status_work,
+	.port_funcs = &gaudi2_cn_port_funcs,
+};
+
+void gaudi2_cn_set_asic_funcs(struct hbl_cn_device *hdev)
+{
+	hdev->asic_funcs = &gaudi2_cn_funcs;
+}
diff --git a/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.h b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.h
new file mode 100644
index 000000000000..58a0d4e86d47
--- /dev/null
+++ b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn.h
@@ -0,0 +1,427 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#ifndef GAUDI2_CN_H_
+#define GAUDI2_CN_H_
+
+#include <linux/net/intel/gaudi2.h>
+
+#include "../common/hbl_cn.h"
+#include "asic_reg/gaudi2_regs.h"
+
+#define NIC_NUMBER_OF_MACROS		12
+#define NIC_NUMBER_OF_ENGINES		(NIC_NUMBER_OF_MACROS * 2)
+#define NIC_MAX_NUMBER_OF_PORTS		(NIC_NUMBER_OF_ENGINES * 2)
+#define NIC_MAX_FIFO_RINGS		32
+#define NIC_MAC_NUM_OF_LANES		4
+#define NIC_MAC_LANES_START		0
+#define NIC_NUMBER_OF_EQS		1
+#define DEVICE_CACHE_LINE_SIZE		128
+#define NIC_SEND_WQE_SIZE		32
+#define NIC_SEND_WQE_SIZE_MULTI_STRIDE	64
+#define NIC_RECV_WQE_SIZE		16
+#define DB_FIFO_ELEMENT_SIZE		8
+/* 4 entries of 32 bit each i.e. 16 bytes */
+#define NIC_RAW_EQE_SIZE		16
+#define NIC_MAX_CCQS_NUM		1
+#define NIC_HW_MAX_QP_NUM		BIT(24) /* 16M (per port) */
+
+#define NIC_NUMBER_OF_PORTS		NIC_NUMBER_OF_ENGINES
+#define NIC_MAX_NUM_OF_LANES		(NIC_NUMBER_OF_MACROS * NIC_MAC_LANES)
+#define NIC_CQS_NUM			2 /* For Raw and RDMA */
+#define NIC_EQ_ERR_SYNDROME		0
+#define NIC_QP_ERR_RETRY_SYNDROME	0x40
+#define NIC_MAX_QP_ERR_SYNDROMES	0x100
+#define GAUDI2_NIC_MAX_CQS_NUM		16
+
+/* make sure generic max CCQs number is always larger than h/w specific max CCQs number */
+static_assert(NIC_MAX_CCQS_NUM <= NIC_DRV_MAX_CCQS_NUM);
+
+#define GAUDI2_NIC_NUM_DB_FIFOS			32
+
+/* writing to the device memory-mapped dram using the writel or writeb commands (for example) is
+ * subject to the write-combined rules, meaning that writes temporarily stored in a buffer and are
+ * released together later in burst mode towards the device.
+ * Due to the high latencies in the PLDM such writes take a lot of time which may lead to system
+ * hangs. The burst issue gets more severe if ports are opened in parallel as each port accesses
+ * this memory, therefore we limit the amount of pending writes by inserting reads every several
+ * writes which causes the pending writes to be flushed to the device.
+ */
+#define NIC_MAX_COMBINED_WRITES	0x2000
+
+#define NIC_MAX_RC_MTU		SZ_8K
+
+#define UDP_HDR_SIZE		8
+
+/* This is the max frame length the H/W supports (Tx/Rx) */
+#define NIC_MAX_RDMA_HDRS	128
+#define NIC_MAX_TNL_HDR_SIZE	32 /* Bytes */
+#define NIC_MAX_TNL_HDRS	(NIC_MAX_TNL_HDR_SIZE + UDP_HDR_SIZE)
+#define NIC_MAX_FRM_LEN		(NIC_MAX_RC_MTU + NIC_MAX_RDMA_HDRS)
+#define NIC_MAC_MAX_FRM_LEN	(NIC_MAX_FRM_LEN + HBL_EN_MAX_HEADERS_SZ + NIC_MAX_TNL_HDRS)
+#define NIC_RAW_MIN_MTU		(SZ_1K - HBL_EN_MAX_HEADERS_SZ)
+#define NIC_RAW_MAX_MTU		(NIC_MAX_RC_MTU - HBL_EN_MAX_HEADERS_SZ)
+
+/* This is the size of an element size in the RAW buffer - note that it is different than
+ * NIC_MAX_FRM_LEN, because it has to be power of 2.
+ */
+#define NIC_RAW_ELEM_SIZE	(2 * NIC_MAX_RC_MTU)
+
+#define NIC_RX_RING_PKT_NUM	BIT(8)
+
+#define NIC_MIN_CONN_ID		1
+#define NIC_MAX_CONN_ID		(BIT(13) - 1) /* 8K QPs */
+
+#define NIC_MAX_QP_NUM		(NIC_MAX_CONN_ID + 1)
+
+/* Number of available QPs must not exceed NIC_HW_MAX_QP_NUM */
+static_assert(NIC_MAX_QP_NUM <= NIC_HW_MAX_QP_NUM);
+
+/* Allocate an extra QP to be used as dummy QP. */
+#define REQ_QPC_TOTAL_PORT_SIZE		((NIC_MAX_QP_NUM + 1) * sizeof(struct gaudi2_qpc_requester))
+#define RES_QPC_TOTAL_PORT_SIZE		ALIGN((NIC_MAX_QP_NUM + 1) * \
+					      sizeof(struct gaudi2_qpc_responder),  \
+					      DEVICE_CACHE_LINE_SIZE)
+
+#define TMR_ENT_SIZE		4
+#define TMR_GRANULARITY		256
+#define TMR_FSM_SIZE		ALIGN(NIC_MAX_QP_NUM, DEVICE_CACHE_LINE_SIZE)
+/* each timer serves two NICs, hence multiply by 2 */
+#define TMR_FIFO_SIZE		ALIGN((NIC_MAX_QP_NUM * 2 * TMR_ENT_SIZE) + \
+				      DEVICE_CACHE_LINE_SIZE * TMR_GRANULARITY, \
+				      DEVICE_CACHE_LINE_SIZE)
+#define TMR_FREE_NUM_ENTRIES	(TMR_FIFO_SIZE / DEVICE_CACHE_LINE_SIZE)
+#define TMR_FREE_SIZE		ALIGN(TMR_FREE_NUM_ENTRIES * TMR_ENT_SIZE, \
+				      DEVICE_CACHE_LINE_SIZE)
+#define TMR_TOTAL_MACRO_SIZE	(TMR_FSM_SIZE * 2 + TMR_FREE_SIZE + TMR_FIFO_SIZE)
+
+#define TMR_FSM0_OFFS		0
+#define TMR_FREE_OFFS		(TMR_FSM0_OFFS + 2 * TMR_FSM_SIZE)
+#define TMR_FIFO_OFFS		(TMR_FREE_OFFS + TMR_FREE_SIZE)
+
+#define TXS_ENT_SIZE		4
+#define TXS_GRANULARITY		256
+#define TXS_FIFO_SIZE		ALIGN((NIC_MAX_QP_NUM * 2 * TXS_ENT_SIZE) + \
+				      DEVICE_CACHE_LINE_SIZE * TXS_GRANULARITY, \
+				      DEVICE_CACHE_LINE_SIZE)
+#define TXS_FREE_NUM_ENTRIES	(TXS_FIFO_SIZE / DEVICE_CACHE_LINE_SIZE)
+#define TXS_FREE_SIZE		ALIGN(TXS_FREE_NUM_ENTRIES * TXS_ENT_SIZE, \
+				      DEVICE_CACHE_LINE_SIZE)
+#define TXS_TOTAL_PORT_SIZE	(TXS_FREE_SIZE + TXS_FIFO_SIZE)
+
+#define TXS_FREE_OFFS		0
+#define TXS_FIFO_OFFS		(TXS_FREE_OFFS + TXS_FREE_SIZE)
+
+#define TXS_NUM_PORTS		NIC_MAC_LANES
+#define TXS_SCHEDQ		TXS_GRANULARITY
+#define TXS_NUM_SCHEDQS		TXS_SCHEDQ
+
+#define TXS_PORT_NUM_SCHEDQS		(TXS_NUM_SCHEDQS / TXS_NUM_PORTS)
+#define TXS_PORT_NUM_SCHED_GRANS	(TXS_PORT_NUM_SCHEDQS / HBL_EN_PFC_PRIO_NUM)
+#define TXS_PORT_RAW_SCHED_Q		(TXS_PORT_NUM_SCHED_GRANS - QPC_RAW_SCHED_Q)
+#define TXS_PORT_RES_SCHED_Q		(TXS_PORT_NUM_SCHED_GRANS - QPC_RES_SCHED_Q)
+#define TXS_PORT_REQ_SCHED_Q		(TXS_PORT_NUM_SCHED_GRANS - QPC_REQ_SCHED_Q)
+
+#define RXB_NUM_BUFFS			2880
+#define RXB_BUFF_SIZE			128 /* size in bytes */
+#define RXB_NUM_MTU_BUFFS		((NIC_MAX_FRM_LEN / RXB_BUFF_SIZE) + 1)
+#define RXB_DROP_SMALL_TH_DEPTH		3
+#define RXB_DROP_TH_DEPTH		(1 * RXB_NUM_MTU_BUFFS)
+#define RXB_XOFF_TH_DEPTH		(11 * RXB_NUM_MTU_BUFFS)
+#define RXB_XON_TH_DEPTH		(1 * RXB_NUM_MTU_BUFFS)
+#define RXB_NUM_STATIC_CREDITS		(RXB_NUM_BUFFS / 2)
+
+#define SECTION_ALIGN_SIZE		0x100000ull
+#define NIC_DRV_BASE_ADDR(nic_drv_addr)	ALIGN(nic_drv_addr, SECTION_ALIGN_SIZE)
+
+#define NIC_DRV_END_ADDR(nic_drv_addr, nic_drv_size) \
+					ALIGN(((nic_drv_addr) + (nic_drv_size)), \
+					      SECTION_ALIGN_SIZE)
+
+#define REQ_QPC_BASE_ADDR		NIC_DRV_BASE_ADDR
+
+#define RES_QPC_BASE_ADDR(nic_drv_addr)	(REQ_QPC_BASE_ADDR(nic_drv_addr) + \
+					 ALIGN(NIC_NUMBER_OF_ENGINES * REQ_QPC_TOTAL_PORT_SIZE, \
+					       SECTION_ALIGN_SIZE))
+
+#define TMR_BASE_ADDR(nic_drv_addr)	(RES_QPC_BASE_ADDR(nic_drv_addr) + \
+					 ALIGN(NIC_NUMBER_OF_ENGINES * RES_QPC_TOTAL_PORT_SIZE, \
+					       SECTION_ALIGN_SIZE))
+
+#define TXS_BASE_ADDR(nic_drv_addr)	(TMR_BASE_ADDR(nic_drv_addr) + \
+					 ALIGN(NIC_NUMBER_OF_MACROS * TMR_TOTAL_MACRO_SIZE, \
+					       SECTION_ALIGN_SIZE))
+
+#define WQ_BASE_ADDR(nic_drv_addr)	(TXS_BASE_ADDR(nic_drv_addr) + \
+					 ALIGN(NIC_NUMBER_OF_ENGINES * TXS_TOTAL_PORT_SIZE, \
+					       SECTION_ALIGN_SIZE))
+
+/* Unlike the other port related sizes, this size is shared between all the engines */
+#define WQ_BASE_SIZE(nic_drv_addr, nic_drv_size) \
+	({ \
+		u64 __nic_drv_addr = (nic_drv_addr); \
+		NIC_DRV_END_ADDR(__nic_drv_addr, (nic_drv_size)) - WQ_BASE_ADDR(__nic_drv_addr); \
+	})
+
+#define WQ_BUFFER_LOG_SIZE		8
+#define WQ_BUFFER_SIZE			(1 << (WQ_BUFFER_LOG_SIZE))
+#define CQE_SIZE			sizeof(struct gaudi2_cqe)
+#define NIC_CQ_RAW_IDX			0
+#define NIC_CQ_RDMA_IDX			1
+#define QP_WQE_NUM_REC			128
+#define TX_WQE_NUM_IN_CLINE		(DEVICE_CACHE_LINE_SIZE / NIC_SEND_WQE_SIZE_MULTI_STRIDE)
+#define RX_WQE_NUM_IN_CLINE		(DEVICE_CACHE_LINE_SIZE / NIC_RECV_WQE_SIZE)
+#define RAW_QPN				0
+
+#define NIC_FIFO_DB_SIZE		64
+#define NIC_TX_BUF_SIZE			QP_WQE_NUM_REC
+#define NIC_CQ_MAX_ENTRIES		BIT(13)
+#define NIC_EQ_RING_NUM_REC		BIT(18)
+
+/* if not equal, the size of the WQ must be considered when checking data bounds in en_tx_done */
+static_assert(NIC_TX_BUF_SIZE == QP_WQE_NUM_REC);
+
+#define NIC_TOTAL_CQ_MEM_SIZE		(NIC_CQ_MAX_ENTRIES * CQE_SIZE)
+
+#define NIC_CQ_USER_MIN_ENTRIES		4
+#define NIC_CQ_USER_MAX_ENTRIES		NIC_CQ_MAX_ENTRIES
+
+#define NIC_MIN_CQ_ID			NIC_CQS_NUM
+#define NIC_MAX_CQ_ID			(GAUDI2_NIC_MAX_CQS_NUM - 1)
+
+static_assert(NIC_CQ_RDMA_IDX < GAUDI2_NIC_MAX_CQS_NUM);
+static_assert(NIC_CQ_RAW_IDX < GAUDI2_NIC_MAX_CQS_NUM);
+
+#define USER_WQES_MIN_NUM		16
+#define USER_WQES_MAX_NUM		BIT(15) /* 32K */
+
+#define NIC_RXE_AXUSER_AXUSER_CQ_OFFSET (NIC0_RXE0_AXUSER_AXUSER_CQ1_HB_ASID - \
+					 NIC0_RXE0_AXUSER_AXUSER_CQ0_HB_ASID)
+
+/* Unsecure userspace doorbell fifo IDs as reported to the user, HW IDs are 0-29 */
+#define GAUDI2_MIN_DB_FIFO_ID	1
+#define GAUDI2_MAX_DB_FIFO_ID	30
+
+#define GAUDI2_DB_FIFO_SECURE_HW_ID	30
+#define GAUDI2_DB_FIFO_PRIVILEGE_HW_ID	31
+
+/* The size of the DB FIFO in bytes is constant */
+#define DB_FIFO_ENTRY_SIZE	8
+#define DB_FIFO_NUM_OF_ENTRIES	64
+#define DB_FIFO_SIZE		(DB_FIFO_NUM_OF_ENTRIES * DB_FIFO_ENTRY_SIZE)
+
+/* User encapsulation IDs. There are 8 encaps and 4 decap resources available per macro.
+ * So for now let's allow the max of 2 encaps per port.
+ */
+#define GAUDI2_MIN_ENCAP_ID	0
+#define GAUDI2_MAX_ENCAP_ID	1
+
+#define QPC_GW_MASK_REG_NUM	(((NIC0_QPC0_GW_MASK_31 - NIC0_QPC0_GW_MASK_0) >> 2) + 1)
+
+#define NIC_CFG_LO_SIZE		(NIC0_QPC1_REQ_STATIC_CONFIG - NIC0_QPC0_REQ_STATIC_CONFIG)
+
+#define NIC_CFG_HI_SIZE		(NIC0_RXE1_CONTROL - NIC0_RXE0_CONTROL)
+
+#define NIC_CFG_BASE(port, reg) \
+	({ \
+		u32 __port = (port); \
+		u32 __reg = (reg); \
+		(u64)(NIC_MACRO_CFG_BASE(__port) + ((__reg < NIC0_RXE0_CONTROL) ? \
+		(NIC_CFG_LO_SIZE * (u64)(__port & 1)) : (NIC_CFG_HI_SIZE * (u64)(__port & 1)))); \
+	})
+
+#define NIC_RREG32(reg) \
+	({ \
+		u32 _reg = (reg); \
+		RREG32(NIC_CFG_BASE(port, _reg) + _reg); \
+	})
+
+#define NIC_WREG32(reg, val) \
+	({ \
+		u32 _reg = (reg); \
+		WREG32(NIC_CFG_BASE(port, _reg) + _reg, (val)); \
+	})
+
+#define NIC_RMWREG32(reg, val, mask) \
+	({ \
+		u32 _reg = (reg); \
+		RMWREG32(NIC_CFG_BASE(port, _reg) + _reg, (val), (mask)); \
+	})
+
+#define NIC_RMWREG32_SHIFTED(reg, val, mask) \
+	({ \
+		u32 _reg = (reg); \
+		RMWREG32_SHIFTED(NIC_CFG_BASE(port, _reg) + _reg, (val), (mask)); \
+	})
+
+#define MAC_CH_OFFSET(lane) ((NIC0_MAC_CH1_MAC_PCS_BASE - NIC0_MAC_CH0_MAC_PCS_BASE) * (lane))
+
+#define WARN_ON_CACHE_UNALIGNED(addr) WARN_ON_ONCE(!IS_ALIGNED(addr, DEVICE_CACHE_LINE_SIZE))
+
+enum gaudi2_cn_mac_fec_stats_type {
+	FEC_CW_CORRECTED_ACCUM,
+	FEC_CW_UNCORRECTED_ACCUM,
+	FEC_CW_CORRECTED,
+	FEC_CW_UNCORRECTED,
+	FEC_SYMBOL_ERR_CORRECTED_LANE_0,
+	FEC_SYMBOL_ERR_CORRECTED_LANE_1,
+	FEC_SYMBOL_ERR_CORRECTED_LANE_2,
+	FEC_SYMBOL_ERR_CORRECTED_LANE_3,
+	FEC_PRE_FEC_SER_INT,
+	FEC_PRE_FEC_SER_EXP,
+	FEC_POST_FEC_SER_INT,
+	FEC_POST_FEC_SER_EXP,
+	FEC_STAT_LAST
+};
+
+enum gaudi2_cn_perf_stats_type {
+	PERF_BANDWIDTH_INT,
+	PERF_BANDWIDTH_FRAC,
+	PERF_LATENCY_INT,
+	PERF_LATENCY_FRAC,
+	PERF_STAT_LAST
+};
+
+enum gaudi2_cn_pcs_link_state {
+	PCS_LINK_STATE_SETTLING,
+	PCS_LINK_STATE_STRESS,
+	PCS_LINK_STATE_STEADY
+};
+
+struct gaudi2_cn_port;
+
+/**
+ * struct gaudi2_cn_port - manage specific port.
+ * @hdev: habanalabs device structure.
+ * @cn_port: pointer to a common device structure.
+ * @fifo_ring: rings array for doorbell H/W interface.
+ * @wq_ring: raw work queue ring.
+ * @rx_ring: raw skb ring.
+ * @cq_ring: ring array for the completion queue of raw/rdma packets.
+ * @eq_ring: ring for the event queue.
+ * @eq_work: EQ work for processing events (e.g Tx completion).
+ * @qp_sanity_work: QPC sanity check worker.
+ * @qp_sanity_wq: QPC sanity worker thread.
+ * @cfg_lock: Serializes the port configuration.
+ * @qp_destroy_lock: protects the MAC loopback switching for QP destroy flow.
+ * @pcs_link_stady_state_ts: the timestamp to move to the pcs link steady state.
+ * @pcs_link_state: the current pcs link state.
+ * @qp_destroy_cnt: number of QPs currently under destruction.
+ * @min_qp_size: the size of the smallest QP.
+ * @db_fifo_pi: DB fifo ring producer index.
+ * @qp_timeout_cnt: count of timeouts occurred on a port operating a QP.
+ * @pcs_link_samples_per_sec: the number of times we check the pcs link in a second.
+ * @advanced: true if advanced features are supported.
+ * @adaptive_timeout_en: enable adaptive timeout feature.
+ * @qp_destroy_mac_lpbk: port in is MAC loopback due to QP destroy flow.
+ * @initial_tx_taps_cfg: first tx taps config since the last PHY power-up.
+ * @tx_taps_cfg: current tx taps config.
+ * @tx_taps_modified: flag to indicate if tx_taps were modified due to remote faults.
+ */
+struct gaudi2_cn_port {
+	struct hbl_cn_device *hdev;
+	struct hbl_cn_port *cn_port;
+	struct hbl_cn_ring fifo_ring;
+	struct hbl_cn_ring wq_ring;
+	struct hbl_cn_ring rx_ring;
+	struct hbl_cn_ring cq_rings[NIC_CQS_NUM];
+	struct hbl_cn_ring eq_ring;
+	struct delayed_work eq_work;
+	struct delayed_work qp_sanity_work;
+	struct workqueue_struct *qp_sanity_wq;
+	/* Serializes the port configuration */
+	struct mutex cfg_lock;
+	/* protects the MAC loopback switching for QP destroy flow */
+	struct mutex qp_destroy_lock;
+	ktime_t pcs_link_stady_state_ts;
+	enum gaudi2_cn_pcs_link_state pcs_link_state;
+	u32 qp_destroy_cnt;
+	u32 min_qp_size;
+	u32 db_fifo_pi;
+	u32 qp_timeout_cnt;
+	u32 pcs_link_samples_per_sec;
+	u8 advanced;
+	u8 adaptive_timeout_en;
+	u8 qp_destroy_mac_lpbk;
+	u8 initial_tx_taps_cfg;
+	u8 tx_taps_cfg;
+	u8 tx_taps_modified;
+};
+
+/**
+ * struct gaudi2_cn_device - ASIC specific manage structure.
+ * @cn_ports: array that holds all ports manage structures.
+ * @cn_macros: array that holds all macro manage structures.
+ * @en_aux_data: data to be used by the Ethernet driver.
+ * @en_aux_ops: functions for Ethernet <-> CN drivers communication.
+ * @cn_aux_ops: functions for CN <-> compute drivers communication.
+ * @setup_type: type of setup connectivity.
+ * @cfg_base: configuration space base address.
+ * @irq_num_port_base: base IRQ number for port EQ.
+ * @sob_id_base: first reserved SOB ID.
+ * @sob_inc_cfg_val: configuration value for incrementing SOB by one.
+ * @fw_security_enabled: FW security enabled.
+ * @msix_enabled: MSI-X enabled.
+ * @temporal_polling: EQ polling activity is temporal and is used only in specific cases.
+ * @flush_db_fifo: force flush DB FIFO after a write.
+ * @in_compute_reset: device is under compute reset.
+ * @mac_rs_fec_ctrl_support: Is MAC_RS_FEC_CONTROL block supported.
+ */
+struct gaudi2_cn_device {
+	struct gaudi2_cn_port cn_ports[NIC_NUMBER_OF_PORTS];
+	struct gaudi2_en_aux_data en_aux_data;
+	struct gaudi2_en_aux_ops en_aux_ops;
+	struct gaudi2_cn_aux_ops *cn_aux_ops;
+	enum gaudi2_setup_type setup_type;
+	u64 cfg_base;
+	u32 irq_num_port_base;
+	u32 sob_id_base;
+	u32 sob_inc_cfg_val;
+	u8 fw_security_enabled;
+	u8 msix_enabled;
+	u8 temporal_polling;
+	u8 flush_db_fifo;
+	u8 in_compute_reset;
+	u8 mac_rs_fec_ctrl_support;
+};
+
+int gaudi2_cn_eq_init(struct hbl_cn_device *hdev);
+void gaudi2_cn_eq_fini(struct hbl_cn_device *hdev);
+int gaudi2_cn_debugfs_qp_read(struct hbl_cn_device *hdev, struct hbl_cn_qp_info *qp_info, char *buf,
+			      size_t bsize);
+int gaudi2_cn_debugfs_wqe_read(struct hbl_cn_device *hdev, char *buf, size_t bsize);
+void gaudi2_cn_debugfs_collect_fec_stats(struct hbl_cn_port *cn_port, char *buf, size_t size);
+int gaudi2_cn_eq_dispatcher_register_db(struct gaudi2_cn_port *gaudi2_cn, u32 asid, u32 dbn);
+int gaudi2_cn_eq_request_irqs(struct hbl_cn_device *hdev);
+void gaudi2_cn_eq_sync_irqs(struct hbl_cn_device *hdev);
+void gaudi2_cn_eq_free_irqs(struct hbl_cn_device *hdev);
+struct hbl_cn_ev_dq *gaudi2_cn_eq_dispatcher_select_dq(struct hbl_cn_port *cn_port,
+						       const struct hbl_cn_eqe *eqe);
+char *gaudi2_cn_qp_err_syndrome_to_str(u32 syndrome);
+int gaudi2_cn_qpc_read(struct hbl_cn_port *cn_port, void *qpc, u32 qpn, bool is_req);
+int gaudi2_cn_wqe_read(struct hbl_cn_port *cn_port, void *wqe, u32 qpn, u32 wqe_idx, bool is_tx);
+void gaudi2_cn_hw_mac_loopback_cfg(struct gaudi2_cn_port *gaudi2_cn);
+int gaudi2_cn_set_info(struct hbl_cn_device *hdev, bool get_from_fw);
+int gaudi2_cn_phy_reset_macro(struct hbl_cn_macro *cn_macro);
+int gaudi2_cn_phy_init(struct hbl_cn_device *hdev);
+void gaudi2_cn_eq_enter_temporal_polling_mode(struct hbl_cn_device *hdev);
+void gaudi2_cn_eq_exit_temporal_polling_mode(struct hbl_cn_device *hdev);
+void gaudi2_cn_phy_flush_link_status_work(struct hbl_cn_device *hdev);
+int gaudi2_cn_phy_port_init(struct hbl_cn_port *cn_port);
+void gaudi2_cn_phy_port_start_stop(struct hbl_cn_port *cn_port, bool is_start);
+const char *gaudi2_cn_phy_get_fw_name(void);
+int gaudi2_cn_phy_fw_load_all(struct hbl_cn_device *hdev);
+u16 gaudi2_cn_phy_get_crc(struct hbl_cn_device *hdev);
+int gaudi2_cn_phy_port_power_up(struct hbl_cn_port *cn_port);
+void gaudi2_cn_phy_port_reconfig(struct hbl_cn_port *cn_port);
+void gaudi2_cn_phy_port_fini(struct hbl_cn_port *cn_port);
+void gaudi2_cn_phy_link_status_work(struct work_struct *work);
+void gaudi2_cn_phy_dump_serdes_params(struct hbl_cn_device *hdev, char *buf, size_t size);
+void gaudi2_cn_get_mac_fec_stats(struct hbl_cn_port *cn_port, u64 *data);
+bool gaudi2_cn_is_cq_in_overrun(struct hbl_cn_port *cn_port, u8 cq_id);
+bool gaudi2_handle_qp_error_retry(struct hbl_cn_port *cn_port, u32 qpn);
+
+#endif /* GAUDI2_CN_H_ */
diff --git a/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_debugfs.c b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_debugfs.c
new file mode 100644
index 000000000000..3acd8b8b0f4a
--- /dev/null
+++ b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_debugfs.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#include "gaudi2_cn.h"
+
+#define _fsnprintf(buf, size, fmt, ...)							\
+		do {									\
+			if (full_print)							\
+				__snprintf(buf, size, fmt, ##__VA_ARGS__);		\
+											\
+		} while (0)
+
+static int gaudi2_cn_debugfs_qpc_req_parse(struct hbl_cn_device *hdev,
+					   struct hbl_cn_qp_info *qp_info,
+					   struct gaudi2_qpc_requester *req, char *buf,
+					   size_t bsize)
+{
+	bool full_print, force_read;
+
+	force_read = qp_info->force_read;
+	full_print = qp_info->full_print;
+
+	__snprintf(buf, bsize, "Valid: %lld\n", REQ_QPC_GET_VALID(*req));
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	if (!force_read && !REQ_QPC_GET_VALID(*req))
+		return 0;
+
+	__snprintf(buf, bsize, "Error: %lld\n", REQ_QPC_GET_ERROR(*req));
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	if (!force_read && REQ_QPC_GET_ERROR(*req))
+		return 0;
+
+	_fsnprintf(buf, bsize, "in_work: 0x%llx\n", REQ_QPC_GET_IN_WORK(*req));
+	_fsnprintf(buf, bsize, "trusted: 0x%llx\n", REQ_QPC_GET_TRUST_LEVEL(*req));
+	_fsnprintf(buf, bsize, "WQ addr: 0x%llx\n", REQ_QPC_GET_WQ_BASE_ADDR(*req));
+	_fsnprintf(buf, bsize, "MTU: 0x%llx\n", REQ_QPC_GET_MTU(*req));
+	_fsnprintf(buf, bsize, "cong mode: 0x%llx\n", REQ_QPC_GET_CONGESTION_MODE(*req));
+	_fsnprintf(buf, bsize, "priority: 0x%llx\n", REQ_QPC_GET_PRIORITY(*req));
+	_fsnprintf(buf, bsize, "transport service: 0x%llx\n", REQ_QPC_GET_TRANSPORT_SERVICE(*req));
+	_fsnprintf(buf, bsize, "SWQ gran: 0x%llx\n", REQ_QPC_GET_SWQ_GRANULARITY(*req));
+	__snprintf(buf, bsize, "WQ type: 0x%llx\n", REQ_QPC_GET_WQ_TYPE(*req));
+	_fsnprintf(buf, bsize, "port/lane: 0x%llx\n", REQ_QPC_GET_PORT(*req));
+	_fsnprintf(buf, bsize, "Gaudi1 mode: 0x%llx\n", REQ_QPC_GET_MOD_GAUDI1(*req));
+	__snprintf(buf, bsize, "data MMU BP: 0x%llx\n", REQ_QPC_GET_DATA_MMU_BYPASS(*req));
+	_fsnprintf(buf, bsize, "PSN delivered: 0x%llx\n", REQ_QPC_GET_PSN_DELIVERED(*req));
+	_fsnprintf(buf, bsize, "pacing time: 0x%llx\n", REQ_QPC_GET_PACING_TIME(*req));
+	_fsnprintf(buf, bsize, "Ackreq freq: 0x%llx\n", REQ_QPC_GET_ACKREQ_FREQ(*req));
+	_fsnprintf(buf, bsize, "PSN since ackreq: 0x%llx\n", REQ_QPC_GET_PSN_SINCE_ACKREQ(*req));
+	__snprintf(buf, bsize, "oldest unacked remote PI: 0x%llx\n",
+		   REQ_QPC_GET_OLDEST_UNACKED_REMOTE_PRODUCER_IDX(*req));
+	__snprintf(buf, bsize, "remote CI: 0x%llx\n", REQ_QPC_GET_REMOTE_CONSUMER_IDX(*req));
+	__snprintf(buf, bsize, "remote PI: 0x%llx\n", REQ_QPC_GET_REMOTE_PRODUCER_IDX(*req));
+	__snprintf(buf, bsize, "local PI: 0x%llx\n", REQ_QPC_GET_LOCAL_PRODUCER_IDX(*req));
+	__snprintf(buf, bsize, "local CI: 0x%llx\n", REQ_QPC_GET_CONSUMER_IDX(*req));
+	__snprintf(buf, bsize, "local EI: 0x%llx\n", REQ_QPC_GET_EXECUTION_IDX(*req));
+	__snprintf(buf, bsize, "last index: 0x%llx\n", REQ_QPC_GET_LAST_IDX(*req));
+	__snprintf(buf, bsize, "ASID: 0x%llx\n", REQ_QPC_GET_ASID(*req));
+	_fsnprintf(buf, bsize, "burst size: 0x%llx\n", REQ_QPC_GET_BURST_SIZE(*req));
+	_fsnprintf(buf, bsize, "CC RTT PSN: 0x%llx\n", REQ_QPC_GET_RTT_MARKED_PSN(*req));
+	_fsnprintf(buf, bsize, "CC RTT timestamp: 0x%llx\n", REQ_QPC_GET_RTT_TIMESTAMP(*req));
+	_fsnprintf(buf, bsize, "congestion window: 0x%llx\n", REQ_QPC_GET_CONGESTION_WIN(*req));
+	_fsnprintf(buf, bsize, "encap en: 0x%llx\n", REQ_QPC_GET_ENCAP_ENABLE(*req));
+	_fsnprintf(buf, bsize, "RTT state: 0x%llx\n", REQ_QPC_GET_RTT_STATE(*req));
+	_fsnprintf(buf, bsize, "CQ num: 0x%llx\n", REQ_QPC_GET_CQ_NUM(*req));
+	_fsnprintf(buf, bsize, "congestion window NMA: 0x%llx\n",
+		   REQ_QPC_GET_CONGESTION_NON_MARKED_ACK(*req));
+	_fsnprintf(buf, bsize, "encap type: 0x%llx\n", REQ_QPC_GET_ENCAP_TYPE(*req));
+	__snprintf(buf, bsize, "remote WQ log bsize: 0x%llx\n", REQ_QPC_GET_REMOTE_WQ_LOG_SZ(*req));
+	_fsnprintf(buf, bsize, "congestion window MA: 0x%llx\n",
+		   REQ_QPC_GET_CONGESTION_MARKED_ACK(*req));
+	_fsnprintf(buf, bsize, "WQ back-press: 0x%llx\n", REQ_QPC_GET_WQ_BACK_PRESSURE(*req));
+	_fsnprintf(buf, bsize, "timeout gran: 0x%llx\n", REQ_QPC_GET_TM_GRANULARITY(*req));
+	__snprintf(buf, bsize, "BCC PSN: 0x%llx\n", REQ_QPC_GET_BCC_PSN(*req));
+	__snprintf(buf, bsize, "ONA PSN: 0x%llx\n", REQ_QPC_GET_ONA_PSN(*req));
+	_fsnprintf(buf, bsize, "sched Q: 0x%llx\n", REQ_QPC_GET_SCHD_Q_NUM(*req));
+	__snprintf(buf, bsize, "BCS PSN: 0x%llx\n", REQ_QPC_GET_BCS_PSN(*req));
+	__snprintf(buf, bsize, "NTS PSN: 0x%llx\n", REQ_QPC_GET_NTS_PSN(*req));
+	_fsnprintf(buf, bsize, "timeout retry cnt: 0x%llx\n",
+		   REQ_QPC_GET_TIMEOUT_RETRY_COUNT(*req));
+	_fsnprintf(buf, bsize, "seq ERR retry cnt: 0x%llx\n",
+		   REQ_QPC_GET_SEQUENCE_ERROR_RETRY_COUNT(*req));
+	__snprintf(buf, bsize, "dst MAC: %04llx%08llx\n", REQ_QPC_GET_DST_MAC_MSB(*req),
+		   REQ_QPC_GET_DST_MAC_LSB(*req));
+	_fsnprintf(buf, bsize, "dst ipv4: 0x%llx\n", REQ_QPC_GET_DST_IP(*req));
+	_fsnprintf(buf, bsize, "remote key: 0x%llx\n", REQ_QPC_GET_RKEY(*req));
+	_fsnprintf(buf, bsize, "multi-stride state: 0x%016llx%08llx\n",
+		   REQ_QPC_GET_MULTI_STRIDE_STATE_MSB(*req),
+		   REQ_QPC_GET_MULTI_STRIDE_STATE_LSB(*req));
+	_fsnprintf(buf, bsize, "dest QP: 0x%llx\n", REQ_QPC_GET_DST_QP(*req));
+
+	/* make sure the caller is aware that the buffer it is using is not long enough */
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	return 0;
+}
+
+static int gaudi2_cn_debugfs_qpc_res_parse(struct hbl_cn_device *hdev,
+					   struct hbl_cn_qp_info *qp_info,
+					   struct gaudi2_qpc_responder *res, char *buf,
+					   size_t bsize)
+{
+	bool full_print, force_read;
+
+	force_read = qp_info->force_read;
+	full_print = qp_info->full_print;
+
+	__snprintf(buf, bsize, "Valid: %lld\n", RES_QPC_GET_VALID(*res));
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	if (!force_read && !RES_QPC_GET_VALID(*res))
+		return 0;
+
+	_fsnprintf(buf, bsize, "in work: 0x%llx\n", RES_QPC_GET_IN_WORK(*res));
+	_fsnprintf(buf, bsize, "peer WQ gran: 0x%llx\n", RES_QPC_GET_PEER_WQ_GRAN(*res));
+	_fsnprintf(buf, bsize, "CQ num: 0x%llx\n", RES_QPC_GET_CQ_NUM(*res));
+	__snprintf(buf, bsize, "cyc_idx: 0x%llx\n", RES_QPC_GET_CYCLIC_IDX(*res));
+	_fsnprintf(buf, bsize, "encap EN: 0x%llx\n", RES_QPC_GET_ENCAP_ENABLE(*res));
+	_fsnprintf(buf, bsize, "encap type: 0x%llx\n", RES_QPC_GET_ENCAP_TYPE(*res));
+	__snprintf(buf, bsize, "data MMU BP: 0x%llx\n", RES_QPC_GET_DATA_MMU_BYPASS(*res));
+	_fsnprintf(buf, bsize, "Gaudi1 mode: 0x%llx\n", RES_QPC_GET_MOD_GAUDI1(*res));
+	_fsnprintf(buf, bsize, "trust level: 0x%llx\n", RES_QPC_GET_TRUST_LEVEL(*res));
+	__snprintf(buf, bsize, "expected PSN: 0x%llx\n", RES_QPC_GET_EXPECTED_PSN(*res));
+	_fsnprintf(buf, bsize, "sched Q: 0x%llx\n", RES_QPC_GET_SCHD_Q_NUM(*res));
+	_fsnprintf(buf, bsize, "peer QP: 0x%llx\n", RES_QPC_GET_PEER_QP(*res));
+	__snprintf(buf, bsize, "ASID: 0x%llx\n", RES_QPC_GET_ASID(*res));
+	_fsnprintf(buf, bsize, "transport service: 0x%llx\n", RES_QPC_GET_TRANSPORT_SERVICE(*res));
+	_fsnprintf(buf, bsize, "ECN count: 0x%llx\n", RES_QPC_GET_ECN_COUNT(*res));
+	__snprintf(buf, bsize, "dst MAC: %04llx%08llx\n", RES_QPC_GET_DST_MAC_MSB(*res),
+		   RES_QPC_GET_DST_MAC_LSB(*res));
+	__snprintf(buf, bsize, "dst ipv4: 0x%llx\n", RES_QPC_GET_DST_IP(*res));
+	_fsnprintf(buf, bsize, "local key: 0x%llx\n", RES_QPC_GET_LKEY(*res));
+	_fsnprintf(buf, bsize, "NACK syndrome: 0x%llx\n", RES_QPC_GET_NACK_SYNDROME(*res));
+	__snprintf(buf, bsize, "conn state: 0x%llx\n", RES_QPC_GET_CONN_STATE(*res));
+	_fsnprintf(buf, bsize, "priority: 0x%llx\n", RES_QPC_GET_PRIORITY(*res));
+	_fsnprintf(buf, bsize, "port/lane: 0x%llx\n", RES_QPC_GET_PORT(*res));
+	_fsnprintf(buf, bsize, "dest QP: 0x%llx\n", RES_QPC_GET_DESTINATION_QP(*res));
+
+	/* make sure the caller is aware that the buffer it is using is not long enough */
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	return 0;
+}
+
+int gaudi2_cn_debugfs_qp_read(struct hbl_cn_device *hdev, struct hbl_cn_qp_info *qp_info, char *buf,
+			      size_t bsize)
+{
+	struct hbl_cn_asic_port_funcs *port_funcs;
+	struct gaudi2_qpc_requester qpc_req = {};
+	struct gaudi2_qpc_responder qpc_res = {};
+	struct hbl_cn_port *cn_port;
+	u32 port, qpn;
+	void *qpc;
+	bool req;
+	int rc;
+
+	req = qp_info->req;
+	port = qp_info->port;
+	qpn = qp_info->qpn;
+
+	port_funcs = hdev->asic_funcs->port_funcs;
+	cn_port = &hdev->cn_ports[port];
+	qpc = req ? (void *)&qpc_req : (void *)&qpc_res;
+
+	if (!hbl_cn_is_port_open(cn_port)) {
+		dev_err(hdev->dev,
+			"Cannot read port %d QP %d, port is not initialized\n", port, qpn);
+		return -EPERM;
+	}
+
+	port_funcs->cfg_lock(cn_port);
+	rc = gaudi2_cn_qpc_read(cn_port, qpc, qpn, req);
+	port_funcs->cfg_unlock(cn_port);
+	if (rc)
+		return rc;
+
+	__snprintf(buf, bsize, "port %d, qpn %d, req %d:\n", port, qpn, req);
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	if (req)
+		rc = gaudi2_cn_debugfs_qpc_req_parse(hdev, qp_info, &qpc_req, buf, bsize);
+	else
+		rc = gaudi2_cn_debugfs_qpc_res_parse(hdev, qp_info, &qpc_res, buf, bsize);
+
+	return rc;
+}
+
+static int gaudi2_cn_debugfs_wqe_parse(struct hbl_cn_device *hdev, struct hbl_cn_wqe_info *wqe_info,
+				       void *wqe, char *buf, size_t bsize)
+{
+	struct gaudi2_sq_wqe *sq_wqe;
+	struct gaudi2_rq_wqe *rq_wqe;
+	u8 i;
+
+	if (wqe_info->tx) {
+		i = wqe_info->wqe_idx % TX_WQE_NUM_IN_CLINE;
+		sq_wqe = &(((struct gaudi2_sq_wqe *)wqe)[i]);
+		__snprintf(buf, bsize, "opcode: 0x%llx\n", TX_WQE_GET_OPCODE(*sq_wqe));
+		__snprintf(buf, bsize, "trace event data: 0x%llx\n",
+			   TX_WQE_GET_TRACE_EVENT_DATA(*sq_wqe));
+		__snprintf(buf, bsize, "trace event: 0x%llx\n", TX_WQE_GET_TRACE_EVENT(*sq_wqe));
+		__snprintf(buf, bsize, "WQE index: 0x%llx\n", TX_WQE_GET_WQE_INDEX(*sq_wqe));
+		__snprintf(buf, bsize, "reduction opcode: 0x%llx\n",
+			   TX_WQE_GET_REDUCTION_OPCODE(*sq_wqe));
+		__snprintf(buf, bsize, "SE: 0x%llx\n", TX_WQE_GET_SE(*sq_wqe));
+		__snprintf(buf, bsize, "inline: 0x%llx\n", TX_WQE_GET_INLINE(*sq_wqe));
+		__snprintf(buf, bsize, "ackreq: 0x%llx\n", TX_WQE_GET_ACKREQ(*sq_wqe));
+		__snprintf(buf, bsize, "size: 0x%llx\n", TX_WQE_GET_SIZE(*sq_wqe));
+		__snprintf(buf, bsize, "local address LSB: 0x%llx\n",
+			   TX_WQE_GET_LOCAL_ADDR_LSB(*sq_wqe));
+		__snprintf(buf, bsize, "local address MSB: 0x%llx\n",
+			   TX_WQE_GET_LOCAL_ADDR_MSB(*sq_wqe));
+		__snprintf(buf, bsize, "remote address LSB: 0x%llx\n",
+			   TX_WQE_GET_REMOTE_ADDR_LSB(*sq_wqe));
+		__snprintf(buf, bsize, "remote address MSB: 0x%llx\n",
+			   TX_WQE_GET_REMOTE_ADDR_MSB(*sq_wqe));
+		__snprintf(buf, bsize, "tag: 0x%llx\n", TX_WQE_GET_TAG(*sq_wqe));
+		__snprintf(buf, bsize, "remote SOB: 0x%llx\n", TX_WQE_GET_REMOTE_SOB(*sq_wqe));
+		__snprintf(buf, bsize, "remote SOB data: 0x%llx\n",
+			   TX_WQE_GET_REMOTE_SOB_DATA(*sq_wqe));
+		__snprintf(buf, bsize, "SOB command: 0x%llx\n", TX_WQE_GET_SOB_CMD(*sq_wqe));
+		__snprintf(buf, bsize, "completion type: 0x%llx\n",
+			   TX_WQE_GET_COMPLETION_TYPE(*sq_wqe));
+	} else {
+		i = wqe_info->wqe_idx % RX_WQE_NUM_IN_CLINE;
+		rq_wqe = &(((struct gaudi2_rq_wqe *)wqe)[i]);
+		__snprintf(buf, bsize, "opcode: 0x%llx\n", RX_WQE_GET_OPCODE(*rq_wqe));
+		__snprintf(buf, bsize, "WQE index: 0x%llx\n", RX_WQE_GET_WQE_INDEX(*rq_wqe));
+		__snprintf(buf, bsize, "SOB command: 0x%llx\n", RX_WQE_GET_SOB_CMD(*rq_wqe));
+		__snprintf(buf, bsize, "local SOB: 0x%llx\n", RX_WQE_GET_LOCAL_SOB(*rq_wqe));
+		__snprintf(buf, bsize, "local SOB data: 0x%llx\n",
+			   RX_WQE_GET_LOCAL_SOB_DATA(*rq_wqe));
+		__snprintf(buf, bsize, "completion type: 0x%llx\n",
+			   RX_WQE_GET_COMPLETION_TYPE(*rq_wqe));
+		__snprintf(buf, bsize, "size: 0x%llx\n", RX_WQE_GET_SIZE(*rq_wqe));
+		__snprintf(buf, bsize, "tag: 0x%llx\n", RX_WQE_GET_TAG(*rq_wqe));
+	}
+
+	/* Make sure the caller is aware that the buffer used isn't big enough */
+	if (strlen(buf) >= bsize)
+		return -EFBIG;
+
+	return 0;
+}
+
+int gaudi2_cn_debugfs_wqe_read(struct hbl_cn_device *hdev, char *buf, size_t bsize)
+{
+	struct gaudi2_sq_wqe sq_wqe[TX_WQE_NUM_IN_CLINE] = {};
+	struct gaudi2_rq_wqe rq_wqe[RX_WQE_NUM_IN_CLINE] = {};
+	struct hbl_cn_asic_port_funcs *port_funcs;
+	struct hbl_cn_wqe_info *wqe_info;
+	struct hbl_cn_port *cn_port;
+	u32 port, qpn, wqe_idx;
+	void *wqe;
+	bool tx;
+	int rc;
+
+	port_funcs = hdev->asic_funcs->port_funcs;
+
+	/* Get the details of the WQE to read as written by the user via debugfs */
+	wqe_info = &hdev->wqe_info;
+	tx = wqe_info->tx;
+	port = wqe_info->port;
+	qpn = wqe_info->qpn;
+	wqe_idx = wqe_info->wqe_idx;
+
+	cn_port = &hdev->cn_ports[port];
+	wqe = tx ? (void *)&sq_wqe : (void *)&rq_wqe;
+
+	if (!hbl_cn_is_port_open(cn_port)) {
+		dev_err(hdev->dev,
+			"Cannot read port %d QP %d, port is not initialized\n", port, qpn);
+		return -EPERM;
+	}
+
+	port_funcs->cfg_lock(cn_port);
+	rc = gaudi2_cn_wqe_read(cn_port, wqe, qpn, wqe_idx, tx);
+	port_funcs->cfg_unlock(cn_port);
+	if (rc)
+		goto exit;
+
+	__snprintf(buf, bsize, "port %d, qpn %d, wqe_idx %d, tx %d:\n", port, qpn, wqe_idx, tx);
+
+	rc = gaudi2_cn_debugfs_wqe_parse(hdev, wqe_info, wqe, buf, bsize);
+
+exit:
+	return rc;
+}
+
+void gaudi2_cn_debugfs_collect_fec_stats(struct hbl_cn_port *cn_port, char *buf, size_t size)
+{
+	u32 port = cn_port->port;
+	u64 data[FEC_STAT_LAST];
+	ssize_t len;
+
+	gaudi2_cn_get_mac_fec_stats(cn_port, data);
+
+	len = strlen(buf);
+	if ((size - len) <= 1)
+		return;
+
+	if (cn_port->pcs_link)
+		snprintf(buf + len, size - len,
+			 "Port %u: pre_fec_SER: %llue-%llu post_fec_SER: %llue-%llu\n", port,
+			 data[FEC_PRE_FEC_SER_INT], data[FEC_PRE_FEC_SER_EXP],
+			 data[FEC_POST_FEC_SER_INT], data[FEC_POST_FEC_SER_EXP]);
+	else
+		snprintf(buf + len, size - len, "Port %u: Link is down\n", port);
+}
diff --git a/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_eq.c b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_eq.c
new file mode 100644
index 000000000000..68f6367f3798
--- /dev/null
+++ b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_eq.c
@@ -0,0 +1,732 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#include <linux/pci.h>
+
+#include "gaudi2_cn.h"
+
+#define GAUDI2_NIC_MAX_STRING_LEN	64
+
+static const char
+gaudi2_cn_eq_irq_name[NIC_NUMBER_OF_ENGINES][GAUDI2_NIC_MAX_STRING_LEN] = {
+	"gaudi2 cn0 qpc0 EQ",
+	"gaudi2 cn0 qpc1 EQ",
+	"gaudi2 cn1 qpc0 EQ",
+	"gaudi2 cn1 qpc1 EQ",
+	"gaudi2 cn2 qpc0 EQ",
+	"gaudi2 cn2 qpc1 EQ",
+	"gaudi2 cn3 qpc0 EQ",
+	"gaudi2 cn3 qpc1 EQ",
+	"gaudi2 cn4 qpc0 EQ",
+	"gaudi2 cn4 qpc1 EQ",
+	"gaudi2 cn5 qpc0 EQ",
+	"gaudi2 cn5 qpc1 EQ",
+	"gaudi2 cn6 qpc0 EQ",
+	"gaudi2 cn6 qpc1 EQ",
+	"gaudi2 cn7 qpc0 EQ",
+	"gaudi2 cn7 qpc1 EQ",
+	"gaudi2 cn8 qpc0 EQ",
+	"gaudi2 cn8 qpc1 EQ",
+	"gaudi2 cn9 qpc0 EQ",
+	"gaudi2 cn9 qpc1 EQ",
+	"gaudi2 cn10 qpc0 EQ",
+	"gaudi2 cn10 qpc1 EQ",
+	"gaudi2 cn11 qpc0 EQ",
+	"gaudi2 cn11 qpc1 EQ",
+};
+
+/* Event queues for all the ports are initialized ahead of port-specific initialization regardless
+ * of being enabled or not. We do the same for their IRQs.
+ */
+static irqreturn_t gaudi2_cn_eq_threaded_isr(int irq, void *arg);
+
+int gaudi2_cn_eq_request_irqs(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	int i, rc, irq;
+
+	if (!gaudi2->msix_enabled)
+		return 0;
+
+	/* IRQs should be allocated if polling activity is only temporal */
+	if (hdev->poll_enable && !gaudi2->temporal_polling)
+		return 0;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		gaudi2_port = &gaudi2->cn_ports[i];
+		irq = pci_irq_vector(hdev->pdev, gaudi2->irq_num_port_base + i);
+		rc = request_threaded_irq(irq, NULL, gaudi2_cn_eq_threaded_isr, IRQF_ONESHOT,
+					  gaudi2_cn_eq_irq_name[i], gaudi2_port);
+		if (rc) {
+			dev_err(hdev->dev, "Failed to request IRQ %d for port %d\n", irq, i);
+			goto irq_fail;
+		}
+	}
+
+	return 0;
+
+irq_fail:
+	for (i--; i >= 0; i--) {
+		gaudi2_port = &gaudi2->cn_ports[i];
+		irq = pci_irq_vector(hdev->pdev, gaudi2->irq_num_port_base + i);
+		free_irq(irq, gaudi2_port);
+	}
+	return rc;
+}
+
+void gaudi2_cn_eq_sync_irqs(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	int i, irq;
+
+	if (!gaudi2->msix_enabled)
+		return;
+
+	/* IRQs are allocated if polling is temporal so return only if polling mode is constant */
+	if (hdev->poll_enable && !gaudi2->temporal_polling)
+		return;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		irq = pci_irq_vector(hdev->pdev, gaudi2->irq_num_port_base + i);
+		synchronize_irq(irq);
+	}
+}
+
+void gaudi2_cn_eq_free_irqs(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	int i, irq;
+
+	if (!gaudi2->msix_enabled)
+		return;
+
+	/* IRQs are allocated if polling is temporal so return only if polling mode is constant */
+	if (hdev->poll_enable && !gaudi2->temporal_polling)
+		return;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		gaudi2_port = &gaudi2->cn_ports[i];
+		irq = pci_irq_vector(hdev->pdev, gaudi2->irq_num_port_base + i);
+		free_irq(irq, gaudi2_port);
+	}
+}
+
+/* HW per port link/lane status mask */
+static u32 gaudi2_cn_get_link_status_mask(struct gaudi2_cn_port *gaudi2_port)
+{
+	switch (gaudi2_port->cn_port->speed) {
+	case SPEED_50000:
+		/* In 50GbE mode, HW supports up to 2 SERDES
+		 * links per port.
+		 * Note: SW uses fixed link 0 per port for
+		 * transmission. Link 1 is unused.
+		 */
+		return 0x3;
+	case SPEED_25000:
+		fallthrough;
+	case SPEED_100000:
+		/* In 100GbE mode, HW supports only one
+		 * SERDES link per port.
+		 */
+		return 0x1;
+	default:
+		dev_err(gaudi2_port->hdev->dev, "Unsupported speed %d\n",
+			gaudi2_port->cn_port->speed);
+	}
+
+	return 0;
+}
+
+static void gaudi2_cn_link_event_handler(struct gaudi2_cn_port *gaudi2_port)
+{
+	u32 curr_link_sts, link_sts_change, link_status_mask, port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	struct gaudi2_cn_port *gaudi2_port_curr;
+	u8 l, cn_m, port_offset, port_shift;
+	struct hbl_cn_port *cn_port_curr;
+	struct gaudi2_cn_device *gaudi2;
+	struct hbl_cn_macro *cn_macro;
+	bool link_up, prev_link_up;
+
+	gaudi2 = hdev->asic_specific;
+	port = gaudi2_port->cn_port->port;
+	cn_macro = gaudi2_port->cn_port->cn_macro;
+
+	curr_link_sts = (NIC_MACRO_RREG32(PRT0_MAC_CORE_MAC_REC_STS0) &
+			 PRT0_MAC_CORE_MAC_REC_STS0_REC_LINK_STS_MASK) >>
+			PRT0_MAC_CORE_MAC_REC_STS0_REC_LINK_STS_SHIFT;
+
+	/* get the change on the serdes by XOR with previous val */
+	link_sts_change = curr_link_sts ^ cn_macro->rec_link_sts;
+
+	/* store current value as previous (for next round) */
+	cn_macro->rec_link_sts = curr_link_sts;
+
+	/* calc the MACRO its link-change we need to handle */
+	cn_m = port >> 1;
+
+	/* Iterate all SERDES links and check which one was changed */
+	for (l = 0; l < NIC_MAC_LANES; l++) {
+		if (!(link_sts_change & BIT(l)))
+			continue;
+
+		/* calc port offset from current link
+		 * (2 ports per macro and 2 links per port)
+		 */
+		port_offset = l >> 1;
+		port_shift = port_offset ? 2 : 0;
+
+		/* get the port struct to handle its link according to the
+		 * current SERDES link index
+		 */
+		gaudi2_port_curr = &gaudi2->cn_ports[cn_m * 2 + port_offset];
+		cn_port_curr = gaudi2_port_curr->cn_port;
+
+		mutex_lock(&cn_port_curr->control_lock);
+
+		/* Skip in case the port is closed because the port_close method took care of
+		 * disabling the carrier and stopping the queue.
+		 */
+		if (!hbl_cn_is_port_open(cn_port_curr)) {
+			mutex_unlock(&cn_port_curr->control_lock);
+			continue;
+		}
+
+		link_status_mask = gaudi2_cn_get_link_status_mask(gaudi2_port_curr);
+		link_up = (curr_link_sts >> port_shift) & link_status_mask;
+		prev_link_up = cn_port_curr->pcs_link;
+
+		if (prev_link_up != link_up && !link_up) {
+			mutex_lock(&gaudi2_port_curr->qp_destroy_lock);
+
+			if (gaudi2_port_curr->qp_destroy_cnt && !cn_port_curr->mac_loopback) {
+				cn_port_curr->mac_loopback = true;
+				gaudi2_cn_hw_mac_loopback_cfg(gaudi2_port_curr);
+				gaudi2_port_curr->qp_destroy_mac_lpbk = true;
+			}
+
+			mutex_unlock(&gaudi2_port_curr->qp_destroy_lock);
+		}
+
+		/* Record the current link status that we got.
+		 * In case it is UP, and PHY is not ready, we don't want to actually set it and
+		 * reflect it to the user - this will be done later once the PHY will be ready.
+		 */
+		cn_port_curr->eq_pcs_link = link_up;
+
+		/* In case of link DOWN, set the actual link and reflect it to the user */
+		if (!link_up)
+			cn_port_curr->pcs_link = false;
+
+		/* Set the actual link status that is reflected to the user and print it in case
+		 * either we don't have PHY or we have PHY and it's ready.
+		 */
+		if (!hdev->phy_config_fw || cn_port_curr->phy_fw_tuned) {
+			cn_port_curr->pcs_link = link_up;
+			hbl_cn_phy_set_port_status(cn_port_curr, link_up);
+		}
+
+		mutex_unlock(&cn_port_curr->control_lock);
+	}
+}
+
+static void gaudi2_cn_eq_dispatcher_default_handler(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 event_type, port, synd;
+	struct hbl_cn_eqe eqe;
+
+	port = cn_port->port;
+
+	mutex_lock(&cn_port->control_lock);
+
+	while (!hbl_cn_eq_dispatcher_dequeue(cn_port, hdev->kernel_asid, &eqe, true)) {
+		if (!EQE_IS_VALID(&eqe)) {
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d got invalid EQE on default queue!\n", port);
+			continue;
+		}
+
+		event_type = EQE_TYPE(&eqe);
+
+		switch (event_type) {
+		case EQE_COMP:
+			dev_warn_ratelimited(hdev->dev, "Port-%d comp event for invalid CQ:%d\n",
+					     port, EQE_CQ_EVENT_CQ_NUM(&eqe));
+			break;
+		case EQE_RAW_TX_COMP:
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d raw-tx-comp event for invalid QP:%d\n",
+					     port, EQE_RAW_TX_EVENT_QPN(&eqe));
+			break;
+		case EQE_QP_ERR:
+			synd = EQE_QP_EVENT_ERR_SYND(&eqe);
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d qp-err event: %d ,%s, for invalid QP:%d\n",
+					     port, synd, gaudi2_cn_qp_err_syndrome_to_str(synd),
+					     EQE_QP_EVENT_QPN(&eqe));
+			break;
+		case EQE_COMP_ERR:
+			dev_warn_ratelimited(hdev->dev, "Port-%d cq-err event for invalid CQ:%d\n",
+					     port, EQE_CQ_EVENT_CQ_NUM(&eqe));
+			break;
+		case EQE_DB_FIFO_OVERRUN:
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d db-fifo overrun event for invalid DB:%d\n",
+					     port, EQE_DB_EVENT_DB_NUM(&eqe));
+			break;
+		case EQE_CONG:
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d congestion event for invalid CCQ:%d\n",
+					     port, EQE_CQ_EVENT_CCQ_NUM(&eqe));
+			break;
+		case EQE_CONG_ERR:
+			/* congestion error due to cc cq hw bug is known */
+			cn_port->cong_q_err_cnt++;
+			dev_dbg_ratelimited(hdev->dev, "Port-%d congestion error event\n", port);
+			break;
+		case EQE_QP_ALIGN_COUNTERS:
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d QP align counters event, for invalid QP:%d\n",
+					     port, EQE_SW_EVENT_QPN(&eqe));
+			break;
+		default:
+			dev_warn_ratelimited(hdev->dev, "Port-%d unsupported event type: %d",
+					     port, event_type);
+		}
+	}
+
+	mutex_unlock(&cn_port->control_lock);
+}
+
+static void cn_eq_handler(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 event_type, port, synd, qpn;
+	bool qp_retry_handled = false;
+	struct hbl_cn_ring *eq_ring;
+	struct hbl_cn_eqe *eqe_p;
+	int rc;
+
+	eq_ring = &gaudi2_port->eq_ring;
+	port = cn_port->port;
+
+	/* read the producer index from HW once. New event, received
+	 * after the "read once", will be handled in the next callback.
+	 */
+	eq_ring->pi_shadow = *((u32 *)RING_PI_ADDRESS(eq_ring));
+
+	while (eq_ring->ci_shadow != eq_ring->pi_shadow) {
+		eqe_p = (struct hbl_cn_eqe *)RING_BUF_ADDRESS(eq_ring) +
+			(eq_ring->ci_shadow & (eq_ring->count - 1));
+		if (!EQE_IS_VALID(eqe_p)) {
+			dev_warn_ratelimited(hdev->dev,
+					     "Port-%d got invalid EQE on EQ (eq.data[0] 0x%x, ci 0x%x, pi 0x%x)\n",
+					     port, eqe_p->data[0], eq_ring->ci_shadow,
+					     eq_ring->pi_shadow);
+		} else {
+			event_type = EQE_TYPE(eqe_p);
+
+			if (event_type == EQE_QP_ERR) {
+				synd = EQE_QP_EVENT_ERR_SYND(eqe_p);
+				if (gaudi2_port->adaptive_timeout_en && synd ==
+				    NIC_QP_ERR_RETRY_SYNDROME) {
+					qpn = EQE_RAW_TX_EVENT_QPN(eqe_p);
+					if (qpn != RAW_QPN)
+						qp_retry_handled =
+							gaudi2_handle_qp_error_retry(cn_port, qpn);
+				}
+			}
+
+			/* In case this is link event, we handle it now and the dispatcher won't be
+			 * involved.
+			 */
+			if (event_type == EQE_LINK_STATUS) {
+				gaudi2_cn_link_event_handler(gaudi2_port);
+			/* ignore CQ errors when CQ is in overrun, as CQ overflow errors are
+			 * expected.
+			 */
+			} else if (!qp_retry_handled && ((event_type != EQE_COMP_ERR) ||
+				!gaudi2_cn_is_cq_in_overrun(cn_port, EQE_CQ_EVENT_CQ_NUM(eqe_p)))) {
+				rc = hbl_cn_eq_dispatcher_enqueue(cn_port, eqe_p);
+				if (rc)
+					dev_warn_ratelimited(hdev->dev,
+							     "failed to dispatch event %d, err %d\n",
+							     event_type, rc);
+			}
+
+			/* Mark the EQ-entry is not valid */
+			EQE_SET_INVALID(eqe_p);
+		}
+
+		eq_ring->rep_idx++;
+		eq_ring->ci_shadow = (eq_ring->ci_shadow + 1) & EQ_IDX_MASK;
+
+		/* Update the HW consumer index, every quarter ring, with an
+		 * absolute value (ci_shadow is a wrap-around value).
+		 * Use the read producer index value for that.
+		 */
+		if (eq_ring->rep_idx > (eq_ring->count / 4) - 1) {
+			eq_ring->rep_idx = 0;
+			NIC_WREG32(NIC0_QPC0_EVENT_QUE_CONSUMER_INDEX, eq_ring->ci_shadow);
+		}
+	}
+
+	if (!qp_retry_handled) {
+		hbl_cn_eq_handler(cn_port);
+
+		/* Handle unknown resources and events */
+		gaudi2_cn_eq_dispatcher_default_handler(gaudi2_port);
+	}
+}
+
+static inline void gaudi2_cn_eq_clr_interrupts(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = gaudi2_port->cn_port->port;
+
+	/* Release the HW to allow more EQ interrupts.
+	 * No need for interrupt masking. As long as the SW hasn't set the clear reg,
+	 * new interrupts won't be raised
+	 */
+	NIC_WREG32(NIC0_QPC0_INTERRUPT_CLR, 0x200);
+
+	/* flush write so the interrupt will be cleared as soon as possible */
+	NIC_RREG32(NIC0_QPC0_INTERRUPT_CLR);
+}
+
+static void gaudi2_cn_eq_work(struct work_struct *work)
+{
+	struct gaudi2_cn_port *gaudi2_port = container_of(work, struct gaudi2_cn_port,
+							  eq_work.work);
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+
+	cn_eq_handler(gaudi2_port);
+
+	if (hdev->poll_enable)
+		schedule_delayed_work(&gaudi2_port->eq_work, msecs_to_jiffies(1));
+	else
+		gaudi2_cn_eq_clr_interrupts(gaudi2_port);
+}
+
+/* Use this routine when working with real HW */
+static irqreturn_t gaudi2_cn_eq_threaded_isr(int irq, void *arg)
+{
+	struct gaudi2_cn_port *gaudi2_port = arg;
+
+	gaudi2_cn_eq_clr_interrupts(gaudi2_port);
+	cn_eq_handler(gaudi2_port);
+
+	return IRQ_HANDLED;
+}
+
+static void gaudi2_cn_eq_hw_config(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_ring *ring = &gaudi2_port->eq_ring;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = gaudi2_port->cn_port->port;
+
+	WARN_ON_CACHE_UNALIGNED(RING_PI_DMA_ADDRESS(ring));
+	WARN_ON_CACHE_UNALIGNED(RING_BUF_DMA_ADDRESS(ring));
+
+	/* set base address for event queue */
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_PI_ADDR_63_32, upper_32_bits(RING_PI_DMA_ADDRESS(ring)));
+
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_PI_ADDR_31_7,
+		   lower_32_bits(RING_PI_DMA_ADDRESS(ring)) >> 7);
+
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_BASE_ADDR_63_32,
+		   upper_32_bits(RING_BUF_DMA_ADDRESS(ring)));
+
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_BASE_ADDR_31_7,
+		   lower_32_bits(RING_BUF_DMA_ADDRESS(ring)) >> 7);
+
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_LOG_SIZE, ilog2(ring->count));
+
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_WRITE_INDEX, 0);
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_PRODUCER_INDEX, 0);
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_CONSUMER_INDEX, 0);
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_CONSUMER_INDEX_CB, 0);
+
+	NIC_WREG32(NIC0_QPC0_EVENT_QUE_CFG, NIC0_QPC0_EVENT_QUE_CFG_INTERRUPT_PER_EQE_MASK |
+		   NIC0_QPC0_EVENT_QUE_CFG_WRITE_PI_EN_MASK | NIC0_QPC0_EVENT_QUE_CFG_ENABLE_MASK);
+
+	NIC_WREG32(NIC0_QPC0_AXUSER_EV_QUE_LBW_INTR_HB_WR_OVRD_LO, 0xFFFFFBFF);
+	NIC_WREG32(NIC0_QPC0_AXUSER_EV_QUE_LBW_INTR_HB_RD_OVRD_LO, 0xFFFFFBFF);
+
+	/* reset SW indices */
+	*((u32 *)RING_PI_ADDRESS(ring)) = 0;
+	ring->pi_shadow = 0;
+	ring->ci_shadow = 0;
+	ring->rep_idx = 0;
+}
+
+static void gaudi2_cn_eq_interrupts_enable_conditionally(struct gaudi2_cn_port *gaudi2_port,
+							 bool poll_enable)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port, sob_id;
+	struct gaudi2_cn_device *gaudi2;
+
+	gaudi2 = hdev->asic_specific;
+
+	if (poll_enable) {
+		/* Masking all QPC Interrupts except EQ wire int */
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_MASK, 0x3FF);
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_EN,
+			   NIC0_QPC0_INTERRUPT_EN_INTERRUPT10_WIRE_EN_MASK);
+	} else {
+		sob_id = gaudi2->sob_id_base + port;
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_BASE_9,
+			   DCORE0_SYNC_MNGR_OBJS_SOB_OBJ_0 + sob_id * sizeof(u32));
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_DATA_9, gaudi2->sob_inc_cfg_val);
+
+		/* Masking all QPC Interrupts except EQ int and error event queue int */
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_MASK, 0x1FF);
+
+		NIC_WREG32(NIC0_QPC0_INTERRUPT_EN,
+			   NIC0_QPC0_INTERRUPT_EN_INTERRUPT9_MSI_EN_MASK |
+			   NIC0_QPC0_INTERRUPT_EN_INTERRUPT10_WIRE_EN_MASK);
+	}
+
+	/* flush */
+	NIC_RREG32(NIC0_QPC0_INTERRUPT_EN);
+}
+
+static void gaudi2_cn_eq_interrupts_disable(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+	u32 port = cn_port->port;
+
+	/* disabling and masking all QPC Interrupts */
+	NIC_WREG32(NIC0_QPC0_INTERRUPT_EN, 0);
+	NIC_WREG32(NIC0_QPC0_INTERRUPT_MASK, 0x7FF);
+
+	/* flush */
+	NIC_RREG32(NIC0_QPC0_INTERRUPT_EN);
+}
+
+void gaudi2_cn_eq_enter_temporal_polling_mode(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	int i;
+
+	if (hdev->poll_enable)
+		return;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		gaudi2_port = &gaudi2->cn_ports[i];
+		gaudi2_cn_eq_interrupts_enable_conditionally(gaudi2_port, true);
+	}
+
+	hdev->poll_enable = true;
+
+	/* wait for ISRs to complete before scheduling the polling work */
+	gaudi2_cn_eq_sync_irqs(hdev);
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		gaudi2_port = &gaudi2->cn_ports[i];
+		schedule_delayed_work(&gaudi2_port->eq_work, msecs_to_jiffies(1));
+	}
+}
+
+void gaudi2_cn_eq_exit_temporal_polling_mode(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	int i;
+
+	if (!hdev->poll_enable)
+		return;
+
+	if (!gaudi2->temporal_polling)
+		return;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		gaudi2_port = &gaudi2->cn_ports[i];
+		cancel_delayed_work_sync(&gaudi2_port->eq_work);
+	}
+
+	hdev->poll_enable = false;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		gaudi2_port = &gaudi2->cn_ports[i];
+		gaudi2_cn_eq_interrupts_enable_conditionally(gaudi2_port, false);
+		/* Schedule the work as interrupts may be pending but not acked thus preventing
+		 * interrupts from triggering.
+		 * Double scheduling avoidance of the work (from the ISR and from here)
+		 * is done by the WQ scheduler itself.
+		 */
+		schedule_delayed_work(&gaudi2_port->eq_work, 0);
+	}
+}
+
+static int gaudi2_cn_eq_port_init(struct gaudi2_cn_port *gaudi2_port)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+
+	gaudi2_cn_eq_hw_config(gaudi2_port);
+
+	/* we disable eq handler here in order to prevent a crash if a race occurs
+	 * between the work-queue calling the handler routine and the eth driver
+	 * unregistering it.
+	 */
+	gaudi2_port->cn_port->eq_handler_enable = false;
+
+	INIT_DELAYED_WORK(&gaudi2_port->eq_work, gaudi2_cn_eq_work);
+
+	gaudi2_cn_eq_interrupts_enable_conditionally(gaudi2_port, hdev->poll_enable);
+
+	if (hdev->poll_enable)
+		schedule_delayed_work(&gaudi2_port->eq_work, msecs_to_jiffies(1));
+
+	return 0;
+}
+
+static void gaudi2_cn_eq_port_fini(struct gaudi2_cn_port *gaudi2_port)
+{
+	gaudi2_cn_eq_interrupts_disable(gaudi2_port);
+	cancel_delayed_work_sync(&gaudi2_port->eq_work);
+	gaudi2_port->cn_port->eq_handler_enable = false;
+}
+
+int gaudi2_cn_eq_init(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	struct gaudi2_cn_port *gaudi2_port;
+	int rc, i, port_cnt = 0;
+	u32 port;
+
+	/* Need to reset the value of 'poll_enable' for a case that we entered temporal polling mode
+	 * but didn't exit it (e.g. during a failing soft-reset).
+	 * The original value is actually the inverse of 'temporal_polling' which is set once in
+	 * sw_init and is constant.
+	 */
+	hdev->poll_enable = !gaudi2->temporal_polling;
+
+	/* Due to H/W bug on gaudi2, link events for both even and odd ports arrive only on the odd
+	 * port in the macro. Therefore, need to initialize all EQs of all ports regardless of their
+	 * enablement.
+	 */
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++, port_cnt++) {
+		gaudi2_port = &gaudi2->cn_ports[i];
+		port = gaudi2_port->cn_port->port;
+
+		rc = gaudi2_cn_eq_port_init(gaudi2_port);
+		if (rc) {
+			dev_err(hdev->dev, "Failed to init the hardware EQ, port: %d, %d\n", port,
+				rc);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	for (i = 0; i < port_cnt; i++)
+		gaudi2_cn_eq_port_fini(&gaudi2->cn_ports[i]);
+
+	return rc;
+}
+
+void gaudi2_cn_eq_fini(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	int i;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++)
+		gaudi2_cn_eq_port_fini(&gaudi2->cn_ports[i]);
+}
+
+/* event dispatcher
+ *
+ * In gaudi2 each port has a single EQ. The HW writes all the related events
+ * to this EQ. Since multiple applications can use the port at the same time we
+ * need to have a way to dispatch the app-related events to the correct
+ * application, these events will be read later on by the IB API.
+ */
+
+struct hbl_cn_ev_dq *gaudi2_cn_eq_dispatcher_select_dq(struct hbl_cn_port *cn_port,
+						       const struct hbl_cn_eqe *eqe)
+{
+	struct gaudi2_cn_port *gaudi2_port = (struct gaudi2_cn_port *)cn_port->cn_specific;
+	struct hbl_cn_ev_dqs *ev_dqs = &cn_port->ev_dqs;
+	struct hbl_cn_ev_dq *dq = NULL;
+	u32 event_type = EQE_TYPE(eqe);
+	u32 cqn, qpn, dbn, ccqn;
+
+	switch (event_type) {
+	case EQE_COMP:
+		fallthrough;
+	case EQE_COMP_ERR:
+		cqn = EQE_CQ_EVENT_CQ_NUM(eqe);
+		dq = hbl_cn_cqn_to_dq(ev_dqs, cqn, gaudi2_port->hdev);
+		break;
+	case EQE_QP_ERR:
+		qpn = EQE_QP_EVENT_QPN(eqe);
+		dq = hbl_cn_qpn_to_dq(ev_dqs, qpn);
+		break;
+	case EQE_RAW_TX_COMP:
+		qpn = EQE_RAW_TX_EVENT_QPN(eqe);
+		dq = hbl_cn_qpn_to_dq(ev_dqs, qpn);
+		break;
+	case EQE_DB_FIFO_OVERRUN:
+		dbn = EQE_DB_EVENT_DB_NUM(eqe);
+		dq = hbl_cn_dbn_to_dq(ev_dqs, dbn, gaudi2_port->hdev);
+		break;
+	case EQE_CONG:
+		ccqn = EQE_CQ_EVENT_CCQ_NUM(eqe);
+		dq = hbl_cn_ccqn_to_dq(ev_dqs, ccqn, gaudi2_port->hdev);
+		break;
+	case EQE_QP_ALIGN_COUNTERS:
+		qpn = EQE_SW_EVENT_QPN(eqe);
+		dq = hbl_cn_qpn_to_dq(ev_dqs, qpn);
+		break;
+	case EQE_CONG_ERR:
+		fallthrough;
+	case EQE_RESERVED:
+		fallthrough;
+	default:
+		dq = &ev_dqs->default_edq;
+	}
+
+	/* Unknown resources and events should be handled by default events
+	 * dispatch queue.
+	 */
+	return IS_ERR_OR_NULL(dq) ? &ev_dqs->default_edq : dq;
+}
+
+int gaudi2_cn_eq_dispatcher_register_db(struct gaudi2_cn_port *gaudi2_port, u32 asid, u32 dbn)
+{
+	struct hbl_cn_device *hdev = gaudi2_port->hdev;
+
+	if (dbn == GAUDI2_DB_FIFO_PRIVILEGE_HW_ID)
+		return -EINVAL;
+
+	if (asid != hdev->kernel_asid && dbn == GAUDI2_DB_FIFO_SECURE_HW_ID)
+		return -EINVAL;
+
+	return hbl_cn_eq_dispatcher_register_db(gaudi2_port->cn_port, asid, dbn);
+}
diff --git a/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_phy.c b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_phy.c
new file mode 100644
index 000000000000..2837fc11c43a
--- /dev/null
+++ b/drivers/net/ethernet/intel/hbl_cn/gaudi2/gaudi2_cn_phy.c
@@ -0,0 +1,2743 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+
+#include "gaudi2_cn.h"
+
+#define NIC_PHY_CFG_SIZE (NIC0_SERDES1_LANE0_REGISTER_0P00 - NIC0_SERDES0_LANE0_REGISTER_0P00)
+
+#define NIC_PHY_CFG_BASE(port) \
+		({ \
+			u32 __port = (port); \
+			((u64)(NIC_MACRO_CFG_BASE(__port) + \
+			NIC_PHY_CFG_SIZE * (u64)((__port) & 1))); \
+		})
+
+#define LANE_LO_OFF (NIC0_SERDES0_LANE1_REGISTER_0P00 - NIC0_SERDES0_LANE0_REGISTER_0P00)
+
+#define LANE_HI_OFF (NIC0_SERDES0_LANE1_REGISTER_AI00 - NIC0_SERDES0_LANE0_REGISTER_AI00)
+
+#define LANE_OFF(reg, lane) \
+		({ \
+			u32 __lane = lane; \
+			((reg) < NIC0_SERDES0_LANE0_REGISTER_AI00) ? \
+			((__lane) * LANE_LO_OFF) : ((__lane) * LANE_HI_OFF); \
+		})
+
+#define PHY_PRINT(port, lane, op, val, reg) \
+	({ \
+		if (hdev->phy_regs_print) { \
+			u32 __port = (port); \
+			dev_info(hdev->dev, "[%s],Nic,%u,Port,%u,Lane,%d,%s,0x%08x,0x%08llx\n", \
+				 __func__, __port >> 1, __port & 0x1, (lane), (op), (val), (reg)); \
+			usleep_range(1000, 2000); \
+		} \
+	})
+
+#define NIC_PHY_RREG32(reg) \
+	({ \
+		u32 _port = port; \
+		u64 _reg = NIC_PHY_CFG_BASE(_port) + (reg); \
+		u32 _val = RREG32(_reg); \
+		PHY_PRINT(_port, -1, "read", _val, _reg); \
+		_val; \
+	})
+
+#define NIC_PHY_WREG32(reg, val) \
+	do { \
+		u32 _port = port; \
+		u64 _reg = NIC_PHY_CFG_BASE(_port) + (reg); \
+		u32 _val = (val); \
+		WREG32(_reg, _val); \
+		PHY_PRINT(_port, -1, "write", _val, _reg); \
+	} while (0)
+
+#define NIC_PHY_RMWREG32(reg, val, mask) \
+	do { \
+		u32 _port = port; \
+		u64 _reg = NIC_PHY_CFG_BASE(_port) + (reg); \
+		u32 _val = (val); \
+		u32 _mask = (mask); \
+		u32 _tmp = RREG32(_reg); \
+		PHY_PRINT(_port, -1, "read(rmw)", _tmp, _reg); \
+		_tmp &= ~_mask; \
+		_tmp |= (_val << __ffs(_mask)); \
+		WREG32(_reg, _tmp); \
+		PHY_PRINT(_port, -1, "write(rmw)", _tmp, _reg); \
+	} while (0)
+
+#define NIC_PHY_RREG32_LANE(reg) \
+	({ \
+		u32 _port = port; \
+		u32 _lane = lane; \
+		u64 _reg = (reg); \
+		u64 __reg = NIC_PHY_CFG_BASE(_port) + _reg + LANE_OFF(_reg, _lane); \
+		u32 _val = RREG32(__reg); \
+		PHY_PRINT(_port, _lane, "read", _val, __reg); \
+		_val; \
+	})
+
+#define NIC_PHY_WREG32_LANE(reg, val) \
+	do { \
+		u32 _port = port; \
+		u32 _lane = lane; \
+		u64 _reg = (reg); \
+		u64 __reg = NIC_PHY_CFG_BASE(_port) + _reg + LANE_OFF(_reg, _lane); \
+		u32 _val = (val); \
+		WREG32(__reg, _val); \
+		PHY_PRINT(_port, _lane, "write", _val, __reg); \
+	} while (0)
+
+#define NIC_PHY_RMWREG32_LANE(reg, val, mask) \
+	do { \
+		u32 _port = port; \
+		u32 _lane = lane; \
+		u64 _reg = (reg); \
+		u64 __reg = NIC_PHY_CFG_BASE(_port) + _reg + LANE_OFF(_reg, _lane); \
+		u32 _val = (val); \
+		u32 _mask = (mask); \
+		u32 _tmp = RREG32(__reg); \
+		PHY_PRINT(_port, _lane, "read(rmw)", _tmp, __reg); \
+		_tmp &= ~_mask; \
+		_tmp |= (_val << __ffs(_mask)); \
+		WREG32(__reg, _tmp); \
+		PHY_PRINT(_port, _lane, "write(rmw)", _tmp, __reg); \
+	} while (0)
+
+#define NIC_PHY_READ_COUNTS_PER_MS		100000
+#define NIC_PHY_FW_TIME_CONSTANT_RATIO		64
+#define NIC_PHY_FW_TUNING_INTERVAL_MS		100
+#define NIC_PHY_FW_TUNING_TIMEOUT_MS		(30 * MSEC_PER_SEC) /* 30 seconds */
+#define NIC_PHY_PAM4_BER_FACTOR			53125000
+#define NIC_PHY_NRZ_BER_FACTOR			25781250
+
+#define NIC_PHY_TX_POL_MASK_HL225		0xF00000000430
+#define NIC_PHY_RX_POL_MASK_HL225		0x0FFFFFFFFBCF
+#define NIC_PHY_TX_POL_MASK_HLS2		0x0
+#define NIC_PHY_RX_POL_MASK_HLS2		0x0
+
+#define NIC_PHY_PCS_LINK_DOWN_TH_S		5
+#define NIC_PHY_MAC_REMOTE_FAULT_TH_S		10
+
+#define NIC_PHY_PCS_SETTLING_WAIT_MS		(5 * MSEC_PER_SEC)
+#define NIC_PHY_PCS_STRESS_INT_MS		10
+#define NIC_PHY_PCS_STEADY_STATE_INT_MS		(1 * MSEC_PER_SEC)
+
+#define NIC_PHY_PCS_TESTING_WINDOW_S		20
+#define NIC_PHY_PCS_TESTING_WINDOW_MS		(NIC_PHY_PCS_TESTING_WINDOW_S * MSEC_PER_SEC)
+#define NIC_PHY_PCS_STRESS_WINDOW_MS \
+		(NIC_PHY_PCS_TESTING_WINDOW_MS - NIC_PHY_PCS_SETTLING_WAIT_MS)
+
+#define NIC_PHY_PCS_MAX_LINK_TOGGLES		5
+
+enum tx_taps_sets {
+	NIC_PHY_TX_TAPS_SET_1 = 0,
+	NIC_PHY_TX_TAPS_SET_2,
+	NIC_PHY_TX_TAPS_SET_3,
+	NIC_PHY_TX_TAPS_SET_4,
+
+	NIC_PHY_TX_TAPS_NUM_SETS
+};
+
+#define NIC_PHY_DEFAULT_TX_TAPS_DEFAULT		NIC_PHY_TX_TAPS_SET_1
+
+struct hbl_cn_tx_taps tx_taps_set_array[NIC_PHY_TX_TAPS_NUM_SETS] = {
+	{.pam4_taps = {2, -10, 23, 0, 0}, .nrz_taps = {0, -10, 26, 0, 0}},
+	{.pam4_taps = {0, -6, 22, 0, 0}, .nrz_taps = {0, -10, 26, 0, 0}},
+	{.pam4_taps = {3, -12, 21, 0, 0}, .nrz_taps = {0, -10, 26, 0, 0}},
+	{.pam4_taps = {1, -7, 18, 0, 0}, .nrz_taps = {0, -10, 26, 0, 0}},
+};
+
+static enum tx_taps_sets tx_taps_cfg_array[][2] = {
+	{NIC_PHY_TX_TAPS_SET_1, NIC_PHY_TX_TAPS_SET_1},
+	{NIC_PHY_TX_TAPS_SET_1, NIC_PHY_TX_TAPS_SET_2},
+	{NIC_PHY_TX_TAPS_SET_2, NIC_PHY_TX_TAPS_SET_1},
+	{NIC_PHY_TX_TAPS_SET_2, NIC_PHY_TX_TAPS_SET_2},
+	{NIC_PHY_TX_TAPS_SET_1, NIC_PHY_TX_TAPS_SET_3},
+	{NIC_PHY_TX_TAPS_SET_3, NIC_PHY_TX_TAPS_SET_1},
+	{NIC_PHY_TX_TAPS_SET_3, NIC_PHY_TX_TAPS_SET_3},
+	{NIC_PHY_TX_TAPS_SET_1, NIC_PHY_TX_TAPS_SET_4},
+	{NIC_PHY_TX_TAPS_SET_4, NIC_PHY_TX_TAPS_SET_1},
+	{NIC_PHY_TX_TAPS_SET_4, NIC_PHY_TX_TAPS_SET_4}
+};
+
+static size_t tx_taps_num_cfgs = ARRAY_SIZE(tx_taps_cfg_array);
+
+#define NIC_MAC_LANE_MAP(lane_0, lane_1, lane_2, lane_3) \
+	(((lane_0) & \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES0_TX0_SWAP_ID_MASK) | \
+	(((lane_1) & \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES0_TX0_SWAP_ID_MASK) << \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES0_TX1_SWAP_ID_SHIFT) | \
+	(((lane_2) & \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES0_TX0_SWAP_ID_MASK) << \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES1_TX0_SWAP_ID_SHIFT) | \
+	(((lane_3) & \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES0_TX0_SWAP_ID_MASK) << \
+	NIC0_PHY_PHY_ASYNC_LANE_SWAP_SERDES1_TX1_SWAP_ID_SHIFT))
+
+/* Lane map for HL-225 */
+static u32 default_cn_mac_lane_remap[] = {
+	/* MACRO 0 */
+	NIC_MAC_LANE_MAP(NIC_MAC_LANE_3, NIC_MAC_LANE_1, NIC_MAC_LANE_0, NIC_MAC_LANE_2),
+	/* MACRO 1-10. Use default HW power on reset mapping. */
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+	/* MACRO 11 */
+	NIC_MAC_LANE_MAP(NIC_MAC_LANE_1, NIC_MAC_LANE_0, NIC_MAC_LANE_3, NIC_MAC_LANE_2),
+};
+
+/* Firmware lane mapping per macro are nibbles.
+ * e.g. 0x3210 maps to lane 3/2/1/0
+ */
+#define FW_PARSE_LANE_MAP(macro, lane) \
+	({ \
+		u32 _lane = (lane); \
+		((macro) & (0xf << (_lane * 4))) >> (_lane * 4); \
+	})
+
+enum lane_state {
+	READY,
+	NOT_READY,
+	FAILURE
+};
+
+#define GAUDI2_PHY_FW_FILE	"habanalabs/gaudi2/gaudi2_cn_fw.bin"
+
+MODULE_FIRMWARE(GAUDI2_PHY_FW_FILE);
+
+const char *gaudi2_cn_phy_get_fw_name(void)
+{
+	return GAUDI2_PHY_FW_FILE;
+}
+
+static int get_tx_lane_in_macro(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 lane_in_macro, lane_swap_val;
+	int tx_lane;
+
+	lane_in_macro = (port & 0x1) * 2 + lane;
+	lane_swap_val = hdev->mac_lane_remap[port >> 1];
+
+	if (!lane_swap_val)
+		return lane_in_macro;
+
+	for (tx_lane = 0; tx_lane < NIC_MAC_NUM_OF_LANES; tx_lane++) {
+		if (((lane_swap_val >> (tx_lane * 2)) & 0x3) == lane_in_macro)
+			break;
+	}
+
+	return tx_lane;
+}
+
+static void get_tx_port_and_lane(struct hbl_cn_device *hdev, u32 port, int lane, u32 *tx_port,
+				 int *tx_lane)
+{
+	struct hbl_cn_port *cn_port = &hdev->cn_ports[port];
+	u32 tx_lane_in_macro, abs_tx_lane_idx;
+
+	if (!cn_port->auto_neg_enable) {
+		*tx_port = port;
+		*tx_lane = lane;
+		return;
+	}
+
+	tx_lane_in_macro = get_tx_lane_in_macro(hdev, port, lane);
+	abs_tx_lane_idx = (port >> 1) * NIC_MAC_NUM_OF_LANES + tx_lane_in_macro;
+
+	*tx_port = abs_tx_lane_idx >> 1;
+	*tx_lane = abs_tx_lane_idx & 0x1;
+}
+
+static bool is_lane_swapping(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 tx_port;
+	int tx_lane;
+
+	get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+	return (tx_port != port) || (tx_lane != lane);
+}
+
+static void set_fw_lane_mapping(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_cpucp_info *cpucp_info = hdev->cpucp_info;
+	u16 cpu_macro_tx_swap_map;
+	int i;
+
+	for (i = 0; i < NIC_NUMBER_OF_MACROS; i++) {
+		cpu_macro_tx_swap_map = cpucp_info->tx_swap_map[i];
+		hdev->mac_lane_remap[i] = NIC_MAC_LANE_MAP(FW_PARSE_LANE_MAP(cpu_macro_tx_swap_map,
+									     0), /* lane 0 */
+							   FW_PARSE_LANE_MAP(cpu_macro_tx_swap_map,
+									     1), /* lane 1 */
+							   FW_PARSE_LANE_MAP(cpu_macro_tx_swap_map,
+									     2), /* lane 2 */
+							   FW_PARSE_LANE_MAP(cpu_macro_tx_swap_map,
+									     3)); /* lane 3 */
+	}
+}
+
+static void mac_lane_remap(struct hbl_cn_device *hdev, u32 port)
+{
+	if (hdev->mac_lane_remap[port >> 1])
+		NIC_MACRO_WREG32(NIC0_PHY_PHY_ASYNC_LANE_SWAP, hdev->mac_lane_remap[port >> 1]);
+}
+
+static void soft_reset(struct hbl_cn_device *hdev, u32 port)
+{
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980D, 0x888,
+			 NIC0_SERDES0_REGISTER_980D_DOMAIN_RESET_MASK);
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980D, 0x0,
+			 NIC0_SERDES0_REGISTER_980D_DOMAIN_RESET_MASK);
+}
+
+static void logic_reset(struct hbl_cn_device *hdev, u32 port)
+{
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980D, 0x777,
+			 NIC0_SERDES0_REGISTER_980D_DOMAIN_RESET_MASK);
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980D, 0x0,
+			 NIC0_SERDES0_REGISTER_980D_DOMAIN_RESET_MASK);
+}
+
+static void cpu_reset(struct hbl_cn_device *hdev, u32 port)
+{
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980D, 0xAAA,
+			 NIC0_SERDES0_REGISTER_980D_DOMAIN_RESET_MASK);
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980D, 0x0,
+			 NIC0_SERDES0_REGISTER_980D_DOMAIN_RESET_MASK);
+}
+
+static int fw_cmd(struct hbl_cn_device *hdev, u32 port, u32 cmd, u32 *detail, u32 expected_res,
+		  u32 *res_ptr)
+{
+	u32 res, val, checks = 0;
+
+	if (detail)
+		NIC_PHY_WREG32(NIC0_SERDES0_REGISTER_9816, *detail);
+
+	NIC_PHY_WREG32(NIC0_SERDES0_REGISTER_9815, cmd);
+
+	do {
+		usleep_range(1000, 2000);
+		res = NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9815);
+		if (checks++ > NIC_PHY_READ_COUNTS_PER_MS) {
+			dev_dbg(hdev->dev, "timeout for PHY cmd 0x%x port %u\n", cmd, port);
+			return -ETIMEDOUT;
+		}
+	} while (res == cmd);
+
+	val = (res >> 8) & 0xF;
+
+	if (val != expected_res) {
+		dev_dbg(hdev->dev, "cmd 0x%x returned error 0x%x port %u\n", cmd, val, port);
+		return -EFAULT;
+	}
+
+	*res_ptr = res;
+
+	return 0;
+}
+
+static void clock_init(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 first_val, second_val;
+
+	if (port & 0x1) { /* raven 1 */
+		if (lane == 0) {
+			first_val = 0xA9E0;
+			second_val = 0x9B9E;
+		} else { /* lane 1 */
+			first_val = 0xA9E0;
+			second_val = 0x9B9E;
+		}
+	} else { /* raven 0 */
+		if (lane == 0) {
+			first_val = 0x59E0;
+			second_val = 0x9B5E;
+		} else { /* lane 1 */
+			first_val = 0xA9E0;
+			second_val = 0x9B9E;
+		}
+	}
+
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PCC, first_val);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0NF3, second_val);
+}
+
+static u32 int_to_twos(s32 val, u8 bitwidth)
+{
+	return val < 0 ? (1 << bitwidth) + val : val;
+}
+
+static int twos_to_int(unsigned int val, u8 bitwidth)
+{
+	u32 mask = 1 << (bitwidth - 1);
+
+	return -(val & mask) + (val & ~mask);
+}
+
+static void set_tx_taps(struct hbl_cn_device *hdev, u32 port, int lane, s32 tx_pre2, s32 tx_pre1,
+			s32 tx_main, s32 tx_post1, s32 tx_post2, bool pam4)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA5, int_to_twos(tx_pre2, 8),
+			      NIC0_SERDES0_LANE0_REGISTER_0PA5_TX_PRE_2_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA7, int_to_twos(tx_pre1, 8),
+			      NIC0_SERDES0_LANE0_REGISTER_0PA7_TX_PRE_1_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA9, int_to_twos(tx_main, 8),
+			      NIC0_SERDES0_LANE0_REGISTER_0PA9_TX_MAIN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAB, int_to_twos(tx_post1, 8),
+			      NIC0_SERDES0_LANE0_REGISTER_0PAB_TX_POST_1_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAD, int_to_twos(tx_post2, 8),
+			      NIC0_SERDES0_LANE0_REGISTER_0PAD_TX_POST_2_MASK);
+
+	dev_dbg(hdev->dev, "Card %u Port %u lane %d: set %s tx taps [%d,%d,%d,%d,%d]\n",
+		hdev->card_location, port, lane, pam4 ? "PAM4" : "NRZ", tx_pre2, tx_pre1, tx_main,
+		tx_post1, tx_post2);
+}
+
+static void set_tx_taps_cfg(struct hbl_cn_device *hdev, u32 port, int lane, u8 cfg, bool pam4,
+			    bool reset_taps)
+{
+	enum tx_taps_sets set_id;
+	u32 abs_lane_idx;
+	s32 *taps;
+
+	set_id = tx_taps_cfg_array[cfg][lane];
+	abs_lane_idx = (port << 1) + lane;
+
+	if (pam4) {
+		taps = hdev->phy_tx_taps[abs_lane_idx].pam4_taps;
+		memcpy(taps, tx_taps_set_array[set_id].pam4_taps,
+		       sizeof(hdev->phy_tx_taps[abs_lane_idx].pam4_taps));
+	} else {
+		taps = hdev->phy_tx_taps[abs_lane_idx].nrz_taps;
+		memcpy(taps, tx_taps_set_array[set_id].nrz_taps,
+		       sizeof(hdev->phy_tx_taps[abs_lane_idx].nrz_taps));
+	}
+
+	if (reset_taps) {
+		/* Here we first reset the Tx taps (setting all to zero) in order to force link
+		 * down on the remote port, so it will have a "fresh start" when setting the next
+		 * Tx taps set.
+		 */
+		set_tx_taps(hdev, port, lane, 0, 0, 0, 0, 0, pam4);
+		msleep(100);
+	}
+
+	set_tx_taps(hdev, port, lane, taps[0], taps[1], taps[2], taps[3], taps[4], pam4);
+}
+
+static u8 get_curr_tx_taps_cfg(struct hbl_cn_device *hdev, u32 port)
+{
+	struct gaudi2_cn_port *gaudi2_port = hdev->cn_ports[port].cn_specific;
+
+	return gaudi2_port->tx_taps_cfg;
+}
+
+static void init_pam4_tx(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA1, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA2, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA3, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA4, 0x0);
+	/* data quite */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x6320);
+	/* auto symmetric, scale */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAF, 0xFAC9);
+	/* data, prbs */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x4000);
+	/* cursor -2 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA5, 0x100);
+	/* cursor -1 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA7, 0xF900);
+	/* cursor -main */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA9, 0x1700);
+	/* cursor +1 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAB, 0x0);
+	/* cursor +2 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAD, 0x0);
+}
+
+static void init_pam4_rx(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	/* ac-couple always */
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PF8, 0x1,
+			      NIC0_SERDES0_LANE0_REGISTER_0PF8_AC_COUPLE_EN_MASK);
+}
+
+static void set_lane_mode_tx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4)
+{
+	if (pam4) {
+		/* Disable NRZ mode */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x0,
+				      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_MODE_MASK);
+		/* Disable NRZ PRBS Generator */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x0,
+				      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_PRBS_GEN_EN_MASK);
+		/* Enable PAM4 PRBS Generator */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_CLK_EN_MASK);
+	} else {
+		/* Disable PAM4 PRBS Generator */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x0,
+				      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_CLK_EN_MASK);
+		/* Enable NRZ mode */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_MODE_MASK);
+		/* Enable NRZ PRBS Generator */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_PRBS_GEN_EN_MASK);
+	}
+}
+
+static void set_lane_mode_rx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4)
+{
+	if (pam4)
+		/* Enable PAM4 mode */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P41, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0P41_PAM4_EN_MASK);
+	else
+		/* Disable PAM4 mode */
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P41, 0x0,
+				      NIC0_SERDES0_LANE0_REGISTER_0P41_PAM4_EN_MASK);
+}
+
+static void prbs_mode_select_tx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4,
+				char *mode)
+{
+	u32 val;
+
+	if (!mode || strncmp(mode, "PRBS", strlen("PRBS")))
+		return;
+
+	if (pam4) {
+		if (!strncmp(mode, "PRBS9", strlen("PRBS9")))
+			val = 0;
+		else if (!strncmp(mode, "PRBS13", strlen("PRBS13")))
+			val = 1;
+		else if (!strncmp(mode, "PRBS15", strlen("PRBS15")))
+			val = 2;
+		else /* PRBS31 */
+			val = 3;
+
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, val,
+				      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_MODE_MASK);
+	} else {
+		if (!strncmp(mode, "PRBS9", strlen("PRBS9")))
+			val = 0;
+		else if (!strncmp(mode, "PRBS15", strlen("PRBS15")))
+			val = 1;
+		else if (!strncmp(mode, "PRBS23", strlen("PRBS23")))
+			val = 2;
+		else /* PRBS31 */
+			val = 3;
+
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, val,
+				      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_MODE_MASK);
+	}
+
+	val = pam4 ? 0 : 1;
+
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, val,
+			      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_PRBS_CLK_EN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, val,
+			      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_PRBS_GEN_EN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, val,
+			      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_NRZ_MODE_MASK);
+
+	if (pam4)
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x0,
+				      NIC0_SERDES0_LANE0_REGISTER_0PB0_TX_HALF_RATE_EN_MASK);
+
+	val = pam4 ? 1 : 0;
+
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x1,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_TEST_DATA_SRC_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, val,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_CLK_EN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x1,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PAM4_TEST_EN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, val,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_GEN_EN_MASK);
+}
+
+static void prbs_mode_select_rx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4,
+				char *mode)
+{
+	u32 val;
+
+	if (!mode || strncmp(mode, "PRBS", strlen("PRBS")))
+		return;
+
+	if (pam4) {
+		if (!strncmp(mode, "PRBS9", strlen("PRBS9")))
+			val = 0;
+		else if (!strncmp(mode, "PRBS13", strlen("PRBS13")))
+			val = 1;
+		else if (!strncmp(mode, "PRBS15", strlen("PRBS15")))
+			val = 2;
+		else /* PRBS31 */
+			val = 3;
+
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, val,
+				      NIC0_SERDES0_LANE0_REGISTER_0P43_PRBS_MODE_SEL_MASK);
+	} else {
+		if (!strncmp(mode, "PRBS9", strlen("PRBS9")))
+			val = 0;
+		else if (!strncmp(mode, "PRBS15", strlen("PRBS15")))
+			val = 1;
+		else if (!strncmp(mode, "PRBS23", strlen("PRBS23")))
+			val = 2;
+		else /* PRBS31 */
+			val = 3;
+
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N61, val,
+				      NIC0_SERDES0_LANE0_REGISTER_0N61_NRZ_PRBS_MODE_SEL_MASK);
+	}
+
+	if (pam4) {
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0P43_PU_PRBS_CHKR_MASK);
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0P43_PU_PRBS_SYNC_CHKR_MASK);
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0P43_RX_PRBS_AUTO_SYNC_EN_MASK);
+	} else {
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N61, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0N61_PRBS_CHKR_EN_MASK);
+	}
+}
+
+static void set_default_polarity_values(struct hbl_cn_device *hdev)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	enum gaudi2_setup_type setup_type;
+	u64 pol_tx, pol_rx;
+
+	setup_type = gaudi2->setup_type;
+
+	if (hdev->skip_phy_pol_cfg)
+		return;
+
+	switch (setup_type) {
+	case GAUDI2_SETUP_TYPE_HLS2:
+		pol_tx = NIC_PHY_TX_POL_MASK_HL225 ^ NIC_PHY_TX_POL_MASK_HLS2;
+		pol_rx = NIC_PHY_RX_POL_MASK_HL225 ^ NIC_PHY_RX_POL_MASK_HLS2;
+		break;
+	default:
+		dev_err(hdev->dev, "Wrong setup type %d\n", setup_type);
+		return;
+	}
+
+	hdev->pol_tx_mask = pol_tx;
+	hdev->pol_rx_mask = pol_rx;
+}
+
+static void set_default_mac_lane_remap(struct hbl_cn_device *hdev)
+{
+	memcpy(hdev->mac_lane_remap, default_cn_mac_lane_remap,
+	       sizeof(default_cn_mac_lane_remap));
+}
+
+static s32 get_pam4_tap_pre2(struct hbl_cn_device *hdev, u32 card_location, u32 abs_lane_idx)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	enum gaudi2_setup_type setup_type;
+
+	setup_type = gaudi2->setup_type;
+
+	switch (setup_type) {
+	case GAUDI2_SETUP_TYPE_HLS2:
+		return tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].pam4_taps[0];
+	default:
+		dev_err(hdev->dev, "Wrong setup type %d\n", setup_type);
+	}
+
+	return 2;
+}
+
+static s32 get_pam4_tap_pre1(struct hbl_cn_device *hdev, u32 card_location, u32 abs_lane_idx)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	enum gaudi2_setup_type setup_type;
+
+	setup_type = gaudi2->setup_type;
+
+	switch (setup_type) {
+	case GAUDI2_SETUP_TYPE_HLS2:
+		return tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].pam4_taps[1];
+	default:
+		dev_err(hdev->dev, "Wrong setup type %d\n", setup_type);
+	}
+
+	return -12;
+}
+
+static s32 get_pam4_tap_main(struct hbl_cn_device *hdev, u32 card_location, u32 abs_lane_idx)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	enum gaudi2_setup_type setup_type;
+
+	setup_type = gaudi2->setup_type;
+
+	switch (setup_type) {
+	case GAUDI2_SETUP_TYPE_HLS2:
+		return tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].pam4_taps[2];
+	default:
+		dev_err(hdev->dev, "Wrong setup type %d\n", setup_type);
+	}
+
+	return 22;
+}
+
+static s32 get_pam4_tap_post1(struct hbl_cn_device *hdev, u32 card_location, u32 abs_lane_idx)
+{
+	return tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].pam4_taps[3];
+}
+
+static s32 get_pam4_tap_post2(struct hbl_cn_device *hdev, u32 card_location, u32 abs_lane_idx)
+{
+	return tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].pam4_taps[4];
+}
+
+static void set_default_tx_taps_values(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_properties *cn_props = &hdev->cn_props;
+	u32 card_location;
+	int abs_lane_idx;
+	s32 *taps;
+
+	card_location = hdev->card_location;
+
+	for (abs_lane_idx = 0; abs_lane_idx < cn_props->max_num_of_lanes; abs_lane_idx++) {
+		/* PAM4 */
+		taps = hdev->phy_tx_taps[abs_lane_idx].pam4_taps;
+		taps[0] = get_pam4_tap_pre2(hdev, card_location, abs_lane_idx);
+		taps[1] = get_pam4_tap_pre1(hdev, card_location, abs_lane_idx);
+		taps[2] = get_pam4_tap_main(hdev, card_location, abs_lane_idx);
+		taps[3] = get_pam4_tap_post1(hdev, card_location, abs_lane_idx);
+		taps[4] = get_pam4_tap_post2(hdev, card_location, abs_lane_idx);
+
+		/* NRZ */
+		taps = hdev->phy_tx_taps[abs_lane_idx].nrz_taps;
+		taps[0] = tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].nrz_taps[0];
+		taps[1] = tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].nrz_taps[1];
+		taps[2] = tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].nrz_taps[2];
+		taps[3] = tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].nrz_taps[3];
+		taps[4] = tx_taps_set_array[NIC_PHY_DEFAULT_TX_TAPS_DEFAULT].nrz_taps[4];
+	}
+}
+
+static void set_pol_tx(struct hbl_cn_device *hdev, u32 port, int lane, u32 tx_pol)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, tx_pol,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_ANA_OUT_FLIP_MASK);
+}
+
+static void set_pol_rx(struct hbl_cn_device *hdev, u32 port, int lane, u32 rx_pol)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, rx_pol,
+			      NIC0_SERDES0_LANE0_REGISTER_0P43_RX_DATA_FLIP_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N61, rx_pol,
+			      NIC0_SERDES0_LANE0_REGISTER_0N61_PRBS_CHECK_FLIP_MASK);
+}
+
+static void set_gc_tx(struct hbl_cn_device *hdev, u32 port, int lane, u32 tx_gc)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAF, tx_gc,
+			      NIC0_SERDES0_LANE0_REGISTER_0PAF_TX_GRAYCODE_EN_MASK);
+}
+
+static void set_gc_rx(struct hbl_cn_device *hdev, u32 port, int lane, u32 rx_gc)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P42, rx_gc,
+			      NIC0_SERDES0_LANE0_REGISTER_0P42_RX_GRAYCODE_EN_MASK);
+}
+
+static void set_pc_tx(struct hbl_cn_device *hdev, u32 port, int lane, u32 tx_pc)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAF, tx_pc,
+			      NIC0_SERDES0_LANE0_REGISTER_0PAF_TX_PRECODE_EN_MASK);
+}
+
+static void set_pc_rx(struct hbl_cn_device *hdev, u32 port, int lane, u32 rx_pc)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P42, rx_pc,
+			      NIC0_SERDES0_LANE0_REGISTER_0P42_RX_PRECODE_EN_MASK);
+}
+
+static void set_msblsb_tx(struct hbl_cn_device *hdev, u32 port, int lane, u32 tx_msblsb)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAF, tx_msblsb,
+			      NIC0_SERDES0_LANE0_REGISTER_0PAF_TX_SWAP_MSB_LSB_MASK);
+}
+
+static void set_msblsb_rx(struct hbl_cn_device *hdev, u32 port, int lane, u32 rx_msblsb)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, rx_msblsb,
+			      NIC0_SERDES0_LANE0_REGISTER_0P43_RX_SWAP_MSB_LSB_MASK);
+}
+
+static void init_lane_for_fw_tx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4,
+				bool do_lt)
+{
+	u32 abs_lane_idx, tx_pol, tx_gc, tx_msblsb;
+
+	abs_lane_idx = (port << 1) + lane;
+	tx_pol = (hdev->pol_tx_mask >> abs_lane_idx) & 1;
+
+	tx_gc = (pam4 && !do_lt) ? 1 : 0;
+	tx_msblsb = do_lt ? 1 : 0;
+
+	set_lane_mode_tx(hdev, port, lane, pam4);
+	set_gc_tx(hdev, port, lane, tx_gc);
+	set_pc_tx(hdev, port, lane, 0);
+	set_msblsb_tx(hdev, port, lane, tx_msblsb);
+	set_pol_tx(hdev, port, lane, tx_pol);
+}
+
+static void init_lane_for_fw_rx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4,
+				bool do_lt)
+{
+	u32 abs_lane_idx, rx_pol, rx_gc, rx_msblsb;
+
+	abs_lane_idx = (port << 1) + lane;
+	rx_pol = (hdev->pol_rx_mask >> abs_lane_idx) & 1;
+
+	rx_gc = (pam4 && !do_lt) ? 1 : 0;
+	rx_msblsb = do_lt ? 1 : 0;
+
+	set_lane_mode_rx(hdev, port, lane, pam4);
+	set_gc_rx(hdev, port, lane, rx_gc);
+	set_pc_rx(hdev, port, lane, 0);
+	set_msblsb_rx(hdev, port, lane, rx_msblsb);
+	set_pol_rx(hdev, port, lane, rx_pol);
+}
+
+static void set_functional_mode_lane(struct hbl_cn_device *hdev, u32 port, int lane, bool do_lt)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_CLK_EN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PAM4_TEST_EN_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PRBS_GEN_EN_MASK);
+
+	if (do_lt)
+		NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AN10, 0x5);
+	else
+		NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AN10, 0);
+}
+
+static void set_functional_mode(struct hbl_cn_device *hdev, u32 port)
+{
+	struct hbl_cn_port *cn_port = &hdev->cn_ports[port];
+	int lane, tx_lane;
+	u32 tx_port;
+	bool do_lt;
+
+	do_lt = cn_port->auto_neg_enable;
+
+	for (lane = 0; lane < 2; lane++) {
+		get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+		set_functional_mode_lane(hdev, tx_port, tx_lane, do_lt);
+	}
+
+	cn_port->phy_func_mode_en = true;
+}
+
+static u32 get_fw_reg(struct hbl_cn_device *hdev, u32 port, u32 fw_addr)
+{
+	u32 ignore;
+
+	fw_cmd(hdev, port, 0xE010, &fw_addr, 0xE, &ignore);
+
+	return NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9812);
+}
+
+static int set_fw_reg(struct hbl_cn_device *hdev, u32 port, u32 fw_addr, u32 val)
+{
+	u32 ignore;
+
+	NIC_PHY_WREG32(NIC0_SERDES0_REGISTER_9812, val);
+
+	return fw_cmd(hdev, port, 0xE020, &fw_addr, 0xE, &ignore);
+}
+
+static void enable_lane_swapping(struct hbl_cn_device *hdev, u32 port, int lane, bool do_an,
+				 bool do_lt)
+{
+	if (do_an || do_lt)
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AJ40, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_AJ40_ANLT_LANE_SWAPPING_EN_MASK);
+
+	if (do_an)
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AJ40, 0x0, 0x40);
+}
+
+static void disable_lane_swapping(struct hbl_cn_device *hdev, u32 port, int lane, bool do_an,
+				  bool do_lt)
+{
+	if (do_an)
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AJ40, 0x0,
+				      NIC0_SERDES0_LANE0_REGISTER_AJ40_ANLT_LANE_SWAPPING_EN_MASK);
+}
+
+static void lane_swapping_config(struct hbl_cn_device *hdev, u32 port, int lane, bool do_an,
+				 bool do_lt)
+{
+	u32 tx_port, lt_option;
+	int tx_lane;
+
+	get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+	lt_option = get_fw_reg(hdev, port, 366);
+
+	if (is_lane_swapping(hdev, port, lane)) {
+		enable_lane_swapping(hdev, tx_port, tx_lane, do_an, do_lt);
+		enable_lane_swapping(hdev, port, lane, do_an, do_lt);
+
+		lt_option |= (1 << (3 + 8 * (1 - lane)));
+	} else {
+		disable_lane_swapping(hdev, tx_port, tx_lane, do_an, do_lt);
+		disable_lane_swapping(hdev, port, lane, do_an, do_lt);
+
+		lt_option &= ~(1 << (3 + 8 * (1 - lane)));
+	}
+
+	set_fw_reg(hdev, port, 366, lt_option);
+}
+
+static int fw_start(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4, bool do_lt)
+{
+	u32 cmd, speed, ignore;
+
+	cmd = pam4 ? (0x80D0 | lane) : (0x80C0 | lane);
+	speed = pam4 ? 0x9 : 0x3;
+
+	if (do_lt)
+		speed |= 0x100;
+
+	return fw_cmd(hdev, port, cmd, &speed, 0x8, &ignore);
+}
+
+static int fw_start_tx(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4, bool do_lt)
+{
+	u32 speed, cmd, ignore;
+	int rc;
+
+	speed = pam4 ? 0x9 : 0x3;
+
+	if (pam4)
+		cmd = do_lt ? (0x7030 | lane) : (0x7010 | lane);
+	else
+		cmd = do_lt ? (0x7020 | lane) : (0x7000 | lane);
+
+	rc = fw_cmd(hdev, port, cmd, &speed, 0x7, &ignore);
+	if (rc)
+		return rc;
+
+	if (do_lt)
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_0PA0_RSVD_0PA0_04_MASK);
+
+	return 0;
+}
+
+static int fw_config_vcocap(struct hbl_cn_device *hdev, u32 port, int lane, u32 mode,
+			    u32 counter_value)
+{
+	u32 ignore;
+
+	return fw_cmd(hdev, port, 0x6000 | (mode << 4) | lane, &counter_value, 14, &ignore);
+}
+
+static int set_pll_tx(struct hbl_cn_device *hdev, u32 port, int lane, u32 data_rate)
+{
+	u32 card_location, msbc, lsbc;
+	int rc;
+
+	card_location = hdev->card_location;
+
+	if (lane == 0)
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x0,
+				 NIC0_SERDES0_REGISTER_9825_PLL_0_LOCK_32T_CLK_SEL_MASK);
+	else
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_982E, 0x0,
+				 NIC0_SERDES0_REGISTER_982E_PLL_1_LOCK_32T_CLK_SEL_MASK);
+
+	switch (data_rate) {
+	case NIC_DR_50:
+		/* toggle FRACN LSB for better phase noise */
+		NIC_PHY_RMWREG32_LANE(0x54587D4, 0x0, 0x1);
+		msbc = 0x5;
+		lsbc = 0x4FFA;
+		break;
+	case NIC_DR_26:
+		/* toggle FRACN LSB for better phase noise */
+		NIC_PHY_RMWREG32_LANE(0x54587D4, 0x0, 0x1);
+		NIC_PHY_RMWREG32_LANE(0x5458320, 0x0, 0x1);
+		msbc = 0x5;
+		lsbc = 0x4FFA;
+		break;
+	case NIC_DR_25:
+		msbc = 0x5;
+		lsbc = 0x27FA;
+		break;
+	case NIC_DR_10:
+		msbc = 0x2;
+		lsbc = 0xFFD;
+		break;
+	default:
+		dev_err(hdev->dev, "Card %u Port %u lane %d: unsupported data rate\n",
+			card_location, port, lane);
+		return -EFAULT;
+	}
+
+	rc = fw_config_vcocap(hdev, port, lane, 1, msbc);
+	if (rc)
+		return rc;
+
+	rc = fw_config_vcocap(hdev, port, lane, 2, lsbc);
+	if (rc)
+		return rc;
+
+	rc = fw_config_vcocap(hdev, port, lane, 3, 0x40);
+	if (rc)
+		return rc;
+
+	rc = fw_config_vcocap(hdev, port, lane, 4, 0x0);
+	if (rc)
+		return rc;
+
+	usleep_range(500, 1000);
+
+	if (lane == 0) {
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x1,
+				 NIC0_SERDES0_REGISTER_9825_PLL_LOCK_SRC_SEL_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x0,
+				 NIC0_SERDES0_REGISTER_9825_PLL_0_LOCK_EN_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x1,
+				 NIC0_SERDES0_REGISTER_9825_PLL_0_LOCK_EN_MASK);
+	} else {
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x2,
+				 NIC0_SERDES0_REGISTER_9825_PLL_LOCK_SRC_SEL_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_982E, 0x0,
+				 NIC0_SERDES0_REGISTER_982E_PLL_1_LOCK_EN_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_982E, 0x1,
+				 NIC0_SERDES0_REGISTER_982E_PLL_1_LOCK_EN_MASK);
+	}
+
+	usleep_range(500, 1000);
+
+	return 0;
+}
+
+static int set_pll_rx(struct hbl_cn_device *hdev, u32 port, int lane, u32 data_rate)
+{
+	u32 card_location, msbc, lsbc, third_val;
+	int rc;
+
+	card_location = hdev->card_location;
+
+	if (lane == 0)
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x1,
+				 NIC0_SERDES0_REGISTER_9825_PLL_0_LOCK_32T_CLK_SEL_MASK);
+	else
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_982E, 0x1,
+				 NIC0_SERDES0_REGISTER_982E_PLL_1_LOCK_32T_CLK_SEL_MASK);
+
+	switch (data_rate) {
+	case NIC_DR_50:
+	case NIC_DR_26:
+		msbc = 0x5;
+		lsbc = 0x4FFA;
+		third_val = 0x30;
+		break;
+	case NIC_DR_25:
+		msbc = 0x5;
+		lsbc = 0x27FA;
+		third_val = 0x30;
+		break;
+	case NIC_DR_10:
+		msbc = 0x2;
+		lsbc = 0xFFD;
+		third_val = 0x40;
+		break;
+	default:
+		dev_err(hdev->dev, "Card %u Port %u lane %d: unsupported data rate\n",
+			card_location, port, lane);
+		return -EFAULT;
+	}
+
+	rc = fw_config_vcocap(hdev, port, lane, 1, msbc);
+	if (rc)
+		return rc;
+
+	rc = fw_config_vcocap(hdev, port, lane, 2, lsbc);
+	if (rc)
+		return rc;
+
+	rc = fw_config_vcocap(hdev, port, lane, 3, third_val);
+	if (rc)
+		return rc;
+
+	rc = fw_config_vcocap(hdev, port, lane, 4, 0x1);
+	if (rc)
+		return rc;
+
+	usleep_range(500, 1000);
+
+	if (lane == 0) {
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x1,
+				 NIC0_SERDES0_REGISTER_9825_PLL_LOCK_SRC_SEL_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x0,
+				 NIC0_SERDES0_REGISTER_9825_PLL_0_LOCK_EN_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x1,
+				 NIC0_SERDES0_REGISTER_9825_PLL_0_LOCK_EN_MASK);
+	} else {
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_9825, 0x2,
+				 NIC0_SERDES0_REGISTER_9825_PLL_LOCK_SRC_SEL_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_982E, 0x0,
+				 NIC0_SERDES0_REGISTER_982E_PLL_1_LOCK_EN_MASK);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_982E, 0x1,
+				 NIC0_SERDES0_REGISTER_982E_PLL_1_LOCK_EN_MASK);
+	}
+
+	usleep_range(500, 1000);
+
+	return 0;
+}
+
+static int set_pll(struct hbl_cn_device *hdev, u32 port, int lane, u32 data_rate)
+{
+	u32 card_location, tx_port;
+	int tx_lane, rc;
+
+	card_location = hdev->card_location;
+
+	get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+	rc = set_pll_tx(hdev, tx_port, tx_lane, data_rate);
+	if (rc) {
+		dev_err(hdev->dev, "Card %u Port %u lane %d: set Tx PLL failed, rc %d\n",
+			card_location, tx_port, tx_lane, rc);
+		return rc;
+	}
+
+	rc = set_pll_rx(hdev, port, lane, data_rate);
+	if (rc) {
+		dev_err(hdev->dev, "Card %u Port %u lane %d: set Rx PLL failed, rc %d\n",
+			card_location, port, lane, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void set_tx_taps_scale(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAF, 0x4, 0x3E);
+}
+
+static int fw_config_speed_pam4(struct hbl_cn_device *hdev, u32 port, int lane, bool do_lt)
+{
+	u32 tx_port, card_location, val;
+	u8 curr_tx_taps_cfg;
+	int tx_lane, rc;
+
+	card_location = hdev->card_location;
+
+	get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+	init_pam4_tx(hdev, tx_port, tx_lane);
+	init_pam4_rx(hdev, port, lane);
+
+	/* Disable AN/LT lane swapping */
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AJ40, 0x0,
+			      NIC0_SERDES0_LANE0_REGISTER_AJ40_ANLT_LANE_SWAPPING_EN_MASK);
+
+	lane_swapping_config(hdev, port, lane, false, do_lt);
+
+	init_lane_for_fw_tx(hdev, tx_port, tx_lane, true, do_lt);
+	init_lane_for_fw_rx(hdev, port, lane, true, do_lt);
+
+	prbs_mode_select_tx(hdev, tx_port, tx_lane, true, "PRBS31");
+	prbs_mode_select_rx(hdev, port, lane, true, "PRBS31");
+
+	rc = fw_start(hdev, port, lane, true, do_lt);
+	if (rc) {
+		dev_err(hdev->dev,
+			"Card %u Port %u lane %d: F/W config speed PAM4 failed (LT %s), rc %d\n",
+			card_location, port, lane, do_lt ? "enabled" : "disable", rc);
+		return rc;
+	}
+
+	if (is_lane_swapping(hdev, port, lane)) {
+		rc = fw_start_tx(hdev, tx_port, tx_lane, true, do_lt);
+		if (rc) {
+			dev_err(hdev->dev,
+				"Card %u Port %u lane %d: F/W config speed PAM4 failed (LT %s), rc %d\n",
+				card_location, tx_port, tx_lane, do_lt ? "enabled" : "disable",
+				rc);
+			return rc;
+		}
+
+		if (do_lt)
+			NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x1,
+					      NIC0_SERDES0_LANE0_REGISTER_0PA0_RSVD_0PA0_04_MASK);
+	}
+
+	if (do_lt) {
+		if (!hdev->phy_calc_ber) {
+			/* tell the F/W to do LT with PCS data instead of PRBS */
+			val = get_fw_reg(hdev, port, 366);
+			val &= 0xFEFE;
+			set_fw_reg(hdev, port, 366, val);
+		}
+
+		set_tx_taps_scale(hdev, tx_port, tx_lane);
+		set_gc_tx(hdev, tx_port, tx_lane, 0);
+		set_pc_tx(hdev, tx_port, tx_lane, 0);
+		set_gc_rx(hdev, port, lane, 0);
+		set_pc_rx(hdev, port, lane, 0);
+	} else {
+		curr_tx_taps_cfg = get_curr_tx_taps_cfg(hdev, port);
+		set_tx_taps_cfg(hdev, tx_port, tx_lane, curr_tx_taps_cfg, true, false);
+	}
+
+	return 0;
+}
+
+static void init_nrz_tx(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA1, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA2, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA3, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA4, 0x0);
+	/* data quiet */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x6320);
+	/* auto symmetric, scale */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAF, 0xF8C9);
+	/* data, prbs */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PB0, 0x4820);
+	/* cursor -2 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA5, 0x0);
+	/* cursor -1 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA7, 0xFC00);
+	/* cursor -main */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA9, 0x1800);
+	/* cursor +1 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAB, 0x0);
+	/* cursor +2 */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAD, 0x0);
+}
+
+static void init_nrz_rx(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PF8, 0xEC06);
+}
+
+static int fw_config_speed_nrz(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 tx_port, card_location;
+	u8 curr_tx_taps_cfg;
+	int tx_lane, rc;
+
+	card_location = hdev->card_location;
+
+	get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+	lane_swapping_config(hdev, port, lane, false, false);
+
+	init_nrz_tx(hdev, tx_port, tx_lane);
+	init_nrz_rx(hdev, port, lane);
+
+	init_lane_for_fw_tx(hdev, tx_port, tx_lane, false, false);
+	init_lane_for_fw_rx(hdev, port, lane, false, false);
+
+	prbs_mode_select_tx(hdev, tx_port, tx_lane, false, "PRBS31");
+	prbs_mode_select_rx(hdev, port, lane, false, "PRBS31");
+
+	rc = fw_start(hdev, port, lane, false, false);
+	if (rc) {
+		dev_err(hdev->dev,
+			"Card %u Port %u lane %d: F/W config speed NRZ failed, rc %d\n",
+			card_location, port, lane, rc);
+		return rc;
+	}
+
+	if (is_lane_swapping(hdev, port, lane)) {
+		rc = fw_start_tx(hdev, tx_port, tx_lane, false, false);
+		if (rc) {
+			dev_err(hdev->dev,
+				"Card %u Port %u lane %d: F/W config speed NRZ failed, rc %d\n",
+				card_location, tx_port, tx_lane, rc);
+			return rc;
+		}
+	}
+
+	curr_tx_taps_cfg = get_curr_tx_taps_cfg(hdev, port);
+	set_tx_taps_cfg(hdev, tx_port, tx_lane, curr_tx_taps_cfg, false, false);
+
+	return 0;
+}
+
+static void reset_mac_tx(struct hbl_cn_device *hdev, u32 port)
+{
+	struct gaudi2_cn_device *gaudi2 = hdev->asic_specific;
+	u32 tx_ch_mask;
+
+	/* For F/W version 37.1.0 and above, the reset will be done by the F/W */
+	if ((hdev->fw_major_version == 37 && hdev->fw_minor_version > 1) ||
+	    hdev->fw_major_version > 37) {
+		struct gaudi2_cn_aux_ops *gaudi2_aux_ops;
+		struct hbl_cn_aux_ops *aux_ops;
+		struct hbl_aux_dev *aux_dev;
+		struct cpucp_packet pkt;
+		int rc;
+
+		aux_dev = hdev->cn_aux_dev;
+		aux_ops = aux_dev->aux_ops;
+		gaudi2_aux_ops = aux_ops->asic_ops;
+
+		memset(&pkt, 0, sizeof(pkt));
+		pkt.ctl = cpu_to_le32(CPUCP_PACKET_NIC_MAC_TX_RESET << CPUCP_PKT_CTL_OPCODE_SHIFT);
+		pkt.port_index = cpu_to_le32(port);
+
+		rc = gaudi2_aux_ops->send_cpu_message(aux_dev, (u32 *)&pkt, sizeof(pkt), 0, NULL);
+		if (rc)
+			dev_warn(hdev->dev, "Card %u Port %u: Failed to reset MAC Tx, rc %d\n",
+				 hdev->card_location, port, rc);
+
+		return;
+	}
+
+	if (gaudi2->fw_security_enabled) {
+		dev_warn(hdev->dev, "Card %u Port %u: Failed to reset MAC Tx, security is enabled.\n",
+			 hdev->card_location, port);
+		return;
+	}
+
+	tx_ch_mask = 1 << PRT0_MAC_CORE_MAC_RST_CFG_SD_TX_SW_RST_N_SHIFT;
+	tx_ch_mask <<= (port & 0x1) ? 2 : 0;
+
+	NIC_MACRO_RMWREG32(PRT0_MAC_CORE_MAC_RST_CFG, 0, tx_ch_mask);
+	msleep(100);
+	NIC_MACRO_RMWREG32(PRT0_MAC_CORE_MAC_RST_CFG, 1, tx_ch_mask);
+}
+
+static int fw_config(struct hbl_cn_device *hdev, u32 port, u32 data_rate, bool do_lt)
+{
+	u32 card_location;
+	int lane, rc;
+	bool pam4;
+
+	card_location = hdev->card_location;
+	pam4 = (data_rate == NIC_DR_50);
+
+	/* clear go bit */
+	if (pam4) {
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980F, 0x1, 0x800);
+		NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980F, 0x1, 0x100);
+	}
+
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980F, 0x0, 0x8000);
+
+	for (lane = 0; lane < 2; lane++) {
+		if (pam4) {
+			rc = fw_config_speed_pam4(hdev, port, lane, do_lt);
+			if (rc) {
+				dev_err(hdev->dev,
+					"Card %u Port %u lane %d: F/W PAM4 config failed, rc %d\n",
+					card_location, port, lane, rc);
+				return rc;
+			}
+
+			NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PEA, 0x60,
+					      NIC0_SERDES0_LANE0_REGISTER_0PEA_VDACCLKPHASE0_MASK);
+		} else {
+			rc = fw_config_speed_nrz(hdev, port, lane);
+			if (rc) {
+				dev_err(hdev->dev,
+					"Card %u Port %u lane %d: F/W NRZ config failed, rc %d\n",
+					card_location, port, lane, rc);
+				return rc;
+			}
+		}
+	}
+
+	for (lane = 0; lane < 2; lane++) {
+		rc = set_pll(hdev, port, lane, data_rate);
+		if (rc)
+			return rc;
+	}
+
+	msleep(100);
+
+	reset_mac_tx(hdev, port);
+
+	if (!hdev->phy_calc_ber)
+		set_functional_mode(hdev, port);
+
+	/* set go bit */
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980F, 0x1, 0x8000);
+
+	return 0;
+}
+
+static void phy_port_reset(struct hbl_cn_device *hdev, u32 port)
+{
+	int lane;
+
+	soft_reset(hdev, port);
+	usleep_range(500, 1000);
+
+	for (lane = 0; lane < 2; lane++)
+		clock_init(hdev, port, lane);
+
+	cpu_reset(hdev, port);
+	logic_reset(hdev, port);
+
+	usleep_range(500, 1000);
+}
+
+static void prbs_reset(struct hbl_cn_port *cn_port, int lane, bool pam4)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 1,
+			      NIC0_SERDES0_LANE0_REGISTER_0P43_RX_PRBS_AUTO_SYNC_EN_MASK);
+
+	if (pam4) {
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 1,
+				      NIC0_SERDES0_LANE0_REGISTER_0P43_PRBS_SYNC_CNTR_RESET_MASK);
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 0,
+				      NIC0_SERDES0_LANE0_REGISTER_0P43_PRBS_SYNC_CNTR_RESET_MASK);
+	} else {
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N61, 1,
+				      NIC0_SERDES0_LANE0_REGISTER_0N61_PRBS_CNTR_RESET_MASK);
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N61, 0,
+				      NIC0_SERDES0_LANE0_REGISTER_0N61_PRBS_CNTR_RESET_MASK);
+	}
+
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43, 0,
+			      NIC0_SERDES0_LANE0_REGISTER_0P43_RX_PRBS_AUTO_SYNC_EN_MASK);
+}
+
+static u64 _get_prbs_cnt(struct hbl_cn_port *cn_port, int lane, bool pam4)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	u64 cnt;
+
+	if (pam4)
+		cnt = (((u64)NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P50)) << 16) +
+		      NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P51);
+	else
+		cnt = (((u64)NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N66)) << 16) +
+		      NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N67);
+
+	return cnt;
+}
+
+static enum lane_state get_prbs_cnt(struct hbl_cn_port *cn_port, int lane, bool pam4,
+				    u64 prbs_prev_cnt, u64 *prbs_new_cnt)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port, phy_ready;
+	u64 cnt;
+
+	if (pam4) {
+		phy_ready = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P6A) &
+			     NIC0_SERDES0_LANE0_REGISTER_0P6A_RX_READ_PHY_READY_MASK) >>
+			    NIC0_SERDES0_LANE0_REGISTER_0P6A_RX_READ_PHY_READY_SHIFT;
+	} else {
+		phy_ready = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N2E) &
+			     NIC0_SERDES0_LANE0_REGISTER_0N2E_NRZ_READ_PHY_READY_MASK) >>
+			    NIC0_SERDES0_LANE0_REGISTER_0N2E_NRZ_READ_PHY_READY_SHIFT;
+	}
+
+	if (!phy_ready)
+		return NOT_READY;
+
+	cnt = _get_prbs_cnt(cn_port, lane, pam4);
+
+	/* check PRBS counter wrapped around */
+	if (cnt < prbs_prev_cnt) {
+		if ((prbs_prev_cnt - cnt) < 0x10000)
+			return FAILURE;
+
+		cnt = _get_prbs_cnt(cn_port, lane, pam4);
+	}
+
+	*prbs_new_cnt = cnt;
+
+	return READY;
+}
+
+static void _calc_ber_lane(struct hbl_cn_port *cn_port, int lane, u64 total_cnt, u64 error_cnt,
+			   struct hbl_cn_ber_info *ber_info)
+{
+	u64 total_high_digits, error_high_digits, integer, frac;
+	u8 total_num_digits, error_num_digits, exp;
+	int i;
+
+	total_num_digits = hbl_cn_get_num_of_digits(total_cnt);
+	error_num_digits = hbl_cn_get_num_of_digits(error_cnt);
+
+	if (total_num_digits > 2) {
+		total_high_digits = total_cnt;
+
+		for (i = 0; i < total_num_digits - 2; i++)
+			total_high_digits = total_high_digits / 10;
+	} else {
+		total_high_digits = total_cnt;
+	}
+
+	if (!total_high_digits)
+		return;
+
+	if (error_num_digits > 2) {
+		error_high_digits = error_cnt;
+
+		for (i = 0; i < error_num_digits - 2; i++)
+			error_high_digits = error_high_digits / 10;
+	} else {
+		error_high_digits = error_cnt;
+	}
+
+	exp = total_num_digits - error_num_digits;
+
+	if (error_high_digits < total_high_digits) {
+		error_high_digits *= 10;
+		exp++;
+	}
+
+	integer = div_u64(error_high_digits, total_high_digits);
+	frac = div_u64(((error_high_digits - (integer * total_high_digits)) * 10),
+		       total_high_digits);
+
+	ber_info->integer = integer;
+	ber_info->frac = frac;
+	ber_info->exp = exp;
+	ber_info->valid = true;
+}
+
+static void calc_ber_lane(struct hbl_cn_port *cn_port, int lane, bool pam4)
+{
+	u64 prbs_err_cnt_pre, prbs_prev_cnt, prbs_err_cnt_post, prbs_err_cnt,
+	    prbs_reset_time_jiffies, prbs_accum_time_jiffies, prbs_accum_time_ms,
+	    factor, error_cnt, total_cnt;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 card_location, port, abs_lane_idx;
+	struct hbl_cn_ber_info *ber_info;
+	enum lane_state state;
+
+	card_location = hdev->card_location;
+	port = cn_port->port;
+	abs_lane_idx = (port << 1) + lane;
+
+	ber_info = &hdev->phy_ber_info[abs_lane_idx];
+	memset(ber_info, 0, sizeof(*ber_info));
+
+	prbs_reset(cn_port, lane, pam4);
+	prbs_reset_time_jiffies = jiffies;
+	prbs_err_cnt_pre = _get_prbs_cnt(cn_port, lane, pam4);
+	prbs_err_cnt_post = 0;
+
+	prbs_prev_cnt = prbs_err_cnt_pre;
+
+	while (true) {
+		msleep(500);
+
+		state = get_prbs_cnt(cn_port, lane, pam4, prbs_prev_cnt, &prbs_err_cnt_post);
+		prbs_accum_time_jiffies = jiffies - prbs_reset_time_jiffies;
+		prbs_accum_time_ms = jiffies_to_msecs(prbs_accum_time_jiffies);
+		prbs_err_cnt = prbs_err_cnt_post - prbs_err_cnt_pre;
+
+		if (state != READY) {
+			dev_dbg(hdev->dev, "Card %u Port %u lane %d: No BER (state = %s)\n",
+				card_location, port, lane,
+				(state == NOT_READY) ? "NOT_READY" : "FAILURE");
+			return;
+		}
+
+		if (prbs_accum_time_ms >= 5000 || prbs_err_cnt >= 10000000)
+			break;
+
+		prbs_prev_cnt = prbs_err_cnt_post;
+	}
+
+	factor = pam4 ? NIC_PHY_PAM4_BER_FACTOR : NIC_PHY_NRZ_BER_FACTOR;
+
+	error_cnt = prbs_err_cnt;
+	total_cnt = prbs_accum_time_ms * factor;
+
+	_calc_ber_lane(cn_port, lane, total_cnt, error_cnt, ber_info);
+
+	dev_dbg(hdev->dev,
+		"Card %u Port %u lane %d: total_cnt %llu error_cnt %llu (%llu ms) - BER %llu.%llue-%u\n",
+		card_location, port, lane, total_cnt, error_cnt, prbs_accum_time_ms,
+		ber_info->integer, ber_info->frac, ber_info->exp);
+}
+
+static void calc_ber(struct hbl_cn_port *cn_port)
+{
+	int lane;
+
+	for (lane = 0; lane < 2; lane++)
+		calc_ber_lane(cn_port, lane, cn_port->data_rate == NIC_DR_50);
+}
+
+static void get_tx_port_lane(u32 port, int lane, u32 *_port, int *_lane)
+{
+	if (port != 0 && port != 1) {
+		*_port = port;
+		*_lane = lane;
+		return;
+	}
+
+	if (port == 0 && lane == 0) {
+		*_port = 1;
+		*_lane = 1;
+	} else if (port == 0 && lane == 1) {
+		*_port = 0;
+		*_lane = 1;
+	} else if (port == 1 && lane == 0) {
+		*_port = 0;
+		*_lane = 0;
+	} else if (port == 1 && lane == 1) {
+		*_port = 1;
+		*_lane = 0;
+	}
+}
+
+static void modify_tx_taps(struct hbl_cn_port *cn_port)
+{
+	struct gaudi2_cn_port *gaudi2_port = cn_port->cn_specific;
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u8 curr_cfg, next_cfg;
+	u32 port, _port;
+	int lane, _lane;
+	bool pam4;
+
+	port = cn_port->port;
+	curr_cfg = get_curr_tx_taps_cfg(hdev, port);
+	next_cfg = (curr_cfg + 1) % tx_taps_num_cfgs;
+	pam4 = cn_port->data_rate == NIC_DR_50;
+	_port = 0;
+	_lane = 0;
+
+	gaudi2_port->tx_taps_cfg = next_cfg;
+
+	/* If the next cfg equals the initial cfg, it means that we went through all the taps cfgs.
+	 * In that case, PHY reconfigure should be triggered.
+	 */
+	if (next_cfg == gaudi2_port->initial_tx_taps_cfg) {
+		dev_dbg(hdev->dev,
+			"Card %u Port %u: all tx taps cfgs were failed - reconfiguring PHY\n",
+			hdev->card_location, port);
+
+		return hbl_cn_phy_port_reconfig(cn_port);
+	}
+
+	dev_dbg(hdev->dev, "Card %u Port %u: modify %s tx taps (%u,%u)->(%u,%u)\n",
+		hdev->card_location, port, pam4 ? "PAM4" : "NRZ",
+		tx_taps_cfg_array[curr_cfg][0] + 1, tx_taps_cfg_array[curr_cfg][1] + 1,
+		tx_taps_cfg_array[next_cfg][0] + 1, tx_taps_cfg_array[next_cfg][1] + 1);
+
+	for (lane = 0; lane < 2; lane++) {
+		get_tx_port_lane(port, lane, &_port, &_lane);
+		set_tx_taps_cfg(hdev, _port, _lane, next_cfg, pam4, true);
+	}
+
+	gaudi2_port->tx_taps_modified = true;
+}
+
+static void print_final_tx_taps(struct hbl_cn_port *cn_port)
+{
+	char tx_taps_str0[25] = {0}, tx_taps_str1[25] = {0};
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port, abs_lane0_idx, abs_lane1_idx;
+	s32 *taps;
+	bool pam4;
+
+	pam4 = cn_port->data_rate == NIC_DR_50;
+	port = cn_port->port;
+	abs_lane0_idx = port << 1;
+	abs_lane1_idx = abs_lane0_idx + 1;
+
+	taps = pam4 ? hdev->phy_tx_taps[abs_lane0_idx].pam4_taps :
+			hdev->phy_tx_taps[abs_lane0_idx].nrz_taps;
+	sprintf(tx_taps_str0, "%d,%d,%d,%d,%d", taps[0], taps[1], taps[2], taps[3], taps[4]);
+
+	taps = pam4 ? hdev->phy_tx_taps[abs_lane1_idx].pam4_taps :
+			hdev->phy_tx_taps[abs_lane1_idx].nrz_taps;
+	sprintf(tx_taps_str1, "%d,%d,%d,%d,%d", taps[0], taps[1], taps[2], taps[3], taps[4]);
+
+	dev_dbg(hdev->dev, "Card %u Port %u: Final Tx taps - lane0: [%s], lane1: [%s]\n",
+		hdev->card_location, port, tx_taps_str0, tx_taps_str1);
+}
+
+static void change_pcs_link_state(struct gaudi2_cn_port *gaudi2_port,
+				  enum gaudi2_cn_pcs_link_state pcs_link_state)
+{
+	struct hbl_cn_port *cn_port = gaudi2_port->cn_port;
+
+	gaudi2_port->pcs_link_state = pcs_link_state;
+
+	/* The retry count is being incremented in a different frequency in every state.
+	 * Therefore, in order to have a logical value in each state, it needs to be reset when
+	 * moving to a new state.
+	 */
+	cn_port->retry_cnt = 0;
+}
+
+static void check_pcs_link(struct hbl_cn_port *cn_port)
+{
+	u32 card_location, port, mac_gnrl_sts, pcs_link_samples_per_sec, link_down_cnt_th,
+	    remote_fault_cnt_th, link_toggles;
+	enum gaudi2_cn_pcs_link_state pcs_link_state;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_device *hdev;
+
+	hdev = cn_port->hdev;
+	gaudi2_port = cn_port->cn_specific;
+	card_location = hdev->card_location;
+	port = cn_port->port;
+	pcs_link_state = gaudi2_port->pcs_link_state;
+
+	if (pcs_link_state == PCS_LINK_STATE_SETTLING) {
+		if (cn_port->eth_enable) {
+			change_pcs_link_state(gaudi2_port, PCS_LINK_STATE_STEADY);
+		} else {
+			change_pcs_link_state(gaudi2_port, PCS_LINK_STATE_STRESS);
+			gaudi2_port->pcs_link_stady_state_ts =
+				ktime_add_ms(ktime_get(), NIC_PHY_PCS_STRESS_WINDOW_MS);
+		}
+
+		return;
+	}
+
+	mac_gnrl_sts = (port & 0x1) ? NIC_MACRO_RREG32(PRT0_MAC_CORE_MAC_GNRL_STS_2) :
+			NIC_MACRO_RREG32(PRT0_MAC_CORE_MAC_GNRL_STS_0);
+
+	if (FIELD_GET(PRT0_MAC_CORE_MAC_GNRL_STS_LOC_FAULT_MASK, mac_gnrl_sts))
+		cn_port->pcs_local_fault_cnt++;
+
+	if (FIELD_GET(PRT0_MAC_CORE_MAC_GNRL_STS_REM_FAULT_MASK, mac_gnrl_sts)) {
+		cn_port->pcs_remote_fault_cnt++;
+		cn_port->pcs_remote_fault_seq_cnt++;
+	} else {
+		cn_port->pcs_remote_fault_seq_cnt = 0;
+	}
+
+	pcs_link_samples_per_sec = gaudi2_port->pcs_link_samples_per_sec;
+	remote_fault_cnt_th = NIC_PHY_MAC_REMOTE_FAULT_TH_S * pcs_link_samples_per_sec;
+
+	if (pcs_link_state == PCS_LINK_STATE_STRESS) {
+		if (ktime_after(ktime_get(), gaudi2_port->pcs_link_stady_state_ts)) {
+			change_pcs_link_state(gaudi2_port, PCS_LINK_STATE_STEADY);
+			goto check_link;
+		}
+
+		if (cn_port->pcs_remote_fault_seq_cnt) {
+			dev_dbg(hdev->dev, "Card %u Port %u: got MAC remote fault during stress window\n",
+				card_location, port);
+
+			modify_tx_taps(cn_port);
+			change_pcs_link_state(gaudi2_port, PCS_LINK_STATE_SETTLING);
+			cn_port->pcs_remote_fault_seq_cnt = 0;
+		}
+	} else { /* PCS_LINK_STATE_STEADY */
+		if (gaudi2_port->tx_taps_modified) {
+			print_final_tx_taps(cn_port);
+			gaudi2_port->tx_taps_modified = false;
+		}
+
+		if (cn_port->pcs_remote_fault_seq_cnt == remote_fault_cnt_th) {
+			dev_dbg(hdev->dev,
+				"Card %u Port %u: %u sequential seconds of MAC remote faults\n",
+				card_location, port, NIC_PHY_MAC_REMOTE_FAULT_TH_S);
+
+			/* Modify tx taps - external ports are excluded */
+			if (!cn_port->eth_enable) {
+				modify_tx_taps(cn_port);
+				change_pcs_link_state(gaudi2_port, PCS_LINK_STATE_SETTLING);
+			}
+
+			cn_port->pcs_remote_fault_seq_cnt = 0;
+		}
+	}
+
+check_link:
+	link_toggles = cn_port->port_toggle_cnt - cn_port->port_toggle_cnt_prev;
+	cn_port->port_toggle_cnt_prev = cn_port->port_toggle_cnt;
+
+	/* The condition to reset the retry_cnt is that the link is UP, and if in steady state,
+	 * only if the link toggling threshold is not exceeded.
+	 */
+	if (cn_port->pcs_link && !(pcs_link_state == PCS_LINK_STATE_STEADY &&
+				   link_toggles > NIC_PHY_PCS_MAX_LINK_TOGGLES)) {
+		cn_port->retry_cnt = 0;
+		return;
+	}
+
+	cn_port->retry_cnt++;
+	link_down_cnt_th = NIC_PHY_PCS_LINK_DOWN_TH_S * pcs_link_samples_per_sec;
+
+	if (cn_port->retry_cnt == link_down_cnt_th) {
+		dev_dbg(hdev->dev,
+			"Card %u Port %u: %u sequential seconds of PCS link down - reconfiguring PHY\n",
+			card_location, port, NIC_PHY_PCS_LINK_DOWN_TH_S);
+
+		hbl_cn_phy_port_reconfig(cn_port);
+	}
+}
+
+static u32 rv_debug(struct hbl_cn_device *hdev, u32 port, int lane, u32 mode, u32 index)
+{
+	u32 cmd, res;
+
+	cmd = 0xB000 + ((mode & 0xF) << 4) + lane;
+
+	fw_cmd(hdev, port, cmd, &index, 0xB, &res);
+
+	return NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9816);
+}
+
+static int fw_tuning(struct hbl_cn_device *hdev, u32 port, int lane, bool pam4)
+{
+	u32 state, mode;
+
+	mode = pam4 ? 2 : 1;
+	state = rv_debug(hdev, port, lane, mode, 0);
+
+	if (pam4) {
+		if (((u16)state) != 0x8F00 && ((u16)state) != 0x8F80)
+			return -EAGAIN;
+	} else {
+		if (((u16)state) != 0x9A00)
+			return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static void do_fw_tuning(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 card_location, port;
+	int lane, rc;
+	bool pam4;
+
+	card_location = hdev->card_location;
+	port = cn_port->port;
+	pam4 = (cn_port->data_rate == NIC_DR_50);
+
+	for (lane = 0; lane < 2; lane++) {
+		rc = fw_tuning(hdev, port, lane, pam4);
+		if (rc) {
+			if (ktime_after(ktime_get(), cn_port->fw_tuning_limit_ts)) {
+				dev_dbg(hdev->dev,
+					"Card %u Port %u lane %d: F/W tuning limit - reconfiguring PHY\n",
+					card_location, port, lane);
+
+				hbl_cn_phy_port_reconfig(cn_port);
+				return;
+			}
+
+			break;
+		}
+	}
+
+	if (!rc) {
+		/* The control lock needs to be taken here in order to protect against a parallel
+		 * status set from the link event handler.
+		 * This lock also protects port close flow that destroys this thread synchronically,
+		 * so a potential deadlock could happen here.
+		 * In order to avoid this deadlock, we need to check if this lock was taken.
+		 * If it was taken and the port is marked as closed (i.e., we are now during port
+		 * close flow), we can return immediately.
+		 * Otherwise, we need to keep trying to take this lock before we enter the critial
+		 * section.
+		 */
+		while (!mutex_trylock(&cn_port->control_lock))
+			if (!hbl_cn_is_port_open(cn_port))
+				return;
+
+		cn_port->phy_fw_tuned = true;
+
+		/* If we got link up event, set it now when PHY is ready */
+		if (cn_port->eq_pcs_link) {
+			cn_port->pcs_link = true;
+			hbl_cn_phy_set_port_status(cn_port, true);
+		}
+
+		mutex_unlock(&cn_port->control_lock);
+
+		cn_port->retry_cnt = 0;
+	}
+}
+
+static int fw_tuning_an(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 state = rv_debug(hdev, port, lane, 1, 0);
+
+	if (((u16)state) != 0xA01F && ((u16)state) != 0xA020 && ((u16)state) != 0xAF00) {
+		u32 error_status = rv_debug(hdev, port, lane, 0, 3);
+
+		dev_dbg_ratelimited(hdev->dev,
+				    "Card %u Port %u lane %d: auto neg fw is not ready, state 0x%x error 0x%x\n",
+				    hdev->card_location, port, lane, state, error_status);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static void tx_quite(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA1, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA2, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA3, 0x0);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA4, 0x0);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x0,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_TEST_DATA_SRC_MASK);
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x0,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PAM4_TEST_EN_MASK);
+}
+
+static int do_anlt(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port, tx_port;
+	int tx_lane, rc;
+
+	/* fw_tuning_an needs to be done only on lane 0 */
+	rc = fw_tuning_an(hdev, port, 0);
+	if (rc)
+		return rc;
+
+	get_tx_port_and_lane(hdev, port, 0, &tx_port, &tx_lane);
+	tx_quite(hdev, tx_port, tx_lane);
+
+	rc = fw_config(hdev, port, NIC_DR_50, true);
+	if (rc) {
+		dev_dbg(hdev->dev,
+			"Card %u Port %u: PHY link training failed, rc %d - reconfiguring PHY\n",
+			hdev->card_location, port, rc);
+
+		hbl_cn_phy_port_reconfig(cn_port);
+
+		return rc;
+	}
+
+	cn_port->auto_neg_resolved = true;
+
+	return 0;
+}
+
+static void do_fw_tuning_auto_neg(struct hbl_cn_port *cn_port)
+{
+	u32 fw_tuning_timeout_ms;
+
+	if (cn_port->auto_neg_enable) {
+		if (do_anlt(cn_port))
+			return;
+	} else {
+		cn_port->auto_neg_skipped = true;
+	}
+
+	if (cn_port->eth_enable)
+		fw_tuning_timeout_ms = NIC_PHY_FW_TUNING_TIMEOUT_MS;
+	else
+		fw_tuning_timeout_ms = tx_taps_num_cfgs * NIC_PHY_PCS_SETTLING_WAIT_MS;
+
+	cn_port->fw_tuning_limit_ts = ktime_add_ms(ktime_get(), fw_tuning_timeout_ms);
+	do_fw_tuning(cn_port);
+}
+
+static u32 get_timeout_ms(struct hbl_cn_port *cn_port)
+{
+	u32 card_location, port, timeout_ms;
+	struct gaudi2_cn_port *gaudi2_port;
+	struct hbl_cn_device *hdev;
+
+	hdev = cn_port->hdev;
+	gaudi2_port = cn_port->cn_specific;
+	card_location = hdev->card_location;
+	port = cn_port->port;
+	timeout_ms = MSEC_PER_SEC;
+
+	if (!cn_port->phy_fw_tuned) {
+		timeout_ms = NIC_PHY_FW_TUNING_INTERVAL_MS;
+	} else if (!cn_port->phy_func_mode_en) {
+		u16 timeout_sec = hdev->phy_calc_ber_wait_sec;
+
+		dev_info(hdev->dev, "Card %u Port %u: Waiting %u seconds before calculating BER\n",
+			 card_location, port, timeout_sec);
+		timeout_ms = timeout_sec * MSEC_PER_SEC;
+	} else {
+		enum gaudi2_cn_pcs_link_state pcs_link_state = gaudi2_port->pcs_link_state;
+
+		switch (pcs_link_state) {
+		case PCS_LINK_STATE_SETTLING:
+			timeout_ms = NIC_PHY_PCS_SETTLING_WAIT_MS;
+			dev_dbg(hdev->dev, "Card %u Port %u: waiting %lu seconds for settling\n",
+				card_location, port, timeout_ms / MSEC_PER_SEC);
+			break;
+		case PCS_LINK_STATE_STRESS:
+			timeout_ms = NIC_PHY_PCS_STRESS_INT_MS;
+			gaudi2_port->pcs_link_samples_per_sec = MSEC_PER_SEC / timeout_ms;
+			break;
+		case PCS_LINK_STATE_STEADY:
+			timeout_ms = NIC_PHY_PCS_STEADY_STATE_INT_MS;
+			gaudi2_port->pcs_link_samples_per_sec = MSEC_PER_SEC / timeout_ms;
+			break;
+		default:
+			dev_err(hdev->dev, "Card %u Port %u: invalid pcs_link_state %u\n",
+				card_location, port, pcs_link_state);
+		}
+	}
+
+	return timeout_ms;
+}
+
+void gaudi2_cn_phy_link_status_work(struct work_struct *work)
+{
+	u32 card_location, port, timeout_ms;
+	struct gaudi2_cn_device *gaudi2;
+	struct hbl_cn_port *cn_port;
+	struct hbl_cn_device *hdev;
+
+	cn_port = container_of(work, struct hbl_cn_port, link_status_work.work);
+	hdev = cn_port->hdev;
+	gaudi2 = hdev->asic_specific;
+	card_location = hdev->card_location;
+	port = cn_port->port;
+
+	/* Reschedule this work if the device is under compute reset */
+	if (gaudi2->in_compute_reset) {
+		timeout_ms = MSEC_PER_SEC;
+		goto reschedule;
+	}
+
+	if (cn_port->phy_fw_tuned) {
+		if (!cn_port->phy_func_mode_en) {
+			calc_ber(cn_port);
+			dev_info(hdev->dev, "Card %u Port %u: BER calculation is done\n",
+				 card_location, port);
+			return;
+		}
+
+		check_pcs_link(cn_port);
+	} else {
+		if (cn_port->auto_neg_resolved || cn_port->auto_neg_skipped)
+			do_fw_tuning(cn_port);
+		else
+			do_fw_tuning_auto_neg(cn_port);
+	}
+
+	timeout_ms = get_timeout_ms(cn_port);
+
+reschedule:
+	queue_delayed_work(cn_port->wq, &cn_port->link_status_work, msecs_to_jiffies(timeout_ms));
+}
+
+static void set_tx(struct hbl_cn_device *hdev, u32 port, int lane, bool enable)
+{
+	u32 val = enable ? 0x1 : 0x0;
+
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0NF8, val,
+			      NIC0_SERDES0_LANE0_REGISTER_0NF8_PU_VDRV_MASK);
+}
+
+void gaudi2_cn_phy_port_start_stop(struct hbl_cn_port *cn_port, bool is_start)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port, tx_port;
+	int lane, tx_lane;
+
+	for (lane = 0; lane < 2; lane++) {
+		get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+		if (is_start) {
+			/* Enable TX driver in SerDes */
+			set_tx(hdev, tx_port, tx_lane, true);
+			/* Enable F/W Rx tuning is done during power up flow */
+		} else {
+			/* Disable TX driver in SerDes */
+			set_tx(hdev, tx_port, tx_lane, false);
+			/* Silence F/W Rx tuning */
+			NIC_PHY_WREG32(NIC0_SERDES0_REGISTER_9815, 0x9000 | lane);
+		}
+	}
+}
+
+static int fw_start_an(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 detail = 0, ignore;
+
+	return fw_cmd(hdev, port, 0x80A0 | lane, &detail, 0x8, &ignore);
+}
+
+static int fw_start_an_tx(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	u32 detail = 0, ignore;
+	int rc;
+
+	rc = fw_cmd(hdev, port, 0x7040 | lane, &detail, 0x7, &ignore);
+	if (rc)
+		return rc;
+
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0, 0x0,
+			      NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_PAM4_TEST_EN_MASK);
+
+	return 0;
+}
+
+static int fw_config_auto_neg(struct hbl_cn_device *hdev, u32 port, int lane)
+{
+	struct hbl_cn_port *cn_port = &hdev->cn_ports[port];
+	u64 basepage = 0x800000001ull;
+	u32 tx_port, pflags;
+	u32 card_location;
+	int tx_lane, rc;
+
+	card_location = hdev->card_location;
+	pflags = hbl_cn_get_pflags(cn_port);
+
+	get_tx_port_and_lane(hdev, port, lane, &tx_port, &tx_lane);
+
+	/* clear go bit */
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980F, 0x0, 0x8000);
+
+	init_nrz_tx(hdev, tx_port, tx_lane);
+	init_nrz_rx(hdev, port, lane);
+
+	init_lane_for_fw_tx(hdev, tx_port, tx_lane, false, true);
+	init_lane_for_fw_rx(hdev, port, lane, false, true);
+
+	prbs_mode_select_tx(hdev, tx_port, tx_lane, false, "PRBS31");
+	prbs_mode_select_rx(hdev, port, lane, false, "PRBS31");
+
+	lane_swapping_config(hdev, port, lane, true, true);
+
+	/* set FW to start AN */
+
+	rc = fw_start_an(hdev, port, lane);
+	if (rc) {
+		dev_err(hdev->dev, "Card %u Port %u lane %d: start auto neg failed, rc %d\n",
+			card_location, tx_port, tx_lane, rc);
+		return rc;
+	}
+
+	if (is_lane_swapping(hdev, port, lane)) {
+		rc = fw_start_an_tx(hdev, tx_port, tx_lane);
+		if (rc) {
+			dev_err(hdev->dev,
+				"Card %u Port %u lane %d: start auto neg failed, rc %d\n",
+				card_location, tx_port, tx_lane, rc);
+			return rc;
+		}
+	}
+
+	/* AN reset */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AK00, 0xE000);
+
+	/* AN mode */
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AI10, basepage & 0xFFFF);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AI11, (basepage >> 16) & 0xFFFF);
+	NIC_PHY_WREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AI12, (basepage >> 32) & 0xFFFF);
+
+	/* IEEE */
+	NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AK00, 0x1,
+			      NIC0_SERDES0_LANE0_REGISTER_AK00_ARG_ANEG_IEEE_MODE_S_MASK);
+
+	if (pflags & PFLAGS_PHY_AUTO_NEG_LPBK)
+		NIC_PHY_RMWREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_AK00, 0x1,
+				      NIC0_SERDES0_LANE0_REGISTER_AK00_ARG_DIS_NONCE_MATCH_S_MASK);
+
+	rc = set_pll(hdev, port, lane, NIC_DR_25);
+	if (rc)
+		return rc;
+
+	/* set go bit */
+	NIC_PHY_RMWREG32(NIC0_SERDES0_REGISTER_980F, 0x1, 0x8000);
+
+	return 0;
+}
+
+static int port_9_reinit(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_port *cn_port_9 = &hdev->cn_ports[9];
+
+	if (!hbl_cn_is_port_open(cn_port_9))
+		return 0;
+
+	dev_dbg(hdev->dev,
+		"Card %u Port 9: Performing port 9 PHY reinit following port 8 PHY init\n",
+		hdev->card_location);
+
+	hbl_cn_phy_fini(cn_port_9);
+
+	return hbl_cn_phy_init(cn_port_9);
+}
+
+int gaudi2_cn_phy_port_power_up(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	struct gaudi2_cn_port *gaudi2_port;
+	u32 data_rate = cn_port->data_rate;
+	u32 card_location, port;
+	int rc;
+
+	gaudi2_port = cn_port->cn_specific;
+	card_location = hdev->card_location;
+	port = cn_port->port;
+
+	phy_port_reset(hdev, port);
+
+	if (hdev->phy_force_first_tx_taps_cfg)
+		gaudi2_port->tx_taps_cfg = 0;
+
+	cn_port->phy_func_mode_en = false;
+	gaudi2_port->pcs_link_state = PCS_LINK_STATE_SETTLING;
+	gaudi2_port->initial_tx_taps_cfg = gaudi2_port->tx_taps_cfg;
+
+	if (cn_port->auto_neg_enable) {
+		/* AN config should be done only on lane 0 */
+		rc = fw_config_auto_neg(hdev, port, 0);
+		if (rc) {
+			dev_err(hdev->dev, "Card %u Port %u: F/W config auto_neg failed, rc %d\n",
+				card_location, port, rc);
+			return rc;
+		}
+	} else {
+		rc = fw_config(hdev, port, data_rate, false);
+		if (rc) {
+			dev_err(hdev->dev, "Card %u Port %u: F/W config failed, rc %d\n",
+				card_location, port, rc);
+			return rc;
+		}
+	}
+
+	/* Port 8 is an external port which will usually be brought UP after all the internal ports
+	 * are UP. Due to macro clock nest dependency, when PHY reset is called for port 8,
+	 * port 9 (which is internal) is being toggled and might lost stabilization.
+	 * A W/A to overcome this issue is to reinit port 9 right after.
+	 */
+	if (port == 8)
+		port_9_reinit(hdev);
+
+	return 0;
+}
+
+void gaudi2_cn_phy_port_reconfig(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 card_location, port;
+	int rc;
+
+	if (!hdev->phy_config_fw)
+		return;
+
+	card_location = hdev->card_location;
+	port = cn_port->port;
+
+	rc = gaudi2_cn_phy_port_power_up(cn_port);
+	if (rc)
+		dev_err(hdev->dev, "Card %u Port %u: PHY reconfig failed\n", card_location, port);
+}
+
+int gaudi2_cn_phy_port_init(struct hbl_cn_port *cn_port)
+{
+	struct hbl_cn_device *hdev = cn_port->hdev;
+	u32 port = cn_port->port;
+	int rc;
+
+	mac_lane_remap(hdev, port);
+
+	rc = hbl_cn_phy_init(cn_port);
+	if (rc)
+		dev_err(hdev->dev, "Port %u: failed to init PHY, rc %d\n", port, rc);
+
+	return rc;
+}
+
+void gaudi2_cn_phy_port_fini(struct hbl_cn_port *cn_port)
+{
+	hbl_cn_phy_fini(cn_port);
+}
+
+int gaudi2_cn_phy_reset_macro(struct hbl_cn_macro *cn_macro)
+{
+	struct hbl_cn_device *hdev = cn_macro->hdev;
+	u32 port;
+
+	/* Reset the two ports under the given cn_macro */
+	port = cn_macro->idx << 1;
+
+	/* Enable PHY refclk */
+	NIC_MACRO_WREG32(NIC0_PHY_PHY_IDDQ_0, 0);
+	NIC_MACRO_WREG32(NIC0_PHY_PHY_IDDQ_1, 0);
+
+	phy_port_reset(hdev, port);
+	phy_port_reset(hdev, port + 1);
+
+	return 0;
+}
+
+void gaudi2_cn_phy_flush_link_status_work(struct hbl_cn_device *hdev)
+{
+	struct hbl_cn_port *cn_port;
+	int i;
+
+	for (i = 0; i < hdev->cn_props.max_num_of_ports; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		cn_port = &hdev->cn_ports[i];
+
+		flush_delayed_work(&cn_port->link_status_work);
+	}
+}
+
+static int find_first_enabled_port(struct hbl_cn_device *hdev, u32 *port)
+{
+	int i;
+
+	for (i = 0; i < NIC_NUMBER_OF_PORTS; i++) {
+		if (!(hdev->ports_mask & BIT(i)))
+			continue;
+
+		*port = i;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void fw_write_all(struct hbl_cn_device *hdev, u32 addr, u32 data)
+{
+	int port;
+
+	for (port = 0; port < NIC_NUMBER_OF_PORTS; port++) {
+		if (!(hdev->ports_mask & BIT(port)))
+			continue;
+
+		NIC_PHY_WREG32(addr, data);
+	}
+}
+
+static void fw_write_all_lanes(struct hbl_cn_device *hdev, u32 addr, u32 data)
+{
+	int port, lane;
+
+	for (port = 0; port < NIC_NUMBER_OF_PORTS; port++) {
+		if (!(hdev->ports_mask & BIT(port)))
+			continue;
+
+		for (lane = 0; lane < 2; lane++)
+			NIC_PHY_WREG32_LANE(addr, data);
+	}
+}
+
+static void fw_unload_all(struct hbl_cn_device *hdev)
+{
+	u32 port;
+
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9814, 0xFFF0);
+
+	for (port = 0; port < NIC_NUMBER_OF_PORTS; port++) {
+		if (!(hdev->ports_mask & BIT(port)))
+			continue;
+
+		cpu_reset(hdev, port);
+	}
+
+	msleep(100);
+
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9814, 0x0);
+
+	/* PAM4 */
+	fw_write_all_lanes(hdev, NIC0_SERDES0_LANE0_REGISTER_0P11, 0);
+	usleep_range(1000, 2000);
+	fw_write_all_lanes(hdev, NIC0_SERDES0_LANE0_REGISTER_0P11, 0x2000);
+
+	/* NRZ */
+	fw_write_all_lanes(hdev, NIC0_SERDES0_LANE0_REGISTER_0N0B, 0);
+	fw_write_all_lanes(hdev, NIC0_SERDES0_LANE0_REGISTER_0N0C, 0);
+	usleep_range(1000, 2000);
+	fw_write_all_lanes(hdev, NIC0_SERDES0_LANE0_REGISTER_0N0C, 0x8000);
+}
+
+static u32 fw_crc(struct hbl_cn_device *hdev, u32 port)
+{
+	u32 checksum_code, ignore;
+
+	fw_cmd(hdev, port, 0xF001, NULL, 0xF, &ignore);
+	checksum_code = NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9816);
+
+	return checksum_code;
+}
+
+static u32 fw_hash(struct hbl_cn_device *hdev, u32 port)
+{
+	u32 low_word, hash_code, res;
+
+	fw_cmd(hdev, port, 0xF000, NULL, 0xF, &res);
+	low_word = NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9816);
+	hash_code = ((res & 0xFF) << 16) | low_word;
+
+	return hash_code;
+}
+
+static int mcu_cal_enable_all(struct hbl_cn_device *hdev)
+{
+	u32 port;
+	int rc;
+
+	for (port = 0; port < NIC_NUMBER_OF_PORTS; port++) {
+		if (!(hdev->ports_mask & BIT(port)))
+			continue;
+
+		rc = set_fw_reg(hdev, port, 357, NIC_PHY_FW_TIME_CONSTANT_RATIO);
+		if (rc) {
+			dev_dbg(hdev->dev, "Port %u: MCU calibration failed\n", port);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+int gaudi2_cn_phy_fw_load_all(struct hbl_cn_device *hdev)
+{
+	u32 entry_point, length, ram_addr, sections, status, checks, checksum;
+	int rc, i, j, data_ptr = 0;
+	const struct firmware *fw;
+	const void *fw_data;
+	const char *fw_name;
+	u16 mdio_data;
+	u32 port; /* For regs read */
+
+	rc = find_first_enabled_port(hdev, &port);
+	if (rc)
+		return rc;
+
+	fw_name = gaudi2_cn_phy_get_fw_name();
+
+	fw_unload_all(hdev);
+
+	rc = request_firmware(&fw, fw_name, hdev->dev);
+	if (rc) {
+		dev_err(hdev->dev, "Firmware file %s is not found\n", fw_name);
+		return rc;
+	}
+
+	fw_data = (const void *)fw->data;
+	fw_data += 0x1000;
+
+	/* skip hash, crc and date */
+	entry_point = get_unaligned_be32(fw_data + 8);
+	length = get_unaligned_be32(fw_data + 12);
+	ram_addr = get_unaligned_be32(fw_data + 16);
+
+	dev_dbg(hdev->dev, "entry_point: 0x%x\n", entry_point);
+	dev_dbg(hdev->dev, "length: 0x%x\n", length);
+
+	fw_data += 20;
+
+	sections = DIV_ROUND_UP(length, 24);
+
+	dev_dbg(hdev->dev, "sections: %d\n", sections);
+
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9814, 0xFFF0); /* FW2 */
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_980D, 0x0AAA); /* FW1 */
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_980D, 0x0); /* FW1 */
+
+	checks = 0;
+
+	do {
+		usleep_range(10000, 20000);
+		status = NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9814); /* FW2 */
+		dev_dbg(hdev->dev, "port %d, status: 0x%x\n", port, status);
+		if (checks++ > NIC_PHY_READ_COUNTS_PER_MS) {
+			dev_err(hdev->dev, "failed to load F/W, fw2 timeout 0x%x\n", status);
+			rc = -ETIMEDOUT;
+			goto release_fw;
+		}
+	} while (status);
+
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9814, 0x0);
+
+	for (i = 0; i <= sections; i++) {
+		checksum = 0x800C;
+
+		fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0C, ram_addr >> 16); /* FW0 + 12 */
+		fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0D, ram_addr & 0xFFFF); /* FW0 + 13 */
+		checksum += (ram_addr >> 16) + (ram_addr & 0xFFFF);
+
+		for (j = 0; j < 12; j++) {
+			if (data_ptr >= length)
+				mdio_data = 0;
+			else
+				mdio_data = get_unaligned_be16(fw_data + data_ptr);
+
+			fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F00 + 4 * j, mdio_data);
+
+			checksum += mdio_data;
+			data_ptr += 2;
+			ram_addr += 2;
+		}
+
+		/* FW0 + 14 */
+		fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0E, (~checksum + 1) & 0xFFFF);
+		fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0F, 0x800C); /* FW0 + 15 */
+
+		checks = 0;
+
+		do {
+			usleep_range(1000, 2000);
+			status = NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9F0F); /* FW0 + 15 */
+			if (checks++ > NIC_PHY_READ_COUNTS_PER_MS) {
+				dev_err(hdev->dev, "failed to load F/W, fw0 timeout 0x%x\n",
+					status);
+				rc = -ETIMEDOUT;
+				goto release_fw;
+			}
+		} while (status == 0x800C);
+	}
+
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0C, entry_point >> 16); /* FW0 + 12 */
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0D, entry_point & 0xFFFF); /* FW0 + 13 */
+	checksum = (entry_point >> 16) + (entry_point & 0xFFFF) + 0x4000;
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0E, (~checksum + 1) & 0xFFFF); /* FW0 + 14 */
+	fw_write_all(hdev, NIC0_SERDES0_REGISTER_9F0F, 0x4000); /* FW0 + 15 */
+
+	msleep(500);
+
+	dev_dbg(hdev->dev, "F/W CRC = 0x%x\n", fw_crc(hdev, port));
+	dev_dbg(hdev->dev, "F/W hash = 0x%x\n", fw_hash(hdev, port));
+
+	rc = mcu_cal_enable_all(hdev);
+
+release_fw:
+	release_firmware(fw);
+	return rc;
+}
+
+u16 gaudi2_cn_phy_get_crc(struct hbl_cn_device *hdev)
+{
+	u32 port;
+	int rc;
+
+	rc = find_first_enabled_port(hdev, &port);
+	if (rc)
+		return rc;
+
+	return fw_crc(hdev, port);
+}
+
+static bool is_old_phy_fw_loaded(struct hbl_cn_device *hdev)
+{
+	return gaudi2_cn_phy_get_crc(hdev) == 0x1723;
+}
+
+static bool is_phy_fw_with_anlt_support(struct hbl_cn_device *hdev)
+{
+	return gaudi2_cn_phy_get_crc(hdev) == 0x185E;
+}
+
+int gaudi2_cn_phy_init(struct hbl_cn_device *hdev)
+{
+	if (!hdev->phy_config_fw)
+		return 0;
+
+	/* Fail the initialization in case of an old PHY F/W, as the current PHY init flow won't
+	 * work with it.
+	 */
+	if (is_old_phy_fw_loaded(hdev)) {
+		dev_err(hdev->dev, "PHY F/W is very old - failing the initialization\n");
+		return -EINVAL;
+	}
+
+	/* In case LKD override the existing PHY F/W with an unofficial one and this F/W has ANLT
+	 * support, ANLT will be enabled according to the mask.
+	 * Otherwise, ANLT will be disabled on all ports.
+	 */
+	if (hdev->load_phy_fw && is_phy_fw_with_anlt_support(hdev))
+		hdev->auto_neg_mask = hdev->phys_auto_neg_mask;
+	else
+		hdev->auto_neg_mask = 0;
+
+	/* In case we didn't get serdes info from FW, set to default values */
+	if (hdev->use_fw_serdes_info) {
+		set_fw_lane_mapping(hdev);
+		hbl_cn_phy_set_fw_polarity(hdev);
+	} else {
+		set_default_mac_lane_remap(hdev);
+		set_default_polarity_values(hdev);
+	}
+
+	/* Set the tx taps to their default values only once */
+	if (!hdev->skip_phy_default_tx_taps_cfg) {
+		set_default_tx_taps_values(hdev);
+		hdev->skip_phy_default_tx_taps_cfg = true;
+	}
+
+	return 0;
+}
+
+static int fw_read_s16(struct hbl_cn_device *hdev, u32 port, u32 offset)
+{
+	u32 t = NIC_PHY_RREG32(NIC0_SERDES0_REGISTER_9F00 + 4 * offset);
+
+	return (t & 0x8000) ? t - 0x10000 : t;
+}
+
+static void get_channel_estimation_params(struct hbl_cn_device *hdev, u32 port, int lane, u32 *of,
+					  u32 *hf)
+{
+	struct hbl_cn_port *cn_port = &hdev->cn_ports[port];
+
+	if (cn_port->auto_neg_enable) {
+		*of = rv_debug(hdev, port, lane, 5, 22);
+		*hf = rv_debug(hdev, port, lane, 5, 23);
+	} else {
+		*of = rv_debug(hdev, port, lane, 2, 4);
+		*hf = rv_debug(hdev, port, lane, 2, 5);
+	}
+}
+
+static void get_tx_taps(struct hbl_cn_device *hdev, u32 port, int lane, int *tx_taps)
+{
+	u32 tx_pre2, tx_pre1, tx_main, tx_post1, tx_post2;
+
+	tx_pre2 = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA5) &
+		   NIC0_SERDES0_LANE0_REGISTER_0PA5_TX_PRE_2_MASK) >>
+		  NIC0_SERDES0_LANE0_REGISTER_0PA5_TX_PRE_2_SHIFT;
+	tx_pre1 = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA7) &
+		   NIC0_SERDES0_LANE0_REGISTER_0PA7_TX_PRE_1_MASK) >>
+		  NIC0_SERDES0_LANE0_REGISTER_0PA7_TX_PRE_1_SHIFT;
+	tx_main = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA9) &
+		   NIC0_SERDES0_LANE0_REGISTER_0PA9_TX_MAIN_MASK) >>
+		  NIC0_SERDES0_LANE0_REGISTER_0PA9_TX_MAIN_SHIFT;
+	tx_post1 = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAB) &
+		    NIC0_SERDES0_LANE0_REGISTER_0PAB_TX_POST_1_MASK) >>
+		   NIC0_SERDES0_LANE0_REGISTER_0PAB_TX_POST_1_SHIFT;
+	tx_post2 = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PAD) &
+		    NIC0_SERDES0_LANE0_REGISTER_0PAD_TX_POST_2_MASK) >>
+		   NIC0_SERDES0_LANE0_REGISTER_0PAD_TX_POST_2_SHIFT;
+
+	tx_taps[0] = twos_to_int(tx_pre2, 8);
+	tx_taps[1] = twos_to_int(tx_pre1, 8);
+	tx_taps[2] = twos_to_int(tx_main, 8);
+	tx_taps[3] = twos_to_int(tx_post1, 8);
+	tx_taps[4] = twos_to_int(tx_post2, 8);
+}
+
+static void copy_info(char *buf, char *name, int *data, u8 count, ssize_t size)
+{
+	int i;
+
+	__snprintf(buf, size, "%s:", name);
+
+	for (i = 0; i < count; i++)
+		__snprintf(buf, size, " %d", data[i]);
+
+	__snprintf(buf, size, "\n");
+}
+
+static void dump_ber_info(struct hbl_cn_device *hdev, u32 port, int lane, char *buf, ssize_t size)
+{
+	struct hbl_cn_ber_info *ber_info;
+	u32 abs_lane_idx;
+
+	abs_lane_idx = (port << 1) + lane;
+	ber_info = &hdev->phy_ber_info[abs_lane_idx];
+
+	if (ber_info->valid)
+		__snprintf(buf, size, "BER: %llu.%llue-%u\n",
+			   ber_info->integer, ber_info->frac, ber_info->exp);
+	else
+		__snprintf(buf, size, "No BER information\n");
+}
+
+void gaudi2_cn_phy_dump_serdes_params(struct hbl_cn_device *hdev, char *buf, size_t size)
+{
+	u32 port, card_location, sd, phy_ready, ch_est_of, ch_est_hf, ppm_twos, adapt_state;
+	int lane, i, ppm, eye[3], isi[18], tx_taps[5];
+	u8 tx_pol, rx_pol;
+	bool pam4;
+
+	port = hdev->phy_port_to_dump;
+	card_location = hdev->card_location;
+	pam4 = hdev->cn_ports[port].data_rate == NIC_DR_50;
+
+	__snprintf(buf, size, "\nmode: %s\n\n", pam4 ? "PAM4" : "NRZ");
+
+	for (lane = 0; lane < 2; lane++) {
+		sd = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P6A) &
+		      NIC0_SERDES0_LANE0_REGISTER_0P6A_READ_SIG_DET_MASK) >>
+		     NIC0_SERDES0_LANE0_REGISTER_0P6A_READ_SIG_DET_SHIFT;
+
+		phy_ready = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P6A) &
+			     NIC0_SERDES0_LANE0_REGISTER_0P6A_RX_READ_PHY_READY_MASK) >>
+			    NIC0_SERDES0_LANE0_REGISTER_0P6A_RX_READ_PHY_READY_SHIFT;
+		ppm_twos = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P73) &
+			    NIC0_SERDES0_LANE0_REGISTER_0P73_READ_FREQ_ACC_MASK) >>
+			   NIC0_SERDES0_LANE0_REGISTER_0P73_READ_FREQ_ACC_SHIFT;
+		ppm = twos_to_int(ppm_twos, 11);
+		adapt_state = rv_debug(hdev, port, lane, 2, 0);
+
+		tx_pol = (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0PA0) &
+			  NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_ANA_OUT_FLIP_MASK) >>
+			  NIC0_SERDES0_LANE0_REGISTER_0PA0_TX_ANA_OUT_FLIP_SHIFT;
+
+		rx_pol = pam4 ? (NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0P43) &
+				 NIC0_SERDES0_LANE0_REGISTER_0P43_RX_DATA_FLIP_MASK) >>
+				 NIC0_SERDES0_LANE0_REGISTER_0P43_RX_DATA_FLIP_SHIFT :
+				(NIC_PHY_RREG32_LANE(NIC0_SERDES0_LANE0_REGISTER_0N61) &
+				 NIC0_SERDES0_LANE0_REGISTER_0N61_PRBS_CHECK_FLIP_MASK) >>
+				 NIC0_SERDES0_LANE0_REGISTER_0N61_PRBS_CHECK_FLIP_SHIFT;
+
+		get_channel_estimation_params(hdev, port, lane, &ch_est_of, &ch_est_hf);
+
+		rv_debug(hdev, port, lane, 0xA, 5);
+		for (i = 0; i < 3; i++)
+			eye[i] = fw_read_s16(hdev, port, i);
+
+		rv_debug(hdev, port, lane, 0xA, 0);
+		for (i = 0; i < 16; i++)
+			isi[i] = fw_read_s16(hdev, port, i);
+
+		rv_debug(hdev, port, lane, 0xA, 8);
+		for (i = 0; i < 2; i++)
+			isi[16 + i] = fw_read_s16(hdev, port, i);
+
+		get_tx_taps(hdev, port, lane, tx_taps);
+
+		__snprintf(buf, size, "Card %u Port %u lane %d:\n", card_location, port, lane);
+		__snprintf(buf, size,
+			   "sd: %u\nphy_ready: %u\nppm: %d\nch_est_of: %u\nch_est_hf: %u\n"
+			   "adaptation state: 0x%x\ntx_pol: %u\nrx_pol: %u\n", sd, phy_ready, ppm,
+			   ch_est_of, ch_est_hf, adapt_state, tx_pol, rx_pol);
+		copy_info(buf, "eyes", eye, 3, size);
+		copy_info(buf, "isi", isi, 18, size);
+		copy_info(buf, "tx_taps", tx_taps, 5, size);
+
+		dump_ber_info(hdev, port, lane, buf, size);
+
+		__snprintf(buf, size, "\n");
+	}
+}
diff --git a/include/linux/net/intel/gaudi2.h b/include/linux/net/intel/gaudi2.h
new file mode 100644
index 000000000000..49dd1b6b7c86
--- /dev/null
+++ b/include/linux/net/intel/gaudi2.h
@@ -0,0 +1,432 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#ifndef HBL_GAUDI2_H_
+#define HBL_GAUDI2_H_
+
+#include <linux/net/intel/cn.h>
+#include <linux/net/intel/gaudi2_aux.h>
+
+#define NIC_PSN_NBITS		24
+#define NIC_PSN_MSB_MASK	(BIT(NIC_PSN_NBITS - 1))
+#define NIC_PSN_LOWER_MASK	((NIC_PSN_MSB_MASK) - 1)
+
+#define NIC_IS_PSN_CYCLIC_BIG(psn_a, psn_b) \
+	({ \
+		u32 _psn_a = (psn_a); \
+		u32 _psn_b = (psn_b); \
+		((_psn_a & NIC_PSN_MSB_MASK) == (_psn_b & NIC_PSN_MSB_MASK) ? \
+		 (_psn_a & NIC_PSN_LOWER_MASK) > (_psn_b & NIC_PSN_LOWER_MASK) : \
+		 (_psn_a & NIC_PSN_LOWER_MASK) < (_psn_b & NIC_PSN_LOWER_MASK)); \
+	})
+
+enum gaudi2_wqe_opcode {
+	WQE_NOP = 0,
+	WQE_SEND = 1,
+	WQE_LINEAR = 2,
+	WQE_STRIDE = 3,
+	WQE_MULTI_STRIDE = 4,
+	WQE_RENDEZVOUS_WR = 5,
+	WQE_RENDEZVOUS_RD = 6,
+	WQE_QOS_UPDATE = 7
+};
+
+#define NIC_SKB_PAD_SIZE       187
+
+/**
+ * enum gaudi2_eqe_type - Event queue element types for the NIC.
+ * @EQE_COMP: Completion queue event. May occur upon Ethernet or RDMA Rx completion.
+ * @EQE_COMP_ERR: Completion queue error event. May occur upon CQ overrun or other errors. Overrun
+ *                may occur in case the S/W doesn't consume the CQ entries fast enough so there is
+ *                no room for new H/W's entries.
+ * @EQE_QP_ERR: QP moved to error state event. May occur by varies QP errors, e.g.: QP not valid,
+ *              QP state invalid etc.
+ * @EQE_LINK_STATUS: PCS link status changed event. May occur upon link up/down events.
+ * @EQE_RAW_TX_COMP: Ethernet Tx completion event. May occur once H/W complete to send Ethernet
+ *                   packet.
+ * @EQE_DB_FIFO_OVERRUN: DB FIFO overrun event. May occur upon FIFO overrun in case S/W overwrite
+ *                       un-consumed FIFO entry.
+ * @EQE_CONG: Congestion control completion queue event. May occur upon any packet completion in
+ *            case CC is enabled.
+ * @EQE_CONG_ERR: Congestion control completion queue error event. May occur upon CCQ overrun or
+ *                other errors. Overrun may occur in case the S/W doesn't consume the CCQ entries
+ *                fast enough so there is no room for new H/W's entries.
+ * @EQE_RESERVED: Reserved event value.
+ *
+ * ******************* SW events *******************
+ * @EQE_QP_ALIGN_COUNTERS: QPC sanity failed and QPC counters were reset to last valid values.
+ */
+enum gaudi2_eqe_type {
+	EQE_COMP = 0x0,
+	EQE_COMP_ERR = 0x1,
+	EQE_QP_ERR = 0x2,
+	EQE_LINK_STATUS = 0x3,
+	EQE_RAW_TX_COMP = 0x4,
+	EQE_DB_FIFO_OVERRUN = 0x5,
+	EQE_CONG = 0x6,
+	EQE_CONG_ERR = 0x7,
+	EQE_RESERVED = 0x8,
+
+	/* events triggered by SW */
+	EQE_QP_ALIGN_COUNTERS = 0xa,
+};
+
+/* BIT() macro is overflowing on full 64 bit mask, use the safer BITMLL() instead */
+#define BITMLL(nr)	(U64_MAX >> (64 - (nr)))
+
+/* Use multiple underscores to avoid hiding collisions. Using len and _len like in NIC_SET_BITS()
+ * causes len to be 0 here in NIC_SET().
+ */
+#define NIC_SET(desc, idx, shift, val, __len) \
+	({ \
+		u64 *_data = &(desc).data[(idx)]; \
+		u32 _shift = (shift); \
+		u32 ___len = (__len); \
+		*_data &= ~((u64)(BITMLL(___len)) << _shift); \
+		*_data |= (u64)((val) & BITMLL(___len)) << _shift; \
+	})
+
+#define NIC_SET_BITS(desc, lsb, val, len) \
+	do { \
+		u32 _lsb = (lsb); \
+		u32 _len = (len); \
+		BUILD_BUG_ON((_lsb / 64) != ((_lsb + _len - 1) / 64)); \
+		NIC_SET((desc), _lsb / 64, _lsb % 64, (val), _len); \
+	} while (0)
+
+#define NIC_GET(desc, idx, shift, len) \
+		((((desc).data[idx]) >> (shift)) & BITMLL(len))
+
+#define NIC_GET_BITS(desc, lsb, len) \
+	({ \
+		u32 _lsb = (lsb); \
+		u32 _len = (len); \
+		BUILD_BUG_ON((_lsb / 64) != ((_lsb + _len - 1) / 64)); \
+		NIC_GET(desc, _lsb / 64, _lsb % 64, _len); \
+	})
+
+struct gaudi2_qpc_requester {
+	u64 data[16];
+};
+
+struct qpc_mask {
+	u64 data[sizeof(struct gaudi2_qpc_requester) >> 3];
+};
+
+#define REQ_QPC_SET_DST_QP(req, val)		NIC_SET_BITS(req, 0, val, 24)
+#define REQ_QPC_SET_RKEY(req, val)		NIC_SET_BITS(req, 128, val, 32)
+#define REQ_QPC_SET_DST_IP(req, val)		NIC_SET_BITS(req, 160, val, 32)
+#define REQ_QPC_SET_DST_MAC_LSB(req, val)	NIC_SET_BITS(req, 192, val, 32)
+#define REQ_QPC_SET_DST_MAC_MSB(req, val)	NIC_SET_BITS(req, 224, val, 16)
+#define REQ_QPC_SET_TIMEOUT_RETRY_COUNT(req, val)	\
+						NIC_SET_BITS(req, 248, val, 8)
+#define REQ_QPC_SET_NTS_PSN(req, val)		NIC_SET_BITS(req, 256, val, 24)
+#define REQ_QPC_SET_BCS_PSN(req, val)		NIC_SET_BITS(req, 288, val, 24)
+#define REQ_QPC_SET_SCHD_Q_NUM(req, val)	NIC_SET_BITS(req, 312, val, 8)
+#define REQ_QPC_SET_ONA_PSN(req, val)		NIC_SET_BITS(req, 320, val, 24)
+
+#define REQ_QPC_SET_TM_GRANULARITY(req, val)	NIC_SET_BITS(req, 376, val, 7)
+#define REQ_QPC_SET_WQ_BACK_PRESSURE(req, val)	NIC_SET_BITS(req, 383, val, 1)
+#define REQ_QPC_SET_REMOTE_WQ_LOG_SZ(req, val)	NIC_SET_BITS(req, 408, val, 5)
+#define REQ_QPC_SET_ENCAP_TYPE(req, val)	NIC_SET_BITS(req, 413, val, 3)
+#define REQ_QPC_SET_CQ_NUM(req, val)		NIC_SET_BITS(req, 440, val, 5)
+#define REQ_QPC_SET_RTT_STATE(req, val)		NIC_SET_BITS(req, 445, val, 2)
+#define REQ_QPC_SET_ENCAP_ENABLE(req, val)	NIC_SET_BITS(req, 447, val, 1)
+#define REQ_QPC_SET_CONGESTION_WIN(req, val)	NIC_SET_BITS(req, 448, val, 24)
+#define REQ_QPC_SET_BURST_SIZE(req, val)	NIC_SET_BITS(req, 544, val, 22)
+#define REQ_QPC_SET_ASID(req, val)		NIC_SET_BITS(req, 566, val, 8)
+
+#define REQ_QPC_SET_LAST_IDX(req, val)		NIC_SET_BITS(req, 576, val, 22)
+#define REQ_QPC_SET_EXECUTION_IDX(req, val)	NIC_SET_BITS(req, 608, val, 22)
+#define REQ_QPC_SET_CONSUMER_IDX(req, val)	NIC_SET_BITS(req, 640, val, 22)
+#define REQ_QPC_SET_LOCAL_PRODUCER_IDX(req, val)	NIC_SET_BITS(req, 672, val, 22)
+#define REQ_QPC_SET_REMOTE_PRODUCER_IDX(req, val)	NIC_SET_BITS(req, 704, val, 22)
+#define REQ_QPC_SET_REMOTE_CONSUMER_IDX(req, val)	NIC_SET_BITS(req, 736, val, 22)
+#define REQ_QPC_SET_OLDEST_UNACKED_REMOTE_PRODUCER_IDX(req, val)	NIC_SET_BITS(req, 768, \
+											val, 22)
+#define REQ_QPC_SET_PSN_SINCE_ACKREQ(req, val)	NIC_SET_BITS(req, 800, val, 8)
+#define REQ_QPC_SET_ACKREQ_FREQ(req, val)	NIC_SET_BITS(req, 808, val, 8)
+#define REQ_QPC_SET_PACING_TIME(req, val)	NIC_SET_BITS(req, 832, val, 16)
+
+#define REQ_QPC_SET_DATA_MMU_BYPASS(req, val)	NIC_SET_BITS(req, 1003, val, 1)
+#define REQ_QPC_SET_MOD_GAUDI1(req, val)	NIC_SET_BITS(req, 1004, val, 1)
+#define REQ_QPC_SET_PORT(req, val)		NIC_SET_BITS(req, 1005, val, 2)
+#define REQ_QPC_SET_WQ_TYPE(req, val)		NIC_SET_BITS(req, 1007, val, 2)
+
+#define REQ_QPC_SET_SWQ_GRANULARITY(req, val)	NIC_SET_BITS(req, 1009, val, 1)
+#define REQ_QPC_SET_TRANSPORT_SERVICE(req, val)	NIC_SET_BITS(req, 1010, val, 1)
+#define REQ_QPC_SET_PRIORITY(req, val)		NIC_SET_BITS(req, 1011, val, 2)
+#define REQ_QPC_SET_CONGESTION_MODE(req, val)	NIC_SET_BITS(req, 1013, val, 2)
+#define REQ_QPC_SET_MTU(req, val)		NIC_SET_BITS(req, 1015, val, 2)
+
+#define REQ_QPC_SET_WQ_BASE_ADDR(req, val)	NIC_SET_BITS(req, 1017, val, 2)
+#define REQ_QPC_SET_TRUST_LEVEL(req, val)	NIC_SET_BITS(req, 1019, val, 2)
+#define REQ_QPC_SET_ERR(req, val)		NIC_SET_BITS(req, 1022, val, 1)
+#define REQ_QPC_SET_VALID(req, val)		NIC_SET_BITS(req, 1023, val, 1)
+
+/* REQ QPC Get */
+#define REQ_QPC_GET_DST_QP(req)					NIC_GET_BITS(req, 0, 24)
+#define REQ_QPC_GET_MULTI_STRIDE_STATE_LSB(req)			NIC_GET_BITS(req, 32, 32)
+#define REQ_QPC_GET_MULTI_STRIDE_STATE_MSB(req)			NIC_GET_BITS(req, 64, 64)
+#define REQ_QPC_GET_RKEY(req)					NIC_GET_BITS(req, 128, 32)
+#define REQ_QPC_GET_DST_IP(req)					NIC_GET_BITS(req, 160, 32)
+#define REQ_QPC_GET_DST_MAC_LSB(req)				NIC_GET_BITS(req, 192, 32)
+#define REQ_QPC_GET_DST_MAC_MSB(req)				NIC_GET_BITS(req, 224, 16)
+#define REQ_QPC_GET_SEQUENCE_ERROR_RETRY_COUNT(req)		NIC_GET_BITS(req, 240, 8)
+#define REQ_QPC_GET_TIMEOUT_RETRY_COUNT(req)			NIC_GET_BITS(req, 248, 8)
+#define REQ_QPC_GET_NTS_PSN(req)				NIC_GET_BITS(req, 256, 24)
+#define REQ_QPC_GET_BCS_PSN(req)				NIC_GET_BITS(req, 288, 24)
+#define REQ_QPC_GET_SCHD_Q_NUM(req)				NIC_GET_BITS(req, 312, 8)
+#define REQ_QPC_GET_ONA_PSN(req)				NIC_GET_BITS(req, 320, 24)
+#define REQ_QPC_GET_BCC_PSN(req)				NIC_GET_BITS(req, 352, 24)
+#define REQ_QPC_GET_TM_GRANULARITY(req)				NIC_GET_BITS(req, 376, 7)
+#define REQ_QPC_GET_WQ_BACK_PRESSURE(req)			NIC_GET_BITS(req, 383, 1)
+#define REQ_QPC_GET_CONGESTION_MARKED_ACK(req)			NIC_GET_BITS(req, 384, 24)
+#define REQ_QPC_GET_REMOTE_WQ_LOG_SZ(req)			NIC_GET_BITS(req, 408, 5)
+#define REQ_QPC_GET_ENCAP_TYPE(req)				NIC_GET_BITS(req, 413, 3)
+#define REQ_QPC_GET_CONGESTION_NON_MARKED_ACK(req)		NIC_GET_BITS(req, 416, 24)
+#define REQ_QPC_GET_CQ_NUM(req)					NIC_GET_BITS(req, 440, 5)
+#define REQ_QPC_GET_RTT_STATE(req)				NIC_GET_BITS(req, 445, 2)
+#define REQ_QPC_GET_ENCAP_ENABLE(req)				NIC_GET_BITS(req, 447, 1)
+#define REQ_QPC_GET_CONGESTION_WIN(req)				NIC_GET_BITS(req, 448, 24)
+#define REQ_QPC_GET_RTT_TIMESTAMP(req)				NIC_GET_BITS(req, 480, 25)
+#define REQ_QPC_GET_RTT_MARKED_PSN(req)				NIC_GET_BITS(req, 512, 24)
+#define REQ_QPC_GET_BURST_SIZE(req)				NIC_GET_BITS(req, 544, 22)
+#define REQ_QPC_GET_ASID(req)					NIC_GET_BITS(req, 566, 10)
+#define REQ_QPC_GET_LAST_IDX(req)				NIC_GET_BITS(req, 576, 22)
+#define REQ_QPC_GET_EXECUTION_IDX(req)				NIC_GET_BITS(req, 608, 22)
+#define REQ_QPC_GET_CONSUMER_IDX(req)				NIC_GET_BITS(req, 640, 22)
+#define REQ_QPC_GET_LOCAL_PRODUCER_IDX(req)			NIC_GET_BITS(req, 672, 22)
+#define REQ_QPC_GET_REMOTE_PRODUCER_IDX(req)			NIC_GET_BITS(req, 704, 22)
+#define REQ_QPC_GET_REMOTE_CONSUMER_IDX(req)			NIC_GET_BITS(req, 736, 22)
+#define REQ_QPC_GET_OLDEST_UNACKED_REMOTE_PRODUCER_IDX(req)	NIC_GET_BITS(req, 768, 22)
+#define REQ_QPC_GET_PSN_SINCE_ACKREQ(req)			NIC_GET_BITS(req, 800, 8)
+#define REQ_QPC_GET_ACKREQ_FREQ(req)				NIC_GET_BITS(req, 808, 8)
+#define REQ_QPC_GET_PACING_TIME(req)				NIC_GET_BITS(req, 832, 16)
+#define REQ_QPC_GET_PSN_DELIVERED(req)				NIC_GET_BITS(req, 864, 24)
+#define REQ_QPC_GET_DATA_MMU_BYPASS(req)			NIC_GET_BITS(req, 1003, 1)
+#define REQ_QPC_GET_MOD_GAUDI1(req)				NIC_GET_BITS(req, 1004, 1)
+#define REQ_QPC_GET_PORT(req)					NIC_GET_BITS(req, 1005, 2)
+#define REQ_QPC_GET_WQ_TYPE(req)				NIC_GET_BITS(req, 1007, 2)
+#define REQ_QPC_GET_SWQ_GRANULARITY(req)			NIC_GET_BITS(req, 1009, 1)
+#define REQ_QPC_GET_TRANSPORT_SERVICE(req)			NIC_GET_BITS(req, 1010, 1)
+#define REQ_QPC_GET_PRIORITY(req)				NIC_GET_BITS(req, 1011, 2)
+#define REQ_QPC_GET_CONGESTION_MODE(req)			NIC_GET_BITS(req, 1013, 2)
+#define REQ_QPC_GET_MTU(req)					NIC_GET_BITS(req, 1015, 2)
+#define REQ_QPC_GET_WQ_BASE_ADDR(req)				NIC_GET_BITS(req, 1017, 2)
+#define REQ_QPC_GET_TRUST_LEVEL(req)				NIC_GET_BITS(req, 1019, 2)
+#define REQ_QPC_GET_IN_WORK(req)				NIC_GET_BITS(req, 1021, 1)
+#define REQ_QPC_GET_ERROR(req)					NIC_GET_BITS(req, 1022, 1)
+#define REQ_QPC_GET_VALID(req)					NIC_GET_BITS(req, 1023, 1)
+
+/* Resp QPC */
+struct gaudi2_qpc_responder {
+	u64 data[4];
+};
+
+#define RES_QPC_SET_DST_QP(res, val)		NIC_SET_BITS(res, 0, val, 24)
+#define RES_QPC_SET_PORT(res, val)		NIC_SET_BITS(res, 24, val, 2)
+#define RES_QPC_SET_PRIORITY(res, val)		NIC_SET_BITS(res, 26, val, 2)
+#define RES_QPC_SET_LKEY(res, val)		NIC_SET_BITS(res, 32, val, 32)
+
+#define RES_QPC_SET_DST_IP(res, val)		NIC_SET_BITS(res, 64, val, 32)
+#define RES_QPC_SET_DST_MAC_LSB(res, val)	NIC_SET_BITS(res, 96, val, 32)
+#define RES_QPC_SET_DST_MAC_MSB(res, val)	NIC_SET_BITS(res, 128, val, 16)
+#define RES_QPC_SET_TRANSPORT_SERVICE(res, val)	NIC_SET_BITS(res, 149, val, 1)
+
+#define RES_QPC_SET_ASID(res, val)		NIC_SET_BITS(res, 150, val, 10)
+#define RES_QPC_SET_PEER_QP(res, val)		NIC_SET_BITS(res, 160, val, 24)
+#define RES_QPC_SET_SCHD_Q_NUM(res, val)	NIC_SET_BITS(res, 184, val, 8)
+
+#define RES_QPC_SET_TRUST_LEVEL(res, val)	NIC_SET_BITS(res, 216, val, 2)
+#define RES_QPC_SET_MOD_GAUDI1(res, val)	NIC_SET_BITS(res, 218, val, 1)
+#define RES_QPC_SET_DATA_MMU_BYPASS(res, val)	NIC_SET_BITS(res, 219, val, 1)
+#define RES_QPC_SET_ENCAP_TYPE(res, val)	NIC_SET_BITS(res, 220, val, 3)
+#define RES_QPC_SET_ENCAP_ENABLE(res, val)	NIC_SET_BITS(res, 223, val, 1)
+#define RES_QPC_SET_CQ_NUM(res, val)		NIC_SET_BITS(res, 248, val, 5)
+
+#define RES_QPC_SET_PEER_WQ_GRAN(res, val)	NIC_SET_BITS(res, 253, val, 1)
+#define RES_QPC_SET_VALID(res, val)		NIC_SET_BITS(res, 255, val, 1)
+
+/* Resp QPC Get */
+#define RES_QPC_GET_DESTINATION_QP(res)		NIC_GET_BITS(res, 0, 24)
+#define RES_QPC_GET_PORT(res)			NIC_GET_BITS(res, 24, 2)
+#define RES_QPC_GET_PRIORITY(res)		NIC_GET_BITS(res, 26, 2)
+#define RES_QPC_GET_CONN_STATE(res)		NIC_GET_BITS(res, 28, 2)
+#define RES_QPC_GET_NACK_SYNDROME(res)		NIC_GET_BITS(res, 30, 2)
+#define RES_QPC_GET_LKEY(res)			NIC_GET_BITS(res, 32, 32)
+#define RES_QPC_GET_DST_IP(res)			NIC_GET_BITS(res, 64, 32)
+#define RES_QPC_GET_DST_MAC_LSB(res)		NIC_GET_BITS(res, 96, 32)
+#define RES_QPC_GET_DST_MAC_MSB(res)		NIC_GET_BITS(res, 128, 16)
+#define RES_QPC_GET_ECN_COUNT(res)		NIC_GET_BITS(res, 144, 5)
+#define RES_QPC_GET_TRANSPORT_SERVICE(res)	NIC_GET_BITS(res, 149, 1)
+#define RES_QPC_GET_ASID(res)			NIC_GET_BITS(res, 150, 10)
+#define RES_QPC_GET_PEER_QP(res)		NIC_GET_BITS(res, 160, 24)
+#define RES_QPC_GET_SCHD_Q_NUM(res)		NIC_GET_BITS(res, 184, 8)
+#define RES_QPC_GET_EXPECTED_PSN(res)		NIC_GET_BITS(res, 192, 24)
+#define RES_QPC_GET_TRUST_LEVEL(res)		NIC_GET_BITS(res, 216, 2)
+#define RES_QPC_GET_MOD_GAUDI1(res)		NIC_GET_BITS(res, 218, 1)
+#define RES_QPC_GET_DATA_MMU_BYPASS(res)	NIC_GET_BITS(res, 219, 1)
+#define RES_QPC_GET_ENCAP_TYPE(res)		NIC_GET_BITS(res, 220, 3)
+#define RES_QPC_GET_ENCAP_ENABLE(res)		NIC_GET_BITS(res, 223, 1)
+#define RES_QPC_GET_CYCLIC_IDX(res)		NIC_GET_BITS(res, 224, 24)
+#define RES_QPC_GET_CQ_NUM(res)			NIC_GET_BITS(res, 248, 5)
+#define RES_QPC_GET_PEER_WQ_GRAN(res)		NIC_GET_BITS(res, 253, 1)
+#define RES_QPC_GET_IN_WORK(res)		NIC_GET_BITS(res, 254, 1)
+#define RES_QPC_GET_VALID(res)			NIC_GET_BITS(res, 255, 1)
+
+struct gaudi2_sq_wqe {
+	u64 data[4];
+};
+
+/* TX WQE Get */
+#define TX_WQE_GET_OPCODE(wqe)			NIC_GET_BITS(wqe, 0, 5)
+#define TX_WQE_GET_TRACE_EVENT_DATA(wqe)	NIC_GET_BITS(wqe, 5, 1)
+#define TX_WQE_GET_TRACE_EVENT(wqe)		NIC_GET_BITS(wqe, 6, 1)
+#define TX_WQE_GET_WQE_INDEX(wqe)		NIC_GET_BITS(wqe, 8, 8)
+#define TX_WQE_GET_REDUCTION_OPCODE(wqe)	NIC_GET_BITS(wqe, 16, 13)
+#define TX_WQE_GET_SE(wqe)			NIC_GET_BITS(wqe, 29, 1)
+#define TX_WQE_GET_INLINE(wqe)			NIC_GET_BITS(wqe, 30, 1)
+#define TX_WQE_GET_ACKREQ(wqe)			NIC_GET_BITS(wqe, 31, 1)
+#define TX_WQE_GET_SIZE(wqe)			NIC_GET_BITS(wqe, 32, 32)
+#define TX_WQE_GET_LOCAL_ADDR_LSB(wqe)		NIC_GET_BITS(wqe, 64, 32)
+#define TX_WQE_GET_LOCAL_ADDR_MSB(wqe)		NIC_GET_BITS(wqe, 96, 32)
+#define TX_WQE_GET_REMOTE_ADDR_LSB(wqe)		NIC_GET_BITS(wqe, 128, 32)
+#define TX_WQE_GET_REMOTE_ADDR_MSB(wqe)		NIC_GET_BITS(wqe, 160, 32)
+#define TX_WQE_GET_TAG(wqe)			NIC_GET_BITS(wqe, 192, 32)
+#define TX_WQE_GET_REMOTE_SOB(wqe)		NIC_GET_BITS(wqe, 224, 27)
+#define TX_WQE_GET_REMOTE_SOB_DATA(wqe)		NIC_GET_BITS(wqe, 251, 2)
+#define TX_WQE_GET_SOB_CMD(wqe)			NIC_GET_BITS(wqe, 253, 1)
+#define TX_WQE_GET_COMPLETION_TYPE(wqe)		NIC_GET_BITS(wqe, 254, 2)
+
+/* TX WQE Set */
+#define CFG_SQ_WQE_RESET(swq) memset((swq)->data, 0, sizeof(u64) * 4)
+
+#define CFG_SQ_WQE_OPCODE(swq, val) \
+						((swq)->data[0] |= (val))
+#define CFG_SQ_WQE_INDEX(swq, val) \
+						((swq)->data[0] |= (val) << 8)
+#define CFG_SQ_WQE_SOL_EVENT(swq, val) \
+						((swq)->data[0] |= (val) << 29)
+#define CFG_SQ_WQE_INLINE(swq, val) \
+						((swq)->data[0] |= (val) << 30)
+#define CFG_SQ_WQE_SIZE(swq, val) \
+						((swq)->data[0] |= (val) << 32)
+#define CFG_SQ_WQE_LOCAL_ADDRESS(swq, val) \
+						((swq)->data[1] = (val))
+struct gaudi2_rq_wqe {
+	u64 data[2];
+};
+
+/* RX WQE Get */
+#define RX_WQE_GET_OPCODE(wqe)			NIC_GET_BITS(wqe, 0, 5)
+#define RX_WQE_GET_WQE_INDEX(wqe)		NIC_GET_BITS(wqe, 8, 8)
+#define RX_WQE_GET_SOB_CMD(wqe)			NIC_GET_BITS(wqe, 31, 1)
+#define RX_WQE_GET_LOCAL_SOB(wqe)		NIC_GET_BITS(wqe, 32, 27)
+#define RX_WQE_GET_LOCAL_SOB_DATA(wqe)		NIC_GET_BITS(wqe, 59, 3)
+#define RX_WQE_GET_COMPLETION_TYPE(wqe)		NIC_GET_BITS(wqe, 62, 2)
+#define RX_WQE_GET_SIZE(wqe)			NIC_GET_BITS(wqe, 64, 32)
+#define RX_WQE_GET_TAG(wqe)			NIC_GET_BITS(wqe, 96, 32)
+
+struct gaudi2_cqe {
+	u32 data[4];
+};
+
+#define CQE_IS_VALID(cqe)		(((cqe)->data[0] >> 31) & 1)
+#define CQE_IS_REQ(cqe)			(((cqe)->data[0] >> 24) & 1)
+#define CQE_QPN(cqe)			((cqe)->data[0] & 0xFFFFFF)
+#define CQE_SET_INVALID(cqe)		((cqe)->data[0] &= ~(1ull << 31))
+#define CQE_WQE_IDX(cqe)		((cqe)->data[1])
+#define CQE_TAG(cqe)			((cqe)->data[2])
+#define CQE_RAW_PKT_SIZE(cqe)		((cqe)->data[3])
+
+#define EQE_HEADER(valid, type)		((!!(valid) << 31) | (type))
+#define EQE_TYPE(eqe)			((eqe)->data[0] & 0xf)
+#define EQE_IS_VALID(eqe)		(((eqe)->data[0] >> 31) & 0x1)
+#define EQE_SET_INVALID(eqe)		((eqe)->data[0] &= ~(1ull << 31))
+#define EQE_CQ_EVENT_CQ_NUM(eqe)	((eqe)->data[1] & 0xffff)
+#define EQE_CQ_EVENT_PI(eqe)		((eqe)->data[2])
+#define EQE_CQ_EVENT_CCQ_NUM(eqe)	((eqe)->data[1] & 0xffff)
+
+#define EQE_QP_EVENT_QPN(eqe)		((eqe)->data[1] & 0xffffff)
+#define EQE_QP_EVENT_RESET(eqe)		(((eqe)->data[1] >> 31) & 0x1)
+#define EQE_QP_EVENT_ERR_SYND(eqe)	((eqe)->data[2])
+
+#define EQE_RAW_TX_EVENT_QPN(eqe)	((eqe)->data[1] & 0xffffff)
+#define EQE_RAW_TX_EVENT_IDX(eqe)	((eqe)->data[2] & 0xffffffff)
+
+#define EQE_LINK_STATUS_TIME_STAMP(eqe)	((eqe)->data[1])
+#define EQE_LINK_STATUS(eqe)		((eqe)->data[2] & 0xf)
+
+#define EQE_DB_EVENT_DB_NUM(eqe)	((eqe)->data[1] & 0xffff)
+
+#define EQE_SW_EVENT_QPN(eqe)		((eqe)->data[1] & 0xffffff)
+
+#define EQ_IDX_MASK			GENMASK(23, 0)
+
+/**
+ * struct gaudi2_en_tx_buf - indicates a tx buffer
+ * @skb: the transmitted skb
+ * @dma_addr: the skb's mapped dma address
+ * @len: buffer size
+ */
+struct gaudi2_en_tx_buf {
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	int len;
+};
+
+/**
+ * struct gaudi2_en_aux_data - Gaudi2 Ethernet driver data.
+ * @rx_rings: array of the Rx rings of all ports.
+ * @cq_rings: array of the CQ rings of all ports.
+ * @wq_rings: array of the WQ rings of all ports.
+ * @kernel_asid: kernel ASID.
+ * @raw_qpn: raw data (Ethernet) QP number.
+ * @tx_ring_len: number of elements in the Tx ring.
+ * @schedq_num: sched-Q number used for the Eth driver of the port.
+ * @pad_size: the pad size in bytes for the skb to transmit.
+ */
+struct gaudi2_en_aux_data {
+	struct hbl_cn_ring **rx_rings;
+	struct hbl_cn_ring **cq_rings;
+	struct hbl_cn_ring **wq_rings;
+	u32 kernel_asid;
+	u32 raw_qpn;
+	u32 tx_ring_len;
+	u32 schedq_num;
+	u16 pad_size;
+};
+
+/**
+ * struct gaudi2_en_aux_ops - ASIC specific functions for cn <-> en drivers communication.
+ * @configure_cq: configure a CQ.
+ * @arm_cq: arm a CQ to issue an interrupt after reaching certain index or timeout.
+ * @write_rx_ci: write the Rx CI to the HW.
+ * @get_pfc_cnts: retrieve PFC counters.
+ * @ring_tx_doorbell: ring the Tx door bell so the HW will send it.
+ * @qp_err_syndrome_to_str: Convert error syndrome id to string.
+ * @db_fifo_reset: Reset Ethernet doorbell fifo.
+ * @port_reset_locked: reset the port assuming we are under lock.
+ * @get_overrun_cnt: get db fifo overrun counter.
+ */
+struct gaudi2_en_aux_ops {
+	/* en2cn */
+	void (*configure_cq)(struct hbl_aux_dev *aux_dev, u32 port, u16 coalesce_usec, bool enable);
+	void (*arm_cq)(struct hbl_aux_dev *aux_dev, u32 port, u32 index);
+	void (*write_rx_ci)(struct hbl_aux_dev *aux_dev, u32 port, u32 ci);
+	void (*get_pfc_cnts)(struct hbl_aux_dev *aux_dev, u32 port, int pfc_prio,
+			     u64 *indications, u64 *requests);
+	int (*ring_tx_doorbell)(struct hbl_aux_dev *aux_dev, u32 port, u32 pi, bool *full_after_tx);
+	char* (*qp_err_syndrome_to_str)(u32 syndrome);
+	void (*db_fifo_reset)(struct hbl_aux_dev *aux_dev, u32 port);
+
+	/* cn2en */
+	int (*port_reset_locked)(struct hbl_aux_dev *aux_dev, u32 port);
+	u32 (*get_overrun_cnt)(struct hbl_aux_dev *aux_dev, u32 port_idx);
+};
+
+#endif /* HBL_GAUDI2_H_ */
diff --git a/include/linux/net/intel/gaudi2_aux.h b/include/linux/net/intel/gaudi2_aux.h
new file mode 100644
index 000000000000..6b2025ff5713
--- /dev/null
+++ b/include/linux/net/intel/gaudi2_aux.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright 2020-2024 HabanaLabs, Ltd.
+ * Copyright (C) 2023-2024, Intel Corporation.
+ * All Rights Reserved.
+ */
+
+#ifndef HBL_GAUDI2_AUX_H_
+#define HBL_GAUDI2_AUX_H_
+
+#include <linux/types.h>
+#include <linux/net/intel/cn_aux.h>
+
+enum gaudi2_setup_type {
+	GAUDI2_SETUP_TYPE_HLS2,
+};
+
+/**
+ * struct gaudi2_cn_aux_data - Gaudi2 CN driver data.
+ * @setup_type: type of setup connectivity.
+ * @cfg_base: configuration space base address.
+ * @irq_num_port_base: base IRQ number for port EQ.
+ * @sob_id_base: first reserved SOB ID.
+ * @sob_inc_cfg_val: configuration value for incrementing SOB by one.
+ * @fw_security_enabled: FW security enabled.
+ * @msix_enabled: MSI-X enabled.
+ */
+struct gaudi2_cn_aux_data {
+	enum gaudi2_setup_type setup_type;
+	u64 cfg_base;
+	u32 irq_num_port_base;
+	u32 sob_id_base;
+	u32 sob_inc_cfg_val;
+	u8 fw_security_enabled;
+	u8 msix_enabled;
+};
+
+/**
+ * struct gaudi2_cn_aux_ops - ASIC specific functions for cn <-> compute drivers communication.
+ * @get_event_name: Translate event type to name.
+ * @poll_mem: Poll on a memory address until a given condition is fulfilled or timeout.
+ * @dma_alloc_coherent: Allocate coherent DMA memory.
+ * @dma_free_coherent: Free coherent DMA memory.
+ * @dma_pool_zalloc: Allocate small size DMA memory from the pool.
+ * @dma_pool_free: Free small size DMA memory from the pool.
+ * @spmu_get_stats_info: get SPMU statistics information.
+ * @spmu_config: config the SPMU.
+ * @spmu_sample: read SPMU counters.
+ * @poll_reg: Poll on a register until a given condition is fulfilled or timeout.
+ * @send_cpu_message: send message to F/W. If the message is timedout, the driver will eventually
+ *                    reset the device. The timeout is passed as an argument. If it is 0 the
+ *                    timeout set is the default timeout for the specific ASIC.
+ * @post_send_status: handler for post sending status packet to FW.
+ * @reset_prepare: Prepare to reset.
+ * @reset_late_init: Notify that compute device finished reset.
+ * @sw_err_event_handler: Handle SW error event.
+ * @axi_error_response_event_handler: Handle AXI error.
+ * @ports_stop_prepare: prepare the ports for a stop.
+ * @send_port_cpucp_status: Send port status to FW.
+ */
+struct gaudi2_cn_aux_ops {
+	/* cn2compute */
+	char *(*get_event_name)(struct hbl_aux_dev *aux_dev, u16 event_type);
+	int (*poll_mem)(struct hbl_aux_dev *aux_dev, u32 *addr, u32 *val,
+			hbl_cn_poll_cond_func func);
+	void *(*dma_alloc_coherent)(struct hbl_aux_dev *aux_dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t flag);
+	void (*dma_free_coherent)(struct hbl_aux_dev *aux_dev, size_t size, void *cpu_addr,
+				  dma_addr_t dma_handle);
+	void *(*dma_pool_zalloc)(struct hbl_aux_dev *aux_dev, size_t size, gfp_t mem_flags,
+				 dma_addr_t *dma_handle);
+	void (*dma_pool_free)(struct hbl_aux_dev *aux_dev, void *vaddr, dma_addr_t dma_addr);
+	void (*spmu_get_stats_info)(struct hbl_aux_dev *aux_dev, u32 port,
+				    struct hbl_cn_stat **stats, u32 *n_stats);
+	int (*spmu_config)(struct hbl_aux_dev *aux_dev, u32 port, u32 num_event_types,
+			   u32 event_types[], bool enable);
+	int (*spmu_sample)(struct hbl_aux_dev *aux_dev, u32 port, u32 num_out_data, u64 out_data[]);
+	int (*poll_reg)(struct hbl_aux_dev *aux_dev, u32 reg, u64 timeout_us,
+			hbl_cn_poll_cond_func func, void *arg);
+	int (*send_cpu_message)(struct hbl_aux_dev *aux_dev, u32 *msg, u16 len, u32 timeout,
+				u64 *result);
+	void (*post_send_status)(struct hbl_aux_dev *aux_dev, u32 port);
+	/* compute2cn */
+	void (*reset_prepare)(struct hbl_aux_dev *aux_dev);
+	void (*reset_late_init)(struct hbl_aux_dev *aux_dev);
+	int (*sw_err_event_handler)(struct hbl_aux_dev *aux_dev, u16 event_type, u8 macro_index,
+				    struct hl_eq_nic_intr_cause *intr_cause_cpucp);
+	int (*axi_error_response_event_handler)(struct hbl_aux_dev *aux_dev, u16 event_type,
+						u8 macro_index,
+						struct hl_eq_nic_intr_cause *intr_cause_cpucp);
+	void (*ports_stop_prepare)(struct hbl_aux_dev *aux_dev, bool fw_reset, bool in_teardown);
+	int (*send_port_cpucp_status)(struct hbl_aux_dev *aux_dev, u32 port, u8 cmd, u8 period);
+};
+
+#endif /* HBL_GAUDI2_AUX_H_ */
-- 
2.34.1

