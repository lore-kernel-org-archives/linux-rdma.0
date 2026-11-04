Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.38
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807824;
	b=RBxlFXu3ThurmmnQqVDaSVpt3qvFMk62odMF+wrH1dxs0a4+1CSXML/ISxUVPpTMPtsT
	 oNE67ys/BgQrWtkXlZQFeRYPLMLqfKygAdgPTsJpq+NwkNMWHW5RHgy7o1ErNUtVGDyA1
	 /zZHseO8iNGdrDrqy+yCOX3TejFgFZUw2Pf1AAP545j9XtOBJBqHzdCuw0mDNOJyIUsqT
	 FmLI9MTcm6a5ZCWfRZpNH5raBEjXoy0ueo8bRcrvIiMpMCq0Qa9rYcbtILI1ADM/MVhOB
	 PPzwgrbYaJLWZCAkeeBAf4eqN8/vq0yh4BmxqKQ4X/c9uNWDL1LZqK8MgTbcJmi/Qqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807824;
	h=DMARC-Filter:DKIM-Signature:To:Date:X-Lms-Return-Path:Subject:
	 Mime-Version:X-Mailer:In-Reply-To:References:Received:Content-Type:
	 X-Original-From:Content-Transfer-Encoding:Cc:From:Message-Id;
	bh=sPRldwEz1nne4YMKgH0y+ZI8QpeWJuj/Rnm+22Z5KZ8=;
	b=z7SY9l9nu6WTUBbFYi2Sktum/sP7+2rDeHpfR60Vfc7LbM9OFVIq8bpPMXY8YezYVr8z
	 FK2fUd1KlgcHbFEBU6ueFKA4SRULakyfijw0782O9ldnL+RCJatj36jfIidy1ccUX8oC2
	 3k+D/q18PeZy9VIvZkxawvzDCKqCOM25B3a9jQbTDVnPDcSE/JuFmDBLYaURitk0/AMzM
	 H8lg5XJFoa7SZUG64FnMdlQ63de13tBFPNemFMfOt/io0lHRmlWsvj+XPUEsDi/7u/yFG
	 JLPCC4Nb4Gf4jeVw36oafVEQawVmWxXDyJBOQtEyIEG7t1OAIZEgYS8iACDW3cXZnSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=RO36VakQ;
	arc=none smtp.remote-ip=209.127.231.38
Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34662606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34662606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=RO36VakQ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807817; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=sPRldwEz1nne4YMKgH0y+ZI8QpeWJuj/Rnm+22Z5KZ8=;
 b=RO36VakQg5dRT44rN17/xCQNnkM0uYHBWij3Vx6ifhX2v2SKfO2EeZ3g/YXmJ4blZabNmq
 0p9aO8Mm7o8uUkbUlzczF/7d060aozZotgRHpuLQAEQZ2V7TJ9rAQIsE50S4arsAr33RYV
 dg7jQ933RgeIMbwqg+imVlCe6Un+bsDUhjue94da9xwTygH0V2uE9XfCbjaL7EC+KAParn
 rrXhL9aUa5vvj9ZL1T5s2OqV15c7eHROX537jE3iQdmAwkltoUIgiJQzMZp6ORzC2sR0FI
 5GVtvvpYd8sBuAef/ApVpCbvqzwe+0Z+kWD1o75XNdpPaIh5694IfxcWCjj2gg==
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
Date: Wed, 04 Nov 2026 23:56:55 +0800
X-Lms-Return-Path: <lba+26aeb55c7+3b04cd+vger.kernel.org+tianx@yunsilicon.com>
Subject: [PATCH v1 02/15] net/xsc: add PCI core driver skeleton
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
References: <20261104155650.37053-1-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:56:55 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Message-Id: <20261104155653.37053-3-tianx@yunsilicon.com>

Add the PCI core driver for Yunsilicon XSC controllers.  The driver
binds to the PCI functions and provides the shared infrastructure
that the ethernet and RDMA function drivers build on: a central
xsc_core_device per PCI function, firmware capability parsing, DMA
buffer abstractions, and the QP/CQ/EQ resource tables.

Introduce the common headers describing the firmware interface:
the HSI wire formats (hca_cap, command mailboxes, QP/CQ contexts,
WQE/CQE layouts), the command interface structures, and the device
resource tables.  The capabilities are read from firmware at init
and drive most later configuration, including the 64-bit feature
flag bits and the MPT/MTT geometry.

The probe path keeps to PCI lifecycle work: map BAR 0, set a 64-bit
DMA mask with a 2G segment size limit, save the PCI state, and
allocate the core device.  Support PF device IDs for vendor 0x1f67;
SR-IOV and VF handling are not part of this series.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/yunsilicon/Kconfig       |   26 +
 drivers/net/ethernet/yunsilicon/Makefile      |    8 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmd.h  | 1025 +++++++++++++++++
 .../yunsilicon/xsc/common/xsc_cmd_api.h       |   25 +
 .../ethernet/yunsilicon/xsc/common/xsc_cmdq.h |  191 +++
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |  662 +++++++++++
 .../yunsilicon/xsc/common/xsc_device.h        |   94 ++
 .../ethernet/yunsilicon/xsc/common/xsc_hsi.h  |  123 ++
 .../ethernet/yunsilicon/xsc/common/xsc_reg.h  |   28 +
 .../net/ethernet/yunsilicon/xsc/pci/Kconfig   |   15 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |    9 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  255 ++++
 14 files changed, 2463 insertions(+)
 create mode 100644 drivers/net/ethernet/yunsilicon/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd_api.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_device.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_hsi.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/main.c

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 8581ccba1..3f357b773 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -70,6 +70,7 @@ source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
+source "drivers/net/ethernet/yunsilicon/Kconfig"
 
 config JME
 	tristate "JMicron(R) PCI-Express Gigabit Ethernet support"
diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
index 2b1153d35..4ad89b36b 100644
--- a/drivers/net/ethernet/Makefile
+++ b/drivers/net/ethernet/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_NET_VENDOR_INTEL) += intel/
 obj-$(CONFIG_NET_VENDOR_I825XX) += i825xx/
 obj-$(CONFIG_NET_VENDOR_MICROSOFT) += microsoft/
 obj-$(CONFIG_NET_VENDOR_XSCALE) += xscale/
+obj-$(CONFIG_NET_VENDOR_YUNSILICON) += yunsilicon/
 obj-$(CONFIG_JME) += jme.o
 obj-$(CONFIG_KORINA) += korina.o
 obj-$(CONFIG_LANTIQ_ETOP) += lantiq_etop.o
