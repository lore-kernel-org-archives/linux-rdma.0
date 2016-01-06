From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/9] IB/qib: Remove mmap from qib
Date: Wed, 06 Jan 2016 10:23:15 -0800
Message-ID: <20160106182315.5401.10254.stgit@scvm10.sc.intel.com>
References: <20160106181837.5401.67435.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106181837.5401.67435.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Since mmap functionality has been moved into rdmavt, its time for qib to
use that.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile    |    2 
 drivers/infiniband/hw/qib/qib_cq.c    |   18 ++-
 drivers/infiniband/hw/qib/qib_mmap.c  |  174 ---------------------------------
 drivers/infiniband/hw/qib/qib_qp.c    |   24 ++---
 drivers/infiniband/hw/qib/qib_sdma.c  |    4 -
 drivers/infiniband/hw/qib/qib_srq.c   |   18 ++-
 drivers/infiniband/hw/qib/qib_verbs.c |   44 ++++----
 drivers/infiniband/hw/qib/qib_verbs.h |   15 ---
 8 files changed, 53 insertions(+), 246 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_mmap.c

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index 75140f5..45db4fc 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_INFINIBAND_QIB) += ib_qib.o
 
 ib_qib-y := qib_cq.o qib_diag.o qib_driver.o qib_eeprom.o \
 	qib_file_ops.o qib_fs.o qib_init.o qib_intr.o \
-	qib_mad.o qib_mmap.o qib_pcie.o qib_pio_copy.o \
+	qib_mad.o qib_pcie.o qib_pio_copy.o \
 	qib_qp.o qib_qsfp.o qib_rc.o qib_ruc.o qib_sdma.o qib_srq.o \
 	qib_sysfs.o qib_twsi.o qib_tx.o qib_uc.o qib_ud.o \
 	qib_user_pages.o qib_user_sdma.o qib_verbs_mcast.o qib_iba7220.o \
