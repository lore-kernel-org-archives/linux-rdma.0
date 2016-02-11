From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 6/7] IB/core: Peer memory client for IO memory
Date: Thu, 11 Feb 2016 18:12:56 +0200
Message-ID: <1455207177-11949-7-git-send-email-artemyko@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds kernel module allowing RDMA transfers with various types of memory
like mmaped devices (that create PFN mappings) and mmaped files from DAX
filesystems, such as those that reside on NVRAM devices.

Module original source [1]

[1] https://github.com/sbates130272/io_peer_mem

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/Kconfig            |   9 +
 drivers/infiniband/core/Makefile      |   4 +
 drivers/infiniband/core/io_peer_mem.c | 332 ++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+)
 create mode 100644 drivers/infiniband/core/io_peer_mem.c

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 2837d66..90811b2 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -74,6 +74,15 @@ config INFINIBAND_PEER_MEM
 	  memory in external hardware devices, such as GPU cards, SSD based
 	  storage, dedicated ASIC accelerators, etc.
 
+config INFINIBAND_IO_PEER_MEM
+	tristate "InfiniBand Peer memory client for IO memory"
+	depends on INFINIBAND_PEER_MEM
+	default y
+	---help---
+	  Adds kernel module allowing RDMA transfers with various types of memory
+	  like mmaped devices (that create PFN mappings) and mmaped files from DAX
+	  filesystems, such as those that reside on NVRAM devices.
+
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 9882d00..529f1e9 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_mad.o ib_sa.o \
 obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
+obj-$(CONFIG_INFINIBAND_IO_PEER_MEM) += ib_io_mr.o
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
@@ -36,3 +37,6 @@ ib_umad-y :=			user_mad.o
 ib_ucm-y :=			ucm.o
 
 ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+
