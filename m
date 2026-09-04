Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96AE473C8C
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519175; cv=none; b=KBWs6OpCe3TuSYRsEgQaFNEVYwKTLLPcStU6ANaGCcy9d6iBJs8GND4sUHlLBwdjRiBR8nvEqKZ2qCBDFLujfYPPEi9zRfft7tlTG3kRsQmIfgUHoV63dFAZhPlvBgGavfMobIqfMG52Q5y20/NbTEZdSg72jh7X6BtQ6fG2ILA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519175; c=relaxed/simple;
	bh=5RnVP50Jw4OOVTgDZ+jpxpWKhsvLq0OchPhXCviaiHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR2XLyN34sCrQRbhK4gAmFOlybzhPHKHBCV99NWEU8UzAqpbj0SSLTV8Y4g3DmXx6ctYWjRVcmjptIyuqWGwZshWZoyeTDM7SaNgl60Rwh6ff5xOaGgDa54QtefqhsQ3J5x4s44VF2PX/hU8U2+MTwLgyOYolmUMktC719yBGq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Plc6nwPd; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Plc6nwPd"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7f4f53975e6so769752a34.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519164; x=1789123964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nxoLV8SOLC5W282cKJPffUsodQfNCPPge1WzFuhBQiE=;
        b=KdCLPcz3YS4AxY8VFEoMWVXuImE3MIHHG3uCZLk4qO0yeionXUV+7Fz9IrQ4PBAyZu
         MUUIJIMoZBqYFYZIhXc7CpoBf/KTpTNS04D3DAA4IJPlqD3E91EhHToWsq41KZdqqbSt
         riqj3a+XZgovSa5u6SE/BFdMrrroUIP7MvMDz+Bi7O+4E6zLnz5srA/K0WvkHmxLY3fA
         yRXE/hVkcsb6RiT5HD52HUSryt4ZUiRA2yyCqcvSSBFRLhHwZnf4y6T38lJfApSt4Jh8
         o+YXCvFwHS2vbgsQ/mUrI5f2LD2KJBYeJx7Xui6mtFNuGXNEzfEJRB/SFQgCVt/L/Btc
         KZsA==
X-Forwarded-Encrypted: i=1; AKwUvBxLmFLaaBHC72N5mwzz5hrfP/DhIaNkHJplDbgzv6MKIcv1rI3s2exLSXE/1VBvFmB8847VZk/zOeLv@vger.kernel.org
X-Gm-Message-State: AFuF++n+e5s4ETGe8UtBDEUbeampmFMdS7HYjK4xgAGWHR5yczu8JuMw
	iVRy7sIVPpxXJVOmPCcKKNIy9x0SrzDmMCJe8QzFrhqo8kTd/ihDiJ87Vll40bvB2HzihYrLV2/
	nrFrOijgUYZbrcv2dwZRlPUIbzKgnFYywDATJ2Ksuto3YBqxAipLnNb/GABgp0XRjLAhRsuPLmk
	AdTWQvaLJnmb8ADBQLbbA4g9G3561nIrN62hX/lT/pxZuTwLeSEBfw7plR+KU/0mKqixsThZlQi
	oNPpNd0SSPRLq5o9g==
X-Gm-Gg: AYBFou2ggdTyylEZZ8gxA49qglLjGbIDMgU8M2wTjyrUajyOu50RPBPO3V0d6/Y/oQY
	wmCsImkZDw8SVa+S1dT6f5W9NhtvwlnXNgtUqlUD03fCr1gMP4gDdvn+R98o+3z3VK+lYyzEO7C
	YN6/kF6hST3hTTQJ9NAnEgsE2eUpifOX0WEgHwk8x6BdfyuBCF8vFXLoJQoprXmGzu8aen0C5Vz
	7Ek50tmehNAXumNdJ6Xm2eSBkbuvvCNjSGrWS9+txNOb+dNpbyCMUzAnAK37BlKT9gbt4XaXcJp
	74BS5VWMkOtkrJBpVCxKkefWwc2nnMhBJrNjVfoZEiU+wWXUZCCARFDuaJeBCPQ/DqdvrMCQ+Oq
	n3K9ZqrHa7VAdCJDq2EUhYraj7MStE9TSNQ7PrRdegXJM1r3qPbXMLC3RKX6JPy4uTF6ZpdI3vv
	eDLaTJeV1hqYiJI9v8O13Qc+0XMAdFfGr2qQ==
X-Received: by 2002:a05:6830:3155:b0:7f4:e1af:9b35 with SMTP id 46e09a7af769-7fa1adbc4a9mr4324731a34.0.1788519164000;
        Fri, 04 Sep 2026 03:52:44 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7f9f6ca3671sm270748a34.6.2026.09.04.03.52.43
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:43 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so1856439a91.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519162; x=1789123962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxoLV8SOLC5W282cKJPffUsodQfNCPPge1WzFuhBQiE=;
        b=Plc6nwPdbBQEI+uTrOKm9FO4CbgDTaoMtSW/ySeVkUzMuHMR+yOHwwt8tXE9pPyxGH
         VMoBjXVB962UepDLUj5KQ72j2sdU2xkoubWh+hlcaUkA3odoS2gQqoG0zB7iZVukowZQ
         S7WBp8wCnrP4Mu2KMBoTS32mN27HcI9rz7AMo=
X-Forwarded-Encrypted: i=1; AKwUvBzT+cOVbLVzZZtQMLV4qD1aiGR4J/nxNaapv5RBxPY8brre+O7s7AaeFIJDmGOSi5xCQuSOmyMGxWOE@vger.kernel.org
X-Received: by 2002:a17:90b:3943:b0:398:d8eb:cb2a with SMTP id 98e67ed59e1d1-39b26273e31mr8943914a91.23.1788519161733;
        Fri, 04 Sep 2026 03:52:41 -0700 (PDT)
X-Received: by 2002:a17:90b:3943:b0:398:d8eb:cb2a with SMTP id 98e67ed59e1d1-39b26273e31mr8943821a91.23.1788519161094;
        Fri, 04 Sep 2026 03:52:41 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:40 -0700 (PDT)
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
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 10/15] RDMA/bng_re: Add CQ verbs
Date: Fri,  4 Sep 2026 03:43:18 -0700
Message-ID: <20260904104328.763768-11-siva.kallam@broadcom.com>
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

