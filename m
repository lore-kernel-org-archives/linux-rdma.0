Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705054;
	b=dxWgzQxODJKMakbKOugkz8frqo1RnhwCJQOwS8n1HtTiaOVIsKxWYhb5J9wWTGA3coGl
	 VKOpH/19cFcMaw5qRG/B6xSd9Ut1b+b7A1fV4lnRqv+QN8xtCbpzUa9ChbB3E6ENh7YjN
	 loqXtc3t2k1jmRY46/JyaELhhVPBw7CSSWtPCUYmFiFUGcAfycr/CD6x3tdhmCaT7zWCb
	 4H831E2ReIPmh2FJMlO1vGuZI9SjeLIuhO4I33XoLZGOhpJFTOt6BuBzxuREVhbmPJB1Z
	 xqSF+Tp6eilU0a9ylAVA4WLe0WqVRuYckRmGcD73A/bR35PcRrcw+omj7uD+4xwCqLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705054;
	h=DMARC-Filter:DKIM-Signature:Content-Transfer-Encoding:From:Date:
	 Message-Id:Mime-Version:X-Lms-Return-Path:Received:To:In-Reply-To:
	 Subject:X-Mailer:X-Original-From:Cc:Content-Type:References;
	bh=+y+/jrgoPqCNW0ADni9CFFLs+jGmXdj1fzl2PGy/NRg=;
	b=hrNLLb2Rxf2IpJX/uLywG7ygoz+LoPj35CbXl018lhiEAUfzG5oKxHGVbjs7lF/KxN3y
	 UETc9/g6beAosjiLitLayr2yku7V5R+1bxUtsh3SHkOUQCY9BEUOKFRQ1YIM4VccVeuMG
	 5oV/5Dtuupi0ZEX9mtL5A8Ek09Jkwy3pDmg3I2SbHr9YxCVPDMV1ppBIgEXUayTTK9NnG
	 JwQpzVr6pAEFNk1oQzc+RcwfUR8GprH3UIVRuTJQs10IyJitpIEu0zV12d29CczD8H6ru
	 Xzzg1McQxg+vxSOaONjO67lmx/YYspfFsen02Jbv7TA3Vd1kjiarz3kKPmtu1LtFNfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b="RCurVD/D";
	arc=none smtp.remote-ip=209.127.231.44
Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AAA606A6B8
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76AAA606A6B8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=RCurVD/D
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705044; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+y+/jrgoPqCNW0ADni9CFFLs+jGmXdj1fzl2PGy/NRg=;
 b=RCurVD/DkwInrNjfccWSlkspQMVPBqHfuR/w3eVnlq52WB/uATwMGkh5Ye4GJ0Ij5y4iMD
 s5Ly8jm/Jnhty5nWw9u62vKtbVSccfYE1+1+geS7kBDP68/H/IlTHI1QgbolpJZiovWzW7
 WrCvnQOBjyfgsm4FLkj41WIF2v7KBakZNfBjaidvsmNtTAVcgMBy9ctMdyXV1i7Xxbki1M
 oUR/ClaRuzWFfkklbpnYi+78HYFEVIdeICCco+X53JrC22K7mByaAvm9A/0lMIcgygnjcQ
 7iPS0ZGblPbUKDPO2qimVlReWcYUQl+Wn7PwswfildO3fuvUwq+9x0MlL39UuA==
Content-Transfer-Encoding: 7bit
From: "Xin Tian" <tianx@yunsilicon.com>
Date: Thu, 26 Nov 2026 22:57:20 +0800
Message-Id: <20261126145718.70868-4-tianx@yunsilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26b0848d1+fc4906+vger.kernel.org+tianx@yunsilicon.com>
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:20 +0800
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
Subject: [PATCH v2 03/11] net/xsc: add the command queue
X-Mailer: git-send-email 2.25.1
X-Original-From: Xin Tian <tianx@yunsilicon.com>
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=UTF-8
References: <20261126145711.70868-1-tianx@yunsilicon.com>

Provide the mailbox-based firmware command interface: a single polling
thread, the command exec path with status-to-errno mapping, and the
firmware version check. Event-driven mode is deferred.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_cmd.h  | 560 ++++++++++++++
 .../ethernet/yunsilicon/xsc/common/xsc_core.h |   4 +
 .../net/ethernet/yunsilicon/xsc/pci/Makefile  |   2 +-
 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c | 708 ++++++++++++++++++
 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h |  87 +++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    |  18 +
 6 files changed, 1378 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c
 create mode 100644 drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
