From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 26/27] IB/hfi1, qib,
 rdmavt: Move AETH defines to rdma/ib_hdrs.h
Date: Wed, 08 Feb 2017 05:28:25 -0800
Message-ID: <20170208132824.16442.61753.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rename RVT AETH defines and export in rdma/ib_hdrs.h

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c     |   18 +++++++++---------
 drivers/infiniband/hw/hfi1/ruc.c    |    2 +-
 drivers/infiniband/hw/hfi1/trace.c  |    4 ++--
 drivers/infiniband/hw/qib/qib_rc.c  |   18 +++++++++---------
 drivers/infiniband/hw/qib/qib_ruc.c |    2 +-
 drivers/infiniband/sw/rdmavt/qp.c   |    7 ++++---
 drivers/infiniband/sw/rdmavt/rc.c   |   15 +++++++--------
 include/rdma/ib_hdrs.h              |    6 ++++++
 include/rdma/rdmavt_qp.h            |    5 -----
 9 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 3cddf7d..7382be1 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -211,9 +211,9 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		ps->s_txreq->ss = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
-				cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
+				cpu_to_be32((qp->r_msn & IB_MSN_MASK) |
 					    (qp->s_nak_state <<
-					     RVT_AETH_CREDIT_SHIFT));
+					     IB_AETH_CREDIT_SHIFT));
 		else
 			ohdr->u.aeth = rvt_compute_aeth(qp);
 		hwords++;
@@ -758,9 +758,9 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	if (qp->r_nak_state)
-		ohdr->u.aeth = cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
+		ohdr->u.aeth = cpu_to_be32((qp->r_msn & IB_MSN_MASK) |
 					    (qp->r_nak_state <<
-					     RVT_AETH_CREDIT_SHIFT));
+					     IB_AETH_CREDIT_SHIFT));
 	else
 		ohdr->u.aeth = rvt_compute_aeth(qp);
 	sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
@@ -1157,7 +1157,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	 * request but will include an ACK'ed request(s).
 	 */
 	ack_psn = psn;
-	if (aeth >> RVT_AETH_NAK_SHIFT)
+	if (aeth >> IB_AETH_NAK_SHIFT)
 		ack_psn--;
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	ibp = rcd_to_iport(rcd);
@@ -1237,7 +1237,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			break;
 	}
 
-	switch (aeth >> RVT_AETH_NAK_SHIFT) {
+	switch (aeth >> IB_AETH_NAK_SHIFT) {
 	case 0:         /* ACK */
 		this_cpu_inc(*ibp->rvp.rc_acks);
 		if (qp->s_acked != qp->s_tail) {
@@ -1300,8 +1300,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			goto bail_stop;
 		/* The last valid PSN is the previous PSN. */
 		update_last_psn(qp, psn - 1);
-		switch ((aeth >> RVT_AETH_CREDIT_SHIFT) &
-			RVT_AETH_CREDIT_MASK) {
+		switch ((aeth >> IB_AETH_CREDIT_SHIFT) &
+			IB_AETH_CREDIT_MASK) {
 		case 0: /* PSN sequence error */
 			ibp->rvp.n_seq_naks++;
 			/*
@@ -1431,7 +1431,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		/* Update credits for "ghost" ACKs */
 		if (diff == 0 && opcode == OP(ACKNOWLEDGE)) {
 			aeth = be32_to_cpu(ohdr->u.aeth);
-			if ((aeth >> RVT_AETH_NAK_SHIFT) == 0)
+			if ((aeth >> IB_AETH_NAK_SHIFT) == 0)
 				rvt_get_credit(qp, aeth);
 		}
 		goto ack_done;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index bdf3697..aa15bcb 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -580,7 +580,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
 	rvt_add_rnr_timer(sqp, qp->r_min_rnr_timer <<
-				RVT_AETH_CREDIT_SHIFT);
+				IB_AETH_CREDIT_SHIFT);
 	goto clr_busy;
 
 op_err:
diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 0985b4f..e86798a 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -130,14 +130,14 @@ u8 ibhdr_exhdr_len(struct ib_header *hdr)
 	case OP(RC, ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN, be32_to_cpu(eh->aeth) >> 24,
 				 parse_syndrome(be32_to_cpu(eh->aeth) >> 24),
-				 be32_to_cpu(eh->aeth) & RVT_MSN_MASK);
+				 be32_to_cpu(eh->aeth) & IB_MSN_MASK);
 		break;
 	/* aeth + atomicacketh */
 	case OP(RC, ATOMIC_ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN " " ATOMICACKETH_PRN,
 				 be32_to_cpu(eh->at.aeth) >> 24,
 				 parse_syndrome(be32_to_cpu(eh->at.aeth) >> 24),
-				 be32_to_cpu(eh->at.aeth) & RVT_MSN_MASK,
+				 be32_to_cpu(eh->at.aeth) & IB_MSN_MASK,
 				 ib_u64_get(&eh->at.atomic_ack_eth));
 		break;
 	/* atomiceth */
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 2a495fb..12658e3 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -187,9 +187,9 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 		qp->s_cur_sge = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
-				cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
+				cpu_to_be32((qp->r_msn & IB_MSN_MASK) |
 					    (qp->s_nak_state <<
-					     RVT_AETH_CREDIT_SHIFT));
+					     IB_AETH_CREDIT_SHIFT));
 		else
 			ohdr->u.aeth = rvt_compute_aeth(qp);
 		hwords++;
@@ -648,9 +648,9 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	if (qp->r_nak_state)
-		ohdr->u.aeth = cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
+		ohdr->u.aeth = cpu_to_be32((qp->r_msn & IB_MSN_MASK) |
 					    (qp->r_nak_state <<
-					     RVT_AETH_CREDIT_SHIFT));
+					     IB_AETH_CREDIT_SHIFT));
 	else
 		ohdr->u.aeth = rvt_compute_aeth(qp);
 	lrh0 |= ibp->sl_to_vl[qp->remote_ah_attr.sl] << 12 |
