From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 9/9] IB/qib: Remove create qp and create qp table
 functionality
Date: Fri, 22 Jan 2016 12:56:52 -0800
Message-ID: <20160122205651.6530.90211.stgit@scvm10.sc.intel.com>
References: <20160122205437.6530.68843.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122205437.6530.68843.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rely on rdmavt functions for creation of qp and qp table.  Function to
allocate a qpn is still being provided by qib as the algorithm to allocate
a qpn in qib is different from that of the algorithm in rdmavt.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h       |    3 
 drivers/infiniband/hw/qib/qib_qp.c    |  361 +++------------------------------
 drivers/infiniband/hw/qib/qib_verbs.c |   48 +---
 drivers/infiniband/hw/qib/qib_verbs.h |   19 +-
 4 files changed, 57 insertions(+), 374 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 309b6f3..29cbe67 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1136,8 +1136,9 @@ extern spinlock_t qib_devs_lock;
 extern struct qib_devdata *qib_lookup(int unit);
 extern u32 qib_cpulist_count;
 extern unsigned long *qib_cpulist;
-
+extern u16 qpt_mask;
 extern unsigned qib_cc_table_size;
+
 int qib_init(struct qib_devdata *, int);
 int init_chip_wc_pat(struct qib_devdata *dd, u32);
 int qib_enable_wc(struct qib_devdata *dd);
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index c5e9cf5..83dec69 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -48,7 +48,7 @@
  * as qpt_mask here instead of adding the mask field to
  * rvt_qpn_table.
  */
-static u16 qpt_mask;
+u16 qpt_mask;
 
 static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
 			      struct rvt_qpn_map *map, unsigned off)
@@ -128,12 +128,15 @@ static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map,
  * Allocate the next available QPN or
  * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
  */
-static int alloc_qpn(struct qib_devdata *dd, struct rvt_qpn_table *qpt,
-		     enum ib_qp_type type, u8 port, gfp_t gfp)
+int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
+	      enum ib_qp_type type, u8 port, gfp_t gfp)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
 	u32 ret;
+	struct qib_ibdev *verbs_dev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = container_of(verbs_dev, struct qib_devdata,
+					      verbs_dev);
 
 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
 		unsigned n;
@@ -296,18 +299,13 @@ static void remove_qp(struct qib_ibdev *dev, struct rvt_qp *qp)
 
 /**
  * qib_free_all_qps - check for QPs still in use
- * @qpt: the QP table to empty
- *
- * There should not be any QPs still in use.
- * Free memory for table.
  */
-unsigned qib_free_all_qps(struct qib_devdata *dd)
+unsigned qib_free_all_qps(struct rvt_dev_info *rdi)
 {
-	struct qib_ibdev *dev = &dd->verbs_dev;
-	unsigned long flags;
-	struct rvt_qp *qp;
+	struct qib_ibdev *verbs_dev = container_of(rdi, struct qib_ibdev, rdi);
+	struct qib_devdata *dd = container_of(verbs_dev, struct qib_devdata,
+					      verbs_dev);
 	unsigned n, qp_inuse = 0;
-	spinlock_t *qpt_lock_ptr; /* Pointer to make checkpatch happy */
 
 	for (n = 0; n < dd->num_pports; n++) {
 		struct qib_ibport *ibp = &dd->pport[n].ibport_data;
@@ -321,21 +319,6 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 			qp_inuse++;
 		rcu_read_unlock();
 	}
-
-	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
-	qpt_lock_ptr = &dev->rdi.qp_dev->qpt_lock;
-	for (n = 0; n < dev->rdi.qp_dev->qp_table_size; n++) {
-		qp = rcu_dereference_protected(dev->rdi.qp_dev->qp_table[n],
-					       lockdep_is_held(qpt_lock_ptr));
-		RCU_INIT_POINTER(dev->rdi.qp_dev->qp_table[n], NULL);
-
-		for (; qp; qp = rcu_dereference_protected(qp->next,
-					lockdep_is_held(qpt_lock_ptr)))
-			qp_inuse++;
-	}
-	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
-	synchronize_rcu();
-
 	return qp_inuse;
 }
 
@@ -374,57 +357,11 @@ struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
 	return qp;
 }
 
