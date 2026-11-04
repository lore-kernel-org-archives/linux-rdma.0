Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.27
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807834;
	b=w/BtXr18PA/rFunI9W/OoL9+Snw1LXHtsotKa26dWkohWxksPLZLa5VG1cdSNAKotB6+
	 HytGjTRgBeEroPeR2ZbGx09rsSX5vVwMi0qMo4nQLlSLmH09Gb0aUVMGspCAYJwCGvX7I
	 OCdFil6JGQZqBPMj12GucJHV1A80aaHWGs381kVoeODIWITdSNUuUx9d5zXCkYLgHaveX
	 2tksYEpzp07oP2u52DaL/Gfi1HkPkMYbC+E1U4E5b1lbyxeLhDj3Oa1PrB2FDBRes0INp
	 mh0U5uEqPN2qphDuOTZsQ8c6NbV1b5CXt5XjwaK857kLPEZF/71cIkDcpkXKf86wmDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807834;
	h=DMARC-Filter:DKIM-Signature:Subject:Mime-Version:To:In-Reply-To:Date:
	 References:X-Mailer:X-Lms-Return-Path:Content-Type:X-Original-From:
	 Content-Transfer-Encoding:Cc:From:Message-Id:Received;
	bh=fHA3j+utswZwhnnsvDReGD8wDU1II7ohSSmEzqODQFs=;
	b=llV44QGzwjvIKRdnT7OCeTPGvC5gttnOzLlyAvIHV0gaPUoDyyKX3Xd8pFxQtYoE5tWe
	 nt7xqvWRvPaGN+D+h9TJCEUIGi76YQ5ylUoFWOa29CZQwpVFDW29JXvrWfHCij29HdTB+
	 gDu4+HcLP9Dp34002Lanijn0gsq0+z0tUmujKKHJbI8pfgd9TG8W9QbBJ0DMMg4vsWCjU
	 IZZCB78oZNEwkYLHEeC9eM5UhFB2hPnwubLuWT84jmg8qqVNaPDEQ2n/hMwL8XTAgJFvL
	 /Q458YPmAun1kkeSaZxWw87VjiWtaCDBSdO2Z/O+B9y48TyzNh79TWGePz6TM9c4bBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b="Uo5dN//F";
	arc=none smtp.remote-ip=209.127.231.27
Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26E5606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 15:57:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C26E5606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=Uo5dN//F
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1793807822; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=fHA3j+utswZwhnnsvDReGD8wDU1II7ohSSmEzqODQFs=;
 b=Uo5dN//FNQ7QH030vO2YrPc1bdbfsdOmlMK2XNah5i7tbK9R9/7WwBZiNt54YOa2cvWEZ9
 WNeNOqfYZhIHJkWaNi0Da7VvdiCDztL0ctybuPUex/BYFhy/I1qi4TyFkQ6Rl7au00/Nmj
 cYVdyzJAZ8aKOx7oXxAYc+TKpojE0grNvHGbP2bLEMmGyqrRvi6/1upXFf5UR/CRnJeULV
 /UGuDZRacR8DcwYBHgZ4rcQyRzZsKwM/ZEVet2wR8Kp6ChY1XkISy32Dm7dNTgVLk/OkNS
 gSKVNV9fkhgVxmih1eFtqgCz+E7zd0nFNWHDskB1HeGUFP1ucThn1DCyvq2sRQ==
Subject: [PATCH v1 04/15] net/xsc: add the command queue
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
In-Reply-To: <20261104155650.37053-1-tianx@yunsilicon.com>
Date: Wed, 04 Nov 2026 23:57:00 +0800
References: <20261104155650.37053-1-tianx@yunsilicon.com>
X-Mailer: git-send-email 2.25.1
X-Lms-Return-Path: <lba+26aeb55cc+d77209+vger.kernel.org+tianx@yunsilicon.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
From: "Xin Tian" <tianx@yunsilicon.com>
Message-Id: <20261104155658.37053-5-tianx@yunsilicon.com>
Received: from sw-dev-sha252.yunsilicon.com ([180.152.18.210]) by smtp.feishu.cn with ESMTPS; Wed, 04 Nov 2026 23:57:00 +0800

Add the command queue used to talk to firmware.  Requests and
responses travel through a pair of DMA-coherent PAGE_SIZE rings of
32 64-byte descriptors, with a dma_pool of 512-byte protected blocks
backing mailbox payloads too large to fit inline.  A request fills
the inline descriptor fields, chains overflow mailboxes, then rings
the request doorbell with the advanced producer index.

Completion can run either from a polling kthread or from the
command-CQ interrupt; both match the response against the in-use
slot bitmap and complete the waiter.  Command slots are allocated
from a bitmap under a spinlock and the doorbell is rung under a
separate lock so that concurrent submitters do not corrupt the
producer index.  A ten second timeout moves the queue into a
timed-out state after which submitters fail fast rather than hang.
At init the current producer and consumer indices are read back from
hardware, so the queue resumes correctly after a kexec or FLR.

On top of the transport, add the initial firmware handshake:
validate the command interface version, query the HCA capabilities
into struct xsc_caps, query and activate the GUID, reset the
function, and cache the per-board GUID and message-opcode table in a
small table keyed by board serial number so the work is shared by
all PCI functions of the same physical card.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_cmdq.h |    1 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |    2 +-
 .../net/ethernet/yunsilicon/xsc/pci/cmdq.c    | 1244 +++++++++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c  |  316 +++++
 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h  |   18 +
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |   55 +
 6 files changed, 1635 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/hw.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
