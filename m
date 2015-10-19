From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 22/23] staging/rdma/hfi1: add additional rc traces
Date: Mon, 19 Oct 2015 12:43:46 -0400
Message-ID: <1445273027-29634-23-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add additional rc traces to aid in debugging rc retry logic.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c    |  4 ++++
 drivers/staging/rdma/hfi1/trace.c |  4 ++--
 drivers/staging/rdma/hfi1/trace.h | 48 +++++++++++++++++++++++++++++----------
 3 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 8e4f421b2b58..e25c70b9de34 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -927,6 +927,7 @@ static void rc_timeout(unsigned long arg)
 		ibp->n_rc_timeouts++;
 		qp->s_flags &= ~HFI1_S_TIMER;
 		del_timer(&qp->s_timer);
+		trace_hfi1_rc_timeout(qp, qp->s_last_psn + 1);
 		restart_rc(qp, qp->s_last_psn + 1, 1);
 		hfi1_schedule_send(qp);
 	}
@@ -1442,6 +1443,8 @@ static void rc_rcv_resp(struct hfi1_ibport *ibp,
 
 	spin_lock_irqsave(&qp->s_lock, flags);
 
+	trace_hfi1_rc_ack(qp, psn);
+
 	/* Ignore invalid responses. */
 	if (cmp_psn(psn, qp->s_next_psn) >= 0)
 		goto ack_done;
@@ -1630,6 +1633,7 @@ static noinline int rc_rcv_error(struct hfi1_other_headers *ohdr, void *data,
 	u8 i, prev;
 	int old_req;
 
+	trace_hfi1_rc_rcv_error(qp, psn);
 	if (diff > 0) {
 		/*
 		 * Packet sequence error.
diff --git a/drivers/staging/rdma/hfi1/trace.c b/drivers/staging/rdma/hfi1/trace.c
index 70ad7b9fc1ce..f55b75194847 100644
--- a/drivers/staging/rdma/hfi1/trace.c
+++ b/drivers/staging/rdma/hfi1/trace.c
@@ -126,13 +126,13 @@ const char *parse_everbs_hdrs(
 	case OP(RC, ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN,
 			be32_to_cpu(eh->aeth) >> 24,
-			be32_to_cpu(eh->aeth) & HFI1_QPN_MASK);
+			be32_to_cpu(eh->aeth) & HFI1_MSN_MASK);
 		break;
 	/* aeth + atomicacketh */
 	case OP(RC, ATOMIC_ACKNOWLEDGE):
 		trace_seq_printf(p, AETH_PRN " " ATOMICACKETH_PRN,
 			(be32_to_cpu(eh->at.aeth) >> 24) & 0xff,
-			be32_to_cpu(eh->at.aeth) & HFI1_QPN_MASK,
+			be32_to_cpu(eh->at.aeth) & HFI1_MSN_MASK,
 			(unsigned long long)ib_u64_get(eh->at.atomic_ack_eth));
 		break;
 	/* atomiceth */
diff --git a/drivers/staging/rdma/hfi1/trace.h b/drivers/staging/rdma/hfi1/trace.h
index 0354dca9a6f4..db51cf55c538 100644
--- a/drivers/staging/rdma/hfi1/trace.h
+++ b/drivers/staging/rdma/hfi1/trace.h
@@ -1290,37 +1290,61 @@ TRACE_EVENT(hfi1_sdma_state,
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_rc
 
-DECLARE_EVENT_CLASS(hfi1_sdma_rc,
+DECLARE_EVENT_CLASS(hfi1_rc_template,
 	TP_PROTO(struct hfi1_qp *qp, u32 psn),
 	TP_ARGS(qp, psn),
 	TP_STRUCT__entry(
 		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
 		__field(u32, qpn)
-		__field(u32, flags)
+		__field(u32, s_flags)
 		__field(u32, psn)
-		__field(u32, sending_psn)
-		__field(u32, sending_hpsn)
+		__field(u32, s_psn)
+		__field(u32, s_next_psn)
+		__field(u32, s_sending_psn)
+		__field(u32, s_sending_hpsn)
+		__field(u32, r_psn)
 	),
 	TP_fast_assign(
 		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
 		__entry->qpn = qp->ibqp.qp_num;
-		__entry->flags = qp->s_flags;
+		__entry->s_flags = qp->s_flags;
 		__entry->psn = psn;
-		__entry->sending_psn = qp->s_sending_psn;
-		__entry->sending_hpsn = qp->s_sending_hpsn;
+		__entry->s_psn = qp->s_psn;
+		__entry->s_next_psn = qp->s_next_psn;
+		__entry->s_sending_psn = qp->s_sending_psn;
+		__entry->s_sending_hpsn = qp->s_sending_hpsn;
+		__entry->r_psn = qp->r_psn;
 	),
 	TP_printk(
-		"[%s] qpn 0x%x flags 0x%x psn 0x%x sending_psn 0x%x sending_hpsn 0x%x",
+		"[%s] qpn 0x%x s_flags 0x%x psn 0x%x s_psn 0x%x s_next_psn 0x%x s_sending_psn 0x%x sending_hpsn 0x%x r_psn 0x%x",
 		__get_str(dev),
 		__entry->qpn,
-		__entry->flags,
+		__entry->s_flags,
 		__entry->psn,
-		__entry->sending_psn,
-		__entry->sending_psn
+		__entry->s_psn,
+		__entry->s_next_psn,
+		__entry->s_sending_psn,
+		__entry->s_sending_hpsn,
+		__entry->r_psn
 	)
 );
 
-DEFINE_EVENT(hfi1_sdma_rc, hfi1_rc_sendcomplete,
+DEFINE_EVENT(hfi1_rc_template, hfi1_rc_sendcomplete,
+	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_ARGS(qp, psn)
+);
+
+DEFINE_EVENT(hfi1_rc_template, hfi1_rc_ack,
+	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_ARGS(qp, psn)
+);
+
+DEFINE_EVENT(hfi1_rc_template, hfi1_rc_timeout,
+	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
+	     TP_ARGS(qp, psn)
+);
+
+DEFINE_EVENT(hfi1_rc_template, hfi1_rc_rcv_error,
 	     TP_PROTO(struct hfi1_qp *qp, u32 psn),
 	     TP_ARGS(qp, psn)
 );
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
