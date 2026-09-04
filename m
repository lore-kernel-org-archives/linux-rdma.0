Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4882144C4EE
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519190; cv=none; b=WszIJSOY4RDJNKAiw5Aah3gP3sCwV6iQM15LqQp+tN2VnAPcvNGXJQQIKSQ1Subp9xSyGreuf2MykjsC6tEhSx0Ihue2PQt10WbnnDQh+c/5DrPA5+xOi3T0Olvi9oybsU8JnaWgNWiPuZvfDpzwwt9QWnLT0mtpSQNl9HK6d6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519190; c=relaxed/simple;
	bh=c6oYnEfFM0MWFee9Fp07J6hOp+zyvekq7hitaGWhijw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsO67NHKLchxEVp3rcK7vCD89mlM3eIQxyLU+HKurkD62kCLJthvSo38mSbYJ7vBkA0ssN0iXu9OPApI/ER/x4WsS1Vcrc8d24N1WH8Nr77E3rCSQJs8TQeUN+bCR7EbH6MZHhVuzFOjMhpvRRpUaClhnyhl65qf7El0JKA9qRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gkd0Bku9; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gkd0Bku9"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-853c947bfefso723919b3a.0
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519169; x=1789123969;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Ie/+ne82/k/5wtZX1JIYtWTA4vnoi50qIFmR+/v6VQ=;
        b=f2+EjpwDstmkUWMQDRk2pAZa75T8IOp5xEkh0hOM2kUzfWlJ+8/bzIW4y9BRYFGMCG
         CNJozPy2EQX5XJhBUp2nvjTCUfIXs+9mO/lpgu8JT0MM8/d1CdCN3i2lolhD0XtfEW8g
         PTTFZy/dVeF0aF6e7H2kILOOoTXBkAs3HpY2wY9EekTvYTw6cNPqjOrFqqo1/I+JtaKb
         9DCQflUcnONSLNDtO6ic969CXq1LUs5dzlN/FOzzrmcvYOjJwtl7Z7cZOAMY1e248iPV
         dvuJWupRSQzF7FeHjWEcbEGTsm08Rd8+bAR3Kg8NDehiNZBTznL7X7YnB9uv8JOmQrw3
         ODdg==
X-Forwarded-Encrypted: i=1; AKwUvBznpfDzYXoW7LlGNDm19ff9CVfj5jTWL2U6b6uViaVuvV04+kIWsRriDKzsW2Jv6ZrBorQLl+Li9kHG@vger.kernel.org
X-Gm-Message-State: AFuF++l4rpUG+7gPkxG4CE9fm8aOvrhadRhQ189yfpjwmC8p/0lWM6DG
	TojrTGZDt9Oh38vmsoWFDnRAFVnccvLwfPLjSkgrY64aBuzYE4wjI9GWnvdFwNluTeLIWplZ3BB
	peyijfAmFjcXMGGNEpeTfeEgDS8IqE5DxR/m0QQpTvHshPmtokvQTuvqY2eEAbUwpONRmNTeWBH
	KL/XqyS0T7v8gwg2DOnOmCLeltjWMk3K/GRnFcX72cPWW2fvxQOgzu/RYzaHAMih15i3wW/Ee/4
	T/zzCOU9cXbj6uS/A==
X-Gm-Gg: AYBFou0C6YlF3v2mCd0QCFCw1ny//0F5LYmMlmx/BT+iMuBNU1k8EaIc+m+hWILFC4T
	cT2Hrbb7G6te/ZQf6SyY0/MBCW9Sb5+TZMVMJVOVBCGRxurquPCfowdG9v7nyx4pNJpxoJqKUR2
	kUSryZY9ZfFX/39hgtZY1C4W2ciI6eA09NzFZ6IQ9u3L40SEnPKGerHVTaNImgjUbvJaCwQByxN
	43eB828bLRAAefQ2rGJKWeArXIH23KITIjK2oArnIWpx5XjTcpdbjp/gl5sV/O7yRDADJVN7qgx
	kJa6cRveOcF3XcyghgneDAsIaTaEVw2ssayG5HHcdY4h71cxYY9UT3YUlczvDTAzVFRGNJdIkhE
	2MfTdi3sueiia5l/p0OoUa/a0O/Yqt7MOPKqxxyk+yTwIG0zrk22vA5ePl1tdvrtdg4gB5s+lNr
	K58qOhyiqPqcnSe+m3yaJWvgdIQshZsq4t/g==
X-Received: by 2002:a05:6a00:17aa:b0:84e:c851:a058 with SMTP id d2e1a72fcca58-85ffcb616aamr10164159b3a.10.1788519169340;
        Fri, 04 Sep 2026 03:52:49 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8614e59bd50sm778806b3a.1.2026.09.04.03.52.48
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:49 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39af92138f9so1430144a91.0
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519167; x=1789123967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Ie/+ne82/k/5wtZX1JIYtWTA4vnoi50qIFmR+/v6VQ=;
        b=gkd0Bku9XO9NDPr/fY+fcxKp2UCwL6JOTrnvFkDCaP3RzsK5eV3cPyNwRSjIT3F9XF
         dC/syyAhZ81tB8JMe+4ecK5B8Eo2hQCVjM3nos6qsGGKA98gWDfUw12lcdq0DI4pryEb
         QuVzv6jd8g0Tk1tC26jg++W92JCM3abSBXz5g=
X-Forwarded-Encrypted: i=1; AKwUvBzXNDBZbpNuOkyts6ctVS1qc4LifWsdLu5nwWZme3cAb271kBpRDkjU31x8FjjngaJE6dt/yYfDXh0v@vger.kernel.org
X-Received: by 2002:a17:90b:4988:b0:398:ceed:b903 with SMTP id 98e67ed59e1d1-39b080364famr14317887a91.11.1788519166800;
        Fri, 04 Sep 2026 03:52:46 -0700 (PDT)
X-Received: by 2002:a17:90b:4988:b0:398:ceed:b903 with SMTP id 98e67ed59e1d1-39b080364famr14317844a91.11.1788519166209;
        Fri, 04 Sep 2026 03:52:46 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:45 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Usman Ansari <usman.ansari@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 12/15] RDMA/bng_re: Add Stats verbs
Date: Fri,  4 Sep 2026 03:43:20 -0700
Message-ID: <20260904104328.763768-13-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260904104328.763768-1-siva.kallam@broadcom.com>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Usman Ansari <usman.ansari@broadcom.com>

This patch adds below verbs.
- bng_re_alloc_hw_port_stats
- bng_re_ib_get_hw_stats

