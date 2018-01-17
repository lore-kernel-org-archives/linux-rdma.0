From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/4] IB/core: add support for draining Shared receive queues
Date: Wed, 17 Jan 2018 15:52:55 +0200
Message-ID: <1516197178-26493-2-git-send-email-maxg@mellanox.com>
References: <1516197178-26493-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197178-26493-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
Cc: danielm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To avoid theoretical leakage for QPs assocoated with SRQ,
according to IB spec (section 10.3.1):

"Note, for QPs that are associated with an SRQ, the Consumer should take
the QP through the Error State before invoking a Destroy QP or a Modify
QP to the Reset State. The Consumer may invoke the Destroy QP without
first performing a Modify QP to the Error State and waiting for the Affiliated
Asynchronous Last WQE Reached Event. However, if the Consumer
does not wait for the Affiliated Asynchronous Last WQE Reached Event,
then WQE and Data Segment leakage may occur. Therefore, it is good
programming practice to tear down a QP that is associated with an SRQ
by using the following process:
 - Put the QP in the Error State;
 - wait for the Affiliated Asynchronous Last WQE Reached Event;
 - either:
   - drain the CQ by invoking the Poll CQ verb and either wait for CQ
     to be empty or the number of Poll CQ operations has exceeded
     CQ capacity size; or
   - post another WR that completes on the same CQ and wait for this
     WR to return as a WC;
 - and then invoke a Destroy QP or Reset QP."

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 69 ++++++++++++++++++++++++++++++++++++++++-
 include/rdma/ib_verbs.h         |  8 +++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 7868727..7604450 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -886,8 +886,10 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		if (qp_init_attr->recv_cq)
 			atomic_inc(&qp_init_attr->recv_cq->usecnt);
 		qp->srq = qp_init_attr->srq;
-		if (qp->srq)
+		if (qp->srq) {
 			atomic_inc(&qp_init_attr->srq->usecnt);
+			init_completion(&qp->srq_completion);
+		}
 	}
 
 	qp->pd	    = pd;
@@ -1405,6 +1407,22 @@ int ib_get_eth_speed(struct ib_device *dev, u8 port_num, u8 *speed, u8 *width)
 }
 EXPORT_SYMBOL(ib_get_eth_speed);
 
+int ib_notify_qp(struct ib_qp *qp, enum ib_event_type event)
+{
+	int ret = 0;
+
+	switch (event) {
+	case IB_EVENT_QP_LAST_WQE_REACHED:
+		complete(&qp->srq_completion);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_notify_qp);
+
 int ib_modify_qp(struct ib_qp *qp,
 		 struct ib_qp_attr *qp_attr,
 		 int qp_attr_mask)
@@ -2213,6 +2231,53 @@ static void __ib_drain_rq(struct ib_qp *qp)
 		wait_for_completion(&rdrain.done);
 }
 
+/*
+ * __ib_drain_srq() - Block until all Last WQE Reached event arrives, or
+ *                    timeout expires (best effort).
+ * @qp:               queue pair associated with SRQ to drain
+ *
+ * In order to avoid WQE and data segment leakage, one should destroy
+ * QP associated after performing the following:
+ *  - moving QP to err state
+ *  - wait for the Affiliated Asynchronous Last WQE Reached Event
+ *  - drain the CQ
+ */
+static void __ib_drain_srq(struct ib_qp *qp)
+{
+	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
+	struct ib_cq *cq;
+	int ret;
+
+	if (!qp->srq) {
+		WARN_ONCE(1, "QP 0x%p is not associated with SRQ\n", qp);
+		return;
+	}
+
+	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+	if (ret) {
+		WARN_ONCE(ret, "failed to drain shared recv queue: %d\n", ret);
+		return;
+	}
+
+	if (ib_srq_has_cq(qp->srq->srq_type)) {
+		cq = qp->srq->ext.cq;
+	} else if (qp->recv_cq) {
+		cq = qp->recv_cq;
+	} else {
+		WARN_ONCE(1, "QP 0x%p has no CQ associated with SRQ\n", qp);
+		return;
+	}
+
+	/*
+         * ULP should invoke ib_notify_qp on IB_EVENT_QP_LAST_WQE_REACHED
+         * arrival, otherwise timeout will expire and leakage may occur.
+         * Use long timeout, for the buggy ULPs/HCAs that don't notify the
+         * QP nor raising IB_EVENT_QP_LAST_WQE_REACHED event.
+         */
+	if (wait_for_completion_timeout(&qp->srq_completion, 10 * HZ) > 0)
+		ib_process_cq_direct(cq, -1);
+}
+
 /**
  * ib_drain_sq() - Block until all SQ CQEs have been consumed by the
  *		   application.
@@ -2289,5 +2354,7 @@ void ib_drain_qp(struct ib_qp *qp)
 	ib_drain_sq(qp);
 	if (!qp->srq)
 		ib_drain_rq(qp);
+	else
+		__ib_drain_srq(qp);
 }
 EXPORT_SYMBOL(ib_drain_qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fd84cda..c5febae 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1728,6 +1728,7 @@ struct ib_qp {
 	struct list_head	rdma_mrs;
 	struct list_head	sig_mrs;
 	struct ib_srq	       *srq;
+	struct completion	srq_completion;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
 
@@ -3060,6 +3061,13 @@ int ib_modify_qp(struct ib_qp *qp,
 		 int qp_attr_mask);
 
 /**
+ * ib_notify_qp - Notifies the QP for event arrival
+ * @qp: The QP to notify.
+ * @event: Specifies the event to notify.
+ */
+int ib_notify_qp(struct ib_qp *qp, enum ib_event_type event);
+
+/**
  * ib_query_qp - Returns the attribute list and current values for the
  *   specified QP.
  * @qp: The QP to query.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
