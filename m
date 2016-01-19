From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 23/31] staging/rdma/hfi1: Use rdmavt version of post_send
Date: Tue, 19 Jan 2016 14:43:33 -0800
Message-ID: <20160119224333.32765.2701.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Edward Mascarenhas <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch removes the post_send and post_one_send from the hfi1 driver.
The "posting" of sends will be done by rdmavt which will walk a WQE and
queue work. This patch will still provide the capability to schedule that
work as well as kick the progress. These are provided to the rdmavt layer.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Edward Mascarenhas <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c      |    8 +
 drivers/staging/rdma/hfi1/qp.c          |   14 +-
 drivers/staging/rdma/hfi1/rc.c          |   40 +++---
 drivers/staging/rdma/hfi1/ruc.c         |   28 +++-
 drivers/staging/rdma/hfi1/uc.c          |   12 +-
 drivers/staging/rdma/hfi1/ud.c          |   10 +-
 drivers/staging/rdma/hfi1/verbs.c       |  201 +------------------------------
 drivers/staging/rdma/hfi1/verbs.h       |   35 +----
 drivers/staging/rdma/hfi1/verbs_mcast.c |    4 -
 9 files changed, 74 insertions(+), 278 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index ec2286a..d57c08f 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -335,8 +335,8 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			spin_lock_irqsave(&qp->r_lock, flags);
 
 			/* Check for valid receive state. */
