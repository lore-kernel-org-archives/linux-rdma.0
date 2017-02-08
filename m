From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/27] IB/hfi1, qib,
 rdmavt: Move AETH credit functions into rdmavt
Date: Wed, 08 Feb 2017 05:27:07 -0800
Message-ID: <20170208132706.16442.16428.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add rvt_compute_aeth() and rvt_get_credit() as shared functions in
rdmavt, moved from hfi1/qib logic.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/common.h    |    4 -
 drivers/infiniband/hw/hfi1/qp.c        |  137 -----------------------
 drivers/infiniband/hw/hfi1/qp.h        |   16 ---
 drivers/infiniband/hw/hfi1/rc.c        |   40 +++----
 drivers/infiniband/hw/hfi1/trace.c     |    4 -
 drivers/infiniband/hw/hfi1/verbs.h     |    9 --
 drivers/infiniband/hw/qib/qib_common.h |    4 -
 drivers/infiniband/hw/qib/qib_qp.c     |  134 -----------------------
 drivers/infiniband/hw/qib/qib_rc.c     |   40 +++----
 drivers/infiniband/hw/qib/qib_verbs.h  |    4 -
 drivers/infiniband/sw/rdmavt/Makefile  |    4 -
 drivers/infiniband/sw/rdmavt/rc.c      |  190 ++++++++++++++++++++++++++++++++
 include/rdma/rdmavt_qp.h               |   31 +++++
 13 files changed, 265 insertions(+), 352 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/rc.c

diff --git a/drivers/infiniband/hw/hfi1/common.h b/drivers/infiniband/hw/hfi1/common.h
index da7be21..1b783bb 100644
--- a/drivers/infiniband/hw/hfi1/common.h
+++ b/drivers/infiniband/hw/hfi1/common.h
@@ -331,10 +331,6 @@ struct diag_pkt {
 #define FULL_MGMT_P_KEY      0xFFFF
 
 #define DEFAULT_P_KEY LIM_MGMT_P_KEY
-#define HFI1_AETH_CREDIT_SHIFT 24
-#define HFI1_AETH_CREDIT_MASK 0x1F
-#define HFI1_AETH_CREDIT_INVAL 0x1F
-#define HFI1_MSN_MASK 0xFFFFFF
 #define HFI1_FECN_SHIFT 31
 #define HFI1_FECN_MASK 1
 #define HFI1_FECN_SMASK BIT(HFI1_FECN_SHIFT)
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 8f66c58..319e296 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -79,43 +79,6 @@ static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
 	return (map - qpt->map) * RVT_BITS_PER_PAGE + off;
 }
 
