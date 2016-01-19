From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] IB/qib: Remove qib multicast verbs functions
Date: Tue, 19 Jan 2016 14:33:56 -0800
Message-ID: <20160119223355.30925.79724.stgit@scvm10.sc.intel.com>
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

Multicast is now supported by rdmavt. Remove the verbs multicast functions
and use that.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Makefile          |    2 
 drivers/infiniband/hw/qib/qib_qp.c          |    2 
 drivers/infiniband/hw/qib/qib_verbs.c       |   13 -
 drivers/infiniband/hw/qib/qib_verbs.h       |   29 --
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |  368 ---------------------------
 5 files changed, 7 insertions(+), 407 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_verbs_mcast.c

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
index d78f688..8d5e36b 100644
--- a/drivers/infiniband/hw/qib/Makefile
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -5,7 +5,7 @@ ib_qib-y := qib_diag.o qib_driver.o qib_eeprom.o \
 	qib_mad.o qib_pcie.o qib_pio_copy.o \
 	qib_qp.o qib_qsfp.o qib_rc.o qib_ruc.o qib_sdma.o qib_srq.o \
 	qib_sysfs.o qib_twsi.o qib_tx.o qib_uc.o qib_ud.o \
-	qib_user_pages.o qib_user_sdma.o qib_verbs_mcast.o qib_iba7220.o \
+	qib_user_pages.o qib_user_sdma.o qib_iba7220.o \
 	qib_sd7220.o qib_iba7322.o qib_verbs.o
 
 # 6120 has no fallback if no MSI interrupts, others can do INTx
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 373d5b6..df55d49 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -309,8 +309,6 @@ unsigned qib_free_all_qps(struct rvt_dev_info *rdi)
 	for (n = 0; n < dd->num_pports; n++) {
 		struct qib_ibport *ibp = &dd->pport[n].ibport_data;
 
-		if (!qib_mcast_tree_empty(ibp))
-			qp_inuse++;
 		rcu_read_lock();
 		if (rcu_dereference(ibp->rvp.qp[0]))
 			qp_inuse++;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index add899b..cbf5f88 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -411,19 +411,19 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 	/* Get the destination QP number. */
 	qp_num = be32_to_cpu(ohdr->bth[1]) & QIB_QPN_MASK;
 	if (qp_num == QIB_MULTICAST_QPN) {
-		struct qib_mcast *mcast;
-		struct qib_mcast_qp *p;
+		struct rvt_mcast *mcast;
+		struct rvt_mcast_qp *p;
 
 		if (lnh != QIB_LRH_GRH)
 			goto drop;
-		mcast = qib_mcast_find(ibp, &hdr->u.l.grh.dgid);
+		mcast = rvt_mcast_find(&ibp->rvp, &hdr->u.l.grh.dgid);
 		if (mcast == NULL)
 			goto drop;
 		this_cpu_inc(ibp->pmastats->n_multicast_rcv);
 		list_for_each_entry_rcu(p, &mcast->qp_list, list)
 			qib_qp_rcv(rcd, hdr, 1, data, tlen, p->qp);
 		/*
-		 * Notify qib_multicast_detach() if it is waiting for us
+		 * Notify rvt_multicast_detach() if it is waiting for us
 		 * to finish.
 		 */
 		if (atomic_dec_return(&mcast->refcount) <= 1)
@@ -1657,7 +1657,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	/* Only need to initialize non-zero fields. */
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
-	spin_lock_init(&dev->n_mcast_grps_lock);
 	init_timer(&dev->mem_timer);
 	dev->mem_timer.function = mem_timer;
 	dev->mem_timer.data = (unsigned long) dev;
@@ -1780,8 +1779,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->map_phys_fmr = NULL;
 	ibdev->unmap_fmr = NULL;
 	ibdev->dealloc_fmr = NULL;
-	ibdev->attach_mcast = qib_multicast_attach;
-	ibdev->detach_mcast = qib_multicast_detach;
+	ibdev->attach_mcast = NULL;
+	ibdev->detach_mcast = NULL;
 	ibdev->process_mad = qib_process_mad;
 	ibdev->mmap = NULL;
 	ibdev->dma_ops = NULL;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index fdf2516..6b1e56b 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -185,25 +185,6 @@ struct qib_pio_header {
 } __packed;
 
 /*
- * There is one struct qib_mcast for each multicast GID.
- * All attached QPs are then stored as a list of
- * struct qib_mcast_qp.
- */
-struct qib_mcast_qp {
-	struct list_head list;
-	struct rvt_qp *qp;
-};
-
-struct qib_mcast {
-	struct rb_node rb_node;
-	union ib_gid mgid;
-	struct list_head qp_list;
-	wait_queue_head_t wait;
-	atomic_t refcount;
-	int n_attached;
-};
-
-/*
  * qib specific data structure that will be hidden from rvt after the queue pair
  * is made common.
  */
@@ -291,8 +272,6 @@ struct qib_ibdev {
 	spinlock_t n_qps_lock;
 	u32 n_srqs_allocated;   /* number of SRQs allocated for device */
 	spinlock_t n_srqs_lock;
-	u32 n_mcast_grps_allocated; /* number of mcast groups allocated */
-	spinlock_t n_mcast_grps_lock;
 #ifdef CONFIG_DEBUG_FS
 	/* per HCA debugfs */
 	struct dentry *qib_ibdev_dbg;
@@ -373,8 +352,6 @@ static inline int qib_cmp24(u32 a, u32 b)
 	return (((int) a) - ((int) b)) << 8;
 }
 
-struct qib_mcast *qib_mcast_find(struct qib_ibport *ibp, union ib_gid *mgid);
-
 int qib_snapshot_counters(struct qib_pportdata *ppd, u64 *swords,
 			  u64 *rwords, u64 *spkts, u64 *rpkts,
 			  u64 *xmit_wait);
@@ -382,12 +359,6 @@ int qib_snapshot_counters(struct qib_pportdata *ppd, u64 *swords,
 int qib_get_counters(struct qib_pportdata *ppd,
 		     struct qib_verbs_counters *cntrs);
 
-int qib_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
-
-int qib_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
-
-int qib_mcast_tree_empty(struct qib_ibport *ibp);
-
 __be32 qib_compute_aeth(struct rvt_qp *qp);
 
 struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn);
diff --git a/drivers/infiniband/hw/qib/qib_verbs_mcast.c b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
deleted file mode 100644
index 6eca307..0000000
--- a/drivers/infiniband/hw/qib/qib_verbs_mcast.c
+++ /dev/null
@@ -1,368 +0,0 @@
-/*
- * Copyright (c) 2006, 2007, 2008, 2009 QLogic Corporation. All rights reserved.
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
-#include <linux/rculist.h>
-
-#include "qib.h"
-
-/**
- * qib_mcast_qp_alloc - alloc a struct to link a QP to mcast GID struct
- * @qp: the QP to link
- */
-static struct qib_mcast_qp *qib_mcast_qp_alloc(struct rvt_qp *qp)
-{
-	struct qib_mcast_qp *mqp;
-
-	mqp = kmalloc(sizeof(*mqp), GFP_KERNEL);
-	if (!mqp)
-		goto bail;
-
-	mqp->qp = qp;
-	atomic_inc(&qp->refcount);
-
-bail:
-	return mqp;
-}
-
-static void qib_mcast_qp_free(struct qib_mcast_qp *mqp)
-{
-	struct rvt_qp *qp = mqp->qp;
-
-	/* Notify qib_destroy_qp() if it is waiting. */
-	if (atomic_dec_and_test(&qp->refcount))
-		wake_up(&qp->wait);
-
-	kfree(mqp);
-}
-
-/**
- * qib_mcast_alloc - allocate the multicast GID structure
- * @mgid: the multicast GID
- *
- * A list of QPs will be attached to this structure.
- */
-static struct qib_mcast *qib_mcast_alloc(union ib_gid *mgid)
-{
-	struct qib_mcast *mcast;
-
-	mcast = kmalloc(sizeof(*mcast), GFP_KERNEL);
-	if (!mcast)
-		goto bail;
-
-	mcast->mgid = *mgid;
-	INIT_LIST_HEAD(&mcast->qp_list);
-	init_waitqueue_head(&mcast->wait);
-	atomic_set(&mcast->refcount, 0);
-	mcast->n_attached = 0;
-
-bail:
-	return mcast;
-}
-
-static void qib_mcast_free(struct qib_mcast *mcast)
-{
-	struct qib_mcast_qp *p, *tmp;
-
-	list_for_each_entry_safe(p, tmp, &mcast->qp_list, list)
-		qib_mcast_qp_free(p);
-
-	kfree(mcast);
-}
-
-/**
- * qib_mcast_find - search the global table for the given multicast GID
- * @ibp: the IB port structure
- * @mgid: the multicast GID to search for
- *
- * Returns NULL if not found.
- *
- * The caller is responsible for decrementing the reference count if found.
- */
-struct qib_mcast *qib_mcast_find(struct qib_ibport *ibp, union ib_gid *mgid)
-{
-	struct rb_node *n;
-	unsigned long flags;
-	struct qib_mcast *mcast;
-
-	spin_lock_irqsave(&ibp->rvp.lock, flags);
-	n = ibp->rvp.mcast_tree.rb_node;
-	while (n) {
-		int ret;
-
-		mcast = rb_entry(n, struct qib_mcast, rb_node);
-
-		ret = memcmp(mgid->raw, mcast->mgid.raw,
-			     sizeof(union ib_gid));
-		if (ret < 0)
-			n = n->rb_left;
-		else if (ret > 0)
-			n = n->rb_right;
-		else {
-			atomic_inc(&mcast->refcount);
-			spin_unlock_irqrestore(&ibp->rvp.lock, flags);
-			goto bail;
-		}
-	}
-	spin_unlock_irqrestore(&ibp->rvp.lock, flags);
-
-	mcast = NULL;
-
-bail:
-	return mcast;
-}
-
-/**
- * qib_mcast_add - insert mcast GID into table and attach QP struct
- * @mcast: the mcast GID table
- * @mqp: the QP to attach
- *
- * Return zero if both were added.  Return EEXIST if the GID was already in
- * the table but the QP was added.  Return ESRCH if the QP was already
- * attached and neither structure was added.
- */
-static int qib_mcast_add(struct qib_ibdev *dev, struct qib_ibport *ibp,
-			 struct qib_mcast *mcast, struct qib_mcast_qp *mqp)
-{
-	struct rb_node **n = &ibp->rvp.mcast_tree.rb_node;
-	struct rb_node *pn = NULL;
-	int ret;
-
-	spin_lock_irq(&ibp->rvp.lock);
-
-	while (*n) {
-		struct qib_mcast *tmcast;
-		struct qib_mcast_qp *p;
-
-		pn = *n;
-		tmcast = rb_entry(pn, struct qib_mcast, rb_node);
-
-		ret = memcmp(mcast->mgid.raw, tmcast->mgid.raw,
-			     sizeof(union ib_gid));
-		if (ret < 0) {
-			n = &pn->rb_left;
-			continue;
-		}
-		if (ret > 0) {
-			n = &pn->rb_right;
-			continue;
-		}
-
-		/* Search the QP list to see if this is already there. */
-		list_for_each_entry_rcu(p, &tmcast->qp_list, list) {
-			if (p->qp == mqp->qp) {
-				ret = ESRCH;
-				goto bail;
-			}
-		}
-		if (tmcast->n_attached == ib_qib_max_mcast_qp_attached) {
-			ret = ENOMEM;
-			goto bail;
-		}
-
-		tmcast->n_attached++;
-
-		list_add_tail_rcu(&mqp->list, &tmcast->qp_list);
-		ret = EEXIST;
-		goto bail;
-	}
-
-	spin_lock(&dev->n_mcast_grps_lock);
-	if (dev->n_mcast_grps_allocated == ib_qib_max_mcast_grps) {
-		spin_unlock(&dev->n_mcast_grps_lock);
-		ret = ENOMEM;
-		goto bail;
-	}
-
-	dev->n_mcast_grps_allocated++;
-	spin_unlock(&dev->n_mcast_grps_lock);
-
-	mcast->n_attached++;
-
-	list_add_tail_rcu(&mqp->list, &mcast->qp_list);
-
-	atomic_inc(&mcast->refcount);
-	rb_link_node(&mcast->rb_node, pn, n);
-	rb_insert_color(&mcast->rb_node, &ibp->rvp.mcast_tree);
-
-	ret = 0;
-
-bail:
-	spin_unlock_irq(&ibp->rvp.lock);
-
-	return ret;
-}
-
-int qib_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-	struct qib_ibdev *dev = to_idev(ibqp->device);
-	struct qib_ibport *ibp;
-	struct qib_mcast *mcast;
-	struct qib_mcast_qp *mqp;
-	int ret;
-
-	if (ibqp->qp_num <= 1 || qp->state == IB_QPS_RESET) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	/*
-	 * Allocate data structures since its better to do this outside of
-	 * spin locks and it will most likely be needed.
-	 */
-	mcast = qib_mcast_alloc(gid);
-	if (mcast == NULL) {
-		ret = -ENOMEM;
-		goto bail;
-	}
-	mqp = qib_mcast_qp_alloc(qp);
-	if (mqp == NULL) {
-		qib_mcast_free(mcast);
-		ret = -ENOMEM;
-		goto bail;
-	}
-	ibp = to_iport(ibqp->device, qp->port_num);
-	switch (qib_mcast_add(dev, ibp, mcast, mqp)) {
-	case ESRCH:
-		/* Neither was used: OK to attach the same QP twice. */
-		qib_mcast_qp_free(mqp);
-		qib_mcast_free(mcast);
-		break;
-
-	case EEXIST:            /* The mcast wasn't used */
-		qib_mcast_free(mcast);
-		break;
-
-	case ENOMEM:
-		/* Exceeded the maximum number of mcast groups. */
-		qib_mcast_qp_free(mqp);
-		qib_mcast_free(mcast);
-		ret = -ENOMEM;
-		goto bail;
-
-	default:
-		break;
-	}
-
-	ret = 0;
-
-bail:
-	return ret;
-}
-
-int qib_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
-{
-	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
-	struct qib_ibdev *dev = to_idev(ibqp->device);
-	struct qib_ibport *ibp = to_iport(ibqp->device, qp->port_num);
-	struct qib_mcast *mcast = NULL;
-	struct qib_mcast_qp *p, *tmp;
-	struct rb_node *n;
-	int last = 0;
-	int ret;
-
-	if (ibqp->qp_num <= 1 || qp->state == IB_QPS_RESET) {
-		ret = -EINVAL;
-		goto bail;
-	}
-
-	spin_lock_irq(&ibp->rvp.lock);
-
-	/* Find the GID in the mcast table. */
-	n = ibp->rvp.mcast_tree.rb_node;
-	while (1) {
-		if (n == NULL) {
-			spin_unlock_irq(&ibp->rvp.lock);
-			ret = -EINVAL;
-			goto bail;
-		}
-
-		mcast = rb_entry(n, struct qib_mcast, rb_node);
-		ret = memcmp(gid->raw, mcast->mgid.raw,
-			     sizeof(union ib_gid));
-		if (ret < 0)
-			n = n->rb_left;
-		else if (ret > 0)
-			n = n->rb_right;
-		else
-			break;
-	}
-
-	/* Search the QP list. */
-	list_for_each_entry_safe(p, tmp, &mcast->qp_list, list) {
-		if (p->qp != qp)
-			continue;
-		/*
-		 * We found it, so remove it, but don't poison the forward
-		 * link until we are sure there are no list walkers.
-		 */
-		list_del_rcu(&p->list);
-		mcast->n_attached--;
-
-		/* If this was the last attached QP, remove the GID too. */
-		if (list_empty(&mcast->qp_list)) {
-			rb_erase(&mcast->rb_node, &ibp->rvp.mcast_tree);
-			last = 1;
-		}
-		break;
-	}
-
-	spin_unlock_irq(&ibp->rvp.lock);
-
-	if (p) {
-		/*
-		 * Wait for any list walkers to finish before freeing the
-		 * list element.
-		 */
-		wait_event(mcast->wait, atomic_read(&mcast->refcount) <= 1);
-		qib_mcast_qp_free(p);
-	}
-	if (last) {
-		atomic_dec(&mcast->refcount);
-		wait_event(mcast->wait, !atomic_read(&mcast->refcount));
-		qib_mcast_free(mcast);
-		spin_lock_irq(&dev->n_mcast_grps_lock);
-		dev->n_mcast_grps_allocated--;
-		spin_unlock_irq(&dev->n_mcast_grps_lock);
-	}
-
-	ret = 0;
-
-bail:
-	return ret;
-}
-
-int qib_mcast_tree_empty(struct qib_ibport *ibp)
-{
-	return !(ibp->rvp.mcast_tree.rb_node);
-}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
