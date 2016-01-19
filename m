From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] IB/qib: Remove completion queue data structures and
 functions from qib
Date: Tue, 19 Jan 2016 14:33:40 -0800
Message-ID: <20160119223339.30925.34651.stgit@scvm10.sc.intel.com>
References: <20160119223130.30925.93860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223130.30925.93860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the completion queue functionality provided by rdmavt.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile    |    2 
 drivers/infiniband/hw/qib/qib.h       |    2 
 drivers/infiniband/hw/qib/qib_cq.c    |  545 ---------------------------------
 drivers/infiniband/hw/qib/qib_init.c  |    3 
 drivers/infiniband/hw/qib/qib_qp.c    |    4 
 drivers/infiniband/hw/qib/qib_rc.c    |    6 
 drivers/infiniband/hw/qib/qib_ruc.c   |    8 
 drivers/infiniband/hw/qib/qib_uc.c    |    2 
 drivers/infiniband/hw/qib/qib_ud.c    |    4 
 drivers/infiniband/hw/qib/qib_verbs.c |   17 +
 drivers/infiniband/hw/qib/qib_verbs.h |   62 ----
 11 files changed, 24 insertions(+), 631 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_cq.c

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index 45db4fc..d78f688 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_INFINIBAND_QIB) += ib_qib.o
 
-ib_qib-y := qib_cq.o qib_diag.o qib_driver.o qib_eeprom.o \
+ib_qib-y := qib_diag.o qib_driver.o qib_eeprom.o \
 	qib_file_ops.o qib_fs.o qib_init.o qib_intr.o \
 	qib_mad.o qib_pcie.o qib_pio_copy.o \
 	qib_qp.o qib_qsfp.o qib_rc.o qib_ruc.o qib_sdma.o qib_srq.o \
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 29cbe67..ccadece 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1097,8 +1097,6 @@ struct qib_devdata {
 	u16 psxmitwait_check_rate;
 	/* high volume overflow errors defered to tasklet */
 	struct tasklet_struct error_tasklet;
-	/* per device cq worker */
-	struct kthread_worker *worker;
 
 	int assigned_node_id; /* NUMA node closest to HCA */
 };
