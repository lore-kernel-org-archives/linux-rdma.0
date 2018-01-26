From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 13/16] IB/hfi1: Optimize process_receive_ib()
Date: Fri, 26 Jan 2018 06:33:02 -0800
Message-ID: <20180126143259.6868.38467.stgit@scvm10.sc.intel.com>
References: <20180126142640.6868.12402.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126142640.6868.12402.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The arguments for trace_hfi1_rcvhdr() get computed every
time in the hot path regardless of the whether the trace
is on or off. This is seen to be costly with a profile.
The handling of fault inject isolates the verbs device for
all packets regardless of the presence of a RHF_DC_ERR error.

Fix the first by computing trace_hfi1_rcvhdr() arguments within
the trace itself, so that when the trace is off, the argument
data isn't computed. Fix the second by moving the error check to
handle_eflags() when an RHF error occurs and by testing for
RHF_DC_ERR before executing the reset of handle_eflags().

Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c   |   21 +++++++--------------
 drivers/infiniband/hw/hfi1/trace_rx.h |   28 ++++++++++------------------
 2 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index ea09c56..c7e6b67 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -256,7 +256,12 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 	u32 mlid_base;
 	struct hfi1_ibport *ibp = rcd_to_iport(rcd);
 	struct hfi1_devdata *dd = ppd->dd;
-	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
+	struct hfi1_ibdev *verbs_dev = &dd->verbs_dev;
+	struct rvt_dev_info *rdi = &verbs_dev->rdi;
+
+	if ((packet->rhf & RHF_DC_ERR) &&
+	    hfi1_dbg_fault_suppress_err(verbs_dev))
+		return;
 
 	if (packet->rhf & (RHF_VCRC_ERR | RHF_ICRC_ERR))
 		return;
@@ -1554,19 +1559,7 @@ int process_receive_ib(struct hfi1_packet *packet)
 	if (hfi1_setup_9B_packet(packet))
 		return RHF_RCV_CONTINUE;
 
-	trace_hfi1_rcvhdr(packet->rcd->ppd->dd,
-			  packet->rcd->ctxt,
-			  rhf_err_flags(packet->rhf),
-			  RHF_RCV_TYPE_IB,
-			  packet->hlen,
-			  packet->tlen,
-			  packet->updegr,
-			  rhf_egr_index(packet->rhf));
-
-	if (unlikely(
-		 (hfi1_dbg_fault_suppress_err(&packet->rcd->dd->verbs_dev) &&
-		 (packet->rhf & RHF_DC_ERR))))
-		return RHF_RCV_CONTINUE;
+	trace_hfi1_rcvhdr(packet, RHF_RCV_TYPE_IB);
 
 	if (unlikely(rhf_err_flags(packet->rhf))) {
 		handle_eflags(packet);
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index 4d487fe..f768415 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -63,17 +63,9 @@
 #define TRACE_SYSTEM hfi1_rx
 
 TRACE_EVENT(hfi1_rcvhdr,
-	    TP_PROTO(struct hfi1_devdata *dd,
-		     u32 ctxt,
-		     u64 eflags,
-		     u32 etype,
-		     u32 hlen,
-		     u32 tlen,
-		     u32 updegr,
-		     u32 etail
-		    ),
-	    TP_ARGS(dd, ctxt, eflags, etype, hlen, tlen, updegr, etail),
-	    TP_STRUCT__entry(DD_DEV_ENTRY(dd)
+	    TP_PROTO(struct hfi1_packet *packet, u32 etype),
+	    TP_ARGS(packet, etype),
+	    TP_STRUCT__entry(DD_DEV_ENTRY(packet->rcd->dd)
 			     __field(u64, eflags)
 			     __field(u32, ctxt)
 			     __field(u32, etype)
@@ -82,14 +74,14 @@
 			     __field(u32, updegr)
 			     __field(u32, etail)
 			     ),
-	     TP_fast_assign(DD_DEV_ASSIGN(dd);
-			    __entry->eflags = eflags;
-			    __entry->ctxt = ctxt;
+	     TP_fast_assign(DD_DEV_ASSIGN(packet->rcd->dd);
+			    __entry->eflags = rhf_err_flags(packet->rhf);
+			    __entry->ctxt = packet->rcd->ctxt;
 			    __entry->etype = etype;
-			    __entry->hlen = hlen;
-			    __entry->tlen = tlen;
-			    __entry->updegr = updegr;
-			    __entry->etail = etail;
+			    __entry->hlen = packet->hlen;
+			    __entry->tlen = packet->tlen;
+			    __entry->updegr = packet->updegr;
+			    __entry->etail = rhf_egr_index(packet->rhf);
 			    ),
 	     TP_printk(
 		"[%s] ctxt %d eflags 0x%llx etype %d,%s hlen %d tlen %d updegr %d etail %d",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
