From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/5] staging/rdma/hfi1: centralize timer routines into rc
Date: Thu, 04 Feb 2016 10:59:01 -0800
Message-ID: <20160204185855.6973.96966.stgit@scvm10.sc.intel.com>
References: <20160204185718.6973.92668.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160204185718.6973.92668.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Centralize disparate timer maintenance.

This allow for central control and changes to the RC
timer handling including future optimizations.

Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c |  107 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 371edc3..350faaa 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -62,6 +62,113 @@
 
 static void rc_timeout(unsigned long arg);
 
+/**
+ * hfi1_add_retry_timer - add/start a retry timer
+ * @qp - the QP
+ *
+ * add a retry timer on the QP
+ */
+static inline void hfi1_add_retry_timer(struct rvt_qp *qp)
+{
+	qp->s_flags |= RVT_S_TIMER;
+	qp->s_timer.function = rc_timeout;
+	/* 4.096 usec. * (1 << qp->timeout) */
+	qp->s_timer.expires = jiffies + qp->timeout_jiffies;
+	add_timer(&qp->s_timer);
+}
+
+/**
+ * hfi1_add_rnr_timer - add/start an rnr timer
+ * @qp - the QP
+ * @to - timeout in usecs
+ *
+ * add an rnr timer on the QP
+ */
+static inline void hfi1_add_rnr_timer(struct rvt_qp *qp, u32 to)
+{
+	qp->s_flags |= RVT_S_WAIT_RNR;
+	qp->s_timer.function = hfi1_rc_rnr_retry;
+	qp->s_timer.expires = jiffies + usecs_to_jiffies(to);
+	add_timer(&qp->s_timer);
+}
+
+/**
+ * hfi1_mod_retry_timer - mod a retry timer
+ * @qp - the QP
+ *
+ * Modify a potentially already running retry
+ * timer
+ */
+static inline void hfi1_mod_retry_timer(struct rvt_qp *qp)
+{
+	qp->s_flags |= RVT_S_TIMER;
+	qp->s_timer.function = rc_timeout;
+	/* 4.096 usec. * (1 << qp->timeout) */
+	mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
+}
+
+/**
+ * hfi1_stop_retry_timer - stop a retry timer
+ * @qp - the QP
+ *
+ * stop a retry timer and return if the timer
+ * had been pending.
+ */
+static inline int hfi1_stop_retry_timer(struct rvt_qp *qp)
+{
+	int rval = 0;
+
+	/* Remove QP from retry */
+	if (qp->s_flags & RVT_S_TIMER) {
+		qp->s_flags &= ~RVT_S_TIMER;
+		rval = del_timer(&qp->s_timer);
+	}
+	return rval;
+}
+
+/**
+ * hfi1_stop_rc_timers - stop all timers
+ * @qp - the QP
+ *
+ * stop any pending timers
+ */
+static inline void hfi1_stop_rc_timers(struct rvt_qp *qp)
+{
+	/* Remove QP from all timers */
+	if (qp->s_flags & (RVT_S_TIMER | RVT_S_WAIT_RNR)) {
+		qp->s_flags &= ~(RVT_S_TIMER | RVT_S_WAIT_RNR);
+		del_timer(&qp->s_timer);
+	}
+}
+
+/**
+ * hfi1_stop_rnr_timer - stop an rnr timer
+ * @qp - the QP
+ *
+ * stop an rnr timer and return if the timer
+ * had been pending.
+ */
+static inline int hfi1_stop_rnr_timer(struct rvt_qp *qp)
+{
+	int rval = 0;
+
+	/* Remove QP from rnr timer */
+	if (qp->s_flags & RVT_S_WAIT_RNR) {
+		qp->s_flags &= ~RVT_S_WAIT_RNR;
+		rval = del_timer(&qp->s_timer);
+	}
+	return rval;
+}
+
+/**
+ * hfi1_del_timers_sync - wait for any timeout routines to exit
+ * @qp - the QP
+ */
+static inline void hfi1_del_timers_sync(struct rvt_qp *qp)
+{
+	del_timer_sync(&qp->s_timer);
+}
+
 static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
 		       u32 psn, u32 pmtu)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
