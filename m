From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 19/31] staging/rdma/hfi1: Remove create_qp functionality
Date: Tue, 19 Jan 2016 14:43:12 -0800
Message-ID: <20160119224311.32765.59506.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rely on rdmavt to provide queue pair creation.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |  633 ++++---------------------------------
 drivers/staging/rdma/hfi1/qp.h    |   22 +
 drivers/staging/rdma/hfi1/verbs.c |   31 +-
 3 files changed, 100 insertions(+), 586 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 1bf8083..43584ff 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -60,7 +60,7 @@
 #include "trace.h"
 #include "sdma.h"
 
-static unsigned int hfi1_qp_table_size = 256;
+unsigned int hfi1_qp_table_size = 256;
 module_param_named(qp_table_size, hfi1_qp_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(qp_table_size, "QP table size");
 
@@ -115,105 +115,6 @@ static const u16 credit_table[31] = {
 	32768                   /* 1E */
 };
 
-static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
-{
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
-
-	/*
-	 * Free the page if someone raced with us installing it.
-	 */
-
-	spin_lock(&qpt->lock);
-	if (map->page)
-		free_page(page);
-	else
-		map->page = (void *)page;
-	spin_unlock(&qpt->lock);
-}
-
-/*
- * Allocate the next available QPN or
- * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
- */
-static int alloc_qpn(struct hfi1_devdata *dd, struct rvt_qpn_table *qpt,
-		     enum ib_qp_type type, u8 port)
-{
-	u32 i, offset, max_scan, qpn;
-	struct rvt_qpn_map *map;
-	u32 ret;
-
-	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
-		unsigned n;
-
-		ret = type == IB_QPT_GSI;
-		n = 1 << (ret + 2 * (port - 1));
-		spin_lock(&qpt->lock);
-		if (qpt->flags & n)
-			ret = -EINVAL;
-		else
-			qpt->flags |= n;
-		spin_unlock(&qpt->lock);
-		goto bail;
-	}
-
-	qpn = qpt->last + qpt->incr;
-	if (qpn >= RVT_QPN_MAX)
-		qpn = qpt->incr | ((qpt->last & 1) ^ 1);
-	/* offset carries bit 0 */
-	offset = qpn & RVT_BITS_PER_PAGE_MASK;
-	map = &qpt->map[qpn / RVT_BITS_PER_PAGE];
-	max_scan = qpt->nmaps - !offset;
-	for (i = 0;;) {
-		if (unlikely(!map->page)) {
-			get_map_page(qpt, map);
-			if (unlikely(!map->page))
-				break;
-		}
-		do {
-			if (!test_and_set_bit(offset, map->page)) {
-				qpt->last = qpn;
-				ret = qpn;
-				goto bail;
-			}
-			offset += qpt->incr;
-			/*
-			 * This qpn might be bogus if offset >=
-			 * RVT_BITS_PER_PAGE.  That is OK.   It gets re-assigned
-			 * below
-			 */
-			qpn = mk_qpn(qpt, map, offset);
-		} while (offset < RVT_BITS_PER_PAGE && qpn < RVT_QPN_MAX);
-		/*
-		 * In order to keep the number of pages allocated to a
-		 * minimum, we scan the all existing pages before increasing
-		 * the size of the bitmap table.
-		 */
-		if (++i > max_scan) {
-			if (qpt->nmaps == RVT_QPNMAP_ENTRIES)
-				break;
-			map = &qpt->map[qpt->nmaps++];
-			/* start at incr with current bit 0 */
-			offset = qpt->incr | (offset & 1);
-		} else if (map < &qpt->map[qpt->nmaps]) {
-			++map;
-			/* start at incr with current bit 0 */
-			offset = qpt->incr | (offset & 1);
-		} else {
-			map = &qpt->map[0];
-			/* wrap to first map page, invert bit 0 */
-			offset = qpt->incr | ((offset & 1) ^ 1);
-		}
-		/* there can be no bits at shift and below */
-		WARN_ON(offset & (dd->qos_shift - 1));
-		qpn = mk_qpn(qpt, map, offset);
-	}
-
-	ret = -ENOMEM;
-
-bail:
-	return ret;
-}
-
 static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 {
 	struct rvt_qpn_map *map;
@@ -296,113 +197,6 @@ static void remove_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 	}
 }
 
