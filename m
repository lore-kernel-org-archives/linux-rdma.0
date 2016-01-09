From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 18/27] IB/hfi1: Remove qpdev and qpn table from hfi1
Date: Sat, 09 Jan 2016 07:18:18 -0800
Message-ID: <20160109151818.30800.67035.stgit@scvm10.sc.intel.com>
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

Another change on the way to removing queue pair functionality from
hfi1. This patch removes the private queue pair structure and the table
which holds the queue pair numbers in favor of using what is provided
by rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qp.c    |  147 +++++++++++++++++++------------------
 drivers/staging/rdma/hfi1/qp.h    |   38 +---------
 drivers/staging/rdma/hfi1/verbs.h |    3 -
 3 files changed, 78 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 6b38c8a..a2d9501 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -60,9 +60,6 @@
 #include "trace.h"
 #include "sdma.h"
 
-#define BITS_PER_PAGE           (PAGE_SIZE*BITS_PER_BYTE)
-#define BITS_PER_PAGE_MASK      (BITS_PER_PAGE-1)
-
 static unsigned int hfi1_qp_table_size = 256;
 module_param_named(qp_table_size, hfi1_qp_table_size, uint, S_IRUGO);
 MODULE_PARM_DESC(qp_table_size, "QP table size");
@@ -75,10 +72,10 @@ static int iowait_sleep(
 	unsigned seq);
 static void iowait_wakeup(struct iowait *wait, int reason);
 
-static inline unsigned mk_qpn(struct hfi1_qpn_table *qpt,
-			      struct qpn_map *map, unsigned off)
+static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
+			      struct rvt_qpn_map *map, unsigned off)
 {
-	return (map - qpt->map) * BITS_PER_PAGE + off;
+	return (map - qpt->map) * RVT_BITS_PER_PAGE + off;
 }
 
 /*
@@ -118,7 +115,7 @@ static const u16 credit_table[31] = {
 	32768                   /* 1E */
 };
 