diff --git a/drivers/infiniband/hw/qib/qib_cq.c b/drivers/infiniband/hw/qib/qib_cq.c
deleted file mode 100644
index 094f694..0000000
--- a/drivers/infiniband/hw/qib/qib_cq.c
+++ /dev/null
@@ -1,545 +0,0 @@
-/*
- * Copyright (c) 2013 Intel Corporation.  All rights reserved.
- * Copyright (c) 2006, 2007, 2008, 2010 QLogic Corporation. All rights reserved.
- * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
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
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/kthread.h>
-
-#include "qib_verbs.h"
-#include "qib.h"
-
-/**
- * qib_cq_enter - add a new entry to the completion queue
- * @cq: completion queue
- * @entry: work completion entry to add
- * @sig: true if @entry is a solicitated entry
- *
- * This may be called with qp->s_lock held.
- */
-void qib_cq_enter(struct qib_cq *cq, struct ib_wc *entry, int solicited)
-{
-	struct qib_cq_wc *wc;
-	unsigned long flags;
-	u32 head;
-	u32 next;
-
-	spin_lock_irqsave(&cq->lock, flags);
-
-	/*
-	 * Note that the head pointer might be writable by user processes.
-	 * Take care to verify it is a sane value.
-	 */
-	wc = cq->queue;
-	head = wc->head;
-	if (head >= (unsigned) cq->ibcq.cqe) {
-		head = cq->ibcq.cqe;
-		next = 0;
-	} else
-		next = head + 1;
-	if (unlikely(next == wc->tail)) {
-		spin_unlock_irqrestore(&cq->lock, flags);
-		if (cq->ibcq.event_handler) {
-			struct ib_event ev;
-
-			ev.device = cq->ibcq.device;
-			ev.element.cq = &cq->ibcq;
-			ev.event = IB_EVENT_CQ_ERR;
-			cq->ibcq.event_handler(&ev, cq->ibcq.cq_context);
-		}
-		return;
-	}
-	if (cq->ip) {
-		wc->uqueue[head].wr_id = entry->wr_id;
-		wc->uqueue[head].status = entry->status;
-		wc->uqueue[head].opcode = entry->opcode;
-		wc->uqueue[head].vendor_err = entry->vendor_err;
-		wc->uqueue[head].byte_len = entry->byte_len;
-		wc->uqueue[head].ex.imm_data =
-			(__u32 __force)entry->ex.imm_data;
-		wc->uqueue[head].qp_num = entry->qp->qp_num;
-		wc->uqueue[head].src_qp = entry->src_qp;
-		wc->uqueue[head].wc_flags = entry->wc_flags;
-		wc->uqueue[head].pkey_index = entry->pkey_index;
-		wc->uqueue[head].slid = entry->slid;
-		wc->uqueue[head].sl = entry->sl;
-		wc->uqueue[head].dlid_path_bits = entry->dlid_path_bits;
-		wc->uqueue[head].port_num = entry->port_num;
-		/* Make sure entry is written before the head index. */
-		smp_wmb();
-	} else
-		wc->kqueue[head] = *entry;
-	wc->head = next;
-
-	if (cq->notify == IB_CQ_NEXT_COMP ||
-	    (cq->notify == IB_CQ_SOLICITED &&
-	     (solicited || entry->status != IB_WC_SUCCESS))) {
-		struct kthread_worker *worker;
-		/*
-		 * This will cause send_complete() to be called in
-		 * another thread.
-		 */
-		smp_rmb();
-		worker = cq->dd->worker;
-		if (likely(worker)) {
-			cq->notify = IB_CQ_NONE;
-			cq->triggered++;
-			queue_kthread_work(worker, &cq->comptask);
-		}
-	}
-
-	spin_unlock_irqrestore(&cq->lock, flags);
-}
-
-/**
- * qib_poll_cq - poll for work completion entries
- * @ibcq: the completion queue to poll
- * @num_entries: the maximum number of entries to return
- * @entry: pointer to array where work completions are placed
- *
- * Returns the number of completion entries polled.
- *
- * This may be called from interrupt context.  Also called by ib_poll_cq()
- * in the generic verbs code.
- */
-int qib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
-{
-	struct qib_cq *cq = to_icq(ibcq);
-	struct qib_cq_wc *wc;
-	unsigned long flags;
-	int npolled;
-	u32 tail;
-
-	/* The kernel can only poll a kernel completion queue */
-	if (cq->ip) {
-		npolled = -EINVAL;
-		goto bail;
-	}
-
-	spin_lock_irqsave(&cq->lock, flags);
-
-	wc = cq->queue;
-	tail = wc->tail;
-	if (tail > (u32) cq->ibcq.cqe)
-		tail = (u32) cq->ibcq.cqe;
-	for (npolled = 0; npolled < num_entries; ++npolled, ++entry) {
-		if (tail == wc->head)
-			break;
-		/* The kernel doesn't need a RMB since it has the lock. */
-		*entry = wc->kqueue[tail];
-		if (tail >= cq->ibcq.cqe)
-			tail = 0;
-		else
-			tail++;
-	}
-	wc->tail = tail;
-
-	spin_unlock_irqrestore(&cq->lock, flags);
-
-bail:
-	return npolled;
-}
-
-static void send_complete(struct kthread_work *work)
-{
-	struct qib_cq *cq = container_of(work, struct qib_cq, comptask);
-
-	/*
-	 * The completion handler will most likely rearm the notification
-	 * and poll for all pending entries.  If a new completion entry
-	 * is added while we are in this routine, queue_work()
-	 * won't call us again until we return so we check triggered to
-	 * see if we need to call the handler again.
-	 */
-	for (;;) {
-		u8 triggered = cq->triggered;
-
-		/*
-		 * IPoIB connected mode assumes the callback is from a
-		 * soft IRQ. We simulate this by blocking "bottom halves".
-		 * See the implementation for ipoib_cm_handle_tx_wc(),
-		 * netif_tx_lock_bh() and netif_tx_lock().
-		 */
-		local_bh_disable();
-		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
-		local_bh_enable();
-
-		if (cq->triggered == triggered)
-			return;
-	}
-}
-
-/**
- * qib_create_cq - create a completion queue
- * @ibdev: the device this completion queue is attached to
- * @attr: creation attributes
- * @context: unused by the QLogic_IB driver
- * @udata: user data for libibverbs.so
- *
- * Returns a pointer to the completion queue or negative errno values
- * for failure.
- *
- * Called by ib_create_cq() in the generic verbs code.
- */
-struct ib_cq *qib_create_cq(struct ib_device *ibdev,
-			    const struct ib_cq_init_attr *attr,
-			    struct ib_ucontext *context,
-			    struct ib_udata *udata)
-{
-	int entries = attr->cqe;
-	struct qib_ibdev *dev = to_idev(ibdev);
-	struct qib_cq *cq;
-	struct qib_cq_wc *wc;
-	struct ib_cq *ret;
-	u32 sz;
-
-	if (attr->flags)
-		return ERR_PTR(-EINVAL);
-
-	if (entries < 1 || entries > ib_qib_max_cqes) {
-		ret = ERR_PTR(-EINVAL);
-		goto done;
-	}
-
-	/* Allocate the completion queue structure. */
-	cq = kmalloc(sizeof(*cq), GFP_KERNEL);
-	if (!cq) {
-		ret = ERR_PTR(-ENOMEM);
-		goto done;
-	}
-
-	/*
-	 * Allocate the completion queue entries and head/tail pointers.
-	 * This is allocated separately so that it can be resized and
-	 * also mapped into user space.
-	 * We need to use vmalloc() in order to support mmap and large
-	 * numbers of entries.
-	 */
-	sz = sizeof(*wc);
-	if (udata && udata->outlen >= sizeof(__u64))
-		sz += sizeof(struct ib_uverbs_wc) * (entries + 1);
-	else
-		sz += sizeof(struct ib_wc) * (entries + 1);
-	wc = vmalloc_user(sz);
-	if (!wc) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail_cq;
-	}
-
-	/*
-	 * Return the address of the WC as the offset to mmap.
-	 * See qib_mmap() for details.
-	 */
-	if (udata && udata->outlen >= sizeof(__u64)) {
-		int err;
-
-		cq->ip = rvt_create_mmap_info(&dev->rdi, sz, context, wc);
-		if (!cq->ip) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail_wc;
-		}
-
-		err = ib_copy_to_udata(udata, &cq->ip->offset,
-				       sizeof(cq->ip->offset));
-		if (err) {
-			ret = ERR_PTR(err);
-			goto bail_ip;
-		}
-	} else
-		cq->ip = NULL;
-
-	spin_lock(&dev->n_cqs_lock);
-	if (dev->n_cqs_allocated == ib_qib_max_cqs) {
-		spin_unlock(&dev->n_cqs_lock);
-		ret = ERR_PTR(-ENOMEM);
-		goto bail_ip;
-	}
-
-	dev->n_cqs_allocated++;
-	spin_unlock(&dev->n_cqs_lock);
-
-	if (cq->ip) {
-		spin_lock_irq(&dev->rdi.pending_lock);
-		list_add(&cq->ip->pending_mmaps, &dev->rdi.pending_mmaps);
-		spin_unlock_irq(&dev->rdi.pending_lock);
-	}
-
-	/*
-	 * ib_create_cq() will initialize cq->ibcq except for cq->ibcq.cqe.
-	 * The number of entries should be >= the number requested or return
-	 * an error.
-	 */
-	cq->dd = dd_from_dev(dev);
-	cq->ibcq.cqe = entries;
-	cq->notify = IB_CQ_NONE;
-	cq->triggered = 0;
-	spin_lock_init(&cq->lock);
-	init_kthread_work(&cq->comptask, send_complete);
-	wc->head = 0;
-	wc->tail = 0;
-	cq->queue = wc;
-
-	ret = &cq->ibcq;
-
-	goto done;
-
-bail_ip:
-	kfree(cq->ip);
-bail_wc:
-	vfree(wc);
-bail_cq:
-	kfree(cq);
-done:
-	return ret;
-}
-
-/**
- * qib_destroy_cq - destroy a completion queue
- * @ibcq: the completion queue to destroy.
- *
- * Returns 0 for success.
- *
- * Called by ib_destroy_cq() in the generic verbs code.
- */
-int qib_destroy_cq(struct ib_cq *ibcq)
-{
-	struct qib_ibdev *dev = to_idev(ibcq->device);
-	struct qib_cq *cq = to_icq(ibcq);
-
-	flush_kthread_work(&cq->comptask);
-	spin_lock(&dev->n_cqs_lock);
-	dev->n_cqs_allocated--;
-	spin_unlock(&dev->n_cqs_lock);
-	if (cq->ip)
-		kref_put(&cq->ip->ref, rvt_release_mmap_info);
-	else
-		vfree(cq->queue);
-	kfree(cq);
-
-	return 0;
-}
-
-/**
- * qib_req_notify_cq - change the notification type for a completion queue
- * @ibcq: the completion queue
- * @notify_flags: the type of notification to request
- *
- * Returns 0 for success.
- *
- * This may be called from interrupt context.  Also called by
- * ib_req_notify_cq() in the generic verbs code.
- */
-int qib_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
-{
-	struct qib_cq *cq = to_icq(ibcq);
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&cq->lock, flags);
-	/*
-	 * Don't change IB_CQ_NEXT_COMP to IB_CQ_SOLICITED but allow
-	 * any other transitions (see C11-31 and C11-32 in ch. 11.4.2.2).
-	 */
-	if (cq->notify != IB_CQ_NEXT_COMP)
-		cq->notify = notify_flags & IB_CQ_SOLICITED_MASK;
-
-	if ((notify_flags & IB_CQ_REPORT_MISSED_EVENTS) &&
-	    cq->queue->head != cq->queue->tail)
-		ret = 1;
-
-	spin_unlock_irqrestore(&cq->lock, flags);
-
-	return ret;
-}
-
-/**
- * qib_resize_cq - change the size of the CQ
- * @ibcq: the completion queue
- *
- * Returns 0 for success.
- */
-int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
-{
-	struct qib_cq *cq = to_icq(ibcq);
-	struct qib_cq_wc *old_wc;
-	struct qib_cq_wc *wc;
-	u32 head, tail, n;
-	int ret;
-	u32 sz;
-
-	if (cqe < 1 || cqe > ib_qib_max_cqes) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	/*
-	 * Need to use vmalloc() if we want to support large #s of entries.
-	 */
-	sz = sizeof(*wc);
-	if (udata && udata->outlen >= sizeof(__u64))
-		sz += sizeof(struct ib_uverbs_wc) * (cqe + 1);
-	else
-		sz += sizeof(struct ib_wc) * (cqe + 1);
-	wc = vmalloc_user(sz);
-	if (!wc) {
-		ret = -ENOMEM;
-		goto bail;
-	}
-
-	/* Check that we can write the offset to mmap. */
-	if (udata && udata->outlen >= sizeof(__u64)) {
-		__u64 offset = 0;
-
-		ret = ib_copy_to_udata(udata, &offset, sizeof(offset));
-		if (ret)
-			goto bail_free;
-	}
-
-	spin_lock_irq(&cq->lock);
-	/*
-	 * Make sure head and tail are sane since they
-	 * might be user writable.
-	 */
-	old_wc = cq->queue;
-	head = old_wc->head;
-	if (head > (u32) cq->ibcq.cqe)
-		head = (u32) cq->ibcq.cqe;
-	tail = old_wc->tail;
-	if (tail > (u32) cq->ibcq.cqe)
-		tail = (u32) cq->ibcq.cqe;
-	if (head < tail)
-		n = cq->ibcq.cqe + 1 + head - tail;
-	else
-		n = head - tail;
-	if (unlikely((u32)cqe < n)) {
-		ret = -EINVAL;
-		goto bail_unlock;
-	}
-	for (n = 0; tail != head; n++) {
-		if (cq->ip)
-			wc->uqueue[n] = old_wc->uqueue[tail];
-		else
-			wc->kqueue[n] = old_wc->kqueue[tail];
-		if (tail == (u32) cq->ibcq.cqe)
-			tail = 0;
-		else
-			tail++;
-	}
-	cq->ibcq.cqe = cqe;
-	wc->head = n;
-	wc->tail = 0;
-	cq->queue = wc;
-	spin_unlock_irq(&cq->lock);
-
-	vfree(old_wc);
-
-	if (cq->ip) {
-		struct qib_ibdev *dev = to_idev(ibcq->device);
-		struct rvt_mmap_info *ip = cq->ip;
-
-		rvt_update_mmap_info(&dev->rdi, ip, sz, wc);
-
-		/*
-		 * Return the offset to mmap.
-		 * See qib_mmap() for details.
-		 */
-		if (udata && udata->outlen >= sizeof(__u64)) {
-			ret = ib_copy_to_udata(udata, &ip->offset,
-					       sizeof(ip->offset));
-			if (ret)
-				goto bail;
-		}
-
-		spin_lock_irq(&dev->rdi.pending_lock);
-		if (list_empty(&ip->pending_mmaps))
-			list_add(&ip->pending_mmaps, &dev->rdi.pending_mmaps);
-		spin_unlock_irq(&dev->rdi.pending_lock);
-	}
-
-	ret = 0;
-	goto bail;
-
-bail_unlock:
-	spin_unlock_irq(&cq->lock);
-bail_free:
-	vfree(wc);
-bail:
-	return ret;
-}
-
-int qib_cq_init(struct qib_devdata *dd)
-{
-	int ret = 0;
-	int cpu;
-	struct task_struct *task;
-
-	if (dd->worker)
-		return 0;
-	dd->worker = kzalloc(sizeof(*dd->worker), GFP_KERNEL);
-	if (!dd->worker)
-		return -ENOMEM;
-	init_kthread_worker(dd->worker);
-	task = kthread_create_on_node(
-		kthread_worker_fn,
-		dd->worker,
-		dd->assigned_node_id,
-		"qib_cq%d", dd->unit);
-	if (IS_ERR(task))
-		goto task_fail;
-	cpu = cpumask_first(cpumask_of_node(dd->assigned_node_id));
-	kthread_bind(task, cpu);
-	wake_up_process(task);
-out:
-	return ret;
-task_fail:
-	ret = PTR_ERR(task);
-	kfree(dd->worker);
-	dd->worker = NULL;
-	goto out;
-}
-
-void qib_cq_exit(struct qib_devdata *dd)
-{
-	struct kthread_worker *worker;
-
-	worker = dd->worker;
-	if (!worker)
-		return;
-	/* blocks future queuing from send_complete() */
-	dd->worker = NULL;
-	smp_wmb();
-	flush_kthread_worker(worker);
-	kthread_stop(worker->task);
-	kfree(worker);
-}
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index a3c74bb..3f062f0 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -457,8 +457,6 @@ static int loadtime_init(struct qib_devdata *dd)
 	init_timer(&dd->intrchk_timer);
 	dd->intrchk_timer.function = verify_interrupt;
 	dd->intrchk_timer.data = (unsigned long) dd;
