From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: fix qp RCU sparse warnings
Date: Mon, 16 Jul 2012 13:11:06 -0400
Message-ID: <20120716171106.14715.34959.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit af061a64 ("IB/qib: Use RCU for qpn lookup")
introduced sparse warnings.

This patch corrects those issues.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |   12 ++++-------
 drivers/infiniband/hw/qib/qib_mad.c     |   12 ++++-------
 drivers/infiniband/hw/qib/qib_qp.c      |   35 +++++++++++++++++++++----------
 drivers/infiniband/hw/qib/qib_verbs.c   |   23 ++++++++++++++++++--
 drivers/infiniband/hw/qib/qib_verbs.h   |   14 +++++++-----
 5 files changed, 61 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index c881e74..78e8550 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1,5 +1,6 @@
 /*
- * Copyright (c) 2008, 2009, 2010 QLogic Corporation. All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2008 - 2012 QLogic Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -49,6 +50,7 @@
 #include "qib_qsfp.h"
 
 #include "qib_mad.h"
+#include "qib_verbs.h"
 
 static void qib_setup_7322_setextled(struct qib_pportdata *, u32);
 static void qib_7322_handle_hwerrors(struct qib_devdata *, char *, size_t);
@@ -5151,15 +5153,11 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 		goto retry;
 
 	if (!ibp->smi_ah) {
-		struct ib_ah_attr attr;
 		struct ib_ah *ah;
 
-		memset(&attr, 0, sizeof attr);
-		attr.dlid = be16_to_cpu(IB_LID_PERMISSIVE);
-		attr.port_num = ppd->port;
-		ah = ib_create_ah(ibp->qp0->ibqp.pd, &attr);
+		ah = qib_create_qp0_ah(ibp, be16_to_cpu(IB_LID_PERMISSIVE));
 		if (IS_ERR(ah))
-			ret = -EINVAL;
+			ret = PTR_ERR(ah);
 		else {
 			send_buf->ah = ah;
 			ibp->smi_ah = to_iah(ah);
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 4339021..6e20b58 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
- * All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -90,14 +90,10 @@ static void qib_send_trap(struct qib_ibport *ibp, void *data, unsigned len)
 	if (!ibp->sm_ah) {
 		if (ibp->sm_lid != be16_to_cpu(IB_LID_PERMISSIVE)) {
 			struct ib_ah *ah;
-			struct ib_ah_attr attr;
 
-			memset(&attr, 0, sizeof attr);
-			attr.dlid = ibp->sm_lid;
-			attr.port_num = ppd_from_ibp(ibp)->port;
-			ah = ib_create_ah(ibp->qp0->ibqp.pd, &attr);
+			ah = qib_create_qp0_ah(ibp, ibp->sm_lid);
 			if (IS_ERR(ah))
-				ret = -EINVAL;
+				ret = PTR_ERR(ah);
 			else {
 				send_buf->ah = ah;
 				ibp->sm_ah = to_iah(ah);
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 693041b..4850d03 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
- * All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation.  * All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -250,23 +250,33 @@ static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 
 	spin_lock_irqsave(&dev->qpt_lock, flags);
 
-	if (ibp->qp0 == qp) {
+	if (rcu_dereference_protected(ibp->qp0,
+			lockdep_is_held(&dev->qpt_lock)) == qp) {
 		atomic_dec(&qp->refcount);
 		rcu_assign_pointer(ibp->qp0, NULL);
-	} else if (ibp->qp1 == qp) {
+	} else if (rcu_dereference_protected(ibp->qp1,
+			lockdep_is_held(&dev->qpt_lock)) == qp) {
 		atomic_dec(&qp->refcount);
 		rcu_assign_pointer(ibp->qp1, NULL);
 	} else {
-		struct qib_qp *q, **qpp;
+		struct qib_qp *q;
+		struct qib_qp __rcu **qpp;
 
 		qpp = &dev->qp_table[n];
-		for (; (q = *qpp) != NULL; qpp = &q->next)
+		q = rcu_dereference_protected(*qpp,
+			lockdep_is_held(&dev->qpt_lock));
+		for (; q; qpp = &q->next) {
 			if (q == qp) {
 				atomic_dec(&qp->refcount);
-				rcu_assign_pointer(*qpp, qp->next);
-				qp->next = NULL;
+				*qpp = qp->next;
+				rcu_assign_pointer(qp->next, NULL);
+				q = rcu_dereference_protected(*qpp,
+					lockdep_is_held(&dev->qpt_lock));
 				break;
 			}
+			q = rcu_dereference_protected(*qpp,
+				lockdep_is_held(&dev->qpt_lock));
+		}
 	}
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
@@ -302,10 +312,12 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 
 	spin_lock_irqsave(&dev->qpt_lock, flags);
 	for (n = 0; n < dev->qp_table_size; n++) {
-		qp = dev->qp_table[n];
+		qp = rcu_dereference_protected(dev->qp_table[n],
+			lockdep_is_held(&dev->qpt_lock));
 		rcu_assign_pointer(dev->qp_table[n], NULL);
 
-		for (; qp; qp = qp->next)
+		for (; qp; qp = rcu_dereference_protected(qp->next,
+					lockdep_is_held(&dev->qpt_lock)))
 			qp_inuse++;
 	}
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
@@ -337,7 +349,8 @@ struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
 		unsigned n = qpn_hash(dev, qpn);
 
 		rcu_read_lock();
-		for (qp = dev->qp_table[n]; rcu_dereference(qp); qp = qp->next)
+		for (qp = rcu_dereference(dev->qp_table[n]); qp;
+			qp = rcu_dereference(qp->next))
 			if (qp->ibqp.qp_num == qpn)
 				break;
 	}
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 59cdea3..03ace06 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
- * All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -1845,6 +1845,23 @@ bail:
 	return ret;
 }
 
+struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
+{
+	struct ib_ah_attr attr;
+	struct ib_ah *ah = ERR_PTR(-EINVAL);
+	struct qib_qp *qp0;
+
+	memset(&attr, 0, sizeof attr);
+	attr.dlid = dlid;
+	attr.port_num = ppd_from_ibp(ibp)->port;
+	rcu_read_lock();
+	qp0 = rcu_dereference(ibp->qp0);
+	if (qp0)
+		ah = ib_create_ah(qp0->ibqp.pd, &attr);
+	rcu_read_unlock();
+	return ah;
+}
+
 /**
  * qib_destroy_ah - destroy an address handle
  * @ibah: the AH to destroy
@@ -2060,7 +2077,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	spin_lock_init(&dev->lk_table.lock);
 	dev->lk_table.max = 1 << ib_qib_lkey_table_size;
 	lk_tab_size = dev->lk_table.max * sizeof(*dev->lk_table.table);
-	dev->lk_table.table = (struct qib_mregion **)
+	dev->lk_table.table = (struct qib_mregion __rcu **)
 		__get_free_pages(GFP_KERNEL, get_order(lk_tab_size));
 	if (dev->lk_table.table == NULL) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 1293133..61fad05 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1,6 +1,6 @@
 /*
- * Copyright (c) 2006, 2007, 2008, 2009, 2010 QLogic Corporation.
- * All rights reserved.
+ * Copyright (c) 2012 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2006 - 2012 QLogic Corporation. All rights reserved.
  * Copyright (c) 2005, 2006 PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -420,7 +420,7 @@ struct qib_qp {
 	/* read mostly fields above and below */
 	struct ib_ah_attr remote_ah_attr;
 	struct ib_ah_attr alt_ah_attr;
