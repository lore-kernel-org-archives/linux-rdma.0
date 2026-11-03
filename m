Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711283;
	b=s2DUrNx3IAGAF8jTXi078FFP4tkLG2NK4h5R6ns1H/2a4YUNlbeDzfK92AZZD8GbUpKJ
	 Zq5eIOJbmrqc1bKaOVtnTl/Qym6q3ZeClSkZb9gcdCAAGSkbtkt1KIQ1uHfQ8BjlGL/sV
	 HkXA/8wFm1odrBOZDCuyxe7xAMCz13aB8lDZPgdp47wGGDBePOrGY3iT7IIUaG/QHKIze
	 sXg3PJ0/daEtQzYE+z8ldViMn9gdKsq5MWnZ/8MZail2FZ/KoAtIHQxJwBKn4uQ2qNEEn
	 VFHKnWhOd9OcXttRT16jJPvV35TFCWQhLP4/lSPZLiZf+cDUiC2FWXKBnLH0nj0oOrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711283;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:
	 X-Zmail-LocalSMTP:X-Zmail-RealSender:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 X-ZMAIL-USEORIGINALEMLTOOUTBOUND:Content-Transfer-Encoding:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=v4lYIM0SvjxPW32gf6zITcbWdJHPfGBHnkDa4HrPaHY=;
	b=UjM1dtKNMjNTWvMN9srhMGKFOGE/La8HaUTfqqvXNmXi0Gxtpo2qgFJM6tb/UwyJnUfB
	 GF/fGGLRR34PX50j3KqGuArDPBsO/sSDd7ZjrysEsBaxBXrwz8Bqta6OgmKd6/0cS6mH+
	 jBEm/2xh5inANigWKHH9Bg2y27jCLdRtNk42eUzjRoEWv7th2cGSuTfVZt3LODIvC12Lj
	 7E3g/g1gwqBNdpmQVKXa/qFf8vRhhylT62tx0axjq9SlAaO47pHztSJQ/U+tw+dtTgIWh
	 DFifpT5S2jd+QzpyiDMwfIhFqpSM8bAGdX2H5MYIBsJHInN8OCDx+CRj45zMxYxUtOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2712D6082BF2;
	Tue,  3 Nov 2026 13:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2712D6082BF2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJplj6Nw3z8Xrrh;
	Tue, 03 Nov 2026 21:08:01 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
	by mse-fl1.zte.com.cn with SMTP id 6A3D7j7I004969;
	Tue, 3 Nov 2026 21:07:45 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 3 Nov 2026 21:07:48 +0800
X-Zmail-TransId: 3e816ae9dca4029-7edf3
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev
Cc: Markus.Elfring@web.de, lkp@intel.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, wei.quan@zte.com.cn,
        han.junyang@zte.com.cn, ran.ming@zte.com.cn, han.chengfei@zte.com.cn,
        zhang.yanze@zte.com.cn
Subject: [PATCH rdma v9 4/7] RDMA/zrdma: Add hardware resource initialization and verbs skeleton
Date: Tue,  3 Nov 2026 20:56:51 +0800
Message-ID: <20261103125654.2707069-5-zhang.yanze@zte.com.cn>
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
X-MAIL:mse-fl1.zte.com.cn 6A3D7j7I004969
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 21:08:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9DCB1.002/4jJplj6Nw3z8Xrrh

Implement hardware resource initialization logic and provide a minimal
but functional verbs layer skeleton. This includes basic device
registration with the minimal set of device ops (owner, driver_id,
uverbs_abi_ver), to satisfy the requirement that the driver must be
functional and have a valid driver ID.

The hardware resources of the driver are held in a single allocation,
which carries the allocation bitmaps of the resource pools. The first
entry of the memory region, protection domain, queue pair, address
handle and multicast group pools is reserved.

The device ops are exported so that the probe path can install them
right after ib_alloc_device(). When the resource memory cannot be
allocated, the 8K index counter array is released with a cleared
pointer, so that the dealloc hook does not free the same allocation
twice.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/Makefile      |   5 +-
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 118 +++++++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c |  50 +++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 119 ++++++++++++++++++++++
 4 files changed, 291 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.h

