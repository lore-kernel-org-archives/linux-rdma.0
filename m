From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 15/27] IB/hfi1: Use new rdmavt timers
Date: Wed, 08 Feb 2017 05:27:19 -0800
Message-ID: <20170208132718.16442.86370.stgit@scvm10.sc.intel.com>
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

Reduce hfi1 code footprint by using the rdmavt timers.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c    |    4 -
 drivers/infiniband/hw/hfi1/rc.c    |  194 ++----------------------------------
 drivers/infiniband/hw/hfi1/ruc.c   |   43 --------
 drivers/infiniband/hw/hfi1/verbs.c |    1 
 drivers/infiniband/hw/hfi1/verbs.h |    9 --
 5 files changed, 16 insertions(+), 235 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 319e296..c4ebd09 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -671,8 +671,6 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		iowait_sleep,
 		iowait_wakeup,
 		iowait_sdma_drained);
-	setup_timer(&priv->s_rnr_timer, hfi1_rc_rnr_retry, (unsigned long)qp);
-	qp->s_timer.function = hfi1_rc_timeout;
 	return priv;
 }
 
@@ -713,7 +711,6 @@ void flush_qp_waiters(struct rvt_qp *qp)
 {
 	lockdep_assert_held(&qp->s_lock);
 	flush_iowait(qp);
-	hfi1_stop_rc_timers(qp);
 }
 
 void stop_send_queue(struct rvt_qp *qp)
@@ -721,7 +718,6 @@ void stop_send_queue(struct rvt_qp *qp)
 	struct hfi1_qp_priv *priv = qp->priv;
 
 	cancel_work_sync(&priv->s_iowait.iowork);
-	hfi1_del_timers_sync(qp);
 }
 
 void quiesce_qp(struct rvt_qp *qp)
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index b04a903..c2f1a6f 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -57,133 +57,6 @@
 /* cut down ridiculously long IB macro names */
 #define OP(x) RC_OP(x)
 