This patch adds below verbs.
- bng_re_create_cq
- bng_re_create_user_cq
- bng_re_resize_cq
- bng_re_req_notify_cq
- bng_re_destroy_cq

Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/Makefile    |   1 +
 drivers/infiniband/hw/bng_re/bng_dev.c   |  17 ++
 drivers/infiniband/hw/bng_re/bng_fp.c    |  38 +++
 drivers/infiniband/hw/bng_re/bng_fp.h    |   8 +
 drivers/infiniband/hw/bng_re/bng_re.h    |   6 +
 drivers/infiniband/hw/bng_re/bng_res.h   |  73 ++++++
 drivers/infiniband/hw/bng_re/bng_sp.c    | 235 ++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_sp.h    |  73 ++++++
 drivers/infiniband/hw/bng_re/bng_verbs.c | 303 +++++++++++++++++++++++
 drivers/infiniband/hw/bng_re/bng_verbs.h |  32 +++
 include/uapi/rdma/bng_re-abi.h           |  21 ++
 11 files changed, 807 insertions(+)
 create mode 100644 drivers/infiniband/hw/bng_re/bng_fp.c
 create mode 100644 drivers/infiniband/hw/bng_re/bng_fp.h

diff --git a/drivers/infiniband/hw/bng_re/Makefile b/drivers/infiniband/hw/bng_re/Makefile
index 1b954a35993b..5e650a35b185 100644
--- a/drivers/infiniband/hw/bng_re/Makefile
+++ b/drivers/infiniband/hw/bng_re/Makefile
@@ -13,4 +13,5 @@ bng_re-y := \
 	bng_fw.o \
 	bng_dev.o \
 	bng_sp.o \
+	bng_fp.o \
 	bng_verbs.o
diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 44c278a93778..9c35c56ae583 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -52,6 +52,12 @@ static const struct ib_device_ops bng_re_dev_ops = {
 	.reg_user_mr		= bng_re_reg_user_mr,
 	.reg_user_mr_dmabuf	= bng_re_reg_user_mr_dmabuf,
 	.dereg_mr		= bng_re_dereg_mr,
+	.create_cq		= bng_re_create_cq,
+	.create_user_cq		= bng_re_create_user_cq,
+	.resize_user_cq		= bng_re_resize_cq,
+	.req_notify_cq		= bng_re_req_notify_cq,
+	.destroy_cq		= bng_re_destroy_cq,
+	INIT_RDMA_OBJ_SIZE(ib_cq, bng_re_cq, ib_cq),
 	INIT_RDMA_OBJ_SIZE(ib_pd, bng_re_pd, ib_pd),
 	INIT_RDMA_OBJ_SIZE(ib_ucontext, bng_re_ucontext, ib_uctx),
 };
@@ -319,6 +325,10 @@ static void bng_re_dev_uninit(struct bng_re_dev *rdev)
 {
 	int rc;
 
+	if (rdev->bng_res.dpi_tbl.max)
+		bng_re_dealloc_dpi(&rdev->bng_res,
+				   &rdev->dpi_privileged);
+
 	bng_deinit_mpc(rdev);
 	bng_re_free_xid_tables(&rdev->bng_res);
 
@@ -480,6 +490,13 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 			  "MPC alloc-init failed rc = %#x\n", rc);
 		goto deinit_mpc;
 	}
+
+	rc = bng_re_alloc_dpi(&rdev->bng_res,
+			      &rdev->dpi_privileged,
+			      rdev, BNG_RE_DPI_TYPE_KERNEL);
+	if (rc)
+		goto deinit_mpc;
+
 	return 0;
 deinit_mpc:
 	bng_deinit_mpc(rdev);
