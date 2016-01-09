From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 21/27] IB/hfi1: Remove CQ data structures and functions
 from hfi1
Date: Sat, 09 Jan 2016 07:18:35 -0800
Message-ID: <20160109151835.30800.36447.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The completion queue is not a complex data structure and it can be removed
at the same time as its functions. Unlike the more complicated queue pair
which was done in multiple patches. This single patch removes all traces
of hfi1 specific completeion queues from the hfi1 driver.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/cq.c  |    4 
 drivers/staging/rdma/hfi1/Makefile |    2 
 drivers/staging/rdma/hfi1/cq.c     |  558 ------------------------------------
 drivers/staging/rdma/hfi1/hfi.h    |    2 
 drivers/staging/rdma/hfi1/init.c   |    2 
 drivers/staging/rdma/hfi1/qp.c     |    4 
 drivers/staging/rdma/hfi1/rc.c     |    8 -
 drivers/staging/rdma/hfi1/ruc.c    |   10 -
 drivers/staging/rdma/hfi1/uc.c     |    6 
 drivers/staging/rdma/hfi1/ud.c     |   10 -
 drivers/staging/rdma/hfi1/verbs.c  |   21 +
 drivers/staging/rdma/hfi1/verbs.h  |   65 ----
 12 files changed, 35 insertions(+), 657 deletions(-)
 delete mode 100644 drivers/staging/rdma/hfi1/cq.c

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 7308a27..38150c1 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -432,7 +432,7 @@ int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 			ret = ib_copy_to_udata(udata, &ip->offset,
 					       sizeof(ip->offset));
 			if (ret)
-				goto bail;
+				return ret;
 		}
 
 		spin_lock_irq(&rdi->pending_lock);
@@ -447,9 +447,7 @@ bail_unlock:
 	spin_unlock_irq(&cq->lock);
 bail_free:
 	vfree(wc);
-bail:
 	return ret;
