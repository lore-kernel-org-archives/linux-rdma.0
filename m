From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/7] IB/rdmavt: Add create queue pair functionality
Date: Fri, 22 Jan 2016 12:50:17 -0800
Message-ID: <20160122205016.4351.82572.stgit@scvm10.sc.intel.com>
References: <20160122204807.4351.24569.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122204807.4351.24569.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add create queue pair verbs call as well as supporting functions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |  425 +++++++++++++++++++++++++++++++++++--
 drivers/infiniband/sw/rdmavt/vt.c |    1 
 include/rdma/rdma_vt.h            |   10 +
 3 files changed, 413 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 17dd6ab..7d1f02e 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -47,8 +47,11 @@
 
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
-#include "vt.h"
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <rdma/ib_verbs.h>
 #include "qp.h"
+#include "vt.h"
 
 static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
 {
@@ -151,7 +154,10 @@ int rvt_driver_qp_init(struct rvt_dev_info *rdi)
 	 * If driver is not doing any QP allocation then make sure it is
 	 * providing the necessary QP functions.
 	 */
-	if (!rdi->driver_f.free_all_qps)
+	if (!rdi->driver_f.free_all_qps ||
+	    !rdi->driver_f.qp_priv_alloc ||
+	    !rdi->driver_f.qp_priv_free ||
+	    !rdi->driver_f.notify_qp_reset)
 		return -EINVAL;
 
 	/* allocate parent object */
@@ -178,7 +184,9 @@ int rvt_driver_qp_init(struct rvt_dev_info *rdi)
 	if (init_qpn_table(rdi, &rdi->qp_dev->qpn_table))
 		goto fail_table;
 
-	return ret;
+	spin_lock_init(&rdi->n_qps_lock);
+
+	return 0;
 
 fail_table:
 	kfree(rdi->qp_dev->qp_table);
@@ -197,31 +205,29 @@ no_qp_table:
  * There should not be any QPs still in use.
  * Free memory for table.
  */
-static unsigned free_all_qps(struct rvt_dev_info *rdi)
+static unsigned rvt_free_all_qps(struct rvt_dev_info *rdi)
 {
 	unsigned long flags;
 	struct rvt_qp *qp;
 	unsigned n, qp_inuse = 0;
 	spinlock_t *ql; /* work around too long line below */
 
-	rdi->driver_f.free_all_qps(rdi);
+	if (rdi->driver_f.free_all_qps)
+		qp_inuse = rdi->driver_f.free_all_qps(rdi);
 
 	if (!rdi->qp_dev)
-		return 0;
+		return qp_inuse;
 
 	ql = &rdi->qp_dev->qpt_lock;
-	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
+	spin_lock_irqsave(ql, flags);
 	for (n = 0; n < rdi->qp_dev->qp_table_size; n++) {
 		qp = rcu_dereference_protected(rdi->qp_dev->qp_table[n],
 					       lockdep_is_held(ql));
 		RCU_INIT_POINTER(rdi->qp_dev->qp_table[n], NULL);
-		qp =  rcu_dereference_protected(qp->next,
-						lockdep_is_held(ql));
-		while (qp) {
+
+		for (; qp; qp = rcu_dereference_protected(qp->next,
+							  lockdep_is_held(ql)))
 			qp_inuse++;
-			qp =  rcu_dereference_protected(qp->next,
-							lockdep_is_held(ql));
-		}
 	}
 	spin_unlock_irqrestore(ql, flags);
 	synchronize_rcu();
@@ -230,26 +236,190 @@ static unsigned free_all_qps(struct rvt_dev_info *rdi)
 
 void rvt_qp_exit(struct rvt_dev_info *rdi)
 {
-	u32 qps_inuse = free_all_qps(rdi);
+	u32 qps_inuse = rvt_free_all_qps(rdi);
 
-	qps_inuse = free_all_qps(rdi);
 	if (qps_inuse)
 		rvt_pr_err(rdi, "QP memory leak! %u still in use\n",
 			   qps_inuse);
 	if (!rdi->qp_dev)
 		return;
 
+	if (rdi->flags & RVT_FLAG_QP_INIT_DRIVER)
+		return; /* driver did the qp init so nothing else to do */
+
 	kfree(rdi->qp_dev->qp_table);
 	free_qpn_table(&rdi->qp_dev->qpn_table);
 	kfree(rdi->qp_dev);
 }
 
+static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
+			      struct rvt_qpn_map *map, unsigned off)
+{
+	return (map - qpt->map) * RVT_BITS_PER_PAGE + off;
+}
+
+/*
+ * Allocate the next available QPN or
+ * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
+ */
+static int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
+		     enum ib_qp_type type, u8 port)
+{
+	u32 i, offset, max_scan, qpn;
+	struct rvt_qpn_map *map;
+	u32 ret;
+
+	if (rdi->driver_f.alloc_qpn)
+		return rdi->driver_f.alloc_qpn(rdi, qpt, type, port);
+
+	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
+		unsigned n;
+
+		ret = type == IB_QPT_GSI;
+		n = 1 << (ret + 2 * (port - 1));
+		spin_lock(&qpt->lock);
+		if (qpt->flags & n)
+			ret = -EINVAL;
+		else
+			qpt->flags |= n;
+		spin_unlock(&qpt->lock);
+		goto bail;
+	}
+
+	qpn = qpt->last + qpt->incr;
+	if (qpn >= RVT_QPN_MAX)
+		qpn = qpt->incr | ((qpt->last & 1) ^ 1);
+	/* offset carries bit 0 */
+	offset = qpn & RVT_BITS_PER_PAGE_MASK;
+	map = &qpt->map[qpn / RVT_BITS_PER_PAGE];
+	max_scan = qpt->nmaps - !offset;
+	for (i = 0;;) {
+		if (unlikely(!map->page)) {
+			get_map_page(qpt, map);
+			if (unlikely(!map->page))
+				break;
+		}
+		do {
+			if (!test_and_set_bit(offset, map->page)) {
+				qpt->last = qpn;
+				ret = qpn;
+				goto bail;
+			}
+			offset += qpt->incr;
+			/*
+			 * This qpn might be bogus if offset >= BITS_PER_PAGE.
+			 * That is OK.   It gets re-assigned below
+			 */
+			qpn = mk_qpn(qpt, map, offset);
+		} while (offset < RVT_BITS_PER_PAGE && qpn < RVT_QPN_MAX);
+		/*
+		 * In order to keep the number of pages allocated to a
+		 * minimum, we scan the all existing pages before increasing
+		 * the size of the bitmap table.
+		 */
+		if (++i > max_scan) {
+			if (qpt->nmaps == RVT_QPNMAP_ENTRIES)
+				break;
+			map = &qpt->map[qpt->nmaps++];
+			/* start at incr with current bit 0 */
+			offset = qpt->incr | (offset & 1);
+		} else if (map < &qpt->map[qpt->nmaps]) {
+			++map;
+			/* start at incr with current bit 0 */
+			offset = qpt->incr | (offset & 1);
+		} else {
+			map = &qpt->map[0];
+			/* wrap to first map page, invert bit 0 */
+			offset = qpt->incr | ((offset & 1) ^ 1);
+		}
+		/* there can be no bits at shift and below */
+		WARN_ON(offset & (rdi->dparms.qos_shift - 1));
+		qpn = mk_qpn(qpt, map, offset);
+	}
+
+	ret = -ENOMEM;
+
+bail:
+	return ret;
+}
+
+static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
+{
+	struct rvt_qpn_map *map;
+
+	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
+	if (map->page)
+		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
+}
+
+/**
+ * reset_qp - initialize the QP state to the reset state
+ * @qp: the QP to reset
+ * @type: the QP type
+ */
+static void reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+		     enum ib_qp_type type)
+{
+	qp->remote_qpn = 0;
+	qp->qkey = 0;
+	qp->qp_access_flags = 0;
+
+	/*
+	 * Let driver do anything it needs to for a new/reset qp
+	 */
+	rdi->driver_f.notify_qp_reset(qp);
+
+	qp->s_flags &= RVT_S_SIGNAL_REQ_WR;
+	qp->s_hdrwords = 0;
+	qp->s_wqe = NULL;
+	qp->s_draining = 0;
+	qp->s_next_psn = 0;
+	qp->s_last_psn = 0;
+	qp->s_sending_psn = 0;
+	qp->s_sending_hpsn = 0;
+	qp->s_psn = 0;
+	qp->r_psn = 0;
+	qp->r_msn = 0;
+	if (type == IB_QPT_RC) {
+		qp->s_state = IB_OPCODE_RC_SEND_LAST;
+		qp->r_state = IB_OPCODE_RC_SEND_LAST;
+	} else {
+		qp->s_state = IB_OPCODE_UC_SEND_LAST;
+		qp->r_state = IB_OPCODE_UC_SEND_LAST;
+	}
+	qp->s_ack_state = IB_OPCODE_RC_ACKNOWLEDGE;
+	qp->r_nak_state = 0;
+	qp->r_aflags = 0;
+	qp->r_flags = 0;
+	qp->s_head = 0;
+	qp->s_tail = 0;
+	qp->s_cur = 0;
+	qp->s_acked = 0;
+	qp->s_last = 0;
+	qp->s_ssn = 1;
+	qp->s_lsn = 0;
+	qp->s_mig_state = IB_MIG_MIGRATED;
+	memset(qp->s_ack_queue, 0, sizeof(qp->s_ack_queue));
+	qp->r_head_ack_queue = 0;
+	qp->s_tail_ack_queue = 0;
+	qp->s_num_rd_atomic = 0;
+	if (qp->r_rq.wq) {
+		qp->r_rq.wq->head = 0;
+		qp->r_rq.wq->tail = 0;
+	}
+	qp->r_sge.num_sge = 0;
+}
+
 /**
  * rvt_create_qp - create a queue pair for a device
  * @ibpd: the protection domain who's device we create the queue pair for
  * @init_attr: the attributes of the queue pair
  * @udata: user data for libibverbs.so
  *
+ * Queue pair creation is mostly an rvt issue. However, drivers have their own
+ * unique idea of what queue pair numbers mean. For instance there is a reserved
+ * range for PSM.
+ *
  * Returns the queue pair on success, otherwise returns an errno.
  *
  * Called by the ib_create_qp() core verbs function.
@@ -258,15 +428,226 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata)
 {
+	struct rvt_qp *qp;
+	int err;
+	struct rvt_swqe *swq = NULL;
+	size_t sz;
+	size_t sg_list_sz;
+	struct ib_qp *ret = ERR_PTR(-ENOMEM);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibpd->device);
+	void *priv = NULL;
+
+	if (!rdi)
+		return ERR_PTR(-EINVAL);
+
+	if (init_attr->cap.max_send_sge > rdi->dparms.props.max_sge ||
+	    init_attr->cap.max_send_wr > rdi->dparms.props.max_qp_wr ||
+	    init_attr->create_flags)
+		return ERR_PTR(-EINVAL);
+
+	/* Check receive queue parameters if no SRQ is specified. */
+	if (!init_attr->srq) {
+		if (init_attr->cap.max_recv_sge > rdi->dparms.props.max_sge ||
+		    init_attr->cap.max_recv_wr > rdi->dparms.props.max_qp_wr)
+			return ERR_PTR(-EINVAL);
+
+		if (init_attr->cap.max_send_sge +
+		    init_attr->cap.max_send_wr +
+		    init_attr->cap.max_recv_sge +
+		    init_attr->cap.max_recv_wr == 0)
+			return ERR_PTR(-EINVAL);
+	}
+
+	switch (init_attr->qp_type) {
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+		if (init_attr->port_num == 0 ||
+		    init_attr->port_num > ibpd->device->phys_port_cnt)
+			return ERR_PTR(-EINVAL);
+	case IB_QPT_UC:
+	case IB_QPT_RC:
+	case IB_QPT_UD:
+		sz = sizeof(struct rvt_sge) *
+			init_attr->cap.max_send_sge +
+			sizeof(struct rvt_swqe);
+		swq = vmalloc((init_attr->cap.max_send_wr + 1) * sz);
+		if (!swq)
+			return ERR_PTR(-ENOMEM);
+
+		sz = sizeof(*qp);
+		sg_list_sz = 0;
+		if (init_attr->srq) {
+			struct rvt_srq *srq = ibsrq_to_rvtsrq(init_attr->srq);
+
+			if (srq->rq.max_sge > 1)
+				sg_list_sz = sizeof(*qp->r_sg_list) *
+					(srq->rq.max_sge - 1);
+		} else if (init_attr->cap.max_recv_sge > 1)
+			sg_list_sz = sizeof(*qp->r_sg_list) *
+				(init_attr->cap.max_recv_sge - 1);
+		qp = kzalloc(sz + sg_list_sz, GFP_KERNEL);
+		if (!qp)
+			goto bail_swq;
+
+		RCU_INIT_POINTER(qp->next, NULL);
+
+		/*
+		 * Driver needs to set up it's private QP structure and do any
+		 * initialization that is needed.
+		 */
+		priv = rdi->driver_f.qp_priv_alloc(rdi, qp);
+		if (!priv)
+			goto bail_qp;
+		qp->priv = priv;
+		qp->timeout_jiffies =
+			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
+				1000UL);
+		if (init_attr->srq) {
+			sz = 0;
+		} else {
+			qp->r_rq.size = init_attr->cap.max_recv_wr + 1;
+			qp->r_rq.max_sge = init_attr->cap.max_recv_sge;
+			sz = (sizeof(struct ib_sge) * qp->r_rq.max_sge) +
+				sizeof(struct rvt_rwqe);
+			qp->r_rq.wq = vmalloc_user(sizeof(struct rvt_rwq) +
+						   qp->r_rq.size * sz);
+			if (!qp->r_rq.wq)
+				goto bail_driver_priv;
+		}
+
+		/*
+		 * ib_create_qp() will initialize qp->ibqp
+		 * except for qp->ibqp.qp_num.
+		 */
+		spin_lock_init(&qp->r_lock);
+		spin_lock_init(&qp->s_lock);
+		spin_lock_init(&qp->r_rq.lock);
+		atomic_set(&qp->refcount, 0);
+		init_waitqueue_head(&qp->wait);
+		init_timer(&qp->s_timer);
+		qp->s_timer.data = (unsigned long)qp;
+		INIT_LIST_HEAD(&qp->rspwait);
+		qp->state = IB_QPS_RESET;
+		qp->s_wq = swq;
+		qp->s_size = init_attr->cap.max_send_wr + 1;
+		qp->s_max_sge = init_attr->cap.max_send_sge;
+		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
+			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
+
+		err = alloc_qpn(rdi, &rdi->qp_dev->qpn_table,
+				init_attr->qp_type,
+				init_attr->port_num);
+		if (err < 0) {
+			ret = ERR_PTR(err);
+			goto bail_rq_wq;
+		}
+		qp->ibqp.qp_num = err;
+		qp->port_num = init_attr->port_num;
+		reset_qp(rdi, qp, init_attr->qp_type);
+		break;
+
+	default:
+		/* Don't support raw QPs */
+		return ERR_PTR(-EINVAL);
+	}
+
+	init_attr->cap.max_inline_data = 0;
+
 	/*
-	 * Queue pair creation is mostly an rvt issue. However, drivers have
-	 * their own unique idea of what queue pare numbers mean. For instance
-	 * there is a reserved range for PSM.
-	 *
-	 * VI-DRIVER-API: make_qpn()
-	 * Returns a valid QPN for verbs to use
+	 * Return the address of the RWQ as the offset to mmap.
+	 * See hfi1_mmap() for details.
 	 */
