From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 07/37] lib/dma-virt: Add dma_virt_ops
Date: Fri, 20 Jan 2017 13:04:07 -0800
Message-ID: <20170120210437.26389-8-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Several RDMA drivers (hfi1, qib and rxe) expect that ib_sge.addr
is a virtual address. Provide DMA mapping operations that are
suitable for these drivers.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/dma-mapping.h |  1 +
 lib/Kconfig                 |  5 ++++
 lib/Makefile                |  1 +
 lib/dma-virt.c              | 72 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)
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
 
diff --git a/lib/Kconfig b/lib/Kconfig
index b6baf0609e8b..97af23b26f33 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -400,6 +400,11 @@ config DMA_NOOP_OPS
 	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
 	default n
 
+config DMA_VIRT_OPS
+	bool
+	depends on HAS_DMA && (!64BIT || ARCH_DMA_ADDR_T_64BIT)
+	default n
+
 config CHECK_SIGNATURE
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index ada06d5652e8..b97e9a814854 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -27,6 +27,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 lib-$(CONFIG_DMA_NOOP_OPS) += dma-noop.o
+lib-$(CONFIG_DMA_VIRT_OPS) += dma-virt.o
 
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
diff --git a/lib/dma-virt.c b/lib/dma-virt.c
new file mode 100644
index 000000000000..dcd4df1f7174
--- /dev/null
+++ b/lib/dma-virt.c
@@ -0,0 +1,72 @@
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
+				    unsigned long offset, size_t size,
+				    enum dma_data_direction dir,
+				    unsigned long attrs)
+{
+	return (uintptr_t)(page_address(page) + offset);
+}
+
+static int dma_virt_map_sg(struct device *dev, struct scatterlist *sgl,
+			   int nents, enum dma_data_direction dir,
+			   unsigned long attrs)
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
+EXPORT_SYMBOL(dma_virt_ops);
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
