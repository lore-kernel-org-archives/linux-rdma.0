From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/31] staging/rdma/hfi1: Use rdmavt send flags and recv
 flags
Date: Tue, 19 Jan 2016 14:43:01 -0800
Message-ID: <20160119224300.32765.9807.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use the definitions of the s_flags and r_flags which are now in rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |    8 +-
 drivers/staging/rdma/hfi1/pio.c    |    2 
 drivers/staging/rdma/hfi1/qp.c     |   58 +++++++-------
 drivers/staging/rdma/hfi1/qp.h     |    2 
 drivers/staging/rdma/hfi1/rc.c     |  152 ++++++++++++++++++------------------
 drivers/staging/rdma/hfi1/ruc.c    |   30 ++++---
 drivers/staging/rdma/hfi1/uc.c     |   14 ++-
 drivers/staging/rdma/hfi1/ud.c     |   22 +++--
 drivers/staging/rdma/hfi1/verbs.c  |   28 +++----
 drivers/staging/rdma/hfi1/verbs.h  |   85 +-------------------
 10 files changed, 162 insertions(+), 239 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index da55e39..ec2286a 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -781,14 +781,14 @@ static inline void process_rcv_qp_work(struct hfi1_packet *packet)
 	 */
 	list_for_each_entry_safe(qp, nqp, &rcd->qp_wait_list, rspwait) {
 		list_del_init(&qp->rspwait);
-		if (qp->r_flags & HFI1_R_RSP_DEFERED_ACK) {
-			qp->r_flags &= ~HFI1_R_RSP_DEFERED_ACK;
+		if (qp->r_flags & RVT_R_RSP_NAK) {
+			qp->r_flags &= ~RVT_R_RSP_NAK;
 			hfi1_send_rc_ack(rcd, qp, 0);
 		}
-		if (qp->r_flags & HFI1_R_RSP_SEND) {
+		if (qp->r_flags & RVT_R_RSP_SEND) {
 			unsigned long flags;
 
-			qp->r_flags &= ~HFI1_R_RSP_SEND;
+			qp->r_flags &= ~RVT_R_RSP_SEND;
 			spin_lock_irqsave(&qp->s_lock, flags);
 			if (ib_hfi1_state_ops[qp->state] &
 					HFI1_PROCESS_OR_FLUSH_SEND)
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index 8ee7ed8..be0dcc3 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -1564,7 +1564,7 @@ full:
 	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 
 	for (i = 0; i < n; i++)
-		hfi1_qp_wakeup(qps[i], HFI1_S_WAIT_PIO);
+		hfi1_qp_wakeup(qps[i], RVT_S_WAIT_PIO);
 }
 
 /* translate a send credit update to a bit code of reasons */
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 20b1a84..d5620ba 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -360,7 +360,7 @@ static void reset_qp(struct rvt_qp *qp, enum ib_qp_type type)
 		hfi1_do_send,
 		iowait_sleep,
 		iowait_wakeup);
-	qp->s_flags &= HFI1_S_SIGNAL_REQ_WR;
+	qp->s_flags &= RVT_S_SIGNAL_REQ_WR;
 	qp->s_hdrwords = 0;
 	qp->s_wqe = NULL;
 	qp->s_draining = 0;
@@ -407,7 +407,7 @@ static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 {
 	unsigned n;
 
-	if (test_and_clear_bit(HFI1_R_REWIND_SGE, &qp->r_aflags))
+	if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 		hfi1_put_ss(&qp->s_rdma_read_sge);
 
 	hfi1_put_ss(&qp->r_sge);
@@ -471,24 +471,24 @@ int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 
 	qp->state = IB_QPS_ERR;
 
-	if (qp->s_flags & (HFI1_S_TIMER | HFI1_S_WAIT_RNR)) {
-		qp->s_flags &= ~(HFI1_S_TIMER | HFI1_S_WAIT_RNR);
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
 
-	if (qp->s_flags & HFI1_S_ANY_WAIT_SEND)
-		qp->s_flags &= ~HFI1_S_ANY_WAIT_SEND;
+	if (qp->s_flags & RVT_S_ANY_WAIT_SEND)
+		qp->s_flags &= ~RVT_S_ANY_WAIT_SEND;
 
 	write_seqlock(&dev->iowait_lock);
-	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & HFI1_S_BUSY)) {
-		qp->s_flags &= ~HFI1_S_ANY_WAIT_IO;
+	if (!list_empty(&priv->s_iowait.list) && !(qp->s_flags & RVT_S_BUSY)) {
+		qp->s_flags &= ~RVT_S_ANY_WAIT_IO;
 		list_del_init(&priv->s_iowait.list);
 		if (atomic_dec_and_test(&qp->refcount))
 			wake_up(&qp->wait);
 	}
 	write_sequnlock(&dev->iowait_lock);
 
-	if (!(qp->s_flags & HFI1_S_BUSY)) {
+	if (!(qp->s_flags & RVT_S_BUSY)) {
 		qp->s_hdrwords = 0;
 		if (qp->s_rdma_mr) {
 			rvt_put_mr(qp->s_rdma_mr);
@@ -507,7 +507,7 @@ int hfi1_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	wc.qp = &qp->ibqp;
 	wc.opcode = IB_WC_RECV;
 
-	if (test_and_clear_bit(HFI1_R_WRID_VALID, &qp->r_aflags)) {
+	if (test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags)) {
 		wc.wr_id = qp->r_wr_id;
 		wc.status = err;
 		hfi1_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
@@ -742,7 +742,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (qp->state != IB_QPS_RESET) {
 			qp->state = IB_QPS_RESET;
 			flush_iowait(qp);
-			qp->s_flags &= ~(HFI1_S_TIMER | HFI1_S_ANY_WAIT);
+			qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
 			spin_unlock(&qp->s_lock);
 			spin_unlock_irq(&qp->r_lock);
 			/* Stop the sending work queue and retry timer */
@@ -762,7 +762,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	case IB_QPS_RTR:
 		/* Allow event to re-trigger if QP set to RTR more than once */
-		qp->r_flags &= ~HFI1_R_COMM_EST;
+		qp->r_flags &= ~RVT_R_COMM_EST;
 		qp->state = new_state;
 		break;
 
@@ -828,7 +828,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			qp->remote_ah_attr = qp->alt_ah_attr;
 			qp->port_num = qp->alt_ah_attr.port_num;
 			qp->s_pkey_index = qp->s_alt_pkey_index;
-			qp->s_flags |= HFI1_S_AHG_CLEAR;
+			qp->s_flags |= RVT_S_AHG_CLEAR;
 			priv->s_sc = ah_to_sc(ibqp->device, &qp->remote_ah_attr);
 			priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 		}
@@ -954,7 +954,7 @@ int hfi1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	init_attr->recv_cq = qp->ibqp.recv_cq;
 	init_attr->srq = qp->ibqp.srq;
 	init_attr->cap = attr->cap;
-	if (qp->s_flags & HFI1_S_SIGNAL_REQ_WR)
+	if (qp->s_flags & RVT_S_SIGNAL_REQ_WR)
 		init_attr->sq_sig_type = IB_SIGNAL_REQ_WR;
 	else
 		init_attr->sq_sig_type = IB_SIGNAL_ALL_WR;
@@ -1154,7 +1154,7 @@ struct ib_qp *hfi1_create_qp(struct ib_pd *ibpd,
 		qp->s_size = init_attr->cap.max_send_wr + 1;
 		qp->s_max_sge = init_attr->cap.max_send_sge;
 		if (init_attr->sq_sig_type == IB_SIGNAL_REQ_WR)
-			qp->s_flags = HFI1_S_SIGNAL_REQ_WR;
+			qp->s_flags = RVT_S_SIGNAL_REQ_WR;
 		dev = to_idev(ibpd->device);
 		dd = dd_from_dev(dev);
 		err = alloc_qpn(dd, &dev->qp_dev->qpn_table, init_attr->qp_type,
@@ -1292,7 +1292,7 @@ int hfi1_destroy_qp(struct ib_qp *ibqp)
 	if (qp->state != IB_QPS_RESET) {
 		qp->state = IB_QPS_RESET;
 		flush_iowait(qp);
-		qp->s_flags &= ~(HFI1_S_TIMER | HFI1_S_ANY_WAIT);
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_ANY_WAIT);
 		spin_unlock(&qp->s_lock);
 		spin_unlock_irq(&qp->r_lock);
 		cancel_work_sync(&priv->s_iowait.iowork);
@@ -1398,20 +1398,20 @@ void hfi1_get_credit(struct rvt_qp *qp, u32 aeth)
 	 * honor the credit field.
 	 */
 	if (credit == HFI1_AETH_CREDIT_INVAL) {
-		if (!(qp->s_flags & HFI1_S_UNLIMITED_CREDIT)) {
-			qp->s_flags |= HFI1_S_UNLIMITED_CREDIT;
-			if (qp->s_flags & HFI1_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~HFI1_S_WAIT_SSN_CREDIT;
+		if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
+			qp->s_flags |= RVT_S_UNLIMITED_CREDIT;
+			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
+				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
 				hfi1_schedule_send(qp);
 			}
 		}
-	} else if (!(qp->s_flags & HFI1_S_UNLIMITED_CREDIT)) {
+	} else if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT)) {
 		/* Compute new LSN (i.e., MSN + credit) */
 		credit = (aeth + credit_table[credit]) & HFI1_MSN_MASK;
 		if (cmp_msn(credit, qp->s_lsn) > 0) {
 			qp->s_lsn = credit;
-			if (qp->s_flags & HFI1_S_WAIT_SSN_CREDIT) {
-				qp->s_flags &= ~HFI1_S_WAIT_SSN_CREDIT;
+			if (qp->s_flags & RVT_S_WAIT_SSN_CREDIT) {
+				qp->s_flags &= ~RVT_S_WAIT_SSN_CREDIT;
 				hfi1_schedule_send(qp);
 			}
 		}
@@ -1469,13 +1469,13 @@ static int iowait_sleep(
 				to_iport(qp->ibqp.device, qp->port_num);
 
 			ibp->rvp.n_dmawait++;
-			qp->s_flags |= HFI1_S_WAIT_DMA_DESC;
+			qp->s_flags |= RVT_S_WAIT_DMA_DESC;
 			list_add_tail(&priv->s_iowait.list, &sde->dmawait);
-			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_DMA_DESC);
+			trace_hfi1_qpsleep(qp, RVT_S_WAIT_DMA_DESC);
 			atomic_inc(&qp->refcount);
 		}
 		write_sequnlock(&dev->iowait_lock);
-		qp->s_flags &= ~HFI1_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		ret = -EBUSY;
 	} else {
@@ -1495,7 +1495,7 @@ static void iowait_wakeup(struct iowait *wait, int reason)
 	struct rvt_qp *qp = iowait_to_qp(wait);
 
 	WARN_ON(reason != SDMA_AVAIL_REASON);
-	hfi1_qp_wakeup(qp, HFI1_S_WAIT_DMA_DESC);
+	hfi1_qp_wakeup(qp, RVT_S_WAIT_DMA_DESC);
 }
 
 int hfi1_qp_init(struct hfi1_ibdev *dev)
@@ -1712,7 +1712,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 
 void qp_comm_est(struct rvt_qp *qp)
 {
-	qp->r_flags |= HFI1_R_COMM_EST;
+	qp->r_flags |= RVT_R_COMM_EST;
 	if (qp->ibqp.event_handler) {
 		struct ib_event ev;
 
@@ -1736,7 +1736,7 @@ void hfi1_migrate_qp(struct rvt_qp *qp)
 	qp->remote_ah_attr = qp->alt_ah_attr;
 	qp->port_num = qp->alt_ah_attr.port_num;
 	qp->s_pkey_index = qp->s_alt_pkey_index;
-	qp->s_flags |= HFI1_S_AHG_CLEAR;
+	qp->s_flags |= RVT_S_AHG_CLEAR;
 	priv->s_sc = ah_to_sc(qp->ibqp.device, &qp->remote_ah_attr);
 	priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
 
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 8e66562..9efa4bc 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -125,7 +125,7 @@ static inline void clear_ahg(struct rvt_qp *qp)
 	struct hfi1_qp_priv *priv = qp->priv;
 
 	priv->s_hdr->ahgcount = 0;
-	qp->s_flags &= ~(HFI1_S_AHG_VALID | HFI1_S_AHG_CLEAR);
+	qp->s_flags &= ~(RVT_S_AHG_VALID | RVT_S_AHG_CLEAR);
 	if (priv->s_sde && qp->s_ahgidx >= 0)
 		sdma_ahg_free(priv->s_sde, qp->s_ahgidx);
 	qp->s_ahgidx = -1;
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index d7334f4..bd504de 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -76,7 +76,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 
 static void start_timer(struct rvt_qp *qp)
 {
-	qp->s_flags |= HFI1_S_TIMER;
+	qp->s_flags |= RVT_S_TIMER;
 	qp->s_timer.function = rc_timeout;
 	/* 4.096 usec. * (1 << qp->timeout) */
 	qp->s_timer.expires = jiffies + qp->timeout_jiffies;
@@ -133,7 +133,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 	case OP(ACKNOWLEDGE):
 		/* Check for no next entry in the queue. */
 		if (qp->r_head_ack_queue == qp->s_tail_ack_queue) {
-			if (qp->s_flags & HFI1_S_ACK_PENDING)
+			if (qp->s_flags & RVT_S_ACK_PENDING)
 				goto normal;
 			goto bail;
 		}
@@ -218,7 +218,7 @@ normal:
 		 * (see above).
 		 */
 		qp->s_ack_state = OP(SEND_ONLY);
-		qp->s_flags &= ~HFI1_S_ACK_PENDING;
+		qp->s_flags &= ~RVT_S_ACK_PENDING;
 		qp->s_cur_sge = NULL;
 		if (qp->s_nak_state)
 			ohdr->u.aeth =
@@ -242,12 +242,12 @@ bail:
 	qp->s_ack_state = OP(ACKNOWLEDGE);
 	/*
 	 * Ensure s_rdma_ack_cnt changes are committed prior to resetting
-	 * HFI1_S_RESP_PENDING
+	 * RVT_S_RESP_PENDING
 	 */
 	smp_wmb();
-	qp->s_flags &= ~(HFI1_S_RESP_PENDING
-				| HFI1_S_ACK_PENDING
-				| HFI1_S_AHG_VALID);
+	qp->s_flags &= ~(RVT_S_RESP_PENDING
+				| RVT_S_ACK_PENDING
+				| RVT_S_AHG_VALID);
 	return 0;
 }
 
@@ -287,7 +287,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	spin_lock_irqsave(&qp->s_lock, flags);
 
 	/* Sending responses has higher priority over sending requests. */
-	if ((qp->s_flags & HFI1_S_RESP_PENDING) &&
+	if ((qp->s_flags & RVT_S_RESP_PENDING) &&
 	    make_rc_ack(dev, qp, ohdr, pmtu))
 		goto done;
 
@@ -299,7 +299,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_iowait.sdma_busy)) {
-			qp->s_flags |= HFI1_S_WAIT_DMA;
+			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
 		clear_ahg(qp);
@@ -310,12 +310,12 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		goto done;
 	}
 
-	if (qp->s_flags & (HFI1_S_WAIT_RNR | HFI1_S_WAIT_ACK))
+	if (qp->s_flags & (RVT_S_WAIT_RNR | RVT_S_WAIT_ACK))
 		goto bail;
 
 	if (cmp_psn(qp->s_psn, qp->s_sending_hpsn) <= 0) {
 		if (cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0) {
-			qp->s_flags |= HFI1_S_WAIT_PSN;
+			qp->s_flags |= RVT_S_WAIT_PSN;
 			goto bail;
 		}
 		qp->s_sending_psn = qp->s_psn;
@@ -348,7 +348,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 			 */
 			if ((wqe->wr.send_flags & IB_SEND_FENCE) &&
 			    qp->s_num_rd_atomic) {
-				qp->s_flags |= HFI1_S_WAIT_FENCE;
+				qp->s_flags |= RVT_S_WAIT_FENCE;
 				goto bail;
 			}
 			wqe->psn = qp->s_next_psn;
@@ -366,9 +366,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 		case IB_WR_SEND:
 		case IB_WR_SEND_WITH_IMM:
 			/* If no credit, return. */
-			if (!(qp->s_flags & HFI1_S_UNLIMITED_CREDIT) &&
+			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
 			    cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
-				qp->s_flags |= HFI1_S_WAIT_SSN_CREDIT;
+				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
 			wqe->lpsn = wqe->psn;
@@ -394,14 +394,14 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 			break;
 
 		case IB_WR_RDMA_WRITE:
-			if (newreq && !(qp->s_flags & HFI1_S_UNLIMITED_CREDIT))
+			if (newreq && !(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 				qp->s_lsn++;
 			/* FALLTHROUGH */
 		case IB_WR_RDMA_WRITE_WITH_IMM:
 			/* If no credit, return. */
-			if (!(qp->s_flags & HFI1_S_UNLIMITED_CREDIT) &&
+			if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT) &&
 			    cmp_msn(wqe->ssn, qp->s_lsn + 1) > 0) {
-				qp->s_flags |= HFI1_S_WAIT_SSN_CREDIT;
+				qp->s_flags |= RVT_S_WAIT_SSN_CREDIT;
 				goto bail;
 			}
 			ohdr->u.rc.reth.vaddr =
@@ -441,11 +441,11 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 			if (newreq) {
 				if (qp->s_num_rd_atomic >=
 				    qp->s_max_rd_atomic) {
-					qp->s_flags |= HFI1_S_WAIT_RDMAR;
+					qp->s_flags |= RVT_S_WAIT_RDMAR;
 					goto bail;
 				}
 				qp->s_num_rd_atomic++;
-				if (!(qp->s_flags & HFI1_S_UNLIMITED_CREDIT))
+				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
 				/*
 				 * Adjust s_next_psn to count the
@@ -478,11 +478,11 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 			if (newreq) {
 				if (qp->s_num_rd_atomic >=
 				    qp->s_max_rd_atomic) {
-					qp->s_flags |= HFI1_S_WAIT_RDMAR;
+					qp->s_flags |= RVT_S_WAIT_RDMAR;
 					goto bail;
 				}
 				qp->s_num_rd_atomic++;
-				if (!(qp->s_flags & HFI1_S_UNLIMITED_CREDIT))
+				if (!(qp->s_flags & RVT_S_UNLIMITED_CREDIT))
 					qp->s_lsn++;
 				wqe->lpsn = wqe->psn;
 			}
@@ -649,9 +649,9 @@ int hfi1_make_rc_req(struct rvt_qp *qp)
 	delta = delta_psn(bth2, wqe->psn);
 	if (delta && delta % HFI1_PSN_CREDIT == 0)
 		bth2 |= IB_BTH_REQ_ACK;
-	if (qp->s_flags & HFI1_S_SEND_ONE) {
-		qp->s_flags &= ~HFI1_S_SEND_ONE;
-		qp->s_flags |= HFI1_S_WAIT_ACK;
+	if (qp->s_flags & RVT_S_SEND_ONE) {
+		qp->s_flags &= ~RVT_S_SEND_ONE;
+		qp->s_flags |= RVT_S_WAIT_ACK;
 		bth2 |= IB_BTH_REQ_ACK;
 	}
 	qp->s_len -= len;
@@ -669,7 +669,7 @@ done:
 	goto unlock;
 
 bail:
-	qp->s_flags &= ~HFI1_S_BUSY;
+	qp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
@@ -701,7 +701,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	unsigned long flags;
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
-	if (qp->s_flags & HFI1_S_RESP_PENDING)
+	if (qp->s_flags & RVT_S_RESP_PENDING)
 		goto queue_ack;
 
 	/* Ensure s_rdma_ack_cnt changes are committed */
@@ -774,11 +774,11 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 queue_ack:
 	this_cpu_inc(*ibp->rvp.rc_qacks);
 	spin_lock_irqsave(&qp->s_lock, flags);
-	qp->s_flags |= HFI1_S_ACK_PENDING | HFI1_S_RESP_PENDING;
+	qp->s_flags |= RVT_S_ACK_PENDING | RVT_S_RESP_PENDING;
 	qp->s_nak_state = qp->r_nak_state;
 	qp->s_ack_psn = qp->r_ack_psn;
 	if (is_fecn)
-		qp->s_flags |= HFI1_S_ECN;
+		qp->s_flags |= RVT_S_ECN;
 
 	/* Schedule the send tasklet. */
 	hfi1_schedule_send(qp);
@@ -866,14 +866,14 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
 done:
 	qp->s_psn = psn;
 	/*
-	 * Set HFI1_S_WAIT_PSN as rc_complete() may start the timer
+	 * Set RVT_S_WAIT_PSN as rc_complete() may start the timer
 	 * asynchronously before the send tasklet can get scheduled.
 	 * Doing it in hfi1_make_rc_req() is too late.
 	 */
 	if ((cmp_psn(qp->s_psn, qp->s_sending_hpsn) <= 0) &&
 	    (cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0))
-		qp->s_flags |= HFI1_S_WAIT_PSN;
-	qp->s_flags &= ~HFI1_S_AHG_VALID;
+		qp->s_flags |= RVT_S_WAIT_PSN;
+	qp->s_flags &= ~RVT_S_AHG_VALID;
 }
 
 /*
@@ -904,11 +904,11 @@ static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 	else
 		ibp->rvp.n_rc_resends += delta_psn(qp->s_psn, psn);
 
-	qp->s_flags &= ~(HFI1_S_WAIT_FENCE | HFI1_S_WAIT_RDMAR |
-			 HFI1_S_WAIT_SSN_CREDIT | HFI1_S_WAIT_PSN |
-			 HFI1_S_WAIT_ACK);
+	qp->s_flags &= ~(RVT_S_WAIT_FENCE | RVT_S_WAIT_RDMAR |
+			 RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_PSN |
+			 RVT_S_WAIT_ACK);
 	if (wait)
-		qp->s_flags |= HFI1_S_SEND_ONE;
+		qp->s_flags |= RVT_S_SEND_ONE;
 	reset_psn(qp, psn);
 }
 
@@ -923,10 +923,10 @@ static void rc_timeout(unsigned long arg)
 
 	spin_lock_irqsave(&qp->r_lock, flags);
 	spin_lock(&qp->s_lock);
-	if (qp->s_flags & HFI1_S_TIMER) {
+	if (qp->s_flags & RVT_S_TIMER) {
 		ibp = to_iport(qp->ibqp.device, qp->port_num);
 		ibp->rvp.n_rc_timeouts++;
-		qp->s_flags &= ~HFI1_S_TIMER;
+		qp->s_flags &= ~RVT_S_TIMER;
 		del_timer(&qp->s_timer);
 		trace_hfi1_rc_timeout(qp, qp->s_last_psn + 1);
 		restart_rc(qp, qp->s_last_psn + 1, 1);
@@ -945,8 +945,8 @@ void hfi1_rc_rnr_retry(unsigned long arg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&qp->s_lock, flags);
-	if (qp->s_flags & HFI1_S_WAIT_RNR) {
-		qp->s_flags &= ~HFI1_S_WAIT_RNR;
+	if (qp->s_flags & RVT_S_WAIT_RNR) {
+		qp->s_flags &= ~RVT_S_WAIT_RNR;
 		del_timer(&qp->s_timer);
 		hfi1_schedule_send(qp);
 	}
@@ -1017,7 +1017,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	 */
 	if ((psn & IB_BTH_REQ_ACK) && qp->s_acked != qp->s_tail &&
 	    !(qp->s_flags &
-		(HFI1_S_TIMER | HFI1_S_WAIT_RNR | HFI1_S_WAIT_PSN)) &&
+		(RVT_S_TIMER | RVT_S_WAIT_RNR | RVT_S_WAIT_PSN)) &&
 		(ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK))
 		start_timer(qp);
 
@@ -1032,7 +1032,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & HFI1_S_SIGNAL_REQ_WR) ||
+		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 			memset(&wc, 0, sizeof(wc));
 			wc.wr_id = wqe->wr.wr_id;
@@ -1050,9 +1050,9 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct hfi1_ib_header *hdr)
 	 * and they are now complete, restart sending.
 	 */
 	trace_hfi1_rc_sendcomplete(qp, psn);
-	if (qp->s_flags & HFI1_S_WAIT_PSN &&
+	if (qp->s_flags & RVT_S_WAIT_PSN &&
 	    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
-		qp->s_flags &= ~HFI1_S_WAIT_PSN;
+		qp->s_flags &= ~RVT_S_WAIT_PSN;
 		qp->s_sending_psn = qp->s_psn;
 		qp->s_sending_hpsn = qp->s_psn - 1;
 		hfi1_schedule_send(qp);
@@ -1089,7 +1089,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			rvt_put_mr(sge->mr);
 		}
 		/* Post a send completion queue entry if requested. */
-		if (!(qp->s_flags & HFI1_S_SIGNAL_REQ_WR) ||
+		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
 			memset(&wc, 0, sizeof(wc));
 			wc.wr_id = wqe->wr.wr_id;
@@ -1169,8 +1169,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	int diff;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (HFI1_S_TIMER | HFI1_S_WAIT_RNR)) {
-		qp->s_flags &= ~(HFI1_S_TIMER | HFI1_S_WAIT_RNR);
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
 
@@ -1218,11 +1218,11 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		      wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) &&
 		     (opcode != OP(ATOMIC_ACKNOWLEDGE) || diff != 0))) {
 			/* Retry this request. */
-			if (!(qp->r_flags & HFI1_R_RDMAR_SEQ)) {
-				qp->r_flags |= HFI1_R_RDMAR_SEQ;
+			if (!(qp->r_flags & RVT_R_RDMAR_SEQ)) {
+				qp->r_flags |= RVT_R_RDMAR_SEQ;
 				restart_rc(qp, qp->s_last_psn + 1, 0);
 				if (list_empty(&qp->rspwait)) {
-					qp->r_flags |= HFI1_R_RSP_SEND;
+					qp->r_flags |= RVT_R_RSP_SEND;
 					atomic_inc(&qp->refcount);
 					list_add_tail(&qp->rspwait,
 						      &rcd->qp_wait_list);
@@ -1245,14 +1245,14 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		     wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD)) {
 			qp->s_num_rd_atomic--;
 			/* Restart sending task if fence is complete */
-			if ((qp->s_flags & HFI1_S_WAIT_FENCE) &&
+			if ((qp->s_flags & RVT_S_WAIT_FENCE) &&
 			    !qp->s_num_rd_atomic) {
-				qp->s_flags &= ~(HFI1_S_WAIT_FENCE |
-						 HFI1_S_WAIT_ACK);
+				qp->s_flags &= ~(RVT_S_WAIT_FENCE |
+						 RVT_S_WAIT_ACK);
 				hfi1_schedule_send(qp);
-			} else if (qp->s_flags & HFI1_S_WAIT_RDMAR) {
-				qp->s_flags &= ~(HFI1_S_WAIT_RDMAR |
-						 HFI1_S_WAIT_ACK);
+			} else if (qp->s_flags & RVT_S_WAIT_RDMAR) {
+				qp->s_flags &= ~(RVT_S_WAIT_RDMAR |
+						 RVT_S_WAIT_ACK);
 				hfi1_schedule_send(qp);
 			}
 		}
@@ -1280,8 +1280,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 			qp->s_state = OP(SEND_LAST);
 			qp->s_psn = psn + 1;
 		}
-		if (qp->s_flags & HFI1_S_WAIT_ACK) {
-			qp->s_flags &= ~HFI1_S_WAIT_ACK;
+		if (qp->s_flags & RVT_S_WAIT_ACK) {
+			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			hfi1_schedule_send(qp);
 		}
 		hfi1_get_credit(qp, aeth);
@@ -1295,7 +1295,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 		ibp->rvp.n_rnr_naks++;
 		if (qp->s_acked == qp->s_tail)
 			goto bail;
-		if (qp->s_flags & HFI1_S_WAIT_RNR)
+		if (qp->s_flags & RVT_S_WAIT_RNR)
 			goto bail;
 		if (qp->s_rnr_retry == 0) {
 			status = IB_WC_RNR_RETRY_EXC_ERR;
@@ -1311,8 +1311,8 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 
 		reset_psn(qp, psn);
 
-		qp->s_flags &= ~(HFI1_S_WAIT_SSN_CREDIT | HFI1_S_WAIT_ACK);
-		qp->s_flags |= HFI1_S_WAIT_RNR;
+		qp->s_flags &= ~(RVT_S_WAIT_SSN_CREDIT | RVT_S_WAIT_ACK);
+		qp->s_flags |= RVT_S_WAIT_RNR;
 		qp->s_timer.function = hfi1_rc_rnr_retry;
 		qp->s_timer.expires = jiffies + usecs_to_jiffies(
 			ib_hfi1_rnr_table[(aeth >> HFI1_AETH_CREDIT_SHIFT) &
@@ -1387,8 +1387,8 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 	struct rvt_swqe *wqe;
 
 	/* Remove QP from retry timer */
-	if (qp->s_flags & (HFI1_S_TIMER | HFI1_S_WAIT_RNR)) {
-		qp->s_flags &= ~(HFI1_S_TIMER | HFI1_S_WAIT_RNR);
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
 		del_timer(&qp->s_timer);
 	}
 
@@ -1403,10 +1403,10 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 	}
 
 	ibp->rvp.n_rdma_seq++;
-	qp->r_flags |= HFI1_R_RDMAR_SEQ;
+	qp->r_flags |= RVT_R_RDMAR_SEQ;
 	restart_rc(qp, qp->s_last_psn + 1, 0);
 	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= HFI1_R_RSP_SEND;
+		qp->r_flags |= RVT_R_RSP_SEND;
 		atomic_inc(&qp->refcount);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
@@ -1466,10 +1466,10 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 	 * Skip everything other than the PSN we expect, if we are waiting
 	 * for a reply to a restarted RDMA read or atomic op.
 	 */
-	if (qp->r_flags & HFI1_R_RDMAR_SEQ) {
+	if (qp->r_flags & RVT_R_RDMAR_SEQ) {
 		if (cmp_psn(psn, qp->s_last_psn + 1) != 0)
 			goto ack_done;
-		qp->r_flags &= ~HFI1_R_RDMAR_SEQ;
+		qp->r_flags &= ~RVT_R_RDMAR_SEQ;
 	}
 
 	if (unlikely(qp->s_acked == qp->s_tail))
@@ -1520,10 +1520,10 @@ read_middle:
 		 * We got a response so update the timeout.
 		 * 4.096 usec. * (1 << qp->timeout)
 		 */
-		qp->s_flags |= HFI1_S_TIMER;
+		qp->s_flags |= RVT_S_TIMER;
 		mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
-		if (qp->s_flags & HFI1_S_WAIT_ACK) {
-			qp->s_flags &= ~HFI1_S_WAIT_ACK;
+		if (qp->s_flags & RVT_S_WAIT_ACK) {
+			qp->s_flags &= ~RVT_S_WAIT_ACK;
 			hfi1_schedule_send(qp);
 		}
 
@@ -1613,7 +1613,7 @@ static inline void rc_defered_ack(struct hfi1_ctxtdata *rcd,
 				  struct rvt_qp *qp)
 {
 	if (list_empty(&qp->rspwait)) {
-		qp->r_flags |= HFI1_R_RSP_DEFERED_ACK;
+		qp->r_flags |= RVT_R_RSP_NAK;
 		atomic_inc(&qp->refcount);
 		list_add_tail(&qp->rspwait, &rcd->qp_wait_list);
 	}
@@ -1627,7 +1627,7 @@ static inline void rc_cancel_ack(struct rvt_qp *qp)
 	if (list_empty(&qp->rspwait))
 		return;
 	list_del_init(&qp->rspwait);
-	qp->r_flags &= ~HFI1_R_RSP_DEFERED_ACK;
+	qp->r_flags &= ~RVT_R_RSP_NAK;
 	if (atomic_dec_and_test(&qp->refcount))
 		wake_up(&qp->wait);
 }
@@ -1813,7 +1813,7 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 		break;
 	}
 	qp->s_ack_state = OP(ACKNOWLEDGE);
-	qp->s_flags |= HFI1_S_RESP_PENDING;
+	qp->s_flags |= RVT_S_RESP_PENDING;
 	qp->r_nak_state = 0;
 	hfi1_schedule_send(qp);
 
@@ -2057,7 +2057,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 		break;
 	}
 
-	if (qp->state == IB_QPS_RTR && !(qp->r_flags & HFI1_R_COMM_EST))
+	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST))
 		qp_comm_est(qp);
 
 	/* OK, process the packet. */
@@ -2127,7 +2127,7 @@ send_last:
 		hfi1_copy_sge(&qp->r_sge, data, tlen, 1);
 		hfi1_put_ss(&qp->r_sge);
 		qp->r_msn++;
-		if (!test_and_clear_bit(HFI1_R_WRID_VALID, &qp->r_aflags))
+		if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 			break;
 		wc.wr_id = qp->r_wr_id;
 		wc.status = IB_WC_SUCCESS;
@@ -2264,7 +2264,7 @@ send_last:
 		qp->r_head_ack_queue = next;
 
 		/* Schedule the send tasklet. */
-		qp->s_flags |= HFI1_S_RESP_PENDING;
+		qp->s_flags |= RVT_S_RESP_PENDING;
 		hfi1_schedule_send(qp);
 
 		spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -2331,7 +2331,7 @@ send_last:
 		qp->r_head_ack_queue = next;
 
 		/* Schedule the send tasklet. */
-		qp->s_flags |= HFI1_S_RESP_PENDING;
+		qp->s_flags |= RVT_S_RESP_PENDING;
 		hfi1_schedule_send(qp);
 
 		spin_unlock_irqrestore(&qp->s_lock, flags);
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 98a4798..0b324b1 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -208,7 +208,7 @@ int hfi1_get_rwqe(struct rvt_qp *qp, int wr_id_only)
 	qp->r_wr_id = wqe->wr_id;
 
 	ret = 1;
-	set_bit(HFI1_R_WRID_VALID, &qp->r_aflags);
+	set_bit(RVT_R_WRID_VALID, &qp->r_aflags);
 	if (handler) {
 		u32 n;
 
@@ -382,11 +382,11 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	spin_lock_irqsave(&sqp->s_lock, flags);
 
 	/* Return if we are already busy processing a work request. */
-	if ((sqp->s_flags & (HFI1_S_BUSY | HFI1_S_ANY_WAIT)) ||
+	if ((sqp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT)) ||
 	    !(ib_hfi1_state_ops[sqp->state] & HFI1_PROCESS_OR_FLUSH_SEND))
 		goto unlock;
 
-	sqp->s_flags |= HFI1_S_BUSY;
+	sqp->s_flags |= RVT_S_BUSY;
 
 again:
 	if (sqp->s_last == sqp->s_head)
@@ -550,7 +550,7 @@ again:
 	if (release)
 		hfi1_put_ss(&qp->r_sge);
 
-	if (!test_and_clear_bit(HFI1_R_WRID_VALID, &qp->r_aflags))
+	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		goto send_comp;
 
 	if (wqe->wr.opcode == IB_WR_RDMA_WRITE_WITH_IMM)
@@ -595,7 +595,7 @@ rnr_nak:
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	if (!(ib_hfi1_state_ops[sqp->state] & HFI1_PROCESS_RECV_OK))
 		goto clr_busy;
-	sqp->s_flags |= HFI1_S_WAIT_RNR;
+	sqp->s_flags |= RVT_S_WAIT_RNR;
 	sqp->s_timer.function = hfi1_rc_rnr_retry;
 	sqp->s_timer.expires = jiffies +
 		usecs_to_jiffies(ib_hfi1_rnr_table[qp->r_min_rnr_timer]);
@@ -625,7 +625,7 @@ serr:
 	if (sqp->ibqp.qp_type == IB_QPT_RC) {
 		int lastwqe = hfi1_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
 
-		sqp->s_flags &= ~HFI1_S_BUSY;
+		sqp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock_irqrestore(&sqp->s_lock, flags);
 		if (lastwqe) {
 			struct ib_event ev;
@@ -638,7 +638,7 @@ serr:
 		goto done;
 	}
 clr_busy:
-	sqp->s_flags &= ~HFI1_S_BUSY;
+	sqp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&sqp->s_lock, flags);
 done:
@@ -694,9 +694,9 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
-	if (unlikely(qp->s_flags & HFI1_S_AHG_CLEAR))
+	if (unlikely(qp->s_flags & RVT_S_AHG_CLEAR))
 		clear_ahg(qp);
-	if (!(qp->s_flags & HFI1_S_AHG_VALID)) {
+	if (!(qp->s_flags & RVT_S_AHG_VALID)) {
 		/* first middle that needs copy  */
 		if (qp->s_ahgidx < 0)
 			qp->s_ahgidx = sdma_ahg_alloc(priv->s_sde);
@@ -706,7 +706,7 @@ static inline void build_ahg(struct rvt_qp *qp, u32 npsn)
 			/* save to protect a change in another thread */
 			priv->s_hdr->sde = priv->s_sde;
 			priv->s_hdr->ahgidx = qp->s_ahgidx;
-			qp->s_flags |= HFI1_S_AHG_VALID;
+			qp->s_flags |= RVT_S_AHG_VALID;
 		}
 	} else {
 		/* subsequent middle after valid */
@@ -779,7 +779,7 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 	if (middle)
 		build_ahg(qp, bth2);
 	else
-		qp->s_flags &= ~HFI1_S_AHG_VALID;
+		qp->s_flags &= ~RVT_S_AHG_VALID;
 	priv->s_hdr->ibh.lrh[0] = cpu_to_be16(lrh0);
 	priv->s_hdr->ibh.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
 	priv->s_hdr->ibh.lrh[2] =
@@ -790,8 +790,8 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct hfi1_other_headers *ohdr,
 	bth0 |= extra_bytes << 20;
 	ohdr->bth[0] = cpu_to_be32(bth0);
 	bth1 = qp->remote_qpn;
-	if (qp->s_flags & HFI1_S_ECN) {
-		qp->s_flags &= ~HFI1_S_ECN;
+	if (qp->s_flags & RVT_S_ECN) {
+		qp->s_flags &= ~RVT_S_ECN;
 		/* we recently received a FECN, so return a BECN */
 		bth1 |= (HFI1_BECN_MASK << HFI1_BECN_SHIFT);
 	}
@@ -847,7 +847,7 @@ void hfi1_do_send(struct work_struct *work)
 		return;
 	}
 
-	qp->s_flags |= HFI1_S_BUSY;
+	qp->s_flags |= RVT_S_BUSY;
 
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 
@@ -897,7 +897,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
 	/* See ch. 11.2.4.1 and 10.7.3.1 */
-	if (!(qp->s_flags & HFI1_S_SIGNAL_REQ_WR) ||
+	if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 	    (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
 	    status != IB_WC_SUCCESS) {
 		struct ib_wc wc;
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index cac3724..0935182 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -84,7 +84,7 @@ int hfi1_make_uc_req(struct rvt_qp *qp)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_iowait.sdma_busy)) {
-			qp->s_flags |= HFI1_S_WAIT_DMA;
+			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
 		clear_ahg(qp);
@@ -241,7 +241,7 @@ done:
 	goto unlock;
 
 bail:
-	qp->s_flags &= ~HFI1_S_BUSY;
+	qp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
@@ -332,7 +332,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 inv:
 		if (qp->r_state == OP(SEND_FIRST) ||
 		    qp->r_state == OP(SEND_MIDDLE)) {
-			set_bit(HFI1_R_REWIND_SGE, &qp->r_aflags);
+			set_bit(RVT_R_REWIND_SGE, &qp->r_aflags);
 			qp->r_sge.num_sge = 0;
 		} else
 			hfi1_put_ss(&qp->r_sge);
@@ -382,7 +382,7 @@ inv:
 		goto inv;
 	}
 
-	if (qp->state == IB_QPS_RTR && !(qp->r_flags & HFI1_R_COMM_EST))
+	if (qp->state == IB_QPS_RTR && !(qp->r_flags & RVT_R_COMM_EST))
 		qp_comm_est(qp);
 
 	/* OK, process the packet. */
@@ -391,7 +391,7 @@ inv:
 	case OP(SEND_ONLY):
 	case OP(SEND_ONLY_WITH_IMMEDIATE):
 send_first:
-		if (test_and_clear_bit(HFI1_R_REWIND_SGE, &qp->r_aflags))
+		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 			qp->r_sge = qp->s_rdma_read_sge;
 		else {
 			ret = hfi1_get_rwqe(qp, 0);
@@ -536,7 +536,7 @@ rdma_last_imm:
 		tlen -= (hdrsize + pad + 4);
 		if (unlikely(tlen + qp->r_rcv_len != qp->r_len))
 			goto drop;
-		if (test_and_clear_bit(HFI1_R_REWIND_SGE, &qp->r_aflags))
+		if (test_and_clear_bit(RVT_R_REWIND_SGE, &qp->r_aflags))
 			hfi1_put_ss(&qp->s_rdma_read_sge);
 		else {
 			ret = hfi1_get_rwqe(qp, 1);
@@ -576,7 +576,7 @@ rdma_last:
 	return;
 
 rewind:
-	set_bit(HFI1_R_REWIND_SGE, &qp->r_aflags);
+	set_bit(RVT_R_REWIND_SGE, &qp->r_aflags);
 	qp->r_sge.num_sge = 0;
 drop:
 	ibp->rvp.n_pkt_drops++;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index e058fd2..a0e6222 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -161,8 +161,8 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
-	if (qp->r_flags & HFI1_R_REUSE_SGE)
-		qp->r_flags &= ~HFI1_R_REUSE_SGE;
+	if (qp->r_flags & RVT_R_REUSE_SGE)
+		qp->r_flags &= ~RVT_R_REUSE_SGE;
 	else {
 		int ret;
 
@@ -179,7 +179,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	}
 	/* Silently drop packets which are too big. */
 	if (unlikely(wc.byte_len > qp->r_len)) {
-		qp->r_flags |= HFI1_R_REUSE_SGE;
+		qp->r_flags |= RVT_R_REUSE_SGE;
 		ibp->rvp.n_pkt_drops++;
 		goto bail_unlock;
 	}
@@ -223,7 +223,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		length -= len;
 	}
 	hfi1_put_ss(&qp->r_sge);
-	if (!test_and_clear_bit(HFI1_R_WRID_VALID, &qp->r_aflags))
+	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		goto bail_unlock;
 	wc.wr_id = qp->r_wr_id;
 	wc.status = IB_WC_SUCCESS;
@@ -290,7 +290,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 			goto bail;
 		/* If DMAs are in progress, we can't flush immediately. */
 		if (atomic_read(&priv->s_iowait.sdma_busy)) {
-			qp->s_flags |= HFI1_S_WAIT_DMA;
+			qp->s_flags |= RVT_S_WAIT_DMA;
 			goto bail;
 		}
 		wqe = get_swqe_ptr(qp, qp->s_last);
@@ -324,7 +324,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp)
 			 * zero length descriptor so we get a callback.
 			 */
 			if (atomic_read(&priv->s_iowait.sdma_busy)) {
-				qp->s_flags |= HFI1_S_WAIT_DMA;
+				qp->s_flags |= RVT_S_WAIT_DMA;
 				goto bail;
 			}
 			qp->s_cur = next_cur;
@@ -426,7 +426,7 @@ done:
 	goto unlock;
 
 bail:
-	qp->s_flags &= ~HFI1_S_BUSY;
+	qp->s_flags &= ~RVT_S_BUSY;
 unlock:
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return ret;
@@ -812,8 +812,8 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	/*
 	 * Get the next work request entry to find where to put the data.
 	 */
-	if (qp->r_flags & HFI1_R_REUSE_SGE)
-		qp->r_flags &= ~HFI1_R_REUSE_SGE;
+	if (qp->r_flags & RVT_R_REUSE_SGE)
+		qp->r_flags &= ~RVT_R_REUSE_SGE;
 	else {
 		int ret;
 
@@ -830,7 +830,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	}
 	/* Silently drop packets which are too big. */
 	if (unlikely(wc.byte_len > qp->r_len)) {
-		qp->r_flags |= HFI1_R_REUSE_SGE;
+		qp->r_flags |= RVT_R_REUSE_SGE;
 		goto drop;
 	}
 	if (has_grh) {
@@ -841,7 +841,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
 	hfi1_copy_sge(&qp->r_sge, data, wc.byte_len - sizeof(struct ib_grh), 1);
 	hfi1_put_ss(&qp->r_sge);
-	if (!test_and_clear_bit(HFI1_R_WRID_VALID, &qp->r_aflags))
+	if (!test_and_clear_bit(RVT_R_WRID_VALID, &qp->r_aflags))
 		return;
 	wc.wr_id = qp->r_wr_id;
 	wc.status = IB_WC_SUCCESS;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 301716a..a1e9f0b 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -702,7 +702,7 @@ static void mem_timer(unsigned long data)
 	write_sequnlock_irqrestore(&dev->iowait_lock, flags);
 
 	if (qp)
-		hfi1_qp_wakeup(qp, HFI1_S_WAIT_KMEM);
+		hfi1_qp_wakeup(qp, RVT_S_WAIT_KMEM);
 }
 
 void update_sge(struct rvt_sge_state *ss, u32 length)
@@ -740,12 +740,12 @@ static noinline struct verbs_txreq *__get_txreq(struct hfi1_ibdev *dev,
 		if (ib_hfi1_state_ops[qp->state] & HFI1_PROCESS_RECV_OK &&
 		    list_empty(&priv->s_iowait.list)) {
 			dev->n_txwait++;
-			qp->s_flags |= HFI1_S_WAIT_TX;
+			qp->s_flags |= RVT_S_WAIT_TX;
 			list_add_tail(&priv->s_iowait.list, &dev->txwait);
-			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_TX);
+			trace_hfi1_qpsleep(qp, RVT_S_WAIT_TX);
 			atomic_inc(&qp->refcount);
 		}
-		qp->s_flags &= ~HFI1_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		write_sequnlock(&dev->iowait_lock);
 		spin_unlock_irqrestore(&qp->s_lock, flags);
 		tx = ERR_PTR(-EBUSY);
@@ -803,7 +803,7 @@ void hfi1_put_txreq(struct verbs_txreq *tx)
 			list_del_init(&priv->s_iowait.list);
 			/* refcount held until actual wake up */
 			write_sequnlock_irqrestore(&dev->iowait_lock, flags);
-			hfi1_qp_wakeup(qp, HFI1_S_WAIT_TX);
+			hfi1_qp_wakeup(qp, RVT_S_WAIT_TX);
 			break;
 		}
 	} while (read_seqretry(&dev->iowait_lock, seq));
@@ -838,8 +838,8 @@ static void verbs_sdma_complete(
 		 * do the flush work until that QP's
 		 * sdma work has finished.
 		 */
-		if (qp->s_flags & HFI1_S_WAIT_DMA) {
-			qp->s_flags &= ~HFI1_S_WAIT_DMA;
+		if (qp->s_flags & RVT_S_WAIT_DMA) {
+			qp->s_flags &= ~RVT_S_WAIT_DMA;
 			hfi1_schedule_send(qp);
 		}
 	}
@@ -860,13 +860,13 @@ static int wait_kmem(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 		if (list_empty(&priv->s_iowait.list)) {
 			if (list_empty(&dev->memwait))
 				mod_timer(&dev->mem_timer, jiffies + 1);
-			qp->s_flags |= HFI1_S_WAIT_KMEM;
+			qp->s_flags |= RVT_S_WAIT_KMEM;
 			list_add_tail(&priv->s_iowait.list, &dev->memwait);
-			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_KMEM);
+			trace_hfi1_qpsleep(qp, RVT_S_WAIT_KMEM);
 			atomic_inc(&qp->refcount);
 		}
 		write_sequnlock(&dev->iowait_lock);
-		qp->s_flags &= ~HFI1_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		ret = -EBUSY;
 	}
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1092,17 +1092,17 @@ static int no_bufs_available(struct rvt_qp *qp, struct send_context *sc)
 			int was_empty;
 
 			dev->n_piowait++;
-			qp->s_flags |= HFI1_S_WAIT_PIO;
+			qp->s_flags |= RVT_S_WAIT_PIO;
 			was_empty = list_empty(&sc->piowait);
 			list_add_tail(&priv->s_iowait.list, &sc->piowait);
-			trace_hfi1_qpsleep(qp, HFI1_S_WAIT_PIO);
+			trace_hfi1_qpsleep(qp, RVT_S_WAIT_PIO);
 			atomic_inc(&qp->refcount);
 			/* counting: only call wantpiobuf_intr if first user */
 			if (was_empty)
 				hfi1_sc_wantpiobuf_intr(sc, 1);
 		}
 		write_sequnlock(&dev->iowait_lock);
-		qp->s_flags &= ~HFI1_S_BUSY;
+		qp->s_flags &= ~RVT_S_BUSY;
 		ret = -EBUSY;
 	}
 	spin_unlock_irqrestore(&qp->s_lock, flags);
@@ -1307,7 +1307,7 @@ bad:
  * @ps: the state of the packet to send
  *
  * Return zero if packet is sent or queued OK.
- * Return non-zero and clear qp->s_flags HFI1_S_BUSY otherwise.
+ * Return non-zero and clear qp->s_flags RVT_S_BUSY otherwise.
  */
 int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index eb12978..b9843a5 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -63,6 +63,7 @@
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_mad.h>
 #include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_qp.h>
 
 struct hfi1_ctxtdata;
 struct hfi1_pportdata;
@@ -286,84 +287,6 @@ struct hfi1_pkt_state {
 	struct hfi1_pportdata *ppd;
 };
 
-/*
- * Atomic bit definitions for r_aflags.
- */
-#define HFI1_R_WRID_VALID        0
-#define HFI1_R_REWIND_SGE        1
-
-/*
- * Bit definitions for r_flags.
- */
-#define HFI1_R_REUSE_SGE       0x01
-#define HFI1_R_RDMAR_SEQ       0x02
-/* defer ack until end of interrupt session */
-#define HFI1_R_RSP_DEFERED_ACK 0x04
-/* relay ack to send engine */
-#define HFI1_R_RSP_SEND        0x08
-#define HFI1_R_COMM_EST        0x10
-
-/*
- * Bit definitions for s_flags.
- *
- * HFI1_S_SIGNAL_REQ_WR - set if QP send WRs contain completion signaled
- * HFI1_S_BUSY - send tasklet is processing the QP
- * HFI1_S_TIMER - the RC retry timer is active
- * HFI1_S_ACK_PENDING - an ACK is waiting to be sent after RDMA read/atomics
- * HFI1_S_WAIT_FENCE - waiting for all prior RDMA read or atomic SWQEs
- *                         before processing the next SWQE
- * HFI1_S_WAIT_RDMAR - waiting for a RDMA read or atomic SWQE to complete
- *                         before processing the next SWQE
- * HFI1_S_WAIT_RNR - waiting for RNR timeout
- * HFI1_S_WAIT_SSN_CREDIT - waiting for RC credits to process next SWQE
- * HFI1_S_WAIT_DMA - waiting for send DMA queue to drain before generating
- *                  next send completion entry not via send DMA
- * HFI1_S_WAIT_PIO - waiting for a send buffer to be available
- * HFI1_S_WAIT_TX - waiting for a struct verbs_txreq to be available
- * HFI1_S_WAIT_DMA_DESC - waiting for DMA descriptors to be available
- * HFI1_S_WAIT_KMEM - waiting for kernel memory to be available
- * HFI1_S_WAIT_PSN - waiting for a packet to exit the send DMA queue
- * HFI1_S_WAIT_ACK - waiting for an ACK packet before sending more requests
- * HFI1_S_SEND_ONE - send one packet, request ACK, then wait for ACK
- * HFI1_S_ECN - a BECN was queued to the send engine
- */
-#define HFI1_S_SIGNAL_REQ_WR	0x0001
-#define HFI1_S_BUSY		0x0002
-#define HFI1_S_TIMER		0x0004
-#define HFI1_S_RESP_PENDING	0x0008
-#define HFI1_S_ACK_PENDING	0x0010
-#define HFI1_S_WAIT_FENCE	0x0020
-#define HFI1_S_WAIT_RDMAR	0x0040
-#define HFI1_S_WAIT_RNR		0x0080
-#define HFI1_S_WAIT_SSN_CREDIT	0x0100
-#define HFI1_S_WAIT_DMA		0x0200
-#define HFI1_S_WAIT_PIO		0x0400
-#define HFI1_S_WAIT_TX		0x0800
-#define HFI1_S_WAIT_DMA_DESC	0x1000
-#define HFI1_S_WAIT_KMEM		0x2000
-#define HFI1_S_WAIT_PSN		0x4000
-#define HFI1_S_WAIT_ACK		0x8000
-#define HFI1_S_SEND_ONE		0x10000
-#define HFI1_S_UNLIMITED_CREDIT	0x20000
-#define HFI1_S_AHG_VALID		0x40000
-#define HFI1_S_AHG_CLEAR		0x80000
-#define HFI1_S_ECN		0x100000
-
-/*
- * Wait flags that would prevent any packet type from being sent.
- */
-#define HFI1_S_ANY_WAIT_IO (HFI1_S_WAIT_PIO | HFI1_S_WAIT_TX | \
-	HFI1_S_WAIT_DMA_DESC | HFI1_S_WAIT_KMEM)
-
-/*
- * Wait flags that would prevent send work requests from making progress.
- */
-#define HFI1_S_ANY_WAIT_SEND (HFI1_S_WAIT_FENCE | HFI1_S_WAIT_RDMAR | \
-	HFI1_S_WAIT_RNR | HFI1_S_WAIT_SSN_CREDIT | HFI1_S_WAIT_DMA | \
-	HFI1_S_WAIT_PSN | HFI1_S_WAIT_ACK)
-
-#define HFI1_S_ANY_WAIT (HFI1_S_ANY_WAIT_IO | HFI1_S_ANY_WAIT_SEND)
-
 #define HFI1_PSN_CREDIT  16
 
 /*
@@ -507,9 +430,9 @@ static inline struct rvt_qp *iowait_to_qp(struct  iowait *s_iowait)
  */
 static inline int hfi1_send_ok(struct rvt_qp *qp)
 {
-	return !(qp->s_flags & (HFI1_S_BUSY | HFI1_S_ANY_WAIT_IO)) &&
-		(qp->s_hdrwords || (qp->s_flags & HFI1_S_RESP_PENDING) ||
-		 !(qp->s_flags & HFI1_S_ANY_WAIT_SEND));
+	return !(qp->s_flags & (RVT_S_BUSY | RVT_S_ANY_WAIT_IO)) &&
+		(qp->s_hdrwords || (qp->s_flags & RVT_S_RESP_PENDING) ||
+		 !(qp->s_flags & RVT_S_ANY_WAIT_SEND));
 }
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