-			if (!(ib_hfi1_state_ops[qp->state] &
-			      HFI1_PROCESS_RECV_OK)) {
+			if (!(ib_rvt_state_ops[qp->state] &
+			      RVT_PROCESS_RECV_OK)) {
 				ibp->rvp.n_pkt_drops++;
 			}
 
@@ -790,8 +790,8 @@ static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 
 			qp->r_flags &= ~RVT_R_RSP_SEND;
 			spin_lock_irqsave(&qp->s_lock, flags);
-			if (ib_hfi1_state_ops[qp->state] &
-					HFI1_PROCESS_OR_FLUSH_SEND)
+			if (ib_rvt_state_ops[qp->state] &
+					RVT_PROCESS_OR_FLUSH_SEND)
 				hfi1_schedule_send(qp);
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 		}
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index c0ae374..14560d8 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -208,7 +208,7 @@ static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 
 	if (clr_sends) {
 		while (qp->s_last != qp->s_head) {
-			struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
+			struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 			unsigned i;
 
 			for (i = 0; i < wqe->wr.num_sge; i++) {
@@ -411,7 +411,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		   int attr_mask, struct ib_udata *udata)
 {
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct hfi1_qp_priv *priv = qp->priv;
 	enum ib_qp_state cur_state, new_state;
 	struct ib_event ev;
@@ -710,7 +710,7 @@ bail:
 int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_qp_init_attr *init_attr)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 
 	attr->qp_state = qp->state;
 	attr->cur_qp_state = attr->qp_state;
@@ -829,7 +829,7 @@ __be32 hfi1_compute_aeth(struct rvt_qp *qp)
  */
 int hfi1_destroy_qp(struct ib_qp *ibqp)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_qp_priv *priv = qp->priv;
 
@@ -943,7 +943,7 @@ static int iowait_sleep(
 	priv = qp->priv;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 
 		/*
 		 * If we couldn't queue the DMA request, save the info
@@ -1117,7 +1117,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 	struct sdma_engine *sde;
 
 	sde = qp_to_sdma_engine(qp, priv->s_sc);
-	wqe = get_swqe_ptr(qp, qp->s_last);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	seq_printf(s,
 		   "N %d %s QP%u R %u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u) QP%u LID %x SL %u MTU %d %u %u %u SDE %p,%u\n",
 		   iter->n,
@@ -1224,7 +1224,7 @@ void notify_qp_reset(struct rvt_qp *qp)
 	iowait_init(
 		&priv->s_iowait,
 		1,
-		hfi1_do_send,
+		_hfi1_do_send,
 		iowait_sleep,
 		iowait_wakeup);
 	priv->r_adefered = 0;
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index e80a092..a30bf30 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -105,7 +105,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 	int middle = 0;
 
 	/* Don't send an ACK if we aren't supposed to. */
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		goto bail;
 
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
@@ -291,8 +291,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	    make_rc_ack(dev, qp, ohdr, pmtu))
 		goto done;
 
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_SEND_OK)) {
-		if (!(ib_hfi1_state_ops[qp->state] & HFI1_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
+		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		if (qp->s_last == qp->s_head)
@@ -303,7 +303,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 			goto bail;
 		}
 		clear_ahg(qp);
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		hfi1_send_complete(qp, wqe, qp->s_last != qp->s_acked ?
 			IB_WC_SUCCESS : IB_WC_WR_FLUSH_ERR);
 		/* will get called again */
@@ -323,10 +323,10 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	}
 
 	/* Send a request. */
-	wqe = get_swqe_ptr(qp, qp->s_cur);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 	switch (qp->s_state) {
 	default:
-		if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_NEXT_SEND_OK))
+		if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/*
 		 * Resend an old request or start a new one.
@@ -797,7 +797,7 @@ queue_ack:
 static void reset_psn(struct rvt_qp *qp, u32 psn)
 {
 	u32 n = qp->s_acked;
-	struct rvt_swqe *wqe = get_swqe_ptr(qp, n);
+	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, n);
 	u32 opcode;
 
 	qp->s_cur = n;
@@ -820,7 +820,7 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
 			n = 0;
 		if (n == qp->s_tail)
 			break;
-		wqe = get_swqe_ptr(qp, n);
+		wqe = rvt_get_swqe_ptr(qp, n);
 		diff = cmp_psn(psn, wqe->psn);
 		if (diff < 0)
 			break;
@@ -882,7 +882,7 @@ done:
  */
 static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 {
-	struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_acked);
+	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	struct hfi1_ibport *ibp;
 
 	if (qp->s_retry == 0) {
@@ -964,7 +964,7 @@ static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 
 	/* Find the work request corresponding to the given PSN. */
 	for (;;) {
-		wqe = get_swqe_ptr(qp, n);
+		wqe = rvt_get_swqe_ptr(qp, n);
 		if (cmp_psn(psn, wqe->lpsn) <= 0) {
 			if (wqe->wr.opcode == IB_WR_RDMA_READ)
 				qp->s_sending_psn = wqe->lpsn + 1;
@@ -991,7 +991,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	u32 opcode;
 	u32 psn;
 
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_OR_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
 
 	/* Find out where the BTH is */
@@ -1018,11 +1018,11 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	if ((psn & IB_BTH_REQ_ACK) && qp->s_acked != qp->s_tail &&
 	    !(qp->s_flags &
 		(RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
-		(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK))
+		(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		start_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		if (cmp_psn(wqe->lpsn, qp->s_sending_psn) >= 0 &&
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
@@ -1132,7 +1132,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 		if (++qp->s_cur >= qp->s_size)
 			qp->s_cur = 0;
 		qp->s_acked = qp->s_cur;
-		wqe = get_swqe_ptr(qp, qp->s_cur);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 		if (qp->s_acked != qp->s_tail) {
 			qp->s_state = OP(SEND_LAST);
 			qp->s_psn = wqe->psn;
@@ -1142,7 +1142,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			qp->s_acked = 0;
 		if (qp->state == IB_QPS_SQD && qp->s_acked == qp->s_cur)
 			qp->s_draining = 0;
-		wqe = get_swqe_ptr(qp, qp->s_acked);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	}
 	return wqe;
 }
@@ -1183,7 +1183,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	ack_psn = psn;
 	if (aeth >> 29)
 		ack_psn--;
-	wqe = get_swqe_ptr(qp, qp->s_acked);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 
 	/*
@@ -1392,7 +1392,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 		del_timer(&qp->s_timer);
 	}
 
-	wqe = get_swqe_ptr(qp, qp->s_acked);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 
 	while (cmp_psn(psn, wqe->lpsn) > 0) {
 		if (wqe->wr.opcode == IB_WR_RDMA_READ ||
@@ -1474,7 +1474,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 
 	if (unlikely(qp->s_acked == qp->s_tail))
 		goto ack_done;
-	wqe = get_swqe_ptr(qp, qp->s_acked);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	status = IB_WC_SUCCESS;
 
 	switch (opcode) {
@@ -1492,7 +1492,7 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 		if (!do_rc_ack(qp, aeth, psn, opcode, val, rcd) ||
 		    opcode != OP(RDMA_READ_RESPONSE_FIRST))
 			goto ack_done;
-		wqe = get_swqe_ptr(qp, qp->s_acked);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
 			goto ack_op_err;
 		/*
@@ -1557,7 +1557,7 @@ read_middle:
 		 * have to be careful to copy the data to the right
 		 * location.
 		 */
-		wqe = get_swqe_ptr(qp, qp->s_acked);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 		qp->s_rdma_read_len = restart_sge(&qp->s_rdma_read_sge,
 						  wqe, psn, pmtu);
 		goto read_last;
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index c659cf8..b47e462 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -176,7 +176,7 @@ int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	}
 
 	spin_lock_irqsave(&rq->lock, flags);
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK)) {
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK)) {
 		ret = 0;
 		goto unlock;
 	}
@@ -383,7 +383,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 
 	/* Return if we are already busy processing a work request. */
 	if ((sqp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT)) ||
-	    !(ib_hfi1_state_ops[sqp->state] & HFI1_PROCESS_OR_FLUSH_SEND))
+	    !(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		goto unlock;
 
 	sqp->s_flags |= RVT_S_BUSY;
@@ -391,11 +391,11 @@ static void ruc_loopback(struct rvt_qp *sqp)
 again:
 	if (sqp->s_last == sqp->s_head)
 		goto clr_busy;
-	wqe = get_swqe_ptr(sqp, sqp->s_last);
+	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
 
 	/* Return if it is not OK to start a new work request. */
-	if (!(ib_hfi1_state_ops[sqp->state] & HFI1_PROCESS_NEXT_SEND_OK)) {
-		if (!(ib_hfi1_state_ops[sqp->state] & HFI1_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
+		if (!(ib_rvt_state_ops[sqp->state] & RVT_FLUSH_SEND))
 			goto clr_busy;
 		/* We are in the error state, flush the work request. */
 		send_status = IB_WC_WR_FLUSH_ERR;
@@ -413,7 +413,7 @@ again:
 	}
 	spin_unlock_irqrestore(&sqp->s_lock, flags);
 
-	if (!qp || !(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) ||
+	if (!qp || !(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) ||
 	    qp->ibqp.qp_type != sqp->ibqp.qp_type) {
 		ibp->rvp.n_pkt_drops++;
 		/*
@@ -593,7 +593,7 @@ rnr_nak:
 	if (sqp->s_rnr_retry_cnt < 7)
 		sqp->s_rnr_retry--;
 	spin_lock_irqsave(&sqp->s_lock, flags);
-	if (!(ib_hfi1_state_ops[sqp->state] & HFI1_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
 	sqp->s_flags |= RVT_S_WAIT_RNR;
 	sqp->s_timer.function = hfi1_rc_rnr_retry;
@@ -802,6 +802,14 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 /* when sending, force a reschedule every one of these periods */
 #define SEND_RESCHED_TIMEOUT (5 * HZ)  /* 5s in jiffies */
 
+void _hfi1_do_send(struct work_struct *work)
+{
+	struct iowait *wait = container_of(work, struct iowait, iowork);
+	struct rvt_qp *qp = iowait_to_qp(wait);
+
+	hfi1_do_send(qp);
+}
+
 /**
  * hfi1_do_send - perform a send on a QP
  * @work: contains a pointer to the QP
@@ -810,10 +818,8 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
  * exhausted.  Only allow one CPU to send a packet per QP (tasklet).
  * Otherwise, two threads could send packets out of order.
  */
-void hfi1_do_send(struct work_struct *work)
+void hfi1_do_send(struct rvt_qp *qp)
 {
-	struct iowait *wait = container_of(work, struct iowait, iowork);
-	struct rvt_qp *qp = iowait_to_qp(wait);
 	struct hfi1_pkt_state ps;
 	int (*make_req)(struct rvt_qp *qp);
 	unsigned long flags;
@@ -883,7 +889,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	u32 old_last, last;
 	unsigned i;
 
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_OR_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
 
 	for (i = 0; i < wqe->wr.num_sge; i++) {
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 75cded3..ec404ff 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -76,8 +76,8 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_SEND_OK)) {
-		if (!(ib_hfi1_state_ops[qp->state] & HFI1_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
+		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		if (qp->s_last == qp->s_head)
@@ -88,7 +88,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 			goto bail;
 		}
 		clear_ahg(qp);
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		hfi1_send_complete(qp, wqe, IB_WC_WR_FLUSH_ERR);
 		goto done;
 	}
@@ -98,12 +98,12 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 		ohdr = &priv->s_hdr->ibh.u.l.oth;
 
 	/* Get the next send request. */
-	wqe = get_swqe_ptr(qp, qp->s_cur);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 	qp->s_wqe = NULL;
 	switch (qp->s_state) {
 	default:
-		if (!(ib_hfi1_state_ops[qp->state] &
-		    HFI1_PROCESS_NEXT_SEND_OK))
+		if (!(ib_rvt_state_ops[qp->state] &
+		    RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/* Check if send work queue is empty. */
 		if (qp->s_cur == qp->s_head) {
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index a4746e8..e2cbdc8 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -93,7 +93,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 			IB_QPT_UD : qp->ibqp.qp_type;
 
 	if (dqptype != sqptype ||
-	    !(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK)) {
+	    !(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK)) {
 		ibp->rvp.n_pkt_drops++;
 		goto drop;
 	}
@@ -282,8 +282,8 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_NEXT_SEND_OK)) {
-		if (!(ib_hfi1_state_ops[qp->state] & HFI1_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
+		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		if (qp->s_last == qp->s_head)
@@ -293,7 +293,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		hfi1_send_complete(qp, wqe, IB_WC_WR_FLUSH_ERR);
 		goto done;
 	}
@@ -301,7 +301,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 	if (qp->s_cur == qp->s_head)
 		goto bail;
 
-	wqe = get_swqe_ptr(qp, qp->s_cur);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 	next_cur = qp->s_cur + 1;
 	if (next_cur >= qp->s_size)
 		next_cur = 0;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index ee969d0..b4cfda4 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -133,28 +133,6 @@ static void verbs_sdma_complete(
 #define TXREQ_NAME_LEN 24
 
 /*
- * Note that it is OK to post send work requests in the SQE and ERR
- * states; hfi1_do_send() will process them and generate error
- * completions as per IB 1.2 C10-96.
- */
-const int ib_hfi1_state_ops[IB_QPS_ERR + 1] = {
-	[IB_QPS_RESET] = 0,
-	[IB_QPS_INIT] = HFI1_POST_RECV_OK,
-	[IB_QPS_RTR] = HFI1_POST_RECV_OK | HFI1_PROCESS_RECV_OK,
-	[IB_QPS_RTS] = HFI1_POST_RECV_OK | HFI1_PROCESS_RECV_OK |
-	    HFI1_POST_SEND_OK | HFI1_PROCESS_SEND_OK |
-	    HFI1_PROCESS_NEXT_SEND_OK,
-	[IB_QPS_SQD] = HFI1_POST_RECV_OK | HFI1_PROCESS_RECV_OK |
-	    HFI1_POST_SEND_OK | HFI1_PROCESS_SEND_OK,
-	[IB_QPS_SQE] = HFI1_POST_RECV_OK | HFI1_PROCESS_RECV_OK |
-	    HFI1_POST_SEND_OK | HFI1_FLUSH_SEND,
-	[IB_QPS_ERR] = HFI1_POST_RECV_OK | HFI1_FLUSH_RECV |
-	    HFI1_POST_SEND_OK | HFI1_FLUSH_SEND,
-};
-
-static inline void _hfi1_schedule_send(struct rvt_qp *qp);
-
-/*
  * Translate ib_wr_opcode into ib_wc_opcode.
  */
 const enum ib_wc_opcode ib_hfi1_wc_opcode[] = {
@@ -346,169 +324,6 @@ void hfi1_skip_sge(struct rvt_sge_state *ss, u32 length, int release)
 }
 
 /**
- * post_one_send - post one RC, UC, or UD send work request
- * @qp: the QP to post on
- * @wr: the work request to send
- */
-static int post_one_send(struct rvt_qp *qp, struct ib_send_wr *wr)
-{
-	struct rvt_swqe *wqe;
-	u32 next;
-	int i;
-	int j;
-	int acc;
-	struct rvt_lkey_table *rkt;
-	struct rvt_pd *pd;
-	struct hfi1_devdata *dd = dd_from_ibdev(qp->ibqp.device);
-	struct hfi1_pportdata *ppd;
-	struct hfi1_ibport *ibp;
-
-	/* IB spec says that num_sge == 0 is OK. */
-	if (unlikely(wr->num_sge > qp->s_max_sge))
-		return -EINVAL;
-
-	ppd = &dd->pport[qp->port_num - 1];
-	ibp = &ppd->ibport_data;
-
-	/*
-	 * Don't allow RDMA reads or atomic operations on UC or
-	 * undefined operations.
-	 * Make sure buffer is large enough to hold the result for atomics.
-	 */
-	if (qp->ibqp.qp_type == IB_QPT_UC) {
-		if ((unsigned) wr->opcode >= IB_WR_RDMA_READ)
-			return -EINVAL;
-	} else if (qp->ibqp.qp_type != IB_QPT_RC) {
-		/* Check IB_QPT_SMI, IB_QPT_GSI, IB_QPT_UD opcode */
-		if (wr->opcode != IB_WR_SEND &&
-		    wr->opcode != IB_WR_SEND_WITH_IMM)
-			return -EINVAL;
-		/* Check UD destination address PD */
-		if (qp->ibqp.pd != ud_wr(wr)->ah->pd)
-			return -EINVAL;
-	} else if ((unsigned) wr->opcode > IB_WR_ATOMIC_FETCH_AND_ADD)
-		return -EINVAL;
-	else if (wr->opcode >= IB_WR_ATOMIC_CMP_AND_SWP &&
-		   (wr->num_sge == 0 ||
-		    wr->sg_list[0].length < sizeof(u64) ||
-		    wr->sg_list[0].addr & (sizeof(u64) - 1)))
-		return -EINVAL;
-	else if (wr->opcode >= IB_WR_RDMA_READ && !qp->s_max_rd_atomic)
-		return -EINVAL;
-
-	next = qp->s_head + 1;
-	if (next >= qp->s_size)
-		next = 0;
-	if (next == qp->s_last)
-		return -ENOMEM;
-
-	rkt = &to_idev(qp->ibqp.device)->rdi.lkey_table;
-	pd = ibpd_to_rvtpd(qp->ibqp.pd);
-	wqe = get_swqe_ptr(qp, qp->s_head);
-
-
-	if (qp->ibqp.qp_type != IB_QPT_UC &&
-	    qp->ibqp.qp_type != IB_QPT_RC)
-		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
-	else if (wr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
-		 wr->opcode == IB_WR_RDMA_WRITE ||
-		 wr->opcode == IB_WR_RDMA_READ)
-		memcpy(&wqe->rdma_wr, rdma_wr(wr), sizeof(wqe->rdma_wr));
-	else if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
-		 wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
-		memcpy(&wqe->atomic_wr, atomic_wr(wr), sizeof(wqe->atomic_wr));
-	else
-		memcpy(&wqe->wr, wr, sizeof(wqe->wr));
-
-	wqe->length = 0;
-	j = 0;
-	if (wr->num_sge) {
-		acc = wr->opcode >= IB_WR_RDMA_READ ?
-			IB_ACCESS_LOCAL_WRITE : 0;
-		for (i = 0; i < wr->num_sge; i++) {
-			u32 length = wr->sg_list[i].length;
-			int ok;
-
-			if (length == 0)
-				continue;
-			ok = rvt_lkey_ok(rkt, pd, &wqe->sg_list[j],
-					 &wr->sg_list[i], acc);
-			if (!ok)
-				goto bail_inval_free;
-			wqe->length += length;
-			j++;
-		}
-		wqe->wr.num_sge = j;
-	}
-	if (qp->ibqp.qp_type == IB_QPT_UC ||
-	    qp->ibqp.qp_type == IB_QPT_RC) {
-		if (wqe->length > 0x80000000U)
-			goto bail_inval_free;
-	} else {
-		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
-	}
-	wqe->ssn = qp->s_ssn++;
-	qp->s_head = next;
-
-	return 0;
-
-bail_inval_free:
-	/* release mr holds */
-	while (j) {
-		struct rvt_sge *sge = &wqe->sg_list[--j];
-
-		rvt_put_mr(sge->mr);
-	}
-	return -EINVAL;
-}
-
-/**
- * post_send - post a send on a QP
- * @ibqp: the QP to post the send on
- * @wr: the list of work requests to post
- * @bad_wr: the first bad WR is put here
- *
- * This may be called from interrupt context.
- */
-static int post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
-		     struct ib_send_wr **bad_wr)
-{
-	struct rvt_qp *qp = to_iqp(ibqp);
-	struct hfi1_qp_priv *priv = qp->priv;
-	int err = 0;
-	int call_send;
-	unsigned long flags;
-	unsigned nreq = 0;
-
-	spin_lock_irqsave(&qp->s_lock, flags);
-
-	/* Check that state is OK to post send. */
-	if (unlikely(!(ib_hfi1_state_ops[qp->state] & HFI1_POST_SEND_OK))) {
-		spin_unlock_irqrestore(&qp->s_lock, flags);
-		return -EINVAL;
-	}
-
-	/* sq empty and not list -> call send */
-	call_send = qp->s_head == qp->s_last && !wr->next;
-
-	for (; wr; wr = wr->next) {
-		err = post_one_send(qp, wr);
-		if (unlikely(err)) {
-			*bad_wr = wr;
-			goto bail;
-		}
-		nreq++;
-	}
-bail:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-	if (nreq && !call_send)
-		_hfi1_schedule_send(qp);
-	if (nreq && call_send)
-		hfi1_do_send(&priv->s_iowait.iowork);
-	return err;
-}
-
-/**
  * post_receive - post a receive on a QP
  * @ibqp: the QP to post the receive on
  * @wr: the WR to post
@@ -519,13 +334,13 @@ bail:
 static int post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			struct ib_recv_wr **bad_wr)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct rvt_rwq *wq = qp->r_rq.wq;
 	unsigned long flags;
 	int ret;
 
 	/* Check that state is OK to post receive. */
-	if (!(ib_hfi1_state_ops[qp->state] & HFI1_POST_RECV_OK) || !wq) {
+	if (!(ib_rvt_state_ops[qp->state] & RVT_POST_RECV_OK) || !wq) {
 		*bad_wr = wr;
 		ret = -EINVAL;
 		goto bail;
@@ -576,7 +391,7 @@ static inline int qp_ok(int opcode, struct hfi1_packet *packet)
 {
 	struct hfi1_ibport *ibp;
 
-	if (!(ib_hfi1_state_ops[packet->qp->state] & HFI1_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[packet->qp->state] & RVT_PROCESS_RECV_OK))
 		goto dropit;
 	if (((opcode & OPCODE_QP_MASK) == packet->qp->allowed_ops) ||
 	    (opcode == IB_OPCODE_CNP))
@@ -737,7 +552,7 @@ static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 	if (!tx) {
 		spin_lock_irqsave(&qp->s_lock, flags);
 		write_seqlock(&dev->iowait_lock);
-		if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK &&
+		if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK &&
 		    list_empty(&priv->s_iowait.list)) {
 			dev->n_txwait++;
 			qp->s_flags |= RVT_S_WAIT_TX;
@@ -855,7 +670,7 @@ static int wait_kmem(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 	int ret = 0;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		write_seqlock(&dev->iowait_lock);
 		if (list_empty(&priv->s_iowait.list)) {
 			if (list_empty(&dev->memwait))
@@ -1085,7 +900,7 @@ static int no_bufs_available(struct rvt_qp *qp, struct send_context *sc)
 	 * enabling the PIO avail interrupt.
 	 */
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		write_seqlock(&dev->iowait_lock);
 		if (list_empty(&priv->s_iowait.list)) {
 			struct hfi1_ibdev *dev = &dd->verbs_dev;
@@ -1812,7 +1627,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_qp = hfi1_modify_qp;
 	ibdev->query_qp = hfi1_query_qp;
 	ibdev->destroy_qp = hfi1_destroy_qp;
-	ibdev->post_send = post_send;
+	ibdev->post_send = NULL;
 	ibdev->post_recv = post_receive;
 	ibdev->post_srq_recv = hfi1_post_srq_receive;
 	ibdev->create_cq = NULL;
@@ -1864,6 +1679,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = free_all_qps;
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
+	dd->verbs_dev.rdi.driver_f.do_send = hfi1_do_send;
+	dd->verbs_dev.rdi.driver_f.schedule_send = hfi1_schedule_send;
 
 	/* completeion queue */
 	snprintf(dd->verbs_dev.rdi.dparms.cq_name,
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index ef8fb13..8e032a7 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -92,17 +92,6 @@ struct hfi1_packet;
 #define IB_NAK_REMOTE_OPERATIONAL_ERROR 0x63
 #define IB_NAK_INVALID_RD_REQUEST       0x64
 
-/* Flags for checking QP state (see ib_hfi1_state_ops[]) */
-#define HFI1_POST_SEND_OK                0x01
-#define HFI1_POST_RECV_OK                0x02
-#define HFI1_PROCESS_RECV_OK             0x04
-#define HFI1_PROCESS_SEND_OK             0x08
-#define HFI1_PROCESS_NEXT_SEND_OK        0x10
-#define HFI1_FLUSH_SEND			0x20
-#define HFI1_FLUSH_RECV			0x40
-#define HFI1_PROCESS_OR_FLUSH_SEND \
-	(HFI1_PROCESS_SEND_OK | HFI1_FLUSH_SEND)
-
 /* IB Performance Manager status values */
 #define IB_PMA_SAMPLE_STATUS_DONE       0x00
 #define IB_PMA_SAMPLE_STATUS_STARTED    0x01
@@ -256,19 +245,6 @@ struct hfi1_pkt_state {
 #define HFI1_PSN_CREDIT  16
 
 /*
- * Since struct rvt_swqe is not a fixed size, we can't simply index into
- * struct hfi1_qp.s_wq.  This function does the array index computation.
- */
-static inline struct rvt_swqe *get_swqe_ptr(struct rvt_qp *qp,
-					    unsigned n)
-{
-	return (struct rvt_swqe *)((char *)qp->s_wq +
-				     (sizeof(struct rvt_swqe) +
-				      qp->s_max_sge *
-				      sizeof(struct rvt_sge)) * n);
-}
-
-/*
  * Since struct rvt_rwqe is not a fixed size, we can't simply index into
  * struct rvt_rwq.wq.  This function does the array index computation.
  */
@@ -359,11 +335,6 @@ struct hfi1_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
-{
-	return container_of(ibqp, struct rvt_qp, ibqp);
-}
-
 static inline struct hfi1_ibdev *to_idev(struct ib_device *ibdev)
 {
 	struct rvt_dev_info *rdi;
@@ -544,7 +515,9 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle);
 
-void hfi1_do_send(struct work_struct *work);
+void _hfi1_do_send(struct work_struct *work);
+
+void hfi1_do_send(struct rvt_qp *qp);
 
 void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			enum ib_wc_status status);
@@ -577,7 +550,7 @@ extern const enum ib_wc_opcode ib_hfi1_wc_opcode[];
 
 extern const u8 hdr_len_by_opcode[];
 
-extern const int ib_hfi1_state_ops[];
+extern const int ib_rvt_state_ops[];
 
 extern __be64 ib_hfi1_sys_image_guid;    /* in network order */
 
diff --git a/drivers/staging/rdma/hfi1/verbs_mcast.c b/drivers/staging/rdma/hfi1/verbs_mcast.c
index aa3f560..175396b 100644
--- a/drivers/staging/rdma/hfi1/verbs_mcast.c
+++ b/drivers/staging/rdma/hfi1/verbs_mcast.c
@@ -241,7 +241,7 @@ bail:
 
 int hfi1_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_ibport *ibp;
 	struct hfi1_mcast *mcast;
@@ -299,7 +299,7 @@ bail:
 
 int hfi1_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct hfi1_ibdev *dev = to_idev(ibqp->device);
 	struct hfi1_ibport *ibp = to_iport(ibqp->device, qp->port_num);
 	struct hfi1_mcast *mcast = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
