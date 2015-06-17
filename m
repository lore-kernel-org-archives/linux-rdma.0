From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 13/49] IB/hfi1: add dma operation hooks
Date: Wed, 17 Jun 2015 08:29:45 -0400
Message-ID: <20150617122945.8744.60296.stgit@phlsvslse11.ph.intel.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122755.8744.44665.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Friedley <andrew.friedley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Gregor <john.a.gregor-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kevin Pine <kevin.pine-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kyle Liddell <kyle.liddell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ravi Krishnaswamy <ravi.krishnaswamy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sanath Kumar <sanath.s.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vlad Danushevsky <vladimir.danusevsky-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/dma.c |  185 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)
 create mode 100644 drivers/infiniband/hw/hfi1/dma.c

diff --git a/drivers/infiniband/hw/hfi1/dma.c b/drivers/infiniband/hw/hfi1/dma.c
new file mode 100644
index 0000000..6e86a71
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/dma.c
@@ -0,0 +1,185 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#include <linux/types.h>
+#include <linux/scatterlist.h>
+
+#include "verbs.h"
+
+#define BAD_DMA_ADDRESS ((u64) 0)
+
+/*
+ * The following functions implement driver specific replacements
+ * for the ib_dma_*() functions.
+ *
+ * These functions return kernel virtual addresses instead of
+ * device bus addresses since the driver uses the CPU to copy
+ * data instead of using hardware DMA.
+ */
+
+static int hfi1_mapping_error(struct ib_device *dev, u64 dma_addr)
+{
+	return dma_addr == BAD_DMA_ADDRESS;
+}
+
+static u64 hfi1_dma_map_single(struct ib_device *dev, void *cpu_addr,
+			       size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	return (u64) cpu_addr;
+}
+
+static void hfi1_dma_unmap_single(struct ib_device *dev, u64 addr, size_t size,
+				  enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+
+static u64 hfi1_dma_map_page(struct ib_device *dev, struct page *page,
+			     unsigned long offset, size_t size,
+			    enum dma_data_direction direction)
+{
+	u64 addr;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	if (offset + size > PAGE_SIZE) {
+		addr = BAD_DMA_ADDRESS;
+		goto done;
+	}
+
+	addr = (u64) page_address(page);
+	if (addr)
+		addr += offset;
+
+done:
+	return addr;
+}
+
+static void hfi1_dma_unmap_page(struct ib_device *dev, u64 addr, size_t size,
+				enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+
+static int hfi1_map_sg(struct ib_device *dev, struct scatterlist *sgl,
+		       int nents, enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	u64 addr;
+	int i;
+	int ret = nents;
+
+	BUG_ON(!valid_dma_direction(direction));
+
+	for_each_sg(sgl, sg, nents, i) {
+		addr = (u64) page_address(sg_page(sg));
+		if (!addr) {
+			ret = 0;
+			break;
+		}
+		sg->dma_address = addr + sg->offset;
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+		sg->dma_length = sg->length;
+#endif
+	}
+	return ret;
+}
+
+static void hfi1_unmap_sg(struct ib_device *dev,
+			  struct scatterlist *sg, int nents,
+			 enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+
+static void hfi1_sync_single_for_cpu(struct ib_device *dev, u64 addr,
+				     size_t size, enum dma_data_direction dir)
+{
+}
+
+static void hfi1_sync_single_for_device(struct ib_device *dev, u64 addr,
+					size_t size,
+					enum dma_data_direction dir)
+{
+}
+
+static void *hfi1_dma_alloc_coherent(struct ib_device *dev, size_t size,
+				     u64 *dma_handle, gfp_t flag)
+{
+	struct page *p;
+	void *addr = NULL;
+
+	p = alloc_pages(flag, get_order(size));
+	if (p)
+		addr = page_address(p);
+	if (dma_handle)
+		*dma_handle = (u64) addr;
+	return addr;
+}
+
+static void hfi1_dma_free_coherent(struct ib_device *dev, size_t size,
+				   void *cpu_addr, u64 dma_handle)
+{
+	free_pages((unsigned long) cpu_addr, get_order(size));
+}
+
+struct ib_dma_mapping_ops hfi1_dma_mapping_ops = {
+	.mapping_error = hfi1_mapping_error,
+	.map_single = hfi1_dma_map_single,
+	.unmap_single = hfi1_dma_unmap_single,
+	.map_page = hfi1_dma_map_page,
+	.unmap_page = hfi1_dma_unmap_page,
+	.map_sg = hfi1_map_sg,
+	.unmap_sg = hfi1_unmap_sg,
+	.sync_single_for_cpu = hfi1_sync_single_for_cpu,
+	.sync_single_for_device = hfi1_sync_single_for_device,
+	.alloc_coherent = hfi1_dma_alloc_coherent,
+	.free_coherent = hfi1_dma_free_coherent
+};

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
