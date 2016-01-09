From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 14/27] IB/hfi1: Remove mmap from hfi1
Date: Sat, 09 Jan 2016 07:17:56 -0800
Message-ID: <20160109151755.30800.73904.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mmap data structure has already been moved to rdmavt and hfi1 supports
it. Now that the mmap functionality has also been moved to rdmavt its
time for hfi1 to use that as well.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Makefile |    2 
 drivers/staging/rdma/hfi1/cq.c     |   18 ++-
 drivers/staging/rdma/hfi1/mmap.c   |  192 ------------------------------------
 drivers/staging/rdma/hfi1/qp.c     |   12 +-
 drivers/staging/rdma/hfi1/srq.c    |   20 ++--
 drivers/staging/rdma/hfi1/verbs.c  |    6 -
 drivers/staging/rdma/hfi1/verbs.h  |   17 ---
 7 files changed, 27 insertions(+), 240 deletions(-)
 delete mode 100644 drivers/staging/rdma/hfi1/mmap.c

diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index 3ba64fe..ff663b3 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -8,7 +8,7 @@
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
 hfi1-y := chip.o cq.o device.o diag.o driver.o eprom.o file_ops.o firmware.o \
-	init.o intr.o mad.o mmap.o pcie.o pio.o pio_copy.o \
+	init.o intr.o mad.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
 hfi1-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/staging/rdma/hfi1/cq.c b/drivers/staging/rdma/hfi1/cq.c