-/**
- * hfi1_add_retry_timer - add/start a retry timer
- * @qp - the QP
- *
- * add a retry timer on the QP
- */
-static inline void hfi1_add_retry_timer(struct rvt_qp *qp)
-{
-	struct ib_qp *ibqp = &qp->ibqp;
-	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
-
-	lockdep_assert_held(&qp->s_lock);
-	qp->s_flags |= RVT_S_TIMER;
-	/* 4.096 usec. * (1 << qp->timeout) */
-	qp->s_timer.expires = jiffies + qp->timeout_jiffies +
-			      rdi->busy_jiffies;
-	add_timer(&qp->s_timer);
-}
-
-/**
- * hfi1_add_rnr_timer - add/start an rnr timer
- * @qp - the QP
- * @to - timeout in usecs
- *
- * add an rnr timer on the QP
- */
-void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	lockdep_assert_held(&qp->s_lock);
-	qp->s_flags |= RVT_S_WAIT_RNR;
-	priv->s_rnr_timer.expires = jiffies + usecs_to_jiffies(to);
-	add_timer(&priv->s_rnr_timer);
-}
-
-/**
- * hfi1_mod_retry_timer - mod a retry timer
- * @qp - the QP
- *
- * Modify a potentially already running retry
- * timer
- */
-static inline void hfi1_mod_retry_timer(struct rvt_qp *qp)
-{
-	struct ib_qp *ibqp = &qp->ibqp;
-	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
-
-	lockdep_assert_held(&qp->s_lock);
-	qp->s_flags |= RVT_S_TIMER;
-	/* 4.096 usec. * (1 << qp->timeout) */
-	mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies +
-		  rdi->busy_jiffies);
-}
-
-/**
- * hfi1_stop_retry_timer - stop a retry timer
- * @qp - the QP
- *
- * stop a retry timer and return if the timer
- * had been pending.
- */
-static inline int hfi1_stop_retry_timer(struct rvt_qp *qp)
-{
-	int rval = 0;
-
-	lockdep_assert_held(&qp->s_lock);
-	/* Remove QP from retry */
-	if (qp->s_flags & RVT_S_TIMER) {
-		qp->s_flags &= ~RVT_S_TIMER;
-		rval = del_timer(&qp->s_timer);
-	}
-	return rval;
-}
-
-/**
- * hfi1_stop_rc_timers - stop all timers
- * @qp - the QP
- *
- * stop any pending timers
- */
-void hfi1_stop_rc_timers(struct rvt_qp *qp)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	lockdep_assert_held(&qp->s_lock);
-	/* Remove QP from all timers */
-	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
-		del_timer(&qp->s_timer);
-		del_timer(&priv->s_rnr_timer);
-	}
-}
-
-/**
- * hfi1_stop_rnr_timer - stop an rnr timer
- * @qp - the QP
- *
- * stop an rnr timer and return if the timer
- * had been pending.
- */
-static inline int hfi1_stop_rnr_timer(struct rvt_qp *qp)
-{
-	int rval = 0;
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	lockdep_assert_held(&qp->s_lock);
-	/* Remove QP from rnr timer */
-	if (qp->s_flags & RVT_S_WAIT_RNR) {
-		qp->s_flags &= ~RVT_S_WAIT_RNR;
-		rval = del_timer(&priv->s_rnr_timer);
-	}
-	return rval;
-}
-
-/**
- * hfi1_del_timers_sync - wait for any timeout routines to exit
- * @qp - the QP
- */
-void hfi1_del_timers_sync(struct rvt_qp *qp)
-{
-	struct hfi1_qp_priv *priv = qp->priv;
-
-	del_timer_sync(&qp->s_timer);
-	del_timer_sync(&priv->s_rnr_timer);
-}
-
 static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
 {
@@ -1043,7 +916,7 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
  * Back up requester to resend the last un-ACKed request.
  * The QP r_lock and s_lock should be held and interrupts disabled.
  */
-static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
+void hfi1_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 {
 	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	struct hfi1_ibport *ibp;
@@ -1080,44 +953,6 @@ static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 }
 
 /*
- * This is called from s_timer for missing responses.
- */
-void hfi1_rc_timeout(unsigned long arg)
-{
-	struct rvt_qp *qp = (struct rvt_qp *)arg;
-	struct hfi1_ibport *ibp;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qp->r_lock, flags);
-	spin_lock(&qp->s_lock);
-	if (qp->s_flags & RVT_S_TIMER) {
-		ibp = to_iport(qp->ibqp.device, qp->port_num);
-		ibp->rvp.n_rc_timeouts++;
-		qp->s_flags &= ~RVT_S_TIMER;
-		del_timer(&qp->s_timer);
-		trace_hfi1_timeout(qp, qp->s_last_psn + 1);
-		restart_rc(qp, qp->s_last_psn + 1, 1);
-		hfi1_schedule_send(qp);
-	}
-	spin_unlock(&qp->s_lock);
-	spin_unlock_irqrestore(&qp->r_lock, flags);
-}
-
-/*
- * This is called from s_timer for RNR timeouts.
- */
-void hfi1_rc_rnr_retry(unsigned long arg)
-{
-	struct rvt_qp *qp = (struct rvt_qp *)arg;
-	unsigned long flags;
-
-	spin_lock_irqsave(&qp->s_lock, flags);
-	hfi1_stop_rnr_timer(qp);
-	hfi1_schedule_send(qp);
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-}
-
-/*
  * Set qp->s_sending_psn to the next PSN after the given one.
  * This would be psn+1 except when RDMA reads are present.
  */
