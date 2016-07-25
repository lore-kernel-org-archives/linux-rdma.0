From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/28] IB/hfi1: Add the capability for reserved operations
Date: Mon, 25 Jul 2016 13:39:39 -0700
Message-ID: <20160725203938.4800.99861.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This fix allows for support of in-kernel reserved operations
without impacting the ULP user.

The low level driver can register a non-zero value which
will be transparently added to the send queue size and hidden
from the ULP in every respect.

ULP post sends will never see a full queue due to a reserved
post send and reserved operations will never exceed that
registered value.

The s_avail will continue to track the ULP swqe availability
and the difference between the reserved value and the reserved
in use will track reserved availabity.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   85 +++++++++++++++++++++++++++----------
 include/rdma/rdma_vt.h            |    1 
 include/rdma/rdmavt_qp.h          |   50 ++++++++++++++++++++++
 3 files changed, 113 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index f79b809..218494c 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -584,6 +584,7 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		qp->r_rq.wq->tail = 0;
 	}
 	qp->r_sge.num_sge = 0;
+	atomic_set(&qp->s_reserved_used, 0);
 }
 
 /**
@@ -645,7 +646,8 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 			return ERR_PTR(-EINVAL);
 	}
 	sqsize =
-		init_attr->cap.max_send_wr + 1;
+		init_attr->cap.max_send_wr + 1 +
+		rdi->dparms.reserved_operations;
 	switch (init_attr->qp_type) {
 	case IB_QPT_SMI:
 	case IB_QPT_GSI:
@@ -1335,7 +1337,8 @@ int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	attr->sq_psn = qp->s_next_psn & rdi->dparms.psn_mask;
 	attr->dest_qp_num = qp->remote_qpn;
 	attr->qp_access_flags = qp->qp_access_flags;
-	attr->cap.max_send_wr = qp->s_size - 1;
+	attr->cap.max_send_wr = qp->s_size - 1 -
+		rdi->dparms.reserved_operations;
 	attr->cap.max_recv_wr = qp->ibqp.srq ? 0 : qp->r_rq.size - 1;
 	attr->cap.max_send_sge = qp->s_max_sge;
 	attr->cap.max_recv_sge = qp->r_rq.max_sge;
@@ -1494,27 +1497,65 @@ static inline int rvt_qp_valid_operation(
 }
 
 /**
- * qp_get_savail - return number of avail send entries
+ * rvt_qp_is_avail - determine queue capacity
  * @qp - the qp
+ * @rdi - the rdmavt device
+ * @reserved_op - is reserved operation
  *
  * This assumes the s_hlock is held but the s_last
  * qp variable is uncontrolled.
  *
- * The return is adjusted to not count device specific
- * reserved operations.
+ * For non reserved operations, the qp->s_avail
+ * may be changed.
+ *
+ * The return value is zero or a -ENOMEM.
  */
-static inline u32 qp_get_savail(struct rvt_qp *qp)
+static inline int rvt_qp_is_avail(
+	struct rvt_qp *qp,
+	struct rvt_dev_info *rdi,
+	bool reserved_op)
 {
 	u32 slast;
-	u32 ret;
-
+	u32 avail;
+	u32 reserved_used;
+
+	/* see rvt_qp_wqe_unreserve() */
+	smp_mb__before_atomic();
+	reserved_used = atomic_read(&qp->s_reserved_used);
+	if (unlikely(reserved_op)) {
+		/* see rvt_qp_wqe_unreserve() */
+		smp_mb__before_atomic();
+		if (reserved_used >= rdi->dparms.reserved_operations)
+			return -ENOMEM;
+		return 0;
+	}
+	/* non-reserved operations */
+	if (likely(qp->s_avail))
+		return 0;
 	smp_read_barrier_depends(); /* see rc.c */
 	slast = ACCESS_ONCE(qp->s_last);
 	if (qp->s_head >= slast)
-		ret = qp->s_size - (qp->s_head - slast);
+		avail = qp->s_size - (qp->s_head - slast);
 	else
-		ret = slast - qp->s_head;
-	return ret - 1;
+		avail = slast - qp->s_head;
+
+	/* see rvt_qp_wqe_unreserve() */
+	smp_mb__before_atomic();
+	reserved_used = atomic_read(&qp->s_reserved_used);
+	avail =  avail - 1 -
+		(rdi->dparms.reserved_operations - reserved_used);
+	/* insure we don't assign a negative s_avail */
+	if ((s32)avail <= 0)
+		return -ENOMEM;
+	qp->s_avail = avail;
+	if (WARN_ON(qp->s_avail >
+		    (qp->s_size - 1 - rdi->dparms.reserved_operations)))
+		rvt_pr_err(rdi,
+			   "More avail entries than QP RB size.\nQP: %u, size: %u, avail: %u\nhead: %u, tail: %u, cur: %u, acked: %u, last: %u",
+			   qp->ibqp.qp_num, qp->s_size, qp->s_avail,
+			   qp->s_head, qp->s_tail, qp->s_cur,
+			   qp->s_acked, qp->s_last);
+	return 0;
 }
 
 /**
@@ -1537,6 +1578,7 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 	u8 log_pmtu;
 	int ret;
 	size_t cplen;
+	bool reserved_op;
 
 	BUILD_BUG_ON(IB_QPT_MAX >= (sizeof(u32) * BITS_PER_BYTE));
 
@@ -1574,18 +1616,12 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 		}
 	}
 
+	reserved_op = rdi->post_parms[wr->opcode].flags &
+			RVT_OPERATION_USE_RESERVE;
 	/* check for avail */
