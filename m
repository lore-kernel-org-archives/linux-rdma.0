From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 34/36] IB/rdmavt: Initialize and teardown of qpn table
Date: Wed, 06 Jan 2016 10:04:46 -0800
Message-ID: <20160106180436.8747.79638.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add table init as well as teardown for handling qpn maps. Drivers can still
provide this functionality by setting the QP_INIT_DRIVER bit.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |  197 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/qp.h |    2 
 drivers/infiniband/sw/rdmavt/vt.c |   35 ++++---
 include/rdma/rdma_vt.h            |    9 ++
 include/rdma/rdmavt_qp.h          |   33 ++++++
 5 files changed, 263 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 23a5f68..17dd6ab 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -45,8 +45,205 @@
  *
  */
 
+#include <linux/bitops.h>
+#include <linux/lockdep.h>
+#include "vt.h"
 #include "qp.h"
 
+static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map)
+{
+	unsigned long page = get_zeroed_page(GFP_KERNEL);
+
+	/*
+	 * Free the page if someone raced with us installing it.
+	 */
+
+	spin_lock(&qpt->lock);
+	if (map->page)
+		free_page(page);
+	else
+		map->page = (void *)page;
+	spin_unlock(&qpt->lock);
+}
+
+/**
+ * init_qpn_table - initialize the QP number table for a device
+ * @qpt: the QPN table
+ */
+static int init_qpn_table(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt)
+{
+	u32 offset, i;
+	struct rvt_qpn_map *map;
+	int ret = 0;
+
+	if (!(rdi->dparms.qpn_res_end > rdi->dparms.qpn_res_start))
+		return -EINVAL;
+
+	spin_lock_init(&qpt->lock);
+
+	qpt->last = rdi->dparms.qpn_start;
+	qpt->incr = rdi->dparms.qpn_inc << rdi->dparms.qos_shift;
+
+	/*
+	 * Drivers may want some QPs beyond what we need for verbs let them use
+	 * our qpn table. No need for two. Lets go ahead and mark the bitmaps
+	 * for those. The reserved range must be *after* the range which verbs
+	 * will pick from.
+	 */
+
+	/* Figure out number of bit maps needed before reserved range */
+	qpt->nmaps = rdi->dparms.qpn_res_start / RVT_BITS_PER_PAGE;
+
+	/* This should always be zero */
+	offset = rdi->dparms.qpn_res_start & RVT_BITS_PER_PAGE_MASK;
+
+	/* Starting with the first reserved bit map */
+	map = &qpt->map[qpt->nmaps];
+
+	rvt_pr_info(rdi, "Reserving QPNs from 0x%x to 0x%x for non-verbs use\n",
+		    rdi->dparms.qpn_res_start, rdi->dparms.qpn_res_end);
+	for (i = rdi->dparms.qpn_res_start; i < rdi->dparms.qpn_res_end; i++) {
+		if (!map->page) {
+			get_map_page(qpt, map);
+			if (!map->page) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
+		set_bit(offset, map->page);
+		offset++;
+		if (offset == RVT_BITS_PER_PAGE) {
+			/* next page */
+			qpt->nmaps++;
+			map++;
+			offset = 0;
+		}
+	}
+	return ret;
+}
+
+/**
+ * free_qpn_table - free the QP number table for a device
+ * @qpt: the QPN table
+ */
+static void free_qpn_table(struct rvt_qpn_table *qpt)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(qpt->map); i++)
+		free_page((unsigned long)qpt->map[i].page);
+}
+
+int rvt_driver_qp_init(struct rvt_dev_info *rdi)
+{
+	int i;
+	int ret = -ENOMEM;
+
+	if (rdi->flags & RVT_FLAG_QP_INIT_DRIVER) {
+		rvt_pr_info(rdi, "Driver is doing QP init.\n");
+		return 0;
+	}
+
+	if (!rdi->dparms.qp_table_size)
+		return -EINVAL;
+
+	/*
+	 * If driver is not doing any QP allocation then make sure it is
+	 * providing the necessary QP functions.
+	 */
+	if (!rdi->driver_f.free_all_qps)
+		return -EINVAL;
+
+	/* allocate parent object */
+	rdi->qp_dev = kzalloc(sizeof(*rdi->qp_dev), GFP_KERNEL);
+	if (!rdi->qp_dev)
+		return -ENOMEM;
+
+	/* allocate hash table */
+	rdi->qp_dev->qp_table_size = rdi->dparms.qp_table_size;
+	rdi->qp_dev->qp_table_bits = ilog2(rdi->dparms.qp_table_size);
+	rdi->qp_dev->qp_table =
+		kmalloc(rdi->qp_dev->qp_table_size *
+			sizeof(*rdi->qp_dev->qp_table),
+			GFP_KERNEL);
+	if (!rdi->qp_dev->qp_table)
+		goto no_qp_table;
+
+	for (i = 0; i < rdi->qp_dev->qp_table_size; i++)
+		RCU_INIT_POINTER(rdi->qp_dev->qp_table[i], NULL);
+
+	spin_lock_init(&rdi->qp_dev->qpt_lock);
+
+	/* initialize qpn map */
+	if (init_qpn_table(rdi, &rdi->qp_dev->qpn_table))
+		goto fail_table;
+
+	return ret;
+
+fail_table:
+	kfree(rdi->qp_dev->qp_table);
+	free_qpn_table(&rdi->qp_dev->qpn_table);
+
+no_qp_table:
+	kfree(rdi->qp_dev);
+
+	return ret;
+}
+
+/**
+ * free_all_qps - check for QPs still in use
+ * @qpt: the QP table to empty
+ *
+ * There should not be any QPs still in use.
+ * Free memory for table.
+ */
+static unsigned free_all_qps(struct rvt_dev_info *rdi)
+{
+	unsigned long flags;
+	struct rvt_qp *qp;
+	unsigned n, qp_inuse = 0;
+	spinlock_t *ql; /* work around too long line below */
+
+	rdi->driver_f.free_all_qps(rdi);
+
+	if (!rdi->qp_dev)
+		return 0;
+
+	ql = &rdi->qp_dev->qpt_lock;
+	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
+	for (n = 0; n < rdi->qp_dev->qp_table_size; n++) {
+		qp = rcu_dereference_protected(rdi->qp_dev->qp_table[n],
+					       lockdep_is_held(ql));
+		RCU_INIT_POINTER(rdi->qp_dev->qp_table[n], NULL);
+		qp =  rcu_dereference_protected(qp->next,
+						lockdep_is_held(ql));
+		while (qp) {
+			qp_inuse++;
+			qp =  rcu_dereference_protected(qp->next,
+							lockdep_is_held(ql));
+		}
+	}
+	spin_unlock_irqrestore(ql, flags);
+	synchronize_rcu();
+	return qp_inuse;
+}
+
+void rvt_qp_exit(struct rvt_dev_info *rdi)
+{
+	u32 qps_inuse = free_all_qps(rdi);
+
+	qps_inuse = free_all_qps(rdi);
+	if (qps_inuse)
+		rvt_pr_err(rdi, "QP memory leak! %u still in use\n",
+			   qps_inuse);
+	if (!rdi->qp_dev)
+		return;
+
+	kfree(rdi->qp_dev->qp_table);
+	free_qpn_table(&rdi->qp_dev->qpn_table);
+	kfree(rdi->qp_dev);
+}
+
 /**
  * rvt_create_qp - create a queue pair for a device
  * @ibpd: the protection domain who's device we create the queue pair for
diff --git a/drivers/infiniband/sw/rdmavt/qp.h b/drivers/infiniband/sw/rdmavt/qp.h
index 9c2999d..f438809 100644
--- a/drivers/infiniband/sw/rdmavt/qp.h
+++ b/drivers/infiniband/sw/rdmavt/qp.h
@@ -50,6 +50,8 @@
 
 #include <rdma/rdma_vt.h>
 
+int rvt_driver_qp_init(struct rvt_dev_info *rdi);
+void rvt_qp_exit(struct rvt_dev_info *rdi);
 struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata);
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 44de280..f2d995d 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -223,9 +223,23 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	    (!rdi->driver_f.get_card_name) ||
 	    (!rdi->driver_f.get_pci_dev) ||
 	    (!rdi->driver_f.check_ah)) {
+		pr_err("Driver not supporting req func\n");
 		return -EINVAL;
 	}
 
+	if (!rdi->dparms.nports) {
+		rvt_pr_err(rdi, "Driver says it has no ports.\n");
+		return -EINVAL;
+	}
+
+	rdi->ports = kcalloc(rdi->dparms.nports,
+			     sizeof(struct rvt_ibport **),
+			     GFP_KERNEL);
+	if (!rdi->ports) {
+		rvt_pr_err(rdi, "Could not allocate port mem.\n");
+		return -ENOMEM;
+	}
+
 	/* Once we get past here we can use the rvt_pr macros */
 
 	/* Dev Ops */