-/*
- * Convert the AETH credit code into the number of credits.
- */
-static const u16 credit_table[31] = {
-	0,                      /* 0 */
-	1,                      /* 1 */
-	2,                      /* 2 */
-	3,                      /* 3 */
-	4,                      /* 4 */
-	6,                      /* 5 */
-	8,                      /* 6 */
-	12,                     /* 7 */
-	16,                     /* 8 */
-	24,                     /* 9 */
-	32,                     /* A */
-	48,                     /* B */
-	64,                     /* C */
-	96,                     /* D */
-	128,                    /* E */
-	192,                    /* F */
-	256,                    /* 10 */
-	384,                    /* 11 */
-	512,                    /* 12 */
-	768,                    /* 13 */
-	1024,                   /* 14 */
-	1536,                   /* 15 */
-	2048,                   /* 16 */
-	3072,                   /* 17 */
-	4096,                   /* 18 */
-	6144,                   /* 19 */
-	8192,                   /* 1A */
-	12288,                  /* 1B */
-	16384,                  /* 1C */
-	24576,                  /* 1D */
-	32768                   /* 1E */
-};
-
 const struct rvt_operation_params hfi1_post_parms[RVT_OPERATION_MAX] = {
 [IB_WR_RDMA_WRITE] = {
 	.length = sizeof(struct ib_rdma_wr),
@@ -340,68 +303,6 @@ int hfi1_check_send_wqe(struct rvt_qp *qp,
 }
 
 /**
- * hfi1_compute_aeth - compute the AETH (syndrome + MSN)
- * @qp: the queue pair to compute the AETH for
- *
- * Returns the AETH.
- */
-__be32 hfi1_compute_aeth(struct rvt_qp *qp)
-{
-	u32 aeth = qp->r_msn & HFI1_MSN_MASK;
-
-	if (qp->ibqp.srq) {
-		/*
-		 * Shared receive queues don't generate credits.
-		 * Set the credit field to the invalid value.
-		 */
-		aeth |= HFI1_AETH_CREDIT_INVAL << HFI1_AETH_CREDIT_SHIFT;
-	} else {
-		u32 min, max, x;
-		u32 credits;
-		struct rvt_rwq *wq = qp->r_rq.wq;
-		u32 head;
-		u32 tail;
-
-		/* sanity check pointers before trusting them */
-		head = wq->head;
-		if (head >= qp->r_rq.size)
-			head = 0;
-		tail = wq->tail;
-		if (tail >= qp->r_rq.size)
-			tail = 0;
-		/*
-		 * Compute the number of credits available (RWQEs).
-		 * There is a small chance that the pair of reads are
-		 * not atomic, which is OK, since the fuzziness is
-		 * resolved as further ACKs go out.
-		 */
-		credits = head - tail;
-		if ((int)credits < 0)
-			credits += qp->r_rq.size;
-		/*
-		 * Binary search the credit table to find the code to
-		 * use.
-		 */
-		min = 0;
-		max = 31;
-		for (;;) {
-			x = (min + max) / 2;
-			if (credit_table[x] == credits)
-				break;
-			if (credit_table[x] > credits) {
-				max = x;
-			} else {
-				if (min == x)
-					break;
-				min = x;
-			}
-		}
-		aeth |= x << HFI1_AETH_CREDIT_SHIFT;
-	}
-	return cpu_to_be32(aeth);
-}
-
-/**
  * _hfi1_schedule_send - schedule progress
  * @qp: the QP
  *
@@ -457,44 +358,6 @@ void hfi1_schedule_send(struct rvt_qp *qp)
 		_hfi1_schedule_send(qp);
 }
 
-/**
- * hfi1_get_credit - handle credit in aeth
- * @qp: the qp
- * @aeth: the Acknowledge Extended Transport Header
- *
- * The QP s_lock should be held.
- */
-void hfi1_get_credit(struct rvt_qp *qp, u32 aeth)
-{
-	u32 credit = (aeth >> HFI1_AETH_CREDIT_SHIFT) & HFI1_AETH_CREDIT_MASK;
-
-	lockdep_assert_held(&qp->s_lock);
-	/*
-	 * If the credit is invalid, we can send
-	 * as many packets as we like.  Otherwise, we have to
-	 * honor the credit field.
-	 */
-	if (credit == HFI1_AETH_CREDIT_INVAL) {
-		if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
-			qp->s_flags |= RVT_S_UNLIMITED_CREDIT;
-			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
-				hfi1_schedule_send(qp);
-			}
-		}
-	} else if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
-		/* Compute new LSN (i.e., MSN + credit) */
-		credit = (aeth + credit_table[credit]) & HFI1_MSN_MASK;
-		if (cmp_msn(credit, qp->s_lsn) > 0) {
-			qp->s_lsn = credit;
-			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
-				hfi1_schedule_send(qp);
-			}
-		}
-	}
-}
-
 void hfi1_qp_wakeup(struct rvt_qp *qp, u32 flag)
 {
 	unsigned long flags;
diff --git a/drivers/infiniband/hw/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
index 4012fc5..1eb9cd7 100644
--- a/drivers/infiniband/hw/hfi1/qp.h
+++ b/drivers/infiniband/hw/hfi1/qp.h
@@ -71,14 +71,6 @@ static inline void clear_ahg(struct rvt_qp *qp)
 }
 
 /**
- * hfi1_compute_aeth - compute the AETH (syndrome + MSN)
- * @qp: the queue pair to compute the AETH for
- *
- * Returns the AETH.
- */
-__be32 hfi1_compute_aeth(struct rvt_qp *qp);
-
-/**
  * hfi1_create_qp - create a queue pair for a device
  * @ibpd: the protection domain who's device we create the queue pair for
  * @init_attr: the attributes of the queue pair
@@ -91,14 +83,6 @@ static inline void clear_ahg(struct rvt_qp *qp)
 struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 			     struct ib_qp_init_attr *init_attr,
 			     struct ib_udata *udata);
-/**
- * hfi1_get_credit - flush the send work queue of a QP
- * @qp: the qp who's send work queue to flush
- * @aeth: the Acknowledge Extended Transport Header
- *
- * The QP s_lock should be held.
- */
-void hfi1_get_credit(struct rvt_qp *qp, u32 aeth);
 
 /**
  * hfi1_qp_wakeup - wake up on the indicated event
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index bb52715..b04a903 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -284,7 +284,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 				qp->s_ack_state = OP(RDMA_READ_RESPONSE_ONLY);
 				e->sent = 1;
 			}
-			ohdr->u.aeth = hfi1_compute_aeth(qp);
+			ohdr->u.aeth = rvt_compute_aeth(qp);
 			hwords++;
 			qp->s_ack_rdma_psn = e->psn;
 			bth2 = mask_psn(qp->s_ack_rdma_psn++);
@@ -293,7 +293,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 			ps->s_txreq->ss = NULL;
 			len = 0;
 			qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
-			ohdr->u.at.aeth = hfi1_compute_aeth(qp);
+			ohdr->u.at.aeth = rvt_compute_aeth(qp);
 			ib_u64_put(e->atomic_data, &ohdr->u.at.atomic_ack_eth);
 			hwords += sizeof(ohdr->u.at) / sizeof(u32);
 			bth2 = mask_psn(e->psn);
@@ -315,7 +315,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 			len = pmtu;
 			middle = HFI1_CAP_IS_KSET(SDMA_AHG);
 		} else {
-			ohdr->u.aeth = hfi1_compute_aeth(qp);
+			ohdr->u.aeth = rvt_compute_aeth(qp);
 			hwords++;
 			qp->s_ack_state = OP(RDMA_READ_RESPONSE_LAST);
 			e = &qp->s_ack_queue[qp->s_tail_ack_queue];
@@ -338,11 +338,11 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		ps->s_txreq->ss = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
-				cpu_to_be32((qp->r_msn & HFI1_MSN_MASK) |
+				cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
 					    (qp->s_nak_state <<
-					     HFI1_AETH_CREDIT_SHIFT));
+					     RVT_AETH_CREDIT_SHIFT));
 		else
-			ohdr->u.aeth = hfi1_compute_aeth(qp);
+			ohdr->u.aeth = rvt_compute_aeth(qp);
 		hwords++;
 		len = 0;
 		bth0 = OP(ACKNOWLEDGE) << 24;
@@ -519,7 +519,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		case IB_WR_SEND_WITH_INV:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
-			    cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
+			    rvt_cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
@@ -556,7 +556,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
-			    cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
+			    rvt_cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
@@ -885,11 +885,11 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	if (qp->r_nak_state)
-		ohdr->u.aeth = cpu_to_be32((qp->r_msn & HFI1_MSN_MASK) |
+		ohdr->u.aeth = cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
 					    (qp->r_nak_state <<
-					     HFI1_AETH_CREDIT_SHIFT));
+					     RVT_AETH_CREDIT_SHIFT));
 	else
-		ohdr->u.aeth = hfi1_compute_aeth(qp);
+		ohdr->u.aeth = rvt_compute_aeth(qp);
 	sc5 = ibp->sl_to_sc[qp->remote_ah_attr.sl];
 	/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
 	pbc_flags |= ((!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT);
@@ -1323,7 +1323,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	 * request but will include an ACK'ed request(s).
 	 */
 	ack_psn = psn;
