From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/8] IB/rdmavt: Add completion queue functions
Date: Fri, 22 Jan 2016 13:00:15 -0800
Message-ID: <20160122210013.7850.29158.stgit@scvm10.sc.intel.com>
References: <20160122205822.7850.25466.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122205822.7850.25466.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Brings in completion queue functionality. A kthread worker is added to
the rvt_dev_info to serve as a worker for completion queues.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/cq.c |  445 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/cq.h |    4 
 drivers/infiniband/sw/rdmavt/vt.c |   11 +
 include/rdma/rdma_vt.h            |    9 +
 include/rdma/rdmavt_cq.h          |   99 ++++++++
 5 files changed, 561 insertions(+), 7 deletions(-)
 create mode 100644 include/rdma/rdmavt_cq.h

diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 8d96194..7308a27 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -45,7 +45,126 @@
  *
  */
 
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/kthread.h>
 #include "cq.h"
+#include "vt.h"
+
+/**
+ * rvt_cq_enter - add a new entry to the completion queue
+ * @cq: completion queue
+ * @entry: work completion entry to add
+ * @sig: true if @entry is solicited
+ *
+ * This may be called with qp->s_lock held.
+ */
+void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited)
+{
+	struct rvt_cq_wc *wc;
+	unsigned long flags;
+	u32 head;
+	u32 next;
+
+	spin_lock_irqsave(&cq->lock, flags);
+
+	/*
+	 * Note that the head pointer might be writable by user processes.
+	 * Take care to verify it is a sane value.
+	 */
+	wc = cq->queue;
+	head = wc->head;
+	if (head >= (unsigned)cq->ibcq.cqe) {
+		head = cq->ibcq.cqe;
+		next = 0;
+	} else {
+		next = head + 1;
+	}
+
+	if (unlikely(next == wc->tail)) {
+		spin_unlock_irqrestore(&cq->lock, flags);
+		if (cq->ibcq.event_handler) {
+			struct ib_event ev;
+
+			ev.device = cq->ibcq.device;
+			ev.element.cq = &cq->ibcq;
+			ev.event = IB_EVENT_CQ_ERR;
+			cq->ibcq.event_handler(&ev, cq->ibcq.cq_context);
+		}
+		return;
+	}
+	if (cq->ip) {
+		wc->uqueue[head].wr_id = entry->wr_id;
+		wc->uqueue[head].status = entry->status;
+		wc->uqueue[head].opcode = entry->opcode;
+		wc->uqueue[head].vendor_err = entry->vendor_err;
+		wc->uqueue[head].byte_len = entry->byte_len;
+		wc->uqueue[head].ex.imm_data =
+			(__u32 __force)entry->ex.imm_data;
+		wc->uqueue[head].qp_num = entry->qp->qp_num;
+		wc->uqueue[head].src_qp = entry->src_qp;
+		wc->uqueue[head].wc_flags = entry->wc_flags;
+		wc->uqueue[head].pkey_index = entry->pkey_index;
+		wc->uqueue[head].slid = entry->slid;
+		wc->uqueue[head].sl = entry->sl;
+		wc->uqueue[head].dlid_path_bits = entry->dlid_path_bits;
+		wc->uqueue[head].port_num = entry->port_num;
+		/* Make sure entry is written before the head index. */
+		smp_wmb();
+	} else {
+		wc->kqueue[head] = *entry;
+	}
+	wc->head = next;
+
+	if (cq->notify == IB_CQ_NEXT_COMP ||
+	    (cq->notify == IB_CQ_SOLICITED &&
+	     (solicited || entry->status != IB_WC_SUCCESS))) {
+		struct kthread_worker *worker;
+		/*
+		 * This will cause send_complete() to be called in
+		 * another thread.
+		 */
+		smp_read_barrier_depends(); /* see rvt_cq_exit */
+		worker = cq->rdi->worker;
+		if (likely(worker)) {
+			cq->notify = RVT_CQ_NONE;
+			cq->triggered++;
+			queue_kthread_work(worker, &cq->comptask);
+		}
+	}
+
+	spin_unlock_irqrestore(&cq->lock, flags);
+}
+EXPORT_SYMBOL(rvt_cq_enter);
+
+static void send_complete(struct kthread_work *work)
+{
+	struct rvt_cq *cq = container_of(work, struct rvt_cq, comptask);
+
+	/*
+	 * The completion handler will most likely rearm the notification
+	 * and poll for all pending entries.  If a new completion entry
+	 * is added while we are in this routine, queue_work()
+	 * won't call us again until we return so we check triggered to
+	 * see if we need to call the handler again.
+	 */
+	for (;;) {
+		u8 triggered = cq->triggered;
+
+		/*
+		 * IPoIB connected mode assumes the callback is from a
+		 * soft IRQ. We simulate this by blocking "bottom halves".
+		 * See the implementation for ipoib_cm_handle_tx_wc(),
+		 * netif_tx_lock_bh() and netif_tx_lock().
+		 */
+		local_bh_disable();
+		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+		local_bh_enable();
+
+		if (cq->triggered == triggered)
+			return;
+	}
+}
 
 /**
  * rvt_create_cq - create a completion queue
@@ -64,7 +183,103 @@ struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
 			    struct ib_ucontext *context,
 			    struct ib_udata *udata)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	struct rvt_cq *cq;
+	struct rvt_cq_wc *wc;
+	struct ib_cq *ret;
+	u32 sz;
+	unsigned int entries = attr->cqe;
+
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
+	if (entries < 1 || entries > rdi->dparms.props.max_cqe)
+		return ERR_PTR(-EINVAL);
+
+	/* Allocate the completion queue structure. */
+	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
+	if (!cq)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Allocate the completion queue entries and head/tail pointers.
+	 * This is allocated separately so that it can be resized and
+	 * also mapped into user space.
+	 * We need to use vmalloc() in order to support mmap and large
+	 * numbers of entries.
+	 */
+	sz = sizeof(*wc);
+	if (udata && udata->outlen >= sizeof(__u64))
+		sz += sizeof(struct ib_uverbs_wc) * (entries + 1);
+	else
+		sz += sizeof(struct ib_wc) * (entries + 1);
+	wc = vmalloc_user(sz);
+	if (!wc) {
+		ret = ERR_PTR(-ENOMEM);
+		goto bail_cq;
+	}
+
+	/*
+	 * Return the address of the WC as the offset to mmap.
+	 * See rvt_mmap() for details.
+	 */
+	if (udata && udata->outlen >= sizeof(__u64)) {
+		int err;
+
+		cq->ip = rvt_create_mmap_info(rdi, sz, context, wc);
+		if (!cq->ip) {
+			ret = ERR_PTR(-ENOMEM);
+			goto bail_wc;
+		}
+
+		err = ib_copy_to_udata(udata, &cq->ip->offset,
+				       sizeof(cq->ip->offset));
+		if (err) {
+			ret = ERR_PTR(err);
+			goto bail_ip;
+		}
+	}
+
+	spin_lock(&rdi->n_cqs_lock);
+	if (rdi->n_cqs_allocated == rdi->dparms.props.max_cq) {
+		spin_unlock(&rdi->n_cqs_lock);
+		ret = ERR_PTR(-ENOMEM);
+		goto bail_ip;
+	}
+
+	rdi->n_cqs_allocated++;
+	spin_unlock(&rdi->n_cqs_lock);
+
+	if (cq->ip) {
+		spin_lock_irq(&rdi->pending_lock);
+		list_add(&cq->ip->pending_mmaps, &rdi->pending_mmaps);
+		spin_unlock_irq(&rdi->pending_lock);
+	}
+
+	/*
+	 * ib_create_cq() will initialize cq->ibcq except for cq->ibcq.cqe.
+	 * The number of entries should be >= the number requested or return
+	 * an error.
+	 */
+	cq->rdi = rdi;
+	cq->ibcq.cqe = entries;
+	cq->notify = RVT_CQ_NONE;
+	spin_lock_init(&cq->lock);
+	init_kthread_work(&cq->comptask, send_complete);
+	cq->queue = wc;
+
+	ret = &cq->ibcq;
+
+	goto done;
+
+bail_ip:
+	kfree(cq->ip);
+bail_wc:
+	vfree(wc);
+bail_cq:
+	kfree(cq);
+done:
+	return ret;
 }
 
 /**
@@ -77,12 +292,53 @@ struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
  */
 int rvt_destroy_cq(struct ib_cq *ibcq)
 {
-	return -EOPNOTSUPP;
+	struct rvt_cq *cq = ibcq_to_rvtcq(ibcq);
+	struct rvt_dev_info *rdi = cq->rdi;
+
+	flush_kthread_work(&cq->comptask);
+	spin_lock(&rdi->n_cqs_lock);
+	rdi->n_cqs_allocated--;
+	spin_unlock(&rdi->n_cqs_lock);
+	if (cq->ip)
+		kref_put(&cq->ip->ref, rvt_release_mmap_info);
+	else
+		vfree(cq->queue);
+	kfree(cq);
+
+	return 0;
 }
 
