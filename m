From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/27] IB/qib: Use new rdmavt timers
Date: Wed, 08 Feb 2017 05:27:25 -0800
Message-ID: <20170208132724.16442.65628.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reduce qib code footprint by using the rdmavt timers.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |    1 
 drivers/infiniband/hw/qib/qib_rc.c    |   94 ++++++---------------------------
 drivers/infiniband/hw/qib/qib_ruc.c   |   45 +---------------
 drivers/infiniband/hw/qib/qib_verbs.c |    1 
 drivers/infiniband/hw/qib/qib_verbs.h |    2 -
 5 files changed, 21 insertions(+), 122 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index e869be0..2ac0c0f 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -351,7 +351,6 @@ void qib_stop_send_queue(struct rvt_qp *qp)
 	struct qib_qp_priv *priv = qp->priv;
 
 	cancel_work_sync(&priv->s_work);
-	del_timer_sync(&qp->s_timer);
 }
 
 void qib_quiesce_qp(struct rvt_qp *qp)
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 6a18931..ea0bc6b 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -38,7 +38,6 @@
 /* cut down ridiculously long IB macro names */
 #define OP(x) IB_OPCODE_RC_##x
 
-static void rc_timeout(unsigned long arg);
 
 static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
@@ -54,15 +53,6 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 	return wqe->length - len;
 }
 
-static void start_timer(struct rvt_qp *qp)
-{
-	qp->s_flags |= RVT_S_TIMER;
-	qp->s_timer.function = rc_timeout;
-	/* 4.096 usec. * (1 << qp->timeout) */
-	qp->s_timer.expires = jiffies + qp->timeout_jiffies;
-	add_timer(&qp->s_timer);
-}
-
 /**
  * qib_make_rc_ack - construct a response packet (ACK, NAK, or RDMA read)
  * @dev: the device for this QP
@@ -837,7 +827,7 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
  * Back up requester to resend the last un-ACKed request.
  * The QP r_lock and s_lock should be held and interrupts disabled.
  */
-static void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
+void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 {
 	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	struct qib_ibport *ibp;
@@ -870,46 +860,6 @@ static void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 }
 
 /*
- * This is called from s_timer for missing responses.
- */
-static void rc_timeout(unsigned long arg)
-{
-	struct rvt_qp *qp = (struct rvt_qp *)arg;
-	struct qib_ibport *ibp;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qp->r_lock, flags);
-	spin_lock(&qp->s_lock);
-	if (qp->s_flags & RVT_S_TIMER) {
-		ibp = to_iport(qp->ibqp.device, qp->port_num);
-		ibp->rvp.n_rc_timeouts++;
-		qp->s_flags &= ~RVT_S_TIMER;
-		del_timer(&qp->s_timer);
-		qib_restart_rc(qp, qp->s_last_psn + 1, 1);
-		qib_schedule_send(qp);
-	}
-	spin_unlock(&qp->s_lock);
-	spin_unlock_irqrestore(&qp->r_lock, flags);
-}
-
-/*
- * This is called from s_timer for RNR timeouts.
- */
-void qib_rc_rnr_retry(unsigned long arg)
-{
-	struct rvt_qp *qp = (struct rvt_qp *)arg;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qp->s_lock, flags);
-	if (qp->s_flags & RVT_S_WAIT_RNR) {
-		qp->s_flags &= ~RVT_S_WAIT_RNR;
-		del_timer(&qp->s_timer);
-		qib_schedule_send(qp);
-	}
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-}
-
-/*
  * Set qp->s_sending_psn to the next PSN after the given one.
  * This would be psn+1 except when RDMA reads are present.
  */
@@ -972,7 +922,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 	if ((psn & IB_BTH_REQ_ACK) && qp->s_acked != qp->s_tail &&
 	    !(qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
 	    (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
-		start_timer(qp);
+		rvt_add_retry_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
 		u32 s_last;
@@ -1085,12 +1035,6 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	u32 ack_psn;
 	int diff;
 
-	/* Remove QP from retry timer */
-	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
-		del_timer(&qp->s_timer);
-	}
-
 	/*
 	 * Note that NAKs implicitly ACK outstanding SEND and RDMA write
 	 * requests and implicitly NAK RDMA read and atomic requests issued
@@ -1186,16 +1130,20 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			 * We are expecting more ACKs so
 			 * reset the retransmit timer.
 			 */
-			start_timer(qp);
+			rvt_mod_retry_timer(qp);
 			/*
 			 * We can stop resending the earlier packets and
 			 * continue with the next packet the receiver wants.
 			 */
 			if (qib_cmp24(qp->s_psn, psn) <= 0)
 				reset_psn(qp, psn + 1);
-		} else if (qib_cmp24(qp->s_psn, psn) <= 0) {
-			qp->s_state = OP(SEND_LAST);
-			qp->s_psn = psn + 1;
+		} else {
+			/* No more acks - kill all timers */
+			rvt_stop_rc_timers(qp);
+			if (qib_cmp24(qp->s_psn, psn) <= 0) {
+				qp->s_state = OP(SEND_LAST);
+				qp->s_psn = psn + 1;
+			}
 		}
 		if (qp->s_flags & RVT_S_WAIT_ACK) {
 			qp->s_flags &= ~RVT_S_WAIT_ACK;
@@ -1205,8 +1153,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		qp->s_rnr_retry = qp->s_rnr_retry_cnt;
 		qp->s_retry = qp->s_retry_cnt;
 		update_last_psn(qp, psn);
-		ret = 1;
-		goto bail;
+		return 1;
 
 	case 1:         /* RNR NAK */
 		ibp->rvp.n_rnr_naks++;
@@ -1229,13 +1176,9 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		reset_psn(qp, psn);
 
 		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
-		qp->s_flags |= RVT_S_WAIT_RNR;
-		qp->s_timer.function = qib_rc_rnr_retry;
-		qp->s_timer.expires = jiffies + usecs_to_jiffies(
-			ib_qib_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
-					   RVT_AETH_CREDIT_MASK]);
-		add_timer(&qp->s_timer);
-		goto bail;
+		rvt_stop_rc_timers(qp);
+		rvt_add_rnr_timer(qp, aeth);
+		return 0;
 
 	case 3:         /* NAK */
 		if (qp->s_acked == qp->s_tail)
@@ -1291,6 +1234,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	}
 
 bail:
+	rvt_stop_rc_timers(qp);
 	return ret;
 }
 
@@ -1304,10 +1248,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
 	struct rvt_swqe *wqe;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
-		del_timer(&qp->s_timer);
-	}
+	rvt_stop_rc_timers(qp);
 
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 
@@ -1462,8 +1403,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 		 * We got a response so update the timeout.
 		 * 4.096 usec. * (1 << qp->timeout)
 		 */
-		qp->s_flags |= RVT_S_TIMER;
-		mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
+		rvt_mod_retry_timer(qp);
 		if (qp->s_flags & RVT_S_WAIT_ACK) {
 			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			qib_schedule_send(qp);
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 5e9f5e3..58b2841 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -38,44 +38,6 @@
 #include "qib_mad.h"
 
 /*
- * Convert the AETH RNR timeout code into the number of microseconds.
- */
-const u32 ib_qib_rnr_table[32] = {
-	655360,	/* 00: 655.36 */
-	10,	/* 01:    .01 */
-	20,	/* 02     .02 */
-	30,	/* 03:    .03 */
-	40,	/* 04:    .04 */
-	60,	/* 05:    .06 */
-	80,	/* 06:    .08 */
-	120,	/* 07:    .12 */
-	160,	/* 08:    .16 */
-	240,	/* 09:    .24 */
-	320,	/* 0A:    .32 */
-	480,	/* 0B:    .48 */
-	640,	/* 0C:    .64 */
-	960,	/* 0D:    .96 */
-	1280,	/* 0E:   1.28 */
-	1920,	/* 0F:   1.92 */
-	2560,	/* 10:   2.56 */
-	3840,	/* 11:   3.84 */
-	5120,	/* 12:   5.12 */
-	7680,	/* 13:   7.68 */
-	10240,	/* 14:  10.24 */
-	15360,	/* 15:  15.36 */
-	20480,	/* 16:  20.48 */
-	30720,	/* 17:  30.72 */
-	40960,	/* 18:  40.96 */
-	61440,	/* 19:  61.44 */
-	81920,	/* 1A:  81.92 */
-	122880,	/* 1B: 122.88 */
-	163840,	/* 1C: 163.84 */
-	245760,	/* 1D: 245.76 */
-	327680,	/* 1E: 327.68 */
-	491520	/* 1F: 491.52 */
-};
-
-/*
  * Validate a RWQE and fill in the SGE state.
  * Return 1 if OK.
  */
@@ -599,11 +561,8 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
-	sqp->s_flags |= RVT_S_WAIT_RNR;
-	sqp->s_timer.function = qib_rc_rnr_retry;
-	sqp->s_timer.expires = jiffies +
-		usecs_to_jiffies(ib_qib_rnr_table[qp->r_min_rnr_timer]);
-	add_timer(&sqp->s_timer);
+	rvt_add_rnr_timer(sqp, qp->r_min_rnr_timer <<
+				RVT_AETH_CREDIT_SHIFT);
 	goto clr_busy;
 
 op_err:
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 4b54c0d..ee7741e 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1659,6 +1659,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.stop_send_queue = qib_stop_send_queue;
 	dd->verbs_dev.rdi.driver_f.flush_qp_waiters = qib_flush_qp_waiters;
 	dd->verbs_dev.rdi.driver_f.notify_error_qp = qib_notify_error_qp;
+	dd->verbs_dev.rdi.driver_f.notify_restart_rc = qib_restart_rc;
 	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = qib_mtu_to_path_mtu;
 	dd->verbs_dev.rdi.driver_f.mtu_from_qp = qib_mtu_from_qp;
 	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = qib_get_pmtu_from_attr;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 226e81f..1bdfa1c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -279,7 +279,7 @@ int qib_get_counters(struct qib_pportdata *ppd,
 void qib_notify_qp_reset(struct rvt_qp *qp);
 int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
 		  enum ib_qp_type type, u8 port, gfp_t gfp);
-
+void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait);
 #ifdef CONFIG_DEBUG_FS
 
 struct qib_qp_iter;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
