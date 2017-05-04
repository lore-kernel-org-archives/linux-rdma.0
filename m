From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 03/15] IB/hfi1: Fix yield logic in send engine
Date: Thu, 04 May 2017 05:14:10 -0700
Message-ID: <20170504121409.32747.34734.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When there are many RC QPs and an RDMA READ request
is sent, timeouts occur on the requester side because
of fairness among RC QPs on their relative SDMA engine
on the responder side.  This also hits write and send, but
to a lesser extent.

Complicating the issue is that the current code checks if workqueue
is congested before scheduling other QPs, however, this
check is based on the number of active entries in the
workqueue, which was found to be too big to for
workqueue_congested() to be effective.

Fix by reducing the number of active entries as revealed by
experimentation from the default of num_sdma to
HFI1_MAX_ACTIVE_WORKQUEUE_ENTRIES.  Retry counts were monitored
to determine the correct value.

Tracing to investigate any future issues is also added.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c     |    3 +
 drivers/infiniband/hw/hfi1/ruc.c      |   80 +++++++++++++++++++++------------
 drivers/infiniband/hw/hfi1/trace_tx.h |   34 ++++++++++++++
 drivers/infiniband/hw/hfi1/verbs.h    |    4 ++
 4 files changed, 90 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 4d6b9f8..71b0204 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -70,6 +70,7 @@
 #undef pr_fmt
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
 
+#define HFI1_MAX_ACTIVE_WORKQUEUE_ENTRIES 5
 /*
  * min buffers we want to have per context, after driver
  */
@@ -623,7 +624,7 @@ static int create_workqueues(struct hfi1_devdata *dd)
 				alloc_workqueue(
 				    "hfi%d_%d",
 				    WQ_SYSFS | WQ_HIGHPRI | WQ_CPU_INTENSIVE,
-				    dd->num_sdma,
+				    HFI1_MAX_ACTIVE_WORKQUEUE_ENTRIES,
 				    dd->unit, pidx);
 			if (!ppd->hfi1_wq)
 				goto wq_error;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 891ba0a..3a17dab 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -800,6 +800,43 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 /* when sending, force a reschedule every one of these periods */
 #define SEND_RESCHED_TIMEOUT (5 * HZ)  /* 5s in jiffies */
 
+/**
+ * schedule_send_yield - test for a yield required for QP send engine
+ * @timeout: Final time for timeout slice for jiffies
+ * @qp: a pointer to QP
+ * @ps: a pointer to a structure with commonly lookup values for
+ *      the the send engine progress
+ *
+ * This routine checks if the time slice for the QP has expired
+ * for RC QPs, if so an additional work entry is queued. At this
+ * point, other QPs have an opportunity to be scheduled. It
+ * returns true if a yield is required, otherwise, false
+ * is returned.
+ */
+static bool schedule_send_yield(struct rvt_qp *qp,
+				struct hfi1_pkt_state *ps)
+{
+	if (unlikely(time_after(jiffies, ps->timeout))) {
+		if (!ps->in_thread ||
+		    workqueue_congested(ps->cpu, ps->ppd->hfi1_wq)) {
+			spin_lock_irqsave(&qp->s_lock, ps->flags);
+			qp->s_flags &= ~RVT_S_BUSY;
+			hfi1_schedule_send(qp);
+			spin_unlock_irqrestore(&qp->s_lock, ps->flags);
+			this_cpu_inc(*ps->ppd->dd->send_schedule);
+			trace_hfi1_rc_expired_time_slice(qp, true);
+			return true;
+		}
+
+		cond_resched();
+		this_cpu_inc(*ps->ppd->dd->send_schedule);
+		ps->timeout = jiffies + ps->timeout_int;
+	}
+
+	trace_hfi1_rc_expired_time_slice(qp, false);
+	return false;
+}
+
 void hfi1_do_send_from_rvt(struct rvt_qp *qp)
 {
 	hfi1_do_send(qp, false);
@@ -827,13 +864,13 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 	struct hfi1_pkt_state ps;
 	struct hfi1_qp_priv *priv = qp->priv;
 	int (*make_req)(struct rvt_qp *qp, struct hfi1_pkt_state *ps);
-	unsigned long timeout;
-	unsigned long timeout_int;
-	int cpu;
 
 	ps.dev = to_idev(qp->ibqp.device);
 	ps.ibp = to_iport(qp->ibqp.device, qp->port_num);
 	ps.ppd = ppd_from_ibp(ps.ibp);
+	ps.in_thread = in_thread;
+
+	trace_hfi1_rc_do_send(qp, in_thread);
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
@@ -844,7 +881,7 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 			return;
 		}
 		make_req = hfi1_make_rc_req;
