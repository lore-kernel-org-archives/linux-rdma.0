Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793067763;
	b=4Wj/mWppzqHqyk0lLQC/C4svC2usEzNVw2ML1x7wWqIIiH8OhtkS22H6vg2/D/WeG+tZ
	 0lEyFeiSILCLmiN7snh2ahxQJE3d5tiepJ7pDW+6uBijBXY4lw9mp3wYHFd6Wyc/0ZCGc
	 jHSdWsUAFNQ9zNZai4x07vUu/SKZDilatXJvME8TZh8BwguWmsKmTXDmwo5U7mARsgAey
	 UvgnkcJqNd+GE7lFwsFg7VVTwwsfYShcpeaaadkZujxL9RNeLJ8jXr5WZUV7q2HJPgGop
	 XNQDE05hSMfmGpx+3zvc+CXGc738DdA4cNWBk1aiYdKxYBjJ6MGrT4Sut6BnbHNgBRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793067763;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=dHt7+GqXSUbacV7ulUsr99xwzQ1V0tEpneTCEfBE/Tc=;
	b=mOEZdH/a0f7DsaLQvVXAwj93vXS1bfxH9hQbgmN/nbz8rmq8aegrQJmDPe8dh6i7UMnI
	 iOliQC+xKxgtDgoJgkAm76Au2Q4irxx8Pz+pKE+ikOE9dFDHhWuyPw/qq1Fqy+PYmB8rI
	 LKuY4FJXSVYotsQr7NmEUSPMpNC0MI1ElGe8/QE6xV18cKlqBWnhhTNhKQy9Wc78IG/41
	 UFcpXFJu03vlp+5Ipty31HYihw5y49c9/lLVGfJYvRchFz+aW/xQvZVzGbT5FpI8XJpNV
	 bKCGXL+ClE02b1dCvMFkJJBpCdR6DH4dDnvQh7ZKnvJs2SIZ5Y8y9oraMsmfuqTf4yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F182606A32C;
	Tue, 27 Oct 2026 02:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F182606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jDDmG1TJmz5B7RM;
	Tue, 27 Oct 2026 10:22:38 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl1.zte.com.cn with SMTP id 69R2MRcV088279;
	Tue, 27 Oct 2026 10:22:27 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 27 Oct 2026 10:22:28 +0800
X-Zmail-TransId: 3e816ae00ae3027-4be42
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v7 2/7] RDMA/zrdma: Add core data structures and ABI definitions
Date: Tue, 27 Oct 2026 10:11:14 +0800
Message-ID: <20261027021119.2325798-3-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl1.zte.com.cn 69R2MRcV088279
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 27 Oct 2026 10:22:38 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE00AEE.000/4jDDmG1TJmz5B7RM

Add fundamental data structures, hardware control structures, and
user-space ABI definitions required by the driver. These headers
provide the type definitions for the subsequent implementation patches.

The UAPI header is installed to userspace, so it carries the
Linux-syscall-note SPDX tag that headers_install requires for a
GPL-licensed UAPI header.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_ctrl.h | 22 ++++++
 drivers/infiniband/hw/zrdma/zrdma_defs.h | 19 ++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h | 86 ++++++++++++++++++++++++
 include/uapi/rdma/zrdma_abi.h            | 80 ++++++++++++++++++++++
 4 files changed, 207 insertions(+)
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
index 000000000000..ac7bc023cf16
--- /dev/null
+++ b/include/uapi/rdma/zrdma_abi.h
@@ -0,0 +1,80 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB)
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
+#endif /* ZRDMA_ABI_H */
-- 
2.27.0

