From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 9/9] Samples: Peer memory client example
Date: Mon,  6 Oct 2014 16:26:59 +0300
Message-ID: <1412602019-30659-10-git-send-email-yishaih@mellanox.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412602019-30659-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Adds an example of a peer memory client which implements the peer memory
API as defined under include/rdma/peer_mem.h.
It uses the HOST memory functionality to implement the APIs and
can be a good reference for peer memory client writers.

Usage:
- It's built as a kernel module.
- The sample peer memory client takes ownership of a virtual memory area
  defined using module parameters.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 samples/Kconfig                        |   10 ++
 samples/Makefile                       |    3 +-
 samples/peer_memory/Makefile           |    1 +
 samples/peer_memory/example_peer_mem.c |  260 ++++++++++++++++++++++++++++++++
 4 files changed, 273 insertions(+), 1 deletions(-)
 create mode 100644 samples/peer_memory/Makefile
 create mode 100644 samples/peer_memory/example_peer_mem.c

diff --git a/samples/Kconfig b/samples/Kconfig
index 6181c2c..b75b771 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -21,6 +21,16 @@ config SAMPLE_KOBJECT
 
 	  If in doubt, say "N" here.
 
+config SAMPLE_PEER_MEMORY_CLIENT
+	tristate "Build peer memory sample client -- loadable modules only"
+	depends on INFINIBAND_USER_MEM && m
+	help
+	  This config option will allow you to build a peer memory
+	  example module that can be a very good reference for
+	  peer memory client plugin writers.
+
+	  If in doubt, say "N" here.
+
 config SAMPLE_KPROBES
 	tristate "Build kprobes examples -- loadable modules only"
 	depends on KPROBES && m
