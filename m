From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/7] IB/qib: Use rdmavt version of post_send
Date: Tue, 19 Jan 2016 14:33:45 -0800
Message-ID: <20160119223345.30925.23268.stgit@scvm10.sc.intel.com>
References: <20160119223130.30925.93860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223130.30925.93860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch removes the post_send and post_one_send from the qib driver.
The "posting" of sends will be done by rdmavt which will walk a WQE and
queue work. This patch will still provide the capability to schedule that
work as well as kick the progress. These are provided to the rdmavt layer.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c      |    8 +
 drivers/infiniband/hw/qib/qib_qp.c          |   12 +-
 drivers/infiniband/hw/qib/qib_rc.c          |   46 +++---
 drivers/infiniband/hw/qib/qib_ruc.c         |   33 +++-
 drivers/infiniband/hw/qib/qib_sdma.c        |    4 -
 drivers/infiniband/hw/qib/qib_uc.c          |   12 +-
 drivers/infiniband/hw/qib/qib_ud.c          |   10 +
 drivers/infiniband/hw/qib/qib_verbs.c       |  204 +--------------------------
 drivers/infiniband/hw/qib/qib_verbs.h       |   35 +----
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |    4 -
 10 files changed, 81 insertions(+), 287 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index ad41df3..a11de8e 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -377,8 +377,8 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 			spin_lock(&qp->r_lock);
 
 			/* Check for valid receive state. */
