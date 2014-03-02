From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 04/20] IB/core: Add support for on demand paging regions
Date: Sun,  2 Mar 2014 12:49:22 +0200
Message-ID: <1393757378-16412-5-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

* Extend the umem struct to keep the ODP related data.
* Allocate and initialize the ODP related information in the umem
  (page_list, dma_list) and freeing as needed in the end of the run.
* Store a reference to the process PID struct in the ucontext. Used to
  safely obtain the task_struct and the mm during fault handling, without
  preventing the task destruction if needed.
* Add 2 helper functions: ib_umem_odp_map_dma_pages and
  ib_umem_odp_unmap_dma_pages. These functions get the DMA addresses of
  specific pages of the umem (and, currently, pin them).
* Support for page faults only - IB core will keep the reference on the pages
  used and call put_page when freeing an ODP umem area. Invalidations support
  will be added in a later patch.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/umem.c        |  24 +++
 drivers/infiniband/core/umem_odp.c    | 310 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c  |   5 +
 drivers/infiniband/core/uverbs_main.c |   2 +
 include/rdma/ib_umem.h                |   2 +
 include/rdma/ib_umem_odp.h            | 100 +++++++++++
 include/rdma/ib_verbs.h               |   3 +
 8 files changed, 447 insertions(+)
 create mode 100644 drivers/infiniband/core/umem_odp.c
 create mode 100644 include/rdma/ib_umem_odp.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 3ab3865..5af6f4a 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
+ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o
 
 ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
 
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 138442a..e9798e0 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -39,6 +39,7 @@
 #include <linux/hugetlb.h>
 #include <linux/dma-attrs.h>
 #include <linux/slab.h>
+#include <rdma/ib_umem_odp.h>
 
 #include "uverbs.h"
 
@@ -69,6 +70,10 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 
 /**
  * ib_umem_get - Pin and DMA map userspace memory.
+ *
+ * If access flags indicate ODP memory, avoid pinning. Instead, stores
+ * the mm for future page fault handling.
+ *
  * @context: userspace context to pin memory for
  * @addr: userspace virtual address to start at
  * @size: length of region to pin
@@ -116,6 +121,17 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		(IB_ACCESS_LOCAL_WRITE   | IB_ACCESS_REMOTE_WRITE |
 		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
 
+	if (access & IB_ACCESS_ON_DEMAND) {
+		ret = ib_umem_odp_get(context, umem);
+		if (ret) {
+			kfree(umem);
+			return ERR_PTR(ret);
+		}
+		return umem;
+	}
+
+	umem->odp_data = NULL;
+
 	/* We assume the memory is from hugetlb until proved otherwise */
 	umem->hugetlb   = 1;
 
@@ -234,6 +250,11 @@ void ib_umem_release(struct ib_umem *umem)
 	struct mm_struct *mm;
 	unsigned long diff;
 
+	if (umem->odp_data) {
+		ib_umem_odp_release(umem);
+		return;
+	}
+
 	__ib_umem_release(umem->context->device, umem, 1);
 
 	mm = get_task_mm(current);
@@ -278,6 +299,9 @@ int ib_umem_page_count(struct ib_umem *umem)
 	int n;
 	struct scatterlist *sg;
 