-	if (aeth >> 29)
+	if (aeth >> RVT_AETH_NAK_SHIFT)
 		ack_psn--;
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	ibp = rcd_to_iport(rcd);
@@ -1403,7 +1403,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			break;
 	}
 
-	switch (aeth >> 29) {
+	switch (aeth >> RVT_AETH_NAK_SHIFT) {
 	case 0:         /* ACK */
 		this_cpu_inc(*ibp->rvp.rc_acks);
 		if (qp->s_acked != qp->s_tail) {
@@ -1430,7 +1430,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			hfi1_schedule_send(qp);
 		}
-		hfi1_get_credit(qp, aeth);
+		rvt_get_credit(qp, aeth);
 		qp->s_rnr_retry = qp->s_rnr_retry_cnt;
 		qp->s_retry = qp->s_retry_cnt;
 		update_last_psn(qp, psn);
@@ -1459,8 +1459,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
 		hfi1_stop_rc_timers(qp);
 		to =
-			ib_hfi1_rnr_table[(aeth >> HFI1_AETH_CREDIT_SHIFT) &
-					   HFI1_AETH_CREDIT_MASK];
+			ib_hfi1_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
+					   RVT_AETH_CREDIT_MASK];
 		hfi1_add_rnr_timer(qp, to);
 		return 0;
 
@@ -1469,8 +1469,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			goto bail_stop;
 		/* The last valid PSN is the previous PSN. */
 		update_last_psn(qp, psn - 1);
-		switch ((aeth >> HFI1_AETH_CREDIT_SHIFT) &
-			HFI1_AETH_CREDIT_MASK) {
+		switch ((aeth >> RVT_AETH_CREDIT_SHIFT) &
+			RVT_AETH_CREDIT_MASK) {
 		case 0: /* PSN sequence error */
 			ibp->rvp.n_seq_naks++;
 			/*
@@ -1600,8 +1600,8 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		/* Update credits for "ghost" ACKs */
 		if (diff == 0 && opcode == OP(ACKNOWLEDGE)) {
 			aeth = be32_to_cpu(ohdr->u.aeth);
-			if ((aeth >> 29) == 0)
-				hfi1_get_credit(qp, aeth);
+			if ((aeth >> RVT_AETH_NAK_SHIFT) == 0)
+				rvt_get_credit(qp, aeth);
 		}
 		goto ack_done;
 	}
diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 01f525c..0985b4f 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -130,14 +130,14 @@ u8 ibhdr_exhdr_len(struct ib_header *hdr)
 	case OP(RC, ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN, be32_to_cpu(eh->aeth) >> 24,
 				 parse_syndrome(be32_to_cpu(eh->aeth) >> 24),
-				 be32_to_cpu(eh->aeth) & HFI1_MSN_MASK);
+				 be32_to_cpu(eh->aeth) & RVT_MSN_MASK);
 		break;
 	/* aeth + atomicacketh */
 	case OP(RC, ATOMIC_ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN " " ATOMICACKETH_PRN,
 				 be32_to_cpu(eh->at.aeth) >> 24,
 				 parse_syndrome(be32_to_cpu(eh->at.aeth) >> 24),
-				 be32_to_cpu(eh->at.aeth) & HFI1_MSN_MASK,
+				 be32_to_cpu(eh->at.aeth) & RVT_MSN_MASK,
 				 ib_u64_get(&eh->at.atomic_ack_eth));
 		break;
 	/* atomiceth */
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 39b0074..f359684 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -260,15 +260,6 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 #define PSN_MODIFY_MASK 0xFFFFFF
 
 /*
- * Compare the lower 24 bits of the msn values.
- * Returns an integer <, ==, or > than zero.
- */
-static inline int cmp_msn(u32 a, u32 b)
-{
-	return (((int)a) - ((int)b)) << 8;
-}
-
-/*
  * Compare two PSNs
  * Returns an integer <, ==, or > than zero.
  */
diff --git a/drivers/infiniband/hw/qib/qib_common.h b/drivers/infiniband/hw/qib/qib_common.h
index 1d6e63e..a4a1f56 100644
--- a/drivers/infiniband/hw/qib/qib_common.h
+++ b/drivers/infiniband/hw/qib/qib_common.h
@@ -742,11 +742,7 @@ struct qib_tid_session_member {
 #define SIZE_OF_CRC 1
 
 #define QIB_DEFAULT_P_KEY 0xFFFF
-#define QIB_AETH_CREDIT_SHIFT 24
-#define QIB_AETH_CREDIT_MASK 0x1F
-#define QIB_AETH_CREDIT_INVAL 0x1F
 #define QIB_PSN_MASK 0xFFFFFF
-#define QIB_MSN_MASK 0xFFFFFF
 #define QIB_EAGER_TID_ID QLOGIC_IB_I_TID_MASK
 #define QIB_MULTICAST_QPN 0xFFFFFF
 
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 99d31ef..e869be0 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -61,43 +61,6 @@ static inline unsigned find_next_offset(struct rvt_qpn_table *qpt,
 	return off;
 }
 
-/*
- * Convert the AETH credit code into the number of credits.
- */
-static u32 credit_table[31] = {
-	0,                      /* 0 */
-	1,                      /* 1 */
-	2,                      /* 2 */
-	3,                      /* 3 */
-	4,                      /* 4 */
-	6,                      /* 5 */
-	8,                      /* 6 */
-	12,                     /* 7 */
-	16,                     /* 8 */
-	24,                     /* 9 */
-	32,                     /* A */
-	48,                     /* B */
-	64,                     /* C */
-	96,                     /* D */
-	128,                    /* E */
-	192,                    /* F */
-	256,                    /* 10 */
-	384,                    /* 11 */
-	512,                    /* 12 */
-	768,                    /* 13 */
-	1024,                   /* 14 */
-	1536,                   /* 15 */
-	2048,                   /* 16 */
-	3072,                   /* 17 */
-	4096,                   /* 18 */
-	6144,                   /* 19 */
-	8192,                   /* 1A */
-	12288,                  /* 1B */
-	16384,                  /* 1C */
-	24576,                  /* 1D */
-	32768                   /* 1E */
-};
-
 const struct rvt_operation_params qib_post_parms[RVT_OPERATION_MAX] = {
 [IB_WR_RDMA_WRITE] = {
 	.length = sizeof(struct ib_rdma_wr),
@@ -354,66 +317,6 @@ u32 qib_mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu)
 	return ib_mtu_enum_to_int(pmtu);
 }
 
-/**
- * qib_compute_aeth - compute the AETH (syndrome + MSN)
- * @qp: the queue pair to compute the AETH for
- *
- * Returns the AETH.
- */
-__be32 qib_compute_aeth(struct rvt_qp *qp)
-{
-	u32 aeth = qp->r_msn & QIB_MSN_MASK;
-
-	if (qp->ibqp.srq) {
-		/*
-		 * Shared receive queues don't generate credits.
-		 * Set the credit field to the invalid value.
-		 */
-		aeth |= QIB_AETH_CREDIT_INVAL << QIB_AETH_CREDIT_SHIFT;
-	} else {
-		u32 min, max, x;
-		u32 credits;
-		struct rvt_rwq *wq = qp->r_rq.wq;
-		u32 head;
-		u32 tail;
-
-		/* sanity check pointers before trusting them */
-		head = wq->head;
-		if (head >= qp->r_rq.size)
-			head = 0;
-		tail = wq->tail;
-		if (tail >= qp->r_rq.size)
-			tail = 0;
-		/*
-		 * Compute the number of credits available (RWQEs).
-		 * XXX Not holding the r_rq.lock here so there is a small
-		 * chance that the pair of reads are not atomic.
-		 */
-		credits = head - tail;
-		if ((int)credits < 0)
-			credits += qp->r_rq.size;
-		/*
-		 * Binary search the credit table to find the code to
-		 * use.
-		 */
-		min = 0;
-		max = 31;
-		for (;;) {
-			x = (min + max) / 2;
-			if (credit_table[x] == credits)
-				break;
-			if (credit_table[x] > credits)
-				max = x;
-			else if (min == x)
-				break;
-			else
-				min = x;
-		}
-		aeth |= x << QIB_AETH_CREDIT_SHIFT;
-	}
-	return cpu_to_be32(aeth);
-}
-
 void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp)
 {
 	struct qib_qp_priv *priv;
@@ -474,43 +377,6 @@ void qib_flush_qp_waiters(struct rvt_qp *qp)
 }
 
 /**
- * qib_get_credit - flush the send work queue of a QP
- * @qp: the qp who's send work queue to flush
- * @aeth: the Acknowledge Extended Transport Header
- *
- * The QP s_lock should be held.
- */
-void qib_get_credit(struct rvt_qp *qp, u32 aeth)
-{
-	u32 credit = (aeth >> QIB_AETH_CREDIT_SHIFT) & QIB_AETH_CREDIT_MASK;
-
-	/*
-	 * If the credit is invalid, we can send
-	 * as many packets as we like.  Otherwise, we have to
-	 * honor the credit field.
-	 */
-	if (credit == QIB_AETH_CREDIT_INVAL) {
-		if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
-			qp->s_flags |= RVT_S_UNLIMITED_CREDIT;
-			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
-				qib_schedule_send(qp);
-			}
-		}
-	} else if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
-		/* Compute new LSN (i.e., MSN + credit) */
-		credit = (aeth + credit_table[credit]) & QIB_MSN_MASK;
-		if (qib_cmp24(credit, qp->s_lsn) > 0) {
-			qp->s_lsn = credit;
-			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
-				qib_schedule_send(qp);
-			}
-		}
-	}
-}
-
-/**
  * qib_check_send_wqe - validate wr/wqe
  * @qp - The qp
  * @wqe - The built wqe
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 5b0d01b..6a18931 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -144,7 +144,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 				qp->s_ack_state = OP(RDMA_READ_RESPONSE_ONLY);
 				e->sent = 1;
 			}
-			ohdr->u.aeth = qib_compute_aeth(qp);
+			ohdr->u.aeth = rvt_compute_aeth(qp);
 			hwords++;
 			qp->s_ack_rdma_psn = e->psn;
 			bth2 = qp->s_ack_rdma_psn++ & QIB_PSN_MASK;
@@ -153,7 +153,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 			qp->s_cur_sge = NULL;
 			len = 0;
 			qp->s_ack_state = OP(ATOMIC_ACKNOWLEDGE);
-			ohdr->u.at.aeth = qib_compute_aeth(qp);
+			ohdr->u.at.aeth = rvt_compute_aeth(qp);
 			ib_u64_put(e->atomic_data, &ohdr->u.at.atomic_ack_eth);
 			hwords += sizeof(ohdr->u.at) / sizeof(u32);
 			bth2 = e->psn & QIB_PSN_MASK;
@@ -174,7 +174,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 		if (len > pmtu)
 			len = pmtu;
 		else {
-			ohdr->u.aeth = qib_compute_aeth(qp);
+			ohdr->u.aeth = rvt_compute_aeth(qp);
 			hwords++;
 			qp->s_ack_state = OP(RDMA_READ_RESPONSE_LAST);
 			e = &qp->s_ack_queue[qp->s_tail_ack_queue];
@@ -197,11 +197,11 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 		qp->s_cur_sge = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
-				cpu_to_be32((qp->r_msn & QIB_MSN_MASK) |
+				cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
 					    (qp->s_nak_state <<
-					     QIB_AETH_CREDIT_SHIFT));
+					     RVT_AETH_CREDIT_SHIFT));
 		else
-			ohdr->u.aeth = qib_compute_aeth(qp);
+			ohdr->u.aeth = rvt_compute_aeth(qp);
 		hwords++;
 		len = 0;
 		bth0 = OP(ACKNOWLEDGE) << 24;
@@ -331,7 +331,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		case IB_WR_SEND_WITH_IMM:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
-			    qib_cmp24(wqe->ssn, qp->s_lsn + 1) > 0) {
+			    rvt_cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
@@ -362,7 +362,7 @@ int qib_make_rc_req(struct rvt_qp *qp, unsigned long *flags)
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			/* If no credit, return. */
 			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
