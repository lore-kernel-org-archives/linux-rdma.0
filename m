Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711281;
	b=zsEzVZcxPTBg6I5e4yTsuz5mCrJBXl6HANsZ6eLzxScCpTiMZoTSE6LYq/5XexqVX7GE
	 javDD2nNK2NglQcDP2N6xKDF2HE61sxnXujAzHLHleA9kuiNjRSiy2jfEex6A5wtqLAaP
	 uI8jX242c26JBLIz8xrt7FQAd5A5JzlAH4ieTsPxXbMQoZ0c+PmHXOS+qe+Wt+XOyaLLb
	 g4x2FtCU1xGMr8MK6cUdZoh1rFfj/9durAAOUfgIT3p0/61GXsXWGaikXsvVb22RvsZz5
	 feB3Uh9HQHFLPr/PZVhzek/GN+NacVvyLCLGw6FU8fPAnEs33cSTxBm+CWgkSKNUcHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711281;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=SsTiUKKH3N7WS3PDqzZ28/JKz1al2b3mGlBoFKGo/jQ=;
	b=ieq6je47M8JmEEmd1khnVtsdFLQUL08WZp2hpj4XJHV0uPvttVkj76/dSJaNu244ydmN
	 CLalKUhui9nSrzEs7GovkazvrIpKafITZgdGsPj9g7WnV12y29ZDXy+9PbrJvlHo8DWVJ
	 X94kbufE6gdV/GskkAM6saJNp9VXDRHWueE69FNXCBggY2+wfMWRszU9yZxyWID1tekeh
	 saW/G1EZ6yaiObZm7V2lgNQKX+jzW1iCsQD5dh9wwbPD5mdNkJUyv3GPnw9RRpTCKjZ6i
	 06Zm0TgUdyKIIVHyOv0PU91+zXvUpUSn8np8jH+gLDEaVkQzdFgIjpyRFJfftbVZr6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3026606A324;
	Tue,  3 Nov 2026 13:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3026606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJpld4FRqz58ffr;
	Tue, 03 Nov 2026 21:07:57 +0800 (CST)
Received: from szxl2zmapp05.zte.com.cn ([10.1.32.37])
	by mse-fl2.zte.com.cn with SMTP id 6A3D7i3U057795;
	Tue, 3 Nov 2026 21:07:44 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 3 Nov 2026 21:07:48 +0800
X-Zmail-TransId: 3e816ae9dca3029-7ede9
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v9 3/7] RDMA/zrdma: Add internal headers and hardware register definitions
Date: Tue,  3 Nov 2026 20:56:50 +0800
Message-ID: <20261103125654.2707069-4-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl2.zte.com.cn 6A3D7i3U057795
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 03 Nov 2026 21:07:57 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9DCAD.000/4jJpld4FRqz58ffr

Add internal header files for main driver logic and hardware registers.
These headers define the structures and constants used by the subsequent
implementation patches.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_hw.h   |  21 +++
 drivers/infiniband/hw/zrdma/zrdma_main.h | 177 +++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h |   6 +
 3 files changed, 204 insertions(+)
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.h
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_main.h

