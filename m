From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/9] dma: Add dma_virt_ops
Date: Tue, 10 Jan 2017 16:56:42 -0800
Message-ID: <20170111005648.14988-4-bart.vanassche@sandisk.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170111005648.14988-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, Joerg Roedel <jroedel@suse.de>, Andy Lutomirski <luto@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Several RDMA drivers need to provide a DMA mapping API but use the
CPU to transfer data. Provide DMA mapping operations that are
suitable for these drivers.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/dma-mapping.h |  1 +
 lib/Makefile                |  1 +
 lib/dma-noop.c              |  2 +-
 lib/dma-virt.c              | 73 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 lib/dma-virt.c

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ab8710888ddf..426c43d4fdbf 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -128,6 +128,7 @@ struct dma_map_ops {
 };
 
 extern const struct dma_map_ops dma_noop_ops;
+extern const struct dma_map_ops dma_virt_ops;
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
diff --git a/lib/Makefile b/lib/Makefile
index bc4073a8cd08..2d6c3fcd432c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -27,6 +27,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 lib-$(CONFIG_HAS_DMA) += dma-noop.o
+lib-$(CONFIG_HAS_DMA) += dma-virt.o
 
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
diff --git a/lib/dma-noop.c b/lib/dma-noop.c
index 65e49dd35b7b..de26c8b68f34 100644
--- a/lib/dma-noop.c
+++ b/lib/dma-noop.c
@@ -1,7 +1,7 @@
 /*
  *	lib/dma-noop.c
  *
- * Simple DMA noop-ops that map 1:1 with memory
+ * DMA operations that map to physical addresses without flushing memory.
  */
 #include <linux/export.h>
 #include <linux/mm.h>
diff --git a/lib/dma-virt.c b/lib/dma-virt.c
new file mode 100644
index 000000000000..b3573b6ad5b1
--- /dev/null
+++ b/lib/dma-virt.c
@@ -0,0 +1,73 @@
+/*
+ *	lib/dma-virt.c
+ *
+ * DMA operations that map to virtual addresses without flushing memory.
+ */
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+
+static void *dma_virt_alloc(struct device *dev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t gfp,
+			    unsigned long attrs)
+{
+	void *ret;
+
+	ret = (void *)__get_free_pages(gfp, get_order(size));
+	if (ret)
+		*dma_handle = (uintptr_t)ret;
+	return ret;
+}
+
+static void dma_virt_free(struct device *dev, size_t size,
+			  void *cpu_addr, dma_addr_t dma_addr,
+			  unsigned long attrs)
+{
+	free_pages((unsigned long)cpu_addr, get_order(size));
+}
+
+static dma_addr_t dma_virt_map_page(struct device *dev, struct page *page,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction dir,
+				      unsigned long attrs)
+{
+	return (uintptr_t)(page_address(page) + offset);
+}
+
+static int dma_virt_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
+			     enum dma_data_direction dir,
+			     unsigned long attrs)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(sgl, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+		sg_dma_address(sg) = (uintptr_t)sg_virt(sg);
+		sg_dma_len(sg) = sg->length;
+	}
+
+	return nents;
+}
+
+static int dma_virt_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return false;
+}
+
+static int dma_virt_supported(struct device *dev, u64 mask)
+{
+	return true;
+}
+
+const struct dma_map_ops dma_virt_ops = {
+	.alloc			= dma_virt_alloc,
+	.free			= dma_virt_free,
+	.map_page		= dma_virt_map_page,
+	.map_sg			= dma_virt_map_sg,
+	.mapping_error		= dma_virt_mapping_error,
+	.dma_supported		= dma_virt_supported,
+};
+
+EXPORT_SYMBOL(dma_virt_ops);
-- 
2.11.0