+/**
+ * rvt_req_notify_cq - change the notification type for a completion queue
+ * @ibcq: the completion queue
+ * @notify_flags: the type of notification to request
+ *
+ * Returns 0 for success.
+ *
+ * This may be called from interrupt context.  Also called by
+ * ib_req_notify_cq() in the generic verbs code.
+ */
 int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 {
-	return -EOPNOTSUPP;
+	struct rvt_cq *cq = ibcq_to_rvtcq(ibcq);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&cq->lock, flags);
+	/*
+	 * Don't change IB_CQ_NEXT_COMP to IB_CQ_SOLICITED but allow
+	 * any other transitions (see C11-31 and C11-32 in ch. 11.4.2.2).
+	 */
+	if (cq->notify != IB_CQ_NEXT_COMP)
+		cq->notify = notify_flags & IB_CQ_SOLICITED_MASK;
+
+	if ((notify_flags & IB_CQ_REPORT_MISSED_EVENTS) &&
+	    cq->queue->head != cq->queue->tail)
+		ret = 1;
+
+	spin_unlock_irqrestore(&cq->lock, flags);
+
+	return ret;
 }
 
 /**
@@ -93,7 +349,107 @@ int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
  */
 int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
 {
-	return -EOPNOTSUPP;
+	struct rvt_cq *cq = ibcq_to_rvtcq(ibcq);
+	struct rvt_cq_wc *old_wc;
+	struct rvt_cq_wc *wc;
+	u32 head, tail, n;
+	int ret;
+	u32 sz;
+	struct rvt_dev_info *rdi = cq->rdi;
+
+	if (cqe < 1 || cqe > rdi->dparms.props.max_cqe)
+		return -EINVAL;
+
+	/*
+	 * Need to use vmalloc() if we want to support large #s of entries.
+	 */
+	sz = sizeof(*wc);
+	if (udata && udata->outlen >= sizeof(__u64))
+		sz += sizeof(struct ib_uverbs_wc) * (cqe + 1);
+	else
+		sz += sizeof(struct ib_wc) * (cqe + 1);
+	wc = vmalloc_user(sz);
+	if (!wc)
+		return -ENOMEM;
+
+	/* Check that we can write the offset to mmap. */
+	if (udata && udata->outlen >= sizeof(__u64)) {
+		__u64 offset = 0;
+
+		ret = ib_copy_to_udata(udata, &offset, sizeof(offset));
+		if (ret)
+			goto bail_free;
+	}
+
+	spin_lock_irq(&cq->lock);
+	/*
+	 * Make sure head and tail are sane since they
+	 * might be user writable.
+	 */
+	old_wc = cq->queue;
+	head = old_wc->head;
+	if (head > (u32)cq->ibcq.cqe)
+		head = (u32)cq->ibcq.cqe;
+	tail = old_wc->tail;
+	if (tail > (u32)cq->ibcq.cqe)
+		tail = (u32)cq->ibcq.cqe;
+	if (head < tail)
+		n = cq->ibcq.cqe + 1 + head - tail;
+	else
+		n = head - tail;
+	if (unlikely((u32)cqe < n)) {
+		ret = -EINVAL;
+		goto bail_unlock;
+	}
+	for (n = 0; tail != head; n++) {
+		if (cq->ip)
+			wc->uqueue[n] = old_wc->uqueue[tail];
+		else
+			wc->kqueue[n] = old_wc->kqueue[tail];
+		if (tail == (u32)cq->ibcq.cqe)
+			tail = 0;
+		else
+			tail++;
+	}
+	cq->ibcq.cqe = cqe;
+	wc->head = n;
+	wc->tail = 0;
+	cq->queue = wc;
+	spin_unlock_irq(&cq->lock);
+
+	vfree(old_wc);
+
+	if (cq->ip) {
+		struct rvt_mmap_info *ip = cq->ip;
+
+		rvt_update_mmap_info(rdi, ip, sz, wc);
+
+		/*
+		 * Return the offset to mmap.
+		 * See rvt_mmap() for details.
+		 */
+		if (udata && udata->outlen >= sizeof(__u64)) {
+			ret = ib_copy_to_udata(udata, &ip->offset,
+					       sizeof(ip->offset));
+			if (ret)
+				goto bail;
+		}
+
+		spin_lock_irq(&rdi->pending_lock);
+		if (list_empty(&ip->pending_mmaps))
+			list_add(&ip->pending_mmaps, &rdi->pending_mmaps);
+		spin_unlock_irq(&rdi->pending_lock);
+	}
+
+	return 0;
+
+bail_unlock:
+	spin_unlock_irq(&cq->lock);
+bail_free:
+	vfree(wc);
+bail:
+	return ret;
+
 }
 
 /**
@@ -109,5 +465,84 @@ int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata)
  */
 int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 {
-	return -EOPNOTSUPP;
+	struct rvt_cq *cq = ibcq_to_rvtcq(ibcq);
+	struct rvt_cq_wc *wc;
+	unsigned long flags;
+	int npolled;
+	u32 tail;
+
+	/* The kernel can only poll a kernel completion queue */
+	if (cq->ip)
+		return -EINVAL;
+
+	spin_lock_irqsave(&cq->lock, flags);
+
+	wc = cq->queue;
+	tail = wc->tail;
+	if (tail > (u32)cq->ibcq.cqe)
+		tail = (u32)cq->ibcq.cqe;
+	for (npolled = 0; npolled < num_entries; ++npolled, ++entry) {
+		if (tail == wc->head)
+			break;
+		/* The kernel doesn't need a RMB since it has the lock. */
+		*entry = wc->kqueue[tail];
+		if (tail >= cq->ibcq.cqe)
+			tail = 0;
+		else
+			tail++;
+	}
+	wc->tail = tail;
+
+	spin_unlock_irqrestore(&cq->lock, flags);
+
+	return npolled;
+}
+
+int rvt_driver_cq_init(struct rvt_dev_info *rdi)
+{
+	int ret = 0;
+	int cpu;
+	struct task_struct *task;
+
+	if (rdi->flags & RVT_FLAG_CQ_INIT_DRIVER) {
+		rvt_pr_info(rdi, "Driver is doing CQ init.\n");
+		return 0;
+	}
+
+	if (rdi->worker)
+		return 0;
+	rdi->worker = kzalloc(sizeof(*rdi->worker), GFP_KERNEL);
+	if (!rdi->worker)
+		return -ENOMEM;
+	init_kthread_worker(rdi->worker);
+	task = kthread_create_on_node(
+		kthread_worker_fn,
+		rdi->worker,
+		rdi->dparms.node,
+		"%s", rdi->dparms.cq_name);
+	if (IS_ERR(task)) {
+		kfree(rdi->worker);
+		rdi->worker = NULL;
+		return PTR_ERR(task);
+	}
+
+	cpu = cpumask_first(cpumask_of_node(rdi->dparms.node));
+	kthread_bind(task, cpu);
+	wake_up_process(task);
+	return ret;
+}
+
+void rvt_cq_exit(struct rvt_dev_info *rdi)
+{
+	struct kthread_worker *worker;
+
+	worker = rdi->worker;
+	if (!worker)
+		return;
+	/* blocks future queuing from send_complete() */
+	rdi->worker = NULL;
+	smp_wmb(); /* See rdi_cq_enter */
+	flush_kthread_worker(worker);
+	kthread_stop(worker->task);
+	kfree(worker);
 }