-
-	ret = qib_cq_init(dd);
 done:
 	return ret;
 }
@@ -1435,7 +1433,6 @@ static void cleanup_device_data(struct qib_devdata *dd)
 	}
 	kfree(tmp);
 	kfree(dd->boardname);
-	qib_cq_exit(dd);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 79a28a6..a691410 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -471,7 +471,7 @@ int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	if (test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags)) {
 		wc.wr_id = qp->r_wr_id;
 		wc.status = err;
-		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
 	}
 	wc.status = IB_WC_WR_FLUSH_ERR;
 
@@ -494,7 +494,7 @@ int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 			wc.wr_id = get_rwqe_ptr(&qp->r_rq, tail)->wr_id;
 			if (++tail >= qp->r_rq.size)
 				tail = 0;
-			qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
 		}
 		wq->tail = tail;
 
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index e118004..8be5d45 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1026,7 +1026,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 			wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
 			wc.byte_len = wqe->length;
 			wc.qp = &qp->ibqp;
-			qib_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 0);
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
 		}
 		if (++qp->s_last >= qp->s_size)
 			qp->s_last = 0;
@@ -1082,7 +1082,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			wc.opcode = ib_qib_wc_opcode[wqe->wr.opcode];
 			wc.byte_len = wqe->length;
 			wc.qp = &qp->ibqp;
