Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792826765;
	b=Zr/cfSU6Jk9ofzyTBA5EQ+6XPWH/9HEE1P3NfIb5+OcHwgWFmzsGA5/Svru3giCu5JvJ
	 XPv3eKqfq9ZxtpOkNaZ7mE49TSisIvVpXwWxhI6cD09ETEcdPPjZrimzSAYbYfi/K3l4G
	 9uQDs1MpC3TePggdMesUu6V0FXpxmnklRRXKZZ437tHQneHgMgHFNAWsnhbOVFoS98HmO
	 lzfcZzi2AtOGbIqA5/IfUvUkWi8aLTIyNLritM2pHOEGnhOPmP2FLD2iux9G04P0PLT2m
	 Q5VQ05oxx5dNYdxrP5XPRv3Nu0o3H40jb9f8ABzz7SdChsOZ8pMJ8fabAYpSAaGnFkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792826765;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=Tcf9rPtJ6U0qhEsL7QGe/WGHiDU/jvoq9wbJGd+jU4E=;
	b=VIgJplYmwg6U9w3/eh7y4x2tjPoxHxLjwQNRfszx1ebBDox4yXhYNsWKaV1WnvFzPo6q
	 kBVnCvMlwZgoioSi/dDgjiCoAXG0gELR4aTfOrGyODV6xpCsTwwiWwA1uJqiD+FAuPk3y
	 wvyOZ2gfJLMSQPoOCqk12TXBngS0rRVUz1SwPR6EiTy9z8lLcHCL2UmB7Xk/vzE5Q/Gc8
	 Aax2Myr+u0MZMrMQib9HwHQsiwNaAUIHcqiNhN88bP1DklOWEu/rrxIFj2T6V/rLXotrh
	 Y0fn+P5MxHBq13EXM536BsE3AAcyvSQtDvyoGgbloKFEFMbgKXI3z9CNn6lGHJtLZ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D22606A32E;
	Sat, 24 Oct 2026 07:26:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41D22606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jBWdd2L4qz8Xrrf;
	Sat, 24 Oct 2026 15:25:57 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
	by mse-fl1.zte.com.cn with SMTP id 69O7PiGI030408;
	Sat, 24 Oct 2026 15:25:44 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Sat, 24 Oct 2026 15:25:46 +0800
X-Zmail-TransId: 3e816adc5d7a026-b7b84
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH 2/7] RDMA/zrdma: Add core data structures and ABI definitions
Date: Sat, 24 Oct 2026 15:15:34 +0800
Message-ID: <20261024071539.2182864-3-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl1.zte.com.cn 69O7PiGI030408
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 24 Oct 2026 15:25:57 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADC5D85.000/4jBWdd2L4qz8Xrrf

Add fundamental data structures, hardware control structures, and
user-space ABI definitions required by the driver. These headers
provide the type definitions for the subsequent implementation patches.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h | 22 ++++++
 drivers/infiniband/hw/zrdma/zrdma_defs.h | 19 ++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h | 86 ++++++++++++++++++++++++
 include/uapi/rdma/zrdma_abi.h            | 81 ++++++++++++++++++++++
 4 files changed, 208 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_ctrl.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_defs.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_type.h
 create mode 100644 include/uapi/rdma/zrdma_abi.h

