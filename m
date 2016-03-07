From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/10] IB/hfi1: Add unique trace point for pio and sdma send
Date: Mon, 07 Mar 2016 11:35:19 -0800
Message-ID: <20160307193519.4913.31928.stgit@scvm10.sc.intel.com>
References: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307193146.4913.42900.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This allows for separately enabling pio and sdma
tracepoints to cut the volume of trace information.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |    2 +-
 drivers/infiniband/hw/hfi1/trace.h |   10 +++++++++-
 drivers/infiniband/hw/hfi1/verbs.c |    8 ++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 351f136..0d7e101 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -881,7 +881,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 		goto queue_ack;
 	}
 
-	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &hdr);
+	trace_ack_output_ibhdr(dd_from_ibdev(qp->ibqp.device), &hdr);
 
 	/* write the pbc and data */
 	ppd->dd->pio_inline_send(ppd->dd, pbuf, pbc, &hdr, hwords);
diff --git a/drivers/infiniband/hw/hfi1/trace.h b/drivers/infiniband/hw/hfi1/trace.h
index b8b4416..4d91c18 100644
--- a/drivers/infiniband/hw/hfi1/trace.h
+++ b/drivers/infiniband/hw/hfi1/trace.h
@@ -530,7 +530,15 @@ DEFINE_EVENT(hfi1_ibhdr_template, input_ibhdr,
 	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
 	     TP_ARGS(dd, hdr));
 
-DEFINE_EVENT(hfi1_ibhdr_template, output_ibhdr,
+DEFINE_EVENT(hfi1_ibhdr_template, pio_output_ibhdr,
+	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
+	     TP_ARGS(dd, hdr));
+
+DEFINE_EVENT(hfi1_ibhdr_template, ack_output_ibhdr,
+	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
+	     TP_ARGS(dd, hdr));
+
+DEFINE_EVENT(hfi1_ibhdr_template, sdma_output_ibhdr,
 	     TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ib_header *hdr),
 	     TP_ARGS(dd, hdr));
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 8209757..e605e09 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -891,8 +891,8 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		if (unlikely(ret))
 			goto bail_build;
 	}
-	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
-			   &ps->s_txreq->phdr.hdr);
+	trace_sdma_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
+				&ps->s_txreq->phdr.hdr);
 	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
 	if (unlikely(ret == -ECOMM))
 		goto bail_ecomm;
@@ -1067,8 +1067,8 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		}
 	}
 
-	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
-			   &ps->s_txreq->phdr.hdr);
+	trace_pio_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
+			       &ps->s_txreq->phdr.hdr);
 
 pio_bail:
 	if (qp->s_wqe) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