Signed-off-by: Usman Ansari <usman.ansari@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/Makefile         |   1 +
 drivers/infiniband/hw/bng_re/bng_dev.c        |   3 +
 drivers/infiniband/hw/bng_re/bng_fw.h         |  12 +
 .../infiniband/hw/bng_re/bng_hw_counters.c    | 304 ++++++++++++++++++
 .../infiniband/hw/bng_re/bng_hw_counters.h    | 118 +++++++
 drivers/infiniband/hw/bng_re/bng_re.h         |   4 +
 drivers/infiniband/hw/bng_re/bng_res.h        |  21 ++
 drivers/infiniband/hw/bng_re/bng_sp.c         | 144 +++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h         |  84 +++++
 9 files changed, 691 insertions(+)
 create mode 100644 drivers/infiniband/hw/bng_re/bng_hw_counters.c
 create mode 100644 drivers/infiniband/hw/bng_re/bng_hw_counters.h

diff --git a/drivers/infiniband/hw/bng_re/Makefile b/drivers/infiniband/hw/bng_re/Makefile
index 5e650a35b185..a9a851cc2fa6 100644
--- a/drivers/infiniband/hw/bng_re/Makefile
+++ b/drivers/infiniband/hw/bng_re/Makefile
@@ -14,4 +14,5 @@ bng_re-y := \
 	bng_dev.o \
 	bng_sp.o \
 	bng_fp.o \
+	bng_hw_counters.o \
 	bng_verbs.o
diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index a42e24691cad..978b7efab03e 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -19,6 +19,7 @@
 #include "bng_re_mpc_roce.h"
 #include "bng_xid.h"
 #include "bng_verbs.h"
+#include "bng_hw_counters.h"
 
 MODULE_AUTHOR("Siva Reddy Kallam <siva.kallam@broadcom.com>");
 MODULE_DESCRIPTION(BNG_RE_DESC);
@@ -61,6 +62,8 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.modify_srq		= bng_re_modify_srq,
 	.query_srq		= bng_re_query_srq,
 	.destroy_srq		= bng_re_destroy_srq,
+	.alloc_hw_port_stats	= bng_re_alloc_hw_port_stats,
+	.get_hw_stats		= bng_re_ib_get_hw_stats,
 	INIT_RDMA_OBJ_SIZE(ib_srq, bng_re_srq, ib_srq),
 	INIT_RDMA_OBJ_SIZE(ib_cq, bng_re_cq, ib_cq),
 	INIT_RDMA_OBJ_SIZE(ib_pd, bng_re_pd, ib_pd),
diff --git a/drivers/infiniband/hw/bng_re/bng_fw.h b/drivers/infiniband/hw/bng_re/bng_fw.h
index f89e4aeb2469..011dc18592d0 100644
--- a/drivers/infiniband/hw/bng_re/bng_fw.h
+++ b/drivers/infiniband/hw/bng_re/bng_fw.h
@@ -28,11 +28,15 @@
 	   !((pass) & BNG_RE_FLAG_EPOCH_CONS_MASK))
 #define BNG_FW_CREQ_ENTRY_POLL_BUDGET	0x100
 
+#define BNG_RE_OOS_COUNT_MASK	0xFFFFFFFF
+
 /* CMDQ */
 struct bng_fw_cmdqe {
 	u8	data[16];
 };
 
+#define BNG_RE_CMDQE_UNITS		sizeof(struct bng_fw_cmdqe)
+
 #define BNG_FW_CMDQE_MAX_CNT		8192
 #define BNG_FW_CMDQE_UNITS		sizeof(struct bng_fw_cmdqe)
 #define BNG_FW_CMDQE_BYTES(depth)	((depth) * BNG_FW_CMDQE_UNITS)