diff --git a/drivers/infiniband/hw/zrdma/zrdma_ctrl.h b/drivers/infiniband/hw/zrdma/zrdma_ctrl.h
new file mode 100644
index 000000000000..d25570683b61
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_ctrl.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_CTRL_H
+#define ZRDMA_CTRL_H
+
+struct zxdh_hw {
+	u8 __iomem *hw_addr;
+	struct device *device;
+};
+
+struct zxdh_sc_dev {
+	struct zxdh_hw *hw;
+	u32 max_ceqs;
+	u8 ep_id;
+	u8 driver_load;
+};
+
+#endif
diff --git a/drivers/infiniband/hw/zrdma/zrdma_defs.h b/drivers/infiniband/hw/zrdma/zrdma_defs.h
new file mode 100644
index 000000000000..208f1f60bbae
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_defs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_DEFS_H
+#define ZRDMA_DEFS_H
+
+#include <linux/bitfield.h>
+#include <rdma/ib_verbs.h>
+
+#define ZXDH_FEATURE_RTS_AE 1ULL
+#define ZXDH_FEATURE_CQ_RESIZE 2ULL
+#define ZXDH_FEATURE_64_BYTE_CQE 128ULL
+
+#define ZXDH_MAX_USER_PRIORITY 8
+
+#endif /* ZRDMA_DEFS_H */
diff --git a/drivers/infiniband/hw/zrdma/zrdma_type.h b/drivers/infiniband/hw/zrdma/zrdma_type.h
new file mode 100644
index 000000000000..ded405245345
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_type.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_TYPE_H
+#define ZRDMA_TYPE_H
+
+#include <linux/auxiliary_bus.h>
+#include <linux/msi.h>
+
+enum zxdh_rdma_reset_type {
+	ZXDH_RDMA_PFR,
+	ZXDH_RDMA_CORER,
+	ZXDH_RDMA_GLOBR,
+};
+
+enum zxdh_function_type {
+	ZXDH_FUNCTION_TYPE_PF,
+	ZXDH_FUNCTION_TYPE_VF,
+};
+
+struct zxdh_rdma_core_dev;
+
+struct zxdh_rdma_core_ops {
+	int (*request_reset)(struct zxdh_rdma_core_dev *cdev,
+			     enum zxdh_rdma_reset_type reset_type);
+	int (*zxdh_common_func)(void *in_param, void *out_param, u32 opcode);
+};
+
+struct zxdh_rdma_ver_info {
+	u16 major;
+	u16 minor;
+	u64 support; /* 0~7:net_major,8~15:net_minor,16~23:rdma_minor,24~63:rscv */
+};
+
+enum zxdh_rdma_protocol {
+	ZXDH_RDMA_PROTOCOL_IWARP = BIT(0),
+	ZXDH_RDMA_PROTOCOL_ROCEV2 = BIT(1),
+};
+
+struct zxdh_qos_params {
+	u8 num_tc;
+};
+
+struct zxdh_rdma_core_dev {
+	struct pci_dev *pdev;
+	struct auxiliary_device *adev;
+	u8 __iomem *hw_addr;
+	int zdev_info_id;
+	struct zxdh_rdma_ver_info ver;
+	void *auxiliary_priv;
+	enum zxdh_function_type ftype;
+	u16 vport_id;
+	u16 slot_id;
+	enum zxdh_rdma_protocol rdma_protocol;
+
+	struct zxdh_qos_params qos_info;
+	struct msix_entry *msix_entries;
+	u16 msix_count;
+	const struct zxdh_rdma_core_ops *ops;
+	void *dh_dev;
+};
+
+struct zxdh_rdma_if {
+	void *(*get_rdma_netdev)(void *dh_dev);
+};
+
+struct zxdh_auxiliary_dev {
+	struct auxiliary_device adev;
+	struct zxdh_rdma_core_dev *zxdh_info;
+	struct zxdh_rdma_if *rdma_ops;
+	void *ops;
+	void *parent;
+	s32 aux_id;
+	void *auxiliary_ops[18];
+};
+
+struct zxdh_sc_pd {
+	struct zxdh_sc_dev *dev;
+	u32 pd_id;
+	int abi_ver;
+};
+
+#endif /* ZRDMA_TYPE_H */
diff --git a/include/uapi/rdma/zrdma_abi.h b/include/uapi/rdma/zrdma_abi.h
new file mode 100644
index 000000000000..6686a02f77a3
--- /dev/null
+++ b/include/uapi/rdma/zrdma_abi.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_ABI_H
+#define ZRDMA_ABI_H
+
+#include <linux/types.h>
+
+/* user-space whose last ABI ver is 5 */
+#define ZXDH_ABI_VER 5
+#define ZXDH_CONTEXT_VER_V1 5
+#define ZXDH_CONTEXT_VER_V2 6
+#define ZXDH_CONTEXT_VER_V3 7
+
+enum zxdh_rdma_tool_flags {
+	ZXDH_QP_EXTEND_OP = 1 << 0,
+	ZXDH_CAPTURE = 1 << 1,
+	ZXDH_GET_HW_DATA = 1 << 2,
+	ZXDH_GET_HW_OBJECT_DATA = 1 << 3,
+	ZXDH_CHECK_HW_HEALTH = 1 << 4,
+	ZXDH_RDMA_TOOL_CFG_DEV_PARAM = 1 << 5,
+	ZXDH_RDMA_TOOL_READ_RAM = 1 << 6,
+	ZXDH_RDMA_TOOL_DEVX_MODIFY_CQ = 1 << 7,
+	ZXDH_RDMA_SET_CREDIT_CAP = 1 << 8,
+	ZXDH_RDMA_SWITCH = 1 << 9,
+	ZXDH_RDMA_TOOL_DEVX_EXT_MEM = 1 << 10,
+	ZXDH_RDMA_TOOL_PRIV_EXT = 1 << 11,
+	ZXDH_RDMA_TOOL_IOVA_CAP = 1 << 12,
+};
+
+enum zxdh_db_addr_type {
+	ZXDH_DB_ADDR_PHY = 0,
+	ZXDH_DB_ADDR_BAR = 1,
+};
+
+struct zxdh_alloc_ucontext_req {
+	__u32 rsvd32;
+	__u8 userspace_ver;
+	__u8 rsvd8[3];
+};
+
+struct zxdh_alloc_ucontext_resp {
+	__u32 max_pds;
+	__u32 max_qps;
+	__u32 wq_size; /* size of the WQs (SQ+RQ) in the mmaped area */
+	__u8 kernel_ver;
+	__u8 db_addr_type;
+	__u16 rdma_tool_flags;
+	__aligned_u64 feature_flags;
+	__aligned_u64 sq_db_mmap_key;
+	__aligned_u64 cq_db_mmap_key;
+	__u32 max_hw_wq_frags;
+	__u32 max_hw_read_sges;
+	__u32 max_hw_inline;
+	__u32 max_hw_rq_quanta;
+	__u32 max_hw_srq_quanta;
+	__u32 max_hw_wq_quanta;
+	__u32 max_hw_srq_wr;
+	__u32 min_hw_cq_size;
+	__u32 max_hw_cq_size;
+	__u16 max_hw_sq_chunk;
+	__u8 hw_rev;
+	__u8 chip_rev;
+	__aligned_u64 srq_db_mmap_key;
+	__aligned_u64 sq_db_bar_off;
+	__aligned_u64 cq_db_bar_off;
+	__aligned_u64 srq_db_bar_off;
+	__u32 srq_db_mmap_size;
+	__u16 rsv[6];
+};
+
+struct zxdh_alloc_pd_resp {
+	__u32 pd_id;
+	__u8 rsvd[4];
+};
+
+
+#endif /* ZRDMA_ABI_H */
-- 
2.27.0