-	return ERR_PTR(-EOPNOTSUPP);
+	if (udata && udata->outlen >= sizeof(__u64)) {
+		if (!qp->r_rq.wq) {
+			__u64 offset = 0;
+
+			err = ib_copy_to_udata(udata, &offset,
+					       sizeof(offset));
+			if (err) {
+				ret = ERR_PTR(err);
+				goto bail_qpn;
+			}
+		} else {
+			u32 s = sizeof(struct rvt_rwq) + qp->r_rq.size * sz;
+
+			qp->ip = rvt_create_mmap_info(rdi, s,
+						      ibpd->uobject->context,
+						      qp->r_rq.wq);
+			if (!qp->ip) {
+				ret = ERR_PTR(-ENOMEM);
+				goto bail_qpn;
+			}
+
+			err = ib_copy_to_udata(udata, &qp->ip->offset,
+					       sizeof(qp->ip->offset));
+			if (err) {
+				ret = ERR_PTR(err);
+				goto bail_ip;
+			}
+		}
+	}
+
+	spin_lock(&rdi->n_qps_lock);
+	if (rdi->n_qps_allocated == rdi->dparms.props.max_qp) {
+		spin_unlock(&rdi->n_qps_lock);
+		ret = ERR_PTR(-ENOMEM);
+		goto bail_ip;
+	}
+
+	rdi->n_qps_allocated++;
+	spin_unlock(&rdi->n_qps_lock);
+
+	if (qp->ip) {
+		spin_lock_irq(&rdi->pending_lock);
+		list_add(&qp->ip->pending_mmaps, &rdi->pending_mmaps);
+		spin_unlock_irq(&rdi->pending_lock);
+	}
+
+	ret = &qp->ibqp;
+
+	/*
+	 * We have our QP and its good, now keep track of what types of opcodes
+	 * can be processed on this QP. We do this by keeping track of what the
+	 * 3 high order bits of the opcode are.
+	 */
+	switch (init_attr->qp_type) {
+	case IB_QPT_SMI:
+	case IB_QPT_GSI:
+	case IB_QPT_UD:
+		qp->allowed_ops = IB_OPCODE_UD_SEND_ONLY & RVT_OPCODE_QP_MASK;
+		break;
+	case IB_QPT_RC:
+		qp->allowed_ops = IB_OPCODE_RC_SEND_ONLY & RVT_OPCODE_QP_MASK;
+		break;
+	case IB_QPT_UC:
+		qp->allowed_ops = IB_OPCODE_UC_SEND_ONLY & RVT_OPCODE_QP_MASK;
+		break;
+	default:
+		ret = ERR_PTR(-EINVAL);
+		goto bail_ip;
+	}
+
+	return ret;
+
+bail_ip:
+	kref_put(&qp->ip->ref, rvt_release_mmap_info);
+
+bail_qpn:
+	free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
+
+bail_rq_wq:
+	vfree(qp->r_rq.wq);
+
+bail_driver_priv:
+	rdi->driver_f.qp_priv_free(rdi, qp);
+
+bail_qp:
+	kfree(qp);
+
+bail_swq:
+	vfree(swq);
+
+	return ret;
 }
 
 /**
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index df2df36..e75eb3d 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -362,6 +362,7 @@ void rvt_unregister_device(struct rvt_dev_info *rdi)
 
 	ib_unregister_device(&rdi->ibdev);
 	rvt_mr_exit(rdi);
+	rvt_qp_exit(rdi);
 }
 EXPORT_SYMBOL(rvt_unregister_device);
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 3a78f20..3bdeac7 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -222,7 +222,10 @@ struct rvt_driver_provided {
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 	const char * (*get_card_name)(struct rvt_dev_info *rdi);
 	struct pci_dev * (*get_pci_dev)(struct rvt_dev_info *rdi);
-	void (*free_all_qps)(struct rvt_dev_info *rdi);
+	unsigned (*free_all_qps)(struct rvt_dev_info *rdi);
+	void * (*qp_priv_alloc)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+	void (*qp_priv_free)(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+	void (*notify_qp_reset)(struct rvt_qp *qp);
 
 	/*--------------------*/
 	/* Optional functions */
@@ -230,6 +233,8 @@ struct rvt_driver_provided {
 	int (*check_ah)(struct ib_device *, struct ib_ah_attr *);
 	void (*notify_new_ah)(struct ib_device *, struct ib_ah_attr *,
 			      struct rvt_ah *);
+	int (*alloc_qpn)(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
+			 enum ib_qp_type type, u8 port);
 };
 
 struct rvt_dev_info {
@@ -262,7 +267,10 @@ struct rvt_dev_info {
 	int flags;
 	struct rvt_ibport **ports;
 
+	/* QP */
 	struct rvt_qp_ibdev *qp_dev;
+	u32 n_qps_allocated;    /* number of QPs allocated for device */
+	spinlock_t n_qps_lock; /* keep track of number of qps */
 
 	/* memory maps */
 	struct list_head pending_mmaps;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