@@ -40,6 +44,12 @@ struct bng_fw_cmdqe {
 #define BNG_FW_MAX_COOKIE_VALUE		(BNG_FW_CMDQE_MAX_CNT - 1)
 #define BNG_FW_CMD_IS_BLOCKING		0x8000
 
+struct bng_rcfw_sbuf {
+	void		*sb;
+	dma_addr_t	dma_addr;
+	u32		size;
+};
+
 /* Crsq buf is 1024-Byte */
 struct bng_re_crsbe {
 	u8			data[1024];
@@ -128,6 +138,8 @@ struct bng_re_rcfw {
 	/* cached from chip cctx for quick reference in slow path */
 	u16			max_timeout;
 	atomic_t		rcfw_intr_enabled;
+	u64			oos_prev;
+	u32			init_oos_stats;
 };
 
 struct bng_re_cmdqmsg {
diff --git a/drivers/infiniband/hw/bng_re/bng_hw_counters.c b/drivers/infiniband/hw/bng_re/bng_hw_counters.c
new file mode 100644
index 000000000000..cb9a00fed621
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_hw_counters.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2026 Broadcom.
+
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <rdma/ib_mad.h>
+#include <rdma/ib_pma.h>
+#include <rdma/bng_re-abi.h>
+
+#include "bng_res.h"
+#include "bng_sp.h"
+#include "bng_fw.h"
+#include "bnge.h"
+#include "bnge_auxr.h"
+#include "bng_fp.h"
+#include "bng_re.h"
+#include "bng_hw_counters.h"
+
+static const struct rdma_stat_desc bng_re_stat_descs[] = {
+	[BNG_RE_RX_PKTS].name		=  "rx_pkts",
+	[BNG_RE_RX_BYTES].name		=  "rx_bytes",
+	[BNG_RE_TX_PKTS].name		=  "tx_pkts",
+	[BNG_RE_TX_BYTES].name		=  "tx_bytes",
+	[BNG_RE_RECOVERABLE_ERRORS].name	=  "recoverable_errors",
+	[BNG_RE_TX_ERRORS].name                =  "tx_roce_errors",
+	[BNG_RE_TX_DISCARDS].name              =  "tx_roce_discards",
+	[BNG_RE_RX_ERRORS].name		=  "rx_roce_errors",
+	[BNG_RE_RX_DISCARDS].name		=  "rx_roce_discards",
+	[BNG_RE_TO_RETRANSMITS].name           =  "local_ack_timeout_err",
+	[BNG_RE_SEQ_ERR_NAKS_RCVD].name        =  "packet_seq_err",
+	[BNG_RE_MAX_RETRY_EXCEEDED].name	=  "max_retry_exceeded",
+	[BNG_RE_RNR_NAKS_RCVD].name            =  "rnr_nak_retry_err",
+	[BNG_RE_MISSING_RESP].name             =  "implied_nak_seq_err",
+	[BNG_RE_UNRECOVERABLE_ERR].name     = "unrecoverable_err",
+	[BNG_RE_BAD_RESP_ERR].name          = "bad_resp_err",
+	[BNG_RE_LOCAL_QP_OP_ERR].name       = "local_qp_op_err",
+	[BNG_RE_LOCAL_PROTECTION_ERR].name  = "local_protection_err",
+	[BNG_RE_MEM_MGMT_OP_ERR].name       = "mem_mgmt_op_err",
+	[BNG_RE_REMOTE_INVALID_REQ_ERR].name   = "req_remote_invalid_request",
+	[BNG_RE_REMOTE_ACCESS_ERR].name        = "req_remote_access_errors",
+	[BNG_RE_REMOTE_OP_ERR].name         = "remote_op_err",
+	[BNG_RE_DUP_REQ].name               = "duplicate_request",
+	[BNG_RE_RES_EXCEED_MAX].name        = "res_exceed_max",
+	[BNG_RE_RES_LENGTH_MISMATCH].name   = "resp_local_length_error",
+	[BNG_RE_RES_EXCEEDS_WQE].name       = "res_exceeds_wqe",
+	[BNG_RE_RES_OPCODE_ERR].name        = "res_opcode_err",
+	[BNG_RE_RES_RX_INVALID_RKEY].name   = "res_rx_invalid_rkey",
+	[BNG_RE_RES_RX_DOMAIN_ERR].name     = "res_rx_domain_err",
+	[BNG_RE_RES_RX_NO_PERM].name        = "res_rx_no_perm",
+	[BNG_RE_RES_RX_RANGE_ERR].name      = "res_rx_range_err",
+	[BNG_RE_RES_TX_INVALID_RKEY].name   = "res_tx_invalid_rkey",
+	[BNG_RE_RES_TX_DOMAIN_ERR].name     = "res_tx_domain_err",
+	[BNG_RE_RES_TX_NO_PERM].name        = "res_tx_no_perm",
+	[BNG_RE_RES_TX_RANGE_ERR].name      = "res_tx_range_err",
+	[BNG_RE_RES_IRRQ_OFLOW].name        = "res_irrq_oflow",
+	[BNG_RE_RES_UNSUP_OPCODE].name      = "res_unsup_opcode",
+	[BNG_RE_RES_UNALIGNED_ATOMIC].name  = "res_unaligned_atomic",
+	[BNG_RE_RES_REM_INV_ERR].name       = "res_rem_inv_err",
+	[BNG_RE_RES_MEM_ERROR].name         = "res_mem_err",
+	[BNG_RE_RES_SRQ_ERR].name           = "res_srq_err",
+	[BNG_RE_RES_CMP_ERR].name           = "res_cmp_err",
+	[BNG_RE_RES_INVALID_DUP_RKEY].name  = "res_invalid_dup_rkey",
+	[BNG_RE_RES_WQE_FORMAT_ERR].name    = "res_wqe_format_err",
+	[BNG_RE_RES_CQ_LOAD_ERR].name       = "res_cq_load_err",
+	[BNG_RE_RES_SRQ_LOAD_ERR].name      = "res_srq_load_err",
+	[BNG_RE_RES_TX_PCI_ERR].name        = "res_tx_pci_err",
+	[BNG_RE_RES_RX_PCI_ERR].name        = "res_rx_pci_err",
+	[BNG_RE_OUT_OF_SEQ_ERR].name        = "out_of_sequence",
+	[BNG_RE_TX_ATOMIC_REQ].name	     = "tx_atomic_req",
+	[BNG_RE_TX_READ_REQ].name	     = "tx_read_req",
+	[BNG_RE_TX_READ_RES].name	     = "tx_read_resp",
+	[BNG_RE_TX_WRITE_REQ].name	     = "tx_write_req",
+	[BNG_RE_TX_SEND_REQ].name	     = "tx_send_req",
+	[BNG_RE_TX_ROCE_PKTS].name          = "tx_roce_only_pkts",
+	[BNG_RE_TX_ROCE_BYTES].name         = "tx_roce_only_bytes",
+	[BNG_RE_RX_ATOMIC_REQ].name	     = "rx_atomic_requests",
+	[BNG_RE_RX_READ_REQ].name	     = "rx_read_requests",
+	[BNG_RE_RX_READ_RESP].name	     = "rx_read_resp",
+	[BNG_RE_RX_WRITE_REQ].name	     = "rx_write_requests",
+	[BNG_RE_RX_SEND_REQ].name	     = "rx_send_req",
+	[BNG_RE_RX_ROCE_PKTS].name          = "rx_roce_only_pkts",
+	[BNG_RE_RX_ROCE_BYTES].name         = "rx_roce_only_bytes",
+	[BNG_RE_RX_ROCE_GOOD_PKTS].name     = "rx_roce_good_pkts",
+	[BNG_RE_RX_ROCE_GOOD_BYTES].name    = "rx_roce_good_bytes",
+	[BNG_RE_OOB].name		     = "out_of_buffer",
+	[BNG_RE_TX_CNP].name                = "np_cnp_pkts",
+	[BNG_RE_RX_CNP].name                = "rp_cnp_handled",
+	[BNG_RE_RX_ECN].name                = "np_ecn_marked_roce_packets",
+	[BNG_RE_REQ_CQE_ERROR].name            = "req_cqe_error",
+	[BNG_RE_RESP_CQE_ERROR].name           = "resp_cqe_error",
+	[BNG_RE_RESP_REMOTE_ACCESS_ERRS].name  = "resp_remote_access_errors",
+};
+
+struct rdma_hw_stats *bng_re_alloc_hw_port_stats(struct ib_device *ibdev,
+						    u32 port_num)
+{
+	int num_counters = 0;
+
+	num_counters = BNG_RE_NUM_EXT_COUNTERS;
+
+	return rdma_alloc_hw_stats_struct(bng_re_stat_descs, num_counters,
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
+
+static void bng_re_copy_err_stats(struct bng_re_dev *rdev,
+				  struct rdma_hw_stats *stats,
+				  struct bng_roce_stats *err_s)
+{
+	stats->value[BNG_RE_TO_RETRANSMITS] =
+				err_s->to_retransmits;
+	stats->value[BNG_RE_SEQ_ERR_NAKS_RCVD] =
+				err_s->seq_err_naks_rcvd;
+	stats->value[BNG_RE_MAX_RETRY_EXCEEDED] =
+				err_s->max_retry_exceeded;
+	stats->value[BNG_RE_RNR_NAKS_RCVD] =
+				err_s->rnr_naks_rcvd;
+	stats->value[BNG_RE_MISSING_RESP] =
+				err_s->missing_resp;
+	stats->value[BNG_RE_UNRECOVERABLE_ERR] =
+				err_s->unrecoverable_err;
+	stats->value[BNG_RE_BAD_RESP_ERR] =
+				err_s->bad_resp_err;
+	stats->value[BNG_RE_LOCAL_QP_OP_ERR]	=
+			err_s->local_qp_op_err;
+	stats->value[BNG_RE_LOCAL_PROTECTION_ERR] =
+			err_s->local_protection_err;
+	stats->value[BNG_RE_MEM_MGMT_OP_ERR] =
+			err_s->mem_mgmt_op_err;
+	stats->value[BNG_RE_REMOTE_INVALID_REQ_ERR] =
+			err_s->remote_invalid_req_err;
+	stats->value[BNG_RE_REMOTE_ACCESS_ERR] =
+			err_s->remote_access_err;
+	stats->value[BNG_RE_REMOTE_OP_ERR] =
+			err_s->remote_op_err;
+	stats->value[BNG_RE_DUP_REQ] =
+			err_s->dup_req;
+	stats->value[BNG_RE_RES_EXCEED_MAX] =
+			err_s->res_exceed_max;
+	stats->value[BNG_RE_RES_LENGTH_MISMATCH] =
+			err_s->res_length_mismatch;
+	stats->value[BNG_RE_RES_EXCEEDS_WQE] =
+			err_s->res_exceeds_wqe;
+	stats->value[BNG_RE_RES_OPCODE_ERR] =
+			err_s->res_opcode_err;
+	stats->value[BNG_RE_RES_RX_INVALID_RKEY] =
+			err_s->res_rx_invalid_rkey;
+	stats->value[BNG_RE_RES_RX_DOMAIN_ERR] =
+			err_s->res_rx_domain_err;
+	stats->value[BNG_RE_RES_RX_NO_PERM] =
+			err_s->res_rx_no_perm;
+	stats->value[BNG_RE_RES_RX_RANGE_ERR]  =
+			err_s->res_rx_range_err;
+	stats->value[BNG_RE_RES_TX_INVALID_RKEY] =
+			err_s->res_tx_invalid_rkey;
+	stats->value[BNG_RE_RES_TX_DOMAIN_ERR] =
+			err_s->res_tx_domain_err;
+	stats->value[BNG_RE_RES_TX_NO_PERM] =
+			err_s->res_tx_no_perm;
+	stats->value[BNG_RE_RES_TX_RANGE_ERR]  =
+			err_s->res_tx_range_err;
+	stats->value[BNG_RE_RES_IRRQ_OFLOW] =
+			err_s->res_irrq_oflow;
+	stats->value[BNG_RE_RES_UNSUP_OPCODE]  =
+			err_s->res_unsup_opcode;
+	stats->value[BNG_RE_RES_UNALIGNED_ATOMIC] =
+			err_s->res_unaligned_atomic;
+	stats->value[BNG_RE_RES_REM_INV_ERR]   =
+			err_s->res_rem_inv_err;
+	stats->value[BNG_RE_RES_MEM_ERROR] =
+			err_s->res_mem_error;
+	stats->value[BNG_RE_RES_SRQ_ERR] =
+			err_s->res_srq_err;
+	stats->value[BNG_RE_RES_CMP_ERR] =
+			err_s->res_cmp_err;
+	stats->value[BNG_RE_RES_INVALID_DUP_RKEY] =
+			err_s->res_invalid_dup_rkey;
+	stats->value[BNG_RE_RES_WQE_FORMAT_ERR] =
+			err_s->res_wqe_format_err;
+	stats->value[BNG_RE_RES_CQ_LOAD_ERR]   =
+			err_s->res_cq_load_err;
+	stats->value[BNG_RE_RES_SRQ_LOAD_ERR]  =
+			err_s->res_srq_load_err;
+	stats->value[BNG_RE_RES_TX_PCI_ERR]    =
+			err_s->res_tx_pci_err;
+	stats->value[BNG_RE_RES_RX_PCI_ERR]    =
+			err_s->res_rx_pci_err;
+	stats->value[BNG_RE_OUT_OF_SEQ_ERR]    =
+			err_s->res_oos_drop_count;
+	stats->value[BNG_RE_REQ_CQE_ERROR]     =
+			err_s->bad_resp_err +
+			err_s->local_qp_op_err +
+			err_s->local_protection_err +
+			err_s->mem_mgmt_op_err +
+			err_s->remote_invalid_req_err +
+			err_s->remote_access_err +
+			err_s->remote_op_err;
+	stats->value[BNG_RE_RESP_CQE_ERROR] =
+			err_s->res_cmp_err +
+			err_s->res_cq_load_err;
+	stats->value[BNG_RE_RESP_REMOTE_ACCESS_ERRS] =
+			err_s->res_rx_no_perm +
+			err_s->res_tx_no_perm;
+}
+
+static void bng_re_copy_ext_stats(struct bng_re_dev *rdev,
+				  struct rdma_hw_stats *stats,
+				  struct bng_re_ext_stat *s)
+{
+	stats->value[BNG_RE_TX_ATOMIC_REQ] = s->tx_atomic_req;
+	stats->value[BNG_RE_TX_READ_REQ]   = s->tx_read_req;
+	stats->value[BNG_RE_TX_READ_RES]   = s->tx_read_res;
+	stats->value[BNG_RE_TX_WRITE_REQ]  = s->tx_write_req;
+	stats->value[BNG_RE_TX_SEND_REQ]   = s->tx_send_req;
+	stats->value[BNG_RE_TX_ROCE_PKTS]  = s->tx_roce_pkts;
+	stats->value[BNG_RE_TX_ROCE_BYTES] = s->tx_roce_bytes;
+	stats->value[BNG_RE_RX_ATOMIC_REQ] = s->rx_atomic_req;
+	stats->value[BNG_RE_RX_READ_REQ]   = s->rx_read_req;
+	stats->value[BNG_RE_RX_READ_RESP]  = s->rx_read_res;
+	stats->value[BNG_RE_RX_WRITE_REQ]  = s->rx_write_req;
+	stats->value[BNG_RE_RX_SEND_REQ]   = s->rx_send_req;
+	stats->value[BNG_RE_RX_ROCE_PKTS]  = s->rx_roce_pkts;
+	stats->value[BNG_RE_RX_ROCE_BYTES] = s->rx_roce_bytes;
+	stats->value[BNG_RE_RX_ROCE_GOOD_PKTS] = s->rx_roce_good_pkts;
+	stats->value[BNG_RE_RX_ROCE_GOOD_BYTES] = s->rx_roce_good_bytes;
+	stats->value[BNG_RE_OOB] = s->rx_out_of_buffer;
+	stats->value[BNG_RE_TX_CNP] = s->tx_cnp;
+	stats->value[BNG_RE_RX_CNP] = s->rx_cnp;
+	stats->value[BNG_RE_RX_ECN] = s->rx_ecn_marked;
+	stats->value[BNG_RE_OUT_OF_SEQ_ERR] = s->rx_out_of_sequence;
+}
+
+static int bng_re_get_ext_stat(struct bng_re_dev *rdev,
+			       struct rdma_hw_stats *stats)
+{
+	struct bng_re_ext_stat *estat = &rdev->stats.rstat.ext_stat;
+	u32 fid;
+	int rc;
+
+	fid = PCI_FUNC(rdev->aux_dev->pdev->devfn);
+	rc = bng_re_qext_stat(&rdev->rcfw, fid, estat);
+	if (rc)
+		goto done;
+	bng_re_copy_ext_stats(rdev, stats, estat);
+
+done:
+	return rc;
+}
+
+int bng_re_ib_get_hw_stats(struct ib_device *ibdev,
+			   struct rdma_hw_stats *stats,
+			   u32 port, int index)
+{
+	struct bng_re_dev *rdev = to_bng_re_dev(ibdev, ibdev);
+	struct bng_roce_stats *err_s = NULL;
+	struct ctx_hw_stats *hw_stats = NULL;
+	int rc  = 0;
+
+	hw_stats = rdev->ctx.stats.dma;
+	if (!port || !stats)
+		return -EINVAL;
+
+	if (hw_stats) {
+		stats->value[BNG_RE_RECOVERABLE_ERRORS] =
+			le64_to_cpu(hw_stats->tx_bcast_pkts);
+		stats->value[BNG_RE_TX_DISCARDS] =
+			le64_to_cpu(hw_stats->tx_discard_pkts);
+		stats->value[BNG_RE_TX_ERRORS] =
+			le64_to_cpu(hw_stats->tx_error_pkts);
+		stats->value[BNG_RE_RX_ERRORS] =
+			le64_to_cpu(hw_stats->rx_error_pkts);
+		stats->value[BNG_RE_RX_DISCARDS] =
+			le64_to_cpu(hw_stats->rx_discard_pkts);
+		stats->value[BNG_RE_RX_PKTS] =
+			le64_to_cpu(hw_stats->rx_ucast_pkts);
+		stats->value[BNG_RE_RX_BYTES] =
+			le64_to_cpu(hw_stats->rx_ucast_bytes);
+		stats->value[BNG_RE_TX_PKTS] =
+			le64_to_cpu(hw_stats->tx_ucast_pkts);
+		stats->value[BNG_RE_TX_BYTES] =
+			le64_to_cpu(hw_stats->tx_ucast_bytes);
+	}
+	err_s = &rdev->stats.rstat.errs;
+	if (test_bit(BNG_RE_FLAG_ISSUE_ROCE_STATS, &rdev->flags)) {
+		rc = bng_re_get_roce_stats(&rdev->rcfw, err_s);
+		if (rc) {
+			clear_bit(BNG_RE_FLAG_ISSUE_ROCE_STATS,
+				  &rdev->flags);
+			goto done;
+		}
+		bng_re_copy_err_stats(rdev, stats, err_s);
+		if (bng_ext_stats_supported(rdev->chip_ctx, rdev->dev_attr->dev_cap_flags,
+					     rdev->bng_res.is_vf)) {
+			rc = bng_re_get_ext_stat(rdev, stats);
+			if (rc) {
+				clear_bit(BNG_RE_FLAG_ISSUE_ROCE_STATS,
+					  &rdev->flags);
+				goto done;
+			}
+		}
+	}
+
+done:
+	return BNG_RE_NUM_EXT_COUNTERS;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_hw_counters.h b/drivers/infiniband/hw/bng_re/bng_hw_counters.h
new file mode 100644
index 000000000000..792dbb655f7e
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_hw_counters.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+// Copyright (c) 2026 Broadcom
+//
+#ifndef __HW_COUNTERS_H__
+#define __HW_COUNTERS_H__
+
+struct bng_roce_stats;
+struct bng_re_ext_stat;
+
+enum bng_re_hw_enum_stats {
+	BNG_RE_RX_PKTS,
+	BNG_RE_RX_BYTES,
+	BNG_RE_TX_PKTS,
+	BNG_RE_TX_BYTES,
+	BNG_RE_RECOVERABLE_ERRORS,
+	BNG_RE_TX_ERRORS,
+	BNG_RE_TX_DISCARDS,
+	BNG_RE_RX_ERRORS,
+	BNG_RE_RX_DISCARDS,
+	BNG_RE_TO_RETRANSMITS,
+	BNG_RE_SEQ_ERR_NAKS_RCVD,
+	BNG_RE_MAX_RETRY_EXCEEDED,
+	BNG_RE_RNR_NAKS_RCVD,
+	BNG_RE_MISSING_RESP,
+	BNG_RE_UNRECOVERABLE_ERR,
+	BNG_RE_BAD_RESP_ERR,
+	BNG_RE_LOCAL_QP_OP_ERR,
+	BNG_RE_LOCAL_PROTECTION_ERR,
+	BNG_RE_MEM_MGMT_OP_ERR,
+	BNG_RE_REMOTE_INVALID_REQ_ERR,
+	BNG_RE_REMOTE_ACCESS_ERR,
+	BNG_RE_REMOTE_OP_ERR,
+	BNG_RE_DUP_REQ,
+	BNG_RE_RES_EXCEED_MAX,
+	BNG_RE_RES_LENGTH_MISMATCH,
+	BNG_RE_RES_EXCEEDS_WQE,
+	BNG_RE_RES_OPCODE_ERR,
+	BNG_RE_RES_RX_INVALID_RKEY,
+	BNG_RE_RES_RX_DOMAIN_ERR,
+	BNG_RE_RES_RX_NO_PERM,
+	BNG_RE_RES_RX_RANGE_ERR,
+	BNG_RE_RES_TX_INVALID_RKEY,
+	BNG_RE_RES_TX_DOMAIN_ERR,
+	BNG_RE_RES_TX_NO_PERM,
+	BNG_RE_RES_TX_RANGE_ERR,
+	BNG_RE_RES_IRRQ_OFLOW,
+	BNG_RE_RES_UNSUP_OPCODE,
+	BNG_RE_RES_UNALIGNED_ATOMIC,
+	BNG_RE_RES_REM_INV_ERR,
+	BNG_RE_RES_MEM_ERROR,
+	BNG_RE_RES_SRQ_ERR,
+	BNG_RE_RES_CMP_ERR,
+	BNG_RE_RES_INVALID_DUP_RKEY,
+	BNG_RE_RES_WQE_FORMAT_ERR,
+	BNG_RE_RES_CQ_LOAD_ERR,
+	BNG_RE_RES_SRQ_LOAD_ERR,
+	BNG_RE_RES_TX_PCI_ERR,
+	BNG_RE_RES_RX_PCI_ERR,
+	BNG_RE_OUT_OF_SEQ_ERR,
+	BNG_RE_TX_ATOMIC_REQ,
+	BNG_RE_TX_READ_REQ,
+	BNG_RE_TX_READ_RES,
+	BNG_RE_TX_WRITE_REQ,
+	BNG_RE_TX_SEND_REQ,
+	BNG_RE_TX_ROCE_PKTS,
+	BNG_RE_TX_ROCE_BYTES,
+	BNG_RE_RX_ATOMIC_REQ,
+	BNG_RE_RX_READ_REQ,
+	BNG_RE_RX_READ_RESP,
+	BNG_RE_RX_WRITE_REQ,
+	BNG_RE_RX_SEND_REQ,
+	BNG_RE_RX_ROCE_PKTS,
+	BNG_RE_RX_ROCE_BYTES,
+	BNG_RE_RX_ROCE_GOOD_PKTS,
+	BNG_RE_RX_ROCE_GOOD_BYTES,
+	BNG_RE_OOB,
+	BNG_RE_TX_CNP,
+	BNG_RE_RX_CNP,
+	BNG_RE_RX_ECN,
+	BNG_RE_REQ_CQE_ERROR,
+	BNG_RE_RESP_CQE_ERROR,
+	BNG_RE_RESP_REMOTE_ACCESS_ERRS,
+	BNG_RE_NUM_EXT_COUNTERS
+};
+
+struct bng_re_res_cntrs {
+	atomic_t qp_count;
+	atomic_t rc_qp_count;
+	atomic_t ud_qp_count;
+	atomic_t cq_count;
+	atomic_t srq_count;
+	atomic_t mr_count;
+	atomic_t mr_dmabuf_count;
+	atomic_t peer_mem_mr_count;
+	atomic_t mw_count;
+	atomic_t ah_count;
+	atomic_t ah_hw_count;
+	atomic_t pd_count;
+	atomic_t resize_count;
+	atomic_t max_qp_count;
+	atomic_t max_rc_qp_count;
+	atomic_t max_ud_qp_count;
+	atomic_t max_cq_count;
+	atomic_t max_srq_count;
+	atomic_t max_mr_count;
+	atomic_t max_mr_dmabuf_count;
+	atomic_t max_peer_mem_mr_count;
+	atomic_t max_mw_count;
+	atomic_t max_ah_count;
+	atomic_t max_ah_hw_count;
+	atomic_t max_pd_count;
+};
+
+struct rdma_hw_stats *bng_re_alloc_hw_port_stats(struct ib_device *ibdev,
+					    u32 port_num);
+int bng_re_ib_get_hw_stats(struct ib_device *ibdev, struct rdma_hw_stats *stats,
+			u32 port, int index);
+#endif /* __HW_COUNTERS_H__ */
diff --git a/drivers/infiniband/hw/bng_re/bng_re.h b/drivers/infiniband/hw/bng_re/bng_re.h
index 70851f1180d0..414768585e67 100644
--- a/drivers/infiniband/hw/bng_re/bng_re.h
+++ b/drivers/infiniband/hw/bng_re/bng_re.h
@@ -9,6 +9,7 @@
 #include "bng_res.h"
 #include "bng_fw.h"
 #include "bng_sp.h"
+#include "bng_hw_counters.h"
 #include <rdma/ib_verbs.h>
 
 #define BNG_RE_XID_AVOID_REUSE		false
@@ -273,6 +274,7 @@ struct bng_re_dev {
 #define BNG_RE_FLAG_NETDEV_REGISTERED		0
 #define BNG_RE_FLAG_RCFW_CHANNEL_EN		1
 #define BNG_RE_FLAG_TBLS_ALLOC_INITED		2
+#define BNG_RE_FLAG_ISSUE_ROCE_STATS		29
 #define BNG_RE_FLAG_MPC_FW_CHANNEL_EN		31
 #define BNG_RE_FLAG_MPC_FW_THREAD_EN		32
 #define BNG_RE_FLAG_MPC_DB_PAGE_EN		34
@@ -297,6 +299,8 @@ struct bng_re_dev {
 	struct bng_sp_cq_coal_param	cq_coalescing;
 	DECLARE_HASHTABLE(cq_hash, MAX_CQ_HASH_BITS);
 	DECLARE_HASHTABLE(srq_hash, 8);  /* SRQ hash table */
+	struct bng_re_hw_stats		stats;
+	struct bng_re_ctx		ctx;
 };
 
 #define to_bng_re_dev(ptr, member)	\
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index 00429b4a7d30..5a6db1786886 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -227,6 +227,15 @@ struct bng_re_res {
 	/* Serialize access to PD table */
 	struct mutex			pd_tbl_lock;
 	struct bng_re_rcfw		*rcfw;
+	bool   is_vf;
+};
+
+struct bng_re_ctx {
+	u32				qpc_count;
+	u32				mrw_count;
+	u32				srqc_count;
+	u32				cq_count;
+	struct bng_re_stats		stats;
 };
 
 #define to_bng_re_res(ptr, member)	container_of(ptr, struct bng_re_res, member)
@@ -394,6 +403,18 @@ static inline u8 bng_re_base_pg_size(struct bng_re_hwq *hwq)
 	return pg_size;
 }
 
+static inline bool _is_ext_stats_supported(u16 dev_cap_flags)
+{
+	return dev_cap_flags & CREQ_QUERY_FUNC_RESP_SB_EXT_STATS;
+}
+
+static inline int bng_ext_stats_supported(struct bng_re_chip_ctx *ctx,
+				      u16 flags, bool virtfn)
+{
+	return (_is_ext_stats_supported(flags) && ((virtfn) || (!virtfn)));
+}
+
+
 void bng_re_free_hwq(struct bng_re_res *res,
 		     struct bng_re_hwq *hwq);
 
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index 78e2bb9ad859..26435fe4e892 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -960,3 +960,147 @@ int bng_sp_destroy_srq(struct bng_re_res *res, struct bng_sp_srq *srq)
 
 	return 0;
 }
+
+int bng_re_get_roce_stats(struct bng_re_rcfw *rcfw, struct bng_roce_stats *stats)
+{
+	struct creq_query_roce_stats_resp resp = {};
+	struct creq_query_roce_stats_resp_sb *sb;
+	struct cmdq_query_roce_stats req = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct bng_rcfw_sbuf sbuf;
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			      CMDQ_BASE_OPCODE_QUERY_ROCE_STATS, sizeof(req));
+
+	sbuf.size = ALIGN(sizeof(*sb), BNG_RE_CMDQE_UNITS);
+	sbuf.sb = dma_alloc_coherent(&rcfw->pdev->dev, sbuf.size,
+				     &sbuf.dma_addr, GFP_KERNEL);
+	if (!sbuf.sb)
+		return -ENOMEM;
+	sb = sbuf.sb;
+	req.resp_size = sbuf.size / BNG_RE_CMDQE_UNITS;
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, &sbuf, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		goto bail;
+	stats->to_retransmits = le64_to_cpu(sb->to_retransmits);
+	stats->seq_err_naks_rcvd = le64_to_cpu(sb->seq_err_naks_rcvd);
+	stats->max_retry_exceeded = le64_to_cpu(sb->max_retry_exceeded);
+	stats->rnr_naks_rcvd = le64_to_cpu(sb->rnr_naks_rcvd);
+	stats->missing_resp = le64_to_cpu(sb->missing_resp);
+	stats->unrecoverable_err = le64_to_cpu(sb->unrecoverable_err);
+	stats->bad_resp_err = le64_to_cpu(sb->bad_resp_err);
+	stats->local_qp_op_err = le64_to_cpu(sb->local_qp_op_err);
+	stats->local_protection_err = le64_to_cpu(sb->local_protection_err);
+	stats->mem_mgmt_op_err = le64_to_cpu(sb->mem_mgmt_op_err);
+	stats->remote_invalid_req_err = le64_to_cpu(sb->remote_invalid_req_err);
+	stats->remote_access_err = le64_to_cpu(sb->remote_access_err);
+	stats->remote_op_err = le64_to_cpu(sb->remote_op_err);
+	stats->dup_req = le64_to_cpu(sb->dup_req);
+	stats->res_exceed_max = le64_to_cpu(sb->res_exceed_max);
+	stats->res_length_mismatch = le64_to_cpu(sb->res_length_mismatch);
+	stats->res_exceeds_wqe = le64_to_cpu(sb->res_exceeds_wqe);
+	stats->res_opcode_err = le64_to_cpu(sb->res_opcode_err);
+	stats->res_rx_invalid_rkey = le64_to_cpu(sb->res_rx_invalid_rkey);
+	stats->res_rx_domain_err = le64_to_cpu(sb->res_rx_domain_err);
+	stats->res_rx_no_perm = le64_to_cpu(sb->res_rx_no_perm);
+	stats->res_rx_range_err = le64_to_cpu(sb->res_rx_range_err);
+	stats->res_tx_invalid_rkey = le64_to_cpu(sb->res_tx_invalid_rkey);
+	stats->res_tx_domain_err = le64_to_cpu(sb->res_tx_domain_err);
+	stats->res_tx_no_perm = le64_to_cpu(sb->res_tx_no_perm);
+	stats->res_tx_range_err = le64_to_cpu(sb->res_tx_range_err);
+	stats->res_irrq_oflow = le64_to_cpu(sb->res_irrq_oflow);
+	stats->res_unsup_opcode = le64_to_cpu(sb->res_unsup_opcode);
+	stats->res_unaligned_atomic = le64_to_cpu(sb->res_unaligned_atomic);
+	stats->res_rem_inv_err = le64_to_cpu(sb->res_rem_inv_err);
+	stats->res_mem_error = le64_to_cpu(sb->res_mem_error);
+	stats->res_srq_err = le64_to_cpu(sb->res_srq_err);
+	stats->res_cmp_err = le64_to_cpu(sb->res_cmp_err);
+	stats->res_invalid_dup_rkey = le64_to_cpu(sb->res_invalid_dup_rkey);
+	stats->res_wqe_format_err = le64_to_cpu(sb->res_wqe_format_err);
+	stats->res_cq_load_err = le64_to_cpu(sb->res_cq_load_err);
+	stats->res_srq_load_err = le64_to_cpu(sb->res_srq_load_err);
+	stats->res_tx_pci_err = le64_to_cpu(sb->res_tx_pci_err);
+	stats->res_rx_pci_err = le64_to_cpu(sb->res_rx_pci_err);
+	if (!rcfw->init_oos_stats) {
+		rcfw->oos_prev = le64_to_cpu(sb->res_oos_drop_count);
+		rcfw->init_oos_stats = 1;
+	} else {
+		stats->res_oos_drop_count +=
+				(le64_to_cpu(sb->res_oos_drop_count) -
+				 rcfw->oos_prev) & BNG_RE_OOS_COUNT_MASK;
+		rcfw->oos_prev = le64_to_cpu(sb->res_oos_drop_count);
+	}
+
+bail:
+	dma_free_coherent(&rcfw->pdev->dev, sbuf.size,
+			  sbuf.sb, sbuf.dma_addr);
+	return rc;
+}
+
+int bng_re_qext_stat(struct bng_re_rcfw *rcfw, u32 fid,
+		     struct bng_re_ext_stat *estat)
+{
+	struct creq_query_roce_stats_ext_resp resp = {};
+	struct creq_query_roce_stats_ext_resp_sb *sb;
+	struct cmdq_query_roce_stats_ext req = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct bng_rcfw_sbuf sbuf;
+	int rc;
+
+	sbuf.size = ALIGN(sizeof(*sb), BNG_RE_CMDQE_UNITS);
+	sbuf.sb = dma_alloc_coherent(&rcfw->pdev->dev, sbuf.size,
+				     &sbuf.dma_addr, GFP_KERNEL);
+	if (!sbuf.sb)
+		return -ENOMEM;
+
+	sb = sbuf.sb;
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			      CMDQ_QUERY_ROCE_STATS_EXT_OPCODE_QUERY_ROCE_STATS,
+			      sizeof(req));
+
+	req.resp_size = sbuf.size / BNG_RE_CMDQE_UNITS;
+	req.resp_addr = cpu_to_le64(sbuf.dma_addr);
+	if (rcfw->res->is_vf)
+		req.function_id =
+			cpu_to_le32(CMDQ_QUERY_ROCE_STATS_EXT_VF_VALID |
+				    (fid << CMDQ_QUERY_ROCE_STATS_EXT_VF_NUM_SFT));
+	else
+		req.function_id = cpu_to_le32(fid);
+	req.flags = cpu_to_le16(CMDQ_QUERY_ROCE_STATS_EXT_FLAGS_FUNCTION_ID);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, &sbuf, sizeof(req),
+				sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		goto bail;
+
+	estat->tx_atomic_req = le64_to_cpu(sb->tx_atomic_req_pkts);
+	estat->tx_read_req = le64_to_cpu(sb->tx_read_req_pkts);
+	estat->tx_read_res = le64_to_cpu(sb->tx_read_res_pkts);
+	estat->tx_write_req = le64_to_cpu(sb->tx_write_req_pkts);
+	estat->tx_send_req = le64_to_cpu(sb->tx_send_req_pkts);
+	estat->tx_roce_pkts = le64_to_cpu(sb->tx_roce_pkts);
+	estat->tx_roce_bytes = le64_to_cpu(sb->tx_roce_bytes);
+	estat->rx_atomic_req = le64_to_cpu(sb->rx_atomic_req_pkts);
+	estat->rx_read_req = le64_to_cpu(sb->rx_read_req_pkts);
+	estat->rx_read_res = le64_to_cpu(sb->rx_read_res_pkts);
+	estat->rx_write_req = le64_to_cpu(sb->rx_write_req_pkts);
+	estat->rx_send_req = le64_to_cpu(sb->rx_send_req_pkts);
+	estat->rx_roce_pkts = le64_to_cpu(sb->rx_roce_pkts);
+	estat->rx_roce_bytes = le64_to_cpu(sb->rx_roce_bytes);
+	estat->rx_roce_good_pkts = le64_to_cpu(sb->rx_roce_good_pkts);
+	estat->rx_roce_good_bytes = le64_to_cpu(sb->rx_roce_good_bytes);
+	estat->rx_out_of_buffer = le64_to_cpu(sb->rx_out_of_buffer_pkts);
+	estat->rx_out_of_sequence = le64_to_cpu(sb->rx_out_of_sequence_pkts);
+	estat->tx_cnp = le64_to_cpu(sb->tx_cnp_pkts);
+	estat->rx_cnp = le64_to_cpu(sb->rx_cnp_pkts);
+	estat->rx_ecn_marked = le64_to_cpu(sb->rx_ecn_marked_pkts);
+
+bail:
+	dma_free_coherent(&rcfw->pdev->dev, sbuf.size,
+			  sbuf.sb, sbuf.dma_addr);
+	return rc;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index da4dceba4f46..d69d97e1940b 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -191,6 +191,86 @@ struct bng_sp_srq {
 	u16				eventq_hw_ring_id;
 };
 
+struct bng_roce_stats {
+	u64	to_retransmits;
+	u64	seq_err_naks_rcvd;
+	u64	max_retry_exceeded;
+	u64	rnr_naks_rcvd;
+	u64	missing_resp;
+	u64	unrecoverable_err;
+	u64	bad_resp_err;
+	u64	local_qp_op_err;
+	u64	local_protection_err;
+	u64	mem_mgmt_op_err;
+	u64	remote_invalid_req_err;
+	u64	remote_access_err;
+	u64	remote_op_err;
+	u64	dup_req;
+	u64	res_exceed_max;
+	u64	res_length_mismatch;
+	u64	res_exceeds_wqe;
+	u64	res_opcode_err;
+	u64	res_rx_invalid_rkey;
+	u64	res_rx_domain_err;
+	u64	res_rx_no_perm;
+	u64	res_rx_range_err;
+	u64	res_tx_invalid_rkey;
+	u64	res_tx_domain_err;
+	u64	res_tx_no_perm;
+	u64	res_tx_range_err;
+	u64	res_irrq_oflow;
+	u64	res_unsup_opcode;
+	u64	res_unaligned_atomic;
+	u64	res_rem_inv_err;
+	u64	res_mem_error;
+	u64	res_srq_err;
+	u64	res_cmp_err;
+	u64	res_invalid_dup_rkey;
+	u64	res_wqe_format_err;
+	u64	res_cq_load_err;
+	u64	res_srq_load_err;
+	u64	res_tx_pci_err;
+	u64	res_rx_pci_err;
+	u64	res_oos_drop_count;
+	u64	active_qp_count_p0;
+	u64	active_qp_count_p1;
+	u64	active_qp_count_p2;
+	u64	active_qp_count_p3;
+};
+
+struct bng_re_ext_stat {
+	u64	tx_atomic_req;
+	u64	tx_read_req;
+	u64	tx_read_res;
+	u64	tx_write_req;
+	u64	tx_send_req;
+	u64	tx_roce_pkts;
+	u64	tx_roce_bytes;
+	u64	rx_atomic_req;
+	u64	rx_read_req;
+	u64	rx_read_res;
+	u64	rx_write_req;
+	u64	rx_send_req;
+	u64	rx_roce_pkts;
+	u64	rx_roce_bytes;
+	u64	rx_roce_good_pkts;
+	u64	rx_roce_good_bytes;
+	u64	rx_out_of_buffer;
+	u64	rx_out_of_sequence;
+	u64	tx_cnp;
+	u64	rx_cnp;
+	u64	rx_ecn_marked;
+};
+
+struct bng_re_rstat {
+	struct bng_roce_stats	errs;
+	struct bng_re_ext_stat	ext_stat;
+};
+
+struct bng_re_hw_stats {
+	struct bng_re_rstat            rstat;
+};
+
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -228,5 +308,9 @@ int bng_sp_destroy_cq(struct bng_re_res *res, struct bng_sp_cq *cq);
 int bng_sp_create_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
 int bng_sp_query_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
 int bng_sp_destroy_srq(struct bng_re_res *res, struct bng_sp_srq *srq);
+int bng_re_qext_stat(struct bng_re_rcfw *rcfw, u32 fid,
+		     struct bng_re_ext_stat *estat);
+int bng_re_get_roce_stats(struct bng_re_rcfw *rcfw,
+		     struct bng_roce_stats *stats);
 
 #endif
-- 
2.43.5