@@ -1183,7 +1018,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 	    !(qp->s_flags &
 		(RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
 		(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
-		hfi1_add_retry_timer(qp);
+		rvt_add_retry_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
 		u32 s_last;
@@ -1313,7 +1148,6 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	int ret = 0;
 	u32 ack_psn;
 	int diff;
-	unsigned long to;
 
 	lockdep_assert_held(&qp->s_lock);
 	/*
@@ -1362,7 +1196,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			/* Retry this request. */
 			if (!(qp->r_flags & RVT_R_RDMAR_SEQ)) {
 				qp->r_flags |= RVT_R_RDMAR_SEQ;
-				restart_rc(qp, qp->s_last_psn + 1, 0);
+				hfi1_restart_rc(qp, qp->s_last_psn + 1, 0);
 				if (list_empty(&qp->rspwait)) {
 					qp->r_flags |= RVT_R_RSP_SEND;
 					rvt_get_qp(qp);
@@ -1411,7 +1245,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			 * We are expecting more ACKs so
 			 * mod the retry timer.
 			 */
-			hfi1_mod_retry_timer(qp);
+			rvt_mod_retry_timer(qp);
 			/*
 			 * We can stop re-sending the earlier packets and
 			 * continue with the next packet the receiver wants.
@@ -1420,7 +1254,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 				reset_psn(qp, psn + 1);
 		} else {
 			/* No more acks - kill all timers */
-			hfi1_stop_rc_timers(qp);
+			rvt_stop_rc_timers(qp);
 			if (cmp_psn(qp->s_psn, psn) <= 0) {
 				qp->s_state = OP(SEND_LAST);
 				qp->s_psn = psn + 1;
@@ -1457,11 +1291,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		reset_psn(qp, psn);
 
 		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
-		hfi1_stop_rc_timers(qp);
-		to =
-			ib_hfi1_rnr_table[(aeth >> RVT_AETH_CREDIT_SHIFT) &
-					   RVT_AETH_CREDIT_MASK];
-		hfi1_add_rnr_timer(qp, to);
+		rvt_stop_rc_timers(qp);
+		rvt_add_rnr_timer(qp, aeth);
 		return 0;
 
 	case 3:         /* NAK */
@@ -1479,7 +1310,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			 * RDMA READ response which terminates the RDMA
 			 * READ.
 			 */
-			restart_rc(qp, psn, 0);
+			hfi1_restart_rc(qp, psn, 0);
 			hfi1_schedule_send(qp);
 			break;
 
@@ -1518,7 +1349,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	}
 	/* cannot be reached  */
 bail_stop:
-	hfi1_stop_rc_timers(qp);
+	rvt_stop_rc_timers(qp);
 	return ret;
 }
 
@@ -1533,7 +1364,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 
 	lockdep_assert_held(&qp->s_lock);
 	/* Remove QP from retry timer */
-	hfi1_stop_rc_timers(qp);
+	rvt_stop_rc_timers(qp);
 
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 
@@ -1547,7 +1378,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 
 	ibp->rvp.n_rdma_seq++;
 	qp->r_flags |= RVT_R_RDMAR_SEQ;
-	restart_rc(qp, qp->s_last_psn + 1, 0);
+	hfi1_restart_rc(qp, qp->s_last_psn + 1, 0);
 	if (list_empty(&qp->rspwait)) {
 		qp->r_flags |= RVT_R_RSP_SEND;
 		rvt_get_qp(qp);
@@ -1661,8 +1492,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		 * We got a response so update the timeout.
 		 * 4.096 usec. * (1 << qp->timeout)
 		 */
-		qp->s_flags |= RVT_S_TIMER;
-		mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
+		rvt_mod_retry_timer(qp);
 		if (qp->s_flags & RVT_S_WAIT_ACK) {
 			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			hfi1_schedule_send(qp);
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index a1e2b6a..dc41b2c 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -54,44 +54,6 @@
 #include "trace.h"
 
 /*
- * Convert the AETH RNR timeout code into the number of microseconds.
- */
-const u32 ib_hfi1_rnr_table[32] = {
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
@@ -361,7 +323,6 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	int release;
 	int ret;
 	int copy_last = 0;
-	u32 to;
 	int local_ops = 0;
 
 	rcu_read_lock();
@@ -618,8 +579,8 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
-	to = ib_hfi1_rnr_table[qp->r_min_rnr_timer];
-	hfi1_add_rnr_timer(sqp, to);
+	rvt_add_rnr_timer(sqp, qp->r_min_rnr_timer <<
+				RVT_AETH_CREDIT_SHIFT);
 	goto clr_busy;
 
 op_err:
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index b937a23..cae3230 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1845,6 +1845,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = mtu_to_path_mtu;
 	dd->verbs_dev.rdi.driver_f.check_modify_qp = hfi1_check_modify_qp;
 	dd->verbs_dev.rdi.driver_f.modify_qp = hfi1_modify_qp;
+	dd->verbs_dev.rdi.driver_f.notify_restart_rc = hfi1_restart_rc;
 	dd->verbs_dev.rdi.driver_f.check_send_wqe = hfi1_check_send_wqe;
 
 	/* completeion queue */
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index f359684..6e9e4bb 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -127,7 +127,6 @@ struct hfi1_qp_priv {
 	u8 s_sc;		                  /* SC[0..4] for next packet */
 	u8 r_adefered;                            /* number of acks defered */
 	struct iowait s_iowait;
-	struct timer_list s_rnr_timer;
 	struct rvt_qp *owner;
 };
 
@@ -310,12 +309,6 @@ void hfi1_rc_hdrerr(
 
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid);
 
-void hfi1_rc_rnr_retry(unsigned long arg);
-void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to);
-void hfi1_rc_timeout(unsigned long arg);
-void hfi1_del_timers_sync(struct rvt_qp *qp);
-void hfi1_stop_rc_timers(struct rvt_qp *qp);
-
 void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr);
 
 void hfi1_ud_rcv(struct hfi1_packet *packet);
@@ -331,7 +324,7 @@ int hfi1_check_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 
 void hfi1_modify_qp(struct rvt_qp *qp, struct ib_qp_attr *attr,
 		    int attr_mask, struct ib_udata *udata);
-
+void hfi1_restart_rc(struct rvt_qp *qp, u32 psn, int wait);
 int hfi1_check_send_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe);
 
 extern const u32 rc_only_opcode;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
