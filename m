Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793608300;
	b=eMSXwr5XvsLiyivOBpe5zrQ1KNH04NdjL+vAIgHjGKqRy05NxtOhDIloX5g2A5p6hFOo
	 w5kKea2I97dVkhPJwHBN+Oho0COh8nrZcF1TExwkAiKpDFVJn7izv77AShuLUcvd6hGLR
	 rX0qCOPUdo3O8aCcURXdPoRVxH0lPPObqfw36UCFRI9zRd2R4JCBit5FLT0yn585Pz987
	 KHTFlZc0AoRRsyBRRognVUgDjRWEBDBGG2jAalCkqYDwNvpcuqHRnO9eJYLRGASQqi0wP
	 JQyiCWXh2LczUBpEo+fEKLDoIN6rcYJeVJmAme3EhrLVNVCvNW0pqIb2Kbd1rbsdwrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793608300;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=X+wfl0xW72DsCulp/29RMTuEmvn0kpuTBgFzAQQNjbk=;
	b=3P1wq2hsKgp/IOiNobJvITnB0DqGGxPUWIFZz6/OmDFcX6e3C2wWRDi6zMBvckM1sERD
	 DAtQgGyqNi+lw4Tt/Uqh5Wdc5QqnZoyE69gR7ysl7ORMRMQAl5tCdbmrQdw3/XzgC8roT
	 Y9FzEkSYeIE9ARe5yC8Z6plly10hEIjpgegV9Kj9aXThjsos3VoKRoUFFLzkdAQ/clcQT
	 DpnGtrK3v8T+QMkPsr+vLIuxtG28cPf0Cpvazk7pYoB8JsOyZhCuGKi/LhJYLUbtkh2c6
	 wdxMSD38pVE7ve3tz9Q97XF3pA260YbbN5CAano4qU7rT53PE4wr5Gyjot7vwQWW/Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3634560A2622;
	Mon,  2 Nov 2026 08:31:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3634560A2622
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJ4g55Gj3z5B14q;
	Mon, 02 Nov 2026 16:31:29 +0800 (CST)
Received: from szxl2zmapp06.zte.com.cn ([10.1.32.108])
	by mse-fl1.zte.com.cn with SMTP id 6A28VETH099826;
	Mon, 2 Nov 2026 16:31:14 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Mon, 2 Nov 2026 16:31:16 +0800
X-Zmail-TransId: 3e816ae84a54028-fc61b
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev,
        Markus.Elfring@web.de
Cc: lkp@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v8 3/7] RDMA/zrdma: Add internal headers and hardware register definitions
Date: Mon,  2 Nov 2026 16:20:22 +0800
Message-ID: <20261102082026.2645777-4-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl1.zte.com.cn 6A28VETH099826
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 02 Nov 2026 16:31:29 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE84A61.000/4jJ4g55Gj3z5B14q

Add internal header files for main driver logic and hardware registers.
These headers define the structures and constants used by the subsequent
implementation patches.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/zrdma_hw.h   |  21 +++
 drivers/infiniband/hw/zrdma/zrdma_main.h | 228 +++++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_type.h |   6 +
 3 files changed, 255 insertions(+)
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
index 0000000000000..31679b4eccb2c
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
@@ -0,0 +1,228 @@
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
+#define ZXDH_PF_NAME "dinghai10e"
+#define ZXDH_RDMA_DEV_NAME "rdma_aux"
+
+#define ZXDH_FUNC_TYPE(vport_id) (((vport_id) >> 11) & 0x1)
+#define ZXDH_PF_ID(vport_id) (((vport_id) >> 8) & 0x7)
+#define ZXDH_EP_ID(vport_id) (((vport_id) >> 12) & 0x7)
+
+#define PCI_SBDF_SAFE_LEN 64
+#define ZXDH_RST_TIMEOUT_HZ 4
+
+#define ZXDH_RDMA_COMMON_FUNC_CAP 1
+#define ZXDH_RDMA_COMM_FUNC BIT_ULL(24)
+
+extern struct list_head zxdh_handlers;
+extern spinlock_t zxdh_handler_lock;
+extern const struct ib_device_ops zxdh_dev_ops;
+
+struct zxdh_pci_f;
+
+struct zxdh_rdma_node {
+	char name[IB_DEVICE_NAME_MAX];
+	char sbdf[PCI_SBDF_SAFE_LEN];
+	struct list_head list;
+};
+
+enum zxdh_func_type {
+	ZXDH_FUNC_NUM_REQUIRE = 0,
+	ZXDH_FUNC_NP_MAC = 1,
+	ZXDH_FUNC_IRQ_REQUEST = 2,
+	ZXDH_FUNC_IRQ_FREE = 3,
+	ZXDH_FUNC_PMTU_INFO_ADD = 4,
+	ZXDH_FUNC_PMTU_INFO_DEL = 5,
+	ZXDH_FUNC_QP_INFO_DEL_WX = 6,
+	ZXDH_FUNC_NETDEV_SPEED_GET = 7,
+	ZXDH_FUNC_SEARCH_MAC_FROM_FW = 8,
+	ZXDH_COMM_FUNC_GET_TRUST_TYPE = 9,
+	ZXDH_FUNC_VF_VLAN_GET = 10,
+	ZXDH_FUNC_NUM_MAX,
+};
+
+enum init_completion_state {
+	INVALID_STATE = 0,
+	INITIAL_STATE,
+	CQP_CREATED,
+	SMMU_PAGETABLE_INITIALIZED,
+	DATA_CAP_CREATED,
+	HMC_OBJS_CREATED,
+	HW_RSRC_INITIALIZED,
+	CQP_QP_CREATED,
+	AEQ_CREATED,
+	CCQ_CREATED,
+	CEQ0_CREATED,
+	CEQS_CREATED,
+	PBLE_CHUNK_MEM,
+};
+
+enum zxdh_rdma_vers {
+	ZXDH_GEN_RSVD,
+	ZXDH_GEN_1,
+	ZXDH_GEN_2,
+};
+
+struct zxdh_handler {
+	struct list_head list;
+	struct zxdh_device *zdev;
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
+	spinlock_t qptable_lock; /* protects qp_table access */
+	spinlock_t cqtable_lock; /* protects cq_table access */
+	struct zxdh_qp **qp_table;
+	struct zxdh_cq **cq_table;
+	spinlock_t srqtable_lock; /* protects srq_table access */
+	struct zxdh_srq **srq_table;
+
+	struct msix_entry *msix_entries;
+	struct zxdh_gen_ops gen_ops;
+	struct zxdh_device *zdev;
+	u16 qp_index;
+	u32 srq_mem_size;
+	bool net_irq_cap;
+	int common_func_num_max;
+	void *dh_dev;
+};
+
+struct zxdh_device {
+	struct ib_device ibdev;
+	struct zxdh_pci_f *rf;
+	struct net_device *netdev;
+	struct net_device *source_netdev;
+	struct zxdh_handler *hdl;
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
+int zxdh_get_del_rdma_name(const char *sbdf, char *name, size_t name_len);
+int zxdh_ctrl_init_hw(struct zxdh_pci_f *rf);
+int zxdh_ib_register_device(struct zxdh_device *zdev);
+void zxdh_del_handler(struct zxdh_handler *hdl);
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

