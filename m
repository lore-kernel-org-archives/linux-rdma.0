From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 24/52] IB/qib: Add qib_mmap.c
Date: Thu, 06 May 2010 17:00:57 -0700
Message-ID: <20100507000057.3441.36574.stgit@chromite.mv.qlogic.com>
References: <20100506235849.3441.85930.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506235849.3441.85930.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

creates the qib_mmap.c file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_mmap.c |  173 ++++++++++++++++++++++++++++++++++
 1 files changed, 173 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/qib_mmap.c

diff --git a/drivers/infiniband/hw/qib/qib_mmap.c b/drivers/infiniband/hw/qib/qib_mmap.c
new file mode 100644
index 0000000..ae15d38
--- /dev/null
+++ b/drivers/infiniband/hw/qib/qib_mmap.c
@@ -0,0 +1,173 @@
+/*
+ * Copyright (c) 2006, 2007, 2008, 2009 QLogic Corporation. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <asm/pgtable.h>
+
+#include "qib_verbs.h"
+
+/**
+ * qib_release_mmap_info - free mmap info structure
+ * @ref: a pointer to the kref within struct qib_mmap_info
+ */
+void qib_release_mmap_info(struct kref *ref)
+{
+	struct qib_mmap_info *ip =
+		container_of(ref, struct qib_mmap_info, ref);
+	struct qib_ibdev *dev = to_idev(ip->context->device);
+
+	spin_lock_irq(&dev->pending_lock);
+	list_del(&ip->pending_mmaps);
+	spin_unlock_irq(&dev->pending_lock);
+
+	vfree(ip->obj);
+	kfree(ip);
+}
+
+/*
+ * open and close keep track of how many times the CQ is mapped,
+ * to avoid releasing it.
+ */
+static void qib_vma_open(struct vm_area_struct *vma)
+{
+	struct qib_mmap_info *ip = vma->vm_private_data;
+
+	kref_get(&ip->ref);
+}
+
+static void qib_vma_close(struct vm_area_struct *vma)
+{
+	struct qib_mmap_info *ip = vma->vm_private_data;
+
+	kref_put(&ip->ref, qib_release_mmap_info);
+}
+
+static struct vm_operations_struct qib_vm_ops = {
+	.open =     qib_vma_open,
+	.close =    qib_vma_close,
+};
+
+/**
+ * qib_mmap - create a new mmap region
+ * @context: the IB user context of the process making the mmap() call
+ * @vma: the VMA to be initialized
+ * Return zero if the mmap is OK. Otherwise, return an errno.
+ */
+int qib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	struct qib_ibdev *dev = to_idev(context->device);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	struct qib_mmap_info *ip, *pp;
+	int ret = -EINVAL;
+
+	/*
+	 * Search the device's list of objects waiting for a mmap call.
+	 * Normally, this list is very short since a call to create a
+	 * CQ, QP, or SRQ is soon followed by a call to mmap().
+	 */
+	spin_lock_irq(&dev->pending_lock);
+	list_for_each_entry_safe(ip, pp, &dev->pending_mmaps,
+				 pending_mmaps) {
+		/* Only the creator is allowed to mmap the object */
+		if (context != ip->context || (__u64) offset != ip->offset)
+			continue;
+		/* Don't allow a mmap larger than the object. */
+		if (size > ip->size)
+			break;
+
+		list_del_init(&ip->pending_mmaps);
+		spin_unlock_irq(&dev->pending_lock);
+
+		ret = remap_vmalloc_range(vma, ip->obj, 0);
+		if (ret)
+			goto done;
+		vma->vm_ops = &qib_vm_ops;
+		vma->vm_private_data = ip;
+		qib_vma_open(vma);
+		goto done;
+	}
+	spin_unlock_irq(&dev->pending_lock);
+done:
+	return ret;
+}
+
+/*
+ * Allocate information for qib_mmap
+ */
+struct qib_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj) {
+	struct qib_mmap_info *ip;
+
+	ip = kmalloc(sizeof *ip, GFP_KERNEL);
+	if (!ip)
+		goto bail;
+
+	size = PAGE_ALIGN(size);
+
+	spin_lock_irq(&dev->mmap_offset_lock);
+	if (dev->mmap_offset == 0)
+		dev->mmap_offset = PAGE_SIZE;
+	ip->offset = dev->mmap_offset;
+	dev->mmap_offset += size;
+	spin_unlock_irq(&dev->mmap_offset_lock);
+
+	INIT_LIST_HEAD(&ip->pending_mmaps);
+	ip->size = size;
+	ip->context = context;
+	ip->obj = obj;
+	kref_init(&ip->ref);
+
+bail:
+	return ip;
+}
+
+void qib_update_mmap_info(struct qib_ibdev *dev, struct qib_mmap_info *ip,
+			  u32 size, void *obj)
+{
+	size = PAGE_ALIGN(size);
+
+	spin_lock_irq(&dev->mmap_offset_lock);
+	if (dev->mmap_offset == 0)
+		dev->mmap_offset = PAGE_SIZE;
+	ip->offset = dev->mmap_offset;
+	dev->mmap_offset += size;
+	spin_unlock_irq(&dev->mmap_offset_lock);
+
+	ip->size = size;
+	ip->obj = obj;
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
