From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/7] IB/qib: precompute timeout jiffies to optimize latency
Date: Fri, 23 Sep 2011 13:16:49 -0400
Message-ID: <20110923171649.14542.38803.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A new field is added to qib_qp called timeout_jiffies. It
is initialized upon create and modify.

The field is now used vs. the computation based on qp->timeout.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c    |    9 ++++++++-
 drivers/infiniband/hw/qib/qib_rc.c    |    7 ++-----
 drivers/infiniband/hw/qib/qib_verbs.h |    1 +
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 500981b..7e7e16f 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -801,8 +801,12 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_MIN_RNR_TIMER)
 		qp->r_min_rnr_timer = attr->min_rnr_timer;
 
-	if (attr_mask & IB_QP_TIMEOUT)
+	if (attr_mask & IB_QP_TIMEOUT) {
 		qp->timeout = attr->timeout;
+		qp->timeout_jiffies =
+			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
+				1000UL);
+	}
 
 	if (attr_mask & IB_QP_QKEY)
 		qp->qkey = attr->qkey;
@@ -1034,6 +1038,9 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 			goto bail_swq;
 		}
 		RCU_INIT_POINTER(qp->next, NULL);
+		qp->timeout_jiffies =
+			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
+				1000UL);
 		if (init_attr->srq)
 			sz = 0;
 		else {
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 5d77cb8..ecfa087 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -59,8 +59,7 @@ static void start_timer(struct qib_qp *qp)
 	qp->s_flags |= QIB_S_TIMER;
 	qp->s_timer.function = rc_timeout;
 	/* 4.096 usec. * (1 << qp->timeout) */
-	qp->s_timer.expires = jiffies +
-		usecs_to_jiffies((4096UL * (1UL << qp->timeout)) / 1000UL);
+	qp->s_timer.expires = jiffies + qp->timeout_jiffies;
 	add_timer(&qp->s_timer);
 }
 
@@ -1519,9 +1518,7 @@ read_middle:
 		 * 4.096 usec. * (1 << qp->timeout)
 		 */
 		qp->s_flags |= QIB_S_TIMER;
-		mod_timer(&qp->s_timer, jiffies +
-			usecs_to_jiffies((4096UL * (1UL << qp->timeout)) /
-					 1000UL));
+		mod_timer(&qp->s_timer, jiffies + qp->timeout_jiffies);
 		if (qp->s_flags & QIB_S_WAIT_ACK) {
 			qp->s_flags &= ~QIB_S_WAIT_ACK;
 			qib_schedule_send(qp);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index d7b6109..0c19ef0 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -496,6 +496,7 @@ struct qib_qp {
 	u32 s_last;             /* last completed entry */
 	u32 s_ssn;              /* SSN of tail entry */
 	u32 s_lsn;              /* limit sequence number (credit) */
+	unsigned long timeout_jiffies;  /* computed from timeout */
 	struct qib_swqe *s_wq;  /* send work queue */
 	struct qib_swqe *s_wqe;
 	struct qib_rq r_rq;             /* receive work queue */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