-		timeout_int = (qp->timeout_jiffies);
+		ps.timeout_int = qp->timeout_jiffies;
 		break;
 	case IB_QPT_UC:
 		if (!loopback && ((rdma_ah_get_dlid(&qp->remote_ah_attr) &
@@ -854,11 +891,11 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 			return;
 		}
 		make_req = hfi1_make_uc_req;
-		timeout_int = SEND_RESCHED_TIMEOUT;
+		ps.timeout_int = SEND_RESCHED_TIMEOUT;
 		break;
 	default:
 		make_req = hfi1_make_ud_req;
-		timeout_int = SEND_RESCHED_TIMEOUT;
+		ps.timeout_int = SEND_RESCHED_TIMEOUT;
 	}
 
 	spin_lock_irqsave(&qp->s_lock, ps.flags);
@@ -871,9 +908,11 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 
 	qp->s_flags |= RVT_S_BUSY;
 
-	timeout = jiffies + (timeout_int) / 8;
-	cpu = priv->s_sde ? priv->s_sde->cpu :
+	ps.timeout_int = ps.timeout_int / 8;
+	ps.timeout = jiffies + ps.timeout_int;
+	ps.cpu = priv->s_sde ? priv->s_sde->cpu :
 			cpumask_first(cpumask_of_node(ps.ppd->dd->node));
+
 	/* insure a pre-built packet is handled  */
 	ps.s_txreq = get_waiting_verbs_txreq(qp);
 	do {
@@ -889,28 +928,9 @@ void hfi1_do_send(struct rvt_qp *qp, bool in_thread)
 			/* Record that s_ahg is empty. */
 			qp->s_hdrwords = 0;
 			/* allow other tasks to run */
-			if (unlikely(time_after(jiffies, timeout))) {
-				if (!in_thread ||
-				    workqueue_congested(
-						cpu,
-						ps.ppd->hfi1_wq)) {
-					spin_lock_irqsave(
-						&qp->s_lock,
-						ps.flags);
-					qp->s_flags &= ~RVT_S_BUSY;
-					hfi1_schedule_send(qp);
-					spin_unlock_irqrestore(
-						&qp->s_lock,
-						ps.flags);
-					this_cpu_inc(
-						*ps.ppd->dd->send_schedule);
-					return;
-				}
-				cond_resched();
-				this_cpu_inc(
-					*ps.ppd->dd->send_schedule);
-				timeout = jiffies + (timeout_int) / 8;
-			}
+			if (schedule_send_yield(qp, &ps))
+				return;
+
 			spin_lock_irqsave(&qp->s_lock, ps.flags);
 		}
 	} while (make_req(qp, &ps));
diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index 2c9ac57..c59809a 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -676,6 +676,40 @@
 	)
 );
 
+DECLARE_EVENT_CLASS(
+	hfi1_do_send_template,
+	TP_PROTO(struct rvt_qp *qp, bool flag),
+	TP_ARGS(qp, flag),
+	TP_STRUCT__entry(
+		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
+		__field(u32, qpn)
+		__field(bool, flag)
+	),
+	TP_fast_assign(
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->flag = flag;
+	),
+	TP_printk(
+		"[%s] qpn %x flag %d",
+		__get_str(dev),
+		__entry->qpn,
+		__entry->flag
+	)
+);
+
+DEFINE_EVENT(
+	hfi1_do_send_template, hfi1_rc_do_send,
+	TP_PROTO(struct rvt_qp *qp, bool flag),
+	TP_ARGS(qp, flag)
+);
+
+DEFINE_EVENT(
+	hfi1_do_send_template, hfi1_rc_expired_time_slice,
+	TP_PROTO(struct rvt_qp *qp, bool flag),
+	TP_ARGS(qp, flag)
+);
+
 #endif /* __HFI1_TRACE_TX_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index c0913c6..cd635d0 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -139,6 +139,10 @@ struct hfi1_pkt_state {
 	struct hfi1_pportdata *ppd;
 	struct verbs_txreq *s_txreq;
 	unsigned long flags;
+	unsigned long timeout;
+	unsigned long timeout_int;
+	int cpu;
+	bool in_thread;
 };
 
 #define HFI1_PSN_CREDIT  16

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