index ffd0e7a..25d1a2a 100644
--- a/drivers/staging/rdma/hfi1/cq.c
+++ b/drivers/staging/rdma/hfi1/cq.c
@@ -277,7 +277,7 @@ struct ib_cq *hfi1_create_cq(
 	if (udata && udata->outlen >= sizeof(__u64)) {
 		int err;
 
-		cq->ip = hfi1_create_mmap_info(dev, sz, context, wc);
+		cq->ip = rvt_create_mmap_info(&dev->rdi, sz, context, wc);
 		if (!cq->ip) {
 			ret = ERR_PTR(-ENOMEM);
 			goto bail_wc;
@@ -303,9 +303,9 @@ struct ib_cq *hfi1_create_cq(
 	spin_unlock(&dev->n_cqs_lock);
 
 	if (cq->ip) {
-		spin_lock_irq(&dev->pending_lock);
-		list_add(&cq->ip->pending_mmaps, &dev->pending_mmaps);
-		spin_unlock_irq(&dev->pending_lock);
+		spin_lock_irq(&dev->rdi.pending_lock);
+		list_add(&cq->ip->pending_mmaps, &dev->rdi.pending_mmaps);
+		spin_unlock_irq(&dev->rdi.pending_lock);
 	}
 
 	/*
@@ -355,7 +355,7 @@ int hfi1_destroy_cq(struct ib_cq *ibcq)
 	dev->n_cqs_allocated--;
 	spin_unlock(&dev->n_cqs_lock);
 	if (cq->ip)
-		kref_put(&cq->ip->ref, hfi1_release_mmap_info);
+		kref_put(&cq->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(cq->queue);
 	kfree(cq);
@@ -481,7 +481,7 @@ int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 		struct hfi1_ibdev *dev = to_idev(ibcq->device);
 		struct rvt_mmap_info *ip = cq->ip;
 
-		hfi1_update_mmap_info(dev, ip, sz, wc);
+		rvt_update_mmap_info(&dev->rdi, ip, sz, wc);
 
 		/*
 		 * Return the offset to mmap.
@@ -494,10 +494,10 @@ int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 				goto bail;
 		}
 
-		spin_lock_irq(&dev->pending_lock);
+		spin_lock_irq(&dev->rdi.pending_lock);
 		if (list_empty(&ip->pending_mmaps))
-			list_add(&ip->pending_mmaps, &dev->pending_mmaps);
-		spin_unlock_irq(&dev->pending_lock);
+			list_add(&ip->pending_mmaps, &dev->rdi.pending_mmaps);
+		spin_unlock_irq(&dev->rdi.pending_lock);
 	}
 
 	ret = 0;
diff --git a/drivers/staging/rdma/hfi1/mmap.c b/drivers/staging/rdma/hfi1/mmap.c
deleted file mode 100644
index 4ce6be6..0000000
--- a/drivers/staging/rdma/hfi1/mmap.c
+++ /dev/null
@@ -1,192 +0,0 @@
-/*
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  - Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  - Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  - Neither the name of Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-#include <linux/errno.h>
-#include <asm/pgtable.h>
-
-#include "verbs.h"
-
-/**
- * hfi1_release_mmap_info - free mmap info structure
- * @ref: a pointer to the kref within struct rvt_mmap_info
- */
-void hfi1_release_mmap_info(struct kref *ref)
-{
-	struct rvt_mmap_info *ip =
-		container_of(ref, struct rvt_mmap_info, ref);
-	struct hfi1_ibdev *dev = to_idev(ip->context->device);
-
-	spin_lock_irq(&dev->pending_lock);
-	list_del(&ip->pending_mmaps);
-	spin_unlock_irq(&dev->pending_lock);
-
-	vfree(ip->obj);
-	kfree(ip);
-}
-
-/*
- * open and close keep track of how many times the CQ is mapped,
- * to avoid releasing it.
- */
-static void hfi1_vma_open(struct vm_area_struct *vma)
-{
-	struct rvt_mmap_info *ip = vma->vm_private_data;
-
-	kref_get(&ip->ref);
-}
-
-static void hfi1_vma_close(struct vm_area_struct *vma)
-{
-	struct rvt_mmap_info *ip = vma->vm_private_data;
-
-	kref_put(&ip->ref, hfi1_release_mmap_info);
-}
-
-static struct vm_operations_struct hfi1_vm_ops = {
-	.open =     hfi1_vma_open,
-	.close =    hfi1_vma_close,
-};
-
-/**
- * hfi1_mmap - create a new mmap region
- * @context: the IB user context of the process making the mmap() call
- * @vma: the VMA to be initialized
- * Return zero if the mmap is OK. Otherwise, return an errno.
- */
-int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
-{
-	struct hfi1_ibdev *dev = to_idev(context->device);
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned long size = vma->vm_end - vma->vm_start;
-	struct rvt_mmap_info *ip, *pp;
-	int ret = -EINVAL;
-
-	/*
-	 * Search the device's list of objects waiting for a mmap call.
-	 * Normally, this list is very short since a call to create a
-	 * CQ, QP, or SRQ is soon followed by a call to mmap().
-	 */
-	spin_lock_irq(&dev->pending_lock);
-	list_for_each_entry_safe(ip, pp, &dev->pending_mmaps,
-				 pending_mmaps) {
-		/* Only the creator is allowed to mmap the object */
-		if (context != ip->context || (__u64) offset != ip->offset)
-			continue;
-		/* Don't allow a mmap larger than the object. */
-		if (size > ip->size)
-			break;
-
-		list_del_init(&ip->pending_mmaps);
-		spin_unlock_irq(&dev->pending_lock);
-
-		ret = remap_vmalloc_range(vma, ip->obj, 0);
-		if (ret)
-			goto done;
-		vma->vm_ops = &hfi1_vm_ops;
-		vma->vm_private_data = ip;
-		hfi1_vma_open(vma);
-		goto done;
-	}
-	spin_unlock_irq(&dev->pending_lock);
-done:
-	return ret;
-}
-
-/*
- * Allocate information for hfi1_mmap
- */
-struct rvt_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev,
-					    u32 size,
-					    struct ib_ucontext *context,
-					    void *obj) {
-	struct rvt_mmap_info *ip;
-
-	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
-	if (!ip)
-		goto bail;
-
-	size = PAGE_ALIGN(size);
-
-	spin_lock_irq(&dev->mmap_offset_lock);
-	if (dev->mmap_offset == 0)
-		dev->mmap_offset = PAGE_SIZE;
-	ip->offset = dev->mmap_offset;
-	dev->mmap_offset += size;
-	spin_unlock_irq(&dev->mmap_offset_lock);
-
-	INIT_LIST_HEAD(&ip->pending_mmaps);
-	ip->size = size;
-	ip->context = context;
-	ip->obj = obj;
-	kref_init(&ip->ref);
-
-bail:
-	return ip;
-}
-
-void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct rvt_mmap_info *ip,
-			   u32 size, void *obj)
-{
-	size = PAGE_ALIGN(size);
-
-	spin_lock_irq(&dev->mmap_offset_lock);
-	if (dev->mmap_offset == 0)
-		dev->mmap_offset = PAGE_SIZE;
-	ip->offset = dev->mmap_offset;
-	dev->mmap_offset += size;
-	spin_unlock_irq(&dev->mmap_offset_lock);
-
-	ip->size = size;
-	ip->obj = obj;
-}
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 5f7e203..1de81e0 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -1178,7 +1178,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 		} else {
 			u32 s = sizeof(struct rvt_rwq) + qp->r_rq.size * sz;
 
-			qp->ip = hfi1_create_mmap_info(dev, s,
+			qp->ip = rvt_create_mmap_info(&dev->rdi, s,
 						      ibpd->uobject->context,
 						      qp->r_rq.wq);
 			if (!qp->ip) {
@@ -1206,9 +1206,9 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 	spin_unlock(&dev->n_qps_lock);
 
 	if (qp->ip) {
-		spin_lock_irq(&dev->pending_lock);
-		list_add(&qp->ip->pending_mmaps, &dev->pending_mmaps);
-		spin_unlock_irq(&dev->pending_lock);
+		spin_lock_irq(&dev->rdi.pending_lock);
+		list_add(&qp->ip->pending_mmaps, &dev->rdi.pending_mmaps);
+		spin_unlock_irq(&dev->rdi.pending_lock);
 	}
 
 	ret = &qp->ibqp;
@@ -1239,7 +1239,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 
 bail_ip:
 	if (qp->ip)
-		kref_put(&qp->ip->ref, hfi1_release_mmap_info);
+		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(qp->r_rq.wq);
 	free_qpn(&dev->qp_dev->qpn_table, qp->ibqp.qp_num);
@@ -1299,7 +1299,7 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 	spin_unlock(&dev->n_qps_lock);
 
 	if (qp->ip)
-		kref_put(&qp->ip->ref, hfi1_release_mmap_info);
+		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(qp->r_rq.wq);
 	vfree(qp->s_wq);
diff --git a/drivers/staging/rdma/hfi1/srq.c b/drivers/staging/rdma/hfi1/srq.c
index 78f190a..c53b378 100644
--- a/drivers/staging/rdma/hfi1/srq.c
+++ b/drivers/staging/rdma/hfi1/srq.c
@@ -165,8 +165,8 @@ struct ib_srq *hfi1_create_srq(struct ib_pd *ibpd,
 		u32 s = sizeof(struct rvt_rwq) + srq->rq.size * sz;
 
 		srq->ip =
-		    hfi1_create_mmap_info(dev, s, ibpd->uobject->context,
-					  srq->rq.wq);
+		    rvt_create_mmap_info(&dev->rdi, s, ibpd->uobject->context,
+					 srq->rq.wq);
 		if (!srq->ip) {
 			ret = ERR_PTR(-ENOMEM);
 			goto bail_wq;
@@ -200,9 +200,9 @@ struct ib_srq *hfi1_create_srq(struct ib_pd *ibpd,
 	spin_unlock(&dev->n_srqs_lock);
 
 	if (srq->ip) {
-		spin_lock_irq(&dev->pending_lock);
-		list_add(&srq->ip->pending_mmaps, &dev->pending_mmaps);
-		spin_unlock_irq(&dev->pending_lock);
+		spin_lock_irq(&dev->rdi.pending_lock);
+		list_add(&srq->ip->pending_mmaps, &dev->rdi.pending_mmaps);
+		spin_unlock_irq(&dev->rdi.pending_lock);
 	}
 
 	ret = &srq->ibsrq;
@@ -324,7 +324,7 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			struct hfi1_ibdev *dev = to_idev(srq->ibsrq.device);
 			u32 s = sizeof(struct rvt_rwq) + size * sz;
 
-			hfi1_update_mmap_info(dev, ip, s, wq);
+			rvt_update_mmap_info(&dev->rdi, ip, s, wq);
 
 			/*
 			 * Return the offset to mmap.
@@ -341,11 +341,11 @@ int hfi1_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			 * Put user mapping info onto the pending list
 			 * unless it already is on the list.
 			 */
-			spin_lock_irq(&dev->pending_lock);
+			spin_lock_irq(&dev->rdi.pending_lock);
 			if (list_empty(&ip->pending_mmaps))
 				list_add(&ip->pending_mmaps,
-					 &dev->pending_mmaps);
-			spin_unlock_irq(&dev->pending_lock);
+					 &dev->rdi.pending_mmaps);
+			spin_unlock_irq(&dev->rdi.pending_lock);
 		}
 	} else if (attr_mask & IB_SRQ_LIMIT) {
 		spin_lock_irq(&srq->rq.lock);
@@ -388,7 +388,7 @@ int hfi1_destroy_srq(struct ib_srq *ibsrq)
 	dev->n_srqs_allocated--;
 	spin_unlock(&dev->n_srqs_lock);
 	if (srq->ip)
-		kref_put(&srq->ip->ref, hfi1_release_mmap_info);
+		kref_put(&srq->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(srq->rq.wq);
 	kfree(srq);
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 361f217..ebf5e2d 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1807,11 +1807,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dev->mem_timer.function = mem_timer;
 	dev->mem_timer.data = (unsigned long) dev;
 
-	INIT_LIST_HEAD(&dev->pending_mmaps);
-	spin_lock_init(&dev->pending_lock);
 	seqlock_init(&dev->iowait_lock);
-	dev->mmap_offset = PAGE_SIZE;
-	spin_lock_init(&dev->mmap_offset_lock);
 	INIT_LIST_HEAD(&dev->txwait);
 	INIT_LIST_HEAD(&dev->memwait);
 
@@ -1917,7 +1913,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->attach_mcast = hfi1_multicast_attach;
 	ibdev->detach_mcast = hfi1_multicast_detach;
 	ibdev->process_mad = hfi1_process_mad;
-	ibdev->mmap = hfi1_mmap;
+	ibdev->mmap = NULL;
 	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = port_immutable;
 
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 0289393..0828f67 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -412,9 +412,6 @@ struct hfi1_ibport {
 struct hfi1_qp_ibdev;
 struct hfi1_ibdev {
 	struct rvt_dev_info rdi; /* Must be first */
-	struct list_head pending_mmaps;
-	spinlock_t mmap_offset_lock; /* protect mmap_offset */
-	u32 mmap_offset;
 
 	struct hfi1_qp_ibdev *qp_dev;
 
@@ -427,9 +424,6 @@ struct hfi1_ibdev {
 	struct kmem_cache *verbs_txreq_cache;
 	struct timer_list mem_timer;
 
-	/* other waiters */
-	spinlock_t pending_lock;
-
 	u64 n_piowait;
 	u64 n_txwait;
 	u64 n_kmem_wait;
@@ -668,17 +662,6 @@ static inline void hfi1_put_ss(struct rvt_sge_state *ss)
 	}
 }
 
-void hfi1_release_mmap_info(struct kref *ref);
-
-struct rvt_mmap_info *hfi1_create_mmap_info(struct hfi1_ibdev *dev, u32 size,
-					    struct ib_ucontext *context,
-					    void *obj);
-
-void hfi1_update_mmap_info(struct hfi1_ibdev *dev, struct rvt_mmap_info *ip,
-			   u32 size, void *obj);
-
-int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
-
 int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only);
 
 void hfi1_migrate_qp(struct rvt_qp *qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