new file mode 100644
index 000000000..4dc650f83
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h
@@ -0,0 +1,560 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_CMD_H
+#define __XSC_CMD_H
+
+#include <linux/if_ether.h>
+#include <linux/types.h>
+
+struct xsc_core_device;
+
+#define XSC_CMDQ_VERSION	0x32
+
+#define XSC_BOARD_SN_LEN		32
+#define XSC_MAX_NUM_PCIE_INTF		2
+#define XSC_MAX_PF_NUM_PER_PCIE		8
+
+/* hca_cap mbox version */
+#define XSC_CMD_QUERY_HCA_CAP_V1	1
+
+enum {
+	XSC_CMD_STAT_OK				= 0x0,
+	XSC_CMD_STAT_BAD_OP_ERR			= 0x2,
+	XSC_CMD_STAT_BAD_PARAM_ERR		= 0x3,
+	XSC_CMD_STAT_RES_BUSY			= 0x6,
+	XSC_CMD_STAT_IX_ERR			= 0xa,
+	XSC_CMD_STAT_QP_FLUSH_BUSY		= 0x4b,
+	XSC_CMD_STAT_QP_FLUSH_PENDING		= 0x4c,
+	XSC_CMD_STAT_INVAL_FUNC			= 0x41,
+};
+
+enum {
+	XSC_CMD_OP_QUERY_HCA_CAP		= 0x100,
+	XSC_CMD_OP_QUERY_CMDQ_VERSION		= 0x10a,
+	XSC_CMD_OP_FUNCTION_RESET		= 0x10c,
+
+	XSC_CMD_OP_CREATE_EQ			= 0x301,
+	XSC_CMD_OP_DESTROY_EQ			= 0x302,
+
+	XSC_CMD_OP_CREATE_CQ			= 0x400,
+	XSC_CMD_OP_DESTROY_CQ			= 0x401,
+
+	XSC_CMD_OP_CREATE_QP			= 0x500,
+	XSC_CMD_OP_DESTROY_QP			= 0x501,
+	XSC_CMD_OP_2RST_QP			= 0x50a,
+	XSC_CMD_OP_RTR2RTS_QP			= 0x504,
+
+	XSC_CMD_OP_ENABLE_NIC_HCA		= 0x810,
+	XSC_CMD_OP_DISABLE_NIC_HCA		= 0x811,
+	XSC_CMD_OP_MODIFY_RAW_QP		= 0x81f,
+
+	XSC_CMD_OP_QUERY_VPORT_STATE		= 0x822,
+	XSC_CMD_OP_QUERY_EVENT_TYPE		= 0x831,
+
+	XSC_CMD_OP_ENABLE_MSIX			= 0x850,
+
+	XSC_CMD_OP_SET_MTU			= 0x1100,
+	XSC_CMD_OP_QUERY_ETH_MAC		= 0x1101,
+
+	XSC_CMD_OP_SET_PORT_ADMIN_STATUS	= 0x1801,
+};
+
+enum xsc_dma_direct {
+	XSC_DMA_DIR_TO_MAC,
+};
+
+enum {
+	XSC_TBM_CAP_HASH_PPH = 0,
+	XSC_TBM_CAP_RSS,
+	XSC_TBM_CAP_PCT_DROP_CONFIG,
+};
+
+struct xsc_inbox_hdr {
+	__be16		opcode;
+	u8		rsvd[4];
+	__be16		ver;
+};
+
+struct xsc_outbox_hdr {
+	u8		status;
+	u8		rsvd[5];
+	__be16		ver;
+};
+
+/* CQ mbox */
+struct xsc_cq_context {
+	__be16		eqn;
+	__be16		pa_num;
+	__be16		glb_func_id;
+	u8		log_cq_sz;
+	u8		cq_type;
+};
+
+struct xsc_create_cq_mbox_in {
+	struct xsc_inbox_hdr	hdr;
+	struct xsc_cq_context	ctx;
+	__be64			pas[];
+};
+
+struct xsc_create_cq_mbox_out {
+	struct xsc_outbox_hdr	hdr;
+	__be32			cqn;
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
+/* QP mbox */
+struct __packed xsc_create_qp_request {
+	__be16		input_qpn;
+	__be16		pa_num;
+	u8		qp_type;
+	u8		log_sq_sz;
+	u8		log_rq_sz;
+	u8		dma_direct;
+	__be32		pdn;
+	__be16		cqn_send;
+	__be16		cqn_recv;
+	__be16		glb_funcid;
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
+	__be32			qpn;
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
+/* EQ mbox */
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
+	u8			rsvd[6];
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
+/* fw mailbox layout, do not change */
+struct xsc_fw_version {
+	u8		rsvd[16];
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
+	__be32		hw_feature_flag;
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
+	__be32		max_rwq_indirection_tables;
+	__be32		max_rwq_indirection_table_size;
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
+	u8		rsvd_v2_v3[36];
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
+	u8		rsvd_v6[46];
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
+	u8			state;
+#define XSC_QUERY_VPORT_ADMIN_STATE_MASK	GENMASK(3, 0)
+#define XSC_QUERY_VPORT_STATE_MASK		GENMASK(7, 4)
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
+int xsc_cmd_init(struct xsc_core_device *xdev);
+void xsc_cmd_cleanup(struct xsc_core_device *xdev);
+int xsc_cmd_exec(struct xsc_core_device *xdev,
+		 void *in, unsigned int in_size,
+		 void *out, unsigned int out_size);
+int xsc_cmd_version_check(struct xsc_core_device *xdev);
+
+int xsc_cmd_status_to_err(struct xsc_outbox_hdr *hdr);
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index 9580d89a1..a6f0149ed 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -24,12 +24,16 @@
 #define XSC_PAGE_SHIFT_4K		12
 #define XSC_PAGE_SIZE_4K		(_AC(1, UL) << XSC_PAGE_SHIFT_4K)
 
+struct xsc_cmd;
+
 struct xsc_core_device {
 	struct pci_dev		*pdev;
 	struct device		*device;
 
 	void __iomem		*bar;
 	int			bar_num;
+
+	struct xsc_cmd		*cmd;
 };
 
 void xsc_update_tx_db(struct xsc_core_device *xdev, u32 sqn, u32 next_pid);
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
index 4a08b92cd..e17a10cc1 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/Makefile
@@ -6,4 +6,4 @@ ccflags-y += -I$(srctree)/drivers/net/ethernet/yunsilicon/xsc
 
 obj-$(CONFIG_YUNSILICON_XSC_PCI) += xsc_pci.o
 
-xsc_pci-y := main.o doorbell.o
+xsc_pci-y := main.o cmd.o doorbell.o
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c
new file mode 100644
index 000000000..45dcdb2b4
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.c
@@ -0,0 +1,708 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ * Copyright (c) 2013-2016, Mellanox Technologies. All rights reserved.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/kthread.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
+#include "common/xsc_cmd.h"
+#include "cmd.h"
+#include "common/xsc_core.h"
+
+#define XSC_CMD_DATA_BLOCK_SIZE	512
+#define XSC_CMD_FIRST_SIZE	8
+
+struct xsc_cmd_prot_block {
+	u8		data[XSC_CMD_DATA_BLOCK_SIZE];
+	u8		rsvd0[48];
+	__be64		next;
+	__be32		block_num;
+	u8		owner_status;
+	u8		token;
+	u8		ctrl_sig;
+	u8		sig;
+};
+
+/* hw layout, do not change */
+struct xsc_cmd_layout {
+	u16		rsv0;
+	u8		rsv[2];
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
+	u16		rsv0;
+	u8		rsv[2];
+	__be32		out[XSC_RSP_FIRST_SIZE];
+	u8		token;
+	u8		sig;
+	u8		idx;
+	u8		type_owner;
+};
+
+#define XSC_CMD_TYPE_MASK		GENMASK(6, 0)
+#define XSC_CMD_OWNER_BIT		BIT(7)
+
+enum {
+	XSC_CMDQ_ERR_HW_READ_REQ_ERR	= BIT(0),
+	XSC_CMDQ_ERR_HW_WRITE_REQ_ERR	= BIT(1),
+	XSC_CMDQ_ERR_REQ_PID_ERR	= BIT(2),
+	XSC_CMDQ_ERR_RSP_CID_ERR	= BIT(3),
+};
+
+enum {
+	XSC_CMDQ_ELEMENT_SIZE_LOG	= 6,
+	XSC_CMDQ_Q_DEPTH_LOG		= 5,
+};
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
+static u16 xsc_msg_to_opcode(const struct xsc_cmd_msg *in)
+{
+	const struct xsc_inbox_hdr *hdr = (const void *)in->first;
+
+	return be16_to_cpu(hdr->opcode);
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
+	mailbox->buf = dma_pool_zalloc(xdev->cmd->pool, flags, &mailbox->dma);
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
+	dma_pool_free(xdev->cmd->pool, mailbox->buf, mailbox->dma);
+	kfree(mailbox);
+}
+
+static struct xsc_cmd_msg *xsc_alloc_msg(struct xsc_core_device *xdev,
+					 unsigned int size,
+					 unsigned int first_size)
+{
+	struct xsc_cmd_mailbox *tmp, *head = NULL;
+	struct xsc_cmd_prot_block *block;
+	struct xsc_cmd_msg *msg;
+	unsigned int blen;
+	int err;
+	int n;
+	int i;
+
+	msg = kzalloc_obj(*msg, GFP_KERNEL);
+	if (!msg)
+		return ERR_PTR(-ENOMEM);
+
+	blen = size - min(size, first_size);
+	n = DIV_ROUND_UP(blen, XSC_CMD_DATA_BLOCK_SIZE);
+
+	for (i = 0; i < n; i++) {
+		tmp = xsc_alloc_cmd_box(xdev, GFP_KERNEL);
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
+	msg->first_size = first_size;
+
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
+static void xsc_free_msg(struct xsc_core_device *xdev, struct xsc_cmd_msg *msg)
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
+static int xsc_copy_to_cmd_msg(struct xsc_cmd_msg *to, const void *from,
+			       unsigned int size)
+{
+	struct xsc_cmd_prot_block *block;
+	struct xsc_cmd_mailbox *next;
+	const u8 *src = from;
+	unsigned int copy;
+
+	copy = min(size, to->first_size);
+	memcpy(to->first, src, copy);
+	size -= copy;
+	src += copy;
+
+	next = to->next;
+	while (size) {
+		if (!next) {
+			WARN_ONCE(1, "Mailbox too short\n");
+			return -ENOMEM;
+		}
+
+		copy = min(size, XSC_CMD_DATA_BLOCK_SIZE);
+		block = next->buf;
+		memcpy(block->data, src, copy);
+		block->owner_status = 0;
+		src += copy;
+		size -= copy;
+		next = next->next;
+	}
+
+	return 0;
+}
+
+static int xsc_copy_from_rsp_msg(void *to, const struct xsc_cmd_msg *from,
+				 unsigned int size)
+{
+	struct xsc_cmd_prot_block *block;
+	struct xsc_cmd_mailbox *next;
+	u8 *dst = to;
+	unsigned int copy;
+
+	copy = min(size, from->first_size);
+	memcpy(dst, from->first, copy);
+	size -= copy;
+	dst += copy;
+
+	next = from->next;
+	while (size) {
+		if (!next) {
+			WARN_ONCE(1, "Mailbox too short\n");
+			return -ENOMEM;
+		}
+
+		copy = min(size, XSC_CMD_DATA_BLOCK_SIZE);
+		block = next->buf;
+		if (!block->owner_status)
+			return -EIO;
+
+		memcpy(dst, block->data, copy);
+		dst += copy;
+		size -= copy;
+		next = next->next;
+	}
+
+	return 0;
+}
+
+static int xsc_cmd_invoke(struct xsc_core_device *xdev, struct xsc_cmd_msg *in,
+			  struct xsc_cmd_msg *out, u8 *status)
+{
+	struct xsc_cmd *cmd = xdev->cmd;
+	struct xsc_cmd_layout *lay;
+	struct xsc_cmd_work_ent *ent;
+	unsigned long timeout;
+	unsigned long flags;
+	int err;
+
+	ent = kzalloc_obj(*ent, GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+
+	ent->in = in;
+	ent->out = out;
+	init_completion(&ent->done);
+	down(&cmd->sem);
+	ent->idx = xsc_alloc_ent(cmd);
+	if (ent->idx < 0) {
+		pci_err(xdev->pdev, "failed to allocate command entry\n");
+		up(&cmd->sem);
+		kfree(ent);
+		return -ENOMEM;
+	}
+	ent->token = ent->idx + 1;
+	cmd->ent_arr[ent->idx] = ent;
+
+	spin_lock_irqsave(&cmd->doorbell_lock, flags);
+	lay = xsc_get_inst(cmd, cmd->cmd_pid);
+	memset(lay, 0, sizeof(*lay));
+	memcpy(lay->in, in->first, sizeof(lay->in));
+	if (in->next)
+		lay->in_ptr = cpu_to_be64(in->next->dma);
+	lay->inlen = cpu_to_be32(in->len);
+	if (out->next)
+		lay->out_ptr = cpu_to_be64(out->next->dma);
+	lay->outlen = cpu_to_be32(out->len);
+	lay->type_owner = FIELD_PREP(XSC_CMD_TYPE_MASK, XSC_PCI_CMD_XPORT);
+	lay->token = ent->token;
+	lay->idx = ent->idx;
+	lay->sig = 0xff;
+
+	/* ring doorbell after the descriptor is valid */
+	wmb();
+
+	cmd->cmd_pid = (cmd->cmd_pid + 1) % (1 << cmd->log_sz);
+	xsc_update_cmdq_req_pid(xdev, cmd->cmd_pid);
+	spin_unlock_irqrestore(&cmd->doorbell_lock, flags);
+
+	timeout = msecs_to_jiffies(XSC_CMD_TIMEOUT_MSEC);
+	if (!wait_for_completion_timeout(&ent->done, timeout)) {
+		cmd->cmd_status = XSC_CMD_STATUS_TIMEDOUT;
+		pci_err(xdev->pdev, "wait for opcode 0x%x response timeout\n",
+			xsc_msg_to_opcode(in));
+		/* the entry stays registered for the completion handler */
+		return -ETIMEDOUT;
+	}
+
+	err = ent->ret;
+	*status = ent->status;
+
+	spin_lock_irqsave(&cmd->alloc_lock, flags);
+	if (cmd->ent_arr[ent->idx] == ent)
+		cmd->ent_arr[ent->idx] = NULL;
+	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
+	kfree(ent);
+
+	return err;
+}
+
+static void xsc_cmd_comp_handler(struct xsc_core_device *xdev, u8 idx,
+				 struct xsc_rsp_layout *rsp)
+{
+	struct xsc_cmd *cmd = xdev->cmd;
+	struct xsc_cmd_work_ent *ent;
+
+	if (idx >= cmd->max_reg_cmds || (cmd->cmd_entry_mask & BIT(idx))) {
+		pci_err(xdev->pdev, "idx[%d] exceeds max cmds or has no request\n",
+			idx);
+		return;
+	}
+	ent = cmd->ent_arr[idx];
+
+	memcpy(ent->out->first, rsp->out, sizeof(rsp->out));
+	ent->ret = 0;
+	ent->status = ((struct xsc_outbox_hdr *)ent->out->first)->status;
+	cmd->retry_cnt = 0;
+
+	xsc_free_ent(cmd, ent->idx);
+	complete(&ent->done);
+	up(&cmd->sem);
+}
+
+static void xsc_cmd_handle_rsp_before_reload(struct xsc_cmd *cmd,
+					     struct xsc_core_device *xdev)
+{
+	u32 rsp_pid, rsp_cid;
+
+	rsp_pid = xsc_get_cmdq_rsp_pid(xdev) & XSC_CMDQ_INDEX_MASK;
+	rsp_cid = xsc_get_cmdq_rsp_cid(xdev) & XSC_CMDQ_INDEX_MASK;
+	if (rsp_pid == rsp_cid)
+		return;
+
+	cmd->cq_cid = rsp_pid;
+	xsc_update_cmdq_rsp_cid(xdev, cmd->cq_cid);
+}
+
+static void xsc_cmd_err_handler(struct xsc_core_device *xdev, u32 raw)
+{
+	struct xsc_cmd *cmd = xdev->cmd;
+	unsigned long flags;
+	int err = 0;
+	int retry = 0;
+	u32 stat = raw;
+
+	while (stat) {
+		err++;
+		if (stat & XSC_CMDQ_ERR_HW_READ_REQ_ERR) {
+			retry = 1;
+			stat &= ~XSC_CMDQ_ERR_HW_READ_REQ_ERR;
+			pci_err(xdev->pdev, "hw read request from host failed\n");
+		} else if (stat & XSC_CMDQ_ERR_HW_WRITE_REQ_ERR) {
+			retry = 1;
+			stat &= ~XSC_CMDQ_ERR_HW_WRITE_REQ_ERR;
+			pci_err(xdev->pdev, "hw write request to fw failed\n");
+		} else if (stat & XSC_CMDQ_ERR_REQ_PID_ERR) {
+			stat &= ~XSC_CMDQ_ERR_REQ_PID_ERR;
+			pci_err(xdev->pdev, "hw reported unexpected req pid\n");
+		} else if (stat & XSC_CMDQ_ERR_RSP_CID_ERR) {
+			stat &= ~XSC_CMDQ_ERR_RSP_CID_ERR;
+			pci_err(xdev->pdev, "hw reported unexpected rsp cid\n");
+		} else {
+			stat = 0;
+			pci_err(xdev->pdev, "ignore unknown cmdq error\n");
+		}
+	}
+
+	if (retry) {
+		if (cmd->retry_cnt >= XSC_CMD_MAX_RETRY_CNT) {
+			pci_warn(xdev->pdev, "error handler retried %d times, stop retrying\n",
+				 cmd->retry_cnt);
+		} else {
+			spin_lock_irqsave(&cmd->doorbell_lock, flags);
+			xsc_update_cmdq_req_pid(xdev, cmd->cmd_pid);
+			cmd->retry_cnt++;
+			spin_unlock_irqrestore(&cmd->doorbell_lock, flags);
+		}
+	}
+
+	if (err)
+		xsc_clear_cmdq_err_status(xdev, raw);
+}
+
+static int xsc_cmd_cq_polling(void *data)
+{
+	struct xsc_core_device *xdev = data;
+	struct xsc_cmd *cmd = xdev->cmd;
+	struct xsc_rsp_layout *rsp;
+	u32 err_status;
+	u32 cq_pid;
+
+	while (!kthread_should_stop()) {
+		if (need_resched())
+			schedule();
+
+		err_status = xsc_read_cmdq_err_status(xdev);
+		if (err_status)
+			xsc_cmd_err_handler(xdev, err_status);
+
+		cq_pid = xsc_get_cmdq_rsp_pid(xdev) & XSC_CMDQ_INDEX_MASK;
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
+					    "rsp doorbell advanced but buffer not ready %u %u\n",
+					    cmd->cq_cid, cq_pid);
+			msleep(20);
+			continue;
+		}
+
+		/* the hardware writes the payload before flipping the owner bit */
+		dma_rmb();
+
+		xsc_cmd_comp_handler(xdev, rsp->idx, rsp);
+
+		cmd->cq_cid = (cmd->cq_cid + 1) % (1 << cmd->log_sz);
+		xsc_update_cmdq_rsp_cid(xdev, cmd->cq_cid);
+		if (cmd->cq_cid == 0)
+			cmd->owner_bit = !cmd->owner_bit;
+	}
+
+	return 0;
+}
+
+int xsc_cmd_status_to_err(struct xsc_outbox_hdr *hdr)
+{
+	switch (hdr->status) {
+	case XSC_CMD_STAT_OK:
+		return 0;
+	case XSC_CMD_STAT_BAD_OP_ERR:
+		return -EOPNOTSUPP;
+	case XSC_CMD_STAT_BAD_PARAM_ERR:
+		return -EINVAL;
+	case XSC_CMD_STAT_RES_BUSY:
+	case XSC_CMD_STAT_QP_FLUSH_BUSY:
+		return -EBUSY;
+	case XSC_CMD_STAT_QP_FLUSH_PENDING:
+		return -EAGAIN;
+	case XSC_CMD_STAT_IX_ERR:
+	case XSC_CMD_STAT_INVAL_FUNC:
+		return -ENODEV;
+	default:
+		return -EIO;
+	}
+}
+
+static int _xsc_cmd_exec(struct xsc_core_device *xdev,
+			 void *in, unsigned int in_size,
+			 void *out, unsigned int out_size)
+{
+	struct xsc_cmd *cmd = xdev->cmd;
+	struct xsc_cmd_msg *outb;
+	struct xsc_cmd_msg *inb;
+	u8 status = 0;
+	int err;
+
+	if (cmd->cmd_status == XSC_CMD_STATUS_TIMEDOUT)
+		return -ETIMEDOUT;
+
+	inb = xsc_alloc_msg(xdev, in_size, sizeof(inb->first[0]) *
+					   XSC_CMD_FIRST_SIZE);
+	if (IS_ERR(inb))
+		return PTR_ERR(inb);
+
+	err = xsc_copy_to_cmd_msg(inb, in, in_size);
+	if (err) {
+		pci_err(xdev->pdev, "copy to cmd msg err %d\n", err);
+		goto err_free_msg;
+	}
+
+	outb = xsc_alloc_msg(xdev, out_size, sizeof(outb->first[0]) *
+					    XSC_RSP_FIRST_SIZE);
+	if (IS_ERR(outb)) {
+		err = PTR_ERR(outb);
+		goto err_free_msg;
+	}
+
+	err = xsc_cmd_invoke(xdev, inb, outb, &status);
+	if (err == -ETIMEDOUT)
+		/* the command owns both mailboxes now */
+		return err;
+
+	if (err)
+		goto err_free_rsp;
+
+	if (status) {
+		pci_err(xdev->pdev, "opcode 0x%x failed with status %u\n",
+			xsc_msg_to_opcode(inb), status);
+		xsc_copy_from_rsp_msg(out, outb, out_size);
+		err = -EREMOTEIO;
+		goto err_free_rsp;
+	}
+
+	err = xsc_copy_from_rsp_msg(out, outb, out_size);
+
+err_free_rsp:
+	xsc_free_msg(xdev, outb);
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
+int xsc_cmd_init(struct xsc_core_device *xdev)
+{
+	unsigned int size = sizeof(struct xsc_cmd_prot_block);
+	int align = roundup_pow_of_two(size);
+	struct xsc_cmd *cmd;
+	u32 addr_h, addr_l;
+	int err = -ENOMEM;
+
+	cmd = kzalloc_obj(*cmd, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	xdev->cmd = cmd;
+
+	cmd->pool = dma_pool_create("xsc_cmd", &xdev->pdev->dev, size, align, 0);
+	if (!cmd->pool)
+		goto err_free_pool;
+
+	cmd->cmd_buf = dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE, &cmd->dma,
+					  GFP_KERNEL);
+	if (!cmd->cmd_buf)
+		goto err_free_pool;
+
+	cmd->cq_buf = dma_alloc_coherent(&xdev->pdev->dev, PAGE_SIZE,
+					 &cmd->cq_dma, GFP_KERNEL);
+	if (!cmd->cq_buf)
+		goto err_free_cmd;
+
+	memset(cmd->cmd_buf, 0, PAGE_SIZE);
+	memset(cmd->cq_buf, 0, PAGE_SIZE);
+
+	cmd->log_sz = XSC_CMDQ_Q_DEPTH_LOG;
+	cmd->log_stride = XSC_CMDQ_ELEMENT_SIZE_LOG;
+	cmd->max_reg_cmds = 1 << cmd->log_sz;
+	bitmap_fill(&cmd->cmd_entry_mask, cmd->max_reg_cmds);
+
+	spin_lock_init(&cmd->alloc_lock);
+	spin_lock_init(&cmd->doorbell_lock);
+	sema_init(&cmd->sem, cmd->max_reg_cmds);
+
+	cmd->cmd_pid = xsc_get_cmdq_req_pid(xdev) & XSC_CMDQ_INDEX_MASK;
+	cmd->cq_cid = xsc_get_cmdq_rsp_cid(xdev) & XSC_CMDQ_INDEX_MASK;
+	cmd->ownerbit_learned = 0;
+	cmd->cmd_status = XSC_CMD_STATUS_NORMAL;
+
+	xsc_cmd_handle_rsp_before_reload(cmd, xdev);
+
+	addr_h = upper_32_bits(cmd->dma);
+	addr_l = lower_32_bits(cmd->dma);
+	xsc_set_cmdq_req_buf_addr(xdev, addr_h, addr_l);
+
+	addr_h = upper_32_bits(cmd->cq_dma);
+	addr_l = lower_32_bits(cmd->cq_dma);
+	xsc_set_cmdq_rsp_buf_addr(xdev, addr_h, addr_l);
+
+	/* make sure firmware sees the complete address before we proceed */
+	wmb();
+
+	xsc_clear_cmdq_err_status(xdev, xsc_read_cmdq_err_status(xdev));
+
+	cmd->cq_task = kthread_create(xsc_cmd_cq_polling, (void *)xdev,
+				      "xsc_cmd_cq_polling");
+	if (IS_ERR(cmd->cq_task)) {
+		err = PTR_ERR(cmd->cq_task);
+		pci_err(xdev->pdev, "failed to create cq polling task: %d\n",
+			err);
+		goto err_free_cq;
+	}
+	wake_up_process(cmd->cq_task);
+
+	return 0;
+
+err_free_cq:
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf, cmd->cq_dma);
+
+err_free_cmd:
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf, cmd->dma);
+
+err_free_pool:
+	dma_pool_destroy(cmd->pool);
+
+	kfree(cmd);
+	xdev->cmd = NULL;
+
+	return err;
+}
+
+void xsc_cmd_cleanup(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd *cmd = xdev->cmd;
+	int i;
+
+	if (!cmd)
+		return;
+
+	if (!IS_ERR_OR_NULL(cmd->cq_task)) {
+		kthread_stop(cmd->cq_task);
+		cmd->cq_task = NULL;
+	}
+
+	/* a timed-out command stays registered for a response that may never
+	 * come; with the polling thread stopped nothing can touch it anymore
+	 */
+	for (i = 0; i < cmd->max_reg_cmds; i++) {
+		if (!cmd->ent_arr[i])
+			continue;
+		xsc_free_msg(xdev, cmd->ent_arr[i]->in);
+		xsc_free_msg(xdev, cmd->ent_arr[i]->out);
+		kfree(cmd->ent_arr[i]);
+		cmd->ent_arr[i] = NULL;
+	}
+
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cq_buf, cmd->cq_dma);
+	dma_free_coherent(&xdev->pdev->dev, PAGE_SIZE, cmd->cmd_buf, cmd->dma);
+	dma_pool_destroy(cmd->pool);
+
+	kfree(cmd);
+	xdev->cmd = NULL;
+}
+
+int xsc_cmd_version_check(struct xsc_core_device *xdev)
+{
+	struct xsc_cmd_query_cmdq_ver_mbox_out out = {};
+	struct xsc_cmd_query_cmdq_ver_mbox_in in = {};
+	int err;
+
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_CMDQ_VERSION);
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+	if (err)
+		return err;
+
+	if (be16_to_cpu(out.cmdq_ver) != XSC_CMDQ_VERSION) {
+		pci_err(xdev->pdev, "cmdq version mismatch, expected %d got %d\n",
+			XSC_CMDQ_VERSION, be16_to_cpu(out.cmdq_ver));
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h
new file mode 100644
index 000000000..c5fc62ae7
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/cmd.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021-2026, Shanghai Yunsilicon Technology Co., Ltd.
+ * All rights reserved.
+ */
+
+#ifndef __XSC_PCI_CMD_H
+#define __XSC_PCI_CMD_H
+
+#include <linux/completion.h>
+#include <linux/dma-mapping.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/spinlock.h>
+
+#include "common/xsc_cmd.h"
+
+#define XSC_CMD_MAX_RETRY_CNT	3
+
+enum {
+	XSC_CMD_TIMEOUT_MSEC	= 10 * 1000,
+};
+
+enum {
+	XSC_MAX_COMMANDS	= 32,
+	XSC_CMDQ_INDEX_MASK	= XSC_MAX_COMMANDS - 1,
+	XSC_PCI_CMD_XPORT	= 7,
+};
+
+#define XSC_RSP_FIRST_SIZE	14
+
+struct xsc_cmd_mailbox {
+	void			*buf;
+	dma_addr_t		dma;
+	struct xsc_cmd_mailbox	*next;
+};
+
+struct xsc_cmd_msg {
+	u32			len;
+	unsigned int		first_size;
+	struct xsc_cmd_mailbox	*next;
+	__be32			first[XSC_RSP_FIRST_SIZE];
+};
+
+struct xsc_cmd_work_ent {
+	struct xsc_cmd_msg	*in;
+	struct xsc_cmd_msg	*out;
+	int			idx;
+	struct completion	done;
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
+struct xsc_cmd {
+	void			*cmd_buf;
+	void			*cq_buf;
+	dma_addr_t		dma;
+	dma_addr_t		cq_dma;
+	u16			cmd_pid;
+	u16			cq_cid;
+	u8			owner_bit;
+	u8			retry_cnt;
+	u8			log_sz;
+	u8			log_stride;
+	int			max_reg_cmds;
+
+	/* the bitmap holds per-entry slots, the semaphore caps outstanding
+	 * commands at max_reg_cmds so xsc_alloc_ent() cannot fail
+	 */
+	spinlock_t		alloc_lock;
+	/* serializes filling a request slot and ringing its doorbell */
+	spinlock_t		doorbell_lock;
+	unsigned long		cmd_entry_mask;
+	struct task_struct	*cq_task;
+	struct semaphore	sem;
+	struct xsc_cmd_work_ent	*ent_arr[XSC_MAX_COMMANDS];
+	struct dma_pool		*pool;
+	unsigned int		ownerbit_learned;
+	u8			cmd_status;
+};
+
+#endif
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index c926507a7..9b08580f5 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -5,6 +5,7 @@
 
 #include <linux/slab.h>
 
+#include "common/xsc_cmd.h"
 #include "common/xsc_core.h"
 
 static const struct pci_device_id xsc_pci_id_table[] = {
@@ -75,8 +76,24 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
 	xdev->bar_num = bar_num;
 	xdev->bar = bar_base;
 
+	err = xsc_cmd_init(xdev);
+	if (err) {
+		pci_err(pdev, "failed to initialize command interface: err=%d\n",
+			err);
+		goto err_io_unmap;
+	}
+
+	err = xsc_cmd_version_check(xdev);
+	if (err) {
+		pci_err(pdev, "failed to check command queue version: err=%d\n",
+			err);
+		goto err_cmd_cleanup;
+	}
+
 	return 0;
 
+err_cmd_cleanup:
+	xsc_cmd_cleanup(xdev);
 err_io_unmap:
 	pci_iounmap(pdev, bar_base);
 err_clr_master:
@@ -92,6 +109,7 @@ static void xsc_pci_fini(struct xsc_core_device *xdev)
 {
 	struct pci_dev *pdev = xdev->pdev;
 
+	xsc_cmd_cleanup(xdev);
 	pci_iounmap(pdev, xdev->bar);
 	pci_clear_master(pdev);
 	pci_release_region(pdev, xdev->bar_num);
-- 
2.43.0
