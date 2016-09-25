From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/13] IB/hfi1: Cleanup tasklet refs in comments
Date: Sun, 25 Sep 2016 07:42:08 -0700
Message-ID: <20160925144206.10261.32466.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The code no longer uses tasklets for the send engine. However it does
use a tasklet for sdma but the send routines use a workqueue now days.
Update the comments to reflect that. Make things more generic with
saying "send engine" because that is what is being referred to.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c  |   14 +++++++-------
 drivers/infiniband/hw/hfi1/ruc.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index e9623d0..8bc5013 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -835,7 +835,7 @@ bail_no_tx:
  *
  * This is called from hfi1_rc_rcv() and handle_receive_interrupt().
  * Note that RDMA reads and atomics are handled in the
- * send side QP state and tasklet.
+ * send side QP state and send engine.
  */
 void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 		      int is_fecn)
@@ -911,7 +911,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	if (!pbuf) {
 		/*
 		 * We have no room to send at the moment.  Pass
-		 * responsibility for sending the ACK to the send tasklet
+		 * responsibility for sending the ACK to the send engine
 		 * so that when enough buffer space becomes available,
 		 * the ACK is sent ahead of other outgoing packets.
 		 */
@@ -936,7 +936,7 @@ queue_ack:
 	if (is_fecn)
 		qp->s_flags |= RVT_S_ECN;
 
-	/* Schedule the send tasklet. */
+	/* Schedule the send engine. */
 	hfi1_schedule_send(qp);
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1025,7 +1025,7 @@ done:
 	qp->s_psn = psn;
 	/*
 	 * Set RVT_S_WAIT_PSN as rc_complete() may start the timer
-	 * asynchronously before the send tasklet can get scheduled.
+	 * asynchronously before the send engine can get scheduled.
 	 * Doing it in hfi1_make_rc_req() is too late.
 	 */
 	if ((cmp_psn(qp->s_psn, qp->s_sending_hpsn) <= 0) &&
@@ -1946,7 +1946,7 @@ static noinline int rc_rcv_error(struct ib_other_headers *ohdr, void *data,
 	case OP(FETCH_ADD): {
 		/*
 		 * If we didn't find the atomic request in the ack queue
-		 * or the send tasklet is already backed up to send an
+		 * or the send engine is already backed up to send an
 		 * earlier entry, we can ignore this request.
 		 */
 		if (!e || e->opcode != (u8)opcode || old_req)
@@ -2433,7 +2433,7 @@ send_last:
 		qp->r_nak_state = 0;
 		qp->r_head_ack_queue = next;
 
-		/* Schedule the send tasklet. */
+		/* Schedule the send engine. */
 		qp->s_flags |= RVT_S_RESP_PENDING;
 		hfi1_schedule_send(qp);
 
@@ -2499,7 +2499,7 @@ send_last:
 		qp->r_nak_state = 0;
 		qp->r_head_ack_queue = next;
 
-		/* Schedule the send tasklet. */
+		/* Schedule the send engine. */
 		qp->s_flags |= RVT_S_RESP_PENDING;
 		hfi1_schedule_send(qp);
 
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 7ce2b3c..a1576ae 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -352,7 +352,7 @@ err:
  *
  * This is called from hfi1_do_send() to
  * forward a WQE addressed to the same HFI.
- * Note that although we are single threaded due to the tasklet, we still
+ * Note that although we are single threaded due to the send engine, we still
  * have to protect against post_send().  We don't have to worry about
  * receive interrupts since this is a connected protocol and all packets
  * will pass through here.
@@ -846,7 +846,7 @@ void _hfi1_do_send(struct work_struct *work)
  * @work: contains a pointer to the QP
  *
  * Process entries in the send work queue until credit or queue is
- * exhausted.  Only allow one CPU to send a packet per QP (tasklet).
+ * exhausted.  Only allow one CPU to send a packet per QP.
  * Otherwise, two threads could send packets out of order.
  */
 void hfi1_do_send(struct rvt_qp *qp)
@@ -909,7 +909,7 @@ void hfi1_do_send(struct rvt_qp *qp)
 			spin_unlock_irqrestore(&qp->s_lock, ps.flags);
 			/*
 			 * If the packet cannot be sent now, return and
-			 * the send tasklet will be woken up later.
+			 * the send engine will be woken up later.
 			 */
 			if (hfi1_verbs_send(qp, &ps))
 				return;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
