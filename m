From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/7] IB/qib: qpn lookup optimizations
Date: Fri, 23 Sep 2011 13:16:44 -0400
Message-ID: <20110923171644.14542.12227.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The heavy weight spinlock in qib_lookup_qpn() is replaced with
the RCU locking mechanism.  The hash list itself is now accessed
via jhash functions vs. the mod.

The changes should benefit multiple receive contexts in different
processors by not contending for the lock to just read the hash
structures.

The patch also adds a lookaside_qp (pointer) and a lookaside_qpn
in the context.  The interrupt handler will test the current
packet's qpn against lookaside_qpn if the lookaside_qp pointer
is non-null.  The pointer is NULL'ed when the interrupt
handler exits.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h        |    3 +
 drivers/infiniband/hw/qib/qib_driver.c |    9 ++++
 drivers/infiniband/hw/qib/qib_qp.c     |   77 ++++++++++++++++++++------------
 drivers/infiniband/hw/qib/qib_verbs.c  |   36 ++++++++++-----
 drivers/infiniband/hw/qib/qib_verbs.h  |    3 +
 5 files changed, 87 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 97e6233..b881bdc 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -223,6 +223,9 @@ struct qib_ctxtdata {
 	/* ctxt rcvhdrq head offset */
 	u32 head;
 	u32 pkt_count;
+	/* lookaside fields */
+	struct qib_qp *lookaside_qp;
+	u32 lookaside_qpn;
 	/* QPs waiting for context processing */
 	struct list_head qp_wait_list;
 };
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 89264ff..d35c9d3 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -547,6 +547,15 @@ move_along:
 			updegr = 0;
 		}
 	}
+	/*
+	 * Notify qib_destroy_qp() if it is waiting
+	 * for lookaside_qp to finish.
+	 */
+	if (rcd->lookaside_qp) {
+		if (atomic_dec_and_test(&rcd->lookaside_qp->refcount))
+			wake_up(&rcd->lookaside_qp->wait);
+		rcd->lookaside_qp = NULL;
+	}
 
 	rcd->head = l;
 	rcd->pkt_count += i;
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 9d094f9..500981b 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -34,6 +34,7 @@
 
 #include <linux/err.h>
 #include <linux/vmalloc.h>
+#include <linux/jhash.h>
 
 #include "qib.h"
 
@@ -204,6 +205,13 @@ static void free_qpn(struct qib_qpn_table *qpt, u32 qpn)
 		clear_bit(qpn & BITS_PER_PAGE_MASK, map->page);
 }
 
+static inline unsigned qpn_hash(struct qib_ibdev *dev, u32 qpn)
+{
+	return jhash_1word(qpn, dev->qp_rnd) &
+		(dev->qp_table_size - 1);
+}
+
+
 /*
  * Put the QP into the hash table.
  * The hash table holds a reference to the QP.
@@ -211,22 +219,23 @@ static void free_qpn(struct qib_qpn_table *qpt, u32 qpn)
 static void insert_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 {
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	unsigned n = qp->ibqp.qp_num % dev->qp_table_size;
 	unsigned long flags;
+	unsigned n = qpn_hash(dev, qp->ibqp.qp_num);
 
 	spin_lock_irqsave(&dev->qpt_lock, flags);
+	atomic_inc(&qp->refcount);
 
 	if (qp->ibqp.qp_num == 0)
-		ibp->qp0 = qp;
+		rcu_assign_pointer(ibp->qp0, qp);
 	else if (qp->ibqp.qp_num == 1)
-		ibp->qp1 = qp;
+		rcu_assign_pointer(ibp->qp1, qp);
 	else {
 		qp->next = dev->qp_table[n];
-		dev->qp_table[n] = qp;
+		rcu_assign_pointer(dev->qp_table[n], qp);
 	}
-	atomic_inc(&qp->refcount);
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
+	synchronize_rcu();
 }
 
 /*
@@ -236,29 +245,32 @@ static void insert_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 static void remove_qp(struct qib_ibdev *dev, struct qib_qp *qp)
 {
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	struct qib_qp *q, **qpp;
+	unsigned n = qpn_hash(dev, qp->ibqp.qp_num);
 	unsigned long flags;
 
-	qpp = &dev->qp_table[qp->ibqp.qp_num % dev->qp_table_size];
-
 	spin_lock_irqsave(&dev->qpt_lock, flags);
 
 	if (ibp->qp0 == qp) {
-		ibp->qp0 = NULL;
 		atomic_dec(&qp->refcount);
+		rcu_assign_pointer(ibp->qp0, NULL);
 	} else if (ibp->qp1 == qp) {
-		ibp->qp1 = NULL;
 		atomic_dec(&qp->refcount);
-	} else
+		rcu_assign_pointer(ibp->qp1, NULL);
+	} else {
+		struct qib_qp *q, **qpp;
+
+		qpp = &dev->qp_table[n];
 		for (; (q = *qpp) != NULL; qpp = &q->next)
 			if (q == qp) {
-				*qpp = qp->next;
-				qp->next = NULL;
 				atomic_dec(&qp->refcount);
+				rcu_assign_pointer(*qpp, qp->next);
+				qp->next = NULL;
 				break;
 			}
+	}
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
+	synchronize_rcu();
 }
 
 /**
@@ -280,21 +292,24 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
 
 		if (!qib_mcast_tree_empty(ibp))
 			qp_inuse++;
-		if (ibp->qp0)
+		rcu_read_lock();
+		if (rcu_dereference(ibp->qp0))
 			qp_inuse++;
-		if (ibp->qp1)
+		if (rcu_dereference(ibp->qp1))
 			qp_inuse++;
+		rcu_read_unlock();
 	}
 
 	spin_lock_irqsave(&dev->qpt_lock, flags);
 	for (n = 0; n < dev->qp_table_size; n++) {
 		qp = dev->qp_table[n];
-		dev->qp_table[n] = NULL;
+		rcu_assign_pointer(dev->qp_table[n], NULL);
 
 		for (; qp; qp = qp->next)
 			qp_inuse++;
 	}
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);
+	synchronize_rcu();
 
 	return qp_inuse;
 }
@@ -309,25 +324,28 @@ unsigned qib_free_all_qps(struct qib_devdata *dd)
  */
 struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn)
 {
-	struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
-	unsigned long flags;
-	struct qib_qp *qp;
+	struct qib_qp *qp = NULL;
 
-	spin_lock_irqsave(&dev->qpt_lock, flags);
+	if (unlikely(qpn <= 1)) {
+		rcu_read_lock();
+		if (qpn == 0)
+			qp = rcu_dereference(ibp->qp0);
+		else
+			qp = rcu_dereference(ibp->qp1);
+	} else {
+		struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
+		unsigned n = qpn_hash(dev, qpn);
 
-	if (qpn == 0)
-		qp = ibp->qp0;
-	else if (qpn == 1)
-		qp = ibp->qp1;
-	else
-		for (qp = dev->qp_table[qpn % dev->qp_table_size]; qp;
-		     qp = qp->next)
+		rcu_read_lock();
+		for (qp = dev->qp_table[n]; rcu_dereference(qp); qp = qp->next)
 			if (qp->ibqp.qp_num == qpn)
 				break;
+	}
 	if (qp)
-		atomic_inc(&qp->refcount);
+		if (unlikely(!atomic_inc_not_zero(&qp->refcount)))
+			qp = NULL;
 
-	spin_unlock_irqrestore(&dev->qpt_lock, flags);
+	rcu_read_unlock();
 	return qp;
 }
 
