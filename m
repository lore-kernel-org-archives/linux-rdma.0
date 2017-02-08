From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/27] IB/hfi1: Process qp wait list in IRQ thread
 periodically
Date: Wed, 08 Feb 2017 05:26:02 -0800
Message-ID: <20170208132601.16442.69915.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In the event that the IRQ thread is extremely busy, the
processing of an rcd wait list can be delayed by quite
a bit until the IRQ thread completes its work.

The QP reset reference count wait can then appear to be stuck, thus
causing up a QP destroy to emit the hung task diagnostic.

Fix by processing the qp wait list periodically from the thread.  The
interval is a multiple (currently 4) of the MAX_PKT_RECV.

Also, reduce some of the excessive inlining.   The guidelines
are per packet is ok inline, otherwise the choice is based on
likelyhood of execution.

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c |  121 +++++++++++++++++++----------------
 1 files changed, 67 insertions(+), 54 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 4fbaee6..29db673 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -100,6 +100,11 @@
  * MAX_PKT_RCV is the max # if packets processed per receive interrupt.
  */
 #define MAX_PKT_RECV 64
+/*
+ * MAX_PKT_THREAD_RCV is the max # of packets processed before
+ * the qp_wait_list queue is flushed.
+ */
+#define MAX_PKT_RECV_THREAD (MAX_PKT_RECV * 4)
 #define EGR_HEAD_UPDATE_THRESHOLD 16
 
 struct hfi1_ib_stats hfi1_stats;
@@ -259,7 +264,7 @@ int hfi1_count_units(int *npresentp, int *nupp)
  * allowed size ranges for the respective type and, optionally,
  * return the proper encoding.
  */
-inline int hfi1_rcvbuf_validate(u32 size, u8 type, u16 *encoded)
+int hfi1_rcvbuf_validate(u32 size, u8 type, u16 *encoded)
 {
 	if (unlikely(!PAGE_ALIGNED(size)))
 		return 0;
@@ -654,24 +659,68 @@ static void __prescan_rxq(struct hfi1_packet *packet)
 	}
 }
 
-static inline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
+static void process_rcv_qp_work(struct hfi1_ctxtdata *rcd)
+{
+	struct rvt_qp *qp, *nqp;
+
+	/*
+	 * Iterate over all QPs waiting to respond.
+	 * The list won't change since the IRQ is only run on one CPU.
+	 */
+	list_for_each_entry_safe(qp, nqp, &rcd->qp_wait_list, rspwait) {
+		list_del_init(&qp->rspwait);
+		if (qp->r_flags & RVT_R_RSP_NAK) {
+			qp->r_flags &= ~RVT_R_RSP_NAK;
+			hfi1_send_rc_ack(rcd, qp, 0);
+		}
+		if (qp->r_flags & RVT_R_RSP_SEND) {
+			unsigned long flags;
+
+			qp->r_flags &= ~RVT_R_RSP_SEND;
+			spin_lock_irqsave(&qp->s_lock, flags);
+			if (ib_rvt_state_ops[qp->state] &
+					RVT_PROCESS_OR_FLUSH_SEND)
+				hfi1_schedule_send(qp);
+			spin_unlock_irqrestore(&qp->s_lock, flags);
+		}
+		rvt_put_qp(qp);
+	}
+}
+
+static noinline int max_packet_exceeded(struct hfi1_packet *packet, int thread)
+{
+	if (thread) {
+		if ((packet->numpkt & (MAX_PKT_RECV_THREAD - 1)) == 0)
+			/* allow defered processing */
+			process_rcv_qp_work(packet->rcd);
+		cond_resched();
+		return RCV_PKT_OK;
+	} else {
+		this_cpu_inc(*packet->rcd->dd->rcv_limit);
+		return RCV_PKT_LIMIT;
+	}
+}
+
+static inline int check_max_packet(struct hfi1_packet *packet, int thread)
 {
 	int ret = RCV_PKT_OK;
 
+	if (unlikely((packet->numpkt & (MAX_PKT_RECV - 1)) == 0))
+		ret = max_packet_exceeded(packet, thread);
+	return ret;
+}
+
+static noinline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
+{
+	int ret;
+
 	/* Set up for the next packet */
 	packet->rhqoff += packet->rsize;
 	if (packet->rhqoff >= packet->maxcnt)
 		packet->rhqoff = 0;
 
 	packet->numpkt++;
-	if (unlikely((packet->numpkt & (MAX_PKT_RECV - 1)) == 0)) {
-		if (thread) {
-			cond_resched();
-		} else {
-			ret = RCV_PKT_LIMIT;
-			this_cpu_inc(*packet->rcd->dd->rcv_limit);
-		}
-	}
+	ret = check_max_packet(packet, thread);
 
 	packet->rhf_addr = (__le32 *)packet->rcd->rcvhdrq + packet->rhqoff +
 				     packet->rcd->dd->rhf_offset;
@@ -682,7 +731,7 @@ static inline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
 
 static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 {
-	int ret = RCV_PKT_OK;
+	int ret;
 
 	packet->hdr = hfi1_get_msgheader(packet->rcd->dd,
 					 packet->rhf_addr);
@@ -723,14 +772,7 @@ static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 	if (packet->rhqoff >= packet->maxcnt)
 		packet->rhqoff = 0;
 
-	if (unlikely((packet->numpkt & (MAX_PKT_RECV - 1)) == 0)) {
-		if (thread) {
-			cond_resched();
-		} else {
-			ret = RCV_PKT_LIMIT;
-			this_cpu_inc(*packet->rcd->dd->rcv_limit);
-		}
-	}
+	ret = check_max_packet(packet, thread);
 
 	packet->rhf_addr = (__le32 *)packet->rcd->rcvhdrq + packet->rhqoff +
 				      packet->rcd->dd->rhf_offset;
@@ -767,38 +809,6 @@ static inline void finish_packet(struct hfi1_packet *packet)
 		       packet->etail, rcv_intr_dynamic, packet->numpkt);
 }
 