-static void get_map_page(struct hfi1_qpn_table *qpt, struct qpn_map *map)
+static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
 {
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 
@@ -138,11 +135,11 @@ static void get_map_page(struct hfi1_qpn_table *qpt, struct qpn_map *map)
  * Allocate the next available QPN or
  * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
  */
-static int alloc_qpn(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt,
+static int alloc_qpn(struct hfi1_devdata *dd, struct rvt_qpn_table *qpt,
 		     enum ib_qp_type type, u8 port)
 {
 	u32 i, offset, max_scan, qpn;
-	struct qpn_map *map;
+	struct rvt_qpn_map *map;
 	u32 ret;
 
 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
@@ -160,11 +157,11 @@ static int alloc_qpn(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt,
 	}
 
 	qpn = qpt->last + qpt->incr;
-	if (qpn >= QPN_MAX)
+	if (qpn >= RVT_QPN_MAX)
 		qpn = qpt->incr | ((qpt->last & 1) ^ 1);
 	/* offset carries bit 0 */
-	offset = qpn & BITS_PER_PAGE_MASK;
-	map = &qpt->map[qpn / BITS_PER_PAGE];
+	offset = qpn & RVT_BITS_PER_PAGE_MASK;
+	map = &qpt->map[qpn / RVT_BITS_PER_PAGE];
 	max_scan = qpt->nmaps - !offset;
 	for (i = 0;;) {
 		if (unlikely(!map->page)) {
@@ -180,18 +177,19 @@ static int alloc_qpn(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt,
 			}
 			offset += qpt->incr;
 			/*
-			 * This qpn might be bogus if offset >= BITS_PER_PAGE.
-			 * That is OK.   It gets re-assigned below
+			 * This qpn might be bogus if offset >=
+			 * RVT_BITS_PER_PAGE.  That is OK.   It gets re-assigned
+			 * below
 			 */
 			qpn = mk_qpn(qpt, map, offset);
-		} while (offset < BITS_PER_PAGE && qpn < QPN_MAX);
+		} while (offset < RVT_BITS_PER_PAGE && qpn < RVT_QPN_MAX);
 		/*
 		 * In order to keep the number of pages allocated to a
 		 * minimum, we scan the all existing pages before increasing
 		 * the size of the bitmap table.
 		 */
 		if (++i > max_scan) {
-			if (qpt->nmaps == QPNMAP_ENTRIES)
+			if (qpt->nmaps == RVT_QPNMAP_ENTRIES)
 				break;
 			map = &qpt->map[qpt->nmaps++];
 			/* start at incr with current bit 0 */
@@ -216,13 +214,13 @@ bail:
 	return ret;
 }
 
-static void free_qpn(struct hfi1_qpn_table *qpt, u32 qpn)
+static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 {
-	struct qpn_map *map;
+	struct rvt_qpn_map *map;
 
-	map = qpt->map + qpn / BITS_PER_PAGE;
+	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
 	if (map->page)
-		clear_bit(qpn & BITS_PER_PAGE_MASK, map->page);
+		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
 }
 
 /*
@@ -235,19 +233,19 @@ static void insert_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 	unsigned long flags;
 
 	atomic_inc(&qp->refcount);
-	spin_lock_irqsave(&dev->qp_dev->qpt_lock, flags);
+	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
 
 	if (qp->ibqp.qp_num <= 1) {
 		rcu_assign_pointer(ibp->rvp.qp[qp->ibqp.qp_num], qp);
 	} else {
-		u32 n = qpn_hash(dev->qp_dev, qp->ibqp.qp_num);
+		u32 n = qpn_hash(dev->rdi.qp_dev, qp->ibqp.qp_num);
 
-		qp->next = dev->qp_dev->qp_table[n];
-		rcu_assign_pointer(dev->qp_dev->qp_table[n], qp);
+		qp->next = dev->rdi.qp_dev->qp_table[n];
+		rcu_assign_pointer(dev->rdi.qp_dev->qp_table[n], qp);
 		trace_hfi1_qpinsert(qp, n);
 	}
 
-	spin_unlock_irqrestore(&dev->qp_dev->qpt_lock, flags);
+	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
 }
 
 /*
@@ -257,40 +255,40 @@ static void insert_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 static void remove_qp(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 {
 	struct hfi1_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
-	u32 n = qpn_hash(dev->qp_dev, qp->ibqp.qp_num);
+	u32 n = qpn_hash(dev->rdi.qp_dev, qp->ibqp.qp_num);
 	unsigned long flags;
 	int removed = 1;
 
-	spin_lock_irqsave(&dev->qp_dev->qpt_lock, flags);
+	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
 
 	if (rcu_dereference_protected(ibp->rvp.qp[0],
 				      lockdep_is_held(
-				      &dev->qp_dev->qpt_lock)) == qp) {
+				      &dev->rdi.qp_dev->qpt_lock)) == qp) {
 		RCU_INIT_POINTER(ibp->rvp.qp[0], NULL);
 	} else if (rcu_dereference_protected(ibp->rvp.qp[1],
-			lockdep_is_held(&dev->qp_dev->qpt_lock)) == qp) {
+			lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)) == qp) {
 		RCU_INIT_POINTER(ibp->rvp.qp[1], NULL);
 	} else {
 		struct rvt_qp *q;
 		struct rvt_qp __rcu **qpp;
 
 		removed = 0;
-		qpp = &dev->qp_dev->qp_table[n];
+		qpp = &dev->rdi.qp_dev->qp_table[n];
 		for (; (q = rcu_dereference_protected(*qpp,
-				lockdep_is_held(&dev->qp_dev->qpt_lock)))
+				lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)))
 					!= NULL;
 				qpp = &q->next)
 			if (q == qp) {
 				RCU_INIT_POINTER(*qpp,
 				 rcu_dereference_protected(qp->next,
-				 lockdep_is_held(&dev->qp_dev->qpt_lock)));
+				 lockdep_is_held(&dev->rdi.qp_dev->qpt_lock)));
 				removed = 1;
 				trace_hfi1_qpremove(qp, n);
 				break;
 			}
 	}
 
-	spin_unlock_irqrestore(&dev->qp_dev->qpt_lock, flags);
+	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
 	if (removed) {
 		synchronize_rcu();
 		if (atomic_dec_and_test(&qp->refcount))
@@ -311,6 +309,7 @@ static unsigned free_all_qps(struct hfi1_devdata *dd)
 	unsigned long flags;
 	struct rvt_qp *qp;
 	unsigned n, qp_inuse = 0;
+	spinlock_t *l; /* useless pointer to shutup checkpatch */
 
 	for (n = 0; n < dd->num_pports; n++) {
 		struct hfi1_ibport *ibp = &dd->pport[n].ibport_data;
@@ -325,19 +324,20 @@ static unsigned free_all_qps(struct hfi1_devdata *dd)
 		rcu_read_unlock();
 	}
 
-	if (!dev->qp_dev)
+	if (!dev->rdi.qp_dev)
 		goto bail;
-	spin_lock_irqsave(&dev->qp_dev->qpt_lock, flags);
-	for (n = 0; n < dev->qp_dev->qp_table_size; n++) {
-		qp = rcu_dereference_protected(dev->qp_dev->qp_table[n],
-			lockdep_is_held(&dev->qp_dev->qpt_lock));
-		RCU_INIT_POINTER(dev->qp_dev->qp_table[n], NULL);
+	spin_lock_irqsave(&dev->rdi.qp_dev->qpt_lock, flags);
+	for (n = 0; n < dev->rdi.qp_dev->qp_table_size; n++) {
+		l = &dev->rdi.qp_dev->qpt_lock;
+		qp = rcu_dereference_protected(dev->rdi.qp_dev->qp_table[n],
+					       lockdep_is_held(l));
+		RCU_INIT_POINTER(dev->rdi.qp_dev->qp_table[n], NULL);
 
 		for (; qp; qp = rcu_dereference_protected(qp->next,
-				lockdep_is_held(&dev->qp_dev->qpt_lock)))
+							  lockdep_is_held(l)))
 			qp_inuse++;
 	}
-	spin_unlock_irqrestore(&dev->qp_dev->qpt_lock, flags);
+	spin_unlock_irqrestore(&dev->rdi.qp_dev->qpt_lock, flags);
 	synchronize_rcu();
 bail:
 	return qp_inuse;
@@ -1140,7 +1140,8 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
 		dev = to_idev(ibpd->device);
 		dd = dd_from_dev(dev);
-		err = alloc_qpn(dd, &dev->qp_dev->qpn_table, init_attr->qp_type,
+		err = alloc_qpn(dd, &dev->rdi.qp_dev->qpn_table,
+				init_attr->qp_type,
 				init_attr->port_num);
 		if (err < 0) {
 			ret = ERR_PTR(err);
@@ -1242,7 +1243,7 @@ bail_ip:
 		kref_put(&qp->ip->ref, rvt_release_mmap_info);
 	else
 		vfree(qp->r_rq.wq);
-	free_qpn(&dev->qp_dev->qpn_table, qp->ibqp.qp_num);
+	free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
 bail_qp:
 	kfree(priv->s_hdr);
 	kfree(priv);
@@ -1293,7 +1294,7 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 	spin_unlock_irq(&qp->r_lock);
 
 	/* all user's cleaned up, mark it available */
-	free_qpn(&dev->qp_dev->qpn_table, qp->ibqp.qp_num);
+	free_qpn(&dev->rdi.qp_dev->qpn_table, qp->ibqp.qp_num);
 	spin_lock(&dev->n_qps_lock);
 	dev->n_qps_allocated--;
 	spin_unlock(&dev->n_qps_lock);
@@ -1313,10 +1314,10 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
  * init_qpn_table - initialize the QP number table for a device
  * @qpt: the QPN table
  */
-static int init_qpn_table(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt)
+static int init_qpn_table(struct hfi1_devdata *dd, struct rvt_qpn_table *qpt)
 {
 	u32 offset, qpn, i;
-	struct qpn_map *map;
+	struct rvt_qpn_map *map;
 	int ret = 0;
 
 	spin_lock_init(&qpt->lock);
@@ -1326,9 +1327,9 @@ static int init_qpn_table(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt)
 
 	/* insure we don't assign QPs from KDETH 64K window */
 	qpn = kdeth_qp << 16;
-	qpt->nmaps = qpn / BITS_PER_PAGE;
+	qpt->nmaps = qpn / RVT_BITS_PER_PAGE;
 	/* This should always be zero */
-	offset = qpn & BITS_PER_PAGE_MASK;
+	offset = qpn & RVT_BITS_PER_PAGE_MASK;
 	map = &qpt->map[qpt->nmaps];
 	dd_dev_info(dd, "Reserving QPNs for KDETH window from 0x%x to 0x%x\n",
 		qpn, qpn + 65535);
@@ -1342,7 +1343,7 @@ static int init_qpn_table(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt)
 		}
 		set_bit(offset, map->page);
 		offset++;
-		if (offset == BITS_PER_PAGE) {
+		if (offset == RVT_BITS_PER_PAGE) {
 			/* next page */
 			qpt->nmaps++;
 			map++;
@@ -1356,7 +1357,7 @@ static int init_qpn_table(struct hfi1_devdata *dd, struct hfi1_qpn_table *qpt)
  * free_qpn_table - free the QP number table for a device
  * @qpt: the QPN table
  */
-static void free_qpn_table(struct hfi1_qpn_table *qpt)
+static void free_qpn_table(struct rvt_qpn_table *qpt)
 {
 	int i;
 
@@ -1488,31 +1489,31 @@ int hfi1_qp_init(struct hfi1_ibdev *dev)
 	int ret = -ENOMEM;
 
 	/* allocate parent object */
-	dev->qp_dev = kzalloc(sizeof(*dev->qp_dev), GFP_KERNEL);
-	if (!dev->qp_dev)
+	dev->rdi.qp_dev = kzalloc(sizeof(*dev->rdi.qp_dev), GFP_KERNEL);
+	if (!dev->rdi.qp_dev)
 		goto nomem;
 	/* allocate hash table */
-	dev->qp_dev->qp_table_size = hfi1_qp_table_size;
-	dev->qp_dev->qp_table_bits = ilog2(hfi1_qp_table_size);
-	dev->qp_dev->qp_table =
-		kmalloc(dev->qp_dev->qp_table_size *
-				sizeof(*dev->qp_dev->qp_table),
+	dev->rdi.qp_dev->qp_table_size = hfi1_qp_table_size;
+	dev->rdi.qp_dev->qp_table_bits = ilog2(hfi1_qp_table_size);
+	dev->rdi.qp_dev->qp_table =
+		kmalloc(dev->rdi.qp_dev->qp_table_size *
+				sizeof(*dev->rdi.qp_dev->qp_table),
 			GFP_KERNEL);
-	if (!dev->qp_dev->qp_table)
+	if (!dev->rdi.qp_dev->qp_table)
 		goto nomem;
-	for (i = 0; i < dev->qp_dev->qp_table_size; i++)
-		RCU_INIT_POINTER(dev->qp_dev->qp_table[i], NULL);
-	spin_lock_init(&dev->qp_dev->qpt_lock);
+	for (i = 0; i < dev->rdi.qp_dev->qp_table_size; i++)
+		RCU_INIT_POINTER(dev->rdi.qp_dev->qp_table[i], NULL);
+	spin_lock_init(&dev->rdi.qp_dev->qpt_lock);
 	/* initialize qpn map */
-	ret = init_qpn_table(dd, &dev->qp_dev->qpn_table);
+	ret = init_qpn_table(dd, &dev->rdi.qp_dev->qpn_table);
 	if (ret)
 		goto nomem;
 	return ret;
 nomem:
-	if (dev->qp_dev) {
-		kfree(dev->qp_dev->qp_table);
-		free_qpn_table(&dev->qp_dev->qpn_table);
-		kfree(dev->qp_dev);
+	if (dev->rdi.qp_dev) {
+		kfree(dev->rdi.qp_dev->qp_table);
+		free_qpn_table(&dev->rdi.qp_dev->qpn_table);
+		kfree(dev->rdi.qp_dev);
 	}
 	return ret;
 }
@@ -1526,10 +1527,10 @@ void hfi1_qp_exit(struct hfi1_ibdev *dev)
 	if (qps_inuse)
 		dd_dev_err(dd, "QP memory leak! %u still in use\n",
 			   qps_inuse);
-	if (dev->qp_dev) {
-		kfree(dev->qp_dev->qp_table);
-		free_qpn_table(&dev->qp_dev->qpn_table);
-		kfree(dev->qp_dev);
+	if (dev->rdi.qp_dev) {
+		kfree(dev->rdi.qp_dev->qp_table);
+		free_qpn_table(&dev->rdi.qp_dev->qpn_table);
+		kfree(dev->rdi.qp_dev);
 	}
 }
 
@@ -1605,11 +1606,11 @@ int qp_iter_next(struct qp_iter *iter)
 	 *
 	 * n = 0..iter->specials is the special qp indices
 	 *
-	 * n = iter->specials..dev->qp_dev->qp_table_size+iter->specials are
+	 * n = iter->specials..dev->rdi.qp_dev->qp_table_size+iter->specials are
 	 * the potential hash bucket entries
 	 *
 	 */
-	for (; n <  dev->qp_dev->qp_table_size + iter->specials; n++) {
+	for (; n <  dev->rdi.qp_dev->qp_table_size + iter->specials; n++) {
 		if (pqp) {
 			qp = rcu_dereference(pqp->next);
 		} else {
@@ -1628,7 +1629,7 @@ int qp_iter_next(struct qp_iter *iter)
 					qp = rcu_dereference(ibp->rvp.qp[1]);
 			} else {
 				qp = rcu_dereference(
-					dev->qp_dev->qp_table[
+					dev->rdi.qp_dev->qp_table[
 						(n - iter->specials)]);
 			}
 		}
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index e806bc0..ffc6130 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -51,41 +51,11 @@
  */
 
 #include <linux/hash.h>
+#include <rdma/rdmavt_qp.h>
 #include "verbs.h"
 #include "sdma.h"
 
-#define QPN_MAX                 (1 << 24)
-#define QPNMAP_ENTRIES          (QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
-
-/*
- * QPN-map pages start out as NULL, they get allocated upon
- * first use and are never deallocated. This way,
- * large bitmaps are not allocated unless large numbers of QPs are used.
- */
-struct qpn_map {
-	void *page;
-};
-
-struct hfi1_qpn_table {
-	spinlock_t lock; /* protect changes in this struct */
-	unsigned flags;         /* flags for QP0/1 allocated for each port */
-	u32 last;               /* last QP number allocated */
-	u32 nmaps;              /* size of the map table */
-	u16 limit;
-	u8  incr;
-	/* bit map of free QP numbers other than 0/1 */
-	struct qpn_map map[QPNMAP_ENTRIES];
-};
-
-struct hfi1_qp_ibdev {
-	u32 qp_table_size;
-	u32 qp_table_bits;
-	struct rvt_qp __rcu **qp_table;
-	spinlock_t qpt_lock;
-	struct hfi1_qpn_table qpn_table;
-};
-
-static inline u32 qpn_hash(struct hfi1_qp_ibdev *dev, u32 qpn)
+static inline u32 qpn_hash(struct rvt_qp_ibdev *dev, u32 qpn)
 {
 	return hash_32(qpn, dev->qp_table_bits);
 }
@@ -107,9 +77,9 @@ static inline struct rvt_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
 		qp = rcu_dereference(ibp->rvp.qp[qpn]);
 	} else {
 		struct hfi1_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
-		u32 n = qpn_hash(dev->qp_dev, qpn);
+		u32 n = qpn_hash(dev->rdi.qp_dev, qpn);
 
-		for (qp = rcu_dereference(dev->qp_dev->qp_table[n]); qp;
+		for (qp = rcu_dereference(dev->rdi.qp_dev->qp_table[n]); qp;
 			qp = rcu_dereference(qp->next))
 			if (qp->ibqp.qp_num == qpn)
 				break;
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index 0349735..6621277 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -334,12 +334,9 @@ struct hfi1_ibport {
 	u8 sc_to_sl[32];
 };
 
-struct hfi1_qp_ibdev;
 struct hfi1_ibdev {
 	struct rvt_dev_info rdi; /* Must be first */
 
-	struct hfi1_qp_ibdev *qp_dev;
-
 	/* QP numbers are shared by all IB ports */
 	/* protect wait lists */
 	seqlock_t iowait_lock;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
