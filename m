Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D58415F27
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805562; cv=none; b=abl+7AK9iPgvUfiY8EURkmGT5gWQKNLOyuvMvyEGpc1+odFrlMKVr82+/FxjojgfzcEP7OhThRajprFeWwlq5IIAfjQYvAq6lHZsUSAmY+tSSDaGeppxgFjGouHw1Pm7RaZwf8AUJFl3mQQt990Fy0zmzRbzWwYkLGptmfjDEek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805562; c=relaxed/simple;
	bh=q+8cUntyTxvjSHdbm2dOSp/wJXsAblcjKqectgchWkM=;
	h=Content-Type:Cc:Date:Message-Id:Mime-Version:From:Subject:To:
	 In-Reply-To:References; b=NKW+BYjAV1f5W3OnN+txrjzZBHK8p2kyDsgb6sKbUs6LTo+dLCdUW9oImxQ9hIAbpnNfI/Uff6+uAG1AHdN2x77h0jasUcHiYwYE2dB4+4TBdwbZtHylUlbVq5iSEKEPr4Zu2pyddi0vISBUf61g+8tiuOpCPn8nX7gguupOlak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com; spf=pass smtp.mailfrom=yunsilicon.com; dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b=VgksOacc; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.b="VgksOacc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1791805438; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=XxslRRDY5BhoHnulsCHR0UTN93/W2n7/aHHo0hTJP8c=;
 b=VgksOaccUUtOeKXrtw+8c4zPSe+yMkErtGCZjnyNdoAkOTXK29DFCWbdGHati1vdveR+h1
 vTdbQ94dK9ufP9FthNvVwiiB2pXHZ8R/MY7kt3NaUTZHtJPmDLe8qXfHHxB+E9OpQU8abt
 u1zHQhET974eb65Z8OBXtX7lrZXD0E33SBxLGDObBCBw+g1h+5PlikTCzA+fPMtZGqdE3J
 MGq18e50b4GoGlvXUlXi9QfIvCTZW2vKeP08VW0eUfT5sWYJx6Rv1BU0onYNNYaptE0jAz
 AUJ0zaMGoZOsDAdhf0dwQ3apZMYN5NI5DyneMfxkEQ4fBXsY2PxfS/ALRc9G7g==
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Date: Mon, 12 Oct 2026 19:43:55 +0800
Message-Id: <20261012114354.2471317-3-tianx@yunsilicon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH 02/15] yunsilicon: add the register HAL
X-Lms-Return-Path: <lba+26accc7fc+e099fa+vger.kernel.org+tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Mon, 12 Oct 2026 19:43:55 +0800
In-Reply-To: <20261012114352.2471317-1-tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
References: <20261012114352.2471317-1-tianx@yunsilicon.com>

