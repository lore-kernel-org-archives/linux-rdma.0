From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/12] IB/rdmavt: Remove unnecessary exported functions
Date: Sun, 14 Feb 2016 12:11:20 -0800
Message-ID: <20160214201117.1410.80669.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove exported functions which are no longer required as the
functionality has moved into rdmavt. This also requires re-ordering some
of the functions since their prototype no longer appears in a header
file. Rather than add forward declarations it is just cleaner to
re-order some of the functions.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mmap.c |    4 -
 drivers/infiniband/sw/rdmavt/mmap.h |    8 +
 drivers/infiniband/sw/rdmavt/qp.c   |  252 ++++++++++++++++-------------------
 drivers/infiniband/sw/rdmavt/srq.c  |    1 
 drivers/infiniband/sw/rdmavt/vt.h   |    1 
 include/rdma/rdma_vt.h              |   13 --
 include/rdma/rdmavt_qp.h            |    4 -
 7 files changed, 128 insertions(+), 155 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 273974f..e202b81 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -80,7 +80,6 @@ void rvt_release_mmap_info(struct kref *ref)
 	vfree(ip->obj);
 	kfree(ip);
 }
-EXPORT_SYMBOL(rvt_release_mmap_info);
 
 static void rvt_vma_open(struct vm_area_struct *vma)
 {
@@ -146,7 +145,6 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 done:
 	return ret;
 }