@@ -1015,6 +1033,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 			ret = ERR_PTR(-ENOMEM);
 			goto bail_swq;
 		}
+		RCU_INIT_POINTER(qp->next, NULL);
 		if (init_attr->srq)
 			sz = 0;
 		else {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 9fab404..9627cb7 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -38,11 +38,12 @@
 #include <linux/utsname.h>
 #include <linux/rculist.h>
 #include <linux/mm.h>
+#include <linux/random.h>
 
 #include "qib.h"
 #include "qib_common.h"
 
-static unsigned int ib_qib_qp_table_size = 251;
+static unsigned int ib_qib_qp_table_size = 256;
 module_param_named(qp_table_size, ib_qib_qp_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(qp_table_size, "QP table size");
 
@@ -659,17 +660,25 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 		if (atomic_dec_return(&mcast->refcount) <= 1)
 			wake_up(&mcast->wait);
 	} else {
-		qp = qib_lookup_qpn(ibp, qp_num);
-		if (!qp)
-			goto drop;
+		if (rcd->lookaside_qp) {
+			if (rcd->lookaside_qpn != qp_num) {
+				if (atomic_dec_and_test(
+					&rcd->lookaside_qp->refcount))
+					wake_up(
+					 &rcd->lookaside_qp->wait);
+					rcd->lookaside_qp = NULL;
+				}
+		}
+		if (!rcd->lookaside_qp) {
+			qp = qib_lookup_qpn(ibp, qp_num);
+			if (!qp)
+				goto drop;
+			rcd->lookaside_qp = qp;
+			rcd->lookaside_qpn = qp_num;
+		} else
+			qp = rcd->lookaside_qp;
 		ibp->n_unicast_rcv++;
 		qib_qp_rcv(rcd, hdr, lnh == QIB_LRH_GRH, data, tlen, qp);
-		/*
-		 * Notify qib_destroy_qp() if it is waiting
-		 * for us to finish.
-		 */
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
 	}
 	return;
 
@@ -1974,6 +1983,8 @@ static void init_ibport(struct qib_pportdata *ppd)
 	ibp->z_excessive_buffer_overrun_errors =
 		cntrs.excessive_buffer_overrun_errors;
 	ibp->z_vl15_dropped = cntrs.vl15_dropped;
+	RCU_INIT_POINTER(ibp->qp0, NULL);
+	RCU_INIT_POINTER(ibp->qp1, NULL);
 }
 
 /**
@@ -1990,12 +2001,15 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	int ret;
 
 	dev->qp_table_size = ib_qib_qp_table_size;
-	dev->qp_table = kzalloc(dev->qp_table_size * sizeof *dev->qp_table,
+	get_random_bytes(&dev->qp_rnd, sizeof(dev->qp_rnd));
+	dev->qp_table = kmalloc(dev->qp_table_size * sizeof *dev->qp_table,
 				GFP_KERNEL);
 	if (!dev->qp_table) {
 		ret = -ENOMEM;
 		goto err_qpt;
 	}
+	for (i = 0; i < dev->qp_table_size; i++)
+		RCU_INIT_POINTER(dev->qp_table[i], NULL);
 
 	for (i = 0; i < dd->num_pports; i++)
 		init_ibport(ppd + i);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index ec3711f..d7b6109 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -724,7 +724,8 @@ struct qib_ibdev {
 	dma_addr_t pio_hdrs_phys;
 	/* list of QPs waiting for RNR timer */
 	spinlock_t pending_lock; /* protect wait lists, PMA counters, etc. */
-	unsigned qp_table_size; /* size of the hash table */
+	u32 qp_table_size; /* size of the hash table */
+	u32 qp_rnd; /* random bytes for hash */
 	spinlock_t qpt_lock;
 
 	u32 n_piowait;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
