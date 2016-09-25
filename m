From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/13] IB/qib: Remove qpt_mask global
Date: Sun, 25 Sep 2016 07:41:05 -0700
Message-ID: <20160925144103.10261.93552.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no need to have a global qpt_mask as that does not support the
multiple chip model which qib has. Instead rely on the value which
exists already in the device data (dd).

Fixes: 898fa52b4ac3 "IB/qib: Remove qpn, qp tables and related variables from qib"
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h       |    1 -
 drivers/infiniband/hw/qib/qib_qp.c    |   13 +++----------
 drivers/infiniband/hw/qib/qib_verbs.c |    2 --
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index bebc9a5..a3e21a2 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1132,7 +1132,6 @@ extern spinlock_t qib_devs_lock;
 extern struct qib_devdata *qib_lookup(int unit);
 extern u32 qib_cpulist_count;
 extern unsigned long *qib_cpulist;
-extern u16 qpt_mask;
 extern unsigned qib_cc_table_size;
 
 int qib_init(struct qib_devdata *, int);
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index f9b8cd2..99d31ef 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -41,14 +41,6 @@
 
 #include "qib.h"
 
-/*
- * mask field which was present in now deleted qib_qpn_table
- * is not present in rvt_qpn_table. Defining the same field
- * as qpt_mask here instead of adding the mask field to
- * rvt_qpn_table.
- */
-u16 qpt_mask;
-
 static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
 			      struct rvt_qpn_map *map, unsigned off)
 {
@@ -57,7 +49,7 @@ static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
 
 static inline unsigned find_next_offset(struct rvt_qpn_table *qpt,
 					struct rvt_qpn_map *map, unsigned off,
-					unsigned n)
+					unsigned n, u16 qpt_mask)
 {
 	if (qpt_mask) {
 		off++;
@@ -179,6 +171,7 @@ int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 	struct qib_ibdev *verbs_dev = container_of(rdi, struct qib_ibdev, rdi);
 	struct qib_devdata *dd = container_of(verbs_dev, struct qib_devdata,
 					      verbs_dev);
+	u16 qpt_mask = dd->qpn_mask;
 
 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
 		unsigned n;
@@ -215,7 +208,7 @@ int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 				goto bail;
 			}
 			offset = find_next_offset(qpt, map, offset,
-				dd->n_krcv_queues);
+				dd->n_krcv_queues, qpt_mask);
 			qpn = mk_qpn(qpt, map, offset);
 			/*
 			 * This test differs from alloc_pidmap().
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index c12ec8f..876ebb4 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1606,8 +1606,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	/* Only need to initialize non-zero fields. */
 	setup_timer(&dev->mem_timer, mem_timer, (unsigned long)dev);
 
-	qpt_mask = dd->qpn_mask;
-
 	INIT_LIST_HEAD(&dev->piowait);
 	INIT_LIST_HEAD(&dev->dmawait);
 	INIT_LIST_HEAD(&dev->txwait);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