-/**
- * qib_reset_qp - initialize the QP state to the reset state
- * @qp: the QP to reset
- * @type: the QP type
- */
-static void qib_reset_qp(struct rvt_qp *qp, enum ib_qp_type type)
+void notify_qp_reset(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
-	qp->remote_qpn = 0;
-	qp->qkey = 0;
-	qp->qp_access_flags = 0;
+
 	atomic_set(&priv->s_dma_busy, 0);
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
-	qp->r_aflags = 0;
-	qp->r_flags = 0;
-	qp->s_head = 0;
-	qp->s_tail = 0;
-	qp->s_cur = 0;
-	qp->s_acked = 0;
-	qp->s_last = 0;
-	qp->s_ssn = 1;
-	qp->s_lsn = 0;
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
 }
 
 static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
@@ -733,7 +670,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			spin_lock_irq(&qp->r_lock);
 			spin_lock(&qp->s_lock);
 			clear_mr_refs(qp, 1);
-			qib_reset_qp(qp, ibqp->qp_type);
+			rvt_reset_qp(&dev->rdi, qp, ibqp->qp_type);
 		}
 		break;
 
@@ -979,246 +916,33 @@ __be32 qib_compute_aeth(struct rvt_qp *qp)
 	return cpu_to_be32(aeth);
 }
 
-/**
- * qib_create_qp - create a queue pair for a device
- * @ibpd: the protection domain who's device we create the queue pair for
- * @init_attr: the attributes of the queue pair
- * @udata: user data for libibverbs.so
- *
- * Returns the queue pair on success, otherwise returns an errno.
- *
- * Called by the ib_create_qp() core verbs function.
- */
-struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
-			    struct ib_qp_init_attr *init_attr,
-			    struct ib_udata *udata)
+void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp)
 {
-	struct rvt_qp *qp;
-	int err;
-	struct rvt_swqe *swq = NULL;
-	struct qib_ibdev *dev;
-	struct qib_devdata *dd;
-	size_t sz;
-	size_t sg_list_sz;
-	struct ib_qp *ret;
-	gfp_t gfp;
 	struct qib_qp_priv *priv;
 
-	if (init_attr->cap.max_send_sge > ib_qib_max_sges ||
-	    init_attr->cap.max_send_wr > ib_qib_max_qp_wrs ||
-	    init_attr->create_flags & ~(IB_QP_CREATE_USE_GFP_NOIO))
-		return ERR_PTR(-EINVAL);
-
-	/* GFP_NOIO is applicable in RC QPs only */
-	if (init_attr->create_flags & IB_QP_CREATE_USE_GFP_NOIO &&
-	    init_attr->qp_type != IB_QPT_RC)
-		return ERR_PTR(-EINVAL);
-
-	gfp = init_attr->create_flags & IB_QP_CREATE_USE_GFP_NOIO ?
-			GFP_NOIO : GFP_KERNEL;
-
-	/* Check receive queue parameters if no SRQ is specified. */
-	if (!init_attr->srq) {
-		if (init_attr->cap.max_recv_sge > ib_qib_max_sges ||
-		    init_attr->cap.max_recv_wr > ib_qib_max_qp_wrs) {
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
-		swq = __vmalloc((init_attr->cap.max_send_wr + 1) * sz,
-				gfp, PAGE_KERNEL);
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
-		qp = kzalloc(sz + sg_list_sz, gfp);
-		if (!qp) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail_swq;
-		}
-		RCU_INIT_POINTER(qp->next, NULL);
-		priv = kzalloc(sizeof(*priv), gfp);
-		if (!priv) {
-			ret = ERR_PTR(-ENOMEM);
-			goto bail_qp_hdr;
-		}
-		priv->owner = qp;
-		priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), gfp);
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
-			if (gfp != GFP_NOIO)
-				qp->r_rq.wq = vmalloc_user(
-						sizeof(struct rvt_rwq) +
-						qp->r_rq.size * sz);
-			else
-				qp->r_rq.wq = __vmalloc(
-						sizeof(struct rvt_rwq) +
-						qp->r_rq.size * sz,
-						gfp, PAGE_KERNEL);
-
-			if (!qp->r_rq.wq) {
-				ret = ERR_PTR(-ENOMEM);
-				goto bail_qp;
-			}
-		}
+	priv = kzalloc(sizeof(*priv), gfp);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+	priv->owner = qp;
 
