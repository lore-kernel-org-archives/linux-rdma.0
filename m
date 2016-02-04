From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/5] staging/rdma/hfi1: use mod_timer when appropriate
Date: Thu, 04 Feb 2016 10:59:18 -0800
Message-ID: <20160204185914.6973.72636.stgit@scvm10.sc.intel.com>
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

Use new timer API to optimize maintenance of
timers during ACK processing.

When we are still expecting ACKs, mod the timer
to avoid a heavyweight delete/add. Otherwise, insure
do_rc_ack() maintains the timer as it had.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c |   42 +++++++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 5c32182..700d849 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1266,9 +1266,6 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	int diff;
 	unsigned long to;
 
-	/* Remove QP from retry timer */
-	hfi1_stop_rc_timers(qp);
-
 	/*
 	 * Note that NAKs implicitly ACK outstanding SEND and RDMA write
 	 * requests and implicitly NAK RDMA read and atomic requests issued
@@ -1296,7 +1293,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		    opcode == OP(RDMA_READ_RESPONSE_ONLY) &&
 		    diff == 0) {
 			ret = 1;
-			goto bail;
+			goto bail_stop;
 		}
 		/*
 		 * If this request is a RDMA read or atomic, and the ACK is
@@ -1327,7 +1324,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			 * No need to process the ACK/NAK since we are
 			 * restarting an earlier request.
 			 */
-			goto bail;
+			goto bail_stop;
 		}
 		if (wqe->wr.opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
 		    wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) {
@@ -1362,18 +1359,22 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		if (qp->s_acked != qp->s_tail) {
 			/*
 			 * We are expecting more ACKs so
-			 * reset the re-transmit timer.
+			 * mod the retry timer.
 			 */
-			hfi1_add_retry_timer(qp);
+			hfi1_mod_retry_timer(qp);
 			/*
 			 * We can stop re-sending the earlier packets and
 			 * continue with the next packet the receiver wants.
 			 */
 			if (cmp_psn(qp->s_psn, psn) <= 0)
 				reset_psn(qp, psn + 1);
-		} else if (cmp_psn(qp->s_psn, psn) <= 0) {
-			qp->s_state = OP(SEND_LAST);
-			qp->s_psn = psn + 1;
+		} else {
+			/* No more acks - kill all timers */
+			hfi1_stop_rc_timers(qp);
+			if (cmp_psn(qp->s_psn, psn) <= 0) {
+				qp->s_state = OP(SEND_LAST);
+				qp->s_psn = psn + 1;
+			}
 		}
 		if (qp->s_flags & RVT_S_WAIT_ACK) {
 			qp->s_flags &= ~RVT_S_WAIT_ACK;
@@ -1383,15 +1384,14 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		qp->s_rnr_retry = qp->s_rnr_retry_cnt;
 		qp->s_retry = qp->s_retry_cnt;
 		update_last_psn(qp, psn);
-		ret = 1;
-		goto bail;
+		return 1;
 
 	case 1:         /* RNR NAK */
 		ibp->rvp.n_rnr_naks++;
 		if (qp->s_acked == qp->s_tail)
-			goto bail;
+			goto bail_stop;
 		if (qp->s_flags & RVT_S_WAIT_RNR)
-			goto bail;
+			goto bail_stop;
 		if (qp->s_rnr_retry == 0) {
 			status = IB_WC_RNR_RETRY_EXC_ERR;
 			goto class_b;
@@ -1407,15 +1407,16 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		reset_psn(qp, psn);
 
 		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
+		hfi1_stop_rc_timers(qp);
 		to =
 			ib_hfi1_rnr_table[(aeth >> HFI1_AETH_CREDIT_SHIFT) &
 					   HFI1_AETH_CREDIT_MASK];
 		hfi1_add_rnr_timer(qp, to);
-		goto bail;
+		return 0;
 
 	case 3:         /* NAK */
 		if (qp->s_acked == qp->s_tail)
-			goto bail;
+			goto bail_stop;
 		/* The last valid PSN is the previous PSN. */
 		update_last_psn(qp, psn - 1);
 		switch ((aeth >> HFI1_AETH_CREDIT_SHIFT) &
@@ -1458,15 +1459,16 @@ class_b:
 		}
 		qp->s_retry = qp->s_retry_cnt;
 		qp->s_rnr_retry = qp->s_rnr_retry_cnt;
-		goto bail;
+		goto bail_stop;
 
 	default:                /* 2: reserved */
 reserved:
 		/* Ignore reserved NAK codes. */
-		goto bail;
+		goto bail_stop;
 	}
-
-bail:
+	return ret;
+bail_stop:
+	hfi1_stop_rc_timers(qp);
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