diff --git a/drivers/infiniband/hw/zrdma/zrdma_hw.h b/drivers/infiniband/hw/zrdma/zrdma_hw.h
new file mode 100644
index 0000000000000..16c5041ac0757
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_hw.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_HW_H
+#define ZRDMA_HW_H
+#include "zrdma_main.h"
+
+#define ZXDH_MAX_CQE 0x200000
+#define ZXDH_MAX_QP 0x4000
+#define ZXDH_MAX_MR 0x10000
+#define ZXDH_MAX_CQ 0x4000
+#define ZXDH_MAX_SRQ 0x2000
+#define ZXDH_MAX_PD 0x100000
+#define ZXDH_MAX_AH 0x10000
+#define ZXDH_MAX_MCG 0x4000
+#define ZXDH_MAX_8K_IDX 0x1c0
+
+#endif /* ZRDMA_HW_H */
diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.h b/drivers/infiniband/hw/zrdma/zrdma_main.h
new file mode 100644
index 0000000000000..d65811735e74e
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
@@ -0,0 +1,177 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_MAIN_H
+#define ZRDMA_MAIN_H
+
+#include <linux/auxiliary_bus.h>
+#include <linux/bitfield.h>
+#include <linux/cleanup.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/zrdma_abi.h>
+#include <net/addrconf.h>
+
+#include "zrdma_type.h"
+#include "zrdma_ctrl.h"
+#include "zrdma_defs.h"
+
+#define ZXDH_FUNC_TYPE(vport_id) (((vport_id) >> 11) & 0x1)
+#define ZXDH_PF_ID(vport_id) (((vport_id) >> 8) & 0x7)
+#define ZXDH_EP_ID(vport_id) (((vport_id) >> 12) & 0x7)
+
+#define ZXDH_RST_TIMEOUT_HZ 4
+
+#define ZXDH_RDMA_COMMON_FUNC_CAP 1
+#define ZXDH_RDMA_COMM_FUNC BIT_ULL(24)
+
+extern const struct ib_device_ops zxdh_dev_ops;
+
+struct zxdh_pci_f;
+
+enum zxdh_func_type {
+	ZXDH_FUNC_NUM_REQUIRE = 0,
+	ZXDH_FUNC_IRQ_FREE = 3,
+};
+
+enum init_completion_state {
+	INVALID_STATE = 0,
+	INITIAL_STATE,
+};
+
+enum zxdh_rdma_vers {
+	ZXDH_GEN_2,
+};
+
+struct zxdh_gen_ops {
+	int (*zxdh_common_func)(void *in_param, void *out_param, u32 opcode);
+};
+
+struct zxdh_pci_f {
+	u8 ftype : 1;
+	u8 *mem_rsrc;
+	u8 rdma_ver;
+	u8 rst_to;
+	u8 pf_id;
+	u8 ep_id;
+	u32 msix_count;
+	u32 max_mr;
+	u32 max_qp;
+	u32 max_cq;
+	u32 max_ah;
+	u32 max_mcg;
+	u32 max_pd;
+	u32 next_pd;
+	u32 max_cqe;
+	u32 max_srq;
+	u32 max_pri;
+	u16 max_8k_idx;
+	u32 *qp_cnt_8k_idxs;
+	u32 ceqs_count;
+
+	unsigned long *allocated_qps;
+	unsigned long *allocated_cqs;
+	unsigned long *allocated_mrs;
+	unsigned long *allocated_pds;
+	unsigned long *allocated_mcgs;
+	unsigned long *allocated_ahs;
+	unsigned long *allocated_srqs;
+	unsigned long *allocated_pris;
+	unsigned long *allocated_8k_idx;
+
+	struct zxdh_sc_dev sc_dev;
+	struct pci_dev *pcidev;
+	struct zxdh_rdma_core_dev *zdev_info;
+	struct zxdh_hw hw;
+
+	spinlock_t rsrc_lock; /* protects resource allocation arrays */
+
+	struct msix_entry *msix_entries;
+	struct zxdh_gen_ops gen_ops;
+	struct zxdh_device *zdev;
+	u16 qp_index;
+	bool net_irq_cap;
+	int common_func_num_max;
+	void *dh_dev;
+};
+
+struct zxdh_device {
+	struct ib_device ibdev;
+	struct zxdh_pci_f *rf;
+	struct net_device *netdev;
+	struct list_head ah_list;
+	struct mutex ah_list_lock; /* protects ah_list operations */
+	u8 ibdev_status;
+	u8 roce_mode : 1;
+	enum init_completion_state init_state;
+	struct zxdh_auxiliary_dev *zxdh_adev;
+	atomic_t tx_port_affinity;
+	atomic_t sport_counter;
+};
+
+static inline struct zxdh_device *to_zdev(struct ib_device *ibdev)
+{
+	return container_of(ibdev, struct zxdh_device, ibdev);
+}
+
+static inline int zxdh_alloc_rsrc(struct zxdh_pci_f *rf,
+				  unsigned long *rsrc_array, u32 max_rsrc,
+				  u32 *req_rsrc_num, u32 *next,
+				  const char *rsrc_name)
+{
+	u32 rsrc_num;
+	int ret;
+
+	/* The pool is searched and the resource is taken under the lock, so
+	 * that two callers cannot pick the same resource. The lock is
+	 * taken with a guard, so that it is released on every exit path.
+	 * The exhaustion log is printed once the lock is released again,
+	 * because printk must not run while a spinlock is held.
+	 *
+	 * The search starts at the position after the last allocation, so
+	 * that the resources are handed out in turn. After the wrap-around
+	 * the position points after the last allocation again, which
+	 * affects the order of the allocations only.
+	 */
+	{
+		guard(spinlock_irqsave)(&rf->rsrc_lock);
+
+		rsrc_num = find_next_zero_bit(rsrc_array, max_rsrc, *next);
+		if (rsrc_num >= max_rsrc)
+			rsrc_num = find_first_zero_bit(rsrc_array, max_rsrc);
+		if (rsrc_num < max_rsrc) {
+			__set_bit(rsrc_num, rsrc_array);
+			*next = rsrc_num + 1;
+			if (*next == max_rsrc)
+				*next = 0;
+			*req_rsrc_num = rsrc_num;
+			ret = 0;
+		} else {
+			ret = -EOVERFLOW;
+		}
+	}
+
+	if (ret)
+		pr_err("zrdma: %s pool exhausted (capacity %u)\n",
+		       rsrc_name, max_rsrc);
+
+	return ret;
+}
+
+static inline void zxdh_free_rsrc(struct zxdh_pci_f *rf,
+				  unsigned long *rsrc_array, u32 rsrc_num)
+{
+	guard(spinlock_irqsave)(&rf->rsrc_lock);
+
+	__clear_bit(rsrc_num, rsrc_array);
+}
+
+int zxdh_ctrl_init_hw(struct zxdh_pci_f *rf);
+int zxdh_ib_register_device(struct zxdh_device *zdev);
+
+#endif /* ZRDMA_MAIN_H */
diff --git a/drivers/infiniband/hw/zrdma/zrdma_type.h b/drivers/infiniband/hw/zrdma/zrdma_type.h
index ded4052453455..c6ad2be17c159 100644
--- a/drivers/infiniband/hw/zrdma/zrdma_type.h
+++ b/drivers/infiniband/hw/zrdma/zrdma_type.h
@@ -21,6 +21,12 @@ enum zxdh_function_type {
 	ZXDH_FUNCTION_TYPE_VF,
 };
 
+/*
+ * The structures below describe the auxiliary device of the DingHai PF
+ * driver. Their layout has to match the definition of the PF driver
+ * exactly, because the probe path reads them through the auxiliary device
+ * that the PF driver provides.
+ */
 struct zxdh_rdma_core_dev;
 
 struct zxdh_rdma_core_ops {
-- 
2.43.5