diff --git a/drivers/infiniband/sw/rdmavt/cq.h b/drivers/infiniband/sw/rdmavt/cq.h
index 63a517d..3813d90 100644
--- a/drivers/infiniband/sw/rdmavt/cq.h
+++ b/drivers/infiniband/sw/rdmavt/cq.h
@@ -49,6 +49,7 @@
  */
 
 #include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_cq.h>
 
 struct ib_cq *rvt_create_cq(struct ib_device *ibdev,
 			    const struct ib_cq_init_attr *attr,
@@ -58,5 +59,6 @@ int rvt_destroy_cq(struct ib_cq *ibcq);
 int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags);
 int rvt_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
-
+int rvt_driver_cq_init(struct rvt_dev_info *rdi);
+void rvt_cq_exit(struct rvt_dev_info *rdi);
 #endif          /* DEF_RVTCQ_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index f2b6438..136cc21 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -324,6 +324,11 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, mmap);
 
 	/* Completion queues */
+	ret = rvt_driver_cq_init(rdi);
+	if (ret) {
+		pr_err("Error in driver CQ init.\n");
+		goto bail_mr;
+	}
 	CHECK_DRIVER_OVERRIDE(rdi, create_cq);
 	CHECK_DRIVER_OVERRIDE(rdi, destroy_cq);
 	CHECK_DRIVER_OVERRIDE(rdi, poll_cq);