-	if (unlikely(!qp->s_avail)) {
-		qp->s_avail = qp_get_savail(qp);
-		if (WARN_ON(qp->s_avail > (qp->s_size - 1)))
-			rvt_pr_err(rdi,
-				   "More avail entries than QP RB size.\nQP: %u, size: %u, avail: %u\nhead: %u, tail: %u, cur: %u, acked: %u, last: %u",
-				   qp->ibqp.qp_num, qp->s_size, qp->s_avail,
-				   qp->s_head, qp->s_tail, qp->s_cur,
-				   qp->s_acked, qp->s_last);
-		if (!qp->s_avail)
-			return -ENOMEM;
-	}
+	ret = rvt_qp_is_avail(qp, rdi, reserved_op);
+	if (ret)
+		return ret;
 	next = qp->s_head + 1;
 	if (next >= qp->s_size)
 		next = 0;
@@ -1653,8 +1689,11 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 		qp->s_next_psn = wqe->lpsn + 1;
 	}
 	trace_rvt_post_one_wr(qp, wqe);
+	if (unlikely(reserved_op))
+		rvt_qp_wqe_reserve(qp, wqe);
+	else
+		qp->s_avail--;
 	smp_wmb(); /* see request builders */
-	qp->s_avail--;
 	qp->s_head = next;
 
 	return 0;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 7fdba92..e315021 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -158,6 +158,7 @@ struct rvt_driver_params {
 	u32 max_mad_size;
 	u8 qos_shift;
 	u8 max_rdma_atomic;
+	u8 reserved_operations;
 };
 
 /* Protection domain */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index b0ab12b..56adcfc 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -145,6 +145,11 @@
 	(RVT_PROCESS_SEND_OK | RVT_FLUSH_SEND)
 
 /*
+ * Internal send flags
+ */
+#define RVT_SEND_RESERVE_USED           IB_SEND_RESERVED_START
+
+/*
  * Send work request queue entry.
  * The size of the sg_list is determined when the QP is created and stored
  * in qp->s_max_sge.
@@ -232,6 +237,7 @@ struct rvt_ack_entry {
 #define RVT_OPERATION_ATOMIC      0x00000002
 #define RVT_OPERATION_ATOMIC_SGE  0x00000004
 #define RVT_OPERATION_LOCAL       0x00000008
+#define RVT_OPERATION_USE_RESERVE 0x00000010
 
 #define RVT_OPERATION_MAX (IB_WR_RESERVED10 + 1)
 
@@ -328,6 +334,7 @@ struct rvt_qp {
 	u32 s_next_psn;         /* PSN for next request */
 	u32 s_avail;            /* number of entries avail */
 	u32 s_ssn;              /* SSN of tail entry */
+	atomic_t s_reserved_used; /* reserved entries in use */
 
 	spinlock_t s_lock ____cacheline_aligned_in_smp;
 	u32 s_flags;
@@ -459,6 +466,49 @@ static inline struct rvt_rwqe *rvt_get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
 		  rq->max_sge * sizeof(struct ib_sge)) * n);
 }
 
+/**
+ * rvt_qp_wqe_reserve - reserve operation
+ * @qp - the rvt qp
+ * @wqe - the send wqe
+ *
+ * This routine used in post send to record
+ * a wqe relative reserved operation use.
+ */
+static inline void rvt_qp_wqe_reserve(
+	struct rvt_qp *qp,
+	struct rvt_swqe *wqe)
+{
+	wqe->wr.send_flags |= RVT_SEND_RESERVE_USED;
+	atomic_inc(&qp->s_reserved_used);
+}
+
+/**
+ * rvt_qp_wqe_unreserve - clean reserved operation
+ * @qp - the rvt qp
+ * @wqe - the send wqe
+ *
+ * This decrements the reserve use count.
+ *
+ * This call MUST precede the change to
+ * s_last to insure that post send sees a stable
+ * s_avail.
+ *
+ * An smp_mp__after_atomic() is used to insure
+ * the compiler does not juggle the order of the s_last
+ * ring index and the decrementing of s_reserved_used.
+ */
+static inline void rvt_qp_wqe_unreserve(
+	struct rvt_qp *qp,
+	struct rvt_swqe *wqe)
+{
+	if (unlikely(wqe->wr.send_flags & RVT_SEND_RESERVE_USED)) {
+		wqe->wr.send_flags &= ~RVT_SEND_RESERVE_USED;
+		atomic_dec(&qp->s_reserved_used);
+		/* insure no compiler re-order up to s_last change */
+		smp_mb__after_atomic();
+	}
+}
+
 extern const int  ib_rvt_state_ops[];
 
 struct rvt_dev_info;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
