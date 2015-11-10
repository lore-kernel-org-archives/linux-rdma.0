From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] staging/rdma/hfi1: add common routine for queuing acks
Date: Tue, 10 Nov 2015 09:13:55 -0500
Message-ID: <20151110141355.30166.93359.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch is a prelimary patch required to
coalesce acks.

The routine to "schedule" a QP for sending a NAK is
now centralized in rc_defer_ack().  The flag is changed
for clarity since the all acks will potentially use
the deferral  mechanism.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |    4 ++-
 drivers/staging/rdma/hfi1/rc.c     |   42 +++++++++++++-----------------------
 drivers/staging/rdma/hfi1/verbs.h  |   12 ++++++----
 3 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ce69141..e8e0f55 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -721,8 +721,8 @@ static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 	 */
 	list_for_each_entry_safe(qp, nqp, &rcd->qp_wait_list, rspwait) {
 		list_del_init(&qp->rspwait);
-		if (qp->r_flags & HFI1_R_RSP_NAK) {
-			qp->r_flags &= ~HFI1_R_RSP_NAK;
+		if (qp->r_flags & HFI1_R_RSP_DEFERED_ACK) {
+			qp->r_flags &= ~HFI1_R_RSP_DEFERED_ACK;
 			hfi1_send_rc_ack(rcd, qp, 0);
 		}
 		if (qp->r_flags & HFI1_R_RSP_SEND) {
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 0b19206..6fe0104 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1608,6 +1608,16 @@ bail:
 	return;
 }
 
+static inline void rc_defered_ack(struct hfi1_ctxtdata *rcd,
+				  struct hfi1_qp *qp)
+{
+	if (list_empty(&qp->rspwait)) {
+		qp->r_flags |= HFI1_R_RSP_DEFERED_ACK;
+		atomic_inc(&qp->refcount);
+		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
+	}
+}
+
 /**
  * rc_rcv_error - process an incoming duplicate or error RC packet
  * @ohdr: the other headers for this packet
@@ -1650,11 +1660,7 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 			 * in the receive queue have been processed.
 			 * Otherwise, we end up propagating congestion.
 			 */
-			if (list_empty(&qp->rspwait)) {
-				qp->r_flags |= HFI1_R_RSP_NAK;
-				atomic_inc(&qp->refcount);
-				list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
-			}
+			rc_defered_ack(rcd, qp);
 		}
 		goto done;
 	}
@@ -2337,11 +2343,7 @@ rnr_nak:
 	qp->r_nak_state = IB_RNR_NAK | qp->r_min_rnr_timer;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue RNR NAK for later */
-	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= HFI1_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
-		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
-	}
+	rc_defered_ack(rcd, qp);
 	return;
 
 nack_op_err:
@@ -2349,11 +2351,7 @@ nack_op_err:
 	qp->r_nak_state = IB_NAK_REMOTE_OPERATIONAL_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
-	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= HFI1_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
-		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
-	}
+	rc_defered_ack(rcd, qp);
 	return;
 
 nack_inv_unlck:
@@ -2363,11 +2361,7 @@ nack_inv:
 	qp->r_nak_state = IB_NAK_INVALID_REQUEST;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
-	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= HFI1_R_RSP_NAK;
-		atomic_inc(&qp->refcount);
-		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
-	}
+	rc_defered_ack(rcd, qp);
 	return;
 
 nack_acc_unlck:
@@ -2421,13 +2415,7 @@ void hfi1_rc_hdrerr(
 			 * Otherwise, we end up
 			 * propagating congestion.
 			 */
-			if (list_empty(&qp->rspwait)) {
-				qp->r_flags |= HFI1_R_RSP_NAK;
-				atomic_inc(&qp->refcount);
-				list_add_tail(
-					&qp->rspwait,
-					&rcd->qp_wait_list);
-				}
+			rc_defered_ack(rcd, qp);
 		} /* Out of sequence NAK */
 	} /* QP Request NAKs */
 }
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index e4a8a0d..c5e6f47 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -547,11 +547,13 @@ struct hfi1_qp {
 /*
  * Bit definitions for r_flags.
  */
-#define HFI1_R_REUSE_SGE 0x01
-#define HFI1_R_RDMAR_SEQ 0x02
-#define HFI1_R_RSP_NAK   0x04
-#define HFI1_R_RSP_SEND  0x08
-#define HFI1_R_COMM_EST  0x10
+#define HFI1_R_REUSE_SGE       0x01
+#define HFI1_R_RDMAR_SEQ       0x02
+/* defer ack until end of interrupt session */
+#define HFI1_R_RSP_DEFERED_ACK 0x04
+/* relay ack to send engine */
+#define HFI1_R_RSP_SEND        0x08
+#define HFI1_R_COMM_EST        0x10
 
 /*
  * Bit definitions for s_flags.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