diff --git a/drivers/infiniband/hw/qib/qib_cq.c b/drivers/infiniband/hw/qib/qib_cq.c
index c1ea21e..094f694 100644
--- a/drivers/infiniband/hw/qib/qib_cq.c
+++ b/drivers/infiniband/hw/qib/qib_cq.c
@@ -264,7 +264,7 @@ struct ib_cq *qib_create_cq(struct ib_device *ibdev,
 	if (udata && udata->outlen >= sizeof(__u64)) {
 		int err;
 
-		cq->ip = qib_create_mmap_info(dev, sz, context, wc);
+		cq->ip = rvt_create_mmap_info(&dev->rdi, sz, context, wc);
 		if (!cq->ip) {
 			ret = ERR_PTR(-ENOMEM);
 			goto bail_wc;
@@ -290,9 +290,9 @@ struct ib_cq *qib_create_cq(struct ib_device *ibdev,
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
@@ -342,7 +342,7 @@ int qib_destroy_cq(struct ib_cq *ibcq)
 	dev->n_cqs_allocated--;
 	spin_unlock(&dev->n_cqs_lock);
 	if (cq->ip)
-		kref_put(&cq->ip->ref, qib_release_mmap_info);
+		kref_put(&cq->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(cq->queue);
 	kfree(cq);
@@ -468,7 +468,7 @@ int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 		struct qib_ibdev *dev = to_idev(ibcq->device);
 		struct rvt_mmap_info *ip = cq->ip;
 
-		qib_update_mmap_info(dev, ip, sz, wc);
+		rvt_update_mmap_info(&dev->rdi, ip, sz, wc);
 
 		/*
 		 * Return the offset to mmap.
@@ -481,10 +481,10 @@ int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
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
diff --git a/drivers/infiniband/hw/qib/qib_mmap.c b/drivers/infiniband/hw/qib/qib_mmap.c
deleted file mode 100644
index c32078c..0000000
--- a/drivers/infiniband/hw/qib/qib_mmap.c
+++ /dev/null
@@ -1,174 +0,0 @@
-/*
- * Copyright (c) 2006, 2007, 2008, 2009 QLogic Corporation. All rights reserved.
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-#include <linux/errno.h>
-#include <asm/pgtable.h>
-
-#include "qib_verbs.h"
-
-/**
- * qib_release_mmap_info - free mmap info structure
- * @ref: a pointer to the kref within struct rvt_mmap_info
- */
-void qib_release_mmap_info(struct kref *ref)
-{
-	struct rvt_mmap_info *ip =
-		container_of(ref, struct rvt_mmap_info, ref);
-	struct qib_ibdev *dev = to_idev(ip->context->device);
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
-static void qib_vma_open(struct vm_area_struct *vma)
-{
-	struct rvt_mmap_info *ip = vma->vm_private_data;
-
-	kref_get(&ip->ref);
-}
-
-static void qib_vma_close(struct vm_area_struct *vma)
-{
-	struct rvt_mmap_info *ip = vma->vm_private_data;
-
-	kref_put(&ip->ref, qib_release_mmap_info);
-}
-
-static const struct vm_operations_struct qib_vm_ops = {
-	.open =     qib_vma_open,
-	.close =    qib_vma_close,
-};
-
-/**
- * qib_mmap - create a new mmap region
- * @context: the IB user context of the process making the mmap() call
- * @vma: the VMA to be initialized
- * Return zero if the mmap is OK. Otherwise, return an errno.
- */
-int qib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
-{
-	struct qib_ibdev *dev = to_idev(context->device);
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
-		vma->vm_ops = &qib_vm_ops;
-		vma->vm_private_data = ip;
-		qib_vma_open(vma);
-		goto done;
-	}
-	spin_unlock_irq(&dev->pending_lock);
-done:
-	return ret;
-}
-
-/*
- * Allocate information for qib_mmap
- */
-struct rvt_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev,
-					   u32 size,
-					   struct ib_ucontext *context,
-					   void *obj) {
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
-void qib_update_mmap_info(struct qib_ibdev *dev, struct rvt_mmap_info *ip,
-			  u32 size, void *obj)
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
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index b320246..89da1e1 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -492,12 +492,12 @@ int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	if (qp->s_flags & QIB_S_ANY_WAIT_SEND)
 		qp->s_flags &= ~QIB_S_ANY_WAIT_SEND;
 
-	spin_lock(&dev->pending_lock);
+	spin_lock(&dev->rdi.pending_lock);
 	if (!list_empty(&priv->iowait) && !(qp->s_flags & QIB_S_BUSY)) {
 		qp->s_flags &= ~QIB_S_ANY_WAIT_IO;
 		list_del_init(&priv->iowait);
 	}
-	spin_unlock(&dev->pending_lock);
+	spin_unlock(&dev->rdi.pending_lock);
 
 	if (!(qp->s_flags & QIB_S_BUSY)) {
 		qp->s_hdrwords = 0;
@@ -700,10 +700,10 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	case IB_QPS_RESET:
 		if (qp->state != IB_QPS_RESET) {
 			qp->state = IB_QPS_RESET;
-			spin_lock(&dev->pending_lock);
+			spin_lock(&dev->rdi.pending_lock);
 			if (!list_empty(&priv->iowait))
 				list_del_init(&priv->iowait);
-			spin_unlock(&dev->pending_lock);
+			spin_unlock(&dev->rdi.pending_lock);
 			qp->s_flags &= ~(QIB_S_TIMER | QIB_S_ANY_WAIT);
 			spin_unlock(&qp->s_lock);
 			spin_unlock_irq(&qp->r_lock);
@@ -1140,7 +1140,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 		} else {
 			u32 s = sizeof(struct rvt_rwq) + qp->r_rq.size * sz;
 
-			qp->ip = qib_create_mmap_info(dev, s,
+			qp->ip = rvt_create_mmap_info(&dev->rdi, s,
 						      ibpd->uobject->context,
 						      qp->r_rq.wq);
 			if (!qp->ip) {
@@ -1168,9 +1168,9 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
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
@@ -1178,7 +1178,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 
 bail_ip:
 	if (qp->ip)
-		kref_put(&qp->ip->ref, qib_release_mmap_info);
+		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(qp->r_rq.wq);
 	free_qpn(&dev->qpn_table, qp->ibqp.qp_num);
@@ -1212,10 +1212,10 @@ int qib_destroy_qp(struct ib_qp *ibqp)
 	spin_lock_irq(&qp->s_lock);
 	if (qp->state != IB_QPS_RESET) {
 		qp->state = IB_QPS_RESET;
-		spin_lock(&dev->pending_lock);
+		spin_lock(&dev->rdi.pending_lock);
 		if (!list_empty(&priv->iowait))
 			list_del_init(&priv->iowait);
-		spin_unlock(&dev->pending_lock);
+		spin_unlock(&dev->rdi.pending_lock);
 		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_ANY_WAIT);
 		spin_unlock_irq(&qp->s_lock);
 		cancel_work_sync(&priv->s_work);
@@ -1238,7 +1238,7 @@ int qib_destroy_qp(struct ib_qp *ibqp)
 	spin_unlock(&dev->n_qps_lock);
 
 	if (qp->ip)
-		kref_put(&qp->ip->ref, qib_release_mmap_info);
+		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(qp->r_rq.wq);
 	vfree(qp->s_wq);
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index 9d1104e..bb34bb9 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -697,7 +697,7 @@ busy:
 		tx->dwords = dwords;
 		priv->s_tx = tx;
 		dev = &ppd->dd->verbs_dev;
-		spin_lock(&dev->pending_lock);
+		spin_lock(&dev->rdi.pending_lock);
 		if (list_empty(&priv->iowait)) {
 			struct qib_ibport *ibp;
 
@@ -706,7 +706,7 @@ busy:
 			qp->s_flags |= QIB_S_WAIT_DMA_DESC;
 			list_add_tail(&priv->iowait, &dev->dmawait);
 		}
-		spin_unlock(&dev->pending_lock);
+		spin_unlock(&dev->rdi.pending_lock);
 		qp->s_flags &= ~QIB_S_BUSY;
 		spin_unlock(&qp->s_lock);
 		ret = -EBUSY;
diff --git a/drivers/infiniband/hw/qib/qib_srq.c b/drivers/infiniband/hw/qib/qib_srq.c
index e9dfa30..dff8808 100644
--- a/drivers/infiniband/hw/qib/qib_srq.c
+++ b/drivers/infiniband/hw/qib/qib_srq.c
@@ -148,7 +148,7 @@ struct ib_srq *qib_create_srq(struct ib_pd *ibpd,
 		u32 s = sizeof(struct rvt_rwq) + srq->rq.size * sz;
 
 		srq->ip =
-		    qib_create_mmap_info(dev, s, ibpd->uobject->context,
+		    rvt_create_mmap_info(&dev->rdi, s, ibpd->uobject->context,
 					 srq->rq.wq);
 		if (!srq->ip) {
 			ret = ERR_PTR(-ENOMEM);
@@ -183,9 +183,9 @@ struct ib_srq *qib_create_srq(struct ib_pd *ibpd,
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
@@ -307,7 +307,7 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			struct qib_ibdev *dev = to_idev(srq->ibsrq.device);
 			u32 s = sizeof(struct rvt_rwq) + size * sz;
 
-			qib_update_mmap_info(dev, ip, s, wq);
+			rvt_update_mmap_info(&dev->rdi, ip, s, wq);
 
 			/*
 			 * Return the offset to mmap.
@@ -324,11 +324,11 @@ int qib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
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
@@ -371,7 +371,7 @@ int qib_destroy_srq(struct ib_srq *ibsrq)
 	dev->n_srqs_allocated--;
 	spin_unlock(&dev->n_srqs_lock);
 	if (srq->ip)
-		kref_put(&srq->ip->ref, qib_release_mmap_info);
+		kref_put(&srq->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(srq->rq.wq);
 	kfree(srq);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9583bc1..368b794 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -726,7 +726,7 @@ static void mem_timer(unsigned long data)
 	struct qib_qp_priv *priv = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->pending_lock, flags);
+	spin_lock_irqsave(&dev->rdi.pending_lock, flags);
 	if (!list_empty(list)) {
 		priv = list_entry(list->next, struct qib_qp_priv, iowait);
 		qp = priv->owner;
@@ -735,7 +735,7 @@ static void mem_timer(unsigned long data)
 		if (!list_empty(list))
 			mod_timer(&dev->mem_timer, jiffies + 1);
 	}
-	spin_unlock_irqrestore(&dev->pending_lock, flags);
+	spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 
 	if (qp) {
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -950,13 +950,13 @@ static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	spin_lock(&dev->pending_lock);
+	spin_lock(&dev->rdi.pending_lock);
 
 	if (!list_empty(&dev->txreq_free)) {
 		struct list_head *l = dev->txreq_free.next;
 
 		list_del(l);
-		spin_unlock(&dev->pending_lock);
+		spin_unlock(&dev->rdi.pending_lock);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		tx = list_entry(l, struct qib_verbs_txreq, txreq.list);
 	} else {
@@ -967,7 +967,7 @@ static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 			list_add_tail(&priv->iowait, &dev->txwait);
 		}
 		qp->s_flags &= ~QIB_S_BUSY;
-		spin_unlock(&dev->pending_lock);
+		spin_unlock(&dev->rdi.pending_lock);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		tx = ERR_PTR(-EBUSY);
 	}
@@ -980,17 +980,17 @@ static inline struct qib_verbs_txreq *get_txreq(struct qib_ibdev *dev,
 	struct qib_verbs_txreq *tx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->pending_lock, flags);
+	spin_lock_irqsave(&dev->rdi.pending_lock, flags);
 	/* assume the list non empty */
 	if (likely(!list_empty(&dev->txreq_free))) {
 		struct list_head *l = dev->txreq_free.next;
 
 		list_del(l);
-		spin_unlock_irqrestore(&dev->pending_lock, flags);
+		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 		tx = list_entry(l, struct qib_verbs_txreq, txreq.list);
 	} else {
 		/* call slow path to get the extra lock */
-		spin_unlock_irqrestore(&dev->pending_lock, flags);
+		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 		tx =  __get_txreq(dev, qp);
 	}
 	return tx;
@@ -1020,7 +1020,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 		kfree(tx->align_buf);
 	}
 
-	spin_lock_irqsave(&dev->pending_lock, flags);
+	spin_lock_irqsave(&dev->rdi.pending_lock, flags);
 
 	/* Put struct back on free list */
 	list_add(&tx->txreq.list, &dev->txreq_free);
@@ -1032,7 +1032,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 		qp = priv->owner;
 		list_del_init(&priv->iowait);
 		atomic_inc(&qp->refcount);
-		spin_unlock_irqrestore(&dev->pending_lock, flags);
+		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 
 		spin_lock_irqsave(&qp->s_lock, flags);
 		if (qp->s_flags & QIB_S_WAIT_TX) {
@@ -1044,7 +1044,7 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 		if (atomic_dec_and_test(&qp->refcount))
 			wake_up(&qp->wait);
 	} else
-		spin_unlock_irqrestore(&dev->pending_lock, flags);
+		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 }
 
 /*
@@ -1063,7 +1063,7 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 
 	n = 0;
 	dev = &ppd->dd->verbs_dev;
-	spin_lock(&dev->pending_lock);
+	spin_lock(&dev->rdi.pending_lock);
 
 	/* Search wait list for first QP wanting DMA descriptors. */
 	list_for_each_entry_safe(qpp, nqpp, &dev->dmawait, iowait) {
@@ -1081,7 +1081,7 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 		qps[n++] = qp;
 	}
 
-	spin_unlock(&dev->pending_lock);
+	spin_unlock(&dev->rdi.pending_lock);
 
 	for (i = 0; i < n; i++) {
 		qp = qps[i];
@@ -1142,14 +1142,14 @@ static int wait_kmem(struct qib_ibdev *dev, struct rvt_qp *qp)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
-		spin_lock(&dev->pending_lock);
+		spin_lock(&dev->rdi.pending_lock);
 		if (list_empty(&priv->iowait)) {
 			if (list_empty(&dev->memwait))
 				mod_timer(&dev->mem_timer, jiffies + 1);
 			qp->s_flags |= QIB_S_WAIT_KMEM;
 			list_add_tail(&priv->iowait, &dev->memwait);
 		}
-		spin_unlock(&dev->pending_lock);
+		spin_unlock(&dev->rdi.pending_lock);
 		qp->s_flags &= ~QIB_S_BUSY;
 		ret = -EBUSY;
 	}
@@ -1279,7 +1279,7 @@ static int no_bufs_available(struct rvt_qp *qp)
 	 */
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
-		spin_lock(&dev->pending_lock);
+		spin_lock(&dev->rdi.pending_lock);
 		if (list_empty(&priv->iowait)) {
 			dev->n_piowait++;
 			qp->s_flags |= QIB_S_WAIT_PIO;
@@ -1287,7 +1287,7 @@ static int no_bufs_available(struct rvt_qp *qp)
 			dd = dd_from_dev(dev);
 			dd->f_wantpiobuf_intr(dd, 1);
 		}
-		spin_unlock(&dev->pending_lock);
+		spin_unlock(&dev->rdi.pending_lock);
 		qp->s_flags &= ~QIB_S_BUSY;
 		ret = -EBUSY;
 	}
@@ -1551,7 +1551,7 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 	 * could end up with QPs on the wait list with the interrupt
 	 * disabled.
 	 */
-	spin_lock_irqsave(&dev->pending_lock, flags);
+	spin_lock_irqsave(&dev->rdi.pending_lock, flags);
 	while (!list_empty(list)) {
 		if (n == ARRAY_SIZE(qps))
 			goto full;
@@ -1563,7 +1563,7 @@ void qib_ib_piobufavail(struct qib_devdata *dd)
 	}
 	dd->f_wantpiobuf_intr(dd, 0);
 full:
-	spin_unlock_irqrestore(&dev->pending_lock, flags);
+	spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 
 	for (i = 0; i < n; i++) {
 		qp = qps[i];
@@ -1987,10 +1987,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	qib_init_qpn_table(dd, &dev->qpn_table);
 
-	INIT_LIST_HEAD(&dev->pending_mmaps);
-	spin_lock_init(&dev->pending_lock);
-	dev->mmap_offset = PAGE_SIZE;
-	spin_lock_init(&dev->mmap_offset_lock);
 	INIT_LIST_HEAD(&dev->piowait);
 	INIT_LIST_HEAD(&dev->dmawait);
 	INIT_LIST_HEAD(&dev->txwait);
@@ -2110,7 +2106,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->attach_mcast = qib_multicast_attach;
 	ibdev->detach_mcast = qib_multicast_detach;
 	ibdev->process_mad = qib_process_mad;
-	ibdev->mmap = qib_mmap;
+	ibdev->mmap = NULL;
 	ibdev->dma_ops = NULL;
 	ibdev->get_port_immutable = qib_port_immutable;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 538d3a6..eade668 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -428,9 +428,6 @@ struct qib_ibport {
 
 struct qib_ibdev {
 	struct rvt_dev_info rdi;
-	struct list_head pending_mmaps;
-	spinlock_t mmap_offset_lock; /* protect mmap_offset */
-	u32 mmap_offset;
 
 	/* QP numbers are shared by all IB ports */
 	struct qib_qpn_table qpn_table;
@@ -444,7 +441,6 @@ struct qib_ibdev {
 	struct qib_pio_header *pio_hdrs;
 	dma_addr_t pio_hdrs_phys;
 	/* list of QPs waiting for RNR timer */
-	spinlock_t pending_lock; /* protect wait lists, PMA counters, etc. */
 	u32 qp_table_size; /* size of the hash table */
 	u32 qp_rnd; /* random bytes for hash */
 	spinlock_t qpt_lock;
@@ -683,17 +679,6 @@ static inline void qib_put_ss(struct rvt_sge_state *ss)
 	}
 }
 
-void qib_release_mmap_info(struct kref *ref);
-
-struct rvt_mmap_info *qib_create_mmap_info(struct qib_ibdev *dev, u32 size,
-					   struct ib_ucontext *context,
-					   void *obj);
-
-void qib_update_mmap_info(struct qib_ibdev *dev, struct rvt_mmap_info *ip,
-			  u32 size, void *obj);
-
-int qib_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
-
 int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only);
 
 void qib_migrate_qp(struct rvt_qp *qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