-EXPORT_SYMBOL(rvt_mmap);
 
 /**
  * rvt_create_mmap_info - allocate information for hfi1_mmap
@@ -185,7 +183,6 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 
 	return ip;
 }
-EXPORT_SYMBOL(rvt_create_mmap_info);
 
 /**
  * rvt_update_mmap_info - update a mem map
@@ -209,4 +206,3 @@ void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
 	ip->size = size;
 	ip->obj = obj;
 }
-EXPORT_SYMBOL(rvt_update_mmap_info);
diff --git a/drivers/infiniband/sw/rdmavt/mmap.h b/drivers/infiniband/sw/rdmavt/mmap.h
index e806747..fab0e7b 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.h
+++ b/drivers/infiniband/sw/rdmavt/mmap.h
@@ -51,5 +51,13 @@
 #include <rdma/rdma_vt.h>
 
 void rvt_mmap_init(struct rvt_dev_info *rdi);
+void rvt_release_mmap_info(struct kref *ref);
+int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
+struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj);
+void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
+			  u32 size, void *obj);
 
 #endif          /* DEF_RDMAVTMMAP_H */
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 441e17a..dbf124d 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -390,12 +390,116 @@ static void free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
 }
 
 /**
+ * rvt_clear_mr_refs - Drop help mr refs
+ * @qp: rvt qp data structure
+ * @clr_sends: If shoudl clear send side or not
+ */
+static void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
+{
+	unsigned n;
+
+	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
+		rvt_put_ss(&qp->s_rdma_read_sge);
+
+	rvt_put_ss(&qp->r_sge);
+
+	if (clr_sends) {
+		while (qp->s_last != qp->s_head) {
+			struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_last);
+			unsigned i;
+
+			for (i = 0; i < wqe->wr.num_sge; i++) {
+				struct rvt_sge *sge = &wqe->sg_list[i];
+
+				rvt_put_mr(sge->mr);
+			}
+			if (qp->ibqp.qp_type == IB_QPT_UD ||
+			    qp->ibqp.qp_type == IB_QPT_SMI ||
+			    qp->ibqp.qp_type == IB_QPT_GSI)
+				atomic_dec(&ibah_to_rvtah(
+						wqe->ud_wr.ah)->refcount);
+			if (++qp->s_last >= qp->s_size)
+				qp->s_last = 0;
+			smp_wmb(); /* see qp_set_savail */
+		}
+		if (qp->s_rdma_mr) {
+			rvt_put_mr(qp->s_rdma_mr);
+			qp->s_rdma_mr = NULL;
+		}
+	}
+
+	if (qp->ibqp.qp_type != IB_QPT_RC)
+		return;
+
+	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
+		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
+
+		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
+		    e->rdma_sge.mr) {
+			rvt_put_mr(e->rdma_sge.mr);
+			e->rdma_sge.mr = NULL;
+		}
+	}
+}
+
+/**
+ * rvt_remove_qp - remove qp form table
+ * @rdi: rvt dev struct
+ * @qp: qp to remove
+ *
+ * Remove the QP from the table so it can't be found asynchronously by
+ * the receive routine.
+ */
+static void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+{
+	struct rvt_ibport *rvp = rdi->ports[qp->port_num - 1];
+	u32 n = hash_32(qp->ibqp.qp_num, rdi->qp_dev->qp_table_bits);
+	unsigned long flags;
+	int removed = 1;
+
+	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
+
+	if (rcu_dereference_protected(rvp->qp[0],
+			lockdep_is_held(&rdi->qp_dev->qpt_lock)) == qp) {
+		RCU_INIT_POINTER(rvp->qp[0], NULL);
+	} else if (rcu_dereference_protected(rvp->qp[1],
+			lockdep_is_held(&rdi->qp_dev->qpt_lock)) == qp) {
+		RCU_INIT_POINTER(rvp->qp[1], NULL);
+	} else {
+		struct rvt_qp *q;
+		struct rvt_qp __rcu **qpp;
+
+		removed = 0;
+		qpp = &rdi->qp_dev->qp_table[n];
+		for (; (q = rcu_dereference_protected(*qpp,
+			lockdep_is_held(&rdi->qp_dev->qpt_lock))) != NULL;
+			qpp = &q->next) {
+			if (q == qp) {
+				RCU_INIT_POINTER(*qpp,
+				     rcu_dereference_protected(qp->next,
+				     lockdep_is_held(&rdi->qp_dev->qpt_lock)));
+				removed = 1;
+				trace_rvt_qpremove(qp, n);
+				break;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&rdi->qp_dev->qpt_lock, flags);
+	if (removed) {
+		synchronize_rcu();
+		if (atomic_dec_and_test(&qp->refcount))
+			wake_up(&qp->wait);
+	}
+}
+
+/**
  * reset_qp - initialize the QP state to the reset state
  * @qp: the QP to reset
  * @type: the QP type
  * r and s lock are required to be held by the caller
  */
-void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		  enum ib_qp_type type)
 {
 	if (qp->state != IB_QPS_RESET) {
@@ -475,7 +579,6 @@ void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 	}
 	qp->r_sge.num_sge = 0;
 }
-EXPORT_SYMBOL(rvt_reset_qp);
 
 /**
  * rvt_create_qp - create a queue pair for a device
@@ -762,60 +865,6 @@ bail_swq:
 }
 
 /**
- * rvt_clear_mr_refs - Drop help mr refs
- * @qp: rvt qp data structure
- * @clr_sends: If shoudl clear send side or not
- */
-void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
-{
-	unsigned n;
-
-	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
-		rvt_put_ss(&qp->s_rdma_read_sge);
-
-	rvt_put_ss(&qp->r_sge);
-
-	if (clr_sends) {
-		while (qp->s_last != qp->s_head) {
-			struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_last);
-			unsigned i;
-
-			for (i = 0; i < wqe->wr.num_sge; i++) {
-				struct rvt_sge *sge = &wqe->sg_list[i];
-
-				rvt_put_mr(sge->mr);
-			}
-			if (qp->ibqp.qp_type == IB_QPT_UD ||
-			    qp->ibqp.qp_type == IB_QPT_SMI ||
-			    qp->ibqp.qp_type == IB_QPT_GSI)
-				atomic_dec(&ibah_to_rvtah(
-						wqe->ud_wr.ah)->refcount);
-			if (++qp->s_last >= qp->s_size)
-				qp->s_last = 0;
-			smp_wmb(); /* see qp_set_savail */
-		}
-		if (qp->s_rdma_mr) {
-			rvt_put_mr(qp->s_rdma_mr);
-			qp->s_rdma_mr = NULL;
-		}
-	}
-
-	if (qp->ibqp.qp_type != IB_QPT_RC)
-		return;
-
-	for (n = 0; n < ARRAY_SIZE(qp->s_ack_queue); n++) {
-		struct rvt_ack_entry *e = &qp->s_ack_queue[n];
-
-		if (e->opcode == IB_OPCODE_RC_RDMA_READ_REQUEST &&
-		    e->rdma_sge.mr) {
-			rvt_put_mr(e->rdma_sge.mr);
-			e->rdma_sge.mr = NULL;
-		}
-	}
-}
-EXPORT_SYMBOL(rvt_clear_mr_refs);
-
-/**
  * rvt_error_qp - put a QP into the error state
  * @qp: the QP to put into the error state
  * @err: the receive completion error to signal if a RWQE is active
@@ -923,58 +972,6 @@ static void rvt_insert_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 }
 
 /**
- * rvt_remove_qp - remove qp form table
- * @rdi: rvt dev struct
- * @qp: qp to remove
- *
- * Remove the QP from the table so it can't be found asynchronously by
- * the receive routine.
- */
-void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp)
-{
-	struct rvt_ibport *rvp = rdi->ports[qp->port_num - 1];
-	u32 n = hash_32(qp->ibqp.qp_num, rdi->qp_dev->qp_table_bits);
-	unsigned long flags;
-	int removed = 1;
-
-	spin_lock_irqsave(&rdi->qp_dev->qpt_lock, flags);
-
-	if (rcu_dereference_protected(rvp->qp[0],
-			lockdep_is_held(&rdi->qp_dev->qpt_lock)) == qp) {
-		RCU_INIT_POINTER(rvp->qp[0], NULL);
-	} else if (rcu_dereference_protected(rvp->qp[1],
-			lockdep_is_held(&rdi->qp_dev->qpt_lock)) == qp) {
-		RCU_INIT_POINTER(rvp->qp[1], NULL);
-	} else {
-		struct rvt_qp *q;
-		struct rvt_qp __rcu **qpp;
-
-		removed = 0;
-		qpp = &rdi->qp_dev->qp_table[n];
-		for (; (q = rcu_dereference_protected(*qpp,
-			lockdep_is_held(&rdi->qp_dev->qpt_lock))) != NULL;
-			qpp = &q->next) {
-			if (q == qp) {
-				RCU_INIT_POINTER(*qpp,
-				     rcu_dereference_protected(qp->next,
-				     lockdep_is_held(&rdi->qp_dev->qpt_lock)));
-				removed = 1;
-				trace_rvt_qpremove(qp, n);
-				break;
-			}
-		}
-	}
-
-	spin_unlock_irqrestore(&rdi->qp_dev->qpt_lock, flags);
-	if (removed) {
-		synchronize_rcu();
-		if (atomic_dec_and_test(&qp->refcount))
-			wake_up(&qp->wait);
-	}
-}
-EXPORT_SYMBOL(rvt_remove_qp);
-
-/**
  * qib_modify_qp - modify the attributes of a queue pair
  * @ibqp: the queue pair who's attributes we're modifying
  * @attr: the new attributes
@@ -1234,6 +1231,19 @@ inval:
 	return -EINVAL;
 }
 
+/** rvt_free_qpn - Free a qpn from the bit map
+ * @qpt: QP table
+ * @qpn: queue pair number to free
+ */
+static void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
+{
+	struct rvt_qpn_map *map;
+
+	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
+	if (map->page)
+		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
+}
+
 /**
  * rvt_destroy_qp - destroy a queue pair
  * @ibqp: the queue pair to destroy
@@ -1664,29 +1674,3 @@ int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 	}
 	return 0;
 }
-
-/** rvt_free_qpn - Free a qpn from the bit map
- * @qpt: QP table
- * @qpn: queue pair number to free
- */
-void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
-{
-	struct rvt_qpn_map *map;
-
-	map = qpt->map + qpn / RVT_BITS_PER_PAGE;
-	if (map->page)
-		clear_bit(qpn & RVT_BITS_PER_PAGE_MASK, map->page);
-}
-EXPORT_SYMBOL(rvt_free_qpn);
-
-/**
- * rvt_dec_qp_cnt - decrement qp count
- * rdi: rvt dev struct
- */
-void rvt_dec_qp_cnt(struct rvt_dev_info *rdi)
-{
-	spin_lock(&rdi->n_qps_lock);
-	rdi->n_qps_allocated--;
-	spin_unlock(&rdi->n_qps_lock);
-}
-EXPORT_SYMBOL(rvt_dec_qp_cnt);
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index 98c4927..f7c48e9 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -50,6 +50,7 @@
 #include <linux/vmalloc.h>
 
 #include "srq.h"