-			    qib_cmp24(wqe->ssn, qp->s_lsn + 1) > 0) {
+			    rvt_cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
 				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
@@ -658,11 +658,11 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 	if (qp->s_mig_state == IB_MIG_MIGRATED)
 		bth0 |= IB_BTH_MIG_REQ;
 	if (qp->r_nak_state)
-		ohdr->u.aeth = cpu_to_be32((qp->r_msn & QIB_MSN_MASK) |
+		ohdr->u.aeth = cpu_to_be32((qp->r_msn & RVT_MSN_MASK) |
 					    (qp->r_nak_state <<
-					     QIB_AETH_CREDIT_SHIFT));
+					     RVT_AETH_CREDIT_SHIFT));
 	else
-		ohdr->u.aeth = qib_compute_aeth(qp);
+		ohdr->u.aeth = rvt_compute_aeth(qp);
 	lrh0 |= ibp->sl_to_vl[qp->remote_ah_attr.sl] << 12 |
 		qp->remote_ah_attr.sl << 4;
 	hdr.lrh[0] = cpu_to_be16(lrh0);
@@ -1098,7 +1098,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	 * request but will include an ACK'ed request(s).
 	 */
 	ack_psn = psn;
-	if (aeth >> 29)
+	if (aeth >> RVT_AETH_NAK_SHIFT)
 		ack_psn--;
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
@@ -1178,7 +1178,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			break;
 	}
 