diff --git a/drivers/infiniband/hw/zrdma/Makefile b/drivers/infiniband/hw/zrdma/Makefile
index 2ddf50d1fd208..9bc3650a8f2a9 100644
--- a/drivers/infiniband/hw/zrdma/Makefile
+++ b/drivers/infiniband/hw/zrdma/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 
 obj-$(CONFIG_INFINIBAND_ZRDMA) += zrdma.o
-zrdma-y := zrdma_main.o
+zrdma-y := \
+	zrdma_main.o \
+	zrdma_hw.o \
+	zrdma_verbs.o
diff --git a/drivers/infiniband/hw/zrdma/zrdma_hw.c b/drivers/infiniband/hw/zrdma/zrdma_hw.c
new file mode 100644
index 0000000000000..ba0e5760b52ca
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_hw.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#include <linux/vmalloc.h>
+#include "zrdma_hw.h"
+#include "zrdma_ctrl.h"
+#include "zrdma_main.h"
+
+static void zxdh_set_hw_rsrc(struct zxdh_pci_f *rf)
+{
+	/* The layout is walked with a byte pointer, so that every step
+	 * matches the size that zxdh_calc_mem_rsrc_size() accounted for.
+	 * Both functions use the same order of the resources.
+	 */
+	u8 *ptr = rf->mem_rsrc;
+
+	rf->allocated_srqs = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_srq);
+	rf->allocated_qps = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_qp);
+	rf->allocated_cqs = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_cq);
+	rf->allocated_mrs = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mr);
+	rf->allocated_pds = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_pd);
+	rf->allocated_ahs = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_ah);
+	rf->allocated_mcgs = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mcg);
+	rf->allocated_pris = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_pri);
+	rf->allocated_8k_idx = (unsigned long *)ptr;
+	ptr += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_8k_idx);
+
+	spin_lock_init(&rf->rsrc_lock);
+}
+
+static u32 zxdh_calc_mem_rsrc_size(struct zxdh_pci_f *rf)
+{
+	u32 rsrc_size;
+
+	rsrc_size = sizeof(unsigned long) * BITS_TO_LONGS(rf->max_srq);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_qp);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_cq);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mr);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_pd);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_ah);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mcg);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_pri);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_8k_idx);
+
+	return rsrc_size;
+}
+
+static int zxdh_initialize_hw_rsrc(struct zxdh_pci_f *rf)
+{
+	u32 rsrc_size;
+	int ret;
+
+	rf->max_cqe = ZXDH_MAX_CQE;
+	rf->max_qp = ZXDH_MAX_QP;
+	rf->max_mr = ZXDH_MAX_MR;
+	rf->max_cq = ZXDH_MAX_CQ;
+	rf->max_srq = ZXDH_MAX_SRQ;
+	rf->max_pd = ZXDH_MAX_PD;
+	rf->max_ah = ZXDH_MAX_AH;
+	rf->max_mcg = ZXDH_MAX_MCG;
+	rf->max_pri = ZXDH_MAX_USER_PRIORITY;
+	rf->max_8k_idx = ZXDH_MAX_8K_IDX;
+
+	rf->qp_cnt_8k_idxs = vzalloc(rf->max_8k_idx * sizeof(u32));
+	if (!rf->qp_cnt_8k_idxs) {
+		ret = -ENOMEM;
+		goto mem_8k_qp_cnt_vmalloc_fail;
+	}
+
+	rsrc_size = zxdh_calc_mem_rsrc_size(rf);
+	rf->mem_rsrc = vzalloc(rsrc_size);
+	if (!rf->mem_rsrc) {
+		ret = -ENOMEM;
+		goto mem_rsrc_vmalloc_fail;
+	}
+
+	zxdh_set_hw_rsrc(rf);
+
+	/* The first entry of the pools that are already in use is
+	 * reserved, so that a resource number of zero is not handed out.
+	 * The pools of the completion queues, the shared receive queues,
+	 * the user priorities and the 8K indices do not reserve an entry
+	 * yet, they are not allocated from yet.
+	 */
+	set_bit(0, rf->allocated_mrs);
+	set_bit(1, rf->allocated_mrs);
+	set_bit(0, rf->allocated_pds);
+	set_bit(0, rf->allocated_qps);
+	set_bit(0, rf->allocated_ahs);
+	set_bit(0, rf->allocated_mcgs);
+
+	return 0;
+
+mem_rsrc_vmalloc_fail:
+	vfree(rf->qp_cnt_8k_idxs);
+	/* Clear the pointer, the dealloc hook releases the very same
+	 * allocation again when the probe path unwinds.
+	 */
+	rf->qp_cnt_8k_idxs = NULL;
+mem_8k_qp_cnt_vmalloc_fail:
+	return ret;
+}
+
+int zxdh_ctrl_init_hw(struct zxdh_pci_f *rf)
+{
+	return zxdh_initialize_hw_rsrc(rf);
+}
diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
new file mode 100644
index 0000000000000..84ee7be418139
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#include "zrdma_main.h"
+#include "zrdma_verbs.h"
+#include "zrdma_ctrl.h"
+
+static int zxdh_init_rdma_device(struct zxdh_device *zdev)
+{
+	struct pci_dev *pcidev = zdev->rf->pcidev;
+
+	zdev->ibdev.phys_port_cnt = 1;
+	/* The core divides by num_comp_vectors in ib_cq_pool_get() and
+	 * rejects every uverbs CQ creation when it is zero, so the count
+	 * is never allowed to drop below one.
+	 */
+	zdev->ibdev.num_comp_vectors = max_t(u32, zdev->rf->ceqs_count, 1);
+	zdev->ibdev.dev.parent = &pcidev->dev;
+
+	return 0;
+}
+
+int zxdh_ib_register_device(struct zxdh_device *zdev)
+{
+	int ret;
+
+	ret = zxdh_init_rdma_device(zdev);
+	if (ret)
+		return ret;
+
+	ret = ib_register_device(&zdev->ibdev, "zrdma%d", zdev->rf->hw.device);
+	if (ret)
+		goto error;
+
+	return 0;
+
+error:
+	pr_err("zrdma: Register RDMA device fail, ret=%d\n", ret);
+
+	return ret;
+}
+
+const struct ib_device_ops zxdh_dev_ops = {
+	.owner = THIS_MODULE,
+	.driver_id = RDMA_DRIVER_ZRDMA,
+	.uverbs_abi_ver = ZXDH_ABI_VER,
+};
diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.h b/drivers/infiniband/hw/zrdma/zrdma_verbs.h
new file mode 100644
index 0000000000000..a435891ab7cf5
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.h
@@ -0,0 +1,119 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ *
+ * ZTE DingHai Rdma driver
+ * Copyright (c) 2022-2026, ZTE Corporation
+ */
+
+#ifndef ZRDMA_VERBS_H
+#define ZRDMA_VERBS_H
+
+#include <rdma/ib_umem.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+
+#define CHIP_VERSION 1
+#define ZXDH_PAGE_OFFSET_NUM (PAGE_SIZE - 1)
+#define MAX_HW_WQ_FRAGS 15
+#define MAX_HW_READ_SGES 15
+#define MAX_HW_INLINE 217
+#define MAX_HW_SRQ_WR 15
+#define MAX_HW_RQ_QUANTA 15
+#define MAX_HW_SRQ_QUANTA 15
+#define MAX_HW_WQ_QUANTA 15
+#define MAX_HW_SQ_CHUNK 0x8000
+#define MAX_HW_CQ_SIZE 0x200000
+#define MIN_HW_CQ_SIZE 4
+
+#define ZXDH_MTU_HEADER_RSV 102
+
+#define ZXDH_PKEY_TBL_SZ 1
+#define ZXDH_GID_TBL_LEN 255
+#define ZXDH_DEFAULT_PKEY 0xFFFF
+
+#define SQ_DB_BAR_OFF 0x4c000
+#define CQ_DB_BAR_OFF 0x43000
+#define SRQ_DB_MMAP_SIZE 0x10000
+#define SRQ_DB_BAR_OFF 0x62000
+
+#define MAX_MR_SIZE 0x200000000000
+#define MAX_QP 0x3fff
+#define MAX_QP_WR 0x1000
+#define MAX_CQ 0x3fff
+#define MAX_CQE 0x200000
+#define MAX_MR 0xfffe
+#define MAX_MW 0xfffe
+#define MAX_PD 0xfffff
+#define MAX_SEND_SGE 0xf
+#define MAX_RECV_SGE 0xf
+#define MAX_SGE_RD 0xf
+#define MAX_QP_RD_ATOM 0x10
+#define MAX_RES_RD_ATOM 0x3fff0
+#define MAX_QP_INIT_RD_ATOM 0x10
+#define MAX_SRQ 0x200
+#define MAX_SRQ_WR 0x7fff
+#define MAX_SRQ_SGE 0xf
+#define LOCAL_CA_ACK_DELAY 16
+#define HCA_CORE_CLOCK (1000 * 1000UL)
+#define MAX_WQ_TYPE_RQ 0x3fff
+#define MAX_AH 0x10000
+#define MAX_FAST_REG_PAGE_LIST_LEN 0x200
+#define MAX_CQ_MODERATION_COUNT 0xffff
+#define MAX_CQ_MODERATION_PERIOD 0x1cc
+#define TIMESTAMP_MASK 0x1ffff
+#define MAX_MSG_SZ 0x100000
+
+enum zxdh_mmap_flag {
+	ZXDH_MMAP_IO_NC,
+	ZXDH_MMAP_IO_WC,
+	ZXDH_MMAP_PFN,
+	ZXDH_MMAP_HMC,
+	ZXDH_MMAP_IO_NC_BY_SIZE,
+};
+
+struct zxdh_ucontext {
+	struct ib_ucontext ibucontext;
+	struct zxdh_device *zdev;
+	struct rdma_user_mmap_entry *sq_db_mmap_entry;
+	struct rdma_user_mmap_entry *cq_db_mmap_entry;
+	struct rdma_user_mmap_entry *srq_db_mmap_entry;
+	struct list_head cq_reg_mem_list;
+	spinlock_t cq_reg_mem_list_lock; /* protect CQ memory list */
+	struct list_head qp_reg_mem_list;
+	spinlock_t qp_reg_mem_list_lock; /* protect QP memory list */
+	struct list_head srq_reg_mem_list;
+	spinlock_t srq_reg_mem_list_lock; /* protect SRQ memory list */
+	int abi_ver;
+	atomic_t tx_port_affinity;
+};
+
+struct zxdh_pd {
+	struct ib_pd ibpd;
+	struct zxdh_sc_pd sc_pd;
+};
+
+struct zxdh_user_mmap_entry {
+	struct rdma_user_mmap_entry rdma_entry;
+	u64 bar_offset;
+	u8 mmap_flag;
+};
+
+void zxdh_ib_dealloc_device(struct ib_device *ibdev);
+
+static inline struct zxdh_pd *to_zpd(struct ib_pd *ibpd)
+{
+	return container_of(ibpd, struct zxdh_pd, ibpd);
+}
+
+static inline struct zxdh_ucontext *to_ucontext(struct ib_ucontext *ibucontext)
+{
+	return container_of(ibucontext, struct zxdh_ucontext, ibucontext);
+}
+
+static inline struct zxdh_user_mmap_entry *
+to_zxdh_mmap_entry(struct rdma_user_mmap_entry *rdma_entry)
+{
+	return container_of(rdma_entry, struct zxdh_user_mmap_entry,
+			    rdma_entry);
+}
+
+#endif /* ZRDMA_VERBS_H */
-- 
2.43.5