diff --git a/drivers/net/ethernet/yunsilicon/Kconfig b/drivers/net/ethernet/yunsilicon/Kconfig
new file mode 100644
index 000000000..ffdfdf4bf
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/Kconfig
@@ -0,0 +1,26 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+#
+# Yunsilicon driver configuration
+#
+
+config NET_VENDOR_YUNSILICON
+	bool "Yunsilicon devices"
+	default y
+	depends on PCI
+	depends on 64BIT || COMPILE_TEST
+	help
+	  If you have a network (Ethernet) device belonging to this class,
+	  say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about Yunsilicon cards. If you say Y, you will be asked
+	  for your specific card in the following questions.
+
+if NET_VENDOR_YUNSILICON
+
+source "drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig"
+
+endif # NET_VENDOR_YUNSILICON
diff --git a/drivers/net/ethernet/yunsilicon/Makefile b/drivers/net/ethernet/yunsilicon/Makefile
new file mode 100644
index 000000000..b2924ccaf
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+#
+# Makefile for the Yunsilicon device drivers.
+#
+
+obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc/pci/
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
new file mode 100644
index 000000000..70dbf9782
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
@@ -0,0 +1,1025 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CMD_H
+#define __XSC_CMD_H
+
+#include <linux/if_ether.h>
+
+#define XSC_CMDQ_VERSION	0x32
+
+#define XSC_BOARD_SN_LEN	32
+#define XSC_DSCP_PCP_UNSET		255
+#define XSC_MAX_NUM_PCIE_INTF		2
+#define XSC_MAX_PF_NUM_PER_PCIE		8
+
+/* hca_cap mbox version */
+#define XSC_CMD_QUERY_HCA_CAP_V1	1
+#define XSC_CMD_QUERY_HCA_CAP_V2	2
+#define XSC_CMD_QUERY_HCA_CAP_V3	3
+#define XSC_CMD_QUERY_HCA_CAP_V4	4
+#define XSC_CMD_QUERY_HCA_CAP_V5	5
+#define XSC_CMD_QUERY_HCA_CAP_V6	6
+#define XSC_CMD_QUERY_HCA_CAP_V7	7
+#define XSC_CMD_QUERY_HCA_CAP_V8	8
+#define XSC_CMD_QUERY_HCA_CAP_V9	9
+
+#define XSC_CMD_SET_CQ_CONTEXT_V1	1
+
+enum {
+	XSC_CMDQ_GET_HW_STATS_RDMA_V0 = 0,
+	XSC_CMDQ_GET_HW_STATS_RDMA_V1 = 1,
+
+	XSC_CMDQ_GET_HW_STATS_RDMA_UNKNOW,
+};
+
+enum {
+	XSC_CMD_STAT_OK				= 0x0,
+	XSC_CMD_STAT_INT_ERR			= 0x1,
+	XSC_CMD_STAT_BAD_OP_ERR			= 0x2,
+	XSC_CMD_STAT_BAD_PARAM_ERR		= 0x3,
+	XSC_CMD_STAT_BAD_SYS_STATE_ERR		= 0x4,
+	XSC_CMD_STAT_BAD_RES_ERR		= 0x5,
+	XSC_CMD_STAT_RES_BUSY			= 0x6,
+	XSC_CMD_STAT_LIM_ERR			= 0x8,
+	XSC_CMD_STAT_BAD_RES_STATE_ERR		= 0x9,
+	XSC_CMD_STAT_IX_ERR			= 0xa,
+	XSC_CMD_STAT_NO_RES_ERR			= 0xf,
+	XSC_CMD_STAT_BAD_QP_STATE_ERR		= 0x10,
+	XSC_CMD_STAT_BAD_PKT_ERR		= 0x30,
+	XSC_CMD_STAT_BAD_SIZE_OUTS_CQES_ERR	= 0x40,
+	XSC_CMD_STAT_BAD_INP_LEN_ERR		= 0x50,
+	XSC_CMD_STAT_BAD_OUTP_LEN_ERR		= 0x51,
+};
+
+/* status aliases used by the RDMA driver (same protocol values) */
+#define XSC_CMD_STATUS_OK			XSC_CMD_STAT_OK
+#define XSC_CMD_STATUS_FAIL			XSC_CMD_STAT_INT_ERR
+#define XSC_CMD_STATUS_NOT_SUPPORTED		XSC_CMD_STAT_BAD_OP_ERR
+#define XSC_CMD_STATUS_BAD_PARAM		XSC_CMD_STAT_BAD_PARAM_ERR
+#define XSC_CMD_STATUS_INVAL_RES		XSC_CMD_STAT_BAD_RES_ERR
+#define XSC_CMD_STATUS_BUSY			XSC_CMD_STAT_RES_BUSY
+#define XSC_CMD_STATUS_INVAL_DATA		XSC_CMD_STAT_LIM_ERR
+#define XSC_CMD_STATUS_NOT_FOUND		XSC_CMD_STAT_IX_ERR
+#define XSC_CMD_STATUS_NO_RES			XSC_CMD_STAT_NO_RES_ERR
+#define XSC_CMD_STATUS_BAD_INBUF		XSC_CMD_STAT_BAD_INP_LEN_ERR
+#define XSC_CMD_STATUS_BAD_OUTBUF		XSC_CMD_STAT_BAD_OUTP_LEN_ERR
+
+/* extended status codes */
+#define XSC_CMD_STATUS_INVAL_FUNC		0x41
+#define XSC_CMD_STATUS_NO_MPT_RES		0x42
+#define XSC_CMD_STATUS_NO_MTT_RES		0x43
+#define XSC_CMD_STATUS_NO_EQN_RES		0x44
+#define XSC_CMD_STATUS_NO_EQ_PA_RES		0x45
+#define XSC_CMD_STATUS_NO_CQN_RES		0x46
+#define XSC_CMD_STATUS_NO_CQ_PA_RES		0x47
+#define XSC_CMD_STATUS_NO_QPN_RES		0x48
+#define XSC_CMD_STATUS_NO_QP_PA_RES		0x49
+#define XSC_CMD_STATUS_NO_PDN_RES		0x4a
+#define XSC_CMD_STATUS_QP_FLUSH_BUSY		0x4b
+#define XSC_CMD_STATUS_QP_FLUSH_PENDING		0x4c
+#define XSC_CMD_STATUS_INVAL_OPCODE		0x52
+
+enum {
+	XSC_CMD_OP_QUERY_HCA_CAP		= 0x100,
+	XSC_CMD_OP_QUERY_CMDQ_VERSION		= 0x10a,
+	XSC_CMD_OP_FUNCTION_RESET		= 0x10c,
+	XSC_CMD_OP_DUMMY			= 0x10d,
+	XSC_CMD_OP_QUERY_GUID			= 0x113,
+	XSC_CMD_OP_ACTIVATE_HW_CONFIG		= 0x114,
+
+	XSC_CMD_OP_QUERY_HW_STATS		= 0x1200,
+	XSC_CMD_OP_QUERY_HW_STATS_RDMA		= 0x1203,
+	XSC_CMD_OP_QUERY_HW_GLOBAL_STATS	= 0x1210,
+
+	XSC_CMD_OP_CREATE_MKEY			= 0x200,
+	XSC_CMD_OP_DESTROY_MKEY			= 0x202,
+	XSC_CMD_OP_REG_MR			= 0x204,
+	XSC_CMD_OP_DEREG_MR			= 0x205,
+	XSC_CMD_OP_SET_MPT			= 0x206,
+	XSC_CMD_OP_SET_MTT			= 0x207,
+
+	XSC_CMD_OP_CREATE_EQ			= 0x301,
+	XSC_CMD_OP_DESTROY_EQ			= 0x302,
+
+	XSC_CMD_OP_CREATE_CQ			= 0x400,
+	XSC_CMD_OP_DESTROY_CQ			= 0x401,
+	XSC_CMD_OP_SET_CQ_CONTEXT		= 0x406,
+	XSC_CMD_OP_SET_CQ_BUF_PA		= 0x407,
+	XSC_CMD_OP_CREATE_CQ_EX			= 0x408,
+
+	XSC_CMD_OP_CREATE_QP			= 0x500,
+	XSC_CMD_OP_DESTROY_QP			= 0x501,
+	XSC_CMD_OP_RST2INIT_QP			= 0x502,
+	XSC_CMD_OP_INIT2RTR_QP			= 0x503,
+	XSC_CMD_OP_RTR2RTS_QP			= 0x504,
+	XSC_CMD_OP_RTS2RTS_QP			= 0x505,
+	XSC_CMD_OP_SQERR2RTS_QP			= 0x506,
+	XSC_CMD_OP_2ERR_QP			= 0x507,
+	XSC_CMD_OP_RTS2SQD_QP			= 0x508,
+	XSC_CMD_OP_SQD2RTS_QP			= 0x509,
+	XSC_CMD_OP_2RST_QP			= 0x50a,
+	XSC_CMD_OP_QUERY_QP			= 0x50b,
+	XSC_CMD_OP_INIT2INIT_QP			= 0x50e,
+	XSC_CMD_OP_SQD2SQD_QP			= 0x511,
+	XSC_CMD_OP_CREATE_MULTI_QP		= 0x515,
+
+	XSC_CMD_OP_ALLOC_PD			= 0x800,
+	XSC_CMD_OP_DEALLOC_PD			= 0x801,
+
+	XSC_CMD_OP_MODIFY_RAW_QP		= 0x81f,
+
+	XSC_CMD_OP_ENABLE_NIC_HCA		= 0x810,
+	XSC_CMD_OP_DISABLE_NIC_HCA		= 0x811,
+
+	XSC_CMD_OP_QUERY_VPORT_STATE		= 0x822,
+	XSC_CMD_OP_QUERY_LINK_INFO		= 0x832,
+	XSC_CMD_OP_MODIFY_LINK_INFO		= 0x834,
+	XSC_CMD_OP_QUERY_EVENT_TYPE		= 0x831,
+
+	XSC_CMD_OP_ENABLE_MSIX			= 0x850,
+
+	XSC_CMD_OP_SET_MTU			= 0x1100,
+	XSC_CMD_OP_QUERY_ETH_MAC		= 0X1101,
+
+	XSC_CMD_OP_SET_PORT_ADMIN_STATUS	= 0x1801,
+
+	XSC_CMD_OP_MAX
+};
+
+enum xsc_dma_direct {
+	XSC_DMA_DIR_TO_MAC,
+	XSC_DMA_DIR_READ,
+	XSC_DMA_DIR_WRITE,
+	XSC_DMA_DIR_LOOPBACK,
+	XSC_DMA_DIR_MAX
+};
+
+/* hw feature bitmap, 32bit */
+enum xsc_hw_feature_flag {
+	XSC_HW_RDMA_SUPPORT			= BIT(0),
+	XSC_HW_PFC_PRIO_STATISTIC_SUPPORT	= BIT(1),
+	XSC_HW_PFC_STALL_STATS_SUPPORT		= BIT(3),
+	XSC_HW_RDMA_CM_SUPPORT			= BIT(5),
+	XSC_HW_MTU_8192_SUPPORT			= BIT(11),
+	XSC_HW_RDMA_ATOMIC_SUPPORT		= BIT(17),
+	XSC_HW_MULTIDOORBELL_SUPPORT		= BIT(18),
+	XSC_HW_CQE64_SUPPORT			= BIT(21),
+
+	XSC_HW_LAST_FEATURE			= BIT(31)
+};
+
+struct xsc_inbox_hdr {
+	__be16		opcode;
+	u8		rsvd[4];
+	__be16		ver; /* cmd version */
+};
+
+struct xsc_outbox_hdr {
+	u8		status;
+	u8		rsvd[5];
+	__be16		ver;
+};
+
+/*CQ mbox*/
+struct xsc_cq_context {
+	__be16		eqn; /* event queue number */
+	__be16		pa_num; /* physical address count in the ctx */
+	__be16		glb_func_id;
+	u8		log_cq_sz;
+	u8		cq_type;
+};
+
+struct xsc_cq_context_ex {
+	struct xsc_cq_context ctx;
+	u8		page_shift;
+	u8		overrun_ignore;
+	u8		rsvd[2];
+	__be32		pa_num_ex;
+};
+
+struct xsc_create_cq_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_cq_context	ctx;
+	__be64			pas[]; /* physical address list */
+};
+
+struct xsc_create_cq_ex_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_cq_context_ex	ctx_ex;
+	__be64			pas[];
+};
+
+struct xsc_create_cq_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			cqn; /* completion queue number */
+	u8			rsvd[4];
+};
+
+struct xsc_destroy_cq_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			cqn;
+	u8			rsvd[4];
+};
+
+struct xsc_destroy_cq_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_set_cq_context_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_cq_context_ex	ctx_ex;
+};
+
+struct xsc_set_cq_context_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			cqn;
+	__be32			cq_pa_list_base;
+};
+
+struct xsc_set_cq_buf_pa_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			pa_list_start;
+	__be32			pa_num;
+	__be64			pas[];
+};
+
+struct xsc_set_cq_buf_pa_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+/* MKey / MPT / MTT mbox */
+struct xsc_create_mkey_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			rsvd[4];
+};
+
+struct xsc_create_mkey_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			mkey;
+};
+
+struct xsc_destroy_mkey_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			mkey;
+};
+
+struct xsc_destroy_mkey_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd;
+};
+
+struct xsc_mpt_item {
+	__be32		pdn;
+	__be32		pa_num;
+	__be32		len;
+	__be32		mkey;
+	__be32		len_h;
+	u8		is_gpu;
+	u8		acc;
+	u8		page_mode;
+	u8		map_en;
+	__be64		va_base;
+};
+
+struct xsc_set_mpt_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_mpt_item	mpt_item;
+};
+
+struct xsc_set_mpt_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			mtt_base;
+	u8			rsvd[4];
+};
+
+struct xsc_mtt_setting {
+	__be32		mtt_base;
+	__be32		pa_num;
+	__be64		pas[];
+};
+
+struct xsc_set_mtt_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_mtt_setting	mtt_setting;
+};
+
+struct xsc_set_mtt_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+/*QP mbox*/
+enum {
+	XSC_MODULE_SPEED_UNKNOWN,
+	XSC_MODULE_SPEED_10G,
+	XSC_MODULE_SPEED_25G,
+	XSC_MODULE_SPEED_40G_R4,
+	XSC_MODULE_SPEED_50G_R,
+	XSC_MODULE_SPEED_50G_R2,
+	XSC_MODULE_SPEED_100G_R2,
+	XSC_MODULE_SPEED_100G_R4,
+	XSC_MODULE_SPEED_200G_R4,
+	XSC_MODULE_SPEED_200G_R8,
+	XSC_MODULE_SPEED_400G_R8,
+	XSC_MODULE_SPEED_400G_R4,
+};
+
+struct __packed xsc_create_qp_request {
+	__be16		input_qpn;
+	__be16		pa_num;
+	u8		qp_type;
+	u8		log_sq_sz;
+	u8		log_rq_sz;
+	u8		dma_direct;
+	__be32		pdn; /* protect domain number */
+	__be16		cqn_send;
+	__be16		cqn_recv;
+	__be16		glb_funcid;
+	/*rsvd, the old logic_port */
+	u8		page_shift;
+	u8		rsvd[5];
+	__be64		pas[];
+};
+
+struct xsc_create_qp_mbox_in {
+	struct xsc_inbox_hdr		hdr;
+	struct xsc_create_qp_request	req;
+};
+
+struct xsc_create_qp_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			qpn; /* queue pair number */
+	u8			rsvd[4];
+};
+
+struct xsc_destroy_qp_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			qpn;
+	u8			rsvd[4];
+};
+
+struct xsc_destroy_qp_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+/* MR mbox */
+struct xsc_register_mr_request {
+	__be32		pdn;
+	__be32		pa_num;
+	__be64		len;
+	__be32		mkey;
+	u8		is_gpu;
+	u8		acc;
+	u8		page_mode;
+	u8		map_en;
+	__be64		va_base;
+	__be64		pas[];
+};
+
+struct xsc_register_mr_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_register_mr_request	req;
+};
+
+struct xsc_unregister_mr_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			mkey;
+	u8			rsvd[4];
+};
+
+struct xsc_unregister_mr_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+enum qp_access_flag {
+	QP_ACCESS_REMOTE_READ = (1 << 0),
+	QP_ACCESS_REMOTE_WRITE = (1 << 1),
+	QP_ACCESS_REMOTE_ATOMIC = (1 << 2),
+	QP_ACCESS_MODIFY_QP_TYPE = (1 << 3),
+};
+
+#define	XSC_QP_CONTEXT_V1	1
+#define XSC_QP_CONTEXT_V2	2
+
+struct xsc_qp_context {
+	__be32		remote_qpn;
+	__be32		cqn_send;
+	__be32		cqn_recv;
+	__be32		next_send_psn;
+	__be32		next_recv_psn;
+	__be32		pdn;
+	__be16		src_udp_port;
+	__be16		path_id;
+	u8		mtu_mode;
+	u8		lag_sel;
+	u8		lag_sel_en;
+	u8		retry_cnt;
+	u8		rnr_retry;
+	u8		dscp;
+	u8		state;
+	u8		hop_limit;
+	u8		dmac[6];
+	u8		smac[6];
+	__be32		dip[4];
+	__be32		sip[4];
+	__be16		ip_type;
+	__be16		grp_id;
+	u8		vlan_valid;
+	u8		dci_cfi_prio_sl;
+	__be16		vlan_id;
+	u8		qp_out_port;
+	u8		pcie_no;
+	__be16		lag_id;
+	__be16		func_id;
+	u8		max_sra;
+	u8		max_rra;
+	u8		no_need_wait;
+	u8		swith_qp_type;
+	u8		rsvd0[2];
+	__be32		qp_access_flags;
+};
+
+struct xsc_modify_qp_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			qpn;
+	struct xsc_qp_context	ctx;
+	u8			no_need_wait;
+};
+
+struct xsc_modify_qp_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_query_qp_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			qpn;
+	u8			rsvd[4];
+};
+
+struct xsc_query_qp_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	struct xsc_qp_context	ctx;
+};
+
+struct xsc_create_multiqp_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be16			qp_num;
+	u8			qp_type;
+	u8			rsvd;
+	__be32			req_len;
+	u8			data[];
+};
+
+struct xsc_create_multiqp_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			qpn_base;
+};
+
+/* PD mbox */
+struct xsc_alloc_pd_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_alloc_pd_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			pdn;
+	u8			rsvd[4];
+};
+
+struct xsc_dealloc_pd_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			pdn;
+	u8			rsvd[4];
+};
+
+struct xsc_dealloc_pd_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+/* MSIX TABLE mbox */
+struct xsc_msix_table_info_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be16			index;
+	u8			rsvd[6];
+};
+
+struct xsc_msix_table_info_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			addr_lo;
+	__be32			addr_hi;
+	__be32			data;
+};
+
+/*EQ mbox*/
+struct xsc_eq_context {
+	__be16			vecidx;
+	__be16			pa_num;
+	u8			log_eq_sz;
+	u8			rsvd1;
+	__be16			glb_func_id;
+	u8			is_async_eq;
+	u8			rsvd;
+};
+
+struct xsc_create_eq_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_eq_context	ctx;
+	__be64			pas[];
+};
+
+struct xsc_create_eq_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			eqn;
+	u8			rsvd[4];
+};
+
+struct xsc_destroy_eq_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			eqn;
+	u8			rsvd[4];
+};
+
+struct xsc_destroy_eq_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_cmd_query_cmdq_ver_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_cmd_query_cmdq_ver_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be16			cmdq_ver;
+	u8			rsvd[6];
+};
+
+struct xsc_fw_version {
+	u8		fw_version_major;
+	u8		fw_version_minor;
+	__be16		fw_version_patch;
+	__be32		fw_version_tweak;
+	u8		fw_version_extra_flag;
+	u8		rsvd[7];
+};
+
+struct __packed xsc_hca_cap {
+	u8		rsvd1[12];
+	u8		send_seg_num;
+	u8		send_wqe_shift;
+	u8		recv_seg_num;
+	u8		recv_wqe_shift;
+	u8		log_max_srq_sz;
+	u8		log_max_qp_sz;
+	u8		log_max_mtt;
+	u8		log_max_qp;
+	u8		log_max_strq_sz;
+	u8		log_max_srqs;
+	u8		rsvd4[2];
+	u8		log_max_tso;
+	u8		log_max_cq_sz;
+	u8		rsvd6;
+	u8		log_max_cq;
+	u8		log_max_eq_sz;
+	u8		log_max_mkey;
+	u8		log_max_msix;
+	u8		log_max_eq;
+	u8		max_indirection;
+	u8		log_max_mrw_sz;
+	u8		log_max_bsf_list_sz;
+	u8		log_max_klm_list_sz;
+	u8		rsvd_8_0;
+	u8		log_max_ra_req_dc;
+	u8		rsvd_8_1;
+	u8		log_max_ra_res_dc;
+	u8		rsvd9;
+	u8		log_max_ra_req_qp;
+	u8		log_max_qp_depth;
+	u8		log_max_ra_res_qp;
+	__be16		max_vfs;
+	__be16		raweth_qp_id_end;
+	__be16		raw_tpe_qp_num;
+	__be16		max_qp_count;
+	__be16		raweth_qp_id_base;
+	u8		rsvd13;
+	u8		local_ca_ack_delay;
+	u8		max_num_eqs;
+	u8		num_ports;
+	u8		log_max_msg;
+	u8		mac_port;
+	__be16		raweth_rss_qp_id_base;
+	__be16		stat_rate_support;
+	u8		rsvd16[8];
+	__be64		flags;
+	u8		rsvd17;
+	u8		uar_sz;
+	u8		rsvd18;
+	u8		log_pg_sz;
+	__be16		bf_log_bf_reg_size;
+	__be16		msix_base;
+	__be16		msix_num;
+	__be16		max_desc_sz_sq;
+	u8		rsvd20[2];
+	__be16		max_desc_sz_rq;
+	u8		rsvd21[2];
+	__be16		max_desc_sz_sq_dc;
+	u8		rsvd22[4];
+	__be16		max_qp_mcg;
+	u8		rsvd23;
+	u8		log_max_mcg;
+	u8		rsvd24;
+	u8		log_max_pd;
+	u8		rsvd25;
+	u8		log_max_xrcd;
+	u8		rsvd26[40];
+	__be32		uar_page_sz;
+	u8		rsvd27[8];
+	__be32		hw_feature_flag; /* enum xsc_hw_feature_flag */
+	__be16		pf0_vf_funcid_base;
+	__be16		pf0_vf_funcid_top;
+	__be16		pf1_vf_funcid_base;
+	__be16		pf1_vf_funcid_top;
+	__be16		pcie0_pf_funcid_base;
+	__be16		pcie0_pf_funcid_top;
+	__be16		pcie1_pf_funcid_base;
+	__be16		pcie1_pf_funcid_top;
+	u8		log_msx_atomic_size_qp;
+	u8		pcie_host;
+	u8		rsvd28;
+	u8		log_msx_atomic_size_dc;
+	u8		board_sn[XSC_BOARD_SN_LEN];
+	u8		max_tc;
+	u8		mac_bit;
+	__be16		funcid_to_logic_port;
+	u8		rsvd29[6];
+	u8		nif_port_num;
+	u8		reg_mr_via_cmdq;
+	__be32		hca_core_clock;
+	__be32		max_rwq_indirection_tables; /* rss_caps */
+	__be32		max_rwq_indirection_table_size; /* rss_caps */
+	__be32		chip_ver_h;
+	__be32		chip_ver_m;
+	__be32		chip_ver_l;
+	__be32		hotfix_num;
+	__be32		feature_flag;
+	__be32		rx_pkt_len_max;
+	__be32		glb_func_id;
+	__be64		tx_db;
+	__be64		rx_db;
+	__be64		complete_db;
+	__be64		complete_reg;
+	__be64		event_db;
+	__be32		qp_rate_limit_min;
+	__be32		qp_rate_limit_max;
+	struct xsc_fw_version	fw_ver;
+	u8		lag_logic_port_ofst;
+	u8		rsvd32[7];
+	/* V1 */
+	__be64		max_mr_size;
+	__be16		max_cmd_in_len;
+	__be16		max_cmd_out_len;
+	/* V2 */
+	__be32		max_qp;
+	__be32		max_cq;
+	__be32		max_pd;
+	__be32		max_mtt;
+	/* V3 */
+	__be32		mpt_tbl_addr;
+	__be32		mpt_tbl_depth;
+	__be32		mpt_tbl_width;
+	__be32		mtt_inst_base_addr;
+	__be32		mtt_inst_stride;
+	__be32		mtt_inst_num_log;
+	__be32		mtt_inst_depth;
+	/* V4 */
+	__be16		vf_funcid_base[XSC_MAX_NUM_PCIE_INTF][XSC_MAX_PF_NUM_PER_PCIE];
+	__be16		vf_funcid_top[XSC_MAX_NUM_PCIE_INTF][XSC_MAX_PF_NUM_PER_PCIE];
+	__be16		pf_funcid_base[XSC_MAX_NUM_PCIE_INTF];
+	__be16		pf_funcid_top[XSC_MAX_NUM_PCIE_INTF];
+	u8		pcie_no;
+	u8		pf_id;
+	__be16		vf_id;
+	u8		pcie_host_num;
+	u8		pf_num_per_pcie;
+	/* V6 */
+	__be16		ft_support;
+	/* V7 */
+	__be16		total_dynamic_vf_msix;
+	__be16		min_dynamic_vf_msix;
+	__be16		max_dynamic_vf_msix;
+	/* V8 */
+	u8		max_sgl_rd;
+	u8		rsvd30;
+	/* V9 */
+	__be32		mdb_num;
+	u8		rsvd31[4];
+	__be64		mdb_base;
+};
+
+struct xsc_cmd_query_hca_cap_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be16			cpu_num;
+	u8			rsvd[6];
+};
+
+struct xsc_cmd_query_hca_cap_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd0[8];
+	struct xsc_hca_cap	hca_cap;
+};
+
+struct xsc_query_vport_state_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			admin_state:4;
+	u8			state:4;
+};
+
+struct xsc_query_vport_state_in {
+	struct xsc_inbox_hdr	hdr;
+	__be32			data0;
+#define XSC_QUERY_VPORT_OTHER_VPORT	BIT(0)
+#define XSC_QUERY_VPORT_VPORT_NUM_MASK	GENMASK(16, 1)
+};
+
+enum {
+	XSC_CMD_EVENT_RESP_CHANGE_LINK		= BIT(0),
+	XSC_CMD_EVENT_RESP_TEMP_WARN		= BIT(1),
+	XSC_CMD_EVENT_RESP_OVER_TEMP_PROTECTION	= BIT(2),
+};
+
+struct xsc_event_resp {
+	u8			resp_cmd_type;
+};
+
+struct xsc_event_query_type_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			rsvd[2];
+};
+
+struct xsc_event_query_type_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	struct xsc_event_resp	ctx;
+};
+
+struct xsc_modify_raw_qp_request {
+	__be16		qpn;
+	__be16		lag_id;
+	__be16		func_id;
+	u8		dma_direct;
+	u8		prio;
+	u8		qp_out_port;
+	u8		rsvd[7];
+};
+
+struct xsc_modify_raw_qp_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			pcie_no;
+	u8			rsvd[7];
+	struct xsc_modify_raw_qp_request	req;
+};
+
+struct xsc_modify_raw_qp_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_set_mtu_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be16			mtu;
+	__be16			rx_buf_sz_min;
+	u8			mac_port;
+	u8			rsvd;
+};
+
+struct xsc_set_mtu_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+};
+
+struct xsc_query_eth_mac_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			index;
+};
+
+struct xsc_query_eth_mac_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			mac[ETH_ALEN];
+};
+
+enum {
+	XSC_TBM_CAP_HASH_PPH = 0,
+	XSC_TBM_CAP_RSS,
+	XSC_TBM_CAP_PP_BYPASS,
+	XSC_TBM_CAP_PCT_DROP_CONFIG,
+};
+
+struct xsc_nic_attr {
+	__be16	caps;
+	__be16	caps_mask;
+	u8	mac_addr[ETH_ALEN];
+};
+
+struct xsc_rss_attr {
+	u8	rss_en;
+	u8	hfunc;
+	__be16	rqn_base;
+	__be16	rqn_num;
+	u8	rsvd[2];
+	__be32	hash_tmpl;
+};
+
+struct xsc_cmd_enable_nic_hca_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_nic_attr	nic;
+	struct xsc_rss_attr	rss;
+};
+
+struct xsc_cmd_enable_nic_hca_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd0[2];
+};
+
+struct xsc_nic_dis_attr {
+	__be16	caps;
+};
+
+struct xsc_cmd_disable_nic_hca_mbox_in {
+	struct xsc_inbox_hdr		hdr;
+	struct xsc_nic_dis_attr		nic;
+};
+
+struct xsc_cmd_disable_nic_hca_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd0[4];
+};
+
+struct xsc_function_reset_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be16			glb_func_id;
+	u8			rsvd[6];
+};
+
+struct xsc_function_reset_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_cmd_query_guid_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_cmd_query_guid_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be64			guid;
+};
+
+struct xsc_cmd_activate_hw_config_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_cmd_activate_hw_config_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	u8			rsvd[8];
+};
+
+struct xsc_event_linkinfo {
+	u8 linkstatus; /*0:down, 1:up*/
+	u8 port;
+	u8 duplex;
+	u8 autoneg;
+	__be32 linkspeed;
+	__be64 supported;
+	__be64 advertising;
+	__be64 supported_fec;	/* reserved, not support currently */
+	__be64 advertised_fec;	/* reserved, not support currently */
+	__be64 supported_speed[2];
+	__be64 advertising_speed[2];
+};
+
+struct xsc_event_query_linkinfo_mbox_out {
+	struct xsc_outbox_hdr		hdr;
+	struct xsc_event_linkinfo	ctx;
+};
+
+struct xsc_event_set_port_admin_status_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	__be16			status;
+};
+
+struct xsc_event_set_port_admin_status_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			status;
+};
+
+/* HW stats mbox */
+struct xsc_hw_stats_rdma_pf {
+	/*by mac port*/
+__be64 rdma_tx_pkts;
+__be64 rdma_tx_bytes;
+__be64 rdma_rx_pkts;
+__be64 rdma_rx_bytes;
+__be64 np_cnp_sent;
+__be64 rp_cnp_handled;
+__be64 np_ecn_marked_roce_packets;
+__be64 rp_cnp_ignored;
+__be64 read_rsp_out_of_seq;
+__be64 implied_nak_seq_err;
+	/*by function*/
+__be64 out_of_sequence;
+__be64 packet_seq_err;
+__be64 out_of_buffer;
+__be64 rnr_nak_retry_err;
+__be64 local_ack_timeout_err;
+__be64 rx_read_requests;
+__be64 rx_write_requests;
+__be64 duplicate_requests;
+__be64 rdma_tx_pkts_func;
+__be64 rdma_tx_payload_bytes;
+__be64 rdma_rx_pkts_func;
+__be64 rdma_rx_payload_bytes;
+	/*global*/
+__be64 rdma_loopback_pkts;
+__be64 rdma_loopback_bytes;
+	/*for diamond*/
+__be64 out_of_sequence_sr;
+__be64 packet_seq_err_sr;
+__be64 rdma_ndp_rx_pkts;
+__be64 rdma_ndp_rx_trimmed_pkts;
+__be64 rdma_ndp_trimmed_pkts_sr;
+__be64 rx_icrc_encapsulated;
+};
+
+struct xsc_hw_stats_rdma_vf {
+	/*by function*/
+__be64 rdma_tx_pkts_func;
+__be64 rdma_tx_payload_bytes;
+__be64 rdma_rx_pkts_func;
+__be64 rdma_rx_payload_bytes;
+
+__be64 out_of_sequence;
+__be64 packet_seq_err;
+__be64 out_of_buffer;
+__be64 rnr_nak_retry_err;
+__be64 local_ack_timeout_err;
+__be64 rx_read_requests;
+__be64 rx_write_requests;
+__be64 duplicate_requests;
+};
+
+struct xsc_hw_stats_rdma {
+	u8 is_pf;
+	u8 rsv;
+	__be16 ver;
+	union {
+		struct xsc_hw_stats_rdma_pf pf_stats;
+		struct xsc_hw_stats_rdma_vf vf_stats;
+	} stats;
+};
+
+#define XSC_CMD_QUERY_HW_STATS_V1 1
+struct xsc_hw_stats_mbox_in {
+	struct xsc_inbox_hdr hdr;
+	u8 mac_port;
+	u8 is_lag;
+	u8 lag_member_num;
+	u8 member_port[];
+};
+
+struct xsc_hw_stats_rdma_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	struct xsc_hw_stats_rdma	hw_stats;
+};
+
+struct xsc_hw_global_stats_rdma {
+	/*by global*/
+__be64 rdma_loopback_pkts;
+__be64 rdma_loopback_bytes;
+__be64 rx_icrc_encapsulated;
+__be64 req_cqe_error;
+__be64 resp_cqe_error;
+__be64 cqe_msg_code_error;
+};
+
+struct xsc_hw_global_stats_mbox_in {
+	struct xsc_inbox_hdr hdr;
+	u8 rsv[4];
+};
+
+struct xsc_hw_global_stats_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	struct xsc_hw_global_stats_rdma	hw_stats;
+};
+
+#endif /* __XSC_CMD_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd_api.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd_api.h
new file mode 100644
index 000000000..2ea02dca2
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd_api.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CMD_API_H
+#define __XSC_CMD_API_H
+
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+
+int xsc_cmd_init(struct xsc_core_device *xdev);
+void xsc_cmd_cleanup(struct xsc_core_device *xdev);
+void xsc_cmd_use_events(struct xsc_core_device *xdev);
+void xsc_cmd_use_polling(struct xsc_core_device *xdev);
+int xsc_cmd_err_handler(struct xsc_core_device *xdev);
+void xsc_cmd_resp_handler(struct xsc_core_device *xdev);
+int xsc_cmd_exec(struct xsc_core_device *xdev,
+		 void *in, unsigned int in_size,
+		 void *out, unsigned int out_size);
+int xsc_cmd_version_check(struct xsc_core_device *xdev);
+
+int xsc_cmd_status_to_err(struct xsc_outbox_hdr *hdr);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
new file mode 100644
index 000000000..c163bd179
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
@@ -0,0 +1,191 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CMDQ_H
+#define __XSC_CMDQ_H
+
+#include <linux/if_ether.h>
+#include <linux/semaphore.h>
+
+#include "common/xsc_cmd.h"
+
+#define XSC_CMD_MAX_RETRY_CNT	3
+
+enum {
+	XSC_CMD_TIMEOUT_MSEC	= 10 * 1000,
+	XSC_CMD_WQ_MAX_NAME	= 32,
+};
+
+enum {
+	XSC_CMD_DATA, /* print command payload only */
+	XSC_CMD_TIME, /* print command execution time */
+};
+
+enum {
+	XSC_MAX_COMMANDS		= 32,
+	XSC_CMD_DATA_BLOCK_SIZE	= 512,
+	XSC_PCI_CMD_XPORT		= 7,
+};
+
+struct xsc_cmd_prot_block {
+	u8		data[XSC_CMD_DATA_BLOCK_SIZE];
+	u8		rsvd0[48];
+	__be64		next;
+	__be32		block_num;
+	/* init to 0, dma user should change this val to 1 */
+	u8		owner_status;
+	u8		token;
+	u8		ctrl_sig;
+	u8		sig;
+};
+
+struct cache_ent {
+	/* protect block chain allocations */
+	spinlock_t		lock;
+	struct list_head	head;
+};
+
+struct cmd_msg_cache {
+	struct cache_ent	large;
+	struct cache_ent	med;
+
+};
+
+#define XSC_CMD_FIRST_SIZE 8
+struct xsc_cmd_first {
+	__be32		data[XSC_CMD_FIRST_SIZE];
+};
+
+struct xsc_cmd_mailbox {
+	void			*buf;
+	dma_addr_t		dma;
+	struct xsc_cmd_mailbox *next;
+};
+
+struct xsc_cmd_msg {
+	struct list_head	list;
+	struct cache_ent	*cache;
+	u32			len;
+	struct xsc_cmd_first	first;
+	struct xsc_cmd_mailbox	*next;
+};
+
+#define XSC_RSP_FIRST_SIZE 14
+struct xsc_rsp_first {
+	/* can be larger, xsc_rsp_layout */
+	__be32		data[XSC_RSP_FIRST_SIZE];
+};
+
+struct xsc_rsp_msg {
+	struct list_head		list;
+	struct cache_ent		*cache;
+	u32				len;
+	struct xsc_rsp_first		first;
+	struct xsc_cmd_mailbox		*next;
+};
+
+typedef void (*xsc_cmd_cbk_t)(int status, void *context);
+
+/* hw will use this for some records(e.g. vf_id) */
+struct cmdq_rsv {
+	u16	vf_id;
+	u8	rsv[2];
+};
+
+/* related with hw, won't change */
+
+struct xsc_cmd_layout {
+	struct cmdq_rsv	rsv0;
+	__be32		inlen;
+	__be64		in_ptr;
+	__be32		in[XSC_CMD_FIRST_SIZE];
+	__be64		out_ptr;
+	__be32		outlen;
+	u8		token;
+	u8		sig;
+	u8		idx;
+	u8		type_owner;
+};
+
+struct xsc_rsp_layout {
+	struct cmdq_rsv	rsv0;
+	__be32		out[XSC_RSP_FIRST_SIZE];
+	u8		token;
+	u8		sig;
+	u8		idx;
+	u8		type_owner;
+};
+#define XSC_CMD_TYPE_MASK		GENMASK(6, 0)
+#define XSC_CMD_OWNER_BIT		BIT(7)
+
+struct xsc_cmd_work_ent {
+	struct xsc_cmd_msg	*in;
+	struct xsc_rsp_msg	*out;
+	int			idx;
+	struct completion	done;
+	struct xsc_cmd		*cmd;
+	struct work_struct	work;
+	struct xsc_cmd_layout	*lay;
+	struct xsc_rsp_layout	*rsp_lay;
+	int			ret;
+	u8			status;
+	u8			token;
+};
+
+enum xsc_cmd_status {
+	XSC_CMD_STATUS_NORMAL,
+	XSC_CMD_STATUS_TIMEDOUT,
+};
+
+enum xsc_cmd_mode {
+	XSC_CMD_MODE_POLLING,
+	XSC_CMD_MODE_EVENTS,
+};
+
+struct xsc_cmd {
+	void			*cmd_buf;
+	void			*cq_buf;
+	dma_addr_t		dma;
+	dma_addr_t		cq_dma;
+	u16			cmd_pid;
+	u16			cq_cid;
+	u8			owner_bit;
+	u8			retry_cnt;
+	u8			cmdif_rev;
+	u8			log_sz;
+	u8			log_stride;
+	int			max_reg_cmds;
+	int			events;
+	u32 __iomem		*vector;
+
+	/* protect command queue allocations */
+	spinlock_t		alloc_lock;
+	/* protect token allocations */
+	spinlock_t		token_lock;
+	/* protect cmdq req pid doorbell */
+	spinlock_t		doorbell_lock;
+	u8			token;
+	unsigned long		cmd_entry_mask;
+	char			wq_name[XSC_CMD_WQ_MAX_NAME];
+	struct workqueue_struct	*wq;
+	struct task_struct	*cq_task;
+	/* The semaphore limits the number of working commands
+	 * to max_reg_cmds. Each exec_cmd call does a down
+	 * to acquire the semaphore before execution and an up
+	 * after completion, ensuring no more than max_reg_cmds
+	 * commands run at the same time.
+	 */
+	struct semaphore	sem;
+	enum xsc_cmd_mode	mode;
+	struct xsc_cmd_work_ent	*ent_arr[XSC_MAX_COMMANDS];
+	struct dma_pool		*pool;
+	struct cmd_msg_cache	cache;
+	int			checksum_disabled;
+	unsigned int		irqn;
+	u8			ownerbit_learned;
+	u8			cmd_status;
+};
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
new file mode 100644
index 000000000..9775412d2
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -0,0 +1,662 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CORE_H
+#define __XSC_CORE_H
+
+#include <linux/pci.h>
+#include <linux/auxiliary_bus.h>
+#include <linux/bitfield.h>
+#include <linux/if_vlan.h>
+#include <linux/radix-tree.h>
+#include <linux/reboot.h>
+
+#include "common/xsc_reg.h"
+#include "common/xsc_cmdq.h"
+
+#define XSC_PCI_VENDOR_ID		0x1f67
+
+#define XSC_MC_PF_DEV_ID		0x1011
+
+#define XSC_MF_HOST_PF_DEV_ID		0x1051
+#define XSC_MF_SOC_PF_DEV_ID		0x1053
+
+#define XSC_MS_PF_DEV_ID		0x1111
+
+#define XSC_MV_HOST_PF_DEV_ID		0x1151
+#define XSC_MV_SOC_PF_DEV_ID		0x1153
+
+#define XSC_PAGE_SHIFT_4K			12
+#define XSC_PAGE_SIZE_4K			(_AC(1, UL) << XSC_PAGE_SHIFT_4K)
+
+#define XSC_ORIGIN_PF_BAR_SIZE		(256 * 1024 * 1024)
+
+enum xsc_coredev_type {
+	XSC_COREDEV_PF,
+	XSC_COREDEV_SF
+};
+
+enum {
+	XSC_MAX_EQ_NAME	= 20
+};
+
+enum {
+	XSC_MAX_IRQ_NAME	= 32
+};
+
+enum {
+	XSC_MAX_FW_PORTS	= 1,
+};
+
+enum {
+	XSC_BF_REGS_PER_PAGE	= 4,
+	XSC_MAX_UAR_PAGES	= 1 << 8,
+	XSC_MAX_UUARS		= XSC_MAX_UAR_PAGES * XSC_BF_REGS_PER_PAGE,
+};
+
+/* alloc */
+struct xsc_buf_list {
+	void			*buf;
+	dma_addr_t		map;
+};
+
+struct xsc_buf {
+	struct xsc_buf_list	direct;
+	struct xsc_buf_list	*page_list;
+	unsigned long		nbufs;
+	unsigned long		npages;
+	unsigned long		page_shift;
+	unsigned long		size;
+};
+
+struct xsc_hw_reg {
+	u32 tx_db;
+	u32 rx_db;
+	u32 complete_db;
+	u32 complete_reg;
+	u32 event_db;
+	u32 req_pid_addr;
+	u32 req_cid_addr;
+	u32 rsp_pid_addr;
+	u32 rsp_cid_addr;
+	u32 req_buf_h_addr;
+	u32 req_buf_l_addr;
+	u32 rsp_buf_h_addr;
+	u32 rsp_buf_l_addr;
+	u32 msix_vec_addr;
+	u32 interrupt_stat_addr;
+	u32 mpt_tbl_addr;
+	u32 mpt_tbl_depth;
+	u32 mpt_tbl_width;
+	u32 mtt_inst_base_addr;
+	u32 mtt_inst_stride;
+	u32 mtt_inst_num_log;
+	u32 mtt_inst_depth;
+};
+
+struct xsc_frag_buf {
+	struct xsc_buf_list	*frags;
+	unsigned long		npages;
+	unsigned long		size;
+	u8			page_shift;
+};
+
+struct xsc_frag_buf_ctrl {
+	struct xsc_buf_list	*frags;
+	u32			sz_m1;
+	u16			frag_sz_m1;
+	u16			strides_offset;
+	u8			log_sz;
+	u8			log_stride;
+	u8			log_frag_strides;
+};
+
+/* qp */
+struct xsc_send_wqe_ctrl_seg {
+	__le32		data0;
+	__le32		msg_len;
+	__le32		data2;
+	__le32		data3;
+};
+#define XSC_WQE_CTRL_SEG_DATA0_MSG_OPCODE_MASK		GENMASK(7, 0)
+#define XSC_WQE_CTRL_SEG_DATA0_WITH_IMM			BIT(8)
+#define XSC_WQE_CTRL_SEG_DATA0_CSUM_EN_MASK		GENMASK(10, 9)
+#define XSC_WQE_CTRL_SEG_DATA0_DS_DATA_NUM_MASK		GENMASK(15, 11)
+#define XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK		GENMASK(31, 16)
+#define XSC_WQE_CTRL_SEG_DATA2_HAS_PPH			BIT(0)
+#define XSC_WQE_CTRL_SEG_DATA2_SO_TYPE			BIT(1)
+#define XSC_WQE_CTRL_SEG_DATA2_SO_DATA_SIZE_MASK		GENMASK(15, 2)
+#define XSC_WQE_CTRL_SEG_DATA2_SO_HDR_LEN_MASK		GENMASK(31, 24)
+#define XSC_WQE_CTRL_SEG_DATA3_SE			BIT(0)
+#define XSC_WQE_CTRL_SEG_DATA3_CE			BIT(1)
+
+struct xsc_wqe_data_seg {
+	union {
+		struct {
+			__le32		data0;
+			__le32		mkey;
+			__le64		va;
+		};
+		struct {
+			u8		in_line_data[16];
+		};
+	};
+};
+#define XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK		GENMASK(31, 1)
+#define XSC_INVALID_LKEY				0x100
+
+struct xsc_core_qp {
+	void			(*event)(struct xsc_core_qp *qp, int type);
+	u32			qpn;
+	atomic_t		refcount;
+	struct completion	free;
+	int			pid;
+	u16			qp_type;
+	u16			eth_queue_type;
+	u16			qp_type_internal;
+	u16			grp_id;
+	u8			mac_id;
+	u8			err_occurred;
+	u32			qp_protocol_mode;
+	u32			qp_access_flags;
+};
+
+struct xsc_qp_table {
+	spinlock_t		lock; /* protect radix tree */
+	struct radix_tree_root	tree;
+};
+
+/* cq */
+#define XSC_MAX_NAME_LEN	32
+#define XSC_MAX_IBDEV_NAME_LEN	64
+
+struct xsc_priv {
+	char			name[XSC_MAX_NAME_LEN];
+	char			ibdev_name[XSC_MAX_IBDEV_NAME_LEN];
+	int			cm_pcp;
+	int			cm_dscp;
+	int			force_pcp;
+	int			force_dscp;
+};
+
+enum xsc_dev_event {
+	XSC_DEV_EVENT_SYS_ERROR,
+	XSC_DEV_EVENT_PORT_UP,
+	XSC_DEV_EVENT_PORT_DOWN,
+	XSC_DEV_EVENT_PORT_INITIALIZED,
+	XSC_DEV_EVENT_LID_CHANGE,
+	XSC_DEV_EVENT_PKEY_CHANGE,
+	XSC_DEV_EVENT_GUID_CHANGE,
+	XSC_DEV_EVENT_CLIENT_REREG,
+};
+
+enum {
+	RDMA_PROTO_ROCEV2,
+	RDMA_PROTO_VEROCE,
+};
+
+#define VEROCE_UDP_DPORT	4794
+#define MAX_MR_CACHE_ENTRIES	5000
+
+enum xsc_event {
+	XSC_EVENT_TYPE_COMP			= 0x0,
+	/* mad */
+	XSC_EVENT_TYPE_COMM_EST			= 0x02,
+	XSC_EVENT_TYPE_CQ_ERROR			= 0x04,
+	XSC_EVENT_TYPE_WQ_CATAS_ERROR		= 0x05,
+	XSC_EVENT_TYPE_INTERNAL_ERROR		= 0x08,
+	/* IBV_EVENT_QP_REQ_ERR */
+	XSC_EVENT_TYPE_WQ_INVAL_REQ_ERROR	= 0x10,
+	/* IBV_EVENT_QP_ACCESS_ERR */
+	XSC_EVENT_TYPE_WQ_ACCESS_ERROR		= 0x11,
+};
+
+struct xsc_cqe {
+	__le32		data0;
+	__le32		imm_data;
+	__le32		msg_len;
+	__le32		vni;
+	__le64		data2;
+	u8		placeholder2;
+	u8		rsv3;
+	__le16		rsv[1];
+	__le32		data1;
+};
+#define XSC_CQE_DATA0_MSG_OPCD_MASK			GENMASK(7, 0)
+#define XSC_CQE_DATA0_ERR_CODE_MASK			GENMASK(6, 0)
+#define XSC_CQE_DATA0_IS_ERR				BIT(7)
+#define XSC_CQE_DATA0_QP_ID_MASK				GENMASK(22, 8)
+#define XSC_CQE_DATA0_SE					BIT(24)
+#define XSC_CQE_DATA0_HAS_PPH				BIT(25)
+#define XSC_CQE_DATA0_TYPE				BIT(26)
+#define XSC_CQE_DATA0_WITH_IMM				BIT(27)
+#define XSC_CQE_DATA0_CSUM_ERR_MASK			GENMASK(31, 28)
+#define XSC_CQE_DATA2_TS_MASK				GENMASK_ULL(47, 0)
+#define XSC_CQE_DATA2_WQE_ID_MASK			GENMASK_ULL(63, 48)
+#define XSC_CQE_DATA1_OWNER				BIT(31)
+
+struct xsc_cqe64 {
+	struct xsc_cqe	cqe;
+	u8		padding[32];
+};
+
+struct xsc_core_cq {
+	u32			cqn;
+	u32			cqe_sz;
+	struct xsc_core_device	*xdev;
+	struct xsc_core_device	*dev;
+	atomic_t		refcount;
+	struct completion	free;
+	unsigned int		vector;
+	unsigned int		irqn;
+	void			(*comp)(struct xsc_core_cq *cq);
+	void			(*event)(struct xsc_core_cq *cq,
+					 enum xsc_event);
+	u32			cons_index;
+	unsigned int		arm_sn;
+	int			pid;
+	u32			reg_next_cid;
+	u32			reg_done_pid;
+	struct xsc_eq		*eq;
+};
+
+struct xsc_cq_table {
+	spinlock_t		lock; /* protect radix tree */
+	struct radix_tree_root	tree;
+};
+
+/* mr */
+struct xsc_core_mr {
+	u64			iova;
+	u64			size;
+	u32			key;
+	u32			pd;
+	u32			access;
+};
+
+/* eq */
+struct xsc_eq {
+	struct xsc_core_device	*dev;
+	struct xsc_cq_table	cq_table;
+	u32			cons_index;
+	struct xsc_buf		buf;
+	unsigned int		irqn;
+	u32			eqn;
+	u32			nent;
+	cpumask_var_t		mask;
+	char			name[XSC_MAX_EQ_NAME];
+	struct list_head	list;
+	u16			index;
+};
+
+struct xsc_eq_table {
+	void __iomem		*update_ci;
+	void __iomem		*update_arm_ci;
+	struct list_head	comp_eqs_list;
+	struct xsc_eq		pages_eq;
+	struct xsc_eq		async_eq;
+	struct xsc_eq		cmd_eq;
+	int			num_comp_vectors;
+	int			eq_vec_comp_base;
+	/* protect EQs list */
+	spinlock_t		lock;
+};
+
+/* irq */
+struct xsc_irq_info {
+	cpumask_var_t mask;
+	char name[XSC_MAX_IRQ_NAME];
+};
+
+/* adev */
+#define XSC_PCI_DRV_NAME "xsc_pci"
+#define XSC_ETH_ADEV_NAME "eth"
+#define XSC_IB_ADEV_NAME "ib"
+
+enum xsc_adev_idx {
+	XSC_ADEV_IDX_ETH,
+	XSC_ADEV_IDX_IB,
+	XSC_ADEV_IDX_MAX,
+};
+
+struct xsc_adev {
+	struct auxiliary_device	adev;
+	struct xsc_core_device	*xdev;
+
+	int			idx;
+};
+
+struct xsc_board_info {
+	u32			board_id;
+	char			board_sn[XSC_BOARD_SN_LEN];
+	__be64			guid;
+	u8			guid_valid;
+	u8			hw_config_activated;
+	struct xsc_msg_opcode	*msg_opcode;
+};
+
+struct xsc_caps {
+	u8		log_max_eq;
+	u8		log_max_cq;
+	u8		log_max_qp;
+	u8		log_max_mkey;
+	u8		log_max_pd;
+	u8		log_max_srq;
+	u8		log_max_msix;
+	u32		max_cq;
+	u32		max_qp;
+	u32		max_pd;
+	u32		max_cqes;
+	u32		max_wqes;
+	u32		max_sq_desc_sz;
+	u32		max_rq_desc_sz;
+	u64		flags;
+	u16		stat_rate_support;
+	u32		log_max_msg;
+	u32		num_ports;
+	u32		max_ra_res_qp;
+	u32		max_ra_req_qp;
+	u32		max_srq_wqes;
+	u32		bf_reg_size;
+	u32		bf_regs_per_page;
+	u32		reserved_lkey;
+	u8		local_ca_ack_delay;
+	u8		log_max_mcg;
+	u16		max_qp_mcg;
+	u32		min_page_sz;
+	u32		send_ds_num;
+	u32		send_wqe_shift;
+	u32		recv_ds_num;
+	u32		recv_wqe_shift;
+	u32		rx_pkt_len_max;
+
+	u32		func_caps;
+
+	u16		max_vfs;
+	u8		log_max_qp_depth;
+	u8		log_max_current_uc_list;
+	u8		log_max_current_mc_list;
+	u16		log_max_vlan_list;
+	u8		fdb_multi_path_to_table;
+	u8		log_esw_max_sched_depth;
+
+	u8		max_num_sf_partitions;
+	u8		log_max_esw_sf;
+	u16		sf_base_id;
+
+	u32		qos_caps;
+	u32		nic_caps;
+	u16		msix_base;
+	u16		msix_num;
+	u8		log_max_mtt;
+	u8		log_max_tso;
+	u32		hca_core_clock;
+	u32		max_rwq_indirection_tables; /* rss_caps */
+	u32		max_rwq_indirection_table_size; /* rss_caps */
+	u16		raweth_qp_id_end;
+	u32		qp_rate_limit_min;
+	u32		qp_rate_limit_max;
+	u32		hw_feature_flag;
+	u16		pf0_vf_funcid_base;
+	u16		pf0_vf_funcid_top;
+	u16		pf1_vf_funcid_base;
+	u16		pf1_vf_funcid_top;
+	u16		pcie0_pf_funcid_base;
+	u16		pcie0_pf_funcid_top;
+	u16		pcie1_pf_funcid_base;
+	u16		pcie1_pf_funcid_top;
+	u8		nif_port_num;
+	u8		pcie_host;
+	u8		mac_bit;
+	u16		funcid_to_logic_port;
+	u8		lag_logic_port_ofst;
+
+	/* RDMA / MR resources (populated from hca_cap V1~V9) */
+	u64		max_mr_size;
+	u16		max_cmd_in_len;
+	u16		max_cmd_out_len;
+	u32		max_mtt;
+	u32		mpt_tbl_addr;
+	u32		mpt_tbl_depth;
+	u32		mpt_tbl_width;
+	u32		mtt_inst_base_addr;
+	u32		mtt_inst_stride;
+	u32		mtt_inst_num_log;
+	u32		mtt_inst_depth;
+};
+#define XSC_CAP_PORT_TYPE			BIT(1)
+#define XSC_CAP_EMBEDDED_CPU			BIT(2)
+#define XSC_CAP_ESWITCH_MANAGER			BIT(3)
+#define XSC_CAP_ECPF_VPORT_EXISTS		BIT(4)
+#define XSC_CAP_VPORT_GROUP_MANAGER		BIT(5)
+#define XSC_CAP_SF				BIT(6)
+#define XSC_CAP_WQE_INLINE_MODE_MASK		GENMASK(9, 7)
+#define XSC_CAP_RAWETH_QP_ID_BASE_MASK		GENMASK(24, 10)
+#define XSC_CAP_MAX_TC_MASK			GENMASK(7, 0)
+#define XSC_CAP_ETS				BIT(8)
+#define XSC_CAP_DCBX				BIT(9)
+#define XSC_CAP_DSCP				BIT(10)
+#define XSC_CAP_SBCAM_REG			BIT(11)
+#define XSC_CAP_QOS				BIT(12)
+#define XSC_CAP_PORT_BUF			BIT(13)
+#define XSC_CAP_RAW_TPE_QP_NUM_MASK		GENMASK(31, 16)
+#define XSC_CAP_MAX_NUM_EQS_MASK		GENMASK(7, 0)
+#define XSC_CAP_MAC_PORT_MASK			GENMASK(15, 8)
+#define XSC_CAP_RAWETH_RSS_QP_ID_BASE_MASK	GENMASK(31, 16)
+
+struct xsc_srq_cache_wr;
+
+/* xsc_core */
+struct xsc_dev_resource {
+	struct xsc_qp_table	qp_table;
+	struct xsc_cq_table	cq_table;
+	struct xsc_eq_table	eq_table;
+	struct xsc_irq_info	*irq_info;
+	/* protect buffer allocation according to numa node */
+	struct mutex		alloc_mutex;
+	/* protect mkey key allocation */
+	spinlock_t		mkey_lock;
+	u8			mkey_key;
+
+	/* srq number allocation, srqn is a software index only */
+	spinlock_t		srq_lock;
+	unsigned long		*srq_tbl;
+	struct xsc_srq_cache_wr	*srq_cache_wr;
+	u32			max_srq_num;
+};
+
+struct xsc_core_device {
+	struct pci_dev		*pdev;
+	struct device		*device;
+	int			adev_id;
+	struct xsc_adev		**xsc_adev_list;
+	void			*eth_priv;
+	struct xsc_dev_resource	*dev_res;
+	int			numa_node;
+
+	/* async event plumbing, owned by the PCI layer */
+	struct work_struct	event_work;
+	struct workqueue_struct	*event_wq;
+	void (*link_event_handler)(void *xdev);
+
+	void __iomem		*bar;
+	int			bar_num;
+	enum xsc_coredev_type	coredev_type;
+	struct xsc_hw_reg	hal_regs;
+
+	u8			mac_port;
+	u8			pcie_no;
+	u8			pf_id;
+	u16			glb_func_id;
+	u16			gsi_qpn;
+	atomic_t		num_qps;
+
+	u16			msix_vec_base;
+
+	void			*netdev;
+
+	u32			rdma_proto_mode;
+	u16			cm_udp_dst_port;
+	u16			veroce_udp_dst_port;
+	u8			read_flush;
+	u8			bql_thresh;
+
+	struct xsc_priv		priv;
+
+	struct xsc_cmd		cmd;
+	u16			cmdq_ver;
+
+	struct xsc_caps		caps;
+	struct xsc_board_info	*board_info;
+
+	u32			chip_ver_h;
+	u32			chip_ver_m;
+	u32			chip_ver_l;
+	u32			hotfix_num;
+	u32			feature_flag;
+
+	u8			fw_version_major;
+	u8			fw_version_minor;
+	u16			fw_version_patch;
+	u32			fw_version_tweak;
+	u8			fw_version_extra_flag;
+	cpumask_var_t		xps_cpumask;
+};
+
+int xsc_core_create_resource_common(struct xsc_core_device *xdev,
+				    struct xsc_core_qp *qp);
+void xsc_core_destroy_resource_common(struct xsc_core_device *xdev,
+				      struct xsc_core_qp *qp);
+int xsc_core_eth_create_qp(struct xsc_core_device *xdev,
+			   struct xsc_create_qp_mbox_in *in,
+			   int insize, u32 *p_qpn);
+int xsc_core_eth_modify_qp_status(struct xsc_core_device *xdev,
+				  u32 qpn, u16 status);
+int xsc_core_eth_destroy_qp(struct xsc_core_device *xdev, u32 qpn);
+int xsc_core_eth_create_rss_qp_rqs(struct xsc_core_device *xdev,
+				   struct xsc_create_multiqp_mbox_in *in,
+				   int insize,
+				   u32 *p_qpn_base);
+int xsc_core_eth_modify_raw_qp(struct xsc_core_device *xdev,
+			       struct xsc_modify_raw_qp_mbox_in *in);
+int xsc_core_eth_create_cq(struct xsc_core_device *xdev,
+			   struct xsc_core_cq *xcq,
+			   struct xsc_create_cq_mbox_in *in,
+			   int insize);
+int xsc_core_eth_destroy_cq(struct xsc_core_device *xdev,
+			    struct xsc_core_cq *xcq);
+
+struct xsc_eq *xsc_core_eq_get(struct xsc_core_device *xdev, int i);
+int xsc_core_vector2eqn(struct xsc_core_device *xdev, int vector, u32 *eqn,
+			unsigned int *irqn);
+
+/*
+ * Link event callback registration. The events are dispatched from the PCI
+ * layer's own workqueue; unregister detaches the callback and waits for one
+ * already in flight, so it must precede freeing what the handler touches.
+ */
+void xsc_irq_event_register(struct xsc_core_device *xdev,
+			    void (*handler)(void *xdev));
+void xsc_irq_event_unregister(struct xsc_core_device *xdev);
+void xsc_core_fill_page_frag_array(struct xsc_frag_buf *buf,
+				   __be64 *pas, unsigned int npages);
+int xsc_core_frag_buf_alloc_node(struct xsc_core_device *xdev,
+				 unsigned long size,
+				 struct xsc_frag_buf *buf,
+				 int node);
+void xsc_core_frag_buf_free(struct xsc_core_device *xdev,
+			    struct xsc_frag_buf *buf);
+
+u8 xsc_core_query_vport_state(struct xsc_core_device *xdev, u16 vport);
+
+static inline void *xsc_buf_offset(struct xsc_buf *buf, unsigned long offset)
+{
+	if (likely(buf->nbufs == 1))
+		return buf->direct.buf + offset;
+	else
+		return buf->page_list[offset >> PAGE_SHIFT].buf +
+			(offset & (PAGE_SIZE - 1));
+}
+
+static inline u8 get_cqe_opcode(struct xsc_cqe *cqe)
+{
+	return FIELD_GET(XSC_CQE_DATA0_MSG_OPCD_MASK, le32_to_cpu(cqe->data0));
+}
+
+static inline bool xsc_core_is_pf(const struct xsc_core_device *dev)
+{
+	return dev->coredev_type == XSC_COREDEV_PF;
+}
+
+static inline bool is_support_hw_pf_stats(struct xsc_core_device *dev)
+{
+	return xsc_core_is_pf(dev);
+}
+
+static inline bool is_support_cqe64(struct xsc_core_device *dev)
+{
+	return dev->caps.hw_feature_flag & XSC_HW_CQE64_SUPPORT;
+}
+
+static inline bool is_support_rdma_cm(struct xsc_core_device *dev)
+{
+	return dev->caps.hw_feature_flag & XSC_HW_RDMA_CM_SUPPORT;
+}
+
+static inline bool is_support_rdma_atomic(struct xsc_core_device *dev)
+{
+	return dev->caps.hw_feature_flag & XSC_HW_RDMA_ATOMIC_SUPPORT;
+}
+
+static inline bool is_support_rdma(struct xsc_core_device *dev)
+{
+	return dev->caps.hw_feature_flag & XSC_HW_RDMA_SUPPORT;
+}
+
+static inline bool is_support_8k_mtu(struct xsc_core_device *dev)
+{
+	return dev->caps.hw_feature_flag & XSC_HW_MTU_8192_SUPPORT;
+}
+
+static inline bool is_pf_bar_compressed(struct xsc_core_device *dev)
+{
+	return pci_resource_len(dev->pdev, 0) != XSC_ORIGIN_PF_BAR_SIZE;
+}
+
+static inline bool is_support_multi_doorbell(struct xsc_core_device *dev)
+{
+	return dev->caps.hw_feature_flag & XSC_HW_MULTIDOORBELL_SUPPORT;
+}
+
+void xsc_remove_rdma_driver(void);
+
+void xsc_init_hal(struct xsc_core_device *xdev);
+
+u8 xsc_get_mr_page_mode(struct xsc_core_device *xdev, u8 page_shift);
+u64 xsc_get_max_mr_size(struct xsc_core_device *xdev);
+void xsc_set_data_seg(struct xsc_core_device *xdev, void *data_seg, u64 addr,
+		      u32 key, u32 length);
+u64 xsc_get_rdma_stat_mask(struct xsc_core_device *xdev, u16 ver);
+u32 xsc_get_max_qp_depth(struct xsc_core_device *xdev);
+bool xsc_check_max_qp_depth(struct xsc_core_device *xdev, u32 *wqe_cnt,
+			    u32 max_qp_depth);
+void xsc_set_wqe_id(struct xsc_core_device *xdev, void *cseg, u32 wqe_id);
+int xsc_get_cqe_wqe_id(struct xsc_core_device *xdev, void *cqe);
+void xsc_get_multidb_info(struct xsc_core_device *xdev, u32 *num, u32 *base);
+u8 xsc_get_cqe_opcode(struct xsc_core_device *xdev, void *cqe);
+u32 xsc_get_recv_ds_num(struct xsc_core_device *xdev);
+int xsc_get_link_speed(struct xsc_core_device *xdev);
+void xsc_set_mtt_info(struct xsc_core_device *xdev);
+void xsc_set_pf_db_addr(struct xsc_core_device *xdev,
+			u64 tx_db, u64 rx_db, u64 cq_db, u64 cq_reg, u64 eq_db);
+void xsc_get_db_addr(struct xsc_core_device *xdev,
+		     u64 *tx_db, u64 *rx_db, u64 *cq_db, u64 *cq_reg, u64 *eq_db);
+
+void xsc_update_tx_db(struct xsc_core_device *xdev, u32 sqn, u32 next_pid);
+void xsc_update_rx_db(struct xsc_core_device *xdev, u32 rqn, u32 next_pid);
+void xsc_arm_cq(struct xsc_core_device *xdev, u32 cqn, u32 next_cid, u8 solicited);
+void xsc_update_cq_ci(struct xsc_core_device *xdev, u32 cqn, u32 next_cid);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_device.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_device.h
new file mode 100644
index 000000000..302534839
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_device.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_DEVICE_H
+#define __XSC_DEVICE_H
+
+#include <linux/types.h>
+
+/* QP type */
+enum {
+	XSC_QUEUE_TYPE_RDMA_RC		= 0,
+	XSC_QUEUE_TYPE_RDMA_MAD		= 1,
+	XSC_QUEUE_TYPE_RAW		= 2,
+	XSC_QUEUE_TYPE_VIRTIO_NET	= 3,
+	XSC_QUEUE_TYPE_VIRTIO_BLK	= 4,
+	XSC_QUEUE_TYPE_RAW_TPE		= 5,
+	XSC_QUEUE_TYPE_RAW_TSO		= 6,
+	XSC_QUEUE_TYPE_RAW_TX		= 7,
+	XSC_QUEUE_TYPE_SNIFFER		= 8,
+	XSC_QUEUE_TYPE_WORC		= 9,
+	XSC_QUEUE_TYPE_INVALID		= 0xFF,
+};
+
+enum {
+	XSC_PERM_LOCAL_READ	= 1 << 0,
+	XSC_PERM_LOCAL_WRITE	= 1 << 1,
+	XSC_PERM_REMOTE_READ	= 1 << 2,
+	XSC_PERM_REMOTE_WRITE	= 1 << 3,
+	XSC_PERM_ATOMIC		= 1 << 4,
+	XSC_PERM_UMR_EN		= 1 << 7,
+};
+
+enum {
+	XSC_DEV_CAP_FLAG_RC		= 1LL <<  0,
+	XSC_DEV_CAP_FLAG_UC		= 1LL <<  1,
+	XSC_DEV_CAP_FLAG_UD		= 1LL <<  2,
+	XSC_DEV_CAP_FLAG_XRC		= 1LL <<  3,
+	XSC_DEV_CAP_FLAG_SRQ		= 1LL <<  6,
+	XSC_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1LL <<  8,
+	XSC_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1LL <<  9,
+	XSC_DEV_CAP_FLAG_APM		= 1LL << 17,
+	XSC_DEV_CAP_FLAG_ATOMIC		= 1LL << 18,
+	XSC_DEV_CAP_FLAG_ON_DMND_PG	= 1LL << 24,
+	XSC_DEV_CAP_FLAG_RESIZE_SRQ	= 1LL << 32,
+	XSC_DEV_CAP_FLAG_REMOTE_FENCE	= 1LL << 38,
+	XSC_DEV_CAP_FLAG_TLP_HINTS	= 1LL << 39,
+	XSC_DEV_CAP_FLAG_SIG_HAND_OVER	= 1LL << 40,
+	XSC_DEV_CAP_FLAG_DCT		= 1LL << 41,
+	XSC_DEV_CAP_FLAG_CMDIF_CSUM	= 1LL << 46,
+};
+
+enum xsc_traffic_types {
+	XSC_TT_IPV4,
+	XSC_TT_IPV4_TCP,
+	XSC_TT_IPV4_UDP,
+	XSC_TT_IPV6,
+	XSC_TT_IPV6_TCP,
+	XSC_TT_IPV6_UDP,
+	XSC_TT_IPV4_IPSEC_AH,
+	XSC_TT_IPV6_IPSEC_AH,
+	XSC_TT_IPV4_IPSEC_ESP,
+	XSC_TT_IPV6_IPSEC_ESP,
+	XSC_TT_ANY,
+	XSC_NUM_TT,
+};
+
+#define XSC_NUM_INDIR_TIRS XSC_NUM_TT
+
+enum {
+	XSC_L3_PROT_TYPE_IPV4	= BIT(0),
+	XSC_L3_PROT_TYPE_IPV6	= BIT(1),
+};
+
+enum {
+	XSC_L4_PROT_TYPE_TCP	= BIT(0),
+	XSC_L4_PROT_TYPE_UDP	= BIT(1),
+};
+
+struct xsc_tirc_config {
+	u8 l3_prot_type;
+	u8 l4_prot_type;
+	u32 rx_hash_fields;
+};
+
+enum {
+	XSC_HASH_FUNC_XOR		= 0,
+	XSC_HASH_FUNC_TOP		= 1,
+	XSC_HASH_FUNC_TOP_SYM	= 2,
+	XSC_HASH_FUNC_RSV		= 3,
+};
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_hsi.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_hsi.h
new file mode 100644
index 000000000..aa2049f89
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_hsi.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_HSI_H
+#define XSC_HSI_H
+
+#include <asm/byteorder.h>
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+
+#define WR_LE_32(x, val)	(x = __cpu_to_le32(val))
+#define WR_LE_64(x, val)	(x = __cpu_to_le64(val))
+
+#define WR_BE_32(x, val)	(x = __cpu_to_be32(val))
+
+#define RD_LE_32(x)		__le32_to_cpu(x)
+#define RD_BE_32(x)		__be32_to_cpu(x)
+
+struct xsc_msg_opcode {
+	u32	send;
+	u32	send_with_imm;
+	u32	rdma_write;
+	u32	rdma_write_with_imm;
+	u32	rdma_read;
+	u32	atomic_cmp_and_swp;
+	u32	atomic_fetch_and_add;
+	u32	masked_atomic_cmp_and_swp;
+	u32	masked_atomic_fetch_and_add;
+	u32	mad;
+};
+
+/* sw cqe opcode */
+enum {
+	XSC_OPCODE_RDMA_REQ_SEND	= 0,
+	XSC_OPCODE_RDMA_REQ_SEND_IMMDT	= 1,
+	XSC_OPCODE_RDMA_RSP_RECV	= 2,
+	XSC_OPCODE_RDMA_RSP_RECV_IMMDT	= 3,
+	XSC_OPCODE_RDMA_REQ_WRITE	= 4,
+	XSC_OPCODE_RDMA_REQ_WRITE_IMMDT	= 5,
+	XSC_OPCODE_RDMA_RSP_WRITE_IMMDT	= 6,
+	XSC_OPCODE_RDMA_REQ_READ	= 7,
+	XSC_OPCODE_RDMA_REQ_ERROR	= 8,
+	XSC_OPCODE_RDMA_RSP_ERROR	= 9,
+	XSC_OPCODE_RDMA_CQE_ERROR	= 10,
+	XSC_OPCODE_RDMA_MAD_REQ_SEND    = 11,
+	XSC_OPCODE_RDMA_MAD_RSP_RECV    = 12,
+	XSC_OPCODE_RDMA_CQE_RAW_SNF     = 13,
+};
+
+enum {
+	XSC_SEND_SEG_MAX		= 32,
+	XSC_BASE_WQE_SHIFT		= 4,
+	XSC_SEND_SEG_NUM		= 4,
+	XSC_SEND_WQE_SHIFT		= 6,
+	XSC_CTRL_SEG_NUM		= 1,
+	XSC_RADDR_SEG_NUM		= 1,
+};
+
+enum {
+	XSC_RECV_SEG_MAX		= 4,
+	XSC_RECV_SEG_NUM		= 1,
+	XSC_RECV_WQE_SHIFT		= 4,
+};
+
+enum {
+	XSC_INLINE_SIZE_MAX		= 15,
+};
+
+#define XSC_MPT_MAP_EN		0
+
+enum {
+	XSC_REQ		= 0,
+	XSC_RSP		= 1,
+};
+
+enum {
+	XSC_WITHOUT_IMMDT	= 0,
+	XSC_WITH_IMMDT		= 1,
+};
+
+/* CQE error codes */
+enum {
+	XSC_ERR_CODE_NAK_RETRY			= 0x40,
+	XSC_ERR_CODE_NAK_OPCODE			= 0x41,
+	XSC_ERR_CODE_NAK_MR			= 0x42,
+	XSC_ERR_CODE_NAK_OPERATION		= 0x43,
+	XSC_ERR_CODE_NAK_RNR			= 0x44,
+	XSC_ERR_CODE_LOCAL_MR			= 0x45,
+	XSC_ERR_CODE_LOCAL_LEN			= 0x46,
+	XSC_ERR_CODE_LOCAL_OPCODE		= 0x47,
+	XSC_ERR_CODE_CQ_OVER_FLOW		= 0x48,
+	XSC_ERR_CODE_STRG_ACC_GEN_CQE		= 0x4c,
+	XSC_ERR_CODE_CQE_ACC			= 0x4d,
+	XSC_ERR_CODE_FLUSH			= 0x4e,
+	XSC_ERR_CODE_MALF_WQE_HOST		= 0x50,
+	XSC_ERR_CODE_MALF_WQE_INFO		= 0x51,
+	XSC_ERR_CODE_MR_NON_NAK			= 0x52,
+	XSC_ERR_CODE_OPCODE_GEN_CQE		= 0x61,
+	XSC_ERR_CODE_MANY_READ			= 0x62,
+	XSC_ERR_CODE_LEN_GEN_CQE		= 0x63,
+	XSC_ERR_CODE_MR				= 0x65,
+	XSC_ERR_CODE_MR_GEN_CQE			= 0x66,
+	XSC_ERR_CODE_OPERATION			= 0x67,
+	XSC_ERR_CODE_MALF_WQE_INFO_GEN_NAK	= 0x68,
+};
+
+enum xsc_qp_state {
+	XSC_QP_STATE_RST		= 0,
+	XSC_QP_STATE_INIT		= 1,
+	XSC_QP_STATE_RTR		= 2,
+	XSC_QP_STATE_RTS		= 3,
+	XSC_QP_STATE_SQER		= 4,
+	XSC_QP_STATE_SQD		= 5,
+	XSC_QP_STATE_ERR		= 6,
+	XSC_QP_STATE_SQ_DRAINING	= 7,
+	XSC_QP_STATE_SUSPENDED		= 9,
+	XSC_QP_NUM_STATE
+};
+
+#endif /* XSC_HSI_H */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
new file mode 100644
index 000000000..52747bb29
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_reg.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_REG_H
+#define XSC_REG_H
+#define CMDQM_HOST_REQ_BUF_BASE_H_ADDR_MEM_ADDR 0x0
+#define CMDQM_HOST_REQ_BUF_BASE_L_ADDR_MEM_ADDR 0x4
+#define CMDQM_HOST_REQ_PID_MEM_ADDR 0x8
+#define CMDQM_HOST_REQ_CID_MEM_ADDR 0xc
+#define CMDQM_HOST_RSP_BUF_BASE_H_ADDR_MEM_ADDR 0x10
+#define CMDQM_HOST_RSP_BUF_BASE_L_ADDR_MEM_ADDR 0x14
+#define CMDQM_HOST_RSP_PID_MEM_ADDR 0x18
+#define CMDQM_HOST_RSP_CID_MEM_ADDR 0x1c
+#define CMDQM_HOST_VF_ERR_STS_MEM_ADDR 0x20
+#define CMDQM_VECTOR_ID_MEM_ADDR 0x24
+
+#define DB_CQ_FUNC_MEM_ADDR 0x8c4
+#define DB_EQ_FUNC_MEM_ADDR 0x8c8
+#define DB_CQ_CID_DIRECT_MEM_ADDR 0x8cc
+#define TX_DB_FUNC_MEM_ADDR 0x8d0
+#define RX_DB_FUNC_MEM_ADDR 0x8d4
+
+#define XSC_MDB_NUM	64
+#define QPM_TX_MDB_BASE_REG_ADDR 0xd00
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig b/drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
new file mode 100644
index 000000000..1cc3f7b49
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Kconfig
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+# Yunsilicon PCI configuration
+#
+
+config YUNSILICON_XSC_PCI
+	tristate "Yunsilicon XSC PCI driver"
+	depends on PCI
+	help
+	  This driver is common for Yunsilicon XSC
+	  ethernet and RDMA drivers.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called xsc_pci.
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
new file mode 100644
index 000000000..c163aa950
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+# All rights reserved.
+
+ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
+
+obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
+
+xsc_pci-y := main.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
new file mode 100644
index 000000000..af654fc04
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include "common/xsc_core.h"
+
+static const struct pci_device_id xsc_pci_id_table[] = {
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MC_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MF_HOST_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MF_SOC_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MS_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MV_HOST_PF_DEV_ID) },
+	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MV_SOC_PF_DEV_ID) },
+	{ 0 }
+};
+
+static int xsc_set_dma_caps(struct pci_dev *pdev)
+{
+	int err;
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (!err)
+		dma_set_max_seg_size(&pdev->dev, SZ_2G);
+
+	return err;
+}
+
+static int xsc_pci_init(struct xsc_core_device *xdev,
+			const struct pci_device_id *id)
+{
+	struct pci_dev *pdev = xdev->pdev;
+	void __iomem *bar_base;
+	int bar_num = 0;
+	int err;
+
+	xdev->numa_node = dev_to_node(&pdev->dev);
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		pci_err(pdev, "failed to enable PCI device: err=%d\n", err);
+		goto err_out;
+	}
+
+	err = pci_request_region(pdev, bar_num, KBUILD_MODNAME);
+	if (err) {
+		pci_err(pdev, "failed to request %s pci_region=%d: err=%d\n",
+			KBUILD_MODNAME, bar_num, err);
+		goto err_disable;
+	}
+
+	pci_set_master(pdev);
+
+	err = xsc_set_dma_caps(pdev);
+	if (err) {
+		pci_err(pdev, "failed to set DMA capabilities mask: err=%d\n",
+			err);
+		goto err_clr_master;
+	}
+
+	bar_base = pci_ioremap_bar(pdev, bar_num);
+	if (!bar_base) {
+		pci_err(pdev, "failed to ioremap %s bar%d\n", KBUILD_MODNAME,
+			bar_num);
+		err = -ENOMEM;
+		goto err_clr_master;
+	}
+
+	err = pci_save_state(pdev);
+	if (err) {
+		pci_err(pdev, "pci_save_state failed: err=%d\n", err);
+		goto err_io_unmap;
+	}
+
+	xdev->bar_num = bar_num;
+	xdev->bar = bar_base;
+
+	return 0;
+
+err_io_unmap:
+	pci_iounmap(pdev, bar_base);
+err_clr_master:
+	pci_clear_master(pdev);
+	pci_release_region(pdev, bar_num);
+err_disable:
+	pci_disable_device(pdev);
+err_out:
+	return err;
+}
+
+static void xsc_pci_fini(struct xsc_core_device *xdev)
+{
+	struct pci_dev *pdev = xdev->pdev;
+
+	pci_iounmap(pdev, xdev->bar);
+	pci_clear_master(pdev);
+	pci_release_region(pdev, xdev->bar_num);
+	pci_disable_device(pdev);
+}
+
+static int xsc_dev_res_init(struct xsc_core_device *xdev)
+{
+	struct xsc_dev_resource *dev_res;
+
+	dev_res = kvzalloc_obj(*dev_res, GFP_KERNEL);
+	if (!dev_res)
+		return -ENOMEM;
+
+	xdev->dev_res = dev_res;
+	mutex_init(&dev_res->alloc_mutex);
+	spin_lock_init(&dev_res->mkey_lock);
+
+	return 0;
+}
+
+static void xsc_dev_res_cleanup(struct xsc_core_device *xdev)
+{
+	kfree(xdev->dev_res);
+}
+
+static int xsc_core_dev_init(struct xsc_core_device *xdev)
+{
+	int err;
+
+	err = xsc_dev_res_init(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc dev res init failed %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void xsc_core_dev_cleanup(struct xsc_core_device *xdev)
+{
+	xsc_dev_res_cleanup(xdev);
+}
+
+static int xsc_hw_setup(struct xsc_core_device *xdev)
+{
+	return 0;
+}
+
+static void xsc_hw_cleanup(struct xsc_core_device *xdev)
+{
+}
+
+static int xsc_load(struct xsc_core_device *xdev)
+{
+	int err = 0;
+
+	err = xsc_hw_setup(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc_hw_setup failed %d\n", err);
+		goto err_out;
+	}
+
+	return 0;
+err_out:
+	return err;
+}
+
+static void xsc_unload(struct xsc_core_device *xdev)
+{
+	xsc_hw_cleanup(xdev);
+}
+
+static int xsc_pci_probe(struct pci_dev *pci_dev,
+			 const struct pci_device_id *id)
+{
+	struct xsc_core_device *xdev;
+	int err;
+
+	xdev = kzalloc_obj(*xdev, GFP_KERNEL);
+	if (!xdev)
+		return -ENOMEM;
+
+	xdev->pdev = pci_dev;
+	xdev->device = &pci_dev->dev;
+	xdev->coredev_type = XSC_COREDEV_PF;
+
+	pci_set_drvdata(pci_dev, xdev);
+	err = xsc_pci_init(xdev, id);
+	if (err) {
+		pci_err(pci_dev, "xsc_pci_init failed %d\n", err);
+		goto err_unset_pci_drvdata;
+	}
+
+	err = xsc_core_dev_init(xdev);
+	if (err) {
+		pci_err(pci_dev, "xsc_core_dev_init failed %d\n", err);
+		goto err_pci_fini;
+	}
+
+	err = xsc_load(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "xsc_load failed %d\n", err);
+		goto err_core_dev_cleanup;
+	}
+
+	return 0;
+err_core_dev_cleanup:
+	xsc_core_dev_cleanup(xdev);
+err_pci_fini:
+	xsc_pci_fini(xdev);
+err_unset_pci_drvdata:
+	pci_set_drvdata(pci_dev, NULL);
+	kfree(xdev);
+
+	return err;
+}
+
+static void xsc_pci_remove(struct pci_dev *pci_dev)
+{
+	struct xsc_core_device *xdev = pci_get_drvdata(pci_dev);
+
+	xsc_unload(xdev);
+	xsc_core_dev_cleanup(xdev);
+	xsc_pci_fini(xdev);
+	pci_set_drvdata(pci_dev, NULL);
+	kfree(xdev);
+}
+
+static struct pci_driver xsc_pci_driver = {
+	.name		= "xsc-pci",
+	.id_table	= xsc_pci_id_table,
+	.probe		= xsc_pci_probe,
+	.remove		= xsc_pci_remove,
+};
+
+static int __init xsc_init(void)
+{
+	int err;
+
+	err = pci_register_driver(&xsc_pci_driver);
+	if (err) {
+		pr_err("failed to register pci driver\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit xsc_fini(void)
+{
+	pci_unregister_driver(&xsc_pci_driver);
+}
+
+module_init(xsc_init);
+module_exit(xsc_fini);
+
+MODULE_DEVICE_TABLE(pci, xsc_pci_id_table);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Yunsilicon XSC PCI driver");
-- 
2.18.4