-	struct qib_qp *next;            /* link list for QPN hash table */
+	struct qib_qp __rcu *next;            /* link list for QPN hash table */
 	struct qib_swqe *s_wq;  /* send work queue */
 	struct qib_mmap_info *ip;
 	struct qib_ib_header *s_hdr;     /* next packet header to send */
@@ -659,8 +659,8 @@ struct qib_opcode_stats {
 };
 
 struct qib_ibport {
-	struct qib_qp *qp0;
-	struct qib_qp *qp1;
+	struct qib_qp __rcu *qp0;
+	struct qib_qp __rcu *qp1;
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
 	struct qib_ah *sm_ah;
 	struct qib_ah *smi_ah;
@@ -743,7 +743,7 @@ struct qib_ibdev {
 	struct list_head memwait;       /* list for wait kernel memory */
 	struct list_head txreq_free;
 	struct timer_list mem_timer;
-	struct qib_qp **qp_table;
+	struct qib_qp __rcu **qp_table;
 	struct qib_pio_header *pio_hdrs;
 	dma_addr_t pio_hdrs_phys;
 	/* list of QPs waiting for RNR timer */
@@ -937,6 +937,8 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 
+struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid);
+
 void qib_rc_rnr_retry(unsigned long arg);
 
 void qib_rc_send_complete(struct qib_qp *qp, struct qib_ib_header *hdr);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