-		/*
-		 * ib_create_qp() will initialize qp->ibqp
-		 * except for qp->ibqp.qp_num.
-		 */
-		spin_lock_init(&qp->r_lock);
-		spin_lock_init(&qp->s_lock);
-		spin_lock_init(&qp->r_rq.lock);
-		atomic_set(&qp->refcount, 0);
-		init_waitqueue_head(&qp->wait);
-		init_waitqueue_head(&priv->wait_dma);
-		init_timer(&qp->s_timer);
-		qp->s_timer.data = (unsigned long)qp;
-		INIT_WORK(&priv->s_work, qib_do_send);
-		INIT_LIST_HEAD(&priv->iowait);
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
-				init_attr->qp_type, init_attr->port_num, gfp);
-		if (err < 0) {
-			ret = ERR_PTR(err);
-			vfree(qp->r_rq.wq);
-			goto bail_qp;
-		}
-		qp->ibqp.qp_num = err;
-		qp->port_num = init_attr->port_num;
-		qib_reset_qp(qp, init_attr->qp_type);
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
-	 * See qib_mmap() for details.
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
+	priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), gfp);
+	if (!priv->s_hdr) {
+		kfree(priv);
+		return ERR_PTR(-ENOMEM);
 	}
+	init_waitqueue_head(&priv->wait_dma);
+	INIT_WORK(&priv->s_work, qib_do_send);
+	INIT_LIST_HEAD(&priv->iowait);
 
-	spin_lock(&dev->n_qps_lock);
-	if (dev->n_qps_allocated == ib_qib_max_qps) {
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
+	return priv;
+}
 
-	ret = &qp->ibqp;
-	goto bail;
+void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+{
+	struct qib_qp_priv *priv = qp->priv;
 
-bail_ip:
-	if (qp->ip)
-		kref_put(&qp->ip->ref, rvt_release_mmap_info);
-	else
-		vfree(qp->r_rq.wq);
-	free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
-bail_qp:
 	kfree(priv->s_hdr);
 	kfree(priv);
-bail_qp_hdr:
-	kfree(qp);
-bail_swq:
-	vfree(swq);
-bail:
-	return ret;
 }
 
 /**
@@ -1277,31 +1001,6 @@ int qib_destroy_qp(struct ib_qp *ibqp)
 }
 
 /**
- * qib_init_qpn_table - initialize the QP number table for a device
- * @qpt: the QPN table
- */
-void qib_init_qpn_table(struct qib_devdata *dd, struct rvt_qpn_table *qpt)
-{
-	spin_lock_init(&qpt->lock);
-	qpt->last = 1;          /* start with QPN 2 */
-	qpt->nmaps = 1;
-	qpt_mask = dd->qpn_mask;
-}
-
-/**
- * qib_free_qpn_table - free the QP number table for a device
- * @qpt: the QPN table
- */
-void qib_free_qpn_table(struct rvt_qpn_table *qpt)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(qpt->map); i++)
-		if (qpt->map[i].page)
-			free_page((unsigned long) qpt->map[i].page);
-}
-
-/**
  * qib_get_credit - flush the send work queue of a QP
  * @qp: the qp who's send work queue to flush
  * @aeth: the Acknowledge Extended Transport Header
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index c190534..6b85153 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1904,29 +1904,11 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	unsigned i, ctxt;
 	int ret;
 
-	/* allocate parent object */
-	dev->rdi.qp_dev = kzalloc(sizeof(*dev->rdi.qp_dev), GFP_KERNEL);
-	if (!dev->rdi.qp_dev)
-		return -ENOMEM;
-	dev->rdi.qp_dev->qp_table_size = ib_qib_qp_table_size;
-	dev->rdi.qp_dev->qp_table_bits = ilog2(ib_qib_qp_table_size);
 	get_random_bytes(&dev->qp_rnd, sizeof(dev->qp_rnd));
-	dev->rdi.qp_dev->qp_table = kmalloc_array(
-				dev->rdi.qp_dev->qp_table_size,
-				sizeof(*dev->rdi.qp_dev->qp_table),
-				GFP_KERNEL);
-	if (!dev->rdi.qp_dev->qp_table) {
-		ret = -ENOMEM;
-		goto err_qpt;
-	}
-	for (i = 0; i < dev->rdi.qp_dev->qp_table_size; i++)
-		RCU_INIT_POINTER(dev->rdi.qp_dev->qp_table[i], NULL);
-
 	for (i = 0; i < dd->num_pports; i++)
 		init_ibport(ppd + i);
 
 	/* Only need to initialize non-zero fields. */
-	spin_lock_init(&dev->rdi.qp_dev->qpt_lock);
 	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
@@ -1935,7 +1917,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dev->mem_timer.function = mem_timer;
 	dev->mem_timer.data = (unsigned long) dev;
 
-	qib_init_qpn_table(dd, &dev->rdi.qp_dev->qpn_table);
+	qpt_mask = dd->qpn_mask;
 
 	INIT_LIST_HEAD(&dev->piowait);
 	INIT_LIST_HEAD(&dev->dmawait);
