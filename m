From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 10/32] IB/rxe: User/kernel shared queues infrastructure
Date: Wed, 16 Sep 2015 16:42:44 +0300
Message-ID: <1442410986-28232-11-git-send-email-kamalh@mellanox.com>
References: <1442410986-28232-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442410986-28232-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

mmap routines

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/staging/rxe/rxe_mmap.c | 173 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 173 insertions(+)
 create mode 100644 drivers/staging/rxe/rxe_mmap.c

diff --git a/drivers/staging/rxe/rxe_mmap.c b/drivers/staging/rxe/rxe_mmap.c
new file mode 100644
index 0000000..fbe3e1d
--- /dev/null
+++ b/drivers/staging/rxe/rxe_mmap.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
+ * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
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
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
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
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <asm/pgtable.h>
+
+#include "rxe.h"
+#include "rxe_loc.h"
+#include "rxe_queue.h"
+
+void rxe_mmap_release(struct kref *ref)
+{
+	struct rxe_mmap_info *ip = container_of(ref,
+					struct rxe_mmap_info, ref);
+	struct rxe_dev *rxe = to_rdev(ip->context->device);
+
+	spin_lock_bh(&rxe->pending_lock);
+
+	if (!list_empty(&ip->pending_mmaps))
+		list_del(&ip->pending_mmaps);
+
+	spin_unlock_bh(&rxe->pending_lock);
+
+	vfree(ip->obj);		/* buf */
+	kfree(ip);
+}
+
+/*
+ * open and close keep track of how many times the memory region is mapped,
+ * to avoid releasing it.
+ */
+static void rxe_vma_open(struct vm_area_struct *vma)
+{
+	struct rxe_mmap_info *ip = vma->vm_private_data;
+
+	kref_get(&ip->ref);
+}
+
+static void rxe_vma_close(struct vm_area_struct *vma)
+{
+	struct rxe_mmap_info *ip = vma->vm_private_data;
+
+	kref_put(&ip->ref, rxe_mmap_release);
+}
+
+static struct vm_operations_struct rxe_vm_ops = {
+	.open = rxe_vma_open,
+	.close = rxe_vma_close,
+};
+
+/**
+ * rxe_mmap - create a new mmap region
+ * @context: the IB user context of the process making the mmap() call
+ * @vma: the VMA to be initialized
+ * Return zero if the mmap is OK. Otherwise, return an errno.
+ */
+int rxe_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	struct rxe_dev *rxe = to_rdev(context->device);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	struct rxe_mmap_info *ip, *pp;
+	int ret;
+
+	/*
+	 * Search the device's list of objects waiting for a mmap call.
+	 * Normally, this list is very short since a call to create a
+	 * CQ, QP, or SRQ is soon followed by a call to mmap().
+	 */
+	spin_lock_bh(&rxe->pending_lock);
+	list_for_each_entry_safe(ip, pp, &rxe->pending_mmaps, pending_mmaps) {
+		if (context != ip->context || (__u64)offset != ip->info.offset)
+			continue;
+
+		/* Don't allow a mmap larger than the object. */
+		if (size > ip->info.size) {
+			pr_err("mmap region is larger than the object!\n");
+			spin_unlock_bh(&rxe->pending_lock);
+			ret = -EINVAL;
+			goto done;
+		}
+
+		goto found_it;
+	}
+	pr_warn("unable to find pending mmap info\n");
+	spin_unlock_bh(&rxe->pending_lock);
+	ret = -EINVAL;
+	goto done;
+
+found_it:
+	list_del_init(&ip->pending_mmaps);
+	spin_unlock_bh(&rxe->pending_lock);
+
+	ret = remap_vmalloc_range(vma, ip->obj, 0);
+	if (ret) {
+		pr_err("rxe: err %d from remap_vmalloc_range\n", ret);
+		goto done;
+	}
+
+	vma->vm_ops = &rxe_vm_ops;
+	vma->vm_private_data = ip;
+	rxe_vma_open(vma);
+done:
+	return ret;
+}
+
+/*
+ * Allocate information for rxe_mmap
+ */
+struct rxe_mmap_info *rxe_create_mmap_info(struct rxe_dev *rxe,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj)
+{
+	struct rxe_mmap_info *ip;
+
+	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
+	if (!ip)
+		return NULL;
+
+	size = PAGE_ALIGN(size);
+
+	spin_lock_bh(&rxe->mmap_offset_lock);
+
+	if (rxe->mmap_offset == 0)
+		rxe->mmap_offset = PAGE_SIZE;
+
+	ip->info.offset = rxe->mmap_offset;
+	rxe->mmap_offset += size;
+
+	spin_unlock_bh(&rxe->mmap_offset_lock);
+
+	INIT_LIST_HEAD(&ip->pending_mmaps);
+	ip->info.size = size;
+	ip->context = context;
+	ip->obj = obj;
+	kref_init(&ip->ref);
+
+	return ip;
+}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
