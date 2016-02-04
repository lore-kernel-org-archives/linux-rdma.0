From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/5] staging/rdma/hfi1: use new timer routines
Date: Thu, 04 Feb 2016 10:59:09 -0800
Message-ID: <20160204185906.6973.19856.stgit@scvm10.sc.intel.com>
References: <20160204185718.6973.92668.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204185718.6973.92668.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the new timer routines.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c |   39 ++++++++++-----------------------------
 1 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 350faaa..5c32182 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -183,15 +183,6 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
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
  * make_rc_ack - construct a response packet (ACK, NAK, or RDMA read)
  * @dev: the device for this QP
@@ -1054,11 +1045,8 @@ void hfi1_rc_rnr_retry(unsigned long arg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (qp->s_flags & RVT_S_WAIT_RNR) {
-		qp->s_flags &= ~RVT_S_WAIT_RNR;
-		del_timer(&qp->s_timer);
-		hfi1_schedule_send(qp);
-	}
+	hfi1_stop_rnr_timer(qp);
+	hfi1_schedule_send(qp);
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 
@@ -1128,7 +1116,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	    !(qp->s_flags &
 		(RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
 		(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
-		start_timer(qp);
+		hfi1_add_retry_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
 		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
@@ -1276,12 +1264,10 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	int ret = 0;
 	u32 ack_psn;
 	int diff;
+	unsigned long to;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
-		del_timer(&qp->s_timer);
-	}
+	hfi1_stop_rc_timers(qp);
 
 	/*
 	 * Note that NAKs implicitly ACK outstanding SEND and RDMA write
@@ -1378,7 +1364,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			 * We are expecting more ACKs so
 			 * reset the re-transmit timer.
 			 */
-			start_timer(qp);
+			hfi1_add_retry_timer(qp);
 			/*
 			 * We can stop re-sending the earlier packets and
 			 * continue with the next packet the receiver wants.
@@ -1421,12 +1407,10 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		reset_psn(qp, psn);
 
 		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
-		qp->s_flags |= RVT_S_WAIT_RNR;
-		qp->s_timer.function = hfi1_rc_rnr_retry;
-		qp->s_timer.expires = jiffies + usecs_to_jiffies(
+		to =
 			ib_hfi1_rnr_table[(aeth >> HFI1_AETH_CREDIT_SHIFT) &
-					   HFI1_AETH_CREDIT_MASK]);
-		add_timer(&qp->s_timer);
+					   HFI1_AETH_CREDIT_MASK];
+		hfi1_add_rnr_timer(qp, to);
 		goto bail;
 
 	case 3:         /* NAK */
@@ -1496,10 +1480,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 	struct rvt_swqe *wqe;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
-		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
-		del_timer(&qp->s_timer);
-	}
+	hfi1_stop_rc_timers(qp);
 
 	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