index c163bd179..256d6a2ce 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmdq.h
@@ -25,6 +25,7 @@ enum {
 
 enum {
 	XSC_MAX_COMMANDS		= 32,
+	XSC_CMDQ_INDEX_MASK		= XSC_MAX_COMMANDS - 1,
 	XSC_CMD_DATA_BLOCK_SIZE	= 512,
 	XSC_PCI_CMD_XPORT		= 7,
 };
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 81b65232e..656cdffa1 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o hal/andes_impl.o
+xsc_pci-y := main.o cmdq.o hw.o hal/andes_impl.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
new file mode 100644
index 000000000..c001b3122
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmdq.c
@@ -0,0 +1,1244 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/random.h>
+#include <linux/kthread.h>
+#include <linux/io-mapping.h>
+
+#include "common/xsc_cmd_api.h"
+#include "common/xsc_cmd.h"
+#include "common/xsc_core.h"
+#include "hal/xsc_hal.h"
+
+enum {
+	CMD_IF_REV = 3,
+};
+
+enum {
+	NUM_LONG_LISTS	  = 2,
+	NUM_MED_LISTS	  = 64,
+	LONG_LIST_SIZE	  = (2ULL * 1024 * 1024 * 1024 / PAGE_SIZE) * 8 + 16 +
+				XSC_CMD_DATA_BLOCK_SIZE,
+	MED_LIST_SIZE	  = 16 + XSC_CMD_DATA_BLOCK_SIZE,
+};
+
+enum {
+	XSC_CMD_DELIVERY_STAT_OK			= 0x0,
+	XSC_CMD_DELIVERY_STAT_SIGNAT_ERR		= 0x1,
+	XSC_CMD_DELIVERY_STAT_TOK_ERR			= 0x2,
+	XSC_CMD_DELIVERY_STAT_BAD_BLK_NUM_ERR		= 0x3,
+	XSC_CMD_DELIVERY_STAT_OUT_PTR_ALIGN_ERR		= 0x4,
+	XSC_CMD_DELIVERY_STAT_IN_PTR_ALIGN_ERR		= 0x5,
+	XSC_CMD_DELIVERY_STAT_FW_ERR			= 0x6,
+	XSC_CMD_DELIVERY_STAT_IN_LENGTH_ERR		= 0x7,
+	XSC_CMD_DELIVERY_STAT_OUT_LENGTH_ERR		= 0x8,
+	XSC_CMD_DELIVERY_STAT_RES_FLD_NOT_CLR_ERR	= 0x9,
+	XSC_CMD_DELIVERY_STAT_CMD_DESCR_ERR		= 0x10,
+};
+
+static struct xsc_cmd_work_ent *xsc_alloc_cmd(struct xsc_cmd *cmd,
+					      struct xsc_cmd_msg *in,
+					      struct xsc_rsp_msg *out)
+{
+	struct xsc_cmd_work_ent *ent;
+
+	ent = kzalloc_obj(*ent, GFP_KERNEL);
+	if (!ent)
+		return ERR_PTR(-ENOMEM);
+
+	ent->in		= in;
+	ent->out	= out;
+	ent->cmd	= cmd;
+
+	return ent;
+}
+
+static u8 xsc_alloc_token(struct xsc_cmd *cmd)
+{
+	u8 token;
+
+	spin_lock(&cmd->token_lock);
+	token = cmd->token++ % 255 + 1;
+	spin_unlock(&cmd->token_lock);
+
+	return token;
+}
+
+static int xsc_alloc_ent(struct xsc_cmd *cmd)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	ret = find_first_bit(&cmd->cmd_entry_mask, cmd->max_reg_cmds);
+	if (ret < cmd->max_reg_cmds)
+		clear_bit(ret, &cmd->cmd_entry_mask);
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
+
+	return ret < cmd->max_reg_cmds ? ret : -ENOSPC;
+}
+
+static void xsc_free_ent(struct xsc_cmd *cmd, int idx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	set_bit(idx, &cmd->cmd_entry_mask);
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
+}
+
+static struct xsc_cmd_layout *xsc_get_inst(struct xsc_cmd *cmd, int idx)
+{
+	return cmd->cmd_buf + (idx << cmd->log_stride);
+}
+
+static struct xsc_rsp_layout *xsc_get_cq_inst(struct xsc_cmd *cmd, int idx)
+{
+	return cmd->cq_buf + (idx << cmd->log_stride);
+}
+
+static u8 xsc_rsp_owner_bit(struct xsc_rsp_layout *rsp)
+{
+	return !!(rsp->type_owner & XSC_CMD_OWNER_BIT);
+}
+
+static u8 xsc_xor8_buf(void *buf, int len)
+{
+	u8 *ptr = buf;
+	u8 sum = 0;
+	int i;
+
+	for (i = 0; i < len; i++)
+		sum ^= ptr[i];
+
+	return sum;
+}
+
+static int xsc_verify_block_sig(struct xsc_cmd_prot_block *block)
+{
+	/* rsvd0 was set to 0xFF by fw */
+	if (xsc_xor8_buf(block->rsvd0,
+			 sizeof(*block) - sizeof(block->data) - 1) != 0xff)
+		return -EINVAL;
+
+	if (xsc_xor8_buf(block, sizeof(*block)) != 0xff)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void xsc_calc_block_sig(struct xsc_cmd_prot_block *block, u8 token)
+{
+	block->token = token;
+	block->ctrl_sig = ~xsc_xor8_buf(block->rsvd0,
+				    sizeof(*block) - sizeof(block->data) - 2);
+	block->sig = ~xsc_xor8_buf(block, sizeof(*block) - 1);
+}
+
+static void xsc_calc_chain_sig(struct xsc_cmd_mailbox *head, u8 token)
+{
+	struct xsc_cmd_mailbox *next = head;
+
+	while (next) {
+		xsc_calc_block_sig(next->buf, token);
+		next = next->next;
+	}
+}
+
+static void xsc_set_signature(struct xsc_cmd_work_ent *ent)
+{
+	ent->lay->sig = ~xsc_xor8_buf(ent->lay, sizeof(*ent->lay));
+	xsc_calc_chain_sig(ent->in->next, ent->token);
+	xsc_calc_chain_sig(ent->out->next, ent->token);
+}
+
+static int xsc_verify_signature(struct xsc_cmd_work_ent *ent)
+{
+	struct xsc_cmd_mailbox *next = ent->out->next;
+	int err;
+	u8 sig;
+
+	sig = xsc_xor8_buf(ent->rsp_lay, sizeof(*ent->rsp_lay));
+	if (sig != 0xff)
+		return -EINVAL;
+
+	while (next) {
+		err = xsc_verify_block_sig(next->buf);
+		if (err)
+			return err;
+
+		next = next->next;
+	}
+
+	return 0;
+}
+
+static const char *xsc_command_str(int command)
+{
+	switch (command) {
+	case XSC_CMD_OP_QUERY_HCA_CAP:
+		return "QUERY_HCA_CAP";
+
+	case XSC_CMD_OP_QUERY_CMDQ_VERSION:
+		return "QUERY_CMDQ_VERSION";
+
+	case XSC_CMD_OP_FUNCTION_RESET:
+		return "FUNCTION_RESET";
+
+	case XSC_CMD_OP_DUMMY:
+		return "DUMMY_CMD";
+
+	case XSC_CMD_OP_CREATE_EQ:
+		return "CREATE_EQ";
+
+	case XSC_CMD_OP_DESTROY_EQ:
+		return "DESTROY_EQ";
+
+	case XSC_CMD_OP_CREATE_CQ:
+		return "CREATE_CQ";
+
+	case XSC_CMD_OP_DESTROY_CQ:
+		return "DESTROY_CQ";
+
+	case XSC_CMD_OP_CREATE_QP:
+		return "CREATE_QP";
+
+	case XSC_CMD_OP_DESTROY_QP:
+		return "DESTROY_QP";
+
+	case XSC_CMD_OP_RST2INIT_QP:
+		return "RST2INIT_QP";
+
+	case XSC_CMD_OP_INIT2RTR_QP:
+		return "INIT2RTR_QP";
+
+	case XSC_CMD_OP_RTR2RTS_QP:
+		return "RTR2RTS_QP";
+
+	case XSC_CMD_OP_RTS2RTS_QP:
+		return "RTS2RTS_QP";
+
+	case XSC_CMD_OP_SQERR2RTS_QP:
+		return "SQERR2RTS_QP";
+
+	case XSC_CMD_OP_2ERR_QP:
+		return "2ERR_QP";
+
+	case XSC_CMD_OP_RTS2SQD_QP:
+		return "RTS2SQD_QP";
+
+	case XSC_CMD_OP_SQD2RTS_QP:
+		return "SQD2RTS_QP";
+
+	case XSC_CMD_OP_2RST_QP:
+		return "2RST_QP";
+
+	case XSC_CMD_OP_INIT2INIT_QP:
+		return "INIT2INIT_QP";
+
+	case XSC_CMD_OP_MODIFY_RAW_QP:
+		return "MODIFY_RAW_QP";
+
+	case XSC_CMD_OP_ENABLE_NIC_HCA:
+		return "ENABLE_NIC_HCA";
+
+	case XSC_CMD_OP_DISABLE_NIC_HCA:
+		return "DISABLE_NIC_HCA";
+
+	case XSC_CMD_OP_QUERY_VPORT_STATE:
+		return "QUERY_VPORT_STATE";
+
+	case XSC_CMD_OP_QUERY_EVENT_TYPE:
+		return "QUERY_EVENT_TYPE";
+
+	case XSC_CMD_OP_ENABLE_MSIX:
+		return "ENABLE_MSIX";
+
+	case XSC_CMD_OP_SET_MTU:
+		return "SET_MTU";
+
+	case XSC_CMD_OP_QUERY_ETH_MAC:
+		return "QUERY_ETH_MAC";
+
+	default: return "unknown command opcode";
+	}
+}
+
+static void cmd_work_handler(struct work_struct *work)
+{
+	struct xsc_cmd_work_ent *ent;
+	struct xsc_core_device *xdev;
+	struct xsc_cmd_layout *lay;
+	struct semaphore *sem;
+	struct xsc_cmd *cmd;
+	unsigned long flags;
+
+	ent = container_of(work, struct xsc_cmd_work_ent, work);
+	cmd = ent->cmd;
+	xdev = container_of(cmd, struct xsc_core_device, cmd);
+	sem = &cmd->sem;
+	down(sem);
+	ent->idx = xsc_alloc_ent(cmd);
+	if (ent->idx < 0) {
+		pci_err(xdev->pdev, "failed to allocate command entry\n");
+		ent->ret = -ENOMEM;
+		complete(&ent->done);
+		up(sem);
+		return;
+	}
+
+	ent->token = xsc_alloc_token(cmd);
+	cmd->ent_arr[ent->idx] = ent;
+
+	spin_lock_irqsave(&cmd->doorbell_lock, flags);
+	lay = xsc_get_inst(cmd, cmd->cmd_pid);
+	ent->lay = lay;
+	memset(lay, 0, sizeof(*lay));
+	memcpy(lay->in, ent->in->first.data, sizeof(lay->in));
+	if (ent->in->next)
+		lay->in_ptr = cpu_to_be64(ent->in->next->dma);
+	lay->inlen = cpu_to_be32(ent->in->len);
+	if (ent->out->next)
+		lay->out_ptr = cpu_to_be64(ent->out->next->dma);
+	lay->outlen = cpu_to_be32(ent->out->len);
+	lay->type_owner = FIELD_PREP(XSC_CMD_TYPE_MASK, XSC_PCI_CMD_XPORT);
+	lay->token = ent->token;
+	lay->idx = ent->idx;
+	if (!cmd->checksum_disabled)
+		xsc_set_signature(ent);
+	else
+		lay->sig = 0xff;
+
+	/* ring doorbell after the descriptor is valid */
+	wmb();
+
+	cmd->cmd_pid = (cmd->cmd_pid + 1) % (1 << cmd->log_sz);
+	xsc_update_cmdq_req_pid(xdev, cmd->cmd_pid);
+	spin_unlock_irqrestore(&cmd->doorbell_lock, flags);
+}
+
+static const char *xsc_deliv_status_to_str(u8 status)
+{
+	switch (status) {
+	case XSC_CMD_DELIVERY_STAT_OK:
+		return "no errors";
+	case XSC_CMD_DELIVERY_STAT_SIGNAT_ERR:
+		return "signature error";
+	case XSC_CMD_DELIVERY_STAT_TOK_ERR:
+		return "token error";
+	case XSC_CMD_DELIVERY_STAT_BAD_BLK_NUM_ERR:
+		return "bad block number";
+	case XSC_CMD_DELIVERY_STAT_OUT_PTR_ALIGN_ERR:
+		return "output pointer not aligned to block size";
+	case XSC_CMD_DELIVERY_STAT_IN_PTR_ALIGN_ERR:
+		return "input pointer not aligned to block size";
+	case XSC_CMD_DELIVERY_STAT_FW_ERR:
+		return "firmware internal error";
+	case XSC_CMD_DELIVERY_STAT_IN_LENGTH_ERR:
+		return "command input length error";
+	case XSC_CMD_DELIVERY_STAT_OUT_LENGTH_ERR:
+		return "command output length error";
+	case XSC_CMD_DELIVERY_STAT_RES_FLD_NOT_CLR_ERR:
+		return "reserved fields not cleared";
+	case XSC_CMD_DELIVERY_STAT_CMD_DESCR_ERR:
+		return "bad command descriptor type";
+	default:
+		return "unknown status code";
+	}
+}
+
+static u16 xsc_msg_to_opcode(struct xsc_cmd_msg *in)
+{
+	struct xsc_inbox_hdr *hdr = (struct xsc_inbox_hdr *)(in->first.data);
+
+	return be16_to_cpu(hdr->opcode);
+}
+
+static int xsc_wait_func(struct xsc_core_device *xdev,
+			 struct xsc_cmd_work_ent *ent)
+{
+	unsigned long timeout = msecs_to_jiffies(XSC_CMD_TIMEOUT_MSEC);
+	struct xsc_cmd *cmd = &xdev->cmd;
+	int err;
+
+	if (!wait_for_completion_timeout(&ent->done, timeout))
+		err = -ETIMEDOUT;
+	else
+		err = ent->ret;
+
+	if (err == -ETIMEDOUT) {
+		cmd->cmd_status = XSC_CMD_STATUS_TIMEDOUT;
+		pci_err(xdev->pdev, "wait for %s(0x%x) response timeout!\n",
+			xsc_command_str(xsc_msg_to_opcode(ent->in)),
+			xsc_msg_to_opcode(ent->in));
+	} else if (err) {
+		pci_err(xdev->pdev, "err %d, delivery status %s(%d)\n", err,
+			xsc_deliv_status_to_str(ent->status), ent->status);
+	}
+
+	return err;
+}
+
+/*  Notes:
+ *    1. Callback functions may not sleep
+ *    2. page queue commands do not support asynchrous completion
+ */
+static int xsc_cmd_invoke(struct xsc_core_device *xdev, struct xsc_cmd_msg *in,
+			  struct xsc_rsp_msg *out, u8 *status)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_cmd_work_ent *ent;
+	int err = 0;
+
+	ent = xsc_alloc_cmd(cmd, in, out);
+	if (IS_ERR(ent))
+		return PTR_ERR(ent);
+
+	init_completion(&ent->done);
+	INIT_WORK(&ent->work, cmd_work_handler);
+	if (!queue_work(cmd->wq, &ent->work)) {
+		pci_err(xdev->pdev, "failed to queue work\n");
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	err = xsc_wait_func(xdev, ent);
+	if (err == -ETIMEDOUT)
+		/* leave the entry for the completion handler; the driver
+		 * is marked timed out and rejects all further commands
+		 */
+		return err;
+
+	*status = ent->status;
+	kfree(ent);
+
+	return err;
+
+err_free:
+	kfree(ent);
+	return err;
+}
+
+static int xsc_copy_to_cmd_msg(struct xsc_cmd_msg *to, void *from,
+			       unsigned int size)
+{
+	struct xsc_cmd_prot_block *block;
+	struct xsc_cmd_mailbox *next;
+	unsigned int copy;
+
+	if (!to || !from)
+		return -ENOMEM;
+
+	copy = min(size, sizeof(to->first.data));
+	memcpy(to->first.data, from, copy);
+	size -= copy;
+	from += copy;
+
+	next = to->next;
+	while (size) {
+		if (!next) {
+			WARN_ONCE(1, "Mail box not enough\n");
+			return -ENOMEM;
+		}
+
+		copy = min(size, XSC_CMD_DATA_BLOCK_SIZE);
+		block = next->buf;
+		memcpy(block->data, from, copy);
+		block->owner_status = 0;
+		from += copy;
+		size -= copy;
+		next = next->next;
+	}
+
+	return 0;
+}
+
+static int xsc_copy_from_rsp_msg(void *to, struct xsc_rsp_msg *from,
+				 unsigned int size)
+{
+	struct xsc_cmd_prot_block *block;
+	struct xsc_cmd_mailbox *next;
+	unsigned int copy;
+
+	if (!to || !from)
+		return -ENOMEM;
+
+	copy = min(size, sizeof(from->first.data));
+	memcpy(to, from->first.data, copy);
+	size -= copy;
+	to += copy;
+
+	next = from->next;
+	while (size) {
+		if (!next) {
+			WARN_ONCE(1, "Mail too short\n");
+			return -ENOMEM;
+		}
+
+		copy = min(size, XSC_CMD_DATA_BLOCK_SIZE);
+		block = next->buf;
+		if (!block->owner_status)
+			return -EIO;
+
+		memcpy(to, block->data, copy);
+		to += copy;
+		size -= copy;
+		next = next->next;
+	}
+
+	return 0;
+}
+
+static struct xsc_cmd_mailbox *xsc_alloc_cmd_box(struct xsc_core_device *xdev,
+						 gfp_t flags)
+{
+	struct xsc_cmd_mailbox *mailbox;
+
+	mailbox = kmalloc_obj(*mailbox, flags);
+	if (!mailbox)
+		return ERR_PTR(-ENOMEM);
+
+	mailbox->buf = dma_pool_zalloc(xdev->cmd.pool, flags,
+				       &mailbox->dma);
+	if (!mailbox->buf) {
+		kfree(mailbox);
+		return ERR_PTR(-ENOMEM);
+	}
+	mailbox->next = NULL;
+
+	return mailbox;
+}
+
+static void xsc_free_cmd_box(struct xsc_core_device *xdev,
+			     struct xsc_cmd_mailbox *mailbox)
+{
+	dma_pool_free(xdev->cmd.pool, mailbox->buf, mailbox->dma);
+
+	kfree(mailbox);
+}
+
+static struct xsc_cmd_msg *xsc_alloc_cmd_msg(struct xsc_core_device *xdev,
+					     gfp_t flags, unsigned int size)
+{
+	struct xsc_cmd_mailbox *tmp, *head = NULL;
+	struct xsc_cmd_prot_block *block;
+	struct xsc_cmd_msg *msg;
+	int blen;
+	int err;
+	int n;
+	int i;
+
+	msg = kzalloc_obj(*msg, GFP_KERNEL);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+
+	blen = size - min(sizeof(msg->first.data), size);
+	n = (blen + XSC_CMD_DATA_BLOCK_SIZE - 1) / XSC_CMD_DATA_BLOCK_SIZE;
+
+	for (i = 0; i < n; i++) {
+		tmp = xsc_alloc_cmd_box(xdev, flags);
+		if (IS_ERR(tmp)) {
+			pci_err(xdev->pdev, "failed allocating block\n");
+			err = PTR_ERR(tmp);
+			goto err_free;
+		}
+
+		block = tmp->buf;
+		tmp->next = head;
+		block->next = cpu_to_be64(tmp->next ? tmp->next->dma : 0);
+		block->block_num = cpu_to_be32(n - i - 1);
+		head = tmp;
+	}
+	msg->next = head;
+	msg->len = size;
+	return msg;
+
+err_free:
+	while (head) {
+		tmp = head->next;
+		xsc_free_cmd_box(xdev, head);
+		head = tmp;
+	}
+	kfree(msg);
+
+	return ERR_PTR(err);
+}
+
+static void xsc_free_cmd_msg(struct xsc_core_device *xdev,
+			     struct xsc_cmd_msg *msg)
+{
+	struct xsc_cmd_mailbox *head = msg->next;
+	struct xsc_cmd_mailbox *next;
+
+	while (head) {
+		next = head->next;
+		xsc_free_cmd_box(xdev, head);
+		head = next;
+	}
+	kfree(msg);
+}
+
+static struct xsc_rsp_msg *xsc_alloc_rsp_msg(struct xsc_core_device *xdev,
+					     gfp_t flags, unsigned int size)
+{
+	struct xsc_cmd_mailbox *tmp, *head = NULL;
+	struct xsc_cmd_prot_block *block;
+	struct xsc_rsp_msg *msg;
+	int blen;
+	int err;
+	int n;
+	int i;
+
+	msg = kzalloc_obj(*msg, GFP_KERNEL);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+
+	blen = size - min_t(int, sizeof(msg->first.data), size);
+	n = (blen + XSC_CMD_DATA_BLOCK_SIZE - 1) / XSC_CMD_DATA_BLOCK_SIZE;
+
+	for (i = 0; i < n; i++) {
+		tmp = xsc_alloc_cmd_box(xdev, flags);
+		if (IS_ERR(tmp)) {
+			pci_err(xdev->pdev, "failed allocating block\n");
+			err = PTR_ERR(tmp);
+			goto err_free;
+		}
+
+		block = tmp->buf;
+		tmp->next = head;
+		block->next = cpu_to_be64(tmp->next ? tmp->next->dma : 0);
+		block->block_num = cpu_to_be32(n - i - 1);
+		head = tmp;
+	}
+	msg->next = head;
+	msg->len = size;
+	return msg;
+
+err_free:
+	while (head) {
+		tmp = head->next;
+		xsc_free_cmd_box(xdev, head);
+		head = tmp;
+	}
+	kfree(msg);
+
+	return ERR_PTR(err);
+}
+
+static void xsc_free_rsp_msg(struct xsc_core_device *xdev,
+			     struct xsc_rsp_msg *msg)
+{
+	struct xsc_cmd_mailbox *head = msg->next;
+	struct xsc_cmd_mailbox *next;
+
+	while (head) {
+		next = head->next;
+		xsc_free_cmd_box(xdev, head);
+		head = next;
+	}
+	kfree(msg);
+}
+
+static void xsc_set_wqname(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+
+	snprintf(cmd->wq_name, sizeof(cmd->wq_name), "xsc_cmd_%s",
+		 dev_name(&xdev->pdev->dev));
+}
+
+void xsc_cmd_use_events(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	int i;
+
+	/* flush first: cmd_work_handler() takes a semaphore permit, so
+	 * flushing after all permits are held would deadlock against a
+	 * just-queued work item
+	 */
+	flush_workqueue(cmd->wq);
+
+	/* keep the cmdq interrupt out while the polling kthread is still
+	 * draining the queue
+	 */
+	disable_irq(cmd->irqn);
+
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		down(&cmd->sem);
+
+	cmd->mode = XSC_CMD_MODE_EVENTS;
+
+	while (cmd->cmd_pid != cmd->cq_cid)
+		msleep(20);
+	kthread_stop(cmd->cq_task);
+	cmd->cq_task = NULL;
+
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		up(&cmd->sem);
+
+	enable_irq(cmd->irqn);
+}
+
+static int xsc_cmd_cq_polling(void *data);
+void xsc_cmd_use_polling(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	int i;
+
+	flush_workqueue(cmd->wq);
+
+	disable_irq(cmd->irqn);
+
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		down(&cmd->sem);
+
+	cmd->mode = XSC_CMD_MODE_POLLING;
+	cmd->cq_task = kthread_create(xsc_cmd_cq_polling,
+				      (void *)xdev,
+				      "xsc_cmd_cq_polling");
+	if (!IS_ERR(cmd->cq_task))
+		wake_up_process(cmd->cq_task);
+
+	for (i = 0; i < cmd->max_reg_cmds; i++)
+		up(&cmd->sem);
+
+	enable_irq(cmd->irqn);
+}
+
+int xsc_cmd_status_to_err(struct xsc_outbox_hdr *hdr)
+{
+	switch (hdr->status) {
+	case XSC_CMD_STATUS_OK:
+		return 0;
+	case XSC_CMD_STATUS_FAIL:
+		return -EIO;
+	case XSC_CMD_STATUS_NOT_SUPPORTED:
+		/* sole -EOPNOTSUPP source; CREATE_CQ_EX compat keys on it */
+		return -EOPNOTSUPP;
+	case XSC_CMD_STATUS_BAD_PARAM:
+		return -EINVAL;
+	case XSC_CMD_STATUS_INVAL_RES:
+	case XSC_CMD_STATUS_INVAL_DATA:
+	case XSC_CMD_STATUS_NO_RES:
+	case XSC_CMD_STATUS_NO_MPT_RES:
+	case XSC_CMD_STATUS_NO_MTT_RES:
+	case XSC_CMD_STATUS_NO_EQN_RES:
+	case XSC_CMD_STATUS_NO_EQ_PA_RES:
+	case XSC_CMD_STATUS_NO_CQN_RES:
+	case XSC_CMD_STATUS_NO_CQ_PA_RES:
+	case XSC_CMD_STATUS_NO_QPN_RES:
+	case XSC_CMD_STATUS_NO_QP_PA_RES:
+	case XSC_CMD_STATUS_NO_PDN_RES:
+	case XSC_CMD_STATUS_BAD_INBUF:
+	case XSC_CMD_STATUS_BAD_OUTBUF:
+		return -EIO;
+	case XSC_CMD_STATUS_BUSY:
+	case XSC_CMD_STATUS_QP_FLUSH_BUSY:
+		return -EBUSY;
+	case XSC_CMD_STATUS_QP_FLUSH_PENDING:
+		return -EAGAIN;
+	case XSC_CMD_STATUS_NOT_FOUND:
+	case XSC_CMD_STATUS_INVAL_FUNC:
+		return -ENODEV;
+	default:
+		return -EIO;
+	}
+}
+
+static struct xsc_cmd_msg *xsc_alloc_msg(struct xsc_core_device *xdev,
+					 unsigned int in_size)
+{
+	struct xsc_cmd_msg *msg = ERR_PTR(-ENOMEM);
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct cache_ent *ent = NULL;
+
+	if (in_size > MED_LIST_SIZE && in_size <= LONG_LIST_SIZE)
+		ent = &cmd->cache.large;
+	else if (in_size > 16 && in_size <= MED_LIST_SIZE)
+		ent = &cmd->cache.med;
+
+	if (ent) {
+		spin_lock(&ent->lock);
+		if (!list_empty(&ent->head)) {
+			msg = list_entry(ent->head.next, typeof(*msg), list);
+			/* For cached lists, we must explicitly state what is
+			 * the real size
+			 */
+			msg->len = in_size;
+			list_del(&msg->list);
+		}
+		spin_unlock(&ent->lock);
+	}
+
+	if (IS_ERR(msg))
+		msg = xsc_alloc_cmd_msg(xdev, GFP_KERNEL, in_size);
+
+	return msg;
+}
+
+static void xsc_free_msg(struct xsc_core_device *xdev, struct xsc_cmd_msg *msg)
+{
+	if (msg->cache) {
+		spin_lock(&msg->cache->lock);
+		list_add_tail(&msg->list, &msg->cache->head);
+		spin_unlock(&msg->cache->lock);
+	} else {
+		xsc_free_cmd_msg(xdev, msg);
+	}
+}
+
+static int _xsc_cmd_exec(struct xsc_core_device *xdev,
+			 void *in, unsigned int in_size,
+			 void *out, unsigned int out_size)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_rsp_msg *outb;
+	struct xsc_cmd_msg *inb;
+	u8 status = 0;
+	int err;
+
+	if (cmd->cmd_status == XSC_CMD_STATUS_TIMEDOUT)
+		return -ETIMEDOUT;
+
+	inb = xsc_alloc_msg(xdev, in_size);
+	if (IS_ERR(inb)) {
+		err = PTR_ERR(inb);
+		return err;
+	}
+
+	err = xsc_copy_to_cmd_msg(inb, in, in_size);
+	if (err) {
+		pci_err(xdev->pdev, "copy to cmd_msg err %d\n", err);
+		goto err_free_msg;
+	}
+
+	outb = xsc_alloc_rsp_msg(xdev, GFP_KERNEL, out_size);
+	if (IS_ERR(outb)) {
+		err = PTR_ERR(outb);
+		goto err_free_msg;
+	}
+
+	err = xsc_cmd_invoke(xdev, inb, outb, &status);
+	if (err == -ETIMEDOUT)
+		/* the entry stays registered for the completion handler
+		 * and keeps its mailboxes
+		 */
+		return err;
+
+	if (err)
+		goto err_free_rsp;
+
+	if (status) {
+		pci_err(xdev->pdev, "opcode:%#x, err %d, status %d\n",
+			xsc_msg_to_opcode(inb), err, status);
+		xsc_copy_from_rsp_msg(out, outb, out_size);
+		err = -EREMOTEIO;
+		goto err_free_rsp;
+	}
+
+	err = xsc_copy_from_rsp_msg(out, outb, out_size);
+
+err_free_rsp:
+	xsc_free_rsp_msg(xdev, outb);
+
+err_free_msg:
+	xsc_free_msg(xdev, inb);
+	return err;
+}
+
+int xsc_cmd_exec(struct xsc_core_device *xdev,
+		 void *in, unsigned int in_size,
+		 void *out, unsigned int out_size)
+{
+	int err;
+
+	err = _xsc_cmd_exec(xdev, in, in_size, out, out_size);
+	if (err == -EREMOTEIO)
+		err = xsc_cmd_status_to_err((struct xsc_outbox_hdr *)out);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xsc_cmd_exec);
+
+static void xsc_destroy_msg_cache(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_cmd_msg *msg;
+	struct xsc_cmd_msg *n;
+
+	list_for_each_entry_safe(msg, n, &cmd->cache.large.head, list) {
+		list_del(&msg->list);
+		xsc_free_cmd_msg(xdev, msg);
+	}
+
+	list_for_each_entry_safe(msg, n, &cmd->cache.med.head, list) {
+		list_del(&msg->list);
+		xsc_free_cmd_msg(xdev, msg);
+	}
+}
+
+static int xsc_create_msg_cache(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_cmd_msg *msg;
+	int err;
+	int i;
+
+	spin_lock_init(&cmd->cache.large.lock);
+	INIT_LIST_HEAD(&cmd->cache.large.head);
+	spin_lock_init(&cmd->cache.med.lock);
+	INIT_LIST_HEAD(&cmd->cache.med.head);
+
+	for (i = 0; i < NUM_LONG_LISTS; i++) {
+		msg = xsc_alloc_cmd_msg(xdev, GFP_KERNEL, LONG_LIST_SIZE);
+		if (IS_ERR(msg)) {
+			err = PTR_ERR(msg);
+			goto err_destroy;
+		}
+		msg->cache = &cmd->cache.large;
+		list_add_tail(&msg->list, &cmd->cache.large.head);
+	}
+
+	for (i = 0; i < NUM_MED_LISTS; i++) {
+		msg = xsc_alloc_cmd_msg(xdev, GFP_KERNEL, MED_LIST_SIZE);
+		if (IS_ERR(msg)) {
+			err = PTR_ERR(msg);
+			goto err_destroy;
+		}
+		msg->cache = &cmd->cache.med;
+		list_add_tail(&msg->list, &cmd->cache.med.head);
+	}
+
+	return 0;
+
+err_destroy:
+	xsc_destroy_msg_cache(xdev);
+	return err;
+}
+
+static void xsc_cmd_comp_handler(struct xsc_core_device *xdev, u8 idx,
+				 struct xsc_rsp_layout *rsp)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_cmd_work_ent *ent;
+
+	if (idx >= cmd->max_reg_cmds || (cmd->cmd_entry_mask & BIT(idx))) {
+		pci_err(xdev->pdev, "idx[%d] exceed max cmds, or has no relative request.\n",
+			idx);
+		return;
+	}
+	ent = cmd->ent_arr[idx];
+	ent->rsp_lay = rsp;
+
+	memcpy(ent->out->first.data,
+	       ent->rsp_lay->out,
+	       sizeof(ent->rsp_lay->out));
+	if (!cmd->checksum_disabled)
+		ent->ret = xsc_verify_signature(ent);
+	else
+		ent->ret = 0;
+	ent->status = ((struct xsc_outbox_hdr *)ent->out->first.data)->status;
+	cmd->retry_cnt = 0;
+
+	xsc_free_ent(cmd, ent->idx);
+	complete(&ent->done);
+	up(&cmd->sem);
+}
+
+static int xsc_cmd_cq_polling(void *data)
+{
+	struct xsc_core_device *xdev = data;
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_rsp_layout *rsp;
+	u32 cq_pid;
+
+	while (!kthread_should_stop()) {
+		if (need_resched())
+			schedule();
+		cq_pid = xsc_get_cmdq_rsp_pid(xdev);
+		if (cmd->cq_cid == cq_pid) {
+			usleep_range(1000, 2000);
+			continue;
+		}
+
+		rsp = xsc_get_cq_inst(cmd, cmd->cq_cid);
+		if (!cmd->ownerbit_learned) {
+			cmd->ownerbit_learned = 1;
+			cmd->owner_bit = xsc_rsp_owner_bit(rsp);
+		}
+		if (cmd->owner_bit != xsc_rsp_owner_bit(rsp)) {
+			dev_err_ratelimited(&xdev->pdev->dev,
+				"hw update cq doorbell but buf not ready %u %u\n",
+				cmd->cq_cid, cq_pid);
+			msleep(20);
+			continue;
+		}
+
+		/* the hardware updates the payload after flipping the
+		 * owner bit; order the payload reads behind the check
+		 */
+		dma_rmb();
+
+		xsc_cmd_comp_handler(xdev, rsp->idx, rsp);
+
+		cmd->cq_cid = (cmd->cq_cid + 1) % (1 << cmd->log_sz);
+
+		xsc_update_cmdq_rsp_cid(xdev, cmd->cq_cid);
+		if (cmd->cq_cid == 0)
+			cmd->owner_bit = !cmd->owner_bit;
+	}
+
+	return 0;
+}
+
+int xsc_cmd_err_handler(struct xsc_core_device *xdev)
+{
+	return xsc_handle_cmdq_interrupt(xdev);
+}
+
+void xsc_cmd_resp_handler(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+	struct xsc_rsp_layout *rsp;
+	const int budget = 32;
+	int count = 0;
+	u32 cq_pid;
+
+	while (count < budget) {
+		cq_pid = xsc_get_cmdq_rsp_pid(xdev);
+		if (cq_pid == cmd->cq_cid)
+			return;
+
+		rsp = xsc_get_cq_inst(cmd, cmd->cq_cid);
+		if (!cmd->ownerbit_learned) {
+			cmd->ownerbit_learned = 1;
+			cmd->owner_bit = xsc_rsp_owner_bit(rsp);
+		}
+		if (cmd->owner_bit != xsc_rsp_owner_bit(rsp)) {
+			pci_err(xdev->pdev, "hw update cq doorbell but buf not ready %u %u\n",
+				cmd->cq_cid, cq_pid);
+			return;
+		}
+
+		dma_rmb();
+
+		xsc_cmd_comp_handler(xdev, rsp->idx, rsp);
+
+		cmd->cq_cid = (cmd->cq_cid + 1) % (1 << cmd->log_sz);
+		xsc_update_cmdq_rsp_cid(xdev, cmd->cq_cid);
+		if (cmd->cq_cid == 0)
+			cmd->owner_bit = !cmd->owner_bit;
+
+		count++;
+	}
+}
+
+static void xsc_cmd_handle_rsp_before_reload
+(struct xsc_cmd *cmd, struct xsc_core_device *xdev)
+{
+	u32 rsp_pid, rsp_cid;
+
+	rsp_pid = xsc_get_cmdq_rsp_pid(xdev) & XSC_CMDQ_INDEX_MASK;
+	rsp_cid = xsc_get_cmdq_rsp_cid(xdev) & XSC_CMDQ_INDEX_MASK;
+	if (rsp_pid == rsp_cid)
+		return;
+
+	cmd->cq_cid = rsp_pid;
+
+	xsc_update_cmdq_rsp_cid(xdev, cmd->cq_cid);
+}
+
+int xsc_cmd_init(struct xsc_core_device *xdev)
+{
+	unsigned int size = sizeof(struct xsc_cmd_prot_block);
+	int align = roundup_pow_of_two(size);
+	struct xsc_cmd *cmd = &xdev->cmd;
+	u32 cmd_h, cmd_l;
+	int err;
+
+	cmd->pool = dma_pool_create("xsc_cmd",
+				    &xdev->pdev->dev,
+				    size, align, 0);
+	if (!cmd->pool)
+		return -ENOMEM;
+
+	cmd->cmd_buf = dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE,
+					  &cmd->dma, GFP_KERNEL);
+	if (!cmd->cmd_buf) {
+		err = -ENOMEM;
+		goto err_free_pool;
+	}
+	cmd->cq_buf = dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE,
+					 &cmd->cq_dma, GFP_KERNEL);
+	if (!cmd->cq_buf) {
+		err = -ENOMEM;
+		goto err_free_cmd;
+	}
+
+	memset(cmd->cmd_buf, 0, PAGE_SIZE);
+	memset(cmd->cq_buf, 0, PAGE_SIZE);
+
+	cmd->cmd_pid = xsc_get_cmdq_req_pid(xdev) & XSC_CMDQ_INDEX_MASK;
+	cmd->cq_cid = xsc_get_cmdq_rsp_cid(xdev) & XSC_CMDQ_INDEX_MASK;
+	cmd->ownerbit_learned = 0;
+
+	xsc_cmd_handle_rsp_before_reload(cmd, xdev);
+
+#define ELEMENT_SIZE_LOG	6 /* 64B */
+#define Q_DEPTH_LOG		5 /* 32 */
+
+	cmd->log_sz = Q_DEPTH_LOG;
+	cmd->log_stride = ELEMENT_SIZE_LOG;
+
+	if (1 << cmd->log_sz > XSC_MAX_COMMANDS) {
+		dev_err(&xdev->pdev->dev, "firmware reports too many outstanding commands %d\n",
+			1 << cmd->log_sz);
+		err = -EINVAL;
+		goto err_free_cq;
+	}
+
+	if (cmd->log_sz + cmd->log_stride > PAGE_SHIFT) {
+		dev_err(&xdev->pdev->dev, "command queue size overflow\n");
+		err = -EINVAL;
+		goto err_free_cq;
+	}
+
+	cmd->checksum_disabled = 1;
+	cmd->max_reg_cmds = 1 << cmd->log_sz;
+	bitmap_fill(&cmd->cmd_entry_mask, cmd->max_reg_cmds);
+
+	spin_lock_init(&cmd->alloc_lock);
+	spin_lock_init(&cmd->token_lock);
+	spin_lock_init(&cmd->doorbell_lock);
+
+	sema_init(&cmd->sem, cmd->max_reg_cmds);
+
+	cmd_h = upper_32_bits(cmd->dma);
+	cmd_l = lower_32_bits(cmd->dma);
+	if (cmd_l & 0xfff) {
+		dev_err(&xdev->pdev->dev, "invalid command queue address\n");
+		err = -ENOMEM;
+		goto err_free_cq;
+	}
+
+	xsc_set_cmdq_req_buf_addr(xdev, cmd_h, cmd_l);
+
+	cmd_h = upper_32_bits(cmd->cq_dma);
+	cmd_l = lower_32_bits(cmd->cq_dma);
+	if (cmd_l & 0xfff) {
+		dev_err(&xdev->pdev->dev, "invalid command queue address\n");
+		err = -ENOMEM;
+		goto err_free_cq;
+	}
+	xsc_set_cmdq_rsp_buf_addr(xdev, cmd_h, cmd_l);
+
+	/* Make sure firmware sees the complete address before we proceed */
+	wmb();
+
+	cmd->mode = XSC_CMD_MODE_POLLING;
+	cmd->cmd_status = XSC_CMD_STATUS_NORMAL;
+
+	err = xsc_create_msg_cache(xdev);
+	if (err) {
+		dev_err(&xdev->pdev->dev, "failed to create command cache\n");
+		goto err_free_cq;
+	}
+
+	xsc_set_wqname(xdev);
+	cmd->wq = create_singlethread_workqueue(cmd->wq_name);
+	if (!cmd->wq) {
+		dev_err(&xdev->pdev->dev, "failed to create command workqueue\n");
+		err = -ENOMEM;
+		goto err_destroy_cache;
+	}
+
+	cmd->cq_task = kthread_create(xsc_cmd_cq_polling,
+				      (void *)xdev,
+				      "xsc_cmd_cq_polling");
+	if (IS_ERR(cmd->cq_task)) {
+		dev_err(&xdev->pdev->dev, "failed to create cq task\n");
+		err = PTR_ERR(cmd->cq_task);
+		goto err_destroy_wq;
+	}
+	wake_up_process(cmd->cq_task);
+
+	/* clear abnormal state to avoid the impact of previous error */
+	xsc_check_cmdq_status(xdev);
+
+	return 0;
+
+err_destroy_wq:
+	destroy_workqueue(cmd->wq);
+
+err_destroy_cache:
+	xsc_destroy_msg_cache(xdev);
+
+err_free_cq:
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf,
+			  cmd->cq_dma);
+
+err_free_cmd:
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf,
+			  cmd->dma);
+
+err_free_pool:
+	dma_pool_destroy(cmd->pool);
+
+	return err;
+}
+
+void xsc_cmd_cleanup(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = &xdev->cmd;
+
+	destroy_workqueue(cmd->wq);
+	if (!IS_ERR_OR_NULL(cmd->cq_task))
+		kthread_stop(cmd->cq_task);
+	xsc_destroy_msg_cache(xdev);
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf,
+			  cmd->cq_dma);
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf,
+			  cmd->dma);
+	dma_pool_destroy(cmd->pool);
+}
+
+int xsc_cmd_version_check(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd_query_cmdq_ver_mbox_out *out;
+	struct xsc_cmd_query_cmdq_ver_mbox_in in;
+
+	int err;
+
+	out = kzalloc_obj(*out, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_CMDQ_VERSION);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
+	if (err)
+		goto err_free;
+
+	if (be16_to_cpu(out->cmdq_ver) != XSC_CMDQ_VERSION) {
+		pci_err(xdev->pdev, "cmdq version check failed, expecting %d, actual %d\n",
+			XSC_CMDQ_VERSION, be16_to_cpu(out->cmdq_ver));
+		err = -EINVAL;
+		goto err_free;
+	}
+	xdev->cmdq_ver = XSC_CMDQ_VERSION;
+
+err_free:
+	kfree(out);
+	return err;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hw.c b/drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
new file mode 100644
index 000000000..0358a40cc
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hw.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+
+#include "common/xsc_cmd_api.h"
+#include "hw.h"
+#include "hal/xsc_hal.h"
+
+#define MAX_BOARD_NUM	32
+
+static struct xsc_board_info *board_info[MAX_BOARD_NUM];
+static DEFINE_MUTEX(board_info_lock);
+
+static struct xsc_board_info *xsc_get_board_info(char *board_sn)
+{
+	int i;
+
+	for (i = 0; i < MAX_BOARD_NUM; i++) {
+		if (!board_info[i])
+			continue;
+		if (!strncmp(board_info[i]->board_sn, board_sn,
+			     XSC_BOARD_SN_LEN))
+			return board_info[i];
+	}
+
+	return NULL;
+}
+
+static struct xsc_board_info *xsc_alloc_board_info(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_BOARD_NUM; i++) {
+		if (!board_info[i])
+			break;
+	}
+	if (i == MAX_BOARD_NUM)
+		return NULL;
+	board_info[i] = vzalloc(sizeof(*board_info[i]));
+	if (!board_info[i])
+		return NULL;
+	board_info[i]->board_id = i;
+	return board_info[i];
+}
+
+void xsc_free_board_info(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_BOARD_NUM; i++)
+		vfree(board_info[i]);
+}
+
+int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
+			  struct xsc_caps *caps)
+{
+	struct xsc_cmd_query_hca_cap_mbox_out *out;
+	struct xsc_cmd_query_hca_cap_mbox_in in;
+	struct xsc_board_info *board_info;
+	int err;
+	u16 t16;
+
+	out = kzalloc_obj(*out, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HCA_CAP);
+	in.cpu_num = cpu_to_be16(num_online_cpus());
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
+	if (err)
+		goto err_free;
+
+	xdev->glb_func_id = be32_to_cpu(out->hca_cap.glb_func_id);
+	caps->pcie0_pf_funcid_base =
+		be16_to_cpu(out->hca_cap.pcie0_pf_funcid_base);
+	caps->pcie0_pf_funcid_top =
+		be16_to_cpu(out->hca_cap.pcie0_pf_funcid_top);
+	caps->pcie1_pf_funcid_base =
+		be16_to_cpu(out->hca_cap.pcie1_pf_funcid_base);
+	caps->pcie1_pf_funcid_top =
+		be16_to_cpu(out->hca_cap.pcie1_pf_funcid_top);
+	caps->funcid_to_logic_port =
+		be16_to_cpu(out->hca_cap.funcid_to_logic_port);
+
+	caps->pcie_host = out->hca_cap.pcie_host;
+	caps->nif_port_num = out->hca_cap.nif_port_num;
+	caps->hw_feature_flag = be32_to_cpu(out->hca_cap.hw_feature_flag);
+
+	caps->func_caps = (caps->func_caps & ~XSC_CAP_RAWETH_QP_ID_BASE_MASK) |
+			  FIELD_PREP(XSC_CAP_RAWETH_QP_ID_BASE_MASK,
+				     be16_to_cpu(out->hca_cap.raweth_qp_id_base));
+	caps->raweth_qp_id_end = be16_to_cpu(out->hca_cap.raweth_qp_id_end);
+	caps->nic_caps = (caps->nic_caps & ~XSC_CAP_RAWETH_RSS_QP_ID_BASE_MASK) |
+			 FIELD_PREP(XSC_CAP_RAWETH_RSS_QP_ID_BASE_MASK,
+				    be16_to_cpu(out->hca_cap.raweth_rss_qp_id_base));
+	caps->qos_caps = (caps->qos_caps & ~XSC_CAP_RAW_TPE_QP_NUM_MASK) |
+			 FIELD_PREP(XSC_CAP_RAW_TPE_QP_NUM_MASK,
+				    be16_to_cpu(out->hca_cap.raw_tpe_qp_num));
+	caps->max_cqes = 1 << out->hca_cap.log_max_cq_sz;
+	caps->max_wqes = 1 << out->hca_cap.log_max_qp_sz;
+	caps->max_sq_desc_sz = be16_to_cpu(out->hca_cap.max_desc_sz_sq);
+	caps->max_rq_desc_sz = be16_to_cpu(out->hca_cap.max_desc_sz_rq);
+	caps->flags = be64_to_cpu(out->hca_cap.flags);
+	caps->stat_rate_support = be16_to_cpu(out->hca_cap.stat_rate_support);
+	caps->log_max_msg = out->hca_cap.log_max_msg & 0x1f;
+	caps->num_ports = out->hca_cap.num_ports & 0xf;
+	caps->log_max_cq = out->hca_cap.log_max_cq & 0x1f;
+	caps->log_max_eq = out->hca_cap.log_max_eq & 0xf;
+	caps->log_max_msix = out->hca_cap.log_max_msix & 0xf;
+	caps->nic_caps = (caps->nic_caps & ~XSC_CAP_MAC_PORT_MASK) |
+			 FIELD_PREP(XSC_CAP_MAC_PORT_MASK,
+				    out->hca_cap.mac_port & 0xff);
+	xdev->mac_port = FIELD_GET(XSC_CAP_MAC_PORT_MASK, caps->nic_caps);
+	if (caps->num_ports > XSC_MAX_FW_PORTS) {
+		pci_err(xdev->pdev, "device has %d ports while the driver supports max %d ports\n",
+			caps->num_ports, XSC_MAX_FW_PORTS);
+		err = -EINVAL;
+		goto err_free;
+	}
+	caps->send_ds_num = out->hca_cap.send_seg_num;
+	caps->send_wqe_shift = out->hca_cap.send_wqe_shift;
+	caps->recv_ds_num = out->hca_cap.recv_seg_num;
+	caps->recv_wqe_shift = out->hca_cap.recv_wqe_shift;
+
+	caps->func_caps &= ~XSC_CAP_EMBEDDED_CPU;
+	caps->func_caps &= ~XSC_CAP_ECPF_VPORT_EXISTS;
+	caps->log_max_current_uc_list = 0;
+	caps->log_max_current_mc_list = 0;
+	caps->log_max_vlan_list = 8;
+	caps->log_max_qp = out->hca_cap.log_max_qp & 0x1f;
+	caps->log_max_mkey = out->hca_cap.log_max_mkey & 0x3f;
+	caps->log_max_pd = out->hca_cap.log_max_pd & 0x1f;
+	caps->log_max_srq = out->hca_cap.log_max_srqs & 0x1f;
+	caps->local_ca_ack_delay = out->hca_cap.local_ca_ack_delay & 0x1f;
+	caps->log_max_mcg = out->hca_cap.log_max_mcg;
+	caps->log_max_mtt = out->hca_cap.log_max_mtt;
+	caps->log_max_tso = out->hca_cap.log_max_tso;
+	caps->hca_core_clock = be32_to_cpu(out->hca_cap.hca_core_clock);
+	caps->max_rwq_indirection_tables =
+		be32_to_cpu(out->hca_cap.max_rwq_indirection_tables);
+	caps->max_rwq_indirection_table_size =
+		be32_to_cpu(out->hca_cap.max_rwq_indirection_table_size);
+	caps->max_qp_mcg = be16_to_cpu(out->hca_cap.max_qp_mcg);
+	caps->max_ra_res_qp = 1 << (out->hca_cap.log_max_ra_res_qp & 0x3f);
+	caps->max_ra_req_qp = 1 << (out->hca_cap.log_max_ra_req_qp & 0x3f);
+	caps->max_srq_wqes = 1 << out->hca_cap.log_max_srq_sz;
+	caps->rx_pkt_len_max = be32_to_cpu(out->hca_cap.rx_pkt_len_max);
+	caps->max_vfs = be16_to_cpu(out->hca_cap.max_vfs);
+	caps->qp_rate_limit_min = be32_to_cpu(out->hca_cap.qp_rate_limit_min);
+	caps->qp_rate_limit_max = be32_to_cpu(out->hca_cap.qp_rate_limit_max);
+
+	caps->msix_base = be16_to_cpu(out->hca_cap.msix_base);
+	caps->msix_num = be16_to_cpu(out->hca_cap.msix_num);
+
+	t16 = be16_to_cpu(out->hca_cap.bf_log_bf_reg_size);
+	if (t16 & 0x8000) {
+		caps->bf_reg_size = 1 << (t16 & 0x1f);
+		caps->bf_regs_per_page = XSC_BF_REGS_PER_PAGE;
+	} else {
+		caps->bf_reg_size = 0;
+		caps->bf_regs_per_page = 0;
+	}
+	caps->min_page_sz = ~(u32)((1 << PAGE_SHIFT) - 1);
+
+	caps->qos_caps |= XSC_CAP_DCBX;
+	caps->qos_caps |= XSC_CAP_QOS;
+	caps->qos_caps |= XSC_CAP_ETS;
+	caps->qos_caps |= XSC_CAP_DSCP;
+	caps->qos_caps = (caps->qos_caps & ~XSC_CAP_MAX_TC_MASK) |
+			 FIELD_PREP(XSC_CAP_MAX_TC_MASK, out->hca_cap.max_tc);
+	caps->log_max_qp_depth = out->hca_cap.log_max_qp_depth & 0xff;
+	caps->mac_bit = out->hca_cap.mac_bit;
+	caps->lag_logic_port_ofst = out->hca_cap.lag_logic_port_ofst;
+
+	caps->max_qp = be32_to_cpu(out->hca_cap.max_qp);
+	caps->max_cq = be32_to_cpu(out->hca_cap.max_cq);
+	caps->max_pd = be32_to_cpu(out->hca_cap.max_pd);
+
+	if (be16_to_cpu(out->hdr.ver) >= XSC_CMD_QUERY_HCA_CAP_V2)
+		caps->max_mtt = be32_to_cpu(out->hca_cap.max_mtt);
+	else
+		caps->max_mtt = 1 << (out->hca_cap.log_max_mtt & 0x3f);
+
+	if (be16_to_cpu(out->hdr.ver) >= XSC_CMD_QUERY_HCA_CAP_V1) {
+		caps->max_mr_size = be64_to_cpu(out->hca_cap.max_mr_size);
+		caps->max_cmd_in_len = be16_to_cpu(out->hca_cap.max_cmd_in_len);
+		caps->max_cmd_out_len = be16_to_cpu(out->hca_cap.max_cmd_out_len);
+	} else {
+		caps->max_mr_size = (1ull << 32) - 1;
+		caps->max_cmd_in_len = 10240;
+		caps->max_cmd_out_len = 2048;
+	}
+
+	if (be16_to_cpu(out->hdr.ver) >= XSC_CMD_QUERY_HCA_CAP_V3) {
+		caps->mpt_tbl_addr = be32_to_cpu(out->hca_cap.mpt_tbl_addr);
+		caps->mpt_tbl_depth = be32_to_cpu(out->hca_cap.mpt_tbl_depth);
+		caps->mpt_tbl_width = be32_to_cpu(out->hca_cap.mpt_tbl_width);
+		caps->mtt_inst_base_addr = be32_to_cpu(out->hca_cap.mtt_inst_base_addr);
+		caps->mtt_inst_stride = be32_to_cpu(out->hca_cap.mtt_inst_stride);
+		caps->mtt_inst_num_log = be32_to_cpu(out->hca_cap.mtt_inst_num_log);
+		caps->mtt_inst_depth = be32_to_cpu(out->hca_cap.mtt_inst_depth);
+		xsc_set_mtt_info(xdev);
+	}
+
+	xdev->pcie_no = out->hca_cap.pcie_no;
+	xdev->pf_id = out->hca_cap.pf_id;
+
+	xdev->chip_ver_h = be32_to_cpu(out->hca_cap.chip_ver_h);
+	xdev->chip_ver_m = be32_to_cpu(out->hca_cap.chip_ver_m);
+	xdev->chip_ver_l = be32_to_cpu(out->hca_cap.chip_ver_l);
+	xdev->hotfix_num = be32_to_cpu(out->hca_cap.hotfix_num);
+	xdev->feature_flag = be32_to_cpu(out->hca_cap.feature_flag);
+
+	mutex_lock(&board_info_lock);
+	board_info = xsc_get_board_info(out->hca_cap.board_sn);
+	if (!board_info) {
+		board_info = xsc_alloc_board_info();
+		if (!board_info) {
+			err = -ENOMEM;
+			mutex_unlock(&board_info_lock);
+			goto err_free;
+		}
+
+		memcpy(board_info->board_sn,
+		       out->hca_cap.board_sn,
+		       sizeof(out->hca_cap.board_sn));
+	}
+	mutex_unlock(&board_info_lock);
+
+	xdev->board_info = board_info;
+
+	xsc_set_pf_db_addr(xdev, be64_to_cpu(out->hca_cap.tx_db),
+			   be64_to_cpu(out->hca_cap.rx_db),
+			   be64_to_cpu(out->hca_cap.complete_db),
+			   be64_to_cpu(out->hca_cap.complete_reg),
+			   be64_to_cpu(out->hca_cap.event_db));
+
+	xdev->fw_version_major = out->hca_cap.fw_ver.fw_version_major;
+	xdev->fw_version_minor = out->hca_cap.fw_ver.fw_version_minor;
+	xdev->fw_version_patch =
+		be16_to_cpu(out->hca_cap.fw_ver.fw_version_patch);
+	xdev->fw_version_tweak =
+		be32_to_cpu(out->hca_cap.fw_ver.fw_version_tweak);
+	xdev->fw_version_extra_flag = out->hca_cap.fw_ver.fw_version_extra_flag;
+
+	kfree(out);
+	return 0;
+err_free:
+	kfree(out);
+	return err;
+}
+
+static int xsc_cmd_query_guid(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd_query_guid_mbox_out out;
+	struct xsc_cmd_query_guid_mbox_in in = {};
+	int err;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_GUID);
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	xdev->board_info->guid = out.guid;
+	xdev->board_info->guid_valid = 1;
+	return 0;
+}
+
+int xsc_query_guid(struct xsc_core_device *xdev)
+{
+	if (xdev->board_info->guid_valid)
+		return 0;
+
+	return xsc_cmd_query_guid(xdev);
+}
+
+static int xsc_cmd_activate_hw_config(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd_activate_hw_config_mbox_out out;
+	struct xsc_cmd_activate_hw_config_mbox_in in = {};
+	int err = 0;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_ACTIVATE_HW_CONFIG);
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	xdev->board_info->hw_config_activated = 1;
+	return 0;
+}
+
+int xsc_activate_hw_config(struct xsc_core_device *xdev)
+{
+	if (xdev->board_info->hw_config_activated)
+		return 0;
+
+	return xsc_cmd_activate_hw_config(xdev);
+}
+
+int xsc_reset_function_resource(struct xsc_core_device *xdev)
+{
+	struct xsc_function_reset_mbox_out out;
+	struct xsc_function_reset_mbox_in in;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_FUNCTION_RESET);
+	in.glb_func_id = cpu_to_be16(xdev->glb_func_id);
+
+	return xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hw.h b/drivers/net/ethernet/yunsilicon/xsc/pci/hw.h
new file mode 100644
index 000000000..5843a72c8
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hw.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_HW_H
+#define __XSC_HW_H
+
+#include "common/xsc_core.h"
+
+void xsc_free_board_info(void);
+int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
+			  struct xsc_caps *caps);
+int xsc_query_guid(struct xsc_core_device *xdev);
+int xsc_activate_hw_config(struct xsc_core_device *xdev);
+int xsc_reset_function_resource(struct xsc_core_device *xdev);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index ab428d20f..53dd8fdf1 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -4,6 +4,8 @@
  */
 
 #include "common/xsc_core.h"