Add the register access layer and the per-device register map: doorbell
and interrupt registers, the command queue pointers and the device
capability queries that the upper layers call.  The register map is
described by xsc_hal.h and implemented for the Andes device.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 .../yunsilicon/xsc/pci/hal/andes_impl.c       | 708 ++++++++++++++++++
 .../yunsilicon/xsc/pci/hal/andes_reg.h        |  43 ++
 .../ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h |  85 +++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |   3 +
 5 files changed, 840 insertions(+), 1 deletion(-)
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
index 000000000..46fc045f9
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
@@ -0,0 +1,708 @@
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
+static void xsc_read32(void __iomem *bar, u32 off, void *data, int len)
+{
+	u32 val = readl(REG_ADDR(bar, off));
+
+	memcpy(data, &val, len);
+}
+
+static void xsc_write32(void __iomem *bar, u32 off, void *data)
+{
+	writel(*(u32 *)data, REG_ADDR(bar, off));
+}
+
+static void andes_ring_tx_doorbell(struct xsc_core_device *xdev,
+				   struct xsc_hw_reg *regs,
+				   void __iomem *bar, u32 sqn, u32 next_pid,
+				   bool mdb)
+{
+	union xsc_send_doorbell {
+		struct{
+			u32  next_pid : 16;
+			u32 qp_id : 15;
+		};
+		u32 raw;
+	} db;
+	u32 db_reg = mdb ? QPM_TX_MDB_BASE_REG_ADDR + (sqn & (MDB_NUM - 1)) * sizeof(u32) :
+		regs->tx_db;
+
+	db.next_pid = next_pid;
+	db.qp_id = sqn;
+
+	/* Make sure that descriptors are written before
+	 * updating doorbell record and ringing the doorbell
+	 */
+	wmb();
+
+	writel(db.raw, REG_ADDR(bar, db_reg));
+}
+
+static void andes_ring_rx_doorbell(struct xsc_hw_reg *regs,
+				   void __iomem *bar, u32 rqn, u32 next_pid)
+{
+	union xsc_recv_doorbell {
+		struct{
+			u32  next_pid : 13;
+			u32 qp_id : 15;
+		};
+		u32 raw;
+	} db;
+
+	db.next_pid = next_pid;
+	db.qp_id = rqn;
+
+	/* Make sure that descriptors are written before
+	 * updating doorbell record and ringing the doorbell
+	 */
+	wmb();
+
+	writel(db.raw, REG_ADDR(bar, regs->rx_db));
+}
+
+static void andes_update_cq_db(struct xsc_hw_reg *regs,
+			       void __iomem *bar, u32 cqn, u32 next_cid,
+			       u8 solicited)
+{
+	union andes_cq_doorbell {
+		struct{
+			u32     cq_next_cid:16;
+			u32     cq_id:15;
+			u32     arm:1;
+		};
+		u32     val;
+	} db;
+
+	db.cq_next_cid = next_cid;
+	db.cq_id = cqn;
+	db.arm = solicited;
+
+	/* Make sure that the doorbell record in host memory is
+	 * written before ringing the doorbell via PCI MMIO.
+	 */
+	wmb();
+	writel(db.val, REG_ADDR(bar, regs->complete_db));
+}
+
+static void andes_set_cq_ci(struct xsc_hw_reg *regs,
+			    void __iomem *bar, u32 cqn, u32 next_cid)
+{
+	union andes_cq_doorbell {
+		struct{
+			u32     cq_next_cid:16;
+			u32     cq_id:15;
+			u32     arm:1;
+		};
+		u32     val;
+	} db;
+
+	db.val = 0;
+	db.cq_next_cid = next_cid;
+	db.cq_id = cqn;
+	/* make sure val write to memory done */
+	wmb();
+	writel(db.val, REG_ADDR(bar, regs->complete_reg));
+}
+
+static void andes_set_eq_ci(struct xsc_hw_reg *regs,
+			    void __iomem *bar, u32 eqn, u32 next_cid,
+			    u8 arm)
+{
+	union andes_eq_doorbell {
+		struct{
+			u32 eq_next_cid : 11;
+			u32 eq_id : 11;
+			u32 arm : 1;
+		};
+		u32 val;
+	} db;
+
+	db.eq_next_cid = next_cid;
+	db.eq_id = eqn;
+	db.arm = !!arm;
+
+	/* make sure val write to memory done */
+	wmb();
+	writel(db.val, REG_ADDR(bar, regs->event_db));
+}
+
+static u8 andes_get_mr_page_mode(u8 page_shift)
+{
+enum {
+	XSC_PAGE_SHIFT_4K	= 12,
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
+	[XSC_MSG_OPCODE_MAD][XSC_RSP][XSC_WITHOUT_IMMDT] = XSC_OPCODE_RDMA_MAD_RSP_RECV,
+};
+
+struct andes_cqe {
+	union {
+		u8		msg_opcode;
+		struct {
+			u8		error_code:7;
+			u8		is_error:1;
+		};
+	};
+	__le32		qp_id:15;
+	u8		rsv1:1;
+	u8		se:1;
+	u8		has_pph:1;
+	u8		type:1;
+	u8		with_immdt:1;
+	u8		csum_err:4;
+	__le32		imm_data;
+	__le32		msg_len;
+	__le32		vni;
+	__le64		ts:48;
+	__le16		wqe_id;
+	__le16		rsv[3];
+	__le16		rsv2:15;
+	u8		owner:1;
+};
+
+static int andes_get_cqe_wqe_id(void *cqe)
+{
+	return ((struct andes_cqe *)cqe)->wqe_id;
+}
+
+static u8 andes_get_cqe_opcode(void *cqe)
+{
+	struct andes_cqe *_cqe = cqe;
+	u8 msg_opcode = _cqe->msg_opcode;
+
+	if (_cqe->is_error)
+		return _cqe->type ? XSC_OPCODE_RDMA_RSP_ERROR : XSC_OPCODE_RDMA_REQ_ERROR;
+	if (msg_opcode > XSC_MSG_OPCODE_MAD)
+		return XSC_OPCODE_RDMA_CQE_ERROR;
+	return xsc_msg_opcode[msg_opcode][_cqe->type][_cqe->with_immdt];
+}
+
+struct andes_data_seg {
+	u32	in_line:1;
+	u32	length:31;
+	u32	key;
+	u64	addr;
+};
+
+static void andes_set_data_seg(void *data_seg, u32 length, u32 key, u64 addr)
+{
+	struct andes_data_seg *seg = data_seg;
+
+	seg->length = length;
+	seg->key = key;
+	seg->addr = addr;
+}
+
+struct andes_send_wqe_ctrl_seg {
+	__le32		msg_opcode:8;
+	__le32		with_immdt:1;
+	__le32		csum_en:2;
+	__le32		ds_data_num:5;
+	__le32		wqe_id:16;
+	__le32		msg_len;
+	union {
+		__le32		opcode_data;
+		struct {
+			u8		has_pph:1;
+			u8		so_type:1;
+			__le16		so_data_size:14;
+			u8:8;
+			u8		so_hdr_len:8;
+		};
+		struct {
+			__le16		desc_id;
+			__le16		is_last_wqe:1;
+			__le16		dst_qp_id:15;
+		};
+	};
+	__le32		se:1;
+	__le32		ce:1;
+	__le32:30;
+};
+
+static void andes_set_wqe_id(void *cseg, u32 wqe_id)
+{
+	u16 _wqe_id = wqe_id;
+
+	((struct andes_send_wqe_ctrl_seg *)cseg)->wqe_id = cpu_to_le16(_wqe_id);
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
+void xsc_init_hal(struct xsc_core_device *xdev, u32 device_id)
+{
+	switch (device_id) {
+	case XSC_MC_VF_DEV_ID:
+	case XSC_MF_HOST_VF_DEV_ID:
+	case XSC_MS_VF_DEV_ID:
+	case XSC_MV_HOST_VF_DEV_ID:
+		/* VFs expose the same BAR-relative window as a bar-compressed PF */
+		xdev->hal_regs = &andes_compressed_regs;
+		break;
+	default:
+		if (is_pf_bar_compressed(xdev))
+			xdev->hal_regs = &andes_compressed_regs;
+		else
+			xdev->hal_regs = &andes_pf_regs;
+		break;
+	}
+}
+
+void xsc_set_mtt_info(struct xsc_core_device *xdev)
+{
+	struct xsc_hw_reg *regs = xdev->hal_regs;
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
+	struct xsc_hw_reg *regs = xdev->hal_regs;
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
+	struct xsc_hw_reg *regs = xdev->hal_regs;
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
+	andes_ring_tx_doorbell(xdev, xdev->hal_regs, xdev->bar, sqn,
+			       next_pid, mdb);
+}
+EXPORT_SYMBOL_GPL(xsc_update_tx_db);
+
+void xsc_update_rx_db(struct xsc_core_device *xdev, u32 rqn, u32 next_pid)
+{
+	andes_ring_rx_doorbell(xdev->hal_regs, xdev->bar, rqn, next_pid);
+}
+EXPORT_SYMBOL_GPL(xsc_update_rx_db);
+
+void xsc_arm_cq(struct xsc_core_device *xdev, u32 cqn, u32 next_cid, u8 solicited)
+{
+	andes_update_cq_db(xdev->hal_regs, xdev->bar, cqn, next_cid, solicited);
+}
+EXPORT_SYMBOL_GPL(xsc_arm_cq);
+
+void xsc_update_cq_ci(struct xsc_core_device *xdev, u32 cqn, u32 next_cid)
+{
+	andes_set_cq_ci(xdev->hal_regs, xdev->bar, cqn, next_cid);
+}
+EXPORT_SYMBOL_GPL(xsc_update_cq_ci);
+
+void xsc_update_eq_ci(struct xsc_core_device *xdev, u32 eqn, u32 next_cid, u8 arm)
+{
+	andes_set_eq_ci(xdev->hal_regs, xdev->bar, eqn, next_cid, arm);
+}
+
+void xsc_update_cmdq_req_pid(struct xsc_core_device *xdev, u32 req_pid)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs->req_pid_addr, &req_pid);
+}
+
+void xsc_update_cmdq_rsp_cid(struct xsc_core_device *xdev, u32 rsp_cid)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs->rsp_cid_addr, &rsp_cid);
+}
+
+u32 xsc_get_cmdq_req_pid(struct xsc_core_device *xdev)
+{
+	u32 val;
+
+	xsc_read32(xdev->bar, xdev->hal_regs->req_pid_addr, &val, sizeof(val));
+	return val;
+}
+
+u32 xsc_get_cmdq_req_cid(struct xsc_core_device *xdev)
+{
+	u32 val;
+
+	xsc_read32(xdev->bar, xdev->hal_regs->req_cid_addr, &val, sizeof(val));
+	return val;
+}
+
+u32 xsc_get_cmdq_rsp_pid(struct xsc_core_device *xdev)
+{
+	u32 val;
+
+	xsc_read32(xdev->bar, xdev->hal_regs->rsp_pid_addr, &val, sizeof(val));
+	return val;
+}
+
+u32 xsc_get_cmdq_rsp_cid(struct xsc_core_device *xdev)
+{
+	u32 val;
+
+	xsc_read32(xdev->bar, xdev->hal_regs->rsp_cid_addr, &val, sizeof(val));
+	return val;
+}
+
+void xsc_set_cmdq_req_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 laddr)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs->req_buf_h_addr, &haddr);
+	xsc_write32(xdev->bar, xdev->hal_regs->req_buf_l_addr, &laddr);
+}
+
+void xsc_set_cmdq_rsp_buf_addr(struct xsc_core_device *xdev, u32 haddr, u32 laddr)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs->rsp_buf_h_addr, &haddr);
+	xsc_write32(xdev->bar, xdev->hal_regs->rsp_buf_l_addr, &laddr);
+}
+
+void xsc_set_cmdq_msix_vector(struct xsc_core_device *xdev, u32 vector)
+{
+	xsc_write32(xdev->bar, xdev->hal_regs->msix_vec_addr, &vector);
+}
+
+void xsc_check_cmdq_status(struct xsc_core_device *xdev)
+{
+	u32 status;
+
+	xsc_read32(xdev->bar, xdev->hal_regs->interrupt_stat_addr, &status,
+		   sizeof(status));
+	if (status) {
+		status = 0xf;
+		xsc_write32(xdev->bar, xdev->hal_regs->interrupt_stat_addr, &status);
+	}
+}
+
+int xsc_handle_cmdq_interrupt(struct xsc_core_device *xdev)
+{
+	union interrupt_stat {
+		struct {
+			u32	hw_read_req_err:1;
+			u32	hw_write_req_err:1;
+			u32	req_pid_err:1;
+			u32	rsp_cid_err:1;
+		};
+		u32	raw;
+	} stat;
+
+	int err = 0;
+	int retry = 0;
+
+	xsc_read32(xdev->bar, xdev->hal_regs->interrupt_stat_addr, &stat.raw,
+		   sizeof(stat.raw));
+	while (stat.raw != 0) {
+		err++;
+		if (stat.hw_read_req_err) {
+			retry = 1;
+			stat.hw_read_req_err = 0;
+			pci_err(xdev->pdev, "hw report read req from host failed!\n");
+		} else if (stat.hw_write_req_err) {
+			retry = 1;
+			stat.hw_write_req_err = 0;
+			pci_err(xdev->pdev, "hw report write req to fw failed!\n");
+		} else if (stat.req_pid_err) {
+			stat.req_pid_err = 0;
+			pci_err(xdev->pdev, "hw report unexpected req pid!\n");
+		} else if (stat.rsp_cid_err) {
+			stat.rsp_cid_err = 0;
+			pci_err(xdev->pdev, "hw report unexpected rsp cid!\n");
+		} else {
+			stat.raw = 0;
+			pci_err(xdev->pdev, "ignore unknown interrupt!\n");
+		}
+	}
+
+	if (retry) {
+		if (xdev->cmd.retry_cnt >= XSC_CMD_MAX_RETRY_CNT) {
+			pci_warn(xdev->pdev, "err handler have retried for %d times, stop retry\n",
+				 xdev->cmd.retry_cnt);
+			goto clear_err_int;
+		}
+		xsc_write32(xdev->bar, xdev->hal_regs->req_pid_addr,
+			    &xdev->cmd.cmd_pid);
+		xdev->cmd.retry_cnt++;
+	}
+
+clear_err_int:
+	if (err) {
+		stat.raw = 0xf;
+		xsc_write32(xdev->bar, xdev->hal_regs->interrupt_stat_addr, &stat.raw);
+	}
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
+	u64 max_mtt_mr_size = xdev->caps.max_mtt * PAGE_SIZE;
+
+	return min_t(u64, max_mpt_mr_size, max_mtt_mr_size);
+}
+EXPORT_SYMBOL_GPL(xsc_get_max_mr_size);
+
+void xsc_get_multidb_info(struct xsc_core_device *xdev, u32 *num, u32 *base)
+{
+	if (is_support_multi_doorbell(xdev)) {
+		*num = MDB_NUM;
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
index 000000000..5a3a7e27f
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/xsc_hal.h
@@ -0,0 +1,85 @@
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
+/* HAL entry points exported to the PCI/RDMA/ETH layers */
+void xsc_init_hal(struct xsc_core_device *xdev, u32 device_id);
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
index 734d48825..35dff401a 100644
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
 
+	xsc_init_hal(xdev, pdev->device);
+
 	return 0;
 
 err_io_unmap:
