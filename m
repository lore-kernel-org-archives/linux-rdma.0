From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/16] staging/rdma/hfi1: remove s_rdma_mr
Date: Sun, 14 Feb 2016 12:44:52 -0800
Message-ID: <20160214204448.29247.17650.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It can be conveyed in the verbs_txreq.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c    |   12 ++++++------
 drivers/staging/rdma/hfi1/verbs.c |    8 --------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 75d70d5..c075e85 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -266,9 +266,9 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 				goto bail;
 			}
 			/* Copy SGE state in case we need to resend */
-			qp->s_rdma_mr = e->rdma_sge.mr;
-			if (qp->s_rdma_mr)
-				rvt_get_mr(qp->s_rdma_mr);
+			ps->s_txreq->mr = e->rdma_sge.mr;
+			if (ps->s_txreq->mr)
+				rvt_get_mr(ps->s_txreq->mr);
 			qp->s_ack_rdma_sge.sge = e->rdma_sge;
 			qp->s_ack_rdma_sge.num_sge = 1;
 			qp->s_cur_sge = &qp->s_ack_rdma_sge;
@@ -305,9 +305,9 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 		/* FALLTHROUGH */
 	case OP(RDMA_READ_RESPONSE_MIDDLE):
 		qp->s_cur_sge = &qp->s_ack_rdma_sge;
-		qp->s_rdma_mr = qp->s_ack_rdma_sge.sge.mr;
-		if (qp->s_rdma_mr)
-			rvt_get_mr(qp->s_rdma_mr);
+		ps->s_txreq->mr = qp->s_ack_rdma_sge.sge.mr;
+		if (ps->s_txreq->mr)
+			rvt_get_mr(ps->s_txreq->mr);
 		len = qp->s_ack_rdma_sge.sge.sge_length;
 		if (len > pmtu) {
 			len = pmtu;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 8cf1d6b..dc8eb6b 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -728,9 +728,6 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
 	}
 	tx->wqe = qp->s_wqe;
-	tx->mr = qp->s_rdma_mr;
-	if (qp->s_rdma_mr)
-		qp->s_rdma_mr = NULL;
 	tx->hdr_dwords = hdrwords + 2;
 	ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
 	if (unlikely(ret))
@@ -889,11 +886,6 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
 			   &ps->s_txreq->phdr.hdr);
 
-	if (qp->s_rdma_mr) {
-		rvt_put_mr(qp->s_rdma_mr);
-		qp->s_rdma_mr = NULL;
-	}
-
 pio_bail:
 	if (qp->s_wqe) {
 		spin_lock_irqsave(&qp->s_lock, flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