-	switch (aeth >> 29) {
+	switch (aeth >> RVT_AETH_NAK_SHIFT) {
 	case 0:         /* ACK */
 		this_cpu_inc(*ibp->rvp.rc_acks);
 		if (qp->s_acked != qp->s_tail) {
@@ -1201,7 +1201,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			qib_schedule_send(qp);
 		}
-		qib_get_credit(qp, aeth);
+		rvt_get_credit(qp, aeth);
 		qp->s_rnr_retry = qp->s_rnr_retry_cnt;
 		qp->s_retry = qp->s_retry_cnt;
 		update_last_psn(qp, psn);
@@ -1232,8 +1232,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		qp->s_flags |= RVT_S_WAIT_RNR;
 		qp->s_timer.function = qib_rc_rnr_retry;
 		qp->s_timer.expires = jiffies + usecs_to_jiffies(
-			ib_qib_rnr_table[(aeth >> QIB_AETH_CREDIT_SHIFT) &
-					   QIB_AETH_CREDIT_MASK]);
+			ib_qib_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
+					   RVT_AETH_CREDIT_MASK]);
 		add_timer(&qp->s_timer);
 		goto bail;
 
@@ -1242,8 +1242,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			goto bail;
 		/* The last valid PSN is the previous PSN. */
 		update_last_psn(qp, psn - 1);
