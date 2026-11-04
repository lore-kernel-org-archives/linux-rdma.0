Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807832;
	b=v9W0ckiZaLb8byHMBoO4wlvxx3F7Jq+f3dNraUX/T7yz1X4MOleI3xcgArm58LpzBFOh
	 AL2RinVgMVkklc0Qs2PzPjFBcFrLVLnt0yR06IgeFJPHJtuZbN+Qsqjb+S4ircQ2sHkud
	 bvL1wa8OGdqgAGDyu2lLQ21r5U/Gka20PvxvOsBWaBL4CfJsKcyX3CEymy3i5HC7rgu0i
	 J3fNqfMMOnmIBJJaRwEGAy0HQbzzKRnOfYZO+PsvPgJnWdE2tM6mAbWseOinPpHiV9j5y
	 jwxLvjoAZgmFW1eMr0/d4RimENqEcEsSTiQQSttatULbv0dSoo0X1rdVdj+iCocvB/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807832;
	h=DMARC-Filter:DKIM-Signature:Subject:Content-Type:From:
	 X-Lms-Return-Path:In-Reply-To:Date:Received:Message-Id:Cc:
	 Mime-Version:References:X-Mailer:X-Original-From:
	 Content-Transfer-Encoding:To;
	bh=/vzYATcmZ4ruIeG+hVXRSJkrqObWYvr6V2YF4vZquNw=;
	b=D2FIA2MOhkPqwkmSf5zzsFIugd2g8ogXxEQxiuhKlEivJF19i4R0yn0OPpTLK+CURGEk
	 ic1cFDkKh8jhNCvrfpyb+jfyaSq0ErxaCS7n6nN9MmdqB4aDGvgf3kqhcn51kgWgbceWl
	 KsQwZqtuoC5/Wq9qPkTFEcfD6omBS4BoswdVOpLhLaPY5NxZz9YcSCZdEh9FeQKt7CRef
	 RDCLs7cRNyaiKfHJI6mUpxC1NFuI0Nv6qWDcn8fKZkaLNSNN0HaC5KvtklXRSjL2Vy3In
	 MCAWfPxqSHRx/Lv8kTJZTE2+8mP4SQX4R85Y8wMri0fY+GPnE6y/ZVIEgsXSoOD5i9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b="UXX4Z/jc";
	arc=none smtp.remote-ip=209.127.231.40
Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6AA606D805
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B6AA606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=UXX4Z/jc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807820; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/vzYATcmZ4ruIeG+hVXRSJkrqObWYvr6V2YF4vZquNw=;
 b=UXX4Z/jcIQ3Gxd0b++oLTpVhYq52lb0eq20tA3tKc2do1KrrY0T7qHy+R1t/esJdeOA+FJ
 J8yRRINzMbiVh/s/NFDmd6mmvjRjUAas+rAkniUwMLkXzMmaQ+t+ncRePOr3r7nkuG4szW
 imp6rBstMpggWEFidHSI7ZNJMlTGztTZcJm0Y8KTNiGK+AmpqQ2/STA56Z+eRLCTS47Km9
 f0B+THY4v5ZQPJUFveZlxB081JHlxTmX4vAkEosUn35E4YPp/P4T0TGut0dFs6mvBMzYz1
 p2keZYU69Oql3pJC7AUx4oiXUtBRbtpQJTFNT/DnuFpc3TYg38N0LOQjqwT1Ug==
Subject: [PATCH v1 03/15] net/xsc: add the register HAL
Content-Type: text/plain; charset=UTF-8
From: "Xin Tian" <tianx@yunsilicon.com>
X-Lms-Return-Path: <lba+26aeb55ca+595dde+vger.kernel.org+tianx@yunsilicon.com>
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
Date: Wed, 04 Nov 2026 23:56:57 +0800
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:56:57 +0800
Message-Id: <20261104155655.37053-4-tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>

Add the hardware abstraction layer that translates logical register
accesses into BAR-relative MMIO.  The XSC BAR layout differs between
full-BAR (256 MB) parts and parts with a compressed register window,
so the map is selected at init from the BAR size and stored per
device in xdev->hal_regs.  One implementation, for the "Andes" chip
generation, is provided.

The layer implements the doorbell encodings for TX, RX, CQ
arm/notify and EQ update, each preceded by a write barrier to order
descriptor writes before the MMIO store.  TX can use a bank of 64
multi-doorbell registers when the firmware reports support.  It also
provides the command-queue register plumbing (req/rsp PIDs, ring
base addresses, error status) including the cmdq interrupt handler
that re-rings the request doorbell on read/write errors, the mkey
and MR page-mode helpers, and the message-opcode tables the RDMA
send path later uses to map IB opcodes to firmware message opcodes.

The implementation is static behind xsc_* wrappers taking a struct
xsc_core_device; a few helpers are exported for the ethernet and
RDMA modules.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../yunsilicon/xsc/pci/hal/andes_impl.c       | 629 ++++++++++++++++++
 .../yunsilicon/xsc/pci/hal/andes_reg.h        |  43 ++
 .../ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h |  60 ++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |   3 +
 5 files changed, 736 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_reg.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index c163aa950..81b65232e 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o
+xsc_pci-y := main.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
new file mode 100644
index 000000000..69f0daae5
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
@@ -0,0 +1,629 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2024 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include "andes_reg.h"
+#include "common/xsc_core.h"
+#include "common/xsc_cmd.h"
+#include "common/xsc_hsi.h"
+#include "common/xsc_reg.h"
+#include "xsc_hal.h"
+
+/* doorbell words */
+#define XSC_ANDES_TX_DB_DATA0_NEXT_PID_MASK	GENMASK(15, 0)
+#define XSC_ANDES_TX_DB_DATA0_QP_ID_MASK	GENMASK(30, 16)
+#define XSC_ANDES_RX_DB_DATA0_NEXT_PID_MASK	GENMASK(12, 0)
+#define XSC_ANDES_RX_DB_DATA0_QP_ID_MASK	GENMASK(27, 13)
+#define XSC_ANDES_CQ_DB_DATA0_NEXT_CID_MASK	GENMASK(15, 0)
+#define XSC_ANDES_CQ_DB_DATA0_CQ_ID_MASK	GENMASK(30, 16)
+#define XSC_ANDES_CQ_DB_DATA0_ARM		BIT(31)
+#define XSC_ANDES_EQ_DB_DATA0_NEXT_CID_MASK	GENMASK(10, 0)
+#define XSC_ANDES_EQ_DB_DATA0_EQ_ID_MASK	GENMASK(21, 11)
+#define XSC_ANDES_EQ_DB_DATA0_ARM		BIT(22)
+
+/* command queue error status bits */
+#define XSC_ANDES_CMDQ_ERR_HW_READ_REQ_ERR	BIT(0)
+#define XSC_ANDES_CMDQ_ERR_HW_WRITE_REQ_ERR	BIT(1)
+#define XSC_ANDES_CMDQ_ERR_REQ_PID_ERR		BIT(2)
+#define XSC_ANDES_CMDQ_ERR_RSP_CID_ERR		BIT(3)
+
+/* message opcode */
+enum {
+	XSC_MSG_OPCODE_SEND		= 0,
+	XSC_MSG_OPCODE_RDMA_WRITE	= 1,
+	XSC_MSG_OPCODE_RDMA_READ	= 2,
+	XSC_MSG_OPCODE_MAD		= 3,
+	XSC_MSG_OPCODE_RDMA_ACK		= 4,
+	XSC_MSG_OPCODE_RDMA_ACK_READ	= 5,
+	XSC_MSG_OPCODE_RDMA_CNP		= 6,
+	XSC_MSG_OPCODE_RAW		= 7,
+	XSC_MSG_OPCODE_VIRTIO_NET	= 8,
+	XSC_MSG_OPCODE_VIRTIO_BLK	= 9,
+	XSC_MSG_OPCODE_RAW_TPE		= 10,
+	XSC_MSG_OPCODE_INIT_QP_REQ	= 11,
+	XSC_MSG_OPCODE_INIT_QP_RSP	= 12,
+	XSC_MSG_OPCODE_INIT_PATH_REQ	= 13,
+	XSC_MSG_OPCODE_INIT_PATH_RSP	= 14,
+
+	XSC_MSG_OPCODE_UNSUPPORT	= -1,
+};
+
+#define REG_ADDR(bp, offset)	((bp) + (offset))
+
+static u32 xsc_read32(void __iomem *bar, u32 off)
+{
+	return readl(REG_ADDR(bar, off));
+}
+
+static void xsc_write32(void __iomem *bar, u32 off, u32 val)
+{
+	writel(val, REG_ADDR(bar, off));
+}
+
+static void andes_ring_tx_doorbell(struct xsc_core_device *xdev,
+				   struct xsc_hw_reg *regs,
+				   void __iomem *bar, u32 sqn, u32 next_pid,
+				   bool mdb)
+{
+	u32 db = FIELD_PREP(XSC_ANDES_TX_DB_DATA0_NEXT_PID_MASK, next_pid) |
+		 FIELD_PREP(XSC_ANDES_TX_DB_DATA0_QP_ID_MASK, sqn);
+	u32 db_reg = mdb ? QPM_TX_MDB_BASE_REG_ADDR + (sqn & (XSC_MDB_NUM - 1)) * sizeof(u32) :
+		regs->tx_db;
+
+	/* Make sure that descriptors are written before
+	 * updating doorbell record and ringing the doorbell
+	 */
+	wmb();
+
+	writel(db, REG_ADDR(bar, db_reg));
+}
+
+static void andes_ring_rx_doorbell(struct xsc_hw_reg *regs,
+				   void __iomem *bar, u32 rqn, u32 next_pid)
+{
+	u32 db = FIELD_PREP(XSC_ANDES_RX_DB_DATA0_NEXT_PID_MASK, next_pid) |
+		 FIELD_PREP(XSC_ANDES_RX_DB_DATA0_QP_ID_MASK, rqn);
+
+	/* Make sure that descriptors are written before
+	 * updating doorbell record and ringing the doorbell
+	 */
+	wmb();
+
+	writel(db, REG_ADDR(bar, regs->rx_db));
+}
+
+static void andes_update_cq_db(struct xsc_hw_reg *regs,
+			       void __iomem *bar, u32 cqn, u32 next_cid,
+			       u8 solicited)
+{
+	u32 db = FIELD_PREP(XSC_ANDES_CQ_DB_DATA0_NEXT_CID_MASK, next_cid) |
+		 FIELD_PREP(XSC_ANDES_CQ_DB_DATA0_CQ_ID_MASK, cqn) |
+		 FIELD_PREP(XSC_ANDES_CQ_DB_DATA0_ARM, !!solicited);
+
+	/* Make sure that the doorbell record in host memory is
+	 * written before ringing the doorbell via PCI MMIO.
+	 */
+	wmb();
+	writel(db, REG_ADDR(bar, regs->complete_db));
+}
+
+static void andes_set_cq_ci(struct xsc_hw_reg *regs,
+			    void __iomem *bar, u32 cqn, u32 next_cid)
+{
+	u32 db = FIELD_PREP(XSC_ANDES_CQ_DB_DATA0_NEXT_CID_MASK, next_cid) |
+		 FIELD_PREP(XSC_ANDES_CQ_DB_DATA0_CQ_ID_MASK, cqn);
+
+	/* make sure val write to memory done */
+	wmb();
+	writel(db, REG_ADDR(bar, regs->complete_reg));
+}
+
+static void andes_set_eq_ci(struct xsc_hw_reg *regs,
+			    void __iomem *bar, u32 eqn, u32 next_cid,
+			    u8 arm)
+{
+	u32 db = FIELD_PREP(XSC_ANDES_EQ_DB_DATA0_NEXT_CID_MASK, next_cid) |
+		 FIELD_PREP(XSC_ANDES_EQ_DB_DATA0_EQ_ID_MASK, eqn) |
+		 FIELD_PREP(XSC_ANDES_EQ_DB_DATA0_ARM, !!arm);
+
+	/* make sure val write to memory done */
+	wmb();
+	writel(db, REG_ADDR(bar, regs->event_db));
+}
+
+static u8 andes_get_mr_page_mode(u8 page_shift)
+{
+enum {
+	PAGE_SHIFT_4K	= 12,
+	XSC_PAGE_SHIFT_64K	= 16,
+	XSC_PAGE_SHIFT_2M	= 21,
+	XSC_PAGE_SHIFT_1G	= 30,
+};
+
+enum {
+	XSC_PAGE_MODE_4K	= 0,
+	XSC_PAGE_MODE_64K	= 1,
+	XSC_PAGE_MODE_2M	= 2,
+	XSC_PAGE_MODE_1G	= 3,
+};
+
+	return (page_shift == XSC_PAGE_SHIFT_4K ? XSC_PAGE_MODE_4K :
+		(page_shift == XSC_PAGE_SHIFT_64K ? XSC_PAGE_MODE_64K :
+		(page_shift == XSC_PAGE_SHIFT_2M ? XSC_PAGE_MODE_2M : XSC_PAGE_MODE_1G)));
+}
+
+static inline u32 andes_mkey_to_idx(u32 mkey)
+{
+	return mkey >> 17;
+}
+
+static inline u32 andes_idx_to_mkey(u32 mkey_idx)
+{
+	return mkey_idx << 17;
+}
+
+static const u32 xsc_msg_opcode[][2][2] = {
+	[XSC_MSG_OPCODE_SEND][XSC_REQ][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_REQ_SEND,
+	[XSC_MSG_OPCODE_SEND][XSC_REQ][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_REQ_SEND_IMMDT,
+	[XSC_MSG_OPCODE_SEND][XSC_RSP][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_RSP_RECV,
+	[XSC_MSG_OPCODE_SEND][XSC_RSP][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_RSP_RECV_IMMDT,
+	[XSC_MSG_OPCODE_RDMA_WRITE][XSC_REQ][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_REQ_WRITE,
+	[XSC_MSG_OPCODE_RDMA_WRITE][XSC_REQ][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_REQ_WRITE_IMMDT,
+	[XSC_MSG_OPCODE_RDMA_WRITE][XSC_RSP][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_CQE_ERROR,
+	[XSC_MSG_OPCODE_RDMA_WRITE][XSC_RSP][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_RSP_WRITE_IMMDT,
+	[XSC_MSG_OPCODE_RDMA_READ][XSC_REQ][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_REQ_READ,
+	[XSC_MSG_OPCODE_RDMA_READ][XSC_REQ][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_CQE_ERROR,
+	[XSC_MSG_OPCODE_RDMA_READ][XSC_RSP][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_CQE_ERROR,
+	[XSC_MSG_OPCODE_RDMA_READ][XSC_RSP][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_CQE_ERROR,
+	[XSC_MSG_OPCODE_MAD][XSC_REQ][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_MAD_REQ_SEND,
+	[XSC_MSG_OPCODE_MAD][XSC_REQ][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_CQE_ERROR,
+	[XSC_MSG_OPCODE_MAD][XSC_RSP][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_MAD_RSP_RECV,
+	[XSC_MSG_OPCODE_MAD][XSC_RSP][XSC_WITH_IMMDT] = XSC_OPCODE_RDMA_CQE_ERROR,
+};
+
+struct andes_cqe {
+	__le32		data0;
+	__le32		imm_data;
+	__le32		msg_len;
+	__le32		vni;
+	__le64		data2;
+	__le16		rsv[2];
+	__le32		data1;
+};
+
+static int andes_get_cqe_wqe_id(void *cqe)
+{
+	return FIELD_GET(XSC_CQE_DATA2_WQE_ID_MASK,
+			 le64_to_cpu(((struct andes_cqe *)cqe)->data2));
+}
+
+static u8 andes_get_cqe_opcode(void *cqe)
+{
+	u32 val = le32_to_cpu(((struct andes_cqe *)cqe)->data0);
+	u8 msg_opcode = FIELD_GET(XSC_CQE_DATA0_MSG_OPCD_MASK, val);
+
+	if (val & XSC_CQE_DATA0_IS_ERR)
+		return (val & XSC_CQE_DATA0_TYPE) ? XSC_OPCODE_RDMA_RSP_ERROR :
+					     XSC_OPCODE_RDMA_REQ_ERROR;
+	if (msg_opcode > XSC_MSG_OPCODE_MAD)
+		return XSC_OPCODE_RDMA_CQE_ERROR;
+	return xsc_msg_opcode[msg_opcode][(val & XSC_CQE_DATA0_TYPE) != 0]
+					 [(val & XSC_CQE_DATA0_WITH_IMM) != 0];
+}
+
+struct andes_data_seg {
+	__le32	data0;
+	__le32	key;
+	__le64	addr;
+};
+
+static void andes_set_data_seg(void *data_seg, u32 length, u32 key, u64 addr)
+{
+	struct andes_data_seg *seg = data_seg;
+
+	seg->data0 = cpu_to_le32(FIELD_PREP(XSC_WQE_DATA_SEG_DATA0_SEG_LEN_MASK,
+					    length));
+	seg->key = cpu_to_le32(key);
+	seg->addr = cpu_to_le64(addr);
+}
+
+struct andes_send_wqe_ctrl_seg {
+	__le32		data0;
+	__le32		msg_len;
+	__le32		data2;
+	__le32		data3;
+};
+
+static void andes_set_wqe_id(void *cseg, u32 wqe_id)
+{
+	struct xsc_send_wqe_ctrl_seg *seg = cseg;
+	u32 val = le32_to_cpu(seg->data0);
+
+	seg->data0 = cpu_to_le32((val & ~XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK) |
+				 FIELD_PREP(XSC_WQE_CTRL_SEG_DATA0_WQE_ID_MASK,
+					    (u16)wqe_id));
+}
+
+static struct xsc_msg_opcode xsc_ib_opcode = {
+	.send = XSC_MSG_OPCODE_SEND,
+	.send_with_imm = XSC_MSG_OPCODE_SEND,
+	.rdma_write = XSC_MSG_OPCODE_RDMA_WRITE,
+	.rdma_write_with_imm = XSC_MSG_OPCODE_RDMA_WRITE,
+	.rdma_read = XSC_MSG_OPCODE_RDMA_READ,
+	.atomic_cmp_and_swp = XSC_MSG_OPCODE_UNSUPPORT,
+	.atomic_fetch_and_add = XSC_MSG_OPCODE_UNSUPPORT,
+	.masked_atomic_cmp_and_swp = XSC_MSG_OPCODE_UNSUPPORT,
+	.masked_atomic_fetch_and_add = XSC_MSG_OPCODE_UNSUPPORT,
+	.mad = XSC_MSG_OPCODE_MAD,
+};
+
+static struct xsc_msg_opcode *andes_get_msg_opcode(void)
+{
+	return &xsc_ib_opcode;
+}
+
+static struct xsc_hw_reg andes_pf_regs = {
+	.req_pid_addr = HIF_CMDQM_HOST_REQ_PID_MEM_ADDR - 0xa0000000,
+	.req_cid_addr = HIF_CMDQM_HOST_REQ_CID_MEM_ADDR - 0xa0000000,
+	.rsp_pid_addr = HIF_CMDQM_HOST_RSP_PID_MEM_ADDR - 0xa0000000,
+	.rsp_cid_addr = HIF_CMDQM_HOST_RSP_CID_MEM_ADDR - 0xa0000000,
+	.req_buf_h_addr = HIF_CMDQM_HOST_REQ_BUF_BASE_H_ADDR_MEM_ADDR - 0xa0000000,
+	.req_buf_l_addr = HIF_CMDQM_HOST_REQ_BUF_BASE_L_ADDR_MEM_ADDR - 0xa0000000,
+	.rsp_buf_h_addr = HIF_CMDQM_HOST_RSP_BUF_BASE_H_ADDR_MEM_ADDR - 0xa0000000,
+	.rsp_buf_l_addr = HIF_CMDQM_HOST_RSP_BUF_BASE_L_ADDR_MEM_ADDR - 0xa0000000,
+	.msix_vec_addr = HIF_CMDQM_VECTOR_ID_MEM_ADDR - 0xa0000000,
+	.interrupt_stat_addr = HIF_CMDQM_HOST_VF_ERR_STS_MEM_ADDR - 0xa0000000,
+	.mpt_tbl_addr = MMC_MPT_TBL_MEM_ADDR - 0xa0000000,
+	.mpt_tbl_depth = MMC_MPT_TBL_MEM_DEPTH,
+	.mpt_tbl_width = MMC_MPT_TBL_MEM_WIDTH,
+	.mtt_inst_base_addr = MMC_MTT_TBL_MEM_ADDR - 0xa0000000,
+	.mtt_inst_stride = 0,
+	.mtt_inst_num_log = 0,
+	.mtt_inst_depth = MMC_MTT_TBL_MEM_DEPTH,
+};
+
+/* BAR-relative window shared by bar-compressed PF and VF */
+static struct xsc_hw_reg andes_compressed_regs = {
+	.tx_db = TX_DB_FUNC_MEM_ADDR,
+	.rx_db = RX_DB_FUNC_MEM_ADDR,
+	.complete_db = DB_CQ_FUNC_MEM_ADDR,
+	.complete_reg = DB_CQ_CID_DIRECT_MEM_ADDR,
+	.event_db = DB_EQ_FUNC_MEM_ADDR,
+	.req_pid_addr = CMDQM_HOST_REQ_PID_MEM_ADDR,
+	.req_cid_addr = CMDQM_HOST_REQ_CID_MEM_ADDR,
+	.rsp_pid_addr = CMDQM_HOST_RSP_PID_MEM_ADDR,
+	.rsp_cid_addr = CMDQM_HOST_RSP_CID_MEM_ADDR,
+	.req_buf_h_addr = CMDQM_HOST_REQ_BUF_BASE_H_ADDR_MEM_ADDR,
+	.req_buf_l_addr = CMDQM_HOST_REQ_BUF_BASE_L_ADDR_MEM_ADDR,
+	.rsp_buf_h_addr = CMDQM_HOST_RSP_BUF_BASE_H_ADDR_MEM_ADDR,
+	.rsp_buf_l_addr = CMDQM_HOST_RSP_BUF_BASE_L_ADDR_MEM_ADDR,
+	.msix_vec_addr = CMDQM_VECTOR_ID_MEM_ADDR,
+	.interrupt_stat_addr = CMDQM_HOST_VF_ERR_STS_MEM_ADDR,
+	.mpt_tbl_addr = MMC_MPT_TBL_MEM_ADDR - 0xa0000000,
+	.mpt_tbl_depth = MMC_MPT_TBL_MEM_DEPTH,
+	.mpt_tbl_width = MMC_MPT_TBL_MEM_WIDTH,
+	.mtt_inst_base_addr = MMC_MTT_TBL_MEM_ADDR - 0xa0000000,
+	.mtt_inst_stride = 0,
+	.mtt_inst_num_log = 0,
+	.mtt_inst_depth = MMC_MTT_TBL_MEM_DEPTH,
+};
+
+void xsc_init_hal(struct xsc_core_device *xdev)
+{
+	struct xsc_hw_reg *regs;
+
+	if (is_pf_bar_compressed(xdev))
+		regs = &andes_compressed_regs;
+	else
+		regs = &andes_pf_regs;
+
+	/* every device gets its own copy, xsc_set_mtt_info() and
+	 * xsc_set_pf_db_addr() fill it with device-specific values
+	 */
+	memcpy(&xdev->hal_regs, regs, sizeof(xdev->hal_regs));
+}
+
+void xsc_set_mtt_info(struct xsc_core_device *xdev)
+{
+	struct xsc_hw_reg *regs = &xdev->hal_regs;
+
+	regs->mpt_tbl_addr = xdev->caps.mpt_tbl_addr - 0xa0000000;
+	regs->mpt_tbl_depth = xdev->caps.mpt_tbl_depth;
+	regs->mpt_tbl_width = xdev->caps.mpt_tbl_width;
+	regs->mtt_inst_base_addr = xdev->caps.mtt_inst_base_addr - 0xa0000000;
+	regs->mtt_inst_stride = xdev->caps.mtt_inst_stride;
+	regs->mtt_inst_num_log = xdev->caps.mtt_inst_num_log;
+	regs->mtt_inst_depth = xdev->caps.mtt_inst_depth;
+}
+
+void xsc_set_pf_db_addr(struct xsc_core_device *xdev,
+			u64 tx_db, u64 rx_db, u64 cq_db, u64 cq_reg, u64 eq_db)
+{
+	struct xsc_hw_reg *regs = &xdev->hal_regs;
+
+	if (is_pf_bar_compressed(xdev))
+		return;
+
+	if (xsc_core_is_pf(xdev)) {
+		regs->tx_db = tx_db - 0xa0000000;
+		regs->rx_db = rx_db - 0xa0000000;
+		regs->complete_db = cq_db - 0xa0000000;
+		regs->complete_reg = cq_reg - 0xa0000000;
+		regs->event_db = eq_db - 0xa0000000;
+	}
+}
+
+void xsc_get_db_addr(struct xsc_core_device *xdev,
+		     u64 *tx_db, u64 *rx_db, u64 *cq_db, u64 *cq_reg, u64 *eq_db)
+{
+	struct xsc_hw_reg *regs = &xdev->hal_regs;
+
+	if (!xsc_core_is_pf(xdev) || is_pf_bar_compressed(xdev)) {
+		if (tx_db)
+			*tx_db = regs->tx_db;
+		if (rx_db)
+			*rx_db = regs->rx_db;
+		if (cq_db)
+			*cq_db = regs->complete_db;
+		if (cq_reg)
+			*cq_reg = regs->complete_reg;
+		if (eq_db)
+			*eq_db = regs->event_db;
+	} else {
+		if (tx_db)
+			*tx_db = regs->tx_db + 0xa0000000;
+		if (rx_db)
+			*rx_db = regs->rx_db + 0xa0000000;
+		if (cq_db)
+			*cq_db = regs->complete_db + 0xa0000000;
+		if (cq_reg)
+			*cq_reg = regs->complete_reg + 0xa0000000;
+		if (eq_db)
+			*eq_db = regs->event_db + 0xa0000000;
+	}
+}
+EXPORT_SYMBOL_GPL(xsc_get_db_addr);
+
+void xsc_update_tx_db(struct xsc_core_device *xdev, u32 sqn, u32 next_pid)
+{
+	bool mdb = is_support_multi_doorbell(xdev);
+
+	andes_ring_tx_doorbell(xdev, &xdev->hal_regs, xdev->bar, sqn,
+			       next_pid, mdb);
+}
+EXPORT_SYMBOL_GPL(xsc_update_tx_db);
+
+void xsc_update_rx_db(struct xsc_core_device *xdev, u32 rqn, u32 next_pid)
+{
+	andes_ring_rx_doorbell(&xdev->hal_regs, xdev->bar, rqn, next_pid);
+}
+EXPORT_SYMBOL_GPL(xsc_update_rx_db);
+
+void xsc_arm_cq(struct xsc_core_device *xdev, u32 cqn, u32 next_cid, u8 solicited)
+{
+	andes_update_cq_db(&xdev->hal_regs, xdev->bar, cqn, next_cid, solicited);
+}
+EXPORT_SYMBOL_GPL(xsc_arm_cq);
+
+void xsc_update_cq_ci(struct xsc_core_device *xdev, u32 cqn, u32 next_cid)
+{
+	andes_set_cq_ci(&xdev->hal_regs, xdev->bar, cqn, next_cid);
+}
+EXPORT_SYMBOL_GPL(xsc_update_cq_ci);
+
+void xsc_update_eq_ci(struct xsc_core_device *xdev, u32 eqn, u32 next_cid, u8 arm)
+{
+	andes_set_eq_ci(&xdev->hal_regs, xdev->bar, eqn, next_cid, arm);
+}
+
+void xsc_update_cmdq_req_pid(struct xsc_core_device *xdev, u32 req_pid)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs.req_pid_addr, req_pid);
+}
+
+void xsc_update_cmdq_rsp_cid(struct xsc_core_device *xdev, u32 rsp_cid)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs.rsp_cid_addr, rsp_cid);
+}
+
+u32 xsc_get_cmdq_req_pid(struct xsc_core_device *xdev)
+{
+	return xsc_read32(xdev->bar, xdev->hal_regs.req_pid_addr);
+}
+
+u32 xsc_get_cmdq_req_cid(struct xsc_core_device *xdev)
+{
+	return xsc_read32(xdev->bar, xdev->hal_regs.req_cid_addr);
+}
+
+u32 xsc_get_cmdq_rsp_pid(struct xsc_core_device *xdev)
+{
+	return xsc_read32(xdev->bar, xdev->hal_regs.rsp_pid_addr);
+}
+
+u32 xsc_get_cmdq_rsp_cid(struct xsc_core_device *xdev)
+{
+	return xsc_read32(xdev->bar, xdev->hal_regs.rsp_cid_addr);
+}
+
+void xsc_set_cmdq_req_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 laddr)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs.req_buf_h_addr, haddr);
+	xsc_write32(xdev->bar, xdev->hal_regs.req_buf_l_addr, laddr);
+}
+
+void xsc_set_cmdq_rsp_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 laddr)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs.rsp_buf_h_addr, haddr);
+	xsc_write32(xdev->bar, xdev->hal_regs.rsp_buf_l_addr, laddr);
+}
+
+void xsc_set_cmdq_msix_vector(struct xsc_core_device *xdev, u32 vector)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs.msix_vec_addr, vector);
+}
+
+void xsc_check_cmdq_status(struct xsc_core_device *xdev)
+{
+	u32 status;
+
+	status = xsc_read32(xdev->bar, xdev->hal_regs.interrupt_stat_addr);
+	if (status)
+		xsc_write32(xdev->bar, xdev->hal_regs.interrupt_stat_addr, status);
+}
+
+int xsc_handle_cmdq_interrupt(struct xsc_core_device *xdev)
+{
+	int err = 0;
+	int retry = 0;
+	u32 stat;
+	u32 raw;
+
+	raw = xsc_read32(xdev->bar, xdev->hal_regs.interrupt_stat_addr);
+	stat = raw;
+	while (stat != 0) {
+		err++;
+		if (stat & XSC_ANDES_CMDQ_ERR_HW_READ_REQ_ERR) {
+			retry = 1;
+			stat &= ~XSC_ANDES_CMDQ_ERR_HW_READ_REQ_ERR;
+			pci_err(xdev->pdev, "hw report read req from host failed!\n");
+		} else if (stat & XSC_ANDES_CMDQ_ERR_HW_WRITE_REQ_ERR) {
+			retry = 1;
+			stat &= ~XSC_ANDES_CMDQ_ERR_HW_WRITE_REQ_ERR;
+			pci_err(xdev->pdev, "hw report write req to fw failed!\n");
+		} else if (stat & XSC_ANDES_CMDQ_ERR_REQ_PID_ERR) {
+			stat &= ~XSC_ANDES_CMDQ_ERR_REQ_PID_ERR;
+			pci_err(xdev->pdev, "hw report unexpected req pid!\n");
+		} else if (stat & XSC_ANDES_CMDQ_ERR_RSP_CID_ERR) {
+			stat &= ~XSC_ANDES_CMDQ_ERR_RSP_CID_ERR;
+			pci_err(xdev->pdev, "hw report unexpected rsp cid!\n");
+		} else {
+			stat = 0;
+			pci_err(xdev->pdev, "ignore unknown interrupt!\n");
+		}
+	}
+
+	if (retry) {
+		unsigned long flags;
+
+		if (xdev->cmd.retry_cnt >= XSC_CMD_MAX_RETRY_CNT) {
+			pci_warn(xdev->pdev, "err handler have retried for %d times, stop retry\n",
+				 xdev->cmd.retry_cnt);
+			goto clear_err_int;
+		}
+		spin_lock_irqsave(&xdev->cmd.doorbell_lock, flags);
+		xsc_write32(xdev->bar, xdev->hal_regs.req_pid_addr,
+			    xdev->cmd.cmd_pid);
+		xdev->cmd.retry_cnt++;
+		spin_unlock_irqrestore(&xdev->cmd.doorbell_lock, flags);
+	}
+
+clear_err_int:
+	if (err)
+		xsc_write32(xdev->bar, xdev->hal_regs.interrupt_stat_addr, raw);
+
+	return err;
+}
+
+u8 xsc_get_mr_page_mode(struct xsc_core_device *xdev, u8 page_shift)
+{
+	return andes_get_mr_page_mode(page_shift);
+}
+EXPORT_SYMBOL_GPL(xsc_get_mr_page_mode);
+
+u32 xsc_mkey_to_idx(struct xsc_core_device *xdev, u32 mkey)
+{
+	return andes_mkey_to_idx(mkey);
+}
+
+u32 xsc_idx_to_mkey(struct xsc_core_device *xdev, u32 mkey_idx)
+{
+	return andes_idx_to_mkey(mkey_idx);
+}
+
+u8 xsc_get_cqe_opcode(struct xsc_core_device *xdev, void *cqe)
+{
+	return andes_get_cqe_opcode(cqe);
+}
+EXPORT_SYMBOL_GPL(xsc_get_cqe_opcode);
+
+u64 xsc_get_rdma_stat_mask(struct xsc_core_device *xdev, u16 ver)
+{
+	u64 mask;
+
+	if (xsc_core_is_pf(xdev))
+		mask = 0xFFFFFF;
+	else
+		mask = 0xfff;
+
+	return mask;
+}
+EXPORT_SYMBOL_GPL(xsc_get_rdma_stat_mask);
+
+void xsc_set_data_seg(struct xsc_core_device *xdev, void *data_seg, u64 addr, u32 key, u32 length)
+{
+	andes_set_data_seg(data_seg, length, key, addr);
+}
+EXPORT_SYMBOL_GPL(xsc_set_data_seg);
+
+u32 xsc_get_max_qp_depth(struct xsc_core_device *xdev)
+{
+	return 32 * 1024;
+}
+EXPORT_SYMBOL_GPL(xsc_get_max_qp_depth);
+
+bool xsc_check_max_qp_depth(struct xsc_core_device *xdev, u32 *wqe_cnt, u32 max_qp_depth)
+{
+	if (*wqe_cnt > max_qp_depth)
+		*wqe_cnt = max_qp_depth;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(xsc_check_max_qp_depth);
+
+u32 xsc_get_recv_ds_num(struct xsc_core_device *xdev)
+{
+	return xdev->caps.recv_ds_num;
+}
+EXPORT_SYMBOL_GPL(xsc_get_recv_ds_num);
+
+void *xsc_get_msg_opcode(struct xsc_core_device *xdev)
+{
+	return andes_get_msg_opcode();
+}
+
+u64 xsc_get_max_mr_size(struct xsc_core_device *xdev)
+{
+	u64 max_mpt_mr_size = xdev->caps.max_mr_size;
+	u64 max_mtt_mr_size = (u64)xdev->caps.max_mtt * XSC_PAGE_SIZE_4K;
+
+	return min_t(u64, max_mpt_mr_size, max_mtt_mr_size);
+}
+EXPORT_SYMBOL_GPL(xsc_get_max_mr_size);
+
+void xsc_get_multidb_info(struct xsc_core_device *xdev, u32 *num, u32 *base)
+{
+	if (is_support_multi_doorbell(xdev)) {
+		*num = XSC_MDB_NUM;
+		*base = QPM_TX_MDB_BASE_REG_ADDR;
+	} else {
+		*num = 0;
+		*base = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(xsc_get_multidb_info);
+
+void xsc_set_wqe_id(struct xsc_core_device *dev, void *cseg, u32 wqe_id)
+{
+	andes_set_wqe_id(cseg, wqe_id);
+}
+EXPORT_SYMBOL_GPL(xsc_set_wqe_id);
+
+int xsc_get_cqe_wqe_id(struct xsc_core_device *dev, void *cqe)
+{
+	return andes_get_cqe_wqe_id(cqe);
+}
+EXPORT_SYMBOL_GPL(xsc_get_cqe_wqe_id);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_reg.h b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_reg.h
new file mode 100644
index 000000000..cd25b64a5
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_reg.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+/* generated time:
+ * Thu Feb 29 15:33:50 CST 2024
+ */
+
+#ifndef ANDES_REG_H
+#define ANDES_REG_H
+
+//hif_irq_csr_defines.h
+
+//hif_cpm_csr_defines.h
+
+//mmc_csr_defines.h
+#define MMC_MPT_TBL_MEM_DEPTH  32768
+#define MMC_MTT_TBL_MEM_DEPTH  262144
+#define MMC_MPT_TBL_MEM_WIDTH  256
+#define MMC_MPT_TBL_MEM_ADDR   0xa4100000
+#define MMC_MTT_TBL_MEM_ADDR   0xa4200000
+
+//clsf_dma_csr_defines.h
+
+//hif_tbl_csr_defines.h
+
+//hif_cmdqm_csr_defines.h
+#define HIF_CMDQM_HOST_REQ_PID_MEM_ADDR   0xa1026000
+#define HIF_CMDQM_HOST_REQ_CID_MEM_ADDR   0xa1028000
+#define HIF_CMDQM_HOST_RSP_PID_MEM_ADDR   0xa102e000
+#define HIF_CMDQM_HOST_RSP_CID_MEM_ADDR   0xa1030000
+#define HIF_CMDQM_HOST_REQ_BUF_BASE_H_ADDR_MEM_ADDR   0xa1022000
+#define HIF_CMDQM_HOST_REQ_BUF_BASE_L_ADDR_MEM_ADDR   0xa1024000
+#define HIF_CMDQM_HOST_RSP_BUF_BASE_H_ADDR_MEM_ADDR   0xa102a000
+#define HIF_CMDQM_HOST_RSP_BUF_BASE_L_ADDR_MEM_ADDR   0xa102c000
+#define HIF_CMDQM_VECTOR_ID_MEM_ADDR   0xa1034000
+#define HIF_CMDQM_HOST_VF_ERR_STS_MEM_ADDR   0xa1032000
+
+//PSV use
+//hif_irq_csr_defines.h
+
+#endif /* XSC_HW_H  */
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
new file mode 100644
index 000000000..f6292a91b
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2024 - 2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef XSC_HAL_H
+#define XSC_HAL_H
+
+struct xsc_core_device;
+
+/* HAL entry points exported to the PCI/RDMA/ETH layers */
+void xsc_init_hal(struct xsc_core_device *xdev);
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
+void xsc_update_eq_ci(struct xsc_core_device *xdev, u32 eqn, u32 next_cid, u8 arm);
+
+void xsc_update_cmdq_req_pid(struct xsc_core_device *xdev, u32 req_pid);
+void xsc_update_cmdq_rsp_cid(struct xsc_core_device *xdev, u32 rsp_cid);
+u32 xsc_get_cmdq_req_pid(struct xsc_core_device *xdev);
+u32 xsc_get_cmdq_req_cid(struct xsc_core_device *xdev);
+u32 xsc_get_cmdq_rsp_pid(struct xsc_core_device *xdev);
+u32 xsc_get_cmdq_rsp_cid(struct xsc_core_device *xdev);
+void xsc_set_cmdq_req_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 laddr);
+void xsc_set_cmdq_rsp_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 laddr);
+void xsc_set_cmdq_msix_vector(struct xsc_core_device *xdev, u32 vector);
+void xsc_check_cmdq_status(struct xsc_core_device *xdev);
+int xsc_handle_cmdq_interrupt(struct xsc_core_device *xdev);
+
+u8 xsc_get_mr_page_mode(struct xsc_core_device *xdev, u8 page_shift);
+u32 xsc_mkey_to_idx(struct xsc_core_device *xdev, u32 mkey);
+u32 xsc_idx_to_mkey(struct xsc_core_device *xdev, u32 mkey_idx);
+
+u8 xsc_get_cqe_opcode(struct xsc_core_device *xdev, void *cqe);
+u64 xsc_get_rdma_stat_mask(struct xsc_core_device *xdev, u16 ver);
+void xsc_set_data_seg(struct xsc_core_device *xdev, void *data_seg, u64 addr, u32 key, u32 length);
+u32 xsc_get_max_qp_depth(struct xsc_core_device *xdev);
+bool xsc_check_max_qp_depth(struct xsc_core_device *xdev, u32 *wqe_cnt, u32 max_qp_depth);
+u32 xsc_get_recv_ds_num(struct xsc_core_device *xdev);
+void *xsc_get_msg_opcode(struct xsc_core_device *xdev);
+u64 xsc_get_max_mr_size(struct xsc_core_device *xdev);
+void xsc_get_multidb_info(struct xsc_core_device *xdev, u32 *num, u32 *base);
+void xsc_set_wqe_id(struct xsc_core_device *dev, void *cseg, u32 wqe_id);
+int xsc_get_cqe_wqe_id(struct xsc_core_device *dev, void *cqe);
+
+enum {
+	CQ_STAT_FIRED,
+	CQ_STAT_KEEP,
+	CQ_STAT_ARM_NEXT,
+	CQ_STAT_ARM_SOLICITED,
+};
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index af654fc04..ab428d20f 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -4,6 +4,7 @@
  */
 
 #include "common/xsc_core.h"
+#include "hal/xsc_hal.h"
 
 static const struct pci_device_id xsc_pci_id_table[] = {
 	{ PCI_DEVICE(XSC_PCI_VENDOR_ID, XSC_MC_PF_DEV_ID) },
@@ -75,6 +76,8 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
 	xdev->bar_num = bar_num;
 	xdev->bar = bar_base;
 
+	xsc_init_hal(xdev);
+
 	return 0;
 
 err_io_unmap:
-- 
2.18.4
