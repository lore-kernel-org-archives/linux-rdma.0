From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/27] IB/hfi1, qib,
 rdmavt: Move two IB event functions into rdmavt
Date: Wed, 08 Feb 2017 05:27:01 -0800
Message-ID: <20170208132700.16442.83927.stgit@scvm10.sc.intel.com>
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

Add rvt_rc_error() and rvt_comm_est() as shared functions in
rdmavt, moved from hfi1/qib logic.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c       |   13 -----------
 drivers/infiniband/hw/hfi1/qp.h       |    6 -----
 drivers/infiniband/hw/hfi1/rc.c       |   27 +++--------------------
 drivers/infiniband/hw/hfi1/ruc.c      |    2 +-
 drivers/infiniband/hw/hfi1/uc.c       |    4 ++-
 drivers/infiniband/hw/hfi1/ud.c       |    4 ++-
 drivers/infiniband/hw/hfi1/verbs.h    |    2 --
 drivers/infiniband/hw/qib/qib_rc.c    |   38 ++++-----------------------------
 drivers/infiniband/hw/qib/qib_ruc.c   |    2 +-
 drivers/infiniband/hw/qib/qib_uc.c    |   15 +++----------
 drivers/infiniband/hw/qib/qib_ud.c    |    4 ++-
 drivers/infiniband/hw/qib/qib_verbs.h |    2 --
 drivers/infiniband/sw/rdmavt/qp.c     |   38 +++++++++++++++++++++++++++++++++
 include/rdma/rdmavt_qp.h              |    2 ++
 14 files changed, 60 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 48d59e7..8f66c58 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -784,19 +784,6 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   qp->pid);
 }
 
-void qp_comm_est(struct rvt_qp *qp)
-{
-	qp->r_flags |= RVT_R_COMM_EST;
-	if (qp->ibqp.event_handler) {
-		struct ib_event ev;
-
-		ev.device = qp->ibqp.device;
-		ev.element.qp = &qp->ibqp;
-		ev.event = IB_EVENT_COMM_EST;
-		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-	}
-}
-
 void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		    gfp_t gfp)
 {
diff --git a/drivers/infiniband/hw/hfi1/qp.h b/drivers/infiniband/hw/hfi1/qp.h
index 587d84d..4012fc5 100644
--- a/drivers/infiniband/hw/hfi1/qp.h
+++ b/drivers/infiniband/hw/hfi1/qp.h
@@ -131,12 +131,6 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
  */
 void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
 
-/**
- * qp_comm_est - handle trap with QP established
- * @qp: the QP
- */
-void qp_comm_est(struct rvt_qp *qp);
-
 void _hfi1_schedule_send(struct rvt_qp *qp);
 void hfi1_schedule_send(struct rvt_qp *qp);
 
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index abea4b7..bb52715 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1966,25 +1966,6 @@ static noinline int rc_rcv_error(struct ib_other_headers *ohdr, void *data,
 	return 0;
 }
 
-void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
-{
-	unsigned long flags;
-	int lastwqe;
-
-	spin_lock_irqsave(&qp->s_lock, flags);
-	lastwqe = rvt_error_qp(qp, err);
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-
-	if (lastwqe) {
-		struct ib_event ev;
-
-		ev.device = qp->ibqp.device;
-		ev.element.qp = &qp->ibqp;
-		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
-		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-	}
-}
-
 static inline void update_ack_queue(struct rvt_qp *qp, unsigned n)
 {
 	unsigned next;
@@ -2185,7 +2166,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	}
 
 	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST))
-		qp_comm_est(qp);
+		rvt_comm_est(qp);
 
 	/* OK, process the packet. */
 	switch (opcode) {
@@ -2517,7 +2498,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	return;
 
 nack_op_err:
-	hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	qp->r_nak_state = IB_NAK_REMOTE_OPERATIONAL_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
@@ -2527,7 +2508,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 nack_inv_unlck:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 nack_inv:
-	hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	qp->r_nak_state = IB_NAK_INVALID_REQUEST;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
@@ -2537,7 +2518,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 nack_acc_unlck:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 nack_acc:
-	hfi1_rc_error(qp, IB_WC_LOC_PROT_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_PROT_ERR);
 	qp->r_nak_state = IB_NAK_REMOTE_ACCESS_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 send_ack:
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 717ed4b..a1e2b6a 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -637,7 +637,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	wc.status = IB_WC_LOC_PROT_ERR;
 err:
 	/* responder goes to error state */
-	hfi1_rc_error(qp, wc.status);
+	rvt_rc_error(qp, wc.status);
 
 serr:
 	spin_lock_irqsave(&sqp->s_lock, flags);
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 74b7b2b..782a0bf 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -384,7 +384,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	}
 
 	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST))