+	if (umem->odp_data)
+		return ib_umem_num_pages(umem);
+
 	shift = ilog2(umem->page_size);
 
 	n = 0;
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
new file mode 100644
index 0000000..67b7816
--- /dev/null
+++ b/drivers/infiniband/core/umem_odp.c
@@ -0,0 +1,310 @@
+/*
+ * Copyright (c) 2014 Mellanox Technologies. All rights reserved.
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
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/pid.h>
+#include <linux/slab.h>
+#include <linux/export.h>
+#include <linux/vmalloc.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_umem.h>
+#include <rdma/ib_umem_odp.h>
+
+int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
+{
+	int ret_val;
+	struct pid *our_pid;
+
+	/* Prevent creating ODP MRs in child processes */
+	rcu_read_lock();
+	our_pid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
+	put_pid(our_pid);
+	if (context->tgid != our_pid)
+		return -EINVAL;
+
+	umem->hugetlb = 0;
+	umem->odp_data = kzalloc(sizeof(*umem->odp_data), GFP_KERNEL);
+	if (!umem->odp_data)
+		return -ENOMEM;
+
+	mutex_init(&umem->odp_data->umem_mutex);
+
+	umem->odp_data->page_list = vzalloc(ib_umem_num_pages(umem) *
+					    sizeof(*umem->odp_data->page_list));
+	if (!umem->odp_data->page_list) {
+		ret_val = -ENOMEM;
+		goto out_odp_data;
+	}
+
+	umem->odp_data->dma_list = vzalloc(ib_umem_num_pages(umem) *
+					  sizeof(*umem->odp_data->dma_list));
+	if (!umem->odp_data->dma_list) {
+		ret_val = -ENOMEM;
+		goto out_page_list;
+	}
+
+	return 0;
+
+out_page_list:
+	vfree(umem->odp_data->page_list);
+out_odp_data:
+	kfree(umem->odp_data);
+	return ret_val;
+}
+
+void ib_umem_odp_release(struct ib_umem *umem)
+{
+	/*
+	 * Ensure that no more pages are mapped in the umem.
+	 *
+	 * It is the driver's responsibility to ensure, before calling us,
+	 * that the hardware will not attempt to access the MR any more.
+	 */
+	ib_umem_odp_unmap_dma_pages(umem, ib_umem_start(umem),
+				    ib_umem_end(umem));
+
+	vfree(umem->odp_data->dma_list);
+	vfree(umem->odp_data->page_list);
+	kfree(umem);
+}
+
+/*
+ * Map for DMA and insert a single page into the on-demand paging page tables.
+ *
+ * @umem: the umem to insert the page to.
+ * @page_index: index in the umem to add the page to.
+ * @page: the page struct to map and add.
+ * @access_mask: access permissions needed for this page.
+ * @current_seq: sequence number for synchronization with invalidations.
+ *               the sequence number is taken from
+ *               umem->odp_data->notifiers_seq.
+ *
+ * The function returns -EFAULT if the DMA mapping operation fails.
+ *
+ * The page is released via put_page even if the operation failed. For
+ * on-demand pinning, the page is released whenever it isn't stored in the
+ * umem.
+ */
+static int ib_umem_odp_map_dma_single_page(
+		struct ib_umem *umem,
+		int page_index,
+		struct page *page,
+		u64 access_mask,
+		unsigned long current_seq)
+{
+	struct ib_device *dev = umem->context->device;
+	dma_addr_t dma_addr;
+	int stored_page = 0;
+	int ret = 0;
+	mutex_lock(&umem->odp_data->umem_mutex);
+	if (!(umem->odp_data->dma_list[page_index])) {
+		dma_addr = ib_dma_map_page(dev,
+					   page,
+					   0, PAGE_SIZE,
+					   DMA_BIDIRECTIONAL);
+		if (ib_dma_mapping_error(dev, dma_addr)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		umem->odp_data->dma_list[page_index] = dma_addr | access_mask;
+		umem->odp_data->page_list[page_index] = page;
+		stored_page = 1;
+	} else if (umem->odp_data->page_list[page_index] == page) {
+		/* Same page. Note that when we add support for different
+		 * permissions for different pages in the same umem, we will
+		 * need to re-map the page for DMA here with the new
+		 * permissions. */
+		WARN_ON(access_mask != (umem->odp_data->dma_list[page_index] &
+					~ODP_DMA_ADDR_MASK));
+	} else {
+		pr_err("error: got different pages in IB device and from get_user_pages. IB device page: %p, gup page: %p\n",
+		       umem->odp_data->page_list[page_index], page);
+	}
+
+out:
+	mutex_unlock(&umem->odp_data->umem_mutex);
+
+	if (!stored_page)
+		put_page(page);
+
+	return ret;
+}
+
+/**
+ * ib_umem_odp_map_dma_pages - Pin and DMA map userspace memory in an ODP MR.
+ *
+ * Pins the range of pages passed in the argument, and maps them to
+ * DMA addresses. The DMA addresses of the mapped pages is updated in
+ * umem->odp_data->dma_list.
+ *
+ * Returns the number of pages mapped in success, negative error code
+ * for failure.
+ *
+ * @umem: the umem to map and pin
+ * @user_virt: the address from which we need to map.
+ * @bcnt: the minimal number of bytes to pin and map. The mapping might be
+ *        bigger due to alignment, and may also be smaller in case of an error
+ *        pinning or mapping a page. The actual pages mapped is returned in
+ *        the return value.
+ * @access_mask: bit mask of the requested access permissions for the given
+ *               range.
+ * @current_seq: the MMU notifiers sequance value for synchronization with
+ *               invalidations. the sequance number is read from
+ *               umem->odp_data->notifiers_seq before calling this function
+ */
+int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
+			      u64 access_mask, unsigned long current_seq)
+{
+	struct task_struct *owning_process  = NULL;
+	struct mm_struct   *owning_mm       = NULL;
+	struct page       **local_page_list = NULL;
+	u64 off;
+	int j, k, ret = 0, start_idx, npages = 0;
+
+	if (access_mask == 0)
+		return -EINVAL;
+
+	if (user_virt < umem->address ||
+	    user_virt + bcnt > umem->address + umem->length)
+		return -EFAULT;
+
+	local_page_list = (struct page **)__get_free_page(GFP_KERNEL);
+	if (!local_page_list)
+		return -ENOMEM;
+
+	off = user_virt & (~PAGE_MASK);
+	user_virt = user_virt & PAGE_MASK;
+	bcnt += off; /* Charge for the first page offset as well. */
+
+	start_idx = (user_virt - ib_umem_start(umem)) >> PAGE_SHIFT;
+	k = start_idx;
+
+	owning_process = get_pid_task(umem->context->tgid, PIDTYPE_PID);
+	if (owning_process == NULL) {
+		ret = -EINVAL;
+		goto out_no_task;
+	}
+
+	owning_mm = get_task_mm(owning_process);
+	if (owning_mm == NULL) {
+		ret = -EINVAL;
+		goto out_put_task;
+	}
+
+	while (bcnt > 0) {
+		down_read(&owning_mm->mmap_sem);
+		/*
+		 * Note: this might result in redundent page getting. We can
+		 * avoid this by checking dma_list to be 0 before calling
+		 * get_user_pages. However, this make the code much more
+		 * complex (and doesn't gain us much performance in most use
+		 * cases).
+		 */
+		npages = get_user_pages(owning_process, owning_mm,
+				     user_virt,
+				     min_t(size_t, max_t(size_t, 1,
+							 bcnt >> PAGE_SHIFT),
+					   PAGE_SIZE / sizeof(struct page *)),
+				     access_mask & ODP_WRITE_ALLOWED_BIT, 0,
+				     local_page_list, NULL);
+		up_read(&owning_mm->mmap_sem);
+
+		if (npages < 0)
+			break;
+
+		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
+		user_virt += npages << PAGE_SHIFT;
+		for (j = 0; j < npages; ++j) {
+			ret = ib_umem_odp_map_dma_single_page(umem, k,
+				local_page_list[j], access_mask, current_seq);
+			if (ret < 0)
+				break;
+			k++;
+		}
+
+		if (ret < 0) {
+			/* Release left over pages when handling errors. */
+			for (++j; j < npages; ++j)
+				put_page(local_page_list[j]);
+		}
+	}
+
+	if (ret >= 0) {
+		if (npages < 0 && k == start_idx)
+			ret = npages;
+		else
+			ret = k - start_idx;
+	}
+
+	mmput(owning_mm);
+out_put_task:
+	put_task_struct(owning_process);
+out_no_task:
+	free_page((unsigned long) local_page_list);
+	return ret;
+}
+EXPORT_SYMBOL(ib_umem_odp_map_dma_pages);
+
+void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
+				 u64 bound)
+{
+	int idx;
+	u64 addr;
+	struct ib_device *dev = umem->context->device;
+	virt  = max_t(u64, virt,  ib_umem_start(umem));
+	bound = min_t(u64, bound, ib_umem_end(umem));
+	for (addr = virt; addr < bound; addr += (u64)umem->page_size) {
+		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
+		mutex_lock(&umem->odp_data->umem_mutex);
+		if (umem->odp_data->page_list[idx]) {
+			struct page *page = umem->odp_data->page_list[idx];
+			struct page *head_page = compound_trans_head(page);
+			dma_addr_t dma_addr = umem->odp_data->dma_list[idx] &
+					      ODP_DMA_ADDR_MASK;
+
+			WARN_ON(!dma_addr);
+
+			ib_dma_unmap_page(dev, dma_addr, PAGE_SIZE,
+					  DMA_BIDIRECTIONAL);
+			if (umem->writable)
+				set_page_dirty_lock(head_page);
+			put_page(page);
+		}
+		mutex_unlock(&umem->odp_data->umem_mutex);
+	}
+}
+EXPORT_SYMBOL(ib_umem_odp_unmap_dma_pages);
+
+
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2795d86..6c6be37 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -36,6 +36,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 
@@ -325,6 +326,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->ah_list);
 	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	INIT_LIST_HEAD(&ucontext->rule_list);
