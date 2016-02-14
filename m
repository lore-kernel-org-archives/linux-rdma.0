From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/12] IB/rdmavt: Add trace and error print statements in
 post_one_wr
Date: Sun, 14 Feb 2016 12:10:12 -0800
Message-ID: <20160214201009.1410.63577.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

These trace and error print statements would help in debugging issues which
are caused due to messed up QP ring buffer pointers.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c    |    8 +++-
 drivers/infiniband/sw/rdmavt/trace.h |   70 ++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 522404a..d629911 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1441,7 +1441,12 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 	/* check for avail */
 	if (unlikely(!qp->s_avail)) {
 		qp->s_avail = qp_get_savail(qp);
-		WARN_ON(qp->s_avail > (qp->s_size - 1));
+		if (WARN_ON(qp->s_avail > (qp->s_size - 1)))
+			rvt_pr_err(rdi,
+				   "More avail entries than QP RB size.\nQP: %u, size: %u, avail: %u\nhead: %u, tail: %u, cur: %u, acked: %u, last: %u",
+				   qp->ibqp.qp_num, qp->s_size, qp->s_avail,
+				   qp->s_head, qp->s_tail, qp->s_cur,
+				   qp->s_acked, qp->s_last);
 		if (!qp->s_avail)
 			return -ENOMEM;
 	}
@@ -1510,6 +1515,7 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 	wqe->lpsn = wqe->psn +
 			(wqe->length ? ((wqe->length - 1) >> log_pmtu) : 0);
 	qp->s_next_psn = wqe->lpsn + 1;
+	trace_rvt_post_one_wr(qp, wqe);
 	smp_wmb(); /* see request builders */
 	qp->s_avail--;
 	qp->s_head = next;
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index d5b1281..6c0457d 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -54,6 +54,7 @@
 #include <linux/tracepoint.h>
 #include <linux/trace_seq.h>
 
+#include <rdma/ib_verbs.h>
 #include <rdma/rdma_vt.h>
 
 #define RDI_DEV_ENTRY(rdi)   __string(dev, rdi->driver_f.get_card_name(rdi))
@@ -108,6 +109,75 @@ DEFINE_EVENT(rvt_qphash_template, rvt_qpremove,
 	TP_PROTO(struct rvt_qp *qp, u32 bucket),
 	TP_ARGS(qp, bucket));
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvt_tx
+
+#define wr_opcode_name(opcode) { IB_WR_##opcode, #opcode  }
+#define show_wr_opcode(opcode)                             \
+__print_symbolic(opcode,                                   \
+	wr_opcode_name(RDMA_WRITE),                        \
+	wr_opcode_name(RDMA_WRITE_WITH_IMM),               \
+	wr_opcode_name(SEND),                              \
+	wr_opcode_name(SEND_WITH_IMM),                     \
+	wr_opcode_name(RDMA_READ),                         \
+	wr_opcode_name(ATOMIC_CMP_AND_SWP),                \
+	wr_opcode_name(ATOMIC_FETCH_AND_ADD),              \
+	wr_opcode_name(LSO),                               \
+	wr_opcode_name(SEND_WITH_INV),                     \
+	wr_opcode_name(RDMA_READ_WITH_INV),                \
+	wr_opcode_name(LOCAL_INV),                         \
+	wr_opcode_name(MASKED_ATOMIC_CMP_AND_SWP),         \
+	wr_opcode_name(MASKED_ATOMIC_FETCH_AND_ADD))
+
+#define POS_PRN \
+"[%s] wr_id %llx qpn %x psn 0x%x lpsn 0x%x length %u opcode 0x%.2x,%s size %u avail %u head %u last %u"
+
+TRACE_EVENT(
+	rvt_post_one_wr,
+	TP_PROTO(struct rvt_qp *qp, struct rvt_swqe *wqe),
+	TP_ARGS(qp, wqe),
+	TP_STRUCT__entry(
+		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
+		__field(u64, wr_id)
+		__field(u32, qpn)
+		__field(u32, psn)
+		__field(u32, lpsn)
+		__field(u32, length)
+		__field(u32, opcode)
+		__field(u32, size)
+		__field(u32, avail)
+		__field(u32, head)
+		__field(u32, last)
+	),
+	TP_fast_assign(
+		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		__entry->wr_id = wqe->wr.wr_id;
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->psn = wqe->psn;
+		__entry->lpsn = wqe->lpsn;
+		__entry->length = wqe->length;
+		__entry->opcode = wqe->wr.opcode;
+		__entry->size = qp->s_size;
+		__entry->avail = qp->s_avail;
+		__entry->head = qp->s_head;
+		__entry->last = qp->s_last;
+	),
+	TP_printk(
+		POS_PRN,
+		__get_str(dev),
+		__entry->wr_id,
+		__entry->qpn,
+		__entry->psn,
+		__entry->lpsn,
+		__entry->length,
+		__entry->opcode, show_wr_opcode(__entry->opcode),
+		__entry->size,
+		__entry->avail,
+		__entry->head,
+		__entry->last
+	)
+);
+
 #endif /* __RDMAVT_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