-		switch ((aeth >> QIB_AETH_CREDIT_SHIFT) &
-			QIB_AETH_CREDIT_MASK) {
+		switch ((aeth >> RVT_AETH_CREDIT_SHIFT) &
+			RVT_AETH_CREDIT_MASK) {
 		case 0: /* PSN sequence error */
 			ibp->rvp.n_seq_naks++;
 			/*
@@ -1400,8 +1400,8 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 		/* Update credits for "ghost" ACKs */
 		if (diff == 0 && opcode == OP(ACKNOWLEDGE)) {
 			aeth = be32_to_cpu(ohdr->u.aeth);
-			if ((aeth >> 29) == 0)
-				qib_get_credit(qp, aeth);
+			if ((aeth >> RVT_AETH_NAK_SHIFT) == 0)
+				rvt_get_credit(qp, aeth);
 		}
 		goto ack_done;
 	}
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index e399cb0..226e81f 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -270,8 +270,6 @@ int qib_snapshot_counters(struct qib_pportdata *ppd, u64 *swords,
 int qib_get_counters(struct qib_pportdata *ppd,
 		     struct qib_verbs_counters *cntrs);
 
-__be32 qib_compute_aeth(struct rvt_qp *qp);
-
 /*
  * Functions provided by qib driver for rdmavt to use
  */
@@ -294,8 +292,6 @@ int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 
 #endif
 
-void qib_get_credit(struct rvt_qp *qp, u32 aeth);
-
 unsigned qib_pkt_delay(u32 plen, u8 snd_mult, u8 rcv_mult);
 
 void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail);
diff --git a/drivers/infiniband/sw/rdmavt/Makefile b/drivers/infiniband/sw/rdmavt/Makefile
index ccaa799..c33a4f8 100644
--- a/drivers/infiniband/sw/rdmavt/Makefile
+++ b/drivers/infiniband/sw/rdmavt/Makefile
@@ -7,7 +7,7 @@
 #
 obj-$(CONFIG_INFINIBAND_RDMAVT) += rdmavt.o
 
-rdmavt-y := vt.o ah.o cq.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o srq.o \
-	trace.o
+rdmavt-y := vt.o ah.o cq.o dma.o mad.o mcast.o mmap.o mr.o pd.o qp.o \
+	rc.o srq.o trace.o
 
 CFLAGS_trace.o = -I$(src)
diff --git a/drivers/infiniband/sw/rdmavt/rc.c b/drivers/infiniband/sw/rdmavt/rc.c
new file mode 100644
index 0000000..b32b5a3
--- /dev/null
+++ b/drivers/infiniband/sw/rdmavt/rc.c
@@ -0,0 +1,190 @@
+/*
+ * Copyright(c) 2016 Intel Corporation.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include <rdma/rdma_vt.h>
+
+#define RVT_AETH_CREDIT_INVAL	RVT_AETH_CREDIT_MASK
+
+/*
+ * Convert the AETH credit code into the number of credits.
+ */
+static const u16 credit_table[31] = {
+	0,                      /* 0 */
+	1,                      /* 1 */
+	2,                      /* 2 */
+	3,                      /* 3 */
+	4,                      /* 4 */
+	6,                      /* 5 */
+	8,                      /* 6 */
+	12,                     /* 7 */
+	16,                     /* 8 */
+	24,                     /* 9 */
+	32,                     /* A */
+	48,                     /* B */
+	64,                     /* C */
+	96,                     /* D */
+	128,                    /* E */
+	192,                    /* F */
+	256,                    /* 10 */
+	384,                    /* 11 */
+	512,                    /* 12 */
+	768,                    /* 13 */
+	1024,                   /* 14 */
+	1536,                   /* 15 */
+	2048,                   /* 16 */
+	3072,                   /* 17 */
+	4096,                   /* 18 */
+	6144,                   /* 19 */
+	8192,                   /* 1A */
+	12288,                  /* 1B */
+	16384,                  /* 1C */
+	24576,                  /* 1D */
+	32768                   /* 1E */
+};
+
+/**
+ * rvt_compute_aeth - compute the AETH (syndrome + MSN)
+ * @qp: the queue pair to compute the AETH for
+ *
+ * Returns the AETH.
+ */
+__be32 rvt_compute_aeth(struct rvt_qp *qp)
+{
+	u32 aeth = qp->r_msn & RVT_MSN_MASK;
+
+	if (qp->ibqp.srq) {
+		/*
+		 * Shared receive queues don't generate credits.
+		 * Set the credit field to the invalid value.
+		 */
+		aeth |= RVT_AETH_CREDIT_INVAL << RVT_AETH_CREDIT_SHIFT;
+	} else {
+		u32 min, max, x;
+		u32 credits;
+		struct rvt_rwq *wq = qp->r_rq.wq;
+		u32 head;
+		u32 tail;
+
+		/* sanity check pointers before trusting them */
+		head = wq->head;
+		if (head >= qp->r_rq.size)
+			head = 0;
+		tail = wq->tail;
+		if (tail >= qp->r_rq.size)
+			tail = 0;
+		/*
+		 * Compute the number of credits available (RWQEs).
+		 * There is a small chance that the pair of reads are
+		 * not atomic, which is OK, since the fuzziness is
+		 * resolved as further ACKs go out.
+		 */
+		credits = head - tail;
+		if ((int)credits < 0)
+			credits += qp->r_rq.size;
+		/*
+		 * Binary search the credit table to find the code to
+		 * use.
+		 */
+		min = 0;
+		max = 31;
+		for (;;) {
+			x = (min + max) / 2;
+			if (credit_table[x] == credits)
+				break;
+			if (credit_table[x] > credits) {
+				max = x;
+			} else {
+				if (min == x)
+					break;
+				min = x;
+			}
+		}
+		aeth |= x << RVT_AETH_CREDIT_SHIFT;
+	}
+	return cpu_to_be32(aeth);
+}
+EXPORT_SYMBOL(rvt_compute_aeth);
+
+/**
+ * rvt_get_credit - flush the send work queue of a QP
+ * @qp: the qp who's send work queue to flush
+ * @aeth: the Acknowledge Extended Transport Header
+ *
+ * The QP s_lock should be held.
+ */
+void rvt_get_credit(struct rvt_qp *qp, u32 aeth)
+{
+	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
+	u32 credit = (aeth >> RVT_AETH_CREDIT_SHIFT) & RVT_AETH_CREDIT_MASK;
+
+	lockdep_assert_held(&qp->s_lock);
+	/*
+	 * If the credit is invalid, we can send
+	 * as many packets as we like.  Otherwise, we have to
+	 * honor the credit field.
+	 */
+	if (credit == RVT_AETH_CREDIT_INVAL) {
+		if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
+			qp->s_flags |= RVT_S_UNLIMITED_CREDIT;
+			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
+				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
+				rdi->driver_f.schedule_send(qp);
+			}
+		}
+	} else if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
+		/* Compute new LSN (i.e., MSN + credit) */
+		credit = (aeth + credit_table[credit]) & RVT_MSN_MASK;
+		if (rvt_cmp_msn(credit, qp->s_lsn) > 0) {
+			qp->s_lsn = credit;
+			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
+				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
+				rdi->driver_f.schedule_send(qp);
+			}
+		}
+	}
+}
+EXPORT_SYMBOL(rvt_get_credit);
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index eaaba1b..a92e7dc 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -582,6 +582,37 @@ static inline void rvt_qp_swqe_complete(
 	}
 }
 
+#define RVT_AETH_CREDIT_SHIFT	24
+#define RVT_AETH_CREDIT_MASK	0x1F
+#define RVT_AETH_NAK_SHIFT	29
+#define RVT_MSN_MASK		0xFFFFFF
+
+/*
+ * Compare the lower 24 bits of the msn values.
+ * Returns an integer <, ==, or > than zero.
+ */
+static inline int rvt_cmp_msn(u32 a, u32 b)
+{
+	return (((int)a) - ((int)b)) << 8;
+}
+
+/**
+ * rvt_compute_aeth - compute the AETH (syndrome + MSN)
+ * @qp: the queue pair to compute the AETH for
+ *
+ * Returns the AETH.
+ */
+__be32 rvt_compute_aeth(struct rvt_qp *qp);
+
+/**
+ * rvt_get_credit - flush the send work queue of a QP
+ * @qp: the qp who's send work queue to flush
+ * @aeth: the Acknowledge Extended Transport Header
+ *
+ * The QP s_lock should be held.
+ */
+void rvt_get_credit(struct rvt_qp *qp, u32 aeth);
+
 /**
  * @qp - the qp pair
  * @len - the length

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