-			if (!(ib_qib_state_ops[qp->state] &
-			      QIB_PROCESS_RECV_OK)) {
+			if (!(ib_rvt_state_ops[qp->state] &
+			      RVT_PROCESS_RECV_OK)) {
 				ibp->rvp.n_pkt_drops++;
 				goto unlock;
 			}
@@ -592,8 +592,8 @@ move_along:
 
 			qp->r_flags &= ~RVT_R_RSP_SEND;
 			spin_lock_irqsave(&qp->s_lock, flags);
-			if (ib_qib_state_ops[qp->state] &
-					QIB_PROCESS_OR_FLUSH_SEND)
+			if (ib_rvt_state_ops[qp->state] &
+					RVT_PROCESS_OR_FLUSH_SEND)
 				qib_schedule_send(qp);
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 		}
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index a691410..373d5b6 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -374,7 +374,7 @@ static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 
 	if (clr_sends) {
 		while (qp->s_last != qp->s_head) {
-			struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
+			struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 			unsigned i;
 
 			for (i = 0; i < wqe->wr.num_sge; i++) {
@@ -519,7 +519,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		  int attr_mask, struct ib_udata *udata)
 {
 	struct qib_ibdev *dev = to_idev(ibqp->device);
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct qib_qp_priv *priv = qp->priv;
 	enum ib_qp_state cur_state, new_state;
 	struct ib_event ev;
@@ -807,7 +807,7 @@ bail:
 int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		 int attr_mask, struct ib_qp_init_attr *init_attr)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 
 	attr->qp_state = qp->state;
 	attr->cur_qp_state = attr->qp_state;
@@ -929,7 +929,7 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 		return ERR_PTR(-ENOMEM);
 	}
 	init_waitqueue_head(&priv->wait_dma);
-	INIT_WORK(&priv->s_work, qib_do_send);
+	INIT_WORK(&priv->s_work, _qib_do_send);
 	INIT_LIST_HEAD(&priv->iowait);
 
 	return priv;
@@ -954,7 +954,7 @@ void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
  */
 int qib_destroy_qp(struct ib_qp *ibqp)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_qp_priv *priv = qp->priv;
 
@@ -1093,7 +1093,7 @@ void qib_qp_iter_print(struct seq_file *s, struct qib_qp_iter *iter)
 	struct rvt_qp *qp = iter->qp;
 	struct qib_qp_priv *priv = qp->priv;
 
-	wqe = get_swqe_ptr(qp, qp->s_last);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 	seq_printf(s,
 		   "N %d QP%u %s %u %u %u f=%x %u %u %u %u %u PSN %x %x %x %x %x (%u %u %u %u %u %u) QP%u LID %x\n",
 		   iter->n,
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 8be5d45..78ae93e 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -84,7 +84,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 	u32 bth2;
 
 	/* Don't send an ACK if we aren't supposed to. */
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		goto bail;
 
 	/* header size in 32-bit words LRH+BTH = (8+12)/4. */
@@ -260,8 +260,8 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	    qib_make_rc_ack(dev, qp, ohdr, pmtu))
 		goto done;
 
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_SEND_OK)) {
-		if (!(ib_qib_state_ops[qp->state] & QIB_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
+		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		if (qp->s_last == qp->s_head)
@@ -271,7 +271,7 @@ int qib_make_rc_req(struct rvt_qp *qp)
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		qib_send_complete(qp, wqe, qp->s_last != qp->s_acked ?
 			IB_WC_SUCCESS : IB_WC_WR_FLUSH_ERR);
 		/* will get called again */
@@ -295,10 +295,10 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	bth0 = 0;
 
 	/* Send a request. */
-	wqe = get_swqe_ptr(qp, qp->s_cur);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 	switch (qp->s_state) {
 	default:
-		if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_NEXT_SEND_OK))
+		if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/*
 		 * Resend an old request or start a new one.
@@ -666,7 +666,7 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		goto unlock;
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
@@ -759,7 +759,7 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 	goto done;
 
 queue_ack:
-	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		this_cpu_inc(*ibp->rvp.rc_qacks);
 		qp->s_flags |= RVT_S_ACK_PENDING | RVT_S_RESP_PENDING;
 		qp->s_nak_state = qp->r_nak_state;
@@ -786,7 +786,7 @@ done:
 static void reset_psn(struct rvt_qp *qp, u32 psn)
 {
 	u32 n = qp->s_acked;
-	struct rvt_swqe *wqe = get_swqe_ptr(qp, n);
+	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, n);
 	u32 opcode;
 
 	qp->s_cur = n;
@@ -809,7 +809,7 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
 			n = 0;
 		if (n == qp->s_tail)
 			break;
-		wqe = get_swqe_ptr(qp, n);
+		wqe = rvt_get_swqe_ptr(qp, n);
 		diff = qib_cmp24(psn, wqe->psn);
 		if (diff < 0)
 			break;
@@ -870,7 +870,7 @@ done:
  */
 static void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 {
-	struct rvt_swqe *wqe = get_swqe_ptr(qp, qp->s_acked);
+	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	struct qib_ibport *ibp;
 
 	if (qp->s_retry == 0) {
@@ -951,7 +951,7 @@ static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 
 	/* Find the work request corresponding to the given PSN. */
 	for (;;) {
-		wqe = get_swqe_ptr(qp, n);
+		wqe = rvt_get_swqe_ptr(qp, n);
 		if (qib_cmp24(psn, wqe->lpsn) <= 0) {
 			if (wqe->wr.opcode == IB_WR_RDMA_READ)
 				qp->s_sending_psn = wqe->lpsn + 1;
@@ -978,7 +978,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 	u32 opcode;
 	u32 psn;
 
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_OR_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
 
 	/* Find out where the BTH is */
@@ -1004,11 +1004,11 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 	 */
 	if ((psn & IB_BTH_REQ_ACK) && qp->s_acked != qp->s_tail &&
 	    !(qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
-	    (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
+	    (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		start_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		if (qib_cmp24(wqe->lpsn, qp->s_sending_psn) >= 0 &&
 		    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
@@ -1101,7 +1101,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 		if (++qp->s_cur >= qp->s_size)
 			qp->s_cur = 0;
 		qp->s_acked = qp->s_cur;
-		wqe = get_swqe_ptr(qp, qp->s_cur);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 		if (qp->s_acked != qp->s_tail) {
 			qp->s_state = OP(SEND_LAST);
 			qp->s_psn = wqe->psn;
@@ -1111,7 +1111,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			qp->s_acked = 0;
 		if (qp->state == IB_QPS_SQD && qp->s_acked == qp->s_cur)
 			qp->s_draining = 0;
-		wqe = get_swqe_ptr(qp, qp->s_acked);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	}
 	return wqe;
 }
@@ -1152,7 +1152,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	ack_psn = psn;
 	if (aeth >> 29)
 		ack_psn--;
-	wqe = get_swqe_ptr(qp, qp->s_acked);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 
 	/*
@@ -1361,7 +1361,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
 		del_timer(&qp->s_timer);
 	}
 
-	wqe = get_swqe_ptr(qp, qp->s_acked);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 
 	while (qib_cmp24(psn, wqe->lpsn) > 0) {
 		if (wqe->wr.opcode == IB_WR_RDMA_READ ||
@@ -1438,7 +1438,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 	}
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		goto ack_done;
 
 	/* Ignore invalid responses. */
@@ -1469,7 +1469,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 
 	if (unlikely(qp->s_acked == qp->s_tail))
 		goto ack_done;
-	wqe = get_swqe_ptr(qp, qp->s_acked);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	status = IB_WC_SUCCESS;
 
 	switch (opcode) {
@@ -1488,7 +1488,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 		    opcode != OP(RDMA_READ_RESPONSE_FIRST))
 			goto ack_done;
 		hdrsize += 4;
-		wqe = get_swqe_ptr(qp, qp->s_acked);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 		if (unlikely(wqe->wr.opcode != IB_WR_RDMA_READ))
 			goto ack_op_err;
 		/*
@@ -1554,7 +1554,7 @@ read_middle:
 		 * have to be careful to copy the data to the right
 		 * location.
 		 */
-		wqe = get_swqe_ptr(qp, qp->s_acked);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 		qp->s_rdma_read_len = restart_sge(&qp->s_rdma_read_sge,
 						  wqe, psn, pmtu);
 		goto read_last;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 80f1130..4961a54 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -158,7 +158,7 @@ int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	}
 
 	spin_lock_irqsave(&rq->lock, flags);
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)) {
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK)) {
 		ret = 0;
 		goto unlock;
 	}
@@ -379,7 +379,7 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 
 	/* Return if we are already busy processing a work request. */
 	if ((sqp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT)) ||
-	    !(ib_qib_state_ops[sqp->state] & QIB_PROCESS_OR_FLUSH_SEND))
+	    !(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		goto unlock;
 
 	sqp->s_flags |= RVT_S_BUSY;
@@ -387,11 +387,11 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 again:
 	if (sqp->s_last == sqp->s_head)
 		goto clr_busy;
-	wqe = get_swqe_ptr(sqp, sqp->s_last);
+	wqe = rvt_get_swqe_ptr(sqp, sqp->s_last);
 
 	/* Return if it is not OK to start a new work reqeust. */
-	if (!(ib_qib_state_ops[sqp->state] & QIB_PROCESS_NEXT_SEND_OK)) {
-		if (!(ib_qib_state_ops[sqp->state] & QIB_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
+		if (!(ib_rvt_state_ops[sqp->state] & RVT_FLUSH_SEND))
 			goto clr_busy;
 		/* We are in the error state, flush the work request. */
 		send_status = IB_WC_WR_FLUSH_ERR;
@@ -409,7 +409,7 @@ again:
 	}
 	spin_unlock_irqrestore(&sqp->s_lock, flags);
 
-	if (!qp || !(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) ||
+	if (!qp || !(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) ||
 	    qp->ibqp.qp_type != sqp->ibqp.qp_type) {
 		ibp->rvp.n_pkt_drops++;
 		/*
@@ -590,7 +590,7 @@ rnr_nak:
 	if (sqp->s_rnr_retry_cnt < 7)
 		sqp->s_rnr_retry--;
 	spin_lock_irqsave(&sqp->s_lock, flags);
-	if (!(ib_qib_state_ops[sqp->state] & QIB_PROCESS_RECV_OK))
+	if (!(ib_rvt_state_ops[sqp->state] & RVT_PROCESS_RECV_OK))
 		goto clr_busy;
 	sqp->s_flags |= RVT_S_WAIT_RNR;
 	sqp->s_timer.function = qib_rc_rnr_retry;
@@ -711,19 +711,26 @@ void qib_make_ruc_header(struct rvt_qp *qp, struct qib_other_headers *ohdr,
 	this_cpu_inc(ibp->pmastats->n_unicast_xmit);
 }
 
+void _qib_do_send(struct work_struct *work)
+{
+	struct qib_qp_priv *priv = container_of(work, struct qib_qp_priv,
+						s_work);
+	struct rvt_qp *qp = priv->owner;
+
+	qib_do_send(qp);
+}
+
 /**
  * qib_do_send - perform a send on a QP
- * @work: contains a pointer to the QP
+ * @qp: pointer to the QP
  *
  * Process entries in the send work queue until credit or queue is
  * exhausted.  Only allow one CPU to send a packet per QP (tasklet).
  * Otherwise, two threads could send packets out of order.
  */
-void qib_do_send(struct work_struct *work)
+void qib_do_send(struct rvt_qp *qp)
 {
-	struct qib_qp_priv *priv = container_of(work, struct qib_qp_priv,
-						s_work);
-	struct rvt_qp *qp = priv->owner;
+	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibport *ibp = to_iport(qp->ibqp.device, qp->port_num);
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	int (*make_req)(struct rvt_qp *qp);
@@ -780,7 +787,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	u32 old_last, last;
 	unsigned i;
 
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_OR_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
 
 	for (i = 0; i < wqe->wr.num_sge; i++) {
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index 3819a6d..ae65e9f 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -672,7 +672,7 @@ unmap:
 	spin_lock(&qp->s_lock);
 	if (qp->ibqp.qp_type == IB_QPT_RC) {
 		/* XXX what about error sending RDMA read responses? */
-		if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)
+		if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK)
 			qib_error_qp(qp, IB_WC_GENERAL_ERR);
 	} else if (qp->s_wqe)
 		qib_send_complete(qp, qp->s_wqe, IB_WC_GENERAL_ERR);
@@ -685,7 +685,7 @@ busy:
 	qp = tx->qp;
 	priv = qp->priv;
 	spin_lock(&qp->s_lock);
-	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		struct qib_ibdev *dev;
 
 		/*
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index caf0191..b97892f 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -57,8 +57,8 @@ int qib_make_uc_req(struct rvt_qp *qp)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_SEND_OK)) {
-		if (!(ib_qib_state_ops[qp->state] & QIB_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {
+		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		if (qp->s_last == qp->s_head)
@@ -68,7 +68,7 @@ int qib_make_uc_req(struct rvt_qp *qp)
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		qib_send_complete(qp, wqe, IB_WC_WR_FLUSH_ERR);
 		goto done;
 	}
@@ -82,12 +82,12 @@ int qib_make_uc_req(struct rvt_qp *qp)
 	bth0 = 0;
 
 	/* Get the next send request. */
-	wqe = get_swqe_ptr(qp, qp->s_cur);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 	qp->s_wqe = NULL;
 	switch (qp->s_state) {
 	default:
-		if (!(ib_qib_state_ops[qp->state] &
-		    QIB_PROCESS_NEXT_SEND_OK))
+		if (!(ib_rvt_state_ops[qp->state] &
+		    RVT_PROCESS_NEXT_SEND_OK))
 			goto bail;
 		/* Check if send work queue is empty. */
 		if (qp->s_cur == qp->s_head)
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index abca527..f0ea002 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -72,7 +72,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 			IB_QPT_UD : qp->ibqp.qp_type;
 
 	if (dqptype != sqptype ||
-	    !(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)) {
+	    !(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK)) {
 		ibp->rvp.n_pkt_drops++;
 		goto drop;
 	}
@@ -252,8 +252,8 @@ int qib_make_ud_req(struct rvt_qp *qp)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_NEXT_SEND_OK)) {
-		if (!(ib_qib_state_ops[qp->state] & QIB_FLUSH_SEND))
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_NEXT_SEND_OK)) {
+		if (!(ib_rvt_state_ops[qp->state] & RVT_FLUSH_SEND))
 			goto bail;
 		/* We are in the error state, flush the work request. */
 		if (qp->s_last == qp->s_head)
@@ -263,7 +263,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
-		wqe = get_swqe_ptr(qp, qp->s_last);
+		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		qib_send_complete(qp, wqe, IB_WC_WR_FLUSH_ERR);
 		goto done;
 	}
@@ -271,7 +271,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 	if (qp->s_cur == qp->s_head)
 		goto bail;
 
-	wqe = get_swqe_ptr(qp, qp->s_cur);
+	wqe = rvt_get_swqe_ptr(qp, qp->s_cur);
 	next_cur = qp->s_cur + 1;
 	if (next_cur >= qp->s_size)
 		next_cur = 0;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 442247a..235452d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -114,26 +114,6 @@ module_param_named(disable_sma, ib_qib_disable_sma, uint, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(disable_sma, "Disable the SMA");
 
 /*
- * Note that it is OK to post send work requests in the SQE and ERR
- * states; qib_do_send() will process them and generate error
- * completions as per IB 1.2 C10-96.
- */
-const int ib_qib_state_ops[IB_QPS_ERR + 1] = {
-	[IB_QPS_RESET] = 0,
-	[IB_QPS_INIT] = QIB_POST_RECV_OK,
-	[IB_QPS_RTR] = QIB_POST_RECV_OK | QIB_PROCESS_RECV_OK,
-	[IB_QPS_RTS] = QIB_POST_RECV_OK | QIB_PROCESS_RECV_OK |
-	    QIB_POST_SEND_OK | QIB_PROCESS_SEND_OK |
-	    QIB_PROCESS_NEXT_SEND_OK,
-	[IB_QPS_SQD] = QIB_POST_RECV_OK | QIB_PROCESS_RECV_OK |
-	    QIB_POST_SEND_OK | QIB_PROCESS_SEND_OK,
-	[IB_QPS_SQE] = QIB_POST_RECV_OK | QIB_PROCESS_RECV_OK |
-	    QIB_POST_SEND_OK | QIB_FLUSH_SEND,
-	[IB_QPS_ERR] = QIB_POST_RECV_OK | QIB_FLUSH_RECV |
-	    QIB_POST_SEND_OK | QIB_FLUSH_SEND,
-};
-
-/*
  * Translate ib_wr_opcode into ib_wc_opcode.
  */
 const enum ib_wc_opcode ib_qib_wc_opcode[] = {
@@ -321,174 +301,6 @@ static void qib_copy_from_sge(void *data, struct rvt_sge_state *ss, u32 length)
 }
 
 /**
- * qib_post_one_send - post one RC, UC, or UD send work request
- * @qp: the QP to post on
- * @wr: the work request to send
- */
-static int qib_post_one_send(struct rvt_qp *qp, struct ib_send_wr *wr,
-			     int *scheduled)
-{
-	struct rvt_swqe *wqe;
-	u32 next;
-	int i;
-	int j;
-	int acc;
-	int ret;
-	unsigned long flags;
-	struct rvt_lkey_table *rkt;
-	struct rvt_pd *pd;
-
-	spin_lock_irqsave(&qp->s_lock, flags);
-
-	/* Check that state is OK to post send. */
-	if (unlikely(!(ib_qib_state_ops[qp->state] & QIB_POST_SEND_OK)))
-		goto bail_inval;
-
-	/* IB spec says that num_sge == 0 is OK. */
-	if (wr->num_sge > qp->s_max_sge)
-		goto bail_inval;
-
-	/*
-	 * Don't allow RDMA reads or atomic operations on UC or
-	 * undefined operations.
-	 * Make sure buffer is large enough to hold the result for atomics.
-	 */
-	if (qp->ibqp.qp_type == IB_QPT_UC) {
-		if ((unsigned) wr->opcode >= IB_WR_RDMA_READ)
-			goto bail_inval;
-	} else if (qp->ibqp.qp_type != IB_QPT_RC) {
-		/* Check IB_QPT_SMI, IB_QPT_GSI, IB_QPT_UD opcode */
-		if (wr->opcode != IB_WR_SEND &&
-		    wr->opcode != IB_WR_SEND_WITH_IMM)
-			goto bail_inval;
-		/* Check UD destination address PD */
-		if (qp->ibqp.pd != ud_wr(wr)->ah->pd)
-			goto bail_inval;
-	} else if ((unsigned) wr->opcode > IB_WR_ATOMIC_FETCH_AND_ADD)
-		goto bail_inval;
-	else if (wr->opcode >= IB_WR_ATOMIC_CMP_AND_SWP &&
-		   (wr->num_sge == 0 ||
-		    wr->sg_list[0].length < sizeof(u64) ||
-		    wr->sg_list[0].addr & (sizeof(u64) - 1)))
-		goto bail_inval;
-	else if (wr->opcode >= IB_WR_RDMA_READ && !qp->s_max_rd_atomic)
-		goto bail_inval;
-
-	next = qp->s_head + 1;
-	if (next >= qp->s_size)
-		next = 0;
-	if (next == qp->s_last) {
-		ret = -ENOMEM;
-		goto bail;
-	}
-
-	rkt = &to_idev(qp->ibqp.device)->rdi.lkey_table;
-	pd = ibpd_to_rvtpd(qp->ibqp.pd);
-	wqe = get_swqe_ptr(qp, qp->s_head);
-
-	if (qp->ibqp.qp_type != IB_QPT_UC &&
-	    qp->ibqp.qp_type != IB_QPT_RC)
-		memcpy(&wqe->ud_wr, ud_wr(wr), sizeof(wqe->ud_wr));
-	else if (wr->opcode == IB_WR_REG_MR)
-		memcpy(&wqe->reg_wr, reg_wr(wr),
-			sizeof(wqe->reg_wr));
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
-	} else if (wqe->length > (dd_from_ibdev(qp->ibqp.device)->pport +
-				  qp->port_num - 1)->ibmtu)
-		goto bail_inval_free;
-	else
-		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
-	wqe->ssn = qp->s_ssn++;
-	qp->s_head = next;
-
-	ret = 0;
-	goto bail;
-
-bail_inval_free:
-	while (j) {
-		struct rvt_sge *sge = &wqe->sg_list[--j];
-
-		rvt_put_mr(sge->mr);
-	}
-bail_inval:
-	ret = -EINVAL;
-bail:
-	if (!ret && !wr->next &&
-	 !qib_sdma_empty(
-	   dd_from_ibdev(qp->ibqp.device)->pport + qp->port_num - 1)) {
-		qib_schedule_send(qp);
-		*scheduled = 1;
-	}
-	spin_unlock_irqrestore(&qp->s_lock, flags);
-	return ret;
-}
-
-/**
- * qib_post_send - post a send on a QP
- * @ibqp: the QP to post the send on
- * @wr: the list of work requests to post
- * @bad_wr: the first bad WR is put here
- *
- * This may be called from interrupt context.
- */
-static int qib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
-			 struct ib_send_wr **bad_wr)
-{
-	struct rvt_qp *qp = to_iqp(ibqp);
-	struct qib_qp_priv *priv = qp->priv;
-	int err = 0;
-	int scheduled = 0;
-
-	for (; wr; wr = wr->next) {
-		err = qib_post_one_send(qp, wr, &scheduled);
-		if (err) {
-			*bad_wr = wr;
-			goto bail;
-		}
-	}
-
-	/* Try to do the send work in the caller's context. */
-	if (!scheduled)
-		qib_do_send(&priv->s_work);
-
-bail:
-	return err;
-}
-
-/**
  * qib_post_receive - post a receive on a QP
  * @ibqp: the QP to post the receive on
  * @wr: the WR to post
@@ -499,13 +311,13 @@ bail:
 static int qib_post_receive(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			    struct ib_recv_wr **bad_wr)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct rvt_rwq *wq = qp->r_rq.wq;
 	unsigned long flags;
 	int ret;
 
 	/* Check that state is OK to post receive. */
-	if (!(ib_qib_state_ops[qp->state] & QIB_POST_RECV_OK) || !wq) {
+	if (!(ib_rvt_state_ops[qp->state] & RVT_POST_RECV_OK) || !wq) {
 		*bad_wr = wr;
 		ret = -EINVAL;
 		goto bail;
@@ -570,7 +382,7 @@ static void qib_qp_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 	spin_lock(&qp->r_lock);
 
 	/* Check for valid receive state. */
-	if (!(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)) {
+	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK)) {
 		ibp->rvp.n_pkt_drops++;
 		goto unlock;
 	}
@@ -950,7 +762,7 @@ static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		tx = list_entry(l, struct qib_verbs_txreq, txreq.list);
 	} else {
-		if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK &&
+		if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK &&
 		    list_empty(&priv->iowait)) {
 			dev->n_txwait++;
 			qp->s_flags |= RVT_S_WAIT_TX;
@@ -1131,7 +943,7 @@ static int wait_kmem(struct qib_ibdev *dev, struct rvt_qp *qp)
 	int ret = 0;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		spin_lock(&dev->rdi.pending_lock);
 		if (list_empty(&priv->iowait)) {
 			if (list_empty(&dev->memwait))
@@ -1268,7 +1080,7 @@ static int no_bufs_available(struct rvt_qp *qp)
 	 * enabling the PIO avail interrupt.
 	 */
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
+	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		spin_lock(&dev->rdi.pending_lock);
 		if (list_empty(&priv->iowait)) {
 			dev->n_piowait++;
@@ -2012,7 +1824,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->modify_qp = qib_modify_qp;
 	ibdev->query_qp = qib_query_qp;
 	ibdev->destroy_qp = qib_destroy_qp;
-	ibdev->post_send = qib_post_send;
+	ibdev->post_send = NULL;
 	ibdev->post_recv = qib_post_receive;
 	ibdev->post_srq_recv = qib_post_srq_receive;
 	ibdev->create_cq = NULL;
@@ -2052,6 +1864,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = qib_free_all_qps;
 	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
+	dd->verbs_dev.rdi.driver_f.do_send = qib_do_send;
+	dd->verbs_dev.rdi.driver_f.schedule_send = qib_schedule_send;
 
 	dd->verbs_dev.rdi.flags = 0;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index aa518f7..fdf2516 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -72,17 +72,6 @@ struct qib_verbs_txreq;
 #define IB_NAK_REMOTE_OPERATIONAL_ERROR 0x63
 #define IB_NAK_INVALID_RD_REQUEST       0x64
 
-/* Flags for checking QP state (see ib_qib_state_ops[]) */
-#define QIB_POST_SEND_OK                0x01
-#define QIB_POST_RECV_OK                0x02
-#define QIB_PROCESS_RECV_OK             0x04
-#define QIB_PROCESS_SEND_OK             0x08
-#define QIB_PROCESS_NEXT_SEND_OK        0x10
-#define QIB_FLUSH_SEND			0x20
-#define QIB_FLUSH_RECV			0x40
-#define QIB_PROCESS_OR_FLUSH_SEND \
-	(QIB_PROCESS_SEND_OK | QIB_FLUSH_SEND)
-
 /* IB Performance Manager status values */
 #define IB_PMA_SAMPLE_STATUS_DONE       0x00
 #define IB_PMA_SAMPLE_STATUS_STARTED    0x01
@@ -231,19 +220,6 @@ struct qib_qp_priv {
 #define QIB_PSN_CREDIT  16
 
 /*
- * Since struct rvt_swqe is not a fixed size, we can't simply index into
- * struct rvt_qp.s_wq.  This function does the array index computation.
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
@@ -339,11 +315,6 @@ struct qib_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct rvt_qp *to_iqp(struct ib_qp *ibqp)
-{
-	return container_of(ibqp, struct rvt_qp, ibqp);
-}
-
 static inline struct qib_ibdev *to_idev(struct ib_device *ibdev)
 {
 	struct rvt_dev_info *rdi;
@@ -528,7 +499,9 @@ u32 qib_make_grh(struct qib_ibport *ibp, struct ib_grh *hdr,
 void qib_make_ruc_header(struct rvt_qp *qp, struct qib_other_headers *ohdr,
 			 u32 bth0, u32 bth2);
 
-void qib_do_send(struct work_struct *work);
+void _qib_do_send(struct work_struct *work);
+
+void qib_do_send(struct rvt_qp *qp);
 
 void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		       enum ib_wc_status status);
@@ -573,7 +546,7 @@ extern const enum ib_wc_opcode ib_qib_wc_opcode[];
 #define IB_PHYSPORTSTATE_CFG_ENH 0x10
 #define IB_PHYSPORTSTATE_CFG_WAIT_ENH 0x13
 
-extern const int ib_qib_state_ops[];
+extern const int ib_rvt_state_ops[];
 
 extern __be64 ib_qib_sys_image_guid;    /* in network order */
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs_mcast.c b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
index 6ab3aee..6eca307 100644
--- a/drivers/infiniband/hw/qib/qib_verbs_mcast.c
+++ b/drivers/infiniband/hw/qib/qib_verbs_mcast.c
@@ -224,7 +224,7 @@ bail:
 
 int qib_multicast_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_ibport *ibp;
 	struct qib_mcast *mcast;
@@ -282,7 +282,7 @@ bail:
 
 int qib_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	struct rvt_qp *qp = to_iqp(ibqp);
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
 	struct qib_ibdev *dev = to_idev(ibqp->device);
 	struct qib_ibport *ibp = to_iport(ibqp->device, qp->port_num);
 	struct qib_mcast *mcast = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