@@ -240,6 +254,12 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, get_port_immutable);
 
 	/* Queue Pairs */
+	ret = rvt_driver_qp_init(rdi);
+	if (ret) {
+		pr_err("Error in driver QP init.\n");
+		return -EINVAL;
+	}
+
 	CHECK_DRIVER_OVERRIDE(rdi, create_qp);
 	CHECK_DRIVER_OVERRIDE(rdi, modify_qp);
 	CHECK_DRIVER_OVERRIDE(rdi, destroy_qp);
@@ -300,19 +320,6 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 
-	if (rdi->dparms.nports) {
-		rdi->ports = kcalloc(rdi->dparms.nports,
-				     sizeof(struct rvt_ibport **),
-				     GFP_KERNEL);
-		if (!rdi->ports) {
-			rvt_pr_err(rdi, "Could not allocate port mem.\n");
-			ret = -ENOMEM;
-			goto bail_mr;
-		}
-	} else {
-		rvt_pr_warn(rdi, "Driver says it has no ports.\n");
-	}
-
 	/* We are now good to announce we exist */
 	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 	if (ret) {
@@ -327,6 +334,8 @@ bail_mr:
 	rvt_mr_exit(rdi);
 
 bail_no_mr:
+	rvt_qp_exit(rdi);
+
 	return ret;
 }
 EXPORT_SYMBOL(rvt_register_device);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 79da8ee..950c291 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -172,7 +172,13 @@ struct rvt_driver_params {
 	 * For instance special module parameters. Goes here.
 	 */
 	unsigned int lkey_table_size;
+	unsigned int qp_table_size;
+	int qpn_start;
+	int qpn_inc;
+	int qpn_res_start;
+	int qpn_res_end;
 	int nports;
+	u8 qos_shift;
 };
 
 /* Protection domain */
