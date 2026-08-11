Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69BB430CD0;
	Tue, 11 Aug 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786441386; cv=none; b=kIEJP5cDz/uXRKkLGI/K2klORR2JNVeiEW9/anpkHz/ck8pdiqVIolnry/c+DTwb3EG86Eb87RfggSmx55Pr5z2HPAyMcv5f/CU4ujtWkuLfgd++2xdZmh6xZrXeE/mAckdrX6LQtWT/BzC4wJ0lvkz43xEV/IBg9A29R/aD9DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786441386; c=relaxed/simple;
	bh=exbOpsXEOs28Aqyceof91u9IE45wAmkdZnqj40Npnik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZgZDDPZYFK+pIIQ4daus5zWFTcbplwMFgvW7BXupLm0lcPiywpuS0PLgW+PlJ6+TpVxeGgcI5RMjW8atbyu8dVW3kdhq3i/EKlT0aAZLOnlQB1WQHeXSVE2Bt8GCSUWSYbjqyFPAZzp4cCFaDru6qFI2n+wuBhje2J90CGL5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hK69r17yHz8Xrrh;
	Tue, 11 Aug 2026 17:42:56 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl2.zte.com.cn with SMTP id 67B9ggPD073903;
	Tue, 11 Aug 2026 17:42:42 +0800 (+08)
	(envelope-from zhang.yanze@zte.com.cn)
Received: from localhost.localdomain (unknown [192.168.6.15])
	by smtp (Zmail) with SMTP;
	Tue, 11 Aug 2026 17:42:44 +0800
X-Zmail-TransId: 3e816a7aee94013-44494
X-Zmail-LocalSMTP: 1
X-Zmail-RealSender: zhang.yanze@zte.com.cn
From: Yanze Zhang <zhang.yanze@zte.com.cn>
To: jgg@ziepe.ca, leon@kernel.org, julianbraha@gmail.com,
        huangjunxian6@hisilicon.com, yanjun.zhu@linux.dev, lkp@intel.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
        han.chengfei@zte.com.cn, zhang.yanze@zte.com.cn
Subject: [PATCH rdma v5 4/7] RDMA/zrdma: Add hardware resource initialization and verbs skeleton
Date: Tue, 11 Aug 2026 17:37:37 +0800
Message-ID: <20260811093740.2607476-5-zhang.yanze@zte.com.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
References: <20260811093740.2607476-1-zhang.yanze@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ZMAIL-USEORIGINALEMLTOOUTBOUND: 1
Content-Transfer-Encoding: 8bit
X-MAIL:mse-fl2.zte.com.cn 67B9ggPD073903
X-TLS: YES
X-ENVELOPE-SENDER: zhang.yanze@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 11 Aug 2026 17:42:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A7AEEA0.001/4hK69r17yHz8Xrrh

Implement hardware resource initialization logic and provide a minimal
but functional verbs layer skeleton. This includes basic device
registration with an empty ops structure to satisfy the requirement
that the driver must be functional and have a valid driver ID.

Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>
---
 drivers/infiniband/hw/zrdma/Makefile      |   5 +-
 drivers/infiniband/hw/zrdma/zrdma_hw.c    | 103 +++++++++++++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.c |  41 +++++++
 drivers/infiniband/hw/zrdma/zrdma_verbs.h | 128 ++++++++++++++++++++++
 4 files changed, 276 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_hw.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/zrdma/zrdma_verbs.h