+ib_io_mr-y :=			io_peer_mem.o
+
diff --git a/drivers/infiniband/core/io_peer_mem.c b/drivers/infiniband/core/io_peer_mem.c
new file mode 100644
index 0000000..df7161c
--- /dev/null
+++ b/drivers/infiniband/core/io_peer_mem.c
@@ -0,0 +1,332 @@
+/*
+ * Copyright (c) 2015 PMC-Sierra Inc.
+ * Copyright (c) 2016 Mellanox Technologies, Inc.  All rights reserved.
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
+
+#include <rdma/peer_mem.h>
+
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mmu_notifier.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+
+MODULE_AUTHOR("Logan Gunthorpe");
+MODULE_DESCRIPTION("MMAP'd IO memory plug-in");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static void *reg_handle;
+static int (*mem_invalidate_callback)(void *reg_handle, u64 core_context);
+
+struct context {
+	unsigned long addr;
+	size_t size;
+	u64 core_context;
+	struct mmu_notifier mn;
+	struct pid *pid;
+	int active;
+	struct work_struct cleanup_work;
+	struct mutex mmu_mutex;
+};
+
+static void do_invalidate(struct context *ctx)
+{
+	mutex_lock(&ctx->mmu_mutex);
+
+	if (!ctx->active)
+		goto unlock_and_return;
+
+	ctx->active = 0;
+	pr_debug("invalidated addr %lx size %zx\n", ctx->addr, ctx->size);
+	mem_invalidate_callback(reg_handle, ctx->core_context);
+
+unlock_and_return:
+	mutex_unlock(&ctx->mmu_mutex);
+}
+
+static void mmu_release(struct mmu_notifier *mn,
+			struct mm_struct *mm)
+{
+	struct context *ctx = container_of(mn, struct context, mn);
+
+	do_invalidate(ctx);
+}
+
+static void mmu_invalidate_range(struct mmu_notifier *mn,
+				 struct mm_struct *mm,
+				 unsigned long start, unsigned long end)
+{
+	struct context *ctx = container_of(mn, struct context, mn);
+
+	if (start >= (ctx->addr + ctx->size) || ctx->addr >= end)
+		return;
+
+	pr_debug("mmu_invalidate_range %lx-%lx\n", start, end);
+	do_invalidate(ctx);
+}
+
+static void mmu_invalidate_page(struct mmu_notifier *mn,
+				struct mm_struct *mm,
+				unsigned long address)
+{
+	struct context *ctx = container_of(mn, struct context, mn);
+
+	if (address < ctx->addr || address < (ctx->addr + ctx->size))
+		return;
+
+	pr_debug("mmu_invalidate_page %lx\n", address);
+	do_invalidate(ctx);
+}
+
+static struct mmu_notifier_ops mmu_notifier_ops = {
+	.release = mmu_release,
+	.invalidate_range = mmu_invalidate_range,
+	.invalidate_page = mmu_invalidate_page,
+};
+
+static void fault_missing_pages(struct vm_area_struct *vma, unsigned long start,
+				unsigned long end)
+{
+	unsigned long pfn;
+
+	if (!(vma->vm_flags & VM_MIXEDMAP))
+		return;
+
+	for (; start < end; start += PAGE_SIZE) {
+		if (!follow_pfn(vma, start, &pfn))
+			continue;
+
+		handle_mm_fault(current->mm, vma, start, FAULT_FLAG_WRITE);
+	}
+}
+
+static int acquire(unsigned long addr, size_t size, void **context)
+{
+	struct vm_area_struct *vma;
+	struct context *ctx;
+	unsigned long pfn, end;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return 0;
+
+	ctx->addr = addr;
+	ctx->size = size;
+	ctx->active = 0;
+
+	end = addr + size;
+	vma = find_vma(current->mm, addr);
+
+	if (!vma || vma->vm_end < end)
+		goto err;
+
+	pr_debug("vma: %lx %lx %lx %zx\n", addr, vma->vm_end - vma->vm_start,
+		 vma->vm_flags, size);
+
+	if (!(vma->vm_flags & VM_WRITE))
+		goto err;
+
+	fault_missing_pages(vma, addr & PAGE_MASK, end);
+
+	if (follow_pfn(vma, addr, &pfn))
+		goto err;
+
+	pr_debug("pfn: %lx\n", pfn << PAGE_SHIFT);
+
+	mutex_init(&ctx->mmu_mutex);
+
+	ctx->mn.ops = &mmu_notifier_ops;
+
+	if (mmu_notifier_register(&ctx->mn, current->mm)) {
+		pr_err("Failed to register mmu_notifier\n");
+		goto err;
+	}
+
+	ctx->pid = get_task_pid(current->group_leader, PIDTYPE_PID);
+
+	if (!ctx->pid)
+		goto err;
+
+	pr_debug("acquire %p\n", ctx);
+	*context = ctx;
+	return 1;
+
+err:
+	kfree(ctx);
+	return 0;
+}
+
+static void deferred_cleanup(struct work_struct *work)
+{
+	struct context *ctx = container_of(work, struct context, cleanup_work);
+	struct task_struct *owning_process;
+	struct mm_struct *owning_mm;
+
+	pr_debug("cleanup %p\n", ctx);
+
+	owning_process = get_pid_task(ctx->pid, PIDTYPE_PID);
+	if (owning_process) {
+		owning_mm = get_task_mm(owning_process);
+		if (owning_mm) {
+			mmu_notifier_unregister(&ctx->mn, owning_mm);
+			mmput(owning_mm);
+		}
+		put_task_struct(owning_process);
+	}
+	put_pid(ctx->pid);
+	kfree(ctx);
+}
+
+static void release(void *context)
+{
+	struct context *ctx = context;
+
+	pr_debug("release %p\n", ctx);
+
+	INIT_WORK(&ctx->cleanup_work, deferred_cleanup);
+	schedule_work(&ctx->cleanup_work);
+}
+
+static int get_pages(unsigned long addr, size_t size, int write, int force,
+		     struct sg_table *sg_head, void *context,
+		     u64 core_context)
+{
+	struct context *ctx = context;
+	int ret;
+
+	ctx->core_context = core_context;
+	ctx->active = 1;
+
+	ret = sg_alloc_table(sg_head, (ctx->size + PAGE_SIZE - 1) / PAGE_SIZE,
+			     GFP_KERNEL);
+	return ret;
+}
+
+static void put_pages(struct sg_table *sg_head, void *context)
+{
+	struct context *ctx = context;
+
+	ctx->active = 0;
+	sg_free_table(sg_head);
+}
+
+static int dma_map(struct sg_table *sg_head, void *context,
+		   struct device *dma_device, int dmasync,
+		   int *nmap)
+{
+	struct scatterlist *sg;
+	struct context *ctx = context;
+	unsigned long pfn;
+	unsigned long addr = ctx->addr;
+	unsigned long size = ctx->size;
+	struct task_struct *owning_process;
+	struct mm_struct *owning_mm;
+	struct vm_area_struct *vma = NULL;
+	int i, ret = 1;
+
+	*nmap = (ctx->size + PAGE_SIZE - 1) / PAGE_SIZE;
+
+	owning_process = get_pid_task(ctx->pid, PIDTYPE_PID);
+	if (!owning_process)
+		return ret;
+
+	owning_mm = get_task_mm(owning_process);
+	if (!owning_mm)
+		goto out;
+
+	vma = find_vma(owning_mm, ctx->addr);
+	if (!vma)
+		goto out;
+
+	for_each_sg(sg_head->sgl, sg, *nmap, i) {
+		sg_set_page(sg, NULL, PAGE_SIZE, 0);
+		ret = follow_pfn(vma, addr, &pfn);
+		if (ret)
+			goto out;
+
+		sg->dma_address = (pfn << PAGE_SHIFT);
+		sg->dma_length = PAGE_SIZE;
+		sg->offset = addr & ~PAGE_MASK;
+
+		pr_debug("sg[%d] %lx %x %d\n", i,
+			 (unsigned long)sg->dma_address,
+			 sg->dma_length, sg->offset);
+
+		addr += sg->dma_length - sg->offset;
+		size -= sg->dma_length - sg->offset;
+	}
+out:
+	put_task_struct(owning_process);
+
+	return 0;
+}
+
+static int dma_unmap(struct sg_table *sg_head, void *context,
+		     struct device  *dma_device)
+{
+	return 0;
+}
+
+static unsigned long get_page_size(void *context)
+{
+	return PAGE_SIZE;
+}
+
+static struct peer_memory_client io_mem_client = {
+	.acquire	= acquire,
+	.get_pages	= get_pages,
+	.dma_map	= dma_map,
+	.dma_unmap	= dma_unmap,
+	.put_pages	= put_pages,
+	.get_page_size	= get_page_size,
+	.release	= release,
+};
+
+static int __init io_mem_init(void)
+{
+	reg_handle = ib_register_peer_memory_client(&io_mem_client,
+						    &mem_invalidate_callback);
+
+	if (!reg_handle)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit io_mem_cleanup(void)
+{
+	ib_unregister_peer_memory_client(reg_handle);
+}
+
+module_init(io_mem_init);
+module_exit(io_mem_cleanup);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