@@ -344,12 +349,15 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 	if (ret) {
 		rvt_pr_err(rdi, "Failed to register driver with ib core.\n");
-		goto bail_mr;
+		goto bail_cq;
 	}
 
 	rvt_pr_info(rdi, "Registration with rdmavt done.\n");
 	return ret;
 
+bail_cq:
+	rvt_cq_exit(rdi);
+
 bail_mr:
 	rvt_mr_exit(rdi);
 
@@ -366,6 +374,7 @@ void rvt_unregister_device(struct rvt_dev_info *rdi)
 		return;
 
 	ib_unregister_device(&rdi->ibdev);
+	rvt_cq_exit(rdi);
 	rvt_mr_exit(rdi);
 	rvt_qp_exit(rdi);
 }
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 70a9596..79080e3 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -138,6 +138,8 @@ struct rvt_ibport {
 	/* TODO: Move sm_ah and smi_ah into here as well*/
 };
 
+#define RVT_CQN_MAX 16 /* maximum length of cq name */
+
 /*
  * Things that are driver specific, module parameters in hfi1 and qib
  */
@@ -190,6 +192,8 @@ struct rvt_driver_params {
 	int nports;
 	int npkeys;
 	u8 qos_shift;
+	char cq_name[RVT_CQN_MAX];
+	int node;
 };
 
 /* Protection domain */