@@ -205,6 +211,7 @@ struct rvt_driver_provided {
 	int (*port_callback)(struct ib_device *, u8, struct kobject *);
 	const char * (*get_card_name)(struct rvt_dev_info *rdi);
 	struct pci_dev * (*get_pci_dev)(struct rvt_dev_info *rdi);
+	void (*free_all_qps)(struct rvt_dev_info *rdi);
 
 	/*--------------------*/
 	/* Optional functions */
@@ -245,6 +252,8 @@ struct rvt_dev_info {
 
 	int flags;
 	struct rvt_ibport **ports;
+
+	struct rvt_qp_ibdev *qp_dev;
 };
 
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index f33fbb0..e6a7d17 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -259,4 +259,37 @@ struct rvt_srq {
 	u32 limit;
 };
 
+#define RVT_QPN_MAX                 BIT(24)
+#define RVT_QPNMAP_ENTRIES          (RVT_QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
+#define RVT_BITS_PER_PAGE           (PAGE_SIZE * BITS_PER_BYTE)
+#define RVT_BITS_PER_PAGE_MASK      (RVT_BITS_PER_PAGE - 1)
+
+/*
+ * QPN-map pages start out as NULL, they get allocated upon
+ * first use and are never deallocated. This way,
+ * large bitmaps are not allocated unless large numbers of QPs are used.
+ */
+struct rvt_qpn_map {
+	void *page;
+};
+
+struct rvt_qpn_table {
+	spinlock_t lock; /* protect changes to the qp table */
+	unsigned flags;         /* flags for QP0/1 allocated for each port */
+	u32 last;               /* last QP number allocated */
+	u32 nmaps;              /* size of the map table */
+	u16 limit;
+	u8  incr;
+	/* bit map of free QP numbers other than 0/1 */
+	struct rvt_qpn_map map[RVT_QPNMAP_ENTRIES];
+};
+
+struct rvt_qp_ibdev {
+	u32 qp_table_size;
+	u32 qp_table_bits;
+	struct rvt_qp __rcu **qp_table;
+	spinlock_t qpt_lock; /* qptable lock */
+	struct rvt_qpn_table qpn_table;
+};
+
 #endif          /* DEF_RDMAVT_INCQP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