diff --git a/drivers/infiniband/hw/bng_re/bng_fp.c b/drivers/infiniband/hw/bng_re/bng_fp.c
new file mode 100644
index 000000000000..287729a83402
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_fp.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2026 Broadcom.
+//
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include "bng_res.h"
+#include "bng_sp.h"
+#include "bng_fp.h"
+
+/* CQE and NQE validation macros */
+#define CQE_CMP_VALID(hdr, pass)                        \
+	(!!((hdr)->cqe_type_toggle & CQ_BASE_TOGGLE) ==   \
+	   !((pass) & BNG_RE_FLAG_EPOCH_CONS_MASK))
+
+bool bng_fp_is_cq_empty(struct bng_sp_cq *cq)
+{
+	struct cq_base *hw_cqe;
+	bool rc = true;
+
+	hw_cqe = bng_re_get_qe(&cq->hwq, cq->hwq.cons, NULL);
+
+	/* Check for Valid bit. If the CQE is valid, return false */
+	rc = !CQE_CMP_VALID(hw_cqe, cq->dbinfo.flags);
+	return rc;
+}
+
+void bng_fp_req_notify_cq(struct bng_sp_cq *cq, u32 arm_type)
+{
+	cq->dbinfo.toggle = cq->toggle;
+
+	if (arm_type)
+		bng_re_ring_db(&cq->dbinfo, arm_type);
+
+	/* Using cq->arm_state variable to track whether to issue cq handler */
+	atomic_set(&cq->arm_state, 1);
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_fp.h b/drivers/infiniband/hw/bng_re/bng_fp.h
new file mode 100644
index 000000000000..4604b4f44816
--- /dev/null
+++ b/drivers/infiniband/hw/bng_re/bng_fp.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2026 Broadcom. */
+
+#ifndef __BNG_FP_H__
+#define __BNG_FP_H__
+bool bng_fp_is_cq_empty(struct bng_sp_cq *cq);
+void bng_fp_req_notify_cq(struct bng_sp_cq *cq, u32 arm_type);
+#endif /* __BNG_FP_H__ */
diff --git a/drivers/infiniband/hw/bng_re/bng_re.h b/drivers/infiniband/hw/bng_re/bng_re.h
index 0c0e362164d7..47b4037e124e 100644
--- a/drivers/infiniband/hw/bng_re/bng_re.h
+++ b/drivers/infiniband/hw/bng_re/bng_re.h
@@ -8,6 +8,7 @@
 #include "bnge_auxr.h"
 #include "bng_res.h"
 #include "bng_fw.h"
+#include "bng_sp.h"
 #include <rdma/ib_verbs.h>
 
 #define BNG_RE_XID_AVOID_REUSE		false
@@ -62,6 +63,8 @@ enum {
 #define ROCE_MPC_MAX_LATENCY_SEC_SLAB_INDEX	BNG_RE_MPC_MAX_LATENCY_SEC_SLAB_INDEX
 #define ROCE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX	BNG_RE_MPC_MAX_LATENCY_MSEC_SLAB_INDEX
 
+#define MAX_CQ_HASH_BITS		(16)
+
 typedef u32 PORT_NUM;
 
 struct bng_re_mpc_poll_info {
@@ -290,6 +293,9 @@ struct bng_re_dev {
 	struct bng_re_stats		stats_ctx;
 	struct bng_re_mpc_roce_creq_info mpc_roce_creq;
 	struct bng_mpc_ctx	*mpc;
+	struct bng_re_dpi		dpi_privileged;
+	struct bng_sp_cq_coal_param	cq_coalescing;
+	DECLARE_HASHTABLE(cq_hash, MAX_CQ_HASH_BITS);
 };
 
 #define to_bng_re_dev(ptr, member)	\
diff --git a/drivers/infiniband/hw/bng_re/bng_res.h b/drivers/infiniband/hw/bng_re/bng_res.h
index cb0f302fc06a..0f832f9bae20 100644
--- a/drivers/infiniband/hw/bng_re/bng_res.h
+++ b/drivers/infiniband/hw/bng_re/bng_res.h
@@ -40,6 +40,11 @@
 
 #define BNG_RE_FR_PMR		0x80000000
 
+enum bng_re_toggle_modes {
+	BNG_RE_CQ_TOGGLE_BIT = 0x1,
+	BNG_RE_SRQ_TOGGLE_BIT = 0x2,
+};
+
 struct bng_re_gid {
 	u8 data[16];
 };
@@ -242,6 +247,18 @@ static inline void *bng_re_get_qe(struct bng_re_hwq *hwq,
 		(type) | BNG_RE_DBR_VALID) << 32) | (indx) |  \
 	 (((u32)(toggle)) << (BNG_RE_DBR_TOGGLE_SHIFT)))
 
+static inline void bng_re_armen_db(struct bng_re_db_info *info, u32 type)
+{
+	u64 key = 0;
+	u8 toggle = 0;
+
+	if (type == DBC_DBC_TYPE_CQ_ARMENA || type == DBC_DBC_TYPE_SRQ_ARMENA)
+		toggle = info->toggle;
+	/* Index always at 0 */
+	key = BNG_RE_INIT_DBHDR(info->xid, type, 0, toggle);
+	writeq(key, info->priv_db);
+}
+
 static inline void bng_re_ring_db(struct bng_re_db_info *info,
 				  u32 type)
 {
@@ -315,6 +332,59 @@ static inline bool _is_max_srq_ext_supported(u16 dev_cap_ext_flags_2)
 	return !!(dev_cap_ext_flags_2 & CREQ_QUERY_FUNC_RESP_SB_MAX_SRQ_EXTENDED);
 }
 
+static inline bool _is_cq_coalescing_supported(u16 dev_cap_ext_flags2)
+{
+	return dev_cap_ext_flags2 & CREQ_QUERY_FUNC_RESP_SB_CQ_COALESCING_SUPPORTED;
+}
+
+#define ROCE_PG_SIZE_4K		(4 * 1024)
+#define ROCE_PG_SIZE_8K		(8 * 1024)
+#define ROCE_PG_SIZE_64K	(64 * 1024)
+#define ROCE_PG_SIZE_2M		(2 * 1024 * 1024)
+#define ROCE_PG_SIZE_8M		(8 * 1024 * 1024)
+#define ROCE_PG_SIZE_1G		(1024 * 1024 * 1024)
+
+enum bng_re_hwrm_pg_size {
+	BNG_RE_HWRM_PG_SIZE_4K	= 0,
+	BNG_RE_HWRM_PG_SIZE_8K	= 1,
+	BNG_RE_HWRM_PG_SIZE_64K	= 2,
+	BNG_RE_HWRM_PG_SIZE_2M	= 3,
+	BNG_RE_HWRM_PG_SIZE_8M	= 4,
+	BNG_RE_HWRM_PG_SIZE_1G	= 5,
+};
+
+static inline u8 bng_re_base_pg_size(struct bng_re_hwq *hwq)
+{
+	u8 pg_size = BNG_RE_HWRM_PG_SIZE_4K;
+	struct bng_re_pbl *pbl;
+
+	pbl = &hwq->pbl[BNG_PBL_LVL_0];
+	switch (pbl->pg_size) {
+	case ROCE_PG_SIZE_4K:
+		pg_size = BNG_RE_HWRM_PG_SIZE_4K;
+		break;
+	case ROCE_PG_SIZE_8K:
+		pg_size = BNG_RE_HWRM_PG_SIZE_8K;
+		break;
+	case ROCE_PG_SIZE_64K:
+		pg_size = BNG_RE_HWRM_PG_SIZE_64K;
+		break;
+	case ROCE_PG_SIZE_2M:
+		pg_size = BNG_RE_HWRM_PG_SIZE_2M;
+		break;
+	case ROCE_PG_SIZE_8M:
+		pg_size = BNG_RE_HWRM_PG_SIZE_8M;
+		break;
+	case ROCE_PG_SIZE_1G:
+		pg_size = BNG_RE_HWRM_PG_SIZE_1G;
+		break;
+	default:
+		break;
+	}
+
+	return pg_size;
+}
+
 void bng_re_free_hwq(struct bng_re_res *res,
 		     struct bng_re_hwq *hwq);
 
@@ -337,4 +407,7 @@ int bng_re_alloc_dpi(struct bng_re_res *res,
 		   void *app, enum bng_re_dpi_type type);
 int bng_re_dealloc_dpi(struct bng_re_res *res,
 		     struct bng_re_dpi *dpi);
+void bng_re_alloc_kernel_dpi(struct bng_re_res *res,
+			     struct bng_re_dpi *dpi);
+void bng_re_dealloc_kernel_dpi(struct bng_re_dpi *dpi);
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.c b/drivers/infiniband/hw/bng_re/bng_sp.c
index cd33ff32845a..04488db6d016 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.c
+++ b/drivers/infiniband/hw/bng_re/bng_sp.c
@@ -581,3 +581,238 @@ int bng_sp_reg_mr(struct bng_re_res *res, struct bng_re_mrw *mr,
 		bng_re_free_hwq(res, &mr->hwq);
 	return rc;
 }
+
+int bng_sp_create_cq(struct bng_re_res *res, struct bng_sp_cq *cq)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct creq_create_cq_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_create_cq req = {};
+	struct bng_re_pbl *pbl;
+	u32 coalescing = 0;
+	u32 pg_sz_lvl;
+	int rc;
+
+	if (!cq->dpi) {
+		dev_err(&rcfw->pdev->dev,
+			"FP: CREATE_CQ failed due to NULL DPI\n");
+		return -EINVAL;
+	}
+
+	cq->dbinfo.flags = 0;
+	hwq_attr.res = res;
+	hwq_attr.depth = cq->max_wqe;
+	hwq_attr.stride = sizeof(struct cq_base);
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+	hwq_attr.sginfo = &cq->sg_info;
+	rc = bng_re_alloc_init_hwq(&cq->hwq, &hwq_attr);
+	if (rc)
+		return rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			      CMDQ_BASE_OPCODE_CREATE_CQ,
+			      sizeof(req));
+
+	req.dpi = cpu_to_le32(cq->dpi->dpi);
+	req.cq_handle = cpu_to_le64(cq->cq_handle);
+	req.cq_size = cpu_to_le32(cq->max_wqe);
+
+	if (_is_cq_coalescing_supported(res->dattr->dev_cap_flags2) &&
+	    cq->coalescing.enable) {
+		req.flags |= cpu_to_le16(CMDQ_CREATE_CQ_FLAGS_COALESCING_VALID);
+		coalescing |= ((cq->coalescing.buf_maxtime <<
+				CMDQ_CREATE_CQ_BUF_MAXTIME_SFT) &
+			       CMDQ_CREATE_CQ_BUF_MAXTIME_MASK);
+		coalescing |= ((cq->coalescing.normal_maxbuf <<
+				CMDQ_CREATE_CQ_NORMAL_MAXBUF_SFT) &
+			       CMDQ_CREATE_CQ_NORMAL_MAXBUF_MASK);
+		coalescing |= ((cq->coalescing.during_maxbuf <<
+				CMDQ_CREATE_CQ_DURING_MAXBUF_SFT) &
+			       CMDQ_CREATE_CQ_DURING_MAXBUF_MASK);
+		if (cq->coalescing.en_ring_idle_mode)
+			coalescing |= CMDQ_CREATE_CQ_ENABLE_RING_IDLE_MODE;
+		else
+			coalescing &= ~CMDQ_CREATE_CQ_ENABLE_RING_IDLE_MODE;
+		req.coalescing = cpu_to_le32(coalescing);
+	}
+
+	pbl = &cq->hwq.pbl[BNG_PBL_LVL_0];
+	pg_sz_lvl = (bng_re_base_pg_size(&cq->hwq) <<
+		     CMDQ_CREATE_CQ_PG_SIZE_SFT);
+	pg_sz_lvl |= (cq->hwq.level & CMDQ_CREATE_CQ_LVL_MASK);
+	req.pg_size_lvl = cpu_to_le32(pg_sz_lvl);
+	req.pbl = cpu_to_le64(pbl->pg_map_arr[0]);
+	req.cq_fco_cnq_id = cpu_to_le32(
+			(cq->cnq_hw_ring_id & CMDQ_CREATE_CQ_CNQ_ID_MASK) <<
+			 CMDQ_CREATE_CQ_CNQ_ID_SFT);
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		goto fail;
+
+	cq->id = le32_to_cpu(resp.xid);
+	cq->period = BNG_QUEUE_START_PERIOD;
+	init_waitqueue_head(&cq->waitq);
+	INIT_LIST_HEAD(&cq->sqf_head);
+	INIT_LIST_HEAD(&cq->rqf_head);
+	spin_lock_init(&cq->compl_lock);
+	spin_lock_init(&cq->flush_lock);
+
+	cq->dbinfo.hwq = &cq->hwq;
+	cq->dbinfo.xid = cq->id;
+	cq->dbinfo.db = cq->dpi->dbr;
+	cq->dbinfo.priv_db = res->dpi_tbl.priv_db;
+	cq->dbinfo.flags = 0;
+	cq->dbinfo.toggle = 0;
+	cq->dbinfo.seed = 0;
+	spin_lock_init(&cq->dbinfo.lock);
+	cq->dbinfo.res = res;
+	cq->dbinfo.is_l2 = false;
+
+	bng_re_armen_db(&cq->dbinfo, DBC_DBC_TYPE_CQ_ARMENA);
+
+	return 0;
+
+fail:
+	bng_re_free_hwq(res, &cq->hwq);
+	return rc;
+}
+
+void bng_sp_resize_cq_complete(struct bng_re_res *res, struct bng_sp_cq *cq)
+{
+	bng_re_free_hwq(res, &cq->hwq);
+	memcpy(&cq->hwq, &cq->resize_hwq, sizeof(cq->hwq));
+	cq->dbinfo.flags &= ~(1UL << BNG_RE_FLAG_EPOCH_CONS_SHIFT);
+}
+
+int bng_sp_resize_cq(struct bng_re_res *res, struct bng_sp_cq *cq,
+		     int new_cqes)
+{
+	struct bng_re_hwq_attr hwq_attr = {};
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct creq_resize_cq_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_resize_cq req = {};
+	struct bng_re_pbl *pbl;
+	u32 pg_sz, lvl, new_sz;
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_RESIZE_CQ,
+			     sizeof(req));
+	hwq_attr.sginfo = &cq->sg_info;
+	hwq_attr.res = res;
+	hwq_attr.depth = new_cqes;
+	hwq_attr.stride = sizeof(struct cq_base);
+	hwq_attr.type = BNG_HWQ_TYPE_QUEUE;
+	rc = bng_re_alloc_init_hwq(&cq->resize_hwq, &hwq_attr);
+	if (rc)
+		return rc;
+
+	req.cq_cid = cpu_to_le32(cq->id);
+	pbl = &cq->resize_hwq.pbl[BNG_PBL_LVL_0];
+	pg_sz = bng_re_base_pg_size(&cq->resize_hwq);
+	lvl = (cq->resize_hwq.level << CMDQ_RESIZE_CQ_LVL_SFT) &
+				       CMDQ_RESIZE_CQ_LVL_MASK;
+	new_sz = (new_cqes << CMDQ_RESIZE_CQ_NEW_CQ_SIZE_SFT) &
+		  CMDQ_RESIZE_CQ_NEW_CQ_SIZE_MASK;
+	req.new_cq_size_pg_size_lvl = cpu_to_le32(new_sz | pg_sz | lvl);
+	req.new_pbl = cpu_to_le64(pbl->pg_map_arr[0]);
+
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		bng_re_free_hwq(res, &cq->resize_hwq);
+	return rc;
+}
+
+static void clean_nq(struct bng_re_nq *nq, struct bng_sp_cq *cq)
+{
+	struct bng_re_hwq *hwq = &nq->hwq;
+	struct nq_base *nqe, **nq_ptr;
+	int budget = nq->budget;
+	uintptr_t q_handle;
+	u16 type;
+
+	spin_lock_bh(&hwq->lock);
+	/* Service the NQ until empty */
+	while (budget--) {
+		nq_ptr = (struct nq_base **)hwq->pbl_ptr;
+		nqe = &nq_ptr[NQE_PG(hwq->cons)][NQE_IDX(hwq->cons)];
+		if (!NQE_CMP_VALID(nqe, nq->nq_db.dbinfo.flags))
+			break;
+
+		/*
+		 * The valid test of the entry must be done first before
+		 * reading any further.
+		 */
+		dma_rmb();
+
+		type = le16_to_cpu(nqe->info10_type) & NQ_BASE_TYPE_MASK;
+		switch (type) {
+		case NQ_BASE_TYPE_CQ_NOTIFICATION:
+		{
+			struct nq_cn *nqcne = (struct nq_cn *)nqe;
+
+			q_handle = le32_to_cpu(nqcne->cq_handle_low);
+			q_handle |= (u64)le32_to_cpu(nqcne->cq_handle_high)
+						     << 32;
+			if ((unsigned long)cq == q_handle) {
+				nqcne->cq_handle_low = 0;
+				nqcne->cq_handle_high = 0;
+				cq->cnq_events++;
+			}
+			break;
+		}
+		default:
+			break;
+		}
+		bng_re_hwq_incr_cons(hwq->max_elements, &hwq->cons,
+				     1, &nq->nq_db.dbinfo.flags);
+	}
+	spin_unlock_bh(&hwq->lock);
+}
+
+/* Wait for receiving all NQEs for this CQ and clean the NQEs associated with
+ * this CQ.
+ */
+static void __wait_for_all_nqes(struct bng_sp_cq *cq, u16 cnq_events)
+{
+	u32 retry_cnt = 100;
+
+	while (retry_cnt--) {
+		if (cnq_events == cq->cnq_events)
+			return;
+		usleep_range(50, 100);
+		clean_nq(cq->nq, cq);
+	}
+}
+
+int bng_sp_destroy_cq(struct bng_re_res *res, struct bng_sp_cq *cq)
+{
+	struct bng_re_rcfw *rcfw = res->rcfw;
+	struct creq_destroy_cq_resp resp = {};
+	struct bng_re_cmdqmsg msg = {};
+	struct cmdq_destroy_cq req = {};
+	u16 total_cnq_events;
+	int rc;
+
+	bng_re_rcfw_cmd_prep((struct cmdq_base *)&req,
+			     CMDQ_BASE_OPCODE_DESTROY_CQ,
+			     sizeof(req));
+
+	req.cq_cid = cpu_to_le32(cq->id);
+	bng_re_fill_cmdqmsg(&msg, &req, &resp, NULL, sizeof(req),
+			    sizeof(resp), 0);
+	rc = bng_re_rcfw_send_message(rcfw, &msg);
+	if (rc)
+		return rc;
+	total_cnq_events = le16_to_cpu(resp.total_cnq_events);
+	__wait_for_all_nqes(cq, total_cnq_events);
+	bng_re_free_hwq(res, &cq->hwq);
+	return 0;
+}
+
diff --git a/drivers/infiniband/hw/bng_re/bng_sp.h b/drivers/infiniband/hw/bng_re/bng_sp.h
index 6dd3ff911548..d05151123f98 100644
--- a/drivers/infiniband/hw/bng_re/bng_sp.h
+++ b/drivers/infiniband/hw/bng_re/bng_sp.h
@@ -15,6 +15,12 @@
 	(!!(le32_to_cpu((hdr)->info63_v[0]) & NQ_BASE_V) ==   \
 	   !((pass) & BNG_RE_FLAG_EPOCH_CONS_MASK))
 
