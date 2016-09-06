From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 13/13] IB/rdmavt,
 IB/hfi1: Add lockdep asserts for lock debug
Date: Tue, 06 Sep 2016 04:37:41 -0700
Message-ID: <20160906113731.27413.66555.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds lockdep asserts in key code paths for
insuring lock correctness.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qp.c   |    8 ++++++--
 drivers/infiniband/hw/hfi1/rc.c   |   17 +++++++++++++++++
 drivers/infiniband/sw/rdmavt/qp.c |    8 ++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index 53ad10c..04eb0c8 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -449,13 +449,14 @@ static void qp_pio_drain(struct rvt_qp *qp)
  */
 void hfi1_schedule_send(struct rvt_qp *qp)
 {
+	lockdep_assert_held(&qp->s_lock);
 	if (hfi1_send_ok(qp))
 		_hfi1_schedule_send(qp);
 }
 
 /**
- * hfi1_get_credit - flush the send work queue of a QP
- * @qp: the qp who's send work queue to flush
+ * hfi1_get_credit - handle credit in aeth
+ * @qp: the qp
  * @aeth: the Acknowledge Extended Transport Header
  *
  * The QP s_lock should be held.
@@ -464,6 +465,7 @@ void hfi1_get_credit(struct rvt_qp *qp, u32 aeth)
 {
 	u32 credit = (aeth >> HFI1_AETH_CREDIT_SHIFT) & HFI1_AETH_CREDIT_MASK;
 
+	lockdep_assert_held(&qp->s_lock);
 	/*
 	 * If the credit is invalid, we can send
 	 * as many packets as we like.  Otherwise, we have to
@@ -822,6 +824,7 @@ void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
+	lockdep_assert_held(&qp->s_lock);
 	kfree(priv->s_ahg);
 	kfree(priv);
 }
@@ -853,6 +856,7 @@ unsigned free_all_qps(struct rvt_dev_info *rdi)
 
 void flush_qp_waiters(struct rvt_qp *qp)
 {
+	lockdep_assert_held(&qp->s_lock);
 	flush_iowait(qp);
 	hfi1_stop_rc_timers(qp);
 }
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 9f7900f..db63967 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -68,6 +68,7 @@ static inline void hfi1_add_retry_timer(struct rvt_qp *qp)
 	struct ib_qp *ibqp = &qp->ibqp;
 	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
 
+	lockdep_assert_held(&qp->s_lock);
 	qp->s_flags |= RVT_S_TIMER;
 	/* 4.096 usec. * (1 << qp->timeout) */
 	qp->s_timer.expires = jiffies + qp->timeout_jiffies +
@@ -86,6 +87,7 @@ void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
+	lockdep_assert_held(&qp->s_lock);
 	qp->s_flags |= RVT_S_WAIT_RNR;
 	qp->s_timer.expires = jiffies + usecs_to_jiffies(to);
 	add_timer(&priv->s_rnr_timer);
@@ -103,6 +105,7 @@ static inline void hfi1_mod_retry_timer(struct rvt_qp *qp)
 	struct ib_qp *ibqp = &qp->ibqp;
 	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
 
+	lockdep_assert_held(&qp->s_lock);
 	qp->s_flags |= RVT_S_TIMER;
 	/* 4.096 usec. * (1 << qp->timeout) */
 	mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies +
@@ -120,6 +123,7 @@ static inline int hfi1_stop_retry_timer(struct rvt_qp *qp)
 {
 	int rval = 0;
 
+	lockdep_assert_held(&qp->s_lock);
 	/* Remove QP from retry */
 	if (qp->s_flags & RVT_S_TIMER) {
 		qp->s_flags &= ~RVT_S_TIMER;
@@ -138,6 +142,7 @@ void hfi1_stop_rc_timers(struct rvt_qp *qp)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 
+	lockdep_assert_held(&qp->s_lock);
 	/* Remove QP from all timers */
 	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
 		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
@@ -158,6 +163,7 @@ static inline int hfi1_stop_rnr_timer(struct rvt_qp *qp)
 	int rval = 0;
 	struct hfi1_qp_priv *priv = qp->priv;
 
+	lockdep_assert_held(&qp->s_lock);
 	/* Remove QP from rnr timer */
 	if (qp->s_flags & RVT_S_WAIT_RNR) {
 		qp->s_flags &= ~RVT_S_WAIT_RNR;
@@ -228,6 +234,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 	u32 pmtu = qp->pmtu;
 	struct hfi1_qp_priv *priv = qp->priv;
 
+	lockdep_assert_held(&qp->s_lock);
 	/* Don't send an ACK if we aren't supposed to. */
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
 		goto bail;
@@ -400,6 +407,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	int middle = 0;
 	int delta;
 
+	lockdep_assert_held(&qp->s_lock);
 	ps->s_txreq = get_txreq(ps->dev, qp);
 	if (IS_ERR(ps->s_txreq))
 		goto bail_no_tx;
@@ -958,6 +966,7 @@ static void reset_psn(struct rvt_qp *qp, u32 psn)
 	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, n);
 	u32 opcode;
 
+	lockdep_assert_held(&qp->s_lock);
 	qp->s_cur = n;
 
 	/*
@@ -1043,6 +1052,8 @@ static void restart_rc(struct rvt_qp *qp, u32 psn, int wait)
 	struct rvt_swqe *wqe = rvt_get_swqe_ptr(qp, qp->s_acked);
 	struct hfi1_ibport *ibp;
 
+	lockdep_assert_held(&qp->r_lock);
+	lockdep_assert_held(&qp->s_lock);
 	if (qp->s_retry == 0) {
 		if (qp->s_mig_state == IB_MIG_ARMED) {
 			hfi1_migrate_qp(qp);
@@ -1119,6 +1130,7 @@ static void reset_sending_psn(struct rvt_qp *qp, u32 psn)
 	struct rvt_swqe *wqe;
 	u32 n = qp->s_last;
 
+	lockdep_assert_held(&qp->s_lock);
 	/* Find the work request corresponding to the given PSN. */
 	for (;;) {
 		wqe = rvt_get_swqe_ptr(qp, n);
@@ -1148,6 +1160,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 	u32 opcode;
 	u32 psn;
 
+	lockdep_assert_held(&qp->s_lock);
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
 
@@ -1239,6 +1252,7 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 	struct ib_wc wc;
 	unsigned i;
 
+	lockdep_assert_held(&qp->s_lock);
 	/*
 	 * Don't decrement refcount and don't generate a
 	 * completion if the SWQE is being resent until the send
@@ -1338,6 +1352,7 @@ static int do_rc_ack(struct rvt_qp *qp, u32 aeth, u32 psn, int opcode,
 	int diff;
 	unsigned long to;
 
+	lockdep_assert_held(&qp->s_lock);
 	/*
 	 * Note that NAKs implicitly ACK outstanding SEND and RDMA write
 	 * requests and implicitly NAK RDMA read and atomic requests issued
@@ -1553,6 +1568,7 @@ static void rdma_seq_err(struct rvt_qp *qp, struct hfi1_ibport *ibp, u32 psn,
 {
 	struct rvt_swqe *wqe;
 
+	lockdep_assert_held(&qp->s_lock);
 	/* Remove QP from retry timer */
 	hfi1_stop_rc_timers(qp);
 
@@ -2136,6 +2152,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 	int copy_last = 0;
 	u32 rkey;
 
+	lockdep_assert_held(&qp->r_lock);
 	bth0 = be32_to_cpu(ohdr->bth[0]);
 	if (hfi1_ruc_check_hdr(ibp, hdr, rcv_flags & HFI1_HAS_GRH, qp, bth0))
 		return;
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 673e2f6..7fe0d7e 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -562,6 +562,9 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 	__must_hold(&qp->s_hlock)
 	__must_hold(&qp->r_lock)
 {
+	lockdep_assert_held(&qp->r_lock);
+	lockdep_assert_held(&qp->s_hlock);
+	lockdep_assert_held(&qp->s_lock);
 	if (qp->state != IB_QPS_RESET) {
 		qp->state = IB_QPS_RESET;
 
@@ -595,6 +598,9 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		rdi->driver_f.notify_qp_reset(qp);
 	}
 	rvt_init_qp(rdi, qp, type);
+	lockdep_assert_held(&qp->r_lock);
+	lockdep_assert_held(&qp->s_hlock);
+	lockdep_assert_held(&qp->s_lock);
 }
 
 /**
@@ -917,6 +923,8 @@ int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err)
 	int ret = 0;
 	struct rvt_dev_info *rdi = ib_to_rvt(qp->ibqp.device);
 
+	lockdep_assert_held(&qp->r_lock);
+	lockdep_assert_held(&qp->s_lock);
 	if (qp->state == IB_QPS_ERR || qp->state == IB_QPS_RESET)
 		goto bail;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