+	rcu_read_lock();
+	ucontext->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
 	ucontext->closing = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
@@ -371,6 +375,7 @@ err_fd:
 	put_unused_fd(resp.async_fd);
 
 err_free:
+	put_pid(ucontext->tgid);
 	ibdev->dealloc_ucontext(ucontext);
 
 err:
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index a767298..a7384f8 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -298,6 +298,8 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	put_pid(context->tgid);
+
 	return context->device->dealloc_ucontext(context);
 }
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 6af91b3..55fc858 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -38,6 +38,7 @@
 #include <linux/workqueue.h>
 
 struct ib_ucontext;
+struct ib_umem_odp;
 
 struct ib_umem {
 	struct ib_ucontext     *context;
@@ -49,6 +50,7 @@ struct ib_umem {
 	struct work_struct	work;
 	struct mm_struct       *mm;
 	unsigned long		diff;
+	struct ib_umem_odp     *odp_data;
 	struct sg_table sg_head;
 	int             nmap;
 	int             npages;
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
new file mode 100644
index 0000000..375ce28
--- /dev/null
+++ b/include/rdma/ib_umem_odp.h
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2014 Mellanox Technologies. All rights reserved.
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
+#ifndef IB_UMEM_ODP_H
+#define IB_UMEM_ODP_H
+
+#include <rdma/ib_umem.h>
+
+struct ib_umem_odp {
+	/*
+	 * An array of the pages included in the on-demand paging umem.
+	 * Indices of pages that are currently not mapped into the device will
+	 * contain NULL.
+	 */
+	struct page		**page_list;
+	/*
+	 * An array of the same size as page_list, with DMA addresses mapped
+	 * for pages the pages in page_list. The lower two bits designate
+	 * access permissions. See ODP_READ_ALLOWED_BIT and
+	 * ODP_WRITE_ALLOWED_BIT.
+	 */
+	dma_addr_t		*dma_list;
+	/*
+	 * The umem_mutex protects the page_list and dma_list fields of an ODP
+	 * umem, allowing only a single thread to map/unmap pages.
+	 */
+	struct mutex		umem_mutex;
+	void			*private; /* for the HW driver to use. */
+
+	atomic_t		notifiers_seq;
+	atomic_t		notifiers_count;
+};
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+
+int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem);
+
+void ib_umem_odp_release(struct ib_umem *umem);
+
+/*
+ * The lower 2 bits of the DMA address signal the R/W permissions for
+ * the entry. To upgrade the permissions, provide the appropriate
+ * bitmask to the map_dma_pages function.
+ *
+ * Be aware that upgrading a mapped address might result in change of
+ * the DMA address for the page.
+ */
+#define ODP_READ_ALLOWED_BIT  (1<<0ULL)
+#define ODP_WRITE_ALLOWED_BIT (1<<1ULL)
+
+#define ODP_DMA_ADDR_MASK (~(ODP_READ_ALLOWED_BIT | ODP_WRITE_ALLOWED_BIT))
+
+int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 start_offset, u64 bcnt,
+			      u64 access_mask, unsigned long current_seq);
+
+void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 start_offset,
+				 u64 bound);
+
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+
+static inline int ib_umem_odp_get(struct ib_ucontext *context,
+				  struct ib_umem *umem)
+{
+	return -EINVAL;
+}
+
+static inline void ib_umem_odp_release(struct ib_umem *umem) {}
+
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+
+#endif /* IB_UMEM_ODP_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 129261c..c557bb5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1153,6 +1153,9 @@ struct ib_ucontext {
 	struct list_head	xrcd_list;
 	struct list_head	rule_list;
 	int			closing;
+
+	/* For ODP support: */
+	struct pid             *tgid;
 };
 
 struct ib_uobject {
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