+#include "vt.h"
 
 /**
  * rvt_driver_srq_init - init srq resources on a per driver basis
diff --git a/drivers/infiniband/sw/rdmavt/vt.h b/drivers/infiniband/sw/rdmavt/vt.h
index e26f9e9..6b01eaa 100644
--- a/drivers/infiniband/sw/rdmavt/vt.h
+++ b/drivers/infiniband/sw/rdmavt/vt.h
@@ -60,6 +60,7 @@
 #include "mmap.h"
 #include "cq.h"
 #include "mad.h"
+#include "mmap.h"
 
 #define rvt_pr_info(rdi, fmt, ...) \
 	__rvt_pr_info(rdi->driver_f.get_pci_dev(rdi), \
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 4c50bbb..a869655 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -476,19 +476,6 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		struct rvt_sge *isge, struct ib_sge *sge, int acc);
-int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
-void rvt_release_mmap_info(struct kref *ref);
-struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
-					   u32 size,
-					   struct ib_ucontext *context,
-					   void *obj);
-void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
-			  u32 size, void *obj);
-int rvt_reg_mr(struct rvt_qp *qp, struct ib_reg_wr *wr);
 struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid);
 
-/* Temporary export */
-void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-		  enum ib_qp_type type);
-
 #endif          /* DEF_RDMA_VT_H */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 1066b5d..933f14f 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -438,10 +438,6 @@ static inline struct rvt_rwqe *rvt_get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
 extern const int  ib_rvt_state_ops[];
 
 struct rvt_dev_info;
-void rvt_remove_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp);
-void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends);
 int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
-void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn);
-void rvt_dec_qp_cnt(struct rvt_dev_info *rdi);
 
 #endif          /* DEF_RDMAVT_INCQP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