-		qp_comm_est(qp);
+		rvt_comm_est(qp);
 
 	/* OK, process the packet. */
 	switch (opcode) {
@@ -584,5 +584,5 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 	return;
 
 op_err:
-	hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 }
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 6d81d79..58cd301 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -167,7 +167,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0) {
-			hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+			rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 			goto bail_unlock;
 		}
 		if (!ret) {
@@ -796,7 +796,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 
 		ret = hfi1_rvt_get_rwqe(qp, 0);
 		if (ret < 0) {
-			hfi1_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+			rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 			return;
 		}
 		if (!ret) {
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index e6b8930..39b0074 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -327,8 +327,6 @@ void hfi1_rc_hdrerr(
 
 void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr);
 
-void hfi1_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
-
 void hfi1_ud_rcv(struct hfi1_packet *packet);
 
 int hfi1_lookup_pkey_idx(struct hfi1_ibport *ibp, u16 pkey);
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 696bcd0..5b0d01b 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1765,25 +1765,6 @@ static int qib_rc_rcv_error(struct ib_other_headers *ohdr,
 	return 0;
 }
 
-void qib_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
-{
-	unsigned long flags;
-	int lastwqe;
-
-	spin_lock_irqsave(&qp->s_lock, flags);
-	lastwqe = rvt_error_qp(qp, err);
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-
-	if (lastwqe) {
-		struct ib_event ev;
-
-		ev.device = qp->ibqp.device;
-		ev.element.qp = &qp->ibqp;
-		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
-		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-	}
-}
-
 static inline void qib_update_ack_queue(struct rvt_qp *qp, unsigned n)
 {
 	unsigned next;
@@ -1895,17 +1876,8 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		break;
 	}
 
-	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST)) {
-		qp->r_flags |= RVT_R_COMM_EST;
-		if (qp->ibqp.event_handler) {
-			struct ib_event ev;
-
-			ev.device = qp->ibqp.device;
-			ev.element.qp = &qp->ibqp;
-			ev.event = IB_EVENT_COMM_EST;
-			qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-		}
-	}
+	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST))
+		rvt_comm_est(qp);
 
 	/* OK, process the packet. */
 	switch (opcode) {
@@ -2197,7 +2169,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 	return;
 
 nack_op_err:
-	qib_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	qp->r_nak_state = IB_NAK_REMOTE_OPERATIONAL_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
@@ -2211,7 +2183,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 nack_inv_unlck:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 nack_inv:
-	qib_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	qp->r_nak_state = IB_NAK_INVALID_REQUEST;
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
@@ -2225,7 +2197,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 nack_acc_unlck:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 nack_acc:
-	qib_rc_error(qp, IB_WC_LOC_PROT_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_PROT_ERR);
 	qp->r_nak_state = IB_NAK_REMOTE_ACCESS_ERROR;
 	qp->r_ack_psn = qp->r_psn;
 send_ack:
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index e54a2fe..5e9f5e3 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -621,7 +621,7 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	wc.status = IB_WC_LOC_PROT_ERR;
 err:
 	/* responder goes to error state */
-	qib_rc_error(qp, wc.status);
+	rvt_rc_error(qp, wc.status);
 
 serr:
 	spin_lock_irqsave(&sqp->s_lock, flags);
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 5b2d483..b337b60 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -325,17 +325,8 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		goto inv;
 	}
 
-	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST)) {
-		qp->r_flags |= RVT_R_COMM_EST;
-		if (qp->ibqp.event_handler) {
-			struct ib_event ev;
-
-			ev.device = qp->ibqp.device;
-			ev.element.qp = &qp->ibqp;
-			ev.event = IB_EVENT_COMM_EST;
-			qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-		}
-	}
+	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST))
+		rvt_comm_est(qp);
 
 	/* OK, process the packet. */
 	switch (opcode) {
@@ -527,7 +518,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 	return;
 
 op_err:
-	qib_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+	rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	return;
 
 }
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index f45cad1..04befa2 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -152,7 +152,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 
 		ret = qib_get_rwqe(qp, 0);
 		if (ret < 0) {
-			qib_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+			rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 			goto bail_unlock;
 		}
 		if (!ret) {
@@ -548,7 +548,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 
 		ret = qib_get_rwqe(qp, 0);
 		if (ret < 0) {
-			qib_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
+			rvt_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 			return;
 		}
 		if (!ret) {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 94fd30f..e399cb0 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -326,8 +326,6 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 
 void qib_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr);
 
-void qib_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
-
 int qib_post_ud_send(struct rvt_qp *qp, struct ib_send_wr *wr);
 
 void qib_ud_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 2a13ac6..444b06c 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1868,3 +1868,41 @@ int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 	}
 	return 0;
 }
+
+/**
+ * qp_comm_est - handle trap with QP established
+ * @qp: the QP
+ */
+void rvt_comm_est(struct rvt_qp *qp)
+{
+	qp->r_flags |= RVT_R_COMM_EST;
+	if (qp->ibqp.event_handler) {
+		struct ib_event ev;
+
+		ev.device = qp->ibqp.device;
+		ev.element.qp = &qp->ibqp;
+		ev.event = IB_EVENT_COMM_EST;
+		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+	}
+}
+EXPORT_SYMBOL(rvt_comm_est);
+
+void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err)
+{
+	unsigned long flags;
+	int lastwqe;
+
+	spin_lock_irqsave(&qp->s_lock, flags);
+	lastwqe = rvt_error_qp(qp, err);
+	spin_unlock_irqrestore(&qp->s_lock, flags);
+
+	if (lastwqe) {
+		struct ib_event ev;
+
+		ev.device = qp->ibqp.device;
+		ev.element.qp = &qp->ibqp;
+		ev.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+	}
+}
+EXPORT_SYMBOL(rvt_rc_error);
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index f3dbd15..eaaba1b 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -607,6 +607,8 @@ static inline u32 rvt_div_mtu(struct rvt_qp *qp, u32 len)
 extern const int  ib_rvt_state_ops[];
 
 struct rvt_dev_info;
+void rvt_comm_est(struct rvt_qp *qp);
 int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);
+void rvt_rc_error(struct rvt_qp *qp, enum ib_wc_status err);
 
 #endif          /* DEF_RDMAVT_INCQP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