-/**
- * free_all_qps - check for QPs still in use
- * @qpt: the QP table to empty
- *
- * There should not be any QPs still in use.
- * Free memory for table.
- */
-static unsigned free_all_qps(struct hfi1_devdata *dd)
-{
-	struct hfi1_ibdev *dev = &dd->verbs_dev;
-	unsigned long flags;
-	struct rvt_qp *qp;
-	unsigned n, qp_inuse = 0;
-	spinlock_t *l; /* useless pointer to shutup checkpatch */
-
-	for (n = 0; n < dd->num_pports; n++) {
-		struct hfi1_ibport *ibp = &dd->pport[n].ibport_data;
-
-		if (!hfi1_mcast_tree_empty(ibp))
-			qp_inuse++;
-		rcu_read_lock();
-		if (rcu_dereference(ibp->rvp.qp[0]))
-			qp_inuse++;
-		if (rcu_dereference(ibp->rvp.qp[1]))
-			qp_inuse++;
-		rcu_read_unlock();
-	}
-
-	if (!dev->rdi.qp_dev)
-		goto bail;
-	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
-	for (n = 0; n < dev->rdi.qp_dev->qp_table_size; n++) {
-		l = &dev->rdi.qp_dev->qpt_lock;
-		qp = rcu_dereference_protected(dev->rdi.qp_dev->qp_table[n],
-					       lockdep_is_held(l));
-		RCU_INIT_POINTER(dev->rdi.qp_dev->qp_table[n], NULL);
-
-		for (; qp; qp = rcu_dereference_protected(qp->next,
-							  lockdep_is_held(l)))
-			qp_inuse++;
-	}
-	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
-	synchronize_rcu();
-bail:
-	return qp_inuse;
-}
-
-/**
- * reset_qp - initialize the QP state to the reset state
- * @qp: the QP to reset
- * @type: the QP type
- */
-static void reset_qp(struct rvt_qp *qp, enum ib_qp_type type)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-	qp->remote_qpn = 0;
-	qp->qkey = 0;
-	qp->qp_access_flags = 0;
-	iowait_init(
-		&priv->s_iowait,
-		1,
-		hfi1_do_send,
-		iowait_sleep,
-		iowait_wakeup);
-	qp->s_flags &= RVT_S_SIGNAL_REQ_WR;
-	qp->s_hdrwords = 0;
-	qp->s_wqe = NULL;
-	qp->s_draining = 0;
-	qp->s_next_psn = 0;
-	qp->s_last_psn = 0;
-	qp->s_sending_psn = 0;
-	qp->s_sending_hpsn = 0;
-	qp->s_psn = 0;
-	qp->r_psn = 0;
-	qp->r_msn = 0;
-	if (type == IB_QPT_RC) {
-		qp->s_state = IB_OPCODE_RC_SEND_LAST;
-		qp->r_state = IB_OPCODE_RC_SEND_LAST;
-	} else {
-		qp->s_state = IB_OPCODE_UC_SEND_LAST;
-		qp->r_state = IB_OPCODE_UC_SEND_LAST;
-	}
-	qp->s_ack_state = IB_OPCODE_RC_ACKNOWLEDGE;
-	qp->r_nak_state = 0;
-	priv->r_adefered = 0;
-	qp->r_aflags = 0;
-	qp->r_flags = 0;
-	qp->s_head = 0;
-	qp->s_tail = 0;
-	qp->s_cur = 0;
-	qp->s_acked = 0;
-	qp->s_last = 0;
-	qp->s_ssn = 1;
-	qp->s_lsn = 0;
-	clear_ahg(qp);
-	qp->s_mig_state = IB_MIG_MIGRATED;
-	memset(qp->s_ack_queue, 0, sizeof(qp->s_ack_queue));
-	qp->r_head_ack_queue = 0;
-	qp->s_tail_ack_queue = 0;
-	qp->s_num_rd_atomic = 0;
-	if (qp->r_rq.wq) {
-		qp->r_rq.wq->head = 0;
-		qp->r_rq.wq->tail = 0;
-	}
-	qp->r_sge.num_sge = 0;
-}
-
 static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
