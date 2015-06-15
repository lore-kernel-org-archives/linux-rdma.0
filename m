From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 26/49] IB/hfi1: add user/kernel memory sharing hooks
Date: Mon, 15 Jun 2015 09:28:18 -0400
Message-ID: <20150615132818.29741.95358.stgit@phlsvslse11.ph.intel.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615132434.29741.35258.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
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
 drivers/infiniband/hw/hfi1/mmap.c |  192 +++++++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)
 create mode 100644 drivers/infiniband/hw/hfi1/mmap.c

diff --git a/drivers/infiniband/hw/hfi1/mmap.c b/drivers/infiniband/hw/hfi1/mmap.c
new file mode 100644
index 0000000..5173b1c
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/mmap.c
@@ -0,0 +1,192 @@
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
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <asm/pgtable.h>
+
+#include "verbs.h"
+
+/**
+ * hfi1_release_mmap_info - free mmap info structure
+ * @ref: a pointer to the kref within struct hfi1_mmap_info
+ */
+void hfi1_release_mmap_info(struct kref *ref)
+{
+	struct hfi1_mmap_info *ip =
+		container_of(ref, struct hfi1_mmap_info, ref);
+	struct hfi1_ibdev *dev = to_idev(ip->context->device);
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
+static void hfi1_vma_open(struct vm_area_struct *vma)
+{
+	struct hfi1_mmap_info *ip = vma->vm_private_data;
+
+	kref_get(&ip->ref);
+}
+
+static void hfi1_vma_close(struct vm_area_struct *vma)
+{
+	struct hfi1_mmap_info *ip = vma->vm_private_data;
+
+	kref_put(&ip->ref, hfi1_release_mmap_info);
+}
+
+static struct vm_operations_struct hfi1_vm_ops = {
+	.open =     hfi1_vma_open,
+	.close =    hfi1_vma_close,
+};
+
+/**
+ * hfi1_mmap - create a new mmap region
+ * @context: the IB user context of the process making the mmap() call
+ * @vma: the VMA to be initialized
+ * Return zero if the mmap is OK. Otherwise, return an errno.
+ */
+int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
+{
+	struct hfi1_ibdev *dev = to_idev(context->device);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	struct hfi1_mmap_info *ip, *pp;
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
+		vma->vm_ops = &hfi1_vm_ops;
+		vma->vm_private_data = ip;
+		hfi1_vma_open(vma);
+		goto done;
+	}
+	spin_unlock_irq(&dev->pending_lock);
+done:
+	return ret;
+}
+
+/*
+ * Allocate information for hfi1_mmap
+ */
+struct hfi1_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev,
+					     u32 size,
+					     struct ib_ucontext *context,
+					     void *obj) {
+	struct hfi1_mmap_info *ip;
+
+	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
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
+void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct hfi1_mmap_info *ip,
+			   u32 size, void *obj)
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