-
 }
 
 /**
diff --git a/drivers/staging/rdma/hfi1/Makefile b/drivers/staging/rdma/hfi1/Makefile
index ff663b3..e6c6983 100644
--- a/drivers/staging/rdma/hfi1/Makefile
+++ b/drivers/staging/rdma/hfi1/Makefile
@@ -7,7 +7,7 @@
 #
 obj-$(CONFIG_INFINIBAND_HFI1) += hfi1.o
 
-hfi1-y := chip.o cq.o device.o diag.o driver.o eprom.o file_ops.o firmware.o \
+hfi1-y := chip.o device.o diag.o driver.o eprom.o file_ops.o firmware.o \
 	init.o intr.o mad.o pcie.o pio.o pio_copy.o \
 	qp.o qsfp.o rc.o ruc.o sdma.o srq.o sysfs.o trace.o twsi.o \
 	uc.o ud.o user_pages.o user_sdma.o verbs_mcast.o verbs.o
diff --git a/drivers/staging/rdma/hfi1/cq.c b/drivers/staging/rdma/hfi1/cq.c
deleted file mode 100644
index 25d1a2a..0000000
--- a/drivers/staging/rdma/hfi1/cq.c
+++ /dev/null
@@ -1,558 +0,0 @@
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
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/kthread.h>
-
-#include "verbs.h"
-#include "hfi.h"
-
-/**
- * hfi1_cq_enter - add a new entry to the completion queue
- * @cq: completion queue
- * @entry: work completion entry to add
- * @sig: true if @entry is a solicited entry
- *
- * This may be called with qp->s_lock held.
- */
-void hfi1_cq_enter(struct hfi1_cq *cq, struct ib_wc *entry, int solicited)
-{
-	struct hfi1_cq_wc *wc;
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
-		smp_read_barrier_depends(); /* see hfi1_cq_exit */
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
- * hfi1_poll_cq - poll for work completion entries
- * @ibcq: the completion queue to poll
- * @num_entries: the maximum number of entries to return
- * @entry: pointer to array where work completions are placed
- *
- * Returns the number of completion entries polled.
- *
- * This may be called from interrupt context.  Also called by ib_poll_cq()
- * in the generic verbs code.
- */
-int hfi1_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
-{
-	struct hfi1_cq *cq = to_icq(ibcq);
-	struct hfi1_cq_wc *wc;
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
-	struct hfi1_cq *cq = container_of(work, struct hfi1_cq, comptask);
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
- * hfi1_create_cq - create a completion queue
- * @ibdev: the device this completion queue is attached to
- * @attr: creation attributes
- * @context: unused by the driver
- * @udata: user data for libibverbs.so
- *
- * Returns a pointer to the completion queue or negative errno values
- * for failure.
- *
- * Called by ib_create_cq() in the generic verbs code.
- */
-struct ib_cq *hfi1_create_cq(
-	struct ib_device *ibdev,
-	const struct ib_cq_init_attr *attr,
-	struct ib_ucontext *context,
-	struct ib_udata *udata)
-{
-	struct hfi1_ibdev *dev = to_idev(ibdev);
-	struct hfi1_cq *cq;
-	struct hfi1_cq_wc *wc;
-	struct ib_cq *ret;
-	u32 sz;
-	unsigned int entries = attr->cqe;
-
-	if (attr->flags)
-		return ERR_PTR(-EINVAL);
-
-	if (entries < 1 || entries > hfi1_max_cqes)
-		return ERR_PTR(-EINVAL);
-
-	/* Allocate the completion queue structure. */
-	cq = kmalloc(sizeof(*cq), GFP_KERNEL);
-	if (!cq)
-		return ERR_PTR(-ENOMEM);
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
-	 * See hfi1_mmap() for details.
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
-	if (dev->n_cqs_allocated == hfi1_max_cqs) {
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
- * hfi1_destroy_cq - destroy a completion queue
- * @ibcq: the completion queue to destroy.
- *
- * Returns 0 for success.
- *
- * Called by ib_destroy_cq() in the generic verbs code.
- */
-int hfi1_destroy_cq(struct ib_cq *ibcq)
-{
-	struct hfi1_ibdev *dev = to_idev(ibcq->device);
-	struct hfi1_cq *cq = to_icq(ibcq);
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
- * hfi1_req_notify_cq - change the notification type for a completion queue
- * @ibcq: the completion queue
- * @notify_flags: the type of notification to request
- *
- * Returns 0 for success.
- *
- * This may be called from interrupt context.  Also called by
- * ib_req_notify_cq() in the generic verbs code.
- */
-int hfi1_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
-{
-	struct hfi1_cq *cq = to_icq(ibcq);
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
- * hfi1_resize_cq - change the size of the CQ
- * @ibcq: the completion queue
- *
- * Returns 0 for success.
- */
-int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
-{
-	struct hfi1_cq *cq = to_icq(ibcq);
-	struct hfi1_cq_wc *old_wc;
-	struct hfi1_cq_wc *wc;
-	u32 head, tail, n;
-	int ret;
-	u32 sz;
-
-	if (cqe < 1 || cqe > hfi1_max_cqes) {
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
-		struct hfi1_ibdev *dev = to_idev(ibcq->device);
-		struct rvt_mmap_info *ip = cq->ip;
-
-		rvt_update_mmap_info(&dev->rdi, ip, sz, wc);
-
-		/*
-		 * Return the offset to mmap.
-		 * See hfi1_mmap() for details.
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
-int hfi1_cq_init(struct hfi1_devdata *dd)
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
-		"hfi1_cq%d", dd->unit);
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
-void hfi1_cq_exit(struct hfi1_devdata *dd)
-{
-	struct kthread_worker *worker;
-
-	worker = dd->worker;
-	if (!worker)
-		return;
-	/* blocks future queuing from send_complete() */
-	dd->worker = NULL;
-	smp_wmb(); /* See hfi1_cq_enter */
-	flush_kthread_worker(worker);
-	kthread_stop(worker->task);
-	kfree(worker);
-}
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 97d6226..b9b11ae 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1000,8 +1000,6 @@ struct hfi1_devdata {
 	u16 psxmitwait_check_rate;
 	/* high volume overflow errors deferred to tasklet */
 	struct tasklet_struct error_tasklet;
-	/* per device cq worker */
-	struct kthread_worker *worker;
 
 	/* MSI-X information */
 	struct hfi1_msix_entry *msix_entries;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index a96b16c..71cf3af 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -744,7 +744,6 @@ int hfi1_init(struct hfi1_devdata *dd, int reinit)
 	/* enable chip even if we have an error, so we can debug cause */
 	enable_chip(dd);
 
-	ret = hfi1_cq_init(dd);
 done:
 	/*
 	 * Set status even if port serdes is not initialized
@@ -1286,7 +1285,6 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 	kfree(dd->boardname);
 	vfree(dd->events);
 	vfree(dd->status);
-	hfi1_cq_exit(dd);
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 9b16f19..98f3a6b 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -304,7 +304,7 @@ int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	if (test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags)) {
 		wc.wr_id = qp->r_wr_id;
 		wc.status = err;
-		hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
 	}
 	wc.status = IB_WC_WR_FLUSH_ERR;
 
@@ -327,7 +327,7 @@ int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 			wc.wr_id = get_rwqe_ptr(&qp->r_rq, tail)->wr_id;
 			if (++tail >= qp->r_rq.size)
 				tail = 0;
-			hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
 		}
 		wq->tail = tail;
 
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index f7d1a50..62f31a7 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1040,7 +1040,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 			wc.opcode = ib_hfi1_wc_opcode[wqe->wr.opcode];
 			wc.byte_len = wqe->length;
 			wc.qp = &qp->ibqp;
-			hfi1_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 0);
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
 		}
 		if (++qp->s_last >= qp->s_size)
 			qp->s_last = 0;
@@ -1097,7 +1097,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			wc.opcode = ib_hfi1_wc_opcode[wqe->wr.opcode];
 			wc.byte_len = wqe->length;
 			wc.qp = &qp->ibqp;
-			hfi1_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 0);
+			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
 		}
 		if (++qp->s_last >= qp->s_size)
 			qp->s_last = 0;
@@ -2138,8 +2138,8 @@ send_last:
 		wc.dlid_path_bits = 0;
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
-		hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
-			      (bth0 & IB_BTH_SOLICITED) != 0);
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
+			     (bth0 & IB_BTH_SOLICITED) != 0);
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 96c1fde..03ec1b3 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -138,7 +138,7 @@ bad_lkey:
 	wc.opcode = IB_WC_RECV;
 	wc.qp = &qp->ibqp;
 	/* Signal solicited completion event. */
-	hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc, 1);
 	ret = 0;
 bail:
 	return ret;
@@ -584,8 +584,8 @@ again:
 	wc.sl = qp->remote_ah_attr.sl;
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
-	hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
-		      wqe->wr.send_flags & IB_SEND_SOLICITED);
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
+		     wqe->wr.send_flags & IB_SEND_SOLICITED);
 
 send_comp:
 	spin_lock_irqsave(&sqp->s_lock, flags);
@@ -947,8 +947,8 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		wc.qp = &qp->ibqp;
 		if (status == IB_WC_SUCCESS)
 			wc.byte_len = wqe->length;
-		hfi1_cq_enter(to_icq(qp->ibqp.send_cq), &wc,
-			      status != IB_WC_SUCCESS);
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc,
+			     status != IB_WC_SUCCESS);
 	}
 
 	last = qp->s_last;
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 1e3cba9..c7586ad 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -466,9 +466,9 @@ last_imm:
 		wc.dlid_path_bits = 0;
 		wc.port_num = 0;
 		/* Signal completion event if the solicited bit is set. */
-		hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
-			      (ohdr->bth[0] &
-				cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+		rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
+			     (ohdr->bth[0] &
+			      cpu_to_be32(IB_BTH_SOLICITED)) != 0);
 		break;
 
 	case OP(RDMA_WRITE_FIRST):
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 561d5d5..d4a41e8 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -248,8 +248,8 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	wc.dlid_path_bits = ah_attr->dlid & ((1 << ppd->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
-	hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
-		      swqe->wr.send_flags & IB_SEND_SOLICITED);
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
+		     swqe->wr.send_flags & IB_SEND_SOLICITED);
 	ibp->rvp.n_loop_pkts++;
 bail_unlock:
 	spin_unlock_irqrestore(&qp->r_lock, flags);
@@ -876,9 +876,9 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		dlid & ((1 << ppd_from_ibp(ibp)->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
-	hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
-		      (ohdr->bth[0] &
-			cpu_to_be32(IB_BTH_SOLICITED)) != 0);
+	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
+		     (ohdr->bth[0] &
+		      cpu_to_be32(IB_BTH_SOLICITED)) != 0);
 	return;
 
 drop:
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 8cd9a87..d84cc17 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1730,7 +1730,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 
-	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
 	spin_lock_init(&dev->n_mcast_grps_lock);
@@ -1827,11 +1826,11 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->post_send = post_send;
 	ibdev->post_recv = post_receive;
 	ibdev->post_srq_recv = hfi1_post_srq_receive;
-	ibdev->create_cq = hfi1_create_cq;
-	ibdev->destroy_cq = hfi1_destroy_cq;
-	ibdev->resize_cq = hfi1_resize_cq;
-	ibdev->poll_cq = hfi1_poll_cq;
-	ibdev->req_notify_cq = hfi1_req_notify_cq;
+	ibdev->create_cq = NULL;
+	ibdev->destroy_cq = NULL;
+	ibdev->resize_cq = NULL;
+	ibdev->poll_cq = NULL;
+	ibdev->req_notify_cq = NULL;
 	ibdev->get_dma_mr = NULL;
 	ibdev->reg_user_mr = NULL;
 	ibdev->dereg_mr = NULL;
@@ -1871,14 +1870,20 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.dparms.qos_shift = dd->qos_shift;
 	dd->verbs_dev.rdi.dparms.qpn_res_start = kdeth_qp << 16;
 	dd->verbs_dev.rdi.dparms.qpn_res_end =
-		dd->verbs_dev.rdi.dparms.qpn_res_start + 65535;
+	dd->verbs_dev.rdi.dparms.qpn_res_start + 65535;
 	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;
 	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = free_all_qps;
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
 
+	/* completeion queue */
+	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
+		 sizeof(dd->verbs_dev.rdi.dparms.cq_name),
+		 "hfi1_cq%d", dd->unit);
+	dd->verbs_dev.rdi.dparms.node = dd->assigned_node_id;
+
 	/* misc settings */
-	dd->verbs_dev.rdi.flags = RVT_FLAG_CQ_INIT_DRIVER;
+	dd->verbs_dev.rdi.flags = 0; /* Let rdmavt handle it all */
 	dd->verbs_dev.rdi.dparms.lkey_table_size = hfi1_lkey_table_size;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = hfi1_get_npkeys(dd);
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 6621277..eaaca98 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -64,6 +64,7 @@
 #include <rdma/ib_mad.h>
 #include <rdma/rdma_vt.h>
 #include <rdma/rdmavt_qp.h>
+#include <rdma/rdmavt_cq.h>
 
 struct hfi1_ctxtdata;
 struct hfi1_pportdata;
@@ -81,12 +82,6 @@ struct hfi1_packet;
  */
 #define HFI1_UVERBS_ABI_VERSION       2
 
-/*
- * Define an ib_cq_notify value that is not valid so we know when CQ
- * notifications are armed.
- */
-#define IB_CQ_NONE      (IB_CQ_NEXT_COMP + 1)
-
 #define IB_SEQ_NAK	(3 << 29)
 
 /* AETH NAK opcode values */
@@ -236,35 +231,6 @@ struct hfi1_mcast {
 };
 
 /*
- * This structure is used to contain the head pointer, tail pointer,
- * and completion queue entries as a single memory allocation so
- * it can be mmap'ed into user space.
- */
-struct hfi1_cq_wc {
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
-struct hfi1_cq {
-	struct ib_cq ibcq;
-	struct kthread_work comptask;
-	struct hfi1_devdata *dd;
-	spinlock_t lock; /* protect changes in this struct */
-	u8 notify;
-	u8 triggered;
-	struct hfi1_cq_wc *queue;
-	struct rvt_mmap_info *ip;
-};
-
-/*
  * hfi1 specific data structures that will be hidden from rvt after the queue
  * pair is made common
  */
@@ -351,8 +317,6 @@ struct hfi1_ibdev {
 	u64 n_kmem_wait;
 	u64 n_send_schedule;
 
-	u32 n_cqs_allocated;    /* number of CQs allocated for device */
-	spinlock_t n_cqs_lock;
 	u32 n_qps_allocated;    /* number of QPs allocated for device */
 	spinlock_t n_qps_lock;
 	u32 n_srqs_allocated;   /* number of SRQs allocated for device */
@@ -383,11 +347,6 @@ struct hfi1_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct hfi1_cq *to_icq(struct ib_cq *ibcq)
-{
-	return container_of(ibcq, struct hfi1_cq, ibcq);
-}
-
 static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
 {
 	return container_of(ibqp, struct rvt_qp, ibqp);
@@ -553,28 +512,6 @@ int hfi1_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr);
 
 int hfi1_destroy_srq(struct ib_srq *ibsrq);
 
-int hfi1_cq_init(struct hfi1_devdata *dd);
-
-void hfi1_cq_exit(struct hfi1_devdata *dd);
-
-void hfi1_cq_enter(struct hfi1_cq *cq, struct ib_wc *entry, int sig);
-
-int hfi1_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
-
-struct ib_cq *hfi1_create_cq(
-	struct ib_device *ibdev,
-	const struct ib_cq_init_attr *attr,
-	struct ib_ucontext *context,
-	struct ib_udata *udata);
-
-int hfi1_destroy_cq(struct ib_cq *ibcq);
-
-int hfi1_req_notify_cq(
-	struct ib_cq *ibcq,
-	enum ib_cq_notify_flags notify_flags);
-
-int hfi1_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
-
 static inline void hfi1_put_ss(struct rvt_sge_state *ss)
 {
 	while (ss->num_sge) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
