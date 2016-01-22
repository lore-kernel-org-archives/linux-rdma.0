From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 8/9] IB/qib: Use rdmavt send and receive flags
Date: Fri, 22 Jan 2016 12:56:46 -0800
Message-ID: <20160122205645.6530.11588.stgit@scvm10.sc.intel.com>
References: <20160122205437.6530.68843.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122205437.6530.68843.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the definitions of the s_flags and r_flags which are now in rdmavt.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |   10 +-
 drivers/infiniband/hw/qib/qib_qp.c     |   44 +++++----
 drivers/infiniband/hw/qib/qib_rc.c     |  152 ++++++++++++++++----------------
 drivers/infiniband/hw/qib/qib_ruc.c    |   18 ++--
 drivers/infiniband/hw/qib/qib_sdma.c   |    4 -
 drivers/infiniband/hw/qib/qib_uc.c     |   16 ++-
 drivers/infiniband/hw/qib/qib_ud.c     |   22 ++---
 drivers/infiniband/hw/qib/qib_verbs.c  |   34 ++++---
 drivers/infiniband/hw/qib/qib_verbs.h  |   78 +---------------
 9 files changed, 153 insertions(+), 225 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index e8b239c..ad41df3 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -414,7 +414,7 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 						 */
 						if (list_empty(&qp->rspwait)) {
 							qp->r_flags |=
-								QIB_R_RSP_NAK;
+								RVT_R_RSP_NAK;
 							atomic_inc(
 								&qp->refcount);
 							list_add_tail(
@@ -583,14 +583,14 @@ move_along:
 	 */
 	list_for_each_entry_safe(qp, nqp, &rcd->qp_wait_list, rspwait) {
 		list_del_init(&qp->rspwait);
-		if (qp->r_flags & QIB_R_RSP_NAK) {
-			qp->r_flags &= ~QIB_R_RSP_NAK;
+		if (qp->r_flags & RVT_R_RSP_NAK) {
+			qp->r_flags &= ~RVT_R_RSP_NAK;
 			qib_send_rc_ack(qp);
 		}
-		if (qp->r_flags & QIB_R_RSP_SEND) {
+		if (qp->r_flags & RVT_R_RSP_SEND) {
 			unsigned long flags;
 
-			qp->r_flags &= ~QIB_R_RSP_SEND;
+			qp->r_flags &= ~RVT_R_RSP_SEND;
 			spin_lock_irqsave(&qp->s_lock, flags);
 			if (ib_qib_state_ops[qp->state] &
 					QIB_PROCESS_OR_FLUSH_SEND)
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index f18ee76..c5e9cf5 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -386,7 +386,7 @@ static void qib_reset_qp(struct rvt_qp *qp, enum ib_qp_type type)
 	qp->qkey = 0;
 	qp->qp_access_flags = 0;
 	atomic_set(&priv->s_dma_busy, 0);
-	qp->s_flags &= QIB_S_SIGNAL_REQ_WR;
+	qp->s_flags &= RVT_S_SIGNAL_REQ_WR;
 	qp->s_hdrwords = 0;
 	qp->s_wqe = NULL;
 	qp->s_draining = 0;
@@ -431,7 +431,7 @@ static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
 
-	if (test_and_clear_bit(QIB_R_REWIND_SGE, &qp->r_aflags))
+	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 		qib_put_ss(&qp->s_rdma_read_sge);
 
 	qib_put_ss(&qp->r_sge);
@@ -496,22 +496,22 @@ int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 
 	qp->state = IB_QPS_ERR;
 
-	if (qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR)) {
-		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_WAIT_RNR);
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
 
-	if (qp->s_flags & QIB_S_ANY_WAIT_SEND)
-		qp->s_flags &= ~QIB_S_ANY_WAIT_SEND;
+	if (qp->s_flags & RVT_S_ANY_WAIT_SEND)
+		qp->s_flags &= ~RVT_S_ANY_WAIT_SEND;
 
 	spin_lock(&dev->rdi.pending_lock);
-	if (!list_empty(&priv->iowait) && !(qp->s_flags & QIB_S_BUSY)) {
-		qp->s_flags &= ~QIB_S_ANY_WAIT_IO;
+	if (!list_empty(&priv->iowait) && !(qp->s_flags & RVT_S_BUSY)) {
+		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
 		list_del_init(&priv->iowait);
 	}
 	spin_unlock(&dev->rdi.pending_lock);
 
-	if (!(qp->s_flags & QIB_S_BUSY)) {
+	if (!(qp->s_flags & RVT_S_BUSY)) {
 		qp->s_hdrwords = 0;
 		if (qp->s_rdma_mr) {
 			rvt_put_mr(qp->s_rdma_mr);
@@ -533,7 +533,7 @@ int qib_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	wc.qp = &qp->ibqp;
 	wc.opcode = IB_WC_RECV;
 
-	if (test_and_clear_bit(QIB_R_WRID_VALID, &qp->r_aflags)) {
+	if (test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags)) {
 		wc.wr_id = qp->r_wr_id;
 		wc.status = err;
 		qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
@@ -716,7 +716,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			if (!list_empty(&priv->iowait))
 				list_del_init(&priv->iowait);
 			spin_unlock(&dev->rdi.pending_lock);
-			qp->s_flags &= ~(QIB_S_TIMER | QIB_S_ANY_WAIT);
+			qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
 			spin_unlock(&qp->s_lock);
 			spin_unlock_irq(&qp->r_lock);
 			/* Stop the sending work queue and retry timer */
@@ -739,7 +739,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	case IB_QPS_RTR:
 		/* Allow event to retrigger if QP set to RTR more than once */
-		qp->r_flags &= ~QIB_R_COMM_EST;
+		qp->r_flags &= ~RVT_R_COMM_EST;
 		qp->state = new_state;
 		break;
 
@@ -910,7 +910,7 @@ int qib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->recv_cq = qp->ibqp.recv_cq;
 	init_attr->srq = qp->ibqp.srq;
 	init_attr->cap = attr->cap;
-	if (qp->s_flags & QIB_S_SIGNAL_REQ_WR)
+	if (qp->s_flags & RVT_S_SIGNAL_REQ_WR)
 		init_attr->sq_sig_type = IB_SIGNAL_REQ_WR;
 	else
 		init_attr->sq_sig_type = IB_SIGNAL_ALL_WR;
@@ -1128,7 +1128,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 		qp->s_size = init_attr->cap.max_send_wr + 1;
 		qp->s_max_sge = init_attr->cap.max_send_sge;
 		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
-			qp->s_flags = QIB_S_SIGNAL_REQ_WR;
+			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
 		dev = to_idev(ibpd->device);
 		dd = dd_from_dev(dev);
 		err = alloc_qpn(dd, &dev->rdi.qp_dev->qpn_table,
@@ -1244,7 +1244,7 @@ int qib_destroy_qp(struct ib_qp *ibqp)
 		if (!list_empty(&priv->iowait))
 			list_del_init(&priv->iowait);
 		spin_unlock(&dev->rdi.pending_lock);
-		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_ANY_WAIT);
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
 		spin_unlock_irq(&qp->s_lock);
 		cancel_work_sync(&priv->s_work);
 		del_timer_sync(&qp->s_timer);
@@ -1318,20 +1318,20 @@ void qib_get_credit(struct rvt_qp *qp, u32 aeth)
 	 * honor the credit field.
 	 */
 	if (credit == QIB_AETH_CREDIT_INVAL) {
-		if (!(qp->s_flags & QIB_S_UNLIMITED_CREDIT)) {
-			qp->s_flags |= QIB_S_UNLIMITED_CREDIT;
-			if (qp->s_flags & QIB_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~QIB_S_WAIT_SSN_CREDIT;
+		if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
+			qp->s_flags |= RVT_S_UNLIMITED_CREDIT;
+			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
+				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
 				qib_schedule_send(qp);
 			}
 		}
-	} else if (!(qp->s_flags & QIB_S_UNLIMITED_CREDIT)) {
+	} else if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
 		/* Compute new LSN (i.e., MSN + credit) */
 		credit = (aeth + credit_table[credit]) & QIB_MSN_MASK;
 		if (qib_cmp24(credit, qp->s_lsn) > 0) {
 			qp->s_lsn = credit;
-			if (qp->s_flags & QIB_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~QIB_S_WAIT_SSN_CREDIT;
+			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
+				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
 				qib_schedule_send(qp);
 			}
 		}
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 1e8463d..e118004 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -56,7 +56,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 
 static void start_timer(struct rvt_qp *qp)
 {
-	qp->s_flags |= QIB_S_TIMER;
+	qp->s_flags |= RVT_S_TIMER;
 	qp->s_timer.function = rc_timeout;
 	/* 4.096 usec. * (1 << qp->timeout) */
 	qp->s_timer.expires = jiffies + qp->timeout_jiffies;
@@ -112,7 +112,7 @@ static int qib_make_rc_ack(struct qib_ibdev *dev, struct rvt_qp *qp,
 	case OP(ACKNOWLEDGE):
 		/* Check for no next entry in the queue. */
 		if (qp->r_head_ack_queue == qp->s_tail_ack_queue) {
-			if (qp->s_flags & QIB_S_ACK_PENDING)
+			if (qp->s_flags & RVT_S_ACK_PENDING)
 				goto normal;
 			goto bail;
 		}
@@ -196,7 +196,7 @@ normal:
 		 * (see above).
 		 */
 		qp->s_ack_state = OP(SEND_ONLY);
-		qp->s_flags &= ~QIB_S_ACK_PENDING;
+		qp->s_flags &= ~RVT_S_ACK_PENDING;
 		qp->s_cur_sge = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
@@ -218,7 +218,7 @@ normal:
 
 bail:
 	qp->s_ack_state = OP(ACKNOWLEDGE);
-	qp->s_flags &= ~(QIB_S_RESP_PENDING | QIB_S_ACK_PENDING);
+	qp->s_flags &= ~(RVT_S_RESP_PENDING | RVT_S_ACK_PENDING);
 	return 0;
 }
 
@@ -256,7 +256,7 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	spin_lock_irqsave(&qp->s_lock, flags);
 
 	/* Sending responses has higher priority over sending requests. */
-	if ((qp->s_flags & QIB_S_RESP_PENDING) &&
+	if ((qp->s_flags & RVT_S_RESP_PENDING) &&
 	    qib_make_rc_ack(dev, qp, ohdr, pmtu))
 		goto done;
 
@@ -268,7 +268,7 @@ int qib_make_rc_req(struct rvt_qp *qp)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
-			qp->s_flags |= QIB_S_WAIT_DMA;
+			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
 		wqe = get_swqe_ptr(qp, qp->s_last);
@@ -278,12 +278,12 @@ int qib_make_rc_req(struct rvt_qp *qp)
 		goto done;
 	}
 
-	if (qp->s_flags & (QIB_S_WAIT_RNR | QIB_S_WAIT_ACK))
+	if (qp->s_flags & (RVT_S_WAIT_RNR | RVT_S_WAIT_ACK))
 		goto bail;
 
 	if (qib_cmp24(qp->s_psn, qp->s_sending_hpsn) <= 0) {
 		if (qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0) {
-			qp->s_flags |= QIB_S_WAIT_PSN;
+			qp->s_flags |= RVT_S_WAIT_PSN;
 			goto bail;
 		}
 		qp->s_sending_psn = qp->s_psn;
@@ -318,7 +318,7 @@ int qib_make_rc_req(struct rvt_qp *qp)
 			 */
 			if ((wqe->wr.send_flags & IB_SEND_FENCE) &&
 			    qp->s_num_rd_atomic) {
-				qp->s_flags |= QIB_S_WAIT_FENCE;
+				qp->s_flags |= RVT_S_WAIT_FENCE;
 				goto bail;
 			}
 			wqe->psn = qp->s_next_psn;
@@ -336,9 +336,9 @@ int qib_make_rc_req(struct rvt_qp *qp)
 		case IB_WR_SEND:
 		case IB_WR_SEND_WITH_IMM:
 			/* If no credit, return. */
-			if (!(qp->s_flags & QIB_S_UNLIMITED_CREDIT) &&
+			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
 			    qib_cmp24(wqe->ssn, qp->s_lsn + 1) > 0) {
-				qp->s_flags |= QIB_S_WAIT_SSN_CREDIT;
+				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
 			wqe->lpsn = wqe->psn;
@@ -364,14 +364,14 @@ int qib_make_rc_req(struct rvt_qp *qp)
 			break;
 
 		case IB_WR_RDMA_WRITE:
-			if (newreq && !(qp->s_flags & QIB_S_UNLIMITED_CREDIT))
+			if (newreq && !(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 				qp->s_lsn++;
 			/* FALLTHROUGH */
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			/* If no credit, return. */
-			if (!(qp->s_flags & QIB_S_UNLIMITED_CREDIT) &&
+			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
 			    qib_cmp24(wqe->ssn, qp->s_lsn + 1) > 0) {
-				qp->s_flags |= QIB_S_WAIT_SSN_CREDIT;
+				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
 
@@ -412,11 +412,11 @@ int qib_make_rc_req(struct rvt_qp *qp)
 			if (newreq) {
 				if (qp->s_num_rd_atomic >=
 				    qp->s_max_rd_atomic) {
-					qp->s_flags |= QIB_S_WAIT_RDMAR;
+					qp->s_flags |= RVT_S_WAIT_RDMAR;
 					goto bail;
 				}
 				qp->s_num_rd_atomic++;
-				if (!(qp->s_flags & QIB_S_UNLIMITED_CREDIT))
+				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
 				/*
 				 * Adjust s_next_psn to count the
@@ -450,11 +450,11 @@ int qib_make_rc_req(struct rvt_qp *qp)
 			if (newreq) {
 				if (qp->s_num_rd_atomic >=
 				    qp->s_max_rd_atomic) {
-					qp->s_flags |= QIB_S_WAIT_RDMAR;
+					qp->s_flags |= RVT_S_WAIT_RDMAR;
 					goto bail;
 				}
 				qp->s_num_rd_atomic++;
-				if (!(qp->s_flags & QIB_S_UNLIMITED_CREDIT))
+				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
 				wqe->lpsn = wqe->psn;
 			}
@@ -619,9 +619,9 @@ int qib_make_rc_req(struct rvt_qp *qp)
 	delta = (((int) bth2 - (int) wqe->psn) << 8) >> 8;
 	if (delta && delta % QIB_PSN_CREDIT == 0)
 		bth2 |= IB_BTH_REQ_ACK;
-	if (qp->s_flags & QIB_S_SEND_ONE) {
-		qp->s_flags &= ~QIB_S_SEND_ONE;
-		qp->s_flags |= QIB_S_WAIT_ACK;
+	if (qp->s_flags & RVT_S_SEND_ONE) {
+		qp->s_flags &= ~RVT_S_SEND_ONE;
+		qp->s_flags |= RVT_S_WAIT_ACK;
 		bth2 |= IB_BTH_REQ_ACK;
 	}
 	qp->s_len -= len;
@@ -634,7 +634,7 @@ done:
 	goto unlock;
 
 bail:
-	qp->s_flags &= ~QIB_S_BUSY;
+	qp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
@@ -670,7 +670,7 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 		goto unlock;
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
-	if ((qp->s_flags & QIB_S_RESP_PENDING) || qp->s_rdma_ack_cnt)
+	if ((qp->s_flags & RVT_S_RESP_PENDING) || qp->s_rdma_ack_cnt)
 		goto queue_ack;
 
 	/* Construct the header with s_lock held so APM doesn't change it. */
@@ -761,7 +761,7 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 queue_ack:
 	if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK) {
 		this_cpu_inc(*ibp->rvp.rc_qacks);
-		qp->s_flags |= QIB_S_ACK_PENDING | QIB_S_RESP_PENDING;
+		qp->s_flags |= RVT_S_ACK_PENDING | RVT_S_RESP_PENDING;
 		qp->s_nak_state = qp->r_nak_state;
 		qp->s_ack_psn = qp->r_ack_psn;
 
@@ -855,13 +855,13 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
 done:
 	qp->s_psn = psn;
 	/*
-	 * Set QIB_S_WAIT_PSN as qib_rc_complete() may start the timer
+	 * Set RVT_S_WAIT_PSN as qib_rc_complete() may start the timer
 	 * asynchronously before the send tasklet can get scheduled.
 	 * Doing it in qib_make_rc_req() is too late.
 	 */
 	if ((qib_cmp24(qp->s_psn, qp->s_sending_hpsn) <= 0) &&
 	    (qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0))
-		qp->s_flags |= QIB_S_WAIT_PSN;
+		qp->s_flags |= RVT_S_WAIT_PSN;
 }
 
 /*
@@ -892,11 +892,11 @@ static void qib_restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 	else
 		ibp->rvp.n_rc_resends += (qp->s_psn - psn) & QIB_PSN_MASK;
 
-	qp->s_flags &= ~(QIB_S_WAIT_FENCE | QIB_S_WAIT_RDMAR |
-			 QIB_S_WAIT_SSN_CREDIT | QIB_S_WAIT_PSN |
-			 QIB_S_WAIT_ACK);
+	qp->s_flags &= ~(RVT_S_WAIT_FENCE | RVT_S_WAIT_RDMAR |
+			 RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_PSN |
+			 RVT_S_WAIT_ACK);
 	if (wait)
-		qp->s_flags |= QIB_S_SEND_ONE;
+		qp->s_flags |= RVT_S_SEND_ONE;
 	reset_psn(qp, psn);
 }
 
@@ -911,10 +911,10 @@ static void rc_timeout(unsigned long arg)
 
 	spin_lock_irqsave(&qp->r_lock, flags);
 	spin_lock(&qp->s_lock);
-	if (qp->s_flags & QIB_S_TIMER) {
+	if (qp->s_flags & RVT_S_TIMER) {
 		ibp = to_iport(qp->ibqp.device, qp->port_num);
 		ibp->rvp.n_rc_timeouts++;
-		qp->s_flags &= ~QIB_S_TIMER;
+		qp->s_flags &= ~RVT_S_TIMER;
 		del_timer(&qp->s_timer);
 		qib_restart_rc(qp, qp->s_last_psn + 1, 1);
 		qib_schedule_send(qp);
@@ -932,8 +932,8 @@ void qib_rc_rnr_retry(unsigned long arg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (qp->s_flags & QIB_S_WAIT_RNR) {
-		qp->s_flags &= ~QIB_S_WAIT_RNR;
+	if (qp->s_flags & RVT_S_WAIT_RNR) {
+		qp->s_flags &= ~RVT_S_WAIT_RNR;
 		del_timer(&qp->s_timer);
 		qib_schedule_send(qp);
 	}
@@ -1003,7 +1003,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 	 * there are still requests that haven't been acked.
 	 */
 	if ((psn & IB_BTH_REQ_ACK) && qp->s_acked != qp->s_tail &&
-	    !(qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR | QIB_S_WAIT_PSN)) &&
+	    !(qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
 	    (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK))
 		start_timer(qp);
 
@@ -1018,7 +1018,7 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
+		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 			memset(&wc, 0, sizeof(wc));
 			wc.wr_id = wqe->wr.wr_id;
@@ -1035,9 +1035,9 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 	 * If we were waiting for sends to complete before resending,
 	 * and they are now complete, restart sending.
 	 */
-	if (qp->s_flags & QIB_S_WAIT_PSN &&
+	if (qp->s_flags & RVT_S_WAIT_PSN &&
 	    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
-		qp->s_flags &= ~QIB_S_WAIT_PSN;
+		qp->s_flags &= ~RVT_S_WAIT_PSN;
 		qp->s_sending_psn = qp->s_psn;
 		qp->s_sending_hpsn = qp->s_psn - 1;
 		qib_schedule_send(qp);
@@ -1074,7 +1074,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
+		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 			memset(&wc, 0, sizeof(wc));
 			wc.wr_id = wqe->wr.wr_id;
@@ -1138,8 +1138,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	int diff;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR)) {
-		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_WAIT_RNR);
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
 
@@ -1187,11 +1187,11 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		      wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) &&
 		     (opcode != OP(ATOMIC_ACKNOWLEDGE) || diff != 0))) {
 			/* Retry this request. */
-			if (!(qp->r_flags & QIB_R_RDMAR_SEQ)) {
-				qp->r_flags |= QIB_R_RDMAR_SEQ;
+			if (!(qp->r_flags & RVT_R_RDMAR_SEQ)) {
+				qp->r_flags |= RVT_R_RDMAR_SEQ;
 				qib_restart_rc(qp, qp->s_last_psn + 1, 0);
 				if (list_empty(&qp->rspwait)) {
-					qp->r_flags |= QIB_R_RSP_SEND;
+					qp->r_flags |= RVT_R_RSP_SEND;
 					atomic_inc(&qp->refcount);
 					list_add_tail(&qp->rspwait,
 						      &rcd->qp_wait_list);
@@ -1214,14 +1214,14 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		     wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD)) {
 			qp->s_num_rd_atomic--;
 			/* Restart sending task if fence is complete */
-			if ((qp->s_flags & QIB_S_WAIT_FENCE) &&
+			if ((qp->s_flags & RVT_S_WAIT_FENCE) &&
 			    !qp->s_num_rd_atomic) {
-				qp->s_flags &= ~(QIB_S_WAIT_FENCE |
-						 QIB_S_WAIT_ACK);
+				qp->s_flags &= ~(RVT_S_WAIT_FENCE |
+						 RVT_S_WAIT_ACK);
 				qib_schedule_send(qp);
-			} else if (qp->s_flags & QIB_S_WAIT_RDMAR) {
-				qp->s_flags &= ~(QIB_S_WAIT_RDMAR |
-						 QIB_S_WAIT_ACK);
+			} else if (qp->s_flags & RVT_S_WAIT_RDMAR) {
+				qp->s_flags &= ~(RVT_S_WAIT_RDMAR |
+						 RVT_S_WAIT_ACK);
 				qib_schedule_send(qp);
 			}
 		}
@@ -1249,8 +1249,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			qp->s_state = OP(SEND_LAST);
 			qp->s_psn = psn + 1;
 		}
-		if (qp->s_flags & QIB_S_WAIT_ACK) {
-			qp->s_flags &= ~QIB_S_WAIT_ACK;
+		if (qp->s_flags & RVT_S_WAIT_ACK) {
+			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			qib_schedule_send(qp);
 		}
 		qib_get_credit(qp, aeth);
@@ -1264,7 +1264,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		ibp->rvp.n_rnr_naks++;
 		if (qp->s_acked == qp->s_tail)
 			goto bail;
-		if (qp->s_flags & QIB_S_WAIT_RNR)
+		if (qp->s_flags & RVT_S_WAIT_RNR)
 			goto bail;
 		if (qp->s_rnr_retry == 0) {
 			status = IB_WC_RNR_RETRY_EXC_ERR;
@@ -1280,8 +1280,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 
 		reset_psn(qp, psn);
 
-		qp->s_flags &= ~(QIB_S_WAIT_SSN_CREDIT | QIB_S_WAIT_ACK);
-		qp->s_flags |= QIB_S_WAIT_RNR;
+		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
+		qp->s_flags |= RVT_S_WAIT_RNR;
 		qp->s_timer.function = qib_rc_rnr_retry;
 		qp->s_timer.expires = jiffies + usecs_to_jiffies(
 			ib_qib_rnr_table[(aeth >> QIB_AETH_CREDIT_SHIFT) &
@@ -1356,8 +1356,8 @@ static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
 	struct rvt_swqe *wqe;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (QIB_S_TIMER | QIB_S_WAIT_RNR)) {
-		qp->s_flags &= ~(QIB_S_TIMER | QIB_S_WAIT_RNR);
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
 
@@ -1372,10 +1372,10 @@ static void rdma_seq_err(struct rvt_qp *qp, struct qib_ibport *ibp, u32 psn,
 	}
 
 	ibp->rvp.n_rdma_seq++;
-	qp->r_flags |= QIB_R_RDMAR_SEQ;
+	qp->r_flags |= RVT_R_RDMAR_SEQ;
 	qib_restart_rc(qp, qp->s_last_psn + 1, 0);
 	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= QIB_R_RSP_SEND;
+		qp->r_flags |= RVT_R_RSP_SEND;
 		atomic_inc(&qp->refcount);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
@@ -1426,7 +1426,7 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 			 * If send tasklet not running attempt to progress
 			 * SDMA queue.
 			 */
-			if (!(qp->s_flags & QIB_S_BUSY)) {
+			if (!(qp->s_flags & RVT_S_BUSY)) {
 				/* Acquire SDMA Lock */
 				spin_lock_irqsave(&ppd->sdma_lock, flags);
 				/* Invoke sdma make progress */
@@ -1461,10 +1461,10 @@ static void qib_rc_rcv_resp(struct qib_ibport *ibp,
 	 * Skip everything other than the PSN we expect, if we are waiting
 	 * for a reply to a restarted RDMA read or atomic op.
 	 */
-	if (qp->r_flags & QIB_R_RDMAR_SEQ) {
+	if (qp->r_flags & RVT_R_RDMAR_SEQ) {
 		if (qib_cmp24(psn, qp->s_last_psn + 1) != 0)
 			goto ack_done;
-		qp->r_flags &= ~QIB_R_RDMAR_SEQ;
+		qp->r_flags &= ~RVT_R_RDMAR_SEQ;
 	}
 
 	if (unlikely(qp->s_acked == qp->s_tail))
@@ -1516,10 +1516,10 @@ read_middle:
 		 * We got a response so update the timeout.
 		 * 4.096 usec. * (1 << qp->timeout)
 		 */
-		qp->s_flags |= QIB_S_TIMER;
+		qp->s_flags |= RVT_S_TIMER;
 		mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
-		if (qp->s_flags & QIB_S_WAIT_ACK) {
-			qp->s_flags &= ~QIB_S_WAIT_ACK;
+		if (qp->s_flags & RVT_S_WAIT_ACK) {
+			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			qib_schedule_send(qp);
 		}
 
@@ -1653,7 +1653,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 			 * Otherwise, we end up propagating congestion.
 			 */
 			if (list_empty(&qp->rspwait)) {
-				qp->r_flags |= QIB_R_RSP_NAK;
+				qp->r_flags |= RVT_R_RSP_NAK;
 				atomic_inc(&qp->refcount);
 				list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 			}
@@ -1792,7 +1792,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 		 * which doesn't accept a RDMA read response or atomic
 		 * response as an ACK for earlier SENDs or RDMA writes.
 		 */
-		if (!(qp->s_flags & QIB_S_RESP_PENDING)) {
+		if (!(qp->s_flags & RVT_S_RESP_PENDING)) {
 			spin_unlock_irqrestore(&qp->s_lock, flags);
 			qp->r_nak_state = 0;
 			qp->r_ack_psn = qp->s_ack_queue[i].psn - 1;
@@ -1806,7 +1806,7 @@ static int qib_rc_rcv_error(struct qib_other_headers *ohdr,
 		break;
 	}
 	qp->s_ack_state = OP(ACKNOWLEDGE);
-	qp->s_flags |= QIB_S_RESP_PENDING;
+	qp->s_flags |= RVT_S_RESP_PENDING;
 	qp->r_nak_state = 0;
 	qib_schedule_send(qp);
 
@@ -1949,8 +1949,8 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 		break;
 	}
 
-	if (qp->state == IB_QPS_RTR && !(qp->r_flags & QIB_R_COMM_EST)) {
-		qp->r_flags |= QIB_R_COMM_EST;
+	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST)) {
+		qp->r_flags |= RVT_R_COMM_EST;
 		if (qp->ibqp.event_handler) {
 			struct ib_event ev;
 
@@ -2029,7 +2029,7 @@ send_last:
 		qib_copy_sge(&qp->r_sge, data, tlen, 1);
 		qib_put_ss(&qp->r_sge);
 		qp->r_msn++;
-		if (!test_and_clear_bit(QIB_R_WRID_VALID, &qp->r_aflags))
+		if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 			break;
 		wc.wr_id = qp->r_wr_id;
 		wc.status = IB_WC_SUCCESS;
@@ -2158,7 +2158,7 @@ send_last:
 		qp->r_head_ack_queue = next;
 
 		/* Schedule the send tasklet. */
-		qp->s_flags |= QIB_S_RESP_PENDING;
+		qp->s_flags |= RVT_S_RESP_PENDING;
 		qib_schedule_send(qp);
 
 		goto sunlock;
@@ -2222,7 +2222,7 @@ send_last:
 		qp->r_head_ack_queue = next;
 
 		/* Schedule the send tasklet. */
-		qp->s_flags |= QIB_S_RESP_PENDING;
+		qp->s_flags |= RVT_S_RESP_PENDING;
 		qib_schedule_send(qp);
 
 		goto sunlock;
@@ -2246,7 +2246,7 @@ rnr_nak:
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue RNR NAK for later */
 	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= QIB_R_RSP_NAK;
+		qp->r_flags |= RVT_R_RSP_NAK;
 		atomic_inc(&qp->refcount);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
@@ -2258,7 +2258,7 @@ nack_op_err:
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
 	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= QIB_R_RSP_NAK;
+		qp->r_flags |= RVT_R_RSP_NAK;
 		atomic_inc(&qp->refcount);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
@@ -2272,7 +2272,7 @@ nack_inv:
 	qp->r_ack_psn = qp->r_psn;
 	/* Queue NAK for later */
 	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= QIB_R_RSP_NAK;
+		qp->r_flags |= RVT_R_RSP_NAK;
 		atomic_inc(&qp->refcount);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 6290979..f7b3bb7 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -190,7 +190,7 @@ int qib_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	qp->r_wr_id = wqe->wr_id;
 
 	ret = 1;
-	set_bit(QIB_R_WRID_VALID, &qp->r_aflags);
+	set_bit(RVT_R_WRID_VALID, &qp->r_aflags);
 	if (handler) {
 		u32 n;
 
@@ -378,11 +378,11 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	spin_lock_irqsave(&sqp->s_lock, flags);
 
 	/* Return if we are already busy processing a work request. */
-	if ((sqp->s_flags & (QIB_S_BUSY | QIB_S_ANY_WAIT)) ||
+	if ((sqp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT)) ||
 	    !(ib_qib_state_ops[sqp->state] & QIB_PROCESS_OR_FLUSH_SEND))
 		goto unlock;
 
-	sqp->s_flags |= QIB_S_BUSY;
+	sqp->s_flags |= RVT_S_BUSY;
 
 again:
 	if (sqp->s_last == sqp->s_head)
@@ -547,7 +547,7 @@ again:
 	if (release)
 		qib_put_ss(&qp->r_sge);
 
-	if (!test_and_clear_bit(QIB_R_WRID_VALID, &qp->r_aflags))
+	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		goto send_comp;
 
 	if (wqe->wr.opcode == IB_WR_RDMA_WRITE_WITH_IMM)
@@ -592,7 +592,7 @@ rnr_nak:
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	if (!(ib_qib_state_ops[sqp->state] & QIB_PROCESS_RECV_OK))
 		goto clr_busy;
-	sqp->s_flags |= QIB_S_WAIT_RNR;
+	sqp->s_flags |= RVT_S_WAIT_RNR;
 	sqp->s_timer.function = qib_rc_rnr_retry;
 	sqp->s_timer.expires = jiffies +
 		usecs_to_jiffies(ib_qib_rnr_table[qp->r_min_rnr_timer]);
@@ -622,7 +622,7 @@ serr:
 	if (sqp->ibqp.qp_type == IB_QPT_RC) {
 		int lastwqe = qib_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
 
-		sqp->s_flags &= ~QIB_S_BUSY;
+		sqp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock_irqrestore(&sqp->s_lock, flags);
 		if (lastwqe) {
 			struct ib_event ev;
@@ -635,7 +635,7 @@ serr:
 		goto done;
 	}
 clr_busy:
-	sqp->s_flags &= ~QIB_S_BUSY;
+	sqp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&sqp->s_lock, flags);
 done:
@@ -751,7 +751,7 @@ void qib_do_send(struct work_struct *work)
 		return;
 	}
 
-	qp->s_flags |= QIB_S_BUSY;
+	qp->s_flags |= RVT_S_BUSY;
 
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 
@@ -794,7 +794,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
 	/* See ch. 11.2.4.1 and 10.7.3.1 */
-	if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
+	if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
 	    status != IB_WC_SUCCESS) {
 		struct ib_wc wc;
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index bb34bb9..3819a6d 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -703,11 +703,11 @@ busy:
 
 			ibp = &ppd->ibport_data;
 			ibp->rvp.n_dmawait++;
-			qp->s_flags |= QIB_S_WAIT_DMA_DESC;
+			qp->s_flags |= RVT_S_WAIT_DMA_DESC;
 			list_add_tail(&priv->iowait, &dev->dmawait);
 		}
 		spin_unlock(&dev->rdi.pending_lock);
-		qp->s_flags &= ~QIB_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock(&qp->s_lock);
 		ret = -EBUSY;
 	} else {
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 659ac51..deceb45 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -65,7 +65,7 @@ int qib_make_uc_req(struct rvt_qp *qp)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
-			qp->s_flags |= QIB_S_WAIT_DMA;
+			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
 		wqe = get_swqe_ptr(qp, qp->s_last);
@@ -221,7 +221,7 @@ done:
 	goto unlock;
 
 bail:
-	qp->s_flags &= ~QIB_S_BUSY;
+	qp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
@@ -279,7 +279,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 inv:
 		if (qp->r_state == OP(SEND_FIRST) ||
 		    qp->r_state == OP(SEND_MIDDLE)) {
-			set_bit(QIB_R_REWIND_SGE, &qp->r_aflags);
+			set_bit(RVT_R_REWIND_SGE, &qp->r_aflags);
 			qp->r_sge.num_sge = 0;
 		} else
 			qib_put_ss(&qp->r_sge);
@@ -329,8 +329,8 @@ inv:
 		goto inv;
 	}
 
-	if (qp->state == IB_QPS_RTR && !(qp->r_flags & QIB_R_COMM_EST)) {
-		qp->r_flags |= QIB_R_COMM_EST;
+	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST)) {
+		qp->r_flags |= RVT_R_COMM_EST;
 		if (qp->ibqp.event_handler) {
 			struct ib_event ev;
 
@@ -347,7 +347,7 @@ inv:
 	case OP(SEND_ONLY):
 	case OP(SEND_ONLY_WITH_IMMEDIATE):
 send_first:
-		if (test_and_clear_bit(QIB_R_REWIND_SGE, &qp->r_aflags))
+		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 			qp->r_sge = qp->s_rdma_read_sge;
 		else {
 			ret = qib_get_rwqe(qp, 0);
@@ -484,7 +484,7 @@ rdma_last_imm:
 		tlen -= (hdrsize + pad + 4);
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
-		if (test_and_clear_bit(QIB_R_REWIND_SGE, &qp->r_aflags))
+		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 			qib_put_ss(&qp->s_rdma_read_sge);
 		else {
 			ret = qib_get_rwqe(qp, 1);
@@ -524,7 +524,7 @@ rdma_last:
 	return;
 
 rewind:
-	set_bit(QIB_R_REWIND_SGE, &qp->r_aflags);
+	set_bit(RVT_R_REWIND_SGE, &qp->r_aflags);
 	qp->r_sge.num_sge = 0;
 drop:
 	ibp->rvp.n_pkt_drops++;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index d84872d..76f854e 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -141,8 +141,8 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
-	if (qp->r_flags & QIB_R_REUSE_SGE)
-		qp->r_flags &= ~QIB_R_REUSE_SGE;
+	if (qp->r_flags & RVT_R_REUSE_SGE)
+		qp->r_flags &= ~RVT_R_REUSE_SGE;
 	else {
 		int ret;
 
@@ -159,7 +159,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	}
 	/* Silently drop packets which are too big. */
 	if (unlikely(wc.byte_len > qp->r_len)) {
-		qp->r_flags |= QIB_R_REUSE_SGE;
+		qp->r_flags |= RVT_R_REUSE_SGE;
 		ibp->rvp.n_pkt_drops++;
 		goto bail_unlock;
 	}
@@ -203,7 +203,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		length -= len;
 	}
 	qib_put_ss(&qp->r_sge);
-	if (!test_and_clear_bit(QIB_R_WRID_VALID, &qp->r_aflags))
+	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		goto bail_unlock;
 	wc.wr_id = qp->r_wr_id;
 	wc.status = IB_WC_SUCCESS;
@@ -260,7 +260,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_dma_busy)) {
-			qp->s_flags |= QIB_S_WAIT_DMA;
+			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
 		wqe = get_swqe_ptr(qp, qp->s_last);
@@ -297,7 +297,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 			 * zero length descriptor so we get a callback.
 			 */
 			if (atomic_read(&priv->s_dma_busy)) {
-				qp->s_flags |= QIB_S_WAIT_DMA;
+				qp->s_flags |= RVT_S_WAIT_DMA;
 				goto bail;
 			}
 			qp->s_cur = next_cur;
@@ -389,7 +389,7 @@ done:
 	goto unlock;
 
 bail:
-	qp->s_flags &= ~QIB_S_BUSY;
+	qp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
@@ -534,8 +534,8 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
-	if (qp->r_flags & QIB_R_REUSE_SGE)
-		qp->r_flags &= ~QIB_R_REUSE_SGE;
+	if (qp->r_flags & RVT_R_REUSE_SGE)
+		qp->r_flags &= ~RVT_R_REUSE_SGE;
 	else {
 		int ret;
 
@@ -552,7 +552,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	}
 	/* Silently drop packets which are too big. */
 	if (unlikely(wc.byte_len > qp->r_len)) {
-		qp->r_flags |= QIB_R_REUSE_SGE;
+		qp->r_flags |= RVT_R_REUSE_SGE;
 		goto drop;
 	}
 	if (has_grh) {
@@ -563,7 +563,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 		qib_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
 	qib_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh), 1);
 	qib_put_ss(&qp->r_sge);
-	if (!test_and_clear_bit(QIB_R_WRID_VALID, &qp->r_aflags))
+	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		return;
 	wc.wr_id = qp->r_wr_id;
 	wc.status = IB_WC_SUCCESS;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 45f9582..c190534 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -734,8 +734,8 @@ static void mem_timer(unsigned long data)
 
 	if (qp) {
 		spin_lock_irqsave(&qp->s_lock, flags);
-		if (qp->s_flags & QIB_S_WAIT_KMEM) {
-			qp->s_flags &= ~QIB_S_WAIT_KMEM;
+		if (qp->s_flags & RVT_S_WAIT_KMEM) {
+			qp->s_flags &= ~RVT_S_WAIT_KMEM;
 			qib_schedule_send(qp);
 		}
 		spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -958,10 +958,10 @@ static noinline struct qib_verbs_txreq *__get_txreq(struct qib_ibdev *dev,
 		if (ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK &&
 		    list_empty(&priv->iowait)) {
 			dev->n_txwait++;
-			qp->s_flags |= QIB_S_WAIT_TX;
+			qp->s_flags |= RVT_S_WAIT_TX;
 			list_add_tail(&priv->iowait, &dev->txwait);
 		}
-		qp->s_flags &= ~QIB_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock(&dev->rdi.pending_lock);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		tx = ERR_PTR(-EBUSY);
@@ -1030,8 +1030,8 @@ void qib_put_txreq(struct qib_verbs_txreq *tx)
 		spin_unlock_irqrestore(&dev->rdi.pending_lock, flags);
 
 		spin_lock_irqsave(&qp->s_lock, flags);
-		if (qp->s_flags & QIB_S_WAIT_TX) {
-			qp->s_flags &= ~QIB_S_WAIT_TX;
+		if (qp->s_flags & RVT_S_WAIT_TX) {
+			qp->s_flags &= ~RVT_S_WAIT_TX;
 			qib_schedule_send(qp);
 		}
 		spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1081,8 +1081,8 @@ void qib_verbs_sdma_desc_avail(struct qib_pportdata *ppd, unsigned avail)
 	for (i = 0; i < n; i++) {
 		qp = qps[i];
 		spin_lock(&qp->s_lock);
-		if (qp->s_flags & QIB_S_WAIT_DMA_DESC) {
-			qp->s_flags &= ~QIB_S_WAIT_DMA_DESC;
+		if (qp->s_flags & RVT_S_WAIT_DMA_DESC) {
+			qp->s_flags &= ~RVT_S_WAIT_DMA_DESC;
 			qib_schedule_send(qp);
 		}
 		spin_unlock(&qp->s_lock);
@@ -1119,8 +1119,8 @@ static void sdma_complete(struct qib_sdma_txreq *cookie, int status)
 	if (atomic_dec_and_test(&priv->s_dma_busy)) {
 		if (qp->state == IB_QPS_RESET)
 			wake_up(&priv->wait_dma);
-		else if (qp->s_flags & QIB_S_WAIT_DMA) {
-			qp->s_flags &= ~QIB_S_WAIT_DMA;
+		else if (qp->s_flags & RVT_S_WAIT_DMA) {
+			qp->s_flags &= ~RVT_S_WAIT_DMA;
 			qib_schedule_send(qp);
 		}
 	}
@@ -1141,11 +1141,11 @@ static int wait_kmem(struct qib_ibdev *dev, struct rvt_qp *qp)
 		if (list_empty(&priv->iowait)) {
 			if (list_empty(&dev->memwait))
 				mod_timer(&dev->mem_timer, jiffies + 1);
-			qp->s_flags |= QIB_S_WAIT_KMEM;
+			qp->s_flags |= RVT_S_WAIT_KMEM;
 			list_add_tail(&priv->iowait, &dev->memwait);
 		}
 		spin_unlock(&dev->rdi.pending_lock);
-		qp->s_flags &= ~QIB_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		ret = -EBUSY;
 	}
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1277,13 +1277,13 @@ static int no_bufs_available(struct rvt_qp *qp)
 		spin_lock(&dev->rdi.pending_lock);
 		if (list_empty(&priv->iowait)) {
 			dev->n_piowait++;
-			qp->s_flags |= QIB_S_WAIT_PIO;
+			qp->s_flags |= RVT_S_WAIT_PIO;
 			list_add_tail(&priv->iowait, &dev->piowait);
 			dd = dd_from_dev(dev);
 			dd->f_wantpiobuf_intr(dd, 1);
 		}
 		spin_unlock(&dev->rdi.pending_lock);
-		qp->s_flags &= ~QIB_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		ret = -EBUSY;
 	}
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1396,7 +1396,7 @@ done:
  * @len: the length of the packet in bytes
  *
  * Return zero if packet is sent or queued OK.
- * Return non-zero and clear qp->s_flags QIB_S_BUSY otherwise.
+ * Return non-zero and clear qp->s_flags RVT_S_BUSY otherwise.
  */
 int qib_verbs_send(struct rvt_qp *qp, struct qib_ib_header *hdr,
 		   u32 hdrwords, struct rvt_sge_state *ss, u32 len)
@@ -1564,8 +1564,8 @@ full:
 		qp = qps[i];
 
 		spin_lock_irqsave(&qp->s_lock, flags);
-		if (qp->s_flags & QIB_S_WAIT_PIO) {
-			qp->s_flags &= ~QIB_S_WAIT_PIO;
+		if (qp->s_flags & RVT_S_WAIT_PIO) {
+			qp->s_flags &= ~RVT_S_WAIT_PIO;
 			qib_schedule_send(qp);
 		}
 		spin_unlock_irqrestore(&qp->s_lock, flags);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index e10ab80..86d7537 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -262,78 +262,6 @@ struct qib_qp_priv {
 	struct rvt_qp *owner;
 };
 
-/*
- * Atomic bit definitions for r_aflags.
- */
-#define QIB_R_WRID_VALID        0
-#define QIB_R_REWIND_SGE        1
-
-/*
- * Bit definitions for r_flags.
- */
-#define QIB_R_REUSE_SGE 0x01
-#define QIB_R_RDMAR_SEQ 0x02
-#define QIB_R_RSP_NAK   0x04
-#define QIB_R_RSP_SEND  0x08
-#define QIB_R_COMM_EST  0x10
-
-/*
- * Bit definitions for s_flags.
- *
- * QIB_S_SIGNAL_REQ_WR - set if QP send WRs contain completion signaled
- * QIB_S_BUSY - send tasklet is processing the QP
- * QIB_S_TIMER - the RC retry timer is active
- * QIB_S_ACK_PENDING - an ACK is waiting to be sent after RDMA read/atomics
- * QIB_S_WAIT_FENCE - waiting for all prior RDMA read or atomic SWQEs
- *                         before processing the next SWQE
- * QIB_S_WAIT_RDMAR - waiting for a RDMA read or atomic SWQE to complete
- *                         before processing the next SWQE
- * QIB_S_WAIT_RNR - waiting for RNR timeout
- * QIB_S_WAIT_SSN_CREDIT - waiting for RC credits to process next SWQE
- * QIB_S_WAIT_DMA - waiting for send DMA queue to drain before generating
- *                  next send completion entry not via send DMA
- * QIB_S_WAIT_PIO - waiting for a send buffer to be available
- * QIB_S_WAIT_TX - waiting for a struct qib_verbs_txreq to be available
- * QIB_S_WAIT_DMA_DESC - waiting for DMA descriptors to be available
- * QIB_S_WAIT_KMEM - waiting for kernel memory to be available
- * QIB_S_WAIT_PSN - waiting for a packet to exit the send DMA queue
- * QIB_S_WAIT_ACK - waiting for an ACK packet before sending more requests
- * QIB_S_SEND_ONE - send one packet, request ACK, then wait for ACK
- */
-#define QIB_S_SIGNAL_REQ_WR	0x0001
-#define QIB_S_BUSY		0x0002
-#define QIB_S_TIMER		0x0004
-#define QIB_S_RESP_PENDING	0x0008
-#define QIB_S_ACK_PENDING	0x0010
-#define QIB_S_WAIT_FENCE	0x0020
-#define QIB_S_WAIT_RDMAR	0x0040
-#define QIB_S_WAIT_RNR		0x0080
-#define QIB_S_WAIT_SSN_CREDIT	0x0100
-#define QIB_S_WAIT_DMA		0x0200
-#define QIB_S_WAIT_PIO		0x0400
-#define QIB_S_WAIT_TX		0x0800
-#define QIB_S_WAIT_DMA_DESC	0x1000
-#define QIB_S_WAIT_KMEM		0x2000
-#define QIB_S_WAIT_PSN		0x4000
-#define QIB_S_WAIT_ACK		0x8000
-#define QIB_S_SEND_ONE		0x10000
-#define QIB_S_UNLIMITED_CREDIT	0x20000
-
-/*
- * Wait flags that would prevent any packet type from being sent.
- */
-#define QIB_S_ANY_WAIT_IO (QIB_S_WAIT_PIO | QIB_S_WAIT_TX | \
-	QIB_S_WAIT_DMA_DESC | QIB_S_WAIT_KMEM)
-
-/*
- * Wait flags that would prevent send work requests from making progress.
- */
-#define QIB_S_ANY_WAIT_SEND (QIB_S_WAIT_FENCE | QIB_S_WAIT_RDMAR | \
-	QIB_S_WAIT_RNR | QIB_S_WAIT_SSN_CREDIT | QIB_S_WAIT_DMA | \
-	QIB_S_WAIT_PSN | QIB_S_WAIT_ACK)
-
-#define QIB_S_ANY_WAIT (QIB_S_ANY_WAIT_IO | QIB_S_ANY_WAIT_SEND)
-
 #define QIB_PSN_CREDIT  16
 
 /*
@@ -473,9 +401,9 @@ static inline struct qib_ibdev *to_idev(struct ib_device *ibdev)
  */
 static inline int qib_send_ok(struct rvt_qp *qp)
 {
-	return !(qp->s_flags & (QIB_S_BUSY | QIB_S_ANY_WAIT_IO)) &&
-		(qp->s_hdrwords || (qp->s_flags & QIB_S_RESP_PENDING) ||
-		 !(qp->s_flags & QIB_S_ANY_WAIT_SEND));
+	return !(qp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT_IO)) &&
+		(qp->s_hdrwords || (qp->s_flags & RVT_S_RESP_PENDING) ||
+		 !(qp->s_flags & RVT_S_ANY_WAIT_SEND));
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
