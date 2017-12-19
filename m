From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 11/11] IB/rdmavt: Add trace for RNRNAK timer
Date: Mon, 18 Dec 2017 19:57:28 -0800
Message-ID: <20171219035726.2126.88467.stgit@scvm10.sc.intel.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219034753.2126.78386.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds static trace for RNRNAK timer. Currently the output from
hrtimer static trace only shows the addresses of hrtimers in the system
and there is no easy way to correlate an RNRNAK timer with its entries in
the hrtimer trace. This patch adds the correlation among a QP, its RNRNAK
timer, and its entries in the hrtimer trace. This correlation will be
enormously helpful when debugging RNRNAK related issues. In addition, this
patch cleans up rvt_stop_rnr_timer() to be void while here.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c       |   11 ++++----
 drivers/infiniband/sw/rdmavt/trace_qp.h |   42 +++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index f3c6d2c..ed46801 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -2075,6 +2075,7 @@ void rvt_add_rnr_timer(struct rvt_qp *qp, u32 aeth)
 	lockdep_assert_held(&qp->s_lock);
 	qp->s_flags |= RVT_S_WAIT_RNR;
 	to = rvt_aeth_to_usec(aeth);
+	trace_rvt_rnrnak_add(qp, to);
 	hrtimer_start(&qp->s_rnr_timer,
 		      ns_to_ktime(1000 * to), HRTIMER_MODE_REL);
 }
@@ -2104,15 +2105,14 @@ void rvt_stop_rc_timers(struct rvt_qp *qp)
  * stop an rnr timer and return if the timer
  * had been pending.
  */
-static int rvt_stop_rnr_timer(struct rvt_qp *qp)
+static void rvt_stop_rnr_timer(struct rvt_qp *qp)
 {
-	int rval = 0;
-
 	lockdep_assert_held(&qp->s_lock);
 	/* Remove QP from rnr timer */
-	if (qp->s_flags & RVT_S_WAIT_RNR)
+	if (qp->s_flags & RVT_S_WAIT_RNR) {
 		qp->s_flags &= ~RVT_S_WAIT_RNR;
-	return rval;
+		trace_rvt_rnrnak_stop(qp, 0);
+	}
 }
 
 /**
@@ -2165,6 +2165,7 @@ enum hrtimer_restart rvt_rc_rnr_retry(struct hrtimer *t)
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 	rvt_stop_rnr_timer(qp);
+	trace_rvt_rnrnak_timeout(qp, 0);
 	rdi->driver_f.schedule_send(qp);
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 	return HRTIMER_NORESTART;
diff --git a/drivers/infiniband/sw/rdmavt/trace_qp.h b/drivers/infiniband/sw/rdmavt/trace_qp.h
index 4c77a31..efc9d81 100644
--- a/drivers/infiniband/sw/rdmavt/trace_qp.h
+++ b/drivers/infiniband/sw/rdmavt/trace_qp.h
@@ -85,6 +85,48 @@
 	TP_PROTO(struct rvt_qp *qp, u32 bucket),
 	TP_ARGS(qp, bucket));
 
+DECLARE_EVENT_CLASS(
+	rvt_rnrnak_template,
+	TP_PROTO(struct rvt_qp *qp, u32 to),
+	TP_ARGS(qp, to),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
+		__field(u32, qpn)
+		__field(void *, hrtimer)
+		__field(u32, s_flags)
+		__field(u32, to)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->hrtimer = &qp->s_rnr_timer;
+		__entry->s_flags = qp->s_flags;
+		__entry->to = to;
+	),
+	TP_printk(
+		"[%s] qpn 0x%x hrtimer 0x%p s_flags 0x%x timeout %u us",
+		__get_str(dev),
+		__entry->qpn,
+		__entry->hrtimer,
+		__entry->s_flags,
+		__entry->to
+	)
+);
+
+DEFINE_EVENT(
+	rvt_rnrnak_template, rvt_rnrnak_add,
+	TP_PROTO(struct rvt_qp *qp, u32 to),
+	TP_ARGS(qp, to));
+
+DEFINE_EVENT(
+	rvt_rnrnak_template, rvt_rnrnak_timeout,
+	TP_PROTO(struct rvt_qp *qp, u32 to),
+	TP_ARGS(qp, to));
+
+DEFINE_EVENT(
+	rvt_rnrnak_template, rvt_rnrnak_stop,
+	TP_PROTO(struct rvt_qp *qp, u32 to),
+	TP_ARGS(qp, to));
 
 #endif /* __RVT_TRACE_QP_H */
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