@@ -2032,7 +2014,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->modify_srq = qib_modify_srq;
 	ibdev->query_srq = qib_query_srq;
 	ibdev->destroy_srq = qib_destroy_srq;
-	ibdev->create_qp = qib_create_qp;
+	ibdev->create_qp = NULL;
 	ibdev->modify_qp = qib_modify_qp;
 	ibdev->query_qp = qib_query_qp;
 	ibdev->destroy_qp = qib_destroy_qp;
@@ -2071,9 +2053,21 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = qib_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = qib_notify_new_ah;
-	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
-				   RVT_FLAG_CQ_INIT_DRIVER);
+	dd->verbs_dev.rdi.driver_f.alloc_qpn = alloc_qpn;
+	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;
+	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
+	dd->verbs_dev.rdi.driver_f.free_all_qps = qib_free_all_qps;
+	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
+
+	dd->verbs_dev.rdi.flags = RVT_FLAG_CQ_INIT_DRIVER;
+
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
+	dd->verbs_dev.rdi.dparms.qp_table_size = ib_qib_qp_table_size;
+	dd->verbs_dev.rdi.dparms.qpn_start = 1;
+	dd->verbs_dev.rdi.dparms.qpn_res_start = QIB_KD_QP;
+	dd->verbs_dev.rdi.dparms.qpn_res_end = QIB_KD_QP; /* Reserve one QP */
+	dd->verbs_dev.rdi.dparms.qpn_inc = 1;
+	dd->verbs_dev.rdi.dparms.qos_shift = 1;
 	dd->verbs_dev.rdi.dparms.nports = dd->num_pports;
 	dd->verbs_dev.rdi.dparms.npkeys = qib_get_npkeys(dd);
 
@@ -2122,8 +2116,6 @@ err_tx:
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
 err_hdrs:
-	kfree(dev->rdi.qp_dev->qp_table);
-err_qpt:
 	qib_dev_err(dd, "cannot register verbs: %d!\n", -ret);
 bail:
 	return ret;
@@ -2132,7 +2124,6 @@ bail:
 void qib_unregister_ib_device(struct qib_devdata *dd)
 {
 	struct qib_ibdev *dev = &dd->verbs_dev;
-	u32 qps_inuse;
 
 	qib_verbs_unregister_sysfs(dd);
 
@@ -2149,13 +2140,7 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 	if (!list_empty(&dev->memwait))
 		qib_dev_err(dd, "memwait list not empty!\n");
 
-	qps_inuse = qib_free_all_qps(dd);
-	if (qps_inuse)
-		qib_dev_err(dd, "QP memory leak! %u still in use\n",
-			    qps_inuse);
-
 	del_timer_sync(&dev->mem_timer);
-	qib_free_qpn_table(&dev->rdi.qp_dev->qpn_table);
 	while (!list_empty(&dev->txreq_free)) {
 		struct list_head *l = dev->txreq_free.next;
 		struct qib_verbs_txreq *tx;
@@ -2169,7 +2154,6 @@ void qib_unregister_ib_device(struct qib_devdata *dd)
 				  dd->pport->sdma_descq_cnt *
 					sizeof(struct qib_pio_header),
 				  dev->pio_hdrs, dev->pio_hdrs_phys);
-	kfree(dev->rdi.qp_dev->qp_table);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 86d7537..bcc6271 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -464,10 +464,6 @@ __be32 qib_compute_aeth(struct rvt_qp *qp);
 
 struct rvt_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn);
 
-struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
-			    struct ib_qp_init_attr *init_attr,
-			    struct ib_udata *udata);
-
 int qib_destroy_qp(struct ib_qp *ibqp);
 
 int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
@@ -477,12 +473,15 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		 int attr_mask, struct ib_qp_init_attr *init_attr);
-
-unsigned qib_free_all_qps(struct qib_devdata *dd);
-
-void qib_init_qpn_table(struct qib_devdata *dd, struct rvt_qpn_table *qpt);
-
-void qib_free_qpn_table(struct rvt_qpn_table *qpt);
+/*
+ * Functions provided by qib driver for rdmavt to use
+ */
+unsigned qib_free_all_qps(struct rvt_dev_info *rdi);
+void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp);
+void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+void notify_qp_reset(struct rvt_qp *qp);
+int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
+	      enum ib_qp_type type, u8 port, gfp_t gfp);
 
 #ifdef CONFIG_DEBUG_FS
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