diff --git a/drivers/infiniband/hw/zrdma/Makefile b/drivers/infiniband/hw/zrdma/Makefile
index 2ddf50d1fd20..88be835f5c5c 100644
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
\ No newline at end of file
diff --git a/drivers/infiniband/hw/zrdma/zrdma_hw.c b/drivers/infiniband/hw/zrdma/zrdma_hw.c
new file mode 100644
index 000000000000..c2432531f238
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_hw.c
@@ -0,0 +1,103 @@
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
+	rf->allocated_srqs = (void *)(rf->mem_rsrc);
+	rf->allocated_qps = &rf->allocated_srqs[BITS_TO_LONGS(rf->max_srq)];
+	rf->allocated_cqs = &rf->allocated_qps[BITS_TO_LONGS(rf->max_qp)];
+	rf->allocated_mrs = &rf->allocated_cqs[BITS_TO_LONGS(rf->max_cq)];
+	rf->allocated_pds = &rf->allocated_mrs[BITS_TO_LONGS(rf->max_mr)];
+	rf->allocated_ahs = &rf->allocated_pds[BITS_TO_LONGS(rf->max_pd)];
+	rf->allocated_mcgs = &rf->allocated_ahs[BITS_TO_LONGS(rf->max_ah)];
+	rf->allocated_pris = &rf->allocated_mcgs[BITS_TO_LONGS(rf->max_mcg)];
+	rf->allocated_8k_idx = &rf->allocated_pris[BITS_TO_LONGS(rf->max_pri)];
+	rf->qp_table = (struct zxdh_qp **)
+				   (&rf->allocated_8k_idx[BITS_TO_LONGS(rf->max_8k_idx)]);
+	rf->cq_table = (struct zxdh_cq **)(&rf->qp_table[rf->max_qp]);
+	rf->srq_table = (struct zxdh_srq **)(&rf->cq_table[rf->max_cq]);
+
+	spin_lock_init(&rf->rsrc_lock);
+	spin_lock_init(&rf->qptable_lock);
+	spin_lock_init(&rf->cqtable_lock);
+	spin_lock_init(&rf->srqtable_lock);
+}
+
+static u32 zxdh_calc_mem_rsrc_size(struct zxdh_pci_f *rf)
+{
+	u32 rsrc_size;
+
+	rsrc_size = sizeof(unsigned long) * BITS_TO_LONGS(rf->max_srq);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_qp);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mr);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_cq);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_pd);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_ah);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mcg);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_pri);
+	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_8k_idx);
+	rsrc_size += sizeof(struct zxdh_qp **) * rf->max_qp;
+	rsrc_size += sizeof(struct zxdh_cq **) * rf->max_cq;
+	rsrc_size += sizeof(struct zxdh_srq **) * rf->max_srq;
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
index 000000000000..6db536c94e01
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c
@@ -0,0 +1,41 @@
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
+static const struct ib_device_ops zxdh_dev_ops = {
+	.owner = THIS_MODULE,
+	.driver_id = RDMA_DRIVER_ZRDMA,
+	.uverbs_abi_ver = ZXDH_ABI_VER,
+};
+
+static int zxdh_init_rdma_device(struct zxdh_device *zdev)
+{
+	zdev->ibdev.phys_port_cnt = 1;
+	zdev->ibdev.num_comp_vectors = zdev->rf->ceqs_count;
+	zdev->ibdev.dev.parent = &zdev->rf->pcidev->dev;
+
+	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
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
+		pr_err("zrdma: Register RDMA device fail\n");
+
+	return ret;
+}
diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.h b/drivers/infiniband/hw/zrdma/zrdma_verbs.h
new file mode 100644
index 000000000000..7af678c2becb
--- /dev/null
+++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.h
@@ -0,0 +1,128 @@
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
+#define ZXDH_DEFAULT_PKEY 0xFFFF
+
+#define SQ_DB_BAR_OFF 0x4c000
+#define CQ_DB_BAR_OFF 0x43000
+#define SRQ_DB_MMAP_SIZE 0x10000
+#define SRQ_DB_BAR_OFF 0x62000
+#define SRQ_DB_OFFSET 0
+
+#define MAX_MR_SIZE 0x200000000000
+#define MAX_QP 0x3fff
+#define MAX_QP_WR 0x1000
+#define MAX_CQ 0x3fff
+#define MAX_CQE 0x200000
+#define MAX_MR 0xfffe
+#define MAX_MW 0xfffe
+#define MAX_PD 0xfffff
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
+static inline enum ib_mtu zxdh_mtu_int_to_enum(int mtu)
+{
+	mtu = mtu - ZXDH_MTU_HEADER_RSV;
+	if (mtu >= 4096)
+		return IB_MTU_4096;
+	else if (mtu >= 2048)
+		return IB_MTU_2048;
+	else if (mtu >= 1024)
+		return IB_MTU_1024;
+	else if (mtu >= 512)
+		return IB_MTU_512;
+	else
+		return IB_MTU_256;
+}
+
+#endif /* ZRDMA_VERBS_H */
-- 
2.27.0

