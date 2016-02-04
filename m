From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] IB/qib: Insure last cursor is updated prior to complete
Date: Thu, 04 Feb 2016 11:03:28 -0800
Message-ID: <20160204190324.8378.67843.stgit@scvm10.sc.intel.com>
References: <20160204190024.8378.5080.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204190024.8378.5080.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch is a prerequisite for adding a separate lock
for post send.

The timing of updating s_last needs to be before returning
any send completion to avoid a race between a poll cq seeing
a completion and the post send checking for a full queue.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_rc.c  |   20 ++++++++++++++++----
 drivers/infiniband/hw/qib/qib_ruc.c |   12 +++++++-----
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 044525d..ce886b2 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1008,10 +1008,18 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 		start_timer(qp);
 
 	while (qp->s_last != qp->s_acked) {
+		u32 s_last;
+
 		wqe = rvt_get_swqe_ptr(qp, qp->s_last);
 		if (qib_cmp24(wqe->lpsn, qp->s_sending_psn) >= 0 &&
 		    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
+		s_last = qp->s_last;
+		if (++s_last >= qp->s_size)
+			s_last = 0;
+		qp->s_last = s_last;
+		/* see post_send() */
+		barrier();
 		for (i = 0; i < wqe->wr.num_sge; i++) {
 			struct rvt_sge *sge = &wqe->sg_list[i];
 
@@ -1028,8 +1036,6 @@ void qib_rc_send_complete(struct rvt_qp *qp, struct qib_ib_header *hdr)
 			wc.qp = &qp->ibqp;
 			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
 		}
-		if (++qp->s_last >= qp->s_size)
-			qp->s_last = 0;
 	}
 	/*
 	 * If we were waiting for sends to complete before resending,
@@ -1068,11 +1074,19 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 	 */
 	if (qib_cmp24(wqe->lpsn, qp->s_sending_psn) < 0 ||
 	    qib_cmp24(qp->s_sending_psn, qp->s_sending_hpsn) > 0) {
+		u32 s_last;
+
 		for (i = 0; i < wqe->wr.num_sge; i++) {
 			struct rvt_sge *sge = &wqe->sg_list[i];
 
 			rvt_put_mr(sge->mr);
 		}
+		s_last = qp->s_last;
+		if (++s_last >= qp->s_size)
+			s_last = 0;
+		qp->s_last = s_last;
+		/* see post_send() */
+		barrier();
 		/* Post a send completion queue entry if requested. */
 		if (!(qp->s_flags & RVT_S_SIGNAL_REQ_WR) ||
 		    (wqe->wr.send_flags & IB_SEND_SIGNALED)) {
@@ -1084,8 +1098,6 @@ static struct rvt_swqe *do_rc_completion(struct rvt_qp *qp,
 			wc.qp = &qp->ibqp;
 			rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.send_cq), &wc, 0);
 		}
-		if (++qp->s_last >= qp->s_size)
-			qp->s_last = 0;
 	} else
 		this_cpu_inc(*ibp->rvp.rc_delayed_comp);
 
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 56668cb..2623684 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -795,6 +795,13 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_OR_FLUSH_SEND))
 		return;
 
+	last = qp->s_last;
+	old_last = last;
+	if (++last >= qp->s_size)
+		last = 0;
+	qp->s_last = last;
+	/* See post_send() */
+	barrier();
 	for (i = 0; i < wqe->wr.num_sge; i++) {
 		struct rvt_sge *sge = &wqe->sg_list[i];
 
@@ -822,11 +829,6 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 			     status != IB_WC_SUCCESS);
 	}
 
-	last = qp->s_last;
-	old_last = last;
-	if (++last >= qp->s_size)
-		last = 0;
-	qp->s_last = last;
 	if (qp->s_acked == old_last)
 		qp->s_acked = last;
 	if (qp->s_cur == old_last)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
