From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/24] IB/qib: adding fix missing from earlier patch
Date: Tue, 28 Dec 2010 10:28:24 -0500
Message-ID: <20101228152824.19960.40529.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rcv/error race fix was missing part
of a fix that makes merges impossible.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_ud.c |   55 ++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index a4b945d..4a51fd1 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -445,13 +445,14 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
 	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & QIB_QPN_MASK;
 
-	/* Get the number of bytes the message was padded by. */
+	/*
+	 * Get the number of bytes the message was padded by
+	 * and drop incomplete packets.
+	 */
 	pad = (be32_to_cpu(ohdr->bth[0]) >> 20) & 3;
-	if (unlikely(tlen < (hdrsize + pad + 4))) {
-		/* Drop incomplete packets. */
-		ibp->n_pkt_drops++;
-		goto bail;
-	}
+	if (unlikely(tlen < (hdrsize + pad + 4)))
+		goto drop;
+
 	tlen -= hdrsize + pad + 4;
 
 	/*
@@ -460,10 +461,8 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	 */
 	if (qp->ibqp.qp_num) {
 		if (unlikely(hdr->lrh[1] == IB_LID_PERMISSIVE ||
-			     hdr->lrh[3] == IB_LID_PERMISSIVE)) {
-			ibp->n_pkt_drops++;
-			goto bail;
-		}
+			     hdr->lrh[3] == IB_LID_PERMISSIVE))
+			goto drop;
 		if (qp->ibqp.qp_num > 1) {
 			u16 pkey1, pkey2;
 
@@ -476,7 +475,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 						0xF,
 					      src_qp, qp->ibqp.qp_num,
 					      hdr->lrh[3], hdr->lrh[1]);
-				goto bail;
+				return;
 			}
 		}
 		if (unlikely(qkey != qp->qkey)) {
@@ -484,30 +483,24 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 				      (be16_to_cpu(hdr->lrh[0]) >> 4) & 0xF,
 				      src_qp, qp->ibqp.qp_num,
 				      hdr->lrh[3], hdr->lrh[1]);
-			goto bail;
+			return;
 		}
 		/* Drop invalid MAD packets (see 13.5.3.1). */
 		if (unlikely(qp->ibqp.qp_num == 1 &&
 			     (tlen != 256 ||
-			      (be16_to_cpu(hdr->lrh[0]) >> 12) == 15))) {
-			ibp->n_pkt_drops++;
-			goto bail;
-		}
+			      (be16_to_cpu(hdr->lrh[0]) >> 12) == 15)))
+			goto drop;
 	} else {
 		struct ib_smp *smp;
 
 		/* Drop invalid MAD packets (see 13.5.3.1). */
-		if (tlen != 256 || (be16_to_cpu(hdr->lrh[0]) >> 12) != 15) {
-			ibp->n_pkt_drops++;
-			goto bail;
-		}
+		if (tlen != 256 || (be16_to_cpu(hdr->lrh[0]) >> 12) != 15)
+			goto drop;
 		smp = (struct ib_smp *) data;
 		if ((hdr->lrh[1] == IB_LID_PERMISSIVE ||
 		     hdr->lrh[3] == IB_LID_PERMISSIVE) &&
-		    smp->mgmt_class != IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
-			ibp->n_pkt_drops++;
-			goto bail;
-		}
+		    smp->mgmt_class != IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
+			goto drop;
 	}
 
 	/*
@@ -523,10 +516,8 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	} else if (opcode == IB_OPCODE_UD_SEND_ONLY) {
 		wc.ex.imm_data = 0;
 		wc.wc_flags = 0;
-	} else {
-		ibp->n_pkt_drops++;
-		goto bail;
-	}
+	} else
+		goto drop;
 
 	/*
 	 * A GRH is expected to preceed the data even if not
@@ -556,8 +547,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	/* Silently drop packets which are too big. */
 	if (unlikely(wc.byte_len > qp->r_len)) {
 		qp->r_flags |= QIB_R_REUSE_SGE;
-		ibp->n_pkt_drops++;
-		return;
+		goto drop;
 	}
 	if (has_grh) {
 		qib_copy_sge(&qp->r_sge, &hdr->u.l.grh,
@@ -594,5 +584,8 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	qib_cq_enter(to_icq(qp->ibqp.recv_cq), &wc,
 		     (ohdr->bth[0] &
 			cpu_to_be32(IB_BTH_SOLICITED)) != 0);
-bail:;
+	return;
+
+drop:
+	ibp->n_pkt_drops++;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