+#define BNG_RE_MAX_NQE_ENTRY_SIZE	sizeof(struct nq_base)
+#define NQE_MAX_IDX_PER_PG	(NQE_CNT_PER_PG - 1)
+#define NQE_CNT_PER_PG		(PAGE_SIZE / BNG_RE_MAX_NQE_ENTRY_SIZE)
+#define NQE_PG(x)		(((x) & ~NQE_MAX_IDX_PER_PG) / NQE_CNT_PER_PG)
+#define NQE_IDX(x)		((x) & NQE_MAX_IDX_PER_PG)
+
 struct bng_re_dev_attr {
 #define FW_VER_ARR_LEN			4
 	u8				fw_ver[FW_VER_ARR_LEN];
@@ -98,6 +104,68 @@ struct bng_sp_mrinfo {
 	bool				request_relax_order;
 };
 
+struct bng_sp_cq_coal_param {
+	u16 buf_maxtime;
+	u8 normal_maxbuf;
+	u8 during_maxbuf;
+	u8 en_ring_idle_mode;
+	u8 enable;
+};
+
+struct bng_sp_cqe {
+	u8				status;
+	u8				type;
+	u8				opcode;
+	u32				length;
+	u16				cfa_meta;
+	u64				wr_id;
+	union {
+		u32			immdata;
+		u32			invrkey;
+	};
+	u64				qp_handle;
+	u64				mr_handle;
+	u16				flags;
+	u8				smac[6];
+	u32				src_qp;
+	u16				raweth_qp1_flags;
+	u16				raweth_qp1_errors;
+	u16				raweth_qp1_cfa_code;
+	u32				raweth_qp1_flags2;
+	u32				raweth_qp1_metadata;
+	u8				raweth_qp1_payload_offset;
+};
+
+#define BNG_QUEUE_START_PERIOD	0x01
+struct bng_sp_cq {
+	struct bng_re_dpi		*dpi;
+	struct bng_re_db_info		dbinfo;
+	u32				max_wqe;
+	u32				id;
+	u16				count;
+	u16				period;
+	struct bng_re_hwq		hwq;
+	struct bng_re_hwq		resize_hwq;
+	u32				cnq_hw_ring_id;
+	struct bng_re_nq		*nq;
+	bool				resize_in_progress;
+	struct bng_re_sg_info		sg_info;
+	u64				cq_handle;
+	u8				toggle;
+	struct bng_re_chip_ctx		*cctx;
+
+#define CQ_RESIZE_WAIT_TIME_MS		500
+	unsigned long			flags;
+#define CQ_FLAGS_RESIZE_IN_PROG		1
+	wait_queue_head_t		waitq;
+	struct bng_sp_cq_coal_param	coalescing;
+	struct list_head		sqf_head, rqf_head;
+	atomic_t			arm_state;
+	spinlock_t			compl_lock;
+	spinlock_t			flush_lock;
+	u16				cnq_events;
+};
+
 int bng_re_get_dev_attr(struct bng_re_rcfw *rcfw);
 int bng_sp_alloc_sgid_tbl(struct bng_re_sgid_tbl *sgid_tbl, u16 size);
 
@@ -127,5 +195,10 @@ int bng_sp_free_mrw(struct bng_re_res *res, struct bng_re_mrw *mrw);
 int bng_sp_reg_mr(struct bng_re_res *res, struct bng_re_mrw *mr,
 		  struct ib_umem *umem, int num_pbls, u32 buf_pg_size,
 		  bool unified_mr);
+int bng_sp_create_cq(struct bng_re_res *res, struct bng_sp_cq *cq);
+void bng_sp_resize_cq_complete(struct bng_re_res *res, struct bng_sp_cq *cq);
+int bng_sp_resize_cq(struct bng_re_res *res, struct bng_sp_cq *cq,
+		     int new_cqes);
+int bng_sp_destroy_cq(struct bng_re_res *res, struct bng_sp_cq *cq);
 
 #endif
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.c b/drivers/infiniband/hw/bng_re/bng_verbs.c
index fe227d20513a..b08ac20d788d 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.c
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.c
@@ -21,6 +21,7 @@
 #include "bnge_auxr.h"
 #include "bng_re.h"
 #include "bng_verbs.h"
+#include "bng_fp.h"
 
 int bng_re_query_device(struct ib_device *ibdev,
 			struct ib_device_attr *ib_attr,
@@ -893,3 +894,305 @@ int bng_re_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 
 	return 0;
 }
+
+static struct bng_re_nq *bng_re_get_nq(struct bng_re_dev *rdev)
+{
+	int min, indx;
+
+	mutex_lock(&rdev->nqr->load_lock);
+	for (indx = 0, min = 0; indx < (rdev->nqr->num_msix - 1); indx++) {
+		if (rdev->nqr->nq[min].load > rdev->nqr->nq[indx].load)
+			min = indx;
+	}
+	rdev->nqr->nq[min].load++;
+	mutex_unlock(&rdev->nqr->load_lock);
+
+	return &rdev->nqr->nq[min];
+}
+
+int bng_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
+			  struct uverbs_attr_bundle *attrs)
+{
+	struct bng_re_cq *cq = container_of(ibcq, struct bng_re_cq, ib_cq);
+	struct bng_re_dev *rdev = to_bng_re_dev(ibcq->device, ibdev);
+	struct ib_udata *udata = &attrs->driver_udata;
+	struct bng_re_ucontext *uctx =
+		rdma_udata_to_drv_context(udata, struct bng_re_ucontext, ib_uctx);
+	struct bng_re_dev_attr *dev_attr = rdev->dev_attr;
+	struct bng_re_chip_ctx *cctx;
+	struct bng_re_cq_resp resp = {};
+	struct bng_re_cq_req req;
+	int rc, entries;
+
+	if (attr->flags)
+		return -EOPNOTSUPP;
+
+	/* Check for valid CQ entries */
+	if (attr->cqe > dev_attr->max_cq_wqes) {
+		ibdev_err(&rdev->ibdev,
+			  "Failed to create CQ, cqe:%d max_cq_wqes:%d",
+			  attr->cqe, dev_attr->max_cq_wqes);
+		return -EINVAL;
+	}
+
+	cq->rdev = rdev;
+	cctx = rdev->chip_ctx;
+	cq->sp_cq.cq_handle = (u64)(unsigned long)(&cq->sp_cq);
+
+	entries = bng_re_init_depth(attr->cqe + 1, uctx);
+
+	rc = ib_copy_from_udata(&req, udata, sizeof(req));
+	if (rc)
+		return rc;
+
+	cq->umem = ib_umem_get_va(&rdev->ibdev, req.cq_va,
+				  entries * sizeof(struct cq_base),
+				  IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(cq->umem))
+		return PTR_ERR(cq->umem);
+
+	cq->sp_cq.sg_info.umem = cq->umem;
+	cq->sp_cq.dpi = &uctx->dpi;
+	cq->sp_cq.max_wqe = entries;
+	cq->sp_cq.coalescing = rdev->cq_coalescing;
+	cq->sp_cq.nq = bng_re_get_nq(rdev);
+	cq->sp_cq.cnq_hw_ring_id = cq->sp_cq.nq->ring_id;
+	rc = bng_sp_create_cq(&rdev->bng_res, &cq->sp_cq);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to create HW CQ");
+		goto udata_cq_fail;
+	}
+
+	cq->ib_cq.cqe = entries;
+	cq->cq_period = cq->sp_cq.period;
+
+	spin_lock_init(&cq->cq_lock);
+
+	if (cctx->modes.toggle_bits & BNG_RE_CQ_TOGGLE_BIT) {
+		/* Allocate a page */
+		cq->uctx_cq_page = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!cq->uctx_cq_page) {
+			rc = -ENOMEM;
+			goto uctx_cq_page_fail;
+		}
+		resp.comp_mask |= BNG_RE_CQ_TOGGLE_PAGE_SUPPORT;
+	}
+	resp.cqid = cq->sp_cq.id;
+	resp.tail = cq->sp_cq.hwq.cons;
+	resp.phase = cq->sp_cq.period;
+	resp.rsvd = 0;
+	rc = ib_copy_to_udata(udata, &resp, min(sizeof(resp), udata->outlen));
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to copy CQ udata");
+		goto destroy_cq;
+	}
+
+	return 0;
+
+destroy_cq:
+	if (cq->uctx_cq_page)
+		free_page((unsigned long)cq->uctx_cq_page);
+uctx_cq_page_fail:
+	bng_sp_destroy_cq(&rdev->bng_res, &cq->sp_cq);
+	ib_umem_release(cq->umem);
+udata_cq_fail:
+	kfree(cq->cql);
+	return rc;
+}
+
+int bng_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
+		     struct uverbs_attr_bundle *attrs)
+{
+	struct bng_re_cq *cq = container_of(ibcq, struct bng_re_cq, ib_cq);
+	struct bng_re_dev *rdev = to_bng_re_dev(ibcq->device, ibdev);
+	struct bng_re_dev_attr *dev_attr = rdev->dev_attr;
+	int rc, entries;
+
+	if (attr->flags)
+		return -EOPNOTSUPP;
+
+	/* Check for valid CQ entries */
+	if (attr->cqe > dev_attr->max_cq_wqes) {
+		ibdev_err(&rdev->ibdev,
+			  "Failed to create CQ, cqe:%d max_cq_wqes:%d",
+			  attr->cqe, dev_attr->max_cq_wqes);
+		return -EINVAL;
+	}
+
+	cq->rdev = rdev;
+	cq->sp_cq.cq_handle = (u64)(unsigned long)(&cq->sp_cq);
+
+	cq->max_cql = min_t(u32, entries, MAX_CQL_PER_POLL);
+	cq->cql = kcalloc(cq->max_cql, sizeof(struct bng_sp_cqe),
+			  GFP_KERNEL);
+	if (!cq->cql)
+		return -ENOMEM;
+
+	cq->sp_cq.sg_info.pgsize = SZ_4K;
+	cq->sp_cq.dpi = &rdev->dpi_privileged;
+	cq->sp_cq.max_wqe = cq->max_cql;
+	cq->sp_cq.coalescing = rdev->cq_coalescing;
+	cq->sp_cq.nq = bng_re_get_nq(rdev);
+	cq->sp_cq.cnq_hw_ring_id = cq->sp_cq.nq->ring_id;
+
+	rc = bng_sp_create_cq(&rdev->bng_res, &cq->sp_cq);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Failed to create HW CQ");
+		goto create_cq_fail;
+	}
+
+	cq->ib_cq.cqe = cq->max_cql;
+	cq->cq_period = cq->sp_cq.period;
+
+	spin_lock_init(&cq->cq_lock);
+
+	return 0;
+
+create_cq_fail:
+	kfree(cq->cql);
+	return rc;
+}
+
+int bng_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe, struct ib_udata *udata)
+{
+	struct bng_re_sg_info sg_info = {};
+	struct bng_re_dpi *orig_dpi = NULL;
+	struct bng_re_dev_attr *dev_attr;
+	struct bng_re_ucontext *uctx = NULL;
+	struct bng_re_resize_cq_req req;
+	struct bng_re_dev *rdev;
+	struct bng_re_cq *cq;
+	int rc, entries;
+
+	cq =  container_of(ibcq, struct bng_re_cq, ib_cq);
+	rdev = cq->rdev;
+	dev_attr = rdev->dev_attr;
+	if (!ibcq->uobject) {
+		ibdev_err(&rdev->ibdev, "Kernel CQ Resize not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (cq->resize_umem) {
+		ibdev_err(&rdev->ibdev, "Resize CQ %#x failed - Busy",
+			  cq->sp_cq.id);
+		return -EBUSY;
+	}
+
+	/* Check the requested cq depth out of supported depth */
+	if (cqe < 1 || cqe > dev_attr->max_cq_wqes) {
+		ibdev_err(&rdev->ibdev, "Resize CQ %#x failed - out of range cqe %d",
+			  cq->sp_cq.id, cqe);
+		return -EINVAL;
+	}
+
+	uctx = rdma_udata_to_drv_context(udata, struct bng_re_ucontext, ib_uctx);
+	entries = bng_re_init_depth(cqe + 1, uctx);
+	if (entries > dev_attr->max_cq_wqes + 1)
+		entries = dev_attr->max_cq_wqes + 1;
+
+	/* uverbs consumer */
+	if (ib_copy_from_udata(&req, udata, sizeof(req))) {
+		rc = -EFAULT;
+		goto fail;
+	}
+
+	cq->resize_umem = ib_umem_get_va(&rdev->ibdev, req.cq_va,
+				      entries * sizeof(struct cq_base),
+				      IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(cq->resize_umem)) {
+		rc = PTR_ERR(cq->resize_umem);
+		ibdev_err(&rdev->ibdev, "%s: ib_umem_get_va failed! rc = %pe\n",
+			  __func__, cq->resize_umem);
+		cq->resize_umem = NULL;
+		goto fail;
+	}
+	cq->resize_cqe = entries;
+	memcpy(&sg_info, &cq->sp_cq.sg_info, sizeof(sg_info));
+	orig_dpi = cq->sp_cq.dpi;
+
+	cq->sp_cq.sg_info.umem = cq->resize_umem;
+	cq->sp_cq.sg_info.pgsize = PAGE_SIZE;
+	cq->sp_cq.sg_info.pgshft = PAGE_SHIFT;
+	cq->sp_cq.dpi = &uctx->dpi;
+
+	rc = bng_sp_resize_cq(&rdev->bng_res, &cq->sp_cq, entries);
+	if (rc) {
+		ibdev_err(&rdev->ibdev, "Resize HW CQ %#x failed!",
+			  cq->sp_cq.id);
+		goto fail;
+	}
+
+	cq->ib_cq.cqe = cq->resize_cqe;
+
+	return 0;
+
+fail:
+	if (cq->resize_umem) {
+		ib_umem_release(cq->resize_umem);
+		cq->resize_umem = NULL;
+		cq->resize_cqe = 0;
+		memcpy(&cq->sp_cq.sg_info, &sg_info, sizeof(sg_info));
+		cq->sp_cq.dpi = orig_dpi;
+	}
+	return rc;
+}
+
+int bng_re_req_notify_cq(struct ib_cq *ib_cq,
+			 enum ib_cq_notify_flags ib_cqn_flags)
+{
+	struct bng_re_cq *cq = container_of(ib_cq, struct bng_re_cq, ib_cq);
+	int type = 0, rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cq->cq_lock, flags);
+	/* Trigger on the very next completion */
+	if (ib_cqn_flags & IB_CQ_NEXT_COMP)
+		type = DBC_DBC_TYPE_CQ_ARMALL;
+	/* Trigger on the next solicited completion */
+	else if (ib_cqn_flags & IB_CQ_SOLICITED)
+		type = DBC_DBC_TYPE_CQ_ARMSE;
+
+	/* Poll to see if there are missed events */
+	if ((ib_cqn_flags & IB_CQ_REPORT_MISSED_EVENTS) &&
+	    !(bng_fp_is_cq_empty(&cq->sp_cq))) {
+		rc = 1;
+		goto mis_events;
+	}
+	bng_fp_req_notify_cq(&cq->sp_cq, type);
+
+mis_events:
+	spin_unlock_irqrestore(&cq->cq_lock, flags);
+	return rc;
+}
+
+static void bng_re_put_nq(struct bng_re_dev *rdev, struct bng_re_nq *nq)
+{
+	mutex_lock(&rdev->nqr->load_lock);
+	nq->load--;
+	mutex_unlock(&rdev->nqr->load_lock);
+}
+
+int bng_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
+{
+	struct bng_re_chip_ctx *cctx;
+	struct bng_re_nq *nq;
+	struct bng_re_dev *rdev;
+	struct bng_re_cq *cq;
+
+	cq = container_of(ib_cq, struct bng_re_cq, ib_cq);
+	rdev = cq->rdev;
+	nq = cq->sp_cq.nq;
+	cctx = rdev->chip_ctx;
+
+	if (cctx->modes.toggle_bits & BNG_RE_CQ_TOGGLE_BIT) {
+		free_page((unsigned long)cq->uctx_cq_page);
+		hash_del(&cq->hash_entry);
+	}
+	bng_sp_destroy_cq(&rdev->bng_res, &cq->sp_cq);
+
+	bng_re_put_nq(rdev, nq);
+	ib_umem_release(cq->umem);
+
+	kfree(cq->cql);
+	return 0;
+}
diff --git a/drivers/infiniband/hw/bng_re/bng_verbs.h b/drivers/infiniband/hw/bng_re/bng_verbs.h
index 0ef7a7535e87..839967c73f08 100644
--- a/drivers/infiniband/hw/bng_re/bng_verbs.h
+++ b/drivers/infiniband/hw/bng_re/bng_verbs.h
@@ -47,6 +47,30 @@ struct bng_re_mr {
 	struct bng_re_frpl	sp_frpl;
 };
 
