From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 06/20] IB/rdmavt: Add additional fields to post send trace
Date: Mon, 20 Mar 2017 17:25:10 -0700
Message-ID: <20170321002509.28538.85964.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This fix is to get additional debugging information.

The following fields are added:
- wqe
- qpt
- num_sge
- ssn
- pid
- send_flags

These additional fields provide for more focused filtering
and triggering.

The patch also moves the trace to just before the wqe is
posted to get the most accurate information and future proofs
the code to trace all possible reserved opcodes.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c       |    2 +-
 drivers/infiniband/sw/rdmavt/trace_tx.h |   34 ++++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 28fb724..3c55a8b 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1772,11 +1772,11 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 					0);
 		qp->s_next_psn = wqe->lpsn + 1;
 	}
-	trace_rvt_post_one_wr(qp, wqe);
 	if (unlikely(reserved_op))
 		rvt_qp_wqe_reserve(qp, wqe);
 	else
 		qp->s_avail--;
+	trace_rvt_post_one_wr(qp, wqe);
 	smp_wmb(); /* see request builders */
 	qp->s_head = next;
 
diff --git a/drivers/infiniband/sw/rdmavt/trace_tx.h b/drivers/infiniband/sw/rdmavt/trace_tx.h
index 0e03173..a613a22 100644
--- a/drivers/infiniband/sw/rdmavt/trace_tx.h
+++ b/drivers/infiniband/sw/rdmavt/trace_tx.h
@@ -71,10 +71,20 @@
 	wr_opcode_name(RDMA_READ_WITH_INV),                \
 	wr_opcode_name(LOCAL_INV),                         \
 	wr_opcode_name(MASKED_ATOMIC_CMP_AND_SWP),         \
-	wr_opcode_name(MASKED_ATOMIC_FETCH_AND_ADD))
+	wr_opcode_name(MASKED_ATOMIC_FETCH_AND_ADD),       \
+	wr_opcode_name(RESERVED1),                         \
+	wr_opcode_name(RESERVED2),                         \
+	wr_opcode_name(RESERVED3),                         \
+	wr_opcode_name(RESERVED4),                         \
+	wr_opcode_name(RESERVED5),                         \
+	wr_opcode_name(RESERVED6),                         \
+	wr_opcode_name(RESERVED7),                         \
+	wr_opcode_name(RESERVED8),                         \
+	wr_opcode_name(RESERVED9),                         \
+	wr_opcode_name(RESERVED10))
 
 #define POS_PRN \
-"[%s] wr_id %llx qpn %x psn 0x%x lpsn 0x%x length %u opcode 0x%.2x,%s size %u avail %u head %u last %u"
+"[%s] wqe %p wr_id %llx send_flags %x qpn %x qpt %u psn %x lpsn %x ssn %x length %u opcode 0x%.2x,%s size %u avail %u head %u last %u pid %u num_sge %u"
 
 TRACE_EVENT(
 	rvt_post_one_wr,
@@ -83,7 +93,9 @@
 	TP_STRUCT__entry(
 		RDI_DEV_ENTRY(ib_to_rvt(qp->ibqp.device))
 		__field(u64, wr_id)
+		__field(struct rvt_swqe *, wqe)
 		__field(u32, qpn)
+		__field(u32, qpt)
 		__field(u32, psn)
 		__field(u32, lpsn)
 		__field(u32, length)
@@ -92,11 +104,17 @@
 		__field(u32, avail)
 		__field(u32, head)
 		__field(u32, last)
+		__field(u32, ssn)
+		__field(int, send_flags)
+		__field(pid_t, pid)
+		__field(int, num_sge)
 	),
 	TP_fast_assign(
 		RDI_DEV_ASSIGN(ib_to_rvt(qp->ibqp.device))
+		__entry->wqe = wqe;
 		__entry->wr_id = wqe->wr.wr_id;
 		__entry->qpn = qp->ibqp.qp_num;
+		__entry->qpt = qp->ibqp.qp_type;
 		__entry->psn = wqe->psn;
 		__entry->lpsn = wqe->lpsn;
 		__entry->length = wqe->length;
@@ -105,20 +123,30 @@
 		__entry->avail = qp->s_avail;
 		__entry->head = qp->s_head;
 		__entry->last = qp->s_last;
+		__entry->pid = qp->pid;
+		__entry->ssn = wqe->ssn;
+		__entry->send_flags = wqe->wr.send_flags;
+		__entry->num_sge = wqe->wr.num_sge;
 	),
 	TP_printk(
 		POS_PRN,
 		__get_str(dev),
+		__entry->wqe,
 		__entry->wr_id,
+		__entry->send_flags,
 		__entry->qpn,
+		__entry->qpt,
 		__entry->psn,
 		__entry->lpsn,
+		__entry->ssn,
 		__entry->length,
 		__entry->opcode, show_wr_opcode(__entry->opcode),
 		__entry->size,
 		__entry->avail,
 		__entry->head,
-		__entry->last
+		__entry->last,
+		__entry->pid,
+		__entry->num_sge
 	)
 );
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