+#include "common/xsc_cmd_api.h"
+#include "hw.h"
 #include "hal/xsc_hal.h"
 
 static const struct pci_device_id xsc_pci_id_table[] = {
@@ -141,11 +143,63 @@ static void xsc_core_dev_cleanup(struct xsc_core_device *xdev)
 
 static int xsc_hw_setup(struct xsc_core_device *xdev)
 {
+	int err;
+
+	err = xsc_cmd_init(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "Failed initializing command interface, aborting\n");
+		goto err_out;
+	}
+
+	err = xsc_cmd_version_check(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "Failed to check cmdq version\n");
+		goto err_cmd_cleanup;
+	}
+
+	err = xsc_cmd_query_hca_cap(xdev, &xdev->caps);
+	if (err) {
+		pci_err(xdev->pdev, "Failed to query hca, err=%d\n", err);
+		goto err_cmd_cleanup;
+	}
+
+	err = xsc_query_guid(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "failed to query guid, err=%d\n", err);
+		goto err_cmd_cleanup;
+	}
+
+	err = xsc_activate_hw_config(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "failed to activate hw config, err=%d\n",
+			err);
+		goto err_cmd_cleanup;
+	}
+
+	err = xsc_reset_function_resource(xdev);
+	if (err) {
+		pci_err(xdev->pdev, "Failed to reset function resource\n");
+		goto err_cmd_cleanup;
+	}
+
+	/* Required by the rdma client, which is probed right after this. */
+	xdev->board_info->msg_opcode = xsc_get_msg_opcode(xdev);
+	if (!xdev->board_info->msg_opcode) {
+		pci_err(xdev->pdev, "failed to get msg opcode table\n");
+		err = -ENODEV;
+		goto err_cmd_cleanup;
+	}
+
 	return 0;
+err_cmd_cleanup:
+	xsc_cmd_cleanup(xdev);
+err_out:
+	return err;
 }
 
 static void xsc_hw_cleanup(struct xsc_core_device *xdev)
 {
+	xsc_cmd_cleanup(xdev);
 }
 
 static int xsc_load(struct xsc_core_device *xdev)
@@ -247,6 +301,7 @@ static int __init xsc_init(void)
 static void __exit xsc_fini(void)
 {
 	pci_unregister_driver(&xsc_pci_driver);
+	xsc_free_board_info();
 }
 
 module_init(xsc_init);
-- 
2.18.4