+struct bng_re_cq {
+	struct ib_cq		ib_cq;
+	struct bng_re_dev	*rdev;
+	spinlock_t		cq_lock;
+	u16			cq_count;
+	u16			cq_period;
+	struct bng_sp_cq	sp_cq;
+	struct bng_sp_cqe	*cql;
+	#define MAX_CQL_PER_POLL	1024
+	u32			max_cql;
+	struct ib_umem		*umem;
+	struct ib_umem		*resize_umem;
+	int			resize_cqe;
+	void			*uctx_cq_page;
+	struct hlist_node		hash_entry;
+};
+
+static inline u32 bng_re_init_depth(u32 ent, struct bng_re_ucontext *uctx)
+{
+	/* roundup_pow_of_two(0) is undefined (UBSAN: shift by 64 on 64-bit). */
+	return uctx ? (uctx->cmask & BNG_RE_UCNTX_CMASK_POW2_DISABLED) ?
+				   ent : roundup_pow_of_two(ent) : ent;
+}
+
 int bng_re_query_device(struct ib_device *ibdev, struct ib_device_attr *ib_attr,
 			struct ib_udata *udata);
 int bng_re_modify_device(struct ib_device *ibdev, int device_modify_mask,
@@ -90,6 +114,14 @@ struct ib_mr *bng_re_reg_user_mr_dmabuf(struct ib_pd *ib_pd, u64 start,
 					int fd, int mr_access_flags,
 					struct ib_dmah *dmah,
 					struct uverbs_attr_bundle *attrs);
+int bng_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
+		     struct uverbs_attr_bundle *attrs);
+int bng_re_create_user_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
+			  struct uverbs_attr_bundle *attrs);
+int bng_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe, struct ib_udata *udata);
+int bng_re_req_notify_cq(struct ib_cq *ib_cq,
+			 enum ib_cq_notify_flags ib_cqn_flags);
+int bng_re_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
 
 #endif /* __BNG_RE_VERBS_H__ */
 
diff --git a/include/uapi/rdma/bng_re-abi.h b/include/uapi/rdma/bng_re-abi.h
index 14d56a88def4..2a88f36bcacd 100644
--- a/include/uapi/rdma/bng_re-abi.h
+++ b/include/uapi/rdma/bng_re-abi.h
@@ -40,4 +40,25 @@ struct bng_re_uctx_resp {
 	__u64 uc_db_mmap_key;
 };
 
+struct bng_re_cq_req {
+	__aligned_u64 cq_va;
+	__aligned_u64 cq_handle;
+};
+
+enum bng_re_cq_mask {
+	BNG_RE_CQ_TOGGLE_PAGE_SUPPORT = 0x1,
+};
+
+struct bng_re_cq_resp {
+	__u32 cqid;
+	__u32 tail;
+	__u32 phase;
+	__u32 rsvd;
+	__aligned_u64 comp_mask;
+};
+
+struct bng_re_resize_cq_req {
+	__aligned_u64 cq_va;
+};
+
 #endif /* __BNG_RE_UVERBS_ABI_H__*/
-- 
2.43.5

