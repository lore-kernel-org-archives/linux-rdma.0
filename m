From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v8 6/7] block: Add rdma affinity based queue mapping helper
Date: Thu, 13 Jul 2017 11:09:43 +0300
Message-ID: <1499933384-17407-7-git-send-email-sagi@grimberg.me>
References: <1499933384-17407-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499933384-17407-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Like pci and virtio, we add a rdma helper for affinity
spreading. This achieves optimal mq affinity assignments
according to the underlying rdma device affinity maps.

Reviewed-by: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 block/Kconfig               |  5 +++++
 block/Makefile              |  1 +
 block/blk-mq-rdma.c         | 52 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq-rdma.h | 10 +++++++++
 4 files changed, 68 insertions(+)
 create mode 100644 block/blk-mq-rdma.c
 create mode 100644 include/linux/blk-mq-rdma.h

diff --git a/block/Kconfig b/block/Kconfig
index 89cd28f8d051..3ab42bbb06d5 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -206,4 +206,9 @@ config BLK_MQ_VIRTIO
 	depends on BLOCK && VIRTIO
 	default y
 
+config BLK_MQ_RDMA
+	bool
+	depends on BLOCK && INFINIBAND
+	default y
+
 source block/Kconfig.iosched
diff --git a/block/Makefile b/block/Makefile
index 2b281cf258a0..9396ebc85d24 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o
 obj-$(CONFIG_BLK_MQ_PCI)	+= blk-mq-pci.o
 obj-$(CONFIG_BLK_MQ_VIRTIO)	+= blk-mq-virtio.o
+obj-$(CONFIG_BLK_MQ_RDMA)	+= blk-mq-rdma.o
 obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 obj-$(CONFIG_BLK_WBT)		+= blk-wbt.o
 obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
new file mode 100644
index 000000000000..996167f1de18
--- /dev/null
+++ b/block/blk-mq-rdma.c
@@ -0,0 +1,52 @@
+/*
+ * Copyright (c) 2017 Sagi Grimberg.
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
+#include <linux/blk-mq.h>
+#include <linux/blk-mq-rdma.h>
+#include <rdma/ib_verbs.h>
+
+/**
+ * blk_mq_rdma_map_queues - provide a default queue mapping for rdma device
+ * @set:	tagset to provide the mapping for
+ * @dev:	rdma device associated with @set.
+ * @first_vec:	first interrupt vectors to use for queues (usually 0)
+ *
+ * This function assumes the rdma device @dev has at least as many available
+ * interrupt vetors as @set has queues.  It will then query it's affinity mask
+ * and built queue mapping that maps a queue to the CPUs that have irq affinity
+ * for the corresponding vector.
+ *
+ * In case either the driver passed a @dev with less vectors than
+ * @set->nr_hw_queues, or @dev does not provide an affinity mask for a
+ * vector, we fallback to the naive mapping.
+ */
+int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
+		struct ib_device *dev, int first_vec)
+{
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
+
+	for (queue = 0; queue < set->nr_hw_queues; queue++) {
+		mask = ib_get_vector_affinity(dev, first_vec + queue);
+		if (!mask)
+			goto fallback;
+
+		for_each_cpu(cpu, mask)
+			set->mq_map[cpu] = queue;
+	}
+
+	return 0;
+
+fallback:
+	return blk_mq_map_queues(set);
+}
+EXPORT_SYMBOL_GPL(blk_mq_rdma_map_queues);
diff --git a/include/linux/blk-mq-rdma.h b/include/linux/blk-mq-rdma.h
new file mode 100644
index 000000000000..b4ade198007d
--- /dev/null
+++ b/include/linux/blk-mq-rdma.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_BLK_MQ_RDMA_H
+#define _LINUX_BLK_MQ_RDMA_H
+
+struct blk_mq_tag_set;
+struct ib_device;
+
+int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
+		struct ib_device *dev, int first_vec);
+
+#endif /* _LINUX_BLK_MQ_RDMA_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