-static inline void process_rcv_qp_work(struct hfi1_packet *packet)
-{
-	struct hfi1_ctxtdata *rcd;
-	struct rvt_qp *qp, *nqp;
-
-	rcd = packet->rcd;
-	rcd->head = packet->rhqoff;
-
-	/*
-	 * Iterate over all QPs waiting to respond.
-	 * The list won't change since the IRQ is only run on one CPU.
-	 */
-	list_for_each_entry_safe(qp, nqp, &rcd->qp_wait_list, rspwait) {
-		list_del_init(&qp->rspwait);
-		if (qp->r_flags & RVT_R_RSP_NAK) {
-			qp->r_flags &= ~RVT_R_RSP_NAK;
-			hfi1_send_rc_ack(rcd, qp, 0);
-		}
-		if (qp->r_flags & RVT_R_RSP_SEND) {
-			unsigned long flags;
-
-			qp->r_flags &= ~RVT_R_RSP_SEND;
-			spin_lock_irqsave(&qp->s_lock, flags);
-			if (ib_rvt_state_ops[qp->state] &
-					RVT_PROCESS_OR_FLUSH_SEND)
-				hfi1_schedule_send(qp);
-			spin_unlock_irqrestore(&qp->s_lock, flags);
-		}
-		rvt_put_qp(qp);
-	}
-}
-
 /*
  * Handle receive interrupts when using the no dma rtail option.
  */
@@ -826,7 +836,8 @@ int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
 	}
-	process_rcv_qp_work(&packet);
+	process_rcv_qp_work(rcd);
+	rcd->head = packet.rhqoff;
 bail:
 	finish_packet(&packet);
 	return last;
@@ -854,7 +865,8 @@ int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 			last = RCV_PKT_DONE;
 		process_rcv_update(last, &packet);
 	}
-	process_rcv_qp_work(&packet);
+	process_rcv_qp_work(rcd);
+	rcd->head = packet.rhqoff;
 bail:
 	finish_packet(&packet);
 	return last;
@@ -1024,7 +1036,8 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 		process_rcv_update(last, &packet);
 	}
 
-	process_rcv_qp_work(&packet);
+	process_rcv_qp_work(rcd);
+	rcd->head = packet.rhqoff;
 
 bail:
 	/*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
