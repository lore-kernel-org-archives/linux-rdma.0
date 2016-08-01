From: Haggai Eran <haggaie@mellanox.com>
Subject: [RFC 6/7] NVMe: Use genalloc to allocate CMB regions
Date: Mon,  1 Aug 2016 09:57:32 +0300
Message-ID: <1470034653-9097-7-git-send-email-haggaie@mellanox.com>
References: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1470034653-9097-1-git-send-email-haggaie@mellanox.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: linux-pci@vger.kernel.org, Stephen Bates <stephen.bates@microsemi.com>, Liran Liss <liranl@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Jerome Glisse <j.glisse@gmail.com>, Yishai Hadas <yishaih@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Register the CMB in a gen_pool dedicated to manage CMB regions. Use the
pool to allocate the SQs to make sure they are registered.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/nvme/host/nvme-pci.h | 24 ++++++++++++++++++++
 drivers/nvme/host/pci.c      | 54 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 74 insertions(+), 4 deletions(-)
 create mode 100644 drivers/nvme/host/nvme-pci.h

diff --git a/drivers/nvme/host/nvme-pci.h b/drivers/nvme/host/nvme-pci.h
new file mode 100644
index 000000000000..5b29508dc182
--- /dev/null
+++ b/drivers/nvme/host/nvme-pci.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright © 2016 Mellanox Technlogies. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _NVME_PCI_H
+#define _NVME_PCI_H
+
+#include "nvme.h"
+
+struct nvme_dev;
+
+void *nvme_alloc_cmb(struct nvme_dev *dev, size_t size, dma_addr_t *dma_addr);
+void nvme_free_cmb(struct nvme_dev *dev, void *addr, size_t size);
+
+#endif
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index befac5b19490..d3da5d9552dd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -42,8 +42,10 @@
 #include <linux/types.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/unaligned.h>
+#include <linux/genalloc.h>
 
 #include "nvme.h"
+#include "nvme-pci.h"
 
 #define NVME_Q_DEPTH		1024
 #define NVME_AQ_DEPTH		256
@@ -99,6 +101,7 @@ struct nvme_dev {
 	dma_addr_t cmb_dma_addr;
 	u64 cmb_size;
 	u32 cmbsz;
+	struct gen_pool *cmb_pool;
 	struct nvme_ctrl ctrl;
 	struct completion ioq_wait;
 };
@@ -937,11 +940,17 @@ static void nvme_cancel_io(struct request *req, void *data, bool reserved)
 
 static void nvme_free_queue(struct nvme_queue *nvmeq)
 {
+	struct nvme_dev *dev = nvmeq->dev;
+
 	dma_free_coherent(nvmeq->q_dmadev, CQ_SIZE(nvmeq->q_depth),
 				(void *)nvmeq->cqes, nvmeq->cq_dma_addr);
 	if (nvmeq->sq_cmds)
 		dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
 					nvmeq->sq_cmds, nvmeq->sq_dma_addr);
+	if (nvmeq->sq_cmds_io)
+		nvme_free_cmb(dev, nvmeq->sq_cmds_io,
+			      roundup(SQ_SIZE(nvmeq->q_depth),
+				      dev->ctrl.page_size));
 	kfree(nvmeq);
 }
 
@@ -1032,10 +1041,12 @@ static int nvme_alloc_sq_cmds(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 				int qid, int depth)
 {
 	if (qid && dev->cmb && use_cmb_sqes && NVME_CMB_SQS(dev->cmbsz)) {
-		unsigned offset = (qid - 1) * roundup(SQ_SIZE(depth),
-						      dev->ctrl.page_size);
-		nvmeq->sq_dma_addr = dev->cmb_dma_addr + offset;
-		nvmeq->sq_cmds_io = dev->cmb + offset;
+		nvmeq->sq_cmds_io =
+			nvme_alloc_cmb(dev, roundup(SQ_SIZE(depth),
+						    dev->ctrl.page_size),
+				       &nvmeq->sq_dma_addr);
+		if (!nvmeq->sq_cmds_io)
+			return -ENOMEM;
 	} else {
 		nvmeq->sq_cmds = dma_alloc_coherent(dev->dev, SQ_SIZE(depth),
 					&nvmeq->sq_dma_addr, GFP_KERNEL);
@@ -1339,6 +1350,7 @@ static void __iomem *nvme_map_cmb(struct nvme_dev *dev)
 	struct pci_dev *pdev = to_pci_dev(dev->dev);
 	void __iomem *cmb;
 	dma_addr_t dma_addr;
+	int ret;
 
 	if (!use_cmb_sqes)
 		return NULL;
@@ -1372,17 +1384,51 @@ static void __iomem *nvme_map_cmb(struct nvme_dev *dev)
 
 	dev->cmb_dma_addr = dma_addr;
 	dev->cmb_size = size;
+
+	dev->cmb_pool = gen_pool_create(PAGE_SHIFT, -1);
+	if (!dev->cmb_pool)
+		goto unmap;
+
+	ret = gen_pool_add_virt(dev->cmb_pool, (unsigned long)(uintptr_t)cmb,
+				dma_addr, size, -1);
+	if (ret)
+		goto destroy_pool;
+
 	return cmb;
+
+destroy_pool:
+	gen_pool_destroy(dev->cmb_pool);
+	dev->cmb_pool = NULL;
+unmap:
+	iounmap(cmb);
+	return NULL;
 }
 
 static inline void nvme_release_cmb(struct nvme_dev *dev)
 {
 	if (dev->cmb) {
+		gen_pool_destroy(dev->cmb_pool);
 		iounmap(dev->cmb);
 		dev->cmb = NULL;
 	}
 }
 
+void *nvme_alloc_cmb(struct nvme_dev *dev, size_t size, dma_addr_t *dma_addr)
+{
+	if (!dev->cmb_pool)
+		return NULL;
+
+	return gen_pool_dma_alloc(dev->cmb_pool, size, dma_addr);
+}
+
+void nvme_free_cmb(struct nvme_dev *dev, void *addr, size_t size)
+{
+	if (WARN_ON(!dev->cmb_pool))
+		return;
+
+	gen_pool_free(dev->cmb_pool, (unsigned long)(uintptr_t)addr, size);
+}
+
 static size_t db_bar_size(struct nvme_dev *dev, unsigned nr_io_queues)
 {
 	return 4096 + ((nr_io_queues + 1) * 8 * dev->db_stride);
-- 
1.7.11.2