-			qib_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 0);
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
 		}
 		if (++qp->s_last >= qp->s_size)
 			qp->s_last = 0;
@@ -2048,7 +2048,7 @@ send_last:
 		wc.dlid_path_bits = 0;
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
-		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
 			     (ohdr->bth[0] &
 			      cpu_to_be32(IB_BTH_SOLICITED)) != 0);
 		break;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index f7b3bb7..80f1130 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -120,7 +120,7 @@ bad_lkey:
 	wc.opcode = IB_WC_RECV;
 	wc.qp = &qp->ibqp;
 	/* Signal solicited completion event. */
-	qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
 	ret = 0;
 bail:
 	return ret;
@@ -563,8 +563,8 @@ again:
 	wc.sl = qp->remote_ah_attr.sl;
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
-	qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
-		       wqe->wr.send_flags & IB_SEND_SOLICITED);
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
+		     wqe->wr.send_flags & IB_SEND_SOLICITED);
 
 send_comp:
 	spin_lock_irqsave(&sqp->s_lock, flags);
@@ -806,7 +806,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		wc.qp = &qp->ibqp;
 		if (status == IB_WC_SUCCESS)
 			wc.byte_len = wqe->length;
-		qib_cq_enter(to_icq(qp->ibqp.send_cq), &wc,
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,
 			     status != IB_WC_SUCCESS);
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index deceb45..caf0191 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -415,7 +415,7 @@ last_imm:
 		wc.dlid_path_bits = 0;
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
-		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
 			     (ohdr->bth[0] &
 				cpu_to_be32(IB_BTH_SOLICITED)) != 0);
 		break;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 76f854e..abca527 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -217,7 +217,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	wc.dlid_path_bits = ah_attr->dlid & ((1 << ppd->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
-	qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
 		     swqe->wr.send_flags & IB_SEND_SOLICITED);
 	ibp->rvp.n_loop_pkts++;
 bail_unlock:
@@ -583,7 +583,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 		dlid & ((1 << ppd_from_ibp(ibp)->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
-	qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
 		     (ohdr->bth[0] &
 			cpu_to_be32(IB_BTH_SOLICITED)) != 0);
 	return;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 831a335..442247a 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1904,7 +1904,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 		init_ibport(ppd + i);
 
 	/* Only need to initialize non-zero fields. */
-	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
 	spin_lock_init(&dev->n_mcast_grps_lock);
@@ -2016,11 +2015,11 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->post_send = qib_post_send;
 	ibdev->post_recv = qib_post_receive;
 	ibdev->post_srq_recv = qib_post_srq_receive;
-	ibdev->create_cq = qib_create_cq;
-	ibdev->destroy_cq = qib_destroy_cq;
-	ibdev->resize_cq = qib_resize_cq;
-	ibdev->poll_cq = qib_poll_cq;
-	ibdev->req_notify_cq = qib_req_notify_cq;
+	ibdev->create_cq = NULL;
+	ibdev->destroy_cq = NULL;
+	ibdev->resize_cq = NULL;
+	ibdev->poll_cq = NULL;
+	ibdev->req_notify_cq = NULL;
 	ibdev->get_dma_mr = NULL;
 	ibdev->reg_user_mr = NULL;
 	ibdev->dereg_mr = NULL;
@@ -2054,7 +2053,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.free_all_qps = qib_free_all_qps;
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
 
-	dd->verbs_dev.rdi.flags = RVT_FLAG_CQ_INIT_DRIVER;
+	dd->verbs_dev.rdi.flags = 0;
 
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
 	dd->verbs_dev.rdi.dparms.qp_table_size = ib_qib_qp_table_size;
@@ -2065,6 +2064,10 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.dparms.qos_shift = 1;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = qib_get_npkeys(dd);
+	dd->verbs_dev.rdi.dparms.node = dd->assigned_node_id;
+	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
+		 sizeof(dd->verbs_dev.rdi.dparms.cq_name),
+		 "qib_cq%d", dd->unit);
 
 	qib_fill_device_attr(dd);
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index dc6573a..aa518f7 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -46,6 +46,7 @@
 #include <rdma/ib_pack.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_cq.h>
 
 struct qib_ctxtdata;
 struct qib_pportdata;
@@ -61,12 +62,6 @@ struct qib_verbs_txreq;
  */
 #define QIB_UVERBS_ABI_VERSION       2
 
-/*
- * Define an ib_cq_notify value that is not valid so we know when CQ
- * notifications are armed.
- */
-#define IB_CQ_NONE      (IB_CQ_NEXT_COMP + 1)
-
 #define IB_SEQ_NAK	(3 << 29)
 
 /* AETH NAK opcode values */
@@ -220,35 +215,6 @@ struct qib_mcast {
 };
 
 /*
- * This structure is used to contain the head pointer, tail pointer,
- * and completion queue entries as a single memory allocation so
- * it can be mmap'ed into user space.
- */
-struct qib_cq_wc {
-	u32 head;               /* index of next entry to fill */
-	u32 tail;               /* index of next ib_poll_cq() entry */
-	union {
-		/* these are actually size ibcq.cqe + 1 */
-		struct ib_uverbs_wc uqueue[0];
-		struct ib_wc kqueue[0];
-	};
-};
-
-/*
- * The completion queue structure.
- */
-struct qib_cq {
-	struct ib_cq ibcq;
-	struct kthread_work comptask;
-	struct qib_devdata *dd;
-	spinlock_t lock; /* protect changes in this struct */
-	u8 notify;
-	u8 triggered;
-	struct qib_cq_wc *queue;
-	struct rvt_mmap_info *ip;
-};
-
-/*
  * qib specific data structure that will be hidden from rvt after the queue pair
  * is made common.
  */
@@ -345,8 +311,6 @@ struct qib_ibdev {
 	u32 n_piowait;
 	u32 n_txwait;
 
-	u32 n_cqs_allocated;    /* number of CQs allocated for device */
-	spinlock_t n_cqs_lock;
 	u32 n_qps_allocated;    /* number of QPs allocated for device */
 	spinlock_t n_qps_lock;
 	u32 n_srqs_allocated;   /* number of SRQs allocated for device */
@@ -375,11 +339,6 @@ struct qib_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct qib_cq *to_icq(struct ib_cq *ibcq)
-{
-	return container_of(ibcq, struct qib_cq, ibcq);
-}
-
 static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
 {
 	return container_of(ibqp, struct rvt_qp, ibqp);
@@ -545,25 +504,6 @@ int qib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
 
 int qib_destroy_srq(struct ib_srq *ibsrq);
 
-int qib_cq_init(struct qib_devdata *dd);
-
-void qib_cq_exit(struct qib_devdata *dd);
-
-void qib_cq_enter(struct qib_cq *cq, struct ib_wc *entry, int sig);
-
-int qib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
-
-struct ib_cq *qib_create_cq(struct ib_device *ibdev,
-			    const struct ib_cq_init_attr *attr,
-			    struct ib_ucontext *context,
-			    struct ib_udata *udata);
-
-int qib_destroy_cq(struct ib_cq *ibcq);
-
-int qib_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags);
-
-int qib_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
-
 void mr_rcu_callback(struct rcu_head *list);
 
 static inline void qib_put_ss(struct rvt_sge_state *ss)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