@@ -756,7 +550,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			spin_lock(&qp->s_lock);
 			clear_mr_refs(qp, 1);
 			clear_ahg(qp);
-			reset_qp(qp, ibqp->qp_type);
+			rvt_reset_qp(&dev->rdi, qp, ibqp->qp_type);
 		}
 		break;
 
@@ -1025,254 +819,6 @@ __be32 hfi1_compute_aeth(struct rvt_qp *qp)
 }
 
 /**
- * hfi1_create_qp - create a queue pair for a device
- * @ibpd: the protection domain who's device we create the queue pair for
- * @init_attr: the attributes of the queue pair
- * @udata: user data for libibverbs.so
- *
- * Returns the queue pair on success, otherwise returns an errno.
- *
- * Called by the ib_create_qp() core verbs function.
- */
-struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
-			     struct ib_qp_init_attr *init_attr,
-			     struct ib_udata *udata)
-{
-	struct rvt_qp *qp;
-	struct hfi1_qp_priv *priv;
-	int err;
-	struct rvt_swqe *swq = NULL;
-	struct hfi1_ibdev *dev;
-	struct hfi1_devdata *dd;
-	size_t sz;
-	size_t sg_list_sz;
-	struct ib_qp *ret;
-
-	if (init_attr->cap.max_send_sge > hfi1_max_sges ||
-	    init_attr->cap.max_send_wr > hfi1_max_qp_wrs ||
-	    init_attr->create_flags) {
-		ret = ERR_PTR(-EINVAL);
-		goto bail;
-	}
-
-	/* Check receive queue parameters if no SRQ is specified. */
-	if (!init_attr->srq) {
-		if (init_attr->cap.max_recv_sge > hfi1_max_sges ||
-		    init_attr->cap.max_recv_wr > hfi1_max_qp_wrs) {
-			ret = ERR_PTR(-EINVAL);
-			goto bail;
-		}
-		if (init_attr->cap.max_send_sge +
-		    init_attr->cap.max_send_wr +
-		    init_attr->cap.max_recv_sge +
-		    init_attr->cap.max_recv_wr == 0) {
-			ret = ERR_PTR(-EINVAL);
-			goto bail;
-		}
-	}
-
-	switch (init_attr->qp_type) {
-	case IB_QPT_SMI:
-	case IB_QPT_GSI:
-		if (init_attr->port_num == 0 ||
-		    init_attr->port_num > ibpd->device->phys_port_cnt) {
-			ret = ERR_PTR(-EINVAL);
-			goto bail;
-		}
-	case IB_QPT_UC:
-	case IB_QPT_RC:
-	case IB_QPT_UD:
-		sz = sizeof(struct rvt_sge) *
-			init_attr->cap.max_send_sge +
-			sizeof(struct rvt_swqe);
-		swq = vmalloc((init_attr->cap.max_send_wr + 1) * sz);
-		if (swq == NULL) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail;
-		}
-		sz = sizeof(*qp);
-		sg_list_sz = 0;
-		if (init_attr->srq) {
-			struct rvt_srq *srq = ibsrq_to_rvtsrq(init_attr->srq);
-
-			if (srq->rq.max_sge > 1)
-				sg_list_sz = sizeof(*qp->r_sg_list) *
-					(srq->rq.max_sge - 1);
-		} else if (init_attr->cap.max_recv_sge > 1)
-			sg_list_sz = sizeof(*qp->r_sg_list) *
-				(init_attr->cap.max_recv_sge - 1);
-		qp = kzalloc(sz + sg_list_sz, GFP_KERNEL);
-		if (!qp) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail_swq;
-		}
-		RCU_INIT_POINTER(qp->next, NULL);
-		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-		if (!priv) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail_qp_priv;
-		}
-		priv->owner = qp;
-		priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), GFP_KERNEL);
-		if (!priv->s_hdr) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail_qp;
-		}
-		qp->priv = priv;
-		qp->timeout_jiffies =
-			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
-				1000UL);
-		if (init_attr->srq)
-			sz = 0;
-		else {
-			qp->r_rq.size = init_attr->cap.max_recv_wr + 1;
-			qp->r_rq.max_sge = init_attr->cap.max_recv_sge;
-			sz = (sizeof(struct ib_sge) * qp->r_rq.max_sge) +
-				sizeof(struct rvt_rwqe);
-			qp->r_rq.wq = vmalloc_user(sizeof(struct rvt_rwq) +
-						   qp->r_rq.size * sz);
-			if (!qp->r_rq.wq) {
-				ret = ERR_PTR(-ENOMEM);
-				goto bail_qp;
-			}
-		}
-
-		/*
-		 * ib_create_qp() will initialize qp->ibqp
-		 * except for qp->ibqp.qp_num.
-		 */
-		spin_lock_init(&qp->r_lock);
-		spin_lock_init(&qp->s_lock);
-		spin_lock_init(&qp->r_rq.lock);
-		atomic_set(&qp->refcount, 0);
-		init_waitqueue_head(&qp->wait);
-		init_timer(&qp->s_timer);
-		qp->s_timer.data = (unsigned long)qp;
-		INIT_LIST_HEAD(&qp->rspwait);
-		qp->state = IB_QPS_RESET;
-		qp->s_wq = swq;
-		qp->s_size = init_attr->cap.max_send_wr + 1;
-		qp->s_max_sge = init_attr->cap.max_send_sge;
-		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
-			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
-		dev = to_idev(ibpd->device);
-		dd = dd_from_dev(dev);
-		err = alloc_qpn(dd, &dev->rdi.qp_dev->qpn_table,
-				init_attr->qp_type,
-				init_attr->port_num);
-		if (err < 0) {
-			ret = ERR_PTR(err);
-			vfree(qp->r_rq.wq);
-			goto bail_qp;
-		}
-		qp->ibqp.qp_num = err;
-		qp->port_num = init_attr->port_num;
-		reset_qp(qp, init_attr->qp_type);
-
-		break;
-
-	default:
-		/* Don't support raw QPs */
-		ret = ERR_PTR(-ENOSYS);
-		goto bail;
-	}
-
-	init_attr->cap.max_inline_data = 0;
-
-	/*
-	 * Return the address of the RWQ as the offset to mmap.
-	 * See hfi1_mmap() for details.
-	 */
-	if (udata && udata->outlen >= sizeof(__u64)) {
-		if (!qp->r_rq.wq) {
-			__u64 offset = 0;
-
-			err = ib_copy_to_udata(udata, &offset,
-					       sizeof(offset));
-			if (err) {
-				ret = ERR_PTR(err);
-				goto bail_ip;
-			}
-		} else {
-			u32 s = sizeof(struct rvt_rwq) + qp->r_rq.size * sz;
-
-			qp->ip = rvt_create_mmap_info(&dev->rdi, s,
-						      ibpd->uobject->context,
-						      qp->r_rq.wq);
-			if (!qp->ip) {
-				ret = ERR_PTR(-ENOMEM);
-				goto bail_ip;
-			}
-
-			err = ib_copy_to_udata(udata, &(qp->ip->offset),
-					       sizeof(qp->ip->offset));
-			if (err) {
-				ret = ERR_PTR(err);
-				goto bail_ip;
-			}
-		}
-	}
-
-	spin_lock(&dev->n_qps_lock);
-	if (dev->n_qps_allocated == hfi1_max_qps) {
-		spin_unlock(&dev->n_qps_lock);
-		ret = ERR_PTR(-ENOMEM);
-		goto bail_ip;
-	}
-
-	dev->n_qps_allocated++;
-	spin_unlock(&dev->n_qps_lock);
-
-	if (qp->ip) {
-		spin_lock_irq(&dev->rdi.pending_lock);
-		list_add(&qp->ip->pending_mmaps, &dev->rdi.pending_mmaps);
-		spin_unlock_irq(&dev->rdi.pending_lock);
-	}
-
-	ret = &qp->ibqp;
-
-	/*
-	 * We have our QP and its good, now keep track of what types of opcodes
-	 * can be processed on this QP. We do this by keeping track of what the
-	 * 3 high order bits of the opcode are.
-	 */
-	switch (init_attr->qp_type) {
-	case IB_QPT_SMI:
-	case IB_QPT_GSI:
-	case IB_QPT_UD:
-		qp->allowed_ops = IB_OPCODE_UD_SEND_ONLY & OPCODE_QP_MASK;
-		break;
-	case IB_QPT_RC:
-		qp->allowed_ops = IB_OPCODE_RC_SEND_ONLY & OPCODE_QP_MASK;
-		break;
-	case IB_QPT_UC:
-		qp->allowed_ops = IB_OPCODE_UC_SEND_ONLY & OPCODE_QP_MASK;
-		break;
-	default:
-		ret = ERR_PTR(-EINVAL);
-		goto bail_ip;
-	}
-
-	goto bail;
-
-bail_ip:
-	if (qp->ip)
-		kref_put(&qp->ip->ref, rvt_release_mmap_info);
-	else
-		vfree(qp->r_rq.wq);
-	free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
-bail_qp:
-	kfree(priv->s_hdr);
-	kfree(priv);
-bail_qp_priv:
-	kfree(qp);
-bail_swq:
-	vfree(swq);
-bail:
-	return ret;
-}
-
-/**
  * hfi1_destroy_qp - destroy a queue pair
  * @ibqp: the queue pair to destroy
  *
@@ -1328,61 +874,6 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 }
 
 /**
- * init_qpn_table - initialize the QP number table for a device
- * @qpt: the QPN table
- */
-static int init_qpn_table(struct hfi1_devdata *dd, struct rvt_qpn_table *qpt)
-{
-	u32 offset, qpn, i;
-	struct rvt_qpn_map *map;
-	int ret = 0;
-
-	spin_lock_init(&qpt->lock);
-
-	qpt->last = 0;
-	qpt->incr = 1 << dd->qos_shift;
-
-	/* insure we don't assign QPs from KDETH 64K window */
-	qpn = kdeth_qp << 16;
-	qpt->nmaps = qpn / RVT_BITS_PER_PAGE;
-	/* This should always be zero */
-	offset = qpn & RVT_BITS_PER_PAGE_MASK;
-	map = &qpt->map[qpt->nmaps];
-	dd_dev_info(dd, "Reserving QPNs for KDETH window from 0x%x to 0x%x\n",
-		qpn, qpn + 65535);
-	for (i = 0; i < 65536; i++) {
-		if (!map->page) {
-			get_map_page(qpt, map);
-			if (!map->page) {
-				ret = -ENOMEM;
-				break;
-			}
-		}
-		set_bit(offset, map->page);
-		offset++;
-		if (offset == RVT_BITS_PER_PAGE) {
-			/* next page */
-			qpt->nmaps++;
-			map++;
-			offset = 0;
-		}
-	}
-	return ret;
-}
-
-/**
- * free_qpn_table - free the QP number table for a device
- * @qpt: the QPN table
- */
-static void free_qpn_table(struct rvt_qpn_table *qpt)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(qpt->map); i++)
-		free_page((unsigned long) qpt->map[i].page);
-}
-
-/**
  * hfi1_get_credit - flush the send work queue of a QP
  * @qp: the qp who's send work queue to flush
  * @aeth: the Acknowledge Extended Transport Header
@@ -1499,58 +990,6 @@ static void iowait_wakeup(struct iowait *wait, int reason)
 	hfi1_qp_wakeup(qp, RVT_S_WAIT_DMA_DESC);
 }
 
-int hfi1_qp_init(struct hfi1_ibdev *dev)
-{
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-	int i;
-	int ret = -ENOMEM;
-
-	/* allocate parent object */
-	dev->rdi.qp_dev = kzalloc(sizeof(*dev->rdi.qp_dev), GFP_KERNEL);
-	if (!dev->rdi.qp_dev)
-		goto nomem;
-	/* allocate hash table */
-	dev->rdi.qp_dev->qp_table_size = hfi1_qp_table_size;
-	dev->rdi.qp_dev->qp_table_bits = ilog2(hfi1_qp_table_size);
-	dev->rdi.qp_dev->qp_table =
-		kmalloc(dev->rdi.qp_dev->qp_table_size *
-				sizeof(*dev->rdi.qp_dev->qp_table),
-			GFP_KERNEL);
-	if (!dev->rdi.qp_dev->qp_table)
-		goto nomem;
-	for (i = 0; i < dev->rdi.qp_dev->qp_table_size; i++)
-		RCU_INIT_POINTER(dev->rdi.qp_dev->qp_table[i], NULL);
-	spin_lock_init(&dev->rdi.qp_dev->qpt_lock);
-	/* initialize qpn map */
-	ret = init_qpn_table(dd, &dev->rdi.qp_dev->qpn_table);
-	if (ret)
-		goto nomem;
-	return ret;
-nomem:
-	if (dev->rdi.qp_dev) {
-		kfree(dev->rdi.qp_dev->qp_table);
-		free_qpn_table(&dev->rdi.qp_dev->qpn_table);
-		kfree(dev->rdi.qp_dev);
-	}
-	return ret;
-}
-
-void hfi1_qp_exit(struct hfi1_ibdev *dev)
-{
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-	u32 qps_inuse;
-
-	qps_inuse = free_all_qps(dd);
-	if (qps_inuse)
-		dd_dev_err(dd, "QP memory leak! %u still in use\n",
-			   qps_inuse);
-	if (dev->rdi.qp_dev) {
-		kfree(dev->rdi.qp_dev->qp_table);
-		free_qpn_table(&dev->rdi.qp_dev->qpn_table);
-		kfree(dev->rdi.qp_dev);
-	}
-}
-
 /**
  *
  * qp_to_sdma_engine - map a qp to a send engine
@@ -1724,6 +1163,74 @@ void qp_comm_est(struct rvt_qp *qp)
 	}
 }
 
+void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	priv->owner = qp;
+
+	priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), GFP_KERNEL);
+	if (!priv->s_hdr) {
+		kfree(priv);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return priv;
+}
+
+void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	kfree(priv->s_hdr);
+	kfree(priv);
+}
+
+unsigned free_all_qps(struct rvt_dev_info *rdi)
+{
+	struct hfi1_ibdev *verbs_dev = container_of(rdi,
+						    struct hfi1_ibdev,
+						    rdi);
+	struct hfi1_devdata *dd = container_of(verbs_dev,
+					       struct hfi1_devdata,
+					       verbs_dev);
+	int n;
+	unsigned qp_inuse = 0;
+
+	for (n = 0; n < dd->num_pports; n++) {
+		struct hfi1_ibport *ibp = &dd->pport[n].ibport_data;
+
+		if (!hfi1_mcast_tree_empty(ibp))
+			qp_inuse++;
+		rcu_read_lock();
+		if (rcu_dereference(ibp->rvp.qp[0]))
+			qp_inuse++;
+		if (rcu_dereference(ibp->rvp.qp[1]))
+			qp_inuse++;
+		rcu_read_unlock();
+	}
+
+	return qp_inuse;
+}
+
+void notify_qp_reset(struct rvt_qp *qp)
+{
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	iowait_init(
+		&priv->s_iowait,
+		1,
+		hfi1_do_send,
+		iowait_sleep,
+		iowait_wakeup);
+	priv->r_adefered = 0;
+	clear_ahg(qp);
+}
+
 /*
  * Switch to alternate path.
  * The QP s_lock should be held and interrupts disabled.
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 18b0f0e..fd72802 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -55,6 +55,8 @@
 #include "verbs.h"
 #include "sdma.h"
 
+extern unsigned int hfi1_qp_table_size;
+
 static inline u32 qpn_hash(struct rvt_qp_ibdev *dev, u32 qpn)
 {
 	return hash_32(qpn, dev->qp_table_bits);
@@ -170,18 +172,6 @@ int hfi1_destroy_qp(struct ib_qp *ibqp);
 void hfi1_get_credit(struct rvt_qp *qp, u32 aeth);
 
 /**
- * hfi1_qp_init - allocate QP tables
- * @dev: a pointer to the hfi1_ibdev
- */
-int hfi1_qp_init(struct hfi1_ibdev *dev);
-
-/**
- * hfi1_qp_exit - free the QP related structures
- * @dev: a pointer to the hfi1_ibdev
- */
-void hfi1_qp_exit(struct hfi1_ibdev *dev);
-
-/**
  * hfi1_qp_wakeup - wake up on the indicated event
  * @qp: the QP
  * @flag: flag the qp on which the qp is stalled
@@ -255,4 +245,12 @@ static inline void hfi1_schedule_send(struct rvt_qp *qp)
 
 void hfi1_migrate_qp(struct rvt_qp *qp);
 
+/*
+ * Functions provided by hfi1 driver for rdmavt to use
+ */
+void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+unsigned free_all_qps(struct rvt_dev_info *rdi);
+void notify_qp_reset(struct rvt_qp *qp);
+
 #endif /* _QP_H */
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a1e9f0b..3f02d0a 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -1720,11 +1720,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	u16 descq_cnt;
 	char buf[TXREQ_NAME_LEN];
 