diff --git a/samples/Makefile b/samples/Makefile
index 1a60c62..b42117a 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,5 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
+			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
+			   peer_memory/
diff --git a/samples/peer_memory/Makefile b/samples/peer_memory/Makefile
new file mode 100644
index 0000000..f498125
--- /dev/null
+++ b/samples/peer_memory/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_PEER_MEMORY_CLIENT) += example_peer_mem.o
diff --git a/samples/peer_memory/example_peer_mem.c b/samples/peer_memory/example_peer_mem.c
new file mode 100644
index 0000000..b76013c
--- /dev/null
+++ b/samples/peer_memory/example_peer_mem.c
@@ -0,0 +1,260 @@
+/*
+ * Copyright (c) 2014, Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <rdma/peer_mem.h>
+
+#define DRV_NAME	"example_peer_mem"
+#define DRV_VERSION	"1.0"
+#define DRV_RELDATE	__DATE__
+
+MODULE_AUTHOR("Yishai Hadas");
+MODULE_DESCRIPTION("Example peer memory");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_VERSION(DRV_VERSION);
+static unsigned long example_mem_start_range;
+static unsigned long example_mem_end_range;
+
+module_param(example_mem_start_range, ulong, 0444);
+MODULE_PARM_DESC(example_mem_start_range, "peer example start memory range");
+module_param(example_mem_end_range, ulong, 0444);
+MODULE_PARM_DESC(example_mem_end_range, "peer example end memory range");
+
+static void *reg_handle;
+
+struct example_mem_context {
+	u64 core_context;
+	u64 page_virt_start;
+	u64 page_virt_end;
+	size_t mapped_size;
+	unsigned long npages;
+	int	      nmap;
+	unsigned long page_size;
+	int	      writable;
+	int dirty;
+};
+
+static void example_mem_put_pages(struct sg_table *sg_head, void *context);
+
+/* acquire return code: 1 mine, 0 - not mine */
+static int example_mem_acquire(unsigned long addr, size_t size, void *peer_mem_private_data,
+			       char *peer_mem_name, void **client_context)
+{
+	struct example_mem_context *example_mem_context;
+
+	if (!(addr >= example_mem_start_range) ||
+	    !(addr + size < example_mem_end_range))
+		/* peer is not the owner */
+		return 0;
+
+	example_mem_context = kzalloc(sizeof(*example_mem_context), GFP_KERNEL);
+	if (!example_mem_context)
+		/* Error case handled as not mine */
+		return 0;
+
+	example_mem_context->page_virt_start = addr & PAGE_MASK;
+	example_mem_context->page_virt_end   = (addr + size + PAGE_SIZE - 1) & PAGE_MASK;
+	example_mem_context->mapped_size  = example_mem_context->page_virt_end - example_mem_context->page_virt_start;
+
+	/* 1 means mine */
+	*client_context = example_mem_context;
+	__module_get(THIS_MODULE);
+	return 1;
+}
+
+static int example_mem_get_pages(unsigned long addr, size_t size, int write, int force,
+				 struct sg_table *sg_head, void *client_context, u64 core_context)
+{
+	int ret;
+	unsigned long npages;
+	unsigned long cur_base;
+	struct page **page_list;
+	struct scatterlist *sg, *sg_list_start;
+	int i;
+	struct example_mem_context *example_mem_context;
+
+	example_mem_context = (struct example_mem_context *)client_context;
+	example_mem_context->core_context = core_context;
+	example_mem_context->page_size = PAGE_SIZE;
+	example_mem_context->writable = write;
+	npages = example_mem_context->mapped_size >> PAGE_SHIFT;
+
+	if (npages == 0)
+		return -EINVAL;
+
+	ret = sg_alloc_table(sg_head, npages, GFP_KERNEL);
+	if (ret)
+		return ret;
+
+	page_list = (struct page **)__get_free_page(GFP_KERNEL);
+	if (!page_list) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	sg_list_start = sg_head->sgl;
+	cur_base = addr & PAGE_MASK;
+
+	while (npages) {
+		ret = get_user_pages(current, current->mm, cur_base,
+				     min_t(unsigned long, npages, PAGE_SIZE / sizeof(struct page *)),
+				     write, force, page_list, NULL);
+
+		if (ret < 0)
+			goto out;
+
+		example_mem_context->npages += ret;
+		cur_base += ret * PAGE_SIZE;
+		npages   -= ret;
+
+		for_each_sg(sg_list_start, sg, ret, i)
+				sg_set_page(sg, page_list[i], PAGE_SIZE, 0);
+
+		/* preparing for next loop */
+		sg_list_start = sg;
+	}
+
+out:
+	if (page_list)
+		free_page((unsigned long)page_list);
+
+	if (ret < 0) {
+		example_mem_put_pages(sg_head, client_context);
+		return ret;
+	}
+	/* mark that pages were exposed from the peer memory */
+	example_mem_context->dirty = 1;
+	return 0;
+}
+
+static int example_mem_dma_map(struct sg_table *sg_head, void *context,
+			       struct device *dma_device, int dmasync,
+			       int *nmap)
+{
+	DEFINE_DMA_ATTRS(attrs);
+	struct example_mem_context *example_mem_context =
+		(struct example_mem_context *)context;
+
+	if (dmasync)
+		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
+	 example_mem_context->nmap = dma_map_sg_attrs(dma_device, sg_head->sgl,
+						      example_mem_context->npages,
+						      DMA_BIDIRECTIONAL, &attrs);
+	if (example_mem_context->nmap <= 0)
+		return -ENOMEM;
+
+	*nmap = example_mem_context->nmap;
+	return 0;
+}
+
+static int example_mem_dma_unmap(struct sg_table *sg_head, void *context,
+				 struct device  *dma_device)
+{
+	struct example_mem_context *example_mem_context =
+		(struct example_mem_context *)context;
+
+	dma_unmap_sg(dma_device, sg_head->sgl,
+		     example_mem_context->nmap,
+		     DMA_BIDIRECTIONAL);
+	return 0;
+}
+
+static void example_mem_put_pages(struct sg_table *sg_head, void *context)
+{
+	struct scatterlist *sg;
+	struct page *page;
+	int i;
+
+	struct example_mem_context *example_mem_context =
+		(struct example_mem_context *)context;
+
+	for_each_sg(sg_head->sgl, sg, example_mem_context->npages, i) {
+		page = sg_page(sg);
+		if (example_mem_context->writable && example_mem_context->dirty)
+			set_page_dirty_lock(page);
+		put_page(page);
+	}
+
+	sg_free_table(sg_head);
+}
+
+static void example_mem_release(void *context)
+{
+	struct example_mem_context *example_mem_context =
+		(struct example_mem_context *)context;
+
+	kfree(example_mem_context);
+	module_put(THIS_MODULE);
+}
+
+static unsigned long example_mem_get_page_size(void *context)
+{
+	struct example_mem_context *example_mem_context =
+				(struct example_mem_context *)context;
+
+	return example_mem_context->page_size;
+}
+
+static const struct peer_memory_client example_mem_client = {
+	.name			= DRV_NAME,
+	.version		= DRV_VERSION,
+	.acquire		= example_mem_acquire,
+	.get_pages	= example_mem_get_pages,
+	.dma_map	= example_mem_dma_map,
+	.dma_unmap	= example_mem_dma_unmap,
+	.put_pages	= example_mem_put_pages,
+	.get_page_size	= example_mem_get_page_size,
+	.release		= example_mem_release,
+};
+
+static int __init example_mem_client_init(void)
+{
+	reg_handle = ib_register_peer_memory_client(&example_mem_client, NULL);
+	if (!reg_handle)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit example_mem_client_cleanup(void)
+{
+	ib_unregister_peer_memory_client(reg_handle);
+}
+
+module_init(example_mem_client_init);
+module_exit(example_mem_client_cleanup);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