@@ -1042,7 +1042,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	 * request but will include an ACK'ed request(s).
 	 */
 	ack_psn = psn;
-	if (aeth >> RVT_AETH_NAK_SHIFT)
+	if (aeth >> IB_AETH_NAK_SHIFT)
 		ack_psn--;
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -1122,7 +1122,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			break;
 	}
 
-	switch (aeth >> RVT_AETH_NAK_SHIFT) {
+	switch (aeth >> IB_AETH_NAK_SHIFT) {
 	case 0:         /* ACK */
 		this_cpu_inc(*ibp->rvp.rc_acks);
 		if (qp->s_acked != qp->s_tail) {
@@ -1185,8 +1185,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			goto bail;
 		/* The last valid PSN is the previous PSN. */
 		update_last_psn(qp, psn - 1);
-		switch ((aeth >> RVT_AETH_CREDIT_SHIFT) &
-			RVT_AETH_CREDIT_MASK) {
+		switch ((aeth >> IB_AETH_CREDIT_SHIFT) &
+			IB_AETH_CREDIT_MASK) {
 		case 0: /* PSN sequence error */
 			ibp->rvp.n_seq_naks++;
 			/*
@@ -1341,7 +1341,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 		/* Update credits for "ghost" ACKs */
 		if (diff == 0 && opcode == OP(ACKNOWLEDGE)) {
 			aeth = be32_to_cpu(ohdr->u.aeth);
-			if ((aeth >> RVT_AETH_NAK_SHIFT) == 0)
+			if ((aeth >> IB_AETH_NAK_SHIFT) == 0)
 				rvt_get_credit(qp, aeth);
 		}
 		goto ack_done;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 58b2841..17655cc 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -562,7 +562,7 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
 	rvt_add_rnr_timer(sqp, qp->r_min_rnr_timer <<
-				RVT_AETH_CREDIT_SHIFT);
+				IB_AETH_CREDIT_SHIFT);
 	goto clr_busy;
 
 op_err:
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 0b97598..f5ad8d4 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -51,6 +51,7 @@
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_hdrs.h>
 #include "qp.h"
 #include "vt.h"
 #include "trace.h"
@@ -1961,14 +1962,14 @@ void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
  */
 unsigned long rvt_rnr_tbl_to_usec(u32 index)
 {
-	return ib_rvt_rnr_table[(index & RVT_AETH_CREDIT_MASK)];
+	return ib_rvt_rnr_table[(index & IB_AETH_CREDIT_MASK)];
 }
 EXPORT_SYMBOL(rvt_rnr_tbl_to_usec);
 
 static inline unsigned long rvt_aeth_to_usec(u32 aeth)
 {
-	return ib_rvt_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
-				  RVT_AETH_CREDIT_MASK];
+	return ib_rvt_rnr_table[(aeth >> IB_AETH_CREDIT_SHIFT) &
+				  IB_AETH_CREDIT_MASK];
 }
 
 /*
diff --git a/drivers/infiniband/sw/rdmavt/rc.c b/drivers/infiniband/sw/rdmavt/rc.c
index b32b5a3..6131cc5 100644
--- a/drivers/infiniband/sw/rdmavt/rc.c
+++ b/drivers/infiniband/sw/rdmavt/rc.c
@@ -46,8 +46,7 @@
  */
 
 #include <rdma/rdma_vt.h>
-
-#define RVT_AETH_CREDIT_INVAL	RVT_AETH_CREDIT_MASK
+#include <rdma/ib_hdrs.h>
 
 /*
  * Convert the AETH credit code into the number of credits.
@@ -94,14 +93,14 @@
  */
 __be32 rvt_compute_aeth(struct rvt_qp *qp)
 {
-	u32 aeth = qp->r_msn & RVT_MSN_MASK;
+	u32 aeth = qp->r_msn & IB_MSN_MASK;
 
 	if (qp->ibqp.srq) {
 		/*
 		 * Shared receive queues don't generate credits.
 		 * Set the credit field to the invalid value.
 		 */
-		aeth |= RVT_AETH_CREDIT_INVAL << RVT_AETH_CREDIT_SHIFT;
+		aeth |= IB_AETH_CREDIT_INVAL << IB_AETH_CREDIT_SHIFT;
 	} else {
 		u32 min, max, x;
 		u32 credits;
@@ -143,7 +142,7 @@ __be32 rvt_compute_aeth(struct rvt_qp *qp)
 				min = x;
 			}
 		}
-		aeth |= x << RVT_AETH_CREDIT_SHIFT;
+		aeth |= x << IB_AETH_CREDIT_SHIFT;
 	}
 	return cpu_to_be32(aeth);
 }
@@ -159,7 +158,7 @@ __be32 rvt_compute_aeth(struct rvt_qp *qp)
 void rvt_get_credit(struct rvt_qp *qp, u32 aeth)
 {
 	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
-	u32 credit = (aeth >> RVT_AETH_CREDIT_SHIFT) & RVT_AETH_CREDIT_MASK;
+	u32 credit = (aeth >> IB_AETH_CREDIT_SHIFT) & IB_AETH_CREDIT_MASK;
 
 	lockdep_assert_held(&qp->s_lock);
 	/*
@@ -167,7 +166,7 @@ void rvt_get_credit(struct rvt_qp *qp, u32 aeth)
 	 * as many packets as we like.  Otherwise, we have to
 	 * honor the credit field.
 	 */
-	if (credit == RVT_AETH_CREDIT_INVAL) {
+	if (credit == IB_AETH_CREDIT_INVAL) {
 		if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
 			qp->s_flags |= RVT_S_UNLIMITED_CREDIT;
 			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
@@ -177,7 +176,7 @@ void rvt_get_credit(struct rvt_qp *qp, u32 aeth)
 		}
 	} else if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
 		/* Compute new LSN (i.e., MSN + credit) */
-		credit = (aeth + credit_table[credit]) & RVT_MSN_MASK;
+		credit = (aeth + credit_table[credit]) & IB_MSN_MASK;
 		if (rvt_cmp_msn(credit, qp->s_lsn) > 0) {
 			qp->s_lsn = credit;
 			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 408439f..c755325 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -75,6 +75,12 @@
 #define IB_GRH_FLOW_SHIFT	0
 #define IB_GRH_NEXT_HDR		0x1B
 
+#define IB_AETH_CREDIT_SHIFT	24
+#define IB_AETH_CREDIT_MASK	0x1F
+#define IB_AETH_CREDIT_INVAL	0x1F
+#define IB_AETH_NAK_SHIFT	29
+#define IB_MSN_MASK		0xFFFFFF
+
 struct ib_reth {
 	__be64 vaddr;        /* potentially unaligned */
 	__be32 rkey;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 9767549..f381639 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -594,11 +594,6 @@ static inline void rvt_qp_swqe_complete(
 	}
 }
 
-#define RVT_AETH_CREDIT_SHIFT	24
-#define RVT_AETH_CREDIT_MASK	0x1F
-#define RVT_AETH_NAK_SHIFT	29
-#define RVT_MSN_MASK		0xFFFFFF
-
 /*
  * Compare the lower 24 bits of the msn values.
  * Returns an integer <, ==, or > than zero.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