-	ret = hfi1_qp_init(dev);
-	if (ret)
-		goto err_qp_init;
-
-
 	for (i = 0; i < dd->num_pports; i++)
 		init_ibport(ppd + i);
 
@@ -1820,7 +1815,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_srq = hfi1_modify_srq;
 	ibdev->query_srq = hfi1_query_srq;
 	ibdev->destroy_srq = hfi1_destroy_srq;
-	ibdev->create_qp = hfi1_create_qp;
+	ibdev->create_qp = NULL;
 	ibdev->modify_qp = hfi1_modify_qp;
 	ibdev->query_qp = hfi1_query_qp;
 	ibdev->destroy_qp = hfi1_destroy_qp;
@@ -1861,8 +1856,25 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = hfi1_notify_new_ah;
 	dd->verbs_dev.rdi.dparms.props.max_ah = hfi1_max_ahs;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
-	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
-				   RVT_FLAG_CQ_INIT_DRIVER);
+	dd->verbs_dev.rdi.dparms.props.max_sge = hfi1_max_sges;
+
+	/* queue pair */
+	dd->verbs_dev.rdi.dparms.props.max_qp = hfi1_max_qps;
+	dd->verbs_dev.rdi.dparms.props.max_qp_wr = hfi1_max_qp_wrs;
+	dd->verbs_dev.rdi.dparms.qp_table_size = hfi1_qp_table_size;
+	dd->verbs_dev.rdi.dparms.qpn_start = 0;
+	dd->verbs_dev.rdi.dparms.qpn_inc = 1;
+	dd->verbs_dev.rdi.dparms.qos_shift = dd->qos_shift;
+	dd->verbs_dev.rdi.dparms.qpn_res_start = kdeth_qp << 16;
+	dd->verbs_dev.rdi.dparms.qpn_res_end =
+		dd->verbs_dev.rdi.dparms.qpn_res_start + 65535;
+	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;
+	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
+	dd->verbs_dev.rdi.driver_f.free_all_qps = free_all_qps;
+	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
+
+	/* misc settings */
+	dd->verbs_dev.rdi.flags = RVT_FLAG_CQ_INIT_DRIVER;
 	dd->verbs_dev.rdi.dparms.lkey_table_size = hfi1_lkey_table_size;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = hfi1_get_npkeys(dd);
@@ -1895,8 +1907,6 @@ err_agents:
 err_reg:
 err_verbs_txreq:
 	kmem_cache_destroy(dev->verbs_txreq_cache);
-	hfi1_qp_exit(dev);
-err_qp_init:
 	dd_dev_err(dd, "cannot register verbs: %d!\n", -ret);
 bail:
 	return ret;
@@ -1917,7 +1927,6 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 	if (!list_empty(&dev->memwait))
 		dd_dev_err(dd, "memwait list not empty!\n");
 
-	hfi1_qp_exit(dev);
 	del_timer_sync(&dev->mem_timer);
 	kmem_cache_destroy(dev->verbs_txreq_cache);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