@@ -281,6 +285,11 @@ struct rvt_dev_info {
 	spinlock_t mmap_offset_lock; /* protect mmap_offset */
 	u32 mmap_offset;
 	spinlock_t pending_lock; /* protect pending mmap list */
+
+	/* CQ */
+	struct kthread_worker *worker; /* per device cq worker */
+	u32 n_cqs_allocated;    /* number of CQs allocated for device */
+	spinlock_t n_cqs_lock; /* protect count of in use cqs */
 };
 
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
diff --git a/include/rdma/rdmavt_cq.h b/include/rdma/rdmavt_cq.h
new file mode 100644
index 0000000..51fd00b
--- /dev/null
+++ b/include/rdma/rdmavt_cq.h
@@ -0,0 +1,99 @@
+#ifndef DEF_RDMAVT_INCCQ_H
+#define DEF_RDMAVT_INCCQ_H
+
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2016 Intel Corporation.
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
+#include <linux/kthread.h>
+#include <rdma/ib_user_verbs.h>
+
+/*
+ * Define an ib_cq_notify value that is not valid so we know when CQ
+ * notifications are armed.
+ */
+#define RVT_CQ_NONE      (IB_CQ_NEXT_COMP + 1)
+
+/*
+ * This structure is used to contain the head pointer, tail pointer,
+ * and completion queue entries as a single memory allocation so
+ * it can be mmap'ed into user space.
+ */
+struct rvt_cq_wc {
+	u32 head;               /* index of next entry to fill */
+	u32 tail;               /* index of next ib_poll_cq() entry */
+	union {
+		/* these are actually size ibcq.cqe + 1 */
+		struct ib_uverbs_wc uqueue[0];
+		struct ib_wc kqueue[0];
+	};
+};
+
+/*
+ * The completion queue structure.
+ */
+struct rvt_cq {
+	struct ib_cq ibcq;
+	struct kthread_work comptask;
+	spinlock_t lock; /* protect changes in this struct */
+	u8 notify;
+	u8 triggered;
+	struct rvt_dev_info *rdi;
+	struct rvt_cq_wc *queue;
+	struct rvt_mmap_info *ip;
+};
+
+static inline struct rvt_cq *ibcq_to_rvtcq(struct ib_cq *ibcq)
+{
+	return container_of(ibcq, struct rvt_cq, ibcq);
+}
+
+void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited);
+
+#endif          /* DEF_RDMAVT_INCCQH */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
