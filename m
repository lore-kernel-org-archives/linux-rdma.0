From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 08/20] IB/rdmavt: Add swqe completion trace
Date: Mon, 20 Mar 2017 17:25:23 -0700
Message-ID: <20170321002522.28538.80908.stgit@scvm10.sc.intel.com>
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

The following fields are available for filter/trace:
- wqe
- wr_id
- qpn
- qpt
- length
- idx
- ssn
- (wr)opcode
- (wr)send_flags

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c       |    2 ++
 drivers/infiniband/hw/hfi1/ruc.c      |    2 ++
 drivers/infiniband/hw/hfi1/trace_tx.h |   43 +++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 4649530..0e56578 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -1028,6 +1028,7 @@ void hfi1_rc_send_complete(struct rvt_qp *qp, struct ib_header *hdr)
 		    cmp_psn(qp->s_sending_psn, qp->s_sending_hpsn) <= 0)
 			break;
 		s_last = qp->s_last;
+		trace_hfi1_qp_send_completion(qp, wqe, s_last);
 		if (++s_last >= qp->s_size)
 			s_last = 0;
 		qp->s_last = s_last;
@@ -1079,6 +1080,7 @@ static inline void update_last_psn(struct rvt_qp *qp, u32 psn)
 
 		rvt_put_swqe(wqe);
 		s_last = qp->s_last;
+		trace_hfi1_qp_send_completion(qp, wqe, s_last);
 		if (++s_last >= qp->s_size)
 			s_last = 0;
 		qp->s_last = s_last;
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index d2eb793..eeb650d 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -909,8 +909,10 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 
 	last = qp->s_last;
 	old_last = last;
+	trace_hfi1_qp_send_completion(qp, wqe, last);
 	if (++last >= qp->s_size)
 		last = 0;
+	trace_hfi1_qp_send_completion(qp, wqe, last);
 	qp->s_last = last;
 	/* See post_send() */
 	barrier();
diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index 415d6be..2c9ac57 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -633,6 +633,49 @@
 	     TP_PROTO(struct hfi1_devdata *dd, struct buffer_control *bc),
 	     TP_ARGS(dd, bc));
 
+TRACE_EVENT(
+	hfi1_qp_send_completion,
+	TP_PROTO(struct rvt_qp *qp, struct rvt_swqe *wqe, u32 idx),
+	TP_ARGS(qp, wqe, idx),
+	TP_STRUCT__entry(
+		DD_DEV_ENTRY(dd_from_ibdev(qp->ibqp.device))
+		__field(struct rvt_swqe *, wqe)
+		__field(u64, wr_id)
+		__field(u32, qpn)
+		__field(u32, qpt)
+		__field(u32, length)
+		__field(u32, idx)
+		__field(u32, ssn)
+		__field(enum ib_wr_opcode, opcode)
+		__field(int, send_flags)
+	),
+	TP_fast_assign(
+		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device))
+		__entry->wqe = wqe;
+		__entry->wr_id = wqe->wr.wr_id;
+		__entry->qpn = qp->ibqp.qp_num;
+		__entry->qpt = qp->ibqp.qp_type;
+		__entry->length = wqe->length;
+		__entry->idx = idx;
+		__entry->ssn = wqe->ssn;
+		__entry->opcode = wqe->wr.opcode;
+		__entry->send_flags = wqe->wr.send_flags;
+	),
+	TP_printk(
+		"[%s] qpn 0x%x qpt %u wqe %p idx %u wr_id %llx length %u ssn %u opcode %x send_flags %x",
+		__get_str(dev),
+		__entry->qpn,
+		__entry->qpt,
+		__entry->wqe,
+		__entry->idx,
+		__entry->wr_id,
+		__entry->length,
+		__entry->ssn,
+		__entry->opcode,
+		__entry->send_flags
+	)
+);
+
 #endif /* __HFI1_TRACE_TX_H */
 
 #undef TRACE_INCLUDE_PATH

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
